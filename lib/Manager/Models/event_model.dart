import 'package:cloud_firestore/cloud_firestore.dart';

class EventModel {
  final String eventId;
  final String eventName;
  final String eventDate;
  final Timestamp eventDateTs;
  final String location;
  final int boysRequired;

  EventModel({
    required this.eventId,
    required this.eventName,
    required this.eventDate,
    required this.eventDateTs,
    required this.location,
    required this.boysRequired,
  });

  factory EventModel.fromMap(Map<String, dynamic> map) {
    return EventModel(
      eventId: map['EVENT_ID'] ?? '',
      eventName: map['EVENT_NAME'] ?? '',
      eventDate: map['EVENT_DATE'] ?? '',
      eventDateTs: map['EVENT_DATE_TS'],
      location: map['LOCATION_NAME'] ?? '',
      boysRequired: map['BOYS_REQUIRED'] ?? 0,
    );
  }
}
