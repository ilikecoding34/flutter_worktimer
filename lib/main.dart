import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:math' as math;
import 'package:url_launcher/url_launcher.dart';
import 'package:worktimer/constants.dart';
import 'package:worktimer/input_widget_hour.dart';
import 'package:worktimer/input_widget_min.dart';
import 'package:worktimer/wave_widget.dart';
import 'input_widget_sec.dart';

import 'package:startapp_sdk/startapp.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Worktimer',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Mikor mehetek már?'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  final String title;

  const MyHomePage({
    Key? key,
    required this.title,
  }) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with TickerProviderStateMixin {
  var startAppSdk = StartAppSdk();
  var _sdkVersion = "";

  StartAppBannerAd? bannerAd;

  late Animation<double> animationfront;
  late Animation<double> animationback;
  late AnimationController controllerfront;
  late AnimationController controllerback;

  final arrivehour = TextEditingController();
  final arrivemin = TextEditingController();
  final arrivesec = TextEditingController();

  String _url = Constants.URL;

  int remain = 31200;
  double dinpercentage = 0.0;
  bool overtimeplus = true;
  bool lunchtime = true;
  bool isover = false;
  bool fail = false;

  double texthfw = 80;
  double textmfw = 100;
  double textsfw = 120;
  final double fsize = 20;

  bool _isRunning = false;
  bool textvisible = false;
  bool english = false;
  int hour = 0;
  int min = 0;
  int sec = 0;
  String overtimetext = "";
  String absolutendtext = "";
  String until = "";

  void _addItem() {
    final DateTime now = DateTime.now();
    if (arrivehour.text.isNotEmpty &&
        arrivemin.text.isNotEmpty &&
        arrivesec.text.isNotEmpty) {
      setState(() {
        textvisible = true;
        final endtime = DateTime(
            now.year,
            now.month,
            now.day - (int.parse(arrivehour.text) > now.hour ? 1 : 0),
            int.parse(arrivehour.text) + 8,
            int.parse(arrivemin.text) + (lunchtime ? 40 : 0),
            int.parse(arrivesec.text));
        final overtime = endtime.add(Duration(minutes: overtimeplus ? 20 : 0));

        hour = now.difference(endtime).inHours.abs() % 24;
        min = now.difference(endtime).inMinutes.abs() % 60;
        sec = now.difference(endtime).inSeconds.abs() % 60;
        dinpercentage =
            ((remain - now.difference(endtime).inSeconds.abs()) / remain);
        Duration value = now.difference(overtime).abs();
        Duration value2 = now.difference(endtime.add(Duration(hours: 4))).abs();
        if (now.isAfter(overtime)) {
          until = "";
        } else {
          until = english ? "until" : ' ';
        }
        isover = now.isAfter(endtime);
        fail = now.isAfter(endtime.add(Duration(hours: 4)));
        overtimetext =
            "${value.inHours % 24} : ${value.inMinutes % 60} : ${value.inSeconds % 60}";
        absolutendtext =
            "${value2.inHours % 24} : ${value2.inMinutes % 60} : ${value2.inSeconds % 60}";
      });
    } else {
      textvisible = false;
    }
  }

  void _launchURL() async {
    if (!await launch(
      _url,
      forceSafariVC: true,
      forceWebView: true,
      enableJavaScript: true,
    )) throw 'Could not launch $_url';
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is removed from the
    // widget tree.
    arrivehour.dispose();
    arrivemin.dispose();
    arrivesec.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    // TODO make sure to comment out this line before release
    startAppSdk.setTestAdsEnabled(true);

    // TODO your app doesn't need to call this method unless for debug purposes
    startAppSdk.getSdkVersion().then((value) {
      setState(() => _sdkVersion = value);
    });

    startAppSdk.loadBannerAd(StartAppBannerType.BANNER).then((bannerAd) {
      setState(() {
        this.bannerAd = bannerAd;
      });
    }).onError<StartAppException>((ex, stackTrace) {
      debugPrint("Error loading Banner ad: ${ex.message}");
    }).onError((error, stackTrace) {
      debugPrint("Error loading Banner ad: $error");
    });

    controllerfront = AnimationController(
      vsync: this,
      duration: Duration(seconds: 4),
    );

    controllerback = AnimationController(
      vsync: this,
      duration: Duration(seconds: 6),
    );

    Tween<double> waveTween = Tween(begin: -math.pi, end: math.pi);

    animationfront = waveTween.animate(
        new CurvedAnimation(parent: controllerfront, curve: Curves.easeInOut));
    animationback = waveTween.animate(
        new CurvedAnimation(parent: controllerback, curve: Curves.easeInOut));

    controllerfront.repeat(reverse: true);
    controllerback.repeat(reverse: true);

    _isRunning = true;
    Timer.periodic(Duration(seconds: 1), (Timer timer) {
      if (!_isRunning) {
        timer.cancel();
      }
      _addItem();
    });
  }

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    final double height = MediaQuery.of(context).size.height;
    String hungariantextovertime =
        fail ? "már mindegy..." : "(Ez előtt tuti: $absolutendtext)";
    String englishtextovertime =
        fail ? 'never mind...' : '(go before: $absolutendtext)';
    String overtext = english ? 'overtime:' : 'túlóra';
    String warningtext =
        english ? (englishtextovertime) : (hungariantextovertime);
    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          title: Text(english ? Constants.TITLE : Constants.CIM),
          actions: [
            Text('HU'),
            Switch(
                activeColor: Colors.yellow,
                value: english,
                onChanged: (v) => {
                      setState(() {
                        english = v;
                      }),
                    }),
            Text('EN'),
          ],
        ),
        body: Stack(children: [
          Positioned(
              child: Waveanimation(
                  width: width,
                  height: height,
                  animation: animationfront,
                  dinpercentage: dinpercentage,
                  front: true)),
          Positioned(
              child: Waveanimation(
                  width: width,
                  height: height,
                  animation: animationback,
                  dinpercentage: dinpercentage,
                  front: false)),
          Column(children: [
            LinearProgressIndicator(
              value: dinpercentage,
              minHeight: 20.0,
              color: dinpercentage < 0.7
                  ? Colors.red
                  : dinpercentage > 0.9
                      ? Colors.green
                      : Colors.yellow,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                    padding: EdgeInsets.only(right: 10),
                    child: Column(
                      children: [
                        Text(english ? Constants.OVERTIME : Constants.TULORA),
                        Switch(
                            value: overtimeplus,
                            onChanged: (value) => {
                                  setState(() {
                                    overtimeplus = value;
                                  }),
                                })
                      ],
                    )),
                Column(
                  children: [
                    Text(english ? Constants.LUNCH : Constants.EBED),
                    Switch(
                        value: lunchtime,
                        onChanged: (value) => {
                              setState(() {
                                lunchtime = value;
                              }),
                            })
                  ],
                )
              ],
            ),
            Padding(
              padding: EdgeInsets.only(top: 10, bottom: 30),
              child: Text(english ? Constants.ARRIVE : Constants.ERKEZES),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                CustomInputhour(
                    controller: arrivehour,
                    textw: texthfw,
                    fsize: fsize,
                    eng: english),
                Padding(
                    padding: EdgeInsets.only(left: 20, right: 20),
                    child: CustomInputmin(
                        controller: arrivemin,
                        textw: textmfw,
                        fsize: fsize,
                        eng: english)),
                CustomInputsec(
                    controller: arrivesec,
                    textw: textsfw,
                    fsize: fsize,
                    eng: english)
              ],
            ),
            Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 500),
                transitionBuilder: (Widget child, Animation<double> animation) {
                  return ScaleTransition(child: child, scale: animation);
                },
                child: Text(
                  '$hour',
                  key: ValueKey<int>(hour),
                  style: Theme.of(context).textTheme.headline4,
                ),
              ),
              Text(' : '),
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 500),
                transitionBuilder: (Widget child, Animation<double> animation) {
                  return ScaleTransition(child: child, scale: animation);
                },
                child: Text(
                  '$min',
                  key: ValueKey<int>(min),
                  style: Theme.of(context).textTheme.headline4,
                ),
              ),
              Text(' :'),
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 500),
                transitionBuilder: (Widget child, Animation<double> animation) {
                  final inAnimation = Tween<Offset>(
                          begin: Offset(0.0, 1.0), end: Offset(0.0, 0.0))
                      .animate(animation);
                  final outAnimation = Tween<Offset>(
                          begin: Offset(0.0, -1.0), end: Offset(0.0, 0.0))
                      .animate(animation);

                  if (child.key == ValueKey(sec)) {
                    return ClipRect(
                      child: SlideTransition(
                        position: isover ? outAnimation : inAnimation,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: child,
                        ),
                      ),
                    );
                  } else {
                    return ClipRect(
                      child: SlideTransition(
                        position: isover ? inAnimation : outAnimation,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: child,
                        ),
                      ),
                    );
                  }
                },
                child: Text(
                  '$sec',
                  key: ValueKey<int>(sec),
                  style: Theme.of(context).textTheme.headline4,
                ),
              ),
            ]),
            textvisible
                ? Visibility(
                    child: Text('$until $overtext $overtimetext'),
                    visible: until != "",
                    replacement: Text(
                        (english ? Constants.MESSAGE : Constants.UZENET) +
                            warningtext),
                  )
                : SizedBox.shrink(),
            SizedBox(
              height: MediaQuery.of(context).size.height -
                  (440 - (kIsWeb ? 80 : 0)),
            ),
            ElevatedButton(onPressed: _launchURL, child: Text('Buy me a 🍺')),
            !kIsWeb ? StartAppBanner(bannerAd!) : Container(),
          ]),
        ]));
  }
}
