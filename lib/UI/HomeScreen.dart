import 'package:desktop_crud_app/Helper/ColorHelper.dart';
import 'package:desktop_crud_app/UI/LoginScreen.dart';
import 'package:desktop_crud_app/UI/ProductListScreen.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../Helper/Helper.dart';
import '../Model/SalesCategory.dart';
import '../Model/SalesData.dart';
import 'BillingScreen.dart';
import 'CategoryManager.dart';
import 'HomeSection.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int _currentIndex = 0;

  void goToTab(int index) {
    setState(() {
      _currentIndex = index;
      _tabController.animateTo(index);
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    _tabController = TabController(length: 4, vsync: this);
    _tabController.addListener(() {
      setState(() {
        _currentIndex = _tabController.index;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorHelper.lightWhiteColor,
      appBar: AppBar(
        backgroundColor: ColorHelper.darkBlueColor,
        title: Text("Welcome to the billing system",style: TextStyle(color: ColorHelper.whiteColor,fontWeight: FontWeight.w500,fontSize: 20),),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 20),
            child: Icon(CupertinoIcons.search,color: ColorHelper.whiteColor,size: 25,),
          ),
        ],
      ),
      //drawer: SideDrawer(),
      body: Center(
        child: Row(
          children: [

            SizedBox(
              width: MediaQuery.of(context).size.width*0.15,
              child: Drawer(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.zero),
                backgroundColor: ColorHelper.darkBlueColor,
                child: Column(
                  children: [
                    UserAccountsDrawerHeader(
                      accountName: Text("John Doe",style: TextStyle(color: ColorHelper.whiteColor,fontWeight: FontWeight.bold),),
                      accountEmail: Text("john.doe@example.com",style: TextStyle(color: ColorHelper.whiteColor,fontWeight: FontWeight.w500),),
                      currentAccountPicture: CircleAvatar(
                        backgroundImage: AssetImage('assets/images/user.png'), // Add your logo path
                      ),
                      decoration: BoxDecoration(
                        color: ColorHelper.darkBlueColor,
                      ),
                    ),
                    Expanded(
                      child: ListView(
                        padding: EdgeInsets.zero,
                        children: [
                          ListTile(
                            leading: Icon(Icons.home,color: ColorHelper.whiteColor,),
                            title: Text("Home",style: TextStyle(color: ColorHelper.whiteColor,fontWeight: FontWeight.w500),),
                            onTap: () {
                              goToTab(0);
                            },
                          ),
                          ListTile(
                            leading: Icon(Icons.production_quantity_limits,color: ColorHelper.whiteColor),
                            title: Text("Products",style: TextStyle(color: ColorHelper.whiteColor,fontWeight: FontWeight.w500),),
                            onTap: () {
                              goToTab(1);
                            },
                          ),
                          ListTile(
                            leading: Icon(Icons.list_alt,color: ColorHelper.whiteColor),
                            title: Text("Category",style: TextStyle(color: ColorHelper.whiteColor,fontWeight: FontWeight.w500),),
                            onTap: () {
                              goToTab(2);
                            },
                          ),
                          ListTile(
                            leading: Icon(Icons.print,color: ColorHelper.whiteColor),
                            title: Text("Bill",style: TextStyle(color: ColorHelper.whiteColor,fontWeight: FontWeight.w500),),
                            onTap: () {
                              goToTab(3);
                            },
                          ),
                          Divider(), // Adds a divider line
                          ListTile(
                            leading: Icon(Icons.logout,color: ColorHelper.whiteColor),
                            title: Text("Logout",style: TextStyle(color: ColorHelper.whiteColor,fontWeight: FontWeight.w500),),
                            onTap: () {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(builder: (context) => LoginScreen()),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    HomeSection(),
                    ProductListScreen(),
                    CategoryManager(),
                    BillingScreen()
                  ],
                ),
              ),
            ),

          ],
        ),
      ),
    );
  }


}
