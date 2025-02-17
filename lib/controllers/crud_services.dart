import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class CrudServices {
  //  save FCM tocken to firestore
  static Future saveUserToken(String token) async {
    User? user = FirebaseAuth.instance.currentUser;

    Map<String, dynamic> data = {
      "email": user!.email,
      "token": token,
    };
    try {
      await FirebaseFirestore.instance
          .collection("user_data")
          .doc(user.uid)
          .set(data);
      print("Print document addedddddddddddddddddddddddddd ${user.uid}");
    } catch (e) {
      print("error in storing the document");
      print(e.toString());
    }
  }
}
