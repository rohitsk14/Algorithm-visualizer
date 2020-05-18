import 'package:algov/searching_screen.dart';
import 'package:flutter/material.dart';
import 'package:algov/sorting_screen.dart';
import 'package:google_fonts/google_fonts.dart';

class myDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: SafeArea(
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(18.0),
              child: Text(
                'Menu',
                style: GoogleFonts.oswald(fontSize: 25),
              ),
            ),
            Divider(),
            ListTile(
              leading: Icon(Icons.search),
              title: Text('Search Algorithms'),
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => searchingScreen()));
              },
            ),
            ListTile(
              leading: Icon(Icons.sort),
              title: Text('Sorting Algorithms'),
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => sortingScreen()));
              },
            ),
            Expanded(
                child: Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                padding: EdgeInsets.all(10.0),
                child: Text(
                  'rohitkhairnar42@gmail.com',
                  style: GoogleFonts.handlee(fontSize: 15),
                ),
              ),
            )),
          ],
        ),
      ),
    );
  }
}
