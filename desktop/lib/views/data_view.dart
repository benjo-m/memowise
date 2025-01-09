import 'dart:developer';

import 'package:desktop/config/constants.dart';
import 'package:desktop/dto/achievement_response.dart';
import 'package:desktop/dto/card_response.dart';
import 'package:desktop/dto/card_stats_response.dart';
import 'package:desktop/dto/deck_response.dart';
import 'package:desktop/dto/feedback_response.dart';
import 'package:desktop/dto/login_record_response.dart';
import 'package:desktop/dto/paginated_response.dart';
import 'package:desktop/dto/payment_record_response.dart';
import 'package:desktop/dto/study_session_response.dart';
import 'package:desktop/dto/user_response.dart';
import 'package:desktop/dto/user_stats_response.dart';
import 'package:desktop/services/achievements_service.dart';
import 'package:desktop/services/card_stats_service.dart';
import 'package:desktop/services/cards_service.dart';
import 'package:desktop/services/deck_service.dart';
import 'package:desktop/services/feedback_service.dart';
import 'package:desktop/services/login_record_service.dart';
import 'package:desktop/services/payment_record_service.dart';
import 'package:desktop/services/study_session_service.dart';
import 'package:desktop/services/user_service.dart';
import 'package:desktop/services/user_stats_service.dart';
import 'package:desktop/widgets/add_achievement_dialog.dart';
import 'package:desktop/widgets/tables/achievements_table.dart';
import 'package:desktop/widgets/tables/card_stats_table.dart';
import 'package:desktop/widgets/tables/cards_table.dart';
import 'package:desktop/widgets/tables/decks_table.dart';
import 'package:desktop/widgets/tables/feedback_table.dart';
import 'package:desktop/widgets/tables/login_records_table.dart';
import 'package:desktop/widgets/tables/payment_records_table.dart';
import 'package:desktop/widgets/tables/study_sessions_table.dart';
import 'package:desktop/widgets/tables/user_stats_table.dart';
import 'package:desktop/widgets/tables/users_table.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class DataView extends StatefulWidget {
  const DataView({super.key});

  @override
  State<DataView> createState() => _DataViewState();
}

class _DataViewState extends State<DataView> {
  // Shared
  final List<String> _tables = [
    "Achievements",
    "Cards",
    "Card Stats",
    "Decks",
    "Feedback",
    "Login Records",
    "Payment Records",
    "Study Sessions",
    "Users",
    "User Stats",
  ];
  int _currentPage = 1;
  final _tableController = TextEditingController();
  String _selectedTable = "Achievements";
  final _sortByController = TextEditingController(text: "Id");
  String _selectedSortBy = "Id";
  final _sortOrderController = TextEditingController(text: "Ascending");
  bool _sortDescending = false;
  List<String> _sortByList = ["Id", "Name", "Description"];

  final _userIdController = TextEditingController();
  int? _userId;

  final _deckIdController = TextEditingController();
  int? _deckId;

  // Achievements Table
  final _achievementsSortByList = ["Id", "Name", "Description"];

  // Decks Table
  final _decksSortByList = ["Id", "Name", "User"];

  // Cards Table
  final _cardsSortByList = ["Id", "Question", "Answer", "Deck"];

  // Login Records Table
  final _loginRecordsSortByList = ["Id", "User", "Date"];

  // Login Records Table
  final _paymentRecordsSortByList = [
    "Id",
    "Payment Intent",
    "User",
    "Amount",
    "Currency",
    "Date"
  ];

  // Study Sessions Table
  final _studySessionsSortByList = [
    "Id",
    "Duration",
    "Card Count",
    "AVG Ease Factor",
    "AVG Repetitions",
    "User",
    "Deck",
  ];

  // Users Table
  final _usersSortByList = [
    "Id",
    "Username",
    "Email",
    "Account Type",
    "Role",
    "Date"
  ];
  final _accountTypeController = TextEditingController(text: "Any");
  String _accountType = "Any";
  final _roleController = TextEditingController(text: "Any");
  String _role = "Any";

