import 'package:baby_binder/models/auth_state.dart';
import 'package:baby_binder/models/auth.dart';
import 'package:baby_binder/models/child_data.dart';
import 'package:baby_binder/screens/child_selection_page.dart';
import 'package:baby_binder/screens/child_settings_page.dart';
import 'package:baby_binder/screens/child_story_page.dart';
import 'package:baby_binder/screens/login_screen.dart';
import 'package:baby_binder/screens/splash_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider<AuthState>(
        create: (context) => AuthState(),
      ),
      ChangeNotifierProvider<ChildData>(
        create: (context) => ChildData(),
      ),
    ],
    child: BabyBinder(),
  ));
}

class BabyBinder extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return Consumer<AuthState>(builder: (context, appState, _) {
      print('appstate');
      print(appState.loginState == ApplicationLoginState.loggedIn);
      appState.context = context;
      return MaterialApp(
        title: 'Baby Binder',
        theme: ThemeData(
            colorScheme: ColorScheme.light().copyWith(
          primary: Colors.teal,
        )),
        home: LandingFlow(),
        routes: {
          LoginScreen.routeName: (context) {
            _updateAuthCallbacks(context, appState);
            return LoginScreen();
          },
          ChildSelectionPage.routeName: (context) {
            _updateAuthCallbacks(context, appState);
            return ChildSelectionPage();
          },
          ChildSettingsPage.routeName: (context) {
            _updateAuthCallbacks(context, appState);
            return ChildSettingsPage();
          },
          ChildStoryPage.routeName: (context) {
            _updateAuthCallbacks(context, appState);
            return ChildStoryPage();
          },
        },
      );
    });
  }

  _updateAuthCallbacks(BuildContext context, AuthState appState) {
    appState.context = context;
  }
}

class LandingFlow extends StatefulWidget {
  @override
  _LandingFlowState createState() => _LandingFlowState();
}

class _LandingFlowState extends State<LandingFlow> {
  bool isSplashOver = false;
  bool hasBoardingScreensShown = true;

  @override
  Widget build(BuildContext context) {
    if (isSplashOver) {
      return StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          }

          if (snapshot.hasData) {
            return ChildSelectionPage();
          } else {
            return LoginScreen();
          }
        },
      );
    }

    return SplashScreen(
      splashDurationInSec: 3,
      onFinished: () => setState(() {
        isSplashOver = true;
      }),
    );
  }
}
