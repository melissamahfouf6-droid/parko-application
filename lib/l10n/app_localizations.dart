import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ar.dart';
import 'app_localizations_en.dart';

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale) : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates = <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('ar'),
    Locale('en')
  ];

  /// No description provided for @appName.
  ///
  /// In en, this message translates to:
  /// **'Parko'**
  String get appName;

  /// No description provided for @tagline.
  ///
  /// In en, this message translates to:
  /// **'Smart Parking Solution'**
  String get tagline;

  /// No description provided for @getStarted.
  ///
  /// In en, this message translates to:
  /// **'Get Started'**
  String get getStarted;

  /// No description provided for @skip.
  ///
  /// In en, this message translates to:
  /// **'Skip'**
  String get skip;

  /// No description provided for @next.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get next;

  /// No description provided for @back.
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get back;

  /// No description provided for @onboardingTitle1.
  ///
  /// In en, this message translates to:
  /// **'Find parking instantly'**
  String get onboardingTitle1;

  /// No description provided for @onboardingBody1.
  ///
  /// In en, this message translates to:
  /// **'Real-time availability at malls, hospitals, universities'**
  String get onboardingBody1;

  /// No description provided for @onboardingTitle2.
  ///
  /// In en, this message translates to:
  /// **'Reserve your spot'**
  String get onboardingTitle2;

  /// No description provided for @onboardingBody2.
  ///
  /// In en, this message translates to:
  /// **'Book ahead and never circle looking for parking again'**
  String get onboardingBody2;

  /// No description provided for @onboardingTitle3.
  ///
  /// In en, this message translates to:
  /// **'Navigate to your spot'**
  String get onboardingTitle3;

  /// No description provided for @onboardingBody3.
  ///
  /// In en, this message translates to:
  /// **'Get guided to your exact parking location'**
  String get onboardingBody3;

  /// No description provided for @authTitle.
  ///
  /// In en, this message translates to:
  /// **'Welcome to Parko'**
  String get authTitle;

  /// No description provided for @phoneTab.
  ///
  /// In en, this message translates to:
  /// **'Phone'**
  String get phoneTab;

  /// No description provided for @emailTab.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get emailTab;

  /// No description provided for @phoneHint.
  ///
  /// In en, this message translates to:
  /// **'Phone number'**
  String get phoneHint;

  /// No description provided for @emailHint.
  ///
  /// In en, this message translates to:
  /// **'Email address'**
  String get emailHint;

  /// No description provided for @passwordHint.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get passwordHint;

  /// No description provided for @sendCode.
  ///
  /// In en, this message translates to:
  /// **'Send Code'**
  String get sendCode;

  /// No description provided for @signIn.
  ///
  /// In en, this message translates to:
  /// **'Sign in'**
  String get signIn;

  /// No description provided for @signUp.
  ///
  /// In en, this message translates to:
  /// **'Sign up'**
  String get signUp;

  /// No description provided for @signUpTitle.
  ///
  /// In en, this message translates to:
  /// **'Create your account'**
  String get signUpTitle;

  /// No description provided for @firstNameHint.
  ///
  /// In en, this message translates to:
  /// **'First name'**
  String get firstNameHint;

  /// No description provided for @lastNameHint.
  ///
  /// In en, this message translates to:
  /// **'Last name'**
  String get lastNameHint;

  /// No description provided for @confirmPasswordHint.
  ///
  /// In en, this message translates to:
  /// **'Confirm password'**
  String get confirmPasswordHint;

  /// No description provided for @createAccount.
  ///
  /// In en, this message translates to:
  /// **'Create account'**
  String get createAccount;

  /// No description provided for @passwordsDoNotMatch.
  ///
  /// In en, this message translates to:
  /// **'Passwords do not match'**
  String get passwordsDoNotMatch;

  /// No description provided for @fillAllFields.
  ///
  /// In en, this message translates to:
  /// **'Please fill all fields'**
  String get fillAllFields;

  /// No description provided for @forgotPasswordComingSoon.
  ///
  /// In en, this message translates to:
  /// **'Password reset will be available in a future update.'**
  String get forgotPasswordComingSoon;

  /// No description provided for @forgotPassword.
  ///
  /// In en, this message translates to:
  /// **'Forgot password?'**
  String get forgotPassword;

  /// No description provided for @searchHint.
  ///
  /// In en, this message translates to:
  /// **'Search destination or parking lot'**
  String get searchHint;

  /// No description provided for @availableNow.
  ///
  /// In en, this message translates to:
  /// **'Available now'**
  String get availableNow;

  /// No description provided for @reservableAhead.
  ///
  /// In en, this message translates to:
  /// **'Reservable in advance'**
  String get reservableAhead;

  /// No description provided for @showFullLots.
  ///
  /// In en, this message translates to:
  /// **'Show full lots'**
  String get showFullLots;

  /// No description provided for @resetFilters.
  ///
  /// In en, this message translates to:
  /// **'Reset filters'**
  String get resetFilters;

  /// No description provided for @applyFilters.
  ///
  /// In en, this message translates to:
  /// **'Apply filters'**
  String get applyFilters;

  /// No description provided for @navigateToParking.
  ///
  /// In en, this message translates to:
  /// **'Navigate to parking'**
  String get navigateToParking;

  /// No description provided for @reserveSpot.
  ///
  /// In en, this message translates to:
  /// **'Reserve spot'**
  String get reserveSpot;

  /// No description provided for @parkPayNow.
  ///
  /// In en, this message translates to:
  /// **'Park & Pay Now'**
  String get parkPayNow;

  /// No description provided for @drawerMyParking.
  ///
  /// In en, this message translates to:
  /// **'My parking'**
  String get drawerMyParking;

  /// No description provided for @drawerWallet.
  ///
  /// In en, this message translates to:
  /// **'Wallet & payments'**
  String get drawerWallet;

  /// No description provided for @drawerSettings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get drawerSettings;

  /// No description provided for @drawerLanguage.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get drawerLanguage;

  /// No description provided for @drawerSignOut.
  ///
  /// In en, this message translates to:
  /// **'Sign out'**
  String get drawerSignOut;

  /// No description provided for @drawerFindParking.
  ///
  /// In en, this message translates to:
  /// **'Find parking near me'**
  String get drawerFindParking;

  /// No description provided for @searchTitle.
  ///
  /// In en, this message translates to:
  /// **'Search'**
  String get searchTitle;

  /// No description provided for @myParkingTitle.
  ///
  /// In en, this message translates to:
  /// **'My parking'**
  String get myParkingTitle;

  /// No description provided for @tabActive.
  ///
  /// In en, this message translates to:
  /// **'Active'**
  String get tabActive;

  /// No description provided for @tabUpcoming.
  ///
  /// In en, this message translates to:
  /// **'Upcoming'**
  String get tabUpcoming;

  /// No description provided for @tabHistory.
  ///
  /// In en, this message translates to:
  /// **'History'**
  String get tabHistory;

  /// No description provided for @emptyActiveParking.
  ///
  /// In en, this message translates to:
  /// **'No active parking'**
  String get emptyActiveParking;

  /// No description provided for @emptyUpcoming.
  ///
  /// In en, this message translates to:
  /// **'No upcoming reservations'**
  String get emptyUpcoming;

  /// No description provided for @emptyHistory.
  ///
  /// In en, this message translates to:
  /// **'No past sessions yet'**
  String get emptyHistory;

  /// No description provided for @mapPreviewTitle.
  ///
  /// In en, this message translates to:
  /// **'Map preview'**
  String get mapPreviewTitle;

  /// No description provided for @mapPreviewHint.
  ///
  /// In en, this message translates to:
  /// **'Google Maps is not embedded on macOS, Linux, or Windows desktop builds. Use iOS Simulator, Android, or Chrome (web) for the live map. Tap a marker below for lot details.'**
  String get mapPreviewHint;

  /// No description provided for @distanceAwayWalk.
  ///
  /// In en, this message translates to:
  /// **'{distance} away • {minutes} min walk'**
  String distanceAwayWalk(String distance, int minutes);

  /// No description provided for @drawerLoyalty.
  ///
  /// In en, this message translates to:
  /// **'Parko Points'**
  String get drawerLoyalty;

  /// No description provided for @loyaltyScreenTitle.
  ///
  /// In en, this message translates to:
  /// **'Parko Points'**
  String get loyaltyScreenTitle;

  /// No description provided for @loyaltyScreenSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Earn نقاط باركو on every visit · redeem for free parking'**
  String get loyaltyScreenSubtitle;

  /// No description provided for @loyaltyBalance.
  ///
  /// In en, this message translates to:
  /// **'Balance: {points} pts'**
  String loyaltyBalance(int points);

  /// No description provided for @loyaltyLifetime.
  ///
  /// In en, this message translates to:
  /// **'Lifetime: {points} pts'**
  String loyaltyLifetime(int points);

  /// No description provided for @loyaltyTierBronze.
  ///
  /// In en, this message translates to:
  /// **'Bronze'**
  String get loyaltyTierBronze;

  /// No description provided for @loyaltyTierSilver.
  ///
  /// In en, this message translates to:
  /// **'Silver'**
  String get loyaltyTierSilver;

  /// No description provided for @loyaltyTierGold.
  ///
  /// In en, this message translates to:
  /// **'Gold'**
  String get loyaltyTierGold;

  /// No description provided for @loyaltyTierPlatinum.
  ///
  /// In en, this message translates to:
  /// **'Platinum'**
  String get loyaltyTierPlatinum;

  /// No description provided for @loyaltyProgressToNext.
  ///
  /// In en, this message translates to:
  /// **'{points} pts to {tierName}'**
  String loyaltyProgressToNext(int points, String tierName);

  /// No description provided for @loyaltyMaxTier.
  ///
  /// In en, this message translates to:
  /// **'Platinum — keep earning for redemptions'**
  String get loyaltyMaxTier;

  /// No description provided for @loyaltyDailyCheckIn.
  ///
  /// In en, this message translates to:
  /// **'Daily check-in (+5)'**
  String get loyaltyDailyCheckIn;

  /// No description provided for @loyaltyDemoParking.
  ///
  /// In en, this message translates to:
  /// **'Demo: complete session (3.5 KWD)'**
  String get loyaltyDemoParking;

  /// No description provided for @loyaltyRedeem100.
  ///
  /// In en, this message translates to:
  /// **'Redeem 100 pts → 5 KWD credit'**
  String get loyaltyRedeem100;

  /// No description provided for @loyaltyRewardsTitle.
  ///
  /// In en, this message translates to:
  /// **'Rewards catalog'**
  String get loyaltyRewardsTitle;

  /// No description provided for @loyaltyRedemptionRule.
  ///
  /// In en, this message translates to:
  /// **'100 points = 5 KWD parking credit'**
  String get loyaltyRedemptionRule;

  /// No description provided for @loyaltyTiersTitle.
  ///
  /// In en, this message translates to:
  /// **'Levels & perks'**
  String get loyaltyTiersTitle;

  /// No description provided for @loyaltyHistoryTitle.
  ///
  /// In en, this message translates to:
  /// **'Points history'**
  String get loyaltyHistoryTitle;

  /// No description provided for @loyaltyEmptyHistory.
  ///
  /// In en, this message translates to:
  /// **'No transactions yet'**
  String get loyaltyEmptyHistory;

  /// No description provided for @loyaltyEarnAtLot.
  ///
  /// In en, this message translates to:
  /// **'Earn up to {points} pts on paid visits here'**
  String loyaltyEarnAtLot(int points);

  /// No description provided for @loyaltySnackEarned.
  ///
  /// In en, this message translates to:
  /// **'You earned {points} pts!'**
  String loyaltySnackEarned(int points);

  /// No description provided for @loyaltySnackLevelUp.
  ///
  /// In en, this message translates to:
  /// **'Level up! You are now {tier}'**
  String loyaltySnackLevelUp(String tier);

  /// No description provided for @loyaltySnackRedeem.
  ///
  /// In en, this message translates to:
  /// **'Redeemed 100 pts for parking credit'**
  String get loyaltySnackRedeem;

  /// No description provided for @loyaltySnackCheckIn.
  ///
  /// In en, this message translates to:
  /// **'+5 pts daily check-in'**
  String get loyaltySnackCheckIn;

  /// No description provided for @loyaltyErrCheckInDone.
  ///
  /// In en, this message translates to:
  /// **'Already checked in today'**
  String get loyaltyErrCheckInDone;

  /// No description provided for @loyaltyErrBalance.
  ///
  /// In en, this message translates to:
  /// **'Not enough points'**
  String get loyaltyErrBalance;

  /// No description provided for @loyaltyRedeemConfirmTitle.
  ///
  /// In en, this message translates to:
  /// **'Redeem 100 points?'**
  String get loyaltyRedeemConfirmTitle;

  /// No description provided for @loyaltyCancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get loyaltyCancel;

  /// No description provided for @loyaltyConfirm.
  ///
  /// In en, this message translates to:
  /// **'Redeem'**
  String get loyaltyConfirm;

  /// No description provided for @loyaltyPerkBronze.
  ///
  /// In en, this message translates to:
  /// **'Bronze (0–499): standard'**
  String get loyaltyPerkBronze;

  /// No description provided for @loyaltyPerkSilver.
  ///
  /// In en, this message translates to:
  /// **'Silver (500–1999): 5% parking discount'**
  String get loyaltyPerkSilver;

  /// No description provided for @loyaltyPerkGold.
  ///
  /// In en, this message translates to:
  /// **'Gold (2000–4999): 10% + priority reservations'**
  String get loyaltyPerkGold;

  /// No description provided for @loyaltyPerkPlatinum.
  ///
  /// In en, this message translates to:
  /// **'Platinum (5000+): 15% + VIP spots + valet perks'**
  String get loyaltyPerkPlatinum;

  /// No description provided for @loyaltyApiHint.
  ///
  /// In en, this message translates to:
  /// **'Run backend and launch with --dart-define=PARKO_API_BASE=… to sync points.'**
  String get loyaltyApiHint;

  /// No description provided for @loyaltyHomeBadge.
  ///
  /// In en, this message translates to:
  /// **'{points} pts'**
  String loyaltyHomeBadge(String points);

  /// No description provided for @predictionBannerOpens.
  ///
  /// In en, this message translates to:
  /// **'Predicted: {lotName} eases in ~{minutes} min'**
  String predictionBannerOpens(String lotName, int minutes);

  /// No description provided for @predictionChance.
  ///
  /// In en, this message translates to:
  /// **'{percent}% chance of finding parking soon'**
  String predictionChance(int percent);

  /// No description provided for @predictionSectionTitle.
  ///
  /// In en, this message translates to:
  /// **'Smart prediction'**
  String get predictionSectionTitle;

  /// No description provided for @predictionTypicalOpens.
  ///
  /// In en, this message translates to:
  /// **'Usually opens around {time}'**
  String predictionTypicalOpens(String time);

  /// No description provided for @predictionPatternTitle.
  ///
  /// In en, this message translates to:
  /// **'Typical fill today'**
  String get predictionPatternTitle;

  /// No description provided for @predictionNotifyMe.
  ///
  /// In en, this message translates to:
  /// **'Notify me when available'**
  String get predictionNotifyMe;

  /// No description provided for @predictionNotifyDone.
  ///
  /// In en, this message translates to:
  /// **'You will be notified when spots open'**
  String get predictionNotifyDone;

  /// No description provided for @predictionNotifyAlready.
  ///
  /// In en, this message translates to:
  /// **'Already on the waitlist for this lot'**
  String get predictionNotifyAlready;

  /// No description provided for @shareSpotTitle.
  ///
  /// In en, this message translates to:
  /// **'Share your spot'**
  String get shareSpotTitle;

  /// No description provided for @shareSpotFab.
  ///
  /// In en, this message translates to:
  /// **'Share spot'**
  String get shareSpotFab;

  /// No description provided for @shareAvailableNow.
  ///
  /// In en, this message translates to:
  /// **'{count} spots shared nearby — save up to 20%'**
  String shareAvailableNow(int count);

  /// No description provided for @shareLeaveEarly.
  ///
  /// In en, this message translates to:
  /// **'Leave early — sell my spot'**
  String get shareLeaveEarly;

  /// No description provided for @shareLeaveEarlyTitle.
  ///
  /// In en, this message translates to:
  /// **'بيع موقفي'**
  String get shareLeaveEarlyTitle;

  /// No description provided for @shareLeaveEarlyBody.
  ///
  /// In en, this message translates to:
  /// **'List your remaining time at a 20% discount. You get 70% refund; buyer enters within 10 minutes.'**
  String get shareLeaveEarlyBody;

  /// No description provided for @shareConfirmList.
  ///
  /// In en, this message translates to:
  /// **'List my spot for sale'**
  String get shareConfirmList;

  /// No description provided for @shareListedSuccess.
  ///
  /// In en, this message translates to:
  /// **'Listed! Refund {amount} KWD credited (demo).'**
  String shareListedSuccess(String amount);

  /// No description provided for @shareActiveSession.
  ///
  /// In en, this message translates to:
  /// **'Active at {lotName}'**
  String shareActiveSession(String lotName);

  /// No description provided for @shareTimeLeft.
  ///
  /// In en, this message translates to:
  /// **'{hours}h {minutes}m left'**
  String shareTimeLeft(int hours, int minutes);

  /// No description provided for @shareStartDemoSession.
  ///
  /// In en, this message translates to:
  /// **'Start demo parking session'**
  String get shareStartDemoSession;

  /// No description provided for @shareEndSession.
  ///
  /// In en, this message translates to:
  /// **'End session'**
  String get shareEndSession;

  /// No description provided for @shareBuyNow.
  ///
  /// In en, this message translates to:
  /// **'Get this spot — {price} KWD'**
  String shareBuyNow(String price);

  /// No description provided for @shareClaimSuccess.
  ///
  /// In en, this message translates to:
  /// **'Spot claimed! Head there within 10 minutes.'**
  String get shareClaimSuccess;

  /// No description provided for @shareSheetTitle.
  ///
  /// In en, this message translates to:
  /// **'Shared parking — available now'**
  String get shareSheetTitle;

  /// No description provided for @shareRemaining.
  ///
  /// In en, this message translates to:
  /// **'{minutes} min left • {discount}% off'**
  String shareRemaining(int minutes, int discount);

  /// No description provided for @buddyCardGoing.
  ///
  /// In en, this message translates to:
  /// **'{count} people going to {destination} now'**
  String buddyCardGoing(int count, String destination);

  /// No description provided for @buddyFindTitle.
  ///
  /// In en, this message translates to:
  /// **'Parking buddies'**
  String get buddyFindTitle;

  /// No description provided for @buddyJoinSearch.
  ///
  /// In en, this message translates to:
  /// **'Join — find a buddy'**
  String get buddyJoinSearch;

  /// No description provided for @buddyJoined.
  ///
  /// In en, this message translates to:
  /// **'You joined the buddy search!'**
  String get buddyJoined;

  /// No description provided for @buddyChatHint.
  ///
  /// In en, this message translates to:
  /// **'Tap a buddy to chat and coordinate parking.'**
  String get buddyChatHint;

  /// No description provided for @buddyEmpty.
  ///
  /// In en, this message translates to:
  /// **'No buddies for this destination yet. Be the first!'**
  String get buddyEmpty;

  /// No description provided for @buddySeatsNeeded.
  ///
  /// In en, this message translates to:
  /// **'{count} seat(s) needed'**
  String buddySeatsNeeded(int count);

  /// No description provided for @buddySearchAction.
  ///
  /// In en, this message translates to:
  /// **'Find parking buddy'**
  String get buddySearchAction;

  /// No description provided for @marketplaceCta.
  ///
  /// In en, this message translates to:
  /// **'Earn ~{amount} KWD/mo — list your driveway'**
  String marketplaceCta(String amount);

  /// No description provided for @marketplaceListTitle.
  ///
  /// In en, this message translates to:
  /// **'Parking marketplace'**
  String get marketplaceListTitle;

  /// No description provided for @marketplaceListMySpot.
  ///
  /// In en, this message translates to:
  /// **'List my spot'**
  String get marketplaceListMySpot;

  /// No description provided for @marketplaceSpotTitleHint.
  ///
  /// In en, this message translates to:
  /// **'Spot title (e.g. Salmiya driveway)'**
  String get marketplaceSpotTitleHint;

  /// No description provided for @marketplacePriceHint.
  ///
  /// In en, this message translates to:
  /// **'Price per day (KWD)'**
  String get marketplacePriceHint;

  /// No description provided for @marketplaceAvailabilityHint.
  ///
  /// In en, this message translates to:
  /// **'Availability'**
  String get marketplaceAvailabilityHint;

  /// No description provided for @marketplaceAddPhoto.
  ///
  /// In en, this message translates to:
  /// **'Add photo (verification)'**
  String get marketplaceAddPhoto;

  /// No description provided for @marketplacePhotoHint.
  ///
  /// In en, this message translates to:
  /// **'Photo verification — camera upload in next build.'**
  String get marketplacePhotoHint;

  /// No description provided for @marketplaceSubmit.
  ///
  /// In en, this message translates to:
  /// **'Publish listing'**
  String get marketplaceSubmit;

  /// No description provided for @marketplaceListed.
  ///
  /// In en, this message translates to:
  /// **'Your spot is live on the map!'**
  String get marketplaceListed;

  /// No description provided for @marketplaceBrowseTitle.
  ///
  /// In en, this message translates to:
  /// **'Nearby private spots'**
  String get marketplaceBrowseTitle;

  /// No description provided for @marketplaceVerified.
  ///
  /// In en, this message translates to:
  /// **'Photo verified (demo)'**
  String get marketplaceVerified;

  /// No description provided for @marketplaceBookSpot.
  ///
  /// In en, this message translates to:
  /// **'Book this spot'**
  String get marketplaceBookSpot;

  /// No description provided for @marketplaceBookSoon.
  ///
  /// In en, this message translates to:
  /// **'Booking & payment — Tap/Stripe next.'**
  String get marketplaceBookSoon;

  /// No description provided for @marketplaceNearLot.
  ///
  /// In en, this message translates to:
  /// **'{count} resident spots nearby from {price} KWD/day'**
  String marketplaceNearLot(int count, String price);

  /// No description provided for @drawerMarketplace.
  ///
  /// In en, this message translates to:
  /// **'List my spot (marketplace)'**
  String get drawerMarketplace;

  /// No description provided for @drawerBuddies.
  ///
  /// In en, this message translates to:
  /// **'Parking buddies'**
  String get drawerBuddies;

  /// No description provided for @reserveTitle.
  ///
  /// In en, this message translates to:
  /// **'Reserve parking'**
  String get reserveTitle;

  /// No description provided for @reserveWhen.
  ///
  /// In en, this message translates to:
  /// **'When'**
  String get reserveWhen;

  /// No description provided for @reserveToday.
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get reserveToday;

  /// No description provided for @reserveTomorrow.
  ///
  /// In en, this message translates to:
  /// **'Tomorrow'**
  String get reserveTomorrow;

  /// No description provided for @reserveDuration.
  ///
  /// In en, this message translates to:
  /// **'Duration'**
  String get reserveDuration;

  /// No description provided for @reserveDuration1h.
  ///
  /// In en, this message translates to:
  /// **'1 hour'**
  String get reserveDuration1h;

  /// No description provided for @reserveDuration2h.
  ///
  /// In en, this message translates to:
  /// **'2 hours'**
  String get reserveDuration2h;

  /// No description provided for @reserveDuration3h.
  ///
  /// In en, this message translates to:
  /// **'3 hours'**
  String get reserveDuration3h;

  /// No description provided for @reserveDurationAllDay.
  ///
  /// In en, this message translates to:
  /// **'All day'**
  String get reserveDurationAllDay;

  /// No description provided for @reserveZoneHint.
  ///
  /// In en, this message translates to:
  /// **'Zone / level (optional)'**
  String get reserveZoneHint;

  /// No description provided for @reserveTotal.
  ///
  /// In en, this message translates to:
  /// **'Estimated total: {price} KWD'**
  String reserveTotal(String price);

  /// No description provided for @reserveConfirm.
  ///
  /// In en, this message translates to:
  /// **'Confirm reservation'**
  String get reserveConfirm;

  /// No description provided for @reserveSuccess.
  ///
  /// In en, this message translates to:
  /// **'Spot reserved! See My parking → Upcoming.'**
  String get reserveSuccess;

  /// No description provided for @reserveCancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel reservation'**
  String get reserveCancel;

  /// No description provided for @reserveCancelConfirm.
  ///
  /// In en, this message translates to:
  /// **'Cancel this reservation?'**
  String get reserveCancelConfirm;

  /// No description provided for @reserveCancelled.
  ///
  /// In en, this message translates to:
  /// **'Reservation cancelled'**
  String get reserveCancelled;

  /// No description provided for @reserveStartsInHours.
  ///
  /// In en, this message translates to:
  /// **'Starts in {hours}h {mins}m'**
  String reserveStartsInHours(int hours, int mins);

  /// No description provided for @reserveStartsInMins.
  ///
  /// In en, this message translates to:
  /// **'Starts in {mins} min'**
  String reserveStartsInMins(int mins);

  /// No description provided for @homeNextReservation.
  ///
  /// In en, this message translates to:
  /// **'Reserved: {lot}'**
  String homeNextReservation(String lot);

  /// No description provided for @reserveNavigateHint.
  ///
  /// In en, this message translates to:
  /// **'Opening directions to {lot}…'**
  String reserveNavigateHint(String lot);

  /// No description provided for @reservePaySoon.
  ///
  /// In en, this message translates to:
  /// **'Pay at arrival — Tap/Stripe wallet next.'**
  String get reservePaySoon;

  /// No description provided for @walletTitle.
  ///
  /// In en, this message translates to:
  /// **'Wallet & payments'**
  String get walletTitle;

  /// No description provided for @walletBalanceLabel.
  ///
  /// In en, this message translates to:
  /// **'Available balance'**
  String get walletBalanceLabel;

  /// No description provided for @walletBalanceAmount.
  ///
  /// In en, this message translates to:
  /// **'{amount} KWD'**
  String walletBalanceAmount(String amount);

  /// No description provided for @walletTopUpTitle.
  ///
  /// In en, this message translates to:
  /// **'Quick top-up (demo)'**
  String get walletTopUpTitle;

  /// No description provided for @walletTopUpAmount.
  ///
  /// In en, this message translates to:
  /// **'+{amount} KWD'**
  String walletTopUpAmount(String amount);

  /// No description provided for @walletTopUpHint.
  ///
  /// In en, this message translates to:
  /// **'Simulates KNET / Tap — production keys later.'**
  String get walletTopUpHint;

  /// No description provided for @walletTopUpSuccess.
  ///
  /// In en, this message translates to:
  /// **'Added {amount} KWD to your wallet'**
  String walletTopUpSuccess(String amount);

  /// No description provided for @walletKnet.
  ///
  /// In en, this message translates to:
  /// **'KNET'**
  String get walletKnet;

  /// No description provided for @walletTap.
  ///
  /// In en, this message translates to:
  /// **'Tap'**
  String get walletTap;

  /// No description provided for @walletHistory.
  ///
  /// In en, this message translates to:
  /// **'Recent activity'**
  String get walletHistory;

  /// No description provided for @walletEmptyHistory.
  ///
  /// In en, this message translates to:
  /// **'No transactions yet'**
  String get walletEmptyHistory;

  /// No description provided for @walletTxType.
  ///
  /// In en, this message translates to:
  /// **'Transaction'**
  String get walletTxType;

  /// No description provided for @walletPayTitle.
  ///
  /// In en, this message translates to:
  /// **'Pay for parking'**
  String get walletPayTitle;

  /// No description provided for @walletPayBalance.
  ///
  /// In en, this message translates to:
  /// **'Wallet balance: {amount} KWD'**
  String walletPayBalance(String amount);

  /// No description provided for @walletPayAmount.
  ///
  /// In en, this message translates to:
  /// **'Total: {amount} KWD'**
  String walletPayAmount(String amount);

  /// No description provided for @walletPayFree.
  ///
  /// In en, this message translates to:
  /// **'This lot is free — starting session without charge.'**
  String get walletPayFree;

  /// No description provided for @walletPayConfirm.
  ///
  /// In en, this message translates to:
  /// **'Pay with wallet'**
  String get walletPayConfirm;

  /// No description provided for @walletPaySuccess.
  ///
  /// In en, this message translates to:
  /// **'Paid — active parking started'**
  String get walletPaySuccess;

  /// No description provided for @walletInsufficient.
  ///
  /// In en, this message translates to:
  /// **'Insufficient wallet balance. Top up in Wallet.'**
  String get walletInsufficient;

  /// No description provided for @walletBalanceUnknown.
  ///
  /// In en, this message translates to:
  /// **'Balance unavailable'**
  String get walletBalanceUnknown;

  /// No description provided for @mapsOpenFailed.
  ///
  /// In en, this message translates to:
  /// **'Could not open maps on this device'**
  String get mapsOpenFailed;

  /// No description provided for @walletHomeChip.
  ///
  /// In en, this message translates to:
  /// **'{amount} KWD'**
  String walletHomeChip(String amount);

  /// No description provided for @settingsTitle.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settingsTitle;

  /// No description provided for @settingsProfileSection.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get settingsProfileSection;

  /// No description provided for @settingsNameLabel.
  ///
  /// In en, this message translates to:
  /// **'Display name'**
  String get settingsNameLabel;

  /// No description provided for @settingsPhoneLabel.
  ///
  /// In en, this message translates to:
  /// **'Phone'**
  String get settingsPhoneLabel;

  /// No description provided for @settingsEmailLabel.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get settingsEmailLabel;

  /// No description provided for @settingsSaveProfile.
  ///
  /// In en, this message translates to:
  /// **'Save profile'**
  String get settingsSaveProfile;

  /// No description provided for @settingsProfileSaved.
  ///
  /// In en, this message translates to:
  /// **'Profile saved'**
  String get settingsProfileSaved;

  /// No description provided for @settingsNotificationsSection.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get settingsNotificationsSection;

  /// No description provided for @settingsParkingReminders.
  ///
  /// In en, this message translates to:
  /// **'Parking reminders'**
  String get settingsParkingReminders;

  /// No description provided for @settingsParkingRemindersHint.
  ///
  /// In en, this message translates to:
  /// **'Reservation start & lot availability alerts'**
  String get settingsParkingRemindersHint;

  /// No description provided for @settingsMarketing.
  ///
  /// In en, this message translates to:
  /// **'Offers & news'**
  String get settingsMarketing;

  /// No description provided for @settingsMarketingHint.
  ///
  /// In en, this message translates to:
  /// **'Mall deals and Parko promotions'**
  String get settingsMarketingHint;

  /// No description provided for @settingsAppSection.
  ///
  /// In en, this message translates to:
  /// **'App'**
  String get settingsAppSection;

  /// No description provided for @settingsAbout.
  ///
  /// In en, this message translates to:
  /// **'About Parko'**
  String get settingsAbout;

  /// No description provided for @settingsVersion.
  ///
  /// In en, this message translates to:
  /// **'Version {version}'**
  String settingsVersion(String version);

  /// No description provided for @loyaltySnackRedeemWallet.
  ///
  /// In en, this message translates to:
  /// **'{amount} KWD added to your Parko wallet'**
  String loyaltySnackRedeemWallet(String amount);

  /// No description provided for @buddyChatSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Coordinate meetup & split parking'**
  String get buddyChatSubtitle;

  /// No description provided for @buddyChatInputHint.
  ///
  /// In en, this message translates to:
  /// **'Message…'**
  String get buddyChatInputHint;

  /// No description provided for @filterTitle.
  ///
  /// In en, this message translates to:
  /// **'Map filters'**
  String get filterTitle;

  /// No description provided for @filterApplied.
  ///
  /// In en, this message translates to:
  /// **'Showing {count} parking locations'**
  String filterApplied(int count);

  /// No description provided for @notificationsTitle.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get notificationsTitle;

  /// No description provided for @notificationsMarkAllRead.
  ///
  /// In en, this message translates to:
  /// **'Mark all read'**
  String get notificationsMarkAllRead;

  /// No description provided for @notificationsEmpty.
  ///
  /// In en, this message translates to:
  /// **'No notifications yet'**
  String get notificationsEmpty;

  /// No description provided for @searchNearMe.
  ///
  /// In en, this message translates to:
  /// **'Use my location'**
  String get searchNearMe;

  /// No description provided for @searchNearMeHint.
  ///
  /// In en, this message translates to:
  /// **'Sort lots by distance from you'**
  String get searchNearMeHint;

  /// No description provided for @locationFound.
  ///
  /// In en, this message translates to:
  /// **'Centered on your location'**
  String get locationFound;

  /// No description provided for @locationUnavailable.
  ///
  /// In en, this message translates to:
  /// **'Location unavailable — enable GPS & allow Parko in Settings'**
  String get locationUnavailable;

  /// No description provided for @searchSelected.
  ///
  /// In en, this message translates to:
  /// **'Searching near {place}'**
  String searchSelected(String place);

  /// No description provided for @marketplacePhotoAdded.
  ///
  /// In en, this message translates to:
  /// **'Photo added for verification (demo)'**
  String get marketplacePhotoAdded;

  /// No description provided for @marketplaceChangePhoto.
  ///
  /// In en, this message translates to:
  /// **'Change photo'**
  String get marketplaceChangePhoto;

  /// No description provided for @legendAvailable.
  ///
  /// In en, this message translates to:
  /// **'Open'**
  String get legendAvailable;

  /// No description provided for @legendLimited.
  ///
  /// In en, this message translates to:
  /// **'Limited'**
  String get legendLimited;

  /// No description provided for @legendFull.
  ///
  /// In en, this message translates to:
  /// **'Full'**
  String get legendFull;

  /// No description provided for @lotDistanceKm.
  ///
  /// In en, this message translates to:
  /// **'{km} km away'**
  String lotDistanceKm(String km);

  /// No description provided for @reviewSectionTitle.
  ///
  /// In en, this message translates to:
  /// **'Rate this lot'**
  String get reviewSectionTitle;

  /// No description provided for @reviewSectionHint.
  ///
  /// In en, this message translates to:
  /// **'Share your experience — earn 10 Parko Points once per day per lot.'**
  String get reviewSectionHint;

  /// No description provided for @reviewCommentHint.
  ///
  /// In en, this message translates to:
  /// **'Optional comment'**
  String get reviewCommentHint;

  /// No description provided for @reviewSubmit.
  ///
  /// In en, this message translates to:
  /// **'Submit review'**
  String get reviewSubmit;

  /// No description provided for @reviewSubmitted.
  ///
  /// In en, this message translates to:
  /// **'Thanks! New rating {rating} ★ ({count} reviews) · +{points} pts'**
  String reviewSubmitted(String rating, int count, int points);

  /// No description provided for @reviewAlreadyToday.
  ///
  /// In en, this message translates to:
  /// **'You already reviewed this lot today.'**
  String get reviewAlreadyToday;

  /// No description provided for @reviewFailed.
  ///
  /// In en, this message translates to:
  /// **'Could not submit review. Try again.'**
  String get reviewFailed;

  /// No description provided for @helpTitle.
  ///
  /// In en, this message translates to:
  /// **'Help & FAQ'**
  String get helpTitle;

  /// No description provided for @helpIntro.
  ///
  /// In en, this message translates to:
  /// **'Quick answers about Parko in Kuwait — parking, wallet, and loyalty.'**
  String get helpIntro;

  /// No description provided for @helpFaq1Q.
  ///
  /// In en, this message translates to:
  /// **'How do I pay for parking?'**
  String get helpFaq1Q;

  /// No description provided for @helpFaq1A.
  ///
  /// In en, this message translates to:
  /// **'Select a lot on the map, tap Pay now, and confirm with your Parko wallet. Top up in Wallet if your balance is low.'**
  String get helpFaq1A;

  /// No description provided for @helpFaq2Q.
  ///
  /// In en, this message translates to:
  /// **'What are Parko Points?'**
  String get helpFaq2Q;

  /// No description provided for @helpFaq2A.
  ///
  /// In en, this message translates to:
  /// **'Earn points when you pay for parking, check in daily, and review lots. Redeem 100 points for 5 KWD wallet credit in Loyalty.'**
  String get helpFaq2A;

  /// No description provided for @helpFaq3Q.
  ///
  /// In en, this message translates to:
  /// **'Can I reserve a spot ahead?'**
  String get helpFaq3Q;

  /// No description provided for @helpFaq3A.
  ///
  /// In en, this message translates to:
  /// **'Yes — open a lot and tap Reserve. Upcoming reservations appear under My Parking.'**
  String get helpFaq3A;

  /// No description provided for @helpFaq4Q.
  ///
  /// In en, this message translates to:
  /// **'Why does the map use OpenStreetMap?'**
  String get helpFaq4Q;

  /// No description provided for @helpFaq4A.
  ///
  /// In en, this message translates to:
  /// **'Parko uses OSM by default so you can explore without a Google Maps billing account. Optional Google Maps is available via scripts/setup_google_maps_key.sh.'**
  String get helpFaq4A;

  /// No description provided for @helpFaq5Q.
  ///
  /// In en, this message translates to:
  /// **'How do shared parking and buddies work?'**
  String get helpFaq5Q;

  /// No description provided for @helpFaq5A.
  ///
  /// In en, this message translates to:
  /// **'Leave early to share your spot, see buddies near you on the map, and list a private driveway in Marketplace.'**
  String get helpFaq5A;

  /// No description provided for @helpContactTitle.
  ///
  /// In en, this message translates to:
  /// **'Contact support'**
  String get helpContactTitle;

  /// No description provided for @helpContactEmail.
  ///
  /// In en, this message translates to:
  /// **'support@parko.kw'**
  String get helpContactEmail;

  /// No description provided for @favoritesTitle.
  ///
  /// In en, this message translates to:
  /// **'Saved lots'**
  String get favoritesTitle;

  /// No description provided for @favoritesEmpty.
  ///
  /// In en, this message translates to:
  /// **'Star a parking lot on the map to save it here for quick access.'**
  String get favoritesEmpty;

  /// No description provided for @favoritesAdded.
  ///
  /// In en, this message translates to:
  /// **'Lot saved to favorites'**
  String get favoritesAdded;

  /// No description provided for @favoritesRemoved.
  ///
  /// In en, this message translates to:
  /// **'Removed from favorites'**
  String get favoritesRemoved;

  /// No description provided for @favoritesSavedOn.
  ///
  /// In en, this message translates to:
  /// **'Saved {date}'**
  String favoritesSavedOn(String date);

  /// No description provided for @homeActiveSession.
  ///
  /// In en, this message translates to:
  /// **'Parking now · {lotName}'**
  String homeActiveSession(String lotName);

  /// No description provided for @authOtpSent.
  ///
  /// In en, this message translates to:
  /// **'Verification code sent'**
  String get authOtpSent;

  /// No description provided for @authOtpHint.
  ///
  /// In en, this message translates to:
  /// **'6-digit code'**
  String get authOtpHint;

  /// No description provided for @authOtpVerify.
  ///
  /// In en, this message translates to:
  /// **'Verify & continue'**
  String get authOtpVerify;

  /// No description provided for @authOtpInvalid.
  ///
  /// In en, this message translates to:
  /// **'Invalid code. Demo code is 123456.'**
  String get authOtpInvalid;

  /// No description provided for @authOtpExpired.
  ///
  /// In en, this message translates to:
  /// **'Code expired — request a new one'**
  String get authOtpExpired;

  /// No description provided for @authDemoCodeHint.
  ///
  /// In en, this message translates to:
  /// **'Demo OTP: 123456 (backend dev mode)'**
  String get authDemoCodeHint;

  /// No description provided for @authChangePhone.
  ///
  /// In en, this message translates to:
  /// **'Change phone number'**
  String get authChangePhone;

  /// No description provided for @searchRecentTitle.
  ///
  /// In en, this message translates to:
  /// **'Recent'**
  String get searchRecentTitle;

  /// No description provided for @searchRecentClear.
  ///
  /// In en, this message translates to:
  /// **'Clear'**
  String get searchRecentClear;

  /// No description provided for @searchPopularTitle.
  ///
  /// In en, this message translates to:
  /// **'Popular in Kuwait'**
  String get searchPopularTitle;

  /// No description provided for @sessionEnded.
  ///
  /// In en, this message translates to:
  /// **'Parking session ended'**
  String get sessionEnded;

  /// No description provided for @sessionExtend30.
  ///
  /// In en, this message translates to:
  /// **'+30 min'**
  String get sessionExtend30;

  /// No description provided for @sessionExtended.
  ///
  /// In en, this message translates to:
  /// **'Session extended by {minutes} minutes'**
  String sessionExtended(int minutes);

  /// No description provided for @homeRefreshed.
  ///
  /// In en, this message translates to:
  /// **'Map data refreshed'**
  String get homeRefreshed;

  /// No description provided for @settingsProfileSynced.
  ///
  /// In en, this message translates to:
  /// **'Profile saved & synced to Parko'**
  String get settingsProfileSynced;

  /// No description provided for @authWelcomeBonus.
  ///
  /// In en, this message translates to:
  /// **'Welcome! {kwd} KWD wallet + {points} Parko Points added'**
  String authWelcomeBonus(String kwd, int points);

  /// No description provided for @filterQuickAll.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get filterQuickAll;

  /// No description provided for @filterQuickFree.
  ///
  /// In en, this message translates to:
  /// **'Free'**
  String get filterQuickFree;

  /// No description provided for @filterQuickValet.
  ///
  /// In en, this message translates to:
  /// **'Valet'**
  String get filterQuickValet;

  /// No description provided for @filterQuickReserve.
  ///
  /// In en, this message translates to:
  /// **'Reservable'**
  String get filterQuickReserve;

  /// No description provided for @receiptTitle.
  ///
  /// In en, this message translates to:
  /// **'Parking receipt'**
  String get receiptTitle;

  /// No description provided for @receiptDuration.
  ///
  /// In en, this message translates to:
  /// **'Time parked'**
  String get receiptDuration;

  /// No description provided for @receiptPaid.
  ///
  /// In en, this message translates to:
  /// **'Paid'**
  String get receiptPaid;

  /// No description provided for @receiptPoints.
  ///
  /// In en, this message translates to:
  /// **'Parko Points'**
  String get receiptPoints;

  /// No description provided for @receiptPointsEarned.
  ///
  /// In en, this message translates to:
  /// **'+{points} pts'**
  String receiptPointsEarned(int points);

  /// No description provided for @receiptViewHistory.
  ///
  /// In en, this message translates to:
  /// **'View parking history'**
  String get receiptViewHistory;

  /// No description provided for @historyTypeSession.
  ///
  /// In en, this message translates to:
  /// **'Walk-up session'**
  String get historyTypeSession;

  /// No description provided for @historyTypeReservation.
  ///
  /// In en, this message translates to:
  /// **'Reservation'**
  String get historyTypeReservation;

  /// No description provided for @historyWhen.
  ///
  /// In en, this message translates to:
  /// **'When'**
  String get historyWhen;

  /// No description provided for @historyShowOnMap.
  ///
  /// In en, this message translates to:
  /// **'Show on map'**
  String get historyShowOnMap;

  /// No description provided for @homeCheckInPrompt.
  ///
  /// In en, this message translates to:
  /// **'Daily check-in available — +5 Parko Points'**
  String get homeCheckInPrompt;

  /// No description provided for @reminderScheduled.
  ///
  /// In en, this message translates to:
  /// **'Device reminder set 15 min before start'**
  String get reminderScheduled;

  /// No description provided for @mapLoadErrorTitle.
  ///
  /// In en, this message translates to:
  /// **'Could not load parking map'**
  String get mapLoadErrorTitle;

  /// No description provided for @mapLoadErrorConnection.
  ///
  /// In en, this message translates to:
  /// **'Parko API is not reachable. Start the backend, or the app will use demo lots when possible.'**
  String get mapLoadErrorConnection;

  /// No description provided for @mapLoadErrorGeneric.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong loading parking data.'**
  String get mapLoadErrorGeneric;

  /// No description provided for @mapLoadErrorApiHint.
  ///
  /// In en, this message translates to:
  /// **'API: {url}'**
  String mapLoadErrorApiHint(String url);

  /// No description provided for @mapRetry.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get mapRetry;

  /// No description provided for @mapOfflineFallback.
  ///
  /// In en, this message translates to:
  /// **'Offline demo map — start backend for live data'**
  String get mapOfflineFallback;

  /// No description provided for @mapNoLotsMatch.
  ///
  /// In en, this message translates to:
  /// **'No lots match your filters'**
  String get mapNoLotsMatch;

  /// No description provided for @apiStatusLive.
  ///
  /// In en, this message translates to:
  /// **'Live'**
  String get apiStatusLive;

  /// No description provided for @apiStatusDemo.
  ///
  /// In en, this message translates to:
  /// **'Demo'**
  String get apiStatusDemo;

  /// No description provided for @apiStatusOffline.
  ///
  /// In en, this message translates to:
  /// **'Offline'**
  String get apiStatusOffline;

  /// No description provided for @parkingStatsVisits.
  ///
  /// In en, this message translates to:
  /// **'{count} visits'**
  String parkingStatsVisits(int count);

  /// No description provided for @parkingStatsSpent.
  ///
  /// In en, this message translates to:
  /// **'{amount} KWD total spent'**
  String parkingStatsSpent(String amount);

  /// No description provided for @signUpPhoneSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Enter your details, then verify your Kuwait mobile number with a one-time code.'**
  String get signUpPhoneSubtitle;

  /// No description provided for @signUpVerifyPhone.
  ///
  /// In en, this message translates to:
  /// **'Continue with phone verification'**
  String get signUpVerifyPhone;

  /// No description provided for @signUpContinueOtp.
  ///
  /// In en, this message translates to:
  /// **'Enter the code sent to your phone to finish signup.'**
  String get signUpContinueOtp;

  /// No description provided for @emailHintOptional.
  ///
  /// In en, this message translates to:
  /// **'Email (optional)'**
  String get emailHintOptional;

  /// No description provided for @signUpPrompt.
  ///
  /// In en, this message translates to:
  /// **'New to Parko?'**
  String get signUpPrompt;

  /// No description provided for @mapLayersTitle.
  ///
  /// In en, this message translates to:
  /// **'Map layers'**
  String get mapLayersTitle;

  /// No description provided for @mapLayersOverlays.
  ///
  /// In en, this message translates to:
  /// **'Overlays'**
  String get mapLayersOverlays;

  /// No description provided for @mapLayersSharedSpots.
  ///
  /// In en, this message translates to:
  /// **'Shared spots'**
  String get mapLayersSharedSpots;

  /// No description provided for @mapLayersPrivateSpots.
  ///
  /// In en, this message translates to:
  /// **'Private garage listings'**
  String get mapLayersPrivateSpots;

  /// No description provided for @mapLayersStyle.
  ///
  /// In en, this message translates to:
  /// **'Map style'**
  String get mapLayersStyle;

  /// No description provided for @mapLayersNormal.
  ///
  /// In en, this message translates to:
  /// **'Standard'**
  String get mapLayersNormal;

  /// No description provided for @mapLayersSatellite.
  ///
  /// In en, this message translates to:
  /// **'Satellite'**
  String get mapLayersSatellite;

  /// No description provided for @shareLot.
  ///
  /// In en, this message translates to:
  /// **'Share lot'**
  String get shareLot;

  /// No description provided for @shareLotMessage.
  ///
  /// In en, this message translates to:
  /// **'Park at {name} on Parko — {spots} spots · {price}\nhttps://maps.google.com/?q={lat},{lng}'**
  String shareLotMessage(String name, String spots, String price, double lat, double lng);

  /// No description provided for @settingsMemberSince.
  ///
  /// In en, this message translates to:
  /// **'Member since {date}'**
  String settingsMemberSince(String date);

  /// No description provided for @settingsUserId.
  ///
  /// In en, this message translates to:
  /// **'Account ID: {id}'**
  String settingsUserId(String id);

  /// No description provided for @buddyChatEmpty.
  ///
  /// In en, this message translates to:
  /// **'Say hello to coordinate parking'**
  String get buddyChatEmpty;

  /// No description provided for @mapTilesOfflineHint.
  ///
  /// In en, this message translates to:
  /// **'Map background needs internet — parking markers still work'**
  String get mapTilesOfflineHint;

  /// No description provided for @settingsCopyId.
  ///
  /// In en, this message translates to:
  /// **'Copy account ID'**
  String get settingsCopyId;

  /// No description provided for @settingsIdCopied.
  ///
  /// In en, this message translates to:
  /// **'Account ID copied'**
  String get settingsIdCopied;

  /// No description provided for @searchLotsTitle.
  ///
  /// In en, this message translates to:
  /// **'Parking lots'**
  String get searchLotsTitle;

  /// No description provided for @searchLotSubtitle.
  ///
  /// In en, this message translates to:
  /// **'{spots} · {price}'**
  String searchLotSubtitle(String spots, String price);

  /// No description provided for @searchNoResults.
  ///
  /// In en, this message translates to:
  /// **'No destinations or lots match your search'**
  String get searchNoResults;

  /// No description provided for @drawerWalletBalance.
  ///
  /// In en, this message translates to:
  /// **'{amount} KWD'**
  String drawerWalletBalance(String amount);

  /// No description provided for @drawerPointsBalance.
  ///
  /// In en, this message translates to:
  /// **'{points} pts'**
  String drawerPointsBalance(int points);

  /// No description provided for @notificationsClearRead.
  ///
  /// In en, this message translates to:
  /// **'Clear read'**
  String get notificationsClearRead;

  /// No description provided for @notificationsClearedRead.
  ///
  /// In en, this message translates to:
  /// **'Read notifications cleared'**
  String get notificationsClearedRead;

  /// No description provided for @walletTopUpCustomTitle.
  ///
  /// In en, this message translates to:
  /// **'Custom top-up'**
  String get walletTopUpCustomTitle;

  /// No description provided for @walletTopUpCustomLabel.
  ///
  /// In en, this message translates to:
  /// **'Amount'**
  String get walletTopUpCustomLabel;

  /// No description provided for @walletTopUpConfirm.
  ///
  /// In en, this message translates to:
  /// **'Add funds'**
  String get walletTopUpConfirm;

  /// No description provided for @walletTopUpInvalid.
  ///
  /// In en, this message translates to:
  /// **'Enter an amount between 1 and 500 KWD'**
  String get walletTopUpInvalid;

  /// No description provided for @homeFavoritesTitle.
  ///
  /// In en, this message translates to:
  /// **'Saved lots'**
  String get homeFavoritesTitle;

  /// No description provided for @homeFavoritesSeeAll.
  ///
  /// In en, this message translates to:
  /// **'See all'**
  String get homeFavoritesSeeAll;

  /// No description provided for @lotHours.
  ///
  /// In en, this message translates to:
  /// **'Hours: {hours}'**
  String lotHours(String hours);

  /// No description provided for @reserveWalletBalance.
  ///
  /// In en, this message translates to:
  /// **'Wallet balance: {amount} KWD'**
  String reserveWalletBalance(String amount);

  /// No description provided for @reservePayFromWallet.
  ///
  /// In en, this message translates to:
  /// **'Pay from wallet now'**
  String get reservePayFromWallet;

  /// No description provided for @reservePayFromWalletHint.
  ///
  /// In en, this message translates to:
  /// **'Hold your spot — amount deducted immediately'**
  String get reservePayFromWalletHint;

  /// No description provided for @notificationsFilterAll.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get notificationsFilterAll;

  /// No description provided for @notificationsFilterReserve.
  ///
  /// In en, this message translates to:
  /// **'Reservations'**
  String get notificationsFilterReserve;

  /// No description provided for @notificationsFilterWallet.
  ///
  /// In en, this message translates to:
  /// **'Wallet'**
  String get notificationsFilterWallet;

  /// No description provided for @notificationsFilterShare.
  ///
  /// In en, this message translates to:
  /// **'Shared'**
  String get notificationsFilterShare;

  /// No description provided for @loyaltyRedeemConfirmBody.
  ///
  /// In en, this message translates to:
  /// **'100 points will be converted to 5 KWD wallet credit for parking.'**
  String get loyaltyRedeemConfirmBody;

  /// No description provided for @reserveCancelledRefund.
  ///
  /// In en, this message translates to:
  /// **'Cancelled · {amount} KWD refunded to wallet'**
  String reserveCancelledRefund(String amount);

  /// No description provided for @historyFilterAll.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get historyFilterAll;

  /// No description provided for @historyFilterSessions.
  ///
  /// In en, this message translates to:
  /// **'Walk-up'**
  String get historyFilterSessions;

  /// No description provided for @historyFilterReservations.
  ///
  /// In en, this message translates to:
  /// **'Reservations'**
  String get historyFilterReservations;

  /// No description provided for @helpFaq6Q.
  ///
  /// In en, this message translates to:
  /// **'Do I get a refund if I cancel a reservation?'**
  String get helpFaq6Q;

  /// No description provided for @helpFaq6A.
  ///
  /// In en, this message translates to:
  /// **'If you paid from your Parko wallet when booking, the amount is refunded automatically when you cancel before the start time.'**
  String get helpFaq6A;

  /// No description provided for @reserveCancelConfirmRefund.
  ///
  /// In en, this message translates to:
  /// **'Cancel this reservation? {amount} KWD will be refunded to your wallet.'**
  String reserveCancelConfirmRefund(String amount);

  /// No description provided for @reserveCancelConfirmNoRefund.
  ///
  /// In en, this message translates to:
  /// **'Cancel this reservation? Wallet refunds apply only before the start time.'**
  String get reserveCancelConfirmNoRefund;

  /// No description provided for @reserveCancelledNoRefund.
  ///
  /// In en, this message translates to:
  /// **'Reservation cancelled (no refund — start time has passed or not paid from wallet).'**
  String get reserveCancelledNoRefund;

  /// No description provided for @settingsTheme.
  ///
  /// In en, this message translates to:
  /// **'Appearance'**
  String get settingsTheme;

  /// No description provided for @settingsThemeSystem.
  ///
  /// In en, this message translates to:
  /// **'Match system'**
  String get settingsThemeSystem;

  /// No description provided for @settingsThemeLight.
  ///
  /// In en, this message translates to:
  /// **'Light'**
  String get settingsThemeLight;

  /// No description provided for @settingsThemeDark.
  ///
  /// In en, this message translates to:
  /// **'Dark'**
  String get settingsThemeDark;
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>['ar', 'en'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {


  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar': return AppLocalizationsAr();
    case 'en': return AppLocalizationsEn();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.'
  );
}
