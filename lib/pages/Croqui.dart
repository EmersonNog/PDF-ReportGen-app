// ignore_for_file: use_build_context_synchronously

import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_drawing_board/flutter_drawing_board.dart';
import 'package:flutter_drawing_board/paint_contents.dart';
import 'package:flutter_drawing_board/paint_extension.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:path_provider/path_provider.dart';

class Arc extends PaintContent {
  Arc();

  Arc.data({
    required this.startPoint,
    required this.centerPoint,
    required this.endPoint,
    required this.roundnessFactor,
    required Paint paint,
  }) : super.paint(paint);

  factory Arc.fromJson(Map<String, dynamic> data) {
    return Arc.data(
      startPoint: jsonToOffset(data['startPoint'] as Map<String, dynamic>),
      centerPoint: jsonToOffset(data['centerPoint'] as Map<String, dynamic>),
      endPoint: jsonToOffset(data['endPoint'] as Map<String, dynamic>),
      roundnessFactor: data['roundnessFactor'] as double,
      paint: jsonToPaint(data['paint'] as Map<String, dynamic>),
    );
  }

  Offset startPoint = Offset.zero;
  Offset centerPoint = Offset.zero;
  Offset endPoint = Offset.zero;
  double roundnessFactor = 0.7;

  @override
  void startDraw(Offset startPoint) => this.startPoint = startPoint;

  @override
  void drawing(Offset nowPoint) {
    centerPoint = Offset(
      (startPoint.dx + nowPoint.dx) / 2,
      (startPoint.dy + nowPoint.dy) / 2,
    );
    endPoint = nowPoint;
  }

  @override
  void draw(Canvas canvas, Size size, bool deeper) {
    final double radius =
        calculateDistance(startPoint, centerPoint) * roundnessFactor;

    final double startAngle = (startPoint - centerPoint).direction;
    final double endAngle = (endPoint - centerPoint).direction;

    const double sweepAngle = pi / 2;

    final Path path = Path()
      ..moveTo(startPoint.dx, startPoint.dy)
      ..arcTo(
        Rect.fromCircle(center: centerPoint, radius: radius),
        startAngle,
        sweepAngle,
        true,
      );

    canvas.drawPath(path, paint);
  }

  double calculateDistance(Offset p1, Offset p2) {
    return (p2 - p1).distance;
  }

  @override
  Arc copy() => Arc();

  @override
  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'startPoint': startPoint.toJson(),
      'centerPoint': centerPoint.toJson(),
      'endPoint': endPoint.toJson(),
      'roundnessFactor': roundnessFactor,
      'paint': paint.toJson(),
    };
  }
}

class Triangle extends PaintContent {
  Triangle();

  Triangle.data({
    required this.startPoint,
    required this.A,
    required this.B,
    required this.C,
    required Paint paint,
  }) : super.paint(paint);

  factory Triangle.fromJson(Map<String, dynamic> data) {
    return Triangle.data(
      startPoint: jsonToOffset(data['startPoint'] as Map<String, dynamic>),
      A: jsonToOffset(data['A'] as Map<String, dynamic>),
      B: jsonToOffset(data['B'] as Map<String, dynamic>),
      C: jsonToOffset(data['C'] as Map<String, dynamic>),
      paint: jsonToPaint(data['paint'] as Map<String, dynamic>),
    );
  }

  Offset startPoint = Offset.zero;

  Offset A = Offset.zero;
  Offset B = Offset.zero;
  Offset C = Offset.zero;

  @override
  void startDraw(Offset startPoint) => this.startPoint = startPoint;

  @override
  void drawing(Offset nowPoint) {
    A = Offset(
        startPoint.dx + (nowPoint.dx - startPoint.dx) / 2, startPoint.dy);
    B = Offset(startPoint.dx, nowPoint.dy);
    C = nowPoint;
  }

  @override
  void draw(Canvas canvas, Size size, bool deeper) {
    final Path path = Path()
      ..moveTo(A.dx, A.dy)
      ..lineTo(B.dx, B.dy)
      ..lineTo(C.dx, C.dy)
      ..close();

    canvas.drawPath(path, paint);
  }

  @override
  Triangle copy() => Triangle();

  @override
  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'startPoint': startPoint.toJson(),
      'A': A.toJson(),
      'B': B.toJson(),
      'C': C.toJson(),
      'paint': paint.toJson(),
    };
  }
}

class Croqui extends StatefulWidget {
  const Croqui({Key? key}) : super(key: key);

  @override
  State<Croqui> createState() => _CroquiState();
}

class _CroquiState extends State<Croqui> {
  final DrawingController _drawingController = DrawingController();
  final TextEditingController _titleController =
      TextEditingController(); // Novo controller para o título

  @override
  void dispose() {
    _drawingController.dispose();
    _titleController.dispose();
    super.dispose();
  }

