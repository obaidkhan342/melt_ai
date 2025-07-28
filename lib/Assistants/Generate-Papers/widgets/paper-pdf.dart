// ignore_for_file: prefer_const_constructors, file_names, avoid_print, use_build_context_synchronously, unused_element

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:share_plus/share_plus.dart';
import '../provider/generate-paper-provider.dart';
import 'paper-widget.dart';
// import 'package:permission_handler/permission_handler.dart';

Future<void> generateAndSaveMidTermPDF({
  required bool downloadOnly,
  required GeneratePaper paperProvider,
  required BuildContext context,
}) async {
  try {
    paperProvider.setPdfGenerating(true); 

    // paperProvider.isPdfGenerating = true;
    final pdf = pw.Document();
    // Safely access paper data
    final results = paperProvider.paper["result"] ?? [];
    final mcqs = results.where((item) => item['type'] == 'mcq').toList();
    final descriptives =
        results.where((item) => item['type'] == 'descriptive').toList();

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        build: (context) => [
          // Header Section
          pw.Column(crossAxisAlignment: pw.CrossAxisAlignment.start, children: [
            _buildHeader(paperProvider),
            pw.SizedBox(height: 5),

            // Part A - MCQs Section
            pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              children: [
                pw.Text("Part-A", style: pw.TextStyle(fontSize: 14)),
                pw.Text("Marks-06", style: pw.TextStyle(fontSize: 14)),
              ],
            ),
            pw.Divider(),
            pw.Text(
              "Q.No.1: Complete the following MCQs with correct option given below.",
              style: pw.TextStyle(fontSize: 12, fontWeight: pw.FontWeight.bold),
            ),
            pw.SizedBox(height: 15),
            _buildMcqSection(mcqs),

            // Part B - Descriptive Questions Section
            pw.SizedBox(height: 10),
            pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              children: [
                pw.Text("Part-B", style: pw.TextStyle(fontSize: 14)),
                pw.Text("Marks-14", style: pw.TextStyle(fontSize: 14)),
              ],
            ),
            pw.Divider(),
            pw.Text(
              "Q.No.2: Answer the following questions.",
              style: pw.TextStyle(fontSize: 12, fontWeight: pw.FontWeight.bold),
            ),
            pw.SizedBox(height: 5),
            _buildDescriptiveSection(descriptives),
          ])
        ],
      ),
    );
    final outputDir = await getApplicationDocumentsDirectory();
    final file = File(
        "${outputDir.path}/exam_paper_${DateTime.now().millisecondsSinceEpoch}.pdf");
    await file.writeAsBytes(await pdf.save());

    if (!downloadOnly) {
      await Share.shareXFiles([XFile(file.path)], text: 'Exam Paper PDF');
    }
    // final outputDir = await getApplicationDocumentsDirectory();
    // final filePath =
    //     "${outputDir.path}/exam_paper_${DateTime.now().millisecondsSinceEpoch}.pdf";

    // final file = File(filePath);
    // await file.writeAsBytes(await pdf.save());

    // if (!downloadOnly) {
    //   await Share.shareXFiles([XFile(file.path)], text: 'Exam Paper PDF');
    // } else {
    //   await _savePdfToDownloads(filePath, context);
    // }
  } catch (e) {
    print('Error generating PDF: $e');
    rethrow;
  }
  finally {
    paperProvider.setPdfGenerating(false);
  }
}

