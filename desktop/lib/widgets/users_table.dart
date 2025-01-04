import 'dart:developer';
import 'package:desktop/dto/user_response.dart';
import 'package:flutter/material.dart';

class UsersTable extends StatefulWidget {
  const UsersTable({
    super.key,
    required this.data,
  });

  final List<UserResponse> data;

  @override
  State<UsersTable> createState() => _UsersTableState();
}

class _UsersTableState extends State<UsersTable> {
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
                      child: Text(user.createdAt
                          .toString()
                          .substring(0, user.createdAt.toString().length - 7))),
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
