import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:tripplaner/todo_list.dart';
import 'package:tripplaner/trip.dart';
import 'package:tripplaner/day_activities.dart';
import 'package:tripplaner/day.dart';

UserCredential? uc;

class FirestoreService {
  final CollectionReference trips = FirebaseFirestore.instance
      .collection('Users')
      .doc(uc?.user?.uid)
      .collection('Trips');

  Future<String> addTrip(Trip t) async {
    DocumentReference docRef = await trips.add(t.toJson());
    for (Day d in t.days) {
      DocumentReference dayRef =
          await trips.doc(docRef.id).collection('days').add(d.toJson());
      d.id = dayRef.id;
    }
    return docRef.id;
  }

  Stream<QuerySnapshot> getTripsStream() {
    final tripsStream = trips.snapshots();
    return tripsStream;
  }

  void updateAttraction(
      String tripId, String dayId, Attraction old, Attraction newOne) {
    trips
        .doc(tripId)
        .collection('days')
        .doc(dayId)
        .collection('attractions')
        .doc(old.id)
        .update(newOne.toJson());
  }

  void updateTransport(
      String tripId, String dayId, Transport old, Transport newOne) {
    trips
        .doc(tripId)
        .collection('days')
        .doc(dayId)
        .collection('transport')
        .doc(old.id)
        .update(newOne.toJson());
  }

  void updateSleepover(
      String tripId, String dayId, Sleepover old, Sleepover newOne) {
    trips
        .doc(tripId)
        .collection('days')
        .doc(dayId)
        .collection('sleepovers')
        .doc(old.id)
        .update(newOne.toJson());
  }

  void updateToDoElementNotification(
      String tripId, ToDoElement element, int notificationID) {
    final a = ToDoElement(description: element.description);
    a.notificationID = notificationID;
    trips.doc(tripId).collection('todo').doc(element.id).update(a.toJson());
  }

  Future<String> addSleepover(String tripId, String dayId, Sleepover a) async {
    DocumentReference docRef = await trips
        .doc(tripId)
        .collection('days')
        .doc(dayId)
        .collection('sleepovers')
        .add(a.toJson());
    return docRef.id;
  }

  Future<String> addAttraction(
      String tripId, String dayId, Attraction a) async {
    DocumentReference docRef = await trips
        .doc(tripId)
        .collection('days')
        .doc(dayId)
        .collection('attractions')
        .add(a.toJson());
    return docRef.id;
  }

  Future<String> addTransport(String tripId, String dayId, Transport t) async {
    DocumentReference docRef = await trips
        .doc(tripId)
        .collection('days')
        .doc(dayId)
        .collection('transport')
        .add(t.toJson());
    return docRef.id;
  }

  Future<String> addPhoto(String tripId, String dayId, UploadedPhoto p) async {
    DocumentReference docRef = await trips
        .doc(tripId)
        .collection('days')
        .doc(dayId)
        .collection('photos')
        .add(p.toJson());
    return docRef.id;
  }

  // Future<String> addFileToStorage(String tripId, String dayId, FilePickerResult res) async {
  //   final imageFile = res.files.first;
  //   final toUpload = File(imageFile.path!);
  //   final path = 'files/${imageFile.name}';

  //   final ref = FirebaseStorage.instance.ref().child(path);
  //   final uploadTask =  ref.putFile(toUpload);

  //   final snapshot = await uploadTask!.whenComplete((){});
  //   final urlDownload = await snapshot.ref.getDownloadURL();

  //   return urlDownload;

  // }

  Future<String> addToDoItem(String tripId, ToDoElement e) async {
    DocumentReference docRef =
        await trips.doc(tripId).collection('todo').add(e.toJson());
    return docRef.id;
  }

  Stream<QuerySnapshot> getToDoStream(String tripId) {
    return trips.doc(tripId).collection('todo').snapshots();
  }

  Stream<QuerySnapshot> getAttractionsStream(String tripId, String dayId) {
    return trips
        .doc(tripId)
        .collection('days')
        .doc(dayId)
        .collection('attractions')
        .snapshots();
  }

  Stream<QuerySnapshot> getPhotosStream(String tripId, String dayId) {
    return trips
        .doc(tripId)
        .collection('days')
        .doc(dayId)
        .collection('photos')
        .snapshots();
  }

  Stream<QuerySnapshot> getTransportsStream(String tripId, String dayId) {
    return trips
        .doc(tripId)
        .collection('days')
        .doc(dayId)
        .collection('transport')
        .snapshots();
  }

  Stream<QuerySnapshot> getSleepoversStream(String tripId, String dayId) {
    return trips
        .doc(tripId)
        .collection('days')
        .doc(dayId)
        .collection('sleepovers')
        .snapshots();
  }

  void deleteAttraction(String tripId, String dayId, String attractionId) {
    trips
        .doc(tripId)
        .collection('days')
        .doc(dayId)
        .collection('attractions')
        .doc(attractionId)
        .delete();
  }

  void deleteTransport(String tripId, String dayId, String transportId) {
    trips
        .doc(tripId)
        .collection('days')
        .doc(dayId)
        .collection('transport')
        .doc(transportId)
        .delete();
  }

  void deletePhoto(String tripId, String dayId, String photoId) {
    trips
        .doc(tripId)
        .collection('days')
        .doc(dayId)
        .collection('photos')
        .doc(photoId)
        .delete();
  }

  void deleteSleepover(String tripId, String dayId, String sleepoverId) {
    trips
        .doc(tripId)
        .collection('days')
        .doc(dayId)
        .collection('sleepovers')
        .doc(sleepoverId)
        .delete();
  }

  void markItemAsDone(String tripId, ToDoElement element) async {
    trips.doc(tripId).collection('todo').doc(element.id).delete();
  }

  Future<String> markItemAsUndone(String tripId, ToDoElement element) async {
    trips.doc(tripId).collection('tododone').doc(element.id).delete();
    DocumentReference docRef =
        await trips.doc(tripId).collection('todoundone').add(element.toJson());
    return docRef.id;
  }

  Future<List<Day>> fetchDaysWithAttractions(String tripId) async {
    List<Day> days = [];

    QuerySnapshot daySnapshot = await trips
        .doc(tripId)
        .collection('days')
        .orderBy('dayDate', descending: false)
        .get();

    for (var dayDoc in daySnapshot.docs) {
      Day day = Day.fromJson(dayDoc.data() as Map<String, dynamic>, dayDoc.id);

      QuerySnapshot attractionSnapshot = await trips
          .doc(tripId)
          .collection('days')
          .doc(day.id)
          .collection('attractions')
          .get();

      QuerySnapshot transportSnapshot = await trips
          .doc(tripId)
          .collection('days')
          .doc(day.id)
          .collection('transport')
          .get();

      QuerySnapshot sleepoversSnapshot = await trips
          .doc(tripId)
          .collection('days')
          .doc(day.id)
          .collection('sleepovers')
          .get();

      day.attractions = attractionSnapshot.docs.map((attractionDoc) {
        return Attraction.fromJson(
            attractionDoc.data() as Map<String, dynamic>, attractionDoc.id);
      }).toList();

      day.sleepovers = sleepoversSnapshot.docs.map((sleepoverDoc) {
        return Sleepover.fromJson(
            sleepoverDoc.data() as Map<String, dynamic>, sleepoverDoc.id);
      }).toList();

      day.transport = transportSnapshot.docs.map((transportDoc) {
        return Transport.fromJson(
            transportDoc.data() as Map<String, dynamic>, transportDoc.id);
      }).toList();

      days.add(day);
    }

    return days;
  }
}
