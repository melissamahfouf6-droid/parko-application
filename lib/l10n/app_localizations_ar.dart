import 'app_localizations.dart';

/// The translations for Arabic (`ar`).
class AppLocalizationsAr extends AppLocalizations {
  AppLocalizationsAr([String locale = 'ar']) : super(locale);

  @override
  String get appName => 'بارکو';

  @override
  String get tagline => 'حل مواقف ذكي';

  @override
  String get getStarted => 'ابدأ الآن';

  @override
  String get skip => 'تخطي';

  @override
  String get next => 'التالي';

  @override
  String get back => 'رجوع';

  @override
  String get onboardingTitle1 => 'اعثر على موقف فوراً';

  @override
  String get onboardingBody1 => 'توفر مباشر في المولات والمستشفيات والجامعات';

  @override
  String get onboardingTitle2 => 'احجز موقفك';

  @override
  String get onboardingBody2 => 'احجز مسبقاً وتوقف عن الدوران بحثاً عن موقف';

  @override
  String get onboardingTitle3 => 'اتجه إلى موقفك';

  @override
  String get onboardingBody3 => 'إرشاد خطوة بخطوة إلى موقع الموقف بالضبط';

  @override
  String get authTitle => 'أهلاً بك في بارکو';

  @override
  String get phoneTab => 'الهاتف';

  @override
  String get emailTab => 'البريد';

  @override
  String get phoneHint => 'رقم الهاتف';

  @override
  String get emailHint => 'البريد الإلكتروني';

  @override
  String get passwordHint => 'كلمة المرور';

  @override
  String get sendCode => 'إرسال الرمز';

  @override
  String get signIn => 'تسجيل الدخول';

  @override
  String get signUp => 'إنشاء حساب';

  @override
  String get signUpTitle => 'إنشاء حسابك';

  @override
  String get firstNameHint => 'الاسم الأول';

  @override
  String get lastNameHint => 'اسم العائلة';

  @override
  String get confirmPasswordHint => 'تأكيد كلمة المرور';

  @override
  String get createAccount => 'إنشاء الحساب';

  @override
  String get passwordsDoNotMatch => 'كلمتا المرور غير متطابقتين';

  @override
  String get fillAllFields => 'يرجى تعبئة جميع الحقول';

  @override
  String get forgotPasswordComingSoon => 'إعادة تعيين كلمة المرور ستتوفر في تحديث لاحق.';

  @override
  String get forgotPassword => 'نسيت كلمة المرور؟';

  @override
  String get searchHint => 'ابحث عن وجهة أو موقف';

  @override
  String get availableNow => 'متاح الآن';

  @override
  String get reservableAhead => 'قابل للحجز مسبقاً';

  @override
  String get showFullLots => 'إظهار الممتلئ';

  @override
  String get resetFilters => 'إعادة ضبط';

  @override
  String get applyFilters => 'تطبيق';

  @override
  String get navigateToParking => 'الاتجاه إلى الموقف';

  @override
  String get reserveSpot => 'حجز موقف';

  @override
  String get parkPayNow => 'ابدأ الوقوف والدفع';

  @override
  String get drawerMyParking => 'مواقفي';

  @override
  String get drawerWallet => 'المحفظة والدفع';

  @override
  String get drawerSettings => 'الإعدادات';

  @override
  String get drawerLanguage => 'اللغة';

  @override
  String get drawerSignOut => 'تسجيل الخروج';

  @override
  String get drawerFindParking => 'أقرب موقف';

  @override
  String get searchTitle => 'بحث';

  @override
  String get myParkingTitle => 'مواقفي';

  @override
  String get tabActive => 'نشط';

  @override
  String get tabUpcoming => 'قادم';

  @override
  String get tabHistory => 'السجل';

  @override
  String get emptyActiveParking => 'لا يوجد وقوف نشط';

  @override
  String get emptyUpcoming => 'لا حجوزات قادمة';

