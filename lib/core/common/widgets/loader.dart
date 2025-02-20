import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:wikifeed_app/themes/app_pallete.dart';

class Loader extends StatelessWidget {
  const Loader({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppPallete.darkGrey,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Lottie.asset("assets/shimmers/loader.json"),
            Text(
              "Getting you there please wait....",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: AppPallete.whiteColor,
                fontFamily: "PressStart",
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
