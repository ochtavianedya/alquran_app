import 'package:alquran_app/app/shared/controller/theme_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppBar({super.key, required this.title, this.actions});

  final String title;
  final List<Widget>? actions;

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        actions: [
          GetBuilder<ThemeController>(
            builder: (controller) {
              return IconButton(
                icon: Icon(
                  controller.isDarkMode
                      ? Icons.light_mode_outlined
                      : Icons.dark_mode_outlined,
                ),
                onPressed: () {
                  controller.toggleTheme();
                },
              );
            },
          ),
          ...(actions ?? []),
        ],
      ),
    );
  }
}
