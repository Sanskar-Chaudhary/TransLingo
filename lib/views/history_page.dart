import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../controllers/translation_controller.dart';

class HistoryPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final translationController = Provider.of<TranslationController>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('History'),
        backgroundColor: Colors.black,
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(Icons.delete, color: Colors.white),
            onPressed: () {
              translationController.clearHistory();
            },
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF1C1C3A), Color(0xFF2E2E48)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: translationController.translations.isEmpty
            ? Center(child: Text('No translations yet.', style: TextStyle(color: Colors.white)))
            : ListView.builder(
          itemCount: translationController.translations.length,
          itemBuilder: (context, index) {
            final translation = translationController.translations[index];
            return ListTile(
              title: Text(translation.originalText, style: TextStyle(color: Colors.white)),
              subtitle: Text(translation.translatedText, style: TextStyle(color: Colors.white)),
            );
          },
        ),
      ),
    );
  }
}
