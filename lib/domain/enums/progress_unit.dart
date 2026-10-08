enum ProgressUnit {
  chapter('Chapter', 'chapter'),
  page('Page', 'page'),
  volume('Volume', 'volume'),
  volumeChapter('Vol & Ch', 'volume_chapter'),
  words('Words', 'words'),
  percent('Percentage', 'percent');

  final String label;
  final String value;
  const ProgressUnit(this.label, this.value);

  static ProgressUnit fromValue(String value) {
    final lower = value.toLowerCase().trim();
    if (lower == 'page' || lower == 'pages' || lower == 'pg' || lower == 'p') {
      return ProgressUnit.page;
    }
    return ProgressUnit.values.firstWhere(
      (e) => e.value == value,
      orElse: () => ProgressUnit.chapter,
    );
  }
}
