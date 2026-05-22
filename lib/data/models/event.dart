import 'business.dart';

class Event {
  String id;
  String title;
  String description;
  DateTime date;
  List<String> businessIds;
  String imageUrl;
  List<Business> participants;

  Event({
    required this.id,
    required this.title,
    String? description,
    DateTime? date,
    List<String>? businessIds,
    String? imageUrl,
    List<Business>? participants,
  }) : description = description ?? '',
       date = date ?? DateTime.now(),
       businessIds = businessIds ?? [],
       imageUrl = imageUrl ?? '',
       participants = participants ?? [];

  factory Event.fromJson(Map<String, dynamic> json) {
    final rawBusinessIds = json['business_ids'];

    return Event(
      id: json['id']?.toString() ?? '',
      title: json['title']?.toString() ?? '',
      description: json['description']?.toString(),
      date: DateTime.tryParse(json['date']?.toString() ?? '') ?? DateTime.now(),
      businessIds: rawBusinessIds is List
          ? rawBusinessIds.map((id) => id.toString()).toList()
          : <String>[],
      imageUrl: json['image_url']?.toString(),
    );
  }
}
