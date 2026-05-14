import 'business.dart';

class Event {
  String id;
  String title;
  List<Business> participants;

  Event({required this.id, required this.title, required this.participants});
}
