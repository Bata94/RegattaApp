// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:regatta_app/models/pause.dart';
import 'package:regatta_app/models/rennen.dart';
import 'package:regatta_app/services/api_request.dart';
import 'package:regatta_app/widgets/base_layout.dart';
import 'package:regatta_app/widgets/dialog.dart';
import 'package:regatta_app/widgets/easy_future_builder.dart';

class Pausen extends StatefulWidget {
  const Pausen({super.key});

  @override
  State<Pausen> createState() => _PausenState();
}

class _PausenState extends State<Pausen> {
  List<Rennen> rennenLs = [];
  List<Pause> pausenLs = [];
  double defPausenLaenge = 30;
  bool dataFetched = false;

  Future<bool> fetchData() async {
    List<Rennen> fetchedRennen = await fetchRennenAll();
    List<Pause> fetchedPausen = await fetchAllPausen();

    setState(() {
      rennenLs = fetchedRennen;
      pausenLs = fetchedPausen;
      dataFetched = true;
    });

    return true;
  }

  void neuePause(String nachRennenUuid) {
    setState(() {
      pausenLs.add(Pause(id: -1, laenge: defPausenLaenge.round(), nachRennenUuid: nachRennenUuid));
    });
  }

  Widget pauseCard(Pause pause, int i) {
    bool pending = pause.id == -1 ? true : false;
    return StatefulBuilder(builder: ((context, setPause) {
      double cardWidth = MediaQuery.of(context).size.width * .7;
      TextStyle cardTitleTheme = Theme.of(context).textTheme.titleLarge!;

      return Container(
        margin: const EdgeInsets.all(8),
        width: cardWidth,
        child: Card(
          color: Colors.green[200],
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.coffee,
                      color: pending ? Theme.of(context).colorScheme.error : null,
                    ),
                    const SizedBox(width: 16),
                    Text(
                      pending ? "Pause noch nicht gespeichert!" : "Pause:",
                      style: pending ? cardTitleTheme.copyWith(color: Theme.of(context).colorScheme.error) : cardTitleTheme,
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: cardWidth * 0.85,
                      child: Row(
                        children: [
                          Expanded(
                            child: Slider(
                              min: 5,
                              max: 120,
                              divisions: 23,
                              value: pause.laenge < 5 ? 5 : pause.laenge > 120 ? 120 : pause.laenge.toDouble(),
                              onChanged: (val) => setPause(() {
                                pending = true;
                                pause.laenge = val.round();
                              }),
                            ),
                          ),
                          const SizedBox(width: 16),
                          SizedBox(width: 120, child: Text("${pause.laenge} Minuten", style: Theme.of(context).textTheme.titleMedium,),),
                        ],
                      ),
                    ),
                    Row(
                      children: [
                        IconButton(
                          icon: Icon(Icons.delete, color: Theme.of(context).colorScheme.error, size: 32,),
                          onPressed: () async {
                            bool confirm = await dialogConfim(context, "Sind Sie sicher, dass Sie die Pause löschen möchten?");
                            if (!confirm) {return;}

                            if (pause.id != -1) {
                              dialogLoading(context);
                              ApiResponse res = await deletePause(pause);
                              Navigator.of(context).pop();
                              if (!res.status) {
                                dialogApiError(context, res);
                                return;
                              }
                            }

                            setState(() {
                              pausenLs.removeAt(i);                            
                            });
                          },
                        ),
                        IconButton(
                          icon: Icon(Icons.save, color: !pending ? Colors.grey : Theme.of(context).colorScheme.primary, size: 32,),
                          onPressed: !pending ? null : () async {
                            dialogLoading(context);
                            late Pause newPause;
                            if (pause.id == -1) {
                              newPause = await createPause(pause.laenge, pause.nachRennenUuid);
                            } else {
                              newPause = await updatePause(pause);
                            }

                            Navigator.of(context).pop();

                            setState(() {
                              pausenLs[i] = newPause;
                            });
                          }
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          )
        ),
      );
    }));
  }

  @override
  Widget build(BuildContext context) {
    if (!dataFetched) {
      return BaseLayout(
        "Regatta Pausen",
        easyFutureBuilder(
          fetchData(),
          (val) {
            if (!val) {
              return const Center(child: Text("Error!"),);
            } else {
              return const Center(child: Text("Redirect should be coming..."),);
            }
          }
        ),
      );
    } else {
      List<Widget> body = [];
      String lastWettkampf = "";

      for (Rennen rennen in rennenLs) {
        if (rennen.wettkampf != lastWettkampf) {
          lastWettkampf = rennen.wettkampf;
          body.add(
            Text(
              "$lastWettkampf:",
              style: Theme.of(context).textTheme.displaySmall,
            )
          );
          body.add(const Divider());
        }
        body.add(
          Card(
            margin: const EdgeInsets.all(8),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "$rennen",
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  IconButton(
                    icon: Icon(
                      Icons.add_circle,
                      size: 38,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    onPressed: () => neuePause(rennen.uuid),
                  ),
                ],
              ),
            ),
          ),
        );

        int i = 0;
        for (Pause pause in pausenLs) {
          if (rennen.uuid == pause.nachRennenUuid) {
            body.add(pauseCard(pause, i));
          }
          i++;
        }
      }


      return BaseLayout(
        "Regatta Pausen",
        SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.all(8.0),
            width: double.infinity,
            child: Column(
              children: body,
            ),
          ),
        ),
      );
    } 
  }
}
