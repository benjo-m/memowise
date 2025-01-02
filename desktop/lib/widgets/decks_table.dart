import 'dart:developer';
import 'package:desktop/dto/deck_response.dart';
import 'package:flutter/material.dart';

class DecksTable extends StatelessWidget {
  const DecksTable({
    super.key,
    required this.data,
  });

  final List<DeckResponse> data;

  @override
  Widget build(BuildContext context) {
    return DataTable(
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
              "Name",
              textAlign: TextAlign.center,
            ),
          ),
        ),
        DataColumn(
          label: Expanded(
            child: Text(
              "UserId",
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
      rows: data.map((deck) {
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
    );
  }
}
