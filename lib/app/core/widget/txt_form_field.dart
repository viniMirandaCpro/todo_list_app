// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

import 'package:todo_list/app/core/ui/todo_list_icons.dart';

class TxtFormField extends StatelessWidget {
  final String label;
  final IconButton? suffixIconButton;
  final bool obscureText;
  final ValueNotifier<bool> obscureTextVN;
  final TextEditingController? controller;
  final FormFieldValidator<String>? validator;
  final FocusNode? focusNode;
  TxtFormField({
    Key? key,
    required this.label,
    this.suffixIconButton,
    this.obscureText = false,
    this.controller,
    this.focusNode,
    this.validator,
  })  : assert(
          obscureText == true ? suffixIconButton == null : true,
          'Obscure Text nao pode ser enviado em conjunto com um suffixIconButton',
        ),
        obscureTextVN = ValueNotifier(obscureText);

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
        valueListenable: obscureTextVN,
        builder: (_, obscureTextVNValue, child) {
          return TextFormField(
            controller: controller,
            validator: validator,
            focusNode: focusNode,
            obscureText: obscureTextVNValue,
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30),
              ),
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30),
                borderSide: const BorderSide(color: Colors.red),
              ),
              labelText: label,
              labelStyle: const TextStyle(
                color: Colors.black,
              ),
              isDense: true,
              suffixIcon: suffixIconButton ??
                  (obscureText == true
                      ? IconButton(
                          onPressed: () {
                            obscureTextVN.value = !obscureTextVN.value;
                          },
                          icon: Icon(
                            !obscureTextVNValue
                                ? TodoList.eye_off
                                : TodoList.eye,
                            size: 15,
                          ),
                        )
                      : null),
            ),
          );
        });
  }
}
