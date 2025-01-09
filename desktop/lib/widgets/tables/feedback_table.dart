import 'dart:developer';

import 'package:desktop/config/constants.dart';
import 'package:desktop/dto/feedback_response.dart';
import 'package:desktop/services/feedback_service.dart';
import 'package:desktop/styles.dart';
import 'package:desktop/widgets/dialogs/edit_feedback_dialog.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class FeedbackTable extends StatefulWidget {
  const FeedbackTable(
      {super.key,
      required this.data,
      required this.onEdit,
      required this.onDelete});

  final List<FeedbackResponse> data;
  final Function() onEdit;
  final Function() onDelete;

  @override
  State<FeedbackTable> createState() => _FeedbackTableState();
}

class _FeedbackTableState extends State<FeedbackTable> {
  final _scrollController = ScrollController();
  final _feedbackService = FeedbackService(baseUrl, http.Client());

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
                    "Title",
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
                    "Submitted At",
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              DataColumn(
                label: Expanded(
                  child: Text(
                    "Status",
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
            rows: widget.data.map((feedback) {
              return DataRow(
                cells: <DataCell>[
                  DataCell(
                    Center(child: Text(feedback.id.toString())),
                  ),
                  DataCell(
                    Center(child: Text(feedback.title)),
                  ),
                  DataCell(
                    Center(
                      child: Text(
                        feedback.description.length > 50
                            ? '${feedback.description.substring(0, 50).trim()}...'
                            : feedback.description,
                      ),
                    ),
                  ),
                  DataCell(
                    Center(
                        child: Text(
                            feedback.submittedAt.toString().substring(0, 10))),
                  ),
                  DataCell(
                    Center(child: Text(feedback.feedbackStatus)),
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
                              builder: (context) => EditFeedbackDialog(
                                    feedback: feedback,
                                    onEdit: () => widget.onEdit(),
                                  )),
                          child: const Text("Edit"),
                        ),
                        SizedBox(width: 10),
                        TextButton(
                          style: redButtonStyle,
                          onPressed: () => showDeleteDialog(feedback.id),
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

  showDeleteDialog(int id) {
    showDialog(
        context: context,
        builder: (context) {
          return SimpleDialog(
            title: const Center(child: Text("Delete Feedback?")),
            children: [
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Center(
                  child: Text("Are you sure you want to delete this feedback?"),
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
    await _feedbackService.delete(id);
    widget.onDelete();
  }
}
