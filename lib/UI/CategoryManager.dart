import 'package:desktop_crud_app/Helper/DBHelper.dart';
import 'package:flutter/material.dart';

import '../Helper/ColorHelper.dart';
import '../Helper/Helper.dart';
import '../Model/Category.dart';

class CategoryManager extends StatefulWidget {
  @override
  _CategoryManagerState createState() => _CategoryManagerState();
}

class _CategoryManagerState extends State<CategoryManager> {
  List<Category> _categories = [];
  final TextEditingController _nameController = TextEditingController();
  final DBHelper _dbHelper = DBHelper();

  @override
  void initState() {
    super.initState();
    _refreshCategoryList();
  }

  Future<void> _refreshCategoryList() async {
    final categories = await _dbHelper.fetchCategories();
    setState(() {
      _categories = categories;
    });
  }

  Future<void> _addCategory(String name) async {
    await _dbHelper.insertCategory(Category(name: name));
    _nameController.clear();
    _refreshCategoryList();
  }

  Future<void> _updateCategory(Category category) async {
    category.name = _nameController.text;
    await _dbHelper.updateCategory(category);
    _nameController.clear();
    _refreshCategoryList();
  }

  Future<void> _deleteCategory(int id) async {
    await _dbHelper.deleteCategory(id);
    _refreshCategoryList();
  }

  void _showCategoryForm({Category? category}) {
    _nameController.text = "";
    if (category != null) {
      _nameController.text = category.name;
    }
    showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          contentPadding: EdgeInsets.zero,
          content: Container(
            padding: EdgeInsets.all(25),
            decoration: BoxDecoration(
                color: ColorHelper.whiteColor,
                borderRadius: BorderRadius.all(Radius.circular(25))
            ),
            height: 250,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [

                Text(category == null ? 'Add Category' : 'Edit Category',
                  style: TextStyle(fontSize: 20,color: ColorHelper.blackColor,fontWeight: FontWeight.bold),),
                SizedBox(height: 30,),
                TextField(
                  controller: _nameController,
                  decoration: InputDecoration(labelText: 'Category Name',border: OutlineInputBorder()),
                ),
                SizedBox(height: 20,),
                Row(
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
                    SizedBox(width: 20,),

                    InkWell(
                      onTap: (){
                        if (_nameController.text.isNotEmpty) {
                          if (category == null) {
                            _addCategory(_nameController.text);
                          } else {
                            _updateCategory(category);
                          }
                          Navigator.of(context).pop();
                        }else{
                          Helper.showToast(context, "Fill All Field");
                        }
                      },
                      child: Container(
                        height: 45,
                        width: 120,
                        padding: EdgeInsets.symmetric(horizontal: 15,),
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                            color: ColorHelper.darkBlueColor,
                            borderRadius: BorderRadius.all(Radius.circular(10))
                        ),
                        child: Text(
                          category == null ? 'Add' : 'Update',
                          style: TextStyle(fontSize: 18,color: ColorHelper.whiteColor,fontWeight: FontWeight.w500),
                        ),
                      ),
                    ),
                  ],
                )


              ],
            ),
          ),

        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Categories List",style: TextStyle(fontSize: 22,fontWeight: FontWeight.w500,color: ColorHelper.blackColor),),
        actions: [
          InkWell(
            onTap: (){
              _showCategoryForm();
            },
            child: Container(
              margin: EdgeInsets.only(right: 20),
              height: 45,
              padding: EdgeInsets.symmetric(horizontal: 15,),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                  color: ColorHelper.darkBlueColor,
                  borderRadius: BorderRadius.all(Radius.circular(10))
              ),
              child: Text(
                "Add Categorie",
                style: TextStyle(fontSize: 18,color: ColorHelper.whiteColor,fontWeight: FontWeight.w500),
              ),
            ),
          )
        ],
      ),
      body: _categories.isEmpty ? Center(child: Text('No categorys available')): ListView.builder(
        itemCount: _categories.length+1,
        itemBuilder: (context, index) {
          final category = index == 0 ? _categories[index] : _categories[index-1];
          return
            Padding(
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
                  Container(color: ColorHelper.darkBlueColor,child: Helper.labelText("Name")),
                  Container(color: ColorHelper.darkBlueColor,child: Helper.labelText("Action")),
                ],
              ),
            ) : Container(
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                  color: index.isEven ? ColorHelper.lightWhiteColor.withOpacity(0.2): ColorHelper.blueColor.withOpacity(0.05)
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Helper.ValueText(category.name),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(Icons.edit,color: ColorHelper.blackColor,),
                        onPressed: () => _showCategoryForm(category: category),
                      ),
                      IconButton(
                        icon: Icon(Icons.delete,color: ColorHelper.redColor,),
                        onPressed: () => _deleteCategory(category.id!),
                      ),
                    ],
                  ),

                ],
              ),
            ),);

        },
      ),
    );
  }
}
