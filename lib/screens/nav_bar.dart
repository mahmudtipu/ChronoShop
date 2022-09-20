import 'package:chronoshop/screens/pending_screen.dart';
import 'package:chronoshop/screens/profile.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

import 'login_screen.dart';

class NavBar extends StatefulWidget {
  @override
  State<NavBar> createState() => _NavBarState();
}

class _NavBarState extends State<NavBar> {

  String phone = '';
  String name = '';
  String address = '';

  @override
  void initState(){
    super.initState();
    getPhone();
    fetchprof();
  }

  getPhone() async{
    User currentUser = await FirebaseAuth.instance.currentUser!;
    setState(() {
      phone=currentUser.phoneNumber!;
    });
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

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Drawer(
        child: ListView(
          // Remove padding
          padding: EdgeInsets.zero,
          children: [
            UserAccountsDrawerHeader(
              accountName: Text(
                name,
                  style: TextStyle(color: Colors.black87, fontSize: 20)
              ),
              accountEmail: Text(
                phone,
                style: TextStyle(color: Colors.black87)
              ),
              currentAccountPicture: CircleAvatar(
                child: ClipOval(
                  child: Image.asset(
                    'assets/images/profile.png',
                    fit: BoxFit.cover,
                    width: 90,
                    height: 90,
                  ),
                ),
              ),
              decoration: BoxDecoration(
                color: Color(0xFFFFFFFF),
                image: DecorationImage(
                    fit: BoxFit.fill,
                    image: NetworkImage(
                        'https://media.istockphoto.com/photos/healthy-food-shopping-concept-picture-id1132266853?k=20&m=1132266853&s=612x612&w=0&h=0GPmf-3NHyy8N-3Gj8mMXNCPYDMsOS0lRWBpH8_MyeM=',
                    )
                ),
              ),
            ),
            ListTile(
              leading: Icon(Icons.pending_actions),
              title: Text('Pending Order'),
              onTap: ((){
                Get.to(PendingScreen());
              }),
            ),
            ListTile(
              leading: Icon(Icons.account_circle_outlined),
              title: Text('My Profile'),
              onTap: ((){
                Get.to(ProfileScreen());
              }),
            ),
            Divider(),
            ListTile(
              leading: Icon(Icons.policy_sharp),
              title: Text('Privacy Policies'),
              onTap: (() async{
                var url = 'https://sites.google.com/view/solutionpro';
                if(await canLaunch(url)){
                  await launch(url);
                }
                else
                {
                  throw "Cannot load url";
                }
              }),
            ),
            ListTile(
              leading: Icon(Icons.description),
              title: Text('Terms Of Use'),
              onTap: (() async{
                var url = 'https://sites.google.com/view/solutionpro';
                if(await canLaunch(url)){
                  await launch(url);
                }
                else
                {
                  throw "Cannot load url";
                }
              }),
            ),
            ListTile(
              leading: Icon(Icons.exit_to_app),
              title: Text('Sign Out'),
              onTap: ((){
                FirebaseAuth.instance.signOut();
                Get.offAll(LoginScreen());
              }),
            ),
          ],
        ),
      ),
    );
  }
}