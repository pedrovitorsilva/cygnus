import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
//  My packages
import 'package:cygnus/pages/main_feed.dart';
import 'package:cygnus/state.dart';
import 'package:cygnus/pages/product.dart';

void main() {
  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (_) => StateApp(),
        child: MaterialApp(
          title: "Cygnus Games",
          theme: ThemeData(
              colorScheme: const ColorScheme.dark(), useMaterial3: true),
          home: const Screen(),
        ));
  }
}

class Screen extends StatefulWidget {
  const Screen({super.key});

  @override
  State<Screen> createState() => _ScreenState();
}

class _ScreenState extends State<Screen> {
  void _showAsPortrait() {
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  }

  @override
  Widget build(BuildContext context) {
    _showAsPortrait();

    stateApp = context.watch<StateApp>();

    Widget screen = const SizedBox.shrink();
    if (stateApp.situation  == Situation.showingMainFeed) {
      screen = const MainFeed();
    } else if (stateApp.situation== Situation.showingProduct) {
      screen = const Product();
    }

    return screen;
  }
}
