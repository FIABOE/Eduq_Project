class User {
  final int id;
  final String name;
  final String surname;
  final String dateNais;
  final String email;
  final String password;
  final String rememberToken;
  final String consent;
  final int filiereId;
  final int objectifId;
  final String role;

  User({
    required this.id,
    required this.name,
    required this.surname,
    required this.dateNais,
    required this.email,
    required this.password,
    required this.rememberToken,
    required this.consent,
    required this.filiereId,
    required this.objectifId,
    required this.role,
  });

  factory User.fromJson(Map<String, dynamic> json) {
  return User(
    id: json['id'] ?? 0, // Valeur par défaut pour id en cas de null
    name: json['name'] ?? 'h',
    surname: json['surname'] ?? 'h',
    dateNais: json['dateNais'] ?? 'g',
    email: json['email'] ?? 'h@gmail.com',
    password: json['password'] ?? 'd',
    rememberToken: json['remember_token'] ?? 'd',
    consent: json['consent'] ?? 'd',
    filiereId: json['filiere_id'] ?? 0, // Valeur par défaut pour filiereId en cas de null
    objectifId: json['objectif_id'] ?? 0, // Valeur par défaut pour objectifId en cas de null
    role: json['role'] ?? 'd',
  );
}


  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'surname': surname,
      'dateNais': dateNais,
      'email': email,
      'password': password,
      'remember_token': rememberToken,
      'consent': consent,
      'filiere_id': filiereId,
      'objectif_id': objectifId,
      'role': role,
    };
  }
}
