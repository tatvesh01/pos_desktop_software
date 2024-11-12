import 'package:flutter/material.dart';
import 'package:simple_toast_message/simple_toast.dart';


class Helper{

  static showToast(BuildContext context,String msg){
    SimpleToast.showErrorToast(context, "Alert", msg,);
  }
  static Widget labelText(String txt,[Color colors = Colors.white]){
    return Expanded(child: Text(txt,style: TextStyle(fontSize: 17,fontWeight: FontWeight.w500,color: colors),));
  }
  static Widget ValueText(String txt,[Color colors = Colors.black]){
    return Expanded(child: Text(txt,style: TextStyle(fontSize: 15,fontWeight: FontWeight.w500,color: colors),));
  }
}