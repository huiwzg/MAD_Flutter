import 'package:flutter/material.dart';

class FlashcardEditWidget extends StatelessWidget {
  final TextEditingController controller1;
  final TextEditingController controller2;

  const FlashcardEditWidget({
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

class FlashcardWidget extends StatelessWidget {
  final TextEditingController controller1;
  final TextEditingController controller2;
  final bool isFlipped;
  final VoidCallback onFlip;
  final VoidCallback onNext;
  final VoidCallback onPrev;

  const FlashcardWidget({
    required this.controller1,
    required this.controller2,
    required this.isFlipped,
    required this.onFlip,
    required this.onNext,
    required this.onPrev,
  });

  @override
  Widget build(BuildContext context) {
    return Column (
      children: [
        GestureDetector(
          onTap: onFlip,
          child: Container(
            width: 300,
            height: 200,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              boxShadow: [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 4.0,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: Center(
              child: Text(
                isFlipped ? controller2.text : controller1.text,
                style: TextStyle(fontSize: 24),
              ),
            ),
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: onPrev,
              child: const Text('Previous'),
            ),
            SizedBox(width: 20),
            ElevatedButton(
              onPressed: onNext,
              child: const Text('Next'),
            ),
          ],
        ),
        // ElevatedButton(
        //   onPressed: onNext,
        //   child: const Text('Next'),
        // ),
        // ElevatedButton(
        //   onPressed: onPrev,
        //   child: const Text('Previous'),
        // ),
      ]
    );
  }
}