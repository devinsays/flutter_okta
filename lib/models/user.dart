class User {
  final String id;
  final String login;
  final String firstName;
  final String lastName;
  final String locale;
  final String timeZone;

  User(
      {this.id,
      this.login,
      this.firstName,
      this.lastName,
      this.locale,
      this.timeZone});

  Map<String, dynamic> toJson() => {
        'id': id,
        'login': login,
        'firstName': firstName,
        'lastName': lastName,
        'locale': locale,
        'timeZone': timeZone,
      };

  User.fromJson(Map<String, dynamic> data)
      : id = data['id'],
        login = data['login'],
        firstName = data['firstName'],
        lastName = data['lastName'],
        locale = data['locale'],
        timeZone = data['timeZone'];

  User.fromApiResponse(Map<String, dynamic> data)
      : id = data['_embedded']['user']['id'],
        login = data['_embedded']['user']['profile']['login'],
        firstName = data['_embedded']['user']['profile']['firstName'],
        lastName = data['_embedded']['user']['profile']['lastName'],
        locale = data['_embedded']['user']['profile']['locale'],
        timeZone = data['_embedded']['user']['profile']['timeZone'];
}
