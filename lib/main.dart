import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:listview_in_blocpattern/MessageBox.dart';
import 'package:listview_in_blocpattern/auth_service.dart';
import 'package:listview_in_blocpattern/chatList.dart';
import 'package:listview_in_blocpattern/database_manager.dart';
import 'package:listview_in_blocpattern/home_page.dart';
import 'package:listview_in_blocpattern/signin.dart';
import 'package:listview_in_blocpattern/user.dart';
import 'package:provider/provider.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

//This is main root file of the project 

const AndroidNotificationChannel channel = AndroidNotificationChannel(
    'high_importance_channel', 'High Importance Notification',
    importance: Importance.high, playSound: true);

//Instance for sending local notification
final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

//This handles notification when the app is in the background 
Future<void> _firebaseMeesagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  print('A bg message just showed up :  ${message.messageId}');
}



Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  FirebaseMessaging.onBackgroundMessage(_firebaseMeesagingBackgroundHandler);
  //for local notification 
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
  // This widget is the root of your application
  //Here we are using Multiproviders for using Authentication services and read the important stuff
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
        routes: {
          '/messagebox': (context) => MessageBox(), //the Message box of the other users from the users list 
        },
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

    //For Foreground Notification handling with using the method  -> ( onMessage.listen )
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
            android: AndroidNotificationDetails( channel.id, channel.name, color: Colors.blue,
            playSound: true,
            icon: '@mipmap/ic_launcher')
          )
        );
        print('Message also contained a notification: ${message.notification}');
      }
    });



    super.initState();
  }

  //Finding out and printing the token of the device which will help in sending notifications later 
  SendToken() async {
    await FirebaseMessaging.instance.getToken().then((value) {
      userToken = value!;
      print('This is Token: -----> ' + userToken); //Printing the token
      return userToken;
    });
  }

  @override
  Widget build(BuildContext context) {
    final appuser = context.watch<User>();  //fetching the current user
    
    if (appuser != null) {
      if (userToken != '') {
        //Pushing the user in our database named UserInfo

        DatabaseManager().createuser(appuser.email!, appuser.uid, userToken);
      }

      return const HomePage();
    } else {
      return const SignInPage();
    }
  }
}
