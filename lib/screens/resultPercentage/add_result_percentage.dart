import 'package:flutter/material.dart';
import 'package:parent_teacher_engagement_app/constants/appbar_constants.dart';
import 'package:parent_teacher_engagement_app/models/academic_year.dart';
import 'package:parent_teacher_engagement_app/models/semister_model.dart';
import 'package:parent_teacher_engagement_app/providers/AcademicYearProvider.dart';
import 'package:parent_teacher_engagement_app/providers/resultPercentageProvider.dart';
import 'package:parent_teacher_engagement_app/providers/semister_provider.dart';
import 'package:parent_teacher_engagement_app/widgets/sharedButton.dart';
import 'package:provider/provider.dart';

class NewResultPercentageForm extends StatefulWidget {
  const NewResultPercentageForm({Key? key}) : super(key: key);

  static const String newResultParcentageRoute = 'new-result-percentage';

  @override
  _NewResultPercentageFormState createState() =>
      _NewResultPercentageFormState();
}

class _NewResultPercentageFormState extends State<NewResultPercentageForm> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _percentageController = TextEditingController();

  int? _selectedAcademicYearId;
  int? _selectedSemisterId;

  @override
  void initState() {
    super.initState();
    Provider.of<AcademicYearProvider>(context, listen: false)
        .fetchAcademicYears();
    Provider.of<SemisterProvider>(context, listen: false).fetchSemisters();
  }

  void saveForm() async {
    final isValid = _formKey.currentState!.validate();
    if (!isValid) {
      return;
    }
    _formKey.currentState!.save();
    final String name = _nameController.text.trim();
    final double percentage = double.parse(_percentageController.text.trim());
    final int academicYearId = _selectedAcademicYearId!;
    final int semisterId = _selectedSemisterId!;

    try {
      await Provider.of<ResultPercentageProvider>(context, listen: false)
          .createResultPercentage(name, percentage, academicYearId, semisterId);
      Navigator.pop(context);
    } catch (error) {
      print('Error creating result percentage: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add New Result Percentage',style: AppBarConstants.textStyle,),
        centerTitle: true,
        backgroundColor: AppBarConstants.backgroundColor,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: <Widget>[
              TextFormField(
                controller: _nameController,
                decoration:const InputDecoration(
                  labelText: 'Name',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the name';
                  }
                  return null;
                },
                onSaved: (value) {
                  _nameController.text = value!;
                },
              ),
              const SizedBox(height: 16.0),
              TextFormField(
                controller: _percentageController,
                decoration: const InputDecoration(
                  labelText: 'Percentage',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the percentage';
                  }
                  final percentage = double.tryParse(value);
                  if (percentage == null ||
                      percentage < 0 ||
                      percentage > 100) {
                    return 'Please enter a valid percentage';
                  }
                  return null;
                },
                onSaved: (value) {
                  _percentageController.text = value!;
                },
              ),
              const SizedBox(height: 16.0),
              Consumer<AcademicYearProvider>(
                builder: (context, academicYearProvider, child) {
                  if (academicYearProvider.academicYears.isEmpty) {
                    return const Center(child: CircularProgressIndicator());
                  } else {
                    return DropdownButtonFormField<int>(
                      decoration: const InputDecoration(
                        labelText: 'Academic Year',
                        border: OutlineInputBorder(),
                      ),
                      value: _selectedAcademicYearId,
                      items: academicYearProvider.academicYears
                          .map((AcademicYear academicYear) {
                        return DropdownMenuItem<int>(
                          value: academicYear.id,
                          child: Text('${academicYear.year}'),
                        );
                      }).toList(),
                      onChanged: (int? newValue) {
                        setState(() {
                          _selectedAcademicYearId = newValue;
                          _selectedSemisterId =
                              null; // Reset semester selection
                        });
                        if (newValue != null) {
                          Provider.of<SemisterProvider>(context, listen: false)
                              .fetchSemistersByAcademicYear(newValue);
                        }
                      },
                      validator: (value) {
                        if (value == null) {
                          return 'Please select an academic year';
                        }
                        return null;
                      },
                    );
                  }
                },
              ),
              const SizedBox(height: 16.0),
              Consumer<SemisterProvider>(
                builder: (context, semisterProvider, child) {
                  if (_selectedAcademicYearId == null) {
                    return const SizedBox(); // Show nothing if no academic year is selected
                  }
                  if (semisterProvider.semisters.isEmpty) {
                    return const Center(child: CircularProgressIndicator());
                  } else {
                    return DropdownButtonFormField<int>(
                      decoration:const InputDecoration(
                        labelText: 'Semester',
                        border: OutlineInputBorder(),
                      ),
                      value: _selectedSemisterId,
                      items:
                          semisterProvider.semisters.map((Semister semister) {
                        return DropdownMenuItem<int>(
                          value: semister.id,
                          child: Text(semister.name),
                        );
                      }).toList(),
                      onChanged: (int? newValue) {
                        setState(() {
                          _selectedSemisterId = newValue;
                        });
                      },
                      validator: (value) {
                        if (value == null) {
                          return 'Please select a semester';
                        }
                        return null;
                      },
                    );
                  }
                },
              ),
              const SizedBox(height: 20),
              SharedButton(onPressed: saveForm, text: "Submit")
            ],
          ),
        ),
      ),
    );
  }
}
