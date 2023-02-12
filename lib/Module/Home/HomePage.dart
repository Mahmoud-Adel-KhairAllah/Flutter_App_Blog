// ignore_for_file: use_build_context_synchronously

import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_blog/Module/Blog/addBlog.dart';
import 'package:flutter_blog/Module/Register/WelcomePage.dart';
import 'package:flutter_blog/Module/Home/HomeScreen.dart';
import 'package:flutter_blog/Module/Profile/ProfileScreen.dart';
import 'package:flutter_blog/Network/NetworkHandler.dart';
import 'package:flutter_blog/model/ProfileModel.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../../model/responseProfileModel.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final flutterSecureStorage = const FlutterSecureStorage();
  int currentState = 0;
  List<Widget> widgets = [const HomeScreen(), const ProfileScreen()];
  List<String> names = ['Home', 'Profile'];
  
  final NetWorkHandler _handler=NetWorkHandler();

  ProfileModel? profileModel;
  
  bool? circula=false;
  
    getData() async {
    var responseProfile = await _handler.get('profile/getData');

    setState(() {
     profileModel = responseProfileModelFromJson(responseProfile).data!;
         log(circula.toString()+"circula==1?");
      circula = true;
      log(circula.toString()+"circula==2?");
   

    });

    log(profileModel!.dob.toString() + "<===============");
    log(profileModel!.name.toString() + "<===============");
    log(profileModel!.userName.toString() + "<===============");
    log(profileModel!.img.toString() + "<===============");
    log(profileModel!.about.toString() + "<===============");
    log(profileModel!.profession.toString() + "<===============");
    log(profileModel!.titleLine.toString() + "<===============");
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getData();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        child: ListView(
          // ignore: prefer_const_literals_to_create_immutables
          children: [
            DrawerHeader(
             
                child: Column(
              children: [
               
              CircleAvatar(
                radius: 50,
                backgroundImage: profileModel!=null&&circula!? 
                    _handler.getImage(profileModel!.img!)
                          : AssetImage("assets/user.png") as ImageProvider,
              ),
                const SizedBox(
                  height: 10,
                ),
                 Text(profileModel == null&&!circula!?'@userName':"@${profileModel!.userName!} ")
              ],
            )),
            ListTile(
              title: const Text("All Posts"),
              trailing: const Icon(Icons.launch),
              onTap: () {},
            ),
            ListTile(
              title: const Text("My Post"),
              trailing: const Icon(Icons.post_add),
              onTap: () {},
            ),
            ListTile(
              title: const Text("New Post"),
              trailing: const Icon(Icons.add),
              onTap: () {},
            ),
            ListTile(
              title: const Text("Settings"),
              trailing: const Icon(Icons.settings),
              onTap: () {},
            ),
            ListTile(
              title: const Text("Feedback"),
              trailing: const Icon(Icons.feedback),
              onTap: () {},
            ),
            ListTile(
              title: const Text("Logout"),
              trailing: const Icon(Icons.logout),
              onTap: () {
                logout();
              },
            ),
          ],
        ),
      ),
      appBar: AppBar(
          backgroundColor: Colors.teal,
          centerTitle: true,
          title: Text(
            names[currentState],
            style: const TextStyle(fontSize: 20),
          ),
          actions: [
            IconButton(
                onPressed: () {
                  // ignore: prefer_const_constructors
                },
                icon: const Icon(Icons.notifications))
          ]),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => AddBlog(),
          ));
        },
        backgroundColor: Colors.teal,
        child: const Text(
          "+",
          style: TextStyle(fontSize: 35),
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        color: Colors.teal,
        shape: const CircularNotchedRectangle(),
        notchMargin: 10,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40),
          child: SizedBox(
              height: 60,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    onPressed: () {
                      setState(() {
                        currentState = 0;
                      });
                    },
                    color: currentState == 0 ? Colors.white : Colors.white70,
                    icon: const Icon(Icons.home),
                    iconSize: 35,
                  ),
                  IconButton(
                    onPressed: () {
                      setState(() {
                        currentState = 1;
                      });
                    },
                    color: currentState == 1 ? Colors.white : Colors.white70,
                    icon: const Icon(Icons.person),
                    iconSize: 35,
                  )
                ],
              )),
        ),
      ),
      body: widgets[currentState],
    );
  }
  logout() async {
     
    await flutterSecureStorage.delete(key: "token");
     // ignore: use_build_context_synchronously
     Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const WelcomePage(),
                  ),
                  (route) => false);
  }
}
