import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/rendering.dart';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:http/http.dart';
import 'package:lur_mobile/utils.dart';
import 'package:package_info/package_info.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:webview_cookie_manager/webview_cookie_manager.dart';

import 'package:device_info/device_info.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:encrypt/encrypt.dart' as encrypt;

import 'package:http/http.dart' as http;

import 'package:app_settings/app_settings.dart';

import 'package:system_settings/system_settings.dart';

import 'dart:ui' as ui;

// import 'package:new_version/new_version.dart';

import 'package:upgrader/upgrader.dart';

// import 'package:firebase_crashlytics/firebase_crashlytics.dart';

// import 'package:new_version/new_version.dart';

// import 'package:flutter_local_notifications/flutter_local_notifications.dart';

// Future<dynamic> myBackgroundMessageHandler(Map<String, dynamic> message) async {
//   if (message.containsKey('data')) {
//     // Handle data message
//     final dynamic data = message['data'];
//   }

//   if (message.containsKey('notification')) {
//     // Handle notification message
//     final dynamic notification = message['notification'];
//   }

//   // Or do other work.
// }

import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:firebase_performance/firebase_performance.dart';

void main() {
  RenderErrorBox.backgroundColor = Colors.transparent;
  RenderErrorBox.textStyle = ui.TextStyle(color: Colors.transparent);

  // FirebaseCrashlytics.instance = true;
  // FlutterError.onError = Crashlytics.instance.recordFlutterError;
  WidgetsFlutterBinding.ensureInitialized();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    // Upgrader().clearSavedSettings(); // Remove this for release builds

    // final appcastURL =
    // 'https://raw.githubusercontent.com/larryaasen/upgrader/master/test/testappcast.xml';
    final appcastURL =
        'https://play.google.com/store/apps/details?id=com.lurenet.lurenetApp';
    final cfg = AppcastConfiguration(url: appcastURL, supportedOS: ['android']);
    return MaterialApp(
        title: 'LURENET',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: StartScreen());
    // home: Scaffold(
    //     body: UpgradeAlert(
    //   appcastConfig: cfg,
    //   messages: UpgraderMessages(code: 'ru'),
    //   debugLogging: true,
    //   child: StartScreen(),
    // )));
    // home: UpgradeAlert(
    //   appcastConfig: cfg,
    //   messages: UpgraderMessages(code: 'es'),
    //   child: Center(child: Text('Checking...')),
    // )
    // home: StartScreen(),
    // home: SplashScreen(
    //   seconds: 5,
    //   navigateAfterSeconds: new MyHomePage(),
    //   // title: new Text('Welcome In SplashScreen',
    //   // style: new TextStyle(
    //   //   fontWeight: FontWeight.bold,
    //   //   fontSize: 20.0
    //   // ),),
    //   image: new Image.asset('./assets/images/lur_plitka_splash.png'),
    //   backgroundColor: Colors.black,
    //   // styleTextUnderTheLoader: new TextStyle(),
    //   photoSize: 200.0,
    //   // onClick: ()=>print("Flutter Egypt"),
    //   // loaderColor: Colors.red
    // ),
    // home: StartScreen(title: 'Lurenet mobile'),
    // );
  }
}

class StartScreen extends StatefulWidget {
  @override
  _StartScreenState createState() => _StartScreenState();
}

class _StartScreenState extends State<StartScreen> {
  int showStartScreenTime = 0;

