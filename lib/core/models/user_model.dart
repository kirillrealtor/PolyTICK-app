/// User model — equivalent of the user object in AuthContext.
/// Fields extracted from JWT claims via jwtDecode().
class UserModel {
  final String email;
  final String? photoURL;
  final bool isVerified;
  final String? fullName;
  final int? createdAt; // Unix timestamp

  const UserModel({
    required this.email,
    this.photoURL,
    this.isVerified = false,
    this.fullName,
    this.createdAt,
  });

  /// Create from JWT decoded payload (matches AuthContext.js field mapping).
  factory UserModel.fromJwt(Map<String, dynamic> claims) {
    int? parseTimestamp(dynamic val) {
      if (val == null) return null;
      if (val is int) return val;
      if (val is num) return val.toInt();
      if (val is String) return int.tryParse(val);
      return null;
    }

    return UserModel(
      email: (claims['sub'] ?? claims['email'] ?? '') as String? ?? '',
      photoURL: claims['picture']?.toString(),
      isVerified: claims['is_verified'] == true || claims['email_verified'] == true,
      fullName: (claims['full_name'] ?? claims['name'])?.toString(),
      createdAt: parseTimestamp(claims['created_at'] ?? claims['iat']),
    );
  }

  /// Get user initials for avatar fallback.
  String get initials {
    if (fullName != null && fullName!.trim().isNotEmpty) {
      final parts = fullName!.trim().split(RegExp(r'\s+'));
      if (parts.length >= 2 && parts[0].isNotEmpty && parts[1].isNotEmpty) {
        return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
      }
      final name = parts[0];
      return name.length >= 2 ? name.substring(0, 2).toUpperCase() : name.toUpperCase();
    }
    if (email.isNotEmpty) {
      final namePart = email.split('@')[0];
      final parts = namePart.split(RegExp(r'[\._\-]'));
      if (parts.length >= 2 && parts[0].isNotEmpty && parts[1].isNotEmpty) {
        return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
      }
      final lettersOnly = namePart.replaceAll(RegExp(r'[^a-zA-Z]'), '');
      if (lettersOnly.length >= 2) {
        return lettersOnly.substring(0, 2).toUpperCase();
      }
      return namePart.length >= 2 ? namePart.substring(0, 2).toUpperCase() : namePart.toUpperCase();
    }
    return 'U';
  }

  UserModel copyWith({
    String? email,
    String? photoURL,
    bool? isVerified,
    String? fullName,
    int? createdAt,
  }) {
    return UserModel(
      email: email ?? this.email,
      photoURL: photoURL ?? this.photoURL,
      isVerified: isVerified ?? this.isVerified,
      fullName: fullName ?? this.fullName,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
