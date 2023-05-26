import 'package:e_commerce_flutter/utils/custom_theme.dart';
import 'package:flutter/material.dart';

class CustomTextInput extends StatelessWidget {
  final String label;
  final String placeHolder;
  final IconData icon;
  final TextEditingController textEditingController;
  final bool password;
  const CustomTextInput(
      {Key? key,
      required this.label,
      required this.placeHolder,
      required this.icon,
      required this.textEditingController,
      this.password = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 20, bottom: 8),
            child: Text(
              label,
              style: Theme.of(context).textTheme.headlineSmall,
            ),
          ),
          SizedBox(
            height: 56,
            child: TextField(
              controller: textEditingController,
              obscureText: password,
              enableSuggestions: !password,
              autocorrect: !password,
              decoration: InputDecoration(
                  prefixIcon: Padding(
                    padding:
                        const EdgeInsetsDirectional.only(start: 22, end: 20),
                    child: Icon(
                      icon,
                      color: Colors.black,
                      size: 24,
                    ),
                  ),
                  border: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(35)),
                      borderSide: BorderSide(width: 1, color: Colors.black)),
                  filled: true,
                  hintStyle: const TextStyle(color: CustomTheme.grey),
                  hintText: placeHolder,
                  fillColor: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}
