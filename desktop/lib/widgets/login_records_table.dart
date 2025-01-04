import 'dart:developer';
import 'package:desktop/dto/login_record_response.dart';
import 'package:flutter/material.dart';

class LoginRecordsTable extends StatefulWidget {
  const LoginRecordsTable({
    super.key,
    required this.data,
  });

  final List<LoginRecordResponse> data;

  @override
  State<LoginRecordsTable> createState() => _LoginRecordsTableState();
}

class _LoginRecordsTableState extends State<LoginRecordsTable> {
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
                    "User ID",
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              DataColumn(
                label: Expanded(
                  child: Text(
                    "Login Time",
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ],
            rows: widget.data.map((loginRecord) {
              return DataRow(
                cells: <DataCell>[
                  DataCell(
                    Center(child: Text(loginRecord.id.toString())),
                  ),
                  DataCell(
                    Center(child: Text(loginRecord.userId.toString())),
                  ),
                  DataCell(
                    Center(
                        child: Text(loginRecord.loginDateTime
                            .toString()
                            .substring(
                                0,
                                loginRecord.loginDateTime.toString().length -
                                    7))),
                  ),
                ],
              );
            }).toList(),
          ),
        ),
      ),
    );
  }
}
