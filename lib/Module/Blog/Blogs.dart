import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_blog/Network/NetworkHandler.dart';
import 'package:flutter_blog/model/BlogPost.dart';
import 'package:flutter_blog/model/responseBlog.dart';
import 'package:flutter_blog/model/responseBlogs.dart';
import 'package:flutter_blog/widgets/PreviewCard.dart';

import '../../widgets/BlogCard.dart';

class Blogs extends StatefulWidget {
   Blogs({super.key,this.url,this.isProfile=false});
  String? url;
  bool isProfile;
  @override
  State<Blogs> createState() => _BlogsState();
}

class _BlogsState extends State<Blogs> {
  bool isLoding=false;
  NetWorkHandler _netWorkHandler=NetWorkHandler();
  List<BlogModel>? _listBlog;
  fetchBlog() async {
    var responseBlog=await _netWorkHandler.get(widget.url!);
      _listBlog=responseBlogsModelFromJson(responseBlog).data; 
      log(responseBlogsModelFromJson(responseBlog).data.toString()+"<-----------------blogs");
      setState(() {
        isLoding=true;
      });

  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchBlog();
  }
  @override
  Widget build(BuildContext context) {
    
      return  Container(
       child:  !isLoding?Center(child: CircularProgressIndicator()):ListView.builder(
            physics:  widget.isProfile?NeverScrollableScrollPhysics():AlwaysScrollableScrollPhysics(),
             scrollDirection: Axis.vertical,
            shrinkWrap: true,
            itemBuilder: (context, i) {
           int index=_listBlog!.length-1-i;
           return BlogCard(blogModel: _listBlog![index],);
            }
           
             ,itemCount: _listBlog!.length,),
      );
    
    
  }
}