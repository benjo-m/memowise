import 'package:desktop/config/constants.dart';
import 'package:desktop/dto/feedback_dto.dart';
import 'package:desktop/dto/feedback_response.dart';
import 'package:desktop/exceptions/exceptions.dart';
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
  final _userIdController = TextEditingController();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  late String _status;
  late DateTime _submittedAt;

  String? _userIdErrorText;

  @override
  void initState() {
    super.initState();
    _userIdController.text = widget.feedback.userId.toString();
    _titleController.text = widget.feedback.title;
    _descriptionController.text = widget.feedback.description;
    _status = widget.feedback.feedbackStatus;
    _submittedAt = widget.feedback.submittedAt;
  }

  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      title: const Center(child: Text("Edit Feedback")),
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
                userId: int.parse(_userIdController.text),
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
    } on InvalidUserIdException {
      setState(() {
        _userIdErrorText = "User does not exist";
      });
      return null;
    }
  }
}
