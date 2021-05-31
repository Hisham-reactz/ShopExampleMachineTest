// import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';

class ProductsPage extends StatefulWidget {
  ProductsPage({Key? key, required this.data}) : super(key: key);

  final data;

  @override
  _ProductsPageState createState() => _ProductsPageState();
}

class _ProductsPageState extends State<ProductsPage>
    with TickerProviderStateMixin {
  int _selectedIndex = 0;
  bool loaded = false;

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

  void _onItemTapped(index) {
    setState(() {
      _selectedIndex = index;
    });
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
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.grid_view),
            label: 'Category',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart),
            label: 'Cart',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.amber[800],
        onTap: _onItemTapped,
      ),
      body: MediaQuery.removePadding(
          context: context,
          removeTop: true,
          child: Column(children: [
            SizedBox(
              height: 13,
            ),
            Expanded(
              flex: 1,
              child: ListView(
                  padding: EdgeInsets.all(3),
                  scrollDirection: Axis.horizontal,
                  children: <Widget>[
                    Row(children: <Widget>[
                      ToggleButtons(
                        fillColor: Color(0xAAE94257),
                        children: subcats
                            .map<Widget>((d) => Padding(
                                  padding: EdgeInsets.all(13),
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
                flex: 13,
                child: Container(
                    padding: EdgeInsets.all(7),
                    child: _data.length == 0
                        ? Center(child: Text('No Products'))
                        : GridView.builder(
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 2,
                                    mainAxisSpacing: 3,
                                    crossAxisSpacing: 3),
                            itemCount: _data.length,
                            itemBuilder: (BuildContext context, int index) {
                              return Column(
                                children: <Widget>[
                                  Expanded(
                                    flex: 15,
                                    child: Image.network(
                                        _data[index]["thumb_url"],
                                        fit: BoxFit.contain),
                                  ),
                                  Expanded(
                                      flex: 5,
                                      child: Padding(
                                        padding: const EdgeInsets.all(7.0),
                                        child: Text(
                                          _data[index]["title"],
                                          textAlign: TextAlign.center,
                                          style: TextStyle(color: Colors.black),
                                        ),
                                      )),
                                  Expanded(
                                      flex: 5,
                                      child: Padding(
                                        padding: const EdgeInsets.all(7.0),
                                        child: Text(
                                          'RS ' +
                                              _data[index]["selected_quantity"]
                                                  ["real_price"],
                                          textAlign: TextAlign.center,
                                          style: TextStyle(color: Colors.black),
                                        ),
                                      )),
                                ],
                              );
                            })))
          ])),
    );
  }
}
