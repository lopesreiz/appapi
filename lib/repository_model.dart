class Repository {
  String? name, user, avatar, description;

  Repository({
    this.name,
    this.user,
    this.avatar,
    this.description,
  });

  Repository.fromJson(Map<String, dynamic> json) {
    name = json['full_name'];
    user = json['owner']['login'];
    avatar = json['owner']['avatar_url'];
    description = json['description'];
  }
}