import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:onepe/data/model.dart/product.dart';
import 'package:onepe/presentation/bloc/order_cubit.dart';

class ProductWidget extends StatelessWidget {
  Product product;
  int qty;
  bool isEdit;
  ProductWidget(this.product, this.qty, this.isEdit, {super.key});

  @override
  Widget build(BuildContext context) {
    print("ss"+qty.toString());
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              children: [
                Text(product.name, style: TextStyle(fontWeight: FontWeight.bold)),

                Text("price ${product.price}"),
              ],
            ),

            Row(
              children: [
                if (isEdit)
                  TextButton(
                    onPressed: () {
                      context.read<OrderCubit>().removeProduct(product);
                    },
                    child: Text("-"),
                  ),

                Row(children: [if (!isEdit) Text("Qty"), if (!isEdit) SizedBox(width: 10), Text(qty.toString())]),
                if (isEdit)
                  TextButton(
                    onPressed: () {
                      context.read<OrderCubit>().addProduct(product,qty);
                    },
                    child: Text("+"),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
