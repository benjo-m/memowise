import 'package:desktop/services/achievements_service.dart';
import 'package:desktop/services/deck_service.dart';
import 'package:desktop/services/login_record_service.dart';
import 'package:desktop/services/user_service.dart';
import 'package:desktop/widgets/achievements_table.dart';
import 'package:desktop/widgets/decks_table.dart';
import 'package:desktop/widgets/login_records_table.dart';
import 'package:flutter/material.dart';

class DataView extends StatefulWidget {
  const DataView({super.key});

  @override
  State<DataView> createState() => _DataViewState();
}

class _DataViewState extends State<DataView> {
  // Shared
  final List<String> _tables = ["Achievements", "Decks", "Login Records"];
  int _currentPage = 1;
  final _tableController = TextEditingController();
  String _selectedTable = "Achievements";
  final _sortByController = TextEditingController(text: "Id");
  String _selectedSortBy = "Id";
  final _sortOrderController = TextEditingController(text: "Ascending");
  bool _sortDescending = false;
  List<String> _sortByList = ["Id", "Name", "Description"];
  late List<int> _userIds;
  final _userIdController = TextEditingController(text: "Any");
  int? _userId;
  Future<void> _fetchUserIds() async {
    List<int> fetchedIds = await UserService().getUserIds();
    setState(() => _userIds = fetchedIds.map((id) => id).toList());
  }

  // Achievements Table
  final _achievementsSortByList = ["Id", "Name", "Description"];

  // Decks Table
  final _decksSortByList = ["Id", "Name", "User"];

  // Login Records Table
  final _loginRecordsSortByList = ["Id", "User", "Date"];

  // Futures
  var _achievementsFuture = AchievementService().getAllAchievements();
  var _decksFuture = DeckService().getAllDecks();
  var _loginRecordsFuture = LoginRecordService().getAllLoginRecords();
  late Future<dynamic> _currentFuture = _achievementsFuture;

  @override
  void initState() {
    super.initState();
    _fetchUserIds();
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
      body: Padding(
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
                if (<String>["Decks", "Login Records"].contains(_selectedTable))
                  userFilterDropdown(),
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
    );
  }

  table(dynamic data) {
    switch (_selectedTable) {
      case "Achievements":
        return AchievementsTable(data: data);
      case "Decks":
        return DecksTable(data: data);
      case "Login Records":
        return LoginRecordsTable(data: data);
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
          _userIdController.text = "Any";
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
          case "Login Records":
            setState(() {
              _loginRecordsFuture = LoginRecordService().getAllLoginRecords();
              _currentFuture = _loginRecordsFuture;
              _sortByList = _loginRecordsSortByList;
            });
            return;
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
      sortCurrentTable();
    });
  }

  previousPage() {
    setState(() {
      _currentPage--;
      sortCurrentTable();
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
          sortCurrentTable();
        });
      },
      dropdownMenuEntries: _sortByList
          .map((item) =>
              DropdownMenuEntry(value: item.toLowerCase(), label: item))
          .toList(),
    );
  }

  void sortCurrentTable() {
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
          sortCurrentTable();
        });
      },
      dropdownMenuEntries: const <DropdownMenuEntry<String>>[
        DropdownMenuEntry(value: "Ascending", label: "Ascending"),
        DropdownMenuEntry(value: "Descending", label: "Descending"),
      ],
    );
  }

  DropdownMenu userFilterDropdown() {
    return DropdownMenu<String>(
      controller: _userIdController,
      label: const Text("User"),
      onSelected: (String? userId) {
        setState(() {
          _currentPage = 1;
          _userId = userId == "-1" ? null : int.parse(userId!);
          sortCurrentTable();
        });
      },
      dropdownMenuEntries: <DropdownMenuEntry<String>>[
        const DropdownMenuEntry(value: "-1", label: "Any"),
        ..._userIds.map(
          (id) => DropdownMenuEntry(value: id.toString(), label: id.toString()),
        ),
      ],
    );
  }
}
