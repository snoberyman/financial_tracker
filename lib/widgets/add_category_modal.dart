import 'package:flutter/material.dart';

class AddCategoryModal extends StatefulWidget {
  final Function(String) onAddCategory;

  const AddCategoryModal({super.key, required this.onAddCategory});

  @override
  _AddCategoryModalState createState() => _AddCategoryModalState();
}

class _AddCategoryModalState extends State<AddCategoryModal> {
  final TextEditingController _nameController = TextEditingController();
  bool isButtonEnabled = false;

  void _handleTextChanged(String text) {
    setState(() {
      isButtonEnabled = text.trim().length >= 3;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom + 30,
        left: 16.0,
        right: 16.0,
        top: 16.0,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _nameController,
            textCapitalization:
                TextCapitalization.sentences, // Capitalize the first letter
            decoration: const InputDecoration(labelText: 'Category Name'),
            onChanged: _handleTextChanged,
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: isButtonEnabled
                ? () {
                    widget.onAddCategory(_nameController.text);
                    Navigator.pop(context);
                  }
                : null,
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }
}
