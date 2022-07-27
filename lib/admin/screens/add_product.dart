
/*
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../db/brand.dart';
import '../db/category.dart';


class AddProduct extends StatefulWidget {
  @override 
  _AddProductState createState() => _AddProductState();

}

class _AddProductState extends State<AddProduct> {
  CategoryService _categoryService = CategoryService();
  BrandService _brandService = BrandService();
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController productNameController = TextEditingController();
  List<DocumentSnapshot> brands = <DocumentSnapshot>[];
  List<DocumentSnapshot> categories = <DocumentSnapshot>[];
  List<DropdownMenuItem<String>> categoriesDropDown = <DropdownMenuItem<String>>[];
  List<DropdownMenuItem<String>> brandsDropDown = <DropdownMenuItem<String>>[];
  String _currentCategory;
  String _currentBrand;
  Color white = Colors.white; 
  Color black = Colors.black;
  Color grey = Colors.grey;
  Color red = Colors.red;

  @override
  void initState(){
    _getCategories();
    categoriesDropDown = getcategoriesDropDown();
    _currentCategory = categoriesDropDown[0].value;
  }

  List<DropdownMenuItem<String>> getcategoriesDropDown(){
    List<DropdownMenuItem<String>> items = new List();
    for(DocumentSnapshot category in categories){
      items.add(new DropdownMenuItem(child: Text(category['category']),
      value: category['category'],));
    }
    return items;
  }
  @override 
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        backgroundColor: white, 
        leading: Icon(Icons.close, color: black,),
        title: Text("add product", style: TextStyle(color: black),),
      ),
      body: Form(
        key: _formKey,
      child: ListView(
        children: <Widget>[
          Row(
            children: <Widget>[
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: OutlinedButton(
               
              
                onPressed: (){},
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(14, 40,14,40),
                  child: new Icon(Icons.add, color: grey,),
              ),
              ),
              ),
              ),


              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: OutlinedButton(
           
                
                onPressed: (){},
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(14, 40,14,40),
                  child: new Icon(Icons.add, color: grey,),
              ),
              ),
              ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: OutlinedButton(
              
              
                onPressed: (){},
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(14, 40,14,40),
                  child: new Icon(Icons.add, color: grey,),
              ),
              ),
              ),
              ),


            ],
          
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
          child: Text('enter a product name with 10 chars', textAlign: TextAlign.center,style: TextStyle(color: red, fontSize: 12),),
          ),

          Padding(
            padding: const EdgeInsets.all(12.0),
            child: TextFormField(
            controller: productNameController, 
            decoration: InputDecoration(
              hintText: 'Product name'
              ),
              validator: (String? value){
                if(value!.isEmpty){
                  return 'you must enter the product name';
                }
                else if(value.length > 10){
                  return 'Product name cant have more than 10 letters';
                }
                },
              
            ), //TextForm
          ),
           Center(
             child: DropDownButton(
               value: _currentCategory, 
               items: categoriesDropDown,
               onChanged: changeSelectedCategory),
             )
            
        ], //widget
      ), //listview
      ), 
    
    );
  }
  /*
  _getCategories() async{
    List<DocumentSnapshot> data = await _categoryService.getCategories();
    setState((){
      categories = data;
    });
  }
   //widget

   changeSelectedCategory(String selectedCategory){
     setState(() => _currentCategory = selectedCategory);
     
   }
} //class 

*/