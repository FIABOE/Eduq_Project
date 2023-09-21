class Moderateur {
  final int id;
  final String name; 

  
  Moderateur({
    required this.id,
    required this.name,
  });

  factory Moderateur.fromJson(Map<String, dynamic> json) {
    return Moderateur(
      id: json['id'],
      name: json['name'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
    };
  }
}