enum WorkFormat {
  webNovel('Web Novel', 'web_novel'),
  fanfiction('Fanfiction', 'fanfiction'),
  oel('OEL / Light Novel', 'oel'),
  webSerial('Web Serial', 'web_serial'),
  shortStory('Short Story', 'short_story'),
  novel('Novel', 'novel'),
  other('Other', 'other');

  final String label;
  final String value;
  const WorkFormat(this.label, this.value);

  static WorkFormat fromValue(String value) {
    return WorkFormat.values.firstWhere(
      (e) => e.value == value,
      orElse: () => WorkFormat.webNovel,
    );
  }
}
