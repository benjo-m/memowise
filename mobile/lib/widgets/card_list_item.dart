import 'package:flutter/material.dart';

class CardListItem extends StatelessWidget {
  const CardListItem({
    super.key,
    required this.question,
    required this.onEdit,
    required this.onDelete,
  });

  final String question;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(5),
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 160, 190, 243),
        borderRadius: BorderRadius.circular(10),
      ),
      child: GestureDetector(
        onTap: () => onEdit(),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(right: 20.0),
                child: Text(
                  question,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
            GestureDetector(
              onTap: () => onDelete(),
              child: const Icon(Icons.delete),
            ),
          ],
        ),
      ),
    );
  }
}
