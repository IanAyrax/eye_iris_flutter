import 'package:flutter/material.dart';
//import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:eye_iris_app/models/result_model.dart';
import 'package:eye_iris_app/widgets/result_carousel.dart';
import 'package:eye_iris_app/widgets/result2_carousel.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  //int _selectedIndex = 0;
  // List<IconData> _icons =[
  //   FontAwesomeIcons.plane,
  //   FontAwesomeIcons.bed,
  //   FontAwesomeIcons.plane,
  //   FontAwesomeIcons.bed,
  // ];

  // Widget _buildIcon(int index) {
  //   return GestureDetector(
  //     onTap: (){
  //       setState(() {
  //         _selectedIndex = index;
  //       });
  //       print(_selectedIndex);
  //     },
  //       child : Container(
  //         height : 100.0,
  //         width  : 300.0,
  //         decoration: BoxDecoration(
  //           color: _selectedIndex == index
  //               ? Theme.of(context).accentColor
  //               : Color(0xFFE7EBEE),
  //           borderRadius: BorderRadius.circular(10.0),
  //         ),
  //         child: Icon(
  //           _icons[index],
  //           size: 25.0,
  //           color: _selectedIndex == index
  //               ? Theme.of(context).primaryColor
  //               : Color(0xFFB4C1C4),
  //         ),
  //       ),
  //   );
  // }
  @override
  Widget build(BuildContext context){
    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: EdgeInsets.symmetric(vertical: 30.0),
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(left: 20.0, right: 120.0),
              child: Text(
                'What would you like to do ?',
                style : TextStyle(
                  fontSize : 30.0,
                  fontWeight: FontWeight.bold,
                )
              ),
            ),
            SizedBox(height: 40.0),
            // Column(
            //   mainAxisAlignment: MainAxisAlignment.spaceAround,
            //   children: _icons.asMap().entries.map((MapEntry map) => _buildIcon(map.key)
            //   ).toList(),
            // ),
            SizedBox(height: 20.0),
            //ResultCarousel(),
            ResultCarousel(),
          ],
        ),
      ),
    );
  }
}