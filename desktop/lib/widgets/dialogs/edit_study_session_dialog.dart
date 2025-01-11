import 'package:desktop/config/constants.dart';
import 'package:desktop/dto/study_session_dto.dart';
import 'package:desktop/dto/study_session_response.dart';
import 'package:desktop/exceptions/exceptions.dart';
import 'package:desktop/services/study_session_service.dart';
import 'package:desktop/styles.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class EditStudySessionDialog extends StatefulWidget {
  const EditStudySessionDialog({
    super.key,
    required this.onEdit,
    required this.studySession,
  });

  final Function() onEdit;
  final StudySessionResponse studySession;

  @override
  State<EditStudySessionDialog> createState() => _EditStudySessionDialogState();
}

class _EditStudySessionDialogState extends State<EditStudySessionDialog> {
  final _studySessionService = StudySessionService(baseUrl, http.Client());

  final _formKey = GlobalKey<FormState>();
  final _durationController = TextEditingController();
  final _cardCountController = TextEditingController();
  final _avgEfController = TextEditingController();
  final _avgRepsController = TextEditingController();
  final _userIdController = TextEditingController();
  final _deckIdController = TextEditingController();
  late DateTime _studiedAt;

  String? _deckIdErrorText;
  String? _userIdErrorText;

  @override
  void initState() {
    super.initState();
    _durationController.text = widget.studySession.duration.toString();
    _cardCountController.text = widget.studySession.cardCount.toString();
    _avgEfController.text = widget.studySession.averageEaseFactor.toString();
    _avgRepsController.text = widget.studySession.averageRepetitions.toString();
    _userIdController.text = widget.studySession.userId.toString();
    _deckIdController.text = widget.studySession.deckId.toString();

    _studiedAt = widget.studySession.studiedAt;
  }

  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      title: const Center(child: Text("Edit Study Session")),
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
                        controller: _durationController,
                        validator: (value) {
                          if (value == null) {
                            return "Please enter a valid positive integer";
                          }
                          int? number = int.tryParse(value);
                          if (number == null || number < 0) {
                            return "Please enter a valid positive integer";
                          }
                          return null;
                        },
                        decoration: const InputDecoration(
                          label: Text("Duration"),
                        ),
                      ),
                      const SizedBox(height: 20),
                      TextFormField(
                        controller: _cardCountController,
                        validator: (value) {
                          if (value == null) {
                            return "Please enter a valid positive integer";
                          }
                          int? number = int.tryParse(value);
                          if (number == null || number < 0) {
                            return "Please enter a valid positive integer";
                          }
                          return null;
                        },
                        decoration: const InputDecoration(
                          label: Text("Card Count"),
                        ),
                      ),
                      const SizedBox(height: 20),
                      TextFormField(
                        controller: _avgEfController,
                        validator: (value) {
                          if (value == null) {
                            return "Please enter a valid positive integer";
                          }
                          double? number = double.tryParse(value);
                          if (number == null || number < 1.3 || number > 2.7) {
                            return "Ease Factor must be between 1.3 & 2.7";
                          }
                          return null;
                        },
                        decoration: const InputDecoration(
                          label: Text("AVG Ease Factor"),
                        ),
                      ),
                      const SizedBox(height: 20),
                      TextFormField(
                        controller: _avgRepsController,
                        validator: (value) {
                          if (value == null) {
                            return "Please enter a valid positive number";
                          }
                          int? number = int.tryParse(value);
                          if (number == null || number < 0) {
                            return "Please enter a valid positive number";
                          }
                          return null;
                        },
                        decoration: const InputDecoration(
                          label: Text("AVG Repetitions"),
                        ),
                      ),
                      const SizedBox(height: 20),
                      InputDatePickerFormField(
                        errorFormatText: "Invalid Date",
                        onDateSaved: (DateTime date) {
                          setState(() => _studiedAt = date);
                        },
                        fieldLabelText: "Studied At",
                        initialDate: DateTime.now(),
                        firstDate:
                            DateTime.now().add(const Duration(days: -365)),
                        lastDate: DateTime.now().add(const Duration(days: 365)),
                      ),
                      const SizedBox(height: 20),
                      TextFormField(
                        controller: _userIdController,
                        validator: (value) {
                          if (value == null) {
                            return "Please enter a valid positive integer";
                          }
                          int? number = int.tryParse(value);
                          if (number == null || number < 0) {
                            return "Please enter a valid positive integer";
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                          label: const Text("User ID"),
                          errorText: _userIdErrorText,
                        ),
                      ),
                      const SizedBox(height: 20),
                      TextFormField(
                        controller: _deckIdController,
                        validator: (value) {
                          if (value == null) {
                            return "Please enter a valid positive integer";
                          }
                          int? number = int.tryParse(value);
                          if (number == null || number < 0) {
                            return "Please enter a valid positive integer";
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                          label: const Text("Deck ID"),
                          errorText: _deckIdErrorText,
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
              _formKey.currentState!.save();
              final request = StudySessionDto(
                averageEaseFactor: double.parse(_avgEfController.text),
                studiedAt: _studiedAt,
                averageRepetitions: double.parse(_avgRepsController.text),
                duration: int.parse(_durationController.text),
                userId: int.parse(_userIdController.text),
                cardCount: int.parse(_cardCountController.text),
                deckId: int.parse(_deckIdController.text),
                cardsRated1: 0,
                cardsRated2: 0,
                cardsRated3: 0,
                cardsRated4: 0,
                cardsRated5: 0,
              );
              final response = await edit(widget.studySession.id, request);
              if (response == null) {
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

  Future<StudySessionResponse?> edit(int id, StudySessionDto request) async {
    try {
      final response = await _studySessionService.update(id, request.toJson());
      return response;
    } on InvalidDeckIdException {
      setState(() {
        _deckIdErrorText = "Deck does not exist";
      });
      return null;
    } on InvalidUserIdException {
      setState(() {
        _userIdErrorText = "User does not exist";
      });
      return null;
    }
  }
}
