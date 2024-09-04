// ignore_for_file: use_build_context_synchronously

import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:regatta_app/services/api_request.dart';
import 'package:regatta_app/widgets/base_layout.dart';
import 'package:regatta_app/widgets/clickable_listtile.dart';
import 'package:regatta_app/widgets/dialog.dart';
import 'package:regatta_app/widgets/easy_future_builder.dart';
import 'dart:io' as io;

class LeitungMeldeergebnis extends StatefulWidget {
  const LeitungMeldeergebnis({super.key});

  @override
  State<LeitungMeldeergebnis> createState() => _LeitungMeldeergebnisState();
}

class _LeitungMeldeergebnisState extends State<LeitungMeldeergebnis> {
  List<String> fileLs = [];

  Future<List<String>> queryFileList() async {
    ApiResponse res = await ApiRequester(baseUrl: ApiUrl.listMeldeergebnis).get();

    if (!res.status) {
      throw Exception(res.msg);
    }

    List<String> ret = [];
    if (res.data != null && !res.data.isEmpty) {
      for (var d in res.data.reversed) {
        ret.add(d.toString());
      }

    }
    return ret;
  }

  void downloadMeldeergebnis(String filename) async {
    dialogLoading(context);
    Uint8List? downloaded = await ApiRequester(baseUrl: ApiUrl.downloadMeldeergebnis).downloadFile(filename);

    Navigator.of(context).pop();
    await Future.delayed(const Duration(milliseconds: 50));

    if (downloaded != null) {
      pdfDialog(downloaded, filename);
    } else {
      dialogError(context, "Fehler beim Herunterladen", "Fehler beim Herunterladen der Datei. Versuchen Sie es später erneut. Sollte der Fehler weiterhin bestehen, wenden Sie sich an den Administrator.");
    }
  }

  void createMeldeergebnis() async {
    dialogLoading(context);
    
    Uint8List? downloaded = await ApiRequester(baseUrl: ApiUrl.createMeldeergebnis).downloadFilePost();

    Navigator.of(context).pop();
    await Future.delayed(const Duration(milliseconds: 50));

    setState(() => fileLs = []);

    if (downloaded != null) {
      pdfDialog(downloaded, "Neues Meldeergebnis");
    } else {
      dialogError(context, "Fehler beim Herunterladen", "Fehler beim Herunterladen der Datei. Versuchen Sie es später erneut. Sollte der Fehler weiterhin bestehen, wenden Sie sich an den Administrator.");
    }
  }

  void pdfDialog(Uint8List data, String filename) {
    showDialog(
      context: context,
      builder: (context) => BaseLayout(
        filename,
        PDFView(
          pdfData: data,
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () async {
            String? outputFile = await FilePicker.platform.saveFile(
              dialogTitle: 'Save Your File to desired location',
              fileName: filename,
            );
             
            try {
              io.File returnedFile = io.File('$outputFile');
              await returnedFile.writeAsBytes(data);
            } catch (e) {
              debugPrint(e.toString());
              dialogError(context, "Fehler beim speichern", e.toString());
            }
          },
          child: const Icon(Icons.save_as),
        ),
      )
    );
  }

  Widget fileListWidget() {
    if (fileLs.isEmpty) {
      return const Center(
        child: Text(
          "Noch kein Meldeergebnis erstellt!\nUm eins zu erstellen klicken Sie den Add-Button am unteren rechten Bildschirmrand.",
        ),
      );
    }
    return ListView.builder(
      itemCount: fileLs.length,
      itemBuilder: (context, int i) => ClickableListTile(
        title: fileLs[i],
        onTap: () => downloadMeldeergebnis(fileLs[i]),
        ),
      );
  }


  Widget _body() {
    if (fileLs.isEmpty) {
      return easyFutureBuilder(
        queryFileList(),
        (data) {
          fileLs = data;
          return fileListWidget();
        },
      );
    } else {
      return fileListWidget();
    }
  }

  @override
  Widget build(BuildContext context) {
    return BaseLayout(
      "Meldeergebnise",
      _body(),
      floatingActionButton: FloatingActionButton(
        onPressed: createMeldeergebnis,
        child: const Icon(Icons.add),
      ),  
    );
  }
}
