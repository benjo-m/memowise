import 'package:flutter/material.dart';
import 'package:mobile/styles.dart';

class CardListItem extends StatelessWidget {
  const CardListItem({
    super.key,
    required this.question,
    required this.onEdit,
    required this.onDelete,
    required this.answer,
  });

  final String question;
  final String answer;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onEdit(),
      child: Container(
        height: 80,
        margin: const EdgeInsets.only(bottom: 15),
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: primaryBackgroundColor,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            width: 3.0,
            color: primaryBorderColor,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(right: 20.0),
                child: RichText(
                  overflow: TextOverflow.ellipsis,
                  maxLines: 3,
                  text: TextSpan(
                    style: const TextStyle(
                      fontSize: 16.0,
                      color: Colors.black,
                    ),
                    children: <TextSpan>[
                      TextSpan(
                        text: "$question\n",
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      TextSpan(text: answer),
                    ],
                  ),
                ),
              ),
            ),
            GestureDetector(
              onTap: () => onDelete(),
              child: const Icon(
                Icons.remove_circle,
                color: Colors.red,
                size: 28,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
