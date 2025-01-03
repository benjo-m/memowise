import 'dart:developer';
import 'package:desktop/dto/login_record_response.dart';
import 'package:desktop/dto/payment_record_response.dart';
import 'package:flutter/material.dart';

class PaymentRecordsTable extends StatefulWidget {
  const PaymentRecordsTable({
    super.key,
    required this.data,
  });

  final List<PaymentRecordResponse> data;

  @override
  State<PaymentRecordsTable> createState() => _PaymentRecordsTableState();
}

class _PaymentRecordsTableState extends State<PaymentRecordsTable> {
  final _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return Scrollbar(
      controller: _scrollController,
      thumbVisibility: true,
      child: SingleChildScrollView(
        controller: _scrollController,
        scrollDirection: Axis.horizontal,
        child: DataTable(
          showBottomBorder: true,
          headingRowColor:
              const WidgetStatePropertyAll(Color.fromARGB(255, 226, 246, 255)),
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
                  Center(child: Text((paymentRecord.amount / 100).toString())),
                ),
                DataCell(
                  Center(child: Text(paymentRecord.currency.toUpperCase())),
                ),
                DataCell(
                  Center(
                      child: Text(paymentRecord.createdAt.toString().substring(
                          0, paymentRecord.createdAt.toString().length - 7))),
                ),
                DataCell(
                  Center(
                      child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        onPressed: () => log("edit"),
                        child: const Text("Edit"),
                      ),
                      ElevatedButton(
                        onPressed: () => log("delete"),
                        child: const Text("Delete"),
                      ),
                    ],
                  )),
                ),
              ],
            );
          }).toList(),
        ),
      ),
    );
  }
}
