import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:github_search/enums/connectivity.dart';
import 'package:github_search/models/repo.dart';
import 'package:github_search/models/user.dart';
import 'package:github_search/pages/repo.dart';
import 'package:github_search/services/github_api.dart';
import 'package:github_search/services/sql_db.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class BookmarksPage extends StatefulWidget {
  BookmarksPage({Key key}) : super(key: key);

  _BookmarksPageState createState() => _BookmarksPageState();
}

class _BookmarksPageState extends State<BookmarksPage> {
  PageController _pageController = PageController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    int _page = 0;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        centerTitle: true,
        elevation: 0.0,
        title: Text('Bookmarks'),
      ),
      bottomNavigationBar: CurvedNavigationBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        color: Colors.black26,
        animationDuration: Duration(milliseconds: 300),
        index: _page,
        items: <Widget>[
          Icon(
            Icons.person,
            size: 30,
          ),
          Icon(FontAwesomeIcons.githubAlt, size: 30),
        ],
        onTap: (index) {
          _pageController.animateToPage(index,
              duration: Duration(milliseconds: 500),
              curve: Curves.easeInOutQuad);
        },
      ),
      body: PageView(controller: _pageController, children: <Widget>[
        BookmarksList(
          queryUser: DBProvider.db.getAllClients(),
          isUser: true,
        ),
        BookmarksList(
          queryRepo: DBProvider.db.getAllRepos(),
          isUser: false,
        ),
      ]),
    );
  }
}

class BookmarksList extends StatelessWidget {
  final Future<List<User>> queryUser;
  final Future<List<Repo>> queryRepo;
  final bool isUser;
  BookmarksList({Key key, this.queryUser, this.queryRepo, this.isUser = true})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: isUser ? queryUser : queryRepo,
      builder: (BuildContext context, snapshot) {
        if (snapshot.hasData) {
          return snapshot.data.length == 0
              ? Center(child: Text('There are no Bookmarks'))
              : ListView.builder(
                  itemCount: snapshot.data.length + 1,
                  itemBuilder: (context, index) {
                    if (index == 0) {
                      return Padding(
                        padding:
                            EdgeInsets.only(left: 15.0, top: 10, right: 15.0),
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              isUser
                                  ? Text(
                                      'Users',
                                      style: TextStyle(fontSize: 20),
                                    )
                                  : Text(
                                      'Repos',
                                      style: TextStyle(fontSize: 20),
                                    ),
                              SizedBox(
                                height: 10,
                              ),
                              Divider(
                                color: Theme.of(context).cursorColor,
                              )
                            ]),
                      );
                    } else {
                      if (isUser) {
                        User userData = snapshot.data[index - 1];
                        return CardData(
                          isUser: true,
                          userData: userData,
                        );
                      } else {
                        Repo repoData = snapshot.data[index - 1];
                        return CardData(
                          isUser: false,
                          repoData: repoData,
                        );
                      }
                    }
                  },
                );
        } else {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }
}

class CardData extends StatelessWidget {
  final NumberFormat numberFormat = NumberFormat.compact();
  final User userData;
  final Repo repoData;
  final bool isUser;

  Future<void> _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      print('error');
    }
  }

  CardData({this.userData, this.repoData, this.isUser = true});
  @override
  Widget build(BuildContext context) {
    GithubApi githubApi = Provider.of<GithubApi>(context);
    ConnectivityStatus connectivity = Provider.of<ConnectivityStatus>(context);
    return Padding(
      padding: const EdgeInsets.only(top: 10.0, bottom: 10.0),
      child: ListTile(
        leading: isUser
            ? Container(
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
              )
            : null,
        title: Text(
          isUser ? userData.username : repoData.fullName,
          style: TextStyle(fontSize: 18),
        ),
        subtitle: isUser
            ? userData.message != 'Error!'
                ? Text(userData.message)
                : Text(userData.bio +
                    '\n' +
                    '# of repositories: ' +
                    numberFormat.format(userData.publicRepos))
            : Text(repoData.description),
        enabled: connectivity == ConnectivityStatus.Offline ? false : true,
        onTap: () async {
          if (userData != null) {
            try {
              await githubApi.setUser(userData);
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
          } else if (repoData != null) {
            _launchURL(repoData.htmlUrl);
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
      ),
    );
  }
}
