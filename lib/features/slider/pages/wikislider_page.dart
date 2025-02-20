import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:neopop/widgets/buttons/neopop_tilted_button/neopop_tilted_button.dart';
import 'package:wikifeed_app/core/common/widgets/loader.dart';
import 'package:wikifeed_app/features/slider/services/topic_service.dart';
import 'package:wikifeed_app/features/slider/widgets/topic_slide.dart';
import 'package:http/http.dart' as http;
import 'package:wikifeed_app/themes/app_pallete.dart';
import 'package:wikifeed_app/utils/snackbar.dart';

class WikiSliderPage extends StatefulWidget {
  final String category;
  WikiSliderPage({required this.category});

  @override
  _WikiSliderPageState createState() => _WikiSliderPageState();
}

class _WikiSliderPageState extends State<WikiSliderPage> {
  List<Map<String, dynamic>> topics = [];
  final topicServices = TopicServices();
  final PageController _pageController = PageController();
  int currentPage = 0;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    fetchTopicsFromGemini(widget.category);

    // Listen for page changes
    _pageController.addListener(() {
      setState(() {
        currentPage = _pageController.page?.toInt() ?? 0;
      });
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  Future<void> fetchTopicsFromGemini(String category) async {
    setState(() {
      isLoading = true;
    });

    List<String> generatedTopics =
        await topicServices.getGeminiTopics(category);
    List<Map<String, dynamic>> verifiedTopics = [];

    for (String topic in generatedTopics) {
      bool exists = await checkTopicOnWikipedia(topic);
      if (exists) {
        verifiedTopics.add({'title': topic, 'summary': ''});
        if (verifiedTopics.length >= 10) break;
      }
    }

    if (verifiedTopics.isNotEmpty) {
      setState(() {
        topics.addAll(verifiedTopics);
      });

      for (var topic in verifiedTopics) {
        fetchSummary(topic['title']);
      }
    }

    setState(() {
      isLoading = false;
    });
  }

  Future<bool> checkTopicOnWikipedia(String topic) async {
    final url = Uri.parse(
        'https://en.wikipedia.org/w/api.php?action=query&titles=${Uri.encodeComponent(topic)}&format=json');
    final response = await http.get(url);
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return data['query']['pages'].values.first['missing'] == null;
    }
    return false;
  }

  Future<void> fetchSummary(String title) async {
    final url = Uri.parse(
        'https://en.wikipedia.org/api/rest_v1/page/summary/${Uri.encodeComponent(title)}');
    final response = await http.get(url);
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      setState(() {
        topics = topics.map((topic) {
          if (topic['title'] == title) {
            topic['summary'] = data['extract'] ?? "No summary available.";
          }
          return topic;
        }).toList();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: topics.isEmpty
          ? const Loader()
          : PageView.builder(
              controller: _pageController,
              scrollDirection: Axis.vertical,
              itemCount: topics.length,
              itemBuilder: (context, index) {
                return TopicSlide(topic: topics[index]);
              },
            ),
      floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
      floatingActionButton: (currentPage + 1) % 10 == 0 && currentPage + 1 <= 50
          ? isLoading
              ? const CircularProgressIndicator(
                  color: AppPallete.blackColor,
                )
              : NeoPopTiltedButton(
                  isFloating: true,
                  onTapUp: () async {
                    if (topics.length < 50) {
                      showSnackBar(context, "loading more topics please wait...");
                      await fetchTopicsFromGemini(widget.category);
                    }
                  },
                  decoration: NeoPopTiltedButtonDecoration(
                    color: Color.fromARGB(255, 69, 68, 68),
                    plunkColor: AppPallete.darkGrey,
                    shadowColor: AppPallete.gradientStart,
                    showShimmer: false,
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.more_horiz,
                        color: AppPallete.whiteColor,
                        size: 24,
                      ),
                      const SizedBox(height: 4),
                      const Text(
                        ' load more ',
                        style: TextStyle(
                          fontSize: 7,
                          fontFamily: "PressStart",
                          color: AppPallete.whiteColor,
                        ),
                      ),
                    ],
                  ),
                )
          : currentPage + 1 == 50
              ? Padding(
                  padding: const EdgeInsets.only(bottom: 20),
                  child: Text(
                    "You are done for today!",
                    style: TextStyle(
                      fontSize: 14,
                      fontFamily: "PressStart",
                      color: Colors.redAccent,
                    ),
                  ),
                )
              : null,
    );
  }
}
