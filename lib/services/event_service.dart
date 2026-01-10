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
  Future<List<EventModel>> fetchUpcomingEvents(String userId) async {
    try {
      // 1️⃣ Get today's UTC start
      final nowUtc = DateTime.now().toUtc();
      final startOfTodayUtc =
      DateTime.utc(nowUtc.year, nowUtc.month, nowUtc.day);

      // 2️⃣ Fetch upcoming events
      final eventsSnapshot = await _db
          .collection('EVENTS')
          .where(
        'EVENT_DATE_TS',
        isGreaterThanOrEqualTo:
        Timestamp.fromDate(startOfTodayUtc),
      )
          .orderBy('EVENT_DATE_TS')
          .get();

      final events = eventsSnapshot.docs
          .map((doc) => EventModel.fromMap(doc.data()))
          .toList();

      // 3️⃣ Fetch confirmed works of this boy
      final confirmedSnapshot = await _db
          .collection('BOYS')
          .doc(userId)
          .collection('CONFIRMED_WORKS')
          .get();

      final confirmedEventIds =
      confirmedSnapshot.docs.map((d) => d.id).toSet();

      // 4️⃣ Remove already confirmed events
      events.removeWhere(
            (event) => confirmedEventIds.contains(event.eventId),
      );

      return events;
    } on FirebaseException catch (e) {
      throw Exception('Firestore error: ${e.message}');
    }
  }


  /// Take a work
  Future<void> takeWork(String eventId, String boyId) async {
    final eventRef = _db.collection('EVENTS').doc(eventId);

    final confirmedBoyRef = eventRef
        .collection('CONFIRMED_BOYS')
        .doc(boyId);

    final boyWorkRef = _db
        .collection('BOYS')
        .doc(boyId)
        .collection('CONFIRMED_WORKS')
        .doc(eventId);

    await _db.runTransaction((transaction) async {
      // 1️⃣ Read Event
      final eventSnap = await transaction.get(eventRef);
      if (!eventSnap.exists) {
        throw Exception('Event not found');
      }

      final data = eventSnap.data()!;
      final int required = data['BOYS_REQUIRED'] ?? 0;
      final int taken = data['BOYS_TAKEN'] ?? 0;

      // 2️⃣ Check capacity
      if (taken >= required) {
        throw Exception('All slots are already filled');
      }

      // 3️⃣ Prevent duplicate booking
      final confirmedBoySnap = await transaction.get(confirmedBoyRef);
      if (confirmedBoySnap.exists) {
        throw Exception('You already took this work');
      }

      final boyWorkSnap = await transaction.get(boyWorkRef);
      if (boyWorkSnap.exists) {
        throw Exception('Work already exists for this boy');
      }

      final int updatedTaken = taken + 1;

      // 4️⃣ Update EVENT (source of truth)
      transaction.update(eventRef, {
        'BOYS_TAKEN': updatedTaken,
        if (updatedTaken == required) 'BOYS_STATUS': 'FULL',
      });

      // 5️⃣ Add to EVENTS → CONFIRMED_BOYS
      transaction.set(confirmedBoyRef, {
        ...data,
        'BOY_ID': boyId,
        'STATUS': 'CONFIRMED',
        'CONFIRMED_AT': FieldValue.serverTimestamp(),
      });

      // 6️⃣ Add to BOYS → CONFIRMED_WORKS
      transaction.set(boyWorkRef, {
        ...data,
        'EVENT_ID': eventId,
        'STATUS': 'CONFIRMED',
        'CONFIRMED_AT': FieldValue.serverTimestamp(),
      });
    });
  }

  Future<List<EventModel>> fetchConfirmedWorks(String userId) async {
    try {
      final snapshot = await _db
          .collection('BOYS')
          .doc(userId)
          .collection('CONFIRMED_WORKS')
          .orderBy('CONFIRMED_AT', descending: true)
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






}
