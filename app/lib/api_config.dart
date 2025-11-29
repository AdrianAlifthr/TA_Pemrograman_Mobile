class ApiConfig {
  static const String baseUrl = "http://10.0.2.2/API_restaurant_app";

  static String countTables = "$baseUrl/count_table_available.php";
  static String login = "$baseUrl/login.php";
  static String activeOrder = "$baseUrl/active_orders.php";
  static String tablesStatus = "$baseUrl/tables_status.php";
  static String updateTableStatus = "$baseUrl/update_table_status.php";
  static String orderList = "$baseUrl/order_list.php";
  static String tablesView = "$baseUrl/tables_view_status.php";
}
