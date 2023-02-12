

import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_blog/Network/NetworkHandler.dart';
import 'package:flutter_blog/model/BlogPost.dart';
import 'package:intl/intl.dart';

class BlogCard extends StatelessWidget {
   BlogCard({super.key,required this.blogModel});
  BlogModel blogModel;


 
  @override
  Widget build(BuildContext context) {
 
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 30,
                        backgroundImage: blogModel.userName!.isNotEmpty ?NetWorkHandler().getImage("uploads\\profile\\${blogModel.userName}.jpg").url.isEmpty ?AssetImage("assets/user.png"):NetWorkHandler().getImage("uploads\\profile\\${blogModel.userName}.jpg") as ImageProvider:AssetImage("assets/user.png") ,
                      ),
                      SizedBox(width: 10,),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(blogModel.userName!.isNotEmpty?'${blogModel.userName}':"",style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),
                           Text(blogModel.createdAt!.isNotEmpty?'${blogModel.createdAt!.split(".").first} ':"",style: TextStyle(fontSize: 15),),
                        ],
                      )
                    ],
                  ),
                  Icon(Icons.more_vert,size: 30,)
                ],
              ),
              SizedBox(height: 15,),
            Text(blogModel.title!.isEmpty?"title":blogModel.title!,style: const TextStyle(fontSize: 18,fontWeight: FontWeight.bold),),
            Text(blogModel.body!.isEmpty?"body":blogModel.body!,style: const TextStyle(fontSize: 15,fontWeight: FontWeight.w500),),
            const SizedBox(height: 10,),
           blogModel.coverImage == null? SizedBox(height: 10,):Container(
              height: 200,
              width: double.infinity,
              decoration: BoxDecoration(image: DecorationImage(image:  NetWorkHandler().getImage(blogModel.coverImage!) ,fit:BoxFit.contain)),
            ),
           
          ],),
        ),
      
      ),
    );
  }
}