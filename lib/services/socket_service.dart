

import 'package:flutter/material.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:socket_io_client/socket_io_client.dart';

enum ServerStatus {
  Online,
  Offline,
  Connecting
}
class SocketService with ChangeNotifier{
  
  ServerStatus _serverStatus= ServerStatus.Connecting;
  late IO.Socket _socket;
  ServerStatus get serverStatus => this._serverStatus;
  IO.Socket get socket=> this._socket;
  Function get emit => this._socket.emit;
  
  SocketService(){
    this._initConfig();

  }

  void _initConfig(){
    // Dart client
    _socket = IO.io('http://localhost:3000',{
      'transports':['websocket'],
      'autoConnect': true
    }
    /*,OptionBuilder()
      .setTransports(['websocket']) // for Flutter or Dart VM
      .enableAutoConnect()  // disable auto-connection
      .build()*/
    );
    socket.onConnect((_) {
      print('connect');
      this._serverStatus = ServerStatus.Online;
      notifyListeners();
    });
    
    socket.onDisconnect((_){ 
      this._serverStatus = ServerStatus.Offline;
      print('disconnect');
      notifyListeners();
      });
  }
}