  @override
  String get emptyHistory => 'لا سجل بعد';

  @override
  String get mapPreviewTitle => 'معاينة الخريطة';

  @override
  String get mapPreviewHint => 'خرائط Google غير مضمنة على تطبيقات macOS أو Linux أو Windows. استخدم محاكي iOS أو Android أو Chrome (ويب) للخريطة الحية. اضغط على أحد المواقع أدناه للتفاصيل.';

  @override
  String distanceAwayWalk(String distance, int minutes) {
    return '$distance • مشي $minutes دقيقة';
  }

  @override
  String get drawerLoyalty => 'نقاط بارکو';

  @override
  String get loyaltyScreenTitle => 'نقاط بارکو';

  @override
  String get loyaltyScreenSubtitle => 'اكسب نقاطاً في كل زيارة واستبدلها بمواقف مجانية';

  @override
  String loyaltyBalance(int points) {
    return 'الرصيد: $points نقطة';
  }

  @override
  String loyaltyLifetime(int points) {
    return 'إجمالي ما كسبته: $points نقطة';
  }

  @override
  String get loyaltyTierBronze => 'برونزي';

  @override
  String get loyaltyTierSilver => 'فضي';

  @override
  String get loyaltyTierGold => 'ذهبي';

  @override
  String get loyaltyTierPlatinum => 'بلاتيني';

  @override
  String loyaltyProgressToNext(int points, String tierName) {
    return '$points نقطة حتى $tierName';
  }

  @override
  String get loyaltyMaxTier => 'بلاتيني — تابع الكسب للاستبدال';

  @override
  String get loyaltyDailyCheckIn => 'حضور يومي (+٥)';

  @override
  String get loyaltyDemoParking => 'تجربة: إنهاء جلسة (٣٫٥ د.ك)';

  @override
  String get loyaltyRedeem100 => 'استبدال ١٠٠ نقطة ← ٥ د.ك رصيد مواقف';

  @override
  String get loyaltyRewardsTitle => 'كتالوج المكافآت';

  @override
  String get loyaltyRedemptionRule => '١٠٠ نقطة = ٥ د.ك رصيد مواقف';

  @override
  String get loyaltyTiersTitle => 'المستويات والمزايا';

  @override
  String get loyaltyHistoryTitle => 'سجل النقاط';

  @override
  String get loyaltyEmptyHistory => 'لا يوجد سجل بعد';

  @override
  String loyaltyEarnAtLot(int points) {
    return 'حتى $points نقطة في الزيارات المدفوعة هنا';
  }

  @override
  String loyaltySnackEarned(int points) {
    return 'ربحت $points نقطة!';
  }

  @override
  String loyaltySnackLevelUp(String tier) {
    return 'صعدت للمستوى: $tier';
  }

  @override
  String get loyaltySnackRedeem => 'استبدلت ١٠٠ نقطة برصيد مواقف';

  @override
  String get loyaltySnackCheckIn => '+٥ نقاط الحضور اليومي';

  @override
  String get loyaltyErrCheckInDone => 'سجّلت حضور اليوم مسبقاً';

  @override
  String get loyaltyErrBalance => 'النقاط غير كافية';

  @override
  String get loyaltyRedeemConfirmTitle => 'استبدال ١٠٠ نقطة؟';

  @override
  String get loyaltyCancel => 'إلغاء';

  @override
  String get loyaltyConfirm => 'استبدال';

  @override
  String get loyaltyPerkBronze => 'برونزي (٠–٤٩٩): أساسي';

  @override
  String get loyaltyPerkSilver => 'فضي (٥٠٠–١٩٩٩): خصم ٥٪ على المواقف';

  @override
  String get loyaltyPerkGold => 'ذهبي (٢٠٠٠–٤٩٩٩): ١٠٪ + أولوية الحجز';

  @override
  String get loyaltyPerkPlatinum => 'بلاتيني (٥٠٠٠+): ١٥٪ + مواقف VIP + فاليه';

