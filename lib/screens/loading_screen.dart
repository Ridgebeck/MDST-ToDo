import 'package:MDST_todo/widgets/gif_page.dart';
import 'package:flutter/material.dart';

class LoadingScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GifPage(assetImageString: 'assets/loading.gif');
  }
}
