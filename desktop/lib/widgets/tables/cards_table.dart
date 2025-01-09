import 'dart:developer';
import 'package:desktop/config/constants.dart';
import 'package:desktop/dto/card_response.dart';
import 'package:desktop/services/cards_service.dart';
import 'package:desktop/styles.dart';
import 'package:desktop/widgets/dialogs/card_edit_dialog.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class CardsTable extends StatefulWidget {
  const CardsTable({
    super.key,
    required this.data,
    required this.onEdit,
    required this.onDelete,
  });

  final List<CardResponse> data;
  final Function() onEdit;
  final Function() onDelete;
  @override
  State<CardsTable> createState() => _CardsTableState();
}

class _CardsTableState extends State<CardsTable> {
  final _cardService = CardService(baseUrl, http.Client());

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
                    "Question",
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              DataColumn(
                label: Expanded(
                  child: Text(
                    "Answer",
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              DataColumn(
                label: Expanded(
                  child: Text(
                    "Deck ID",
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
            rows: widget.data.map((card) {
              return DataRow(
                cells: <DataCell>[
                  DataCell(
                    Center(child: Text(card.id.toString())),
                  ),
                  DataCell(
                    Center(child: Text(card.question)),
                  ),
                  DataCell(
                    Center(child: Text(card.answer)),
                  ),
                  DataCell(
                    Center(child: Text(card.deckId.toString())),
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
                              builder: (context) => EditCardDialog(
                                  card: card, onEdit: () => widget.onEdit())),
                          child: const Text("Edit"),
                        ),
                        SizedBox(width: 10),
                        TextButton(
                          style: redButtonStyle,
                          onPressed: () => showDeleteDialog(card.id),
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
            title: const Center(child: Text("Delete Card?")),
            children: [
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Center(
                  child: Text("Are you sure you want to delete this card?"),
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
    await _cardService.delete(id);
    widget.onDelete();
  }
}