  @override
  String get loyaltyApiHint => 'شغّل الخادم واستخدم --dart-define=PARKO_API_BASE=… لمزامنة النقاط.';

  @override
  String loyaltyHomeBadge(String points) {
    return '$points نقطة';
  }

  @override
  String predictionBannerOpens(String lotName, int minutes) {
    return 'توقع: $lotName يخف الازدحام خلال ~$minutes دقيقة';
  }

  @override
  String predictionChance(int percent) {
    return '$percent% احتمال إيجاد موقف قريباً';
  }

  @override
  String get predictionSectionTitle => 'توقع ذكي';

  @override
  String predictionTypicalOpens(String time) {
    return 'عادة يفضى حوالي $time';
  }

  @override
  String get predictionPatternTitle => 'نمط الامتلاء اليوم';

  @override
  String get predictionNotifyMe => 'أبلغني عند التوفر';

  @override
  String get predictionNotifyDone => 'سنبلغك عند توفر مواقف';

  @override
  String get predictionNotifyAlready => 'أنت مسجّل مسبقاً على قائمة الانتظار';

  @override
  String get shareSpotTitle => 'شارك موقفك';

  @override
  String get shareSpotFab => 'بيع موقفي';

  @override
  String shareAvailableNow(int count) {
    return '$count مواقف معروضة قريباً — وفّر حتى ٢٠٪';
  }

  @override
  String get shareLeaveEarly => 'مغادرة مبكرة — بيع موقفي';

  @override
  String get shareLeaveEarlyTitle => 'بيع موقفي';

  @override
  String get shareLeaveEarlyBody => 'اعرض وقتك المتبقي بخصم ٢٠٪. تسترد ٧٠٪؛ المشتري يدخل خلال ١٠ دقائق.';

  @override
  String get shareConfirmList => 'عرض موقفي للبيع';

  @override
  String shareListedSuccess(String amount) {
    return 'تم العرض! استرداد $amount د.ك (تجربة).';
  }

  @override
  String shareActiveSession(String lotName) {
    return 'نشط في $lotName';
  }

  @override
  String shareTimeLeft(int hours, int minutes) {
    return 'متبقي $hours س $minutes د';
  }

  @override
  String get shareStartDemoSession => 'بدء جلسة وقوف تجريبية';

  @override
  String get shareEndSession => 'إنهاء الجلسة';

  @override
  String shareBuyNow(String price) {
    return 'احجز — $price د.ك';
  }

  @override
  String get shareClaimSuccess => 'تم الحجز! توجه خلال ١٠ دقائق.';

  @override
  String get shareSheetTitle => 'مواقف معروضة — متاحة الآن';

  @override
  String shareRemaining(int minutes, int discount) {
    return 'متبقي $minutes د • خصم $discount٪';
  }

  @override
  String buddyCardGoing(int count, String destination) {
    return '$count أشخاص متجهون إلى $destination الآن';
  }

  @override
  String get buddyFindTitle => 'رفاق المواقف';

  @override
  String get buddyJoinSearch => 'انضم — ابحث عن رفيق';

  @override
  String get buddyJoined => 'انضممت لبحث الرفاق!';

  @override
  String get buddyChatHint => 'اضغط على زميل للدردشة وتنسيق الموقف.';

  @override
  String get buddyEmpty => 'لا يوجد رفاق لهذه الوجهة بعد. كن الأول!';

  @override
  String buddySeatsNeeded(int count) {
    return 'يحتاج $count مقعد';
  }

  @override
  String get buddySearchAction => 'ابحث عن رفيق موقف';

  @override
  String marketplaceCta(String amount) {
    return 'اربح ~$amount د.ك/شهر — اعرض موقفك';
  }

  @override
  String get marketplaceListTitle => 'سوق المواقف';

  @override
  String get marketplaceListMySpot => 'اعرض موقفي';

