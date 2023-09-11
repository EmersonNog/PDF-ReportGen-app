// ignore: file_names
// ignore_for_file: depend_on_referenced_packages, use_build_context_synchronously, no_leading_underscores_for_local_identifiers
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:printing/printing.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:path/path.dart' as path;

Future<Uint8List> generatePdf(
  final PdfPageFormat format,
  String cod,
  //form 1
  String nameEntrevistado,
  String cpfEntrevistado,
  String nameProprietario,
  String cpfProprietario,
  String contato,
  String endereco,
  String cidade,
  String bairro,
  String moradores,
  String situacao,
  String construcao,
  String ocupacao,
  //form 2
  String tipoImovel,
  String pavimento,
  String muro,
  String padraoConstrutivo,
  String idadeAparente,
  String aberto,
  String qtdQuarto,
  String qtdBanheiro,
  String qtdSuite,
  String garagem,
  String situacaoArea,
  //form 3
  String tipologiaPiso,
  //form 4
  String elemento,
  //form 5
  String itensTipologiaEdi,
  String itensRevestimento,
  //form 6
  String tipologiaForro,
  //form 7
  String tipoligaEstruturaCobertura,
  String tipologiaTelha,
  //form 8
  String resumo,
) async {
  final doc = pw.Document(
    title: cod,
  );

  final gpCertare = pw.MemoryImage(
    (await rootBundle.load('assets/images/footer/gp_certare.png'))
        .buffer
        .asUint8List(),
  );
  final companyCertare = pw.MemoryImage(
    (await rootBundle.load('assets/images/footer/company_certare.png'))
        .buffer
        .asUint8List(),
  );
  final htb = pw.MemoryImage(
    (await rootBundle.load('assets/images/footer/htb.png'))
        .buffer
        .asUint8List(),
  );
  final ccr = pw.MemoryImage(
    (await rootBundle.load('assets/images/footer/CCR.jpg'))
        .buffer
        .asUint8List(),
  );
  final assinatura = pw.MemoryImage(
    (await rootBundle.load('assets/images/assinatura.png'))
        .buffer
        .asUint8List(),
  );

  final pageTheme = await _myPageTheme(format);

  const titleTextStyle = pw.TextStyle(fontSize: 10, color: PdfColors.white);

  pw.Widget _buildLabelValuePair(String label, String value) {
    final boldLabelStyle = pw.TextStyle(fontWeight: pw.FontWeight.bold);
    return pw.RichText(
      text: pw.TextSpan(
        children: [
          pw.TextSpan(text: label, style: boldLabelStyle),
          pw.TextSpan(text: ' $value'),
        ],
      ),
    );
  }

  pw.Widget _buildLabelValuePairDescription(String label, String value) {
    final boldLabelStyle = pw.TextStyle(fontWeight: pw.FontWeight.bold);
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text("$label \n", style: boldLabelStyle),
        pw.Text(value),
        pw.SizedBox(height: 10)
      ],
    );
  }

  doc.addPage(pw.MultiPage(
      pageTheme: pageTheme,
      header: (final context) =>
          pw.Row(mainAxisAlignment: pw.MainAxisAlignment.center, children: [
            pw.Container(
              alignment: pw.Alignment.centerLeft,
              color: PdfColor.fromHex('#649c7f'),
              height: 40,
              width: 459,
              child: pw.Text("LAUDO CAUTELAR DE VISTORIA DE VIZINHANÇA",
                  style: pw.TextStyle(
                      fontSize: 15,
                      color: PdfColors.white,
                      fontWeight: pw.FontWeight.bold)),
              margin: const pw.EdgeInsets.fromLTRB(0, -15, 0, 5),
              padding: const pw.EdgeInsets.only(left: 10),
            ),
            pw.Container(
              alignment: pw.Alignment.centerLeft,
              color: PdfColor.fromHex('#ADADAD'),
              height: 40,
              width: 80,
              child: pw.Text("CÓD.: $cod",
                  style: pw.TextStyle(
                      fontSize: 15,
                      color: PdfColors.white,
                      fontWeight: pw.FontWeight.bold)),
              margin: const pw.EdgeInsets.fromLTRB(0, -15, 0, 5),
              padding: const pw.EdgeInsets.only(left: 10),
            ),
          ]),
      footer: (context) => pw.Container(
          margin: const pw.EdgeInsets.only(bottom: -25),
          height: 60,
          child:
              pw.Row(mainAxisAlignment: pw.MainAxisAlignment.center, children: [
            pw.Image(gpCertare, width: 100),
            pw.SizedBox(width: 10),
            pw.Image(companyCertare, width: 100),
            pw.SizedBox(width: 10),
            pw.Image(htb, width: 100),
            pw.SizedBox(width: 10),
            pw.Image(ccr, width: 100),
          ])),
      build: (final context) => [
            pw.Row(
              children: [
                pw.Expanded(
                  child: pw.Container(
                    color: PdfColor.fromHex('#649c7f'),
                    padding: const pw.EdgeInsets.symmetric(
                        horizontal: 154, vertical: 5),
                    child: pw.Text(
                      "IDENTIFICAÇÃO E LOCALIZAÇÃO",
                      style: pw.TextStyle(
                        color: PdfColor.fromHex('#FFFFFF'),
                        fontSize: 14,
                        fontWeight: pw.FontWeight.bold,
                      ),
                    ),
                    margin: const pw.EdgeInsets.only(bottom: 5),
                  ),
                ),
              ],
            ),
            pw.Container(
              color: PdfColor.fromHex('#F0F0F0'),
              padding: const pw.EdgeInsets.all(10),
              child: pw.Row(
                children: [
                  pw.Expanded(
                    child: pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                        _buildLabelValuePair("ENTREVISTADO:", nameEntrevistado),
                        _buildLabelValuePair("PROPRIETÁRIO:", nameProprietario),
                        _buildLabelValuePair("CONTATO:", contato),
                        _buildLabelValuePair("CIDADE:", cidade),
                        _buildLabelValuePair("IMÓVEL ALUGADO:", situacao),
                        _buildLabelValuePair(
                            "QUANTIDADES DE MORADORES:", moradores),
                      ],
                    ),
                  ),
                  pw.Expanded(
                    child: pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                        _buildLabelValuePair("CPF:", cpfEntrevistado),
                        _buildLabelValuePair("CPF:", cpfProprietario),
                        _buildLabelValuePair("ENDEREÇO:", endereco),
                        _buildLabelValuePair("BAIRRO:", bairro),
                        _buildLabelValuePair("TEMPO DE OCUPAÇÃO:", ocupacao),
                        _buildLabelValuePair(
                            "TEMPO DE CONSTRUÇÃO:", construcao),
                      ],
                    ),
                  ),
                ],
              ),
              margin: const pw.EdgeInsets.only(bottom: 5),
            ),
            pw.Row(
              children: [
                pw.Expanded(
                  child: pw.Container(
                    color: PdfColor.fromHex('#649c7f'),
                    padding: const pw.EdgeInsets.symmetric(
                        horizontal: 140, vertical: 5),
                    child: pw.Text(
                      "INFORMAÇÕES GERAIS DO IMÓVEL",
                      style: pw.TextStyle(
                        color: PdfColor.fromHex('#FFFFFF'),
                        fontSize: 14,
                        fontWeight: pw.FontWeight.bold,
                      ),
                    ),
                    margin: const pw.EdgeInsets.only(bottom: 5),
                  ),
                ),
              ],
            ),
            pw.Container(
              color: PdfColor.fromHex('#F0F0F0'),
              padding: const pw.EdgeInsets.all(10),
              child: pw.Row(
                children: [
                  pw.Expanded(
                    child: pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                        _buildLabelValuePair(
                            "TIPO DE IMÓVEL (OU USO):", tipoImovel),
                        _buildLabelValuePair("MURO:", muro),
                        _buildLabelValuePair("PAVIMENTOS:", pavimento),
                        _buildLabelValuePair(
                            "PADRÃO CONSTRUTIVO:", padraoConstrutivo),
                        _buildLabelValuePair("IDADE APARENTE:", idadeAparente),
                        _buildLabelValuePair("SITUAÇÃO:", aberto),
                      ],
                    ),
                  ),
                  pw.Expanded(
                    child: pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                        _buildLabelValuePair("QTD. DE QUARTOS:", qtdQuarto),
                        _buildLabelValuePair("QTD. DE SUÍTES:", qtdSuite),
                        _buildLabelValuePair("QTD. DE BANHEIROS:", qtdBanheiro),
                        _buildLabelValuePair("GARAGEM:", garagem),
                        _buildLabelValuePair("SITUAÇÃO DA ÁREA:", situacaoArea),
                      ],
                    ),
                  ),
                ],
              ),
              margin: const pw.EdgeInsets.only(bottom: 5),
            ),
            pw.Row(
              children: [
                pw.Expanded(
                  child: pw.Container(
                    color: PdfColor.fromHex('#649c7f'),
                    padding: const pw.EdgeInsets.symmetric(
                        horizontal: 140, vertical: 5),
                    child: pw.Text(
                      "CARACTERIZAÇÃO DO IMÓVEL",
                      style: pw.TextStyle(
                        color: PdfColor.fromHex('#FFFFFF'),
                        fontSize: 14,
                        fontWeight: pw.FontWeight.bold,
                      ),
                    ),
                    margin: const pw.EdgeInsets.only(bottom: 5),
                  ),
                ),
              ],
            ),
            pw.Container(
              height: 350,
              color: PdfColor.fromHex('#F0F0F0'),
              padding: const pw.EdgeInsets.all(10),
              child: pw.Row(
                children: [
                  pw.Expanded(
                    child: pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                        _buildLabelValuePairDescription(
                            "TIPOLOGIA DE PISO:", tipologiaPiso),
                        _buildLabelValuePairDescription(
                            "TIPOLOGIA DE ALVENARIA E VEDAÇÃO:",
                            itensTipologiaEdi),
                        _buildLabelValuePairDescription(
                            "TIPOLOGIA DE REVESTIMENTO:", itensRevestimento),
                        _buildLabelValuePairDescription(
                            "TIPOLOGIA DE FORRO:", tipologiaForro),
                        _buildLabelValuePairDescription(
                            "TIPOLOGIA DE SUPERESTRUTURA:", elemento),
                        _buildLabelValuePairDescription(
                            "TIPOLOGIA DA ESTRUTURA DA COBERTURA:",
                            tipoligaEstruturaCobertura),
                        _buildLabelValuePairDescription(
                            "TIPOLOGIA DAS TELHAS:", tipologiaTelha),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ]));

  doc.addPage(pw.MultiPage(
      pageTheme: pageTheme,
      header: (final context) =>
          pw.Row(mainAxisAlignment: pw.MainAxisAlignment.center, children: [
            pw.Container(
              alignment: pw.Alignment.centerLeft,
              color: PdfColor.fromHex('#649c7f'),
              height: 40,
              width: 459,
              child: pw.Text("RESUMO DO LAUDO / VISÃO GERAL DA EDIFICAÇÃO",
                  style: pw.TextStyle(
                      fontSize: 15,
                      color: PdfColors.white,
                      fontWeight: pw.FontWeight.bold)),
              margin: const pw.EdgeInsets.fromLTRB(0, -15, 0, 5),
              padding: const pw.EdgeInsets.only(left: 10),
            ),
            pw.Container(
              alignment: pw.Alignment.centerLeft,
              color: PdfColor.fromHex('#ADADAD'),
              height: 40,
              width: 80,
              child: pw.Text("CÓD.: $cod",
                  style: pw.TextStyle(
                      fontSize: 15,
                      color: PdfColors.white,
                      fontWeight: pw.FontWeight.bold)),
              margin: const pw.EdgeInsets.fromLTRB(0, -15, 0, 5),
              padding: const pw.EdgeInsets.only(left: 10),
            ),
          ]),
      footer: (context) => pw.Container(
          margin: const pw.EdgeInsets.only(bottom: -25),
          height: 60,
          child:
              pw.Row(mainAxisAlignment: pw.MainAxisAlignment.center, children: [
            pw.Image(gpCertare, width: 100),
            pw.SizedBox(width: 10),
            pw.Image(companyCertare, width: 100),
            pw.SizedBox(width: 10),
            pw.Image(htb, width: 100),
            pw.SizedBox(width: 10),
            pw.Image(ccr, width: 100),
          ])),
      build: (final context) => [
            pw.Column(children: [
              pw.SizedBox(height: 20),
              pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.center,
                mainAxisAlignment: pw.MainAxisAlignment.center,
                children: [
                  pw.Container(
                    padding:
                        const pw.EdgeInsets.only(left: 30, right: 30, top: 15),
                    margin: const pw.EdgeInsets.only(top: -20),
                    color: PdfColor.fromHex('#e4e4e4'),
                    height: 700,
                    width: 549,
                    child: pw.Container(
                        child: pw.Column(children: [
                      pw.Column(children: [
                        pw.Text(
                            "         A elaboração deste documento é fundamentada na NBR 12722 - Discriminação de Serviços para Construção de Edifícios - e na metodologia da Norma de Vistoria de Vizinhança do IBAPE, que estabelecem os parâmetros técnicos para realização de laudos cautelares de vizinhança. Este documento foi elaborado por profissionais habilitados, com abordagem profissional, e o processo de elaboração do laudo segue estritos protocolos, de forma ética e imparcial.\n         Todas as informações coletadas são utilizadas exclusivamente para os fins do laudo, sendo armazenadas de forma segura e protegidas contra acessos não autorizados. Os dados pessoais dos proprietários e moradores das edificações vistoriadas são tratados em conformidade com a legislação de proteção de dados vigente.",
                            style: const pw.TextStyle(
                              lineSpacing: 2,
                            )),
                        pw.Align(
                          alignment: pw.Alignment.centerLeft,
                          child: pw.Text('         $resumo',
                              style: const pw.TextStyle(
                                lineSpacing: 2,
                              )),
                        ),
                        pw.Align(
                          alignment: pw.Alignment.centerLeft,
                          child: pw.Text("         No decorrer deste documento, apresentamos a planta baixa em croqui do imóvel, acompanhado por registros fotográficos que atestam e enriquecem as observações sobre o estado da edificação examinada, juntamente com a quantificação das patologias identificadas, visando proporcionar uma compreensão completa para a análise técnica das condições do imóvel.",
                          style: const pw.TextStyle(
                            lineSpacing: 2,
                          )),
                        )
                      ]),
                      pw.Column(children: [
                        pw.SizedBox(height: 10),
                        pw.Image(assinatura, width: 120),
                        pw.Text("Makey Nondas Maia",
                            style:
                                pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                        pw.Text(
                            "Sócio-Diretor / Representante Legal\nRG nº 92017003476 SSP CE\nCPF/MF nº 624.014.403-72",
                            textAlign: pw.TextAlign.center),
                      ])
                    ])),
                  ),
                ],
              ),
            ])
          ]));

  return doc.save();
}

