class Login {
    String username;
    int password;

    Login({required this.username, required this.password});

    factory Login.fromJson(Map<String, dynamic> json){
      return Login(
        username: json['username'],
         password: json['password']);
    }

      Map<String, dynamic> toJson() {
    return {
      'username': username,
      'phone': password,
    };
  }
}