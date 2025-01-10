import 'package:desktop/config/constants.dart';
import 'package:desktop/dto/user_stats_dto.dart';
import 'package:desktop/dto/user_stats_response.dart';
import 'package:desktop/services/user_stats_service.dart';
import 'package:desktop/styles.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class EditUserStatsDialog extends StatefulWidget {
  const EditUserStatsDialog({
    super.key,
    required this.onEdit,
    required this.stats,
  });

  final Function() onEdit;
  final UserStatsResponse stats;
  @override
  State<EditUserStatsDialog> createState() => _EditUserStatsDialogState();
}

class _EditUserStatsDialogState extends State<EditUserStatsDialog> {
  final _userStatService = UserStatsService(baseUrl, http.Client());

  final _formKey = GlobalKey<FormState>();
  final _decksCreatedController = TextEditingController();
  final _cardCreatedController = TextEditingController();
  final _cardsLearnedController = TextEditingController();
  final _studyStreakController = TextEditingController();
  final _sessionsCompletedController = TextEditingController();
  final _decksGeneratedController = TextEditingController();
  final _longestStreakController = TextEditingController();
  final _correctAnswersController = TextEditingController();
  final _userIdController = TextEditingController();

  String? _userIdErrorText;

  @override
  void initState() {
    super.initState();
    _decksCreatedController.text = widget.stats.totalDecksCreated.toString();
    _cardCreatedController.text = widget.stats.totalCardsCreated.toString();
    _cardsLearnedController.text = widget.stats.totalCardsLearned.toString();
    _studyStreakController.text = widget.stats.studyStreak.toString();
    _sessionsCompletedController.text =
        widget.stats.totalSessionsCompleted.toString();
    _decksGeneratedController.text =
        widget.stats.totalDecksGenerated.toString();
    _longestStreakController.text = widget.stats.longestStudyStreak.toString();
    _correctAnswersController.text =
        widget.stats.totalCorrectAnswers.toString();
    _userIdController.text = widget.stats.userId.toString();
  }

  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      title: const Center(child: Text("Edit User Stats")),
      children: [
        SizedBox(
          width: MediaQuery.sizeOf(context).width * 0.25,
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextFormField(
                        controller: _userIdController,
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return "User ID is required";
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                            label: const Text("User ID"),
                            errorText: _userIdErrorText),
                      ),
                      const SizedBox(height: 20),
                      TextFormField(
                        controller: _decksCreatedController,
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return "Decks Created is required";
                          }
                          return null;
                        },
                        decoration: const InputDecoration(
                          label: Text("Decks Created"),
                        ),
                      ),
                      const SizedBox(height: 20),
                      TextFormField(
                        controller: _cardCreatedController,
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return "Cards Created is required";
                          }
                          return null;
                        },
                        decoration: const InputDecoration(
                          label: Text("Cards Created"),
                        ),
                      ),
                      const SizedBox(height: 20),
                      TextFormField(
                        controller: _cardsLearnedController,
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return "Cards Learned is required";
                          }
                          return null;
                        },
                        decoration: const InputDecoration(
                          label: Text("Cards Learned"),
                        ),
                      ),
                      const SizedBox(height: 20),
                      TextFormField(
                        controller: _studyStreakController,
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return "Study Streak is required";
                          }
                          return null;
                        },
                        decoration: const InputDecoration(
                          label: Text("Study Streak"),
                        ),
                      ),
                      const SizedBox(height: 20),
                      TextFormField(
                        controller: _sessionsCompletedController,
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return "Sessions Completed is required";
                          }
                          return null;
                        },
                        decoration: const InputDecoration(
                          label: Text("Study Sessions Completed"),
                        ),
                      ),
                      const SizedBox(height: 20),
                      TextFormField(
                        controller: _correctAnswersController,
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return "Correct Answers is required";
                          }
                          return null;
                        },
                        decoration: const InputDecoration(
                          label: Text("Correct Answers"),
                        ),
                      ),
                      const SizedBox(height: 20),
                      TextFormField(
                        controller: _decksGeneratedController,
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return "Decks Generated is required";
                          }
                          return null;
                        },
                        decoration: const InputDecoration(
                          label: Text("Decks Generated"),
                        ),
                      ),
                      const SizedBox(height: 20),
                      TextFormField(
                        controller: _longestStreakController,
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return "Longest Study Streak is required";
                          }
                          return null;
                        },
                        decoration: const InputDecoration(
                          label: Text("Longest Study Streak"),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                buttonsRow(context)
              ],
            ),
          ),
        )
      ],
    );
  }

  Row buttonsRow(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        TextButton(
          style: greyButtonStyle,
          onPressed: () => Navigator.pop(context),
          child: const Text("Cancel"),
        ),
        const SizedBox(width: 20),
        TextButton(
          style: blueButtonStyle,
          onPressed: () async {
            if (_formKey.currentState!.validate()) {
              final request = UserStatsDto(
                userId: int.parse(_userIdController.text),
                totalDecksCreated: int.parse(_decksCreatedController.text),
                totalDecksGenerated: int.parse(_decksGeneratedController.text),
                totalCardsCreated: int.parse(_cardCreatedController.text),
                totalCardsLearned: int.parse(_cardsLearnedController.text),
                studyStreak: int.parse(_studyStreakController.text),
                longestStudyStreak: int.parse(_longestStreakController.text),
                totalSessionsCompleted:
                    int.parse(_sessionsCompletedController.text),
                totalCorrectAnswers: int.parse(_correctAnswersController.text),
              );
              final response = await edit(widget.stats.id, request);
              if (response == null) {
                if (response == null) {
                  setState(() => _userIdErrorText =
                      "User with this ID already has User Stats");
                  return;
                }
                return;
              }
              if (context.mounted) {
                widget.onEdit();
                Navigator.pop(context);
              }
            }
          },
          child: const Text("Edit"),
        ),
      ],
    );
  }

  Future<UserStatsResponse?> edit(int id, UserStatsDto request) async {
    try {
      final response = await _userStatService.update(id, request.toJson());
      return response;
    } on Exception {
      return null;
    }
  }
}
