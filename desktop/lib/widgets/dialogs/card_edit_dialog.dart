import 'package:desktop/config/constants.dart';
import 'package:desktop/dto/card_dto.dart';
import 'package:desktop/dto/card_response.dart';
import 'package:desktop/exceptions/exceptions.dart';
import 'package:desktop/services/cards_service.dart';
import 'package:desktop/styles.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class EditCardDialog extends StatefulWidget {
  const EditCardDialog({super.key, required this.card, required this.onEdit});

  final CardResponse card;
  final Function() onEdit;

  @override
  State<EditCardDialog> createState() => _EditCardDialogState();
}

class _EditCardDialogState extends State<EditCardDialog> {
  final _cardService = CardService(baseUrl, http.Client());
  final _formKey = GlobalKey<FormState>();
  final _questionController = TextEditingController();
  final _answerController = TextEditingController();
  final _deckIdController = TextEditingController();
  String? _deckIdErrorText;

  @override
  void initState() {
    super.initState();
    _questionController.text = widget.card.question;
    _answerController.text = widget.card.answer;
    _deckIdController.text = widget.card.deckId.toString();
  }

  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      title: const Center(child: Text("Edit Card")),
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
                    children: [
                      TextFormField(
                        controller: _questionController,
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return "Question is required";
                          }
                          return null;
                        },
                        decoration: const InputDecoration(
                          label: Text("Question"),
                        ),
                      ),
                      const SizedBox(height: 20),
                      TextFormField(
                        controller: _answerController,
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return "Answer is required";
                          }
                          return null;
                        },
                        decoration: const InputDecoration(
                          label: Text("Answer"),
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextButton(
                      style: greyButtonStyle,
                      onPressed: () {
                        setState(() => _deckIdErrorText = null);
                        Navigator.pop(context);
                      },
                      child: const Text("Cancel"),
                    ),
                    const SizedBox(width: 20),
                    TextButton(
                      style: blueButtonStyle,
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          final request = CardDto(
                            question: _questionController.text,
                            answer: _answerController.text,
                            deckId: int.parse(_deckIdController.text),
                          );
                          final response = await edit(widget.card.id, request);
                          if (response == null) {
                            return;
                          } else if (context.mounted) {
                            widget.onEdit();
                            Navigator.pop(context);
                            _deckIdErrorText = null;
                          }
                        }
                      },
                      child: const Text("Edit"),
                    ),
                  ],
                ),
              ],
            ),
          ),
        )
      ],
    );
  }

  Future<CardResponse?> edit(int id, CardDto request) async {
    try {
      final response = await _cardService.update(id, request.toJson());
      return response;
    } on InvalidDeckIdException {
      setState(() => _deckIdErrorText = "Deck does not exist");
      return null;
    }
  }
}
