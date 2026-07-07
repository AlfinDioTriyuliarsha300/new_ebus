import 'package:flutter/material.dart';

class StatisticCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;

  const StatisticCard({
    super.key,
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {

    return Card(
      elevation: 4,

      shadowColor: color.withValues(alpha: .30),

      shape: RoundedRectangleBorder(
        borderRadius:
            BorderRadius.circular(22),
      ),

      child: Padding(
        padding: const EdgeInsets.all(18),

        child: Column(
          crossAxisAlignment:
              CrossAxisAlignment.start,

          children: [

            Container(
              padding:
                  const EdgeInsets.all(12),

              decoration: BoxDecoration(
                color:
                    color.withValues(alpha: .12),

                borderRadius:
                    BorderRadius.circular(15),
              ),

              child: Icon(
                icon,
                color: color,
                size: 30,
              ),
            ),

            const Spacer(),

            Text(
              value,

              style: const TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 6),

            Text(
              title,

              style: const TextStyle(
                color: Colors.grey,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }
}