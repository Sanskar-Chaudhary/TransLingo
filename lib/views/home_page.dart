import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../controllers/translation_controller.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _textController = TextEditingController();
  String _translatedText = '';
  bool _isLoading = false;
  String _error = '';
  String _fromLanguage = 'en';
  String _toLanguage = 'ru';

  @override
  Widget build(BuildContext context) {
    final translationController = Provider.of<TranslationController>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('TransLingo'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      extendBodyBehindAppBar: true,
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF1C1C3A), Color(0xFF2E2E48)],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(height: 80), // For spacing from AppBar
              Container(
                padding: EdgeInsets.all(8.0),
                decoration: BoxDecoration(
                  color: Color(0xFF2E2E48),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.white),
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: DropdownButton<String>(
                            value: _fromLanguage,
                            items: translationController.languages.entries
                                .map((entry) => DropdownMenuItem<String>(
                              value: entry.key,
                              child: Text(entry.value, style: TextStyle(color: Colors.white)),
                            ))
                                .toList(),
                            onChanged: (value) {
                              setState(() {
                                _fromLanguage = value!;
                              });
                            },
                            dropdownColor: Color(0xFF2E2E48),
                            underline: Container(),
                            isExpanded: true,
                          ),
                        ),
                        IconButton(
                          icon: Icon(Icons.swap_horiz, color: Colors.green),
                          onPressed: () {
                            setState(() {
                              final temp = _fromLanguage;
                              _fromLanguage = _toLanguage;
                              _toLanguage = temp;
                            });
                          },
                        ),
                        Expanded(
                          child: DropdownButton<String>(
                            value: _toLanguage,
                            items: translationController.languages.entries
                                .map((entry) => DropdownMenuItem<String>(
                              value: entry.key,
                              child: Text(entry.value, style: TextStyle(color: Colors.white)),
                            ))
                                .toList(),
                            onChanged: (value) {
                              setState(() {
                                _toLanguage = value!;
                              });
                            },
                            dropdownColor: Color(0xFF2E2E48),
                            underline: Container(),
                            isExpanded: true,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20),
              Container(
                decoration: BoxDecoration(
                  color: Color(0xFF2E2E48),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.white),
                ),
                padding: EdgeInsets.all(16.0),
                child: TextField(
                  controller: _textController,
                  maxLines: 5,
                  decoration: InputDecoration(
                    hintText: 'Enter text',
                    hintStyle: TextStyle(color: Colors.white54),
                    border: InputBorder.none,
                  ),
                  style: TextStyle(color: Colors.white),
                ),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  setState(() {
                    _isLoading = true;
                    _error = '';
                  });
                  try {
                    final translation = await translationController.translate(_textController.text, _fromLanguage, _toLanguage);
                    setState(() {
                      _translatedText = translation.translatedText;
                    });
                  } catch (e) {
                    setState(() {
                      _error = e.toString();
                    });
                  } finally {
                    setState(() {
                      _isLoading = false;
                    });
                  }
                  FocusScope.of(context).unfocus(); // Hide keyboard after translation
                },
                child: Text('Translate'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 50.0),
                ),
              ),
              SizedBox(height: 20),
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: Color(0xFF2E2E48),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.white),
                  ),
                  padding: EdgeInsets.all(16.0),
                  child: SingleChildScrollView(
                    child: Text(
                      _translatedText,
                      style: TextStyle(fontSize: 20, color: Colors.white),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
