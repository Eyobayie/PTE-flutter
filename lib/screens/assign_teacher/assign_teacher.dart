// ignore_for_file: non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:parent_teacher_engagement_app/constants/appbar_constants.dart';
import 'package:parent_teacher_engagement_app/constants/scaffold_constants.dart';
import 'package:parent_teacher_engagement_app/providers/AcademicYearProvider.dart';
import 'package:parent_teacher_engagement_app/providers/DepartmentProvider.dart';
import 'package:parent_teacher_engagement_app/providers/GradelevelProvider.dart';
import 'package:provider/provider.dart';

class AssignTeacher extends StatefulWidget {
  const AssignTeacher({super.key});
  static const String assignTeacherRoute = 'assignTeacherRoute';

  @override
  State<AssignTeacher> createState() => _AssignTeacherState();
}

class _AssignTeacherState extends State<AssignTeacher> {
  int? AcademicYearId;
  int? SemisterId;
  int? DepartmentID;
  int? GradelevelId;
  int? SectionId;
  int? SubjectId;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    Provider.of<AcademicYearProvider>(context, listen: false)
        .fetchAcademicYears();
    Provider.of<DepartmentProvider>(context).fetchDepartments();
    Provider.of<GradelevelProvider>(context, listen: false).fetchGradelevels();
  }

  void saveForm() {
    final isValid = _formKey.currentState!.validate();
  }

  @override
  Widget build(BuildContext context) {
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
                        AcademicYearId = value;
                      });
                    },
                    value: AcademicYearId,
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
