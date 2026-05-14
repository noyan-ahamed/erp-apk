import 'package:enterprise_resource_planning/data/models/product_category_model.dart';
import 'package:enterprise_resource_planning/data/repositories/product_category_service.dart';
import 'package:enterprise_resource_planning/presentation/widgets/category/category_card.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:quickalert/quickalert.dart';

class ProductCategoryScreen extends StatefulWidget {
  const ProductCategoryScreen({super.key});

  @override
  State<ProductCategoryScreen> createState() => _ProductCategoryScreenState();
}

class _ProductCategoryScreenState extends State<ProductCategoryScreen> {
  final service = ProductCategoryService();

  List<ProductCategory> categoryList = [];
  bool loading = true;

  @override
  void initState() {
    super.initState();
    loadData();
  }

  Future<void> loadData() async {
    setState(() => loading = true);
    try {
      final data = await service.getAllCategories();
      setState(() {
        categoryList = data;
        loading = false;
      });
    } catch (e) {
      setState(() => loading = false);
      if (mounted) {
        debugPrint("Error loading data: $e");
      }
    }
  }

  void onEdit(ProductCategory item) {
    showDialog(
      context: context,
      builder: (_) => CategoryDialog(
        item: item,
        service: service,
        onSuccess: loadData,
      ),
    );
  }

  Future<void> onDelete(int? id) async {
    if (id == null) return;

    QuickAlert.show(
      context: context,
      type: QuickAlertType.confirm,
      text: 'Are you sure you want to delete this category?',
      confirmBtnColor: Colors.red,
      onConfirmBtnTap: () async {
        Navigator.pop(context); // Close confirm dialog
        QuickAlert.show(
            context: context,
            type: QuickAlertType.loading,
            text: 'Deleting...'
        );

        try {
          await service.deleteCategory(id);
          if (mounted) {
            Navigator.pop(context); // Close loading dialog
            QuickAlert.show(
                context: context,
                type: QuickAlertType.success,
                text: 'Deleted successfully!'
            );
            loadData();
          }
        } catch (e) {
          if (mounted) {
            Navigator.pop(context); // Close loading dialog
            QuickAlert.show(
                context: context,
                type: QuickAlertType.error,
                text: 'Failed to delete: $e'
            );
          }
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: RefreshIndicator(
        onRefresh: loadData,
        color: Theme.of(context).primaryColor,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Product Categories",
                    style: GoogleFonts.poppins(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).textTheme.bodyLarge?.color,
                    ),
                  ),
                  ElevatedButton.icon(
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (_) => CategoryDialog(
                          service: service,
                          onSuccess: loadData,
                        ),
                      );
                    },
                    icon: const Icon(Icons.add, color: Colors.white, size: 18),
                    label: const Text("Add New", style: TextStyle(color: Colors.white)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).primaryColor,
                    ),
                  )
                ],
              ),
              const SizedBox(height: 20),
              loading && categoryList.isEmpty
                  ? const Center(
                child: Padding(
                  padding: EdgeInsets.only(top: 50),
                  child: CircularProgressIndicator(color: Color(0xFF6366F1)),
                ),
              )
                  : categoryList.isEmpty
                  ? const Center(
                child: Padding(
                  padding: EdgeInsets.only(top: 50),
                  child: Text("No categories found"),
                ),
              )
                  : GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: categoryList.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 16,
                  crossAxisSpacing: 16,
                  childAspectRatio: 0.85,
                ),
                itemBuilder: (context, index) {
                  final item = categoryList[index];
                  return CategoryCard(
                    item: item,
                    onEdit: () => onEdit(item),
                    onDelete: () => onDelete(item.id),
                  );
                },
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}

class CategoryDialog extends StatefulWidget {
  final ProductCategory? item;
  final ProductCategoryService service;
  final VoidCallback onSuccess;

  const CategoryDialog({
    super.key,
    this.item,
    required this.service,
    required this.onSuccess,
  });

  @override
  State<CategoryDialog> createState() => _CategoryDialogState();
}

class _CategoryDialogState extends State<CategoryDialog> {
  final nameController = TextEditingController();
  final descController = TextEditingController();
  String status = "ACTIVE";

  @override
  void initState() {
    super.initState();
    if (widget.item != null) {
      nameController.text = widget.item!.name;
      descController.text = widget.item!.description ?? '';
      status = widget.item!.status ?? "ACTIVE";
    }
  }

  @override
  void dispose() {
    nameController.dispose();
    descController.dispose();
    super.dispose();
  }

  Future<void> onSubmit() async {
    if (nameController.text.trim().isEmpty) {
      QuickAlert.show(
        context: context,
        type: QuickAlertType.warning,
        text: 'Please enter a category name',
      );
      return;
    }

    QuickAlert.show(
      context: context,
      type: QuickAlertType.loading,
      text: widget.item != null ? 'Updating category...' : 'Creating category...',
    );

    final category = ProductCategory(
      name: nameController.text.trim(),
      description: descController.text.trim(),
      status: status,
    );

    try {
      if (widget.item != null) {
        await widget.service.updateCategory(widget.item!.id!, category);
      } else {
        await widget.service.createCategory(category);
      }

      if (mounted) {
        Navigator.pop(context); // Close loading dialog
        Navigator.pop(context); // Close category dialog
        QuickAlert.show(
          context: context,
          type: QuickAlertType.success,
          text: 'Category ${widget.item != null ? 'updated' : 'saved'} successfully!',
        );
        widget.onSuccess();
      }
    } catch (e) {
      if (mounted) {
        Navigator.pop(context); // Close loading dialog
        QuickAlert.show(
          context: context,
          type: QuickAlertType.error,
          text: 'Operation failed: $e',
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      backgroundColor: Theme.of(context).cardColor,
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                widget.item == null ? "Add Category" : "Edit Category",
                style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: nameController,
                style: TextStyle(color: Theme.of(context).textTheme.bodyLarge?.color),
                decoration: const InputDecoration(
                  labelText: "Category Name",
                  prefixIcon: Icon(Icons.category_outlined),
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: status,
                items: const [
                  DropdownMenuItem(value: "ACTIVE", child: Text("Active")),
                  DropdownMenuItem(value: "INACTIVE", child: Text("Inactive")),
                ],
                onChanged: (v) => setState(() => status = v!),
                decoration: const InputDecoration(
                  labelText: "Status",
                  prefixIcon: Icon(Icons.toggle_on_outlined),
                  border: OutlineInputBorder(),
                ),
                dropdownColor: Theme.of(context).cardColor,
              ),
              const SizedBox(height: 16),
              TextField(
                controller: descController,
                maxLines: 2,
                style: TextStyle(color: Theme.of(context).textTheme.bodyLarge?.color),
                decoration: const InputDecoration(
                  labelText: "Description",
                  prefixIcon: Icon(Icons.description_outlined),
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  onPressed: onSubmit,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).primaryColor,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: Text(
                    widget.item != null ? "Update Category" : "Save Category",
                    style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 16),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}