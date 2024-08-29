import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:band_names/models/band.dart';
class HomePage extends StatefulWidget {
  
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  List<Band> bands = [
    Band(id: '1',name: 'Metalica',votes: 4),
    Band(id: '2',name: 'Mago de Oz',votes: 10),
    Band(id: '3',name: 'Nigga',votes: 90),
    Band(id: '4',name: 'Panda',votes: 14)
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: Text('BandNames',style: TextStyle(color: Colors.black87),),
          elevation: 1.0,
        ),
        body: ListView.builder(
          itemCount: bands.length,
          itemBuilder: (context,  i)=> _bandTitle(bands[i])
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        elevation: 1.0,
        onPressed: addNewBand
        ),
      );
  }

  Widget _bandTitle(Band band) {
    return Dismissible(
      key: Key(band.id),
      direction: DismissDirection.startToEnd,
      onDismissed: (direction) {
        print('direction: $direction');
        print('id: ${band.id}');
        //Todo:llamar el borrado server
      },
      background: Container(
        padding: EdgeInsets.only(left: 8.0),
        color: Colors.red,
        child: Align(
          alignment: Alignment.centerLeft,
          child: Text('Delete Band',style: TextStyle(color: Colors.white),)),),
      child: ListTile(
              leading: CircleAvatar(
                child: Text(band.name.substring(0,2)),
                backgroundColor: Colors.blue[100],
              ),
              title: Text(band.name),
              trailing: Text('${ band.votes }',style: TextStyle(fontSize: 20),),
              onTap: () {
                print(band.name);
              },
              ),
    );
  }

  addNewBand(){
    final textController = TextEditingController();

    if(Platform.isAndroid){
      //Android
        showDialog(
        context: context, 
        builder: (context){
          return AlertDialog(
            title: Text('New band name'),
            content: TextField(
              controller: textController,
            ),
            actions: [MaterialButton(
            onPressed: ()=> addBandList(textController.text),
            child: Text('Add'),
            textColor: Colors.blue,
            elevation: 5.0,)],
          );
        });
    }else if(Platform.isIOS){
       showCupertinoDialog(
       context: context, 
       builder: (_){
        return CupertinoAlertDialog(
          title: Text('New band name'),
          content: CupertinoTextField(
            controller: textController,
          ),
          actions: [
            CupertinoDialogAction(
              isDefaultAction: true,
              child: Text('Add'),
              textStyle: TextStyle(color: Colors.blue),
              onPressed: ()=> addBandList(textController.text),
              ),
              CupertinoDialogAction(
              isDestructiveAction: true,
              child: Text('Dismiss'),
              textStyle: TextStyle(color: Colors.red),
              onPressed: ()=> Navigator.pop(context),
              )
          ],
        );
       });
    }
  }

  void addBandList(String name){

    if(name.length>1)
    { //agregar band
      this.bands.add(new Band(id: DateTime.now().toString(), name: name, votes: 0));
      setState(() {});
    }
    Navigator.pop(context);
  }
}