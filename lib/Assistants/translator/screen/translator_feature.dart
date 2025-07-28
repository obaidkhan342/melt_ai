// ignore_for_file: unused_import

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// import '../../controller/image_controller.dart';
import '../../assistant_screen.dart';
import '../providers/translator_provider.dart';
import '../../../chat-with-ai-bot/widget/custom_btn.dart';
import '../../../chat-with-ai-bot/widget/custom_loading.dart';
import '../widget/language_sheet.dart';


class TranslatorFeature extends StatelessWidget {
  const TranslatorFeature({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('Google Translator',
        style: TextStyle(
          fontWeight : FontWeight.bold,
        ),
        ),
        leading: IconButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => AssistantScreen()));
                    },
                    icon: Icon(Icons.arrow_back_ios))
      ),
      body: Consumer<TranslateProvider>(
        builder: (context, provider, _) => ListView(
          padding: const EdgeInsets.all(16.0),
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _languageSelector(context, provider, isFrom: true),
                IconButton(
                  icon: const Icon(Icons.swap_horiz),
                  onPressed: provider.swapLanguages,
                ),
                _languageSelector(context, provider, isFrom: false),
              ],
            ),
            _inputTextField(provider),
            _resultField(provider),
            SizedBox(
              height: 20,
            ),
            CustomBtn(
              onTap: provider.googleTranslate,
              text: 'Translate',
            ),
          ],
        ),
      ),
    );
  }

  Widget _languageSelector(BuildContext context, TranslateProvider provider,
      {required bool isFrom}) {
    return InkWell(
      onTap: () => showModalBottomSheet(
        context: context,
        builder: (_) => LanguageSheet(isFromLanguage: isFrom),
      ),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.blue),
          borderRadius: const BorderRadius.all(Radius.circular(15)),
        ),
        child: Text(isFrom
            ? provider.from.isEmpty
                ? 'Auto'
                : provider.from
            : provider.to.isEmpty
                ? 'To'
                : provider.to),
      ),
    );
  }

  Widget _inputTextField(TranslateProvider provider) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20.0),
      child: TextField(
        controller: provider.textC,
        maxLines: 5,
        decoration: const InputDecoration(
          hintText: 'Translate anything...',
          border: OutlineInputBorder(),
        ),
      ),
    );
  }

  Widget _resultField(TranslateProvider provider) {
    if (provider.status == Status.loading) {
      return const CustomLoading();
    } else if (provider.status == Status.complete) {
      return TextField(
        controller: provider.resultC,
        readOnly: true,
        decoration: const InputDecoration(border: OutlineInputBorder()),
      );
    }
    return const SizedBox();
  }
}
