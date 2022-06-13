import 'package:bankapp/shared/cubit.dart';
import 'package:bankapp/shared/states.dart';
import 'package:flutter/material.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';

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
              title: Text(cubit.titles[cubit.currentIndex]),
              backgroundColor: Colors.lightBlue,
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
                        isshow: false, icon: Icons.edit);
                  });
                  cubit.changeBottomSheetState(isshow: true, icon: Icons.add);
                }
              },
              child: Icon(cubit.fabIcon),
            ),
            bottomNavigationBar: BottomNavigationBar(
              type: BottomNavigationBarType.fixed,
              currentIndex: AppCubit.get(context).currentIndex,
              onTap: (index) {
                cubit.changeIndex(index);
              },
              items: const [
                BottomNavigationBarItem(
                  icon: Icon(
                    Icons.menu,
                  ),
                  label: 'Home',
                ),
                BottomNavigationBarItem(
                  icon: Icon(
                    Icons.check_circle_outline,
                  ),
                  label: 'Transaction',
                ),
                BottomNavigationBarItem(
                    icon: Icon(Icons.archive_outlined), label: 'Archived'),
              ],
            ),
          );
        },
      ),
    );
  }
}
