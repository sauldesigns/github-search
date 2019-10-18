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
    var darkModeOn = prefs.getBool('darkMode');
    runApp(MyApp(darkmode: darkModeOn));
  });
}

class MyApp extends StatelessWidget {
  final bool darkmode;
  MyApp({this.darkmode});

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
      // theme: ThemeData(
      //   primarySwatch: Colors.grey,
      //   brightness: Brightness.dark,
      // ),
      home: SearchPage(),
    );
  }
}
