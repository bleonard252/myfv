import "package:flutter/material.dart";
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:myfv/parse/data.dart';
import 'package:myfv/render/header.dart';
import 'package:myfv/render/card_basic.dart';

// ignore: must_be_immutable
class RenderedMyfileScreen extends StatelessWidget {
  final ParsedMyfileData myfile;
  RenderedMyfileScreen({ Key? key, required this.myfile }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final List<_TabPage> _tabs = [
      // && myfile.cards.isNotEmpty
      if (MediaQuery.of(context).size.width > 640) _TabPage(Tab(
        child: Text("About"),
      ), Container())
    ];
    return SingleChildScrollView(
      child: MediaQuery.of(context).size.width > 640 ? Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 480,
            child: Column(
              children: [
                Card(
                  child: MyfileHeaderSection(myfile: myfile),
                ),
                for (var card in myfile.cards) 
                  if (card is BasicMyfileCard) Container(child: card.render(), width: double.infinity)
              ],
            ),
          ),
          // Expanded(
          //   child: Column(
          //     children: [
          //       // Tabs and posts here
          //     ],
          //   ),
          // ),
        ]
      ) : Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            color: Theme.of(context).cardColor,
            child: MyfileHeaderSection(myfile: myfile),
          ),
          //SliverFillRemaining(/* Will house tabs and posts */)
        ]
      )
    );
  }
}

class _TabPage {
  final Tab tab;
  final Widget page;
  _TabPage(this.tab, this.page);
}