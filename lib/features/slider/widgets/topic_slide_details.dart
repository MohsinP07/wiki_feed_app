import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:wikifeed_app/core/common/widgets/loader.dart';
import 'package:wikifeed_app/features/landing/pages/landing_screen.dart';
import 'package:wikifeed_app/themes/app_pallete.dart';

class TopicDetailsPage extends StatefulWidget {
  final String title;
  TopicDetailsPage({required this.title});

  @override
  _TopicDetailsPageState createState() => _TopicDetailsPageState();
}

class _TopicDetailsPageState extends State<TopicDetailsPage> {
  String? details;

  @override
  void initState() {
    super.initState();
    fetchDetails();
  }

  Future<void> fetchDetails() async {
    final url = Uri.parse(
        'https://en.wikipedia.org/w/api.php?action=query&prop=extracts&explaintext=true&titles=${Uri.encodeComponent(widget.title)}&format=json');
    final response = await http.get(url);
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final pages = data['query']['pages'];
      final pageId = pages.keys.first;
      setState(() {
        details = pages[pageId]['extract'] ?? "No details available.";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(children: [
        CustomPaint(
          size: const Size(double.infinity, double.infinity),
          painter: NotebookPagePainter(),
        ),
        CustomScrollView(
          slivers: [
            SliverAppBar(
              expandedHeight: 100.0,
              backgroundColor: AppPallete.darkGrey, // Fixed background color
              pinned: true,
              flexibleSpace: FlexibleSpaceBar(
                title: Text(
                  widget.title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'PressStart',
                  ),
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: details == null
                    ? const Loader()
                    : Card(
                        elevation: 4,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Text(
                            details!,
                            style: const TextStyle(
                              fontSize: 12,
                              height: 1.5,
                              fontFamily: 'IBM PlexMono',
                            ),
                            textAlign: TextAlign.justify,
                          ),
                        ),
                      ),
              ),
            ),
          ],
        ),
      ]),
    );
  }
}
