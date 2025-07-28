// ignore_for_file: unused_local_variable

import 'dart:developer';

import 'package:appwrite/appwrite.dart';

import '../helper/global.dart';

class AppWrite {
  static final _client = Client();
  static final _database = Databases(_client);

  static void init() {
    _client
        .setEndpoint('https://cloud.appwrite.io/v1')
        .setProject('67562a4700397464647a')
        .setSelfSigned(status: true);
    getApiKey();
    getFluxKey();
  }

  static Future<String> getApiKey() async {
    try {
      final d = await _database.getDocument(
          databaseId: 'MyDatabase',
          collectionId: 'GeminiApiKey',
          documentId: 'geminiKey');
      apiKey = d.data['apiKey'];
      log(apiKey);
      return apiKey;
    } catch (e) {
      log('$e');
      return '';
    }
  }

  static Future<String> getFluxKey() async {
    try {
      final k = await _database.getDocument(
          databaseId: 'MyDatabase',
          collectionId: 'GeminiApiKey',
          documentId: 'fluxKey');
      fluxKey = k.data['apiKey'];
      log(fluxKey);
      return fluxKey;
    } catch (e) {
      log('$e');
      return '';
    }
  }
}

// Client client = Client();
// client.setProject('67562a4700397464647a');