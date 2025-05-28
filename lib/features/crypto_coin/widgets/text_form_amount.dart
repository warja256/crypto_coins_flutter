import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class TextFormAmountWidget extends StatelessWidget {
  const TextFormAmountWidget({
    super.key,
    required this.amountController,
  });

  final TextEditingController amountController;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: amountController,
      decoration: InputDecoration(
        suffixStyle: Theme.of(context)
            .textTheme
            .bodySmall!
            .copyWith(color: Colors.white),
        suffix: Padding(
          padding: EdgeInsets.only(right: 10),
          child: Text('\$'),
        ),
        errorMaxLines: 1,
        helperText: ' ',
        contentPadding: EdgeInsets.all(8),
        fillColor: Color(0xFF4C4C65),
        filled: true,
        hintText: '0.00',
        hintStyle: Theme.of(context)
            .textTheme
            .bodySmall!
            .copyWith(color: Colors.white),
        suffixIconColor: Color(0xFFE4E4F0),
        enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(color: Color(0xFFA7A7CC), width: 1)),
        focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(color: Color(0xFFE4E4F0), width: 1)),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Color(0xFFA7A7CC), width: 1),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Color(0xFFA7A7CC), width: 1),
        ),
      ),
      keyboardType: TextInputType.numberWithOptions(decimal: true),
      cursorColor: Color(0xFFE4E4F0),
      autofocus: true,
      inputFormatters: [
        FilteringTextInputFormatter.allow(RegExp(r'^\d*,?\d*')),
        FilteringTextInputFormatter.allow(RegExp(r'[а-яА-Я]')),
      ],
    );
  }
}
