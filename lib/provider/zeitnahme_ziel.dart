import 'dart:async';
import 'dart:collection';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:regatta_app/models/zeitnahme.dart';
import 'package:regatta_app/services/api_request.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

// TODO: Handle WS reconnect if Connection closes
// TODO: Give User Feedback if Connection is alive
// TODO: Connect to WS with UserID
// TODO: Give User Feedback for Successful Zeitnahme

class ZeitnahmeZielProvider with ChangeNotifier {
  bool _websocketInitialized = false;
  late WebSocketChannel _channel;
  late Stream _channelStream;
  List<Zeitnahme> _zieleinlaufLS = [];
  final Uri _wsUri = Uri(
    scheme: "ws",
    host: ApiUrl.host,
    port: ApiUrl.port,
    path: "api/v1/zeitnahme/ziel",
  );
  int curLatency = 0;

  UnmodifiableListView<Zeitnahme> get zieleinlaufLS =>
      UnmodifiableListView(_zieleinlaufLS);

  void init() async {
    if (_websocketInitialized) {
      return;
    }
    _channel = WebSocketChannel.connect(_wsUri);
    await _channel.ready;
    _channelStream = _channel.stream;
    _websocketInitialized = true;

    _channelStream.listen(computeWSMessage);
  }

  void closeConnection() {
    _channel.sink.close();

    _zieleinlaufLS = [];
    _websocketInitialized = false;
  }

  @override
  void dispose() {
    closeConnection();
    super.dispose();
  }

  void ensureOpenConnection() {
    _channel.sink.add(
      jsonEncode(
        {
          "method": "ping",
          "data": {},
        },
      ),
    );
  }

  void computeWSMessage(dynamic wsMsg) {
    debugPrint(wsMsg.toString());

    if (wsMsg == "pong") {
      return;
    }

    // TODO: Error Catch
    Map<String, dynamic> wsMsgMap = jsonDecode(wsMsg);

    if (wsMsgMap.containsKey("list")) {
      _zieleinlaufLS = [];
      for (dynamic entry in wsMsgMap['list']) {
        _zieleinlaufLS.add(
          Zeitnahme.fromJson(
            entry,
          ),
        );
      }
    } else if (wsMsgMap.containsKey("new")) {
      _zieleinlaufLS.insert(
        0,
        Zeitnahme.fromJson(
          wsMsgMap['new'],
        ),
      );
    } else if (wsMsgMap.containsKey("update")) {
      for (Zeitnahme zeitnahme in _zieleinlaufLS) {
        if (wsMsgMap['update']['id'] == zeitnahme.id) {
          zeitnahme.startNummer = wsMsgMap['update']['start_nummer'];
        }
      }
    } else if (wsMsgMap.containsKey("delete")) {
      _zieleinlaufLS
          .removeWhere((element) => element.id == wsMsgMap["delete"]["id"]);
    }

    notifyListeners();
  }

  void newZieleinlauf() {
    DateTime now = DateTime.now();
    Map msgBody = {
      "method": "post",
      "data": {
        "time_client": now.toIso8601String()+"Z",
        "measured_latency": curLatency,
      }
    };
    debugPrint(msgBody.toString());

    _channel.sink.add(
      jsonEncode(msgBody),
    );
  }

  void deleteZieleinlauf(int zieleinlaufID) {
    _channel.sink.add(
      jsonEncode(
        {
          "method": "delete",
          "data": {
            "id": zieleinlaufID,
          }
        },
      ),
    );
  }

  void setStartnummer(int zieleinlaufID, String startnummer) {
    _channel.sink.add(
      jsonEncode(
        {
          "method": "put",
          "data": {
            "id": zieleinlaufID,
            "start_nummer": startnummer,
          }
        },
      ),
    );
  }

  void reloadList() {
    _channel.sink.add(
      jsonEncode(
        {
          "method": "get",
          "data": {},
        },
      ),
    );
  }
}

