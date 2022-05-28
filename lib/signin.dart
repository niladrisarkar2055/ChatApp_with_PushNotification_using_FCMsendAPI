import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:listview_in_blocpattern/auth_service.dart';
import 'package:listview_in_blocpattern/database_manager.dart';
import 'package:provider/provider.dart';


//This is SignIn page 
class SignInPage extends StatefulWidget {
  const SignInPage({Key? key}) : super(key: key);

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {

  //These are the controller to fetch the name , email and password 
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController nameController = TextEditingController();


  //Basic UI for Signin page with text fields , textediting controller and signin and signup method   
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: Column(
        children: [
          SizedBox(
            height: 40,
          ),
          Container(
              alignment: Alignment.center,
              padding: const EdgeInsets.all(10),
              child: const Text(
                'Sign in',
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
                child: const Text('Login'),
                onPressed: () {

                  //If thsis button is pressed then the user in signed with the specific email and password by calling the 
                  //signIn method from Databasemanager 
                  context.read<AuthService>().signIn(
                      email: emailController.text.trim(),
                      password: passwordController.text.trim()
                );
                },
              )),
          SizedBox(
            height: 20,
          ),
          Container(
              height: 50,
              padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
              child: ElevatedButton(
                  child: const Text('SignUp'),
                  onPressed: () {

                    //If the user has not created an acount this is for Sign up authetication with the help of SignUp page 
                    context.read<AuthService>().signUp(
                        email: emailController.text.trim(),
                        password: passwordController.text.trim());
                  })),
        ],
      )),
    );
  }
}


