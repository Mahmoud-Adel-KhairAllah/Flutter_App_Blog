import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_blog/Module/Blog/Blogs.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:intl/intl.dart';

import '../Register/WelcomePage.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {


  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      body: SafeArea(
        child: SizedBox(
             height:  double.infinity,
             width: double.infinity,
          child: Blogs(url: "blogPost/getAllBlog",),
        ),
      ),
    );
  }
  
  
}