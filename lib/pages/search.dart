import 'package:flutter/material.dart';
import 'package:github_search/models/user.dart';
import 'package:github_search/services/github_api.dart';
import 'package:provider/provider.dart';

class SearchPage extends StatefulWidget {
  SearchPage({Key key}) : super(key: key);

  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  String searchValue = '';
  User userData;

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
                            icon: Icon(Icons.check_circle),
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
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: githubApi.hasData == true
                  ? ListTile(
                      leading: CircleAvatar(
                        backgroundImage: NetworkImage(userData.avatar),
                      ),
                      title: Text(userData.username),
                    )
                  : Container(),
            ),
          ],
        ),
      ),
    );
  }
}
