import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:hugeicons_showcase/components/custom_app_bar.dart';
import 'package:hugeicons_showcase/main.dart';

class Credit {
  final String name;
  final String copyText;
  const Credit({required this.name, required this.copyText});
}

List<Credit> packages = [
  Credit(copyText: "Todo", name: 'First Credit'),
  Credit(copyText: "Todo", name: 'First Credit'),
  Credit(copyText: "Todo", name: 'First Credit'),
  Credit(copyText: "Todo", name: 'First Credit'),
  Credit(copyText: "Todo", name: 'First Credit'),
  Credit(copyText: "Todo", name: 'First Credit'),
  Credit(copyText: "Todo", name: 'First Credit'),
  Credit(copyText: "Todo", name: 'First Credit'),
  Credit(copyText: "Todo", name: 'First Credit'),
  Credit(copyText: "Todo", name: 'First Credit'),
  Credit(copyText: "Todo", name: 'First Credit'),
  Credit(copyText: "Todo", name: 'First Credit'),
];

class CreditsPage extends StatelessWidget {
  const CreditsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        context,
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        leadingIcon: creditsIcon,
        titleText: "Credits",
      ),
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            title: Text(
              "Flutter Packages",
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ),
          SliverGrid.builder(
            gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
              maxCrossAxisExtent: 200,
            ),
            itemCount: packages.length,
            itemBuilder: (context, index) =>
                Expanded(child: CreditsCard(credit: packages[index])),
          ),
        ],
      ),
    );
  }
}

class CreditsCard extends StatelessWidget {
  final Credit credit;
  const CreditsCard({super.key, required this.credit});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        child: Center(child: Text(credit.name)),
        onLongPress: () => Clipboard.setData(ClipboardData(text: "ToDo")),
      ),
    );
  }
}