  @override
  void initState() {
    super.initState();
    Timer.run(() {
      try {
        InternetAddress.lookup('google.com').then((result) {
          if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
            print('connected');
            _loadWidget();
          } else {
            showStartScreenTime = 20;
            _showInternetConnectionDialog(); // show dialog
          }
        }).catchError((error) {
          showStartScreenTime = 20;
          _showInternetConnectionDialog(); // show dialog
        });
      } on SocketException catch (_) {
        showStartScreenTime = 20;
        _showInternetConnectionDialog();
        print('not connected'); // show dialog
      }
    });
  }

  void _showInternetConnectionDialog() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            content: Text('Необходимо подключение к интернету!',
                textAlign: TextAlign.start, style: TextStyle(fontSize: 17)),
            actions: [
              FlatButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    SystemNavigator.pop();
                    exit(0);
                  },
                  child: Text('OK',
                      style: TextStyle(fontSize: 17),
                      textAlign: TextAlign.center))
            ],
          );
        });
  }

  @override
  void dispose() {
    // _connectivitySubscription.cancel();
    super.dispose();
  }

  _loadWidget() async {
    var _duration = Duration(seconds: 3);
    return Timer(_duration, _navigationPage);
  }

  void _navigationPage() {
    Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (BuildContext context) => MyHomePage(title: 'Lurenet')));
  }

  @override
  Widget build(BuildContext context) {
    // Upgrader().clearSavedSettings(); // Remove this for release builds
    // final appcastURL = 'https://raw.githubusercontent.com/larryaasen/upgrader/master/test/testappcast.xml';
    // final cfg = AppcastConfiguration(url: appcastURL, supportedOS: ['android']);
    return Scaffold(
        backgroundColor: Colors.black,
        body: Center(
            child:
                Image.asset('./assets/images/lur_plitka_splash_cutted.png')));
  }

  void _showNotificationDialog() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    sp.setInt("notificationAlertDialog", 1);

    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
              title: Text('Включение уведомлений'),
              content: Text(
                  ' Для работы приложения рекомендуем включить опции: "Всплывающие уведомления", "Уведомления на экране блокировки", "Звуки".'),
              actions: [
                FlatButton(
                  onPressed: () {
                    AppSettings.openNotificationSettings();
                    Navigator.pop(context);
                  },
                  child: Text('Ok'),
                ),
              ],
              elevation: 24.0);
        });
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String _connectionStatus = "Unknow";
  final Connectivity _connectivity = Connectivity();
  StreamSubscription<ConnectivityResult> _connectivitySubscription;

  String _fcmToken;
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  String _message = '';
  String _auth_token;

  InAppWebViewController _webViewController;
  String url = "";
  double progress = 0;

  static final DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();
  Map<String, dynamic> _deviceData = <String, dynamic>{};

  // check app update'
  // AppUpdateInfo _updateInfo;
  GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey();

  bool _flexibleUpdateAvailable = false;

  PackageInfo _packageInfo = PackageInfo(
      appName: 'Unknown',
      packageName: 'Unknown',
      version: 'Unknown',
      buildNumber: 'Unknown');

  final String cookieValue = '';
  var text;

  // static const PLAY_STORE_URL =
  //     'https://play.google.com/store/apps/details?id=com.lurenet.lurenetApp';

  FirebasePerformance _performance = FirebasePerformance.instance;
  bool _isPerformanceCollectionEnabled = false;
  String _performanceCollectionMessage =
      'Unknow status of performance collection.';
  bool _traceHasRan = false;
  bool _httpMetricHasRan = false;

  @override
  void initState() {
    super.initState();
    _initPackageInfo();

    // initConnectivity();
    _register();
    _addTokenToSF();

    initPlatformState();

    getMessage();

    _testHttpMetric();
    // _testTrace();

    // versionCheck(context);
  }

  // Future<void> _testTrace() async {
  //   setState(() {
  //     _traceHasRan = false;
  //   });

  //   final Trace trace = _performance.newTrace("test");
  //   trace.incrementMetric("metric1", 16);
  //   trace.putAttribute("favorite_color", "blue");

  //   await trace.start();

  //   int sum = 0;
  //   for (int i = 0; i < 10000000; i++) {
  //     sum += i;
  //   }
  //   print(sum);

  //   await trace.stop();

  //   setState(() {
  //     _traceHasRan = true;
  //   });
  // }

  Future<void> _testHttpMetric() async {
    setState(() {
      _httpMetricHasRan = false;
    });

    final _MetricHttpClient metricHttpClient = _MetricHttpClient(Client());

    final Request request = Request(
      "SEND",
      Uri.parse("https://www.google.com"),
    );

    metricHttpClient.send(request);

    setState(() {
      _httpMetricHasRan = true;
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  // versionCheck(context) async {
  //   print('run versionCheck');
  //   print('double ${_packageInfo.version}');
  //   double currentVersion =
  //       double.parse(_packageInfo.version.trim().replaceAll(".", ""));
  //   print(
  //       "double ${double.parse(_packageInfo.version.trim().replaceAll(".", ""))}");
  //   print("remoteConfig ${RemoteConfig.instance}");
  // final RemoteConfig remoteConfig = await RemoteConfig.instance;
  // print("remoteConfig $remoteConfig");

  // try {
  //   print('try remote config');
  //   final RemoteConfig remoteConfig = await RemoteConfig.instance;
  //   await remoteConfig.fetch(expiration: const Duration(seconds: 0));
  //   await remoteConfig.activateFetched();
  //   remoteConfig.getString("update_current_version");
  //   print('remote conf ${remoteConfig.getString("update_current_version")}');
  //   double newVersion = double.parse(remoteConfig
  //       .getString('update_current_version')
  //       .trim()
  //       .replaceAll('.', ""));

  //   if (newVersion > currentVersion) {
  //     _showUpdateAppDialog(context);
  //   }
  // } on FetchThrottledException catch (exception) {
  //   print(exception);
  // } catch (exception) {
  //   print(
  //       'Unable to fetch remote config. Cached or default value will be user');
  // }
  // }

  // _showUpdateAppDialog(context) async {
  //   await showDialog<String>(
  //       context: context,
  //       barrierDismissible: false,
  //       builder: (BuildContext context) {
  //         String title = "Доступно новое обновление";
  //         String content =
  //             'Рекомендуем обновить версию приложения до более новой!';
  //         String btnUpdate = 'Обновить';
  //         String btnLater = 'Позже';
  //         return Platform.isIOS
  //             ? new CupertinoAlertDialog(
  //                 title: Text(title),
  //                 content: Text(content),
  //                 actions: <Widget>[
  //                   FlatButton(
  //                       onPressed: () => _launchURL(PLAY_STORE_URL),
  //                       child: Text(btnUpdate)),
  //                   FlatButton(
  //                       onPressed: () => Navigator.pop(context),
  //                       child: Text(btnUpdate))
  //                 ],
  //               )
  //             : new AlertDialog(
  //                 title: Text(title),
  //                 content: Text(content),
  //                 actions: <Widget>[
  //                   FlatButton(
  //                       onPressed: () => launch(PLAY_STORE_URL),
  //                       child: Text(btnUpdate)),
  //                   FlatButton(
  //                       onPressed: () => Navigator.pop(context),
  //                       child: Text(btnUpdate))
  //                 ],
  //               );
  //       });
  // }

  // _launchURL(String url) async {
  //   if (await canLaunch(url)) {
  //     await launch(url);
  //   } else {
  //     throw ('Cannot lauch url for update $url');
  //   }
  // }
// showDialog(
//         context: context,
//         barrierDismissible: false,
//         builder: (BuildContext context) {
//           return AlertDialog(
//               title: Text('Включение уведомлений'),
//               content: Text(
//                   ' Для работы приложения рекомендуется включить опции: "Всплывающие уведомления", "Уведомления на экране блокировки", "Звуки".'),
//               actions: [
  // void checkAlailableUpdate() async {
  //   final availability = await getUpdateAvailability();
  //   text = availability.fold(
  //     available: () => 'There\'s an update available!',
  //     notAvailable: () => 'There\'s no update available!',
  //     unknown: () => 'Sorry, couldn\'t determine if there is or not '
  //         'an available update!',
  //   );
  // }

  // void gotCookies() async {
  //   final cookieManager = CookieManager();
  //   final gotCookies = await cookieManager.getCookies(
  //       url: Uri.parse('http://git-my.lurenet.ua/sign-in'));
  //   for (var item in gotCookies) {
  //     print('item $item');
  //     gotCookies.removeAt(0);
  //     print("item1 $item");
  //   }
  // }

  void _addTokenToSF() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String strValue = await prefs.getString('device_id');
    print('_addTokenToSF strValue encrypted $strValue');
    if (strValue == null) {
      print('strValue $strValue');
      var localAuthToken = Utils.generateRandomAuthToken();
      prefs.setString('device_id', localAuthToken);
      setState(() => _auth_token = localAuthToken);
    } else {
      setState(() => _auth_token = strValue);
    }
  }

  Future<void> _initPackageInfo() async {
    final PackageInfo info = await PackageInfo.fromPlatform();
    print('app verion ' + info.version);
    setState(() {
      _packageInfo = info;
    });
    // versionCheck(context);
  }

  // Future<void> checkForUpdate() async {
  //   InAppUpdate.checkForUpdate().then((info) {
  //     setState(() {
  //       _updateInfo = info;
  //     });
  //   }).catchError((e) => _showError(e));
  // }

  void _showError(dynamic exception) {
    _scaffoldKey.currentState
        .showSnackBar(SnackBar(content: Text(exception.toString())));
  }

  Future<void> initPlatformState() async {
    Map<String, dynamic> deviceData;

    try {
      if (Platform.isAndroid) {
        deviceData = _readAndroidBuildData(await deviceInfoPlugin.androidInfo);
        print(deviceData);
      } else if (Platform.isIOS) {
        deviceData = _readIosDeviceInfo(await deviceInfoPlugin.iosInfo);
      }
    } on PlatformException {
      deviceData = <String, dynamic>{
        'Error:': 'Failed to get platform version'
      };
    }

    if (!mounted) return;

    setState(() {
      _deviceData = deviceData;
    });
  }

  Map<String, dynamic> _readAndroidBuildData(AndroidDeviceInfo build) {
    return <String, dynamic>{
      'version.securityPatch': build.version.securityPatch,
      'version.sdkInt': build.version.sdkInt,
      'version.release': build.version.release,
      'version.previewSdkInt': build.version.previewSdkInt,
      'version.incremental': build.version.incremental,
      'version.codename': build.version.codename,
      'version.baseOS': build.version.baseOS,
      'board': build.board,
      'bootloader': build.bootloader,
      'brand': build.brand,
      'device': build.device,
      'display': build.display,
      'fingerprint': build.fingerprint,
      'hardware': build.hardware,
      'host': build.host,
      'id': build.id,
      'manufacturer': build.manufacturer,
      'model': build.model,
      'product': build.product,
      'supported32BitAbis': build.supported32BitAbis,
      'supported64BitAbis': build.supported64BitAbis,
      'supportedAbis': build.supportedAbis,
      'tags': build.tags,
      'type': build.type,
      'isPhysicalDevice': build.isPhysicalDevice,
      'androidId': build.androidId,
      'systemFeatures': build.systemFeatures,
    };
  }

  Map<String, dynamic> _readIosDeviceInfo(IosDeviceInfo data) {
    return <String, dynamic>{
      'name': data.name,
      'systemName': data.systemName,
      'systemVersion': data.systemVersion,
      'model': data.model,
      'localizedModel': data.localizedModel,
      'identifierForVendor': data.identifierForVendor,
      'isPhysicalDevice': data.isPhysicalDevice,
      'utsname.sysname:': data.utsname.sysname,
      'utsname.nodename:': data.utsname.nodename,
      'utsname.release:': data.utsname.release,
      'utsname.version:': data.utsname.version,
      'utsname.machine:': data.utsname.machine,
    };
  }

  Future<void> initConnectivity() async {
    ConnectivityResult result;

    try {
      result = await _connectivity.checkConnectivity();
    } on PlatformException catch (e) {
      print(e.toString());
    }

    if (!mounted) {
      return Future.value(null);
    }
    print('Con status $_connectionStatus');
    print('Con status result $result');

    return _updateConnectionStatus(result);
  }

  Future<void> _updateConnectionStatus(ConnectivityResult result) async {
    switch (result) {
      case ConnectivityResult.wifi:
      case ConnectivityResult.mobile:
      case ConnectivityResult.none:
        setState(() => _connectionStatus = result.toString());
        break;
      default:
        setState(() => _connectionStatus = 'Failed to get connectivity');
        break;
    }
    print('Con status $_connectionStatus');
  }

  _register() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String fcm_token = sharedPreferences.getString('fcm_token');
    await _firebaseMessaging.getToken().then((token) {
      if (fcm_token == null) {
        sharedPreferences.setString('fcm_token', token);
        setState(() => _fcmToken = token);
      } else {
        setState(() => _fcmToken = fcm_token);
      }
      print('register method: $token');
    });
  }

//Get Firebase messanging
  void getMessage() {
    _firebaseMessaging.configure(
        onMessage: (Map<String, dynamic> message) async {
      print('on message $message');
      setState(() => _message = message["notification"]["title"]);
    }, onResume: (Map<String, dynamic> message) async {
      print('on resume $message');
      setState(() => _message = message["notification"]["title"]);
    }, onLaunch: (Map<String, dynamic> message) async {
      print('on launch $message');
      setState(() => _message = message["notification"]["title"]);
    });
  }

  // @override
  // Widget build(BuildContext context) {
  //   return Scaffold(
  //     body: Column(children: <Widget>[
  //       Padding(
  //           padding: EdgeInsets.all(MediaQuery.of(context).padding.top),
  //           child: SelectableText(_fcmToken)),
  //       Expanded(child: _buildInAppWebView())
  //     ]),
  //   );
  // }
  @override
  Widget build(BuildContext context) {
    // Upgrader().clearSavedSettings();
    // final appcastURL =
    //     'https://raw.githubusercontent.com/larryaasen/upgrader/master/test/testappcast12.xml';
    // final cfg = AppcastConfiguration(url: appcastURL, supportedOS: ['android']);
    return Scaffold(
        body: UpgradeAlert(
      // appcastConfig: cfg,
      messages: UpgraderMessages(code: 'ru'),
      debugLogging: true,
      child: Column(children: <Widget>[
        Padding(
            padding: EdgeInsets.all(MediaQuery.of(context).padding.top),
            child: Column(children: <Widget>[
              SelectableText(_fcmToken),
              Text(_packageInfo.version + "+ " + _packageInfo.buildNumber),
              // RichText(
              //     text: TextSpan(children: <TextSpan>[
              //   TextSpan(text: _packageInfo.version),
              // ]))
            ])),
        Expanded(child: _buildInAppWebView())
      ]),
    ));
  }

// AlertDialog для перевод пользователя на экран настройки уведомлений
  void _showNotificationDialogLeadUserToSettings() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    if (sp.getInt('notificationLeadUserToSettingsAlertDialog') == null) {
      sp.setInt("notificationLeadUserToSettingsAlertDialog", 1);
    }

    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
              title: Text('Включение уведомлений'),
              content: Text(
                  ' Для работы приложения рекомендуется включить опции: "Всплывающие уведомления", "Уведомления на экране блокировки", "Звуки".'),
              actions: [
                FlatButton(
                  onPressed: () {
                    AppSettings.openNotificationSettings();
                    Navigator.pop(context);
                  },
                  child: Text('Ok'),
                ),
              ],
              elevation: 24.0);
        });
  }

  Widget _buildInAppWebView() {
    print('fcm_token in app $_fcmToken');
    var newFcmToken = _fcmToken;
    print('newFcmToken $newFcmToken');

    String resultString;
    try {
      resultString = 'user_app=' +
          '{' +
          '"fcm_token":' +
          '"' +
          _fcmToken +
          '", ' +
          '"device_id":' +
          '"' +
          _auth_token +
          '", ' +
          '"os_type":' +
          '"' +
          (Platform.isAndroid ? "Android" : "iOS") +
          '", ' +
          '"os_version":' +
          '"' +
          _deviceData["version.incremental"] +
          '", ' +
          '"sdk_version":' +
          '"' +
          _deviceData["version.sdkInt"].toString() +
          '", ' +
          '"app_version":' +
          '"' +
          _packageInfo.version +
          '", ' +
          '"app_version":' +
          '"' +
          _packageInfo.buildNumber.toString() +
          '", ' +
          '"manufacturer":' +
          '"' +
          _deviceData['manufacturer'].toString() +
          '", ' +
          '"model":' +
          '"' +
          _deviceData['model'].toString() +
          '"}';
    } catch (exception) {
      print(exception);
    }

    return InAppWebView(
        initialUrlRequest: URLRequest(
          url: Uri.parse('http://git-my.lurenet.ua/sign-in'),
          method: 'POST',
          body: Uint8List.fromList(utf8.encode(resultString)),
          headers: {'Content-Type': 'application/x-www-form-urlencoded'},
        ),
        onWebViewCreated: (InAppWebViewController controller) async {
          SharedPreferences sp = await SharedPreferences.getInstance();
          if (sp.getInt('notificationLeadUserToSettingsAlertDialog') == null) {
            _showNotificationDialogLeadUserToSettings();
          }
        });
  }
}

class _MetricHttpClient extends BaseClient {
  _MetricHttpClient(this._inner);

  final Client _inner;

  @override
  Future<StreamedResponse> send(BaseRequest request) async {
    final HttpMetric metric = FirebasePerformance.instance
        .newHttpMetric(request.url.toString(), HttpMethod.Get);

    await metric.start();

    StreamedResponse response;
    try {
      response = await _inner.send(request);
      metric
        ..responsePayloadSize = response.contentLength
        ..responseContentType = response.headers['Content-Type']
        ..requestPayloadSize = request.contentLength
        ..httpResponseCode = response.statusCode;
    } finally {
      await metric.stop();
    }

    return response;
  }
}
