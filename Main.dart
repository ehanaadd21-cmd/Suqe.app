import 'package:flutter/material.dart';

void main() {
  runApp(const SuqeApp());
}

class SuqeApp extends StatelessWidget {
  const SuqeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ሱቄ - የሱቅ ሂሳብ መቆጣጠሪያ',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.teal,
        useMaterial3: true,
        fontFamily: 'Roboto',
      ),
      home: const HomeScreen(),
    );
  }
}

// ----------------------------------------------------
// የዕቃ መረጃ መዋቅር (Item Model)
// ----------------------------------------------------
class Item {
  String id;
  String name;
  double buyPrice;
  double sellPrice;
  int quantity;

  Item({
    required this.id,
    required this.name,
    required this.buyPrice,
    required this.sellPrice,
    required this.quantity,
  });
}

// ----------------------------------------------------
// የሽያጭ መረጃ መዋቅር (Sale Model)
// ----------------------------------------------------
class SaleRecord {
  String itemName;
  int quantity;
  double totalAmount;
  double profit;
  DateTime date;

  SaleRecord({
    required this.itemName,
    required this.quantity,
    required this.totalAmount,
    required this.profit,
    required this.date,
  });
}

// ----------------------------------------------------
// የብድር መረጃ መዋቅር (Credit Model)
// ----------------------------------------------------
class CreditRecord {
  String customerName;
  String phone;
  double amount;
  String itemName;

  CreditRecord({
    required this.customerName,
    required this.phone,
    required this.amount,
    required this.itemName,
  });
}

// ----------------------------------------------------
// 1. ዋና ገጽ (Home Screen)
// ----------------------------------------------------
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // ናሙና መረጃዎች (In-memory storage)
  List<Item> inventory = [
    Item(id: '1', name: 'ስኳር (1 ኪ.ግ)', buyPrice: 100, sellPrice: 120, quantity: 20),
    Item(id: '2', name: 'ዘይት (3 ሊትር)', buyPrice: 800, sellPrice: 920, quantity: 5),
  ];

  List<SaleRecord> sales = [];
  List<CreditRecord> credits = [];

  double get todaySalesTotal {
    return sales.fold(0, (sum, item) => sum + item.totalAmount);
  }

  double get todayProfitTotal {
    return sales.fold(0, (sum, item) => sum + item.profit);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ሱቄ - የሱቅ ሂሳብ', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
        elevation: 2,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // 1. የዛሬው አጠቃላይ ሁኔታ Card
            Card(
              color: Colors.teal.shade50,
              elevation: 4,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    const Text('የዛሬው አጠቃላይ ሁኔታ', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.teal)),
                    const SizedBox(height: 15),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Column(
                          children: [
                            const Text('የዛሬ ሽያጭ', style: TextStyle(color: Colors.grey)),
                            const SizedBox(height: 5),
                            Text('${todaySalesTotal.toStringAsFixed(2)} ብር',
                                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87)),
                          ],
                        ),
                        Container(height: 40, width: 1, color: Colors.teal.shade200),
                        Column(
                          children: [
                            const Text('የዛሬ የተጣራ ትርፍ', style: TextStyle(color: Colors.grey)),
                            const SizedBox(height: 5),
                            Text('${todayProfitTotal.toStringAsFixed(2)} ብር',
                                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.green)),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 25),

            // ዋና ቁልፎች (Grid Buttons)
            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              crossAxisSpacing: 15,
              mainAxisSpacing: 15,
              children: [
                _buildMenuButton(
                  context,
                  title: 'ሽያጭ መዝግብ',
                  icon: Icons.add_shopping_cart,
                  color: Colors.green,
                  onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => AddSaleScreen(inventory: inventory, onSaleAdded: (sale) {
                    setState(() {
                      sales.add(sale);
                    });
                  }))),
                ),
                _buildMenuButton(
                  context,
                  title: 'ዕቃ አስገባ / ክምችት',
                  icon: Icons.inventory_2,
                  color: Colors.blue,
                  onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => InventoryScreen(inventory: inventory))),
                ),
                _buildMenuButton(
                  context,
                  title: 'የብድር መዝገብ',
                  icon: Icons.book,
                  color: Colors.orange,
                  onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => CreditScreen(credits: credits))),
                ),
                _buildMenuButton(
                  context,
                  title: 'የቀን ሂሳብ / ሪፖርት',
                  icon: Icons.bar_chart,
                  color: Colors.purple,
                  onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => ReportsScreen(sales: sales))),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuButton(BuildContext context, {required String title, required IconData icon, required Color color, required VoidCallback onTap}) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(15),
      child: Container(
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color: color.withOpacity(0.3), width: 1.5),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 45, color: color),
            const SizedBox(height: 10),
            Text(title, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: color), textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }
}

// ----------------------------------------------------
// 2. ሽያጭ መዝገቢያ ገጽ (Add Sale Screen)
// ----------------------------------------------------
class AddSaleScreen extends StatefulWidget {
  final List<Item> inventory;
  final Function(SaleRecord) onSaleAdded;

  const AddSaleScreen({super.key, required this.inventory, required this.onSaleAdded});

  @override
  State<AddSaleScreen> createState() => _AddSaleScreenState();
}

