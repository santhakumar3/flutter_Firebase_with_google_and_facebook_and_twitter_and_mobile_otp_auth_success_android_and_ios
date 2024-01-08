import 'dart:async';

import 'package:blocauth/provider/sign_in_provider.dart';
import 'package:blocauth/screens/home_screen.dart';
import 'package:blocauth/screens/login_screen.dart';
import 'package:blocauth/utils/config.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../utils/next_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

// init state
@override
  void initState() {
    final sp = context.read<SignInProvider>();
    super.initState();

    //Create a timer of 2 seconds
    Timer(const Duration(seconds: 2),(){
        sp.isSignedIn == false 
          ? nextScreen(context, const LoginScreen())
          : nextScreen(context, const HomeScreen());
    });
    
  }


  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: SafeArea(
        child: Center(
          child: Image(
            image: AssetImage(Config.app_icon),
            height: 800,
            width: 800,
            fit: BoxFit.cover,),
        )),
    );
  }
}