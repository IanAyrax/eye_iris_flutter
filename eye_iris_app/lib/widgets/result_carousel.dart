import 'package:eye_iris_app/screens/detail_screen.dart';
import 'package:eye_iris_app/screens/camera_screen.dart';
import 'package:flutter/material.dart';
import 'package:eye_iris_app/models/result_model.dart';

class ResultCarousel extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    int _selectedIndex = 0;
    return Column(
      children: <Widget>[
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                'Past Result',
                style: TextStyle(
                  fontSize: 22.0,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.5,
                ),
              ),
              GestureDetector(
                onTap: () => print('See All'),
                child: Text(
                  'See All',
                  style: TextStyle(
                    color: Theme
                        .of(context)
                        .primaryColor,
                    fontSize: 16.0,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 1.0,
                  ),
                ),
              ),
            ],
          ),
        ),
        Container(
          width: double.infinity,
          height: 640,
          child: ListView.builder(
              scrollDirection: Axis.vertical,
              itemCount: results.length,
              itemBuilder: (BuildContext context, int index) {
                Result result = results[index];
                _selectedIndex = index;
                return GestureDetector(
                  onTap: () =>
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          //TODO: ADD route to detail page
                          builder: (_) => DetailScreen(selectedIndex: index),
                        ),
                      ),
                  child: Container(
                    margin: EdgeInsets.only(left: 20.0, top: 20.0),
                    width: 210,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: SingleChildScrollView(
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          ClipRRect(
                            borderRadius: BorderRadius.circular(20.0),
                            child: Image(
                              height: 120.0,
                              width: 120.0,
                              image: AssetImage(result.imageUrl),
                              fit: BoxFit.cover,
                              ),
                          ),
                          SizedBox(width: 25.0),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                'Classification : ',
                                style: TextStyle(
                                  fontSize: 22.0,
                                  fontWeight: FontWeight.w600,
                                  letterSpacing: 1.2,
                                ),
                              ),
                              Text(
                                result.classification,
                                style: TextStyle(
                                  fontSize: 22.0,
                                  fontWeight: FontWeight.w600,
                                  letterSpacing: 1.2,
                                ),
                              ),
                              Text(
                                result.date,
                                style: TextStyle(
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }
          ),
        ),
        SizedBox(height: 20.0),
        ElevatedButton(
            child: Text(
                "Take New Photo".toUpperCase(),
                style: TextStyle(
                  fontSize: 22.0,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 1.2,
                )
            ),
            style: ButtonStyle(
                foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
                backgroundColor: MaterialStateProperty.all<Color>(Colors.blue),
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        side: BorderSide(color: Colors.blue, width: 1000)
                    )
                )
            ),
            onPressed: () =>
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    //TODO: ADD route to detail page
                    builder: (_) => CameraScreen(),
                  ),
                ),
        )
      ],
    );
  }
}