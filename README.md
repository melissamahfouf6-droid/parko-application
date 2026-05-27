## Parko (بارکو) — Smart Parking for Kuwait

Parko is a production-grade Flutter app concept that solves Kuwait’s daily parking pain: finding available parking fast, reserving ahead, and navigating to the exact spot.

### What’s included in this repo
- **Flutter app** with **Riverpod 2** + **GoRouter**
- **Design system** (Parko colors, gradient; system **Roboto** typography — no runtime font download)
- **i18n** (English + Arabic) with **RTL** + in-app **language toggle** (drawer)
- **Core flows**: Splash → Onboarding → Auth / **Sign up** → **Home map** (drawer, search, filters, zoom) → **Parking lot** bottom sheet
- **Search** screen with Kuwait destination mocks (ready to swap for Places API)
- **My parking** screen: **Active / Upcoming / History** tabs + mock history
- **Mock parking API** (`MockParkingRepository`) — swap for NestJS + PostGIS later

### Prerequisites
- Flutter **3.19+** (Dart 3)
- Xcode (for iOS) / Android Studio (for Android)

### Run
```bash
cd "/path/to/parko application"
flutter pub get
flutter run
```

Use `flutter run -d chrome` for web, or pick a simulator/device once Android/iOS SDKs are configured.

### Mobile setup (one script)
From the project folder:

```bash
bash scripts/setup_mobile.sh
```

This runs `flutter pub get`, `flutter precache --ios`, `pod install`, auto-configures Android SDK if it exists under the default paths, then `flutter doctor -v`.

### Run on iOS Simulator (boot + run)
`flutter run -d ios` only works after **a simulator is booted** (otherwise Flutter only sees macOS/Chrome). One command:

```bash
bash scripts/run_ios_sim.sh
```

Or manually: `open -a Simulator`, pick a device, wait until it shows the home screen, then `flutter devices` → `flutter run -d <device-id>`.

### Android SDK (if `flutter doctor` cannot find the SDK)
After installing the SDK via Android Studio (default path on macOS):

```bash
flutter config --android-sdk "$HOME/Library/Android/sdk"
flutter doctor --android-licenses
```

### Parko Points (loyalty) + API

The app includes **نقاط بارکو / Parko Points**: balance, lifetime tier (Bronze → Platinum), history, daily check-in (+5), demo parking earn (1 pt per 1 KWD rounded), and **100 pts → 5 KWD** redemption (wallet integration later).

- **Without a server**: leave `PARKO_API_BASE` unset — loyalty uses an **in-memory mock** (still full UI + rules).
- **With NestJS API** (folder `backend/`):

  ```bash
  cd backend && npm install && npm run start:dev
  ```

  Then run the app with a reachable base URL (no trailing slash), for example:

  - iOS Simulator / desktop:  
    `flutter run --dart-define=PARKO_API_BASE=http://127.0.0.1:3000`
  - Android emulator:  
    `flutter run --dart-define=PARKO_API_BASE=http://10.0.2.2:3000`

  All loyalty routes are under `/api/loyalty/*` and expect header **`x-user-id`** (defaults to `demo-user-1` in the app until auth ships). SQLite file: `backend/parko.db` (gitignored).

### Refund policy & dark mode (Week 23)

- **Refund policy**: wallet refunds on cancel only **before reservation start** (API + mock + cancel dialog copy).
- **Dark mode**: Settings → **Appearance** — System / Light / Dark (persisted).
- **Theme**: `ParkoPalette` theme extension — screens use `context.parko.*` so dark mode applies app-wide (map, drawer, sheets, auth, wallet, etc.).

### Refunds, history filters & refresh (Week 22)

- **Cancel refund**: wallet-paid reservations refund to Parko Wallet on cancel (`REFUND` transaction).
- **History filters**: All / Walk-up / Reservations on My Parking → History + pull to refresh.
- **Wallet pull-to-refresh** on the wallet screen.
- **Help FAQ** entry for cancellation refunds.

### Favorites, hours & wallet reserve (Week 21)

