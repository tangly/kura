import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_es.dart';
import 'app_localizations_fr.dart';

// ignore_for_file: type=lint

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
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

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
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('es'),
    Locale('fr'),
  ];

  /// No description provided for @medications.
  ///
  /// In en, this message translates to:
  /// **'Medications inventory'**
  String get medications;

  /// No description provided for @all.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get all;

  /// No description provided for @user.
  ///
  /// In en, this message translates to:
  /// **'User'**
  String get user;

  /// No description provided for @allUsers.
  ///
  /// In en, this message translates to:
  /// **'All Users'**
  String get allUsers;

  /// No description provided for @expired.
  ///
  /// In en, this message translates to:
  /// **'Expired'**
  String get expired;

  /// No description provided for @homeBottomBar.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get homeBottomBar;

  /// No description provided for @medicationsBottomBar.
  ///
  /// In en, this message translates to:
  /// **'Medications'**
  String get medicationsBottomBar;

  /// No description provided for @familyBottomBar.
  ///
  /// In en, this message translates to:
  /// **'Family'**
  String get familyBottomBar;

  /// No description provided for @remindersBottomBar.
  ///
  /// In en, this message translates to:
  /// **'Reminders'**
  String get remindersBottomBar;

  /// No description provided for @settingsBottomBar.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settingsBottomBar;

  /// No description provided for @addMedication.
  ///
  /// In en, this message translates to:
  /// **'Add Medication'**
  String get addMedication;

  /// No description provided for @editMedication.
  ///
  /// In en, this message translates to:
  /// **'Edit Medication'**
  String get editMedication;

  /// No description provided for @deleteMedication.
  ///
  /// In en, this message translates to:
  /// **'Delete Medication'**
  String get deleteMedication;

  /// No description provided for @areYouSureYouWantToDeleteThisMedication.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete this medication?'**
  String get areYouSureYouWantToDeleteThisMedication;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// No description provided for @medicationName.
  ///
  /// In en, this message translates to:
  /// **'Medication Name'**
  String get medicationName;

  /// No description provided for @pleaseEnterAName.
  ///
  /// In en, this message translates to:
  /// **'Please enter a name'**
  String get pleaseEnterAName;

  /// No description provided for @dosage.
  ///
  /// In en, this message translates to:
  /// **'Dosage'**
  String get dosage;

  /// No description provided for @forMedication.
  ///
  /// In en, this message translates to:
  /// **'For: '**
  String get forMedication;

  /// No description provided for @selectFamilyMember.
  ///
  /// In en, this message translates to:
  /// **'Select Family Member'**
  String get selectFamilyMember;

  /// No description provided for @couldNotLoadUsers.
  ///
  /// In en, this message translates to:
  /// **'Could not load users'**
  String get couldNotLoadUsers;

  /// No description provided for @reasonForUse.
  ///
  /// In en, this message translates to:
  /// **'Reason for Use'**
  String get reasonForUse;

  /// No description provided for @expirationDate.
  ///
  /// In en, this message translates to:
  /// **'Expiration Date'**
  String get expirationDate;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @testNotification.
  ///
  /// In en, this message translates to:
  /// **'Test Notification'**
  String get testNotification;

  /// No description provided for @egIbuprofen.
  ///
  /// In en, this message translates to:
  /// **'e.g., Ibuprofen'**
  String get egIbuprofen;

  /// No description provided for @eg2Pills200mg1Spray.
  ///
  /// In en, this message translates to:
  /// **'e.g., 2 pills, 200mg, 1 spray'**
  String get eg2Pills200mg1Spray;

  /// No description provided for @egHeadache.
  ///
  /// In en, this message translates to:
  /// **'e.g., Headache'**
  String get egHeadache;

  /// No description provided for @dosageCard.
  ///
  /// In en, this message translates to:
  /// **'Dosage: '**
  String get dosageCard;

  /// No description provided for @expiredOn.
  ///
  /// In en, this message translates to:
  /// **'Expired '**
  String get expiredOn;

  /// No description provided for @expiresOn.
  ///
  /// In en, this message translates to:
  /// **'Expires '**
  String get expiresOn;

  /// No description provided for @addFamilyMember.
  ///
  /// In en, this message translates to:
  /// **'Add Family Member'**
  String get addFamilyMember;

  /// No description provided for @editFamilyMember.
  ///
  /// In en, this message translates to:
  /// **'Edit Family Member'**
  String get editFamilyMember;

  /// No description provided for @name.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get name;

  /// No description provided for @age.
  ///
  /// In en, this message translates to:
  /// **'Age'**
  String get age;

  /// No description provided for @weight.
  ///
  /// In en, this message translates to:
  /// **'Weight'**
  String get weight;

  /// No description provided for @allergies.
  ///
  /// In en, this message translates to:
  /// **'Allergies'**
  String get allergies;

  /// No description provided for @notes.
  ///
  /// In en, this message translates to:
  /// **'Notes'**
  String get notes;

  /// No description provided for @egJohn.
  ///
  /// In en, this message translates to:
  /// **'e.g., John'**
  String get egJohn;

  /// No description provided for @eg30.
  ///
  /// In en, this message translates to:
  /// **'e.g., 30'**
  String get eg30;

  /// No description provided for @eg70_5.
  ///
  /// In en, this message translates to:
  /// **'e.g., 70.5'**
  String get eg70_5;

  /// No description provided for @egPeanutsPollen.
  ///
  /// In en, this message translates to:
  /// **'e.g., Peanuts, Pollen'**
  String get egPeanutsPollen;

  /// No description provided for @egImportantMedicalHistory.
  ///
  /// In en, this message translates to:
  /// **'e.g., Important medical history'**
  String get egImportantMedicalHistory;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'es', 'fr'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'es':
      return AppLocalizationsEs();
    case 'fr':
      return AppLocalizationsFr();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
