import 'package:flutter/material.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:zenin_motivating/pages/motivating_page.dart';
import 'package:json_theme/json_theme.dart';
import 'package:flutter/services.dart'; // For rootBundle
import 'dart:convert'; // For jsonDecode

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final themeStr = await rootBundle.loadString('lib/assets/appainter_theme.json');
  final themeJson = jsonDecode(themeStr);
  final theme = ThemeDecoder.decodeThemeData(themeJson)!;

  runApp(MyApp(theme: theme));
}

class MyApp extends StatefulWidget {
   final ThemeData theme;

  const MyApp({Key? key, required this.theme}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      home: const MyHomePage(title: 'ZenInMotivating'),
      theme: widget.theme,
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final pages = [
    PageViewModel(
      title: "Inspire yourself",
      bodyWidget: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [
          Text("Your new fav App "),
        ],
      ),
      image: const Center(child: Icon(Icons.lightbulb)),
    ),
    PageViewModel(
      title: "Discover",
      bodyWidget: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [
          Text("Get started and ready to get motivated!"),
        ],
      ),
      image: const Center(child: Icon(Icons.book_rounded)),
    )
  ];

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
          child: IntroductionScreen(
              pages: pages,
              allowImplicitScrolling: true,
              showNextButton: true,
              showSkipButton: true,
              next: const Icon(Icons.arrow_forward),
              skip: const Text('Skip', style: TextStyle(fontWeight: FontWeight.w600)),
              done: const Text("Get Motivated"),
              onDone: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const MotivatingPage()),
                );
              })), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
