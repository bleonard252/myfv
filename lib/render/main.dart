import "package:flutter/material.dart";
import 'package:flutter/src/scheduler/ticker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:myfv/parse/data.dart';
import 'package:myfv/render/header.dart';
import 'package:myfv/render/card_basic.dart';

// ignore: must_be_immutable
class RenderedMyfileScreen extends StatelessWidget implements TickerProvider {
  final ParsedMyfileData myfile;
  RenderedMyfileScreen({ Key? key, required this.myfile }) : super(key: key);

  TabController? tabController;

  @override
  Widget build(BuildContext context) {
    final List<_TabPage> _tabs = [
      // && myfile.cards.isNotEmpty
      if (MediaQuery.of(context).size.width < 640) _TabPage(Tab(
        child: Text("About"),
      ), ListView(children: [
        for (var card in myfile.cards) 
          if (card is BasicMyfileCard) Container(child: card.render(), width: double.infinity)
      ]))
    ];
    tabController = TabController(length: _tabs.length, initialIndex: tabController?.index ?? 0, vsync: this);
    return MediaQuery.of(context).size.width > 640 ? SingleChildScrollView(
      child: Row(
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
          if (_tabs.length > 0) Expanded(
            flex: 0,
            child: Column(
              children: [
                TabBar(
                  tabs: _tabs.map<Widget>((e) => e.tab).toList(),
                  isScrollable: _tabs.length > 3,
                  controller: tabController,
                ),
                TabBarView(
                  children: _tabs.map<Widget>((e) => e.page).toList(),
                  controller: tabController,
                  physics: NeverScrollableScrollPhysics(),
                )
              ],
            ),
          ),
        ]
      )
    ) : CustomScrollView(
      slivers: [
        SliverToBoxAdapter(
          child: Container(
            color: Theme.of(context).cardColor,
            child: MyfileHeaderSection(myfile: myfile)
          ),
        ),
        SliverAppBar(
          elevation: 0,
          pinned: true,
          automaticallyImplyLeading: false,
          backgroundColor: Theme.of(context).cardColor,
          titleSpacing: 0.0,
          title: TabBar(
            labelColor: Theme.of(context).primaryColor,
            tabs: _tabs.map<Widget>((e) => e.tab).toList(),
            isScrollable: _tabs.length > 3,
            controller: tabController,
          ),
        ),
        SliverFillRemaining(
          child: TabBarView(
            children: _tabs.map<Widget>((e) => e.page).toList(),
            controller: tabController,
            physics: NeverScrollableScrollPhysics(),
          ),
        ),
      ]
    );
  }

  @override
  Ticker createTicker(TickerCallback onTick) => Ticker(onTick);
}

class _TabPage {
  final Tab tab;
  final Widget page;
  _TabPage(this.tab, this.page);
}