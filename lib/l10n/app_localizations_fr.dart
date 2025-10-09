// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for French (`fr`).
class AppLocalizationsFr extends AppLocalizations {
  AppLocalizationsFr([String locale = 'fr']) : super(locale);

  @override
  String get medications => 'Médicaments';

  @override
  String get filterBy => 'Filtrer par:';

  @override
  String get all => 'Tous';

  @override
  String get user => 'Utilisateur';

  @override
  String get allUsers => 'Tous les utilisateurs';

  @override
  String get expired => 'Expiré';

  @override
  String get medicationsBottomBar => 'Médicaments';

  @override
  String get familyBottomBar => 'Famille';

  @override
  String get remindersBottomBar => 'Rappels';

  @override
  String get settingsBottomBar => 'Paramètres';

  @override
  String get addMedication => 'Ajouter un médicament';

  @override
  String get editMedication => 'Modifier le médicament';

  @override
  String get deleteMedication => 'Supprimer le médicament';

  @override
  String get areYouSureYouWantToDeleteThisMedication =>
      'Êtes-vous sûr de vouloir supprimer ce médicament?';

  @override
  String get cancel => 'Annuler';

  @override
  String get delete => 'Supprimer';

  @override
  String get medicationName => 'Nom du médicament';

  @override
  String get pleaseEnterAName => 'S\'il vous plaît entrer un nom';

  @override
  String get dosage => 'Dosage';

  @override
  String get forMedication => 'Pour: ';

  @override
  String get selectFamilyMember => 'Sélectionner un membre de la famille';

  @override
  String get couldNotLoadUsers => 'Impossible de charger les utilisateurs';

  @override
  String get reasonForUse => 'Raison d\'utilisation';

  @override
  String get expirationDate => 'Date d\'expiration';

  @override
  String get save => 'Enregistrer';

  @override
  String get testNotification => 'Notification de test';

  @override
  String get egIbuprofen => 'par exemple, l\'ibuprofène';

  @override
  String get eg2Pills200mg1Spray =>
      'par exemple, 2 comprimés, 200 mg, 1 pulvérisation';

  @override
  String get egHeadache => 'par exemple, mal de tête';

  @override
  String get dosageCard => 'Dosage: ';

  @override
  String get expiredOn => 'Expiré le ';

  @override
  String get expiresOn => 'Expire le ';
}
