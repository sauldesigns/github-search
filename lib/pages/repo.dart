import 'package:flutter/material.dart';
import 'package:github_search/models/repo.dart';
import 'package:github_search/models/user.dart';
import 'package:github_search/services/github_api.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class RepoListPage extends StatefulWidget {
  RepoListPage({Key key}) : super(key: key);

  _RepoListPageState createState() => _RepoListPageState();
}

class _RepoListPageState extends State<RepoListPage> {
  @override
  Widget build(BuildContext context) {
    GithubApi githubApi = Provider.of<GithubApi>(context);
    List<Repo> repos = githubApi.getRepo;
    User userData = githubApi.user;
    double avatarRadius = 40;

    Future<void> _launchURL(String url) async {
      if (await canLaunch(url)) {
        await launch(url);
      } else {
        print('error');
      }
    }

    return Scaffold(
      backgroundColor: Color.fromRGBO(31, 26, 36, 1),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        centerTitle: true,
        title: Text('Repos'),
      ),
      body: repos == null
          ? Center(
              child: CircularProgressIndicator(),
            )
          : repos.length == 0
              ? Center(
                  child: Text('User has no repos.',
                      style: TextStyle(fontSize: 20.0)),
                )
              : Column(children: [
                  Padding(
                    padding: const EdgeInsets.only(
                        top: 20.0, left: 40.0, right: 40.0, bottom: 20.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(50),
                            boxShadow: [
                              BoxShadow(
                                  blurRadius: 10.0,
                                  color: Colors.black87,
                                  spreadRadius: 3,
                                  offset: Offset(1, 2)),
                            ],
                          ),
                          child: InkWell(
                            splashColor: Colors.transparent,
                            focusColor: Colors.transparent,
                            highlightColor: Colors.transparent,
                            onTap: () {
                              _launchURL(userData.htmlUrl);
                            },
                            onTapDown: (_) {
                              setState(() {
                                avatarRadius = 50;
                              });
                            },
                            child: CircleAvatar(
                              radius: avatarRadius,
                              backgroundImage: NetworkImage(userData.avatar),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 20.0,
                        ),
                        Expanded(
                          child: Column(
                            children: <Widget>[
                              Text(
                                userData.name,
                                style: TextStyle(fontSize: 25),
                              ),
                              SizedBox(
                                height: 10.0,
                              ),
                              Text(
                                userData.bio,
                                style: TextStyle(fontSize: 13),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                  Expanded(
                    child: ListView.builder(
                      shrinkWrap: true,
                      padding: EdgeInsets.only(top: 0.0, bottom: 20.0),
                      itemCount: repos.length,
                      itemBuilder: (context, index) {
                        Repo repo = repos[index];
                        return Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Container(
                            decoration: BoxDecoration(
                              color: Color.fromRGBO(51, 41, 64, 0.8),
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                color: Colors.black,
                                width: 1,
                              ),
                            ),
                            child: ListTile(
                              title: Text(repo.fullName),
                              subtitle: Text(repo.description),
                              onTap: () {
                                _launchURL(repo.htmlUrl);
                              },
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ]),
    );
  }
}
