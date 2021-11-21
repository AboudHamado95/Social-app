import 'package:bloc/bloc.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:socialapp/cache/cache_helper.dart';
import 'package:socialapp/constants/constants.dart';
import 'package:socialapp/cubit/bloc_observe.dart';
import 'package:socialapp/cubit/social/social_cubit.dart';
import 'package:socialapp/presentation/auth/login_screen.dart';
import 'package:socialapp/presentation/social/layouts/social_layout.dart';
import 'package:socialapp/styles/themes/themes.dart';

main(List<String> args) async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  Bloc.observer = MyBlocObserver();
  await CacheHelper.init();
  Widget? widget;
  uId = CacheHelper.getData(key: 'uId');

  if (uId != null)
    widget = SocialLayout();
  else
    widget = LoginScreen();

  runApp(MyApp(
    startWidget: widget,
  ));
}

class MyApp extends StatelessWidget {
  final Widget? startWidget;
  const MyApp({Key? key, required this.startWidget}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => SocialCubit()
            ..getUserData()
            ..getPosts()
            ..getUsers(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: lightTheme,
        darkTheme: darkTheme,
        home: startWidget,
      ),
    );
  }
}
