import 'package:flutter/material.dart';
import 'package:mobile/models/study_session.dart';
import 'package:mobile/views/main_view.dart';

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
                "Average response time: ${(widget.studySession.duration / widget.studySession.cardCount).toStringAsFixed(2)} seconds",
                style: resultsTextStyle(),
              ),
              SizedBox(
                height: MediaQuery.sizeOf(context).height * 0.03,
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (context) => const MainView()),
                      (route) => false);
                },
                style: ButtonStyle(
                  backgroundColor: const WidgetStatePropertyAll(
                    Colors.greenAccent,
                  ),
                  foregroundColor: const WidgetStatePropertyAll(Colors.white),
                  padding: WidgetStatePropertyAll(
                    EdgeInsets.all(MediaQuery.sizeOf(context).height * 0.014),
                  ),
                  fixedSize: WidgetStatePropertyAll(
                    Size.fromWidth(
                      MediaQuery.sizeOf(context).width * 0.4,
                    ),
                  ),
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.done),
                    SizedBox(
                      width: 5,
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
    return const TextStyle(
      fontWeight: FontWeight.bold,
      color: Color.fromARGB(255, 88, 88, 88),
      fontSize: 16,
    );
  }
}
