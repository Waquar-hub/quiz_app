import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:quiz_task/auth/auth_service.dart';
import 'package:quiz_task/auth/sign_up.dart';
import '../UI/homeScreen/home_screen.dart';
import '../storage/shared_preferences.dart';
class LoginScreen extends StatefulWidget {
  LoginScreen();
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _auth = AuthService();

  bool isLoading = false;
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Quiz App Login'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text(
                'Login',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 200),
              TextField(
                controller: email,
                decoration: const InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 20),
              TextField(
                controller: password,
                decoration: const InputDecoration(
                  labelText: 'Password',
                  border: OutlineInputBorder(),
                ),
                obscureText: true,
              ),
              const SizedBox(height: 40),
              SizedBox(
                width: 200,
                height: 60,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                        vertical: 12.0, horizontal: 24.0), // Text color
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(100.0),
                    ),
                    side: const BorderSide(color: Colors.grey),
                    backgroundColor: Colors.teal,
                  ),
        
                  onPressed: () async{
                    setState(() {
                      isLoading = true;
                    });
                    final user = await _auth.logincreateUserWithPassword(email.text, password.text,context).then((value){
                      setState(() {
                        isLoading = false ;
                      });
                    }).onError((error, stackTrace){
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(error.toString()),
                          duration: Duration(seconds: 2),
                        ),
                      );
                      setState(() {
                        isLoading = false ;
                      });
                    });
                    if(user != null){
                      UserSharedPreferences.setUserAccessToken(user.uid.toString());
                      Navigator.push(context, MaterialPageRoute(builder: (context) => QuestionScreen()));
                    }
                  },
                  child:isLoading?const Center(child: CircularProgressIndicator(),) :const Text('Login',style: TextStyle(color: Colors.white,fontSize: 20),),
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton.icon(
                onPressed: () async{
                  final resp =   await _auth.loginWithGoogle();
                  if(resp != null){
                    Navigator.push(context, MaterialPageRoute(builder: (context) => QuestionScreen()));
                  }
                },
                icon: Image.asset(
                  'assets/google_logo.png', // Add your google logo in assets
                  height: 24,
                  width: 24,
                ),
                label: const Text('Sign in with Google'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                      vertical: 12.0, horizontal: 24.0), // Text color
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  side: const BorderSide(color: Colors.grey),
                ),
              ),
              Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Don't have an account?"),
                    TextButton(
                      onPressed: () {
                        // Navigate to Signup Screen
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => SignupScreen()),
                        );
                      },
                      child: Text('Signup'),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}