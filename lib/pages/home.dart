// ignore_for_file: unused_field
import 'package:aeroporto/pages/ReportPhotoCommercial.dart';
import 'package:aeroporto/pages/ReportPhotoMixed.dart';
import 'package:aeroporto/pages/pdfPage.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/link.dart';
import 'ChatBot.dart';
import 'LoginPage.dart';
import 'ReportPhotoCivil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'ReportPhotoInstitutional.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  HomeState createState() => HomeState();
}

class HomeState extends State<Home> {
  int _currentCarouselIndex = 0;
  User? _user;

  final List<String> carouselImages = [
    'assets/images/certare.png',
    'assets/images/carrossel/obras.png',
    'assets/images/carrossel/supervisao.png',
    'assets/images/carrossel/inovacao.png',
    'assets/images/carrossel/energia.png',
    'assets/images/carrossel/seg_viaria.png',
    'assets/images/carrossel/mineracao.png',
    'assets/images/carrossel/arquitetura.png',
  ];

  void _showPropertyTypeDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.0),
          ),
          child: Container(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text(
                  'Escolha o tipo de imóvel',
                  style: TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                    color: Colors
                        .teal, 
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24.0),
                ElevatedButton.icon(
                  onPressed: () {
                    Navigator.of(context).pop();
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ReportPhotoCivil(),
                      ),
                    );
                  },
                  icon: const Icon(
                    Icons.home,
                    color: Colors.white,
                  ),
                  label: const Text(
                    'Imóvel Residencial',
                    style: TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.teal, 
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                  ),
                ),
                const SizedBox(height: 16.0),
                ElevatedButton.icon(
                  onPressed: () {
                    Navigator.of(context).pop();
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ReportPhotoCommercial(),
                      ),
                    );
                  },
                  icon: const Icon(
                    Icons.business,
                    color: Colors.white,
                  ),
                  label: const Text(
                    'Imóvel Comercial',
                    style: TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                  ),
                ),
                const SizedBox(height: 16.0),
                ElevatedButton.icon(
                  onPressed: () {
                    Navigator.of(context).pop();
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ReportPhotoMixed(),
                      ),
                    );
                  },
                  icon: const Icon(
                    Icons.home_work,
                    color: Colors.white,
                  ),
                  label: const Text(
                    'Imóvel Misto',
                    style: TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.redAccent[500],
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                  ),
                ),
                const SizedBox(height: 16.0),
                ElevatedButton.icon(
                  onPressed: () {
                    Navigator.of(context).pop();
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ReportPhotoInstitutional(),
                      ),
                    );
                  },
                  icon: const Icon(
                    Icons.account_balance,
                    color: Colors.white,
                  ),
                  label: const Text(
                    'Imóvel Institucional',
                    style: TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 213, 75, 26),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        leading: Image.asset('assets/images/certare.png'),
        title: const Text(
          'Grupo Certare',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: const Color(0x00F44336),
        actions: [
          Link(
              uri: Uri.parse('https://www.ilovepdf.com/pt/juntar_pdf'),
              target: LinkTarget.blank,
              builder: (BuildContext ctx, FollowLink? openLink) {
                return IconButton(
                  onPressed: openLink,
                  icon: const FaIcon(FontAwesomeIcons.solidFilePdf),
                  tooltip: "Unir PDFs",
                );
              }),
        ],
      ),
      body: SizedBox(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height / 0.2,
        child: Stack(
          children: [
            Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              decoration: const BoxDecoration(
                color: Colors.white,
              ),
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height / 2.54,
              decoration: const BoxDecoration(
                  color: Color(0xFF7CA98F),
                  borderRadius:
                      BorderRadius.only(bottomRight: Radius.circular(50))),
              child: Padding(
                padding: const EdgeInsets.only(top: 70),
                child: Center(
                  child: CarouselSlider(
                    items: carouselImages.map((imagePath) {
                      return Builder(
                        builder: (BuildContext context) {
                          return Image.asset(
                            imagePath,
                            fit: BoxFit.contain,
                          );
                        },
                      );
                    }).toList(),
                    options: CarouselOptions(
                      autoPlay: true,
                      enlargeCenterPage: true,
                      autoPlayCurve: Curves.easeInBack,
                      onPageChanged: (index, reason) {
                        setState(() {
                          _currentCarouselIndex = index;
                        });
                      },
                    ),
                  ),
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height / 1.649,
                decoration: const BoxDecoration(
                  color: Color.fromARGB(255, 124, 169, 143),
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height / 1.648, // BOTTOM
                padding: const EdgeInsets.only(bottom: 20),
                decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius:
                        BorderRadius.only(topLeft: Radius.circular(50))),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(
                      height: 20,
                    ),
                    RichText(
                      textAlign: TextAlign.start,
                      text: TextSpan(
                        style: textTheme.headlineSmall,
                        children: const <TextSpan>[
                          TextSpan(
                            text: 'Grupo Certare - ',
                            style: TextStyle(
                                color: Color.fromRGBO(0, 129, 6, 1),
                                fontFamily: 'Prototype',
                                fontSize: 34),
                          ),
                          TextSpan(
                            text: 'Teresina',
                            style: TextStyle(
                                color: Color.fromRGBO(255, 0, 0, 1),
                                fontFamily: 'Prototype',
                                fontSize: 34),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    Material(
                      color: const Color.fromRGBO(13, 111, 60, 1),
                      borderRadius: BorderRadius.circular(10),
                      child: InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const PdfPage()),
                          );
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              vertical: 10, horizontal: 30),
                          child: const Text(
                            "CRIAR LAUDO",
                            style: TextStyle(
                                fontFamily: "Prototype",
                                color: Colors.white,
                                fontSize: 18,
                                letterSpacing: 1),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Material(
                      child: InkWell(
                        onTap: () {
                          _showPropertyTypeDialog(context);
                        },
                        child: Container(
                          decoration: BoxDecoration(
                              border: Border.all(
                                color: const Color.fromRGBO(13, 111, 60, 1),
                              ),
                              borderRadius: BorderRadius.circular(10)),
                          padding: const EdgeInsets.symmetric(
                              vertical: 10, horizontal: 30),
                          child: const Text(
                            "RELATÓRIO FOTOGRÁFICO",
                            style: TextStyle(
                                fontFamily: "Prototype",
                                color: Color.fromRGBO(13, 111, 60, 1),
                                fontSize: 18,
                                letterSpacing: 1),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Material(
                      child: InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const LoginPage()),
                          );
                        },
                        child: Container(
                          decoration: BoxDecoration(
                              border: Border.all(
                                color: const Color.fromRGBO(13, 111, 60, 1),
                              ),
                              borderRadius: BorderRadius.circular(10)),
                          padding: const EdgeInsets.symmetric(
                              vertical: 10, horizontal: 30),
                          child: const Text(
                            "ACESSE O BANCO DE DADOS",
                            style: TextStyle(
                                fontFamily: "Prototype",
                                color: Color.fromRGBO(255, 0, 0, 1),
                                fontSize: 18,
                                letterSpacing: 1),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 35,
                    ), // aqyuuuuuu
                    const Padding(
                      padding: EdgeInsets.only(left: 18.0, right: 18.0),
                      child: Text(
                          "Unindo tradição, experiência, inovação e excelência no atendimento ao cliente, o Grupo Certare tem como objetivo englobar todas as áreas da engenharia e arquitetura consultiva, além da implantação de soluções e obras projetadas com as melhores práticas de mercado.",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: Colors.blueGrey,
                              fontFamily: "Prototype",
                              letterSpacing: 1)),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.indigo.shade600,
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const ChatScreen()),
            );
          },
          tooltip: "ChatBot",
          child: const FaIcon(FontAwesomeIcons.robot)),
    );
  }
}
