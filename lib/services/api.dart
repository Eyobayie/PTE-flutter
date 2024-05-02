class ApiService {
  static const String baseUrl = 'http://localhost:5000/api';

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
}
