import 'package:desktop/config/constants.dart';
import 'package:desktop/dto/user_stats_response.dart';
import 'package:desktop/services/user_stats_service.dart';
import 'package:desktop/styles.dart';
import 'package:desktop/widgets/dialogs/edit_user_stats_dialog.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class UserStatsTable extends StatefulWidget {
  const UserStatsTable({
    super.key,
    required this.data,
    required this.onEdit,
    required this.onDelete,
  });

  final List<UserStatsResponse> data;
  final Function() onEdit;
  final Function() onDelete;

  @override
  State<UserStatsTable> createState() => _UserStatsTableState();
}

class _UserStatsTableState extends State<UserStatsTable> {
  final _userStatService = UserStatsService(baseUrl, http.Client());
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
                    "Decks Created",
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              DataColumn(
                label: Expanded(
                  child: Text(
                    "Cards Created",
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              DataColumn(
                label: Expanded(
                  child: Text(
                    "Cards Learned",
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              DataColumn(
                label: Expanded(
                  child: Text(
                    "Study Streak",
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              DataColumn(
                label: Expanded(
                  child: Text(
                    "Sessions Completed",
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              DataColumn(
                label: Expanded(
                  child: Text(
                    "Correct Answers",
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              DataColumn(
                label: Expanded(
                  child: Text(
                    "Decks Generated",
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              DataColumn(
                label: Expanded(
                  child: Text(
                    "Longest Study Streak",
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
            rows: widget.data.map((stats) {
              return DataRow(
                cells: <DataCell>[
                  DataCell(
                    Center(child: Text(stats.id.toString())),
                  ),
                  DataCell(
                    Center(child: Text(stats.userId.toString())),
                  ),
                  DataCell(
                    Center(child: Text(stats.totalDecksCreated.toString())),
                  ),
                  DataCell(
                    Center(child: Text(stats.totalCardsCreated.toString())),
                  ),
                  DataCell(
                    Center(child: Text(stats.totalCardsLearned.toString())),
                  ),
                  DataCell(
                    Center(child: Text(stats.studyStreak.toString())),
                  ),
                  DataCell(
                    Center(
                        child: Text(stats.totalSessionsCompleted.toString())),
                  ),
                  DataCell(
                    Center(child: Text(stats.totalCorrectAnswers.toString())),
                  ),
                  DataCell(
                    Center(child: Text(stats.totalDecksGenerated.toString())),
                  ),
                  DataCell(
                    Center(child: Text(stats.longestStudyStreak.toString())),
                  ),
                  DataCell(
                    Center(child: buttonsRow(stats)),
                  ),
                ],
              );
            }).toList(),
          ),
        ),
      ),
    );
  }

  Row buttonsRow(UserStatsResponse stats) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        TextButton(
          style: blueButtonStyle,
          onPressed: () => showDialog(
            context: context,
            builder: (context) => EditUserStatsDialog(
              stats: stats,
              onEdit: () => widget.onEdit(),
            ),
          ),
          child: const Text("Edit"),
        ),
        const SizedBox(width: 10),
        TextButton(
          style: redButtonStyle,
          onPressed: () => showDeleteDialog(stats.id),
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
            title: const Center(child: Text("Delete User Stats?")),
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
    await _userStatService.delete(id);
    widget.onDelete();
  }
}
