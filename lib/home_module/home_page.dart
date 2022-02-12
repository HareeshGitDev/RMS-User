import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';


class HomePage extends StatefulWidget {
   HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  @override
  Widget build(BuildContext context) {
     return Scaffold(

      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 4,
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text('RMS Home Page'),
      ),
      bottomNavigationBar:CurvedNavigationBar(
        backgroundColor: Colors.blueGrey,
        items: const <Widget>[
          Icon(Icons.add, size: 30),
          Icon(Icons.list, size: 30),
          Icon(Icons.compare_arrows, size: 30),
          Icon(Icons.add,size: 30,),
          Icon(Icons.list,size: 30,)],

        onTap: (index){
        },
      ),
      body:Container( child: Center(child: Text("Hii"))) ,
      floatingActionButton: FloatingActionButton(
        tooltip: 'Increment',
        onPressed: () {  },
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
