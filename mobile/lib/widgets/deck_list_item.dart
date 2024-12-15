import 'package:flutter/material.dart';
import 'package:mobile/dtos/deck_summary_response.dart';
import 'package:mobile/services/deck_service.dart';
import 'package:mobile/views/study_session/study_session_view.dart';

class DeckListItem extends StatelessWidget {
  const DeckListItem({
    super.key,
    required this.deckSummary,
  });

  final DeckSummary deckSummary;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xffFEEFAD),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            width: 2.0,
            color: const Color.fromARGB(255, 252, 221, 84),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Text(
                  deckSummary.name,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
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
                          style: const TextStyle(
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 10,
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
                          style: const TextStyle(fontSize: 16),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.done_all,
                          color: Colors.green,
                        ),
                        const SizedBox(
                          width: 8,
                        ),
                        Text(
                          "Learned: ${deckSummary.learnedCards}",
                          style: const TextStyle(fontSize: 16),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Column(
                children: [
                  if (deckSummary.newCards == 0 &&
                      deckSummary.learningCards == 0)
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.hourglass_bottom_rounded,
                          size: 15.0,
                        ),
                        Text(
                          "All caught up!",
                          style: TextStyle(
                            fontSize: 13,
                          ),
                        ),
                      ],
                    )
                  else if (deckSummary.timeToComplete < 60)
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.hourglass_top_rounded,
                          size: 15.0,
                        ),
                        Text(
                          "< 1 minute",
                          style: TextStyle(
                            fontSize: 13,
                          ),
                        ),
                      ],
                    )
                  else
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.hourglass_top_rounded,
                          size: 15.0,
                        ),
                        Text(
                          "${(deckSummary.timeToComplete / 60).ceil()} minutes",
                          style: const TextStyle(
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  const SizedBox(
                    height: 3,
                  ),
                  Center(
                    child: TextButton(
                      style: const ButtonStyle(
                        foregroundColor: WidgetStatePropertyAll(Colors.white),
                        backgroundColor: WidgetStatePropertyAll(
                            Color.fromARGB(255, 95, 197, 98)),
                        side: WidgetStatePropertyAll(
                          BorderSide(
                            width: 2,
                            color: Colors.green,
                          ),
                        ),
                        fixedSize: WidgetStatePropertyAll(
                          Size(120, 4),
                        ),
                      ),
                      onPressed: () async {
                        final deck =
                            await DeckService().getDeckById(deckSummary.id);
                        if (context.mounted) {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      StudySessionView(deck: deck)));
                        }
                      },
                      child: const Row(
                        children: [
                          Icon(Icons.play_arrow_rounded),
                          Text("Study Deck"),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
