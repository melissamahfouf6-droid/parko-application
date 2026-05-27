/// Display-only estimate of points a user may earn when parking here (ties to spend later).
int estimatedVisitPointsHint(double priceKwdPerHour) {
  if (priceKwdPerHour <= 0) return 5;
  return (priceKwdPerHour * 10).round().clamp(5, 50);
}
