import '../domain/parking_prediction.dart';

abstract class PredictionRepository {
  Future<List<ParkingPrediction>> homeHighlights();
  Future<ParkingPrediction> lotPrediction(String lotId);
  Future<bool> joinWaitlist(String lotId);

  Future<List<String>> listWaitlistLotIds();
}
