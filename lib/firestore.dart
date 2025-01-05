import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tripplaner/trip.dart';
import 'package:tripplaner/dayActivities.dart';

class FirestoreService{
  final CollectionReference trips = FirebaseFirestore.instance.collection('Trips');

  //adding a Trip

  Future<String> addTrip(Trip t)async 
  {
     DocumentReference docRef = await trips.add(t.toJson());
     return docRef.id;
  }

  Stream<QuerySnapshot> getTrips()
  {
    final tripsStream = trips.snapshots();
    return tripsStream;
  }

  Future<Stream<QuerySnapshot>?> getAttractionsStream(String tripId, int dayId)async {

      QuerySnapshot daySnapshot = await FirebaseFirestore.instance
      .collection('Trips')
      .doc(tripId)
      .collection('days').where("index", isEqualTo: dayId)
      .get();

    if (daySnapshot.docs.isNotEmpty) {
    // Get the first matching document ID
    String ID = daySnapshot.docs.first.id; 
      return FirebaseFirestore.instance
      .collection('Trips')
      .doc(tripId)
      .collection('days')
      .doc(ID)
      .collection('attractions')
      .snapshots();

  } else {
    print("No Day found");
    return null;
  }

}

  Future<void> addAttraction(String TripID, int dayindex, Attraction attraction) async
  {
      DocumentReference tripDoc = trips.doc(TripID);
      DocumentSnapshot tripSnapshot = await tripDoc.get();

    if (tripSnapshot.exists) 
    {
      Map<String, dynamic> tripData = tripSnapshot.data() as Map<String, dynamic>;

      // Get the list of days
      List<dynamic> days = tripData['days'] ?? [];

      // Ensure dayIndex is valid
      if (dayindex < days.length) {
        // Update the attractions list for the specific day
        Map<String, dynamic> dayData = days[dayindex] as Map<String, dynamic>;
        List<dynamic> attractions = dayData['attractions'] ?? [];
        attractions.add(attraction.toJson()); // Add the new attraction
        dayData['attractions'] = attractions; // Update the day's attractions

        // Replace the updated day in the days array
        days[dayindex] = dayData;

        // Write the updated days array back to Firestore
        await tripDoc.update({'days': days});
        print("Attraction added successfully!");
      } else {
        print("Invalid day index!");
      }
    } else {
      print("Trip document does not exist!");
    }
  }
}