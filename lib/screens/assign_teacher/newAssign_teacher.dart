// ignore_for_file: non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:parent_teacher_engagement_app/constants/appbar_constants.dart';
import 'package:parent_teacher_engagement_app/constants/card_constants.dart';
import 'package:parent_teacher_engagement_app/models/assign_teacher_model.dart';
import 'package:parent_teacher_engagement_app/models/gradelevel.dart';
import 'package:parent_teacher_engagement_app/models/section.dart';
import 'package:parent_teacher_engagement_app/models/semister_model.dart';
import 'package:parent_teacher_engagement_app/providers/AcademicYearProvider.dart';
import 'package:parent_teacher_engagement_app/providers/AssignmentProvider.dart';
import 'package:parent_teacher_engagement_app/providers/DepartmentProvider.dart';
import 'package:parent_teacher_engagement_app/providers/GradelevelProvider.dart';
import 'package:parent_teacher_engagement_app/providers/SectionProvider.dart';
import 'package:parent_teacher_engagement_app/providers/SubjectProvider.dart';
import 'package:parent_teacher_engagement_app/providers/TeacherProvider.dart';
import 'package:parent_teacher_engagement_app/providers/assinTeacher_provider.dart';
import 'package:parent_teacher_engagement_app/providers/semister_provider.dart';
import 'package:parent_teacher_engagement_app/widgets/sharedButton.dart';

import 'package:provider/provider.dart';

import '../../constants/scaffold_constants.dart';
import '../../models/department.dart';

class NewTeacherAssignment extends StatefulWidget {
  const NewTeacherAssignment({super.key});
  static const String newTeacherAssignmentRoute = 'newTeacherAssignment';

  @override
  State<NewTeacherAssignment> createState() => _NewTeacherAssignmentState();
}

