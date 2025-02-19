import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:wikifeed_app/core/common/widgets/loader.dart';
import 'package:wikifeed_app/features/slider/widgets/topic_slide.dart';
import 'package:http/http.dart' as http;

class WikiSliderPage extends StatefulWidget {
  final String category;
  WikiSliderPage({required this.category});

  @override
  _WikiSliderPageState createState() => _WikiSliderPageState();
}

class _WikiSliderPageState extends State<WikiSliderPage> {
  List<Map<String, dynamic>> topics = [];

  @override
  void initState() {
    super.initState();
    fetchTopics(widget.category);
  }

  Future<void> fetchTopics(String category) async {
    final url = Uri.parse(
        'https://en.wikipedia.org/w/api.php?action=query&list=categorymembers&cmtitle=Category:$category&cmlimit=10&format=json');
    final response = await http.get(url);
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      List<dynamic> pages = data['query']['categorymembers'];
      setState(() {
        topics = pages
            .map((page) => {'title': page['title'], 'summary': ''})
            .toList();
      });
      for (var topic in topics) {
        fetchSummary(topic['title']);
      }
    }
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
              scrollDirection: Axis.vertical,
              itemCount: topics.length,
              itemBuilder: (context, index) {
                return TopicSlide(topic: topics[index]);
              },
            ),
    );
  }
}