  // Feedback Table
  final _statusController = TextEditingController(text: "Any");
  String _selectedStatus = "Any";
  final _feedbackSortByList = [
    "Id",
    "Title",
    "Date",
    "Status",
  ];

  // User Stats Table
  final _userStatsSortByList = [
    "Id",
    "User",
    "Total Decks Created",
    "Total Cards Created",
    "Total Cards Learned",
    "Study Streak",
    "Total Sessions Completed",
    "Total Correct Answers",
    "Total Decks Generated",
    "Longest Study Streak"
  ];

  // Card Stats Table
  final _cardIdController = TextEditingController(text: "Any");
  int? _cardId;
  final _cardStatsSortByList = [
    "Id",
    "Repetitions",
    "Interval",
    "Ease Factor",
    "Due Date",
    "Card",
  ];

  final _userService = UserService(baseUrl, http.Client());
  final _achievementService = AchievementService(baseUrl, http.Client());
  final _decksService = DeckService(baseUrl, http.Client());
  final _cardService = CardService(baseUrl, http.Client());
  final _cardStatsService = CardStatsService(baseUrl, http.Client());
  final _loginRecordService = LoginRecordService(baseUrl, http.Client());
  final _paymnetRecordService = PaymentRecordService(baseUrl, http.Client());
  final _studySessionService = StudySessionService(baseUrl, http.Client());
  final _feedbackService = FeedbackService(baseUrl, http.Client());
  final _userStatsService = UserStatsService(baseUrl, http.Client());

  late Future<PaginatedResponse<AchievementResponse>> _achievementsFuture;
  late Future<PaginatedResponse<DeckResponse>> _decksFuture;
  late Future<PaginatedResponse<CardResponse>> _cardsFuture;
  late Future<PaginatedResponse<UserResponse>> _usersFuture;
  late Future<PaginatedResponse<LoginRecordResponse>> _loginRecordsFuture;
  late Future<PaginatedResponse<PaymentRecordResponse>> _paymentRecordsFuture;
  late Future<PaginatedResponse<StudySessionResponse>> _studySessionsFuture;
  late Future<PaginatedResponse<FeedbackResponse>> _feedbackFuture;
  late Future<PaginatedResponse<CardStatsResponse>> _cardStatsFuture;
  late Future<PaginatedResponse<UserStatsResponse>> _userStatsFuture;

  late Future<dynamic> _currentFuture = _achievementsFuture;

