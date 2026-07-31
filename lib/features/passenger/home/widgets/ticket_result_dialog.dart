import 'package:flutter/material.dart';

class TicketResultDialog extends StatelessWidget {
  final bool success;

  final String message;

  final VoidCallback? onViewTrip;

  const TicketResultDialog({
    super.key,
    required this.success,
    required this.message,
    this.onViewTrip,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),

      content: Column(
        mainAxisSize: MainAxisSize.min,

        children: [
          CircleAvatar(
            radius: 35,
            backgroundColor: success ? Colors.green : Colors.red,

            child: Icon(
              success ? Icons.check : Icons.close,
              color: Colors.white,
              size: 40,
            ),
          ),

          const SizedBox(height: 20),

          Text(
            success ? "Pembelian Berhasil" : "Pembelian Gagal",

            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
          ),

          const SizedBox(height: 12),

          Text(message, textAlign: TextAlign.center),

          const SizedBox(height: 25),

          if (success)
            SizedBox(
              width: double.infinity,

              child: ElevatedButton(
                onPressed: onViewTrip,

                child: const Text("Lihat Perjalanan"),
              ),
            ),

          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },

            child: const Text("Tutup"),
          ),
        ],
      ),
    );
  }
}
