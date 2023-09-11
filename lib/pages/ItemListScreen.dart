// ignore: file_names
// ignore_for_file: use_build_context_synchronously, avoid_print

import 'package:aeroporto/pages/pdfPage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'EditScreen.dart';
import 'home.dart';
import 'package:url_launcher/url_launcher.dart';

class ItemListScreen extends StatefulWidget {
  const ItemListScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _ItemListScreenState createState() => _ItemListScreenState();
}

class _ItemListScreenState extends State<ItemListScreen> {
  FirebaseAuth _auth = FirebaseAuth.instance;
  User? _user;
  FirebaseFirestore db = FirebaseFirestore.instance;
  List<Map<String, dynamic>> itemList = [];
  bool isSearchExpanded = false;
  bool isSearchInputExpanded = false;
  TextEditingController searchController = TextEditingController();
  String searchTerm = '';

  @override
  void initState() {
    super.initState();
    fetchData();
    _getUserInfo();
  }

  Future<void> _getUserInfo() async {
    _user = _auth.currentUser;
    setState(() {});
  }

  Future<DocumentSnapshot> fetchDocument(String id) async {
    return await db.collection("dados").doc(id).get();
  }

  void openMap(String id) async {
    DocumentSnapshot docSnapshot = await fetchDocument(id);
    if (!docSnapshot.exists) {
      print("Document not found in Firestore.");
      return;
    }

    String coordenadas = docSnapshot.get("coordenadas");
    if (coordenadas.isEmpty) {
      print("Location data is not available.");
      return;
    }

    List<String> latLong = coordenadas.split(',');
    double latitude = double.parse(latLong[0]);
    double longitude = double.parse(latLong[1]);

    String mapUrl =
        'https://www.google.com/maps/search/?api=1&query=$latitude,$longitude';

    if (await canLaunchUrl(Uri.parse(mapUrl))) {
      await launchUrl(
        Uri.parse(mapUrl),
        mode: LaunchMode.externalApplication,
      );
    } else {
      throw 'Could not open the map.';
    }
  }

  Future<void> fetchData() async {
    QuerySnapshot query;

    if (searchTerm.isEmpty) {
      query = await db.collection("dados").get();
    } else {
      query = await db
          .collection("dados")
          .where("cod", isGreaterThanOrEqualTo: searchTerm)
          .where("cod", isLessThan: '${searchTerm}z')
          .get();
    }

    List<Map<String, dynamic>> items = [];

    for (var doc in query.docs) {
      String cod = doc.get("cod");
      String coordenadas = doc.get("coordenadas");

      Map<String, dynamic> item = {
        "id": doc.id,
        "cod": cod,
        "coordenadas": coordenadas,
      };

      items.add(item);
    }

    setState(() {
      itemList = items;
    });
  }

