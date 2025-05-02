// Custom class to hold school details
class SchoolGroup {
  final String name;
  final String website;
  final String email;

  const SchoolGroup({
    required this.name,
    required this.website,
    required this.email,
  });

  // Override == and hashCode to allow using this class as a Map key
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SchoolGroup &&
          runtimeType == other.runtimeType &&
          name == other.name &&
          website == other.website &&
          email == other.email;

  @override
  int get hashCode => name.hashCode ^ website.hashCode ^ email.hashCode;
}
