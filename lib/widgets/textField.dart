import 'dart:io';

import 'package:flutter/material.dart';

import 'package:image_picker/image_picker.dart';

class FormCustom extends StatefulWidget {
  const FormCustom({
    Key? key,
    required this.controller,
    required this.label,
    this.isAbout = false,
    required this.hintText,
    required this.icon,
    this.isDOB = false,
    this.isTitle = false,
    this.isBody = false,
   
  }) : super(key: key);

  final TextEditingController? controller;
  final String? label;
  final bool? isAbout;
  final String? hintText;
  final Widget? icon;
  final bool? isDOB;
  final bool? isTitle;
  final bool? isBody;


  @override
  State<FormCustom> createState() => _FormCustomState();
}

class _FormCustomState extends State<FormCustom> {
  

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          TextFormField(
            controller: widget.controller,
            validator: (value) {
              if (value!.isEmpty) {
                return "${widget.label} cant be Empty";
              }
            },
            maxLines: widget.isAbout! || widget.isBody! ? 5 : 1,
            maxLength: widget.isAbout!
                ? 50
                :widget.isBody! ?200:widget.isTitle!
                    ? 100
                    : 20,
            decoration: InputDecoration(
                border: const OutlineInputBorder(
                    borderSide: BorderSide(
                  color: Colors.grey,
                )),
                focusedBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.teal, width: 2)),
                hintText: widget.hintText,
                // label: Text(label!),
                labelText: widget.label,
                labelStyle: const TextStyle(color: Colors.black),
                prefixIcon:  widget.icon,
                helperText: widget.isAbout!
                    ? "Write about yourself"
                    : widget.isDOB!
                        ? "Provide DOB on dd/mm/yyyy"
                        : "${widget.label} cant be empty"),
            readOnly: widget.isDOB! ? true : false,
          ),
          const SizedBox(
            height: 20,
          )
        ],
      ),
    );
  }

 
}
