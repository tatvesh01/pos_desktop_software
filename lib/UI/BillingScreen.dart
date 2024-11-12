import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import '../Helper/ColorHelper.dart';
import '../Helper/DBHelper.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import '../Helper/Helper.dart';
import '../Model/BillItem.dart';
import '../Model/Category.dart';
import '../Model/Product.dart';


class BillingScreen extends StatefulWidget {
  @override
  _BillingScreenState createState() => _BillingScreenState();
}

class _BillingScreenState extends State<BillingScreen> {
  List<Product> _products = [];
  List<Product> billingProducts = [];
  final DBHelper _dbHelper = DBHelper();

  @override
  void initState() {
    super.initState();
    billingProducts = [];
    _refreshProductList();
  }


  Future<void> _refreshProductList() async {
    final data = await _dbHelper.getAllProducts();
    setState(() {
      _products = data.map((item) => Product(
        id: item['id'],
        name: item['name'],
        price: item['price'],
        imagePath: item['image_path'],
        category: item['category'],
        availableQty: item['availableQty'],
        inCartNumber: 0
      )).toList();
    });
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Billing Section'),),
      body: _products.isEmpty
          ? Center(child: Text('No products available'))
          : Container(
        height: MediaQuery.of(context).size.height*0.8,
            child: ListView.builder(
                    itemCount: _products.length+1,
                    itemBuilder: (context, index) {
            //final product = _products[index];
            final product = index == 0 ? _products[index] :  _products[index-1];
            return
              Padding(
                  padding:  EdgeInsets.symmetric(vertical: 3.0,horizontal: 20),
                  child : index == 0 ?
                  Container(
                    padding: EdgeInsets.all(12),
                    margin:  EdgeInsets.only(bottom: 10),
                    decoration: BoxDecoration(
                        color: ColorHelper.darkBlueColor
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(child: Helper.labelText("Photo")),
                        Expanded(child: Helper.labelText("Name")),
                        Expanded(child: Helper.labelText("Price(\$)")),
                        Expanded(child: Helper.labelText("Category")),
                        Expanded(child: Helper.labelText("Qty")),
                        Expanded(child: Helper.labelText("Action")),
                      ],
                    ),
                  ): Container(
                    padding: EdgeInsets.all(12),
                    decoration: BoxDecoration(
                        color: index.isEven ? ColorHelper.lightWhiteColor.withOpacity(0.2): ColorHelper.blueColor.withOpacity(0.05)
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [

                        Expanded(
                            child: Container(
                                alignment: Alignment.centerLeft,
                                child: Image.file(File(product.imagePath), width: 50, height: 50))
                        ),

                        Expanded(child: Helper.ValueText(product.name)),
                        Expanded(child: Helper.ValueText('${product.price}')),
                        Expanded(child: Helper.ValueText('${product.category}')),
                        Expanded(child: Helper.ValueText('${product.availableQty}')),
                        Expanded(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                height: 40,
                                width: 40,
                                decoration: BoxDecoration(color: ColorHelper.darkBlueColor,
                                    borderRadius: BorderRadius.all(Radius.circular(10))),
                                child: IconButton(
                                  icon: Icon(Icons.remove,color: ColorHelper.whiteColor,),
                                  onPressed: (){
                                    int tempNumber = product.inCartNumber ?? 0;
                                    if(tempNumber != 0){
                                      tempNumber--;
                                      product.inCartNumber = tempNumber;
                                      billingProducts.remove(product);
                                      setState(() {
                                      });
                                    }
                                  },
                                ),
                              ),
                              Container(
                                width: 50,
                                alignment: Alignment.center,
                                child: Text(
                                  product.inCartNumber.toString(),
                                  style: TextStyle(fontSize: 18,fontWeight: FontWeight.w500),
                                ),
                              ),
                              Container(
                                height: 40,
                                width: 40,
                                decoration: BoxDecoration(color: ColorHelper.darkBlueColor,
                                    borderRadius: BorderRadius.all(Radius.circular(10))),
                                child: IconButton(
                                  icon: Icon(Icons.add,color: ColorHelper.whiteColor,),
                                  onPressed: (){
                                    int tempNumber = product.inCartNumber ?? 0;
                                    if(tempNumber < product.availableQty){
                                      tempNumber++;
                                      product.inCartNumber = tempNumber;
                                      billingProducts.add(product);
                                      setState(() {
                                      });
                                    }
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),

                      ],
                    ),
                  ));
                    },
                  ),
          ),

      bottomNavigationBar: Container(
        height: MediaQuery.of(context).size.height*0.2,
        color: ColorHelper.darkBlueColor,
        child: finalAmount(),
      ),

    );
  }

