// ignore_for_file: use_build_context_synchronously

import 'package:aeroporto/pages/LoginPage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../widgets/input_field.dart';
import 'home.dart';

class SingupPage extends StatefulWidget {
  const SingupPage({super.key});

  @override
  State<StatefulWidget> createState() {
    return _SingupPageState();
  }
}

class _SingupPageState extends State<SingupPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _isCreatingAccount = false;
  bool _showPassword = false;

  void _cadastrar() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isCreatingAccount = true;
      });

      final String email = _emailController.text.trim();
      final String username = _usernameController.text;
      final String password = _passwordController.text;

      if (email.endsWith('@certare.com.br')) {
        try {
          UserCredential userCredential =
              await _auth.createUserWithEmailAndPassword(
            email: email,
            password: password,
          );

          User? user = userCredential.user;
          if (user != null) {
            await user.updateDisplayName(username);
            await user.sendEmailVerification();
          }
          showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: const Text(
                  'Cadastrado com Sucesso!',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                    color: Colors.teal,
                  ),
                ),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Parabéns! Sua conta foi criada com sucesso.',
                      style: TextStyle(fontSize: 16),
                    ),
                    const Text(
                      'Verifique seu email para ativar sua conta.',
                      style: TextStyle(fontSize: 16),
                    ),
                    Align(
                      alignment: Alignment.center,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const Home()),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.teal,
                        ),
                        child: const Text(
                          'OK',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        } catch (e) {
          setState(() {
            _isCreatingAccount = false;
          });

          String errorMessage =
              'Ocorreu um erro durante o cadastro. Por favor, tente novamente.';

          if (e is FirebaseAuthException) {
            if (e.code == 'email-already-in-use') {
              errorMessage = 'Este e-mail já está em uso por outra conta.';
            }
          }

          showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: const Text(
                  'Erro no Cadastro',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                    color: Colors.red,
                  ),
                ),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      errorMessage,
                      style: const TextStyle(fontSize: 16),
                    ),
                    const SizedBox(height: 16),
                    Align(
                      alignment: Alignment.center,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context); // Close the dialog
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                        ),
                        child: const Text(
                          'OK',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        } finally {
          setState(() {
            _isCreatingAccount = false;
          });
        }
      }
    }
  }

  void _navigateToSignIn() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const LoginPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          color: Colors.white,
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height / 2.2,
              decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Color.fromARGB(255, 153, 235, 187),
                      Color.fromARGB(255, 97, 158, 121)
                    ],
                  ),
                  borderRadius:
                      BorderRadius.only(bottomRight: Radius.circular(90))),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(top: 40),
                    child: Image.asset(
                      'assets/images/certare.png',
                      width: 300,
                    ),
                  ),
                  const Spacer(),
                  Align(
                    alignment: Alignment.bottomLeft,
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 32, left: 32),
                      child: Text(
                        'Cadastro'.toUpperCase(),
                        style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Form(
              key: _formKey,
              child: Container(
                width: MediaQuery.of(context).size.width,
                padding: const EdgeInsets.only(top: 40),
                margin: const EdgeInsets.only(left: 10, right: 10),
                child: Column(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(
                          top: 4, left: 16, right: 16, bottom: 4),
                      child: InputField(
                        inputController: _emailController,
                        textLabel: 'Email',
                        suffixWidget: const Icon(Icons.email),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Por favor insira o seu e-mail';
                          }
                          if (!value.endsWith('@certare.com.br')) {
                            return 'Por favor, use um e-mail que termine com @certare.com.br';
                          }
                          return null;
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                          top: 4, left: 16, right: 16, bottom: 4),
                      child: InputField(
                        inputController: _usernameController,
                        textLabel: 'Nome de Usuário',
                        suffixWidget: const Icon(Icons.person),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Por favor insira um usuário';
                          }
                          if (!value.contains(RegExp(r'[a-zA-Z]'))) {
                            return 'Deve conter letras';
                          }
                          return null;
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                          top: 4, left: 16, right: 16, bottom: 4),
                      child: InputField(
                        inputController: _passwordController,
                        textLabel: 'Senha',
                        suffixWidget: GestureDetector(
                          onTap: () {
                            setState(() {
                              _showPassword = !_showPassword;
                            });
                          },
                          child: Icon(
                            _showPassword
                                ? Icons.visibility
                                : Icons.visibility_off,
                          ),
                        ),
                        obscure: !_showPassword,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Por favor, insira sua senha';
                          }
                          if (value.length < 6) {
                            return 'Senha fraca: mínimo 6 caracteres';
                          }
                          return null;
                        },
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    const Text(
                      'Nota: Por favor, use um e-mail que termine com \n@certare.com.br',
                      style: TextStyle(color: Colors.grey, fontSize: 12),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    GestureDetector(
                      onTap: _cadastrar,
                      child: Container(
                        height: 45,
                        width: MediaQuery.of(context).size.width / 1.2,
                        decoration: const BoxDecoration(
                            gradient: LinearGradient(
                              colors: [Color(0xFFf45d27), Color(0xFFf5851f)],
                            ),
                            borderRadius:
                                BorderRadius.all(Radius.circular(50))),
                        child: Center(
                          child: _isCreatingAccount
                              ? const CircularProgressIndicator(
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                      Colors.white),
                                )
                              : Text(
                                  'Criar uma conta'.toUpperCase(),
                                  style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold),
                                ),
                        ),
                      ),
                    ),
                    TextButton(
                        onPressed: _navigateToSignIn,
                        child: const Text(
                          "Já tem uma conta? Entrar",
                          style: TextStyle(fontStyle: FontStyle.italic),
                        ))
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