  @override
  void initState() {
    super.initState();
    _achievementsFuture = _achievementService.getAll();
    _decksFuture = _decksService.getAll();
    _cardsFuture = _cardService.getAll();
    _cardStatsFuture = _cardStatsService.getAll();
    _loginRecordsFuture = _loginRecordService.getAll();
    _paymentRecordsFuture = _paymnetRecordService.getAll();
    _studySessionsFuture = _studySessionService.getAll();
    _feedbackFuture = _feedbackService.getAll();
    _usersFuture = _userService.getAll();
    _userStatsFuture = _userStatsService.getAll();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Padding(
          padding: EdgeInsets.only(left: 10),
          child: Text("Data"),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(25.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Wrap(
                crossAxisAlignment: WrapCrossAlignment.center,
                spacing: 20,
                runSpacing: 20,
                children: [
                  tableDropdown(),
                  sortByDropdown(),
                  sortOrderDropdown(),
                  if (<String>[
                    "Decks",
                    "Login Records",
                    "Payment Records",
                    "Study Sessions",
                    "User Stats"
                  ].contains(_selectedTable))
                    userSearchTextField(),
                  if (<String>["Cards", "Study Sessions"]
                      .contains(_selectedTable))
                    deckSearchTextField(),
                  if (_selectedTable == "Feedback") feedbackStatusDropdown(),
                  if (_selectedTable == "Card Stats") cardSearchTextField(),
                  if (_selectedTable == "Users") roleDropdownMenu(),
                  if (_selectedTable == "Users") accountTypeDropdownMenu(),
                  TextButton(
                    style: const ButtonStyle(
                      backgroundColor:
                          WidgetStatePropertyAll(Colors.greenAccent),
                      foregroundColor: WidgetStatePropertyAll(Colors.white),
                      fixedSize: WidgetStatePropertyAll(
                        Size(140, 43),
                      ),
                    ),
                    onPressed: () async {
                      if (_selectedTable == "Achievements" && context.mounted) {
                        showDialog(
                          context: context,
                          builder: (context) => AddAchievementDialog(
                            onAdd: (response) {
                              if (response != null) {
                                refreshTable();
                              }
                            },
                          ),
                        );
                      } else if (_selectedTable == "Users") {
                        log("users");
                      }
                    },
                    child: const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.add_circle_outline),
                          SizedBox(width: 5),
                          Text("Add Row"),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              FutureBuilder(
                key: ValueKey(_currentFuture),
                future: _currentFuture,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    final data = snapshot.data!;
                    return SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          const SizedBox(height: 20),
                          table(data.data),
                          const SizedBox(height: 20),
                          navigationButtonsRow(data),
                        ],
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
            ],
          ),
        ),
      ),
    );
  }

  Row navigationButtonsRow(data) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(
          tooltip: "Previous Page",
          onPressed: data.hasPreviousPage ? previousPage : null,
          icon: const Icon(Icons.navigate_before_rounded),
          iconSize: 30,
        ),
        const SizedBox(
          width: 100,
        ),
        IconButton(
          tooltip: "Next Page",
          onPressed: data.hasNextPage ? nextPage : null,
          icon: const Icon(Icons.navigate_next_rounded),
          iconSize: 30,
        ),
      ],
    );
  }

  table(dynamic data) {
    switch (_selectedTable) {
      case "Achievements":
        return AchievementsTable(
          data: data,
          onEdit: () => refreshTable(),
          onDelete: () => refreshTable(),
        );
      case "Decks":
        return DecksTable(data: data);
      case "Cards":
        return CardsTable(data: data);
      case "Login Records":
        return LoginRecordsTable(data: data);
      case "Payment Records":
        return PaymentRecordsTable(data: data);
      case "Study Sessions":
        return StudySessionsTable(data: data);
      case "Users":
        return UsersTable(data: data);
      case "Feedback":
        return FeedbackTable(data: data);
      case "User Stats":
        return UserStatsTable(data: data);
      case "Card Stats":
        return CardStatsTable(data: data);
    }
  }

  DropdownMenu tableDropdown() {
    return DropdownMenu<String>(
      label: const Text("Table"),
      controller: _tableController,
      initialSelection: "Achievements",
      onSelected: (String? item) {
        if (item == _selectedTable) return;
        setState(() {
          _selectedTable = item!;
          _currentPage = 1;
          _sortByController.text = "Id";
          _selectedSortBy = "Id";
          _sortOrderController.text = "Ascending";
          _sortDescending = false;
          _userIdController.text = "";
          _userId = null;
          _deckIdController.text = "";
          _deckId = null;
          _cardIdController.text = "";
          _cardId = null;
          _selectedStatus = "Any";
          _roleController.text = "";
          _role = "Any";
          _accountTypeController.text = "";
          _accountType = "Any";
        });
        refreshTable();
      },
      dropdownMenuEntries: _tables
          .map((table) => DropdownMenuEntry(value: table, label: table))
          .toList(),
    );
  }

  nextPage() {
    setState(() {
      _currentPage++;
      refreshTable();
    });
  }

  previousPage() {
    setState(() {
      _currentPage--;
      refreshTable();
    });
  }

  DropdownMenu sortByDropdown() {
    return DropdownMenu<String>(
      label: const Text("Sort By"),
      controller: _sortByController,
      onSelected: (String? item) {
        if (item == _selectedSortBy) return;
        setState(() {
          _selectedSortBy = item!;
          _currentPage = 1;
          refreshTable();
        });
      },
      dropdownMenuEntries: _sortByList.map((item) {
        List<String> words = item.split(' ');
        String formattedValue = words.asMap().entries.map((entry) {
          int index = entry.key;
          String word = entry.value;
          return index == 0
              ? word.toLowerCase()
              : '${word[0].toUpperCase()}${word.substring(1).toLowerCase()}';
        }).join('');
        return DropdownMenuEntry(value: formattedValue, label: item);
      }).toList(),
    );
  }

  void refreshTable() {
    switch (_selectedTable) {
      case "Achievements":
        setState(() {
          _achievementsFuture = _achievementService.getAll(
            page: _currentPage,
            sortBy: _selectedSortBy,
            sortDescending: _sortDescending,
          );
          _currentFuture = _achievementsFuture;
          _sortByList = _achievementsSortByList;
        });
        break;
      case "Decks":
        setState(() {
          _decksFuture = _decksService.getAll(
            page: _currentPage,
            sortBy: _selectedSortBy,
            sortDescending: _sortDescending,
            user: _userId,
          );
          _currentFuture = _decksFuture;
          _sortByList = _decksSortByList;
        });
        break;
      case "Cards":
        setState(() {
          _cardsFuture = _cardService.getAll(
            page: _currentPage,
            sortBy: _selectedSortBy,
            sortDescending: _sortDescending,
            deck: _deckId,
          );
          _currentFuture = _cardsFuture;
          _sortByList = _cardsSortByList;
        });
        break;
      case "Login Records":
        setState(() {
          _loginRecordsFuture = _loginRecordService.getAll(
            page: _currentPage,
            sortBy: _selectedSortBy,
            sortDescending: _sortDescending,
            user: _userId,
          );
          _currentFuture = _loginRecordsFuture;
          _sortByList = _loginRecordsSortByList;
        });
        break;
      case "Payment Records":
        setState(() {
          _paymentRecordsFuture = _paymnetRecordService.getAll(
            page: _currentPage,
            sortBy: _selectedSortBy,
            sortDescending: _sortDescending,
            user: _userId,
          );
          _currentFuture = _paymentRecordsFuture;
          _sortByList = _paymentRecordsSortByList;
        });
        break;
      case "Study Sessions":
        setState(() {
          _studySessionsFuture = _studySessionService.getAll(
            page: _currentPage,
            sortBy: _selectedSortBy,
            sortDescending: _sortDescending,
            user: _userId,
            deck: _deckId,
          );
          _currentFuture = _studySessionsFuture;
          _sortByList = _studySessionsSortByList;
        });
        break;
      case "Users":
        setState(() {
          _usersFuture = _userService.getAll(
            page: _currentPage,
            sortBy: _selectedSortBy,
            sortDescending: _sortDescending,
            accountType: _accountType,
            role: _role,
          );
          _currentFuture = _usersFuture;
          _sortByList = _usersSortByList;
        });
      case "Feedback":
        setState(() {
          _feedbackFuture = _feedbackService.getAll(
            page: _currentPage,
            sortBy: _selectedSortBy,
            sortDescending: _sortDescending,
            status: _selectedStatus,
          );
          _currentFuture = _feedbackFuture;
          _sortByList = _feedbackSortByList;
        });
      case "User Stats":
        setState(() {
          _userStatsFuture = _userStatsService.getAll(
            page: _currentPage,
            sortBy: _selectedSortBy,
            sortDescending: _sortDescending,
            user: _userId,
          );
          _currentFuture = _userStatsFuture;
          _sortByList = _userStatsSortByList;
        });
      case "Card Stats":
        setState(() {
          _cardStatsFuture = _cardStatsService.getAll(
            page: _currentPage,
            sortBy: _selectedSortBy,
            sortDescending: _sortDescending,
            card: _cardId,
          );
          _currentFuture = _cardStatsFuture;
          _sortByList = _cardStatsSortByList;
        });
    }
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
          refreshTable();
        });
      },
      dropdownMenuEntries: const <DropdownMenuEntry<String>>[
        DropdownMenuEntry(value: "Ascending", label: "Ascending"),
        DropdownMenuEntry(value: "Descending", label: "Descending"),
      ],
    );
  }

  ConstrainedBox userSearchTextField() {
    return ConstrainedBox(
      constraints: const BoxConstraints(minWidth: 100),
      child: IntrinsicWidth(
        child: TextField(
          controller: _userIdController,
          decoration: const InputDecoration(
            label: Text("User ID"),
            floatingLabelBehavior: FloatingLabelBehavior.always,
            border: OutlineInputBorder(),
            hintText: "Any",
            hintStyle:
                TextStyle(color: Colors.black, fontWeight: FontWeight.normal),
          ),
          keyboardType: TextInputType.number,
          onChanged: (value) {
            setState(() {
              _currentPage = 1;
              _userId = value.isEmpty ? null : int.tryParse(value);
              refreshTable();
            });
          },
        ),
      ),
    );
  }

  ConstrainedBox deckSearchTextField() {
    return ConstrainedBox(
      constraints: const BoxConstraints(minWidth: 100),
      child: IntrinsicWidth(
        child: TextField(
          controller: _deckIdController,
          decoration: const InputDecoration(
            label: Text("Deck ID"),
            floatingLabelBehavior: FloatingLabelBehavior.always,
            border: OutlineInputBorder(),
            hintText: "Any",
            hintStyle:
                TextStyle(color: Colors.black, fontWeight: FontWeight.normal),
          ),
          keyboardType: TextInputType.number,
          onChanged: (value) {
            setState(() {
              _currentPage = 1;
              _deckId = value.isEmpty ? null : int.tryParse(value);
              refreshTable();
            });
          },
        ),
      ),
    );
  }

  ConstrainedBox cardSearchTextField() {
    return ConstrainedBox(
      constraints: const BoxConstraints(minWidth: 100),
      child: IntrinsicWidth(
        child: TextField(
          controller: _cardIdController,
          decoration: const InputDecoration(
            label: Text("Card ID"),
            floatingLabelBehavior: FloatingLabelBehavior.always,
            border: OutlineInputBorder(),
            hintText: "Any",
            hintStyle:
                TextStyle(color: Colors.black, fontWeight: FontWeight.normal),
          ),
          keyboardType: TextInputType.number,
          onChanged: (value) {
            setState(() {
              _currentPage = 1;
              _cardId = value.isEmpty ? null : int.tryParse(value);
              refreshTable();
            });
          },
        ),
      ),
    );
  }

  DropdownMenu feedbackStatusDropdown() {
    return DropdownMenu<String>(
      controller: _statusController,
      initialSelection: "Any",
      label: const Text("Status"),
      onSelected: (String? status) {
        if (status == _selectedStatus) return;
        setState(() {
          _selectedStatus = status!;
          _currentPage = 1;
          refreshTable();
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

  DropdownMenu roleDropdownMenu() {
    return DropdownMenu<String>(
      controller: _roleController,
      initialSelection: "Any",
      label: const Text("Role"),
      onSelected: (String? role) {
        if (role == _role) return;
        setState(() {
          _role = role!;
          _currentPage = 1;
          refreshTable();
        });
      },
      dropdownMenuEntries: const <DropdownMenuEntry<String>>[
        DropdownMenuEntry(value: "Any", label: "Any"),
        DropdownMenuEntry(value: "user", label: "User"),
        DropdownMenuEntry(value: "admin", label: "Admin"),
      ],
    );
  }

  DropdownMenu accountTypeDropdownMenu() {
    return DropdownMenu<String>(
      controller: _accountTypeController,
      initialSelection: "Any",
      label: const Text("Account Type"),
      onSelected: (String? accType) {
        if (accType == _accountType) return;
        setState(() {
          _accountType = accType!;
          _currentPage = 1;
          refreshTable();
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
