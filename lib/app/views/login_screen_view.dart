import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Login Screen',
      home: LoginScreen(),
    );
  }
}

class LoginScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(

      ),
      body: Center(

        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            Container(
              height: 100,
              width: 300,
              child: Image(image: AssetImage('assets/meplogo1-removebg-preview.png'),),


            ),
            SizedBox(height: 20),
            Text("Welcome to MEP",
                textScaleFactor: 2.5,
            ),
            SizedBox(height: 10),
            Text("Login to your account",
                textScaleFactor: 1.0,
                style: TextStyle(color: Colors.grey),),
            SizedBox(height: 40),
            Container(child: Usernamebox(),width: 350),
            SizedBox(height: 20),
            Container(child: PasswordBar(),width:350),
            SizedBox(height: 40),
            Text("Forgot password?"),
            SizedBox(height: 40),
            ElevatedButton(
              onPressed: () {
                // Implement login logic
              },
              child: Text('Login'),
            ),

            TextButton(
              onPressed: () {
                // Navigate to signup screen
              },
              child: Text("Don't have an account ? Sign Up"),
            ),
          ],
        ),
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
        prefixIcon:Icon(Icons.account_box_outlined),
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
