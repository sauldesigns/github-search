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
  final String blog;

  User({
    this.username,
    this.avatar,
    this.htmlUrl,
    this.followersUrl,
    this.followingUrl,
    this.starredUrl,
    this.subscriptionUrl,
    this.organizationsUrl,
    this.reposUrl,
    this.eventsUrl,
    this.name,
    this.company,
    this.blog,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      username: json['login'],
      avatar: json['avatar_url'],
      htmlUrl: json['html_url'],
      followersUrl: json['followers_url'],
      followingUrl: json['following_url'],
      starredUrl: json['starred_url'],
      subscriptionUrl: json['subscriptions_url'],
      organizationsUrl: json['organizations_url'],
      reposUrl: json['repos_url'],
      eventsUrl: json['events_url'],
      name: json['name'],
      company: json['company'],
      blog: json['blog'],
    );
  }
}
