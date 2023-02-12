import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_blog/Network/NetworkHandler.dart';
import 'package:flutter_blog/Module/Home/HomePage.dart';
import 'package:flutter_blog/helper/image_helper.dart';
import 'package:flutter_blog/model/ProfileModel.dart';
import 'package:flutter_blog/widgets/toast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

import '../../widgets/textField.dart';

class CreateProfile extends StatefulWidget {
  CreateProfile({super.key, this.profileModel, this.isUpdate = false});
  ProfileModel? profileModel;
  bool isUpdate;
  @override
  State<CreateProfile> createState() => _CreateProfileState();
}

class _CreateProfileState extends State<CreateProfile> {
  final _networkHandlar = NetWorkHandler();
  File? _image;
  bool circular = false;
  final _globalKey = GlobalKey<FormState>();

  final TextEditingController _userNameEditingController = TextEditingController();
  final TextEditingController _nameEditingController = TextEditingController();
  final TextEditingController _proffisionEditingController =TextEditingController();
  // ignore: non_constant_identifier_names
  final TextEditingController _DOBEditingController = TextEditingController();
  final TextEditingController _titleEditingController = TextEditingController();
  final TextEditingController _aboutEditingController = TextEditingController();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if(widget.isUpdate){
      _userNameEditingController.text=widget.profileModel!.userName!;
      _nameEditingController.text=widget.profileModel!.name!;
      _proffisionEditingController.text=widget.profileModel!.profession!;
      _DOBEditingController.text=widget.profileModel!.dob!;
      _titleEditingController.text=widget.profileModel!.titleLine!;
      _aboutEditingController.text=widget.profileModel!.about!;
  
     
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Form(
            key: _globalKey,
            child: ListView(
              children: [
                
                imageProfile(),
                const SizedBox(
                  height: 20,
                ),
                    
                form(
                    controller: _nameEditingController,
                    label: "Name",
                    hintText: "Mahmoud",
                    icon: const Icon(
                      Icons.person,
                      color: Colors.teal,
                    )),
                form(
                    controller: _proffisionEditingController,
                    label: "Profession",
                    hintText: "Programer",
                    icon: const Icon(
                      Icons.person,
                      color: Colors.teal,
                    )),
                form(
                    controller: _DOBEditingController,
                    isDOB: true,
                    label: "Date OF Birth",
                    hintText: "01/01/2000",
                    icon: const Icon(
                      Icons.calendar_month_rounded,
                      color: Colors.teal,
                    )),
                form(
                    controller: _titleEditingController,
                    label: "Title",
                    hintText: "Flutter Developer",
                    icon: const Icon(
                      Icons.person,
                      color: Colors.teal,
                    )),
                form(
                    controller: _aboutEditingController,
                    isAbout: true,
                    label: "About",
                    hintText: "Writr about yourself"),
                InkWell(
                  onTap: () async {
                    setState(() {
                      circular = true;
                    });
                    ProfileModel profileModel = ProfileModel(
                        name: _nameEditingController.text,
                        profession: _proffisionEditingController.text,
                        titleLine: _titleEditingController.text,
                        dob: _DOBEditingController.text,
                        about: _aboutEditingController.text,
                      
                        );
                    if (widget.isUpdate) {
                      if (_image != null) {
                          var imageResponse = await _networkHandlar.patchImage(
                              'profile/add/image', _image!.path);
                          log("$imageResponse<=================imageResponse");
                          ToastCustom.showToast(
                              context: context,
                              content: "تم تحديث الصورة");
                          // ignore: use_build_context_synchronously
                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                              builder: (context) => HomePage(),
                            ),
                            (route) => false,
                          );

                          setState(() {
                            circular = false;
                          });
                        }
                      var responseProfile = await _networkHandlar.post(
                          "profile/update", profileModelToJson(profileModel));

                      // log(jsonDecode(responseProfile['msg'].toString()));
                      setState(() {
                        circular=false;
                      });
                       // ignore: use_build_context_synchronously
                       Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                              builder: (context) => HomePage(),
                            ),
                            (route) => false,
                          );

                    } else if (_globalKey.currentState!.validate() &&
                        _image != null) {
                      log("validate");

                      var responseProfile = await _networkHandlar.post(
                          "profile/add", profileModelToJson(profileModel));

                      log(jsonDecode(responseProfile)['msg']);
                      if (jsonDecode(responseProfile)['result'] == true) {
                        if (_image != null) {
                          var imageResponse = await _networkHandlar.patchImage(
                              'profile/add/image', _image!.path);
                          log("$imageResponse<=================imageResponse");
                          ToastCustom.showToast(
                              context: context,
                              content: jsonDecode(responseProfile)['msg']);
                          // ignore: use_build_context_synchronously
                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                              builder: (context) => HomePage(),
                            ),
                            (route) => false,
                          );

                          setState(() {
                            circular = false;
                          });
                        } else {
                          ToastCustom.showToast(
                              context: context,
                              content: "الرجاء إختيار الصورة!");

                          setState(() {
                            circular = false;
                          });
                        }
                      } else {
                        setState(() {
                          circular = false;
                        });
                        ToastCustom.showToast(
                            context: context,
                            content: jsonDecode(responseProfile)['msg']);
                      }
                    } else {
                      setState(() {
                        circular = false;
                      });
                      if (_image == null) {
                        ToastCustom.showToast(
                            context: context, content: "الرجاء إختيار الصورة!");
                      }
                    }
                  },
                  child: Center(
                    child: Container(
                      width: 150,
                      height: 50,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: Colors.teal),
                      child: Center(
                          child: circular
                              ? const CircularProgressIndicator()
                              : Text(
                                  widget.isUpdate ? "Update" : "Submit",
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white),
                                )),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

 tackPhoto(ImageSource imageSource) async {
  final picker = ImagePicker();
    final XFile? pickedImage = await picker.pickImage(source: imageSource);
    if (pickedImage != null) {
    
       setState(() {
          _image= File(pickedImage.path);
       });
     
    }
   
  }

  Widget imageProfile() {
    return Center(
      child: Stack(
        children: [
          SizedBox(
            width: 150,
            height: 150,
            child: CircleAvatar(
                backgroundImage: _image != null
                    ? FileImage(
                        _image!,
                      )
                    : widget.isUpdate? _networkHandlar.getImage(widget.profileModel!.img!):AssetImage("assets/user.png") as ImageProvider),
          ),
          Positioned(
            bottom: 10,
            right: 10,
            child: SizedBox(
              width: 20,
              height: 20,
              child: IconButton(
                  onPressed: () {
                    showModalBottomSheet(
                      context: context,
                      builder: (context) {
                        return SizedBox(
                          height: 150,
                          child: Center(
                            child: Column(
                              children: [
                                const SizedBox(
                                  height: 20,
                                ),
                                const Text("Choose Profile Image"),
                                const SizedBox(
                                  height: 20,
                                ),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    ElevatedButton.icon(
                                        onPressed: ()  async {
                                       
                                       await tackPhoto(ImageSource.camera);
                                         
                                        },
                                        icon: const Icon(Icons.camera),
                                        label: const Text('Camera'),
                                        style: const ButtonStyle(
                                            backgroundColor:
                                                MaterialStatePropertyAll<Color>(
                                                    Colors.teal))),
                                    ElevatedButton.icon(
                                        onPressed: ()  async {
                                         
                                            
                                         await tackPhoto(ImageSource.gallery);
                                       
                                        },
                                        icon: const Icon(Icons.image),
                                        label: const Text("Image"),
                                        style: const ButtonStyle(
                                            backgroundColor:
                                                MaterialStatePropertyAll<Color>(
                                                    Colors.teal)))
                                  ],
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  },
                  icon: const Icon(Icons.camera_alt)),
            ),
          )
        ],
      ),
    );
  }

// ignore: non_constant_identifier_names
  DOB() async {
    log("message");
    DateTime? pickedDate = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(
            1900), //DateTime.now() - not to allow to choose before today.
        lastDate: DateTime.now());
    if (pickedDate != null) {
      log("${pickedDate.toLocal()}<========local"); //pickedDate output format => 2021-03-10 00:00:00.000
      String formattedDate = DateFormat('dd-MM-yyyy').format(pickedDate);
      log("$formattedDate<=======date"); //formatted date output using intl package =>  2021-03-16
      //you can implement different kind of Date Format here according to your requirement

      setState(() {
        _DOBEditingController.text =
            formattedDate; //set output date to TextField value.
      });
      log("${_DOBEditingController.text}<====================adsvdfbgnfhmgj,h");
    } else {
      print("Date is not selected");
    }
  }

  Widget form(
      {TextEditingController? controller,
      String? label,
      String? hintText,
      Icon? icon,
      bool isAbout = false,
      bool isDOB = false}) {
    return InkWell(
      onTap: () {
        if (isDOB) {
          DOB();
        }
      },
      child:  FormCustom( controller: controller, label: label, isAbout: isAbout, hintText: hintText, icon: icon, isDOB: isDOB)
    );
  }
}

