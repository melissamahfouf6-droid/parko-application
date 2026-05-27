import 'package:dio/dio.dart';

import '../domain/wallet_models.dart';
import 'wallet_repository.dart';

class ApiWalletRepository implements WalletRepository {
  ApiWalletRepository({required Dio dio, required String baseUrl, required String userId})
      : _dio = dio,
        _base = baseUrl.replaceAll(RegExp(r'/$'), ''),
        _userId = userId;

  final Dio _dio;
  final String _base;
  final String _userId;

  Map<String, String> get _headers => {'x-user-id': _userId};

  @override
  Future<WalletSummary> getSummary() async {
    final res = await _dio.get<Map<String, dynamic>>(
      '$_base/api/wallet/summary',
      options: Options(headers: _headers),
    );
    return WalletSummary.fromJson(Map<String, dynamic>.from(res.data ?? {}));
  }

  @override
  Future<WalletSummary> topUp(double amountKwd) async {
    await _dio.post<Map<String, dynamic>>(
      '$_base/api/wallet/top-up',
      data: {'amountKwd': amountKwd},
      options: Options(headers: _headers),
    );
    return getSummary();
  }

  @override
  Future<WalletSummary> pay({
    required double amountKwd,
    required String reference,
    String? description,
  }) async {
    await _dio.post<Map<String, dynamic>>(
      '$_base/api/wallet/pay',
      data: {
        'amountKwd': amountKwd,
        'reference': reference,
        if (description != null) 'description': description,
      },
      options: Options(headers: _headers),
    );
    return getSummary();
  }
}
