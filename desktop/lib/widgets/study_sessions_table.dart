import 'dart:developer';
import 'package:desktop/dto/card_response.dart';
import 'package:desktop/dto/study_session_response.dart';
import 'package:flutter/material.dart';

class StudySessionsTable extends StatefulWidget {
  const StudySessionsTable({
    super.key,
    required this.data,
  });

  final List<StudySessionResponse> data;

  @override
  State<StudySessionsTable> createState() => _StudySessionsTableState();
}

class _StudySessionsTableState extends State<StudySessionsTable> {
  final _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return Scrollbar(
      controller: _scrollController,
      thumbVisibility: true,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        controller: _scrollController,
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
                    "Duration",
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              DataColumn(
                label: Expanded(
                  child: Text(
                    "Card Count",
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              DataColumn(
                label: Expanded(
                  child: Text(
                    "AVG Ease Factor",
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              DataColumn(
                label: Expanded(
                  child: Text(
                    "AVG Repetitions",
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              DataColumn(
                label: Expanded(
                  child: Text(
                    "Studied At",
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
                    "Deck ID",
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
            rows: widget.data.map((session) {
              return DataRow(
                cells: <DataCell>[
                  DataCell(
                    Center(child: Text(session.id.toString())),
                  ),
                  DataCell(
                    Center(child: Text(session.duration.toString())),
                  ),
                  DataCell(
                    Center(child: Text(session.cardCount.toString())),
                  ),
                  DataCell(
                    Center(child: Text(session.averageEaseFactor.toString())),
                  ),
                  DataCell(
                    Center(child: Text(session.averageRepetitions.toString())),
                  ),
                  DataCell(
                    Center(
                        child: Text(session.studiedAt.toString().substring(
                            0, session.studiedAt.toString().length - 10))),
                  ),
                  DataCell(
                    Center(child: Text(session.userId.toString())),
                  ),
                  DataCell(
                    Center(child: Text(session.deckId.toString())),
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