  Future<void> deleteData(String id) async {
    bool confirmDelete = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Confirmar?"),
          content: const Text("Você quer mesmo deletar esse item?"),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text("Cancelar"),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text("Deletar"),
            ),
          ],
        );
      },
    );

    if (confirmDelete == true) {
      await db.collection("dados").doc(id).delete();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Item excluído do banco de dados!"),
          backgroundColor: Colors.redAccent,
        ),
      );

      fetchData();
    }
  }

  void navigateToEditScreen(String id, String coordenadas) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditScreen(itemId: id, coordenadas: coordenadas),
      ),
    ).then((value) {
      if (value == true) {
        fetchData();
      }
    });
  }

  void toggleSearch() {
    setState(() {
      isSearchInputExpanded = !isSearchInputExpanded;
      if (!isSearchInputExpanded) {
        searchController.clear();
        searchData('');
      }
    });
  }

  void searchData(String term) {
    setState(() {
      searchTerm = term;
      fetchData();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Banco de Dados - ${_user!.displayName}"),
        backgroundColor: Colors.teal,
        automaticallyImplyLeading: false,
        leading: isSearchInputExpanded
            ? null
            : IconButton(
                icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const Home()),
                  );
                },
              ),
        actions: [
          if (isSearchInputExpanded)
            Container(
              width: MediaQuery.of(context).size.width * 1,
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 6),
              child: TextField(
                controller: searchController,
                onChanged: searchData,
                onSubmitted: (_) => searchData(searchController.text),
                autofocus: true,
                cursorColor: const Color.fromARGB(255, 69, 69, 69),
                cursorWidth: 1.5,
                cursorHeight: 20,
                style: const TextStyle(color: Colors.white, fontSize: 15),
                decoration: InputDecoration(
                  hintText: "Código do Laudo",
                  contentPadding: const EdgeInsets.only(top: 10),
                  border: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  hintStyle: const TextStyle(color: Colors.white70),
                  prefixIcon: IconButton(
                    icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
                    onPressed:
                        toggleSearch, 
                  ),
                  labelStyle: const TextStyle(color: Colors.white),
                ),
              ),
            ),
          if (!isSearchInputExpanded)
            IconButton(
              iconSize: 28,
              icon: const Icon(Icons.search, color: Colors.white),
              onPressed: toggleSearch,
            ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 40),
        child: StreamBuilder<QuerySnapshot>(
            stream: _getFirestoreStream(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return _buildShimmerEffect();
              } else {
                if (snapshot.hasError) {
                  return Text("Error: ${snapshot.error}");
                } else {
                  return _buildListView(snapshot.data!);
                }
              }
            }),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const PdfPage()),
          );
        },
        backgroundColor: Colors.teal,
        child: const Icon(Icons.add),
      ),
    );
  }

  Stream<QuerySnapshot> _getFirestoreStream() {
    if (searchTerm.isEmpty) {
      return db.collection("dados").snapshots();
    } else {
      return db
          .collection("dados")
          .where("cod", isGreaterThanOrEqualTo: searchTerm)
          .where("cod", isLessThan: '${searchTerm}z')
          .snapshots();
    }
  }

  Widget _buildShimmerEffect() {
    return ListView.builder(
      itemCount: 9,
      itemBuilder: (context, index) {
        return Shimmer.fromColors(
          baseColor: Colors.grey[300]!,
          highlightColor: Colors.grey[100]!,
          child: ListTile(
            title: Container(
              height: 16,
              width: 100,
              color: Colors.white,
            ),
            subtitle: Container(
              height: 12,
              width: 150,
              color: Colors.white,
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  height: 36,
                  width: 36,
                  color: Colors.white,
                ),
                const SizedBox(width: 8),
                Container(
                  height: 36,
                  width: 36,
                  color: Colors.white,
                ),
                const SizedBox(width: 8),
                Container(
                  height: 36,
                  width: 36,
                  color: Colors.white,
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildListView(QuerySnapshot snapshot) {
    List<Map<String, dynamic>> items = [];
    for (var doc in snapshot.docs) {
      String cod = doc.get("cod");
      String coordenadas = doc.get("coordenadas");

      Map<String, dynamic> item = {
        "id": doc.id,
        "cod": cod,
        "coordenadas": coordenadas,
      };

      items.add(item);
    }

    if (items.isEmpty) {
      return const Center(
        child: Text(
          "Nenhum dado no banco de dados.",
          style: TextStyle(fontSize: 18),
        ),
      );
    }

    return SingleChildScrollView(
      child: Column(
        children: [
          for (var item in items)
            ListTile(
              title: Text(
                item["cod"],
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              subtitle: Text(
                "Código: ${item["cod"]}",
                style: const TextStyle(
                  color: Colors.grey,
                ),
              ),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: const Icon(Icons.edit, color: Colors.blueAccent),
                    onPressed: () =>
                        navigateToEditScreen(item["id"], item["coordenadas"]),
                  ),
                  IconButton(
                    icon: const Icon(
                      Icons.delete,
                      color: Color.fromRGBO(244, 67, 54, 1),
                    ),
                    onPressed: () => deleteData(item["id"]),
                  ),
                  IconButton(
                    icon: Icon(Icons.place, color: Colors.green[500]),
                    onPressed: () => openMap(item["id"]),
                  ),
                ],
              ),
              onTap: () =>
                  navigateToEditScreen(item["id"], item["coordenadas"]),
            ),
        ],
      ),
    );
  }
}
