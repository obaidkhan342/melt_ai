// ignore_for_file: avoid_print, unused_import, prefer_const_constructors, prefer_const_literals_to_create_immutables, unnecessary_null_comparison, unnecessary_brace_in_string_interps, unused_local_variable, file_names, deprecated_member_use

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

import 'package:pdf/pdf.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';

import '../provider/generate-paper-provider.dart';
import '../widgets/paper-widget.dart';
import '../widgets/paper-heading.dart';
import '../widgets/paper-pdf.dart';
import '../widgets/prompt-generate-paper.dart';

class PaperScreen extends StatefulWidget {
  const PaperScreen({super.key});

  @override
  State<PaperScreen> createState() => _PaperScreenState();
}

class _PaperScreenState extends State<PaperScreen> {
  @override
  Widget build(BuildContext context) {
    final paperProvider = Provider.of<GeneratePaper>(context);
    return WillPopScope(
        onWillPop: () async {
          // Navigate to HomePage and remove all previous routes
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => PaperScreen()),
            (route) => false, // This removes all previous routes
          );
          return false; // Prevent default back behavior
        },
        child: Scaffold(
          appBar: AppBar(
              automaticallyImplyLeading: false,
              title: PaperHeading(),
              toolbarHeight: 100,
              leading: IconButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => PromptGeneratePaper()));
                  },
                  icon: Icon(Icons.arrow_back_ios))
                  
                  ),
          body: Column(
            children: [
              Expanded(child: PaperWidget()),
              Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Consumer<GeneratePaper>(
                      builder: (context, pProvider, index) {
                    return Row(
                      children: [
                        // Download button
                        // Consumer<GeneratePaper>(
                        //     builder: (context, pProvider, index) {
                        // return
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: pProvider.isLoading
                                ? null
                                : () => generatePaper(
                                    paperProvider: pProvider, context: context),
                            icon: pProvider.isLoading
                                ? CircularProgressIndicator(
                                    color: const Color.fromARGB(
                                        255, 207, 204, 204))
                                : Icon(Icons.refresh),
                            label: Text("Re-Generate"),
                          ),
                        ),

                        SizedBox(width: 10),
                        // Share button
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: pProvider.isPdfGenerating
                                ? null
                                : () =>
                                    paperProvider.selectedTerm == "finalTerm"
                                        ? generateAndSaveFinalTermPDF(
                                            downloadOnly: false,
                                            paperProvider:
                                                context.read<GeneratePaper>(),
                                            context: context,
                                          )
                                        : generateAndSaveMidTermPDF(
                                            downloadOnly: false,
                                            paperProvider:
                                                context.read<GeneratePaper>(),
                                            context: context,
                                          ),
                            icon: pProvider.isPdfGenerating
                                ? CircularProgressIndicator(
                                    color: const Color.fromARGB(
                                        255, 207, 204, 204))
                                : Icon(Icons.share),
                            label: Text("Share PDF"),
                          ),
                        ),
                      ],
                    );
                  })),
            ],
          ),
        ));
  }
}
