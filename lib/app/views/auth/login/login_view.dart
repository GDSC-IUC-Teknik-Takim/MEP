import 'package:flutter/material.dart';
import 'package:mep/app/views/auth/register/register_view.dart';
import 'package:mep/app/views/auth/register/register_service.dart';





class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _authService = AuthService();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            PreferredSize(
              preferredSize: Size.fromHeight(kToolbarHeight + 24.0), // App bar height + 24px additional space
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
            
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Container(
                      height: 200,
                      width: 300,
                      child: Image(
                        image: AssetImage('assets/images/meplogo2.png'),
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
                    Container(child: Usernamebox(emailController: emailController), width: 350),
                    SizedBox(height: 20),
                    Container(child: PasswordBar(passwordController: passwordController), width: 350),
                    SizedBox(height: 40),
                    Text("Forgot password?"),
                    SizedBox(height: 80),
                    LoginButton(
                      emailController: emailController,
                      passwordController: passwordController,
                      authService: _authService,
                    ),
                    TextButton(
                        onPressed: () {
                          // Navigate to signup screen
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => RegisterPage()), // RegisterScreen kullanıyoruz
                          );
                        },
                        child: Text("Don't have an account ? Sign Up",
                            style: TextStyle(color: Color.fromRGBO(50, 90, 62, 100)))),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class LoginButton extends StatelessWidget {
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final AuthService authService; // AuthService buraya eklendi

  const LoginButton({
    Key? key,
    required this.emailController,
    required this.passwordController,
    required this.authService, // AuthService burada da alındı
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        String email = emailController.text;
        String password = passwordController.text;
        print('Email: $email');
        print('Password: $password');

        authService.signIn(context,email: email,password: password);


        // Implement login logic

      },
      style: ElevatedButton.styleFrom(
        backgroundColor: Color.fromRGBO(50, 90, 62, 100),
        fixedSize: Size(300, 10),
      ),
      child: Text(
        'Sign in',
        textScaleFactor: 1,
        style: TextStyle(color: Colors.white),
      ),
    );
  }
}

class PasswordBar extends StatelessWidget {
  final TextEditingController passwordController;

  const PasswordBar({
    Key? key,
    required this.passwordController,
  }) : super(key: key);

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
        ),
        controller: passwordController);
  }
}

class Usernamebox extends StatelessWidget {
  final TextEditingController emailController;

  const Usernamebox({
    Key? key,
    required this.emailController,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextField(
        decoration: InputDecoration(
          prefixIcon: Icon(Icons.account_box_outlined),
          labelText: 'Email',
          border: OutlineInputBorder(
            borderSide: BorderSide(style: BorderStyle.none),
            borderRadius: BorderRadius.circular(12.0),
          ),
          filled: true,
          fillColor: Colors.grey[250],
        ),
        controller: emailController);
  }
}
