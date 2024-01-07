import 'package:blocauth/provider/sign_in_provider.dart';
import 'package:blocauth/screens/login_screen.dart';
import 'package:blocauth/utils/next_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenStateState();
}

class _HomeScreenStateState extends State<HomeScreen> {


Future getData() async {
  final sp = context.read<SignInProvider>();
  sp.getDataFromSharedPreferences();
}



@override
  void initState() {
    super.initState();
    getData();
  }


  @override
  Widget build(BuildContext context) {
    // change read to watch!!!
    final sp = context.watch<SignInProvider>();
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CircleAvatar(
              backgroundColor: Colors.white,
              backgroundImage: NetworkImage("${sp.imageUrl}"),
              radius: 50,
            ),
            const SizedBox(height: 20,),
            Text("Welcome ${sp.name}",style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500),),
            const SizedBox(
            height: 20,
          ),
          const SizedBox(
            height: 10,
          ),
          Text(
            "Email : ${sp.email}",
            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
          ),
          const SizedBox(
            height: 10,
          ),
          Text(
            "User ID : ${sp.uid}",
            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
          ),
          const SizedBox(
            height: 10,
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text("PROVIDER : "),
              const SizedBox(width: 5,),
              Text("${sp.provider}".toUpperCase(),
              style: TextStyle(color: Colors.red,fontWeight: FontWeight.bold),)
            ],
          ),
          const SizedBox(
            height: 20,
          ),
          ElevatedButton(
            onPressed: (){
              sp.userSignOut();
              nextScreenReplace(context, const LoginScreen());
            }, 
            child: Text("SIGN-OUT", style: TextStyle(color: Colors.blueAccent),))
          ],
        )
      ),

    );
      
  }
}