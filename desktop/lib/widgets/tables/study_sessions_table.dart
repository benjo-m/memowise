import 'package:desktop/config/constants.dart';
import 'package:desktop/dto/study_session_response.dart';
import 'package:desktop/services/study_session_service.dart';
import 'package:desktop/styles.dart';
import 'package:desktop/widgets/dialogs/edit_study_session_dialog.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class StudySessionsTable extends StatefulWidget {
  const StudySessionsTable({
    super.key,
    required this.data,
    required this.onEdit,
    required this.onDelete,
  });

  final List<StudySessionResponse> data;
  final Function() onEdit;
  final Function() onDelete;

  @override
  State<StudySessionsTable> createState() => _StudySessionsTableState();
}

class _StudySessionsTableState extends State<StudySessionsTable> {
  final _scrollController = ScrollController();
  final _studySessionService = StudySessionService(baseUrl, http.Client());

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
                    Center(child: buttonsRow(session)),
                  ),
                ],
              );
            }).toList(),
          ),
        ),
      ),
    );
  }

  Row buttonsRow(StudySessionResponse session) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        TextButton(
          style: blueButtonStyle,
          onPressed: () => showDialog(
            context: context,
            builder: (context) => EditStudySessionDialog(
              studySession: session,
              onEdit: () => widget.onEdit(),
            ),
          ),
          child: const Text("Edit"),
        ),
        const SizedBox(width: 10),
        TextButton(
          style: redButtonStyle,
          onPressed: () => showDeleteDialog(session.id),
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
    await _studySessionService.delete(id);
    widget.onDelete();
  }
}
