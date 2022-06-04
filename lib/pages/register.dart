import 'package:ChatGo/bloc/register_bloc/register_bloc_bloc.dart';
import 'package:ChatGo/pages/home.dart';
import 'package:ChatGo/pages/signIn.dart';
import 'package:ChatGo/services/authentication.dart';
import 'package:ChatGo/services/chatDatabase.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/sign_in_bloc/signin_bloc.dart';

class Register extends StatefulWidget {
  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _usernameController = TextEditingController();
  final _formkey = GlobalKey<FormState>();
  RegExp emailRegex = RegExp(
      r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$');
  RegisterBloc registerBloc;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _usernameController.dispose();
    super.dispose();
  }

  initialzeFirebase() async {
    await Firebase.initializeApp();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => RegisterBloc(
          authFunctions: AuthFunctions(),
          chatDatabase: ChatDatabase(),
          initialState: RegisterInitial()),
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
      cubit: registerBloc,
      listener: (context, state) {
        if (state is RegisterErrorState) {
          final snackBar = SnackBar(
            content: Text(state.errorMessage),
          );
          Scaffold.of(context).showSnackBar(snackBar);
        } else if (state is RegisterLoadedState) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => Home(),
            ),
          );
        }
      },
      child: BlocBuilder<RegisterBloc, RegisterState>(
        builder: (context, state) {
          if (state is RegisterInitial) {
            registerBloc = BlocProvider.of<RegisterBloc>(context);
            return registerScreen();
          } else if (state is RegisterLoadingState) return loading();
          return Container();
        },
      ),
    );
  }

  Widget registerScreen() {
    return Container(
      margin: EdgeInsets.all(20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          createAccountText(),
          SizedBox(
            height: 60,
          ),
          Form(
            key: _formkey,
            child: Column(
              children: <Widget>[
                inputUsername(),
                SizedBox(
                  height: 10,
                ),
                inputEmail(),
                SizedBox(
                  height: 10,
                ),
                inputPassword(),
              ],
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              registerText(),
              signInButton(),
            ],
          ),
          SizedBox(
            height: 20,
          ),
          alreadyHaveAccount(),
        ],
      ),
    );
  }

  Widget inputUsername() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.2),
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: Colors.white, width: 1),
      ),
      child: TextFormField(
        validator: (value) {
          return (value.isEmpty || value.length < 4)
              ? "Enter a valid username"
              : null;
        },
        controller: _usernameController,
        cursorColor: Colors.white,
        style: TextStyle(
          color: Colors.white,
          fontSize: 22,
          fontFamily: "gilroy",
        ),
        decoration: InputDecoration(
          border: InputBorder.none,
          contentPadding: EdgeInsets.all(15),
          hintText: "Enter userame",
          hintStyle: TextStyle(
            color: Colors.white,
            fontSize: 22,
            fontFamily: "gilroy",
          ),
        ),
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
          fontSize: 22,
          fontFamily: "gilroy",
        ),
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: "Enter email",
          contentPadding: EdgeInsets.all(15),
          hintStyle: TextStyle(
            color: Colors.white,
            fontSize: 22,
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
          fontSize: 22,
          fontFamily: "gilroy",
        ),
        decoration: InputDecoration(
          hintText: "Enter password",
          border: InputBorder.none,
          contentPadding: EdgeInsets.all(15),
          hintStyle: TextStyle(
            color: Colors.white,
            fontSize: 22,
            fontFamily: "gilroy",
          ),
        ),
      ),
    );
  }

  Widget createAccountText() {
    return Container(
      child: Text(
        "Create\nAccount",
        style: TextStyle(
          color: Colors.white,
          fontSize: 40,
          fontFamily: "gilroy",
        ),
      ),
    );
  }

  Widget signInButton() {
    return GestureDetector(
      onTap: () {
        if (_formkey.currentState.validate()) {
          registerBloc.add(FetchRegisterEvent(
              email: _emailController.text.trim(),
              password: _passwordController.text.trim(),
              username: _usernameController.text.trim()));
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
          size: 30,
          color: Colors.white,
        ),
      ),
    );
  }

  Widget registerText() {
    return Container(
      child: Text(
        "Sign up",
        style: TextStyle(
          color: Colors.white,
          fontSize: 30,
          fontFamily: "gilroy",
        ),
      ),
    );
  }

  Widget alreadyHaveAccount() {
    return Row(
      children: [
        Text(
          "Already have an account?",
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontFamily: "gilroy",
          ),
        ),
        GestureDetector(
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => BlocProvider(
                    create: (context) => SigninBloc(
                      authFunctions: AuthFunctions(),
                      chatDatabase: ChatDatabase(),
                      initialState: SigninInitial(),
                    ),
                    child: SignIn(),
                  ),
                ));
          },
          child: Text(
            "Sign in ",
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              decoration: TextDecoration.underline,
              fontFamily: "gilroy",
            ),
          ),
        ),
      ],
    );
  }

  Widget loading() {
    return Center(
      child: CircularProgressIndicator(),
    );
  }
}
