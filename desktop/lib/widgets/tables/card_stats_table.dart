import 'package:desktop/config/constants.dart';
import 'package:desktop/dto/card_stats_response.dart';
import 'package:desktop/services/card_stats_service.dart';
import 'package:desktop/styles.dart';
import 'package:desktop/widgets/dialogs/edit_card_stats_dialog.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class CardStatsTable extends StatefulWidget {
  const CardStatsTable({
    super.key,
    required this.data,
    required this.onEdit,
    required this.onDelete,
  });
  final Function() onEdit;
  final Function() onDelete;

  final List<CardStatsResponse> data;

  @override
  State<CardStatsTable> createState() => _CardStatsTableState();
}

class _CardStatsTableState extends State<CardStatsTable> {
  final _cardStatService = CardStatsService(baseUrl, http.Client());
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
                        child: Text(stats.dueDate.toString().substring(0, 10))),
                  ),
                  DataCell(
                    Center(child: Text(stats.cardId.toString())),
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
                            builder: (context) => EditCardStatsDialog(
                              cardStats: stats,
                              onEdit: widget.onEdit,
                            ),
                          ),
                          child: const Text("Edit"),
                        ),
                        const SizedBox(width: 10),
                        TextButton(
                          style: redButtonStyle,
                          onPressed: () => showDeleteDialog(stats.id),
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
            title: const Center(child: Text("Delete Card Stats?")),
            children: [
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Center(
                  child: Text(
                    "Are you sure you want to delete this row?",
                  ),
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
    await _cardStatService.delete(id);
    widget.onDelete();
  }
}
