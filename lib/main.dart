import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/layout/home_screen.dart';
import 'package:social_app/modules/login/login_screen.dart';
import 'package:social_app/shared/components/components.dart';
import 'package:social_app/shared/components/constants.dart';
import 'package:social_app/shared/cubit/cubit.dart';
import 'package:social_app/shared/cubit/states.dart';
import 'package:social_app/shared/networks/local/cache_helper.dart';
import 'package:social_app/shared/styles/cubit/cubit.dart';
import 'package:social_app/shared/styles/theme.dart';
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  print('on background message ');
  print(message.data.toString());//ال messageدي نوعها remote messaging جاية من ال firebase ثم .data لو بعت داتا يعني
  showToast(
    text:'on background message ',
    state:ToastStates.SUCCESS,
  );
}
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  var token=await FirebaseMessaging.instance.getToken();
  print(token);
  //foreground [FCM] هتجيلك وانت بتستخدمة وفاتحة
  FirebaseMessaging.onMessage.listen((event) {// هيعمل listen علي اي message هتجيلي
    print('on message');
    print(event.data.toString());//ال event دا نوعة remote messaging جاية من ال firebase ثم .data لو بعت داتا يعني
    showToast(
        text:'on message',
        state:ToastStates.SUCCESS,
    );
  });
// when click on notification to open app  يعني اول ما تدوس عليها هيفتحلك الابلكيشن واول ما يفتح  هتقراها لحظيا
  FirebaseMessaging.onMessageOpenedApp.listen((event) {
    print('on message on message opened app');
    print(event.data.toString());//ال event دا نوعة remote messaging جاية من ال firebase ثم .data لو بعت داتا يعني
    showToast(
      text:'on message opened app',
      state:ToastStates.SUCCESS,
    );
  });
//background [FCM] يعني الابلكيشن مقفول تماما وهتظهرلك وهتقراها وهو مقفول
  FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);//دالة من نفس النوع بوتديك RemoteMessage

  await CacheHelper.init();
  Widget?widget;
  bool?isDark=CacheHelper.getData(key: 'isDark');
  uId = CacheHelper.getData(key: 'uId');

  if (uId != null) {
    widget = HomeScreen();
  }
  else {
    widget = LoginScreen();
  }

  runApp(MyApp(
    startwidget: widget,
    isDark: isDark,
  ));
}

class MyApp extends StatelessWidget {
  Widget?startwidget;
  bool?isDark;

  MyApp({
    required this.startwidget,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) =>
          SocialCubit()..getUserdata()..getPosts()..getAllUsers()..getComments(),
        ),
        BlocProvider(
          create: (context) =>
          AppCubit()..ChangeAppMode(fromShared:isDark),
        ),
      ],
      child: BlocConsumer<SocialCubit, SocialStates>(
        listener: (context, state) {},
        builder: (context, state) {
          var cubit=SocialCubit.get(context);
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            theme:lightTheme,
            darkTheme:darkTheme,
            themeMode:AppCubit.get(context).isDark?ThemeMode.light:ThemeMode.dark,
            home:LoginScreen(),
          );
        },
      ),
    );
  }
}

