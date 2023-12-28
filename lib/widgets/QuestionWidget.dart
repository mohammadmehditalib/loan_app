import 'package:flutter/material.dart';
import 'package:home_loans/models/question.dart';
import 'package:home_loans/result.dart';
import 'package:home_loans/utils/utils.dart';

class QuestionWidget extends StatefulWidget {
  const QuestionWidget({super.key});

  @override
  State<QuestionWidget> createState() => _QuestionWidgetState();
}

class _QuestionWidgetState extends State<QuestionWidget> with TickerProviderStateMixin {
  List<Question> questions = [];
  late PageController _controller;

  String selectedOption = '';
  int questionNumber = 1;
  double progress = 0.0;
  int cnt = 1;

  @override
  void initState() {
    super.initState();
    _controller = PageController(initialPage: 0);
    readJson(
      path: 'lib/data.json',
      onSuccess: (allData) {
        WidgetsBinding.instance.addPostFrameCallback(
          (_) => setState(() {
            questions = allData;
            progress = (cnt / 7);
          }),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 20, right: 20, top: 35),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'About loan',
            style: TextStyle(color: Colors.black87, fontSize: 25),
          ),
          const SizedBox(
            height: 24,
          ),
          LinearProgressIndicator(
            backgroundColor: Colors.grey,
            value: progress,
            color: Colors.green,
          ),
          Expanded(
              child: PageView.builder(
                  controller: _controller,
                  itemCount: questions.length,
                  physics: const NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    return buildQuestion(questions[index]);
                  })),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              GestureDetector(
                onTap: () {
                  _controller.previousPage(
                      duration: const Duration(milliseconds: 200), curve: Curves.easeInExpo);
                  setState(() {
                    questionNumber--;
                    cnt--;
                    progress = cnt / 7;
                  });
                },
                child: Row(
                  children: const [Icon(Icons.chevron_left), Text('Back')],
                ),
              ),
              buildElevatedButton(),
            ],
          )
        ],
      ),
    );
  }

  Widget buildQuestion(Question question) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(
          height: 32,
        ),
        question.text == 'numeric'
            ? Text(
                question.options[0],
                style: const TextStyle(fontSize: 15),
              )
            : Text(
                question.text,
                style: const TextStyle(fontSize: 15),
              ),
        Expanded(child: optionsWidget(question))
      ],
    );
  }

  Widget optionsWidget(Question question) {
    return Column(
        children:
            question.options.map((option) => buildOption(context, option, question)).toList());
  }

  Widget buildOption(BuildContext context, String option, Question question) {
    return Container(
      height: 35,
      margin: const EdgeInsets.symmetric(vertical: 7),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          border: selectedOption != option
              ? Border.all(color: Colors.grey)
              : Border.all(color: Colors.orange)),
      child: Row(
        children: [
          Radio(
              value: option,
              groupValue: selectedOption,
              activeColor: Colors.orange,
              onChanged: (value) {
                setState(() {
                  selectedOption = value!;
                  question.selectedOption = selectedOption;
                });
              }),
          selectedOption != option
              ? Text(
                  option,
                  style: const TextStyle(fontSize: 15),
                )
              : Text(option, style: const TextStyle(fontSize: 15, color: Colors.orange))
        ],
      ),
    );
  }

  Widget buildElevatedButton() {
    return Visibility(
      visible: selectedOption != '',
      child: Container(
        decoration: const BoxDecoration(shape: BoxShape.circle, color: Colors.orange),
        child: IconButton(
            onPressed: () {
              if (questionNumber < questions.length) {
                _controller.nextPage(
                    duration: const Duration(milliseconds: 200), curve: Curves.easeInExpo);
                setState(() {
                  questionNumber++;
                  selectedOption = '';
                  cnt++;
                  progress = cnt / 7;
                });
              } else {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => Results(
                              questions: questions,
                            )));
              }
            },
            icon: const Icon(Icons.chevron_right)),
      ),
    );
  }
}
