import 'dart:convert';

// ignore_for_file: public_member_api_docs, sort_constructors_first

class TaskModel {
  final int id;
  final String description;
  final DateTime dateTime;
  final bool finished;
  TaskModel({
    required this.id,
    required this.description,
    required this.dateTime,
    required this.finished,
  });

  factory TaskModel.loadFromDB(Map<String, dynamic> task) {
    return TaskModel(
        id: task['id'],
        description: task['descricao'],
        dateTime: DateTime.parse(task['data_hora']),
        finished: task['finalizado'] == 1);
  }

  TaskModel copyWith({
    int? id,
    String? description,
    DateTime? dateTime,
    bool? finished,
  }) {
    return TaskModel(
      id: id ?? this.id,
      description: description ?? this.description,
      dateTime: dateTime ?? this.dateTime,
      finished: finished ?? this.finished,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'description': description,
      'dateTime': dateTime.millisecondsSinceEpoch,
      'finished': finished,
    };
  }

  factory TaskModel.fromMap(Map<String, dynamic> map) {
    return TaskModel(
      id: map['id'] as int,
      description: map['description'] as String,
      dateTime: DateTime.fromMillisecondsSinceEpoch(map['dateTime'] as int),
      finished: map['finished'] as bool,
    );
  }

  String toJson() => json.encode(toMap());

  factory TaskModel.fromJson(String source) =>
      TaskModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'TaskModel(id: $id, description: $description, dateTime: $dateTime, finished: $finished)';
  }

  @override
  bool operator ==(covariant TaskModel other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.description == description &&
        other.dateTime == dateTime &&
        other.finished == finished;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        description.hashCode ^
        dateTime.hashCode ^
        finished.hashCode;
  }
}
