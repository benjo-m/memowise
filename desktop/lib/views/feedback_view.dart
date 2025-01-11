import 'package:desktop/config/constants.dart';
import 'package:desktop/dto/feedback_response.dart';
import 'package:desktop/dto/feedback_status_update_request.dart';
import 'package:desktop/dto/paginated_response.dart';
import 'package:desktop/services/feedback_service.dart';
import 'package:desktop/styles.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class FeedbackView extends StatefulWidget {
  const FeedbackView({super.key});

  @override
  State<FeedbackView> createState() => _FeedbackViewState();
}

class _FeedbackViewState extends State<FeedbackView> {
  int _currentPage = 1;

  final _feedbackService = FeedbackService(baseUrl, http.Client());

  late Future<PaginatedResponse<FeedbackResponse>> _feedbackFuture;

  final _statusController = TextEditingController(text: "Any");
  final _accountTypeController = TextEditingController(text: "Any");
  final _sortByController = TextEditingController(text: "Date");
  final _sortOrderController = TextEditingController(text: "Ascending");

  String _selectedStatus = "Any";
  String _selectedSortBy = "Id";
  bool _sortDescending = false;
  String _selectedAccountType = "Any";

  @override
  void initState() {
    super.initState();
    _feedbackFuture = _feedbackService.getAll();
  }

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
                        accountTypeDropdown(),
                      ],
                    ),
                    const SizedBox(height: 20),
                    table(feedbackData.data),
                    const SizedBox(height: 20),
                    navigationButtonsRow(feedbackData),
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

  Row navigationButtonsRow(PaginatedResponse<FeedbackResponse> feedbackData) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(
          tooltip: "Previous Page",
          onPressed: feedbackData.hasPreviousPage ? previousPage : null,
          icon: const Icon(Icons.navigate_before_rounded),
          iconSize: 30,
        ),
        const SizedBox(
          width: 100,
        ),
        IconButton(
          tooltip: "Next Page",
          onPressed: feedbackData.hasNextPage ? nextPage : null,
          icon: const Icon(Icons.navigate_next_rounded),
          iconSize: 30,
        ),
      ],
    );
  }

  nextPage() {
    setState(() {
      _currentPage++;
      _feedbackFuture = _feedbackService.getAll(
        page: _currentPage,
        sortBy: _selectedSortBy,
        sortDescending: _sortDescending,
        status: _selectedStatus,
        accountType: _selectedAccountType,
      );
    });
  }

  previousPage() {
    setState(() {
      _currentPage--;
      _feedbackFuture = _feedbackService.getAll(
        page: _currentPage,
        sortBy: _selectedSortBy,
        sortDescending: _sortDescending,
        status: _selectedStatus,
        accountType: _selectedAccountType,
      );
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
          color: feedback.isPremiumUser
              ? const WidgetStatePropertyAll(Color.fromARGB(255, 255, 242, 120))
              : const WidgetStatePropertyAll(Colors.white),
          cells: <DataCell>[
            DataCell(
              Center(child: Text(feedback.title)),
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
                  TextButton(
                    style: blueButtonStyle,
                    onPressed: () =>
                        feedbackDetailsDialog(context, feedback.id),
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

  feedbackDetailsDialog(BuildContext context, int id) async {
    final feedback = await _feedbackService.getFeedbackById(id);
    if (context.mounted) {
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
                            TextButton(
                              style: redButtonStyle,
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
                              TextButton(
                                style: blueButtonStyle,
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
                              TextButton(
                                style: greenButtonStyle,
                                onPressed: () {
                                  updateFeedbackStatus(
                                      feedback.id, "COMPLETED");
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
  }

  updateFeedbackStatus(int feedbackId, String status) async {
    final req = FeedbackStatusUpdateRequest(status: status);
    await _feedbackService
        .updateFeedbackStatus(feedbackId, req)
        .then((value) => setState(() {
              _feedbackFuture = _feedbackService.getAll(
                page: _currentPage,
                sortBy: _selectedSortBy,
                sortDescending: _sortDescending,
                status: _selectedStatus,
                accountType: _selectedAccountType,
              );
            }));
  }

  removeFeedback(int feedbackId) async {
    await _feedbackService
        .removeFeedback(feedbackId)
        .then((value) => setState(() {
              _feedbackFuture = _feedbackService.getAll(
                page: _currentPage,
                sortBy: _selectedSortBy,
                sortDescending: _sortDescending,
                status: _selectedStatus,
                accountType: _selectedAccountType,
              );
            }));
  }

  DropdownMenu sortByDropdown() {
    return DropdownMenu<String>(
      label: const Text("Sort By"),
      controller: _sortByController,
      initialSelection: "Date",
      onSelected: (String? item) {
        if (item == _selectedSortBy) return;
        setState(() {
          _selectedSortBy = item!;
          _currentPage = 1;
          _feedbackFuture = _feedbackService.getAll(
            page: _currentPage,
            sortBy: _selectedSortBy,
            sortDescending: _sortDescending,
            status: _selectedStatus,
            accountType: _selectedAccountType,
          );
        });
      },
      dropdownMenuEntries: const <DropdownMenuEntry<String>>[
        DropdownMenuEntry(value: "date", label: "Date"),
        DropdownMenuEntry(value: "status", label: "Status"),
        DropdownMenuEntry(value: "title", label: "Title"),
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
          _feedbackFuture = _feedbackService.getAll(
            page: _currentPage,
            sortBy: _selectedSortBy,
            sortDescending: _sortDescending,
            status: _selectedStatus,
            accountType: _selectedAccountType,
          );
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
          _feedbackFuture = _feedbackService.getAll(
            page: _currentPage,
            sortBy: _selectedSortBy,
            sortDescending: _sortDescending,
            status: _selectedStatus,
            accountType: _accountTypeController.text,
          );
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

  DropdownMenu accountTypeDropdown() {
    return DropdownMenu<String>(
      controller: _accountTypeController,
      initialSelection: "Any",
      label: const Text("Account Type"),
      onSelected: (String? accountType) {
        if (accountType == _selectedAccountType) return;
        setState(() {
          _selectedAccountType = accountType!;
          _currentPage = 1;
          _feedbackFuture = _feedbackService.getAll(
            page: _currentPage,
            sortBy: _selectedSortBy,
            sortDescending: _sortDescending,
            status: _selectedStatus,
            accountType: _selectedAccountType,
          );
        });
      },
      dropdownMenuEntries: const <DropdownMenuEntry<String>>[
        DropdownMenuEntry(value: "Any", label: "Any"),
        DropdownMenuEntry(value: "free", label: "Free"),
        DropdownMenuEntry(value: "premium", label: "Premium"),
      ],
    );
  }
}
