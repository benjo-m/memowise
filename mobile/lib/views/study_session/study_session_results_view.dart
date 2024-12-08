import 'package:flutter/material.dart';
import 'package:mobile/models/card.dart' as models;

class StudySessionResultsView extends StatelessWidget {
  const StudySessionResultsView({
    super.key,
    required this.cards,
  });

  final List<models.Card> cards;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Session results"),
        centerTitle: true,
      ),
      body: Column(
        children: cards
            .map((card) => Text("${card.easeFactor} | ${card.interval}"))
            .toList(),
      ),
    );
  }
}
