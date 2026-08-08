
class RegisterResponse {
  final String message;
  final bool success;

  RegisterResponse({
    required this.message,
    required this.success,
  });

  factory RegisterResponse.fromJson(Map<String, dynamic> json) {
    return RegisterResponse(
      message: json["message"] ?? "",
      success: json["success"] ?? false,
    );
  }
}