  @override
  String get marketplaceSpotTitleHint => 'عنوان الموقف';

  @override
  String get marketplacePriceHint => 'السعر لليوم (د.ك)';

  @override
  String get marketplaceAvailabilityHint => 'التوفر';

  @override
  String get marketplaceAddPhoto => 'إضافة صورة (تحقق)';

  @override
  String get marketplacePhotoHint => 'التحقق بالصورة — رفع الكاميرا في تحديث لاحق.';

  @override
  String get marketplaceSubmit => 'نشر الإعلان';

  @override
  String get marketplaceListed => 'موقفك ظهر على الخريطة!';

  @override
  String get marketplaceBrowseTitle => 'مواقف سكنية قريبة';

  @override
  String get marketplaceVerified => 'موثّق بالصورة (تجربة)';

  @override
  String get marketplaceBookSpot => 'احجز هذا الموقف';

  @override
  String get marketplaceBookSoon => 'الحجز والدفع — قريباً.';

  @override
  String marketplaceNearLot(int count, String price) {
    return '$count مواقف سكنية من $price د.ك/يوم';
  }

  @override
  String get drawerMarketplace => 'اعرض موقفي (السوق)';

  @override
  String get drawerBuddies => 'رفاق المواقف';

  @override
  String get reserveTitle => 'حجز موقف';

  @override
  String get reserveWhen => 'متى';

  @override
  String get reserveToday => 'اليوم';

  @override
  String get reserveTomorrow => 'غداً';

  @override
  String get reserveDuration => 'المدة';

  @override
  String get reserveDuration1h => 'ساعة';

  @override
  String get reserveDuration2h => 'ساعتان';

  @override
  String get reserveDuration3h => '3 ساعات';

  @override
  String get reserveDurationAllDay => 'يوم كامل';

  @override
  String get reserveZoneHint => 'المنطقة / الطابق (اختياري)';

  @override
  String reserveTotal(String price) {
    return 'الإجمالي التقريبي: $price د.ك';
  }

  @override
  String get reserveConfirm => 'تأكيد الحجز';

  @override
  String get reserveSuccess => 'تم الحجز! راجع مواقفي → القادمة.';

  @override
  String get reserveCancel => 'إلغاء الحجز';

  @override
  String get reserveCancelConfirm => 'إلغاء هذا الحجز؟';

  @override
  String get reserveCancelled => 'تم إلغاء الحجز';

  @override
  String reserveStartsInHours(int hours, int mins) {
    return 'يبدأ خلال $hours س $mins د';
  }

  @override
  String reserveStartsInMins(int mins) {
    return 'يبدأ خلال $mins د';
  }

  @override
  String homeNextReservation(String lot) {
    return 'محجوز: $lot';
  }

  @override
  String reserveNavigateHint(String lot) {
    return 'فتح الاتجاهات إلى $lot…';
  }

  @override
  String get reservePaySoon => 'الدفع عند الوصول — محفظة Tap/Stripe قريباً.';

  @override
  String get walletTitle => 'المحفظة والدفع';

  @override
  String get walletBalanceLabel => 'الرصيد المتاح';

  @override
  String walletBalanceAmount(String amount) {
    return '$amount د.ك';
  }

  @override
  String get walletTopUpTitle => 'شحن سريع (تجربة)';

  @override
  String walletTopUpAmount(String amount) {
    return '+$amount د.ك';
  }

  @override
  String get walletTopUpHint => 'محاكاة KNET / Tap — مفاتيح الإنتاج لاحقاً.';

  @override
  String walletTopUpSuccess(String amount) {
    return 'تمت إضافة $amount د.ك للمحفظة';
  }

  @override
  String get walletKnet => 'كي نت';

  @override
  String get walletTap => 'تاب';

  @override
  String get walletHistory => 'النشاط الأخير';

  @override
  String get walletEmptyHistory => 'لا معاملات بعد';

  @override
  String get walletTxType => 'معاملة';

