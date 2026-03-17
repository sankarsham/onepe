import 'package:equatable/equatable.dart';
import 'package:onepe/data/model.dart/product.dart';

class OrderState extends Equatable {
  final NetworkStatus networkStatus, tableSelectionNetworkStatus, qtyNetworkStatus;
  final String selectedTable;
  final List<Product> orderList;

  const OrderState({
    required this.networkStatus,
    required this.selectedTable,
    required this.orderList,
    required this.tableSelectionNetworkStatus,
    required this.qtyNetworkStatus,
  });

  @override
  List<Object?> get props => [selectedTable, networkStatus, orderList, tableSelectionNetworkStatus];

  factory OrderState.initial() => OrderState(
    networkStatus: NetworkStatus.initial,
    selectedTable: "",
    orderList: [],
    tableSelectionNetworkStatus: NetworkStatus.initial,
    qtyNetworkStatus: NetworkStatus.initial,
  );

  OrderState copyWith({
    NetworkStatus? networkStatus,
    String? selectedTable,
    List<Product>? orderList,
    NetworkStatus? tableSelectionNetworkStatus,
    NetworkStatus? qtyNetworkStatus,
  }) {
    return OrderState(
      networkStatus: networkStatus ?? this.networkStatus,
      selectedTable: selectedTable ?? this.selectedTable,
      orderList: orderList ?? this.orderList,
      tableSelectionNetworkStatus: tableSelectionNetworkStatus ?? this.tableSelectionNetworkStatus,
      qtyNetworkStatus: qtyNetworkStatus ?? this.qtyNetworkStatus,
    );
  }
}

enum NetworkStatus { initial, loading, loaded, error }
