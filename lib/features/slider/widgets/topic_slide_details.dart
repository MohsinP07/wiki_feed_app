import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:lottie/lottie.dart';
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
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchDetails();
  }

  Future<void> fetchDetails() async {
    try {
      final url = Uri.parse(
          'https://en.wikipedia.org/w/api.php?action=query&prop=extracts&explaintext&format=json&titles=${Uri.encodeComponent(widget.title)}');
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final pages = data['query']['pages'];

        if (pages.isNotEmpty) {
          final pageId = pages.keys.first;
          final page = pages[pageId];

          setState(() {
            details = page.containsKey('extract')
                ? page['extract']
                : "No details available.";
            isLoading = false;
          });
        } else {
          setState(() {
            details = "No details found for this topic.";
            isLoading = false;
          });
        }
      } else {
        setState(() {
          details = "Error fetching data.";
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        details = "An error occurred: ${e.toString()}";
        isLoading = false;
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
              backgroundColor: AppPallete.darkGrey,
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
                child: isLoading
                    ? Lottie.asset("assets/shimmers/notes_loading.json",
                        height: 60)
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
