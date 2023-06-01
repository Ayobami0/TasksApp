import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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
      dueDate: DateTime.now(),
      title: _titleController.value.text,
      content: _contentController.value.text,
    );
    
    ref.watch(taskProvider.notifier).addToTasks(newTask);
    _formKey.currentState!.save();
    await Future.delayed(const Duration(seconds: 2)).then((value) {
      Navigator.pop(context);
      setState(() {
            _isSaving = false;
          });
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
        height: 300,
        child: Padding(
          padding: const EdgeInsets.all(25.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CustomTextField(hintText: 'Title', controller: _titleController, keyboardType: TextInputType.text, validate: true,),
                CustomTextField(hintText: 'Content', controller: _contentController, keyboardType: TextInputType.multiline,),
                TextButton.icon(
                  onPressed: (){}, 
                  icon: const Icon(Icons.event), 
                  label: const Text('Due Date'),
                ),
                _isSaving ? const CircularProgressIndicator() : ElevatedButton(
                  onPressed: _isSaving ? null :() async{
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
  final TextEditingController controller;
  final TextInputType keyboardType;
  final bool validate;
  const CustomTextField({
    super.key,
    this.validate=false,
    required this.hintText,
    required this.controller,
    required this.keyboardType
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary.withOpacity(0.3),
        borderRadius: BorderRadius.circular(8),
      ),
      child: TextFormField(
        validator: !validate ? null : (value){
          if (value == null || value.trim().isEmpty){
            return '$hintText field must not be empty';
          }
          return null;
        },
        keyboardType: keyboardType,
        controller: controller,
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: hintText,
          contentPadding: const EdgeInsets.symmetric(horizontal: 10)
        ),
      ),
    );
  }
}