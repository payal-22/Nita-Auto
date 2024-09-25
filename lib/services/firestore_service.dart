import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> addTravelDetails(
      String travelTime, String travelDate, int peopleCount) async {
    await _firestore.collection('travel_details').add({
      'travel_time': travelTime,
      'travel_date': travelDate,
      'people_count': peopleCount,
    });
  }

  Stream<QuerySnapshot> getTravelDetailsStream() {
    return _firestore.collection('travel_details').snapshots();
  }
}
