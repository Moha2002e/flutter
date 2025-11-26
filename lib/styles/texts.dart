import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'colors.dart';
import 'sizes.dart';

const kBaseFontSize = 16.0;

const TextStyle kCarouselText = TextStyle(
  fontSize: kBaseFontSize,
  fontStyle: FontStyle.italic,
  color: kWhiteColor,
);

const TextStyle kMainButtonText = TextStyle(
  color: kWhiteColor,
  fontSize: 18,
  fontFamily: 'Avenir',
  fontWeight: FontWeight.w500,
);

const TextStyle kSecondaryButtonText = TextStyle(
  color: kMainButtonColor,
  fontSize: 18,
  fontFamily: 'Avenir',
  fontWeight: FontWeight.w500,
);

const kTitleHome = TextStyle(
  fontWeight: FontWeight.w600,
  height: 1,
  fontSize: 27,
  color: kMainColor,
);

const kTextSideBar = TextStyle(
  fontWeight: FontWeight.w600,
  fontSize: 20,
  height: 1,
  color: kSecondaryColor,
);

const kTitleSideBar = TextStyle(
  fontWeight: FontWeight.w600,
  fontSize: 27,
  color: kMainColor,
);

// Styles pour l'écran de connexion
const double kAppNameFontSize = 24.0;
const double kLoginTitleFontSize = 28.0;
const double kLabelFontSize = 16.0;
const double kInputFontSize = 16.0;
const double kLinkFontSize = 14.0;
const double kRegisterLinkFontSize = 16.0;

const TextStyle kAppNameText = TextStyle(
  color: kWhiteColor,
  fontSize: kAppNameFontSize,
  fontWeight: FontWeight.w600,
  fontFamily: 'Avenir',
);

const TextStyle kLoginTitleText = TextStyle(
  color: kWhiteColor,
  fontSize: kLoginTitleFontSize,
  fontWeight: FontWeight.w600,
  fontFamily: 'Avenir',
);

const TextStyle kLabelText = TextStyle(
  color: kWhiteColor,
  fontSize: kLabelFontSize,
  fontFamily: 'Avenir',
);

const TextStyle kInputText = TextStyle(
  color: Colors.black,
  fontSize: kInputFontSize,
  fontFamily: 'Avenir',
);

const TextStyle kLinkText = TextStyle(
  color: kWhiteColor,
  fontSize: kLinkFontSize,
  fontFamily: 'Avenir',
  decoration: TextDecoration.underline,
);

const TextStyle kRegisterLinkText = TextStyle(
  color: kWhiteColor,
  fontSize: kRegisterLinkFontSize,
  fontFamily: 'Avenir',
  decoration: TextDecoration.underline,
);

// Styles pour HomeScreen
const TextStyle kGreetingText = TextStyle(
  color: kWhiteColor,
  fontFamily: 'Avenir',
  fontWeight: FontWeight.w600,
);

const TextStyle kHomeButtonText = TextStyle(
  color: kWhiteColor,
  fontSize: 16.0,
  fontFamily: 'Avenir',
  fontWeight: FontWeight.w500,
);

// Styles pour ProfileScreen
const TextStyle kProfileInfoValueText = TextStyle(
  color: kWhiteColor,
  fontSize: kProfileInfoValueFontSize,
  fontFamily: 'Avenir',
  fontWeight: FontWeight.w500,
);

const TextStyle kProfileButtonText = TextStyle(
  fontSize: kBaseFontSize,
  fontFamily: 'Avenir',
  fontWeight: FontWeight.w600,
);

// Styles pour ClubsScreen
const TextStyle kClubsScreenTitleText = TextStyle(
  color: kWhiteColor,
  fontSize: 24.0,
  fontWeight: FontWeight.bold,
  fontFamily: 'Avenir',
);

const TextStyle kClubCardTitleText = TextStyle(
  fontSize: 18.0,
  fontWeight: FontWeight.bold,
  fontFamily: 'Avenir',
  color: Colors.black,
);

const TextStyle kClubCardDescriptionText = TextStyle(
  fontSize: 14.0,
  fontFamily: 'Avenir',
  color: Colors.black87,
);

const TextStyle kClubCardInfoText = TextStyle(
  fontSize: 12.0,
  fontFamily: 'Avenir',
  color: Colors.black54,
);

const TextStyle kClubCardButtonText = TextStyle(
  fontFamily: 'Avenir',
  fontWeight: FontWeight.w500,
);

// Styles pour ClubDetailScreen
const TextStyle kClubDetailTitleText = TextStyle(
  color: kWhiteColor,
  fontSize: 28.0,
  fontWeight: FontWeight.bold,
  fontFamily: 'Avenir',
);

const TextStyle kClubDetailCardTitleText = TextStyle(
  fontSize: 20.0,
  fontWeight: FontWeight.bold,
  fontFamily: 'Avenir',
  color: Colors.black,
);

const TextStyle kClubDetailDescriptionText = TextStyle(
  fontSize: 16.0,
  fontFamily: 'Avenir',
  color: Colors.black87,
  height: 1.6,
);

const TextStyle kClubDetailButtonText = TextStyle(
  fontSize: 18.0,
  fontFamily: 'Avenir',
  fontWeight: FontWeight.w600,
);

// Styles pour CreerClubScreen
const TextStyle kCreerClubTitleText = TextStyle(
  color: kWhiteColor,
  fontSize: 24.0,
  fontWeight: FontWeight.bold,
  fontFamily: 'Avenir',
);

