import 'package:bookapp/auth/authflow.dart';
import 'package:bookapp/themes/const.dart';
import 'package:bookapp/flows/verification.dart';
import 'package:bookapp/models/users.dart';
import 'package:bookapp/screens/homepage.dart';
import 'package:bookapp/screens/loginscreens.dart';
import 'package:bookapp/screens/signupscreens.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ScreesnController extends StatefulWidget {
  const ScreesnController({super.key});

  @override
  State<ScreesnController> createState() => _ScreesnControllerState();
}

class _ScreesnControllerState extends State<ScreesnController> {
  @override
  Widget build(BuildContext context) {
    final authController = Provider.of<AuthRemote>(context);
    return StreamBuilder<Users?>(
        stream: authController.user,
        builder: (context, AsyncSnapshot<Users?> snapshot) {
          if (snapshot.connectionState == ConnectionState.active) {
            final Users? user = snapshot.data;

              return user == null
                  ? const SignupScreen()
                  : const VerificationEmail();
         
          } else {
            return CircularProgressIndicator.adaptive(
              strokeCap: StrokeCap.square,
              strokeWidth: 4.0,
              backgroundColor: kcombinecolor,
            );
          }
        });
  }
}
