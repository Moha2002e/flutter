

import 'package:flutter/cupertino.dart';
import 'package:projectexamen/screens/LoginScreen.dart';
import 'package:projectexamen/screens/WelcomeScreen.dart';
import 'package:projectexamen/screens/RegisterScreen.dart';
import 'package:projectexamen/screens/HomeScreen.dart';
import 'package:projectexamen/screens/ProfileScreen.dart';

Map<String, WidgetBuilder> router = {
  WelcomeScreen.routeName: (BuildContext context) => const WelcomeScreen(),
  LoginScreen.routeName: (BuildContext context) => const LoginScreen(),
  RegisterScreen.routeName: (BuildContext context) => const RegisterScreen(),
  HomeScreen.routeName: (BuildContext context) => const HomeScreen(),
  ProfileScreen.routeName: (BuildContext context) => const ProfileScreen(),
};
