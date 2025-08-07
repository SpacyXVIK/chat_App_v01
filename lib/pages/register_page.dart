import 'package:chat_app_v01/services/auth/auth_service.dart';
import 'package:chat_app_v01/components/my_button.dart';
import 'package:chat_app_v01/components/my_textfield.dart';
import 'package:flutter/material.dart';

class RegisterPage extends StatelessWidget {

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _PasswordController = TextEditingController();
  final TextEditingController _ConfirmController = TextEditingController();

  // tap to go to login page
  final void Function()? onTap;

   RegisterPage({
    super.key,
    required this.onTap,
    });

  // register method
  void register(BuildContext context){
    // get auth service
    final _auth = AuthService();


    // password match -> create user
    if (_PasswordController.text == _ConfirmController.text) {
      try {
        _auth.signUpWithEmailPassword(
          _emailController.text,
          _PasswordController.text
        );
      } catch(e) {
          showDialog(
          context: context, 
          builder: (context) => AlertDialog(
            title: Text(e.toString()),
          )
        );
      }
    }

    // passwords don't match -> tell user to fix

    else{
      showDialog(
        context: context,
         builder: (context) => AlertDialog(
          title: Text("Password don't match!"),
         )
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // logo
              Icon(
              Icons.message,
              size: 60,
              color: Theme.of(context).colorScheme.primary,
              ),
          
              const SizedBox(height: 50,),
          
              // Welcome back message
              Text("Let's create a account for you",
              style: TextStyle(
                color: Theme.of(context).colorScheme.primary,
                fontSize: 16,
              ),
              ),
          
              const SizedBox(height: 25,),
          
              // email TextField
              MyTextfield(
                hintText: "Email",
                obsecure: false,
                controller: _emailController,
                focusNode: FocusNode(),
              ),
          
              SizedBox(height: 25,),
          
              // PassWord TextField
              MyTextfield(
                hintText: "Password",
                obsecure: true,
                controller: _PasswordController,
                focusNode: FocusNode(),
              ),
          
              SizedBox(height: 25,),
          
              // confirm password
              MyTextfield(
                hintText: "Confirm Password",
                obsecure: true,
                controller: _ConfirmController,
                focusNode: FocusNode(),
              ),
          
              SizedBox(height: 25,),
          
          
              // Login Button
              MyButton(
              text: "Register",
              onTap: () => register(context),
              ),
          
              SizedBox(height: 25,),
          
              // Register now
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Already have an account? "),
                  GestureDetector(
                    onTap: onTap,
                    child: Text(
                    "Login now",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    ),
                  ),
                ],
              ),
          
          
            ],
          ),
        ),
      ),
    );
  }
}