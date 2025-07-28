// ignore_for_file: unnecessary_null_comparison, camel_case_types, unused_local_variable, unnecessary_brace_in_string_interps, file_names, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../provider/generate-paper-provider.dart';

class PaperWidget extends StatelessWidget {
  const PaperWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final paperProvider = Provider.of<GeneratePaper>(context);
    final paperData = paperProvider.paper;
    final allQuestions = paperData["result"] ?? [];

    // Separate questions by type
    final mcqs = allQuestions.where((item) => item['type'] == 'mcq').toList();
    final descriptiveQuestions =
        allQuestions.where((item) => item['type'] == 'descriptive').toList();
    final mcqsMarks = mcqs.length * 2;
    final descrptiveMarks = paperProvider.selectedTerm == "finalTerm"
        ? descriptiveQuestions.length * 10
        : descriptiveQuestions.length * 4;
    // mcqsMarks = ;

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Part A - MCQs Section
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 0.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Part-A",
                    style: TextStyle(
                      fontSize: 14,
                    )),
                Text("Marks: $mcqsMarks ", style: TextStyle(fontSize: 14)),
              ],
            ),
          ),
          const Divider(),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 5.0),
            child: Text(
                "Q.No.1: Complete the following MCQs with correct option given below.",
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                )),
          ),
          const SizedBox(height: 5),

          // MCQs List
          ListView.builder(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: mcqs.length,
            itemBuilder: (context, index) {
              final item = mcqs[index];
              final question = item["question"];
              final choices = item["choices"] as List;

              return Container(
                alignment: Alignment.topLeft,
                margin:
                    const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "${toRoman(index + 1)}. $question",
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 1),
                    if (item["choices"] != null)
                      Wrap(
                        spacing: 2,
                        runSpacing: 4,
                        children: List.generate(choices.length, (i) {
                          final optionLabels = ['a', 'b', 'c', 'd'];
                          return Text(
                            "${optionLabels[i]}) ${choices[i]}",
                          );
                        }),
                      ),
                    const SizedBox(height: 2),
                  ],
                ),
              );
            },
          ),
          const SizedBox(height: 4),
          Divider(),
          const SizedBox(height: 4),
          // Part B - Descriptive Questions Section
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 0.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Part-B",
                    style: TextStyle(
                      fontSize: 14,
                    )),
                Text("Marks: ${descrptiveMarks}",
                    style: TextStyle(fontSize: 14)),
              ],
            ),
          ),
          const Divider(),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            child: Text(
                "Attempt all questions given below. All questions carry equal marks.",
                style: TextStyle(
                  fontSize: 12,
                  // fontWeight: FontWeight.bold,
                )),
          ),
          // Descriptive Questions List
          ListView.builder(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: descriptiveQuestions.length,
            itemBuilder: (context, index) {
              final item = descriptiveQuestions[index];
              final question = item["question"];

              return Container(
                margin:
                    const EdgeInsets.symmetric(horizontal: 16.0, vertical: 2.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Q.${index + 2}) $question",
                      style: const TextStyle(
                        fontSize: 12,
                        //  fontWeight: FontWeight.bold
                      ),
                    ),
                    const SizedBox(height: 4),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

String toRoman(int number) {
  const romanMap = {
    1000: 'M',
    900: 'CM',
    500: 'D',
    400: 'CD',
    100: 'C',
    90: 'XC',
    50: 'L',
    40: 'XL',
    10: 'X',
    9: 'IX',
    5: 'V',
    4: 'IV',
    1: 'I',
  };
  var result = '';
  romanMap.forEach((value, numeral) {
    while (number >= value) {
      result += numeral.toLowerCase(); // lowercase roman
      number -= value;
    }
  });
  return result;
}
