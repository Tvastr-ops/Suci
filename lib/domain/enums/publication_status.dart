enum PublicationStatus {
  ongoing('Ongoing', 'ongoing'),
  completed('Completed', 'completed'),
  hiatus('Hiatus', 'hiatus'),
  cancelled('Cancelled', 'cancelled');

  final String label;
  final String value;
  const PublicationStatus(this.label, this.value);

  static PublicationStatus fromValue(String value) {
    return PublicationStatus.values.firstWhere(
      (e) => e.value == value,
      orElse: () => PublicationStatus.ongoing,
    );
  }
}
