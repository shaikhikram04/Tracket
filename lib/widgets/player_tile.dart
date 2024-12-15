import 'package:flutter/material.dart';
import 'package:tracket/widgets/highlighted_label.dart';

class PlayerTile extends StatelessWidget {
  const PlayerTile({super.key});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {},
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
        child: Row(
          children: [
            const CircleAvatar(
              radius: 30,
              backgroundImage: AssetImage(
                'assets/images/Default_user_pfp.jpg',
              ),
            ),
            const SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      'Player Name',
                      style: Theme.of(context)
                          .textTheme
                          .bodyLarge!
                          .copyWith(fontSize: 18),
                    ),
                    const SizedBox(width: 7),
                    HighlightedLabel(
                      text: 'Captain',
                      bgColor: Colors.blue.shade100,
                      textColor: Colors.blue.shade900,
                    ),
                    const SizedBox(width: 7),
                    HighlightedLabel(
                      text: 'Wicketkeeper',
                      bgColor: Colors.orange.shade100,
                      textColor: Colors.orange.shade900,
                    ),
                  ],
                ),
                const Text('Cricket Role')
              ],
            )
          ],
        ),
      ),
    );
  }
}
