import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../config/api_config.dart';
import 'dio_client.dart';

enum ApiConnectionStatus { demo, live, offline }

class ApiHealthState {
  const ApiHealthState({required this.status, this.latencyMs});

  final ApiConnectionStatus status;
  final int? latencyMs;

  bool get isLive => status == ApiConnectionStatus.live;
}

final apiHealthProvider = FutureProvider<ApiHealthState>((ref) async {
  final base = ApiConfig.parkoApiBase.trim();
  if (base.isEmpty) {
    return const ApiHealthState(status: ApiConnectionStatus.demo);
  }
  final sw = Stopwatch()..start();
  try {
    await ref.read(dioProvider).get<Map<String, dynamic>>(
          '$base/api/health',
          options: Options(
            receiveTimeout: const Duration(seconds: 4),
            sendTimeout: const Duration(seconds: 4),
          ),
        );
    sw.stop();
    return ApiHealthState(status: ApiConnectionStatus.live, latencyMs: sw.elapsedMilliseconds);
  } catch (_) {
    sw.stop();
    return const ApiHealthState(status: ApiConnectionStatus.offline);
  }
});
