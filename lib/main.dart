import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'utilities/screen_util.dart';
import 'package:easy_trip_app/pages/DispatchedRoutePage.dart';
import 'package:easy_trip_app/pages/NewTripPage.dart';
import 'package:easy_trip_app/pages/SettingPage.dart';
import 'package:easy_trip_app/pages/WaterfallFlowSubpage.dart';
import 'package:easy_trip_app/pages/LoginPage.dart';
import 'package:easy_trip_app/presets.dart';
import 'package:easy_trip_app/widgets/BottomNaviBar.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '易旅 | EasyTrip',
      theme: ThemeData(
          primarySwatch: Colors.green,
          fontFamily: "Source Han Sans CN | PingFang SC"),
      home: MyHomePage(title: 'Flutter Demo Ryuujo!'),
      routes: {
        "/login": (_) => LoginPage(),
        "/settings": (_) => SettingPage(),
        "/new-trip": (_) => NewTripPage(),
        // "/dispatch": (_) => DispatchedRoutePage()..initFromUri(),
        ///dispatch
      },
      onGenerateRoute: (settings) {
        var data = settings.arguments as DispatchedRouteArgument;
        if (settings.name == "/dispatch")
          return MaterialPageRoute(builder: (__) => DispatchedRoutePage(spots: data.spots.toList(), routes: data.routes.toList()));
        else return null;
      },
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage>
    with ScreenUtil, TickerProviderStateMixin {
  String? userId;

  int currentIndex = 0;
  late TabController _tabController;

  // late AnimationController animeCtrl;
  // late Color currentColor;
  //
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this)
      ..addListener(() => setState(() {
            currentIndex = _tabController.index;
          }));
    // animeCtrl = AnimationController(
    //     duration: Duration(milliseconds: 3000),
    //     vsync: this
    // )
    //   ..addListener(() =>
    //       setState(() {
    //         currentColor =
    //           Color.lerp(Colors.green[50], Colors.yellow[300], animeCtrl.value)!;
    //       }));
  }

  @override
  void dispose() {
    // animeCtrl.dispose();
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    ScreenUtil.instance = ScreenUtil()..init(context);
    double setSize(double size, {double? max, double? min}) =>
        size > (max ?? size)
            ? max!
            : size < (min ?? size)
                ? min!
                : size;
    var iconSize = setSize(setWidth(50), max: setHeight(60));


    return Scaffold(
        extendBody: true,
        drawer: Container(
          width: setWidth(550),
          color: Colors.white,
          child: Column(
            children: [
              Spacer(),
              Flexible(
                  flex: 10,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
                        color: Colors.grey[50],
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          // ID & Description centered
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            SizedBox(
                              width: 10,
                            ),
                            Container(
                              // color: Colors.lime,
                              child: IconButton(
                                icon: Icon(Icons.account_circle_rounded),
                                iconSize: setWidth(120), // TODO: 修改为百分比布局
                                onPressed: () =>
                                    Navigator.of(context).pushNamed("/login"),
                              ),
                            ),
                            SizedBox(
                              width: 6,
                            ),
                            Container(
                              // maxHeight: setWidth(120),
                              // color: Colors.grey[100],
                              height: setWidth(140),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    userId ?? "ryuujo",
                                    style: defaultTextStyle.copyWith(
                                        fontSize: 24,
                                        fontWeight: FontWeight.w300,
                                        color: Colors.black),
                                  ),
                                  Text(
                                    "coding..",
                                    style: defaultTextStyle.copyWith(
                                        color: Colors.grey[600]),
                                  )
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    ],
                  ))
            ],
          ),
        ),
        appBar: PreferredSize(
          preferredSize:
              Size.fromHeight(setSize(setWidth(100), max: setHeight(120))),
          child: AppBar(
            // User Page - AppBar
            leading: null,
            title: null,
            toolbarHeight: setSize(setWidth(100), max: setHeight(120)),
            // setWidth(100) > setHeight(120)
            //     ? setHeight(120)
            //     : setWidth(100),
            //setWidth(100) > setHeight(120)
            //                           ? setHeight(120)
            //                           : setWidth(100)
            actions: [
              IconButton(
                icon: Icon(Icons.settings_rounded),
                iconSize: iconSize,
                onPressed: () => Navigator.of(context).pushNamed('/settings'),
              ),
              IconButton(
                icon: Icon(Icons.qr_code_scanner_rounded),
                iconSize: iconSize,
                onPressed: () => notImplemented(context),
              ),
              IconButton(
                icon: Icon(Icons.notifications_none_rounded),
                iconSize: iconSize,
                onPressed: () => notImplemented(context),
              ),
              SizedBox(
                width: 18,
              )
            ],
          ),
        ),
        body: TabBarView(
          controller: _tabController,
          children: [
            WaterfallFlowSubpage(),
            Center(
              child: IconButton(
                  splashRadius: 28,
                  iconSize: 64,
                  icon: Icon(
                    Icons.account_circle,
                    size: 64,
                    color: Colors.green[50],
                  ),
                  hoverColor: Colors.white,
                  color: Colors.green[50],
                  onPressed: () => Navigator.of(context).pushNamed("/login")
                  //.then((val) => val != null ? _getRequests() : null),
                  ),
            )
          ],
        ),
        // body: currentIndex == 0 ? null : Center(
        //     child: IconButton(
        //   splashRadius: 28,
        //   iconSize: 64,
        //   icon: Icon(
        //     Icons.account_circle,
        //     size: 64,
        //     color: Colors.green[50],
        //   ),
        //   hoverColor: Colors.white,
        //   color: Colors.green[50],
        //   onPressed: () => Navigator.of(context)
        //       .push(MaterialPageRoute(
        //           builder: (_) => LoginPage(), fullscreenDialog: true))
        //       .then((val) => val ? _getRequests() : null),
        // )),
        floatingActionButton: SizedBox(
            width: setWidth(100),
            height: setWidth(100),
            child: FloatingActionButton(
              child: Center(
                  child: Icon(
                Icons.add_rounded,
                size: setWidth(80),
                color: Colors.white,
              )),
              onPressed: () => Navigator.of(context).pushNamed("/new-trip"),
              // Navigator.of(context).restorablePush((_, __) =>
              // MaterialPageRoute(
              //     settings: RouteSettings(
              //         name: "newTrip", arguments: null //可能会加入长按动作，产生不同的参数。
              //         ),
              //     builder: (_) => WillPopScope(
              //       onWillPop: () async {
              //         Navigator.pop(context);
              //         return true;
              //       },
              //         child: NewTripPage()
              //     ),
              //     fullscreenDialog: true)),
              shape: CircleBorder(),
              elevation: 10,
            )),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        bottomNavigationBar: BottomNaviBar(
          child: SizedBox(
            height: 80,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                IconButton(
                  // index 0
                  iconSize: 48,
                  icon: Icon(
                    Icons.home_rounded,
                  ),
                  color: currentIndex == 0
                      ? Theme.of(context).primaryColor
                      : Colors.grey[500],
                  onPressed: () => setState(() {
                    if (currentIndex != 0) {
                      currentIndex = 0;
                      _tabController.animateTo(0);
                    }
                  }),
                  tooltip: "Home",
                ),
                SizedBox(
                  width: setWidth(120),
                ),
                IconButton(
                  iconSize: 48,
                  icon: Icon(
                    Icons.account_circle_rounded,
                  ),
                  focusColor: Theme.of(context).focusColor,
                  color: currentIndex == 1
                      ? Theme.of(context).primaryColor
                      : Colors.grey[500],
                  onPressed: () => setState(() {
                    if (currentIndex != 1) {
                      currentIndex = 1;
                      _tabController.animateTo(1);
                    }
                  }),
                  tooltip: "User",
                ),
              ],
            ),
          ),
        ));
  }
}
