import 'package:share/share.dart';

void share() {
  DateTime mdstDate = DateTime(2021, 2, 7);
  int difference = mdstDate.difference(DateTime.now()).inDays;
  final String message = "Mach mit beim Mach Deine 💩 Tag 2021. Nur noch $difference Tage! "
      "Einfach App runterladen und los geht's.\n\n "
      "App Store: https://testflight.apple.com/join/3S1WL4km \n\n "
      "Google Play Store: https://play.google.com/apps/internaltest/4698175051157648216";
  Share.share(message);
}
