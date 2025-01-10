import 'dart:developer';

import 'package:desktop/config/constants.dart';
import 'package:desktop/dto/card_dto.dart';
import 'package:desktop/dto/card_response.dart';
import 'package:desktop/services/cards_service.dart';
import 'package:desktop/styles.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class AddCardDialog extends StatefulWidget {
  const AddCardDialog({super.key, required this.onAdd});

  final Function(CardResponse?) onAdd;

  @override
  State<AddCardDialog> createState() => _AddCardDialogState();
}

class _AddCardDialogState extends State<AddCardDialog> {
  final _cardService = CardService(baseUrl, http.Client());

  final _formKey = GlobalKey<FormState>();
  final _questionController = TextEditingController();
  final _answerController = TextEditingController();
  final _deckIdController = TextEditingController();
  String? _nameErrorText;

  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      title: const Center(child: Text("Add Card")),
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
                        decoration: InputDecoration(
                          label: const Text("Question"),
                          errorText: _nameErrorText,
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
                        decoration: const InputDecoration(
                          label: Text("Deck ID"),
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
              final request = CardDto(
                question: _questionController.text,
                answer: _answerController.text,
                deckId: int.parse(_deckIdController.text),
              );
              final response = await create(request);
              if (response == null) {
                setState(() => _nameErrorText = "Name taken");
                log(_nameErrorText ?? "");
                return;
              }
              if (context.mounted) {
                widget.onAdd(response);
                Navigator.pop(context);
              }
            }
          },
          child: const Text("Add"),
        ),
      ],
    );
  }

  Future<CardResponse?> create(CardDto request) async {
    try {
      final response = await _cardService.create(request.toJson());
      return response;
    } on Exception {
      return null;
    }
  }
}
