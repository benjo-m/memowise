import 'dart:developer';

import 'package:desktop/dto/deck_response.dart';
import 'package:flutter/material.dart';

class DecksTable extends StatefulWidget {
  const DecksTable({
    super.key,
    required this.data,
  });

  final List<DeckResponse> data;

  @override
  State<DecksTable> createState() => _DecksTableState();
}

class _DecksTableState extends State<DecksTable> {
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
      ),
    );
  }
}
