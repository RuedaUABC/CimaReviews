import 'package:flutter/material.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  LoginViewState createState() => LoginViewState();
}

class LoginViewState extends State<LoginView> {
  String email = '';
  String password = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          constraints: const BoxConstraints.expand(),
          color: const Color(0xFFFFFFFF),
          child: SingleChildScrollView(
            child: Column(
              children: [
                _headerSection(),
                _emailFieldSection(),
                _passwordFieldSection(),
                _loginButton(),
                _registerLink(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _headerSection() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 102),
      width: double.infinity,
      child: Column(
        children: [
          Container(
            margin: const EdgeInsets.only(bottom: 34),
            width: 119,
            height: 96,
            child: Image.asset("images/CimaReviewsIcon.png", fit: BoxFit.contain)
          ),
          Container(
            margin: const EdgeInsets.only(bottom: 22),
            child: const Text(
              "CimaReviews",
              style: TextStyle(
                color: Color(0xFF166534),
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Container(
            margin: const EdgeInsets.only(bottom: 53),
            child: const Text(
              "Bienvenido",
              style: TextStyle(
                color: Color(0xFF6B7280),
                fontSize: 14,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _emailFieldSection() {
    return Container(
      margin: const EdgeInsets.only(bottom: 16, left: 32, right: 32),
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Correo",
            style: TextStyle(
              color: Color(0xFF374151),
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 8),
          Container(
            alignment: Alignment.center,
            decoration: BoxDecoration(
              border: Border.all(
                color: const Color(0xFF000000),
                width: 1,
              ),
              borderRadius: BorderRadius.circular(12),
              color: const Color(0xFFF9FAFB),
            ),
            width: double.infinity,
            child: TextField(
              style: const TextStyle(
                color: Color(0xFF111827),
                fontSize: 15,
              ),
              onChanged: (value) {
                setState(() {
                  email = value;
                });
              },
              decoration: const InputDecoration(
                hintText: "tu.correo@uabc.edu.mx",
                isDense: true,
                contentPadding: EdgeInsets.all(16),
                border: InputBorder.none,
                focusedBorder: InputBorder.none,
                filled: false,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _passwordFieldSection() {
    return Container(
      margin: const EdgeInsets.only(bottom: 24, left: 32, right: 32),
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Contraseña",
            style: TextStyle(
              color: Color(0xFF374151),
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 8),
          Container(
            alignment: Alignment.center,
            decoration: BoxDecoration(
              border: Border.all(
                color: const Color(0xFF000000),
                width: 1,
              ),
              borderRadius: BorderRadius.circular(12),
              color: const Color(0xFFF9FAFB),
            ),
            width: double.infinity,
            child: TextField(
              style: const TextStyle(
                color: Color(0xFF111827),
                fontSize: 15,
              ),
              onChanged: (value) {
                setState(() {
                  password = value;
                });
              },
              decoration: const InputDecoration(
                hintText: "••••••••",
                isDense: true,
                contentPadding: EdgeInsets.all(16),
                border: InputBorder.none,
                focusedBorder: InputBorder.none,
                filled: false,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _loginButton() {
    return InkWell(
      onTap: () {
        Navigator.pushNamed(context, '/');
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: const Color(0xFF166534),
          boxShadow: [
            BoxShadow(
              color: const Color(0x0D000000),
              blurRadius: 2,
              offset: const Offset(0, 1),
            ),
          ],
        ),
        padding: const EdgeInsets.symmetric(vertical: 16),
        margin: const EdgeInsets.only(bottom: 16, left: 32, right: 32),
        width: double.infinity,
        child: const Text(
          "Log in",
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Color(0xFFFFFFFF),
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _registerLink() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 7, horizontal: 17),
      child: TextButton(
        onPressed: () {
            Navigator.pushNamed(context, '/register');
        },
        child: Text(
          "Registrarse",
          style: TextStyle(
            color: Color(0xFF166534),
            fontSize: 15,
          ),
        ),
      ),
    );
  }
}