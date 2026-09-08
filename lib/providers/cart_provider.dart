import 'package:flutter/foundation.dart';
import '../models/car.dart';

// Represents an item entry within the shopping cart.
// Wraps a Car instance and tracks how many of that car have been added.
class CartItem {
  final Car car; // The vehicle object added to cart
  int quantity;  // Current quantity selected by the user

  CartItem({required this.car, this.quantity = 1});

  // Getter to calculate the subtotal cost for this specific item line (price * quantity)
  double get subtotal => car.price * quantity;
}

// State management class for the shopping cart using Provider and ChangeNotifier.
// Holds the cart state globally and notifies listeners whenever the cart contents change.
class CartProvider with ChangeNotifier {
  // Private internal map storing cart items keyed by car ID for fast lookups
  final Map<String, CartItem> _items = {};

  // Getter returning an unmodifiable copy of the cart items map to prevent external direct mutation
  Map<String, CartItem> get items => {..._items};

  // Calculates the total number of individual items currently in the cart
  int get itemCount {
    return _items.values.fold(0, (sum, item) => sum + item.quantity);
  }

  // Calculates the overall total cost of all items in the cart
  double get totalAmount {
    return _items.values.fold(0.0, (sum, item) => sum + item.subtotal);
  }

  // Adds a car to the cart. If the car is already in the cart, increments its quantity by 1.
  void addItem(Car car) {
    if (_items.containsKey(car.id)) {
      // Car already exists in cart, increment quantity
      _items[car.id]!.quantity += 1;
    } else {
      // New car item, create a new CartItem entry
      _items[car.id] = CartItem(car: car);
    }
    // Triggers rebuild on all listening widgets (like CartScreen and badge counts)
    notifyListeners();
  }

  // Increments the quantity of a specific item in the cart by 1
  void incrementQuantity(String carId) {
    if (_items.containsKey(carId)) {
      _items[carId]!.quantity += 1;
      notifyListeners();
    }
  }

  // Decrements the quantity of a specific item in the cart. 
  // If quantity reaches 0 (decremented from 1), removes the item from the cart entirely.
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

  // Manually removes an item completely from the cart regardless of its quantity
  void removeItem(String carId) {
    _items.remove(carId);
    notifyListeners();
  }

  // Empties the entire cart (used after successful checkout)
  void clear() {
    _items.clear();
    notifyListeners();
  }
}
