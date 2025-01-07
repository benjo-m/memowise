import 'dart:developer';
import 'package:desktop/dto/user_response.dart';
import 'package:desktop/dto/user_stats_response.dart';
import 'package:flutter/material.dart';

class UserStatsTable extends StatefulWidget {
  const UserStatsTable({
    super.key,
    required this.data,
  });

  final List<UserStatsResponse> data;

  @override
  State<UserStatsTable> createState() => _UserStatsTableState();
}

class _UserStatsTableState extends State<UserStatsTable> {
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
      ),
    );
  }
}
