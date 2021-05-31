// import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'products.dart';
import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:sizer/sizer.dart';

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late Future categories;

// int _selectedIndex = 0;

  // bool loaded = false;

  dynamic _data = [];

  @override
  void initState() {
    categories = fetchCategory();
    super.initState();
  }

  fetchCategory() async {
    final response = await http.get(
      Uri.parse('https://japansquareonline.com/v2/get_categories'),
      // Send authorization headers to the backend.
      headers: {
        HttpHeaders.authorizationHeader: '0X6H9E8Um4YMdtfjWei7',
      },
    );
    final responseJson = jsonDecode(response.body);

    // log(response.body);

    setState(() {
      _data = responseJson["data"]["categories"];
      _data == null ? _data = [] : '';
    });

    return responseJson;
  }

  double getScreenWidth(BuildContext context) {
    return MediaQuery.of(context).size.width;
  }

  double getScreenHeight(BuildContext context) {
    return MediaQuery.of(context).size.height;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: Color(0xAAF9B5C2),
        shadowColor: Color(0xAAF9B5C2),
        title: Text(
          'Categories',
          style: TextStyle(color: Colors.black),
        ),
      ),
      bottomNavigationBar: ConvexAppBar(
        height: 100.h / 13,
        curveSize: 0.0,
        backgroundColor: Colors.white,
        color: Color(0xAABBBBBB),
        activeColor: Color(0xAAD43B56),
        items: [
          TabItem(icon: Icons.home_outlined),
          TabItem(
            icon: Icons.grid_view_outlined,
          ),
          TabItem(icon: Icons.shopping_cart_outlined),
          TabItem(icon: Icons.favorite_outline),
          TabItem(icon: Icons.money),
        ],
        initialActiveIndex: 2, //optional, default as 0
        onTap: (int i) => print('click index=$i'),
      ),
      body: MediaQuery.removePadding(
          context: context,
          removeTop: true,
          child: Container(
              padding: EdgeInsets.all(5.w),
              child: GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      mainAxisSpacing: 1.h,
                      crossAxisSpacing: 1.w),
                  itemCount: _data.length,
                  itemBuilder: (BuildContext context, int index) {
                    return GestureDetector(
                      onTap: () => {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  ProductsPage(data: _data[index])),
                        )
                      },
                      child: Card(
                        child: Column(
                          children: <Widget>[
                            AspectRatio(
                              child: Image.network(_data[index]["image"],
                                  fit: BoxFit.contain),
                              aspectRatio: 2 / 1,
                            ),
                            Padding(
                              padding: EdgeInsets.all(1.h),
                              child: Text(
                                _data[index]["title"],
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: Colors.black, fontSize: 8.sp),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }))),
    );
  }
}
