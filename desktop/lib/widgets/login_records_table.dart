import 'dart:developer';
import 'package:desktop/dto/login_record_response.dart';
import 'package:flutter/material.dart';

class LoginRecordsTable extends StatelessWidget {
  const LoginRecordsTable({
    super.key,
    required this.data,
  });

  final List<LoginRecordResponse> data;

  @override
  Widget build(BuildContext context) {
    return DataTable(
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
        DataColumn(
          label: Expanded(
            child: Text(
              "Actions",
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ],
      rows: data.map((loginRecord) {
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
                  child: Text(loginRecord.loginDateTime.toString().substring(
                      0, loginRecord.loginDateTime.toString().length - 7))),
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
    );
  }
}
