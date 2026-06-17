class DailyLog {
  int waterOz;
  bool weightLogged;
  double? weight;
  final Map<String, bool> supplementStatus;

  DailyLog({
    this.waterOz = 0,
    this.weightLogged = false,
    this.weight,
    Map<String, bool>? supplementStatus,
  }) : supplementStatus = supplementStatus ?? {};
}

class PersonProfile {
  final String name;
  final int waterGoalOz;
  final List<String> supplements;

  const PersonProfile({
    required this.name,
    required this.waterGoalOz,
    required this.supplements,
  });
}
