import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:neopop/widgets/buttons/neopop_tilted_button/neopop_tilted_button.dart';
import 'package:wikifeed_app/features/slider/widgets/topic_slide_details.dart';
import 'package:wikifeed_app/themes/app_pallete.dart';

class TopicSlide extends StatelessWidget {
  final Map<String, dynamic> topic;
  TopicSlide({required this.topic});

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    print(topic);
    return Scaffold(
      body: Stack(
        children: [
          CustomPaint(
            size: const Size(double.infinity, double.infinity),
            painter: NotebookPagePainter(),
          ),
          Center(
            child: SingleChildScrollView(
              child: CustomPaint(
                painter: PaperEffectPainter(),
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.9,
                  height: MediaQuery.of(context).size.height * 0.9,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFFAF3), // Soft paper-like color
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.15),
                        blurRadius: 8,
                        spreadRadius: 2,
                        offset: const Offset(3, 5),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        topic['title'],
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'PressStart',
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const Divider(),
                      topic['summary'].isEmpty
                          ? Lottie.asset(
                              "assets/shimmers/notes_loading.json",
                              height: 80,
                            )
                          : Text(
                              topic['summary'],
                              style: const TextStyle(
                                fontSize: 14,
                                fontFamily: 'IBM PlexMono',
                              ),
                              textAlign: TextAlign.center,
                            ),
                      const SizedBox(height: 20),
                      Align(
                        alignment: Alignment.bottomRight,
                        child: NeoPopTiltedButton(
                          isFloating: true,
                          onTapUp: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  TopicDetailsPage(title: topic['title']),
                            ),
                          ),
                          decoration: const NeoPopTiltedButtonDecoration(
                            color: Color.fromRGBO(0, 0, 0, 1),
                            plunkColor: Color.fromRGBO(0, 0, 0, 1),
                            shadowColor: AppPallete.gradientStart,
                            showShimmer: true,
                          ),
                          child: const Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: 40.0,
                              vertical: 6,
                            ),
                            child: Text(
                              'Read more',
                              style: TextStyle(
                                fontSize: 12,
                                fontFamily: "PressStart",
                                color: AppPallete.whiteColor,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class NotebookPagePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final Paint paperPaint = Paint()
      ..color = const Color(0xFFFDF3E7)
      ..style = PaintingStyle.fill;
    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), paperPaint);

    final Paint linePaint = Paint()
      ..color = AppPallete.borderColor.withOpacity(0.2)
      ..strokeWidth = 1;

    const double lineSpacing = 40;
    for (double i = lineSpacing; i < size.height; i += lineSpacing) {
      canvas.drawLine(Offset(0, i), Offset(size.width, i), linePaint);
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}

class PaperEffectPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final Paint texturePaint = Paint()
      ..color = Colors.brown.withOpacity(0.08)
      ..style = PaintingStyle.fill;
    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), texturePaint);

    final Paint subtleLines = Paint()
      ..color = Colors.grey.withOpacity(0.15)
      ..strokeWidth = 0.5;

    for (double i = 20; i < size.height; i += 20) {
      canvas.drawLine(Offset(0, i), Offset(size.width, i), subtleLines);
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
