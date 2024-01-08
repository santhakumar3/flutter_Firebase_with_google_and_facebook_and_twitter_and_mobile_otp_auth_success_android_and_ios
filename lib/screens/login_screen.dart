import 'package:blocauth/provider/internet_provider.dart';
import 'package:blocauth/provider/sign_in_provider.dart';
import 'package:blocauth/screens/home_screen.dart';
import 'package:blocauth/utils/config.dart';
import 'package:blocauth/utils/next_screen.dart';
import 'package:blocauth/utils/snack_bar.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final GlobalKey _scaffoldKey = GlobalKey<ScaffoldState>();
  final RoundedLoadingButtonController googleController = RoundedLoadingButtonController();
  final RoundedLoadingButtonController facebookController = RoundedLoadingButtonController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.only(left: 40,right: 40,top: 90,bottom: 30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Flexible(
              flex: 2,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Image(
                    image: AssetImage(
                      Config.app_icon
                    ),
                    height: 100,
                    width: 100,
                    fit: BoxFit.cover,
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    const Text(
                      "Welcome to FlutterFirebaseAuth",
                      style: TextStyle(fontSize: 20,
                      fontWeight: FontWeight.w500),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Text(
                      "Learn Authentication with Provider", style: TextStyle(
                        fontSize: 15, color: Colors.grey[600]
                      ),
                    )
                ],
              )
              ),

              //roundedbutton
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  RoundedLoadingButton(
                    controller: googleController, 
                    successColor: Colors.red,
                    width: MediaQuery.of(context).size.width * 0.80,
                    elevation: 0,
                    borderRadius: 25,
                    onPressed: (){
                        handleGoogleSignIn();
                    }, 
                    child: Wrap(
                      children: [
                        Icon(
                          // adding font awesome icons
                          FontAwesomeIcons.google,
                          size: 20,
                          color: Colors.white,
                        ),
                        SizedBox(
                          width: 15,
                        ),
                        Text(
                          "Sign in with Google",style: TextStyle(fontSize: 15,fontWeight: FontWeight.w500,color: Colors.white),
                        )
                      ],
                    ),
                    color: Colors.red,
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    // facebook login button
                    RoundedLoadingButton(
                  controller: facebookController,
                  successColor: Colors.blue,
                  width: MediaQuery.of(context).size.width * 0.80,
                  elevation: 0,
                  borderRadius: 25,
                  onPressed: () {
                    handleFacebookAuth();
                  },
                  child: Wrap(
                    children: [
                      Icon(
                        // adding font awesome icons
                        FontAwesomeIcons.facebook,
                        size: 20,
                        color: Colors.white,
                      ),
                      SizedBox(
                        width: 15,
                      ),
                      Text(
                        "Sign in with Facebook",
                        style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                            color: Colors.white),
                      )
                    ],
                  ),
                  color: Colors.blue,
                ),

                ],
              )
          ],
        ),
          )
        ),
    );
  }

// handling google signin in

Future handleGoogleSignIn() async {
  final sp = context.read<SignInProvider>();
  final ip = context.read<InternetProvider>();
  await ip.checkInternetConnection();

  if(ip.hasInternet == false){
    openSnackbar(context, "Check your Internet connection", Colors.red);
    googleController.reset();
  } else {
    await sp.signInWithGoogle().then((value) {
      if(sp.hasError == true){
        openSnackbar(context, sp.errorCode.toString(), Colors.red);
        googleController.reset();
      } else {
        // checking whether user exists or not
        sp.checkUserExists().then((value) async{
          if(value == true){
            // user exists
            await sp.getUserDataFromFireStore(sp.uid).then((value) => 
            sp.saveDataToSharedPreferences()
            .then((value) => sp.setSignIn().then((value) {
              googleController.success();
              handleAfterSignIn();
            }))
            );
          }else{
            // user does not exist
            sp.saveDataToFirestore().then((value) => sp.saveDataToSharedPreferences()
            .then((value) => sp.setSignIn().then((value) {
              googleController.success();
              handleAfterSignIn();
            })));
          }
        });
      }

    });
  }



}



// handling facebookauth

  Future handleFacebookAuth() async {
    final sp = context.read<SignInProvider>();
    final ip = context.read<InternetProvider>();
    await ip.checkInternetConnection();

    if (ip.hasInternet == false) {
      openSnackbar(context, "Check your Internet connection", Colors.red);
      facebookController.reset();
    } else {
      await sp.signInWithFacebook().then((value) {
        if (sp.hasError == true) {
          openSnackbar(context, sp.errorCode.toString(), Colors.red);
          facebookController.reset();
        } else {
          // checking whether user exists or not
          sp.checkUserExists().then((value) async {
            if (value == true) {
              // user exists
              await sp.getUserDataFromFireStore(sp.uid).then((value) => sp
                  .saveDataToSharedPreferences()
                  .then((value) => sp.setSignIn().then((value) {
                        facebookController.success();
                        handleAfterSignIn();
                      })));
            } else {
              // user does not exist
              sp.saveDataToFirestore().then((value) => sp
                  .saveDataToSharedPreferences()
                  .then((value) => sp.setSignIn().then((value) {
                        facebookController.success();
                        handleAfterSignIn();
                      })));
            }
          });
        }
      });
    }
  }

// handle after signin
handleAfterSignIn() async {
  Future.delayed(const Duration(
    milliseconds: 1000
  )).then((value) {
    nextScreenReplace(context, const HomeScreen());
  });
}


}