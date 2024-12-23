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
        title: const Text("Session Results"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(25.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                "Study session duration: ${formatDuration(widget.studySession.duration)} minutes",
                style: resultsTextStyle(),
              ),
              SizedBox(
                height: MediaQuery.sizeOf(context).height * 0.03,
              ),
              Text(
                "Cards learned: ${widget.studySession.cardCount}",
                style: resultsTextStyle(),
              ),
              SizedBox(
                height: MediaQuery.sizeOf(context).height * 0.03,
              ),
              Text(
                "Average response time: ${widget.studySession.duration / widget.studySession.cardCount} seconds",
                style: resultsTextStyle(),
              ),
              SizedBox(
                height: MediaQuery.sizeOf(context).height * 0.03,
              ),
              TextButton(
                onPressed: () => Navigator.pop(context, true),
                style: ButtonStyle(
                  backgroundColor: const WidgetStatePropertyAll(
                    Color.fromARGB(255, 95, 197, 98),
                  ),
                  foregroundColor: const WidgetStatePropertyAll(Colors.white),
                  fixedSize: WidgetStatePropertyAll(Size(
                      MediaQuery.sizeOf(context).width * 0.3,
                      MediaQuery.sizeOf(context).height * 0.05)),
                  side: const WidgetStatePropertyAll(
                    BorderSide(
                      width: 2,
                      color: Colors.green,
                    ),
                  ),
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.done),
                    SizedBox(
                      width: 8,
                    ),
                    Text("Complete"),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String formatDuration(int seconds) {
    final minutes = seconds ~/ 60;
    final remainingSeconds = seconds % 60;
    return '$minutes:${remainingSeconds.toString().padLeft(2, '0')}';
  }

  TextStyle resultsTextStyle() {
    return TextStyle(
      fontWeight: FontWeight.bold,
      color: const Color.fromARGB(255, 88, 88, 88),
      fontSize: MediaQuery.sizeOf(context).height * 0.02,
    );
  }
}
