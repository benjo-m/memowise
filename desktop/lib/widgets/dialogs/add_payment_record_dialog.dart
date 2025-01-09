import 'package:desktop/config/constants.dart';
import 'package:desktop/dto/payment_record_dto.dart';
import 'package:desktop/dto/payment_record_response.dart';
import 'package:desktop/services/payment_record_service.dart';
import 'package:desktop/styles.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class AddPaymentRecordDialog extends StatefulWidget {
  const AddPaymentRecordDialog({super.key, required this.onAdd});

  final Function(PaymentRecordResponse?) onAdd;

  @override
  State<AddPaymentRecordDialog> createState() => _AddPaymentRecordDialogState();
}

class _AddPaymentRecordDialogState extends State<AddPaymentRecordDialog> {
  final _paymentRecordService = PaymentRecordService(baseUrl, http.Client());

  final _formKey = GlobalKey<FormState>();
  final _intentController = TextEditingController();
  final _userIdController = TextEditingController();
  final _amountController = TextEditingController();
  final _currencyController = TextEditingController();

  DateTime _createdAt = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      title: const Center(child: Text("Add Payment Record")),
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
                      TextFormField(
                        controller: _amountController,
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return "Amount is required";
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
              final request = PaymentRecordDto(
                amount: int.parse(_amountController.text),
                createdAt: _createdAt,
                currency: _currencyController.text,
                paymentIntentId: _intentController.text,
                userId: int.parse(_userIdController.text),
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

  Future<PaymentRecordResponse?> create(PaymentRecordDto request) async {
    try {
      final response = await _paymentRecordService.create(request.toJson());
      return response;
    } on Exception {
      return null;
    }
  }
}
