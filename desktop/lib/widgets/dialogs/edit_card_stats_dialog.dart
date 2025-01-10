import 'package:desktop/config/constants.dart';
import 'package:desktop/dto/card_stats_dto.dart';
import 'package:desktop/dto/card_stats_response.dart';
import 'package:desktop/services/card_stats_service.dart';
import 'package:desktop/styles.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class EditCardStatsDialog extends StatefulWidget {
  const EditCardStatsDialog(
      {super.key, required this.cardStats, required this.onEdit});

  final CardStatsResponse cardStats;
  final Function() onEdit;

  @override
  State<EditCardStatsDialog> createState() => _EditCardStatsDialogState();
}

class _EditCardStatsDialogState extends State<EditCardStatsDialog> {
  final _cardStatService = CardStatsService(baseUrl, http.Client());

  final _formKey = GlobalKey<FormState>();
  final _repetitionsController = TextEditingController();
  final _intervalController = TextEditingController();
  final _easeFactorController = TextEditingController();
  final _cardIdController = TextEditingController();

  String? _cardIdErrorText;
  DateTime _dueDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    _repetitionsController.text = widget.cardStats.repetitions.toString();
    _intervalController.text = widget.cardStats.interval.toString();
    _easeFactorController.text = widget.cardStats.easeFactor.toString();
    _cardIdController.text = widget.cardStats.cardId.toString();
  }

  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      title: const Center(child: Text("Edit Card Stats")),
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
                          label: Text("Repetitions"),
                        ),
                      ),
                      const SizedBox(height: 20),
                      TextFormField(
                        controller: _intervalController,
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
                          label: Text("Interval"),
                        ),
                        keyboardType: TextInputType.number,
                      ),
                      const SizedBox(height: 20),
                      TextFormField(
                        controller: _easeFactorController,
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
                        initialDate: widget.cardStats.dueDate,
                        firstDate:
                            DateTime.now().add(const Duration(days: -365)),
                        lastDate: DateTime.now().add(const Duration(days: 365)),
                      ),
                      const SizedBox(height: 20),
                      TextFormField(
                        controller: _cardIdController,
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return "Card ID field is required";
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
                buttonsRow(context),
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
          onPressed: () {
            setState(() => _cardIdErrorText = null);
            Navigator.pop(context);
          },
          child: const Text("Cancel"),
        ),
        const SizedBox(width: 20),
        TextButton(
          style: blueButtonStyle,
          onPressed: () async {
            if (_formKey.currentState!.validate()) {
              _formKey.currentState!.save();
              final request = CardStatsDto(
                repetitions: int.parse(_repetitionsController.text),
                interval: int.parse(_intervalController.text),
                easeFactor: double.parse(_easeFactorController.text),
                dueDate: _dueDate,
                cardId: int.parse(_cardIdController.text),
              );
              final response = await edit(widget.cardStats.id, request);
              if (response == null) {
                setState(() => _cardIdErrorText =
                    "Card Stats row for that card already exists");
                return;
              } else if (context.mounted) {
                widget.onEdit();
                Navigator.pop(context);
                _cardIdErrorText = null;
              }
            }
          },
          child: const Text("Edit"),
        ),
      ],
    );
  }

  Future<CardStatsResponse?> edit(int id, CardStatsDto cardStatsDto) async {
    try {
      final response = await _cardStatService.update(id, cardStatsDto.toJson());
      return response;
    } on Exception {
      return null;
    }
  }
}
