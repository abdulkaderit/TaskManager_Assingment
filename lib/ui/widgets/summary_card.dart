import 'package:flutter/material.dart';

class SummaryCard extends StatelessWidget {
  const SummaryCard({
    super.key,
    required this.title,
    required this.count,
  });

  final String title;
  final int count;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      color: Colors.white,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 18,vertical: 12),
        child: Column(
          children: [
            Text('$count',style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 22,
            ),),
            Text(title),
          ],
        ),
      ),
    );
  }
}