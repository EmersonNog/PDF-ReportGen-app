// ignore_for_file: library_private_types_in_public_api, use_build_context_synchronously

import 'package:aeroporto/pages/ItemListScreen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class EditScreen extends StatefulWidget {
  final String itemId;
  final String coordenadas;

  const EditScreen({Key? key, required this.itemId, required this.coordenadas})
      : super(key: key);

  @override
  _EditScreenState createState() => _EditScreenState();
}

class _EditScreenState extends State<EditScreen> {
  FirebaseFirestore db = FirebaseFirestore.instance;
  bool _isLoading = false;
  String? selectedField;
  dynamic fieldValue;
  final TextEditingController _textEditingController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchItemDetails();
  }

  Future<void> fetchItemDetails() async {
    setState(() {
      _isLoading = true;
    });

    setState(() {
      _isLoading = false;
    });
  }

  Future<void> updateItemDetails() async {
    if (_textEditingController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            "Por favor, insira um novo valor antes de salvar.",
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    await db.collection("dados").doc(widget.itemId).update({
      selectedField!: _textEditingController.text,
    });

    setState(() {
      _isLoading = false;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          "Dados atualizados com sucesso!",
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.greenAccent,
      ),
    );

    Navigator.pop(context, true);
  }

  @override
  Widget build(BuildContext context) {
    List<String> fields = fieldNames.keys.toList()..remove('coordenadas');

    return Scaffold(
        appBar: AppBar(
          title: const Text("Editar Formulário"),
          backgroundColor: Colors.teal,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new_rounded,
                color: Colors.white),
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const ItemListScreen()),
              );
            },
          ),
        ),
        body: _isLoading
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Editar Formulário",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    DropdownButtonFormField<String>(
                      value: selectedField,
                      items: fields.map<DropdownMenuItem<String>>((field) {
                        return DropdownMenuItem<String>(
                          value: field,
                          child: Text(
                            fieldNames[field] ?? field,
                            style: const TextStyle(fontSize: 16),
                          ),
                        );
                      }).toList(),
                      onChanged: (String? value) {
                        setState(() {
                          selectedField = value;
                          fieldValue =
                              null;
                        });
                        fetchFieldValueFromDatabase(
                            value);
                      },
                      decoration: const InputDecoration(
                        labelText: "Campo",
                        border: OutlineInputBorder(),
                        contentPadding:
                            EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      ),
                    ),
                    const SizedBox(height: 24),
                    if (selectedField != null)
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TextFormField(
                            controller: _textEditingController,
                            decoration: const InputDecoration(
                              labelText: "Novo Valor",
                              border: OutlineInputBorder(),
                              contentPadding: EdgeInsets.all(16),
                            ),
                            onChanged: (value) {
                              setState(() {
                                fieldValue = value;
                              });
                            },
                          ),
                          const SizedBox(height: 24),
                          ElevatedButton(
                            style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all<Color>(
                                Colors.teal,
                              ),
                            ),
                            onPressed: updateItemDetails,
                            child: const Text("Editar"),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            "Valor Atual: ${fieldValue != null ? (fieldValue is List ? fieldValue.join(", ") : fieldValue) : "N/A"}",
                            style: const TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                  ],
                ),
              ));
  }

  Future<void> fetchFieldValueFromDatabase(String? field) async {
    if (field != null) {
      setState(() {
        _isLoading = true;
      });

      DocumentSnapshot doc =
          await db.collection("dados").doc(widget.itemId).get();

      setState(() {
        _isLoading = false;
        fieldValue = doc[
            field]; // Update the fieldValue with the value from the database
      });
    }
  }

  Map<String, String> fieldNames = {
    "cod": 'Código',
    "nomeEntrevistado": "Nome de Entrevistado",
    "cpfEntrevistado": "CPF do Entrevistado",
    "nomeProprietario": "Nome do Proprietário",
    "cpfProprietario": "CPF do Proprietário",
    "contato": "Contato",
    "endereco": "Endereço",
    "cidade": "Cidade",
    "bairro": "Bairro",
    "moradores": "Moradores",
    "alugado": "Alugado",
    "construcao": "Construção",
    "ocupacao": "Ocupação",

    // form2 data
    "tipoPropiedade": "Tipo de Propriedade",
    "pavimento": "Pavimento",
    "parede": "Parede",
    "padrãoConstrutivo": "Padrão Construtivo",
    "idadeAparente": "Idade Aparente",
    "situacao": "Situação",
    "numQuartos": "Quantidade de Quartos",
    "numBanheiros": "Quantidade de Banheiros",
    "numSuites": "Quantidade de Suítes",
    "garagem": "Garagem",
    "situacaoArea": "Situação da Área",

    // form3 data
    "tipologiaChao": "Tipologia do Piso",

    //form4 data
    "tipoElemento": "Tipologia da Superestrutura",

    //form 5 data
    "tipologiaEdificacao": "Tipologia da Edificação",
    "itensRevestimento": "Tipo de Revestimento",

    //form 6 data
    "itensForro": "Tipo do Forro",

    //form 7 data
    "tipoligaEstruturaCobertura": "Tipologia da Estrutura da Cobertura",
    "tipologiaTelha": "Tipologia do Telhado",
  };
}
