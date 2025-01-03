import 'dart:developer';

import 'package:desktop/services/achievements_service.dart';
import 'package:desktop/services/cards_service.dart';
import 'package:desktop/services/deck_service.dart';
import 'package:desktop/services/login_record_service.dart';
import 'package:desktop/services/payment_record_service.dart';
import 'package:desktop/services/study_session_service.dart';
import 'package:desktop/services/user_service.dart';
import 'package:desktop/widgets/achievements_table.dart';
import 'package:desktop/widgets/cards_table.dart';
import 'package:desktop/widgets/decks_table.dart';
import 'package:desktop/widgets/login_records_table.dart';
import 'package:desktop/widgets/payment_records_table.dart';
import 'package:desktop/widgets/study_sessions_table.dart';
import 'package:flutter/material.dart';

class DataView extends StatefulWidget {
  const DataView({super.key});

  @override
  State<DataView> createState() => _DataViewState();
}

class _DataViewState extends State<DataView> {
  // Shared
  final List<String> _tables = [
    "Achievements",
    "Decks",
    "Cards",
    "Study Sessions",
    "Login Records",
    "Payment Records",
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
  final _cardsSortBy = ["Id", "Question", "Answer", "Deck"];

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
    "CR1",
    "CR2",
    "CR3",
    "CR4",
    "CR5",
  ];

  // Futures
  var _achievementsFuture = AchievementService().getAllAchievements();
  var _decksFuture = DeckService().getAllDecks();
  var _cardsFuture = CardService().getAllCards();
  var _loginRecordsFuture = LoginRecordService().getAllLoginRecords();
  var _paymentRecordsFuture = PaymentRecordService().getAllPaymentRecords();
  var _studySessionsFuture = StudySessionService().getAllStudySessions();
  late Future<dynamic> _currentFuture = _achievementsFuture;

  @override
  void initState() {
    super.initState();
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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Wrap(
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
                    "Study Sessions"
                  ].contains(_selectedTable))
                    userSearchTextField(),
                  if (<String>["Cards", "Study Sessions"]
                      .contains(_selectedTable))
                    deckSearchTextField(),
                ],
              ),
              FutureBuilder(
                // key: ValueKey(_currentFuture),
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
                          const SizedBox(height: 50),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              ElevatedButton(
                                onPressed:
                                    data.hasPreviousPage ? previousPage : null,
                                child: const Text("Previous page"),
                              ),
                              ElevatedButton(
                                onPressed: data.hasNextPage ? nextPage : null,
                                child: const Text("Next page"),
                              ),
                            ],
                          ),
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

  table(dynamic data) {
    switch (_selectedTable) {
      case "Achievements":
        return AchievementsTable(data: data);
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
          _userId = null;
          _deckId = null;
        });

        switch (item) {
          case "Achievements":
            setState(() {
              _achievementsFuture = AchievementService().getAllAchievements();
              _currentFuture = _achievementsFuture;
              _sortByList = _achievementsSortByList;
            });
            return;
          case "Decks":
            setState(() {
              _decksFuture = DeckService().getAllDecks();
              _currentFuture = _decksFuture;
              _sortByList = _decksSortByList;
            });
            return;
          case "Cards":
            setState(() {
              _cardsFuture = CardService().getAllCards();
              _currentFuture = _cardsFuture;
              _sortByList = _cardsSortBy;
            });
            return;
          case "Login Records":
            setState(() {
              _loginRecordsFuture = LoginRecordService().getAllLoginRecords();
              _currentFuture = _loginRecordsFuture;
              _sortByList = _loginRecordsSortByList;
            });
            return;
          case "Payment Records":
            setState(() {
              _paymentRecordsFuture =
                  PaymentRecordService().getAllPaymentRecords();
              _currentFuture = _paymentRecordsFuture;
              _sortByList = _paymentRecordsSortByList;
            });
            return;
          case "Study Sessions":
            setState(() {
              _studySessionsFuture =
                  StudySessionService().getAllStudySessions();
              _currentFuture = _studySessionsFuture;
              _sortByList = _studySessionsSortByList;
            });
        }
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
        log(item!);
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
          _achievementsFuture = AchievementService().getAllAchievements(
            page: _currentPage,
            sortBy: _selectedSortBy,
            sortDescending: _sortDescending,
          );
          _currentFuture = _achievementsFuture;
        });
        break;
      case "Decks":
        setState(() {
          _decksFuture = DeckService().getAllDecks(
            page: _currentPage,
            sortBy: _selectedSortBy,
            sortDescending: _sortDescending,
            user: _userId,
          );
          _currentFuture = _decksFuture;
        });
        break;
      case "Cards":
        setState(() {
          _cardsFuture = CardService().getAllCards(
            page: _currentPage,
            sortBy: _selectedSortBy,
            sortDescending: _sortDescending,
            deck: _deckId,
          );
          _currentFuture = _cardsFuture;
        });
        break;
      case "Login Records":
        setState(() {
          _loginRecordsFuture = LoginRecordService().getAllLoginRecords(
            page: _currentPage,
            sortBy: _selectedSortBy,
            sortDescending: _sortDescending,
            user: _userId,
          );
          _currentFuture = _loginRecordsFuture;
        });
        break;
      case "Payment Records":
        setState(() {
          _paymentRecordsFuture = PaymentRecordService().getAllPaymentRecords(
            page: _currentPage,
            sortBy: _selectedSortBy,
            sortDescending: _sortDescending,
            user: _userId,
          );
          _currentFuture = _paymentRecordsFuture;
        });
        break;
      case "Study Sessions":
        setState(() {
          _studySessionsFuture = StudySessionService().getAllStudySessions(
            page: _currentPage,
            sortBy: _selectedSortBy,
            sortDescending: _sortDescending,
            user: _userId,
            deck: _deckId,
          );
          _currentFuture = _studySessionsFuture;
        });
        break;
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
}
