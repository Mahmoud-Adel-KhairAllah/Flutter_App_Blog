
import 'package:flutter/material.dart';
import 'package:flutter_blog/Module/Register/SignInPage.dart';
import 'package:flutter_blog/Module/Register/SignUpPage.dart';



class WelcomePage extends StatefulWidget {
  const WelcomePage({super.key});

  @override
  State<WelcomePage> createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> animation;
  late AnimationController _controller1;
  late Animation<Offset> animation1;
  bool isLogin = false;


 
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _controller = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 1500));
    animation = Tween<Offset>(begin: const Offset(0.0, 8.0), end: const Offset(0.0, 0.0))
        .animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

    //loginContainerAnimation
    _controller1 = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 2000));
    animation1 = Tween<Offset>(begin: const Offset(0.0, 10.0), end: const Offset(0.0, 0.0))
        .animate(
            CurvedAnimation(parent: _controller1, curve: Curves.elasticInOut));
    _controller.forward();
    _controller1.forward();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _controller.dispose();
    _controller1.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: Container(
        height: size.height,
        width: size.width,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
              colors: [Colors.white, Colors.green],
              begin: FractionalOffset(0.0, 1.0),
              end: FractionalOffset(0.0, 1.0),
              stops: [0.0, 1.0],
              tileMode: TileMode.repeated),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 50),
          child: Column(
            children: [
              SlideTransition(
                position: animation,
                child: Text(
                  'ALGEDPS',
                  style: styleWelcome(),
                ),
              ),
              SizedBox(
                height: size.height / 5,
              ),
              SlideTransition(
                position: animation,
                child: Text(
                  'Great Stories for graet people',
                  textAlign: TextAlign.center,
                  style: styleWelcome(),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              loginContainer(
                  "assets/google.png", "Sign up with Google", size, null),
              const SizedBox(
                height: 20,
              ),
              loginContainer(
                  "assets/facebook.png", "Sign up with Facebook", size, null),
              const SizedBox(
                height: 20,
              ),
              loginContainer(
                  "assets/gmail.png", "Sign up with Email", size, clickEmail),
              const SizedBox(
                height: 20,
              ),
              SlideTransition(
                position: animation1,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  // ignore: prefer_const_literals_to_create_immutables
                  children: [
                    const Text(
                      "Already have an account?",
                      style: TextStyle(color: Colors.grey, fontSize: 17),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    InkWell(
                      onTap: () {
                         Navigator.push(context, MaterialPageRoute(
      builder: (context) {
        return const SignIn();
      },
    ));
                      },
                      child: const Text(
                        "SignIn",
                        style: TextStyle(color: Colors.green, fontSize: 17),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
  
  

  clickEmail() {
    Navigator.push(context, MaterialPageRoute(
      builder: (context) {
        return const SignUp();
      },
    ));
  }

  TextStyle styleWelcome() =>
      const TextStyle(fontWeight: FontWeight.w600, fontSize: 38, letterSpacing: 2);
  Widget loginContainer(
      String path, String text, Size size, Function()? onClick) {
    return SlideTransition(
      position: animation1,
      child: InkWell(
        onTap: onClick,
        child: Container(
          height: 60,
          width: size.width - 130,
          child: Card(
            // color: Colors.white,
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Image.asset(
                      path,
                      height: 40,
                      width: 40,
                    ),
                    const SizedBox(
                      width: 20,
                    ),
                    Text(
                      text,
                      style: const TextStyle(fontSize: 16, color: Colors.black87),
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
