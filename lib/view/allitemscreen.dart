import 'dart:convert';
import 'dart:developer';

import 'package:barterit/view/useritemscreen.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../model/config.dart';
import '../model/item.dart';
import '../model/user.dart';

class AllItemScreen extends StatefulWidget {
  final User user;
  const AllItemScreen({super.key, required this.user});

  @override
  State<AllItemScreen> createState() => _AllItemScreenState();
}

class _AllItemScreenState extends State<AllItemScreen> {
  String maintitle = "All Item";
  List <Item> itemList = <Item>[];
  //List itemlist = [];
  String titlecenter = "Loading data...";
  late double screenHeight, screenWidth, resWidth;
  late int axiscount = 2;
  int numofpage = 1, curpage = 1;
  int numberofresult = 0;
  var color;
  //final df = DateFormat('dd/MM/yyyy hh:mm a');

  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    loadAllItems(1);
  }

  @override
  void dispose() {
    super.dispose();
    print("dispose");
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    if (screenWidth > 600) {
      axiscount = 3;
    } else {
      axiscount = 2;
    }
    return Scaffold(
       appBar: AppBar(
        title: Text(maintitle),
        actions: [
          IconButton(
              onPressed: () {
                showsearchDialog();
              },
              icon: const Icon(Icons.search)),
        ],
      ),
      body: itemList.isEmpty
          ? const Center(
              child: Text(
                "No Data",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
            )
          : Column(
              children: [
                Container(
                  height: 24,
                  color: Theme.of(context).colorScheme.primary,
                  alignment: Alignment.center,
                  child: Text(
                    //"$numberofresult Items Found",
                    "${_getDisplayText(numberofresult)} Found",
                    style: const TextStyle(color: Colors.white, fontSize: 18),
                  ),
                ),
                Expanded(
                  child: GridView.count(
                    crossAxisCount: axiscount,
                    children: List.generate(itemList.length, (index) {
                      Item item = itemList[index];
                      return Card(
                        child: InkWell(
                          onTap: () async {
                                Item useritem =
                                    Item.fromJson(item.toJson());
                                await Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (content) =>
                                            UserItemScreen(
                                              user: widget.user,
                                              useritem: useritem,
                                            )));
                                loadAllItems(1);
                              },
                          child: Column(
                            children: [
                              CachedNetworkImage(
                                  width: screenWidth,
                                  fit: BoxFit.cover,
                                  imageUrl:
                                      "${Config.server}/barterit/images/items/${itemList[index].itemId}.png",
                                  placeholder: (context, url) =>
                                      const LinearProgressIndicator(),
                                  errorWidget: (context, url, error) =>
                                      const Icon(Icons.error),
                                ),
                                Text(
                                  itemList[index].itemName.toString(),
                                  style: const TextStyle(fontSize: 20),
                                ),
                                Text(
                                  "RM ${double.parse(itemList[index].itemValue.toString()).toStringAsFixed(2)}",
                                  style: const TextStyle(fontSize: 14),
                                ),
                                /*Text(
                                  "${catchList[index].catchQty} available",
                                  style: const TextStyle(fontSize: 14),
                                ),*/
                                Text(
                                  "${itemList[index].itemLocal.toString()}, ${itemList[index].itemState.toString()}",
                                  style: const TextStyle(fontSize: 14),
                                ),
                              ]
                          ),
                        ),
                      );
                    },),
                  ),
                ),
                SizedBox(
                height: 50,
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: numofpage,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, index) {
                    //build the list for textbutton with scroll
                    if ((curpage - 1) == index) {
                      //set current page number active
                      color = Colors.red;
                    } else {
                      color = Colors.black;
                    }
                    return TextButton(
                        onPressed: () {
                          curpage = index + 1;
                          loadAllItems(index + 1);
                        },
                        child: Text(
                          (index + 1).toString(),
                          style: TextStyle(color: color, fontSize: 18),
                        ));
                  },
                ),
              ),
              ],
            ),
    );
  }

  /*String truncateString(String str) {
    if (str.length > 15) {
      str = str.substring(0, 15);
      return str + "...";
    } else {
      return str;
    }
  }*/

  String _getDisplayText(int count) {
    if (count == 1) {
      return "1 Item";
    } else {
      return "$count Items";
    }
  }

  void loadAllItems(int pg) {
    http.post(Uri.parse("${Config.server}/barterit/php/load_item.php"),
        body: {
          "cartuserid": widget.user.id,
          "pageno": pg.toString()
        }).then((response) {
        log(response.body);
        itemList.clear();
        if (response.statusCode == 200) {
          var jsondata = jsonDecode(response.body);
          if (jsondata['status'] == "success") {
            numofpage = int.parse(jsondata['numofpage']); //get number of pages
            numberofresult = int.parse(jsondata['numberofresult']);
            print(numberofresult);
            var extractdata = jsondata['data'];
            /*cartqty = int.parse(jsondata['cartqty'].toString());
            print(cartqty);*/
            extractdata['items'].forEach((v) {
              itemList.add(Item.fromJson(v));
            });
            print(itemList[0].itemName);
          }
          setState(() {});
        }
      }
    );
  }

  void showsearchDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(10.0))),
          title: const Text(
            "Search?",
            style: TextStyle(),
          ),
          content: Column(mainAxisSize: MainAxisSize.min, children: [
            TextField(
                controller: searchController,
                decoration: const InputDecoration(
                    labelText: 'Search',
                    labelStyle: TextStyle(),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(width: 2.0),
                    ))),
            const SizedBox(
              height: 4,
            ),
            ElevatedButton(
                onPressed: () {
                  String search = searchController.text;
                  searchItem(search);
                  Navigator.of(context).pop();
                },
                child: const Text("Search"))
          ]),
          actions: <Widget>[
            TextButton(
              child: const Text(
                "Close",
                style: TextStyle(),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void searchItem(String search) {
    http.post(Uri.parse("${Config.server}/barterit/php/load_item.php"),
        body: {
          "cartuserid": widget.user.id,
          "search": search
        }).then((response) {
      //print(response.body);
      log(response.body);
      itemList.clear();
      if (response.statusCode == 200) {
        var jsondata = jsonDecode(response.body);
        if (jsondata['status'] == "success") {
          var extractdata = jsondata['data'];
          extractdata['items'].forEach((v) {
            itemList.add(Item.fromJson(v));
          });
          numberofresult = int.parse(jsondata['numberofresult']);
          print(itemList[0].itemName);
        }
        setState(() {});
      }
    });
  }
}