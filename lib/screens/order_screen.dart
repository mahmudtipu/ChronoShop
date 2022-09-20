import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../constant.dart';
import 'confirmed.dart';

class OrderScreen extends StatefulWidget {
  const OrderScreen({Key? key}) : super(key: key);

  @override
  _OrderScreenState createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  TextEditingController namecontroller = new TextEditingController();
  TextEditingController numbercontroller = new TextEditingController();
  TextEditingController locationdetailscontroller = new TextEditingController();

  String phone = '';
  String address = '';
  String name = '';

  int d = doc.length;

  @override
  void initState(){
    super.initState();
    getPhone();
    deliverylist(index);
    fetchprof();
  }

  Future<void> fetchprof() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    String? uid = auth.currentUser?.uid.toString();
    String na='',add='';
    await FirebaseFirestore.instance.collection("userdetails").doc(uid).get().then(
            (ds){
          na= ds.data()!['name'];
          add= ds.data()!['address'];
        }

    );
    setState(() {
      name = na;
      address = add;
    });
  }

  getPhone() async{
    User currentUser = await FirebaseAuth.instance.currentUser!;
    setState(() {
      phone=currentUser.phoneNumber!;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: BoxDecoration(
              color: Color(0xFFFFFFFF)
          ),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black87),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text("Confirm order", style: TextStyle(color: Colors.black87),),
      ),
      body: Container(
        height: double.infinity,
          decoration: BoxDecoration(
              color: Color(0xFFFFFFFF)
          ),
          child: SingleChildScrollView(
            child: IntrinsicHeight(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 10,top: 20),
                    child: Center(
                      child: Text(
                        "One step left",
                        style: Theme.of(context)
                            .textTheme
                            .headline6!
                            .copyWith(color: Colors.black87),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 10,top: 30),
                    child: Text(
                      "Name : ",
                      style: Theme.of(context)
                          .textTheme
                          .headline6!
                          .copyWith(color: Colors.black87),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(10),
                    child: TextField(
                      controller: namecontroller..text=name,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: 'Adam Gabriel',
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Row(
                      children: [
                        Text(
                          "Mobile : ",
                          style: Theme.of(context)
                              .textTheme
                              .headline6!
                              .copyWith(color: Colors.black87),
                        ),
                        Spacer(),
                        Text(
                          phone,
                          style: Theme.of(context)
                              .textTheme
                              .headline6!
                              .copyWith(color: Colors.black87),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 10,top: 20),
                    child: Text(
                      "Location Details : ",
                      style: Theme.of(context)
                          .textTheme
                          .headline6!
                          .copyWith(color: Colors.black87),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(10),
                    child: TextField(
                      controller: locationdetailscontroller..text=address,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: '4 place Maurice-Charretier, Charleville-mÉziÈres',
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Row(
                      children: [
                        Text(
                          "Cash on delivery ",
                          style: Theme.of(context)
                              .textTheme
                              .headline6!
                              .copyWith(color: Colors.black87),
                        ),
                        Spacer(),
                        Icon(
                          Icons.delivery_dining,
                          color: Colors.red,
                        )
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Row(
                      children: [
                        Text(
                          "Total: ",
                          style: Theme.of(context)
                              .textTheme
                              .headline6!
                              .copyWith(color: Colors.black87),
                        ),
                        Spacer(),
                        Icon(
                          Icons.euro,
                          color: Colors.black54,
                        ),
                        Text(
                          '$totalbill'+' + '+'$charges'+'(charges)',
                          style: Theme.of(context)
                              .textTheme
                              .headline6!
                              .copyWith(color: Colors.black87),
                        ),
                      ],
                    ),
                  ),
                  Spacer(),
                  Padding(
                    padding: const EdgeInsets.only(top: 30.0),
                    child: InkWell(
                      onTap: (() {
                        FirebaseAuth auth = FirebaseAuth.instance;
                        String? uid = auth.currentUser?.uid.toString();

                        if(namecontroller.text.toString().isNotEmpty && locationdetailscontroller.text.toString().isNotEmpty)
                        {
                          DocumentReference userdetails = FirebaseFirestore.instance.collection('userdetails').doc(uid);
                          userdetails.set(
                              {
                                "name": namecontroller.text.toString(),
                                "mobile": phone,
                                "address": locationdetailscontroller.text.toString(),
                              }).then((value){

                          });

                          for(int i=0;i<=doc.length;i++)
                          {
                            var oldColl = FirebaseFirestore.instance.collection('userdetails').doc(uid).collection('cart').doc('$i');
                            var newColl = FirebaseFirestore.instance.collection('userdetails').doc(uid).collection('order').doc('$i');


                            Future<void> snapshot = oldColl.get()
                            // ignore: missing_return
                                .then((docSnapshot) {
                              if (docSnapshot.exists) {

                                // document id does exist
                                print('Successfully found document');

                                newColl
                                    .set({
                                  'shopid': docSnapshot['shopid'],
                                  'name': docSnapshot['name'],
                                  'price': docSnapshot['price'],
                                  'quantity': docSnapshot['quantity'],
                                })
                                    .then((value) => print("document moved to different collection"))
                                    .catchError((error) => print("Failed to move document: $error")).then((value) => ({

                                  oldColl
                                      .delete()
                                      .then((value) => print("document removed from old collection"))
                                      .catchError((error) {

                                    newColl.delete();
                                    print("Failed to delete document: $error");

                                  })
                                }));

                              } else {

                                //document id doesnt exist
                                print('Failed to find document id');
                              }
                            });
                          }

                          DocumentReference delivery = FirebaseFirestore.instance.collection('delivery').doc('$index');
                          delivery.set(
                              {
                                "uid": uid,
                                "index": index,
                                "address": locationdetailscontroller.text.toString(),
                                "name": namecontroller.text.toString(),
                                "bill": totalbill,
                              }).then((value){

                          });

                          Get.to(ThanksScreen());
                        }
                      }),
                      child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Container(
                          width: double.infinity,
                          color: Colors.black54,
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Center(child: Text("Confirm order",style: new TextStyle(fontWeight: FontWeight.w500,fontSize: 18.0, color: Colors.white))),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
      ),
    );
  }

  Future<void> deliverylist(int i) async {
    List data = [];

    await FirebaseFirestore.instance.collection("delivery").get().then(
          (QuerySnapshot snapshot) =>
          snapshot.docs.forEach((f) {
            //data.add(Question(id: f['id'], question: f['question'], answer: f['answer_index'], options: List.from(f['options'])));

            i = f['id'];
            /*  _questions=data
                .map(
                  (question) => Question(
                  id: question['id'],
                  question: question['question'],
                  options: question['options'],
                  answer: question['answer_index']),
            )
                .toList(); */
            //data.add(Question(id: f['id'], question: f['question'], answer: f['answer_index'], options: List.from(f['options'])));
          }),
    );
    setState(() {
      index=i+1;
    });
    // _questions =
  }
}
