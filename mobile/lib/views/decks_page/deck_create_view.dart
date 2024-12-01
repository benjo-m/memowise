import 'package:flutter/material.dart';
import 'package:mobile/dtos/card_dto.dart';
import 'package:mobile/dtos/deck_create_request.dart';
import 'package:mobile/services/deck_service.dart';
import 'package:mobile/widgets/add_card_dialog.dart';
import 'package:mobile/widgets/card_list_item.dart';
import 'package:mobile/widgets/edit_card_dialog.dart';

class DeckCreateView extends StatefulWidget {
  const DeckCreateView({super.key});

  @override
  State<DeckCreateView> createState() => _DeckCreateViewState();
}

class _DeckCreateViewState extends State<DeckCreateView> {
  final _deckNameController = TextEditingController();
  final List<CardDto> _cards = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Create deck"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(30.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              children: [
                TextFormField(
                  controller: _deckNameController,
                  decoration: const InputDecoration(
                    label: Text("Deck name"),
                  ),
                ),
                const SizedBox(
                  height: 40,
                ),
                Column(
                  children: cardListItems(),
                ),
                const SizedBox(
                  height: 40,
                ),
                ElevatedButton(
                    onPressed: () {
                      showAddCardDialog(context);
                    },
                    child: const Text("Add Card"))
              ],
            ),
            ElevatedButton(
                onPressed: () async {
                  await DeckService().createDeck(DeckCreateRequest(
                      name: _deckNameController.text, cards: _cards));
                  if (context.mounted) {
                    Navigator.pop(context);
                  }
                },
                child: const Text("Create"))
          ],
        ),
      ),
    );
  }

  List<Widget> cardListItems() {
    List<Widget> cards = [];

    for (var i = 0; i < _cards.length; i++) {
      cards.add(CardListItem(
        question: _cards[i].question,
        onEdit: () => showEditCardDialog(context, i),
        onDelete: () => setState(() => _cards.removeAt(i)),
      ));
    }

    return cards;
  }

  void showAddCardDialog(BuildContext context) {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => AddCardDialog(
              onAdd: (CardDto cardDto) {
                setState(() => _cards.add(cardDto));
                Navigator.pop(context);
              },
              onCancel: () => Navigator.pop(context),
            ));
  }

  void showEditCardDialog(BuildContext context, int cardIndex) {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) => EditCardDialog(
            question: _cards[cardIndex].question,
            answer: _cards[cardIndex].answer,
            onCancel: () => Navigator.pop(context),
            onEdit: (CardDto cardDto) {
              setState(() {
                _cards[cardIndex] = cardDto;
                Navigator.pop(context);
              });
            }));
  }
}
