import 'package:flutter/material.dart';
import 'package:github_search/models/repo.dart';
import 'package:github_search/services/github_api.dart';
import 'package:provider/provider.dart';

class RepoListPage extends StatefulWidget {
  RepoListPage({Key key}) : super(key: key);

  _RepoListPageState createState() => _RepoListPageState();
}

class _RepoListPageState extends State<RepoListPage> {
  @override
  Widget build(BuildContext context) {
    GithubApi githubApi = Provider.of<GithubApi>(context);
    List<Repo> repos = githubApi.getRepo;

    return SafeArea(
      child: Scaffold(
        backgroundColor: Color.fromRGBO(31, 26, 36, 1),
        body: repos == null
            ? Center(
                child: CircularProgressIndicator(),
              )
            : repos.length == 0
                ? Center(
                    child: Text('User has no repos.',
                        style: TextStyle(fontSize: 20.0)),
                  )
                : ListView.builder(
                    itemCount: repos.length,
                    itemBuilder: (context, index) {
                      Repo repo = repos[index];
                      return Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Container(
                          decoration: BoxDecoration(
                            color: Color.fromRGBO(51, 41, 64, 1),
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                              color: Colors.black,
                              width: 1,
                            ),
                          ),
                          child: ListTile(
                            title: Text(repo.fullName),
                            subtitle: Text(repo.description),
                          ),
                        ),
                      );
                    },
                  ),
      ),
    );
  }
}
