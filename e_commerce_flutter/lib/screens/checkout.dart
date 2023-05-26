import 'package:e_commerce_flutter/components/custom_button.dart';
import 'package:e_commerce_flutter/components/list_card.dart';
import 'package:e_commerce_flutter/components/loader.dart';
import 'package:e_commerce_flutter/utils/application_state.dart';
import 'package:e_commerce_flutter/utils/common.dart';
import 'package:e_commerce_flutter/utils/custom_theme.dart';
import 'package:e_commerce_flutter/utils/firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/cart.dart';

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({Key? key}) : super(key: key);

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  Future<List<Cart>>? carts;
  bool _checkoutButtonLoading = false;

  @override
  void initState() {
    super.initState();
    carts = FirestoreUtil.getCart(
        Provider.of<ApplicationState>(context, listen: false).user);
  }

  void checkout() async {
    setState(() {
      _checkoutButtonLoading = true;
    });
    String error = await CommonUtil.checkoutFlow(
        Provider.of<ApplicationState>(context, listen: false).user!);

    if (!mounted) return;
    if (error.isEmpty) {
      CommonUtil.showAlert(context, "Success", "Your order is placed");
    } else {
      CommonUtil.showAlert(context, "Alert", error);
    }

    await Future.delayed(const Duration(seconds: 2));
    setState(() {
      _checkoutButtonLoading = false;
      carts = FirestoreUtil.getCart(
          Provider.of<ApplicationState>(context, listen: false).user);
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Cart>>(
        future: carts,
        builder: (context, AsyncSnapshot<List<Cart>> snapshot) {
          if (snapshot.hasData &&
              snapshot.data != null &&
              snapshot.data!.isNotEmpty) {
            return SingleChildScrollView(
              child: Column(
                children: [
                  ListView.builder(
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    padding: const EdgeInsets.symmetric(vertical: 30.0),
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      return ListCard(cart: snapshot.data![index]);
                    },
                  ),
                  priceFooter(snapshot.data!),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        vertical: 20, horizontal: 20),
                    child: CustomButton(
                      text: 'CHECKOUT',
                      onPress: checkout,
                      loading: _checkoutButtonLoading,
                    ),
                  ),
                ],
              ),
            );
          } else if (snapshot.data != null && snapshot.data!.isEmpty) {
            return const Center(
              child: Icon(
                Icons.add_shopping_cart_sharp,
                color: CustomTheme.yellow,
                size: 150,
              ),
            );
          }
          return const Center(
            child: Loader(),
          );
        });
  }

  priceFooter(List<Cart> carts) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Divider(
            height: 2,
            color: CustomTheme.grey,
            thickness: 2,
          ),
          Padding(
            padding: const EdgeInsets.only(top: 20),
            child: Row(
              children: [
                Text(
                  'Total: ',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const Spacer(),
                Text(
                  '₹ ${FirestoreUtil.getCartTotal(carts)}',
                  style: Theme.of(context).textTheme.headlineSmall,
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
