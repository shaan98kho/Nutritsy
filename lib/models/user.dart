class User {
  final String uId;
  final String uName;
  final String uEmail;

  final String uTag;

  User({
    required this.uId,
    required this.uName,
    required this.uEmail,
    required this.uTag,
  });

  Map<String, dynamic> toJson() => {
        'id': uId,
        'name': uName,
        'email': uEmail,
        'tag': uTag,
      };

  /*static User fromJson(Map<String, dynamic> json) => User(
        uId: json['id'],
        uName: json['name'],
        uEmail: json['email'],
        uPassword: json['password'],
      );*/
  //display all users, can be used on search

}