  @override
  String get walletPayTitle => 'دفع المواقف';

  @override
  String walletPayBalance(String amount) {
    return 'رصيد المحفظة: $amount د.ك';
  }

  @override
  String walletPayAmount(String amount) {
    return 'الإجمالي: $amount د.ك';
  }

  @override
  String get walletPayFree => 'هذا الموقف مجاني — بدء الجلسة بدون رسوم.';

  @override
  String get walletPayConfirm => 'الدفع من المحفظة';

  @override
  String get walletPaySuccess => 'تم الدفع — بدأت جلسة موقف نشطة';

  @override
  String get walletInsufficient => 'رصيد غير كافٍ. اشحن من المحفظة.';

  @override
  String get walletBalanceUnknown => 'الرصيد غير متاح';

  @override
  String get mapsOpenFailed => 'تعذر فتح الخرائط على هذا الجهاز';

  @override
  String walletHomeChip(String amount) {
    return '$amount د.ك';
  }

  @override
  String get settingsTitle => 'الإعدادات';

  @override
  String get settingsProfileSection => 'الملف الشخصي';

  @override
  String get settingsNameLabel => 'الاسم';

  @override
  String get settingsPhoneLabel => 'الهاتف';

  @override
  String get settingsEmailLabel => 'البريد';

  @override
  String get settingsSaveProfile => 'حفظ الملف';

  @override
  String get settingsProfileSaved => 'تم حفظ الملف';

  @override
  String get settingsNotificationsSection => 'الإشعارات';

  @override
  String get settingsParkingReminders => 'تذكير المواقف';

  @override
  String get settingsParkingRemindersHint => 'بداية الحجز وتنبيهات التوفر';

  @override
  String get settingsMarketing => 'العروض والأخبار';

  @override
  String get settingsMarketingHint => 'عروض المولات وبارکو';

  @override
  String get settingsAppSection => 'التطبيق';

  @override
  String get settingsAbout => 'عن بارکو';

  @override
  String settingsVersion(String version) {
    return 'الإصدار $version';
  }

  @override
  String loyaltySnackRedeemWallet(String amount) {
    return 'أُضيف $amount د.ك إلى محفظة بارکو';
  }

  @override
  String get buddyChatSubtitle => 'تنسيق اللقاء وتقاسم الموقف';

  @override
  String get buddyChatInputHint => 'رسالة…';

  @override
  String get filterTitle => 'فلاتر الخريطة';

  @override
  String filterApplied(int count) {
    return 'عرض $count مواقع مواقف';
  }

  @override
  String get notificationsTitle => 'الإشعارات';

  @override
  String get notificationsMarkAllRead => 'تعليم الكل كمقروء';

  @override
  String get notificationsEmpty => 'لا إشعارات بعد';

  @override
  String get searchNearMe => 'استخدم موقعي';

  @override
  String get searchNearMeHint => 'ترتيب المواقف حسب بعدك';

  @override
  String get locationFound => 'تم التمركز على موقعك';

  @override
  String get locationUnavailable => 'الموقع غير متاح — فعّل GPS واسمح لبارکو من الإعدادات';

  @override
  String searchSelected(String place) {
    return 'البحث قرب $place';
  }

  @override
  String get marketplacePhotoAdded => 'تمت إضافة الصورة للتحقق (تجربة)';

  @override
  String get marketplaceChangePhoto => 'تغيير الصورة';

  @override
  String get legendAvailable => 'متاح';

  @override
  String get legendLimited => 'محدود';

  @override
  String get legendFull => 'ممتلئ';

  @override
  String lotDistanceKm(String km) {
    return 'على بعد $km كم';
  }

  @override
  String get reviewSectionTitle => 'قيّم هذا الموقف';

  @override
  String get reviewSectionHint => 'شارك تجربتك — 10 نقاط بارکو مرة واحدة يومياً لكل موقف.';

  @override
  String get reviewCommentHint => 'تعليق اختياري';

