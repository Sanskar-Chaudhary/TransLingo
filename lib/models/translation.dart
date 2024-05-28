class Translation {
  final String originalText;
  final String translatedText;

  Translation({required this.originalText, required this.translatedText});

  Map<String, dynamic> toJson() {
    return {
      'originalText': originalText,
      'translatedText': translatedText,
    };
  }

  factory Translation.fromJson(Map<String, dynamic> json) {
    return Translation(
      originalText: json['originalText'],
      translatedText: json['translatedText'],
    );
  }
}
