// ignore_for_file: use_build_context_synchronously

import 'package:aeroporto/pages/ForgotPasswordPage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../widgets/input_field.dart';
import 'ItemListScreen.dart';
import 'SingupPage.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<StatefulWidget> createState() {
    return _LoginPageState();
  }
}

class _LoginPageState extends State<LoginPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  bool _rememberPassword = false;
  bool _showPassword = false;

  @override
  void initState() {
    super.initState();
    _loadSavedCredentials();
  }

  Future<void> _loadSavedCredentials() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String savedEmail = prefs.getString('savedEmail') ?? '';
    bool savedRememberPassword =
        prefs.getBool('savedRememberPassword') ?? false;

    setState(() {
      _emailController.text = savedEmail;
      _rememberPassword = savedRememberPassword;
    });

    if (_rememberPassword) {
      _passwordController.text = prefs.getString('savedPassword') ?? '';
    }
  }

  Future<void> _login() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      final String email = _emailController.text.trim();
      final String password = _passwordController.text;

      try {
        UserCredential userCredential = await _auth.signInWithEmailAndPassword(
          email: email,
          password: password,
        );
        if (userCredential.user != null && userCredential.user!.emailVerified) {
          SharedPreferences prefs = await SharedPreferences.getInstance();
          if (_rememberPassword) {
            prefs.setString('savedEmail', email);
            prefs.setString('savedPassword', password);
            prefs.setBool('savedRememberPassword', _rememberPassword);
          } else {
            prefs.setString('savedEmail', '');
            prefs.setString('savedPassword', ''); // Clear the saved password
            prefs.setBool('savedRememberPassword', _rememberPassword);
          }
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const ItemListScreen()),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content:
                  Text('Por favor, verifique seu email antes de fazer login.'),
              backgroundColor: Colors.orange,
            ),
          );
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Falha no login. Verifique suas credenciais.'),
            backgroundColor: Colors.red,
          ),
        );
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _navigateToSignUp() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const SingupPage()),
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
                      BorderRadius.only(bottomLeft: Radius.circular(90))),
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
                    alignment: Alignment.bottomRight,
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 32, right: 32),
                      child: Text(
                        'Login'.toUpperCase(),
                        style: const TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Form(
              key: _formKey,
              child: Container(
                height: MediaQuery.of(context).size.height / 2,
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
                    Container(
                      padding: const EdgeInsets.only(
                          top: 4, left: 5, right: 16, bottom: 4),
                      child: Row(
                        children: [
                          Checkbox(
                            value: _rememberPassword,
                            onChanged: (newValue) {
                              setState(() {
                                _rememberPassword = newValue!;
                              });
                            },
                          ),
                          const Text('Lembrar senha'),
                          Padding(
                            padding: const EdgeInsets.only(left: 50),
                            child: TextButton(
                              style: TextButton.styleFrom(
                                foregroundColor : Colors.grey, 
                              ),
                              child: const Text("Esqueceu sua senha?"),
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        const ForgotPasswordPage(),
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),const SizedBox(
                      height: 20,
                    ),
                    GestureDetector(
                      onTap: _login,
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
                          child: _isLoading
                              ? const CircularProgressIndicator(
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                      Colors.white),
                                )
                              : Text(
                                  'Login'.toUpperCase(),
                                  style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold),
                                ),
                        ),
                      ),
                    ),
                    TextButton(
                        onPressed: _navigateToSignUp,
                        child: const Text(
                          "Não tem uma conta? Inscreva-se",
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
