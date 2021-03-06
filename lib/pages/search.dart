import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:github_search/enums/connectivity.dart';
import 'package:github_search/models/user.dart';
import 'package:github_search/pages/bookmarks.dart';
import 'package:github_search/pages/repo.dart';
import 'package:github_search/services/github_api.dart';
import 'package:github_search/services/nightmode.dart';
import 'package:github_search/services/sql_db.dart';
import 'package:github_search/services/theme.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SearchPage extends StatefulWidget {
  SearchPage({Key key}) : super(key: key);

  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  String searchValue = '';
  User userData;
  var _darkTheme = true;
  DBProvider db;
  final NumberFormat numberFormat = NumberFormat.compact();
  void searchUser(GithubApi githubApi, String searchValue, String category) {
    githubApi.fetchUserData(
      query: searchValue,
      category: category,
    );
  }

  void onThemeChanged(bool value, ThemeNotifier themeNotifier) async {
    (value)
        ? themeNotifier.setTheme(darkTheme)
        : themeNotifier.setTheme(lightTheme);
    var prefs = await SharedPreferences.getInstance();
    prefs.setBool('darkMode', value);
  }

  @override
  void initState() {
    super.initState();
    DBProvider.db.initDB();
  }

  @override
  Widget build(BuildContext context) {
    GithubApi githubApi = Provider.of<GithubApi>(context);
    User userData = githubApi.getUser;
    ConnectivityStatus connectivity = Provider.of<ConnectivityStatus>(context);
    final themeNotifier = Provider.of<ThemeNotifier>(context);
    _darkTheme = (themeNotifier.getTheme() == darkTheme);
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        brightness: Theme.of(context).brightness,
        centerTitle: true,
        elevation: 0.0,
        actions: <Widget>[
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: FlatButton(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)),
              onPressed: () {
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => BookmarksPage()));
              },
              child: Text('Bookmarks'),
            ),
          )
        ],
      ),
      body: Center(
        child: ListView(
          shrinkWrap: true,
          physics: ScrollPhysics(),
          children: <Widget>[
            LogoWidget(
              darkTheme: _darkTheme,
              themeNotifier: themeNotifier,
              onThemeChanged: onThemeChanged,
            ),
            connectivity == ConnectivityStatus.Offline
                ? Padding(
                    padding: const EdgeInsets.only(bottom: 20.0),
                    child: Center(
                      child: Text(
                        'Device is Offline',
                        style: TextStyle(fontSize: 20, color: Colors.red),
                      ),
                    ),
                  )
                : Container(),
            SearchBar(
              connectivity: connectivity,
              githubApi: githubApi,
            ),
            (githubApi.hasData == true && githubApi.isFetching == false)
                ? resultCard(
                    connectivity: connectivity,
                    githubApi: githubApi,
                    userData: userData)
                : Container(),
          ],
        ),
      ),
    );
  }

  Widget resultCard(
      {ConnectivityStatus connectivity, GithubApi githubApi, User userData}) {
    return Padding(
      padding: const EdgeInsets.all(50.0),
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: Colors.black,
            width: 1,
          ),
        ),
        child: ListTile(
          leading: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(50),
              boxShadow: [
                BoxShadow(
                    blurRadius: 5.0,
                    color: Colors.black45,
                    spreadRadius: 1,
                    offset: Offset(1, 3)),
              ],
            ),
            child: CircleAvatar(
              radius: 20,
              backgroundImage: NetworkImage(userData.avatar),
            ),
          ),
          title: Text(
            userData.username,
            style: TextStyle(fontSize: 18),
          ),
          subtitle: userData.message != 'Error!'
              ? Text(userData.message)
              : Text(userData.bio +
                  '\n' +
                  '# of repositories: ' +
                  numberFormat.format(userData.publicRepos)),
          enabled: connectivity == ConnectivityStatus.Offline ? false : true,
          onTap: () async {
            if (userData != null) {
              try {
                await githubApi.fetchRepoData(
                  query: userData.reposUrl,
                );
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => RepoListPage(),
                  ),
                );
              } catch (e) {
                print(e);
              }
            } else {
              Flushbar(
                flushbarPosition: FlushbarPosition.TOP,
                margin: EdgeInsets.all(8.0),
                borderRadius: 10,
                duration: Duration(seconds: 5),
                message: userData.message,
                icon: Icon(
                  Icons.error,
                  color: Colors.red,
                ),
              )..show(context);
            }
          },
          onLongPress: () async {
            DBProvider.db.newClient(githubApi.user);
            Flushbar(
              flushbarPosition: FlushbarPosition.TOP,
              margin: EdgeInsets.all(8.0),
              borderRadius: 10,
              duration: Duration(seconds: 3),
              message: 'User has been added to bookmarks',
              icon: Icon(
                Icons.check_circle,
                color: Colors.green,
              ),
            )..show(context);
          },
        ),
      ),
    );
  }
}

class SearchBar extends StatefulWidget {
  SearchBar({Key key, this.connectivity, this.githubApi}) : super(key: key);
  final ConnectivityStatus connectivity;
  final GithubApi githubApi;
  @override
  _SearchBarState createState() => _SearchBarState();
}

class _SearchBarState extends State<SearchBar> {
  String searchValue = '';
  void searchUser(GithubApi githubApi, String searchValue, String category) {
    githubApi.fetchUserData(
      query: searchValue,
      category: category,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 50.0, right: 50.0),
      child: Center(
        child: Container(
          decoration: BoxDecoration(
            color: Theme.of(context).dialogBackgroundColor,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: Colors.black,
              width: 1,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(5.0),
            child: TextField(
              enabled: widget.connectivity == ConnectivityStatus.Offline
                  ? false
                  : true,
              autofocus: false,
              cursorColor: Theme.of(context).cursorColor,
              style: Theme.of(context).textTheme.title,
              autocorrect: false,
              textAlign: TextAlign.center,
              decoration: InputDecoration(
                  border: InputBorder.none,
                  suffixIcon: IconButton(
                    highlightColor: Colors.transparent,
                    icon: widget.githubApi.isFetching == true
                        ? SpinKitChasingDots(
                            color: Theme.of(context).cursorColor,
                            size: 25,
                          )
                        : Icon(Icons.check_circle),
                    color: searchValue == '' ? Colors.grey : Colors.green,
                    splashColor: Colors.transparent,
                    onPressed: widget.connectivity == ConnectivityStatus.Offline
                        ? null
                        : () {
                            if (searchValue != '') {
                              searchUser(
                                  widget.githubApi, searchValue, 'users');
                            }
                          },
                  ),
                  hintText: 'Search username'),
              onChanged: (value) {
                setState(() {
                  searchValue = value;
                });
              },
              onSubmitted: (_) {
                if (searchValue != '') {
                  searchUser(widget.githubApi, searchValue, 'users');
                }
              },
            ),
          ),
        ),
      ),
    );
  }
}

class LogoWidget extends StatelessWidget {
  final Function onThemeChanged;
  final bool darkTheme;
  final themeNotifier;
  const LogoWidget(
      {Key key, this.onThemeChanged, this.darkTheme = true, this.themeNotifier})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(bottom: 10.0),
          child: Center(
            child: GestureDetector(
              onDoubleTap: () {
                onThemeChanged(!darkTheme, themeNotifier);
              },
              child: Icon(
                FontAwesomeIcons.github,
                size: 80,
              ),
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.only(top: 20.0, bottom: 20.0),
          child: Center(
            child: Text(
              'Search',
              style: TextStyle(fontSize: 20),
            ),
          ),
        ),
      ],
    );
  }
}
