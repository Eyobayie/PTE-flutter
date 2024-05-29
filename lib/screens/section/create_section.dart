import 'package:flutter/material.dart';
import 'package:parent_teacher_engagement_app/constants/appbar_constants.dart';
import 'package:parent_teacher_engagement_app/providers/AcademicYearProvider.dart';
import 'package:parent_teacher_engagement_app/services/section/section.dart';
import 'package:provider/provider.dart';

import '../../constants/scaffold_constants.dart';

class CreateSection extends StatefulWidget {
  const CreateSection({super.key});
  static const createSectionRoute = 'createSectionRoute';

  @override
  State<CreateSection> createState() => _CreateSectionState();
}

class _CreateSectionState extends State<CreateSection> {
  late String _name;
  late String _description;
  final _nameFocusNode = FocusNode();
  final _descriptionFocusNode = FocusNode();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  int? gradelevelId;
  int? _selectedAcademicYearId;

  @override
  void initState() {
    super.initState();
    Provider.of<AcademicYearProvider>(context, listen: false)
        .fetchAcademicYears();
  }

  void saveForm() {
    final isValid = _formKey.currentState!.validate();
    if (!isValid || _selectedAcademicYearId == null) {
      return;
    }
    _formKey.currentState!.save();
    createSection(_name, _description, gradelevelId!);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    gradelevelId = ModalRoute.of(context)!.settings.arguments as int;

    return Scaffold(
      backgroundColor: ScaffoldConstants.backgroundColor,
      appBar: AppBar(
        title: const Text(
          'Add new gradelevels',
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
                  labelText: "Section",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide: const BorderSide(color: Colors.blue),
                  ),
                ),
                textInputAction: TextInputAction.next,
                keyboardType: TextInputType.text,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Grade level is required';
                  }
                  return null;
                },
                onFieldSubmitted: (value) {
                  FocusScope.of(context).requestFocus(_descriptionFocusNode);
                },
                focusNode: _nameFocusNode,
                maxLines: 1,
                controller: _nameController,
                onSaved: (value) {
                  _name = value!;
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
                textInputAction: TextInputAction.done,
                keyboardType: TextInputType.text,
                focusNode: _descriptionFocusNode,
                maxLines: 4,
                controller: _descriptionController,
                onSaved: (value) {
                  _description = value!;
                },
              ),
              const SizedBox(height: 10),
              Consumer<AcademicYearProvider>(
                builder: (context, academicYearProvider, child) {
                  if (academicYearProvider.academicYears.isEmpty) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  return DropdownButtonFormField<int>(
                    decoration: InputDecoration(
                      labelText: "Academic Year",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        borderSide: const BorderSide(color: Colors.blue),
                      ),
                    ),
                    items:
                        academicYearProvider.academicYears.map((academicYear) {
                      return DropdownMenuItem<int>(
                        value: academicYear.id,
                        child: Text(academicYear.year.toString()),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        _selectedAcademicYearId = value;
                      });
                    },
                    value: _selectedAcademicYearId,
                    validator: (value) {
                      if (value == null) {
                        return 'Please select an academic year';
                      }
                      return null;
                    },
                  );
                },
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: saveForm,
                child: const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  child: Text(
                    "Submit",
                    style: TextStyle(
                      color: Colors.white,
                      backgroundColor: Colors.orange,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
