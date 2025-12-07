import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_application_1/api_config.dart';
import 'package:flutter_application_1/main.dart';

class MenuItemModel {
  final String id;
  final String name;
  final String category;
  final int price;
  final bool available;
  final String image;

  MenuItemModel({
    required this.id,
    required this.name,
    required this.category,
    required this.price,
    required this.available,
    required this.image,
  });

  factory MenuItemModel.fromJson(Map<String, dynamic> json) {
    return MenuItemModel(
      id: json['menu_id'],
      name: json['menu_name'],
      category: json['category_id'],
      price: (json['price'] is int)
          ? json['price']
          : int.tryParse(json['price'].toString()) ?? 0,
      available: json['available'] == 1 || json['available'] == "1",
      image: json['path'],
    );
  }
}

class CartItem {
  final MenuItemModel menu;
  int qty;
  CartItem({required this.menu, required this.qty});
}

class WaiterOrderScreen extends StatefulWidget {
  const WaiterOrderScreen({super.key});

  @override
  State<WaiterOrderScreen> createState() => _WaiterOrderScreenState();
}

class _WaiterOrderScreenState extends State<WaiterOrderScreen> {
  List<MenuItemModel> menus = [];
  String activeCategory = 'All';
  TextEditingController searchController = TextEditingController();
  final List<String> categories = [
    'All',
    'MainCourse',
    'Dessert',
    'Drinks',
    'Appetizer',
  ];

  final Map<String, CartItem> cart = {};

  bool loading = false;

  @override
  void initState() {
    super.initState();
    fetchMenus();
  }

  Future<void> fetchMenus() async {
    setState(() => loading = true);
    String url = ApiConfig.menuListWaiter;
    List<String> params = [];
    if (activeCategory != 'All') {
      params.add('category=${Uri.encodeComponent(activeCategory)}');
    }
    if (searchController.text.isNotEmpty) {
      params.add('search=${Uri.encodeComponent(searchController.text)}');
    }
    if (params.isNotEmpty) url += '?${params.join('&')}';

    try {
      final res = await http.get(Uri.parse(url));
      final body = json.decode(res.body);
      if (body['success'] == true) {
        menus = (body['data'] as List)
            .map((e) => MenuItemModel.fromJson(e))
            .toList();
      } else {
        menus = [];
      }
    } catch (e) {
      menus = [];
      debugPrint('fetchMenus error: $e');
    } finally {
      setState(() => loading = false);
    }
  }

