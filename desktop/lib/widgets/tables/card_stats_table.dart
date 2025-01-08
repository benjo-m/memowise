import 'dart:developer';
import 'package:desktop/dto/card_stats_response.dart';
import 'package:flutter/material.dart';

class CardStatsTable extends StatefulWidget {
  const CardStatsTable({
    super.key,
    required this.data,
  });

  final List<CardStatsResponse> data;

  @override
  State<CardStatsTable> createState() => _CardStatsTableState();
}

class _CardStatsTableState extends State<CardStatsTable> {
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
                    "Repetitions",
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              DataColumn(
                label: Expanded(
                  child: Text(
                    "Interval",
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              DataColumn(
                label: Expanded(
                  child: Text(
                    "Ease Factor",
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              DataColumn(
                label: Expanded(
                  child: Text(
                    "Due Date",
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              DataColumn(
                label: Expanded(
                  child: Text(
                    "Card ID",
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
            rows: widget.data.map((stats) {
              return DataRow(
                cells: <DataCell>[
                  DataCell(
                    Center(child: Text(stats.id.toString())),
                  ),
                  DataCell(
                    Center(child: Text(stats.repetitions.toString())),
                  ),
                  DataCell(
                    Center(child: Text(stats.interval.toString())),
                  ),
                  DataCell(
                    Center(child: Text(stats.easeFactor.toString())),
                  ),
                  DataCell(
                    Center(
                        child: Text(stats.dueDate.toString().substring(
                            0, stats.dueDate.toString().length - 7))),
                  ),
                  DataCell(
                    Center(child: Text(stats.cardId.toString())),
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
