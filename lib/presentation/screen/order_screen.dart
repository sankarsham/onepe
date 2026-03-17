import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:onepe/data/model.dart/product.dart';
import 'package:onepe/presentation/bloc/order_cubit.dart';
import 'package:onepe/presentation/bloc/order_state.dart';
import 'package:onepe/presentation/screen/preview_screen.dart';
import 'package:onepe/presentation/widget/product_widget.dart';
import 'package:onepe/utils/constant.dart';

class OrderScreen extends StatelessWidget {
  const OrderScreen({super.key});

  Product checkProductQty(List<Product> ordersList, String productId) {
    Product product = ordersList.firstWhere((element) {
      return element.productId == productId;
    }, orElse: () => Product.initial());
    return product;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: Theme.of(context).colorScheme.inversePrimary, title: Text("Order Screen")),

      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: 10),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      BlocBuilder<OrderCubit, OrderState>(
                        builder: (context, state) {
                          return DropdownMenu(
                            onSelected: (value) {
                              context.read<OrderCubit>().selectTable(value ?? '');
                            },
                            initialSelection: state.selectedTable.isNotEmpty ? state.selectedTable : null,

                            label: const Text("Select Table"),
                            dropdownMenuEntries: tableList.map((e) => DropdownMenuEntry(value: e, label: e)).toList(),
                          );
                        },
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                  BlocBuilder<OrderCubit, OrderState>(
                    builder: (context, state) {
                      if (state.tableSelectionNetworkStatus == NetworkStatus.loading ||
                          state.qtyNetworkStatus == NetworkStatus.loading) {
                        return SizedBox(
                          height: 200,
                          child: Container(height: 50, width: 50, child: Center(child: CircularProgressIndicator())),
                        );
                      } else {
                        if (state.selectedTable.isNotEmpty) {
                          return ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: productList.length,
                            itemBuilder: (context, index) {
                              Product product = checkProductQty(state.orderList, productList[index].productId);
                              return ProductWidget(productList[index], product.qty, true);
                            },
                          );
                        }
                      }
                      return const Text("Select Table");
                    },
                  ),
                ],
              ),
            ),
          ),

          BlocBuilder<OrderCubit, OrderState>(
            builder: (context, state) {
              if (state.tableSelectionNetworkStatus != NetworkStatus.loading && state.orderList.isNotEmpty) {
                return Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                          onPressed: () {
                            context.read<OrderCubit>().gettingdata();
                            Navigator.push(context, MaterialPageRoute(builder: (context) => const PreviewScreen()));
                          },
                          child: Text("Take Order", style: TextStyle(color: Colors.white)),
                        ),
                      ),
                    ],
                  ),
                );
              } else {
                return Container();
              }
            },
          ),
          SizedBox(height: 20),
        ],
      ),
    );
  }
}
