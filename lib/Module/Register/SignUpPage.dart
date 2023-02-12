import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_blog/Network/NetworkHandler.dart';
import 'package:flutter_blog/model/checkUserName.dart';
import 'package:flutter_blog/model/register.dart';
import 'package:flutter_blog/widgets/toast.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../../model/login.dart';
import '../../model/responseRegister.dart';
import '../Home/HomePage.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  bool vis = true;
  final _globaKey = GlobalKey<FormState>();
  NetWorkHandler _netWorkHandler = NetWorkHandler();
  TextEditingController _usernameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  late String errorText;
  bool validate = false;
  bool circular = false;
  final flutterSecureStorage = const FlutterSecureStorage();
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: Container(
        width: size.width,
        height: size.height,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
              colors: [Colors.white, Colors.green],
              begin: FractionalOffset(1.0, 1.0),
              end: FractionalOffset(1.0, 1.0),
              stops: [0.0, 1.0],
              tileMode: TileMode.mirror),
        ),
        child: Form(
          key: _globaKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Color(0xff00A86B)
              const Text(
                "Sign Up With Email",
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 2,
                ),
              ),
              const SizedBox(
                height: 20,
              ),

              textFeildCustom(
                  controller: _usernameController,
                  text: "UserName",
                  isUserName: true),
              const SizedBox(
                height: 20,
              ),
              textFeildCustom(
                  controller: _emailController, text: "Email", isEmail: true),
              const SizedBox(
                height: 20,
              ),

              textFeildCustom(
                  controller: _passwordController,
                  text: "Password",
                  helpText: "password length must be >=8",
                  isPassword: true),
              const SizedBox(
                height: 20,
              ),

              InkWell(
                onTap: () async {
                  setState(() {
                    circular = true;
                  });
                  await chechUserName();
                  if (_globaKey.currentState!.validate() && validate) {
                    log('validated');
                    var registerModel = RegisterModel(
                        userName: _usernameController.text,
                        email: _emailController.text,
                        password: _passwordController.text);
                    var registerResponse = await _netWorkHandler.post(
                        "user/register", registerModelToJson(registerModel));
                    if (registerResponse != null) {
                      var responseRegister =
                          responseRegisterModelFromJson(registerResponse);
                          ToastCustom.showToast(
                          context: context, content: responseRegister.msg);
                      var loginModel = LoginModel(
                          userName: _usernameController.text,
                          password: _passwordController.text);
                      var loginResponse = await _netWorkHandler.post(
                          "user/login", loginModelToJson(loginModel));
                      if (loginResponse != null) {
                        var responseLogin =
                            responseRegisterModelFromJson(loginResponse);

                        ToastCustom.showToast(
                            context: context, content: responseLogin.msg);
                      
                        if (responseLogin.result == true) {
                          log("${responseLogin.token}<=====================token>>>>>>>>>>>>>>>>>>${responseLogin.result}");
                          await flutterSecureStorage.write(
                              key: "token", value: responseLogin.token);
                                  await flutterSecureStorage.write(
                              key: "userName", value: _usernameController.text);
                               await flutterSecureStorage.write(
                              key: "password", value: _passwordController.text);
                          // ignore: use_build_context_synchronously
                          Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const HomePage(),
                              ),
                              (route) => false);
                        }
                      }

                      
                      setState(() {
                        circular = false;
                        log(circular.toString()+"<=========================circular");
                      });
                    }else{
                      ToastCustom.showToast(
                          context: context, content:"لا يوجد إتصال بالإنترنت");
                    }
                  } else {
                    log('validated2');
                    setState(() {
                      circular = false;
                    });
                  }
                },
                child: Container(
                        height: 50,
                        width: 150,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          color: const Color(0xff00A86B),
                        ),
                        child:  circular
                    ? const Center(child: CircularProgressIndicator())
                    :const Center(
                            child: Text(
                          "SignUp",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold),
                        )),
                      ),
              )
            ],
          ),
        ),
      ),
    );
  }

  chechUserName() async {
    if (_usernameController.text.length == 0) {
      setState(() {
        validate = false;
      });
    } else {
      var response = await _netWorkHandler
          .get("user/chechUserName/${_usernameController.text}");
      log("user");
      var checkUserName = checkStatusFromJson(response);
      log("${checkUserName.status}<===========ss");
      if (checkUserName.status == true) {
        setState(() {
          validate = false;
          errorText = "إسم المستخدم موجود ";
          ToastCustom.showToast(context: context, content: errorText);
        });
      } else {
        setState(() {
          validate = true;
          circular = true;
        });
      }
    }
  }

  Widget textFeildCustom(
      {String? text,
      String? helpText,
      TextEditingController? controller,
      bool isUserName = false,
      bool isEmail = false,
      bool isPassword = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      child: Column(
        children: [
          Text(text!),
          TextFormField(
            controller: controller,
            validator: (value) {
              if (isUserName || isEmail || isPassword) {
                if (value!.isEmpty) {
                  return "$text cant be Empty";
                }
              }

              if (isEmail && !value!.contains("@gmail.com")) {
                return "Email is Invalid @gmail.com";
              }
              if (isPassword && value!.length < 8) {
                return "password length must have >=8";
              }
              return null;
            },
            obscureText: isPassword ? vis : false,
            decoration: InputDecoration(
                // errorText: isUserName?validate?null:errorText:"",
                suffixIcon: isPassword
                    ? IconButton(
                        icon:
                            Icon(vis ? Icons.visibility_off : Icons.visibility),
                        onPressed: () {
                          setState(() {
                            vis = !vis;
                          });
                        },
                      )
                    : null,
                helperText: helpText,
                helperStyle: const TextStyle(fontSize: 15),
                // ignore: prefer_const_constructors
                focusedBorder: UnderlineInputBorder(
                    borderSide:
                        const BorderSide(color: Colors.black, width: 2))),
          )
        ],
      ),
    );
  }
}