- **Home favorites strip**: quick chips for saved lots → focus on map.
- **Lot hours**: `hoursLabel` on each lot (API + lot sheet).
- **Reserve + wallet**: optional **Pay from wallet** on reserve (`payFromWallet` on `POST /api/reservations`); rolls back if balance is low.
- **Notifications filters**: All / Reservations / Wallet / Shared chips.

### Search, wallet & inbox (Week 20)

- **Search lots**: query matches live parking lot names from the API; tap to focus on map.
- **Drawer header**: wallet balance + Parko Points; tap opens Settings.
- **Notifications**: swipe to dismiss; menu → mark all read / clear read (`DELETE` + `POST clear-read`).
- **Wallet**: custom top-up amount (1–500 KWD).
- **Pay parking**: disables pay when balance is low; shortcut to top up.

### Map polish, clustering & UX (Week 19)

- **OSM tiles**: Carto Voyager CDN (more reliable than direct OSM); gradient fallback when tiles fail; offline hint banner.
- **Marker overflow fix**: unified pin widgets sized for FlutterMap markers.
- **Google Maps clustering**: same grid clustering as OSM when zoom &lt; 14; tap cluster to zoom in.
- **Notifications**: pull-to-refresh inbox.
- **Settings**: copy account ID to clipboard.

### Buddy chat, map layers & share (Week 18)

- **Buddy chat API**: `GET/POST /api/buddies/chat/:threadId/messages` — persisted messages; chat screen loads and sends via API.
- **Map layers sheet**: toggle shared/private overlays; **Standard / Satellite** on Google Maps.
- **Share lot**: share button on lot sheet (`share_plus`) with spots, price, and map link.
- **Profile**: `GET /api/auth/me` includes **memberSince**; Settings shows member date, account ID, and sign out.

### API health, waitlist sync & signup (Week 17)

- **Health API**: `GET /api/health` — home map shows **Live** / **Demo** / **Offline** status chip.
- **Waitlist sync**: `GET /api/predictions/waitlist` hydrates waitlist state on home load and refresh.
- **My Parking stats**: history tab header shows visit count and total KWD spent.
- **Phone signup**: Create account → OTP on auth screen → `PATCH /api/auth/profile` applies name & email after verify.

### Reminders, session sync & smart home (Week 16)

- **Device reminders**: when **Parking reminders** are on in Settings, reserving schedules a local notification **15 min before** start (`flutter_local_notifications`).
- **Session complete API**: `POST /api/parking/sessions/complete` — ending a session syncs duration to server history + inbox.
- **Notification taps**: open **My parking**, **Home**, or **Wallet** by category.
- **Daily check-in banner** on home when you have not checked in today.
- **Map auto-refresh** every 2 minutes while on home.
- **Upcoming reservations**: **Show on map** button added.

### Receipts, filters & reservation alerts (Week 15)

- **Map quick filters**: horizontal chips — All, Free, Valet, Reservable (above home banners).
- **Reservation notifications**: server pushes confirm + reminder (+ cancel) to the inbox.
- **Session receipt**: ending active parking shows duration, paid amount, and points hint.
- **History detail**: tap a history row → details + **Show on map** when `lotId` is known.
- **Pay → loyalty**: wallet parking payment awards Parko Points (1 pt per 1 KWD).

### Profile sync, refresh & extend session (Week 14)

- **Welcome bonus** (new OTP users): **10 KWD** wallet + **250** Parko Points on first verify.
- **Profile API**: `GET /api/auth/me`, `PATCH /api/auth/profile` — Settings loads/saves display name & email.
- **Map refresh** button (right side) — reloads lots, wallet, loyalty, notifications, reservations.
- **Extend session**: **+30 min** on My Parking active tab and the green home banner.

### Phone OTP, search history & map clustering (Week 13)

- **Auth API**: `POST /api/auth/otp/send`, `POST /api/auth/otp/verify` → persists **`parko_user_id`** (used as `x-user-id` on all APIs). Demo code: **123456**.
- **Phone sign-in**: two-step OTP on the auth screen (mock without API base).
- **Recent searches**: last 8 destinations on the search screen.
- **OSM clustering**: zoom out on the free map — markers group; tap cluster to zoom in. Label shows `clustered` when active.
- **End session**: ✕ on the green home parking banner.

