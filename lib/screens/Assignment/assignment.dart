import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:parent_teacher_engagement_app/constants/appbar_constants.dart';
import 'package:parent_teacher_engagement_app/constants/scaffold_constants.dart';
import 'package:parent_teacher_engagement_app/models/parent.dart';
import 'package:parent_teacher_engagement_app/models/subject.dart';
import 'package:parent_teacher_engagement_app/providers/AssignmentProvider.dart';
import 'package:parent_teacher_engagement_app/providers/SubjectProvider.dart';
import 'package:parent_teacher_engagement_app/services/subject/subject.dart';
import 'package:parent_teacher_engagement_app/widgets/sharedButton.dart';
import 'package:provider/provider.dart';

class AssignmentPage extends StatefulWidget {
  final int? gradelevelId;
  const AssignmentPage({super.key, this.gradelevelId});
  static const String assignmentRoute = 'assignmentRoute';

  @override
  State<AssignmentPage> createState() => _AssignmentPageState();
}

class _AssignmentPageState extends State<AssignmentPage> {
  late DateTime selectedStartDate = DateTime.now();
  late DateTime selectedEndDate = DateTime.now();
  late String _title;
  late String _description;
  late String _givenDate;
  late int _endDate;
  late int SubjectId = 0;

  // Declaring focus nodes
  final _titleFocusNode = FocusNode();
  final _descriptionFocusNode = FocusNode();
  final _givenDateFocusNode = FocusNode();
  final _endDateFocusNode = FocusNode();

  // Declaring controllers
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _givenDateController = TextEditingController();
  final _endDateController = TextEditingController();
  final _startTimeController = TextEditingController();
  final _endTimeController = TextEditingController();

