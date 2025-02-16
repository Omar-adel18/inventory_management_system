import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:inventory_management_system/components/build_text_field.dart';
import '../../../cubit/CategoriesCubit/get_categories_cubit.dart';

void showAddCategoryDialog(BuildContext context) {
  final formKey = GlobalKey<FormState>();
  String newCategoryName = '';

  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    builder: (BuildContext context) {
      return SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Padding(
                  padding: EdgeInsets.only(
                    right: 16.0,
                    left: 16,
                    top: 16,
                  ),
                  child: Text(
                    'Add New Category',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.teal,
                    ),
                  ),
                ),
                const Divider(
                  color: Colors.teal,
                  thickness: 2,
                  indent: 20,
                  endIndent: 20,
                ),
                const SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child:  BuildTextField(
                    label: 'Write New Category Name',
                    initialValue: newCategoryName,
                    onChanged: (value) {
                      newCategoryName = value;
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Category Name is required';
                      }
                      return null;
                    },
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.grey,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: const Text(
                        'Cancel',
                        style: TextStyle(
                          color: Colors.black,
                        ),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () async {
                        if (formKey.currentState!.validate()) {
                          if (newCategoryName.isNotEmpty) {
                            context.read<CategoriesCubit>().addCategory(newCategoryName);
                            Navigator.pop(context);
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                backgroundColor: Colors.green,
                                content: Text('Category added successfully'),
                              ),
                            );
                          }
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.teal,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: const Text(
                        'Submit',
                        style: TextStyle(
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
              ],
            ),
          ),
        ),
      );
    },
  );

  // showDialog(
  //   barrierDismissible: false,
  //   context: context,
  //   builder: (context) {
  //     return Dialog(
  //       shape: RoundedRectangleBorder(
  //         borderRadius: BorderRadius.circular(12),
  //       ),
  //       child: SizedBox(
  //         height: 225,
  //         width: 400,
  //         child: Form(
  //           key: formKey,
  //           child: Column(
  //             mainAxisAlignment: MainAxisAlignment.start,
  //             children: [
  //               const Padding(
  //                 padding: EdgeInsets.only(
  //                   right: 16.0,
  //                   left: 16,
  //                   top: 16,
  //                 ),
  //                 child: Text(
  //                   'Add New Category',
  //                   style: TextStyle(
  //                     fontSize: 20,
  //                     fontWeight: FontWeight.bold,
  //                     color: Colors.teal,
  //                   ),
  //                 ),
  //               ),
  //               const Divider(
  //                 color: Colors.teal,
  //                 thickness: 2,
  //                 indent: 20,
  //                 endIndent: 20,
  //               ),
  //               const SizedBox(height: 20),
  //               Padding(
  //                 padding: const EdgeInsets.symmetric(horizontal: 10),
  //                 child: BuildTextField(
  //                   label: 'Write New Category Name',
  //                   initialValue: newCategoryName,
  //                   onChanged: (value) {
  //                     newCategoryName = value;
  //                   },
  //                   validator: (value) {
  //                     if (value == null || value.isEmpty) {
  //                       return 'Category Name is required';
  //                     }
  //                     return null;
  //                   },
  //                 ),
  //               ),
  //               const Spacer(),
  //               Row(
  //                 mainAxisAlignment: MainAxisAlignment.spaceEvenly,
  //                 children: [
  //                   ElevatedButton(
  //                     onPressed: () {
  //                       Navigator.pop(context);
  //                     },
  //                     style: ElevatedButton.styleFrom(
  //                       backgroundColor: Colors.grey,
  //                       shape: RoundedRectangleBorder(
  //                         borderRadius: BorderRadius.circular(10),
  //                       ),
  //                     ),
  //                     child: const Text(
  //                       'Cancel',
  //                       style: TextStyle(
  //                         color: Colors.white,
  //                       ),
  //                     ),
  //                   ),
  //                   ElevatedButton(
  //                     onPressed: () async {
  //                       if (formKey.currentState!.validate()) {
  //                         if (newCategoryName.isNotEmpty) {
  //                           context.read<CategoriesCubit>().addCategory(newCategoryName);
  //                           Navigator.pop(context);
  //                           ScaffoldMessenger.of(context)
  //                               .showSnackBar(const SnackBar(
  //                             backgroundColor: Colors.green,
  //                             content: Text('Category added successfully'),
  //                           ));
  //                         }
  //                       }
  //                     },
  //                     style: ElevatedButton.styleFrom(
  //                       backgroundColor: Colors.teal,
  //                       shape: RoundedRectangleBorder(
  //                         borderRadius: BorderRadius.circular(10),
  //                       ),
  //                     ),
  //                     child: const Text(
  //                       'Submit',
  //                       style: TextStyle(
  //                         color: Colors.white,
  //                       ),
  //                     ),
  //                   ),
  //                 ],
  //               ),
  //               const SizedBox(
  //                 height: 10,
  //               ),
  //             ],
  //           ),
  //         ),
  //       ),
  //     );
  //   },
  // );
}
