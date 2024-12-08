import 'package:flutter/material.dart';
import 'package:mobile/dtos/card_stats_update_request.dart';
import 'package:mobile/models/card.dart' as models;
import 'package:mobile/services/card_service.dart';

class StudySessionResultsView extends StatefulWidget {
  const StudySessionResultsView({
    super.key,
    required this.cards,
  });

  final List<CardStatsUpdateRequest> cards;

  @override
  State<StudySessionResultsView> createState() =>
      _StudySessionResultsViewState();
}

class _StudySessionResultsViewState extends State<StudySessionResultsView> {
  @override
  void initState() {
    super.initState();
    CardService().updateCardStats(widget.cards);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Session results"),
        centerTitle: true,
      ),
      body: Column(
        children: widget.cards
            .map((card) => Text("${card.easeFactor} | ${card.interval}"))
            .toList(),
      ),
    );
  }
}