Future<pw.PageTheme> _myPageTheme(PdfPageFormat format) async {
  return const pw.PageTheme(
    margin: pw.EdgeInsets.symmetric(
        horizontal: 1 * PdfPageFormat.cm, vertical: 1 * PdfPageFormat.cm),
    textDirection: pw.TextDirection.ltr,
    orientation: pw.PageOrientation.portrait,
  );
}

Future<void> saveAsFile(
  final BuildContext context,
  final LayoutCallback build,
  final PdfPageFormat pageFormat,
) async {
  final bytes = await build(pageFormat);

  final appDocDir = await getExternalStorageDirectory();
  final appDocPath = appDocDir!.path;
  const baseFileName = 'LCV.pdf';
  String fileName = baseFileName;
  int counter = 1;
  String filePath = path.join(appDocPath, fileName);
  File file = File(filePath);

  while (await file.exists()) {
    fileName =
        '${baseFileName.substring(0, baseFileName.lastIndexOf('.'))}_$counter.pdf';
    filePath = path.join(appDocPath, fileName);
    file = File(filePath);
    counter++;
  }

  await file.writeAsBytes(bytes);

  ScaffoldMessenger.of(context)
      .showSnackBar(SnackBar(content: Text('Documento salvo em: $filePath')));

  OpenFile.open(filePath);
}

void showPrintedToast(final BuildContext context) {
  ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Document printed succesfully!')));
}

void showSharedToast(final BuildContext context) {
  ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Document shared succesfully!')));
}
