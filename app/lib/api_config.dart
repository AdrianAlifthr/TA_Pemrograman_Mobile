import 'package:flutter_dotenv/flutter_dotenv.dart';

class ApiConfig {
  static String get baseUrl => dotenv.env['API_URL'] ?? '';

  static String get countTables => "$baseUrl/count_table_available.php";
  static String get login => "$baseUrl/login.php";
  static String get activeOrder => "$baseUrl/active_orders.php";
  static String get tablesStatus => "$baseUrl/tables_status.php";
  static String get updateTableStatus => "$baseUrl/update_table_status.php";
  static String get orderList => "$baseUrl/order_list.php";
  static String get tablesView => "$baseUrl/tables_view_status.php";
  static String get menuList => "$baseUrl/menu_list.php";
  static String get menuUpdate => "$baseUrl/menu_update_available.php";
  static String get menuListWaiter => "$baseUrl/menu_list.php";
  static String get createOrder => "$baseUrl/create_order.php";
  static String get kitchenTaks => "$baseUrl/kitchen_taks.php";
  static String get updateKitchen => "$baseUrl/update_kitchen_status.php";
  static String get updateOrderStatus => "$baseUrl/update_order_status.php";
}
