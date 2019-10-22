import 'package:flutter/material.dart';
import 'package:github_search/enums/connectivity.dart';
import 'package:github_search/pages/search.dart';
import 'package:github_search/services/connectivity.dart';
import 'package:github_search/services/github_api.dart';
import 'package:github_search/services/nightmode.dart';
import 'package:github_search/services/theme.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences.getInstance().then((prefs) {
    bool darkModeOn = prefs.getBool('darkMode');
    runApp(MyApp(darkmode: darkModeOn));
  });
}

class MyApp extends StatefulWidget {
  MyApp({Key key, this.darkmode}) : super(key: key);
  final bool darkmode;
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool darkmode = true;
  @override
  void initState() {
    super.initState();
    darkmode = widget.darkmode ?? true;
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<GithubApi>(
          builder: (_) => GithubApi(),
        ),
        StreamProvider<ConnectivityStatus>.controller(
          builder: (context) =>
              ConnectivityService().connectionStatusController,
        ),
        ChangeNotifierProvider<ThemeNotifier>(
          builder: (_) => ThemeNotifier(darkmode ? darkTheme : lightTheme),
        ),
      ],
      child: MainWidget(),
    );
  }
}

class MainWidget extends StatelessWidget {
  const MainWidget({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ThemeNotifier usertheme = Provider.of<ThemeNotifier>(context);
    return MaterialApp(
      title: 'Github Search',
      debugShowCheckedModeBanner: false,
      theme: usertheme.getTheme(),
      home: SearchPage(),
    );
  }
}