  @override
  String get reviewSubmit => 'إرسال التقييم';

  @override
  String reviewSubmitted(String rating, int count, int points) {
    return 'شكراً! التقييم الجديد $rating ★ ($count مراجعة) · +$points نقطة';
  }

  @override
  String get reviewAlreadyToday => 'قيّمت هذا الموقف اليوم مسبقاً.';

  @override
  String get reviewFailed => 'تعذر إرسال التقييم. حاول مرة أخرى.';

  @override
  String get helpTitle => 'المساعدة والأسئلة';

  @override
  String get helpIntro => 'إجابات سريعة عن بارکو في الكويت — المواقف والمحفظة والولاء.';

  @override
  String get helpFaq1Q => 'كيف أدفع عن المواقف؟';

  @override
  String get helpFaq1A => 'اختر موقفاً على الخريطة، اضغط ادفع الآن، وأكد من محفظة بارکو. اشحن الرصيد من المحفظة عند الحاجة.';

  @override
  String get helpFaq2Q => 'ما هي نقاط بارکو؟';

  @override
  String get helpFaq2A => 'اكسب نقاطاً عند الدفع، التسجيل اليومي، وتقييم المواقف. استبدل 100 نقطة بـ 5 د.ك رصيد في الولاء.';

  @override
  String get helpFaq3Q => 'هل يمكن الحجز مسبقاً؟';

  @override
  String get helpFaq3A => 'نعم — افتح الموقف واضغط احجز. الحجوزات القادمة في مواقفي.';

  @override
  String get helpFaq4Q => 'لماذا الخريطة OpenStreetMap؟';

  @override
  String get helpFaq4A => 'بارکو يستخدم OSM افتراضياً دون حساب فوترة Google. خرائط Google اختيارية عبر scripts/setup_google_maps_key.sh.';

  @override
  String get helpFaq5Q => 'كيف يعمل مشاركة المواقف والأصدقاء؟';

  @override
  String get helpFaq5A => 'غادر مبكراً لمشاركة موقفك، شاهد الأصدقاء القريبين، وأدرج ممراً خاصاً في السوق.';

  @override
  String get helpContactTitle => 'تواصل مع الدعم';

  @override
  String get helpContactEmail => 'support@parko.kw';

  @override
  String get favoritesTitle => 'المواقف المحفوظة';

  @override
  String get favoritesEmpty => 'اضغط النجمة على موقف في الخريطة لحفظه هنا.';

  @override
  String get favoritesAdded => 'تم حفظ الموقف';

  @override
  String get favoritesRemoved => 'تمت الإزالة من المحفوظة';

  @override
  String favoritesSavedOn(String date) {
    return 'حُفظ في $date';
  }

  @override
  String homeActiveSession(String lotName) {
    return 'موقف نشط · $lotName';
  }

  @override
  String get authOtpSent => 'تم إرسال رمز التحقق';

  @override
  String get authOtpHint => 'رمز من 6 أرقام';

  @override
  String get authOtpVerify => 'تحقق ومتابعة';

  @override
  String get authOtpInvalid => 'رمز غير صحيح. الرمز التجريبي: 123456';

  @override
  String get authOtpExpired => 'انتهت صلاحية الرمز — اطلب رمزاً جديداً';

  @override
  String get authDemoCodeHint => 'رمز تجريبي: 123456';

  @override
  String get authChangePhone => 'تغيير رقم الهاتف';

  @override
  String get searchRecentTitle => 'الأخيرة';

  @override
  String get searchRecentClear => 'مسح';

  @override
  String get searchPopularTitle => 'الأكثر بحثاً في الكويت';

  @override
  String get sessionEnded => 'انتهت جلسة المواقف';

  @override
  String get sessionExtend30 => '+30 دقيقة';

  @override
  String sessionExtended(int minutes) {
    return 'تم تمديد الجلسة $minutes دقيقة';
  }

