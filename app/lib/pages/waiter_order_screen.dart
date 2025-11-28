import 'package:flutter/material.dart';
import 'package:flutter_application_1/main.dart';

class WaiterOrderScreen extends StatefulWidget {
  const WaiterOrderScreen({super.key});

  @override
  State<WaiterOrderScreen> createState() => _WaiterOrderScreenState();
}

class _WaiterOrderScreenState extends State<WaiterOrderScreen> {
  final Map<String, int> _orders = {};
  int tableNumber = 0;

  void _addOrder(String item) {
    setState(() {
      _orders[item] = (_orders[item] ?? 0) + 1;
    });
  }

  void _openSummary() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setStateSheet) {
            return Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    "Ringkasan Pesanan",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 15),

                  
                  TextField(
                    decoration: const InputDecoration(
                      labelText: "Nomor Meja",
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.number,
                    onChanged: (value) {
                      setStateSheet(() {
                        tableNumber = int.tryParse(value) ?? 0;
                      });
                    },
                  ),
                  const SizedBox(height: 20),

                  
                  ..._orders.entries.map((e) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("${e.key}  x${e.value}", style: const TextStyle(fontSize: 16)),
                          Row(
                            children: [
                              IconButton(
                                  onPressed: () {
                                    setStateSheet(() {
                                      if (_orders[e.key] == 1) {
                                        _orders.remove(e.key);
                                      } else {
                                        _orders[e.key] = e.value - 1;
                                      }
                                      setState(() {});
                                    });
                                  },
                                  icon: const Icon(Icons.remove_circle_outline)),
                              IconButton(
                                  onPressed: () {
                                    setStateSheet(() {
                                      _orders[e.key] = e.value + 1;
                                      setState(() {});
                                    });
                                  },
                                  icon: const Icon(Icons.add_circle_outline)),
                            ],
                          )
                        ],
                      ),
                    );
                  }),

                  const SizedBox(height: 20),

                  ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                      _showQRISOverlay();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      minimumSize: const Size(double.infinity, 50),
                    ),
                    child: const Text("Payment", style: TextStyle(color: Colors.white)),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  void _showQRISOverlay() {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text("Scan QRIS", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 20),

                // QRIS Barcode
                Image.asset(
                  "assets/images/qris.png",
                  height: 250,
                ),

                const SizedBox(height: 20),
                Text(
                  "Meja: $tableNumber",
                  style: const TextStyle(fontSize: 16),
                ),
                const SizedBox(height: 10),
                const Text("Silakan selesaikan pembayaran."),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Table Order"), backgroundColor: Colors.transparent),
      backgroundColor: Color(0xFFE6EABD),

      body: Column(
        children: [
          
          SizedBox(
            height: 50,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              children: const [
                Padding(padding: EdgeInsets.only(right: 20), child: Text("Main Course", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16))),
                Padding(padding: EdgeInsets.only(right: 20), child: Text("Dessert", style: TextStyle(color: Colors.grey))),
                Padding(padding: EdgeInsets.only(right: 20), child: Text("Drinks", style: TextStyle(color: Colors.grey))),
              ],
            ),
          ),

          
          Expanded(
            child: GridView.count(
              crossAxisCount: 2,
              padding: const EdgeInsets.all(20),
              childAspectRatio: 0.8,
              mainAxisSpacing: 15,
              crossAxisSpacing: 15,
              children: [
                _menuItemWaiter("Salmon", "\$16.00"),
                _menuItemWaiter("Burger", "\$8.00"),
                _menuItemWaiter("Salad", "\$12.00"),
                _menuItemWaiter("Tiramisu", "\$14.00"),
              ],
            ),
          ),
        ],
      ),

      
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _openSummary,
        backgroundColor: AppColors.primary,
        label: Text("Ringkasan (${_orders.values.fold(0, (a, b) => a + b)})",
            style: const TextStyle(color: Colors.white)),
        icon: const Icon(Icons.shopping_cart, color: Colors.white),
      ),
    );
  }

  
  Widget _menuItemWaiter(String name, String price) {
    return GestureDetector(
      onTap: () => _addOrder(name),
      child: Container(
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(15)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.fastfood, size: 50, color: Colors.orange),
            const SizedBox(height: 10),
            Text(name, style: const TextStyle(fontWeight: FontWeight.bold)),
            Text(price),
            const SizedBox(height: 10),
            const CircleAvatar(radius: 15, backgroundColor: AppColors.primary, child: Icon(Icons.add, color: Colors.white, size: 16)),
          ],
        ),
      ),
    );
  }
}
