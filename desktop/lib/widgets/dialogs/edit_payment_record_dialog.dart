import 'package:desktop/config/constants.dart';
import 'package:desktop/dto/payment_record_dto.dart';
import 'package:desktop/dto/payment_record_response.dart';
import 'package:desktop/exceptions/exceptions.dart';
import 'package:desktop/services/payment_record_service.dart';
import 'package:desktop/styles.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class EditPaymentRecordDialog extends StatefulWidget {
  const EditPaymentRecordDialog(
      {super.key, required this.onEdit, required this.paymentRecord});

  final Function() onEdit;
  final PaymentRecordResponse paymentRecord;

  @override
  State<EditPaymentRecordDialog> createState() =>
      _EditPaymentRecordDialogState();
}

class _EditPaymentRecordDialogState extends State<EditPaymentRecordDialog> {
  final _paymentRecordService = PaymentRecordService(baseUrl, http.Client());

  final _formKey = GlobalKey<FormState>();
  final _intentController = TextEditingController();
  final _userIdController = TextEditingController();
  final _amountController = TextEditingController();
  final _currencyController = TextEditingController();
  late DateTime _createdAt;

  String? _userIdErrorText;

  @override
  void initState() {
    super.initState();
    _intentController.text = widget.paymentRecord.paymentIntentId.toString();
    _userIdController.text = widget.paymentRecord.userId.toString();
    _amountController.text = widget.paymentRecord.amount.toString();
    _currencyController.text = widget.paymentRecord.currency;
    _createdAt = widget.paymentRecord.createdAt;
  }

  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      title: const Center(child: Text("Edit Payment Record")),
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
                        controller: _intentController,
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return "Payment Intent is required";
                          }
                          return null;
                        },
                        decoration: const InputDecoration(
                          label: Text("Payment Intent"),
                        ),
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
                        controller: _amountController,
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
                          label: Text("Amount"),
                        ),
                      ),
                      const SizedBox(height: 20),
                      TextFormField(
                        controller: _currencyController,
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return "Currency is required";
                          }
                          return null;
                        },
                        decoration: const InputDecoration(
                          label: Text("Currency"),
                        ),
                      ),
                      const SizedBox(height: 20),
                      InputDatePickerFormField(
                        errorFormatText: "Invalid Date",
                        onDateSaved: (DateTime date) {
                          setState(() => _createdAt = date);
                        },
                        fieldLabelText: "Created At",
                        initialDate: _createdAt,
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
              _formKey.currentState!.save();
              final request = PaymentRecordDto(
                amount: int.parse(_amountController.text),
                createdAt: _createdAt,
                currency: _currencyController.text,
                paymentIntentId: _intentController.text,
                userId: int.parse(_userIdController.text),
              );
              final response = await edit(widget.paymentRecord.id, request);
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

  Future<PaymentRecordResponse?> edit(int id, PaymentRecordDto request) async {
    try {
      final response = await _paymentRecordService.update(id, request.toJson());
      return response;
    } on InvalidUserIdException {
      setState(() {
        _userIdErrorText = "User does not exist";
      });
      return null;
    }
  }
}
