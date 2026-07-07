import 'package:flutter/material.dart';

class DriverBusCard extends StatelessWidget {
  final String nomorBus;
  final String platNomor;
  final String status;
  final bool tracking;

  const DriverBusCard({
    super.key,
    required this.nomorBus,
    required this.platNomor,
    required this.status,
    required this.tracking,
  });

  @override
  Widget build(BuildContext context) {

    return Card(
      elevation: 5,

      shape: RoundedRectangleBorder(
        borderRadius:
            BorderRadius.circular(22),
      ),

      child: Padding(
        padding: const EdgeInsets.all(22),

        child: Column(
          crossAxisAlignment:
              CrossAxisAlignment.start,

          children: [

            Row(
              children: [

                Container(
                  padding:
                      const EdgeInsets.all(12),

                  decoration: BoxDecoration(
                    color: Colors.blue
                        .withValues(alpha: .12),

                    borderRadius:
                        BorderRadius.circular(15),
                  ),

                  child: const Icon(
                    Icons.directions_bus,
                    color: Colors.blue,
                    size: 30,
                  ),
                ),

                const SizedBox(width: 15),

                const Expanded(
                  child: Text(
                    "Informasi Armada",

                    style: TextStyle(
                      fontSize: 20,
                      fontWeight:
                          FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 25),

            _item(
              "Nomor Bus",
              nomorBus,
            ),

            _item(
              "Plat Nomor",
              platNomor,
            ),

            _item(
              "Status Armada",
              status,
            ),

            const SizedBox(height: 20),

            Row(
              children: [

                const Text(
                  "Tracking GPS",

                  style: TextStyle(
                    fontWeight:
                        FontWeight.bold,
                  ),
                ),

                const Spacer(),

                Container(
                  padding:
                      const EdgeInsets.symmetric(
                    horizontal: 15,
                    vertical: 8,
                  ),

                  decoration: BoxDecoration(
                    color: tracking
                        ? Colors.green
                            .withValues(alpha: .12)
                        : Colors.red
                            .withValues(alpha: .12),

                    borderRadius:
                        BorderRadius.circular(25),
                  ),

                  child: Row(
                    children: [

                      Icon(
                        tracking
                            ? Icons.location_on
                            : Icons.location_off,

                        size: 18,

                        color: tracking
                            ? Colors.green
                            : Colors.red,
                      ),

                      const SizedBox(width: 5),

                      Text(
                        tracking
                            ? "Aktif"
                            : "Nonaktif",

                        style: TextStyle(
                          color: tracking
                              ? Colors.green
                              : Colors.red,

                          fontWeight:
                              FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _item(
    String title,
    String value,
  ) {

    return Padding(
      padding:
          const EdgeInsets.only(bottom: 15),

      child: Row(
        children: [

          Expanded(
            child: Text(
              title,

              style: const TextStyle(
                color: Colors.grey,
              ),
            ),
          ),

          Text(
            value,

            style: const TextStyle(
              fontWeight:
                  FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}