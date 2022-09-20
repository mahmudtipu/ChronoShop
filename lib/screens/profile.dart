import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  _OrderScreenState createState() => _OrderScreenState();
}

class _OrderScreenState extends State<ProfileScreen> {
  TextEditingController namecontroller = new TextEditingController();
  TextEditingController numbercontroller = new TextEditingController();
  TextEditingController locationdetailscontroller = new TextEditingController();

  String phone = '';
  String address = '';
  String name = '';

  @override
  void initState(){
    super.initState();
    getPhone();
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
        title: Text("Profile", style: TextStyle(color: Colors.black87),),
      ),
      body: Container(
          height: double.infinity,
          decoration: BoxDecoration(
              color: Color(0xFFFFFFFF)
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
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
                padding: const EdgeInsets.only(left: 20.0,right: 20,top: 30,bottom: 30),
                child: Row(
                  children: [
                    Text(
                      "Mobile number:",
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
                padding: const EdgeInsets.only(left: 10,top: 30),
                child: Text(
                  "Location details : ",
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
              Spacer(),
              Padding(
                padding: const EdgeInsets.all(8.0),
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
                      Get.back();
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text('Profile updated'),
                        behavior: SnackBarBehavior.floating,
                      ));
                    }
                  }),
                  child: Container(
                    width: double.infinity,
                    color: Colors.black54,
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Center(child: Text("Update profile",style: new TextStyle(fontWeight: FontWeight.w500,fontSize: 18.0, color: Colors.white))),
                    ),
                  ),
                ),
              ),
            ],
          ),
      ),
    );
  }
}
