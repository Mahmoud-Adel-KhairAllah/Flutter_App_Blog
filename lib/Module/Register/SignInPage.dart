import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_blog/Network/NetworkHandler.dart';
import 'package:flutter_blog/Module/Home/HomePage.dart';
import 'package:flutter_blog/Module/Register/SignUpPage.dart';
import 'package:flutter_blog/model/checkUserName.dart';
import 'package:flutter_blog/model/login.dart';
import 'package:flutter_blog/model/register.dart';
import 'package:flutter_blog/widgets/toast.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../../model/responseRegister.dart';

class SignIn extends StatefulWidget {
  const SignIn({super.key});

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  bool vis = true;
  final _globaKey = GlobalKey<FormState>();
  final NetWorkHandler _netWorkHandler = NetWorkHandler();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
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
                "Sign In With Email",
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
                    var registerModel = LoginModel(
                        userName: _usernameController.text,
                        password: _passwordController.text);
                    var response = await _netWorkHandler.post(
                        "user/login", loginModelToJson(registerModel));
                    if (response != null) {
                      var responseLogin =
                          responseRegisterModelFromJson(response);

                      ToastCustom.showToast(
                          context: context, content: responseLogin.msg);
                      setState(() {
                        circular = false;
                      });
                      if (responseLogin.result == true) {
                        // ignore: prefer_interpolation_to_compose_strings
                        log(responseLogin.token.toString() +
                            "<=====================token>>>>>>>>>>>>>>>>>>" +
                            responseLogin.result.toString());
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
                  child: circular
                      ? const Center(child: CircularProgressIndicator())
                      : const Center(
                          child: Text(
                          "SignIn",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold),
                        )),
                ),
              ),

              const Divider(
                height: 50,
                thickness: 2,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Forgot Password?",
                    style: stylelogin(color: Colors.blue),
                  ),
                  const SizedBox(
                    width: 20,
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.pushReplacement(context, MaterialPageRoute(
                        builder: (context) {
                          return const SignUp();
                        },
                      ));
                    },
                    child: Text(
                      "Sign Up?",
                      style: stylelogin(color: Colors.blue[900]),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  TextStyle stylelogin({Color? color}) =>
      TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: color);

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
      log(checkUserName.status.toString() + "<===========ss");
      if (checkUserName.status == true) {
        setState(() {
          circular = true;
          validate = true;
        });
      } else {
        setState(() {
          validate = false;
          errorText = "إسم المستخدم غير موجود ";
          ToastCustom.showToast(context: context, content: errorText);
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
