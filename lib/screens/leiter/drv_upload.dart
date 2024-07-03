import 'dart:io';

import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:path/path.dart';
import 'package:regatta_app/services/api_request.dart';
import 'package:regatta_app/widgets/base_layout.dart';

class DrvUpload extends StatefulWidget {
  const DrvUpload({super.key});

  @override
  State<DrvUpload> createState() => _DrvUploadState();
}

class _DrvUploadState extends State<DrvUpload> {
  File? file;
  String fileStr = "Keine Datei ausgewählt...";
  String errorTxt = "";
  bool uploadPending = false;

  void handleUpload() async {
    if (file == null) {
      setState(() {
        errorTxt ="Bitte Datei auswählen!";
      });
      return;
    }

    setState(() {
      uploadPending = true;
    });

    ApiResponse res = await ApiRequester(baseUrl: ApiUrl.drvMeldUpload).uploadFile(file!);

    if (res.status) {
      setState(() {
        fileStr = "Erfolgreich hochgeladen! Keine Datei ausgewählen!";
        errorTxt = "";
        file = null;
        uploadPending = false;
      });
    } else {
      setState(() {
        errorTxt = "${res.error} - ${res.msg}";
        uploadPending = false;
      });
    }
  }

  void pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ["json"],
    );

    if (result != null) {
      setState(() {
        file = File(result.files.single.path!);
        fileStr = basename(file!.path);
        errorTxt = "";
      });
    } else {
      setState(() {
        errorTxt ="Auswahl wurde abgebrochen, bitte erneut versuchen!";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return BaseLayout(
      "DRV Meldungs Upload",
      Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              width: MediaQuery.of(context).size.width * .6,
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      Text(
                        "Wähle Datei zum Upload aus:",
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const Divider(
                        height: 20,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          GestureDetector(
                            onTap: pickFile,
                            child: SizedBox(
                              width: MediaQuery.of(context).size.width * .45,
                              child: Text(
                                fileStr,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.file_open),
                            onPressed: pickFile,
                          ),
                        ],
                      ),
                      Text(
                        errorTxt,
                        style: Theme.of(context).textTheme.titleSmall!.copyWith(color: Theme.of(context).colorScheme.error),
                      ),
                      ElevatedButton(
                        onPressed: uploadPending ? null : handleUpload,
                        child: SizedBox(
                          width: MediaQuery.of(context).size.width * .1,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              const Icon(Icons.file_upload),
                              Text(uploadPending ? "Bitte warten..." : "Upload"),
                            ],
                          ),
                        ),
                      ),
                    ],
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
