import 'package:ac_app/bloc/bloc_temprature.dart';
import 'package:ac_app/model/temprature_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'ProgressDialog.dart';

class MainMenu extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _MainMenuState();
  }
}

class _MainMenuState extends State<MainMenu> {
  String selectedTempt;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    bloc.getTemprature();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    listenTemprature();
    listenLoading();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1.0,
        centerTitle: true,
        leading: IconButton(
          onPressed: () => _showMessageOption(),
          icon: Icon(Icons.add, color: Colors.black54),
        ),
        title: Text("Monitoring Suhu",
            style: TextStyle(
              color: Colors.black54,
              fontWeight: FontWeight.bold,
              fontSize: 18,
            )),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 10),
            child: IconButton(
              onPressed: () => bloc.getTemprature(),
              icon: Icon(Icons.refresh, color: Colors.black54),
            ),
          )
        ],
      ),
      body: Container(
        padding: EdgeInsets.all(10.0),
        child: StreamBuilder<TempratureModel>(
            stream: bloc.setDefaultTempratureBloc,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return _tempratureWidget(snapshot.data.defaultTemp.toString(),
                    snapshot.data.temprature.toString());
              } else {
                return _tempratureWidget("0", "0");
              }
            }),
      ),
    );
  }

  Widget _tempratureWidget(String defaultTemp, String tempratureRoom) {
    return ProgressDialog(
      inAsyncCall: isLoading,
      child: Column(
        children: [
          Expanded(
            child: Card(
              color: Colors.red,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      "Temp. AC",
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      alignment: FractionalOffset.center,
                      child: Text(
                        "$defaultTemp° C",
                        style: TextStyle(fontSize: 70, color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: Card(
              color: Colors.blue,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      "Temp. Ruangan",
                      // textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      alignment: FractionalOffset.center,
                      child: Text(
                        "$tempratureRoom° C",
                        style: TextStyle(fontSize: 70, color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  _showMessageOption() {
    return showModalBottomSheet(
      context: context,
      elevation: 4,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height / 5,
        width: MediaQuery.of(context).size.width,
        child: Container(
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(10),
                    topRight: Radius.circular(10))),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                StreamBuilder<String>(
                    stream: bloc.setTempratureBloc,
                    builder: (context, snapshot) {
                      return Card(

                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                            elevation: 4,
                            items: <String>[
                              '16',
                              '17',
                              '18',
                              '19',
                              '20',
                              '21',
                              '22',
                              '23',
                              '24',
                              '25',
                              '26',
                              '27',
                              '28',
                              '29',
                              '30'
                            ].map((String value) {
                              return new DropdownMenuItem<String>(
                                value: value,
                                child: new Text(value),
                              );
                            }).toList(),
                            onChanged: (value) => bloc.setTemprature(value),
                            hint: new Text(
                              "Select Temprature",
                              style: TextStyle(fontSize: 18),
                            ),
                            value: snapshot.data,
                          ),
                        ),
                      );
                    }),
                Expanded(

                  child: RaisedButton(
                    color: Colors.blue,
                    onPressed: () => actionUpdate(),
                    child: Text("SET"),
                  ),
                )
              ],
            )),
      ),
    );
  }

  actionUpdate() {
    final Map<String, dynamic> param = {
      "temprature": double.parse(selectedTempt)
    };
    bloc.setDefaultTemprature(param);
  }

  listenTemprature() {
    bloc.setTempratureBloc.listen((event) {
      setState(() => selectedTempt = event);
    });
  }

  listenLoading() {
    bloc.setLoadingBloc.listen((event) {
      setState(() {
        if (event) {
          Navigator.of(context).pop();
        }
        isLoading = event;
      });
    });
  }
}
