import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:listview_in_blocpattern/SignUpPage.dart';
import 'package:listview_in_blocpattern/auth_service.dart';
import 'package:listview_in_blocpattern/database_manager.dart';
import 'package:listview_in_blocpattern/home_page.dart';
import 'package:listview_in_blocpattern/signin.dart';
import 'package:provider/provider.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:firebase_in_app_messaging/firebase_in_app_messaging.dart';


const AndroidNotificationChannel channel = AndroidNotificationChannel(
    'high_importance_channel', 'High Importance Notification',
    importance: Importance.high, playSound: true);

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

Future<void> _firebaseMeesagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  print('A bg message just showed up :  ${message.messageId}');
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  FirebaseMessaging.onBackgroundMessage(_firebaseMeesagingBackgroundHandler);

  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);

  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
      alert: true, badge: true, sound: true);
  runApp(const MyApp());
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
        debugShowCheckedModeBanner: false,
        title: 'Chat App',
        theme: ThemeData(
            primarySwatch: Colors.blue,
            visualDensity: VisualDensity.adaptivePlatformDensity),
        home: const AuthanticationWrapper(),
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
  String userToken = '';

  @override
  void initState() {
    SendToken();
    
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      RemoteNotification notification =
          message.notification?.android as RemoteNotification;
      AndroidNotification? android = message.notification?.android;

      print('Got a message whilst in the foreground!');
      print('Message data: ${message.data}');

      if (notification != null && android != null) {
        flutterLocalNotificationsPlugin.show(
            notification.hashCode,
            notification.title,
            notification.body,
            NotificationDetails(
                android: AndroidNotificationDetails(channel.id, channel.name,
                    color: Colors.blue,
                    playSound: true,
                    icon: '@mipmap/ic_launcher')));
        print('Message also contained a notification: ${message.notification}');
      }
    });

    super.initState();
  }

  SendToken() async {
    await FirebaseMessaging.instance.getToken().then((value) {
      
      setState(() {
        userToken = value!;
      });
      print('This is Token: -----> ' + userToken);
      return userToken;
    });
  }

  

  @override
  Widget build(BuildContext context) {
    final appuser = context.watch<User?>();

    if (appuser != null) {

      // if (userToken != '') {

        DatabaseManager().createuser(appuser.email!, appuser.uid, userToken);
      // }

      return const HomePage();
    } else {
      return const SignInPage();
      
    }
  }
}
