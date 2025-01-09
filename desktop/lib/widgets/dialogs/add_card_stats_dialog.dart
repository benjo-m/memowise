import 'dart:developer';

import 'package:desktop/config/constants.dart';
import 'package:desktop/dto/achievement_dto.dart';
import 'package:desktop/dto/achievement_response.dart';
import 'package:desktop/dto/card_stats_dto.dart';
import 'package:desktop/dto/card_stats_response.dart';
import 'package:desktop/exceptions/exceptions.dart';
import 'package:desktop/services/achievements_service.dart';
import 'package:desktop/services/card_stats_service.dart';
import 'package:desktop/styles.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class AddCardStatsDialog extends StatefulWidget {
  const AddCardStatsDialog({super.key, required this.onAdd});

  final Function(CardStatsResponse?) onAdd;

  @override
  State<AddCardStatsDialog> createState() => _AddCardStatsDialogState();
}

class _AddCardStatsDialogState extends State<AddCardStatsDialog> {
  final _cardStatService = CardStatsService(baseUrl, http.Client());

  final _formKey = GlobalKey<FormState>();
  final _repetitionsController = TextEditingController();
  final _intervalController = TextEditingController();
  final _easeFactorController = TextEditingController();
  final _cardIdController = TextEditingController();

  String? _cardIdErrorText;
  DateTime _dueDate = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      title: const Center(child: Text("Add Card Stats")),
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
                        controller: _repetitionsController,
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return "Repetitions field is required";
                          }
                          return null;
                        },
                        decoration: const InputDecoration(
                          label: Text("Repetitions"),
                        ),
                      ),
                      const SizedBox(height: 20),
                      TextFormField(
                        controller: _intervalController,
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return "Interval is required";
                          }
                          return null;
                        },
                        decoration: const InputDecoration(
                          label: Text("Interval"),
                        ),
                      ),
                      const SizedBox(height: 20),
                      TextFormField(
                        controller: _easeFactorController,
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return "Ease Factor is required";
                          }
                          return null;
                        },
                        decoration: const InputDecoration(
                          label: Text("Ease Factor"),
                        ),
                      ),
                      const SizedBox(height: 20),
                      InputDatePickerFormField(
                        errorFormatText: "Invalid Date",
                        onDateSaved: (DateTime date) {
                          setState(() => _dueDate = date);
                        },
                        fieldLabelText: "Due Date",
                        initialDate: DateTime.now(),
                        firstDate:
                            DateTime.now().add(const Duration(days: -365)),
                        lastDate: DateTime.now().add(const Duration(days: 365)),
                      ),
                      const SizedBox(height: 20),
                      TextFormField(
                        controller: _cardIdController,
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return "Card ID is required";
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                          label: const Text("Card ID"),
                          errorText: _cardIdErrorText,
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
            log(_cardIdController.text);
            if (_formKey.currentState!.validate()) {
              final request = CardStatsDto(
                cardId: int.parse(_cardIdController.text),
                dueDate: _dueDate,
                easeFactor: double.parse(_easeFactorController.text),
                interval: int.parse(_intervalController.text),
                repetitions: int.parse(_intervalController.text),
              );
              final response = await create(request);
              if (response == null) {
                setState(() => _cardIdErrorText =
                    "Card with this ID already has Card Stats");
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

  Future<CardStatsResponse?> create(CardStatsDto request) async {
    try {
      final response = await _cardStatService.create(request.toJson());
      return response;
    } on Exception {
      return null;
    }
  }
}
