import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:listview_in_blocpattern/BottomNavigation.dart';
import 'package:listview_in_blocpattern/MessageBox.dart';
import 'package:listview_in_blocpattern/auth_service.dart';
import 'package:listview_in_blocpattern/database_manager.dart';
import 'package:listview_in_blocpattern/home_page.dart';
import 'package:listview_in_blocpattern/signin.dart';
import 'package:provider/provider.dart';
import 'package:navigation_history_observer/navigation_history_observer.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import 'blocs/item_blocs.dart';
import 'data/repository/item_repo.dart';
import 'notification_setvice/local_notification.dart';

Future<void> backgroundHandler(RemoteMessage message) async {
  print(message.data.toString());
  print(message.notification!.title);
}

final navigatorKey = GlobalKey<NavigatorState>();

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  FirebaseMessaging.onBackgroundMessage(backgroundHandler);
  LocalNotificationService.initialize();
  listenNotifications();
  HttpOverrides.global = new MyHttpOverrides();
  runApp(const MyApp());
}

void listenNotifications() {
  LocalNotificationService.onNotification.stream.listen(onClickedNotification);
}

void onClickedNotification(String? payload) {
  print('OnClickedNotification and messageData is below ======>>>>>');
  List<String> temp = payload!.split('#');
  dynamic tokenfromtemp;
  if (temp[0] == "[") {
    tokenfromtemp = jsonDecode(temp[0]);
  } else {
    tokenfromtemp = temp[0];
  }

  Navigator.pushNamed(navigatorKey.currentContext!, '/home');
  Navigator.of(navigatorKey.currentContext!).pushReplacement(MaterialPageRoute(
      builder: (context) => BlocProvider(
          create: (context) => ItemBloc(repository: ItemRepositoryImpl()),
          child: MessageBox(
            //this token is users token
            token: [tokenfromtemp],
            chatroomID: temp[1],
            receiver: temp[2],
          ))));
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<AuthService>(
            create: (context) => AuthService(FirebaseAuth.instance)),
        StreamProvider(
          create: (context) => context.read<AuthService>().authStateChanges,
          initialData: null,
        )
      ],
      child: MaterialApp(
        navigatorKey: navigatorKey,
        navigatorObservers: [NavigationHistoryObserver()],
        debugShowCheckedModeBanner: false,
        title: 'Chat App',
        theme: ThemeData(
            primarySwatch: Colors.blue,
            visualDensity: VisualDensity.adaptivePlatformDensity),
        home: const AuthanticationWrapper(),
        routes: {'/home': (context) => AuthanticationWrapper()},
      ),
    );
  }
}

class AuthanticationWrapper extends StatefulWidget {
  const AuthanticationWrapper({Key? key}) : super(key: key);

  @override
  State<AuthanticationWrapper> createState() => _AuthanticationWrapperState();
}

class _AuthanticationWrapperState extends State<AuthanticationWrapper> {
  List<String> userToken = [];

  @override
  void initState() {
    SendToken();
    super.initState();

    // 1. This method call when app in terminated state and you get a notification
    // when you click on notification app open from terminated state and you can get notification data in this method

    FirebaseMessaging.instance.getInitialMessage().then(
      (message) {
        print("FirebaseMessaging.instance.getInitialMessage");
      },
    );

    // 2. This method only call when App in forground it mean app must be opened
    FirebaseMessaging.onMessage.listen(
      (message) {
        print("FirebaseMessaging.onMessage.listen");

        if (message.notification != null) {
          print(message.notification!.title);
          print(message.notification!.body);
          print("message.data11 ${message.data}");
          LocalNotificationService.createanddisplaynotification(message);
        }
      },
    );

    // 3. This method only call when App in background and not terminated(not closed)
    FirebaseMessaging.onMessageOpenedApp.listen(
      (message) {
        print("FirebaseMessaging.onMessageOpenedApp.listen");
        if (message.notification != null) {
          print(message.notification!.title);
          print(message.notification!.body);
          print("message.data22 ${message.data['ChatRoomID']}");
        }
      },
    );
  }

  SendToken() async {
    await FirebaseMessaging.instance.getToken().then((value) {
      setState(() {
        userToken.add(value!);
      });
      print("This is token: " + userToken.toString());
      return userToken;
    });
  }

  @override
  Widget build(BuildContext context) {
    final appuser = context.watch<User?>();

    if (appuser != null) {
      DatabaseManager().createuser(appuser.email!, appuser.uid, userToken);

      return HomePage();
    } else {
      return SignInPage();
    }
  }
}
