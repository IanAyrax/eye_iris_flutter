import 'package:eye_iris_app/screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:eye_iris_app/models/result_model.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class Result2Carousel extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Expanded(
          child : ListView.builder(
            itemCount: results.length,
            itemBuilder: (BuildContext context, int index){
              Result result = results[index];
              return Stack(
                children : <Widget>[
                  Container(
                    margin: EdgeInsets.fromLTRB(40.0, 5.0, 20.0, 5.0),
                    height: 170,
                    width: double.infinity,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20.0)
                    ),
                    child: Column(
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            Text(
                                result.classification,
                                style : TextStyle(
                                  color: Colors.black,
                                )
                            ),
                         ],
                        ),
                      ],
                    ),
                  )
                ]
              );
            },
          ),
        )
    );
  }
}