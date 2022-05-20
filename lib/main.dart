import 'package:baby_binder/firebase_options.dart';
import 'package:baby_binder/providers/app_state.dart';
import 'package:baby_binder/screens/child_selection_page.dart';
import 'package:baby_binder/screens/child_settings_page.dart';
import 'package:baby_binder/screens/child_story_page.dart';
import 'package:baby_binder/screens/labor_tracker_page.dart';
import 'package:baby_binder/screens/login_screen.dart';
import 'package:baby_binder/screens/splash_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await Hive.initFlutter();
  var generalBox = await Hive.openBox('general');
  runApp(
    ProviderScope(
        child: BabyBinder(
      box: generalBox,
    )),
  );
}

class BabyBinder extends ConsumerWidget {
  const BabyBinder({required this.box});
  final Box box;
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appState = ref.watch(appStateProvider);
    appState.context = context;
    final lastPage = box.get('lastPage');
    return MaterialApp(
      title: 'Baby Binder',
      theme: ThemeData(
        colorScheme: ColorScheme.light().copyWith(
          primary: Colors.teal,
        ),
        toggleableActiveColor: Colors.teal,
      ),
      initialRoute: FirebaseAuth.instance.currentUser == null
          ? '/landing'
          : lastPage ?? ChildSelectionPage.routeName,
      routes: {
        '/landing': (context) {
          _updateAuthCallbacks(context, appState);
          return LandingFlow();
        },
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
        LaborTrackerPage.routeName: (context) {
          _updateAuthCallbacks(context, appState);
          return LaborTrackerPage();
        },
      },
    );
  }

  _updateAuthCallbacks(BuildContext context, AppState appState) {
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
      splashMaxDurationInSec: 3,
      onFinished: () => setState(() {
        isSplashOver = true;
      }),
    );
  }
}
