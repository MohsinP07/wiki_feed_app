import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lottie/lottie.dart';
import 'package:neopop/widgets/buttons/neopop_tilted_button/neopop_tilted_button.dart';
import 'package:wikifeed_app/features/category/pages/category_page.dart';
import 'package:wikifeed_app/themes/app_pallete.dart';

class LandingPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  AppPallete.gradientStart,
                  AppPallete.gradientEnd,
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),
          CustomPaint(
            size: const Size(double.infinity, double.infinity),
            painter: NotebookPagePainter(),
          ),
          Align(
            alignment: Alignment.center,
            child: Container(
              height: deviceSize.height * 0.9,
              width: deviceSize.width * 0.9,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Column(
                    children: [
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: const [
                          Text(
                            "Wiki",
                            style: TextStyle(
                              fontSize: 30,
                              fontFamily: "PressStart",
                              color: AppPallete.blackColor,
                            ),
                          ),
                          Text(
                            "Feed",
                            style: TextStyle(
                              fontSize: 30,
                              fontFamily: "PressStart",
                              color: AppPallete.extraDarkGrey,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: deviceSize.height * 0.02),
                      const Text(
                        "TEXT FOR NERDS!",
                        style: TextStyle(
                          fontSize: 14,
                          fontFamily: "IBM PlexMono",
                          color: AppPallete.blackColor,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      SizedBox(height: deviceSize.height * 0.02),
                      // Centered Lottie animation with proper sizing
                      SizedBox(
                        height: deviceSize.height * 0.25, // Adjust height
                        width: deviceSize.width * 0.6, // Adjust width
                        child: Lottie.asset(
                          "assets/shimmers/landing.json",
                          fit: BoxFit.contain,
                        ),
                      ),
                    ],
                  ),
                  NeoPopTiltedButton(
                    isFloating: true,
                    onTapUp: () => _navigateToCategoryPage(context),
                    decoration: const NeoPopTiltedButtonDecoration(
                      color: Color.fromRGBO(0, 0, 0, 1),
                      plunkColor: Color.fromRGBO(0, 0, 0, 1),
                      shadowColor: AppPallete.whiteColor,
                      showShimmer: true,
                    ),
                    child: const Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 70.0,
                        vertical: 15,
                      ),
                      child: Text(
                        'Explore Now',
                        style: TextStyle(
                          fontSize: 16,
                          fontFamily: "PressStart",
                          color: AppPallete.whiteColor,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _navigateToCategoryPage(BuildContext context) {
    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => CategoryPage(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          const begin = Offset(1.0, 0.0);
          const end = Offset.zero;
          const curve = Curves.easeInOut;

          var tween =
              Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
          var offsetAnimation = animation.drive(tween);

          return SlideTransition(position: offsetAnimation, child: child);
        },
      ),
    );
  }
}

class NotebookPagePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = AppPallete.borderColor.withOpacity(0.2) // Light Grey Lines
      ..strokeWidth = 1;
    const int marginSpacing = 40;
    for (double i = 0; i < size.width; i += marginSpacing) {
      canvas.drawLine(Offset(i, 0), Offset(i, size.height), paint);
    }

    const int lineSpacing = 40;
    for (double i = 0; i < size.height; i += lineSpacing) {
      canvas.drawLine(Offset(0, i), Offset(size.width, i), paint);
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
