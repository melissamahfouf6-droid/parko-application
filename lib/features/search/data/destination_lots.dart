/// Maps search destination titles to parking lot ids in [MockParkingRepository].
const destinationToLotId = <String, String>{
  'The Avenues Mall': 'avenues',
  '360 Mall': '360_mall',
  'Kuwait International Airport': 'avenues',
  'Souq Al-Mubarakiya': 'kuwait_uni',
  'Dasman Diabetes Institute': 'hospital',
  'Kuwait University (Shadadiya)': 'kuwait_uni',
  'Marina Mall': 'marina',
};

String? lotIdForDestination(String title) => destinationToLotId[title];
