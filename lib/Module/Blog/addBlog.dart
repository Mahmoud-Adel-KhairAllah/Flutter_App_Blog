import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_blog/Module/Home/HomePage.dart';
import 'package:flutter_blog/Network/NetworkHandler.dart';
import 'package:flutter_blog/model/BlogPost.dart';
import 'package:flutter_blog/model/responseBlog.dart';
import 'package:flutter_blog/widgets/PreviewCard.dart';
import 'package:flutter_blog/widgets/textField.dart';
import 'package:image_picker/image_picker.dart';

import '../../widgets/toast.dart';

class AddBlog extends StatefulWidget {
  AddBlog({super.key, this.isUpdate = false, this.blogModel});
  BlogModel? blogModel;
  bool? isUpdate;

  @override
  State<AddBlog> createState() => _AddBlogState();
}

class _AddBlogState extends State<AddBlog> {
  final _globalKey = GlobalKey<FormState>();
  final NetWorkHandler _netWorkHandler = NetWorkHandler();
  final TextEditingController _titleeditingController = TextEditingController();
  final TextEditingController _bodyeditingController = TextEditingController();

  bool? circular=false;
  File? _image;
  final picker = ImagePicker();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(
              Icons.close,
              color: Colors.grey,
            ),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          actions: [
            InkWell(
                onTap: () {
                 showModalBottomSheet(context: context, builder: (builder)=>PreviewCard(file: _image,title: _titleeditingController.text,body: _bodyeditingController.text,));
                },
                child: const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: Center(
                      child: Text(
                    'Preview',
                    style: TextStyle(fontSize: 18, color: Colors.teal),
                  )),
                ))
          ]),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: Form(
            key: _globalKey,
            child: ListView(
              children: [
                imageProfile(),
                SizedBox(
                  height: 20,
                ),
                FormCustom(
                  controller: _titleeditingController,
                  label: "Add Image and Title",
                  icon: const Icon(
                    Icons.image,
                    color: Colors.teal,
                  ),
                  isTitle: true,
                  hintText: '',
                ),
                FormCustom(
                  controller: _bodyeditingController,
                  label: "Provide Body Your Blog",
                  icon: InkWell(
                      onTap: () {
                        log("add image");
                      },
                      child: const Icon(
                        Icons.abc,
                        color: Colors.teal,
                      )),
                  isBody: true,
                  hintText: '',
                ),
                Center(
                    child: InkWell(
                  onTap: () async {
                    setState(() {
                      circular=true;
                    });
                    BlogModel blogModel = BlogModel(
                        title: _titleeditingController.text,
                        body: _bodyeditingController.text,
                        createdAt: DateTime.now().toString());
                    if (_globalKey.currentState!.validate()) {
                      var response = await _netWorkHandler.post(
                          'blogPost/Add', blogModelToJson(blogModel));

                      BlogModel responseblogModel =
                          responseBlogModelFromJson(response).data!;
                      log("${responseBlogModelFromJson(response)
                              .data!
                              .id}<========================post");

                      if (_image != null) {
                        var imageResponse = await _netWorkHandler.patchImage(
                            'blogPost/add/coverImage/${responseblogModel.id}',
                            _image!.path);
                        log("$imageResponse<=================imageResponse");
                        ToastCustom.showToast(
                            context: context, content: "تم رفع الصورة");
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
                        setState(() {
                          circular = false;
                        });
                         ToastCustom.showToast(
                            context: context, content: "تم إضافة المنشور بنجاح");


                    }else{
                        setState(() {
                          circular = false;
                        });
                    }
                  },
                  child: circular!?CircularProgressIndicator():Container(
                    height: 50,
                    width: 150,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Colors.teal),
                    child: const Center(
                        child: Text(
                      'Add Blog',
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    )),
                  ),
                ))
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget imageProfile() {
    return Center(
      child: Stack(
        children: [
          InkWell(
            onTap: () {
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
                                        onPressed: () async {
                                          await tackPhoto(ImageSource.camera);
                                        },
                                        icon: const Icon(Icons.camera),
                                        label: const Text('Camera'),
                                        style: const ButtonStyle(
                                            backgroundColor:
                                                MaterialStatePropertyAll<Color>(
                                                    Colors.teal))),
                                    ElevatedButton.icon(
                                        onPressed: () async {
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
            child: Center(
              child: Container(
                
                width: double.infinity,
                height: 200,
                decoration: BoxDecoration(
               
                  image: DecorationImage(
                     alignment: Alignment.center,
                     
                    fit: BoxFit.contain,image: _image != null
                        ? FileImage(
                            _image!,
                          )
                        : widget.isUpdate!
                            ? _netWorkHandler
                                .getImage(widget.blogModel!.coverImage!)
                            : AssetImage("assets/image.png") as ImageProvider )),
                            
              ),
            ),
          ),
          Positioned(
            bottom: 10,
            right: 10,
            child: SizedBox(
              width: 20,
              height: 20,
              child: IconButton(
                  onPressed: () {
              
                  },
                  icon: const Icon(Icons.camera_alt)),
            ),
          )
        ],
      ),
    );
  }

  tackPhoto(ImageSource imageSource) async {
    final XFile? pickedImage = await picker.pickImage(source: imageSource);
    if (pickedImage != null) {
      setState(() {
        _image = File(pickedImage.path);
      });
    }
  }
}
