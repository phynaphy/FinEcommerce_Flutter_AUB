
class RegisterRequest {
  final String username;
  final String email;
  final String fullName;
  final String password;
  final String confirmPassword;

  RegisterRequest({
    required this.username,
    required this.email,
    required this.fullName,
    required this.password,
    required this.confirmPassword,
  });

  Map<String, dynamic> toJson() {
    return {
      "username": username,
      "email": email,
      "fullName": fullName,
      "password": password,
      "confirmPassword": confirmPassword,
    };
  }
}

