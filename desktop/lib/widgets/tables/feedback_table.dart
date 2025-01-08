import 'dart:developer';

import 'package:desktop/dto/feedback_response.dart';
import 'package:flutter/material.dart';

class FeedbackTable extends StatefulWidget {
  const FeedbackTable({super.key, required this.data});

  final List<FeedbackResponse> data;

  @override
  State<FeedbackTable> createState() => _FeedbackTableState();
}

class _FeedbackTableState extends State<FeedbackTable> {
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
                        child: Text(feedback.submittedAt.toString().substring(
                            0, feedback.submittedAt.toString().length - 7))),
                  ),
                  DataCell(
                    Center(child: Text(feedback.feedbackStatus)),
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
