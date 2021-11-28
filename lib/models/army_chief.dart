class ArmyChief {
  String name = "";
  String tenure = "";
  String img = "";

  ArmyChief({required this.name, required this.tenure, required this.img});

  @override
  String toString() {
    return 'ArmyChief{name: $name, tenure: $tenure, img: $img}';
  }

  factory ArmyChief.fromJson(Map<String, dynamic> json) {
    return ArmyChief(
      name: json["name"] ?? "",
      tenure: json["tenure"] ?? "",
      img: json["img"] ?? ""
    );
  }
}