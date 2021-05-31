// import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';
import 'package:sizer/sizer.dart';
import 'package:convex_bottom_bar/convex_bottom_bar.dart';

class ProductsPage extends StatefulWidget {
  ProductsPage({Key? key, required this.data}) : super(key: key);

  final data;

  @override
  _ProductsPageState createState() => _ProductsPageState();
}

class _ProductsPageState extends State<ProductsPage> {
  // bool loaded = false;

  dynamic subcats = [];

  dynamic _data = [];

  List<bool> isSelected = [];

  @override
  void initState() {
    // print(widget.data);
    super.initState();

    setState(() {
      isSelected = List.generate(widget.data["sub_categories"].length,
          (ind) => ind == 0 ? true : false);
      subcats = widget.data["sub_categories"];
    });

    subcats.length > 0 ? fetchProducts(subcats[0]["id"]) : '';
  }

  fetchProducts(id) async {
    final response = await http.post(
        Uri.parse(
          'https://japansquareonline.com/v2/get_products',
        ),
        // Send authorization headers to the backend.
        headers: {
          HttpHeaders.authorizationHeader: '0X6H9E8Um4YMdtfjWei7',
        },
        body: {
          "category_id": id,
          "sort_order": "newest",
          "page": "1",
          "seller_id": "36"
        });
    final responseJson = jsonDecode(response.body);

    // log(response.body);

    setState(() {
      _data = responseJson?["data"]?["results"];
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
        // bottom:
        // TabBar(
        //   controller: _tabController,
        //   tabs: subcats
        //       .map<Widget>(
        //         (d) => Tab(
        //           icon: Text(d["title"],
        //               style: TextStyle(
        //                 color: Colors.black,
        //               )),
        //         ),
        //       )
        //       .toList(),
        // ),
        actions: [
          IconButton(
              onPressed: () {},
              icon: Icon(Icons.search, size: 33, color: Colors.black)),
          IconButton(
              onPressed: () {},
              icon: Icon(
                Icons.filter_alt_outlined,
                size: 33,
                color: Colors.black,
              )),
          IconButton(
              onPressed: () {},
              icon: Icon(Icons.settings, size: 33, color: Colors.black)),
        ],
        leading: IconButton(
            onPressed: () => {Navigator.pop(context)},
            icon: Icon(
              Icons.arrow_back,
              color: Colors.black,
            )),
        backgroundColor: Colors.white,
        foregroundColor: Color(0xAAF9B5C2),
        shadowColor: Color(0xAAF9B5C2),
        title: Text(
          widget.data["title"],
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
          child: Column(children: [
            SizedBox(
              height: 1.h,
            ),
            Expanded(
              flex: 2,
              child: ListView(
                  padding: EdgeInsets.all(1.w),
                  scrollDirection: Axis.horizontal,
                  children: <Widget>[
                    Row(children: <Widget>[
                      SizedBox(
                        width: 3.w,
                      ),
                      ToggleButtons(
                        fillColor: Color(0xAAE94257),
                        children: subcats
                            .map<Widget>((d) => Padding(
                                  padding: EdgeInsets.all(3.w),
                                  child: Text(d["title"],
                                      style: TextStyle(
                                        color: Colors.black,
                                      )),
                                ))
                            .toList(),
                        onPressed: (int index) {
                          setState(() {
                            for (int buttonIndex = 0;
                                buttonIndex < isSelected.length;
                                buttonIndex++) {
                              if (buttonIndex == index) {
                                fetchProducts(subcats[index]["id"]);
                                isSelected[buttonIndex] = true;
                              } else {
                                isSelected[buttonIndex] = false;
                              }
                            }
                          });
                        },
                        isSelected: isSelected,
                      )
                    ])
                  ]),
            ),
            Expanded(
                flex: 20,
                child: Container(
                    padding: EdgeInsets.all(1.w),
                    child: _data.length == 0
                        ? Center(child: Text('No Products'))
                        : GridView.builder(
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 2,
                                    mainAxisSpacing: 1.h,
                                    crossAxisSpacing: 1.w),
                            itemCount: _data.length,
                            itemBuilder: (BuildContext context, int index) {
                              return Column(
                                children: <Widget>[
                                  SizedBox(
                                    height: 1.h,
                                  ),
                                  Expanded(
                                    flex: 10,
                                    child: Image.network(
                                        _data[index]["thumb_url"],
                                        fit: BoxFit.contain),
                                  ),
                                  Expanded(
                                      flex: 5,
                                      child: Padding(
                                        padding: EdgeInsets.all(1.w),
                                        child: Text(
                                          _data[index]["title"],
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 8.sp),
                                        ),
                                      )),
                                  Expanded(
                                      flex: 2,
                                      child: Padding(
                                        padding: EdgeInsets.all(1.w),
                                        child: Text(
                                          'RS ' +
                                              _data[index]["selected_quantity"]
                                                  ["real_price"],
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 8.sp),
                                        ),
                                      )),
                                ],
                              );
                            })))
          ])),
    );
  }
}
