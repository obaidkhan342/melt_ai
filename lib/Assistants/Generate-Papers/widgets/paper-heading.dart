// ignore_for_file: avoid_unnecessary_containers, prefer_const_constructors, prefer_const_literals_to_create_immutables, file_names

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../provider/generate-paper-provider.dart';

class PaperHeading extends StatelessWidget {
  const PaperHeading({super.key});

  @override
  Widget build(BuildContext context) {
    final pProvider = Provider.of<GeneratePaper>(context);
    return  Container(
          child: Column(
            children: [
             const Text("GOVT POST GRADUATE COLLEGE LKL KHYBER AGENCY",
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  )),
              Center(
                  child: pProvider.selectedTerm == "finalTerm" ? Text("Examination : FINAL TERM",
                      style: TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 10)) : Text("Examination : MID TERM",
                      style: TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 10))),
              Center(
                child: Text("DISCIPLINE : BS ${pProvider.selectedField.toUpperCase()}",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 10,
                      decoration: TextDecoration.underline,
                    )),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Semester: 1st [FALL 2024-25]",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 10,
                        // decoration: TextDecoration.underline,
                      )),
                  Flexible(
                    child: Text("Subject : ${pProvider.subjectController.text}",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 10,
                          // decoration: TextDecoration.underline,
                        )),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                 pProvider.selectedTerm == "finalTerm" ? Text("Time : 03:00 hours",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 8,
                        // decoration: TextDecoration.underline,
                      )): Text("Time : 01:30 hours",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 8,
                        // decoration: TextDecoration.underline,
                      )),
                  Flexible(
                    child: pProvider.selectedTerm == "finalTerm" ? Text("Total Marks : 60",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 8,
                          // decoration: TextDecoration.underline,
                        )) : Text("Total Marks : 20",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 8,
                          // decoration: TextDecoration.underline,
                        )),
                  ),
                  Flexible(
                    child: Text("""Date:   /    /2025""",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 8,
                          // decoration: TextDecoration.underline,
                        )),
                  ),
                ],
              ),
              SizedBox(
                height : 8
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Name:__________________",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 8,
                        // decoration: TextDecoration.underline,
                      )),
                  Flexible(
                    child: Text("C/R.No: ____________",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 8,
                          // decoration: TextDecoration.underline,
                        )),
                  ),
                  Flexible(
                    child: Text("""Course Code: ${pProvider.courseCodeController.text.toUpperCase()}""",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 8,
                          // decoration: TextDecoration.underline,
                        )),
                  ),
                ],
              ),
            ],
          ),
        );
  }
}