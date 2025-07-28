import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/translator_provider.dart';

class LanguageSheet extends StatelessWidget {
  final bool isFromLanguage;

  const LanguageSheet({super.key, required this.isFromLanguage});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<TranslateProvider>(context, listen: true);

    return Container(
      height: MediaQuery.of(context).size.height * 0.5,
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          // Search input field
          TextField(
            onChanged: (value) => provider.search = value.toLowerCase(),
            decoration: const InputDecoration(
              prefixIcon: Icon(Icons.translate),
              hintText: 'Search Language...',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(10)),
              ),
            ),
          ),

          // Display filtered list
          Expanded(
            child: ListView.builder(
              itemCount: provider.filteredLanguages.length,
              itemBuilder: (context, index) {
                final language = provider.filteredLanguages[index];
                // Displaying the language list without excluding any language
                return ListTile(
                  title: Text(language),
                  onTap: () {
                    if (isFromLanguage){
                      provider.from = language;
                      provider.clearSearch();
                    } else {
                      provider.to = language; // Set 'To' language
                      provider.clearSearch();
                    }
                    provider.clearSearch();
                    Navigator.pop(context); // Close the sheet
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