Future<void> generateAndSaveFinalTermPDF({
  required bool downloadOnly,
  required GeneratePaper paperProvider,
  required BuildContext context,
}) async {
  try {
    
    final pdf = pw.Document();
    final results = paperProvider.paper["result"] ?? [];
    final mcqs = results.where((item) => item['type'] == 'mcq').toList();
    final descriptives =
        results.where((item) => item['type'] == 'descriptive').toList();

    // Here is MCQS Page
    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: pw.EdgeInsets.all(10),
        build: (context) => [
          _buildHeader(paperProvider),
          pw.SizedBox(height: 15),
          pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
            children: [
              pw.Text("Part-A", style: pw.TextStyle(fontSize: 14)),
              pw.Text("Marks- ${mcqs.length * 2}",
                  style: pw.TextStyle(fontSize: 14)),
            ],
          ),
          pw.Divider(),
          pw.SizedBox(height: 5),
          pw.Text(
            "Q.No.1: Complete the following MCQs with correct option given below.",
            style: pw.TextStyle(fontSize: 12, fontWeight: pw.FontWeight.bold),
          ),
          pw.SizedBox(height: 15),
          // pw.Divider(),
          _buildMcqSection(mcqs),
        ],
      ),
    );

    // Add descriptive questions as a new page
    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        build: (context) => [
          _buildHeader(paperProvider),
          pw.SizedBox(height: 15),
          pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
            children: [
              pw.Text("Part-B", style: pw.TextStyle(fontSize: 14)),
              pw.Text("Marks- ${descriptives.length * 10}",
                  style: pw.TextStyle(fontSize: 14)),
            ],
          ),
          pw.Divider(),
          pw.Text(
            "Attemp all questions given below. All questions carry equal marks.",
            style: pw.TextStyle(fontSize: 12, fontWeight: pw.FontWeight.bold),
          ),
          pw.SizedBox(height: 5),
          _buildDescriptiveSection(descriptives),
        ],
      ),
    );
    final outputDir = await getApplicationDocumentsDirectory();
    final filePath =
        "${outputDir.path}/exam_paper_${DateTime.now().millisecondsSinceEpoch}.pdf";

    final file = File(filePath);
    await file.writeAsBytes(await pdf.save());

    if (!downloadOnly) {
      await Share.shareXFiles([XFile(file.path)], text: 'Exam Paper PDF');
     
    }

    // final outputDir = await getApplicationDocumentsDirectory();
    // final file = File(
    //     "${outputDir.path}/exam_paper_${DateTime.now().millisecondsSinceEpoch}.pdf");
    // await file.writeAsBytes(await pdf.save());

    // if (!downloadOnly) {
    //   await Share.shareXFiles([XFile(file.path)], text: 'Exam Paper PDF');
    // }
  } catch (e) {
    print('Error generating PDF: $e');
   

    rethrow;
  } 
  // finally {
  //   paperProvider.isPdfGenerating = false;
  // }
}

//Funtion to download file for android
// Future<void> _savePdfToDownloads(String filePath, BuildContext context) async {
//   try {
//     if (Platform.isAndroid) {
//       // Request storage permission
//       var status = await Permission.storage.request();
//       if (!status.isGranted) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(content: Text('Storage permission denied')),
//         );
//         return;
//       }

//       // Define the real Downloads folder path
//       final downloadsPath = "/storage/emulated/0/Download";
//       final downloadsDir = Directory(downloadsPath);

//       if (!await downloadsDir.exists()) {
//         await downloadsDir.create(recursive: true);
//       }

//       // Copy the PDF file to Downloads
//       final fileName = filePath.split('/').last;
//       final newPath = "$downloadsPath/$fileName";

//       await File(filePath).copy(newPath);

//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text("PDF saved to Downloads folder: $fileName")),
//       );
//     } else {
//       // iOS or other platforms: offer to share
//       await Share.shareXFiles([XFile(filePath)], text: 'Save this PDF');
//     }
//   } catch (e) {
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(content: Text('Failed to save: ${e.toString()}')),
//     );
//   }
// }

// Future<void> _savePdfToDownloads(String filePath, BuildContext context) async {
//   try {
//     if (Platform.isAndroid) {
//       final directory = await getExternalStorageDirectory();
//       final downloadsDir = Directory("${directory?.path}/Donwload");

//       if (!await downloadsDir.exists()) {
//         await downloadsDir.create(recursive: true);
//       }
//       final fileName = filePath.split('/').last;
//       final newPath = "${downloadsDir.path}/$fileName";

//       await File(filePath).copy(newPath);

//       ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text("PDF saved to Downloads folder")));
//     } else {
//       await Share.shareXFiles([XFile(filePath)], text: 'Save this PDF');
//     }
//   } catch (e) {
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(content: Text('Failed to save: ${e.toString()}')),
//     );
//   }
// }

