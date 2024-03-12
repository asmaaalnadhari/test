import 'package:flutter/material.dart';

class Supplier {
  final String name;
  final String id; // Assuming there's an ID for the supplier

  Supplier(this.name, this.id);
}

class Customer {
  final String name;
  final String id; // Assuming there's an ID for the customer

  Customer(this.name, this.id);
}

class MyTextFieldExample extends StatefulWidget {
  @override
  _MyTextFieldExampleState createState() => _MyTextFieldExampleState();
}

class _MyTextFieldExampleState extends State<MyTextFieldExample> {
  TextEditingController _textEditingController = TextEditingController();
  List<Supplier> _supplierList = [
    Supplier('Asmaa 1', '1'),
    Supplier('Ayman 2', '2'),
    Supplier('Supplier 3', '3'),
  ];
  List<Customer> _customerList = [
    Customer('Customer A', 'A'),
    Customer('Customer B', 'B'),
    Customer('Customer C', 'C'),
  ];
  List<dynamic>? _currentList;
  dynamic _selectedItem;
  String? _selectedList;

  @override
  void dispose() {
    _textEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Text Field Example'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _textEditingController,
              decoration: InputDecoration(
                labelText: 'Select or Edit Item',
                suffixIcon: IconButton(
                  icon: Icon(Icons.arrow_drop_down),
                  onPressed: () {
                    _showSelectionDialog(context);
                  },
                ),
              ),
              onChanged: (value) {
                _selectedItem = value;
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _showSelectionDialog(BuildContext context) async {
    await showDialog<String>(
      context: context,
      builder: (BuildContext context) {
        return DefaultTabController(
          length: 2, // Number of tabs
          child: AlertDialog(
            title: Text('Select from'),
            content: StatefulBuilder(
              builder: (BuildContext context, StateSetter setState) {
                return SizedBox(
                  width: double.maxFinite,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TabBar(
                        tabs: [
                          Tab(text: 'Suppliers'),
                          Tab(text: 'Customers'),
                        ],
                        onTap: (index) {
                          setState(() {
                            if (index == 0)
                              _currentList = _supplierList;
                            else
                              _currentList = _customerList;
                          });
                        },
                      ),
                      SizedBox(height: 10),
                      Container(
                        height: 200,
                        child: TabBarView(
                          children: [
                            _buildItemList(_supplierList),
                            _buildItemList(_supplierList),
                            // _buildItemList(_customerList),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }


  Widget _buildItemList(List<Supplier> itemList) {
    List<Supplier> filteredItemList = itemList; // Initialize with the full list initially
    TextEditingController searchController = TextEditingController(); // Controller for search field

    return
        Expanded(
          child: StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              print(filteredItemList.length);
              // Use a key for ListView.builder to force it to rebuild when filteredItemList changes
              return  Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: searchController,
                    onChanged: (x) {
                      setState(() {
                        filteredItemList = itemList
                            .where((item) => item.name.toLowerCase().contains(x.toLowerCase()))
                            .toList();
                      });
                    },
                    decoration: const InputDecoration(
                      labelText: 'Search',
                    ),
                  ),
                  Expanded(
                    child: StatefulBuilder(
                      builder: (BuildContext context, StateSetter setState) {
                        // Use a key for ListView.builder to force it to rebuild when filteredItemList changes
                        return ListView.builder(
                          key: UniqueKey(),
                          itemCount: filteredItemList.length,
                          itemBuilder: (context, index) {
                            final item = filteredItemList[index];
                            return ListTile(
                              title: Text(item.name),
                              onTap: () {
                                setState(() {
                                  _selectedItem = item;
                                  _selectedList = 'Supplier';
                                  _textEditingController.text = '${item.name} - $_selectedList (${item.id})';
                                });
                                Navigator.pop(context);
                              },
                            );
                          },
                        );
                      },
                    ),
                  ),
                ],
              );
            },
          ),
        );
  }




}

void main() {
  runApp(MaterialApp(
    home: MyTextFieldExample(),
  ));
}
