import 'package:ChatGo/model/mycolors.dart';
import 'package:ChatGo/pages/account.dart';
import 'package:ChatGo/pages/chatHome.dart';
import 'package:ChatGo/pages/discover.dart';
import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> with SingleTickerProviderStateMixin {
  TabController _tabController;

  @override
  void initState() {
    _tabController = TabController(length: 3, vsync: this, initialIndex: 0);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [content(), bottomNavigation()],
      ),
    );
  }

  Widget bottomNavigation() {
    return Container(
      margin: EdgeInsets.only(bottom: 10),
      child: TabBar(
        controller: _tabController,
        indicator: UnderlineTabIndicator(
            borderSide: BorderSide(style: BorderStyle.none)),
        labelColor: Colors.black,
        unselectedLabelColor: MyColor.grey,
        tabs: [
          Tab(
            icon: Icon(
              Icons.home,
              size: 30,
            ),
          ),
          Tab(
            icon: Icon(
              Icons.search,
              size: 30,
            ),
          ),
          Tab(
            icon: Icon(
              Icons.account_circle,
              size: 30,
            ),
          )
        ],
      ),
    );
  }

  Widget content() {
    return Expanded(
        child: TabBarView(
      controller: _tabController,
      children: [
        ChatHome(),
        DiscoverPeople(),
        Account(),
      ],
    ));
  }
}