### Saved lots & active session banner (Week 12)

- **Favorites**: star icon on lot sheet → `GET/POST/DELETE /api/favorites` (synced per `x-user-id`).
- **Saved lots screen**: drawer → **Saved lots** — tap to focus map + open lot sheet.
- **Home banner**: green **Parking now** chip with live countdown after wallet pay / demo session.

### Lot reviews & help center (Week 11)

- **Rate a lot**: expand any lot sheet → stars + optional comment → `POST /api/parking/lots/:lotId/review` (one review per user per lot per day).
- **Loyalty**: +10 Parko Points on successful review (`POST /api/loyalty/earn` with `type: REVIEW`).
- **Help**: Settings → **Help & FAQ** (`/help`) — parking, wallet, loyalty, maps, share/buddies.

### Parking API & history (Week 10)

- **Lots from API**: `GET /api/parking/lots/nearby?lat=&lng=` (replaces mock when `PARKO_API_BASE` is set). Includes **distanceKm** on each lot.
- **Pay → history**: wallet payment records a **parking session** on the server; **My parking → History** merges sessions + past reservations.
- **Map legend** (bottom-left): green / amber / red availability.

### Location, search focus & photos (Week 9)

- **My location** button on map + **Search → Use my location** — GPS center, lots sorted by distance.
- **Drawer → Find parking near me** — same GPS flow.
- **Search destination** — pans map, opens lot sheet (Avenues, 360, Marina, etc.).
- **Marketplace listing** — pick a verification photo from gallery (demo; upload API later).

Simulator tip: **Features → Location → Custom** to test GPS in Kuwait.

### Map filters, notifications & session (Week 8)

- **Filters** (tune icon): available now, reservable ahead, show full lots — updates map markers live (5 mock lots including full Marina Mall).
- **Notification bell** on home with unread badge → inbox (reservations, predictions, share, wallet).
- **Session**: onboarding shown once; sign-in remembered until **Sign out** (local `shared_preferences`).
- **API**: `GET /api/notifications`, `POST /api/notifications/:id/read`, `POST /api/notifications/read-all`

### Settings, buddy chat & loyalty → wallet (Week 7)

- **Settings** (`/settings`): profile (saved locally), parking/marketing notification toggles, language, links to wallet & loyalty.
- **Buddy chat**: tap chat icon on a buddy → in-app thread (demo; Firebase later).
- **Redeem 100 pts**: credits **5 KWD** to Parko wallet automatically (API + mock).

### Wallet & payments (Week 6)

**بارکو Wallet** — demo balance, top-up, and pay for parking (Tap/KNET-ready).

- **Home chip** (amber) shows balance · **Drawer → Wallet & payments**
- **Lot sheet → Park & Pay Now** — deduct from wallet, start active session
- **Navigate** opens Apple/Google Maps (simulator opens Maps app when available)
- **API**: `GET /api/wallet/summary`, `POST /api/wallet/top-up`, `POST /api/wallet/pay`

### Reserve ahead (Week 5)

Book a spot before you arrive — matches onboarding **“Reserve your spot”**.

- **Lot sheet → Reserve spot**: pick today/tomorrow, duration (1–3h or all day), optional zone.
- **My parking → Upcoming**: list, navigate, cancel.
- **Home banner** when your next reservation is soon.
- **API** (with `PARKO_API_BASE`): `GET /api/reservations`, `POST /api/reservations`, `DELETE /api/reservations/:id`

### Parking buddies + marketplace (Week 4)

**Buddies (شاركني الموقف)** — split cost, coordinate meetups (chat placeholder).

- Home card: **“3 people going to 360 Mall now”** (default destination; change via Search).
- Search → **groups icon** or tap destination → buddy list + **Join**.
- API: `GET /api/buddies/nearby?destination=…`, `POST /api/buddies/join`

**Marketplace (سوق المواقف)** — residents list driveways/garages.

- Home CTA: **Earn ~X KWD/mo — list your driveway**
- **Green garage markers** on the map; lot sheet shows nearby resident spots.
- Drawer → **List my spot** → publish + browse listings.
- API: `GET /api/marketplace/listings`, `POST /api/marketplace/listings`

