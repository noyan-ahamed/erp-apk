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

  /// FORM STATE
  bool showForm = false;
  bool isEdit = false;
  int? editId;

  final nameController = TextEditingController();
  final descController = TextEditingController();
  String status = "ACTIVE";

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
    }
  }

  void resetForm() {
    nameController.clear();
    descController.clear();
    status = "ACTIVE";
    isEdit = false;
    editId = null;
  }

  Future<void> onSubmit() async {
    if (nameController.text.isEmpty) return;

    QuickAlert.show(
      context: context,
      type: QuickAlertType.loading,
      text: isEdit ? 'Updating category...' : 'Creating category...',
    );

    final category = ProductCategory(
      name: nameController.text,
      description: descController.text,
      status: status,
    );

    try {
      if (isEdit && editId != null) {
        await service.updateCategory(editId!, category);
      } else {
        await service.createCategory(category);
      }
      
      if (mounted) {
        Navigator.pop(context); // Close loading
        QuickAlert.show(
          context: context,
          type: QuickAlertType.success,
          text: 'Category ${isEdit ? 'updated' : 'saved'} successfully!',
        );
        resetForm();
        setState(() => showForm = false);
        loadData();
      }
    } catch (e) {
      if (mounted) {
        Navigator.pop(context); // Close loading
        QuickAlert.show(
          context: context,
          type: QuickAlertType.error,
          text: 'Operation failed: $e',
        );
      }
    }
  }

  void onEdit(ProductCategory item) {
    setState(() {
      showForm = true;
      isEdit = true;
      editId = item.id;

      nameController.text = item.name;
      descController.text = item.description ?? '';
      status = item.status ?? "ACTIVE";
    });
  }

  Future<void> onDelete(int? id) async {
    if (id == null) return;

    QuickAlert.show(
      context: context,
      type: QuickAlertType.confirm,
      text: 'Are you sure you want to delete this category?',
      confirmBtnColor: Colors.red,
      onConfirmBtnTap: () async {
        Navigator.pop(context); // Close confirm
        QuickAlert.show(context: context, type: QuickAlertType.loading, text: 'Deleting...');
        
        try {
          await service.deleteCategory(id);
          Navigator.pop(context); // Close loading
          QuickAlert.show(context: context, type: QuickAlertType.success, text: 'Deleted!');
          loadData();
        } catch (e) {
          Navigator.pop(context);
          QuickAlert.show(context: context, type: QuickAlertType.error, text: 'Failed to delete: $e');
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: RefreshIndicator(
        onRefresh: loadData,
        color: const Color(0xFF6366F1),
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Text(
                      //   "Organize your categories",
                      //   style: GoogleFonts.poppins(fontSize: 17, fontWeight: FontWeight.bold),
                      // ),
                    ],
                  ),
                  ElevatedButton.icon(
                    onPressed: () {
                      setState(() => showForm = !showForm);
                      if (!showForm) resetForm();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: showForm ? Colors.grey : const Color(0xFF6366F1),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                    icon: Icon(showForm ? Icons.close : Icons.add, color: Colors.white),
                    label: Text(showForm ? "Cancel" : "Add New", style: const TextStyle(color: Colors.white)),
                  )
                ],
              ),

              const SizedBox(height: 20),

              AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                child: showForm ? buildForm() : const SizedBox.shrink(),
              ),

              const SizedBox(height: 20),

              loading && categoryList.isEmpty
                  ? const Center(child: CircularProgressIndicator(color: Color(0xFF6366F1)))
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

  Widget buildForm() {
    return Card(
      elevation: 5,
      shadowColor: Colors.black12,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(
              controller: nameController,
              decoration: InputDecoration(
                labelText: "Category Name",
                prefixIcon: const Icon(Icons.category_outlined),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField(
              value: status,
              items: const [
                DropdownMenuItem(value: "ACTIVE", child: Text("Active")),
                DropdownMenuItem(value: "INACTIVE", child: Text("Inactive")),
              ],
              onChanged: (v) => setState(() => status = v!),
              decoration: InputDecoration(
                labelText: "Status",
                prefixIcon: const Icon(Icons.toggle_on_outlined),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: descController,
              maxLines: 2,
              decoration: InputDecoration(
                labelText: "Description",
                prefixIcon: const Icon(Icons.description_outlined),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              height: 45,
              child: ElevatedButton(
                onPressed: onSubmit,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF10B981),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: Text(
                  isEdit ? "Update Category" : "Save Category",
                  style: GoogleFonts.poppins(fontWeight: FontWeight.bold, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
