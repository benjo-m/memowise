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

  var _feedbackFuture = FeedbackService().getAllFeedback();

  final _statusController = TextEditingController(text: "Any");
  final _sortByController = TextEditingController(text: "Id");
  final _sortOrderController = TextEditingController(text: "Ascending");

  String _selectedStatus = "Any";
  String _selectedSortBy = "Id";
  bool _sortDescending = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Padding(
          padding: EdgeInsets.only(left: 10),
          child: Text("Feedback"),
        ),
      ),
      body: FutureBuilder(
        future: _feedbackFuture,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final feedbackData = snapshot.data!;
            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(25.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Wrap(
                      spacing: 20,
                      runSpacing: 20,
                      children: [
                        sortByDropdown(),
                        sortOrderDropdown(),
                        statusDropdown(),
                      ],
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    table(feedbackData.data),
                    const SizedBox(
                      height: 50,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        ElevatedButton(
                          onPressed: feedbackData.hasPreviousPage
                              ? previousPage
                              : null,
                          child: const Text("Previous page"),
                        ),
                        ElevatedButton(
                          onPressed: feedbackData.hasNextPage ? nextPage : null,
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

  nextPage() {
    setState(() {
      _currentPage++;
      _feedbackFuture = FeedbackService().getAllFeedback(
          page: _currentPage,
          sortBy: _selectedSortBy,
          sortDescending: _sortDescending,
          status: _selectedStatus);
    });
  }

  previousPage() {
    setState(() {
      _currentPage--;
      _feedbackFuture = FeedbackService().getAllFeedback(
          page: _currentPage,
          sortBy: _selectedSortBy,
          sortDescending: _sortDescending,
          status: _selectedStatus);
    });
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
                          if (feedback.feedbackStatus == "PENDING")
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
                          if (feedback.feedbackStatus != "COMPLETED")
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
              _feedbackFuture = FeedbackService().getAllFeedback(
                  page: _currentPage,
                  sortBy: _selectedSortBy,
                  sortDescending: _sortDescending,
                  status: _selectedStatus);
            }));
  }

  removeFeedback(int feedbackId) async {
    await FeedbackService()
        .removeFeedback(feedbackId)
        .then((value) => setState(() {
              _feedbackFuture = FeedbackService().getAllFeedback(
                  page: _currentPage,
                  sortBy: _selectedSortBy,
                  sortDescending: _sortDescending,
                  status: _selectedStatus);
            }));
  }

  DropdownMenu sortByDropdown() {
    return DropdownMenu<String>(
      label: const Text("Sort By"),
      controller: _sortByController,
      initialSelection: "Id",
      onSelected: (String? item) {
        if (item == _selectedSortBy) return;
        setState(() {
          _selectedSortBy = item!;
          _currentPage = 1;
          _feedbackFuture = FeedbackService().getAllFeedback(
              page: _currentPage,
              sortBy: _selectedSortBy,
              sortDescending: _sortDescending,
              status: _selectedStatus);
        });
      },
      dropdownMenuEntries: const <DropdownMenuEntry<String>>[
        DropdownMenuEntry(value: "id", label: "Id"),
        DropdownMenuEntry(value: "title", label: "Title"),
        DropdownMenuEntry(value: "date", label: "Date"),
        DropdownMenuEntry(value: "status", label: "Status"),
      ],
    );
  }

  DropdownMenu sortOrderDropdown() {
    return DropdownMenu<String>(
      controller: _sortOrderController,
      label: const Text("Sort Order"),
      onSelected: (String? status) {
        if (_sortDescending == true && status == "Descending") return;
        setState(() {
          _sortDescending = status == "Ascending" ? false : true;
          _currentPage = 1;
          _feedbackFuture = FeedbackService().getAllFeedback(
              page: _currentPage,
              sortBy: _selectedSortBy,
              sortDescending: _sortDescending,
              status: _selectedStatus);
        });
      },
      dropdownMenuEntries: const <DropdownMenuEntry<String>>[
        DropdownMenuEntry(value: "Ascending", label: "Ascending"),
        DropdownMenuEntry(value: "Descending", label: "Descending"),
      ],
    );
  }

  DropdownMenu statusDropdown() {
    return DropdownMenu<String>(
      controller: _statusController,
      initialSelection: "Any",
      label: const Text("Status"),
      onSelected: (String? status) {
        if (status == _selectedStatus) return;
        setState(() {
          _selectedStatus = status!;
          _currentPage = 1;
          _feedbackFuture = FeedbackService().getAllFeedback(
              page: _currentPage,
              sortBy: _selectedSortBy,
              sortDescending: _sortDescending,
              status: _selectedStatus);
        });
      },
      dropdownMenuEntries: const <DropdownMenuEntry<String>>[
        DropdownMenuEntry(value: "Any", label: "Any"),
        DropdownMenuEntry(value: "Pending", label: "Pending"),
        DropdownMenuEntry(value: "Saved", label: "Saved"),
        DropdownMenuEntry(value: "Completed", label: "Completed"),
      ],
    );
  }
}
