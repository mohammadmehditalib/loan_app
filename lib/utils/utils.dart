import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:home_loans/models/question.dart';

/// Parse json from mentioned path and convert to model class
///
Future<void> readJson({
  required String path,
  required Function(List<Question>) onSuccess,
}) async {
  final response = await rootBundle.loadString(path);
  final List<Question> allData = [];
  final data = await json.decode(response);
  for (int i = 0; i < (data['schema']['fields']).length; i++) {
    List<String> options = [];
    if (data['schema']['fields'][i]['type'] == 'SingleChoiceSelector' ||
        data['schema']['fields'][i]['type'] == 'SingleSelect') {
      for (int j = 0; j < (data['schema']['fields'][i]['schema']['options']).length; j++) {
        options.add(data['schema']['fields'][i]['schema']['options'][j]['value']);
      }
      allData.add(Question(text: data['schema']['fields'][i]['schema']['label'], options: options));
    } else {
      for (int j = 0; j < (data['schema']['fields'][i]['schema']['fields']).length; j++) {
        options = [];
        if (data['schema']['fields'][i]['schema']['fields'][j]['type'] == 'SingleSelect') {
          for (int k = 0;
              k < data['schema']['fields'][i]['schema']['fields'][j]['schema']['options'].length;
              k++) {
            options.add(data['schema']['fields'][i]['schema']['fields'][j]['schema']['options'][k]
                ['value']);
          }
          allData.add(Question(
              text: data['schema']['fields'][i]['schema']['fields'][j]['schema']['name'],
              options: options));
        } else {
          
          options.add(data['schema']['fields'][i]['schema']['fields'][j]['schema']['name']);
          allData.add(Question(text: 'numeric', options: options));
        }
      }
    }
  }
  for (int i = 0; i < allData.length; i++) {
    print(allData[i].text);
    print(allData[i].options);
  }
  onSuccess.call(allData);
}
