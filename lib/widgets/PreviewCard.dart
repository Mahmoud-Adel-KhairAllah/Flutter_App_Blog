

import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

class PreviewCard extends StatelessWidget {
   PreviewCard({super.key,this.file,this.title,this.body});
  File? file;
  String? title;
  String? body;
  
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
          Text(title!.isEmpty?"title":title!,style: const TextStyle(fontSize: 18,fontWeight: FontWeight.bold),),
          Text(body!.isEmpty?"body":body!,style: const TextStyle(fontSize: 15,fontWeight: FontWeight.w500),),
          const SizedBox(height: 10,),
         Container(
            height: 200,
            width: double.infinity,
            decoration: BoxDecoration(image: DecorationImage(image:  file != null?FileImage(file!):const AssetImage('assets/image.png')as ImageProvider,fit:BoxFit.contain)),
          ),
        ],),
      
      ),
    );
  }
}