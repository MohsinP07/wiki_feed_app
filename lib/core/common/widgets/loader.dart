import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:wikifeed_app/themes/app_pallete.dart';

class Loader extends StatelessWidget {
  const Loader({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppPallete.darkGrey, // Set background color
      child: Center(
        child: Lottie.asset("assets/shimmers/loader.json"),
      ),
    );
  }
}
