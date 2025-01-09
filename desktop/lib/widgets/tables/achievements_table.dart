import 'package:desktop/config/constants.dart';
import 'package:desktop/dto/achievement_response.dart';
import 'package:desktop/services/achievements_service.dart';
import 'package:desktop/styles.dart';
import 'package:desktop/widgets/dialogs/edit_achievement_dialog.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class AchievementsTable extends StatefulWidget {
  const AchievementsTable({
    super.key,
    required this.data,
    required this.onEdit,
    required this.onDelete,
  });

  final List<AchievementResponse> data;
  final Function() onEdit;
  final Function() onDelete;

  @override
  State<AchievementsTable> createState() => _AchievementsTableState();
}

class _AchievementsTableState extends State<AchievementsTable> {
  final _scrollController = ScrollController();
  final _achievementService = AchievementService(baseUrl, http.Client());
  late List<AchievementResponse> achievements;

  @override
  void initState() {
    super.initState();
    achievements = widget.data;
  }

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
            rows: achievements.map((achievement) {
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
                          TextButton(
                            style: blueButtonStyle,
                            onPressed: () => showDialog(
                              context: context,
                              builder: (context) => EditAchievementDialog(
                                achievement: achievement,
                                onEdit: () => widget.onEdit(),
                              ),
                            ),
                            child: const Text("Edit"),
                          ),
                          const SizedBox(width: 10),
                          TextButton(
                            style: redButtonStyle,
                            onPressed: () => showDeleteDialog(achievement.id),
                            child: const Text("Delete"),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              );
            }).toList(),
          ),
        ),
      ),
    );
  }

  showDeleteDialog(int id) {
    showDialog(
        context: context,
        builder: (context) {
          return SimpleDialog(
            title: const Center(child: Text("Delete Achievement?")),
            children: [
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Center(
                  child:
                      Text("Are you sure you want to delete this achievement?"),
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
    await _achievementService.delete(id);
    widget.onDelete();
  }
}