  @override
  String get homeRefreshed => 'تم تحديث بيانات الخريطة';

  @override
  String get settingsProfileSynced => 'تم حفظ الملف ومزامنته مع بارکو';

  @override
  String authWelcomeBonus(String kwd, int points) {
    return 'أهلاً! $kwd د.ك في المحفظة + $points نقطة بارکو';
  }

  @override
  String get filterQuickAll => 'الكل';

  @override
  String get filterQuickFree => 'مجاني';

  @override
  String get filterQuickValet => 'فاليه';

  @override
  String get filterQuickReserve => 'قابل للحجز';

  @override
  String get receiptTitle => 'إيصال المواقف';

  @override
  String get receiptDuration => 'مدة الوقوف';

  @override
  String get receiptPaid => 'المدفوع';

  @override
  String get receiptPoints => 'نقاط بارکو';

  @override
  String receiptPointsEarned(int points) {
    return '+$points نقطة';
  }

  @override
  String get receiptViewHistory => 'عرض السجل';

  @override
  String get historyTypeSession => 'جلسة مباشرة';

  @override
  String get historyTypeReservation => 'حجز';

  @override
  String get historyWhen => 'الوقت';

  @override
  String get historyShowOnMap => 'عرض على الخريطة';

  @override
  String get homeCheckInPrompt => 'تسجيل يومي متاح — +5 نقاط بارکو';

  @override
  String get reminderScheduled => 'تم ضبط تذكير قبل 15 دقيقة من الموعد';

  @override
  String get mapLoadErrorTitle => 'تعذر تحميل الخريطة';

  @override
  String get mapLoadErrorConnection => 'لا يمكن الوصول إلى خادم بارکو. شغّل الـ backend أو سيُستخدم الوضع التجريبي.';

  @override
  String get mapLoadErrorGeneric => 'حدث خطأ أثناء تحميل بيانات المواقف.';

  @override
  String mapLoadErrorApiHint(String url) {
    return 'الواجهة: $url';
  }

  @override
  String get mapRetry => 'إعادة المحاولة';

  @override
  String get mapOfflineFallback => 'خريطة تجريبية — شغّل الخادم للبيانات الحية';

  @override
  String get mapNoLotsMatch => 'لا توجد مواقف تطابق الفلاتر';

  @override
  String get apiStatusLive => 'متصل';

  @override
  String get apiStatusDemo => 'تجريبي';

  @override
  String get apiStatusOffline => 'غير متصل';

  @override
  String parkingStatsVisits(int count) {
    return '$count زيارة';
  }

  @override
  String parkingStatsSpent(String amount) {
    return 'إجمالي $amount د.ك';
  }

  @override
  String get signUpPhoneSubtitle => 'أدخل بياناتك ثم تحقق من رقم جوالك الكويتي برمز لمرة واحدة.';

  @override
  String get signUpVerifyPhone => 'متابعة التحقق بالهاتف';

  @override
  String get signUpContinueOtp => 'أدخل الرمز المرسل إلى جوالك لإكمال التسجيل.';

  @override
  String get emailHintOptional => 'البريد (اختياري)';

  @override
  String get signUpPrompt => 'جديد في بارکو؟';

  @override
  String get mapLayersTitle => 'طبقات الخريطة';

  @override
  String get mapLayersOverlays => 'الطبقات';

  @override
  String get mapLayersSharedSpots => 'مواقف مشتركة';

  @override
  String get mapLayersPrivateSpots => 'كراجات خاصة';

  @override
  String get mapLayersStyle => 'نمط الخريطة';

  @override
  String get mapLayersNormal => 'عادية';

  @override
  String get mapLayersSatellite => 'قمر صناعي';

  @override
  String get shareLot => 'مشاركة الموقف';

  @override
  String shareLotMessage(String name, String spots, String price, double lat, double lng) {
    return 'موقف $name على بارکو — $spots · $price\nhttps://maps.google.com/?q=$lat,$lng';
  }

