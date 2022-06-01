class Token {
  String? access;
  String? id;

  Token({this.access, this.id, });

  Token.fromMap(Map json) {
    access = json['access_token'];
    id = json['id'];
  }
}
