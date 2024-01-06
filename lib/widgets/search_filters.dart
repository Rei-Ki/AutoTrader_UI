import 'package:flutter/material.dart';

class SearchFiltersPage extends StatefulWidget {
  const SearchFiltersPage({super.key});

  @override
  State<SearchFiltersPage> createState() => _SearchFiltersPageState();
}

class _SearchFiltersPageState extends State<SearchFiltersPage> {
  // Define a list of products
  List<Product> products = [
    Product(name: 'Product 1', category: 'Category A'),
    Product(name: 'Product 2', category: 'Category B'),
    Product(name: 'Product 3', category: 'Category A'),
    Product(name: 'Product 4', category: 'Category B'),
  ];

  // Define a list of categories
  List<String> categories = ['All', 'Category A', 'Category B'];

  // Define a variable to store the selected category
  String selectedCategory = 'All';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Фильтры поиска')),
      body: Container(
        alignment: Alignment.topCenter,
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            // Create a row of FilterChip widgets to filter by category
            Row(
              children: categories.map((category) {
                return FilterChip(
                  label: Text(category),
                  selected: selectedCategory == category,
                  onSelected: (isSelected) {
                    setState(() {
                      selectedCategory = isSelected ? category : 'All';
                    });
                  },
                );
              }).toList(),
            ),
            // Create a list of products filtered by category
            Expanded(
              child: ListView.builder(
                itemCount: products.length,
                itemBuilder: (BuildContext context, int index) {
                  if (selectedCategory == 'All' ||
                      selectedCategory == products[index].category) {
                    return ListTile(
                      title: Text(products[index].name),
                    );
                  } else {
                    return SizedBox.shrink();
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class Product {
  final String name;
  final String category;

  Product({required this.name, required this.category});
}
