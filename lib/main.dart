import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:firebase_ui_oauth_google/firebase_ui_oauth_google.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (BuildContext context, AsyncSnapshot<User?> snapshot) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Wordel',
            theme: ThemeData(
              colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
              useMaterial3: true,
            ),
            initialRoute: snapshot.data == null ? '/sign-in' : '/', // Navigate based on auth state, // default route
            routes: {
              '/': (context) => const WordelHome(title: 'Wordel'),
              '/sign-in': (context) => SignInScreen(
                    providers: [
                      GoogleProvider(clientId: '912729450201-umenofau95dm57hbe1ughqkfh1agan4m.apps.googleusercontent.com'),
                    ],
                    actions: [
                      AuthStateChangeAction<SignedIn>((context, state) {
                        Navigator.pushReplacementNamed(context, '/');
                      }),
                    ],
                  ),
            },
          );
        });
  }
}

class WordelHome extends StatefulWidget {
  const WordelHome({super.key, required this.title});

  final String title;

  @override
  State<WordelHome> createState() => _WordelHomeState();
}

class _WordelHomeState extends State<WordelHome> {
  User? user = FirebaseAuth.instance.currentUser;

//---------------- State Management ----------------
  //int _counter = 0;

  // void _incrementCounter() {
  //   setState(() {
  //     //_counter++;
  //   });
  // }
//---------------- State Management ----------------

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary.withOpacity(0.7),
        leading: IconButton(
          icon: const Icon(Icons.menu),
          tooltip: 'Menu',
          onPressed: () {
            const SnackBar(
              content: Text('Menu'),
            );
          },
        ),
        title: Center(
          child: Text(
            widget.title,
            style: GoogleFonts.rancho(
              fontSize: 32,
              fontWeight: FontWeight.w300,
              color: Colors.black,
            ),
          ),
        ),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.settings),
            tooltip: 'Settings',
            onPressed: () {
              const SnackBar(
                content: Text('Settings'),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.person),
            tooltip: 'Account',
            onPressed: () {
              const SnackBar(
                content: Text('Account'),
              );
            },
          ),
        ],
      ),
      body: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
        ),
        child: Text(user?.displayName ?? 'No user signed in.'),
      ),
    );
  }
}
