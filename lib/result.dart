import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:home_loans/models/question.dart';

class Results extends StatefulWidget {
  final List<Question> questions;

  const Results({super.key, required this.questions});

  @override
  State<Results> createState() => _ResultsState();
}

class _ResultsState extends State<Results> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Final Results')),
      body: ListView.builder(
        itemCount: widget.questions.length,
        
        itemBuilder: (context, index) => ListTile(

       title: Text(widget.questions[index].text),
       subtitle:Text(widget.questions[index].selectedOption!) , 

      )),
    );
  }
}
