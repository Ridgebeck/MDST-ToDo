import 'package:flutter/material.dart';

const String mdstStart = '2021-02-07 00:00:00.000';
const String mdstEnd = '2021-02-08 00:00:00.000';
const int kUploadFrequencyMin = 5;
const int kDownloadFrequencyMin = 5;

const Color kKliemannPink = Color.fromRGBO(231, 178, 171, 1.0);
const Color kKliemannGelb = Color.fromRGBO(234, 180, 92, 1.0);
const Color kKliemannBlau = Color.fromRGBO(98, 130, 147, 1.0);
const Color kKliemannGrau = Color.fromRGBO(44, 58, 66, 1.0);

const Color kActiveColor = Colors.white;
const Color kInactiveColor = kKliemannPink;

const kTitleStyle = TextStyle(
  fontSize: 30.0,
  color: kInactiveColor,
);

const kTitleStyleActive = TextStyle(
  fontSize: 30.0,
  color: kActiveColor,
);

const kSubtitleStyle = TextStyle(
  fontSize: 19,
  color: kInactiveColor,
);
const kSubtitleStyleActive = TextStyle(
  fontSize: 19,
  color: kActiveColor,
);

const kInfoTextStyle = TextStyle(
  fontSize: 15,
  color: kInactiveColor,
);
const kInfoTextStyleActive = TextStyle(
  fontSize: 15,
  color: kActiveColor,
);

const kSubtitlePadding = 15.0;
const double kEmojiTextSize = 35.0;
const double kLeadingIconSize = 45.0;
const String slideMessage = 'swipe 👉 wenn feddich';
const String playMessage = 'drück ▶ um zu starten \n swipe 👈 zum 🗑';

enum listType { active, finished, archived }
enum entryType { category, activity }

const kStatsTitleStyle = TextStyle(
  fontSize: 24.0,
  color: kKliemannGrau,
);
const kStatsSubtitleStyle = TextStyle(
  fontSize: 16.0,
  color: kKliemannGrau,
);

const kGifTextStyle = TextStyle(
  color: kKliemannGrau,
  fontSize: 35,
);

const List<Text> emptyTextList = [Text('a')];
