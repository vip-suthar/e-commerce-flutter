import 'package:cached_network_image/cached_network_image.dart';
import 'package:e_commerce_flutter/components/custom_button.dart';
import 'package:e_commerce_flutter/utils/application_state.dart';
import 'package:e_commerce_flutter/utils/custom_theme.dart';
import 'package:e_commerce_flutter/utils/firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/product.dart';

class ProductScreen extends StatefulWidget {
  final Product product;
  const ProductScreen({Key? key, required this.product}) : super(key: key);

  @override
  State<ProductScreen> createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {
  bool addButtonLoad = false;

  void onAddToCart() async {
    setState(() {
      addButtonLoad = true;
    });
    await FirestoreUtil.addToCart(
        Provider.of<ApplicationState>(context, listen: false).user,
        widget.product.id);
    setState(() {
      addButtonLoad = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Stack(
                    children: [
                      SizedBox(
                        height: 500,
                        width: double.infinity,
                        child: CachedNetworkImage(
                          fit: BoxFit.cover,
                          imageUrl: widget.product.image,
                        ),
                      ),
                      Positioned(
                        top: 35,
                        right: 35,
                        child: Container(
                          decoration: const ShapeDecoration(
                            color: CustomTheme.yellow,
                            shape: CircleBorder(),
                            shadows: [
                              BoxShadow(
                                color: CustomTheme.grey,
                                blurRadius: 3,
                                offset: Offset(1, 3),
                              )
                            ],
                          ),
                          child: IconButton(
                            icon: const Icon(Icons.share),
                            color: Colors.black,
                            onPressed: () {},
                          ),
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 30),
                    child: DefaultTextStyle(
                      style: Theme.of(context).textTheme.headlineLarge!,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(top: 22),
                            child: Text(widget.product.title),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 20),
                            child: Row(
                              children: [
                                const Text('MRP: '),
                                Text('₹${widget.product.price}'),
                              ],
                            ),
                          ),
                          CustomButton(
                            text: 'Add to Cart',
                            onPress: onAddToCart,
                            loading: addButtonLoad,
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 20),
                            child: Text(
                              'About the items',
                              style: Theme.of(context).textTheme.headlineMedium,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(bottom: 20),
                            child: Text(
                              widget.product.description,
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                          )
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
            Positioned(
              top: 35,
              left: 30,
              child: Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(5)),
                  boxShadow: [
                    BoxShadow(
                      blurRadius: 3,
                      offset: Offset(1, 3),
                      color: CustomTheme.grey,
                    ),
                  ],
                ),
                child: IconButton(
                  icon: const Icon(Icons.arrow_back),
                  color: Colors.black,
                  onPressed: () {
                    Navigator.of(context).pop(true);
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
