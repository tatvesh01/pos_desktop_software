import 'package:desktop_crud_app/Helper/ColorHelper.dart';
import 'package:desktop_crud_app/Helper/Helper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import '../Helper/DBHelper.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import '../Model/Category.dart';
import '../Model/Product.dart';


class ProductListScreen extends StatefulWidget {
  @override
  _ProductListScreenState createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen> {
  List<Product> _products = [];
  List<Category> _categories = [];
  final DBHelper _dbHelper = DBHelper();
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _loadCategories();
    _refreshProductList();
  }

  Future<void> _loadCategories() async {
    final categories = await _dbHelper.fetchCategories();
    _categories.add(Category(id: 100 ,name: "Select Category"));
    setState(() {
      _categories.addAll(categories);
    });
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
        availableQty: item['availableQty']
      )).toList();
    });
  }

  Future<void> _showForm({Product? product}) async {
    final nameController = TextEditingController(text: product?.name ?? '');
    final priceController = TextEditingController(text: product?.price.toString() ?? '');
    final qtyController = TextEditingController(text: product?.availableQty.toString() ?? '');
    String? imagePath = product?.imagePath;
    String selectedCategory = product?.category ?? "Select Category";

    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return AlertDialog(
              contentPadding: EdgeInsets.zero,
              content: Container(
                width: MediaQuery.of(context).size.width*0.25,
                padding: EdgeInsets.all(25),
                decoration: BoxDecoration(
                    color: ColorHelper.whiteColor,
                  borderRadius: BorderRadius.all(Radius.circular(25))
                ),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [

                      Text(product == null ? 'Add Product' : 'Update Product',
                        style: TextStyle(fontSize: 20,color: ColorHelper.blackColor,fontWeight: FontWeight.bold),),
                      SizedBox(height: 30,),

                      TextField(
                        controller: nameController,
                        decoration: InputDecoration(labelText: 'Product Name',border: OutlineInputBorder()),
                      ),
                      SizedBox(height: 10,),
                      TextField(
                        controller: priceController,
                        decoration: InputDecoration(labelText: 'Price',border: OutlineInputBorder()),
                        keyboardType: TextInputType.number,
                      ),
                      SizedBox(height: 10,),
                      TextField(
                        controller: qtyController,
                        decoration: InputDecoration(labelText: 'Qty',border: OutlineInputBorder()),
                        keyboardType: TextInputType.number,
                      ),
                      SizedBox(height: 20),
                      Container(
                        width: MediaQuery.of(context).size.width*0.25,
                        color: ColorHelper.lightWhiteColor,
                        child: DropdownButton<String>(
                          underline: SizedBox(),
                          value: selectedCategory,
                          isExpanded: true,
                          padding: EdgeInsets.symmetric(horizontal: 10),
                          items: _categories.map<DropdownMenuItem<String>>((Category category) {
                            return DropdownMenuItem<String>(
                              value: category.name,
                              child: Text(category.name),
                            );
                          }).toList(),
                          onChanged: (String? newValue) {
                            setState(() {
                              selectedCategory = newValue!;
                            });
                          },
                        ),
                      ),
                      SizedBox(height: 20),


                      InkWell(
                        onTap: () async {
                          final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
                          if (pickedFile != null) {
                            setState(() {
                              imagePath = pickedFile.path;
                            });
                          }
                        },
                        child: Container(
                          height: 45,
                          width: MediaQuery.of(context).size.width*0.25,
                          padding: EdgeInsets.symmetric(horizontal: 15,),
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                              color: ColorHelper.lightWhiteColor,
                              borderRadius: BorderRadius.all(Radius.circular(10))
                          ),
                          child: Text(
                            imagePath == null ? 'Pick Image' : 'Change Image',
                            style: TextStyle(fontSize: 18,color: ColorHelper.blackColor,fontWeight: FontWeight.w500),
                          ),
                        ),
                      ),

                      SizedBox(height: 20),

                      if (imagePath != null)
                        Stack(
                          children: [
                            Image.file(
                              File(imagePath!),
                              height: 100,
                              width: 100,
                            ),
                            IconButton(
                              icon: Icon(Icons.delete, color: Colors.red),
                              onPressed: () {
                                setState(() {
                                  imagePath = null;
                                });
                              },
                            ),
                          ],
                        ),

                      SizedBox(height: 20,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          InkWell(
                            onTap: (){

                              Navigator.of(context).pop();
                            },
                            child: Container(
                              height: 45,
                              width: 120,
                              padding: EdgeInsets.symmetric(horizontal: 15,),
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                  color: ColorHelper.lightWhiteColor,
                                  borderRadius: BorderRadius.all(Radius.circular(10))
                              ),
                              child: Text(
                                'Cancel',
                                style: TextStyle(fontSize: 18,color: ColorHelper.blackColor,fontWeight: FontWeight.w500),
                              ),
                            ),
                          ),
                          SizedBox(width: 30,),

                          InkWell(
                            onTap: () async {
                              if (nameController.text.isNotEmpty && priceController.text.isNotEmpty && qtyController.text.isNotEmpty) {
                                final name = nameController.text;
                                final price = double.tryParse(priceController.text) ?? 0.0;
                                int qty = int.tryParse(qtyController.text) ?? 1;

                                if (product == null) {
                                  // Add new product
                                  await _dbHelper.insertProduct(Product(
                                    name: name,
                                    price: price,
                                    imagePath: imagePath ?? '',  // Save empty string if no image
                                    category: selectedCategory,
                                    availableQty: qty,
                                  ));
                                } else {
                                  // Update existing product
                                  await _dbHelper.updateProduct(Product(
                                    id: product.id,
                                    name: name,
                                    price: price,
                                    imagePath: imagePath ?? '',  // Save empty string if no image
                                    category: selectedCategory,
                                    availableQty: qty,
                                  ));
                                }
                                Navigator.of(context).pop();
                                _refreshProductList();
                                //Navigator.of(context).pop();
                              }else{
                                Helper.showToast(context, "Fill All Field");
                              }
                            },
                            child: Container(
                              height: 45,
                              width: 180,
                              padding: EdgeInsets.symmetric(horizontal: 15,),
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                  color: ColorHelper.darkBlueColor,
                                  borderRadius: BorderRadius.all(Radius.circular(10))
                              ),
                              child: Text(
                                product == null ? 'Add Product' : 'Update Product',
                                style: TextStyle(fontSize: 18,color: ColorHelper.whiteColor,fontWeight: FontWeight.w500),
                              ),
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ),

            );
          },
        );
      },
    );

  }

  void _deleteProduct(int id) async {
    await _dbHelper.deleteProduct(id);
    _refreshProductList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Product List",style: TextStyle(fontSize: 22,fontWeight: FontWeight.w500,color: ColorHelper.blackColor),),
        actions: [
          InkWell(
            onTap: (){
              _showForm();
            },
            child: Container(
              height: 45,
              padding: EdgeInsets.symmetric(horizontal: 15,),
              margin: EdgeInsets.only(right: 20),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                  color: ColorHelper.darkBlueColor,
                  borderRadius: BorderRadius.all(Radius.circular(10))
              ),
              child: Text(
                "Add Product",
                style: TextStyle(fontSize: 18,color: ColorHelper.whiteColor,fontWeight: FontWeight.w500),
              ),
            ),
          )
        ],
      ),
      body: _products.isEmpty
          ? Center(child: Text('No products available'))
          : ListView.builder(
        itemCount: _products.length+1,
        itemBuilder: (context, index) {
          final product = index == 0 ? _products[index] :  _products[index-1];
          return Padding(
            padding:  EdgeInsets.symmetric(vertical: 3.0,horizontal: 20),
            child: index == 0 ?
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
            )

                : Container(
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
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: Icon(Icons.edit,color: ColorHelper.blackColor,),
                              onPressed: () => _showForm(product: product),
                            ),
                            IconButton(
                              icon: Icon(Icons.delete,color: ColorHelper.redColor,),
                              onPressed: () => _deleteProduct(product.id!),
                            ),
                          ],
                        ),
                      ),

                    ],
                  ),
                ),
          );
        },
      ),
    );

  }

  
}
