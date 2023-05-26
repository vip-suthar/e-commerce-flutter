import 'package:e_commerce_flutter/components/custom_button.dart';
import 'package:e_commerce_flutter/utils/application_state.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool _loadingButton = false;

  void signOutButtonPressed() {
    setState(() {
      _loadingButton = true;
    });
    Provider.of<ApplicationState>(context, listen: false).signOut();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 20.0),
            child: Text(
              "Hi There",
              style: Theme.of(context).textTheme.headlineLarge,
            ),
          ),
          CustomButton(
            text: "SIGN OUT",
            onPress: signOutButtonPressed,
            loading: _loadingButton,
          ),
        ],
      ),
    );
  }
}