pw.Widget _buildHeader(GeneratePaper paperProvider) {
  return pw.Column(
    crossAxisAlignment: pw.CrossAxisAlignment.start,
    children: [
      pw.Center(
        child: pw.Text(
          "GOVT POST GRADUATE COLLEGE LKL KHYBER AGENCY",
          style: pw.TextStyle(fontSize: 12, fontWeight: pw.FontWeight.bold),
        ),
      ),
      pw.SizedBox(height: 5),
      pw.Center(
        child: pw.Text(
          "Examination: ${paperProvider.selectedTerm}",
          style: pw.TextStyle(fontSize: 10, fontWeight: pw.FontWeight.bold),
        ),
      ),
      pw.Center(
        child: pw.Text(
          "DISCIPLINE: ${paperProvider.selectedField}",
          style: pw.TextStyle(
            fontSize: 10,
            fontWeight: pw.FontWeight.bold,
            decoration: pw.TextDecoration.underline,
          ),
        ),
      ),
      pw.SizedBox(height: 10),
      pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
        children: [
          pw.Text(
            "Semester: 1st [FALL 2024-25]",
            style: pw.TextStyle(fontSize: 10, fontWeight: pw.FontWeight.bold),
          ),
          pw.Text(
            "Subject: ${paperProvider.subjectController.text}",
            style: pw.TextStyle(fontSize: 10, fontWeight: pw.FontWeight.bold),
          ),
        ],
      ),
      pw.SizedBox(height: 10),
      pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
        children: [
          paperProvider.selectedTerm == "finalTerm"
              ? pw.Text("Time: 03:00 hours", style: pw.TextStyle(fontSize: 8))
              : pw.Text("Time: 01:30 hours", style: pw.TextStyle(fontSize: 8)),
          paperProvider.selectedTerm == "finalTerm"
              ? pw.Text("Total Marks: 60", style: pw.TextStyle(fontSize: 8))
              : pw.Text("Total Marks: 20", style: pw.TextStyle(fontSize: 8)),
          pw.Text(
            "Date:  /   /   ",
            style: pw.TextStyle(fontSize: 8),
          ),
        ],
      ),
      pw.SizedBox(height: 10),
      pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
        children: [
          pw.Text("Name:__________________", style: pw.TextStyle(fontSize: 8)),
          pw.Text("Roll No: _____________", style: pw.TextStyle(fontSize: 8)),
          pw.Text("Course Code: ${paperProvider.courseCodeController.text}",
              style: pw.TextStyle(fontSize: 8)),
        ],
      ),
      // pw.Divider(thickness: 1),
    ],
  );
}

pw.Widget _buildMcqSection(List<dynamic> mcqs) {
  return pw.ListView.builder(
    itemCount: mcqs.length,
    itemBuilder: (context, index) {
      final item = mcqs[index];
      return pw.Container(
        alignment: pw.Alignment.topLeft,
        margin: pw.EdgeInsets.only(bottom: 5),
        child: pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Text("${toRoman(index + 1)}. ${item['question']}",
                style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
            pw.SizedBox(height: 5),
            if (item["choices"] != null)
              pw.Wrap(
                  spacing: 2,
                  runSpacing: 4,
                  children: List.generate(item['choices'].length, (i) {
                    final optionLabels = ['a', 'b', 'c', 'd'];
                    return pw.Text("${optionLabels[i]}) ${item['choices'][i]}",
                        style: pw.TextStyle(
                          fontSize: 12,
                        ));
                  })),
          ],
        ),
      );
    },
  );
}

pw.Widget _buildDescriptiveSection(List<dynamic> descriptives) {
  return pw.ListView.builder(
    itemCount: descriptives.length,
    itemBuilder: (context, index) {
      final item = descriptives[index];
      return pw.Container(
        margin: pw.EdgeInsets.only(bottom: 15),
        child: pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Text("Q.No ${index + 2}) ${item['question']}",
                style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
            pw.SizedBox(height: 10),
          ],
        ),
      );
    },
  );
}
