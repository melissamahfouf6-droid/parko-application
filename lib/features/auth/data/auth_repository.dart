import 'package:dio/dio.dart';

class UserProfile {
  const UserProfile({
    required this.userId,
    required this.phone,
    this.displayName,
    this.email,
    this.memberSince,
  });

  final String userId;
  final String phone;
  final String? displayName;
  final String? email;
  final DateTime? memberSince;

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    final since = json['memberSince'] as String?;
    return UserProfile(
      userId: json['userId'] as String,
      phone: json['phone'] as String,
      displayName: json['displayName'] as String?,
      email: json['email'] as String?,
      memberSince: since != null ? DateTime.tryParse(since) : null,
    );
  }
}

class AuthVerifyResult {
  const AuthVerifyResult({
    required this.userId,
    required this.phone,
    this.displayName,
    this.token,
    this.welcomeBonus = false,
    this.welcomeWalletKwd = 0,
    this.welcomePoints = 0,
  });

  final String userId;
  final String phone;
  final String? displayName;
  final String? token;
  final bool welcomeBonus;
  final double welcomeWalletKwd;
  final int welcomePoints;

  factory AuthVerifyResult.fromJson(Map<String, dynamic> json) {
    return AuthVerifyResult(
      userId: json['userId'] as String,
      phone: json['phone'] as String,
      displayName: json['displayName'] as String?,
      token: json['token'] as String?,
      welcomeBonus: json['welcomeBonus'] == true,
      welcomeWalletKwd: (json['welcomeWalletKwd'] as num?)?.toDouble() ?? 0,
      welcomePoints: (json['welcomePoints'] as num?)?.toInt() ?? 0,
    );
  }
}

abstract class AuthRepository {
  Future<void> sendOtp(String phone);
  Future<AuthVerifyResult> verifyOtp({required String phone, required String code});
  Future<UserProfile> fetchProfile({required String userId});
  Future<UserProfile> updateProfile({
    required String userId,
    String? displayName,
    String? email,
  });
}

class MockAuthRepository implements AuthRepository {
  @override
  Future<void> sendOtp(String phone) async {
    await Future<void>.delayed(const Duration(milliseconds: 400));
  }

  @override
  Future<AuthVerifyResult> verifyOtp({required String phone, required String code}) async {
    await Future<void>.delayed(const Duration(milliseconds: 300));
    if (code != '123456') throw StateError('otp_invalid');
    final digits = phone.replaceAll(RegExp(r'\D'), '');
    return AuthVerifyResult(
      userId: 'mock-$digits',
      phone: phone,
      token: 'mock-token',
      welcomeBonus: true,
      welcomeWalletKwd: 10,
      welcomePoints: 250,
    );
  }

  @override
  Future<UserProfile> fetchProfile({required String userId}) async {
    await Future<void>.delayed(const Duration(milliseconds: 80));
    return UserProfile(
      userId: userId,
      phone: '+96550000000',
      displayName: 'Parko Guest',
      memberSince: DateTime(2024, 1, 1),
    );
  }

  @override
  Future<UserProfile> updateProfile({
    required String userId,
    String? displayName,
    String? email,
  }) async {
    await Future<void>.delayed(const Duration(milliseconds: 80));
    return UserProfile(
      userId: userId,
      phone: '+96550000000',
      displayName: displayName,
      email: email,
      memberSince: DateTime.now(),
    );
  }
}

class ApiAuthRepository implements AuthRepository {
  ApiAuthRepository({required Dio dio, required String baseUrl})
      : _dio = dio,
        _base = baseUrl.replaceAll(RegExp(r'/$'), '');

  final Dio _dio;
  final String _base;

  @override
  Future<void> sendOtp(String phone) async {
    await _dio.post<Map<String, dynamic>>(
      '$_base/api/auth/otp/send',
      data: {'phone': phone},
    );
  }

  @override
  Future<AuthVerifyResult> verifyOtp({required String phone, required String code}) async {
    final res = await _dio.post<Map<String, dynamic>>(
      '$_base/api/auth/otp/verify',
      data: {'phone': phone, 'code': code},
    );
    return AuthVerifyResult.fromJson(Map<String, dynamic>.from(res.data ?? {}));
  }

  @override
  Future<UserProfile> fetchProfile({required String userId}) async {
    final res = await _dio.get<Map<String, dynamic>>(
      '$_base/api/auth/me',
      options: Options(headers: {'x-user-id': userId}),
    );
    return UserProfile.fromJson(Map<String, dynamic>.from(res.data ?? {}));
  }

  @override
  Future<UserProfile> updateProfile({
    required String userId,
    String? displayName,
    String? email,
  }) async {
    final res = await _dio.patch<Map<String, dynamic>>(
      '$_base/api/auth/profile',
      data: {
        if (displayName != null) 'displayName': displayName,
        if (email != null) 'email': email,
      },
      options: Options(headers: {'x-user-id': userId}),
    );
    return UserProfile.fromJson(Map<String, dynamic>.from(res.data ?? {}));
  }
}
