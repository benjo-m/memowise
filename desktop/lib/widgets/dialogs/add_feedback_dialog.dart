import 'package:desktop/config/constants.dart';
import 'package:desktop/dto/feedback_dto.dart';
import 'package:desktop/dto/feedback_response.dart';
import 'package:desktop/services/feedback_service.dart';
import 'package:desktop/styles.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class AddFeedbackDialog extends StatefulWidget {
  const AddFeedbackDialog({super.key, required this.onAdd});

  final Function(FeedbackResponse?) onAdd;

  @override
  State<AddFeedbackDialog> createState() => _AddFeedbackDialogState();
}

class _AddFeedbackDialogState extends State<AddFeedbackDialog> {
  final _feedbackService = FeedbackService(baseUrl, http.Client());

  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();

  String _status = "PENDING";
  DateTime _submittedAt = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      title: const Center(child: Text("Add Feedback")),
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
                        controller: _titleController,
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
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
                          if (value == null || value.trim().isEmpty) {
                            return "Description is required";
                          }
                          return null;
                        },
                        decoration: const InputDecoration(
                          label: Text("Description"),
                        ),
                      ),
                      const SizedBox(height: 20),
                      InputDatePickerFormField(
                        errorFormatText: "Invalid Date",
                        onDateSaved: (DateTime date) {
                          setState(() => _submittedAt = date);
                        },
                        fieldLabelText: "Submitted At",
                        initialDate: DateTime.now(),
                        firstDate:
                            DateTime.now().add(const Duration(days: -365)),
                        lastDate: DateTime.now().add(const Duration(days: 365)),
                      ),
                      const SizedBox(height: 20),
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
              final request = FeedbackDto(
                title: _titleController.text,
                description: _descriptionController.text,
                submittedAt: _submittedAt,
                status: _status,
              );
              final response = await create(request);
              if (response == null) {
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

  Future<FeedbackResponse?> create(FeedbackDto request) async {
    try {
      final response = await _feedbackService.create(request.toJson());
      return response;
    } on Exception {
      return null;
    }
  }
}
