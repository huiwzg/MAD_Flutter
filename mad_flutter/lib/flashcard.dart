import 'package:flutter/material.dart';

class FlashcardWidget extends StatelessWidget {
  final TextEditingController controller1;
  final TextEditingController controller2;

  const FlashcardWidget({
    required this.controller1,
    required this.controller2,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(8),
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          TextField(
            controller: controller1,
            decoration: InputDecoration(labelText: 'Term'),
          ),
          SizedBox(height: 10),
          TextField(
            controller: controller2,
            decoration: InputDecoration(labelText: 'Definition'),
          ),
        ],
      ),
    );
  }
}
