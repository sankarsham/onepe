import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:onepe/data/model.dart/product.dart';
import 'package:onepe/presentation/bloc/order_state.dart';

class OrderCubit extends Cubit<OrderState> {
  OrderCubit() : super(OrderState.initial());

  void selectTable(String tableName) async {
    emit(state.copyWith(tableSelectionNetworkStatus: NetworkStatus.loading));
    await Future.delayed(Duration(seconds: 1));
    emit(state.copyWith(selectedTable: tableName, orderList: [], tableSelectionNetworkStatus: NetworkStatus.loaded));
  }

  void resetOrder(String tableName) async {
    emit(state.copyWith(tableSelectionNetworkStatus: NetworkStatus.loading));

    await Future.delayed(Duration(seconds: 1));

    emit(state.copyWith(selectedTable: tableName, orderList: [], tableSelectionNetworkStatus: NetworkStatus.loaded));
  }

  void addProduct(Product product, int qty) {
    emit(state.copyWith(qtyNetworkStatus: NetworkStatus.loading));
    if (state.orderList.isEmpty) {
      product.qty = qty + 1;
      emit(state.copyWith(orderList: [product]));
    } else {
      Product existingProduct = state.orderList.firstWhere((element) {
        return element.productId == product.productId;
      }, orElse: () => Product.initial());

      if (existingProduct.productId.isNotEmpty) {
        int index = state.orderList.indexWhere((element) => element.productId == existingProduct.productId);

        List<Product> order = List.from(state.orderList); // ✅ NEW LIST

        Product updatedProduct = order[index].copyWith(qty: order[index].qty + 1);

        order[index] = updatedProduct;

        emit(state.copyWith(orderList: order, qtyNetworkStatus: NetworkStatus.loaded));
      } else {
        List<Product> order = List.from(state.orderList); //
        product.qty = qty + 1;
        order.add(product);
        emit(state.copyWith(orderList: [...order], qtyNetworkStatus: NetworkStatus.loaded));
      }
    }
    emit(state.copyWith(qtyNetworkStatus: NetworkStatus.loaded));
  }

  void removeProduct(Product product) {
    if (state.orderList.isNotEmpty) {
      emit(state.copyWith(qtyNetworkStatus: NetworkStatus.loading));
      int index = state.orderList.indexWhere((element) => element.productId == product.productId);

      Product removeproduct = state.orderList[index];
      if (removeproduct.qty > 0) {
        removeproduct.qty--;
        emit(state.copyWith(orderList: [removeproduct, ...state.orderList], qtyNetworkStatus: NetworkStatus.loaded));
      } else {
        state.orderList.removeAt(index);
        emit(state.copyWith(orderList: state.orderList, qtyNetworkStatus: NetworkStatus.loaded));
      }
    }
  }

  void gettingdata() async {
    emit(state.copyWith(networkStatus: NetworkStatus.loading));

    await Future.delayed(Duration(seconds: 2));

    emit(state.copyWith(networkStatus: NetworkStatus.loaded));
  }
}
