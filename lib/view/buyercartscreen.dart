import 'dart:async';
import 'dart:convert';
import 'package:barterit/model/cart.dart';
import 'package:barterit/model/config.dart';
import 'package:barterit/model/order.dart';
import 'package:barterit/model/user.dart';
import 'package:barterit/view/billscreen.dart';
import 'package:barterit/view/mainscreen.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class BuyerCartScreen extends StatefulWidget {
  final User user;

  const BuyerCartScreen({super.key, required this.user});

  @override
  State<BuyerCartScreen> createState() => _BuyerCartScreenState();
}

class _BuyerCartScreenState extends State<BuyerCartScreen> {
  List<Cart> cartList = <Cart>[];
  late double screenHeight, screenWidth;
  late int axiscount = 2;
  double totalprice = 0.0;
  int sellerid = 0;

  @override
  void initState() {
    super.initState();
    loadcart();
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: const Text("Your Barter Cart"),
        //actions: [IconButton(onPressed: () {}, icon: const Icon(Icons.clear))],
      ),
      body: Column(
        children: [
          cartList.isEmpty
              ? Container()
              : Expanded(
                  child: ListView.builder(
                      itemCount: cartList.length,
                      itemBuilder: (context, index) {
                        return Card(
                            child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            children: [
                              CachedNetworkImage(
                                width: screenWidth / 3,
                                fit: BoxFit.cover,
                                imageUrl:
                                    "${Config.server}/barterit/images/items/${cartList[index].itemId}.png",
                                placeholder: (context, url) =>
                                    const LinearProgressIndicator(),
                                errorWidget: (context, url, error) =>
                                    const Icon(Icons.error),
                              ),
                              Flexible(
                                flex: 4,
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    children: [
                                      Text(
                                        cartList[index].itemName.toString(),
                                        style: const TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          IconButton(
                                              onPressed: () {
                                                if (int.parse(cartList[index]
                                                        .cartQty
                                                        .toString()) <=
                                                    1) {
                                                  ScaffoldMessenger.of(context)
                                                      .showSnackBar(const SnackBar(
                                                          content: Text(
                                                              "Quantity less than 1")));
                                                  //userqty = 1;
                                                  //totalprice = singleprice * userqty;
                                                } else {
                                                  int newqty = int.parse(
                                                          cartList[index]
                                                              .cartQty
                                                              .toString()) -
                                                      1;

                                                  double newprice =
                                                      double.parse(
                                                              cartList[index]
                                                                  .itemPrice
                                                                  .toString()) *
                                                          newqty;
                                                  updateCart(
                                                      index, newqty, newprice);
                                                  //userqty = userqty - 1;
                                                  //totalprice = singleprice * userqty;
                                                }
                                                setState(() {});
                                              },
                                              icon: const Icon(Icons.remove)),
                                          Text(cartList[index]
                                              .cartQty
                                              .toString()),
                                          IconButton(
                                            onPressed: () {
                                              if (int.parse(cartList[index]
                                                      .itemQty
                                                      .toString()) >
                                                  int.parse(cartList[index]
                                                      .cartQty
                                                      .toString())) {
                                                int newqty = int.parse(
                                                        cartList[index]
                                                            .cartQty
                                                            .toString()) +
                                                    1;

                                                double newprice = double.parse(
                                                        cartList[index]
                                                            .itemPrice
                                                            .toString()) *
                                                    newqty;
                                                updateCart(
                                                    index, newqty, newprice);
                                              } else {
                                                ScaffoldMessenger.of(context)
                                                    .showSnackBar(const SnackBar(
                                                        content: Text(
                                                            "Quantity not available")));
                                              }
                                            },
                                            icon: const Icon(Icons.add),
                                          )
                                        ],
                                      ),
                                      Text(
                                          "RM ${double.parse(cartList[index].cartPrice.toString()).toStringAsFixed(2)}")
                                    ],
                                  ),
                                ),
                              ),
                              IconButton(
                                  onPressed: () {
                                    deleteDialog(index);
                                  },
                                  icon: const Icon(Icons.delete))
                            ],
                          ),
                        ));
                      })),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: SizedBox(
                height: 70,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Total Price RM ${totalprice.toStringAsFixed(2)}",
                      style: const TextStyle(
                          fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    ElevatedButton(
                        onPressed: () async {
                          await Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (content) => BillScreen(
                                        user: widget.user,
                                        totalprice: totalprice,
                                        sellerid: int.parse(cartList[0].sellerId.toString()),
                                        onPaymentSuccess: () async {
                                          // Callback function to update cart and order status
                                          // Put your logic here to update the cart and order status after successful payment
                                          // For example, you can clear the cart or mark the order as paid
                                          // Clear the buyer's cart
                                          
                                          clearCart();
                                          //cartList.clear();
                                          // Navigate back to the main screen after a delay of 2 seconds
                                          
                                        },
                                      )));
                          
                          
                          Timer(const Duration(seconds: 2), () {
                                            Navigator.pushAndRemoveUntil(
                                              context,
                                              MaterialPageRoute(builder: (context) => MainScreen(user: widget.user)),
                                              (Route<dynamic> route) => false,
                                            );
                                          });
                          loadcart();
                        },
                        child: const Text("Check Out"))
                  ],
                )),
          )
        ],
      ),
    );
  }

  // Function to clear the cart
  void clearCart() {
    if (cartList.isEmpty) {
      // If the cart list is already empty, no need to send a request
      return;
    }

    for (int i = 0; i < cartList.length; i++) {
      http.post(Uri.parse("${Config.server}/barterit/php/delete_cart.php"),
          body: {
            "cartid": cartList[i].cartId,
          }).then((response) {
        if (response.statusCode == 200) {
          var jsondata = jsonDecode(response.body);
          if (jsondata['status'] == 'success') {
            // Cart item deleted successfully
            if (i == cartList.length - 1) {
              // If this is the last item in the cartList, reload the cart data after all items are deleted
              loadcart();
            }
          } else {
            // Handle error if deleting cart item fails
          }
        } else {
          // Handle error if response status code is not 200
        }
      });
    }
  }

  void loadcart() {
    http.post(Uri.parse("${Config.server}/barterit/php/load_cart.php"),
        body: {
          "userid": widget.user.id,
        }).then((response) {
      // log(response.body);
      cartList.clear();
      if (response.statusCode == 200) {
        var jsondata = jsonDecode(response.body);
        if (jsondata['status'] == "success") {
          var extractdata = jsondata['data'];
          extractdata['carts'].forEach((v) {
            cartList.add(Cart.fromJson(v));
            // totalprice = totalprice +
            //     double.parse(extractdata["carts"]["cart_price"].toString());
          });
          totalprice = 0.0;

          for (var element in cartList) {
            totalprice =
                totalprice + double.parse(element.cartPrice.toString());
            //print(element.catchPrice);
          }
          //print(catchList[0].catchName);
        } else {
          Navigator.of(context).pop();
        }
        setState(() {});
      }
    });
  }

  void deleteDialog(int index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(10.0))),
          title: const Text(
            "Delete this item?",
            style: TextStyle(),
          ),
          content: const Text("Are you sure?", style: TextStyle()),
          actions: <Widget>[
            TextButton(
              child: const Text(
                "Yes",
                style: TextStyle(),
              ),
              onPressed: () {
                Navigator.of(context).pop();
                deleteCart(index);
                //registerUser();
              },
            ),
            TextButton(
              child: const Text(
                "No",
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

  void deleteCart(int index) {
    http.post(Uri.parse("${Config.server}/barterit/php/delete_cart.php"),
        body: {
          "cartid": cartList[index].cartId,
        }).then((response) {
      if (response.statusCode == 200) {
        var jsondata = jsonDecode(response.body);
        if (jsondata['status'] == 'success') {
          loadcart();
          ScaffoldMessenger.of(context)
              .showSnackBar(const SnackBar(content: Text("Delete Success")));
        } else {
          ScaffoldMessenger.of(context)
              .showSnackBar(const SnackBar(content: Text("Delete Failed")));
        }
      } else {
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text("Delete Failed")));
      }
    });
  }

  void updateCart(int index, int newqty, double newprice) {
    http.post(Uri.parse("${Config.server}/barterit/php/update_cart.php"),
        body: {
          "cartid": cartList[index].cartId,
          "newqty": newqty.toString(),
          "newprice": newprice.toString()
        }).then((response) {
      if (response.statusCode == 200) {
        var jsondata = jsonDecode(response.body);
        if (jsondata['status'] == 'success') {
          loadcart();
        } else {}
      } else {}
    });
  }
}