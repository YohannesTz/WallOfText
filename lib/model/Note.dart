import 'dart:convert';

class Note {
  final String id;
  final String title;
  final String content;
  final String date;
  final String time;
  final int v;
  final int likes;
  final int dislikes;
  Note({
    required this.id,
    required this.title,
    required this.content,
    required this.date,
    required this.time,
    required this.v,
    required this.likes,
    required this.dislikes,
  });

  Note copyWith({
    String? id,
    String? title,
    String? content,
    String? date,
    String? time,
    int? v,
    int? likes,
    int? dislikes,
  }) {
    return Note(
      id: id ?? this.id,
      title: title ?? this.title,
      content: content ?? this.content,
      date: date ?? this.date,
      time: time ?? this.time,
      v: v ?? this.v,
      likes: likes ?? this.likes,
      dislikes: dislikes ?? this.dislikes,
    );
  }

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};

    result.addAll({'id': id});
    result.addAll({'title': title});
    result.addAll({'content': content});
    result.addAll({'date': date});
    result.addAll({'time': time});
    result.addAll({'v': v});
    result.addAll({'likes': likes});
    result.addAll({'dislikes': dislikes});

    return result;
  }

  factory Note.fromMap(Map<String, dynamic> map) {
    return Note(
      id: map['_id'] ?? '',
      title: map['title'] ?? '',
      content: map['content'] ?? '',
      date: map['date'] ?? '',
      time: map['time'] ?? '',
      v: map['__v']?.toInt() ?? 0,
      likes: map['likes']?.toInt() ?? 0,
      dislikes: map['dislikes']?.toInt() ?? 0,
    );
  }

  String toJson() => json.encode(toMap());

  factory Note.fromJson(String source) => Note.fromMap(json.decode(source));

  @override
  String toString() {
    return 'Note(id: $id, title: $title, content: $content, date: $date, time: $time, v: $v, likes: $likes, dislikes: $dislikes)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Note &&
        other.id == id &&
        other.title == title &&
        other.content == content &&
        other.date == date &&
        other.time == time &&
        other.v == v &&
        other.likes == likes &&
        other.dislikes == dislikes;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        title.hashCode ^
        content.hashCode ^
        date.hashCode ^
        time.hashCode ^
        v.hashCode ^
        likes.hashCode ^
        dislikes.hashCode;
  }
}
