import 'package:flutter/material.dart';
import 'package:flutter_booking_app/main.dart';
import 'package:flutter_booking_app/models/tutor.dart';
import 'package:flutter_booking_app/pages/home.dart';

class ProductDetails extends StatefulWidget {
  final Tutor tutor;

  ProductDetails({required this.tutor});

  @override
  State<ProductDetails> createState() => _ProductDetailsState();
}

class _ProductDetailsState extends State<ProductDetails> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        elevation: 0.1,
        backgroundColor: Colors.red,
        title: InkWell(
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => new HomePage()));
            },
            child: Text('Find A Tutor For YOu')),
        actions: <Widget>[
          new IconButton(
              icon: Icon(
                Icons.search,
                color: Colors.white,
              ),
              onPressed: null),
        ],
      ),
      body: new ListView(
        children: <Widget>[
          new Container(
            height: 300.0,
            child: GridTile(
              child: Container(
                color: Colors.white70,
                child: Image.asset(widget.tutor.avatar),
              ),
              footer: new Container(
                color: Colors.white70,
                child: ListTile(
                  leading: new Text(
                    widget.tutor.name,
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0),
                  ),
                  title: new Row(
                    children: <Widget>[
                      Expanded(
                          child: new Text(
                        "\$${widget.tutor.price}",
                        style: TextStyle(
                            color: Colors.grey,
                            decoration: TextDecoration.lineThrough),
                      )),
                      Expanded(
                          child: new Text(
                        "\$${widget.tutor.price}",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.red),
                      )),
                    ],
                  ),
                ),
              ),
            ),
          ),

          //the first buttons
          Row(
            children: <Widget>[
              Expanded(
                child: MaterialButton(
                  onPressed: () {
                    showDialog(
                        context: context,
                        builder: (context) {
                          return new AlertDialog(
                            title: new Text("Subject"),
                            content: new Text("Choose the subject"),
                            actions: <Widget>[
                              new MaterialButton(
                                onPressed: () {
                                  Navigator.of(context).pop(context);
                                },
                                child: new Text("close"),
                              )
                            ],
                          );
                        });
                  },
                  color: Colors.white,
                  textColor: Colors.grey,
                  elevation: 0.2,
                  child: Row(
                    children: <Widget>[
                      Expanded(child: new Text("Subject")),
                      Expanded(child: new Icon(Icons.arrow_drop_down))
                    ],
                  ),
                ),
              ),
              //the color button
              Expanded(
                child: MaterialButton(
                  onPressed: () {
                    showDialog(
                        context: context,
                        builder: (context) {
                          return new AlertDialog(
                            title: new Text("Setting"),
                            content: new Text("In person or Virtual"),
                            actions: <Widget>[
                              new MaterialButton(
                                onPressed: () {
                                  Navigator.of(context).pop(context);
                                },
                                child: new Text("close"),
                              )
                            ],
                          );
                        });
                  },
                  color: Colors.white,
                  textColor: Colors.grey,
                  elevation: 0.2,
                  child: Row(
                    children: <Widget>[
                      Expanded(child: new Text("Setting")),
                      Expanded(child: new Icon(Icons.arrow_drop_down))
                    ],
                  ),
                ),
              ),
              Expanded(
                child: MaterialButton(
                  onPressed: () {
                    showDialog(
                        context: context,
                        builder: (context) {
                          return new AlertDialog(
                            title: new Text("Quantity"),
                            content: new Text(
                                "Choose the number of sessions quantity"),
                            actions: <Widget>[
                              new MaterialButton(
                                onPressed: () {
                                  Navigator.of(context).pop(context);
                                },
                                child: new Text("close"),
                              )
                            ],
                          );
                        });
                  },
                  color: Colors.white,
                  textColor: Colors.grey,
                  elevation: 0.2,
                  child: Row(
                    children: <Widget>[
                      Expanded(child: new Text("Qty")),
                      Expanded(child: new Icon(Icons.arrow_drop_down)),
                    ],
                  ),
                ),
              ),
            ],
          ),

          //second button
          Row(
            children: <Widget>[
              Expanded(
                child: MaterialButton(
                    onPressed: () {},
                    color: Colors.red,
                    textColor: Colors.white,
                    elevation: 0.2,
                    child: new Text("Book")),
              ),
              new IconButton(
                  icon: Icon(Icons.add_shopping_cart, color: Colors.red),
                  onPressed: () {}),
              new IconButton(
                  icon: Icon(Icons.favorite_border),
                  color: Colors.red,
                  onPressed: () {}),
            ],
          ),
          Divider(),
          new ListTile(
            title: new Text("Tutor details"),
            subtitle: new Text(widget.tutor.bio),
          ),
          Divider(),
          new Row(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.fromLTRB(12.0, 5.0, 5.0, 5.0),
                child: new Text(
                  "Tutor's Name",
                  style: TextStyle(color: Colors.grey),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(5.0),
                child: new Text(widget.tutor.name),
              )
            ],
          ),

          new Row(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.fromLTRB(12.0, 5.0, 5.0, 5.0),
                child: new Text(
                  "Tutor's Experience",
                  style: TextStyle(color: Colors.grey),
                ),
              ),
              //create product brand later!!
              Padding(
                padding: EdgeInsets.all(5.0),
                child: new Text("4 years"),
              )
            ],
          ),
