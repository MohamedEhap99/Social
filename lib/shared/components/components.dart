import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:social_app/shared/styles/icon_broken.dart';

navigateAndFinish(context,Widget)=>Navigator.pushAndRemoveUntil(
    context, MaterialPageRoute(builder: (context) => Widget),
        (route) {
      return false;
    });

navigateTo(context,Widget)=>Navigator.push(context,
    MaterialPageRoute(builder:(context)=>Widget));

defaultFormField({
  TextStyle ? style,
  required String ? labeltext,
 String ? hinttext,
  TextStyle ? labelstyle,
  required IconData ? prefixicon,
  Color?color,
  IconData ? suffixicon,
  VoidCallback? suffixpressed,
  Color ? fillcolor,
  bool ? filled,
  required TextEditingController ? controller,
  required  TextInputType ? keyboardtype,
  required bool  obscuretext,
  ValueChanged<String> ? onSubmit,
  required FormFieldValidator<String> ? validate,
  required BorderRadius borderradius,
  required BorderSide borderside,

})=>TextFormField(
  style:style,
  decoration:InputDecoration(
    enabledBorder:OutlineInputBorder(
        borderRadius:borderradius ,
        borderSide:borderside
    ),
    labelText:labeltext,
    hintText: hinttext,
    labelStyle:labelstyle,
    prefixIcon:Icon(
      prefixicon,
    color:color ,
    ),
    suffixIcon: suffixicon!=null?IconButton(
        onPressed:suffixpressed, icon:Icon(suffixicon)):null,
    fillColor:fillcolor,
    filled:filled,
  ),

  controller:controller,
  keyboardType:keyboardtype,
  obscureText:obscuretext,
  onFieldSubmitted:onSubmit,
  validator:validate ,
);


defaultMaterialButton({
  required VoidCallback? onpressed,
  String? text,
  TextStyle? style,
  ShapeBorder?shape,
  Color? color,
  double?minwidth,
  double? height,
})=>MaterialButton(
  onPressed:onpressed,
  child:Text(
    text!.toUpperCase(),
    style:style ,
  ),
  shape:shape,
  color:color,
  minWidth:minwidth ,
  height:height,


);
defaultTextButton({
  required VoidCallback onpressed,
  required String text,
  TextStyle?style,

})=>TextButton(
onPressed:onpressed,
child:Text(
    text.toUpperCase(),
  style:style,
),

);

 defaultAppBar({
  required BuildContext context,
  String?title,
  List<Widget>?actions,
})=>AppBar(
  title:Text(
    title!,
  ),
 leading: IconButton(
      onPressed: () {
        Navigator.pop(context);
      },
      icon:Icon(
        IconBroken.Arrow___Left_2,
      ),
    ),
actions:actions,
   titleSpacing:1.0,
);

void showToast({
  required String text,
  required ToastStates state,
}){
  Fluttertoast.showToast(
    msg:text,
    toastLength:Toast.LENGTH_LONG,
    gravity:ToastGravity.BOTTOM,
    timeInSecForIosWeb:5,
    backgroundColor:chooseToastColor(state),
    textColor:Colors.white,
    fontSize:16.0,
  );
}



enum ToastStates{SUCCESS,ERROR,WARNING}

late Color color;

Color chooseToastColor(ToastStates state){
  switch(state){
    case ToastStates.SUCCESS:
      color=Colors.green;
      break;
    case ToastStates.ERROR:
      color=Colors.red;
  break;
    case ToastStates.WARNING:
      color=Colors.amber;
      break;
  }
  return color;
}


