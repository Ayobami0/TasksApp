import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:tasks/models/task.dart';
import 'package:uuid/uuid.dart';

class CreateTaskDialog extends ConsumerStatefulWidget {
  const CreateTaskDialog({super.key});

  @override
  ConsumerState<CreateTaskDialog> createState() => _CreateTaskDialogState();
}

class _CreateTaskDialogState extends ConsumerState<CreateTaskDialog> {
  final _formKey = GlobalKey<FormState>();

  bool _isSaving = false;

  final TextEditingController _titleController = TextEditingController();

  final TextEditingController _contentController = TextEditingController();

  DateTime? _selectedDateTime;

  Future _saveTask() async{
    final isValid = _formKey.currentState!.validate();

    if (!isValid){
      return;
    }
    
    setState(() {
          _isSaving = true;
        });
    final Task newTask = Task(
      id:const Uuid().v4(),
      startDate: DateTime.now(),
      dueDate: _selectedDateTime,
      title: _titleController.value.text,
      content: _contentController.value.text,
    );
    
    ref.read(taskProvider.notifier).addToTasks(newTask);
    _formKey.currentState!.save();
    await Future.delayed(const Duration(seconds: 2)).then((value) {
      Navigator.pop(context);
      setState(() {
            _isSaving = false;
          });
      if (newTask.dueDate != null && newTask.status != TaskStatus.completed){
        Timer(_selectedDateTime!.difference(DateTime.now()), () {
          print('Expired');
          ref.read(taskProvider.notifier).updateTaskStatus(newTask.id, TaskStatus.overdue);
        });
      }
    });
  }

  @override
    void dispose() {
      _contentController.dispose();
      _titleController.dispose();
      super.dispose();
    }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20)),
      child: SizedBox(
        height: 350,
        child: Padding(
          padding: const EdgeInsets.all(25.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CustomTextField(hintText: 'Title', controller: _titleController, keyboardType: TextInputType.text, validate: true, maxLength: 25,),
                CustomTextField(hintText: 'Content', controller: _contentController, keyboardType: TextInputType.multiline, maxLines: 5,),
                Column(
                  children: [
                    TextButton.icon(
                      onPressed: () async{
                        await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(2000),
                          lastDate: DateTime(2050)
                        ).then((dateValue) async{
                          if (dateValue == null) return;
                          await showTimePicker(
                            context: context,
                            initialTime: TimeOfDay.now()
                          ).then((timeValue){
                            setState(() {
                              if (timeValue == null) return;
                              _selectedDateTime = dateValue.add(Duration(
                                hours: timeValue.hour,
                                minutes: timeValue.minute
                              ));
                            });
                          });
                        }).onError((error, stackTrace){
                          print(error);
                        });
                      }, 
                      icon: const Icon(Icons.event), 
                      label: const Text('Due Date'),
                    ),
                    Text(_selectedDateTime != null ? DateFormat.yMMMEd().add_jm().format(_selectedDateTime!) : '-')
                  ],
                ),
                _isSaving ? const CircularProgressIndicator() : ElevatedButton(
                  onPressed: () async{
                                      await _saveTask();
                                    },
                  child: const Text('CREATE TASK')
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class CustomTextField extends StatelessWidget {
  final String hintText;
  final int? maxLength;
  final int maxLines;
  final TextEditingController controller;
  final TextInputType keyboardType;
  final bool validate;
  const CustomTextField({
    super.key,
    this.validate=false,
    this.maxLength,
    this.maxLines=1,
    required this.hintText,
    required this.controller,
    required this.keyboardType
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      maxLength: maxLength,
      maxLines: maxLines,
      validator: !validate ? null : (value){
        if (value == null || value.trim().isEmpty){
          return '$hintText field must not be empty';
        }
        return null;
      },
      keyboardType: keyboardType,
      controller: controller,
      decoration: InputDecoration(
        filled: true,
        fillColor: Theme.of(context).colorScheme.primary.withOpacity(0.3),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide.none 
        ),
        hintText: hintText,
        contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5)
      ),
    );
  }
}
