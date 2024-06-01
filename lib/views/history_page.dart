import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
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
        child: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance.collection('translations').orderBy('timestamp', descending: true).snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            }

            if (snapshot.hasError) {
              return Center(child: Text('Error fetching translations'));
            }

            final translations = snapshot.data?.docs ?? [];

            if (translations.isEmpty) {
              return Center(child: Text('No translations yet.', style: TextStyle(color: Colors.white)));
            }

            return ListView.builder(
              itemCount: translations.length,
              itemBuilder: (context, index) {
                final translation = translations[index];
                return ListTile(
                  title: Text(translation['originalText'], style: TextStyle(color: Colors.white)),
                  subtitle: Text(translation['translatedText'], style: TextStyle(color: Colors.white)),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
