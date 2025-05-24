import 'package:flutter/material.dart';

class ElevatedButtonSmall extends StatefulWidget {
  const ElevatedButtonSmall({
    Key? key,
    required this.title,
    required this.color,
    required this.amountController,
    required this.onSuccess,
  }) : super(key: key);

  final String title;
  final Color color;
  final TextEditingController amountController;
  final VoidCallback onSuccess;

  @override
  State<ElevatedButtonSmall> createState() => _ElevatedButtonSmallState();
}

class _ElevatedButtonSmallState extends State<ElevatedButtonSmall> {
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ButtonStyle(
        backgroundColor: WidgetStatePropertyAll(Colors.transparent),
        shadowColor: WidgetStatePropertyAll(Colors.transparent),
        padding: WidgetStatePropertyAll(EdgeInsets.zero),
      ),
      onPressed: () {
        if (widget.amountController.text.isEmpty) {
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text('Amount is required')));
          return;
        }
        widget.onSuccess();
      },
      child: Ink(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12), color: widget.color),
        child: Container(
          height: 54,
          alignment: Alignment.center,
          child: Text(
            widget.title,
            style: Theme.of(context).textTheme.labelSmall,
          ),
        ),
      ),
    );
  }
}