  Future<void> _getImageData() async {
    final Uint8List? data =
        (await _drawingController.getImageData())?.buffer.asUint8List();
    if (data == null) {
      debugPrint('Failed to get image data');
      return;
    }

    final tempDir = await getTemporaryDirectory();
    final tempFile = File('${tempDir.path}/Croqui.png');

    await tempFile.writeAsBytes(data);

    if (await GallerySaver.saveImage(tempFile.path, albumName: 'Croqui') ==
        true) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            "Croqui salvo na galeria com sucesso",
            style: TextStyle(color: Colors.black),
          ),
          backgroundColor: Colors.greenAccent,
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            "Erro ao salvar",
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.red,
        ),
      );
    }

    if (mounted) {
      showDialog<void>(
        context: context,
        builder: (BuildContext c) {
          return Column(
            children: [
              Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () => Navigator.pop(c),
                  child: Image.memory(data),
                ),
              ),
            ],
          );
        },
      );
    }
  }

  Future<void> _getJson() async {
    showDialog<void>(
      context: context,
      builder: (BuildContext c) {
        return Center(
          child: Material(
            color: Colors.white,
            child: InkWell(
              onTap: () => Navigator.pop(c),
              child: Container(
                constraints:
                    const BoxConstraints(maxWidth: 500, maxHeight: 800),
                padding: const EdgeInsets.all(20.0),
                child: SelectableText(
                  const JsonEncoder.withIndent('  ')
                      .convert(_drawingController.getJsonList()),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  List<Map<String, dynamic>> tData = [
    {
      'type': 'SimpleLine',
      'startPoint': {'dx': 100.0, 'dy': 100.0},
      'endPoint': {'dx': 200.0, 'dy': 200.0},
      'paint': {
        'blendMode': 3,
        'color': 4294198070,
        'filterQuality': 3,
        'invertColors': false,
        'isAntiAlias': false,
        'strokeCap': 1,
        'strokeJoin': 1,
        'strokeWidth': 4.0,
        'style': 1,
      },
    },
    {
      'type': 'Eraser',
      'startPoint': {'dx': 150.0, 'dy': 150.0},
      'endPoint': {'dx': 250.0, 'dy': 250.0},
      'paint': {
        'blendMode': 3,
        'color': 4294198070,
        'filterQuality': 3,
        'invertColors': false,
        'isAntiAlias': false,
        'strokeCap': 1,
        'strokeJoin': 1,
        'strokeWidth': 10.0,
        'style': 1,
      },
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Croqui'),
        backgroundColor: Colors.teal,
        elevation: 8,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: _getImageData,
            tooltip: 'Salvar imagem',
          ),
          IconButton(
            icon: const Icon(Icons.data_array),
            onPressed: _getJson,
            tooltip: 'Ver JSON',
          ),
        ],
      ),
      body: Container(
        color: Colors.grey[400],
        child: Column(
          children: <Widget>[
            Padding(
                padding: const EdgeInsets.all(18.0),
                child: TextFormField(
                  controller: _titleController,
                  decoration: const InputDecoration(
                    labelText: 'Título do Croqui',
                    labelStyle: TextStyle(
                        fontSize: 15,
                        color: Colors.black54,
                        fontWeight: FontWeight.bold),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.teal, width: 2.0),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey),
                    ),
                    filled: true,
                    fillColor: Colors.white,
                    contentPadding:
                        EdgeInsets.symmetric(vertical: 10.0, horizontal: 16.0),
                  ),
                )),
            Expanded(
              child: LayoutBuilder(
                builder: (BuildContext context, BoxConstraints constraints) {
                  return DrawingBoard(
                    boardScaleEnabled: true,
                    boardConstrained: true,
                    controller: _drawingController,
                    background: Container(
                      width: constraints.maxWidth * 1,
                      height: constraints.maxHeight * 0.8,
                      color: Colors.white,
                      child: Padding(
                        padding: const EdgeInsets.only(top: 18.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              _titleController.text,
                              style: const TextStyle(
                                  fontFamily: 'Prototype', letterSpacing: 1),
                            ),
                          ],
                        ),
                      ),
                    ),
                    showDefaultActions: true,
                    showDefaultTools: true,
                    defaultToolsBuilder: (Type t, _) {
                      return DrawingBoard.defaultTools(t, _drawingController)
                        ..insert(
                          3,
                          DefToolItem(
                            icon: Icons.change_history_rounded,
                            isActive: t == Triangle,
                            onTap: () =>
                                _drawingController.setPaintContent = Triangle(),
                          ),
                        )
                        ..insert(
                          4,
                          DefToolItem(
                            icon: Icons.sensor_door_outlined,
                            isActive: t == Arc,
                            onTap: () =>
                                _drawingController.setPaintContent = Arc(),
                          ),
                        );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
