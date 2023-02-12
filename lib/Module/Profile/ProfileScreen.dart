import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_blog/Network/NetworkHandler.dart';
import 'package:flutter_blog/Module/Profile/MainProfile.dart';
import 'package:flutter_blog/model/responseRegister.dart';

import '../../model/checkUserName.dart';
import 'CreateProfile.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  NetWorkHandler netWorkHandler = NetWorkHandler();
  Widget page = CircularProgressIndicator();

  checkProfile() async {
    var responseProfile = await netWorkHandler.get("profile/checkProfile");

    CheckStatus checkUserName = checkStatusFromJson(responseProfile);
    log(checkUserName.status.toString() + "<===================status");
    if (checkUserName.status!) {
      setState(() {
        page = showProfile();
      });
    } else {
      setState(() {
        page = button();
      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    checkProfile();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Center(child: page));
  }

  Widget showProfile() {
    return new MainProfile();
  }

  Widget button() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const Text(
          'add to button to add profile data',
          style: TextStyle(fontSize: 20, color: Colors.deepOrange),
        ),
        const SizedBox(
          height: 30,
        ),
        InkWell(
          onTap: () {
            Navigator.push(context, MaterialPageRoute(
              builder: (context) {
                return CreateProfile();
              },
            ));
          },
          child: Container(
            height: 60,
            width: 150,
            decoration: BoxDecoration(
                color: Colors.blueGrey,
                borderRadius: BorderRadius.circular(20)),
            child: const Center(
                child: Text(
              'Add Profile',
              style: TextStyle(fontSize: 18, color: Colors.white),
            )),
          ),
        ),
      ],
    );
  }
}
