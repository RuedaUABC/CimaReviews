import 'package:flutter/material.dart';

class RegisterUserView extends StatefulWidget {
  const RegisterUserView({super.key});

  @override
  RegisterUserViewState createState() => RegisterUserViewState();
}

class RegisterUserViewState extends State<RegisterUserView> {
  String name = '';
  String email = '';
  String password = '';
  String selectedRole = 'Cliente';

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
                _nameFieldSection(),
                _emailFieldSection(),
                _passwordFieldSection(),
                _roleSelectionSection(),
                _registerButton(),
                _loginLink(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _headerSection() {
    return Container(
      padding: const EdgeInsets.only(top: 65),
      width: double.infinity,
      child: Column(
        children: [
          Container(
            margin: const EdgeInsets.only(bottom: 22),
            width: 119,
            height: 96,
            child: Image.network(
              "https://storage.googleapis.com/tagjs-prod.appspot.com/v1/qVyoVyLVaQ/n0uyhe4c_expires_30_days.png",
              fit: BoxFit.fill,
            ),
          ),
          Container(
            margin: const EdgeInsets.only(bottom: 26),
            child: const Text(
              "Registrarse",
              style: TextStyle(
                color: Color(0xFF166534),
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _nameFieldSection() {
    return Container(
      margin: const EdgeInsets.only(bottom: 16, left: 32, right: 32),
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Nombre",
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
                  name = value;
                });
              },
              decoration: const InputDecoration(
                hintText: "Tu nombre",
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
      margin: const EdgeInsets.only(bottom: 16, left: 32, right: 32),
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

  Widget _roleSelectionSection() {
    return Container(
      margin: const EdgeInsets.only(bottom: 25, left: 32, right: 32),
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Soy",
            style: TextStyle(
              color: Color(0xFF374151),
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: InkWell(
                  onTap: () {
                    setState(() {
                      selectedRole = 'Cliente';
                    });
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: selectedRole == 'Cliente'
                          ? const Color(0xFF166534)
                          : const Color(0xFFF9FAFB),
                      border: selectedRole == 'Cliente'
                          ? null
                          : Border.all(
                              color: const Color(0xFFE5E7EB),
                              width: 1,
                            ),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    margin: const EdgeInsets.only(right: 12),
                    width: double.infinity,
                    child: Text(
                      "Cliente",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: selectedRole == 'Cliente'
                            ? const Color(0xFFFFFFFF)
                            : const Color(0xFF374151),
                        fontSize: 15,
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: InkWell(
                  onTap: () {
                    setState(() {
                      selectedRole = 'Vendedor';
                    });
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: selectedRole == 'Vendedor'
                          ? const Color(0xFF166534)
                          : const Color(0xFFF9FAFB),
                      border: selectedRole == 'Vendedor'
                          ? null
                          : Border.all(
                              color: const Color(0xFFE5E7EB),
                              width: 1,
                            ),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    width: double.infinity,
                    child: Text(
                      "Vendedor",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: selectedRole == 'Vendedor'
                            ? const Color(0xFFFFFFFF)
                            : const Color(0xFF374151),
                        fontSize: 15,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _registerButton() {
    return InkWell(
      onTap: () {},
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
        child: TextButton(
          onPressed: () {
            Navigator.pushNamed(context, '/login');
          },
          child: Text(
            "Registrarse",
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Color(0xFFFFFFFF),
              fontSize: 16,
            fontWeight: FontWeight.bold,
            ),
          )
        ),
      ),
    );
  }

  Widget _loginLink() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 7),
      margin: const EdgeInsets.only(bottom: 27),
      child: TextButton(
        onPressed: () {
          Navigator.pop(context);
        },
        child: Text(
          "Ya tienes una cuenta? Inicia sesion",
          style: TextStyle(
            color: Color(0xFF166534),
            fontSize: 15,
          ),
        )
      ),
    );
  }
}