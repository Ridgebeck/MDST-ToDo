import 'package:share/share.dart';

void share() {
  DateTime mdstDate = DateTime(2021, 2, 7);
  int difference = mdstDate.difference(DateTime.now()).inDays;
  difference = difference > 0 ? difference : 0;
  final String message =
      "Mach mit beim Mach Deine 💩 Tag 2021 am 7ten Februar. Nur noch $difference Tage! "
      "Einfach App runterladen und los geht's.\n\n "
      "App Store: https://apps.apple.com/us/app/mdst21/id1550716944 \n\n "
      "Google Play Store: https://play.google.com/store/apps/details?id=com.xrx.mdst_21";
  Share.share(message);
}
