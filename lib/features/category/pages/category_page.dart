import 'package:flutter/material.dart';
import 'package:wikifeed_app/features/slider/pages/wikislider_page.dart';
import 'package:wikifeed_app/themes/app_pallete.dart';

class CategoryPage extends StatelessWidget {
  final List<Map<String, dynamic>> categories = [
    {"name": "Technology", "icon": Icons.computer},
    {"name": "Science", "icon": Icons.science},
    {"name": "History", "icon": Icons.history},
    {"name": "Art", "icon": Icons.brush},
    {"name": "Geography", "icon": Icons.public},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Select Category",
          style: TextStyle(
            fontFamily: 'PressStart',
            fontSize: 14,
          ),
        ),
        backgroundColor: AppPallete.darkGrey,
        elevation: 0,
      ),
      body: Stack(
        children: [
          CustomPaint(
            size: const Size(double.infinity, double.infinity),
            painter: NotebookPagePainter(),
          ),
          ListView.builder(
            padding: const EdgeInsets.symmetric(vertical: 16),
            itemCount: categories.length,
            itemBuilder: (context, index) {
              return Container(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: Colors.white.withOpacity(0.8),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.2),
                      spreadRadius: 1,
                      blurRadius: 2,
                      offset: const Offset(0, 1),
                    ),
                  ],
                ),
                child: ListTile(
                  leading: Icon(categories[index]["icon"],
                      color: AppPallete.darkGrey),
                  title: Text(
                    categories[index]["name"],
                    style: const TextStyle(
                      fontFamily: 'IBM PlexMono',
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  trailing: const Icon(Icons.arrow_forward_ios, size: 18),
                  onTap: () =>
                      _navigateToCategory(context, categories[index]["name"]),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  void _navigateToCategory(BuildContext context, String category) {
    Navigator.of(context).push(
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) =>
            WikiSliderPage(category: category),
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
      ..color = AppPallete.borderColor.withOpacity(0.2)
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
