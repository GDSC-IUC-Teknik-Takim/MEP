import 'package:flutter/material.dart';

void main() {
  runApp(LoginScreen());
}

class LoginScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(

        ),
        body: Padding(
          padding: EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text("Sign Up",textScaleFactor: 2.5,),
              Text("Create your new account",
                textScaleFactor: 1.0,
                style: TextStyle(color: Colors.grey),),
              SizedBox(height: 40.0),
              Fullnamebar(),
              SizedBox(height: 20.0),
              MailBar(),
              SizedBox(height: 20.0),
              PasswordBar(),
              SizedBox(height: 20.0),
              ConfPassword(),
              SizedBox(height: 40.0),
              SignUpButton(),
              SizedBox(height: 20.0),
          TextButton(
            onPressed: () {
              // Navigate to signup screen
            },
            child: Text("Already have an account ? Login",
                style: TextStyle(color:Color.fromRGBO(50, 90, 62, 100))),)

            ],
          ),
        ),
      ),
    );
  }
}

class SignUpButton extends StatelessWidget {
  const SignUpButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {},
      style: ElevatedButton.styleFrom(
          backgroundColor: Color.fromRGBO(50, 90, 62, 100),
          fixedSize:Size(300,10)),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('Sign up',
            textScaleFactor: 1,
            style: TextStyle(color:Colors.white),
          ),
        ],
      ),
    );
  }
}

class ConfPassword extends StatelessWidget {
  const ConfPassword({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(obscureText: true,
      decoration: InputDecoration(
        prefixIcon:Icon(Icons.lock),
        labelText: 'Confirm Password',
        border:OutlineInputBorder(
          borderSide: BorderSide(style: BorderStyle.none),
          borderRadius: BorderRadius.circular(12.0),
        ),
        filled: true,
        fillColor: Colors.grey[250],
      ),);
  }
}

class PasswordBar extends StatelessWidget {
  const PasswordBar({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(obscureText: true,
      decoration: InputDecoration(
        prefixIcon:Icon(Icons.lock),
        labelText: 'Password',
        border:OutlineInputBorder(
          borderSide: BorderSide(style: BorderStyle.none),
          borderRadius: BorderRadius.circular(12.0),
        ),
        filled: true,
        fillColor: Colors.grey[250],
      ),);
  }
}

class MailBar extends StatelessWidget {
  const MailBar({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      decoration: InputDecoration(
        prefixIcon:Icon(Icons.mail_outline),
        labelText: 'Email',
        border:OutlineInputBorder(
          borderSide: BorderSide(style: BorderStyle.none),
          borderRadius: BorderRadius.circular(12.0),
        ),
        filled: true,
        fillColor: Colors.grey[250],
      ),
    );
  }
}

class Fullnamebar extends StatelessWidget {
  const Fullnamebar({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      decoration: InputDecoration(
        prefixIcon:Icon(Icons.account_box_outlined),
        labelText: 'Full name',
        border:OutlineInputBorder(
          borderSide: BorderSide(style: BorderStyle.none),
          borderRadius: BorderRadius.circular(12.0),
        ),
        filled: true,
        fillColor: Colors.grey[250],
      ),
    );
  }
}
