import 'package:bankapp/screens/customr.dart';
import 'package:bankapp/screens/homepage.dart';
import 'package:bankapp/shared/states.dart';
import 'package:bankapp/screens/Transaction.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:sqflite/sqflite.dart';

import '../screens/H1.dart';

class AppCubit extends Cubit<AppStates> {
  AppCubit() : super(AppInititalState());
  static AppCubit get(context) => BlocProvider.of(context);

  int currentIndex = 0;
  late Database database;
  List<Map> data = [];
  bool isbottomsheet = false;
  IconData fabIcon = Icons.edit;
  List<Widget> screens = [
    HomeScreen(),
    Customer(),
    Transactions(),
  ];

  List<String> titles = [
    'Home Page',
    'Customers',
    'Transcations',
  ];
  void changeIndex(int index) {
    currentIndex = index;
    emit(AppChangeBottomNavBarState());
  }

  void createDatabase() {
    openDatabase(
      'bank.db',
      version: 1,
      onCreate: (database, version) {
        print('database created');
        database.execute(
            'CREATE TABLE Bank (id INTEGER PRIMARY KEY, name TEXT,email TEXT, balance TEXT,transactions TEXT)');
        print('table created');
        database.transaction((txn) async {
          await txn
              .rawInsert(
                  'INSERT INTO Bank(name,balance,email) VALUES("hussein","8000","husseinzomar@gmail.com")')
              .then((value) {
            print("$value inserted successfully");
          }).catchError((error) {
            print("error when inserting  Record ${error.toString()}");
          });
          await txn
              .rawInsert(
                  'INSERT INTO Bank(name,balance,email) VALUES("hussein","55456","hussein6190@gmail.com")')
              .then((value) {
            print("$value inserted successfully");
          }).catchError((error) {
            print("error when inserting  Record ${error.toString()}");
          });
          await txn
              .rawInsert(
                  'INSERT INTO Bank(name,balance,email) VALUES("hassan","6945","hassanzomar@gmail.com")')
              .then((value) {
            print("$value inserted successfully");
          }).catchError((error) {
            print("error when inserting  Record ${error.toString()}");
          });
          await txn
              .rawInsert(
                  'INSERT INTO Bank(name,balance,email) VALUES("ahmed","5964","ahmed@gmail.com")')
              .then((value) {
            print("$value inserted successfully");
          }).catchError((error) {
            print("error when inserting  Record ${error.toString()}");
          });
        });
      },
      onOpen: (database) {
        getDataFromDataBase(database).then((value) {
          data = value;
          print(data);

          emit(AppGetDatabaseState());
        });
        print('database opened');
      },
    ).then((value) {
      database = value;

      emit(AppCreateDatabaseState());
    });
  }

  insertToDatabase() async {
    await database.transaction((txn) async {
      await txn
          .rawInsert(
              'INSERT INTO Bank(name,balance,email) VALUES("hussein","1200","husseinzomar@gmail.com")')
          .then((value) {
        print("$value inserted successfully");
        emit(AppInsertDatabaseState());

        getDataFromDataBase(database).then((value) {
          data = value;
          print(data);
          emit(AppGetDatabaseState());
        });
      }).catchError((error) {
        print("error when inserting  Record ${error.toString()}");
      });
      return null;
    });
  }

  Future<List<Map>> getDataFromDataBase(database) async {
    emit(AppGetDatabaseLoadingState());
    return await database.rawQuery('SELECT * FROM Bank');
    // print(data);
  }

  void changeBottomSheetState({required bool isshow, required IconData icon}) {
    isbottomsheet = isshow;
    fabIcon = icon;
    emit(AppChangeBottomNavBarState());
  }
}
