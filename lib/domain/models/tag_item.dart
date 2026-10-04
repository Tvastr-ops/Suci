import 'package:flutter/foundation.dart';
import '../../data/database/app_database.dart';

@immutable
class TagItem {
  final String id;
  final String name;

  const TagItem({
    required this.id,
    required this.name,
  });

  factory TagItem.fromDrift(Tag tag) {
    return TagItem(
      id: tag.id,
      name: tag.name,
    );
  }

  TagItem copyWith({
    String? id,
    String? name,
  }) {
    return TagItem(
      id: id ?? this.id,
      name: name ?? this.name,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TagItem &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          name == other.name;

  @override
  int get hashCode => id.hashCode ^ name.hashCode;

  @override
  String toString() => 'TagItem(id: $id, name: $name)';
}
