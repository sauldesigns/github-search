import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:github_search/models/user.dart';
import 'package:github_search/pages/repo.dart';
import 'package:github_search/services/github_api.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class SearchPage extends StatefulWidget {
  SearchPage({Key key}) : super(key: key);

  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  String searchValue = '';
  User userData;
  final NumberFormat numberFormat = NumberFormat.compact();

  void searchUser(GithubApi githubApi, String searchValue, String category) {
    githubApi.fetchUserData(
      query: searchValue,
      category: category,
    );
  }

  @override
  Widget build(BuildContext context) {
    GithubApi githubApi = Provider.of<GithubApi>(context);
    User userData = githubApi.getUser;
    return Scaffold(
      backgroundColor: Color.fromRGBO(31, 26, 36, 1),
      body: Center(
        child: ListView(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(bottom: 50.0),
              child: Center(
                child: Text(
                  'Github',
                  style: TextStyle(
                    fontSize: 50,
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 50.0, right: 50.0),
              child: Center(
                child: Container(
                  decoration: BoxDecoration(
                    color: Color.fromRGBO(51, 41, 64, 1),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: Colors.black,
                      width: 1,
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: TextField(
                      autofocus: true,
                      cursorColor: Colors.white,
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.white,
                      ),
                      autocorrect: false,
                      textAlign: TextAlign.center,
                      decoration: InputDecoration(
                          border: InputBorder.none,
                          suffixIcon: IconButton(
                            icon: githubApi.isFetching == true
                                ? SpinKitChasingDots(
                                    color: Colors.white,
                                    size: 25,
                                  )
                                : Icon(Icons.check_circle),
                            color: searchValue == ''
                                ? Colors.white24
                                : Colors.greenAccent,
                            splashColor: Colors.transparent,
                            onPressed: () {
                              searchUser(githubApi, searchValue, 'users');
                            },
                          ),
                          hintText: 'Search username'),
                      onChanged: (value) {
                        setState(() {
                          searchValue = value;
                        });
                      },
                      onSubmitted: (_) {
                        searchUser(githubApi, searchValue, 'users');
                      },
                    ),
                  ),
                ),
              ),
            ),
            (githubApi.hasData == true && githubApi.isFetching == false)
                ? Padding(
                    padding: const EdgeInsets.all(50.0),
                    child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white12,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: Colors.black,
                            width: 1,
                          ),
                        ),
                        child: ListTile(
                          leading: CircleAvatar(
                            radius: 20,
                            backgroundImage: NetworkImage(userData.avatar),
                          ),
                          title: Text(
                            userData.username,
                            style: TextStyle(fontSize: 18),
                          ),
                          subtitle: Text(userData.bio +
                              '\n' +
                              '# of repositories: ' +
                              numberFormat.format(userData.publicRepos)),
                          onTap: () {
                            if (userData.reposUrl != null) {
                              try {
                                githubApi.fetchRepoData(
                                    query: userData.reposUrl);
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
                                message:
                                    'Error!',
                                icon: Icon(
                                  Icons.error,
                                  color: Colors.red,
                                ),
                              )..show(context);
                            }
                          },
                        )),
                  )
                : Container(),
          ],
        ),
      ),
    );
  }
}
