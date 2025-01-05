import 'dart:developer';
import 'package:desktop/dto/achievement_response.dart';
import 'package:desktop/services/achievements_service.dart';
import 'package:flutter/material.dart';

class AchievementsTable extends StatefulWidget {
  const AchievementsTable({
    super.key,
    required this.data,
  });

  final List<AchievementResponse> data;

  @override
  State<AchievementsTable> createState() => _AchievementsTableState();
}

class _AchievementsTableState extends State<AchievementsTable> {
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
                    "Name",
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              DataColumn(
                label: Expanded(
                  child: Text(
                    "Description",
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
            rows: widget.data.map((achievement) {
              return DataRow(
                cells: <DataCell>[
                  DataCell(
                    Center(child: Text(achievement.id.toString())),
                  ),
                  DataCell(
                    Center(child: Text(achievement.name)),
                  ),
                  DataCell(
                    Center(child: Text(achievement.description)),
                  ),
                  DataCell(
                    Center(
                        child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton(
                          onPressed: () => edit(achievement.id),
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
      ),
    );
  }

  edit(int id) async {
    final a = await AchievementService().getById(id);
    log(a.toJson().toString());
  }
}