//Add the product condition
          new Row(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.fromLTRB(12.0, 5.0, 5.0, 5.0),
                child: new Text(
                  "Tutor's Rating",
                  style: TextStyle(color: Colors.grey),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(5.0),
                child: new Text(".."),
              )
            ],
          ),
          Divider(),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: new Text("Similar tutors"),
          ),
          //similar product section
          Container(
            height: 340.0,
            child: Similar_Tutors(),
          )
        ],
      ),
    );
  }
}

class Similar_Tutors extends StatefulWidget {
  @override
  State<Similar_Tutors> createState() => _Similar_TutorsState();
}

class _Similar_TutorsState extends State<Similar_Tutors> {
  @override
  var product_list = [
    {
      "name": "Ken",
      "picture": "assets/images/c2.jpg",
      "old_price": 120,
      "price": 85,
    },
    {
      "name": "Kelly",
      "picture": "assets/images/c2.jpg",
      "old_price": 100,
      "price": 50,
    },
    {
      "name": "Amber",
      "picture": "assets/images/c3.jpg",
      "old_price": 100,
      "price": 50,
    },
    {
      "name": "Jamar",
      "picture": "assets/images/c3.jpg",
      "old_price": 100,
      "price": 50,
    },
    {
      "name": "Donald",
      "picture": "assets/images/c3.jpg",
      "old_price": 100,
      "price": 50,
    },
    {
      "name": "Simone",
      "picture": "assets/images/c3.jpg",
      "old_price": 100,
      "price": 50,
    }
  ];
  @override
  Widget build(BuildContext context) {
    final tutors = [];
    return GridView.builder(
        itemCount: tutors.length,
        gridDelegate:
            new SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
        itemBuilder: (BuildContext context, int index) {
          return Similar_single_prod(tutor: tutors[index]);
        });
  }
}

class Similar_single_prod extends StatelessWidget {
  final Tutor tutor;

  Similar_single_prod({
    required this.tutor,
  });
  @override
  Widget build(BuildContext context) {
    return Card(
      child: Hero(
          tag: new Text("hero 1"),
          child: Material(
            child: InkWell(
              onTap: () => Navigator.of(context).push(new MaterialPageRoute(
                  //here we are passing the values of the product to the product detail page
                  builder: (context) => new ProductDetails(
                        tutor: tutor,
                      ))),
              child: GridTile(
                  footer: Container(
                    color: Colors.white,
                    child: new Row(
                      children: <Widget>[
                        Expanded(
                          child: Text(
                            tutor.name,
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 16.0),
                          ),
                        ),
                        new Text(
                          "\$${tutor.price}",
                          style: TextStyle(
                              color: Colors.red, fontWeight: FontWeight.bold),
                        )
                      ],
                    ),
                  ),
                  child: Image.asset(
                    tutor.avatar,
                    fit: BoxFit.cover,
                  )),
            ),
          )),
    );
  }
}
