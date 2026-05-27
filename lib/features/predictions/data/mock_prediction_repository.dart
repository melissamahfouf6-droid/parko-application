import 'prediction_engine.dart';
import 'prediction_repository.dart';
import '../domain/parking_prediction.dart';

class MockPredictionRepository implements PredictionRepository {
  final Set<String> _waitlist = {};

  @override
  Future<List<ParkingPrediction>> homeHighlights() async {
    await Future<void>.delayed(const Duration(milliseconds: 200));
    return PredictionEngine.homeHighlights();
  }

  @override
  Future<ParkingPrediction> lotPrediction(String lotId) async {
    await Future<void>.delayed(const Duration(milliseconds: 150));
    return PredictionEngine.forLot(lotId);
  }

  @override
  Future<bool> joinWaitlist(String lotId) async {
    await Future<void>.delayed(const Duration(milliseconds: 120));
    return _waitlist.add(lotId);
  }

  @override
  Future<List<String>> listWaitlistLotIds() async {
    await Future<void>.delayed(const Duration(milliseconds: 50));
    return _waitlist.toList();
  }
}
