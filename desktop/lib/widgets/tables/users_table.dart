import 'package:desktop/config/constants.dart';
import 'package:desktop/dto/user_response.dart';
import 'package:desktop/services/user_service.dart';
import 'package:desktop/styles.dart';
import 'package:desktop/widgets/dialogs/edit_user_dialog.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class UsersTable extends StatefulWidget {
  const UsersTable({
    super.key,
    required this.data,
    required this.onEdit,
    required this.onDelete,
  });

  final List<UserResponse> data;
  final Function() onEdit;
  final Function() onDelete;

  @override
  State<UsersTable> createState() => _UsersTableState();
}

class _UsersTableState extends State<UsersTable> {
  final _scrollController = ScrollController();
  final _userService = UserService(baseUrl, http.Client());

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
                    "Username",
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              DataColumn(
                label: Expanded(
                  child: Text(
                    "Email",
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              DataColumn(
                label: Expanded(
                  child: Text(
                    "Is Admin",
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              DataColumn(
                label: Expanded(
                  child: Text(
                    "Is Premium",
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
            rows: widget.data.map((user) {
              return DataRow(
                cells: <DataCell>[
                  DataCell(
                    Center(child: Text(user.id.toString())),
                  ),
                  DataCell(
                    Center(child: Text(user.username)),
                  ),
                  DataCell(
                    Center(child: Text(user.email)),
                  ),
                  DataCell(
                    Center(child: Text(user.isAdmin.toString())),
                  ),
                  DataCell(
                    Center(child: Text(user.isPremium.toString())),
                  ),
                  DataCell(
                    Center(
                        child: Text(user.createdAt.toString().substring(
                            0, user.createdAt.toString().length - 7))),
                  ),
                  DataCell(
                    Center(child: buttonsRow(user)),
                  ),
                ],
              );
            }).toList(),
          ),
        ),
      ),
    );
  }

  Row buttonsRow(UserResponse user) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        TextButton(
          style: blueButtonStyle,
          onPressed: () => showDialog(
            context: context,
            builder: (context) => EditUserDialog(
              user: user,
              onEdit: () => widget.onEdit(),
            ),
          ),
          child: const Text("Edit"),
        ),
        const SizedBox(width: 10),
        TextButton(
          style: redButtonStyle,
          onPressed: () => showDeleteDialog(user.id),
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
            title: const Center(child: Text("Delete Study Session?")),
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
    await _userService.delete(id);
    widget.onDelete();
  }
}
