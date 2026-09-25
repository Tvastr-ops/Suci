enum ReadingStatus {
  reading('Reading', 'reading'),
  planToRead('Plan to Read', 'plan_to_read'),
  onHold('On Hold', 'on_hold'),
  completed('Completed', 'completed'),
  dropped('Dropped', 'dropped');

  final String label;
  final String value;
  const ReadingStatus(this.label, this.value);

  static ReadingStatus fromValue(String value) {
    return ReadingStatus.values.firstWhere(
      (e) => e.value == value,
      orElse: () => ReadingStatus.reading,
    );
  }
}
