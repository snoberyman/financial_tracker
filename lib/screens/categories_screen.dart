import 'dart:async';

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../models/catgeory.dart'; // Import the Category model
import '../services/categories_firestore_service.dart'; // Import the Firestore service

import '../widgets/category_add_modal.dart';

class CategoriesScreen extends StatefulWidget {
  const CategoriesScreen({super.key});

  @override
  _CategoriesScreenState createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends State<CategoriesScreen> {
  final CategoriesFirestoreService _firestoreService =
      CategoriesFirestoreService();
  List<Category> _categories = [];
  bool _isLoading = true;
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    _fetchCategories();
  }

  void _fetchCategories() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      List<Category> categories =
          await _firestoreService.getCategories(user.uid);
      setState(() {
        _categories = categories;
        _isLoading = false;
      });
    }
  }

// Handle reordering of the categories with debouncing
  void _onReorder(int oldIndex, int newIndex) {
    setState(() {
      if (newIndex > oldIndex) {
        newIndex -= 1;
      }
      final Category movedCategory = _categories.removeAt(oldIndex);
      _categories.insert(newIndex, movedCategory);
    });

    // Cancel any existing timer
    if (_debounce?.isActive ?? false) _debounce?.cancel();

    // Set a delay before updating the order in Firestore
    _debounce = Timer(const Duration(milliseconds: 500), () {
      _updateCategoryOrder();
    });
  }

// Update category order in Firestore using a batch write
// Update category order in Firestore using the extracted service
  void _updateCategoryOrder() async {
    final user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      await _firestoreService.updateCategoryOrder(user.uid, _categories);
    }
  }

  // method to add a new category
  Future<void> _addCategory(String name) async {
    if (_categories.length >= 15) return;

    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      await _firestoreService.addCategory(name, user.uid);
      _fetchCategories(); // Re-fetch to update the list
    }
  }

  Future<void> _deleteCategory(Category category) async {
    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      await _firestoreService.deleteCategory(category.id, user.uid);
      _fetchCategories(); // Re-fetch to update the list
    }
  }

  void _showAddCategoryModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return AddCategoryModal(
          onAddCategory: (categoryName) {
            // Add your logic to handle adding a category here
            _addCategory(categoryName);
          },
        );
      },
    );
  }

  void _handleAddCategory() {
    if (_categories.length >= 15) {
      // Show an alert dialog if there are already 15 categories
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Category Limit Reached'),
            content: const Text('You cannot add more than 15 categories.'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('OK'),
              ),
            ],
          );
        },
      );
    } else {
      _showAddCategoryModal(context);
    }
  }

  void _confirmDeleteCategory(BuildContext context, Category category) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Delete Category'),
          content: Text('Are you sure you want to delete "${category.name}"?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('No'),
            ),
            TextButton(
              onPressed: () {
                _deleteCategory(category);
                Navigator.pop(context);
              },
              child: const Text('Yes'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 0,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              mainAxisAlignment: MainAxisAlignment
                  .spaceBetween, // Ensure "Add Category" sticks to the bottom
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    mainAxisAlignment:
                        MainAxisAlignment.start, // Align text to the right
                    children: [
                      const Text(
                        'Categories List',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Expanded(child: SizedBox()),
                      IconButton(
                        icon: const Icon(Icons.add),
                        onPressed: _handleAddCategory,
                        tooltip: 'Add Category',
                      ),
                    ],
                  ),
                ),
                Expanded(
                  // Takes up remaining space
                  child: Scrollbar(
                    // Add scrollbar for better scroll visibility
                    child: SingleChildScrollView(
                      child: ReorderableListView(
                        onReorder: _onReorder,
                        shrinkWrap:
                            true, // Ensures it only takes up as much space as needed
                        physics:
                            const NeverScrollableScrollPhysics(), // Disables inner scroll to avoid conflict with outer scroll
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        children: [
                          for (int index = 0;
                              index < _categories.length;
                              index++)
                            ListTile(
                              key: ValueKey(_categories[index].id),
                              title: Text(_categories[index].name),
                              leading: IconButton(
                                icon: const Icon(Icons.delete),
                                onPressed: () => _confirmDeleteCategory(
                                    context, _categories[index]),
                              ),
                              trailing: ReorderableDragStartListener(
                                index: index,
                                child: const Icon(Icons.drag_handle),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 30,
                )
                // if (_categories.length < 15)
                //   Padding(
                //     padding: const EdgeInsets.all(20.0),
                //     child: ListTile(
                //       key: const ValueKey('add_category'),
                //       title: const Center(child: Icon(Icons.add)),
                //       onTap: () => _showAddCategoryModal(context),
                //     ),
                //   ),
              ],
            ),
    );
  }
}
