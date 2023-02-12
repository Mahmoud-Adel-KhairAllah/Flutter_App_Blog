import 'package:flutter/material.dart';
import 'package:flutter_blog/Module/Blog/addBlog.dart';
import 'package:flutter_blog/Module/Home/HomePage.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'Module/Register/WelcomePage.dart';

void main() {
  
  runApp(const MyApp(),);
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Widget page=const WelcomePage();
  final flutterSecureStorage= const FlutterSecureStorage();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    checkLogin();
  }
  checkLogin()async{
    String? token= await flutterSecureStorage.read(key: 'token');
    if(token!=null){
      setState(() {
        page=const HomePage();
      });
    }else{
      setState(() {
        page=const WelcomePage();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return  MaterialApp(
      debugShowCheckedModeBanner: true,
       theme: ThemeData(
    textTheme: GoogleFonts.openSansTextTheme(
     Theme.of(context).textTheme
    ),
  ),
      home:  page,
    );
  }
}