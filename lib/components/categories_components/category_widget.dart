import 'package:flutter/material.dart';
import '../../../const.dart';
import '../../../models/category.dart';
import 'handle_delete.dart';

class CategoryWidget extends StatelessWidget {
  const CategoryWidget({
    super.key,
    required this.category,
    this.userRole,
  });

  final Category category;
  final String? userRole;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 150,
      width: 150,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        gradient: LinearGradient(
          colors: [
            generateRandomLightColor(),
            generateRandomDarkColor(),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            offset: Offset(0, 4),
            blurRadius: 6,
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
               if (userRole == 'admin')
                IconButton(
                  onPressed: () {
                    handleDelete(context, category.categoryID, category.name);
                  },
                  icon: const Icon(
                    Icons.delete,
                    color: Colors.white,
                  ),
                )
               else if(userRole == 'staff' || userRole == 'viewer')
                Container(
                  height: 40,
                ),
            ],
          ),
          const Spacer(),
          Text(
            category.name,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
          const Spacer(
            flex: 2,
          )
        ],
      ),
    );
  }
}