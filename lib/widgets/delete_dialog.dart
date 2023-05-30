import 'package:flutter/material.dart';

showDeleteDialog(BuildContext context){
  showDialog(
    context: context, 
    builder: (ctx){
      return AlertDialog(
        title: const Text(''),
        content: const Text('You are about to delete this task. Please confirm'),
        actions: [
          TextButton(onPressed: (){}, child: const Text('NO')),
          TextButton(
            onPressed: (){}, 
            child: const Text('YES', style: TextStyle(color: Colors.red),)),
        ],
      );
    }
    );
}
