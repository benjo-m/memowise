import 'package:flutter/material.dart';
import 'package:mobile/dtos/deck_summary_response.dart';
import 'package:mobile/services/deck_service.dart';
import 'package:mobile/styles.dart';
import 'package:mobile/views/study_session/study_session_view.dart';

class DeckListItem extends StatelessWidget {
  const DeckListItem({
    super.key,
    required this.deckSummary,
  });

  final DeckSummary deckSummary;

  @override
  Widget build(BuildContext context) {
    var textStyle = TextStyle(
      fontSize: MediaQuery.sizeOf(context).width * 0.04,
      fontWeight: FontWeight.bold,
      // color: Colors.white,
    );

    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: primaryBackgroundColor,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          width: 3,
          color: primaryBorderColor,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            deckSummary.name,
            style: TextStyle(
              fontSize: MediaQuery.sizeOf(context).width * 0.05,
              fontWeight: FontWeight.bold,
              // color: Colors.white,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.star_rounded,
                    color: Colors.amber,
                  ),
                  const SizedBox(
                    width: 8,
                  ),
                  Text(
                    "New: ${deckSummary.newCards}",
                    style: textStyle,
                  ),
                ],
              ),
              const SizedBox(
                height: 5,
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.school,
                    color: Colors.blue,
                  ),
                  const SizedBox(
                    width: 8,
                  ),
                  Text(
                    "Learning: ${deckSummary.learningCards}",
                    style: textStyle,
                  ),
                ],
              ),
              const SizedBox(
                height: 5,
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.done_all,
                    color: Color.fromARGB(255, 146, 226, 76),
                  ),
                  const SizedBox(
                    width: 8,
                  ),
                  Text(
                    "Learned: ${deckSummary.learnedCards}",
                    style: textStyle,
                  ),
                ],
              ),
            ],
          ),
          Column(
            children: [
              timeToCompleteStudySession(context),
              TextButton(
                style: ButtonStyle(
                  foregroundColor: const WidgetStatePropertyAll(Colors.white),
                  backgroundColor:
                      WidgetStatePropertyAll(Color.fromARGB(255, 146, 226, 76)),
                  fixedSize: WidgetStatePropertyAll(
                      Size.fromWidth(MediaQuery.sizeOf(context).width * 0.35)),
                ),
                onPressed: () async => await startStudySession(context),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.play_arrow_rounded),
                    Text(
                      "Study Deck",
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Future<void> startStudySession(BuildContext context) async {
    final deck = await DeckService().getDeckById(deckSummary.id);
    if (context.mounted) {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => StudySessionView(deck: deck)));
    }
  }

  Row timeToCompleteStudySession(BuildContext context) {
    const iconColor = Colors.black;

    final TextStyle textStyle = TextStyle(
      fontSize: MediaQuery.sizeOf(context).width * 0.03,
      // color: Colors.white,
      fontWeight: FontWeight.bold,
    );

    if (deckSummary.newCards == 0 && deckSummary.learningCards == 0) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.hourglass_bottom_rounded,
            size: 15.0,
            color: iconColor,
          ),
          Text(
            "All caught up!",
            style: textStyle,
          ),
        ],
      );
    } else if (deckSummary.timeToComplete < 60) {
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.hourglass_top_rounded,
            size: 15.0,
            color: iconColor,
          ),
          Text(
            "< 1 minute",
            style: textStyle,
          ),
        ],
      );
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Icon(
          Icons.hourglass_top_rounded,
          size: 15.0,
          color: iconColor,
        ),
        Text(
          "${(deckSummary.timeToComplete / 60).ceil()} minutes",
          style: textStyle,
        ),
      ],
    );
  }
}
