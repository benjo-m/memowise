import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:mobile/dtos/deck_create_request.dart';
import 'package:mobile/services/deck_service.dart';

class DeckCreateView extends StatefulWidget {
  const DeckCreateView({super.key});

  @override
  State<DeckCreateView> createState() => _DeckCreateViewState();
}

class _DeckCreateViewState extends State<DeckCreateView> {
  final _cardFormKey = GlobalKey<FormState>();
  final _deckNameController = TextEditingController();
  final _questionController = TextEditingController();
  final _answerController = TextEditingController();
  final List<CardCreateRequest> _cards = [];

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
                  children: _cards
                      .map((card) => Container(
                            margin: const EdgeInsets.only(bottom: 10),
                            padding: const EdgeInsets.all(5),
                            decoration: BoxDecoration(
                              color: const Color.fromARGB(255, 160, 190, 243),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: GestureDetector(
                              onTap: () {
                                log("Edit ${card.question}");
                              },
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: Padding(
                                      padding:
                                          const EdgeInsets.only(right: 20.0),
                                      child: Text(
                                        card.question,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ),
                                  GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          _cards.remove(card);
                                        });
                                      },
                                      child: const Icon(Icons.delete)),
                                ],
                              ),
                            ),
                          ))
                      .toList(),
                ),
                const SizedBox(
                  height: 40,
                ),
                ElevatedButton(
                    onPressed: () {
                      showDialog(
                          context: context,
                          barrierDismissible: false,
                          builder: (context) => SimpleDialog(
                                insetPadding: EdgeInsets.all(10),
                                title: const Center(child: Text("Add Card")),
                                children: [
                                  Form(
                                    key: _cardFormKey,
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                          top: 10, left: 20, right: 20),
                                      child: Column(
                                        children: [
                                          TextFormField(
                                            controller: _questionController,
                                            minLines: 3,
                                            maxLines: 3,
                                            decoration: const InputDecoration(
                                              label: Text(
                                                "Question",
                                                style: TextStyle(
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              floatingLabelBehavior:
                                                  FloatingLabelBehavior.always,
                                              enabledBorder: OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.all(
                                                    Radius.circular(10),
                                                  ),
                                                  borderSide: BorderSide(
                                                    color: Colors.blue,
                                                    width: 2,
                                                  )),
                                              focusedBorder: OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.all(
                                                    Radius.circular(10),
                                                  ),
                                                  borderSide: BorderSide(
                                                    color: Colors.blue,
                                                    width: 2,
                                                  )),
                                            ),
                                            keyboardType:
                                                TextInputType.multiline,
                                          ),
                                          const SizedBox(
                                            height: 10,
                                          ),
                                          TextFormField(
                                            controller: _answerController,
                                            minLines: 3,
                                            maxLines: 3,
                                            decoration: const InputDecoration(
                                              label: Text(
                                                "Answer",
                                                style: TextStyle(
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              floatingLabelBehavior:
                                                  FloatingLabelBehavior.always,
                                              enabledBorder: OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.all(
                                                    Radius.circular(10),
                                                  ),
                                                  borderSide: BorderSide(
                                                    color: Colors.blue,
                                                    width: 2,
                                                  )),
                                              focusedBorder: OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.all(
                                                    Radius.circular(10),
                                                  ),
                                                  borderSide: BorderSide(
                                                    color: Colors.blue,
                                                    width: 2,
                                                  )),
                                            ),
                                          ),
                                          const SizedBox(
                                            height: 30,
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceEvenly,
                                            children: [
                                              ElevatedButton(
                                                  onPressed: () {
                                                    _cardFormKey.currentState!
                                                        .reset();
                                                    Navigator.pop(context);
                                                  },
                                                  child: const Text("Cancel")),
                                              ElevatedButton(
                                                  onPressed: () {
                                                    setState(() {
                                                      _cards.add(
                                                        CardCreateRequest(
                                                            question:
                                                                _questionController
                                                                    .text,
                                                            answer:
                                                                _answerController
                                                                    .text),
                                                      );
                                                    });

                                                    _cardFormKey.currentState!
                                                        .reset();

                                                    Navigator.pop(context);
                                                  },
                                                  child: const Text("Add")),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  )
                                ],
                              ));
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
}
