import 'package:blog_app/core/theme/app_palette.dart';
import 'package:flutter/material.dart';

class FaqItem extends StatefulWidget {
  final String question;
  final String answer;

  const FaqItem({super.key, required this.question, required this.answer});

  @override
  State<FaqItem> createState() => _FaqItemState();
}

class _FaqItemState extends State<FaqItem> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      color: AppPalette.backgroundColor,
      child: ExpansionTile(
        title: Text(
          widget.question,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),

        onExpansionChanged:
            (expanded) => setState(() => _isExpanded = expanded),
        trailing: Icon(
          _isExpanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
        ),
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text(widget.answer),
          ),
        ],
      ),
    );
  }
}
