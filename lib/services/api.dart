class Api {
  static const String baseUrl = 'http://localhost:4000/api';

  static String apiUrl(String endpoint) {
    return '$baseUrl/$endpoint';
  }

  // department endpoints
  static String get departmentUrl => apiUrl('department');
  static String get departmentsUrl => apiUrl('departments');

  // GradeLevel endpoints
  static String get gradeLevelsUrl => apiUrl('gradelevels');
  static String get gradeLevelUrl => apiUrl('gradelevel');
  //Parent endpoints
  static String get parentstUrl => apiUrl('parents');
  static String get parentUrl => apiUrl('parent');
  //teachers endpoint
  static String get teachersUrl => apiUrl('teachers');
  static String get teacherUrl => apiUrl('teacher');
  // sections endpoint
  static String get sectionsUrl => apiUrl('sections');
  static String get sectionUrl => apiUrl('section');
  // sebjects endpoint
  static String get subjectsUrl => apiUrl('subjects');
  static String get subjectUrl => apiUrl('subject');
  static String get subjectGradeLevel => apiUrl('subjectGradeLevel');
  // Notifications endpoint
  static String get announcementsUrl => apiUrl('announcements');
  static String get announcementUrl => apiUrl('announcement');
  // Students endpoint
  static String get studentsUrl => apiUrl('students');
  static String get studentUrl => apiUrl('student');
  static String get studentPerSectionUrl => apiUrl('gradelevel');
  // Gradelevel with section
  static String get gradewithsection => apiUrl('gradewithsection');

  // Help endpoints
  static String get helpsUrl => apiUrl('helps');
  static String get helpUrl => apiUrl('help');
  static String get helpWithResponse => apiUrl('helpWithResponse');

  // Academic year Endpoints
  static String get academicYearsUrl => apiUrl('academicyears');
  static String get academicYear => apiUrl('academicyear');
  //attendance endpoint
  static String get attendaceUrl => apiUrl('attendances');
  //assignment endpoint
  static String get assignmentUrl => apiUrl('assignments');
  static String get assignment => apiUrl('assignment');
  //semester endpoint
  static String get semisters => apiUrl('semisters');
  static String get semister => apiUrl('semister');
  static String get academicyearsemisters => apiUrl('academicyearsemisters');
  static String get semisterAcademicyear => apiUrl('academicyear');
  //assign teacher endpoint
  static String get teacherassignments => apiUrl('teacherassignments');
  static String get teacherAssignment => apiUrl('teacherAssignment');
  static String get resultpercentages => apiUrl('result-percentages');
}
