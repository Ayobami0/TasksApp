import 'package:flutter/material.dart';
import 'package:tasks/widgets/bottom_modal_screen.dart';

class CustomFloatingActionButton extends StatelessWidget {
  final Function() onPressed;
  const CustomFloatingActionButton({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: (){
        showDialog(
          context: context,
          builder: (context) => const CreateTaskDialog()
        );
      },
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10)
      ),
      child: const Icon(Icons.add),
    );
  }
}
