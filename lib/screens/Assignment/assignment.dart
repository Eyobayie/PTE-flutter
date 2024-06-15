import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:parent_teacher_engagement_app/constants/appbar_constants.dart';
import 'package:parent_teacher_engagement_app/constants/scaffold_constants.dart';
import 'package:parent_teacher_engagement_app/models/subject.dart';
import 'package:parent_teacher_engagement_app/providers/AssignmentProvider.dart';
import 'package:parent_teacher_engagement_app/providers/SubjectProvider.dart';
import 'package:provider/provider.dart';

class AssignmentPage extends StatefulWidget {
  final int? gradelevelId;

  const AssignmentPage({Key? key, this.gradelevelId}) : super(key: key);

  static const String assignmentRoute = 'assignmentRoute';

  @override
  _AssignmentPageState createState() => _AssignmentPageState();
}

class _AssignmentPageState extends State<AssignmentPage> {
  late DateTime selectedStartDate = DateTime.now();
  late DateTime selectedEndDate = DateTime.now();
  late String _title = '';
  late String _description = '';
  late String _givenDate = '';
  late String _endDate = '';
  late int subjectId = 0;

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

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    if (widget.gradelevelId != null) {
      WidgetsBinding.instance!.addPostFrameCallback((_) {
        Provider.of<SubjectProvider>(context, listen: false)
            .fetchSubjectByGradelevel(widget.gradelevelId!);
      });
    }
  }

  @override
  void dispose() {
    _titleFocusNode.dispose();
    _descriptionFocusNode.dispose();
    _givenDateFocusNode.dispose();
    _endDateFocusNode.dispose();
    _titleController.dispose();
    _descriptionController.dispose();
    _givenDateController.dispose();
    _endDateController.dispose();
    super.dispose();
  }

  void saveForm() async {
    final isValid = _formKey.currentState!.validate();
    if (!isValid) {
      return;
    }
    _formKey.currentState!.save();

    final String enteredTitle = _titleController.text.trim();
    final String enteredDescription = _descriptionController.text.trim();
    final DateTime givenDate = DateFormat('yyyy-MM-dd').parse(_givenDateController.text.trim());
    final DateTime endDate = DateFormat('yyyy-MM-dd').parse(_endDateController.text.trim());

    try {
      await Provider.of<AssignmentProvider>(context, listen: false).addAssignment(
        enteredTitle,
        enteredDescription,
        subjectId,
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
        title: const Text(
          'Assignment Registration',
          style: AppBarConstants.textStyle,
        ),
        backgroundColor: AppBarConstants.backgroundColor,
        iconTheme: AppBarConstants.iconTheme,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Title',
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
                  onFieldSubmitted: (_) {
                    FocusScope.of(context).requestFocus(_descriptionFocusNode);
                  },
                  focusNode: _titleFocusNode,
                  controller: _titleController,
                  onSaved: (value) {
                    _title = value!;
                  },
                ),
                const SizedBox(height: 16.0),
                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Description',
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
                  onFieldSubmitted: (_) {
                    FocusScope.of(context).requestFocus(_givenDateFocusNode);
                  },
                  focusNode: _descriptionFocusNode,
                  controller: _descriptionController,
                  onSaved: (value) {
                    _description = value!;
                  },
                ),
                const SizedBox(height: 16.0),
                Consumer<SubjectProvider>(
                  builder: (context, subjectProvider, child) {
                    if (subjectProvider.subjectGradleles.isEmpty) {
                      return const Center(child: CircularProgressIndicator());
                    } else {
                      return DropdownButtonFormField<int>(
                        decoration: InputDecoration(
                          labelText: 'Subject',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                            borderSide: const BorderSide(color: Colors.blue),
                          ),
                        ),
                        items: subjectProvider.subjectGradleles.map((Subject sub) {
                          return DropdownMenuItem<int>(
                            value: sub.id,
                            child: Text(sub.name ?? ''),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            subjectId = value!;
                          });
                        },
                        value: subjectId != 0 ? subjectId : null,
                        validator: (value) {
                          if (value == null || value == 0) {
                            return 'Please select a subject';
                          }
                          return null;
                        },
                      );
                    }
                  },
                ),
                const SizedBox(height: 16.0),
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        readOnly: true,
                        controller: _givenDateController,
                        decoration: InputDecoration(
                          labelText: 'Given Date',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                            borderSide: const BorderSide(color: Colors.blue),
                          ),
                          suffixIcon: IconButton(
                            icon: const Icon(Icons.calendar_today),
                            onPressed: () => _selectDate(true),
                          ),
                        ),
                        onTap: () => _selectDate(true),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Given Date is required';
                          }
                          return null;
                        },
                        onSaved: (value) {
                          _givenDate = value!;
                        },
                      ),
                    ),
                    const SizedBox(width: 16.0),
                    Expanded(
                      child: TextFormField(
                        readOnly: true,
                        controller: _endDateController,
                        decoration: InputDecoration(
                          labelText: 'End Date',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                            borderSide: const BorderSide(color: Colors.blue),
                          ),
                          suffixIcon: IconButton(
                            icon: Icon(Icons.calendar_today),
                            onPressed: () => _selectDate(false),
                          ),
                        ),
                        onTap: () => _selectDate(false),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'End Date is required';
                          }
                          return null;
                        },
                        onSaved: (value) {
                          _endDate = value!;
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20.0),
                ElevatedButton(
                  onPressed: saveForm,
                  child: Text('Submit'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _selectDate(bool isGivenDate) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(DateTime.now().year + 5),
    );

    if (pickedDate != null) {
      setState(() {
        if (isGivenDate) {
          selectedStartDate = pickedDate;
          _givenDateController.text = DateFormat('yyyy-MM-dd').format(pickedDate);
        } else {
          selectedEndDate = pickedDate;
          _endDateController.text = DateFormat('yyyy-MM-dd').format(pickedDate);
        }
      });
    }
  }
}
