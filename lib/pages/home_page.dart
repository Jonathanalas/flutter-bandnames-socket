import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pie_chart/pie_chart.dart';
//mis importaciones
import 'package:band_names/services/socket_service.dart';
import 'package:band_names/models/band.dart';
enum LegendShape { circle, rectangle }

class HomePage extends StatefulWidget {
  
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  List<Band> bands = [
    /*Band(id: '1',name: 'Metalica',votes: 4),
    Band(id: '2',name: 'Mago de Oz',votes: 10),
    Band(id: '3',name: 'Nigga',votes: 90),
    Band(id: '4',name: 'Panda',votes: 14)*/
  ];
  @override
  void initState() {
     final socketService  = Provider.of<SocketService>(context,listen: false);

     socketService.socket.on('active-bands',_handleActiveBands);
    super.initState();
  }
  _handleActiveBands(dynamic payload){
    this.bands = (payload as List).map((band) => Band.formMap(band)).toList();
      setState(() {});
  }
  @override
  void dispose() {
    final socketService  = Provider.of<SocketService>(context,listen: false);

     socketService.socket.off('active-bands');// se deja de escuchar
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
     final socketService  = Provider.of<SocketService>(context);
     
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: Text('BandNames',style: TextStyle(color: Colors.black87),),
          elevation: 1.0,
          actions: [
            Container(
              child: (socketService.serverStatus==ServerStatus.Online)? Icon(Icons.check_circle,color: Colors.blue[300],)
              : Icon(Icons.offline_bolt,color: Colors.red[300],)
            )
          ],
        ),
        body: Column(children: [
          _showGraph(),
          Expanded(child: ListView.builder(itemCount: bands.length,
                                          itemBuilder: (context,  i)=> _bandTitle(bands[i])
          )
          )
        ],),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        elevation: 1.0,
        onPressed: addNewBand
        ),
      );
  }

  Widget _bandTitle(Band band) {
    final socketService = Provider.of<SocketService>(context,listen: false);
    return Dismissible(
      key: Key(band.id),
      direction: DismissDirection.startToEnd,
      onDismissed: (_) => socketService.emit('delete-band',{'id':band.id}),
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
              onTap: () => socketService.emit('vote-band',{'id':band.id})
              ),
    );
  }

  addNewBand(){
    final textController = TextEditingController();

    if(Platform.isAndroid){
      //Android
        showDialog(
        context: context, 
        builder: (_)=> AlertDialog(
            title: Text('New band name'),
            content: TextField(
              controller: textController,
            ),
            actions: [MaterialButton(
            onPressed: ()=> addBandList(textController.text),
            child: Text('Add'),
            textColor: Colors.blue,
            elevation: 5.0,)],
          )
        );
    }else if(Platform.isIOS){
       showCupertinoDialog(
       context: context, 
       builder: (_)=> CupertinoAlertDialog(
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
              onPressed: (){
                Navigator.pop(context);
                },
              )
          ],
        )
       );
    }
  }

  void addBandList(String name){
    
    if(name.length>1)
    { //agregar band
      final socketService = Provider.of<SocketService>(context,listen: false);
      socketService.emit('add-band',{'name':name});
      /*this.bands.add(new Band(id: DateTime.now().toString(), name: name, votes: 0));*/
      //setState(() {});
    }
    Navigator.pop(context);
  }
    Widget _showGraph(){
      Map<String, double> dataMap = {
                                    "Flutter": 5,
                                   // "React": 3,
                                    //"Xamarin": 2,
                                   // "Ionic": 2
                                    };
      bands.forEach((band){
        dataMap.putIfAbsent(band.name, () => band.votes.toDouble());
      });
     final List<Color> colorList = <Color>[
        const Color(0xfffdcb6e),
        const Color(0xff0984e3),
        const Color(0xfffd79a8),
        const Color(0xffe17055),
        const Color(0xff6c5ce7),
      ];
        LegendShape? _legendShape = LegendShape.circle;

      return Container(
        padding: EdgeInsets.only(top: 10),
        width: double.infinity,
        height: 200.0,
        child: PieChart(
      dataMap: dataMap,
      animationDuration: Duration(milliseconds: 800),
      chartLegendSpacing: 32,
      chartRadius: MediaQuery.of(context).size.width / 3.2,
      colorList: colorList,
      initialAngleInDegree: 0,
      chartType: ChartType.ring,
      ringStrokeWidth: 30,
      centerText: "",
      legendOptions: LegendOptions(
        showLegendsInRow: false,
        legendPosition: LegendPosition.right,
        showLegends: true,
        legendShape: _legendShape == LegendShape.circle
            ? BoxShape.circle
            : BoxShape.rectangle,
        legendTextStyle: TextStyle(
          fontWeight: FontWeight.bold,
        ),
      ),
      chartValuesOptions: ChartValuesOptions(
        showChartValueBackground: true,
        showChartValues: true,
        showChartValuesInPercentage: true,
        showChartValuesOutside: true,
        decimalPlaces: 0,
      ),
      // gradientList: ---To add gradient colors---
      // emptyColorGradient: ---Empty Color gradient---
    ));//PieChart(dataMap: dataMap));
    }
}