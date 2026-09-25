enum ProgressUnit {
  chapter('Chapter', 'chapter'),
  volumeChapter('Vol & Ch', 'volume_chapter'),
  words('Words', 'words'),
  percent('Percentage', 'percent');

  final String label;
  final String value;
  const ProgressUnit(this.label, this.value);

  static ProgressUnit fromValue(String value) {
    return ProgressUnit.values.firstWhere(
      (e) => e.value == value,
      orElse: () => ProgressUnit.chapter,
    );
  }
}
