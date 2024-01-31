
// ignore_for_file: use_build_context_synchronously
import 'package:money_logger/constants/colour_values.dart';

import 'package:flutter/material.dart';
import 'package:money_logger/constants/routes.dart';
import 'package:money_logger/services/auth/auth_service.dart';

class VerifyEmailView extends StatefulWidget {
  const VerifyEmailView({super.key});

  @override
  State<VerifyEmailView> createState() => _VerifyEmailViewState();
}


class _VerifyEmailViewState extends State<VerifyEmailView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(backgroundColor:backgroundColour,
      appBar: AppBar(backgroundColor: backgroundColour,
        
      ),
      body: Center(
        child: Column(
            children: [
              const Spacer(flex:2),

              const Text("Verify Email",
              textAlign: TextAlign.center,
              style: TextStyle(fontFamily: 'RobotoRoman',
                  fontSize: 50.0,
                  color: textColour,
              
                ),              
              ),
              const Spacer(flex:2),
              const Text("Email has been sent to your mail for the account to get verified",
              textAlign: TextAlign.center,
              style: TextStyle(fontFamily: 'RobotoRoman',
                  fontSize: 17.0,
                  color: unhighlightedTextColour,
              
                ),              
              ),
              const Spacer(flex:2),
              SizedBox(
                width: 352,
                height: 56,  
                child: TextButton(
            
                     style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(primaryColour),

                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4.0),
                    side: const BorderSide(color:primaryColour)
                    )
                   )           
              ),
                  onPressed: () async {
                  AuthService.firebase().sendEmailVerification();
                  
                }, 
                child: const Text("Resend Verification email",
                  style: TextStyle(
                    color: textColour,
                    fontSize: 20.0,
                    ),  
                        
                ),
                            ),
              ),
              const Spacer(flex:4),

            SizedBox(
                width: 352,
                height: 56,                
              child: TextButton(
            
                     style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(primaryColour),

                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4.0),
                    side: const BorderSide(color:primaryColour)
                    )
                   )           
              ),
                  onPressed: () {
                     Navigator.of(context).pushNamedAndRemoveUntil(
                      loginRoute,
                    (route) => false,
                  );
                }, 
                child: const Text("Re-enter the details to login",
                style: TextStyle(
                    color: textColour,
                    fontSize: 20.0,
                    ),  
                      
                ),
              ),
            ),
            const Spacer(flex:100),

            SizedBox(
                width:246.21 ,
                height:48,              
              child: TextButton(
              
                  onPressed: () async {
                     await AuthService.firebase().logOut();
                      Navigator.of(context).pushNamedAndRemoveUntil(
                      registerRoute,
                      (route) => false,
                     );
                }, 
                child: const Text("Made an error in creating an account? Restart here.",
                style: TextStyle(color: unhighlightedTextColour), 
                    ),
              ),
            ),  
          ],
        ),
      ),
    );
  }
}