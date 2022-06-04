import 'package:firebase_auth/firebase_auth.dart';
import 'package:ChatGo/services/saveData.dart';

class AuthFunctions {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future signInWithEmailAndPassword(String email, String password) async {
    UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email, password: password);
    return userCredential.credential;
  }

  Future registerWithEmailAndPassword(String email, String password) async {
    UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email, password: password);
    return userCredential;
  }

  Future logout() async {
    try {
      SaveData.saveUserLoggedInPreferences(false);
      SaveData.removeUserNameInPreferences();
      return await _auth.signOut();
    } catch (e) {
      print(e.toString());
    }
  }
}
