import 'package:desktop/config/constants.dart';
import 'package:desktop/dto/login_record_response.dart';
import 'package:desktop/services/login_record_service.dart';
import 'package:desktop/styles.dart';
import 'package:desktop/widgets/dialogs/edit_login_record_dialog.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class LoginRecordsTable extends StatefulWidget {
  const LoginRecordsTable({
    super.key,
    required this.data,
    required this.onEdit,
    required this.onDelete,
  });

  final List<LoginRecordResponse> data;
  final Function() onEdit;
  final Function() onDelete;
  @override
  State<LoginRecordsTable> createState() => _LoginRecordsTableState();
}

class _LoginRecordsTableState extends State<LoginRecordsTable> {
  final _scrollController = ScrollController();
  final _loginRecordService = LoginRecordService(baseUrl, http.Client());

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
              DataColumn(
                label: Expanded(
                  child: Text(
                    "Actions",
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
                      child: Text(
                        loginRecord.loginDateTime.toString().substring(
                            0, loginRecord.loginDateTime.toString().length - 7),
                      ),
                    ),
                  ),
                  DataCell(
                    Center(child: buttonsRow(loginRecord)),
                  ),
                ],
              );
            }).toList(),
          ),
        ),
      ),
    );
  }

  Row buttonsRow(LoginRecordResponse loginRecord) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        TextButton(
          style: blueButtonStyle,
          onPressed: () => showDialog(
              context: context,
              builder: (context) => EditLoginRecordDialog(
                  onEdit: () => widget.onEdit(), loginRecord: loginRecord)),
          child: const Text("Edit"),
        ),
        const SizedBox(width: 10),
        TextButton(
          style: redButtonStyle,
          onPressed: () => showDeleteDialog(loginRecord.id),
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
            title: const Center(child: Text("Delete Login Record?")),
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
    await _loginRecordService.delete(id);
    widget.onDelete();
  }
}
