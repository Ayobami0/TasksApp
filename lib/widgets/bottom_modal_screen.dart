import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:tasks/models/task.dart';
import 'package:tasks/providers/reminder.dart';
import 'package:uuid/uuid.dart';

class CreateTaskDialog extends ConsumerStatefulWidget {
  const CreateTaskDialog({super.key});

  @override
  ConsumerState<CreateTaskDialog> createState() => _CreateTaskDialogState();
}

class _CreateTaskDialogState extends ConsumerState<CreateTaskDialog> {
  final _formKey = GlobalKey<FormState>();

  bool _isSaving = false;

  final int _remindWhen = 1; // in minutes

  bool _remindTask = false;

  final TextEditingController _titleController = TextEditingController();

  final TextEditingController _contentController = TextEditingController();

  DateTime? _selectedDateTime;

  late TasksNotifier _taskProvider;

  /// Check that the _selectedDateTime is not less than then remind time
  /// to prevent execution of the reminder in the past
  bool _checkDifference() {
    return _selectedDateTime!.difference(DateTime.now()).inMinutes <= _remindWhen;
  }

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
      isPinned: _remindTask, 
    );
    
    await _taskProvider.addToTasks(newTask).then(
      (value){
        _formKey.currentState!.save();
        setState(() {
            _isSaving = false;
        });
        Navigator.of(context).pop();
      });
    if (newTask.dueDate != null && newTask.status != TaskStatus.completed){
      if (newTask.isPinned && !_checkDifference()) {
        Timer(
          _selectedDateTime!.subtract(Duration(
            minutes: ref.watch(reminderTimeProvider)
          )).difference(DateTime.now()),         () {
            print('Reminding ${newTask.id}');
          });
      }
      Timer(_selectedDateTime!.difference(DateTime.now()), () async{
        print('Expired');
        await _taskProvider.updateTaskStatus(
          newTask.id,
          TaskStatus.overdue
        );
      });
    }
  }
  @override
    void didChangeDependencies() {
      super.didChangeDependencies();
      _taskProvider = ProviderScope.containerOf(context).read(taskProvider.notifier);
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
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
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
                  SwitchListTile(
                    title: const Text('Remind Task'),
                    value: _remindTask,
                    onChanged: _selectedDateTime == null || _checkDifference() || !ref.watch(remindProvider)
                      ? null 
                      : (bool value){
                      setState((){
                        _remindTask = value;
                      });
                    }
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
