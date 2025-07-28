// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, unused_local_variable, unused_element, use_build_context_synchronously, sort_child_properties_last, await_only_futures, file_names, sized_box_for_whitespace

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../assistant_screen.dart';
import '../provider/generate-paper-provider.dart';
import '../screens/paper-screen.dart';

class PromptGeneratePaper extends StatefulWidget {
  const PromptGeneratePaper({super.key});

  @override
  State<PromptGeneratePaper> createState() => _PromptGeneratePaperState();
}

class _PromptGeneratePaperState extends State<PromptGeneratePaper> {
  
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final paperProvider = Provider.of<GeneratePaper>(context, listen: false);
      paperProvider.paper = {"result": []}; // Load the first question
    });
  }

  @override
  Widget build(BuildContext context) {
    // final paperProvider = Provider.of<GeneratePaper>(context, listen: false);
    return Consumer<GeneratePaper>(builder: (context, paperProvider, index) {
      return Scaffold(
        backgroundColor:  Colors.blue.shade50,
        appBar: AppBar(
        backgroundColor:  Colors.blue.shade50,
          automaticallyImplyLeading: false,
          title: Text("PaperGenie",
          style : TextStyle(
            fontWeight : FontWeight.bold,
          )
          ),
          centerTitle: true,
          leading: IconButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => AssistantScreen()));
                  },
                  icon: Icon(Icons.arrow_back_ios))
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(
                height: 25,
              ),
              TextField(
                controller: paperProvider.subjectController,
                decoration: InputDecoration(
                  labelText: 'Enter Subject Name',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              TextField(
                controller: paperProvider.contentController,
                // minLines: 3,
                maxLines: 3,
                decoration: InputDecoration(
                  labelText:
                      'Type all the content here you thought to students',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              TextField(
                controller: paperProvider.courseCodeController,
                decoration: InputDecoration(
                  labelText: 'Course Code',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(
                height : 20
              ),
              DropdownButtonFormField<String>(
                  value: paperProvider.selectedField,
                  decoration: InputDecoration(
                    labelText: 'Field',
                    border: OutlineInputBorder(),
                  ),
                  items: paperProvider.fieldOptions.map((String value) {
                    return DropdownMenuItem(value: value, child: Text(value));
                  }).toList(),
                  onChanged: (String? newValue) {
                    paperProvider.selectedField = newValue!;
                  }),
              SizedBox(
                height: 20,
              ),
              DropdownButtonFormField<String>(
                  value: paperProvider.selectedTerm,
                  decoration: InputDecoration(
                    labelText: 'Examination',
                    border: OutlineInputBorder(),
                  ),
                  items: paperProvider.termOptions.map((String value) {
                    return DropdownMenuItem(value: value, child: Text(value));
                  }).toList(),
                  onChanged: (String? newValue) {
                    paperProvider.selectedTerm = newValue!;
                  }),
              SizedBox(
                height: 20,
              ),
              DropdownButtonFormField<String>(
                  value: paperProvider.selectedDifficulty,
                  decoration: InputDecoration(
                    labelText: 'Difficulty',
                    border: OutlineInputBorder(),
                  ),
                  items: paperProvider.difficultyOptions.map((String value) {
                    return DropdownMenuItem(value: value, child: Text(value));
                  }).toList(),
                  onChanged: (String? newValue) {
                    paperProvider.selectedDifficulty = newValue!;
                  }),
              SizedBox(
                height: 20,
              ),

              GestureDetector(
                  onTap : paperProvider.isLoading
                    ? null
                    : () => generatePaper(paperProvider: paperProvider, context : context),
                  child: Card(
                    elevation : 10,
                    child: Container(
                      height : 50,
                      decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Colors.blue.shade50,
                        Colors.white
                      ], // Subtle gradient background
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius:
                        BorderRadius.circular(15), // Match card border radius
                                ),
                      child:  paperProvider.isLoading
                            ? Container(
                              height : 40,
                              width : 40,
                              child: Center(
                                child: CircularProgressIndicator(
                                    color: const Color.fromARGB(255, 207, 204, 204)),
                              ),
                            ) 
                            : Center(
                              child: Text('Generate Paper',
                              style : TextStyle(
                                color : Colors.black
                              )
                              ),
                            ),
                       
                        ),
                      
                      
                    ),
                  ),
              
              
            ],
          )),
        ),
      );
    });
  }

 
}
 generatePaper({required GeneratePaper paperProvider,
 required BuildContext context,
  bool reGenerate = false,
 }) async {
    String subject = paperProvider.subjectController.text.trim();
    String content = paperProvider.contentController.text.trim();
    String term = paperProvider.selectedTerm.toString();
    String field = paperProvider.selectedField.toString();
    String difficulty = paperProvider.selectedDifficulty;

    if (subject.isEmpty || content.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please fill in all fields')),
      );
      return "";
    }