  Parent? parent;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    print('geggeggegge:${widget.gradelevelId}');
    if (widget.gradelevelId != null) {
      WidgetsBinding.instance!.addPostFrameCallback((_) {
        Provider.of<SubjectProvider>(context, listen: false)
            .fetchSubjectByGradelevel(widget.gradelevelId!)
            .then((_) {
          setState(() {
            final subjectProvider =
                Provider.of<SubjectProvider>(context, listen: false);
            SubjectId = subjectProvider.subjectGradleles.isNotEmpty
                ? subjectProvider.subjectGradleles.first.id
                : 0;
          });
        });
      });
    }
  }

  void saveForm() async {
    final isValid = _formKey.currentState!.validate();
    if (!isValid) {
      return;
    }
    _formKey.currentState!.save();

    final String enteredTitle = _titleController.text.trim();
    final String enteredDescription = _descriptionController.text.trim();
    final DateTime givenDate =
        DateFormat('yyyy-MM-dd').parse(_givenDateController.text.trim());
    final DateTime endDate =
        DateFormat('yyyy-MM-dd').parse(_endDateController.text.trim());

    try {
      await Provider.of<AssignmentProvider>(context, listen: false)
          .addAssignment(
        enteredTitle,
        enteredDescription,
        SubjectId,
        givenDate,
        endDate,
      );
      Navigator.of(context).pop(); // Pop the create page

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Assignment created successfully!'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (error) {
      print('Error creating assignment: $error');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Error creating assignment. Please try again.'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ScaffoldConstants.backgroundColor,
      appBar: AppBar(
        title: Text(
          parent == null ? 'Assignment registration' : 'Edit Assignment',
          style: AppBarConstants.textStyle,
        ),
        backgroundColor: AppBarConstants.backgroundColor,
        iconTheme: AppBarConstants.iconTheme,
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(15, 50, 15, 0),
        child: Form(
          key: _formKey,
          child: ListView(
            shrinkWrap: true,
            children: <Widget>[
              TextFormField(
                decoration: InputDecoration(
                  labelText: "Title",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide: const BorderSide(color: Colors.blue),
                  ),
                ),
                textInputAction: TextInputAction.next,
                keyboardType: TextInputType.text,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Title is required';
                  }
                  return null;
                },
                onFieldSubmitted: (value) {
                  FocusScope.of(context).requestFocus(_descriptionFocusNode);
                },
                focusNode: _titleFocusNode,
                maxLines: 1,
                controller: _titleController,
                onSaved: (value) {
                  _title = value!;
                },
              ),
              const SizedBox(height: 10),
              TextFormField(
                decoration: InputDecoration(
                  labelText: "Description",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide: const BorderSide(color: Colors.blue),
                  ),
                ),
                textInputAction: TextInputAction.next,
                keyboardType: TextInputType.text,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Description is required';
                  }
                  return null;
                },
                onFieldSubmitted: (value) {
                  FocusScope.of(context).requestFocus(_givenDateFocusNode);
                },
                focusNode: _descriptionFocusNode,
                maxLines: 2,
                controller: _descriptionController,
                onSaved: (value) {
                  _description = value!;
                },
              ),
              const SizedBox(
                height: 10,
              ),
              Consumer<SubjectProvider>(
                builder: (context, subjectProvider, child) {
                  if (subjectProvider.subjectGradleles.isEmpty) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  return DropdownButtonFormField<int>(
                    decoration: InputDecoration(
                      labelText: "Subject",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        borderSide: const BorderSide(color: Colors.blue),
                      ),
                    ),
                    items: subjectProvider.subjectGradleles.map((Subject sub) {
                      return DropdownMenuItem<int>(
                        value: sub.id,
                        child: Text(sub.name),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        SubjectId = value!;
                      });
                    },
                    value: SubjectId != 0 ? SubjectId : null,
                    validator: (value) {
                      if (value == null || value == 0) {
                        return 'Please select a subject';
                      }
                      return null;
                    },
                  );
                },
              ),
              const SizedBox(
                height: 10,
              ),
              Row(
                children: [
                  Column(
                    children: [
                      const SizedBox(
                        height: 10,
                      ),
                      SizedBox(
                        width: 220,
                        child: TextFormField(
                          readOnly: true,
                          controller: _startTimeController,
                          decoration: InputDecoration(
                            contentPadding: const EdgeInsets.all(16),
                            hintText: 'Select Start Time',
                            hintStyle: const TextStyle(fontSize: 14),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                          ),
                          onTap: () {
                            _selectStartTime(context);
                          },
                          maxLines: 1,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(width: 20),
                  Column(
                    children: [
                      const SizedBox(
                        height: 10,
                      ),
                      SizedBox(
                        width: 230,
                        child: TextFormField(
                          readOnly: true,
                          controller: _endTimeController,
                          decoration: InputDecoration(
                            contentPadding: const EdgeInsets.all(16),
                            hintText: 'Select End Time',
                            hintStyle: const TextStyle(fontSize: 14),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                          ),
                          onTap: () {
                            _selectEndTime(context);
                          },
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(
                width: 60,
                height: 40,
              ),
              SharedButton(
                onPressed: () => saveForm(),
                text: parent == null ? 'Submit' : 'Update',
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _selectStartTime(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(2015, 8),
        lastDate: DateTime(2101),
        builder: (context, child) {
          return Transform.scale(
            scale: 0.8,
            child: child,
          );
        });
    if (pickedDate != null) {
      setState(() {
        _startTimeController.text = DateFormat('yyyy-MM-dd').format(pickedDate);
        _givenDateController.text = DateFormat('yyyy-MM-dd').format(pickedDate);
      });
    }
  }

  Future<void> _selectEndTime(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2015, 8),
      lastDate: DateTime(2101),
      builder: (context, child) {
        return Transform.scale(
          scale: 0.8,
          child: child,
        );
      },
    );
    if (pickedDate != null) {
      setState(() {
        _endTimeController.text = DateFormat('yyyy-MM-dd').format(pickedDate);
        _endDateController.text = DateFormat('yyyy-MM-dd').format(pickedDate);
      });
      print(_endDateController.text);
    }
  }
}
