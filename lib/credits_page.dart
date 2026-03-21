import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:hugeicons_showcase/components/custom_app_bar.dart';

class CreditsPage extends StatelessWidget {
  const CreditsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        context,
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        leadingIcon: HugeIcon(icon: HugeIcons.strokeRoundedLaurelWreath01),
        titleText: "Credits",
      ),
    );
  }
}
