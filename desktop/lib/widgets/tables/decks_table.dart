import 'package:desktop/config/constants.dart';
import 'package:desktop/dto/deck_response.dart';
import 'package:desktop/services/deck_service.dart';
import 'package:desktop/styles.dart';
import 'package:desktop/widgets/dialogs/edit_deck_dialog.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class DecksTable extends StatefulWidget {
  const DecksTable({
    super.key,
    required this.data,
    required this.onEdit,
    required this.onDelete,
  });

  final List<DeckResponse> data;
  final Function() onEdit;
  final Function() onDelete;
  @override
  State<DecksTable> createState() => _DecksTableState();
}

class _DecksTableState extends State<DecksTable> {
  final _deckService = DeckService(baseUrl, http.Client());
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
                    "Name",
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
                    "Actions",
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ],
            rows: widget.data.map((deck) {
              return DataRow(
                cells: <DataCell>[
                  DataCell(
                    Center(child: Text(deck.id.toString())),
                  ),
                  DataCell(
                    Center(child: Text(deck.name)),
                  ),
                  DataCell(
                    Center(child: Text(deck.userId.toString())),
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
                            builder: (context) => EditDeckDialog(
                                deck: deck, onEdit: () => widget.onEdit()),
                          ),
                          child: const Text("Edit"),
                        ),
                        const SizedBox(width: 10),
                        TextButton(
                          style: redButtonStyle,
                          onPressed: () => showDeleteDialog(deck.id),
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
            title: const Center(child: Text("Delete Deck?")),
            children: [
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Center(
                  child: Text("Are you sure you want to delete this deck?"),
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
    await _deckService.delete(id);
    widget.onDelete();
  }
}
