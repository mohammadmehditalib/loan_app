import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

class ResultWidget extends StatefulWidget {
  final String question;
  final String selectedOption;

  const ResultWidget({super.key, required this.question, required this.selectedOption});

  @override
  State<ResultWidget> createState() => _ResultWidgetState();
}

class _ResultWidgetState extends State<ResultWidget> {
  @override
  Widget build(BuildContext context) {
    return Column(

      children: [Text(widget.question),
      
      
       Text(widget.selectedOption),
       ListTile()
       
       
       ],
      
    );
  }
}
