import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:onepe/presentation/bloc/order_cubit.dart';
import 'package:onepe/presentation/bloc/order_state.dart';
import 'package:onepe/presentation/screen/home_screen.dart';
import 'package:onepe/presentation/widget/product_widget.dart';
import 'package:onepe/utils/constant.dart';

class PreviewScreen extends StatefulWidget {
  const PreviewScreen({super.key});

  @override
  State<PreviewScreen> createState() => _PreviewScreenState();
}

class _PreviewScreenState extends State<PreviewScreen> {
  Timer? _timer;
  int _seconds = 0;

  startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      // setState(() {
      _seconds++;
      //});

      print(_seconds);
      if (_seconds == 60) {
        _timer?.cancel();
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => MyHomePage(title: 'Order')),
          (route) => false,
        );
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  void initState() {
    // TODO: implement initState
    startTimer();
    super.initState();
  }

  Future<void> _showSubmitOrderDialog(BuildContext context) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Submit Order'),
          content: SingleChildScrollView(
            child: ListBody(children: const <Widget>[Text('Are you sure you want to submit the order?')]),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Submit'),
              onPressed: () {
                context.read<OrderCubit>().resetOrder('');

                Navigator.of(context).pop();

                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => MyHomePage(title: 'Order')),
                  (route) => false,
                );
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Preview')),
      body: BlocBuilder<OrderCubit, OrderState>(
        builder: (context, state) {
          print(state.selectedTable);

          print(state.orderList);

          if (state.networkStatus == NetworkStatus.loading) {
            return Center(child: CircularProgressIndicator());
          } else {
            return Center(
              child: Column(
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          Text('Preview Screen'),

                          Row(children: [Text("Table Name"), Text(state.selectedTable)]),

                          BlocBuilder<OrderCubit, OrderState>(
                            builder: (context, state) {
                              return ListView.builder(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: state.orderList.length,
                                itemBuilder: (context, index) =>
                                    ProductWidget(state.orderList[index], state.orderList[index].qty, false),
                              );
                            },
                            // return const Text("Select Table");
                          ),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Row(
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                            onPressed: () {
                              _showSubmitOrderDialog(context);
                            },
                            child: Text("Submit Order", style: TextStyle(color: Colors.white)),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 20),
                ],
              ),
            );
          }
        },
      ),
    );
  }
}
