import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  static final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  static String verifyId = "";

  // to sent and otp to user
  static Future sentOtp({
    required String phone,
    required Function errorStep,
    required Function nextStep,
  }) async {
    await _firebaseAuth
        .verifyPhoneNumber(
      timeout: Duration(seconds: 60),
      phoneNumber: "+91$phone",
      verificationCompleted: (phoneAuthCredential) async {
        return;
      },
      verificationFailed: (error) async {
        return;
      },
      codeSent: (verificationId, forceResendingToken) async {
        verifyId = verificationId;
        nextStep();
      },
      codeAutoRetrievalTimeout: (verificationId) async {
        return;
      },
    )
        .onError((error, stackTrace) {
      errorStep();
    });
  }

  // verify the otp code and login
  static Future loginWithOtp({required String otp}) async {
    final cred =
    PhoneAuthProvider.credential(verificationId: verifyId, smsCode: otp);

    try {
      final user = await _firebaseAuth.signInWithCredential(cred);
      if (user.user != null) {
        return "Success";
      } else {
        return "Error in Otp login";
      }
    } on FirebaseAuthException catch (e) {
      return e.message.toString();
    } catch (e) {
      return e.toString();
    }
  }

  static Future<bool> isLoggedIn() async {
    var user = _firebaseAuth.currentUser;
    return user != null;
  }

  Future<void> saveUserData({
    required String name,
    required String phoneNumber,
    required String stylistName,
    required DateTime selectedDate,
    required List<String> selectedTimeSlots,
  }) async {
    try {
      await FirebaseFirestore.instance.collection('users').add({
        'name': name,
        'phoneNumber': phoneNumber,
        'stylistname' : stylistName,
        'selectedDate': selectedDate,
        'selectedTimeSlots': selectedTimeSlots,

      });
    } catch (e) {
      print("Error saving user data: $e");
    }
  }
}