import admin = require("firebase-admin");
import express = require("express");
import { Stripe } from "stripe";
import { NextFunction, Request, Response } from "express";
import {
  completeOrder,
  createOrder,
  getAmountAndCart,
  getStripeCustomerId,
  storeStripeCustomerId,
} from "./utils/FirestoreUtils";
import bodyParser = require("body-parser");
const config = require("../files/config.json");

const stripe = new Stripe(config.stripeKey, {
  apiVersion: "2020-08-27",
});

const serviceAccount = require("../files/service_key.json");

admin.initializeApp({
  credential: admin.credential.cert(serviceAccount),
  databaseURL: config.databaseURL,
  databaseAuthVariableOverride: {
    uid: "nameserver",
  },
});

const app = express();

app.use(decodeIdToken);

async function decodeIdToken(req: Request, res: Response, next: NextFunction) {
  if (req.headers?.authorization?.startsWith("Bearer ")) {
    const idToken = req.headers?.authorization.split("Bearer ")[1];
    try {
      const decodeToken = await admin.auth().verifyIdToken(idToken);
      req["currentUser"] = decodeToken;
      next();
    } catch (err) {
      console.log(err);
      res.status(403).send("You must be logged In !!");
    }
  } else if (req.originalUrl == "/webhook") {
    next();
  }
}

app.post("/add/user", async (req: Request, res: Response) => {
  const user = req["currentUser"];
  const customer = await stripe.customers.create({ email: user.email });

  if (customer) {
    storeStripeCustomerId(customer.id, user.uid);
    res.status(200).send({ status: "ok" });
  }
});

app.post("/checkout", async (req: Request, res: Response) => {
  const user = req["currentUser"];
  const { customer_id } = await getStripeCustomerId(user);

  const ephermeralKey = await stripe.ephemeralKeys.create(
    { customer: customer_id },
    { apiVersion: "2020-08-27 " }
  );

  const { amount, cart } = await getAmountAndCart(user);

  const paymentIntent = await stripe.paymentIntents.create({
    amount: amount,
    currency: "INR",
    customer: customer_id,
  });

  createOrder(cart, paymentIntent.id, user.uid, amount);

  res.json({
    paymentIntent: paymentIntent.client_secret,
    ephermeralKey: ephermeralKey.secret,
    customer: customer_id,
  });
});

app.post(
  "/webhook",
  bodyParser.raw({ type: "application/json" }),
  async (req: Request, res: Response) => {
    const sig = req.headers["stripe-signature"];

    let event;
    try {
      event = stripe.webhooks.constructEvent(
        req.body,
        sig,
        "webhook signature"
      );
    } catch (err) {
      res.status(400).send("not found");
    }

    switch (event.type) {
      case "payment_intent.succeeded":
        const paymentIntent = event.data.object;
        await completeOrder(paymentIntent.id);
        break;
      default:
        console.log(`Unhadled event type ${event.type}`);
    }

    res.json({ received: true });
  }
);

app.listen(4242, () => {
  console.log("Node server listening on port 4242");
});
