import 'package:flutter/material.dart';
import 'package:mobile/models/achievement.dart';
import 'package:mobile/styles.dart';

class AchievementListItem extends StatelessWidget {
  const AchievementListItem({
    super.key,
    required this.achievement,
    required this.isLocked,
  });

  final Achievement achievement;
  final bool isLocked;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        showDialog(
            context: context,
            builder: (context) => SimpleDialog(
                  title: Text(
                    achievement.name,
                    textAlign: TextAlign.center,
                  ),
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Text(
                        achievement.description,
                        textAlign: TextAlign.center,
                      ),
                    ),
                    const SizedBox(height: 30),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton(
                            onPressed: () => Navigator.pop(context),
                            child: const Text("Close")),
                      ],
                    )
                  ],
                ));
      },
      child: Container(
        height: 80,
        margin: const EdgeInsets.only(bottom: 15),
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: isLocked
              ? Color.fromARGB(255, 212, 212, 212)
              : const Color(0xffFEEFAD),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            width: 2.0,
            color: isLocked
                ? Color.fromARGB(255, 194, 194, 194)
                : const Color.fromARGB(255, 252, 221, 84),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 255, 239, 239),
                    border: Border.all(
                      width: 1.5,
                      color: const Color.fromARGB(255, 78, 78, 78),
                    ),
                    borderRadius: const BorderRadius.all(Radius.circular(10)),
                  ),
                  child: Image.asset(
                    'lib/assets/achievements/${achievement.icon}',
                    errorBuilder: (BuildContext context, Object error,
                        StackTrace? stackTrace) {
                      return Image.asset(
                          'lib/assets/achievements/fallback.png');
                    },
                  ),
                ),
                const SizedBox(width: 10),
                Text(
                  achievement.name,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            if (isLocked)
              const Icon(
                Icons.lock,
                color: Colors.yellow,
              ),
          ],
        ),
      ),
    );
  }
}