### Share parking — leave early (Week 3)

Sell remaining time when you leave early (**بيع موقفي**): 20% buyer discount, 70% seller refund (demo).

- **My parking → Active**: tap **Start demo parking session**, then **Leave early — sell my spot**.
- **Home map**: amber ⚡ markers = shared spots; **Share spot** FAB when you have an active session.
- **API** (with `PARKO_API_BASE`): `GET /api/share/available`, `POST /api/share/list`, `POST /api/share/:id/claim`

### Smart parking predictions (Week 2)

Historical fill patterns drive **“when will this lot ease?”** insights on the home swipeable banner and on **nearly-full** lot sheets (≤25% spots left).

- **Mock (no API)**: works out of the box with `PredictionEngine` in Dart.
- **API** (same `PARKO_API_BASE` as loyalty):
  - `GET /api/predictions/highlights` — home banner cards
  - `GET /api/predictions/lot/:lotId` — lot insight + hourly pattern
  - `POST /api/predictions/waitlist` `{ lotId }` — notify when available (SQLite waitlist)
  - `GET /api/predictions/waitlist` — user’s subscriptions

### Maps (free by default)

**No Google account or billing required** for development: the app uses **OpenStreetMap** tiles (`flutter_map`) whenever a Google Maps API key is not configured. You get a real scrollable map on **iOS Simulator**, Android, and **macOS** with parking markers.

Optional **Google Maps** (requires [Google Cloud billing](https://developers.google.com/maps/billing-and-pricing) on the project, though light usage often stays within the monthly free credit):

```bash
bash scripts/setup_google_maps_key.sh YOUR_KEY
```

After a valid key is installed, **iOS / Android / Web** switch to Google Maps automatically.

### Google Maps setup (optional)
`google_maps_flutter` supports **Android**, **iOS**, and **Web** only — **not macOS desktop**. Without a key, macOS uses the free OSM map instead of a static preview.

Create keys in [Google Cloud Console](https://console.cloud.google.com/) → APIs & Services → Credentials (enable **Maps SDK for Android**, **Maps SDK for iOS**, and **Maps JavaScript API** as needed). Prefer **separate restricted keys** per platform.

- **Android**: add a line to **`android/local.properties`** (this file is gitignored; do not commit keys):

  `GOOGLE_MAPS_API_KEY=your_android_key_here`

  The value is injected at build time into `AndroidManifest.xml` via Gradle `manifestPlaceholders`.

- **iOS (device or Simulator — same build)**: the home screen already uses the **embedded `GoogleMap`** on iOS; the Simulator is **not** blocked. If tiles stay **grey/blank**, the Maps SDK is almost always missing a **valid API key** or **Maps SDK for iOS** / **billing** is not enabled for the GCP project.

  **Recommended (keeps secrets out of git):** copy `ios/Flutter/Secrets.xcconfig.example` to **`ios/Flutter/Secrets.xcconfig`** (gitignored) and set:

  `GOOGLE_MAPS_API_KEY=your_ios_key_here`

  `Debug.xcconfig` / `Release.xcconfig` include that file **after** the placeholder so your key wins. Restrict the key by iOS bundle id **`com.parko.kw.parko`** (Simulator uses the same bundle id as the app).

  After changing the **Podfile** (static frameworks for Maps), run **`cd ios && pod install`** (or `bash scripts/setup_mobile.sh`), then **`flutter run`** on your booted Simulator.

  Xcode console: if the key is still missing, **`AppDelegate`** logs a **`[Parko] Google Maps:`** hint. The map uses `myLocationEnabled: false` on the Simulator only to avoid location-layer edge cases; markers and tiles still load like on device.

- **Web**: in **`web/index.html`**, replace **`YOUR_WEB_MAPS_API_KEY`** in the Maps script `src` URL, then run with `flutter run -d chrome`. See [google_maps_flutter_web](https://pub.dev/packages/google_maps_flutter_web).

### Notes
- Networking, auth, realtime, payments, and notifications are scaffolded as **interfaces/placeholders**. You can connect them to your NestJS backend when ready.
