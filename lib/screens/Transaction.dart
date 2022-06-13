import 'package:bankapp/shared/cubit.dart';
import 'package:bankapp/shared/states.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class Transactions extends StatelessWidget {
  const Transactions({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppStates>(
        listener: (BuildContext context, AppStates state) {},
        builder: (BuildContext context, AppStates state) {
          var data = AppCubit.get(context).data;
          return ListView.separated(
            itemBuilder: (context, index) => buildItem(data[index]),
            separatorBuilder: (context, index) => Container(
              width: double.infinity,
              height: 3,
              color: Colors.grey,
            ),
            itemCount: data.length,
          );
        });
  }

  Widget buildItem(Map model) => Padding(
        padding: const EdgeInsets.all(10.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.all(Radius.circular(10))),
                height: 50,
                child: Center(
                  child: Text(
                    '${model['name']}',
                    style:
                        TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ),
            SizedBox(
              width: 10.0,
            ),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                    color: Colors.lightBlue,
                    borderRadius: BorderRadius.all(Radius.circular(10))),
                height: 50,
                child: Center(
                  child: Text(
                    '${model['transactions']}',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ),
          ],
        ),
      );
}
