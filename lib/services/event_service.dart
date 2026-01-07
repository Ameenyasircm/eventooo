import 'package:cloud_firestore/cloud_firestore.dart';
import '../Manager/Models/event_model.dart';


class EventService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  /// Fetch all events
  Future<List<EventModel>> fetchAllEvents() async {
    try {
      final snapshot = await _db
          .collection('EVENTS')
          .where('EVENT_STATUS',isEqualTo: 'UPCOMING')
          .orderBy('EVENT_DATE_TS', descending: false)
          .get();

      return snapshot.docs
          .map((doc) => EventModel.fromMap(doc.data()))
          .toList();
    } on FirebaseException catch (e) {
      throw Exception('Firestore error: ${e.message}');
    } catch (e) {
      throw Exception('Unexpected error: $e');
    }
  }

  /// Fetch upcoming events
  Future<List<EventModel>> fetchUpcomingEvents() async {
    try {
      final nowUtc = DateTime.now().toUtc();
      final startOfTodayUtc =
      DateTime.utc(nowUtc.year, nowUtc.month, nowUtc.day);

      final snapshot = await _db
          .collection('EVENTS')
          .where('EVENT_DATE_TS', isGreaterThanOrEqualTo:
        Timestamp.fromDate(startOfTodayUtc),).orderBy('EVENT_DATE_TS').get();


      return snapshot.docs
          .map((doc) => EventModel.fromMap(doc.data()))
          .toList();
    } on FirebaseException catch (e) {
      throw Exception('Firestore error: ${e.message}');
    }
  }

  /// Take a work
  Future<void> takeWork(String eventId, String userId) async {
    final eventRef = _db.collection('EVENTS').doc(eventId);
    final userWorkRef = _db
        .collection('BOYS')
        .doc(userId)
        .collection('CONFIRMED_WORKS')
        .doc(eventId);

    await _db.runTransaction((transaction) async {
      // 1️⃣ Read event
      final eventSnap = await transaction.get(eventRef);

      if (!eventSnap.exists) {
        throw Exception('Event not found');
      }

      final data = eventSnap.data()!;
      final int required = data['BOYS_REQUIRED'] ?? 0;
      final int taken = data['BOYS_TAKEN'] ?? 0;

      // 2️⃣ Check limit
      if (taken >= required) {
        throw Exception('All slots are already filled');
      }

      // 3️⃣ Prevent same user taking twice
      final userWorkSnap = await transaction.get(userWorkRef);
      if (userWorkSnap.exists) {
        throw Exception('You already took this work');
      }

      final int updatedTaken = taken + 1;

      // 4️⃣ Update event
      transaction.update(eventRef, {
        'BOYS_TAKEN': updatedTaken,
        if (updatedTaken == required) 'BOYS_STATUS': 'FULL',
      });

      // 5️⃣ Copy event data to CONFIRMED_WORKS
      transaction.set(userWorkRef, {
        ...data,
        'EVENT_ID': eventId,
        'STATUS': 'CONFIRMED',
        'BOYS_TAKEN': updatedTaken, // ✅ correct value
        'CONFIRMED_AT': FieldValue.serverTimestamp(),
      });
    });
  }





}
