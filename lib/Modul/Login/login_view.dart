import 'package:bonjour/Modul/Login/login_controller.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  @override
  Widget build(BuildContext context) {
  final loginCtrl = Provider.of<LoginController>(context);
    return Scaffold(
      body: Center(
        child: Container(
          padding: EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Login',style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),),
              SizedBox(height: 30,),
              Container(
                width: 350,
                child: TextFormField(
                  controller: loginCtrl.username,
                  decoration: InputDecoration(
                    errorText: loginCtrl.errname ? "Username can't empty" : null,
                    labelText: 'Username',
                    labelStyle: TextStyle(color: Colors.grey),
                    hintText: 'Username',
                    hintStyle: TextStyle(color: Colors.grey),
                    prefixIcon: Icon(Icons.person, color: Colors.black,),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: const BorderSide(width: 2,color: Colors.black),
                    ),
                    enabledBorder: OutlineInputBorder( // Default border when not focused
                      borderRadius: BorderRadius.circular(30),
                      borderSide: const BorderSide(width: 1, color: Colors.black),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: const BorderSide(width: 2,color: Colors.black),
                    ),
                    errorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: const BorderSide(color: Color.fromARGB(255, 255, 0, 0)),
                    ),
                    focusedErrorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: const BorderSide(color: Color.fromARGB(255, 255, 0, 0)),
                    ),
                  ),
                  style: TextStyle(color: Colors.black),
                ),
              ),
              SizedBox(height: 30,),
              Container(
                width: 350,
                child: TextFormField(
                  controller: loginCtrl.password,
                  obscureText: loginCtrl.obscure,
                  decoration: InputDecoration(
                    errorText: loginCtrl.errpass ? "Incorrect password. Please try again." : null,
                    labelText: 'Password',
                    labelStyle: TextStyle(color: Colors.grey),
                    hintText: 'Password',
                    hintStyle: TextStyle(color: Colors.grey),
                    prefixIcon: Icon(Icons.lock, color: Colors.black,),
                    suffixIcon: IconButton(
                      onPressed: loginCtrl.onOffSecure, 
                      icon: Icon(loginCtrl.obscure ? Icons.visibility : Icons.visibility_off, color: Colors.black,)
                    ),  
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: const BorderSide(width: 2,color: Colors.black),
                    ),
                    enabledBorder: OutlineInputBorder( // Default border when not focused
                      borderRadius: BorderRadius.circular(30),
                      borderSide: const BorderSide(width: 1, color: Colors.black),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: const BorderSide(width: 2,color: Colors.black),
                    ),
                    errorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: const BorderSide(color: Color.fromARGB(255, 255, 0, 0)),
                    ),
                    focusedErrorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: const BorderSide(color: Color.fromARGB(255, 255, 0, 0)),
                    ),
                  ),
                  style: TextStyle(color: Colors.black),
                ),
              ),
              SizedBox(height: 30,),
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  elevation: 2,
                  backgroundColor: Colors.black,
                  foregroundColor: Colors.white
                ),
                onPressed: loginCtrl.login, 
                icon: Icon(Icons.login), 
                label: Text('Login')
              )
            ],
          ),
        ),
      ),
    );
  }
}