// Styles pour AnnoncesScreen
const TextStyle kAnnoncesScreenTitleText = TextStyle(
  color: kWhiteColor,
  fontSize: 24.0,
  fontWeight: FontWeight.bold,
  fontFamily: 'Avenir',
);

const TextStyle kAnnonceCardTitleText = TextStyle(
  fontSize: 18.0,
  fontWeight: FontWeight.bold,
  fontFamily: 'Avenir',
  color: Colors.black,
);

const TextStyle kAnnonceCardDescriptionText = TextStyle(
  fontSize: 14.0,
  fontFamily: 'Avenir',
  color: Colors.black87,
);

const TextStyle kAnnonceCardInfoText = TextStyle(
  fontSize: 12.0,
  fontFamily: 'Avenir',
  color: Colors.black54,
);

const TextStyle kAnnonceCardButtonText = TextStyle(
  fontFamily: 'Avenir',
  fontWeight: FontWeight.w500,
);

// Styles pour CreerAnnonceScreen
const TextStyle kCreerAnnonceTitleText = TextStyle(
  color: kWhiteColor,
  fontSize: 24.0,
  fontWeight: FontWeight.bold,
  fontFamily: 'Avenir',
);

// Styles pour EvenementsScreen
const TextStyle kEvenementsScreenTitleText = TextStyle(
  color: kWhiteColor,
  fontSize: 24.0,
  fontWeight: FontWeight.bold,
  fontFamily: 'Avenir',
);

const TextStyle kEvenementCardTitleText = TextStyle(
  fontSize: 18.0,
  fontWeight: FontWeight.bold,
  fontFamily: 'Avenir',
  color: Colors.black,
);

const TextStyle kEvenementCardDescriptionText = TextStyle(
  fontSize: 14.0,
  fontFamily: 'Avenir',
  color: Colors.black87,
);

const TextStyle kEvenementCardInfoText = TextStyle(
  fontSize: 12.0,
  fontFamily: 'Avenir',
  color: Colors.black54,
);

const TextStyle kEvenementCardButtonText = TextStyle(
  fontFamily: 'Avenir',
  fontWeight: FontWeight.w500,
);

// Styles pour CreerEvenementScreen
const TextStyle kCreerEvenementTitleText = TextStyle(
  color: kWhiteColor,
  fontSize: 24.0,
  fontWeight: FontWeight.bold,
  fontFamily: 'Avenir',
);

// Styles pour CalendrierScreen
const TextStyle kCalendrierScreenTitleText = TextStyle(
  color: kWhiteColor,
  fontSize: 24.0,
  fontWeight: FontWeight.bold,
  fontFamily: 'Avenir',
);

const TextStyle kCoursCardTitleText = TextStyle(
  fontSize: 18.0,
  fontWeight: FontWeight.bold,
  fontFamily: 'Avenir',
  color: Colors.black,
);

const TextStyle kCoursCardInfoText = TextStyle(
  fontSize: 12.0,
  fontFamily: 'Avenir',
  color: Colors.black54,
);

const TextStyle kCoursCardButtonText = TextStyle(
  fontFamily: 'Avenir',
  fontWeight: FontWeight.w500,
);

// Styles pour CreerCoursScreen
const TextStyle kCreerCoursTitleText = TextStyle(
  color: kWhiteColor,
  fontSize: 24.0,
  fontWeight: FontWeight.bold,
  fontFamily: 'Avenir',
);

// Styles pour CoursDetailScreen
const TextStyle kCoursDetailTitleText = TextStyle(
  color: kWhiteColor,
  fontSize: 28.0,
  fontWeight: FontWeight.bold,
  fontFamily: 'Avenir',
);

const TextStyle kCoursDetailCardTitleText = TextStyle(
  fontSize: 20.0,
  fontWeight: FontWeight.bold,
  fontFamily: 'Avenir',
  color: Colors.black,
);

const TextStyle kCoursDetailInfoText = TextStyle(
  fontSize: 16.0,
  fontFamily: 'Avenir',
  color: Colors.black87,
);

// Styles pour AnnonceDetailScreen
const TextStyle kAnnonceDetailTitleText = TextStyle(
  color: kWhiteColor,
  fontSize: 28.0,
  fontWeight: FontWeight.bold,
  fontFamily: 'Avenir',
);

const TextStyle kAnnonceDetailCardTitleText = TextStyle(
  fontSize: 20.0,
  fontWeight: FontWeight.bold,
  fontFamily: 'Avenir',
  color: Colors.black,
);

const TextStyle kAnnonceDetailDescriptionText = TextStyle(
  fontSize: 16.0,
  fontFamily: 'Avenir',
  color: Colors.black87,
  height: 1.6,
);

const TextStyle kAnnonceDetailInfoText = TextStyle(
  fontSize: 16.0,
  fontFamily: 'Avenir',
  color: Colors.black87,
);

// Styles pour EvenementDetailScreen
const TextStyle kEvenementDetailTitleText = TextStyle(
  color: kWhiteColor,
  fontSize: 28.0,
  fontWeight: FontWeight.bold,
  fontFamily: 'Avenir',
);

const TextStyle kEvenementDetailCardTitleText = TextStyle(
  fontSize: 20.0,
  fontWeight: FontWeight.bold,
  fontFamily: 'Avenir',
  color: Colors.black,
);

const TextStyle kEvenementDetailDescriptionText = TextStyle(
  fontSize: 16.0,
  fontFamily: 'Avenir',
  color: Colors.black87,
  height: 1.6,
);

const TextStyle kEvenementDetailInfoText = TextStyle(
  fontSize: 16.0,
  fontFamily: 'Avenir',
  color: Colors.black87,
);
