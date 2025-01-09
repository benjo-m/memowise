import 'dart:developer';
import 'package:desktop/config/constants.dart';
import 'package:desktop/dto/payment_record_response.dart';
import 'package:desktop/services/payment_record_service.dart';
import 'package:desktop/styles.dart';
import 'package:desktop/widgets/dialogs/edit_payment_record_dialog.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class PaymentRecordsTable extends StatefulWidget {
  const PaymentRecordsTable({
    super.key,
    required this.data,
    required this.onEdit,
    required this.onDelete,
  });

  final List<PaymentRecordResponse> data;
  final Function() onEdit;
  final Function() onDelete;

  @override
  State<PaymentRecordsTable> createState() => _PaymentRecordsTableState();
}

class _PaymentRecordsTableState extends State<PaymentRecordsTable> {
  final _paymentRecordService = PaymentRecordService(baseUrl, http.Client());
  final _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return Scrollbar(
      controller: _scrollController,
      thumbVisibility: true,
      child: SingleChildScrollView(
        controller: _scrollController,
        scrollDirection: Axis.horizontal,
        child: ConstrainedBox(
          constraints:
              BoxConstraints(minWidth: MediaQuery.sizeOf(context).width * 0.93),
          child: DataTable(
            showBottomBorder: true,
            headingRowColor: const WidgetStatePropertyAll(
                Color.fromARGB(255, 226, 246, 255)),
            columns: const <DataColumn>[
              DataColumn(
                label: Expanded(
                  child: Text(
                    "Id",
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              DataColumn(
                label: Expanded(
                  child: Text(
                    "Payment Intent ID",
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              DataColumn(
                label: Expanded(
                  child: Text(
                    "User ID",
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              DataColumn(
                label: Expanded(
                  child: Text(
                    "Amount",
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              DataColumn(
                label: Expanded(
                  child: Text(
                    "Currency",
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              DataColumn(
                label: Expanded(
                  child: Text(
                    "Created At",
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              DataColumn(
                label: Expanded(
                  child: Text(
                    "Actions",
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ],
            rows: widget.data.map((paymentRecord) {
              return DataRow(
                cells: <DataCell>[
                  DataCell(
                    Center(child: Text(paymentRecord.id.toString())),
                  ),
                  DataCell(
                    Center(child: Text(paymentRecord.paymentIntentId)),
                  ),
                  DataCell(
                    Center(child: Text(paymentRecord.userId.toString())),
                  ),
                  DataCell(
                    Center(
                        child: Text((paymentRecord.amount / 100).toString())),
                  ),
                  DataCell(
                    Center(child: Text(paymentRecord.currency.toUpperCase())),
                  ),
                  DataCell(
                    Center(
                        child: Text(paymentRecord.createdAt
                            .toString()
                            .substring(
                                0,
                                paymentRecord.createdAt.toString().length -
                                    7))),
                  ),
                  DataCell(
                    Center(child: buttonsRow(paymentRecord)),
                  ),
                ],
              );
            }).toList(),
          ),
        ),
      ),
    );
  }

  Row buttonsRow(PaymentRecordResponse paymentRecord) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        TextButton(
          style: blueButtonStyle,
          onPressed: () => showDialog(
              context: context,
              builder: (context) => EditPaymentRecordDialog(
                    onEdit: () => widget.onEdit(),
                    paymentRecord: paymentRecord,
                  )),
          child: const Text("Edit"),
        ),
        SizedBox(width: 10),
        TextButton(
          style: redButtonStyle,
          onPressed: () => showDeleteDialog(paymentRecord.id),
          child: const Text("Delete"),
        ),
      ],
    );
  }

  showDeleteDialog(int id) {
    showDialog(
        context: context,
        builder: (context) {
          return SimpleDialog(
            title: const Center(child: Text("Delete Payment Record?")),
            children: [
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Center(
                  child: Text("Are you sure you want to delete this row?"),
                ),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextButton(
                    style: greyButtonStyle,
                    onPressed: () => Navigator.pop(context),
                    child: const Text("Cancel"),
                  ),
                  const SizedBox(width: 20),
                  TextButton(
                    style: redButtonStyle,
                    onPressed: () {
                      delete(id);
                      Navigator.pop(context);
                    },
                    child: const Text("Delete"),
                  ),
                ],
              ),
            ],
          );
        });
  }

  delete(int id) async {
    await _paymentRecordService.delete(id);
    widget.onDelete();
  }
}
