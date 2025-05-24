import 'package:flutter/material.dart';

class LogOutWidget extends StatelessWidget {
  const LogOutWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ButtonStyle(
        backgroundColor: WidgetStatePropertyAll(Colors.transparent),
        shadowColor: WidgetStatePropertyAll(Colors.transparent),
        padding: WidgetStatePropertyAll(EdgeInsets.zero),
      ),
      onPressed: () {},
      child: Ink(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12), color: Color(0xFF232336)),
        child: Container(
          height: 33,
          width: 102,
          alignment: Alignment.center,
          child: Text(
            'Log Out',
            style: Theme.of(context)
                .textTheme
                .displaySmall!
                .copyWith(fontWeight: FontWeight.w500),
          ),
        ),
      ),
    );
  }
}
