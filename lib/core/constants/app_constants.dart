class AppConstants {
  AppConstants._();

  static const String appName = 'Snaptrieve';
  static const String appVersion = '1.0.0';
}

class AppSpacing {
  AppSpacing._();

  static const double xs = 4;
  static const double sm = 8;
  static const double md = 12;
  static const double lg = 16;
  static const double xl = 20;
  static const double xxl = 24;
  static const double xxxl = 32;
}

class AppRadius {
  AppRadius._();

  static const double sm = 6;
  static const double md = 10;
  static const double lg = 12;
  static const double xl = 16;
  static const double xxl = 20;
  static const double circular = 100;
}

class AppSizes {
  AppSizes._();

  static const double iconSmall = 16;
  static const double iconMedium = 20;
  static const double iconLarge = 24;

  static const double buttonHeight = 50;
  static const double appBarHeight = 56;
  static const double bottomNavHeight = 64;

  static const double defaultContentPadding = 16;
  static const double borderWidth = 1;

  // Splash Screen
  static const double splashLogoSize = 88;
  static const double splashLogoIconSize = 40;
  static const double splashIndicatorSize = 24;
  static const double splashIndicatorStroke = 2;

  static const double onboardingIllustrationSize = 220;
  static const double onboardingIconSize = 88;
  static const double onboardingIndicatorWidth = 22;
  static const double onboardingIndicatorHeight = 6;

  // Dashboard
  static const double dashboardHorizontalPadding = 20;
  static const double dashboardHeaderTopPadding = 16;
  static const double dashboardSectionSpacing = 28;
  static const double dashboardCardPadding = 18;
  static const double dashboardStatCardHeight = 112;
  static const double dashboardCategoryCardHeight = 112;
  static const double dashboardIconContainerSize = 42;
  static const double dashboardEmptyIconSize = 44;
  static const double dashboardHeaderIconSize = 42;
  static const double dashboardGridSpacing = 12;
  static const double dashboardBottomSpacing = 32;

  // Screenshots
  static const double screenshotsSearchHeight = 50;
  static const double screenshotsFilterHeight = 38;
  static const double screenshotsGridSpacing = 12;
  static const double screenshotsGridAspectRatio = 0.78;
  static const double screenshotsEmptyIconSize = 48;

  // Import Screenshots
  static const double importHorizontalPadding = 20;
  static const double importSectionSpacing = 24;
  static const double importPreviewSpacing = 10;
  static const double importImageAspectRatio = 0.78;
  static const double importImageRemoveButtonSize = 28;
  static const double importEmptyIconSize = 56;
  static const double importPickerIconSize = 28;
  static const double importBottomSpacing = 24;

  // Import Results
  static const double importResultIconSize = 48;
  static const double importResultCardPadding = 16;
  static const double importResultCardSpacing = 12;

  // Screenshot Grid
  static const int screenshotGridColumns = 3;
  static const double screenshotGridItemSpacing = 12;
  static const double screenshotGridItemRadius = 12;
  static const double screenshotGridImageAspectRatio = 0.78;

  // Screenshot Preview
  static const double screenshotPreviewImageSize = 72;
  static const double screenshotPreviewCardPadding = 12;
  static const double screenshotPreviewCardSpacing = 12;
  static const double screenshotPreviewCardRadius = 12;

  // Dashboard Recent Screenshots
  static const double dashboardRecentItemSpacing = 12;

  // Screenshot Details
  static const double screenshotDetailsImageHeight = 420;
  static const double screenshotDetailsFullImagePadding = 16;
  static const double screenshotDetailsInfoIconSize = 18;
  static const double screenshotDetailsCardSpacing = 14;
  static const double screenshotDetailsTextMaxHeight = 180;

  // Search
  static const double searchCategoryFilterHeight = 48;
  static const double searchResultSpacing = 12;
  static const double searchResultImageSize = 76;
  static const double searchEmptyIconSize = 56;
  static const int searchResultPreviewLines = 3;

  // Dashboard Storage Analytics
  static const double dashboardStorageCardPadding = 20;
  static const double dashboardStorageProgressSize = 176;
  static const double dashboardStorageProgressStroke = 12;
  static const double dashboardStorageProgressGap = 8;
  static const double dashboardStorageMetricSpacing = 16;
  static const double dashboardStorageCategoryBarHeight = 7;
  static const double dashboardStorageLargestImageSize = 52;
  static const double dashboardStorageLargestItemSpacing = 12;
  static const double dashboardStorageSectionSpacing = 20;
  static const double dashboardStorageProgressCenterSize = 140;

  // Dashboard Analytics Design
  static const double dashboardAnalyticsHeaderIconSize = 48;
  static const double dashboardAnalyticsMetricIconSize = 42;
  static const double dashboardAnalyticsMetricIconContainer = 56;
  static const double dashboardAnalyticsProgressSize = 176;
  static const double dashboardAnalyticsProgressStroke = 13;
  static const double dashboardAnalyticsProgressCenterSize = 138;
  static const double dashboardAnalyticsTileSpacing = 12;
  static const double dashboardAnalyticsTilePadding = 14;
  static const double dashboardAnalyticsHeaderSpacing = 12;
  static const double dashboardAnalyticsSubtitleSpacing = 4;
  static const double dashboardAnalyticsSectionSpacing = 24;
  static const double dashboardAnalyticsStatusSpacing = 20;
  static const double dashboardAnalyticsDecorationSize = 150;

  static const double dashboardAnalyticsStatusDividerHeight = 32;
}

class AppDurations {
  AppDurations._();

  static const Duration splashAnimation = Duration(milliseconds: 900);
  static const Duration searchDebounce = Duration(milliseconds: 300);
}

class DefaultCategories {
  DefaultCategories._();

  static const String links = 'Links';
  static const String emails = 'Emails';
  static const String contacts = 'Contacts';
  static const String datesAndEvents = 'Dates & Events';
  static const String generalText = 'General Text';
  static const String uncategorized = 'Uncategorized';

  // Icon identifiers will be mapped to Phosphor icons in the UI.
  static const String linksIcon = 'link';
  static const String emailsIcon = 'envelope';
  static const String contactsIcon = 'user';
  static const String datesAndEventsIcon = 'calendar';
  static const String generalTextIcon = 'text';
  static const String uncategorizedIcon = 'folder';
}
