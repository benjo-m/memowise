import 'package:desktop/config/constants.dart';
import 'package:desktop/dto/card_stats_dto.dart';
import 'package:desktop/dto/card_stats_response.dart';
import 'package:desktop/dto/feedback_dto.dart';
import 'package:desktop/dto/feedback_response.dart';
import 'package:desktop/services/card_stats_service.dart';
import 'package:desktop/services/feedback_service.dart';
import 'package:desktop/styles.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class EditFeedbackDialog extends StatefulWidget {
  const EditFeedbackDialog(
      {super.key, required this.feedback, required this.onEdit});

  final FeedbackResponse feedback;
  final Function() onEdit;

  @override
  State<EditFeedbackDialog> createState() => _EditFeedbackDialogState();
}

class _EditFeedbackDialogState extends State<EditFeedbackDialog> {
  final _feedbackService = FeedbackService(baseUrl, http.Client());

  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();

  late String _status;
  late DateTime _submittedAt;

  @override
  void initState() {
    super.initState();
    _titleController.text = widget.feedback.title;
    _descriptionController.text = widget.feedback.description;
    _status = widget.feedback.feedbackStatus;
    _submittedAt = widget.feedback.submittedAt;
  }

  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      title: const Center(child: Text("Edit Achievement")),
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
                        controller: _titleController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Title is required";
                          }
                          return null;
                        },
                        decoration: const InputDecoration(
                          label: Text("Title"),
                        ),
                      ),
                      const SizedBox(height: 20),
                      TextFormField(
                        controller: _descriptionController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Title is required";
                          }
                          return null;
                        },
                        decoration: const InputDecoration(
                          label: Text("Description"),
                        ),
                        keyboardType: TextInputType.number,
                      ),
                      const SizedBox(height: 20),
                      InputDatePickerFormField(
                        errorFormatText: "Invalid Date",
                        onDateSaved: (DateTime date) {
                          setState(() => _submittedAt = date);
                        },
                        fieldLabelText: "Due Date",
                        initialDate: widget.feedback.submittedAt,
                        firstDate:
                            DateTime.now().add(const Duration(days: -365)),
                        lastDate: DateTime.now().add(const Duration(days: 365)),
                      ),
                      SizedBox(height: 20),
                      DropdownButtonFormField<String>(
                        value: _status,
                        decoration: const InputDecoration(
                          labelText: "Status",
                        ),
                        onChanged: (value) {
                          setState(() {
                            _status = value!;
                          });
                        },
                        items: const [
                          DropdownMenuItem(
                              value: "PENDING", child: Text("PENDING")),
                          DropdownMenuItem(
                              value: "SAVED", child: Text("SAVED")),
                          DropdownMenuItem(
                              value: "COMPLETED", child: Text("COMPLETED")),
                        ],
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

              final request = FeedbackDto(
                status: _status,
                title: _titleController.text,
                description: _descriptionController.text,
                submittedAt: _submittedAt,
              );

              final response = await edit(widget.feedback.id, request);
              if (response == null) {
                return;
              } else if (context.mounted) {
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

  Future<FeedbackResponse?> edit(int id, FeedbackDto request) async {
    try {
      final response = await _feedbackService.update(id, request.toJson());
      return response;
    } on Exception {
      return null;
    }
  }
}
