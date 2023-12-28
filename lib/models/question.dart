class Question{
  final String text;
  final List<String> options;
  String? selectedOption;


  Question({
   required this.text,
    required this.options,
    this.selectedOption
  }) ;
}