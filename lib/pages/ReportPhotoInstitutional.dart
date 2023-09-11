import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

import 'ItemScreenInstitutional.dart';
import 'home.dart';

class ItemInstitutional{
  String id;
  String name;
  List<PhotoDataInstitutional> photos;

  ItemInstitutional(this.name, this.photos) : id = const Uuid().v4();
}

class PhotoDataInstitutional{
  String path;
  String description;
  String environment;

  PhotoDataInstitutional(this.path, this.description, this.environment);
}

class ReportPhotoInstitutional extends StatefulWidget {
  const ReportPhotoInstitutional({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _ReportPhotoInstitutionalState createState() => _ReportPhotoInstitutionalState();
}

class _ReportPhotoInstitutionalState extends State<ReportPhotoInstitutional> {
  List<ItemInstitutional> items = [];
  String searchText = '';
  bool _showSearchField = false;

  void _toggleSearchField() {
    setState(() {
      _showSearchField = !_showSearchField;
    });
  }

  List<ItemInstitutional> _filterItems() {
    if (searchText.isEmpty) {
      return items;
    } else {
      final String searchTextLower = searchText.toLowerCase();
      return items.where((item) => item.name.toLowerCase().contains(searchTextLower)).toList();
    }
  }

  void searchData(String value) {
    setState(() {
      searchText = value.trim();
    });
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: Colors.redAccent,
        content: Text(message),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  Future<void> _addItem() async {
    String? itemName = await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        final TextEditingController itemNameController =
            TextEditingController();
        return AlertDialog(
          title: const Text('Criar Novo Laudo'),
          content: TextField(
            controller: itemNameController,
            decoration: const InputDecoration(labelText: 'Código do Laudo'),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context, itemNameController.text.trim());
              },
              child: const Text('Criar'),
            ),
          ],
        );
      },
    );

    if (itemName != null && itemName.isNotEmpty) {
      if (items.any((item) => item.name == itemName)) {
        _showSnackBar("Já possuí um Laudo com esse código.");
      } else {
        setState(() {
          items.add(ItemInstitutional(itemName, []));
          _saveItems();
        });
      }
    } else {
      _showSnackBar('Insira um Código para o Laudo.');
    }
  }

  Future<void> _saveItems() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<Map<String, dynamic>> itemsData = [];

    for (var item in items) {
      Map<String, dynamic> itemData = {
        'id': item.id,
        'name': item.name,
        'photos': item.photos.map((photo) {
          return {
            'path': photo.path,
            'description': photo.description,
            'environment': photo.environment,
          };
        }).toList(),
      };
      itemsData.add(itemData);
    }

    await prefs.setString('itemsDataInstitutional', jsonEncode(itemsData));
  }

  Future<void> _loadItems() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? itemsDataJson = prefs.getString('itemsDataInstitutional');

    if (itemsDataJson != null) {
      List<dynamic> itemsData = jsonDecode(itemsDataJson);
      List<ItemInstitutional> loadedItems = [];

      for (var itemData in itemsData) {
        List<PhotoDataInstitutional> photos =
            (itemData['photos'] as List<dynamic>).map((photoData) {
          return PhotoDataInstitutional(
            photoData['path'],
            photoData['description'],
            photoData['environment'],
          );
        }).toList();

        loadedItems.add(ItemInstitutional(itemData['name'], photos)..id = itemData['id']);
      }

      setState(() {
        items = loadedItems;
      });
    }
  }

  void removeItem(int index) {
    setState(() {
      items.removeAt(index);
    });
    _saveItems();
  }

  Future<void> _showDeleteItemConfirmationDialog(int index) async {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirmar?'),
          content: const Text('Você quer mesmo deletar esse item?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () {
                removeItem(index);
                Navigator.pop(context);
              },
              child: const Text('Deletar'),
            ),
          ],
        );
      },
    );
  }

  void _editItemName(int index) async {
    String? updatedItemName = await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        final TextEditingController itemNameController =
            TextEditingController(text: items[index].name);
        return AlertDialog(
          title: const Text('Editar Laudo'),
          content: TextField(
            controller: itemNameController,
            decoration: const InputDecoration(labelText: 'Código do Laudo'),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context, itemNameController.text.trim());
              },
              child: const Text('Salvar'),
            ),
          ],
        );
      },
    );

    if (updatedItemName != null && updatedItemName.isNotEmpty) {
      setState(() {
        items[index].name = updatedItemName;
        _saveItems();
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _loadItems();
  }

  @override
  Widget build(BuildContext context) {
    List<ItemInstitutional> filteredItems = _filterItems();
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: _showSearchField
            ? TextField(
                autofocus: true,
                cursorColor: const Color.fromARGB(255, 69, 69, 69),
                cursorWidth: 1.5,
                cursorHeight: 20,
                style: const TextStyle(color: Colors.white, fontSize: 15),
                onChanged: searchData,
                decoration: const InputDecoration(
                  hintText: "Nome da Pasta",
                  contentPadding: EdgeInsets.only(top: 2),
                  border: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  hintStyle: TextStyle(color: Colors.white70),
                  labelStyle: TextStyle(color: Colors.white),
                ),
              )
            : const Text(
                'Relatório Fotográfico',
                style: TextStyle(color: Colors.white),
              ),
        backgroundColor: Colors.teal,
        leading: _showSearchField
            ? IconButton(
                icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
                onPressed: _toggleSearchField,
              )
            : IconButton(
                icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => const Home()),
                  );
                },
              ),
        actions: [
          if (!_showSearchField)
            IconButton(
              icon: const Icon(Icons.search, color: Colors.white),
              onPressed: _toggleSearchField,
            )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 40),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text(
              "Catálogo de Imagens",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(
              height: 5,
            ),
            const Text(
              "Institucional",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(
              height: 16,
            ),
            Expanded(
              child: filteredItems.isEmpty
                  ? const Center(
                      child: Text(
                        'Nenhum item encontrado.',
                        style: TextStyle(fontSize: 18.0),
                      ),
                    )
                  : ListView.builder(
                      itemCount: filteredItems.length,
                      itemBuilder: (context, index) {
                        return Card(
                          elevation: 2.0,
                          color: Colors.white,
                          child: Row(
                            children: [
                              Expanded(
                                child: ListTile(
                                  leading: const Icon(Icons.photo),
                                  title: Text(
                                    filteredItems[index].name,
                                    style: const TextStyle(
                                      fontSize: 18.0,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => ItemScreenInstitutional(
                                            filteredItems[index]),
                                      ),
                                    );
                                  },
                                ),
                              ),
                              IconButton(
                                icon: const Icon(
                                  Icons.edit,
                                  color: Colors.blue,
                                ),
                                onPressed: () => _editItemName(index),
                              ),
                              IconButton(
                                icon: const Icon(
                                  Icons.delete,
                                  color: Colors.red,
                                ),
                                onPressed: () =>
                                    _showDeleteItemConfirmationDialog(index),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
      floatingActionButton: Align(
        alignment: Alignment.bottomRight,
        child: FloatingActionButton(
          onPressed: _addItem,
          backgroundColor: Colors.teal,
          child: const Icon(Icons.add),
        ),
      ),
    );
  }
}
