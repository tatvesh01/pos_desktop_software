import 'package:desktop_crud_app/Helper/ColorHelper.dart';
import 'package:desktop_crud_app/UI/HomeScreen.dart';
import 'package:desktop_crud_app/UI/ProductListScreen.dart';
import 'package:flutter/material.dart';

import '../Helper/Helper.dart';
import 'BillingScreen.dart';
import 'CategoryManager.dart';

import 'package:flutter/material.dart';

class LoginScreen extends StatelessWidget {
  final TextEditingController _usernameController = TextEditingController(text: "admin");
  final TextEditingController _passwordController = TextEditingController(text: "123456");

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          width: 400,
          padding: EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [BoxShadow(blurRadius: 10, color: Colors.black26)],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.confirmation_number_sharp,size: 100,color: ColorHelper.darkBlueColor,),
              Text(
                'Login',
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 24),
              TextField(
                controller: _usernameController,
                decoration: InputDecoration(
                  labelText: 'Username',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 16),
              TextField(
                controller: _passwordController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'Password',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: ColorHelper.darkBlueColor,
                    foregroundColor: ColorHelper.whiteColor,
                    padding: EdgeInsets.symmetric(horizontal: 32, vertical: 16), // Button padding
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                    elevation: 5, // Shadow depth
                    textStyle: TextStyle(
                      fontSize: 18, // Text size
                      fontWeight: FontWeight.bold, // Text weight
                    ),
                  ),
                  onPressed: () {
                    if(_passwordController.text.isNotEmpty && _usernameController.text.isNotEmpty){
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => HomeScreen()),
                      );
                    }else{
                      Helper.showToast(context,"Please Fill All Field");
                    }
                  },
                  child: Text('Login'),
                ),
              ),

              SizedBox(height: 10,),
              TextButton(
                onPressed: () {
                  Helper.showToast(context,"Please contact to admin");
                },
                child: Text('Forgot Password'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

