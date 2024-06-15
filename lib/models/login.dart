class Login {
    String username;
    int phone;

    Login({required this.username, required this.phone});

    factory Login.fromJson(Map<String, dynamic> json){
      return Login(
        username: json['username'],
         phone: json['phone']);
    }

      Map<String, dynamic> toJson() {
    return {
      'username': username,
      'phone': phone,
    };
  }
}