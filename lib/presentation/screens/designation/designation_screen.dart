import 'package:enterprise_resource_planning/data/models/designation_model.dart';
import 'package:enterprise_resource_planning/data/repositories/designation_service.dart';
import 'package:enterprise_resource_planning/presentation/widgets/designation/designation_dialog.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:quickalert/quickalert.dart';

class DesignationScreen extends StatefulWidget {
  const DesignationScreen({super.key});

  @override
  State<DesignationScreen> createState() => _DesignationScreenState();
}

class _DesignationScreenState extends State<DesignationScreen> {
  final DesignationService service = DesignationService();

  List<DesignationModel> designations = [];

  bool loading = true;

  bool showForm = false;

  DesignationModel? selectedDesignation;

  @override
  void initState() {
    super.initState();
    loadData();
  }

  Future<void> loadData() async {
    setState(() => loading = true);

    try {
      final data = await service.getAllDesignations();

      setState(() {
        designations = data;
        loading = false;
      });
    } catch (e) {
      setState(() => loading = false);
    }
  }

  void resetForm() {
    selectedDesignation = null;
  }

  Future<void> deleteDesignation(int id) async {
    QuickAlert.show(
      context: context,
      type: QuickAlertType.confirm,
      text: 'Are you sure you want to delete this designation?',
      confirmBtnColor: Colors.red,

      onConfirmBtnTap: () async {
        Navigator.pop(context);

        QuickAlert.show(
          context: context,
          type: QuickAlertType.loading,
          text: 'Deleting...',
        );

        try {
          await service.deleteDesignation(id);

          if (mounted) {
            Navigator.pop(context);

            QuickAlert.show(
              context: context,
              type: QuickAlertType.success,
              text: 'Designation deleted successfully!',
            );

            loadData();
          }
        } catch (e) {
          if (mounted) {
            Navigator.pop(context);

            QuickAlert.show(
              context: context,
              type: QuickAlertType.error,
              text: 'Delete failed!',
            );
          }
        }
      },
    );
  }

  void onEdit(DesignationModel designation) {
    setState(() {
      showForm = true;
      selectedDesignation = designation;
    });
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
                mainAxisAlignment: MainAxisAlignment.end,
                children: [

                  ElevatedButton.icon(
                    onPressed: () {
                      setState(() {
                        showForm = !showForm;

                        if (!showForm) {
                          resetForm();
                        }
                      });
                    },

                    style: ElevatedButton.styleFrom(
                      backgroundColor: showForm
                          ? Colors.grey
                          : const Color(0xFF6366F1),

                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),

                    icon: Icon(
                      showForm ? Icons.close : Icons.add,
                      color: Colors.white,
                    ),

                    label: Text(
                      showForm ? "Cancel" : "Add Designation",
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 20),

              AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),

                child: showForm
                    ? DesignationDialog(
                  designation: selectedDesignation,

                  onSuccess: () {
                    resetForm();

                    setState(() {
                      showForm = false;
                    });

                    loadData();
                  },
                )
                    : const SizedBox.shrink(),
              ),

              const SizedBox(height: 20),

              loading && designations.isEmpty
                  ? const Center(
                child: CircularProgressIndicator(
                  color: Color(0xFF6366F1),
                ),
              )

                  : designations.isEmpty
                  ? Center(
                child: Padding(
                  padding: const EdgeInsets.only(top: 50),
                  child: Text(
                    "No designations found",
                    style: GoogleFonts.inter(
                      color: Colors.grey,
                    ),
                  ),
                ),
              )

                  : ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),

                itemCount: designations.length,

                itemBuilder: (context, index) {
                  final d = designations[index];

                  return Container(
                    margin: const EdgeInsets.only(bottom: 12),

                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),

                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.02),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),

                    child: ListTile(
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 4,
                      ),

                      leading: Container(
                        width: 48,
                        height: 48,

                        decoration: BoxDecoration(
                          color: const Color(0xFF6366F1)
                              .withOpacity(0.1),

                          borderRadius: BorderRadius.circular(12),
                        ),

                        child: Center(
                          child: Text(
                            d.name[0].toUpperCase(),

                            style: const TextStyle(
                              color: Color(0xFF6366F1),
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                        ),
                      ),

                      title: Text(
                        d.name,

                        style: GoogleFonts.inter(
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                          color: const Color(0xFF1E293B),
                        ),
                      ),

                      subtitle: Text(
                        d.department.name,

                        style: GoogleFonts.inter(
                          fontSize: 12,
                          color: const Color(0xFF64748B),
                        ),
                      ),

                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [

                          IconButton(
                            icon: const Icon(
                              Icons.edit_outlined,
                              color: Color(0xFF64748B),
                              size: 20,
                            ),

                            onPressed: () {
                              onEdit(d);
                            },
                          ),

                          IconButton(
                            icon: const Icon(
                              Icons.delete_outline_rounded,
                              color: Colors.redAccent,
                              size: 20,
                            ),

                            onPressed: () {
                              deleteDesignation(d.id!);
                            },
                          ),
                        ],
                      ),
                    ),
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