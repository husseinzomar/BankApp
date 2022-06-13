import 'package:bankapp/shared/cubit.dart';
import 'package:bankapp/shared/states.dart';
import 'package:flutter/material.dart';
import 'package:bloc/bloc.dart';
import 'package:bottom_navy_bar/bottom_navy_bar.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:hexcolor/hexcolor.dart';

import 'package:sqflite/sqflite.dart';

class HomePage extends StatelessWidget {
  GlobalKey<ScaffoldState> scaffoldkey = GlobalKey<ScaffoldState>();
  var formKey = GlobalKey<FormState>();

  var nameController = TextEditingController();
  var amountController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => AppCubit()..createDatabase(),
      child: BlocConsumer<AppCubit, AppStates>(
        listener: (BuildContext context, AppStates state) {
          if (state is AppInsertDatabaseState) {
            Navigator.pop(context);
          }
        },
        builder: (BuildContext context, AppStates state) {
          AppCubit? cubit = AppCubit.get(context);
          return Scaffold(
            key: scaffoldkey,
            appBar: AppBar(
              elevation: 20.0,
              title: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(cubit.titles[cubit.currentIndex]),
                ],
              ),
              backgroundColor: HexColor('#21083b'),
              toolbarHeight: 80.0,
              actions: [
                Container(
                  margin: EdgeInsets.all(10.0),
                  decoration: BoxDecoration(
                    color: Colors.black38,
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: IconButton(
                      onPressed: () {}, icon: Icon(Icons.menu_outlined)),
                )
              ],
              leadingWidth: 70.0,
              leading: Container(
                margin: EdgeInsets.all(10.0),
                decoration: BoxDecoration(
                  color: Colors.black26,
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: IconButton(
                  onPressed: () {},
                  icon: Icon(
                    Icons.notifications_none_outlined,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            body: ConditionalBuilder(
              condition: state is! AppGetDatabaseLoadingState,
              builder: (context) => cubit.screens[cubit.currentIndex],
              fallback: (context) => const Center(
                child: CircularProgressIndicator(),
              ),
            ),
            backgroundColor: Colors.grey[200],
            floatingActionButton: FloatingActionButton(
              onPressed: () {
                if (cubit.isbottomsheet) {
                  if (formKey.currentState!.validate()) {
                    cubit.isbottomsheet = true;
                  }
                } else {
                  scaffoldkey.currentState!
                      .showBottomSheet(
                        (BuildContext context) => Container(
                          color: Colors.white,
                          padding: const EdgeInsets.all(20),
                          child: Form(
                            key: formKey,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  'Transactions :',
                                  style: TextStyle(fontSize: 20),
                                ),
                                const SizedBox(height: 15.0),
                                TextFormField(
                                    controller: nameController,
                                    keyboardType: TextInputType.text,
                                    validator: (String? value) {
                                      if (value!.isEmpty) {
                                        return 'title must not be empty';
                                      }
                                      return null;
                                    },
                                    decoration: InputDecoration(
                                      labelText: 'Name',
                                      prefix: const Icon(Icons.title),
                                      border: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(10.0),
                                      ),
                                    )),
                                SizedBox(height: 15.0),
                                TextFormField(
                                  controller: amountController,
                                  keyboardType: TextInputType.number,
                                  validator: (String? value) {
                                    if (value!.isEmpty) {
                                      return 'amount must not be empty';
                                    }
                                    return null;
                                  },
                                  decoration: InputDecoration(
                                    labelText: 'Amount',
                                    prefix: const Icon(Icons.attach_money),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10.0),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        elevation: 20.0,
                      )
                      .closed
                      .then((value) {
                    cubit.changeBottomSheetState(
                      isshow: false,
                      icon: Icons.edit,
                    );
                  });
                  cubit.changeBottomSheetState(isshow: true, icon: Icons.add);
                }
              },
              child: Icon(cubit.fabIcon),
            ),
            bottomNavigationBar: Padding(
              padding: const EdgeInsets.only(left: 20, right: 20, bottom: 10),
              child: Container(
                height: 60,
                width: 350,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(30.0),
                  child: BottomNavyBar(
                    selectedIndex: AppCubit.get(context).currentIndex,
                    onItemSelected: (index) {
                      cubit.changeIndex(index);
                    },
                    backgroundColor: HexColor('#21083b'),
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    items: [
                      BottomNavyBarItem(
                        title: Text('Home'),
                        icon: Icon(
                          Icons.menu,
                          color: Colors.white,
                          size: 25,
                        ),
                        activeColor: Colors.white,
                        inactiveColor: Colors.white,
                      ),
                      BottomNavyBarItem(
                        title: Text('Transaction'),
                        icon: Icon(
                          Icons.check_circle_outline,
                          color: Colors.white,
                          size: 25,
                        ),
                        activeColor: Colors.white,
                        inactiveColor: Colors.white,
                      ),
                      BottomNavyBarItem(
                        title: Text('Archived'),
                        icon: Icon(
                          Icons.archive_outlined,
                          color: Colors.white,
                          size: 25,
                        ),
                        activeColor: Colors.white,
                        inactiveColor: Colors.white,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
