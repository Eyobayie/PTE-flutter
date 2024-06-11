import 'package:parent_teacher_engagement_app/models/academic_year.dart';
import 'package:parent_teacher_engagement_app/models/result_percentage.dart';
import 'package:parent_teacher_engagement_app/models/semister_model.dart';
import 'package:parent_teacher_engagement_app/models/student.dart';
import 'package:parent_teacher_engagement_app/models/subject.dart';

class StudentResult {
  final int id;
  final double result;
  final String resultType;
  final AcademicYear academicYear;
  final Semister semister;
  final Subject subject;
  final Student student;
  final ResultPercentage resultPercentage;

  StudentResult({
    required this.id,
    required this.result,
    required this.resultType,
    required this.academicYear,
    required this.semister,
    required this.subject,
    required this.student,
    required this.resultPercentage,
  });

  factory StudentResult.fromJson(Map<String, dynamic> json) {
    return StudentResult(
      id: json['id'],
      result: json['result'],
      resultType: json['ResultType'],
      academicYear: AcademicYear.fromJson(json['AcademicYear']),
      semister: Semister.fromJson(json['Semister']),
      subject: Subject.fromJson(json['Subject']),
      student: Student.fromJson(json['Student']),
      resultPercentage: ResultPercentage.fromJson(json['ResultPercentage']),
    );
  }
}