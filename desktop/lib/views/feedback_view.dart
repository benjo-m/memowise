import 'dart:developer';

import 'package:desktop/dto/feedback_response.dart';
import 'package:desktop/dto/feedback_paginated_response.dart';
import 'package:desktop/services/feedback_service.dart';
import 'package:flutter/material.dart';

class FeedbackView extends StatefulWidget {
  const FeedbackView({super.key});

  @override
  State<FeedbackView> createState() => _FeedbackViewState();
}

class _FeedbackViewState extends State<FeedbackView> {
  int _currentPage = 1;
  Future<FeedbackPaginatedResponse> _fetchFeedback(int page) async {
    return await FeedbackService().getFeedback(page);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Feedback"),
        ),
        body: FutureBuilder(
          future: _fetchFeedback(_currentPage),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              final feedbackData = snapshot.data!;
              return SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(25.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      table(feedbackData.data),
                      SizedBox(
                        height: 50,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          ElevatedButton(
                            onPressed: feedbackData.hasPreviousPage
                                ? () => setState(() => _currentPage--)
                                : null,
                            child: const Text("Previous page"),
                          ),
                          ElevatedButton(
                            onPressed: feedbackData.hasNextPage
                                ? () => setState(() => _currentPage++)
                                : null,
                            child: const Text("Next page"),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              );
            }

            if (snapshot.hasError) {
              return Text(snapshot.error!.toString());
            }

            return const Center(
              child: CircularProgressIndicator(),
            );
          },
        ));
  }

  DataTable table(List<FeedbackResponse> data) {
    return DataTable(
      showBottomBorder: true,
      headingRowColor:
          WidgetStatePropertyAll(Color.fromARGB(255, 226, 246, 255)),
      columns: const <DataColumn>[
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
              "View Details",
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ],
      rows: data.map((feedback) {
        return DataRow(
          cells: <DataCell>[
            DataCell(
              Center(child: Text(feedback.title)),
            ),
            DataCell(
              Center(
                  child: Text(DateTime(
                feedback.submittedAt.year,
                feedback.submittedAt.month,
                feedback.submittedAt.day,
              ).toString().replaceAll("00:00:00.000", ""))),
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
                    onPressed: () => log("view details for ${feedback.title}"),
                    child: const Text("Details"),
                  ),
                ],
              )),
            ),
          ],
        );
      }).toList(),
    );
  }
}
