// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class QueryModel {
  final String query;
  final String? image;
  final String content;
  QueryModel({
    required this.query,
    this.image,
    required this.content,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'query': query,
      'image': image,
      'content': content,
    };
  }

  factory QueryModel.fromMap(Map<String, dynamic> map) {
    return QueryModel(
      query: map['query'] ?? "",
      image: map['image'] ?? "",
      content: map['content'] ?? "",
    );
  }

  String toJson() => json.encode(toMap());

  factory QueryModel.fromJson(String source) =>
      QueryModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