  void addToCart(MenuItemModel menu) {
    if (!menu.available) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Menu not available')));
      return;
    }
    setState(() {
      if (cart.containsKey(menu.id)) {
        cart[menu.id]!.qty += 1;
      } else {
        cart[menu.id] = CartItem(menu: menu, qty: 1);
      }
    });
  }

  int cartCount() => cart.values.fold(0, (s, c) => s + c.qty);
  int cartTotal() => cart.values.fold(0, (s, c) => s + c.qty * c.menu.price);

  void openCartSummary() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        int tableNumber = 0;
        return StatefulBuilder(
          builder: (context, setSheetState) {
            return DraggableScrollableSheet(
              expand: false,
              initialChildSize: 0.7,
              builder: (_, controller) {
                return Container(
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(20),
                    ),
                  ),
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      const SizedBox(height: 6),
                      Container(
                        width: 60,
                        height: 6,
                        decoration: BoxDecoration(
                          color: Colors.grey[300],
                          borderRadius: BorderRadius.circular(3),
                        ),
                      ),
                      const SizedBox(height: 12),
                      const Text(
                        'Ringkasan Pesanan',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 12),
                      TextField(
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          labelText: 'Nomor Meja',
                          border: OutlineInputBorder(),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: AppColors.accentGreen,
                            ),
                          ),
                          floatingLabelStyle: TextStyle(
                            color: AppColors.accentGreen,
                          ),
                        ),
                        onChanged: (v) => setSheetState(
                          () => tableNumber = int.tryParse(v) ?? 0,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Expanded(
                        child: ListView(
                          controller: controller,
                          children: [
                            for (var e in cart.entries)
                              ListTile(
                                title: Text(e.value.menu.name),
                                subtitle: Text('Rp ${e.value.menu.price}'),
                                trailing: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    IconButton(
                                      icon: const Icon(
                                        Icons.remove_circle_outline,
                                      ),
                                      onPressed: () {
                                        setSheetState(() {
                                          if (e.value.qty <= 1) {
                                            cart.remove(e.key);
                                          } else {
                                            e.value.qty -= 1;
                                          }
                                        });
                                        setState(() {});
                                      },
                                    ),
                                    Text('${e.value.qty}'),
                                    IconButton(
                                      icon: const Icon(
                                        Icons.add_circle_outline,
                                      ),
                                      onPressed: () {
                                        setSheetState(() {
                                          e.value.qty += 1;
                                        });
                                        setState(() {});
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            const SizedBox(height: 10),
                            ListTile(
                              title: const Text('Total'),
                              trailing: Text('Rp ${cartTotal()}'),
                            ),
                            const SizedBox(height: 10),
                            Text(
                              'Payment method',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                Expanded(
                                  child: ElevatedButton(
                                    onPressed: () {
                                      // cash flow
                                      Navigator.of(context).pop();
                                      createOrderAndPay(tableNumber, 'CASH');
                                    },
                                    child: const Text(
                                      'Cash',
                                      style: TextStyle(
                                        color: AppColors.accentGreen,
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: ElevatedButton(
                                    onPressed: () {
                                      // show qris then place order
                                      Navigator.of(context).pop();
                                      showQRISThenPlaceOrder(tableNumber);
                                    },
                                    child: const Text(
                                      'QRIS',
                                      style: TextStyle(
                                        color: AppColors.accentGreen,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 20),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            );
          },
        );
      },
    );
  }

  Future<void> showQRISThenPlaceOrder(int tableNumber) async {
    // show QRIS dialog
    await showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          title: const Text('Scan QRIS'),
          backgroundColor: AppColors.cardWhite,
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset('assets/images/qris.png', height: 220),
              const SizedBox(height: 8),
              Text('Meja: $tableNumber'),
              const SizedBox(height: 8),
              const Text('Selesaikan pembayaran lalu tekan "Buat Pesanan"'),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text(
                'Batal',
                style: TextStyle(color: AppColors.accentGreen),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                createOrderAndPay(tableNumber, 'QRIS');
              },
              child: const Text(
                'Buat Pesanan',
                style: TextStyle(color: AppColors.accentGreen),
              ),
            ),
          ],
        );
      },
    );
  }

  Future<void> createOrderAndPay(int tableNumber, String paymentMethod) async {
    if (cart.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Keranjang masih kosong'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    if (tableNumber <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Masukkan nomor meja yang valid'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    final items = cart.values
        .map((c) => {'menu_id': c.menu.id, 'quantity': c.qty})
        .toList();

    final payload = {
      'table_id': 'T_$tableNumber',
      'items': items,
      'payment_method': paymentMethod,
    };

    try {
      final res = await http.post(
        Uri.parse(ApiConfig.createOrder),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(payload),
      );

      final body = json.decode(res.body);

      if (body['success'] == true) {
        setState(() => cart.clear());

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Center(
              child: Text(
                'Order meja $tableNumber berhasil dibuat',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            backgroundColor: Colors.green,
            behavior: SnackBarBehavior.floating,
            margin: const EdgeInsets.all(12),
            duration: const Duration(seconds: 3),
          ),
        );
        return;
      }
      final errorMessage =
          body['message'] ?? body['error'] ?? 'Terjadi kesalahan pada server';

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Pesanan gagal dibuat',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 4),
              Text(errorMessage),
            ],
          ),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
          margin: const EdgeInsets.all(12),
          duration: const Duration(seconds: 4),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                '❌ Pesanan gagal dibuat',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 4),
              Text(e.toString()),
            ],
          ),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
          margin: const EdgeInsets.all(12),
          duration: const Duration(seconds: 4),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Table Order'),
        backgroundColor: Colors.transparent,
      ),
      backgroundColor: const Color(0xFFE6EABD),
      body: Column(
        children: [
          // search & categories
          Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: searchController,
                    decoration: const InputDecoration(
                      hintText: 'Search menu',
                      filled: true,
                      fillColor: Colors.white,
                      prefixIcon: Icon(Icons.search),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(12)),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    onChanged: (_) => fetchMenus(),
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  onPressed: fetchMenus,
                  icon: const Icon(Icons.refresh),
                ),
              ],
            ),
          ),

          SizedBox(
            height: 44,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              children: categories.map((c) {
                final active = c == activeCategory;
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: ChoiceChip(
                    label: Text(c),
                    selected: active,
                    onSelected: (val) {
                      setState(() {
                        activeCategory = c;
                      });
                      fetchMenus();
                    },
                  ),
                );
              }).toList(),
            ),
          ),

          const SizedBox(height: 12),

          // grid
          Expanded(
            child: loading
                ? const Center(child: CircularProgressIndicator())
                : menus.isEmpty
                ? const Center(child: Text('Menu kosong'))
                : GridView.builder(
                    padding: const EdgeInsets.all(12),
                    itemCount: menus.length,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          childAspectRatio: 0.78,
                          mainAxisSpacing: 12,
                          crossAxisSpacing: 12,
                        ),
                    itemBuilder: (_, i) {
                      final m = menus[i];
                      return GestureDetector(
                        onTap: () => addToCart(m),
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: ClipRRect(
                                  borderRadius: const BorderRadius.vertical(
                                    top: Radius.circular(12),
                                  ),
                                  child: Image.network(
                                    m.image,
                                    width: double.infinity,
                                    fit: BoxFit.cover,
                                    errorBuilder: (_, __, ___) => const Center(
                                      child: Icon(Icons.image_not_supported),
                                    ),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      m.name,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      'Rp ${m.price}',
                                      style: const TextStyle(
                                        color: Colors.grey,
                                        fontSize: 12,
                                      ),
                                    ),
                                    const SizedBox(height: 6),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          m.available ? 'Available' : 'Empty',
                                          style: TextStyle(
                                            color: m.available
                                                ? Colors.green
                                                : Colors.red,
                                          ),
                                        ),
                                        CircleAvatar(
                                          radius: 14,
                                          backgroundColor: AppColors.primary,
                                          child: const Icon(
                                            Icons.add,
                                            color: Colors.white,
                                            size: 16,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: openCartSummary,
        backgroundColor: AppColors.primary,
        icon: const Icon(Icons.shopping_cart, color: AppColors.background),
        label: Text(
          'Ringkasan (${cartCount()})',
          style: TextStyle(color: AppColors.background),
        ),
      ),
    );
  }
}