class _AddSaleScreenState extends State<AddSaleScreen> {
  Item? selectedItem;
  final TextEditingController quantityController = TextEditingController(text: '1');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('አዲስ ሽያጭ መዝግብ'), backgroundColor: Colors.green, foregroundColor: Colors.white),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            DropdownButtonFormField<Item>(
              decoration: const InputDecoration(labelText: 'የተሸጠውን ዕቃ ምረጪ', border: OutlineInputBorder()),
              items: widget.inventory.map((item) {
                return DropdownMenuItem<Item>(
                  value: item,
                  child: Text('${item.name} (ያለው ብዛት: ${item.quantity})'),
                );
              }).toList(),
              onChanged: (val) => setState(() => selectedItem = val),
            ),
            const SizedBox(height: 15),
            TextField(
              controller: quantityController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'የተሸጠው ብዛት', border: OutlineInputBorder()),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.green, minimumSize: const Size.fromHeight(50)),
              onPressed: () {
                if (selectedItem != null && quantityController.text.isNotEmpty) {
                  int qty = int.parse(quantityController.text);
                  if (qty <= selectedItem!.quantity) {
                    selectedItem!.quantity -= qty;
                    double total = qty * selectedItem!.sellPrice;
                    double profit = qty * (selectedItem!.sellPrice - selectedItem!.buyPrice);

                    widget.onSaleAdded(SaleRecord(
                      itemName: selectedItem!.name,
                      quantity: qty,
                      totalAmount: total,
                      profit: profit,
                      date: DateTime.now(),
                    ));

                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('ሽያጩ በተሳካ ሁኔታ ተመዝግቧል!')));
                    Navigator.pop(context);
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('በክምችት ውስጥ በቂ ዕቃ የለም!')));
                  }
                }
              },
              child: const Text('ሽያጭ አስመዝግብ', style: TextStyle(color: Colors.white, fontSize: 18)),
            )
          ],
        ),
      ),
    );
  }
}

// ----------------------------------------------------
// 3. የዕቃ ክምችት ገጽ (Inventory Screen)
// ----------------------------------------------------
class InventoryScreen extends StatefulWidget {
  final List<Item> inventory;
  const InventoryScreen({super.key, required this.inventory});

  @override
  State<InventoryScreen> createState() => _InventoryScreenState();
}

class _InventoryScreenState extends State<InventoryScreen> {
  final nameController = TextEditingController();
  final buyPriceController = TextEditingController();
  final sellPriceController = TextEditingController();
  final qtyController = TextEditingController();

  void _addItem() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (ctx) => Padding(
        padding: EdgeInsets.only(top: 20, left: 20, right: 20, bottom: MediaQuery.of(ctx).viewInsets.bottom + 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('አዲስ ዕቃ መዝግብ', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            TextField(controller: nameController, decoration: const InputDecoration(labelText: 'የዕቃው ስም')),
            TextField(controller: buyPriceController, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'የተገዛበት ዋጋ (ብር)')),
            TextField(controller: sellPriceController, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'የሚሸጥበት ዋጋ (ብር)')),
            TextField(controller: qtyController, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'ብዛት')),
            const SizedBox(height: 15),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  widget.inventory.add(Item(
                    id: DateTime.now().toString(),
                    name: nameController.text,
                    buyPrice: double.parse(buyPriceController.text),
                    sellPrice: double.parse(sellPriceController.text),
                    quantity: int.parse(qtyController.text),
                  ));
                });
                Navigator.pop(context);
              },
              child: const Text('አስገባ'),
            )
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('የዕቃ ክምችት (Inventory)'), backgroundColor: Colors.blue, foregroundColor: Colors.white),
      body: ListView.builder(
        itemCount: widget.inventory.length,
        itemBuilder: (ctx, i) {
          final item = widget.inventory[i];
          return ListTile(
            leading: const Icon(Icons.shopping_bag, color: Colors.blue),
            title: Text(item.name, style: const TextStyle(fontWeight: FontWeight.bold)),
            subtitle: Text('የተገዛው: ${item.buyPrice} ብር | የሚሸጠው: ${item.sellPrice} ብር'),
            trailing: Text('${item.quantity} ፒስ', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.teal)),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addItem,
        backgroundColor: Colors.blue,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}

// ----------------------------------------------------
// 4. የብድር መዝገብ ገጽ (Credit Screen)
// ----------------------------------------------------
class CreditScreen extends StatelessWidget {
  final List<CreditRecord> credits;
  const CreditScreen({super.key, required this.credits});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('የብድር መዝገብ'), backgroundColor: Colors.orange, foregroundColor: Colors.white),
      body: credits.isEmpty
          ? const Center(child: Text('ምንም የተመዘገበ ዕዳ የለም።'))
          : ListView.builder(
              itemCount: credits.length,
              itemBuilder: (ctx, i) => ListTile(
                title: Text(credits[i].customerName),
                subtitle: Text('ዕቃ: ${credits[i].itemName} | ስልክ: ${credits[i].phone}'),
                trailing: Text('${credits[i].amount} ብር', style: const TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
              ),
            ),
    );
  }
}

// ----------------------------------------------------
// 5. የቀን ሂሳብ/ሪፖርት ገጽ (Reports Screen)
// ----------------------------------------------------
class ReportsScreen extends StatelessWidget {
  final List<SaleRecord> sales;
  const ReportsScreen({super.key, required this.sales});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('የቀን ሂሳብ / ሪፖርት'), backgroundColor: Colors.purple, foregroundColor: Colors.white),
      body: sales.isEmpty
          ? const Center(child: Text('ምንም የተቀመጠ የሽያጭ ሪፖርት የለም።'))
          : ListView.builder(
              itemCount: sales.length,
              itemBuilder: (ctx, i) {
                final sale = sales[i];
                return ListTile(
                  leading: const Icon(Icons.check_circle, color: Colors.green),
                  title: Text('${sale.itemName} (${sale.quantity} ፒስ)'),
                  subtitle: Text('የትርፍ መጠን: ${sale.profit.toStringAsFixed(2)} ብር'),
                  trailing: Text('${sale.totalAmount.toStringAsFixed(2)} ብር', style: const TextStyle(fontWeight: FontWeight.bold)),
                );
              },
            ),
    );
  }
}
