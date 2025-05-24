import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class DownloadWidget extends StatelessWidget {
  const DownloadWidget({
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
            borderRadius: BorderRadius.circular(12), color: Color(0xFF3C3C59)),
        child: Container(
            height: 40,
            width: 185,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Download receipt',
                  style: Theme.of(context).textTheme.displaySmall,
                ),
                SizedBox(
                  width: 12,
                ),
                SvgPicture.asset(
                  'assets/svg/download.svg',
                  width: 15,
                  height: 15,
                )
              ],
            )),
      ),
    );
  }
}
