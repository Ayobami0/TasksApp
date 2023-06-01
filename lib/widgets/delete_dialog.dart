import 'package:flutter/material.dart';

showDeleteDialog(BuildContext context) async{
  return await showDialog(
    context: context, 
    builder: (context){
      return AlertDialog(
        title: const Text('Confirm delete'),
        content: const Text('You are about to delete this task. Please confirm'),
        actions: [
          TextButton(onPressed: (){
            Navigator.of(context).pop(false);
          }, child: const Text('NO')),
          TextButton(
            onPressed: (){
              Navigator.of(context).pop(true);
            }, 
            child: const Text('YES', style: TextStyle(color: Colors.red),)),
        ],
      );
    }
    );
}
