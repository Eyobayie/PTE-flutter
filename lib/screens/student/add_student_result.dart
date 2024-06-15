import 'package:flutter/material.dart';
import 'package:parent_teacher_engagement_app/constants/appbar_constants.dart';
import 'package:parent_teacher_engagement_app/providers/AcademicYearProvider.dart';
import 'package:parent_teacher_engagement_app/providers/SubjectProvider.dart';
import 'package:parent_teacher_engagement_app/providers/resultPercentageProvider.dart';
import 'package:parent_teacher_engagement_app/providers/semister_provider.dart';
import 'package:parent_teacher_engagement_app/providers/studentResultProvider.dart';
import 'package:provider/provider.dart';

class CreateStudentResultForm extends StatefulWidget {
  static const resultFormRote = "result-form";
  const CreateStudentResultForm({Key? key}) : super(key: key);

  @override
  _CreateStudentResultFormState createState() => _CreateStudentResultFormState();
}

class _CreateStudentResultFormState extends State<CreateStudentResultForm> {
  final _formKey = GlobalKey<FormState>();
  double _result = 0.0;
  String _resultType = '';
  int? _selectedAcademicYear;
  int? _selectedSemister;
  int? _selectedSubject;
  int? _selectedResultPercentage;

  int? _studentId; // Change Student to int
  bool _isInit = true;

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (_isInit) {
      _studentId = ModalRoute.of(context)!.settings.arguments as int; // Retrieve the studentId
      
      // Fetch initial data
      Provider.of<AcademicYearProvider>(context, listen: false).fetchAcademicYears();
      Provider.of<SemisterProvider>(context, listen: false).fetchSemisters();
      Provider.of<SubjectProvider>(context, listen: false).fetchSubjects();
      
      _isInit = false;
    }
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Student Result',style: AppBarConstants.textStyle,),
        centerTitle: true,
        backgroundColor: AppBarConstants.backgroundColor,
      ),
      body: Consumer4<AcademicYearProvider, SemisterProvider, SubjectProvider, ResultPercentageProvider>(
        builder: (context, academicYearProvider, semisterProvider, subjectProvider, resultPercentageProvider, child) {
          return Form(
            key: _formKey,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: ListView(
                children: [
                  TextFormField(
                    decoration: const InputDecoration(
                      labelText: 'Result',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.number,
                    onSaved: (value) {
                      _result = double.parse(value!);
                    },
                  ),
                  const SizedBox(height: 16.0),
                  DropdownButtonFormField<String>(
                    decoration:const InputDecoration(
                      labelText: 'Result Type',
                      border: OutlineInputBorder(),
                    ),
                    items: ['Midterm', 'Final', 'Assignment'].map((String type) {
                      return DropdownMenuItem<String>(
                        value: type,
                        child: Text(type),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        _resultType = value!;
                      });
                    },
                    validator: (value) => value == null ? 'Please select a result type' : null,
                  ),
                  const SizedBox(height: 16.0),
                  DropdownButtonFormField<int>(
                    decoration:const InputDecoration(
                      labelText: 'Academic Year',
                      border: OutlineInputBorder(),
                    ),
                    items: academicYearProvider.academicYears.map((academicYear) {
                      return DropdownMenuItem<int>(
                        value: academicYear.id,
                        child: Text(academicYear.year.toString()),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        _selectedAcademicYear = value;
                      });
                      if (value != null) {
                        semisterProvider.fetchSemistersByAcademicYear(value);
                        Provider.of<ResultPercentageProvider>(context, listen: false).fetchResultPercentagesPerYearProvider(value);
                      }
                    },
                    validator: (value) => value == null ? 'Please select an academic year' : null,
                  ),
                  const SizedBox(height: 16.0),
                  DropdownButtonFormField<int>(
                    decoration:const InputDecoration(
                      labelText: 'Semister',
                      border: OutlineInputBorder(),
                    ),
                    items: semisterProvider.semisters.map((semister) {
                      return DropdownMenuItem<int>(
                        value: semister.id,
                        child: Text(semister.name ?? ''),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        _selectedSemister = value;
                      });
                    },
                    validator: (value) => value == null ? 'Please select a semister' : null,
                  ),
                  const SizedBox(height: 16.0),
                  DropdownButtonFormField<int>(
                    decoration:const InputDecoration(
                      labelText: 'Subject',
                      border: OutlineInputBorder(),
                    ),
                    items: subjectProvider.subjects.map((subject) {
                      return DropdownMenuItem<int>(
                        value: subject.id,
                        child: Text(subject.name ?? ''),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        _selectedSubject = value;
                      });
                    },
                    validator: (value) => value == null ? 'Please select a subject' : null,
                  ),
                  const SizedBox(height: 16.0),
                  DropdownButtonFormField<int>(
                    decoration:const InputDecoration(
                      labelText: 'Result Percentage',
                      border: OutlineInputBorder(),
                    ),
                    items: resultPercentageProvider.resultPercentages.map((resultPercentage) {
                      return DropdownMenuItem<int>(
                        value: resultPercentage.id,
                        child: Text(resultPercentage.name),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        _selectedResultPercentage = value;
                      });
                    },
                    validator: (value) => value == null ? 'Please select a result percentage' : null,
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        _formKey.currentState!.save();
                        Provider.of<ResultProvider>(context, listen: false).createStudentResultProvider(
                          studentId: _studentId!, // Use the studentId
                          result: _result,
                          resultType: _resultType,
                          academicYearId: _selectedAcademicYear!,
                          semisterId: _selectedSemister!,
                          subjectId: _selectedSubject!,
                          resultPercentageId: _selectedResultPercentage!,
                        );
                      }
                    },
                    child: const Text('Submit'),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
