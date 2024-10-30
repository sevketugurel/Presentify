// lib/widgets/animated_timeline_list.dart

import 'package:flutter/material.dart';
import 'package:timeline_tile/timeline_tile.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

class AnimatedTimelineList extends StatefulWidget {
  final List<MapEntry<String, String>> sections;

  AnimatedTimelineList({required this.sections});

  @override
  _AnimatedTimelineListState createState() => _AnimatedTimelineListState();
}

class _AnimatedTimelineListState extends State<AnimatedTimelineList> {
  final GlobalKey<AnimatedListState> _listKey = GlobalKey<AnimatedListState>();
  final List<MapEntry<String, String>> _displayedSections = [];

  @override
  void initState() {
    super.initState();
    _animateSections();
  }

  /// Animates the addition of timeline sections with a delay.
  void _animateSections() async {
    for (var i = 0; i < widget.sections.length; i++) {
      await Future.delayed(Duration(milliseconds: 200)); // Delay between items
      _displayedSections.add(widget.sections[i]);
      _listKey.currentState?.insertItem(i);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20.0),
      child: AnimatedList(
        key: _listKey,
        initialItemCount: _displayedSections.length,
        itemBuilder: (context, index, animation) {
          final entry = _displayedSections[index];
          return FadeTransition(
            opacity: animation,
            child: SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(1, 0),
                end: Offset.zero,
              ).animate(animation),
              child: TimelineTile(
                alignment: TimelineAlign.start,
                indicatorStyle: IndicatorStyle(
                  width: 20,
                  color: Colors.blueAccent,
                  indicatorXY: 0.5,
                  padding: const EdgeInsets.all(8),
                ),
                beforeLineStyle: LineStyle(color: Colors.blueAccent, thickness: 2),
                endChild: Container(
                  margin: const EdgeInsets.only(bottom: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        entry.key,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.blueAccent,
                        ),
                      ),
                      const SizedBox(height: 5),
                      MarkdownBody(
                        data: entry.value,
                        styleSheet: MarkdownStyleSheet(
                          p: TextStyle(fontSize: 16, color: Colors.black87, height: 1.5),
                          strong: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
