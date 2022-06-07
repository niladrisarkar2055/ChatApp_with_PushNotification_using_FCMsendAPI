import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/material.dart';
import 'package:listview_in_blocpattern/auth_service.dart';
import 'package:listview_in_blocpattern/database_manager.dart';
import 'package:listview_in_blocpattern/home_page.dart';
import 'package:listview_in_blocpattern/signin.dart';
import 'package:provider/provider.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({Key? key}) : super(key: key);

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  @override
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  String userToken = "";
  SendToken() async {
    await FirebaseMessaging.instance.getToken().then((value) {
      userToken = value!;
      print('This is Token: -----> ' + userToken);
      return userToken;
    });
  }

  @override
  void initState() {
    SendToken();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: Column(
        children: [
          const SizedBox(
            height: 40,
          ),
          Container(
              alignment: Alignment.center,
              padding: const EdgeInsets.all(10),
              child: const Text(
                'Sign Up',
                style: TextStyle(fontSize: 20),
              )),
          Container(
            padding: const EdgeInsets.all(10),
            child: TextField(
              controller: emailController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'User Email',
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
            child: TextField(
              obscureText: true,
              controller: passwordController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Password',
              ),
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Container(
              height: 50,
              padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
              child: ElevatedButton(
                  child: const Text('Sign Up'),
                  onPressed: () {
                  
                    signUp(emailController, passwordController);
                    //   context.read<AuthService>().signUp(
                    //       email: emailController.text.trim(),
                    //       password: passwordController.text.trim());

                    //   //fetching the uid
                    //   final FirebaseAuth auth = FirebaseAuth.instance;
                    //   final User? user = auth.currentUser;
                    //   final myUid = user!.uid;
                    //   //Creating the user
                    //   DatabaseManager()
                    //       .createuser(emailController.text, myUid, userToken);
                    //   Navigator.push(context,
                    //       MaterialPageRoute(builder: (context) => HomePage()));
                  }
                  // },
                  )),
          SizedBox(
            height: 20,
          ),
          Container(
              height: 50,
              padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
              child: ElevatedButton(
                child: const Text('Sign In'),
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => SignInPage()));
                },
              )),
          SizedBox(
            height: 20,
          )
        ],
      )),
    );
  }

signUp(emailController, passwordController) async{
   await context.read<AuthService>().signUp(
        email: emailController.text.trim(),
        password: passwordController.text.trim());

    //fetching the uid
    // final FirebaseAuth auth = FirebaseAuth.instance;
    // final User? user = auth.currentUser;
    // final myUid = user!.uid;
    // //Creating the user
    // DatabaseManager().createuser(emailController, myUid, userToken);
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => HomePage()));
  }
}
