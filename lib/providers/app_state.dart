import 'package:baby_binder/providers/hive_provider.dart';
import 'package:baby_binder/screens/child_selection_page.dart';
import 'package:baby_binder/screens/login_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:google_fonts/google_fonts.dart';

import 'auth.dart';

final appStateProvider = ChangeNotifierProvider((ref) {
  final hiveBox = ref.watch(hiveProvider).asData?.value;
  return AppState(hiveBox);
});
final FirebaseFirestore firestore = FirebaseFirestore.instance;

class AppState extends ChangeNotifier {
  AppState(this.hive) {
    init();
  }
  HiveDB? hive;

  BuildContext? context;
  Future<void> init() async {
    FirebaseAuth.instance.userChanges().listen((user) {
      if (user != null) {
        _loginState = ApplicationLoginState.loggedIn;
      } else {
        _loginState = ApplicationLoginState.loggedOut;
      }
      notifyListeners();
    });
  }

  void Function() loginSuccessCallback = () {};
  ApplicationLoginState _loginState = ApplicationLoginState.loggedOut;
  ApplicationLoginState get loginState => _loginState;

  String? _email;
  String? get email => _email;

  void navigateToPage(BuildContext context, String route) {
    hive?.updateLastPage(route);
    Navigator.of(context).pushNamed(route);
  }

  void startLoginFlow() {
    _loginState = ApplicationLoginState.emailAddress;
    notifyListeners();
  }

  void verifyEmail(
    String email,
    void Function(FirebaseAuthException e) errorCallback,
  ) async {
    try {
      var methods =
          await FirebaseAuth.instance.fetchSignInMethodsForEmail(email);
      if (methods.contains('password')) {
        _loginState = ApplicationLoginState.password;
      } else {
        _loginState = ApplicationLoginState.register;
      }
      _email = email;
      notifyListeners();
    } on FirebaseAuthException catch (e) {
      errorCallback(e);
    }
  }

  void signInWithEmailAndPassword(
    BuildContext context,
    String email,
    String password,
    void Function() successCallback,
    void Function(FirebaseAuthException e) errorCallback,
  ) async {
    this.context = context;
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      navigateToPage(context, ChildSelectionPage.routeName);
    } on FirebaseAuthException catch (e) {
      errorCallback(e);
    }
  }

  void cancelRegistration() {
    _loginState = ApplicationLoginState.emailAddress;
    notifyListeners();
  }

  void registerAccount(
      BuildContext context,
      String email,
      String displayName,
      String password,
      void Function(FirebaseAuthException e) errorCallback) async {
    this.context = context;
    try {
      var credential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);
      await credential.user!.updateDisplayName(displayName);

      await firestore.collection('users').doc(credential.user!.uid).set({
        'name': displayName,
        'children': [],
        'email': email,
      });
      navigateToPage(context, ChildSelectionPage.routeName);
    } on FirebaseAuthException catch (e) {
      errorCallback(e);
    }
  }

  void signOut(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
    Navigator.of(context).pushReplacementNamed(LoginScreen.routeName);
  }
}
