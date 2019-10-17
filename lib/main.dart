import 'package:flutter/material.dart';
import 'package:github_search/enums/connectivity.dart';
import 'package:github_search/pages/search.dart';
import 'package:github_search/services/connectivity.dart';
import 'package:github_search/services/github_api.dart';
import 'package:github_search/services/nightmode.dart';
import 'package:github_search/services/theme.dart';
import 'package:provider/provider.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
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
          builder: (_) => ThemeNotifier(darkTheme),
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