class _NewTeacherAssignmentState extends State<NewTeacherAssignment> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  AssignTeacherModel? assignTeacher;
  int? TeacherId;
  int? AcademicYearId;
  int? SemisterId;
  int? DepartmentID;
  int? SubjectId;
  int? GradelevelId;
  int? SectionId;

  int? _selectedAcademicYearId;

  @override
  void initState() {
    super.initState();
    Provider.of<AcademicYearProvider>(context, listen: false)
        .fetchAcademicYears();
    Provider.of<TeacherProvider>(context, listen: false).fetchTeachers();
    Provider.of<DepartmentProvider>(context, listen: false).fetchDepartments();
    Provider.of<SemisterProvider>(context, listen: false).fetchSemisters();
    Provider.of<GradelevelProvider>(context, listen: false).fetchGradelevels();
    Provider.of<SubjectProvider>(context, listen: false).fetchSubjects();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args = ModalRoute.of(context)?.settings.arguments;
    if (args is AssignTeacherModel) {
      assignTeacher = args;

      AcademicYearId = assignTeacher?.AcademicYearId;
      TeacherId = assignTeacher?.TeacherId;
      SemisterId = assignTeacher?.SemisterId;
      DepartmentID = assignTeacher?.DepartmentID;
      SubjectId = assignTeacher?.SubjectId;
      GradelevelId = assignTeacher?.GradelevelId;
      SectionId = assignTeacher?.SectionId;
    }
  }

  void saveForm() async {
    final isValid = _formKey.currentState!.validate();
    if (!isValid || AcademicYearId == null) {
      return;
    }
    _formKey.currentState!.save();

    // Print values to the terminal
    print('TeacherId: $TeacherId');
    print('AcademicYearId: $AcademicYearId');
    print('SemisterId: $SemisterId');
    print('DepartmentID: $DepartmentID');
    print('SubjectId: $SubjectId');
    print('GradelevelId: $GradelevelId');
    print('SectionId: $SectionId');

    if (assignTeacher == null) {
      // Create new semester
      try {
        await Provider.of<AssignTeacherProvider>(context, listen: false)
            .addAssignedTeacher(
          TeacherId!,
          AcademicYearId!,
          SemisterId!,
          DepartmentID!,
          SubjectId!,
          GradelevelId!,
          SectionId!,
        );
      } catch (error) {
        print('Error occurring assigning the teacher to class: $error');
      }
    } else {
      // Update existing semester
      try {
        await Provider.of<AssignTeacherProvider>(context, listen: false)
            .updateAssignedTeacher(assignTeacher!);
      } catch (error) {
        print('Error updating semester: $error');
      }
    }

    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ScaffoldConstants.backgroundColor,
      appBar: AppBar(
        title: Text(
          assignTeacher == null
              ? 'Add new AssignTeacher'
              : 'Edit AssignedTeacher',
          style: AppBarConstants.textStyle,
        ),
        backgroundColor: AppBarConstants.backgroundColor,
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(15.0, 50.0, 15.0, 0),
        child: Card(
          elevation: CardConstants.elevationHeight,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(15.0, 50.0, 15.0, 70),
            child: Form(
              key: _formKey,
              child: ListView(
                shrinkWrap: true,
                children: <Widget>[
                  Consumer<TeacherProvider>(
                    builder: (context, teacherProvider, child) {
                      if (teacherProvider.teachers.isEmpty) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      return DropdownButtonFormField<int>(
                        decoration: InputDecoration(
                          labelText: "Teacher",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                            borderSide: const BorderSide(color: Colors.blue),
                          ),
                        ),
                        items: teacherProvider.teachers.map((teacher) {
                          return DropdownMenuItem<int>(
                            value: teacher.id,
                            child: Text(teacher.firstname),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            TeacherId = value;
                          });
                        },
                        value: TeacherId,
                        validator: (value) {
                          if (value == null) {
                            return 'Please select an  teacher';
                          }
                          return null;
                        },
                      );
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
                        items: academicYearProvider.academicYears
                            .map((academicYear) {
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
                  Consumer<SemisterProvider>(
                    builder: (context, semisterProvider, child) {
                      if (semisterProvider.semisters.isEmpty) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      return DropdownButtonFormField<int>(
                        decoration: InputDecoration(
                          labelText: "Semister",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                            borderSide: const BorderSide(color: Colors.blue),
                          ),
                        ),
                        items: semisterProvider.semisters.map((semister) {
                          return DropdownMenuItem<int>(
                            value: semister.id,
                            child: Text(semister.name),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            SemisterId = value;
                          });
                        },
                        value: SemisterId,
                        validator: (value) {
                          if (value == null) {
                            return 'Please select an semister';
                          }
                          return null;
                        },
                      );
                    },
                  ),
                  const SizedBox(height: 10),
                  Consumer<DepartmentProvider>(
                    builder: (context, deptProvider, child) {
                      if (deptProvider.departments.isEmpty) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      return DropdownButtonFormField<int>(
                        decoration: InputDecoration(
                          labelText: "Department",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                            borderSide: const BorderSide(color: Colors.blue),
                          ),
                        ),
                        items: deptProvider.departments.map((department) {
                          return DropdownMenuItem<int>(
                            value: department.id,
                            child: Text(department.name),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            DepartmentID = value;
                          });
                        },
                        value: DepartmentID,
                        validator: (value) {
                          if (value == null) {
                            return 'Please select an department';
                          }
                          return null;
                        },
                      );
                    },
                  ),
                  const SizedBox(height: 10),
                  Consumer<SubjectProvider>(
                    builder: (context, subProvider, child) {
                      if (subProvider.subjects.isEmpty) {
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
                        items: subProvider.subjects.map((subject) {
                          return DropdownMenuItem<int>(
                            value: subject.id,
                            child: Text(subject.name),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            SubjectId = value;
                          });
                        },
                        value: SubjectId,
                        validator: (value) {
                          if (value == null) {
                            return 'Please select an Subject';
                          }
                          return null;
                        },
                      );
                    },
                  ),
                  const SizedBox(height: 10),
                  Consumer<GradelevelProvider>(
                    builder: (context, gradelevelProvider, child) {
                      if (gradelevelProvider.gradelevels.isEmpty) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      return DropdownButtonFormField<int>(
                        decoration: InputDecoration(
                          labelText: "Grade level",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                            borderSide: const BorderSide(color: Colors.blue),
                          ),
                        ),
                        items: gradelevelProvider.gradelevels
                            .map((Gradelevel gradelevel) {
                          return DropdownMenuItem<int>(
                            value: gradelevel.id,
                            child: Text(gradelevel.grade),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            GradelevelId = value;
                            Provider.of<SectionProvider>(context, listen: false)
                                .fetchSections(GradelevelId);
                            SectionId =
                                null; // Reset section when grade level changes
                          });
                        },
                        value: GradelevelId,
                        validator: (value) {
                          if (value == null) {
                            return 'Please select a grade level';
                          }
                          return null;
                        },
                      );
                    },
                  ),
                  const SizedBox(height: 20),
                  Consumer<SectionProvider>(
                    builder: (context, sectionProvider, child) {
                      if (GradelevelId == null ||
                          sectionProvider.sections.isEmpty) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      return DropdownButtonFormField<int>(
                        decoration: InputDecoration(
                          labelText: "Section",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                            borderSide: const BorderSide(color: Colors.blue),
                          ),
                        ),
                        items: sectionProvider.sections.map((Section section) {
                          return DropdownMenuItem<int>(
                            value: section.id,
                            child: Text(section.name),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            SectionId = value;
                          });
                        },
                        value: SectionId,
                        validator: (value) {
                          if (value == null) {
                            return 'Please select a section';
                          }
                          return null;
                        },
                      );
                    },
                  ),
                  const SizedBox(height: 40),
                  SharedButton(
                    onPressed: saveForm,
                    text: assignTeacher == null ? 'CREATE' : 'UPDATE',
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