  @override
  String settingsMemberSince(String date) {
    return 'عضو منذ $date';
  }

  @override
  String settingsUserId(String id) {
    return 'معرف الحساب: $id';
  }

  @override
  String get buddyChatEmpty => 'راسِل زميلك لتنسيق الموقف';

  @override
  String get mapTilesOfflineHint => 'خلفية الخريطة تحتاج إنترنت — العلامات ما زالت تعمل';

  @override
  String get settingsCopyId => 'نسخ معرف الحساب';

  @override
  String get settingsIdCopied => 'تم نسخ معرف الحساب';

  @override
  String get searchLotsTitle => 'مواقف السيارات';

  @override
  String searchLotSubtitle(String spots, String price) {
    return '$spots · $price';
  }

  @override
  String get searchNoResults => 'لا توجد وجهات أو مواقف مطابقة';

  @override
  String drawerWalletBalance(String amount) {
    return '$amount د.ك';
  }

  @override
  String drawerPointsBalance(int points) {
    return '$points نقطة';
  }

  @override
  String get notificationsClearRead => 'مسح المقروء';

  @override
  String get notificationsClearedRead => 'تم مسح الإشعارات المقروءة';

  @override
  String get walletTopUpCustomTitle => 'شحن مخصص';

  @override
  String get walletTopUpCustomLabel => 'المبلغ';

  @override
  String get walletTopUpConfirm => 'إضافة رصيد';

  @override
  String get walletTopUpInvalid => 'أدخل مبلغاً بين 1 و 500 د.ك';

  @override
  String get homeFavoritesTitle => 'مواقف محفوظة';

  @override
  String get homeFavoritesSeeAll => 'عرض الكل';

  @override
  String lotHours(String hours) {
    return 'الساعات: $hours';
  }

  @override
  String reserveWalletBalance(String amount) {
    return 'رصيد المحفظة: $amount د.ك';
  }

  @override
  String get reservePayFromWallet => 'الدفع من المحفظة الآن';

  @override
  String get reservePayFromWalletHint => 'حجز الموقف — يُخصم المبلغ فوراً';

  @override
  String get notificationsFilterAll => 'الكل';

  @override
  String get notificationsFilterReserve => 'حجوزات';

  @override
  String get notificationsFilterWallet => 'المحفظة';

  @override
  String get notificationsFilterShare => 'مشاركة';

  @override
  String get loyaltyRedeemConfirmBody => 'سيتم تحويل ١٠٠ نقطة إلى ٥ د.ك رصيد مواقف في المحفظة.';

  @override
  String reserveCancelledRefund(String amount) {
    return 'تم الإلغاء · استرداد $amount د.ك للمحفظة';
  }

  @override
  String get historyFilterAll => 'الكل';

  @override
  String get historyFilterSessions => 'مباشر';

  @override
  String get historyFilterReservations => 'حجوزات';

  @override
  String get helpFaq6Q => 'هل أسترد المبلغ عند إلغاء الحجز؟';

  @override
  String get helpFaq6A => 'إذا دفعت من محفظة بارکو عند الحجز، يُعاد المبلغ تلقائياً عند الإلغاء قبل وقت البدء.';

  @override
  String reserveCancelConfirmRefund(String amount) {
    return 'إلغاء الحجز؟ سيتم استرداد $amount د.ك إلى محفظتك.';
  }

  @override
  String get reserveCancelConfirmNoRefund => 'إلغاء الحجز؟ الاسترداد للمحفظة متاح فقط قبل وقت البدء.';

  @override
  String get reserveCancelledNoRefund => 'تم الإلغاء (لا استرداد — انتهى وقت البدء أو لم يُدفع من المحفظة).';

  @override
  String get settingsTheme => 'المظهر';

  @override
  String get settingsThemeSystem => 'حسب النظام';

  @override
  String get settingsThemeLight => 'فاتح';

  @override
  String get settingsThemeDark => 'داكن';
}
