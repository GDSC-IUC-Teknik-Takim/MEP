import 'package:flutter/material.dart';
import 'package:mep/app/views/auth/register/register_view.dart';
import 'package:mep/app/views/home/navigation_bar/navigation_bar.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title:Text("Sign in to your account")),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              Container(
                height: 100,
                width: 300,
                child: Image(
                  image:
                      AssetImage('assets/images/meplogo1-removebg-preview.png'),
                ),
              ),
              const SizedBox(height: 40),
              const Text(
                "Welcome to MEP",
                textScaleFactor: 2.5,
              ),
              SizedBox(height: 10),
              Text(
                "Sign in to your account",
                textScaleFactor: 1.0,
                style: TextStyle(color: Colors.grey),
              ),
              SizedBox(height: 50),
              Container(child: Usernamebox(), width: 350),
              SizedBox(height: 20),
              Container(child: PasswordBar(), width: 350),
              SizedBox(height: 40),
              Text("Forgot password?"),
              SizedBox(height: 40),
              LoginButton(),
              TextButton(
                  onPressed: () {
                    // Navigate to signup screen
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => RegisterPage()),
                    );
                  },
                  child: Text("Don't have an account ? Sign Up",
                      style: TextStyle(color: Color.fromRGBO(50, 90, 62, 100)))),
            ],
          ),
        ),
      ),
    );
  }
}

class LoginButton extends StatefulWidget {
  const LoginButton({
    super.key,
  });

  @override
  State<LoginButton> createState() => _LoginButtonState();
}

class _LoginButtonState extends State<LoginButton> {
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        // Implement login logic
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => NavigationBarPage()),
        );
      },
      style: ElevatedButton.styleFrom(
          backgroundColor: Color.fromRGBO(50, 90, 62, 100),
          fixedSize: Size(300, 10)),
      child: Text(
        'Sign in',
        textScaleFactor: 1,
        style: TextStyle(color: Colors.white),
      ),
    );
  }
}

class PasswordBar extends StatefulWidget {
  const PasswordBar({
    super.key,
  });

  @override
  State<PasswordBar> createState() => _PasswordBarState();
}

class _PasswordBarState extends State<PasswordBar> {
  @override
  Widget build(BuildContext context) {
    return TextField(
        obscureText: true,
        decoration: InputDecoration(
          prefixIcon: Icon(Icons.lock),
          labelText: 'Password',
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.0),
          ),
          filled: true,
          fillColor: Colors.grey[250],
        ));
  }
}

class Usernamebox extends StatefulWidget {
  const Usernamebox({
    super.key,
  });

  @override
  State<Usernamebox> createState() => _UsernameboxState();
}

class _UsernameboxState extends State<Usernamebox> {
  @override
  Widget build(BuildContext context) {
    return TextField(
        decoration: InputDecoration(
      prefixIcon: Icon(Icons.account_box_outlined),
      labelText: 'Full name',
      border: OutlineInputBorder(
        borderSide: BorderSide(style: BorderStyle.none),
        borderRadius: BorderRadius.circular(12.0),
      ),
      filled: true,
      fillColor: Colors.grey[250],
    ));
  }
}
