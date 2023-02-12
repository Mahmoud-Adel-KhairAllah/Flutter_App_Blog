import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_blog/Module/Blog/Blogs.dart';
import 'package:flutter_blog/Network/NetworkHandler.dart';
import 'package:flutter_blog/Module/Profile/CreateProfile.dart';
import 'package:flutter_blog/model/responseProfileModel.dart';

import '../../model/ProfileModel.dart';

class MainProfile extends StatefulWidget {
  const MainProfile({super.key});

  @override
  State<MainProfile> createState() => _MainProfileState();
}

class _MainProfileState extends State<MainProfile> {
  NetWorkHandler _handler = NetWorkHandler();
  ProfileModel? profileModel;
  bool circula = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getData();
  }

  getData() async {
    var responseProfile = await _handler.get('profile/getData');

    setState(() {
      profileModel = responseProfileModelFromJson(responseProfile).data!;
      circula = true;
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
  Widget build(BuildContext context) {
    if (!circula) {
      return CircularProgressIndicator();
    } else {
      return Scaffold(
            appBar: AppBar(
                elevation: 0,
                backgroundColor: Colors.white,
                // leading: IconButton(
                //     onPressed: () {},
                    // icon: Icon(
                    //   Icons.arrow_back_ios,
                    //   color: Colors.black,
                    // )),
                actions: [
                  IconButton(
                      onPressed: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context) {
                          return CreateProfile(profileModel: profileModel,isUpdate: true,);
                        },));
                      },
                      icon: Icon(
                        Icons.edit,
                        color: Colors.black,
                      ))
                ]),
            body: SafeArea(
                child: 
             
                              
                                ListView(
                                  shrinkWrap: true,
                                children: [
                                                  headers(),
                                                  profileModel!.name == null
                                                      ? Container()
                                                      : otherDetailes(label: 'Name', value: profileModel!.name!),
                                                  profileModel!.dob == null
                                                      ? Container()
                                                      : otherDetailes(
                                                          label: 'Date of Birth', value: profileModel!.dob!),
                                                  profileModel!.profession == null
                                                      ? Container()
                                                      : otherDetailes(
                                                          label: 'Profession', value: profileModel!.profession!),
                                                  profileModel!.titleLine == null
                                                      ? Container()
                                                      : otherDetailes(
                                                          label: 'TitleLine', value: profileModel!.titleLine!),
                                                  profileModel!.about == null
                                                      ? Container()
                                                      : otherDetailes(
                                                          label: 'About', value: profileModel!.about!),
                                                              
                                                  
                                                          
                                                            SingleChildScrollView(child: Container(
                                                          
                                                              child: Blogs(url: "blogPost/getOwnBlog",isProfile: true,)))
                                                          ],
                                              )),
          );
    }
  }

  Widget headers() {
    return Column(
      children: [
        CircleAvatar(
          radius: 70,
          backgroundImage: _handler.getImage(profileModel!.img!),
        ),
        SizedBox(
          height: 15,
        ),
        Text(
          '@${profileModel!.userName ??""}',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        SizedBox(
          height: 15,
        ),
       Text(
          profileModel!.titleLine??"",
        ),
        SizedBox(
          height: profileModel!.titleLine ==null?0:15,
        ),
        Divider(
          thickness: 3,
        ),
       
      ],
    );
  }

  Widget otherDetailes({required String label, required String value}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '$label:',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          SizedBox(
            height: 5,
          ),
          Text(
            '$value',
            style: TextStyle(fontSize: 15),
          ),
           Divider()
        ],
      ),
    );
  }
}
