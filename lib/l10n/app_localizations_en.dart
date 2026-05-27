import 'app_localizations.dart';

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appName => 'Parko';

  @override
  String get tagline => 'Smart Parking Solution';

  @override
  String get getStarted => 'Get Started';

  @override
  String get skip => 'Skip';

  @override
  String get next => 'Next';

  @override
  String get back => 'Back';

  @override
  String get onboardingTitle1 => 'Find parking instantly';

  @override
  String get onboardingBody1 => 'Real-time availability at malls, hospitals, universities';

  @override
  String get onboardingTitle2 => 'Reserve your spot';

  @override
  String get onboardingBody2 => 'Book ahead and never circle looking for parking again';

  @override
  String get onboardingTitle3 => 'Navigate to your spot';

  @override
  String get onboardingBody3 => 'Get guided to your exact parking location';

  @override
  String get authTitle => 'Welcome to Parko';

  @override
  String get phoneTab => 'Phone';

  @override
  String get emailTab => 'Email';

  @override
  String get phoneHint => 'Phone number';

  @override
  String get emailHint => 'Email address';

  @override
  String get passwordHint => 'Password';

  @override
  String get sendCode => 'Send Code';

  @override
  String get signIn => 'Sign in';

  @override
  String get signUp => 'Sign up';

  @override
  String get signUpTitle => 'Create your account';

  @override
  String get firstNameHint => 'First name';

  @override
  String get lastNameHint => 'Last name';

  @override
  String get confirmPasswordHint => 'Confirm password';

  @override
  String get createAccount => 'Create account';

  @override
  String get passwordsDoNotMatch => 'Passwords do not match';

  @override
  String get fillAllFields => 'Please fill all fields';

  @override
  String get forgotPasswordComingSoon => 'Password reset will be available in a future update.';

  @override
  String get forgotPassword => 'Forgot password?';

  @override
  String get searchHint => 'Search destination or parking lot';

  @override
  String get availableNow => 'Available now';

  @override
  String get reservableAhead => 'Reservable in advance';

  @override
  String get showFullLots => 'Show full lots';

  @override
  String get resetFilters => 'Reset filters';

  @override
  String get applyFilters => 'Apply filters';

  @override
  String get navigateToParking => 'Navigate to parking';

  @override
  String get reserveSpot => 'Reserve spot';

  @override
  String get parkPayNow => 'Park & Pay Now';

  @override
  String get drawerMyParking => 'My parking';

  @override
  String get drawerWallet => 'Wallet & payments';

  @override
  String get drawerSettings => 'Settings';

  @override
  String get drawerLanguage => 'Language';

  @override
  String get drawerSignOut => 'Sign out';

  @override
  String get drawerFindParking => 'Find parking near me';

  @override
  String get searchTitle => 'Search';

  @override
  String get myParkingTitle => 'My parking';

  @override
  String get tabActive => 'Active';

  @override
  String get tabUpcoming => 'Upcoming';

  @override
  String get tabHistory => 'History';

  @override
  String get emptyActiveParking => 'No active parking';

  @override
  String get emptyUpcoming => 'No upcoming reservations';

  @override
  String get emptyHistory => 'No past sessions yet';

  @override
  String get mapPreviewTitle => 'Map preview';

  @override
  String get mapPreviewHint => 'Google Maps is not embedded on macOS, Linux, or Windows desktop builds. Use iOS Simulator, Android, or Chrome (web) for the live map. Tap a marker below for lot details.';

  @override
  String distanceAwayWalk(String distance, int minutes) {
    return '$distance away • $minutes min walk';
  }

  @override
  String get drawerLoyalty => 'Parko Points';

  @override
  String get loyaltyScreenTitle => 'Parko Points';

  @override
  String get loyaltyScreenSubtitle => 'Earn نقاط باركو on every visit · redeem for free parking';

  @override
  String loyaltyBalance(int points) {
    return 'Balance: $points pts';
  }

  @override
  String loyaltyLifetime(int points) {
    return 'Lifetime: $points pts';
  }

  @override
  String get loyaltyTierBronze => 'Bronze';

  @override
  String get loyaltyTierSilver => 'Silver';

  @override
  String get loyaltyTierGold => 'Gold';

  @override
  String get loyaltyTierPlatinum => 'Platinum';

  @override
  String loyaltyProgressToNext(int points, String tierName) {
    return '$points pts to $tierName';
  }

  @override
  String get loyaltyMaxTier => 'Platinum — keep earning for redemptions';

  @override
  String get loyaltyDailyCheckIn => 'Daily check-in (+5)';

  @override
  String get loyaltyDemoParking => 'Demo: complete session (3.5 KWD)';

  @override
  String get loyaltyRedeem100 => 'Redeem 100 pts → 5 KWD credit';

  @override
  String get loyaltyRewardsTitle => 'Rewards catalog';

  @override
  String get loyaltyRedemptionRule => '100 points = 5 KWD parking credit';

  @override
  String get loyaltyTiersTitle => 'Levels & perks';

  @override
  String get loyaltyHistoryTitle => 'Points history';

  @override
  String get loyaltyEmptyHistory => 'No transactions yet';

  @override
  String loyaltyEarnAtLot(int points) {
    return 'Earn up to $points pts on paid visits here';
  }

  @override
  String loyaltySnackEarned(int points) {
    return 'You earned $points pts!';
  }

  @override
  String loyaltySnackLevelUp(String tier) {
    return 'Level up! You are now $tier';
  }

  @override
  String get loyaltySnackRedeem => 'Redeemed 100 pts for parking credit';

  @override
  String get loyaltySnackCheckIn => '+5 pts daily check-in';

  @override
  String get loyaltyErrCheckInDone => 'Already checked in today';

  @override
  String get loyaltyErrBalance => 'Not enough points';

  @override
  String get loyaltyRedeemConfirmTitle => 'Redeem 100 points?';

  @override
  String get loyaltyCancel => 'Cancel';

  @override
  String get loyaltyConfirm => 'Redeem';

  @override
  String get loyaltyPerkBronze => 'Bronze (0–499): standard';

  @override
  String get loyaltyPerkSilver => 'Silver (500–1999): 5% parking discount';

  @override
  String get loyaltyPerkGold => 'Gold (2000–4999): 10% + priority reservations';

  @override
  String get loyaltyPerkPlatinum => 'Platinum (5000+): 15% + VIP spots + valet perks';

  @override
  String get loyaltyApiHint => 'Run backend and launch with --dart-define=PARKO_API_BASE=… to sync points.';

  @override
  String loyaltyHomeBadge(String points) {
    return '$points pts';
  }

  @override
  String predictionBannerOpens(String lotName, int minutes) {
    return 'Predicted: $lotName eases in ~$minutes min';
  }

  @override
  String predictionChance(int percent) {
    return '$percent% chance of finding parking soon';
  }

  @override
  String get predictionSectionTitle => 'Smart prediction';

  @override
  String predictionTypicalOpens(String time) {
    return 'Usually opens around $time';
  }

  @override
  String get predictionPatternTitle => 'Typical fill today';

  @override
  String get predictionNotifyMe => 'Notify me when available';

  @override
  String get predictionNotifyDone => 'You will be notified when spots open';

  @override
  String get predictionNotifyAlready => 'Already on the waitlist for this lot';

  @override
  String get shareSpotTitle => 'Share your spot';

  @override
  String get shareSpotFab => 'Share spot';

  @override
  String shareAvailableNow(int count) {
    return '$count spots shared nearby — save up to 20%';
  }

  @override
  String get shareLeaveEarly => 'Leave early — sell my spot';

  @override
  String get shareLeaveEarlyTitle => 'بيع موقفي';

  @override
  String get shareLeaveEarlyBody => 'List your remaining time at a 20% discount. You get 70% refund; buyer enters within 10 minutes.';

  @override
  String get shareConfirmList => 'List my spot for sale';

  @override
  String shareListedSuccess(String amount) {
    return 'Listed! Refund $amount KWD credited (demo).';
  }

  @override
  String shareActiveSession(String lotName) {
    return 'Active at $lotName';
  }

  @override
  String shareTimeLeft(int hours, int minutes) {
    return '${hours}h ${minutes}m left';
  }

  @override
  String get shareStartDemoSession => 'Start demo parking session';

  @override
  String get shareEndSession => 'End session';

  @override
  String shareBuyNow(String price) {
    return 'Get this spot — $price KWD';
  }

  @override
  String get shareClaimSuccess => 'Spot claimed! Head there within 10 minutes.';

  @override
  String get shareSheetTitle => 'Shared parking — available now';

  @override
  String shareRemaining(int minutes, int discount) {
    return '$minutes min left • $discount% off';
  }

  @override
  String buddyCardGoing(int count, String destination) {
    return '$count people going to $destination now';
  }

  @override
  String get buddyFindTitle => 'Parking buddies';

  @override
  String get buddyJoinSearch => 'Join — find a buddy';

  @override
  String get buddyJoined => 'You joined the buddy search!';

  @override
  String get buddyChatHint => 'Tap a buddy to chat and coordinate parking.';

  @override
  String get buddyEmpty => 'No buddies for this destination yet. Be the first!';

  @override
  String buddySeatsNeeded(int count) {
    return '$count seat(s) needed';
  }

  @override
  String get buddySearchAction => 'Find parking buddy';

  @override
  String marketplaceCta(String amount) {
    return 'Earn ~$amount KWD/mo — list your driveway';
  }

  @override
  String get marketplaceListTitle => 'Parking marketplace';

  @override
  String get marketplaceListMySpot => 'List my spot';

  @override
  String get marketplaceSpotTitleHint => 'Spot title (e.g. Salmiya driveway)';

  @override
  String get marketplacePriceHint => 'Price per day (KWD)';

  @override
  String get marketplaceAvailabilityHint => 'Availability';

  @override
  String get marketplaceAddPhoto => 'Add photo (verification)';

  @override
  String get marketplacePhotoHint => 'Photo verification — camera upload in next build.';

  @override
  String get marketplaceSubmit => 'Publish listing';

  @override
  String get marketplaceListed => 'Your spot is live on the map!';

  @override
  String get marketplaceBrowseTitle => 'Nearby private spots';

  @override
  String get marketplaceVerified => 'Photo verified (demo)';

  @override
  String get marketplaceBookSpot => 'Book this spot';

  @override
  String get marketplaceBookSoon => 'Booking & payment — Tap/Stripe next.';

  @override
  String marketplaceNearLot(int count, String price) {
    return '$count resident spots nearby from $price KWD/day';
  }

  @override
  String get drawerMarketplace => 'List my spot (marketplace)';

  @override
  String get drawerBuddies => 'Parking buddies';

  @override
  String get reserveTitle => 'Reserve parking';

  @override
  String get reserveWhen => 'When';

  @override
  String get reserveToday => 'Today';

  @override
  String get reserveTomorrow => 'Tomorrow';

  @override
  String get reserveDuration => 'Duration';

  @override
  String get reserveDuration1h => '1 hour';

  @override
  String get reserveDuration2h => '2 hours';

  @override
  String get reserveDuration3h => '3 hours';

  @override
  String get reserveDurationAllDay => 'All day';

  @override
  String get reserveZoneHint => 'Zone / level (optional)';

  @override
  String reserveTotal(String price) {
    return 'Estimated total: $price KWD';
  }

  @override
  String get reserveConfirm => 'Confirm reservation';

  @override
  String get reserveSuccess => 'Spot reserved! See My parking → Upcoming.';

  @override
  String get reserveCancel => 'Cancel reservation';

  @override
  String get reserveCancelConfirm => 'Cancel this reservation?';

  @override
  String get reserveCancelled => 'Reservation cancelled';

  @override
  String reserveStartsInHours(int hours, int mins) {
    return 'Starts in ${hours}h ${mins}m';
  }

  @override
  String reserveStartsInMins(int mins) {
    return 'Starts in $mins min';
  }

  @override
  String homeNextReservation(String lot) {
    return 'Reserved: $lot';
  }

  @override
  String reserveNavigateHint(String lot) {
    return 'Opening directions to $lot…';
  }

  @override
  String get reservePaySoon => 'Pay at arrival — Tap/Stripe wallet next.';

  @override
  String get walletTitle => 'Wallet & payments';

  @override
  String get walletBalanceLabel => 'Available balance';

  @override
  String walletBalanceAmount(String amount) {
    return '$amount KWD';
  }

  @override
  String get walletTopUpTitle => 'Quick top-up (demo)';

  @override
  String walletTopUpAmount(String amount) {
    return '+$amount KWD';
  }

  @override
  String get walletTopUpHint => 'Simulates KNET / Tap — production keys later.';

  @override
  String walletTopUpSuccess(String amount) {
    return 'Added $amount KWD to your wallet';
  }

  @override
  String get walletKnet => 'KNET';

  @override
  String get walletTap => 'Tap';

  @override
  String get walletHistory => 'Recent activity';

  @override
  String get walletEmptyHistory => 'No transactions yet';

  @override
  String get walletTxType => 'Transaction';

  @override
  String get walletPayTitle => 'Pay for parking';

  @override
  String walletPayBalance(String amount) {
    return 'Wallet balance: $amount KWD';
  }

  @override
  String walletPayAmount(String amount) {
    return 'Total: $amount KWD';
  }

  @override
  String get walletPayFree => 'This lot is free — starting session without charge.';

  @override
  String get walletPayConfirm => 'Pay with wallet';

  @override
  String get walletPaySuccess => 'Paid — active parking started';

  @override
  String get walletInsufficient => 'Insufficient wallet balance. Top up in Wallet.';

  @override
  String get walletBalanceUnknown => 'Balance unavailable';

  @override
  String get mapsOpenFailed => 'Could not open maps on this device';

  @override
  String walletHomeChip(String amount) {
    return '$amount KWD';
  }

  @override
  String get settingsTitle => 'Settings';

  @override
  String get settingsProfileSection => 'Profile';

  @override
  String get settingsNameLabel => 'Display name';

  @override
  String get settingsPhoneLabel => 'Phone';

  @override
  String get settingsEmailLabel => 'Email';

  @override
  String get settingsSaveProfile => 'Save profile';

  @override
  String get settingsProfileSaved => 'Profile saved';

  @override
  String get settingsNotificationsSection => 'Notifications';

  @override
  String get settingsParkingReminders => 'Parking reminders';

  @override
  String get settingsParkingRemindersHint => 'Reservation start & lot availability alerts';

  @override
  String get settingsMarketing => 'Offers & news';

  @override
  String get settingsMarketingHint => 'Mall deals and Parko promotions';

  @override
  String get settingsAppSection => 'App';

  @override
  String get settingsAbout => 'About Parko';

  @override
  String settingsVersion(String version) {
    return 'Version $version';
  }

  @override
  String loyaltySnackRedeemWallet(String amount) {
    return '$amount KWD added to your Parko wallet';
  }

  @override
  String get buddyChatSubtitle => 'Coordinate meetup & split parking';

  @override
  String get buddyChatInputHint => 'Message…';

  @override
  String get filterTitle => 'Map filters';

  @override
  String filterApplied(int count) {
    return 'Showing $count parking locations';
  }

  @override
  String get notificationsTitle => 'Notifications';

  @override
  String get notificationsMarkAllRead => 'Mark all read';

  @override
  String get notificationsEmpty => 'No notifications yet';

  @override
  String get searchNearMe => 'Use my location';

  @override
  String get searchNearMeHint => 'Sort lots by distance from you';

  @override
  String get locationFound => 'Centered on your location';

  @override
  String get locationUnavailable => 'Location unavailable — enable GPS & allow Parko in Settings';

  @override
  String searchSelected(String place) {
    return 'Searching near $place';
  }

  @override
  String get marketplacePhotoAdded => 'Photo added for verification (demo)';

  @override
  String get marketplaceChangePhoto => 'Change photo';

  @override
  String get legendAvailable => 'Open';

  @override
  String get legendLimited => 'Limited';

  @override
  String get legendFull => 'Full';

  @override
  String lotDistanceKm(String km) {
    return '$km km away';
  }

  @override
  String get reviewSectionTitle => 'Rate this lot';

  @override
  String get reviewSectionHint => 'Share your experience — earn 10 Parko Points once per day per lot.';

  @override
  String get reviewCommentHint => 'Optional comment';

  @override
  String get reviewSubmit => 'Submit review';

  @override
  String reviewSubmitted(String rating, int count, int points) {
    return 'Thanks! New rating $rating ★ ($count reviews) · +$points pts';
  }

  @override
  String get reviewAlreadyToday => 'You already reviewed this lot today.';

  @override
  String get reviewFailed => 'Could not submit review. Try again.';

  @override
  String get helpTitle => 'Help & FAQ';

  @override
  String get helpIntro => 'Quick answers about Parko in Kuwait — parking, wallet, and loyalty.';

  @override
  String get helpFaq1Q => 'How do I pay for parking?';

  @override
  String get helpFaq1A => 'Select a lot on the map, tap Pay now, and confirm with your Parko wallet. Top up in Wallet if your balance is low.';

  @override
  String get helpFaq2Q => 'What are Parko Points?';

  @override
  String get helpFaq2A => 'Earn points when you pay for parking, check in daily, and review lots. Redeem 100 points for 5 KWD wallet credit in Loyalty.';

  @override
  String get helpFaq3Q => 'Can I reserve a spot ahead?';

  @override
  String get helpFaq3A => 'Yes — open a lot and tap Reserve. Upcoming reservations appear under My Parking.';

  @override
  String get helpFaq4Q => 'Why does the map use OpenStreetMap?';

  @override
  String get helpFaq4A => 'Parko uses OSM by default so you can explore without a Google Maps billing account. Optional Google Maps is available via scripts/setup_google_maps_key.sh.';

  @override
  String get helpFaq5Q => 'How do shared parking and buddies work?';

  @override
  String get helpFaq5A => 'Leave early to share your spot, see buddies near you on the map, and list a private driveway in Marketplace.';

  @override
  String get helpContactTitle => 'Contact support';

  @override
  String get helpContactEmail => 'support@parko.kw';

  @override
  String get favoritesTitle => 'Saved lots';

  @override
  String get favoritesEmpty => 'Star a parking lot on the map to save it here for quick access.';

  @override
  String get favoritesAdded => 'Lot saved to favorites';

  @override
  String get favoritesRemoved => 'Removed from favorites';

  @override
  String favoritesSavedOn(String date) {
    return 'Saved $date';
  }

  @override
  String homeActiveSession(String lotName) {
    return 'Parking now · $lotName';
  }

  @override
  String get authOtpSent => 'Verification code sent';

  @override
  String get authOtpHint => '6-digit code';

  @override
  String get authOtpVerify => 'Verify & continue';

  @override
  String get authOtpInvalid => 'Invalid code. Demo code is 123456.';

  @override
  String get authOtpExpired => 'Code expired — request a new one';

  @override
  String get authDemoCodeHint => 'Demo OTP: 123456 (backend dev mode)';

  @override
  String get authChangePhone => 'Change phone number';

  @override
  String get searchRecentTitle => 'Recent';

  @override
  String get searchRecentClear => 'Clear';

  @override
  String get searchPopularTitle => 'Popular in Kuwait';

  @override
  String get sessionEnded => 'Parking session ended';

  @override
  String get sessionExtend30 => '+30 min';

  @override
  String sessionExtended(int minutes) {
    return 'Session extended by $minutes minutes';
  }

  @override
  String get homeRefreshed => 'Map data refreshed';

  @override
  String get settingsProfileSynced => 'Profile saved & synced to Parko';

  @override
  String authWelcomeBonus(String kwd, int points) {
    return 'Welcome! $kwd KWD wallet + $points Parko Points added';
  }

  @override
  String get filterQuickAll => 'All';

  @override
  String get filterQuickFree => 'Free';

  @override
  String get filterQuickValet => 'Valet';

  @override
  String get filterQuickReserve => 'Reservable';

  @override
  String get receiptTitle => 'Parking receipt';

  @override
  String get receiptDuration => 'Time parked';

  @override
  String get receiptPaid => 'Paid';

  @override
  String get receiptPoints => 'Parko Points';

  @override
  String receiptPointsEarned(int points) {
    return '+$points pts';
  }

  @override
  String get receiptViewHistory => 'View parking history';

  @override
  String get historyTypeSession => 'Walk-up session';

  @override
  String get historyTypeReservation => 'Reservation';

  @override
  String get historyWhen => 'When';

  @override
  String get historyShowOnMap => 'Show on map';

  @override
  String get homeCheckInPrompt => 'Daily check-in available — +5 Parko Points';

  @override
  String get reminderScheduled => 'Device reminder set 15 min before start';

  @override
  String get mapLoadErrorTitle => 'Could not load parking map';

  @override
  String get mapLoadErrorConnection => 'Parko API is not reachable. Start the backend, or the app will use demo lots when possible.';

  @override
  String get mapLoadErrorGeneric => 'Something went wrong loading parking data.';

  @override
  String mapLoadErrorApiHint(String url) {
    return 'API: $url';
  }

  @override
  String get mapRetry => 'Retry';

  @override
  String get mapOfflineFallback => 'Offline demo map — start backend for live data';

  @override
  String get mapNoLotsMatch => 'No lots match your filters';

  @override
  String get apiStatusLive => 'Live';

  @override
  String get apiStatusDemo => 'Demo';

  @override
  String get apiStatusOffline => 'Offline';

  @override
  String parkingStatsVisits(int count) {
    return '$count visits';
  }

  @override
  String parkingStatsSpent(String amount) {
    return '$amount KWD total spent';
  }

  @override
  String get signUpPhoneSubtitle => 'Enter your details, then verify your Kuwait mobile number with a one-time code.';

  @override
  String get signUpVerifyPhone => 'Continue with phone verification';

  @override
  String get signUpContinueOtp => 'Enter the code sent to your phone to finish signup.';

  @override
  String get emailHintOptional => 'Email (optional)';

  @override
  String get signUpPrompt => 'New to Parko?';

  @override
  String get mapLayersTitle => 'Map layers';

  @override
  String get mapLayersOverlays => 'Overlays';

  @override
  String get mapLayersSharedSpots => 'Shared spots';

  @override
  String get mapLayersPrivateSpots => 'Private garage listings';

  @override
  String get mapLayersStyle => 'Map style';

  @override
  String get mapLayersNormal => 'Standard';

  @override
  String get mapLayersSatellite => 'Satellite';

  @override
  String get shareLot => 'Share lot';

  @override
  String shareLotMessage(String name, String spots, String price, double lat, double lng) {
    return 'Park at $name on Parko — $spots spots · $price\nhttps://maps.google.com/?q=$lat,$lng';
  }

  @override
  String settingsMemberSince(String date) {
    return 'Member since $date';
  }

  @override
  String settingsUserId(String id) {
    return 'Account ID: $id';
  }

  @override
  String get buddyChatEmpty => 'Say hello to coordinate parking';

  @override
  String get mapTilesOfflineHint => 'Map background needs internet — parking markers still work';

  @override
  String get settingsCopyId => 'Copy account ID';

  @override
  String get settingsIdCopied => 'Account ID copied';

  @override
  String get searchLotsTitle => 'Parking lots';

  @override
  String searchLotSubtitle(String spots, String price) {
    return '$spots · $price';
  }

  @override
  String get searchNoResults => 'No destinations or lots match your search';

  @override
  String drawerWalletBalance(String amount) {
    return '$amount KWD';
  }

  @override
  String drawerPointsBalance(int points) {
    return '$points pts';
  }

  @override
  String get notificationsClearRead => 'Clear read';

  @override
  String get notificationsClearedRead => 'Read notifications cleared';

  @override
  String get walletTopUpCustomTitle => 'Custom top-up';

  @override
  String get walletTopUpCustomLabel => 'Amount';

  @override
  String get walletTopUpConfirm => 'Add funds';

  @override
  String get walletTopUpInvalid => 'Enter an amount between 1 and 500 KWD';

  @override
  String get homeFavoritesTitle => 'Saved lots';

  @override
  String get homeFavoritesSeeAll => 'See all';

  @override
  String lotHours(String hours) {
    return 'Hours: $hours';
  }

  @override
  String reserveWalletBalance(String amount) {
    return 'Wallet balance: $amount KWD';
  }

  @override
  String get reservePayFromWallet => 'Pay from wallet now';

  @override
  String get reservePayFromWalletHint => 'Hold your spot — amount deducted immediately';

  @override
  String get notificationsFilterAll => 'All';

  @override
  String get notificationsFilterReserve => 'Reservations';

  @override
  String get notificationsFilterWallet => 'Wallet';

  @override
  String get notificationsFilterShare => 'Shared';

  @override
  String get loyaltyRedeemConfirmBody => '100 points will be converted to 5 KWD wallet credit for parking.';

  @override
  String reserveCancelledRefund(String amount) {
    return 'Cancelled · $amount KWD refunded to wallet';
  }

  @override
  String get historyFilterAll => 'All';

  @override
  String get historyFilterSessions => 'Walk-up';

  @override
  String get historyFilterReservations => 'Reservations';

  @override
  String get helpFaq6Q => 'Do I get a refund if I cancel a reservation?';

  @override
  String get helpFaq6A => 'If you paid from your Parko wallet when booking, the amount is refunded automatically when you cancel before the start time.';

  @override
  String reserveCancelConfirmRefund(String amount) {
    return 'Cancel this reservation? $amount KWD will be refunded to your wallet.';
  }

  @override
  String get reserveCancelConfirmNoRefund => 'Cancel this reservation? Wallet refunds apply only before the start time.';

  @override
  String get reserveCancelledNoRefund => 'Reservation cancelled (no refund — start time has passed or not paid from wallet).';

  @override
  String get settingsTheme => 'Appearance';

  @override
  String get settingsThemeSystem => 'Match system';

  @override
  String get settingsThemeLight => 'Light';

  @override
  String get settingsThemeDark => 'Dark';
}
