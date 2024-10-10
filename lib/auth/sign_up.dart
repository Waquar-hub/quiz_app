import 'package:flutter/material.dart';
import 'package:quiz_task/auth/auth_service.dart';

import '../UI/homeScreen/home_screen.dart';
import '../storage/shared_preferences.dart';
import 'login_screen.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {

  final _auth = AuthService();

  bool dataFetched  = true;

  TextEditingController name = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Signup To Start Quiz'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text(
                'Signup',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 100),
              TextField(
                controller: name,
                decoration: const InputDecoration(
                  labelText: 'Name',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20),
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
                width: double.infinity,
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
                      dataFetched = false;
                    });
                    final user =    await   _auth.createUserWithPassword(email.text, password.text);
                    setState(() {
                      dataFetched = true;
                    });
                    if(user != null){
                      UserSharedPreferences.setUserAccessToken(user.uid.toString());
                      Navigator.push(context, MaterialPageRoute(builder: (context) => QuestionScreen()));

                    }
                  },
                  child:dataFetched? const Text('Signup',style: TextStyle(
                    color: Colors.white,
                    fontSize: 20
                  ),):const Center(child: CircularProgressIndicator(),),
                ),
              ),
              const SizedBox(height: 50),
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
              const SizedBox(height: 20),

              Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Already have an account?"),
                    TextButton(
                      onPressed: () {
                        // Navigate to Login Screen
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => LoginScreen()),
                        );
                      },
                      child: const Text('Login'),
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