//prompt to generate gpgc mid term paper
final midTermPrompt = '''
Generate a unique exam paper in JSON format with these specifications:
- Subject: "$subject" (Field: $field)
- Examination: $term
- Difficulty: $difficulty
- Based on this content: "$content"
**Required Questions:**
1. 6 MCQs (multiple choice questions) with:
   - "type": "mcq"
   - "question": (clear, concise question)
   - "choices": [4 options including correct answer]
2. 3 Descriptive questions with:
   - "type": "descriptive"
   - "question": (open-ended question)
3. Explicitly demands **uniqueness** for mcq and descpritive.  
4. Uses strong language like *"NONE of these mcq and descriptive question have been generated before"* to reduce repetition. 
5. Each choice in choices should not contain more than 20 characters because it expanded the size of page
6. Ensure the response is **only the JSON array** without any extra characters or formatting.
**Important**: Ensure the response is **only the JSON array** without any extra characters or formatting.

**Output Rules:**
- Return ONLY a valid JSON array
- All questions MUST be unique and never repeated
- MCQ options should be plausible and randomized
- Questions should cover different aspects of the content
- Escape special characters properly
- before json there should not should any not some symbols and not any json name
- Format like this example:

```json
[
  {
    "type": "mcq",
    "question": "What is the main advantage of using functions in programming?",
    "choices": [
      "Code reusability",
      "Faster execution",
      "Reduced memory usage",
      "Better hardware compatibility"
    ]
  },
  {
    "type": "descriptive",
    "question": "Explain the difference between procedural and object-oriented programming"
  }
]

**Important**: Ensure the response is **only the JSON array** without any extra characters or formatting.''';

//prompt to generate gpgc final term paper
    final finalTermPrompt = '''
Generate a unique exam paper in JSON format with these specifications:
- Subject: "$subject" (Field: $field)
- Examination: $term
- Difficulty: $difficulty
- Based on this content: "$content"
**Required Questions:**
1. 10 MCQs (multiple choice questions) with:
   - "type": "mcq"
   - "question": (clear, concise question)
   - "choices": [4 options including correct answer]
2. 4 Descriptive questions with:
   - "type": "descriptive"
   - "question": (open-ended question)
3. Explicitly demands **uniqueness** for mcq and descpritive.
4. Uses strong language like *"NONE of these mcq and descriptive question have been generated before"* to reduce repetition.
5. each response should must be different from previous one 
**Important**: Ensure the response is **only the JSON array** without any extra characters or formatting.

**Output Rules:**
- Return ONLY a valid JSON array
- All questions MUST be unique and never repeated
- MCQ options should be plausible and randomized
- Questions should cover different aspects of the content
- Escape special characters properly
- before json there should not should any not some symbols and not any json name
- Format like this example:

```json
[
  {
    "type": "mcq",
    "question": "What is the main advantage of using functions in programming?",
    "choices": [
      "Code reusability",
      "Faster execution",
      "Reduced memory usage",
      "Better hardware compatibility"
    ]
  },
  {
    "type": "descriptive",
    "question": "Explain the difference between procedural and object-oriented programming"
  }
]

**Important**: Ensure the response is **only the JSON array** without any extra characters or formatting.
''';


try {
      
if(paperProvider.selectedTerm == "finalTerm"){
final response = await paperProvider.sendPromtAndGetResponse(
              message: finalTermPrompt, isTextOnly: true);
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => PaperScreen()));
      }else{
        final response = await paperProvider.sendPromtAndGetResponse(
              message: midTermPrompt, isTextOnly: true);
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => PaperScreen()));
      }

      
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error generating paper: $e')),
      );
    }
  }