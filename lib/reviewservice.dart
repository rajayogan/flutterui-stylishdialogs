import 'package:cloud_firestore/cloud_firestore.dart';

class ReviewService {
  getAllReviews() {
    return Firestore.instance.collection('reviews').getDocuments();
  }
}
