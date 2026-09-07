import 'package:flutter/foundation.dart';
import '../models/car.dart';

class CartItem {
  final Car car;
  int quantity;

  CartItem({required this.car, this.quantity = 1});

  double get subtotal => car.price * quantity;
}

class CartProvider with ChangeNotifier {
  final Map<String, CartItem> _items = {};

  Map<String, CartItem> get items => {..._items};

  int get itemCount {
    return _items.values.fold(0, (sum, item) => sum + item.quantity);
  }

  double get totalAmount {
    return _items.values.fold(0.0, (sum, item) => sum + item.subtotal);
  }

  void addItem(Car car) {
    if (_items.containsKey(car.id)) {
      _items[car.id]!.quantity += 1;
    } else {
      _items[car.id] = CartItem(car: car);
    }
    notifyListeners();
  }

  void incrementQuantity(String carId) {
    if (_items.containsKey(carId)) {
      _items[carId]!.quantity += 1;
      notifyListeners();
    }
  }

  void decrementQuantity(String carId) {
    if (_items.containsKey(carId)) {
      if (_items[carId]!.quantity > 1) {
        _items[carId]!.quantity -= 1;
      } else {
        _items.remove(carId);
      }
      notifyListeners();
    }
  }

  void removeItem(String carId) {
    _items.remove(carId);
    notifyListeners();
  }

  void clear() {
    _items.clear();
    notifyListeners();
  }
}