  Widget finalAmount() {
    var finalAmount = 0;
    billingProducts.forEach((element) {
      finalAmount = finalAmount+element.price.toInt();
    });

    return Padding(
      padding: const EdgeInsets.only(right: 10),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "Total Qty: "+billingProducts.length.toString(),
            style: TextStyle(fontSize: 18,color: ColorHelper.whiteColor),
          ),
          Text(
            "Payable Amount: "+finalAmount.toString(),
            style: TextStyle(fontSize: 18,color: ColorHelper.whiteColor),
          ),
          SizedBox(height: 15,),
          InkWell(
            onTap: (){
              if(billingProducts.isNotEmpty){
                showDialog(
                  context: context,
                  builder: (_) {
                    return AlertDialog(
                      contentPadding: EdgeInsets.zero,
                      content: generateBill(),
                    );
                  },
                );
              }else{
                Helper.showToast(context, "Add Item First");
              }

            },
            child: Container(
              height: 45,
              width: 100,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: ColorHelper.blackColor,
                borderRadius: BorderRadius.all(Radius.circular(10))
              ),
              child: Text(
                "Print Bill",
                style: TextStyle(fontSize: 18,color: ColorHelper.whiteColor,fontWeight: FontWeight.w500),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget generateBill(){
    List<BillItem> items = [];

    billingProducts.forEach((element) {
      int tempIndex = items.indexWhere((elements) => elements.id == element.id!);
      if(tempIndex != -1){
        int aa = element.inCartNumber!;
        items.removeAt(tempIndex);
        items.insert(tempIndex,BillItem(id: element.id!,name: element.name, quantity: aa, price: element.price));
      }else{
        items.add(BillItem(id: element.id!,name: element.name, quantity: element.inCartNumber!, price: element.price));
      }
    });

    double subtotal = items.fold(0, (sum, item) => sum + item.total);
    double tax = subtotal * 0.1; // Example 10% tax
    double total = subtotal + tax;
    DateTime now = DateTime.now();
    String formattedDate = DateFormat('yyyy-MM-dd HH:mm').format(now);
    String formattedDateForBillNo = DateFormat('yyyyMMddHHmmss').format(now);

    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
          color: ColorHelper.whiteColor,
          borderRadius: BorderRadius.all(Radius.circular(25))
      ),
      width: MediaQuery.of(context).size.width*0.2,
      height: MediaQuery.of(context).size.height*0.8,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [


          Icon(Icons.add_business_rounded,color: ColorHelper.blackColor,size: 45,),
          Text("XYZ Billing LTD.",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 18)),
          Divider(),
          Text("Abc Complex Near Lorem Ipsum Garden,\nWashingtone, USA 352252\nPhone: 8855225588",style: TextStyle(fontWeight: FontWeight.w500,fontSize: 12),textAlign: TextAlign.center,),

          SizedBox(height: 10,),
          Divider(),
          Text("Tax Invoice", style: TextStyle(fontWeight: FontWeight.w500,fontSize: 20)),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Bill No. ${formattedDateForBillNo}"),
              Text("Bill Dt. ${formattedDate}"),
            ],
          ),
          SizedBox(height: 15,),
          Divider(),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Name",style: TextStyle(fontSize: 15,fontWeight: FontWeight.w500),),
              Text("Qty",style: TextStyle(fontSize: 15,fontWeight: FontWeight.w500),),
              Text("Price",style: TextStyle(fontSize: 15,fontWeight: FontWeight.w500),),
            ],
          ),

          Divider(),
          Expanded(
            child: ListView.builder(
              itemCount: items.length,
              itemBuilder: (context, index) {
                final item = items[index];
                return Padding(
                  padding: const EdgeInsets.all(3.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("${item.name}",style: TextStyle(fontSize: 15,fontWeight: FontWeight.w500),),
                      Text("${item.quantity}",style: TextStyle(fontSize: 15,fontWeight: FontWeight.w500),),
                      Text("${item.total.toStringAsFixed(2)}\$",style: TextStyle(fontSize: 15,fontWeight: FontWeight.w500),),
                    ],
                  ),
                );
                /*ListTile(
                  title: Text("${item.name} ${item.quantity}"),
                  trailing: Text("\$${item.total.toStringAsFixed(2)}"),
                );*/
              },
            ),
          ),
          Divider(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Subtotal:"),
              Text("${subtotal.toStringAsFixed(2)}\$"),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Tax (10%):"),
              Text("${tax.toStringAsFixed(2)}\$"),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Total:"),
              Text("${total.toStringAsFixed(2)}\$", style: TextStyle(fontWeight: FontWeight.bold)),
            ],
          ),
          SizedBox(height: 5),
          Text("Thanks For visiting XYZ Store, visit again.", style: TextStyle(fontSize: 12)),

          SizedBox(height: 20),
          InkWell(
            onTap: () {
              Helper.showToast(context, "Please Connect Printer First");
            },
            child: Align(
              alignment: Alignment.center,
              child: Container(
                height: 40,
                width: 80,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                    color: ColorHelper.blackColor,
                    borderRadius: BorderRadius.all(Radius.circular(10))
                ),
                child: Text(
                  "Proceed",
                  style: TextStyle(fontSize: 16,color: ColorHelper.whiteColor,fontWeight: FontWeight.w500),
                ),
              ),
            ),
          ),
        ],
      ),
    );

  }
}
