export type LotSeed = {
  id: string;
  name: string;
  lat: number;
  lng: number;
  totalSpots: number;
  availableSpots: number;
  priceKwdPerHour: number;
  rating: number;
  reviewCount: number;
  hasValet: boolean;
  supportsReservation: boolean;
  hoursLabel: string;
};

export const PARKING_LOTS_SEED: LotSeed[] = [
  {
    id: 'avenues',
    name: 'The Avenues Mall',
    lat: 29.3346,
    lng: 47.9415,
    totalSpots: 1500,
    availableSpots: 240,
    priceKwdPerHour: 1.5,
    rating: 4.6,
    reviewCount: 1240,
    hasValet: true,
    supportsReservation: true,
    hoursLabel: '10 AM – 10 PM',
  },
  {
    id: 'kuwait_uni',
    name: 'Kuwait University',
    lat: 29.325,
    lng: 47.9726,
    totalSpots: 700,
    availableSpots: 32,
    priceKwdPerHour: 0,
    rating: 4.2,
    reviewCount: 310,
    hasValet: false,
    supportsReservation: true,
    hoursLabel: '7 AM – 9 PM',
  },
  {
    id: 'hospital',
    name: 'Dasman Diabetes Institute',
    lat: 29.3683,
    lng: 47.9874,
    totalSpots: 220,
    availableSpots: 9,
    priceKwdPerHour: 1,
    rating: 4.4,
    reviewCount: 520,
    hasValet: false,
    supportsReservation: false,
    hoursLabel: '24 hours',
  },
  {
    id: '360_mall',
    name: '360 Mall',
    lat: 29.3503,
    lng: 48.0187,
    totalSpots: 800,
    availableSpots: 12,
    priceKwdPerHour: 2,
    rating: 4.5,
    reviewCount: 890,
    hasValet: true,
    supportsReservation: true,
    hoursLabel: '10 AM – 11 PM',
  },
  {
    id: 'marina',
    name: 'Marina Mall',
    lat: 29.3461,
    lng: 48.0592,
    totalSpots: 600,
    availableSpots: 0,
    priceKwdPerHour: 1.75,
    rating: 4.3,
    reviewCount: 640,
    hasValet: true,
    supportsReservation: true,
    hoursLabel: '10 AM – 10 PM',
  },
];

export function haversineKm(
  lat1: number,
  lng1: number,
  lat2: number,
  lng2: number,
): number {
  const R = 6371;
  const dLat = ((lat2 - lat1) * Math.PI) / 180;
  const dLng = ((lng2 - lng1) * Math.PI) / 180;
  const a =
    Math.sin(dLat / 2) ** 2 +
    Math.cos((lat1 * Math.PI) / 180) *
      Math.cos((lat2 * Math.PI) / 180) *
      Math.sin(dLng / 2) ** 2;
  return R * 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1 - a));
}

export function lotById(lotId: string): LotSeed | undefined {
  return PARKING_LOTS_SEED.find((l) => l.id === lotId);
}
