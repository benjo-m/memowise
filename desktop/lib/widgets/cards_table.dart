import 'dart:developer';
import 'package:desktop/dto/card_response.dart';
import 'package:flutter/material.dart';

class CardsTable extends StatefulWidget {
  const CardsTable({
    super.key,
    required this.data,
  });

  final List<CardResponse> data;

  @override
  State<CardsTable> createState() => _CardsTableState();
}

class _CardsTableState extends State<CardsTable> {
  final _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return Scrollbar(
      controller: _scrollController,
      thumbVisibility: true,
      child: SingleChildScrollView(
        controller: _scrollController,
        scrollDirection: Axis.horizontal,
        child: DataTable(
          showBottomBorder: true,
          headingRowColor:
              const WidgetStatePropertyAll(Color.fromARGB(255, 226, 246, 255)),
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
    );
  }
}
