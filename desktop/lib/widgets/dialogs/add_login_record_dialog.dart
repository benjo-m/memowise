import 'package:desktop/config/constants.dart';
import 'package:desktop/dto/login_record_dto.dart';
import 'package:desktop/dto/login_record_response.dart';
import 'package:desktop/services/login_record_service.dart';
import 'package:desktop/styles.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class AddLoginRecordDialog extends StatefulWidget {
  const AddLoginRecordDialog({super.key, required this.onAdd});

  final Function(LoginRecordResponse?) onAdd;

  @override
  State<AddLoginRecordDialog> createState() => _AddLoginRecordDialogState();
}

class _AddLoginRecordDialogState extends State<AddLoginRecordDialog> {
  final _loginRecordService = LoginRecordService(baseUrl, http.Client());

  final _formKey = GlobalKey<FormState>();
  final _userIdController = TextEditingController();

  DateTime _loginDate = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      title: const Center(child: Text("Add Login Record")),
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
                        decoration: const InputDecoration(
                          label: Text("User ID"),
                        ),
                      ),
                      const SizedBox(height: 20),
                      const SizedBox(height: 20),
                      InputDatePickerFormField(
                        errorFormatText: "Invalid Date",
                        onDateSaved: (DateTime date) {
                          setState(() => _loginDate = date);
                        },
                        fieldLabelText: "Login Date",
                        initialDate: DateTime.now(),
                        firstDate:
                            DateTime.now().add(const Duration(days: -365)),
                        lastDate: DateTime.now().add(const Duration(days: 365)),
                      ),
                      const SizedBox(height: 20),
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
              final request = LoginRecordDto(
                userId: int.parse(_userIdController.text),
                loginDateTime: _loginDate,
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

  Future<LoginRecordResponse?> create(LoginRecordDto request) async {
    try {
      final response = await _loginRecordService.create(request.toJson());
      return response;
    } on Exception {
      return null;
    }
  }
}
