import 'package:aeroporto/pages/form.dart';
import 'package:aeroporto/pages/home.dart';
import 'package:aeroporto/pages/pdfQualitativo.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:printing/printing.dart';
import 'package:pdf/widgets.dart' as pw;

class PdfPage extends StatefulWidget {
  const PdfPage({Key? key}) : super(key: key);

  @override
  State<PdfPage> createState() => _PdfPageState();
}

class _PdfPageState extends State<PdfPage> {
  PrintingInfo? printingInfo;
  String cod = '';
  //form 1
  String nameEntrevistado = '';
  String cpfEntrevistado = '';
  String nameProprietario = '';
  String cpfProprietario = '';
  String contato = '';
  String endereco = '';
  String cidade = '';
  String bairro = '';
  String moradores = '';
  String situacao = '';
  String construcao = '';
  String ocupacao = '';
  //form 2
  String tipoImovel = '';
  String pavimento = '';
  String muro = '';
  String padraoConstrutivo = '';
  String idadeAparente = '';
  String aberto = '';
  String qtdQuarto = '';
  String qtdBanheiro = '';
  String qtdSuite = '';
  String garagem = '';
  String situacaoArea = '';
  //form 3
  String tipologiaPiso = '';
  //form 4
  String posivelIdentificar = '';
  String elemento = '';
  //form 5
  String itensTipologiaEdi = '';
  String itensRevestimento = '';
  //form 6
  String tipologiaForro = '';
  //form 7
  String tipoligaEstruturaCobertura = '';
  String tipologiaTelha = '';
  //form 8
  String resumo = '';

  @override
  void initState() {
    super.initState();
    _init();
  }

  Future<void> _init() async {
    final info = await Printing.info();
    setState(() {
      printingInfo = info;
    });
  }

  void _handleFormSubmitted(FormData formData) {
    setState(() {
      cod = formData.cod;
      //form 1
      nameEntrevistado = formData.nomeEntrevistado;
      cpfEntrevistado = formData.cpfEntrevistado;
      nameProprietario = formData.nomeProprietario;
      cpfProprietario = formData.cpfProprietario;
      contato = formData.contato;
      endereco = formData.endereco;
      cidade = formData.cidade;
      bairro = formData.bairro;
      moradores = formData.moradores;
      situacao = formData.situacao;
      construcao = formData.construcao;
      ocupacao = formData.ocupacao;
      //form 2
      tipoImovel = formData.tipoImovel;
      pavimento = formData.pavimento;
      muro = formData.muro;
      padraoConstrutivo = formData.padraoConstrutivo;
      idadeAparente = formData.idadeAparente;
      aberto = formData.aberto;
      qtdQuarto = formData.qtdQuarto;
      qtdBanheiro = formData.qtdBanheiro;
      qtdSuite = formData.qtdSuite;
      garagem = formData.garagem;
      situacaoArea = formData.situacaoArea;
      //form 3
      tipologiaPiso = formData.tipologiaPiso;
      //form 4
      elemento = formData.elemento;
      //form 5
      itensTipologiaEdi = formData.itensTipologiaEdi;
      itensRevestimento = formData.itensRevestimento;
      //form 6
      tipologiaForro = formData.tipologiaForro;
      //form 7
      tipoligaEstruturaCobertura = formData.tipoligaEstruturaCobertura;
      tipologiaTelha = formData.tipologiaTelha;
      //form 8
      resumo = formData.resumo;
    });
  }

  @override
  Widget build(BuildContext context) {
    pw.RichText.debug = true;
    final actions = <PdfPreviewAction>[
      if (!kIsWeb)
        const PdfPreviewAction(
          icon: Icon(Icons.save),
          onPressed: saveAsFile,
        ),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Laudo - Certare',
            style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.black),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const Home()),
            );
          },
        ),
      ),
      body: cod.isEmpty
          ? Formulario(onFormSubmitted: _handleFormSubmitted)
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  const SizedBox(height: 16.0),
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.2),
                            spreadRadius: 5.0,
                            blurRadius: 4.0,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: PdfPreview(
                        maxPageWidth: 700,
                        actions: actions,
                        onShared: (_) => showSharedToast(context),
                        onPrinted: (_) => showPrintedToast(context),
                        build: (format) => generatePdf(
                          format,
                          cod,
                          //form 1
                          nameEntrevistado,
                          cpfEntrevistado,
                          nameProprietario,
                          cpfProprietario,
                          contato,
                          endereco,
                          cidade,
                          bairro,
                          moradores,
                          situacao,
                          construcao,
                          ocupacao,
                          //form 2
                          tipoImovel,
                          pavimento,
                          muro,
                          padraoConstrutivo,
                          idadeAparente,
                          aberto,
                          qtdQuarto,
                          qtdBanheiro,
                          qtdSuite,
                          garagem,
                          situacaoArea,
                          //form 3
                          tipologiaPiso,
                          //form 4
                          elemento,
                          //form 5
                          itensTipologiaEdi,
                          itensRevestimento,
                          //form 6
                          tipologiaForro,
                          //form 7
                          tipoligaEstruturaCobertura,
                          tipologiaTelha,
                          //form 8
                          resumo,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
