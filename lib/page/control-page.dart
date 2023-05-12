import 'package:antdesign_icons/antdesign_icons.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:khatadiary/page/add-client.dart';
import 'package:khatadiary/page/cleared-page.dart';
import 'package:khatadiary/page/history-page.dart';
import 'package:khatadiary/page/home-page.dart';
import 'package:khatadiary/page/log-page.dart';
import 'package:khatadiary/service/firebase/auth.dart';
import 'package:khatadiary/service/firebase/update.dart';

import '../common/style.dart';
import '../service/firebase/add.dart';
import '../widget/function/navigator.dart';
import '../widget/home/log-tile.dart';

class ControlPage extends StatefulWidget {
  const ControlPage({super.key});

  @override
  State<ControlPage> createState() => _ControlPageState();
}

class _ControlPageState extends State<ControlPage>
    with SingleTickerProviderStateMixin {
  int currentIndex = 0;
  bool search = false;
  String name = '';
  bool internet = false;

  List<Widget> tabs = [
    const Tab(
      text: 'Home',
    ),
    const Tab(
      text: 'Log',
    ),
    const Tab(
      text: 'Cleared',
    ),
  ];

  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    checkInternet();
    updateInterest();
    _tabController = TabController(length: tabs.length, vsync: this);
  }

  Future<void> checkInternet() async {
    var connectivityResult = await Connectivity().checkConnectivity();
    if (connectivityResult == ConnectivityResult.none) {
      setState(() {
        internet = false;
      });
    } else {
      setState(() {
        internet = true;
      });
    }
  }

  Future<void> updateInterest() async {
    try {
      QuerySnapshot querySnapshot = await firestore.collection('client').get();
      for (DocumentSnapshot docSnapshot in querySnapshot.docs) {
        DocumentReference docRef = docSnapshot.reference;
        dynamic id = docSnapshot.get('id');
        dynamic principal = docSnapshot.get('principal');
        dynamic time = docSnapshot.get('time');
        dynamic monthly = docSnapshot.get('monthly');
        DateTime today = DateTime.now();
        DateTime principalDay =
            DateTime.fromMillisecondsSinceEpoch(int.parse(time));
        Duration difference = today.difference(principalDay);
        double interest = monthly
            ? principal * 0.3 * difference.inDays / 365
            : principal * 0.36 * difference.inDays / 365;
        updateDaily(id, principal + interest, interest,
            '${DateTime.now().millisecondsSinceEpoch}');
      }
    } catch (e) {
      debugPrint('--------> ${e.toString()}');
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  List<Widget> tabViews = [
    const HomePage(),
    const LogPage(),
    const ClearedPage()
  ];
  @override
  Widget build(BuildContext context) {
    return internet
        ? Scaffold(
            floatingActionButton: Padding(
              padding: EdgeInsets.all(kPad(context) * 0.05),
              child: InkWell(
                onTap: () => push(context, const AddClient()),
                child: Material(
                  shadowColor: primaryColor(context).withOpacity(0.5),
                  elevation: 10,
                  shape: const CircleBorder(),
                  child: Container(
                    decoration: BoxDecoration(
                        shape: BoxShape.circle, color: primaryColor(context)),
                    padding: EdgeInsets.all(kPad(context) * 0.04),
                    child: Icon(
                      CupertinoIcons.add,
                      color: scaffoldColor(context),
                    ),
                  ),
                ),
              ),
            ),
            appBar: AppBar(
              toolbarHeight: kPad(context) * 0.15,
              elevation: 0,
              backgroundColor: scaffoldColor(context),
              centerTitle: true,
              title: Text(
                'Interest Diary',
                style: style(context).copyWith(
                    color: darkC.withOpacity(0.6),
                    fontWeight: FontWeight.bold,
                    fontSize: kPad(context) * 0.05),
              ),
              leading: IconButton(
                padding: EdgeInsets.only(left: kPad(context) * 0.1),
                onPressed: () async => await signOut(context),
                icon: Icon(
                  AntIcons.disconnectOutlined,
                  color: darkC.withOpacity(0.5),
                  size: kPad(context) * 0.05,
                ),
              ),
              actions: [
                Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: kPad(context) * 0.05),
                  child: IconButton(
                      onPressed: () => setState(() => search = !search),
                      icon: Icon(
                        search
                            ? CupertinoIcons.multiply
                            : CupertinoIcons.search,
                        color: darkC.withOpacity(0.5),
                        size: kPad(context) * 0.05,
                      )),
                )
              ],
              bottom: search
                  ? PreferredSize(
                      preferredSize: const Size(double.infinity, 45),
                      child: Container(
                        height: kPad(context) * 0.1,
                        width: kPad(context) * 0.85,
                        decoration: BoxDecoration(
                            color: shadowColor(context).withOpacity(0.03),
                            borderRadius: BorderRadius.circular(5)),
                        padding: EdgeInsets.symmetric(
                            horizontal: kPad(context) * 0.05),
                        child: TextFormField(
                          showCursor: false,
                          onChanged: (v) {
                            setState(() {
                              name = v;
                            });
                          },
                          style: style(context)
                              .copyWith(decoration: TextDecoration.none),
                          decoration: InputDecoration(
                            hintText: 'Search here',
                            hintStyle: style(context).copyWith(
                                color: shadowColor(context).withOpacity(0.4)),
                            enabledBorder: InputBorder.none,
                            focusedBorder: InputBorder.none,
                          ),
                        ),
                      ))
                  : TabBar(
                      labelColor: primaryColor(context),
                      unselectedLabelColor:
                          shadowColor(context).withOpacity(0.4),
                      labelStyle: style(context).copyWith(
                          fontWeight: FontWeight.bold,
                          fontSize: kPad(context) * 0.04),
                      indicatorColor: primaryColor(context),
                      controller: _tabController,
                      tabs: tabs,
                      onTap: (index) {
                        currentIndex = index;
                      },
                    ),
            ),
            body: Column(
              children: [
                Expanded(
                    child: search
                        ? StreamBuilder(
                            stream: firestore
                                .collection('client')
                                .orderBy('id', descending: true)
                                .snapshots(),
                            builder: (context, snapshot) {
                              return (snapshot.connectionState ==
                                      ConnectionState.waiting)
                                  ? const SizedBox(
                                      height: 0,
                                    )
                                  : ListView.builder(
                                      physics: const BouncingScrollPhysics(),
                                      itemCount: snapshot.data!.docs.length,
                                      itemBuilder: (context, index) {
                                        var data =
                                            snapshot.data!.docs[index].data();
                                        DateTime nTime =
                                            DateTime.fromMillisecondsSinceEpoch(
                                                int.parse(data['time']));
                                        String date =
                                            DateFormat('dd MMMM, yyyy')
                                                .format(nTime);
                                        if (name.isEmpty) {
                                          return const SizedBox(
                                            height: 0,
                                          );
                                        }
                                        if (data['name']
                                            .toString()
                                            .toLowerCase()
                                            .startsWith(name.toLowerCase())) {
                                          return InkWell(
                                            onTap: () => push(
                                                context,
                                                HistoryPage(
                                                  id: data['id'],
                                                  name: data['name'],
                                                )),
                                            child: LogTile(
                                              name: data['name'],
                                              left: data['amount'],
                                              given: data['loan'],
                                              got: data['received'],
                                              date: date,
                                              avatar: '',
                                              monthly: data['monthly'],
                                              clear: data['clear'],
                                            ),
                                          );
                                        }
                                        return const SizedBox(
                                          height: 0,
                                        );
                                      });
                            })
                        : TabBarView(
                            controller: _tabController,
                            children: tabViews,
                          ))
              ],
            ))
        : Scaffold(
            body: Center(
              child: Material(
                borderRadius: BorderRadius.circular(20),
                elevation: 20,
                shadowColor: primaryColor(context).withOpacity(0.3),
                child: Container(
                  height: kPad(context) * 0.7,
                  width: kPad(context) * 0.6,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      gradient: LinearGradient(colors: [
                        primaryColor(context).withOpacity(0.4),
                        Colors.blueAccent
                      ], begin: Alignment.topLeft, end: Alignment.bottomRight)),
                  child: Padding(
                    padding: EdgeInsets.all(kPad(context) * 0.1),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          AntIcons.disconnectOutlined,
                          color: Colors.white,
                          size: kPad(context) * 0.1,
                        ),
                        SizedBox(
                          height: kPad(context) * 0.04,
                        ),
                        Center(
                          child: Text(
                            'No Internet',
                            style: style(context).copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: kPad(context) * 0.07),
                          ),
                        ),
                        SizedBox(
                          height: kPad(context) * 0.05,
                        ),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              shadowColor:
                                  shadowColor(context).withOpacity(0.5),
                              backgroundColor: scaffoldColor(context),
                              side: BorderSide(
                                  color: shadowColor(context).withOpacity(0.1)),
                              elevation: 0),
                          onPressed: () =>
                              replace(context, const ControlPage()),
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: kPad(context) * 0.05,
                                vertical: kPad(context) * 0.04),
                            child: Text(
                              'Retry',
                              style: style(context).copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: primaryColor(context)),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
  }
}
