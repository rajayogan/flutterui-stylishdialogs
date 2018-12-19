import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:stylingdialogs/reviewservice.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List allReviews = [];

  bool reviewsLoaded = false;

  void initState() {
    super.initState();
    ReviewService().getAllReviews().then((QuerySnapshot docs) {
      allReviews = [];
      setState(() {
        allReviews = docs.documents;
        reviewsLoaded = true;
      });
    }).catchError((e) {
      print(e);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Styling Alerts'),
          backgroundColor: Colors.teal,
          centerTitle: true,
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Center(
                child: reviewsLoaded
                    ? Text(allReviews[0].data['reviewMade'])
                    : Container()),
            RaisedButton(
              child: Text('Show more'),
              elevation: 4.0,
              color: Colors.teal,
              textColor: Colors.white,
              onPressed: () {
                showReview(context, allReviews[0].data);
              },
            ),
            RaisedButton(
              child: Text('Default'),
              elevation: 4.0,
              color: Colors.teal,
              textColor: Colors.white,
              onPressed: () {
                infoDialog(context, allReviews[0].data);
              },
            )
          ],
        ));
  }
}

Future<bool> infoDialog(context, review) {
  return showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Review'),
          content: Text(review['reviewMade']),
          actions: <Widget>[
            FlatButton(
              child: Text('Okay'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            )
          ],
        );
      });
}

Future<bool> showReview(context, review) {
  return showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return Dialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0)),
            child: Container(
                height: 350.0,
                width: 200.0,
                decoration:
                    BoxDecoration(borderRadius: BorderRadius.circular(20.0)),
                child: Column(
                  children: <Widget>[
                    Stack(
                      children: <Widget>[
                        Container(height: 150.0),
                        Container(
                          height: 100.0,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(10.0),
                                topRight: Radius.circular(10.0),
                              ),
                              color: Colors.teal),
                        ),
                        Positioned(
                            top: 50.0,
                            left: 94.0,
                            child: Container(
                              height: 90.0,
                              width: 90.0,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(45.0),
                                  border: Border.all(
                                      color: Colors.white,
                                      style: BorderStyle.solid,
                                      width: 2.0),
                                  image: DecorationImage(
                                      image:
                                          NetworkImage(review['reviewerPic']),
                                      fit: BoxFit.cover)),
                            ))
                      ],
                    ),
                    SizedBox(height: 20.0),
                    Padding(
                        padding: EdgeInsets.all(10.0),
                        child: Text(
                          review['reviewMade'],
                          style: TextStyle(
                            fontFamily: 'Quicksand',
                            fontSize: 14.0,
                            fontWeight: FontWeight.w300,
                          ),
                        )),
                    SizedBox(height: 15.0),
                    FlatButton(
                      child: Center(
                        child: Text(
                          'OKAY',
                          style: TextStyle(
                              fontFamily: 'Montserrat',
                              fontSize: 14.0,
                              color: Colors.teal),
                        ),
                      ),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      color: Colors.transparent
                    )
                  ],
                )));
      });
}
