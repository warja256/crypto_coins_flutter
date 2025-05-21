import 'package:flutter/material.dart';

class TextFieldWidget extends StatefulWidget {
  const TextFieldWidget({
    super.key,
    required this.controller,
    required this.textInputType,
    required this.isSuffixIcon,
    required this.focusNode,
    this.nextFocusNode,
    required this.validator,
    this.textInputAction = TextInputAction.done,
    required this.autoValidate,
    this.onFieldSubmitted,
    required this.fieldKey,
  });

  final TextEditingController controller;
  final TextInputType textInputType;
  final bool isSuffixIcon;
  final FocusNode focusNode;
  final FocusNode? nextFocusNode;
  final TextInputAction textInputAction;
  final String? Function(String?) validator;
  final bool autoValidate;
  final VoidCallback? onFieldSubmitted;
  final GlobalKey<FormFieldState>? fieldKey;

  @override
  State<TextFieldWidget> createState() => _TextFieldWidgetState();
}

class _TextFieldWidgetState extends State<TextFieldWidget> {
  bool isPasswordvisible = false;

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints(minHeight: 30),
      child: TextFormField(
        key: widget.fieldKey,
        autovalidateMode: widget.autoValidate
            ? AutovalidateMode.always
            : AutovalidateMode.disabled,
        validator: widget.validator,
        focusNode: widget.focusNode,
        style: Theme.of(context)
            .textTheme
            .bodySmall!
            .copyWith(color: Color(0xFFE4E4F0)),
        cursorHeight: 15,
        controller: widget.controller,
        keyboardType: widget.textInputType,
        textInputAction: TextInputAction.done,
        autofocus: false,
        cursorColor: Color(0xFFE4E4F0),
        cursorErrorColor: Color(0xFFE4E4F0),
        obscureText: isPasswordvisible,
        onFieldSubmitted: (_) {
          if (widget.onFieldSubmitted != null) {
            widget.onFieldSubmitted!();
          }
          if (widget.nextFocusNode != null) {
            FocusScope.of(context).requestFocus(widget.nextFocusNode);
          } else {
            FocusScope.of(context).unfocus();
          }
        },
        decoration: InputDecoration(
          errorMaxLines: 1,
          helperText: ' ',
          contentPadding: EdgeInsets.all(8),
          fillColor: Color(0xFF4C4C65),
          filled: true,
          suffixIcon: widget.isSuffixIcon
              ? IconButton(
                  onPressed: () =>
                      setState(() => isPasswordvisible = !isPasswordvisible),
                  icon: isPasswordvisible
                      ? Icon(Icons.visibility_off)
                      : Icon(Icons.visibility))
              : Container(
                  width: 0,
                ),
          suffixIconColor: Color(0xFFE4E4F0),
          enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Color(0xFFA7A7CC), width: 1)),
          focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Color(0xFFE4E4F0), width: 1)),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(
                color: Color(0xFFA7A7CC), width: 1), // как enabledBorder
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(
                color: Color(0xFFA7A7CC), width: 1), // как enabledBorder
          ),
        ),
      ),
    );
  }
}
