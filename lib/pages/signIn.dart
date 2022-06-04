import 'package:ChatGo/bloc/sign_in_bloc/signin_bloc.dart';
import 'package:ChatGo/pages/chatHome.dart';
import 'package:ChatGo/pages/register.dart';
import 'package:ChatGo/services/authentication.dart';
import 'package:ChatGo/services/chatDatabase.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/register_bloc/register_bloc_bloc.dart';

class SignIn extends StatefulWidget {
  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  final _formkey = GlobalKey<FormState>();
  RegExp emailRegex = RegExp(
      r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$');
  SigninBloc signinBloc;
  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void initialzeFirebase() async {
    await Firebase.initializeApp();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SigninBloc(
          authFunctions: AuthFunctions(),
          chatDatabase: ChatDatabase(),
          initialState: SigninInitial()),
      child: DecoratedBox(
        position: DecorationPosition.background,
        decoration: BoxDecoration(
          color: Colors.white,
          image: DecorationImage(
            image: AssetImage('images/girl.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          backgroundColor: Colors.transparent,
          body: blocController(),
        ),
      ),
    );
  }

  Widget blocController() {
    return BlocListener(
      cubit: signinBloc,
      listener: (context, state) {
        if (state is SignInErrorState) {
          final snackBar = SnackBar(
            content: Text(state.errorMessage),
          );
          Scaffold.of(context).showSnackBar(snackBar);
        } else if (state is SignInLoadedState) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => ChatHome(),
            ),
          );
        }
      },
      child: BlocBuilder<SigninBloc, SigninState>(builder: (context, state) {
        if (state is SigninInitial) {
          // initialzeFirebase();
          signinBloc = BlocProvider.of<SigninBloc>(context);
          return signInScreen();
        } else if (state is SignInLoadingState) return loading();
        return Container();
      }),
    );
  }

  Widget signInScreen() {
    return Container(
      margin: EdgeInsets.all(20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.05,
          ),
          welcomeBackText(),
          SizedBox(
            height: 60,
          ),
          Form(
            key: _formkey,
            child: Column(
              children: <Widget>[
                inputEmail(),
                SizedBox(
                  height: 10,
                ),
                inputPassword()
              ],
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              signInText(),
              signInButton(),
            ],
          ),
          SizedBox(
            height: 40,
          ),
          dontHaveAccount(context),
        ],
      ),
    );
  }

  Widget inputEmail() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.2),
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: Colors.white, width: 1),
      ),
      child: TextFormField(
        validator: (value) {
          return emailRegex.hasMatch(value) || value.isEmpty
              ? null
              : "Enter a valid email";
        },
        controller: _emailController,
        cursorColor: Colors.white,
        style: TextStyle(
          color: Colors.white,
          fontSize: 25,
          fontFamily: "gilroy",
        ),
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: "Enter email",
          contentPadding: EdgeInsets.all(15),
          hintStyle: TextStyle(
            color: Colors.white,
            fontSize: 25,
            fontFamily: "gilroy",
          ),
        ),
      ),
    );
  }

  Widget inputPassword() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.2),
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: Colors.white, width: 1),
      ),
      child: TextFormField(
        controller: _passwordController,
        obscureText: true,
        cursorColor: Colors.white,
        style: TextStyle(
          color: Colors.white,
          fontSize: 25,
          fontFamily: "gilroy",
        ),
        decoration: InputDecoration(
          hintText: "Enter password",
          border: InputBorder.none,
          contentPadding: EdgeInsets.all(15),
          hintStyle: TextStyle(
            color: Colors.white,
            fontSize: 25,
            fontFamily: "gilroy",
          ),
        ),
      ),
    );
  }

  Widget welcomeBackText() {
    return Container(
      child: Text(
        "Welcome\nBack",
        style: TextStyle(
          color: Colors.white,
          fontSize: 50,
          fontFamily: "gilroy",
        ),
      ),
    );
  }

  Widget signInButton() {
    return GestureDetector(
      onTap: () {
        if (_formkey.currentState.validate()) {
          signinBloc.add(FetchSignInEvent(
              email: _emailController.text.trim(),
              password: _passwordController.text.trim()));
        }
      },
      child: Container(
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(40),
          color: Colors.white.withOpacity(0.15),
        ),
        child: Icon(
          Icons.arrow_forward_ios,
          size: 35,
          color: Colors.white,
        ),
      ),
    );
  }

  Widget signInText() {
    return Container(
      child: Text(
        "Sign in",
        style: TextStyle(
          color: Colors.white,
          fontSize: 40,
          fontFamily: "gilroy",
        ),
      ),
    );
  }

  Widget dontHaveAccount(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => BlocProvider(
                create: (context) => RegisterBloc(
                  authFunctions: AuthFunctions(),
                  chatDatabase: ChatDatabase(),
                  initialState: RegisterInitial(),
                ),
                child: Register(),
              ),
            ));
      },
      child: Text(
        "Sign up ",
        style: TextStyle(
          decoration: TextDecoration.underline,
          color: Colors.white,
          fontSize: 22,
          fontFamily: "gilroy",
        ),
      ),
    );
  }

  alertDialog(BuildContext context, String error) async {
    setState(() {
      _emailController.clear();
      _passwordController.clear();
    });
    return showDialog(
        context: context,
        barrierDismissible: true,
        builder: (context) {
          return AlertDialog(
            title: Text(error),
            titlePadding: EdgeInsets.all(20),
            titleTextStyle: TextStyle(
              fontFamily: "GilroyRegular",
              color: Colors.black,
              fontSize: 22,
            ),
            contentPadding: EdgeInsets.all(20),
          );
        });
  }

  Widget loading() {
    return Center(child: CircularProgressIndicator());
  }
}
