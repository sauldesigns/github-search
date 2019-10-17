class User {
  final String username;
  final String avatar;
  final String htmlUrl;
  final String followersUrl;
  final String followingUrl;
  final String starredUrl;
  final String subscriptionUrl;
  final String organizationsUrl;
  final String reposUrl;
  final String eventsUrl;
  final String name;
  final String company;
  final String bio;
  final String blog;
  final int publicRepos;
  final String message;
  final int id;

  User({
    this.id,
    this.username,
    this.avatar,
    this.htmlUrl,
    this.followersUrl,
    this.bio,
    this.followingUrl,
    this.starredUrl,
    this.subscriptionUrl,
    this.organizationsUrl,
    this.reposUrl,
    this.eventsUrl,
    this.name,
    this.company,
    this.blog,
    this.publicRepos,
    this.message,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] ?? 0,
      username: json['login'] ?? 'Error loading data',
      avatar: json['avatar_url'] ?? 'https://github.githubassets.com/images/modules/logos_page/GitHub-Mark.png',
      htmlUrl: json['html_url'],
      followersUrl: json['followers_url'],
      followingUrl: json['following_url'],
      starredUrl: json['starred_url'],
      subscriptionUrl: json['subscriptions_url'],
      organizationsUrl: json['organizations_url'],
      reposUrl: json['repos_url'],
      eventsUrl: json['events_url'],
      name: json['name'] ?? '...',
      company: json['company'] ?? '...',
      blog: json['blog'] ?? '..',
      bio: json['bio'] ?? '...',
      publicRepos: json['public_repos'] ?? 0,
      message: json['message'] ?? 'Error!',
    );
  }

  Map<String, dynamic> toMap() => {
      'id': id,
      'username': username,
      'avatar': avatar,
      'htmlUrl': htmlUrl,
      'followersUrl': followersUrl,
      'followingUrl': followingUrl,
      'starredUrl': starredUrl,
      'subscriptionUrl': subscriptionUrl,
      'organizationsUrl': organizationsUrl,
      'reposUrl': reposUrl,
      'eventsUrl': eventsUrl,
      'name': name,
      'company': company,
      'blog': blog,
      'bio': bio,
      'publicRepos': publicRepos,
      };
}
