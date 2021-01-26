// import 'package:firebase_auth/firebase_auth.dart';
//
// class AuthService {
//   final FirebaseAuth _auth = FirebaseAuth.instance;
//
//   Future signInAnon() async {
//     try {
//       UserCredential userCred = await _auth.signInAnonymously();
//       dynamic user = userCred.user;
//       if (user != null) {
//         print('User signed in anonymously.');
//         return user;
//       } else {
//         //TODO: handle a null return
//         return null;
//       }
//       //      return user;
//     } catch (e) {
//       //TODO: handle error
//       print(e);
//       return null;
//     }
//   }
// }
