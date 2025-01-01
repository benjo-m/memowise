import 'dart:developer';

import 'package:desktop/dto/feedback_paginated_response.dart';
import 'package:desktop/dto/feedback_response.dart';
import 'package:desktop/dto/feedback_status_update_request.dart';
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
    return await FeedbackService().getAllFeedback(page);
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
                    const SizedBox(
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
      ),
    );
  }

  DataTable table(List<FeedbackResponse> data) {
    return DataTable(
      showBottomBorder: true,
      headingRowColor:
          const WidgetStatePropertyAll(Color.fromARGB(255, 226, 246, 255)),
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
                    onPressed: () => feedbackDetailsDialog(feedback.id),
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

  feedbackDetailsDialog(int id) async {
    final feedback = await FeedbackService().getFeedbackById(id);
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return SimpleDialog(
            titlePadding: const EdgeInsets.all(25),
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(feedback.title),
                MouseRegion(
                  cursor: SystemMouseCursors.click,
                  child: GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: const Icon(Icons.close),
                  ),
                )
              ],
            ),
            children: [
              Padding(
                padding: const EdgeInsets.all(25.0),
                child: SizedBox(
                  width: MediaQuery.sizeOf(context).width * 0.5,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Description",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Text(feedback.description),
                      const SizedBox(
                        height: 50,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          ElevatedButton(
                            onPressed: () {
                              removeFeedback(feedback.id);
                              Navigator.pop(context);
                            },
                            child: const Text("Remove"),
                          ),
                          const SizedBox(
                            width: 20,
                          ),
                          ElevatedButton(
                            onPressed: () {
                              updateFeedbackStatus(feedback.id, "SAVED");
                              Navigator.pop(context);
                            },
                            child: const Text("Save"),
                          ),
                          const SizedBox(
                            width: 20,
                          ),
                          ElevatedButton(
                            onPressed: () {
                              updateFeedbackStatus(feedback.id, "COMPLETED");
                              Navigator.pop(context);
                            },
                            child: const Text("Complete"),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              )
            ],
          );
        });
  }

  updateFeedbackStatus(int feedbackId, String status) async {
    final req = FeedbackStatusUpdateRequest(status: status);
    await FeedbackService()
        .updateFeedbackStatus(feedbackId, req)
        .then((value) => setState(() {
              _fetchFeedback(_currentPage);
            }));
  }

  removeFeedback(int feedbackId) async {
    await FeedbackService()
        .removeFeedback(feedbackId)
        .then((value) => setState(() {
              _fetchFeedback(_currentPage);
            }));
  }
}
