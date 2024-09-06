import 'package:band_names/services/socket_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


class StatusPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final socketService = Provider.of<SocketService>(context);
  return Scaffold(
     body: Center (
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('Server Status: ${ socketService.serverStatus }')
        ],
      )
     ),
     floatingActionButton: FloatingActionButton(
      child: Icon(Icons.message),
      onPressed: (){
        //Tarea enviar emit datos
        //socketService.socket.emit('emitir-mensaje',{'nombre':'Jonathan','mensaje':'hola mundo','mensaje2':'Magda'});
        socketService.emit('emitir-mensaje',{'nombre':'Jonathan','mensaje':'hola mundo','mensaje2':'Magda'});
     }),
    );
  }
}