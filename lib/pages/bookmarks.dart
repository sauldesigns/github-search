import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:github_search/enums/connectivity.dart';
import 'package:github_search/models/user.dart';
import 'package:github_search/pages/repo.dart';
import 'package:github_search/services/github_api.dart';
import 'package:github_search/services/sql_db.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class BookmarksPage extends StatefulWidget {
  BookmarksPage({Key key}) : super(key: key);

  _BookmarksPageState createState() => _BookmarksPageState();
}

class _BookmarksPageState extends State<BookmarksPage> {
  final NumberFormat numberFormat = NumberFormat.compact();
  @override
  Widget build(BuildContext context) {
    GithubApi githubApi = Provider.of<GithubApi>(context);
    ConnectivityStatus connectivity = Provider.of<ConnectivityStatus>(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        centerTitle: true,
        title: Text('Bookmarks'),
      ),
      body: FutureBuilder(
        future: DBProvider.db.getAllClients(),
        builder: (BuildContext context, AsyncSnapshot<List<User>> snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
              itemCount: snapshot.data.length,
              itemBuilder: (context, index) {
                User userData = snapshot.data[index];
                return Padding(
                  padding: const EdgeInsets.only(top: 10.0, bottom: 10.0),
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
                    enabled: connectivity == ConnectivityStatus.Offline
                        ? false
                        : true,
                    onTap: () async {
                      if (userData.reposUrl != null) {
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
              },
            );
          } else {
            return CircularProgressIndicator();
          }
        },
      ),
    );
  }
}
