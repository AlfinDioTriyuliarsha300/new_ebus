import 'package:flutter/material.dart';

class QuickMenuGrid extends StatelessWidget {

  final Function(int index) onTap;

  const QuickMenuGrid({
    super.key,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {

    final menus = [

      (
        Icons.location_searching,
        "Tracking",
        Colors.green,
      ),

      (
        Icons.history,
        "Riwayat",
        Colors.orange,
      ),

      (
        Icons.confirmation_num,
        "Tiket",
        Colors.blue,
      ),

      (
        Icons.notifications,
        "Notifikasi",
        Colors.red,
      ),

      (
        Icons.person,
        "Profil",
        Colors.deepPurple,
      ),

      (
        Icons.settings,
        "Pengaturan",
        Colors.teal,
      ),
    ];

    return GridView.builder(
      shrinkWrap: true,

      physics:
          const NeverScrollableScrollPhysics(),

      itemCount: menus.length,

      gridDelegate:
          const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,

        crossAxisSpacing: 15,

        mainAxisSpacing: 15,

        childAspectRatio: 1,
      ),

      itemBuilder: (context, index) {

        final menu = menus[index];

        return InkWell(
          borderRadius:
              BorderRadius.circular(22),

          onTap: () => onTap(index),

          child: Card(
            elevation: 4,

            shape: RoundedRectangleBorder(
              borderRadius:
                  BorderRadius.circular(22),
            ),

            child: Column(
              mainAxisAlignment:
                  MainAxisAlignment.center,

              children: [

                Container(
                  padding:
                      const EdgeInsets.all(16),

                  decoration: BoxDecoration(
                    color: menu.$3.withValues(alpha: .12),

                    borderRadius:
                        BorderRadius.circular(18),
                  ),

                  child: Icon(
                    menu.$1,

                    color: menu.$3,

                    size: 34,
                  ),
                ),

                const SizedBox(height: 14),

                Text(
                  menu.$2,

                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}