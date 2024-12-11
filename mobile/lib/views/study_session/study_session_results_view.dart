import 'package:flutter/material.dart';
import 'package:mobile/models/study_session.dart';

class StudySessionResultsView extends StatefulWidget {
  const StudySessionResultsView({
    super.key,
    required this.studySession,
  });

  final StudySession studySession;

  @override
  State<StudySessionResultsView> createState() =>
      _StudySessionResultsViewState();
}

class _StudySessionResultsViewState extends State<StudySessionResultsView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Session results"),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Text(
              "Study session duration: ${widget.studySession.duration.toString()} seconds"),
        ],
      ),
    );
  }
}
