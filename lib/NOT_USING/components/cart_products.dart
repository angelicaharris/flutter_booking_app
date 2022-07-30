import 'package:flutter/material.dart';

//my imports
//import 'package:flutter_booking_app/components/cart_Tutors.dart';

class Cart_Tutors extends StatefulWidget {
  const Cart_Tutors({Key? key}) : super(key: key);

  @override
  State<Cart_Tutors> createState() => _Cart_TutorsState();
}

class _Cart_TutorsState extends State<Cart_Tutors> {
  var Tutors_on_the_cart = [
    {
      "name": "James",
      "picture": "assets/images/c5.png",
      "price": 50,
      "size": "ACT Reading",
      "color": "3",
      "quantity": 1,
    },
    {
      "name": "Ken",
      "picture": "assets/images/c6.png",
      "price": 55,
      "size": "ACT Math",
      "color": "5",
      "quantity": 1,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return new ListView.builder(
      itemCount: Tutors_on_the_cart.length,
      itemBuilder: (context, index) {
        return Single_cart_product(
            cart_prod_name: Tutors_on_the_cart[index]["name"],
            cart_prod_color: Tutors_on_the_cart[index]["color"],
            cart_prod_qty: Tutors_on_the_cart[index]["quantity"],
            cart_prod_size: Tutors_on_the_cart[index]["size"],
            cart_prod_price: Tutors_on_the_cart[index]["price"],
            cart_prod_picture: Tutors_on_the_cart[index]["picture"]);
      },
    );
  }
}

class Single_cart_product extends StatelessWidget {
  final cart_prod_name;
  final cart_prod_picture;
  final cart_prod_price;
  final cart_prod_size;
  final cart_prod_color;
  final cart_prod_qty;

  Single_cart_product(
      {this.cart_prod_name,
      this.cart_prod_color,
      this.cart_prod_price,
      this.cart_prod_picture,
      this.cart_prod_qty,
      this.cart_prod_size});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        //leading section
        leading: new Image.asset(
          cart_prod_picture,
          width: 80.0,
          height: 80.0,
        ),
        //title section
        title: new Text(cart_prod_name),
        //subtitle section
        subtitle: new Column(
          children: <Widget>[
            // ROW Inside the column
            new Row(
              children: <Widget>[
                //this section is for the size of the product
                Padding(
                  padding: const EdgeInsets.all(0.0),
                  child: new Text("Size: "),
                ),
                Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: new Text(
                    cart_prod_size,
                    style: TextStyle(color: Colors.red),
                  ),
                ),
                // this section is for the product color
                new Padding(
                  padding: const EdgeInsets.fromLTRB(20.0, 8.0, 8.0, 8.0),
                  child: new Text("Color:"),
                ),
                Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: new Text(
                    cart_prod_color,
                    style: TextStyle(color: Colors.red),
                  ),
                ),
              ],
            ),
// this section is for the product price
            new Container(
              alignment: Alignment.topLeft,
              child: new Text(
                "\$${cart_prod_price}",
                style: TextStyle(
                    fontSize: 17.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.red),
              ),
            )
          ],
        ),
        trailing: new Column(
          children: <Widget>[
            new IconButton(icon: Icon(Icons.arrow_drop_up), onPressed: () {}),
            new Text("$cart_prod_qty"),
            new IconButton(icon: Icon(Icons.arrow_drop_down), onPressed: () {}),
          ],
        ),
      ),
    );
  }
}
