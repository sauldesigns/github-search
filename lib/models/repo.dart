class Repo {
  final String name;
  final String fullName;
  final String htmlUrl;
  final String description;
  final String repoUrl;
  final String commitsUrl;
  final String createdAt;
  final String pushedAt;
  final String updatedAt;
  final String gitUrl;
  final String sshUrl;
  final String cloneUrl;
  final int forksCount;
  final int watchers;

  Repo({
    this.name,
    this.fullName,
    this.htmlUrl,
    this.description,
    this.repoUrl,
    this.commitsUrl,
    this.createdAt,
    this.pushedAt,
    this.updatedAt,
    this.gitUrl,
    this.sshUrl,
    this.cloneUrl,
    this.forksCount,
    this.watchers,
  });

  factory Repo.fromJson(Map<String, dynamic> json) {
    return Repo(
      name: json['name'] ?? '...',
      fullName: json['full_name'] ?? '...',
      htmlUrl: json['html_url'],
      description: json['description'] ?? 'no description',
      repoUrl: json['url'],
      commitsUrl: json['commits_url'],
      createdAt: json['created_at'],
      pushedAt: json['pushed_at'],
      updatedAt: json['updated_at'],
      gitUrl: json['git_url'],
      cloneUrl: json['clone_url'],
      sshUrl: json['ssh_url'],
      forksCount: json['forks_count'] ?? 0,
      watchers: json['watchers'] ?? 0,
    );
  }
}
