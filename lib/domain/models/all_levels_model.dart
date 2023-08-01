import 'package:cubetis/domain/models/level_model.dart';

class AllLevelsModel {
  final List<LevelModel> levels;

  AllLevelsModel({
    required this.levels,
  });

  AllLevelsModel copyWith({
    List<LevelModel>? levels,
  }) =>
      AllLevelsModel(
        levels: levels ?? this.levels,
      );

  factory AllLevelsModel.fromJson(Map<String, dynamic> json) => AllLevelsModel(
        levels: List<LevelModel>.from(
          json["levels"].map(
            (x) => LevelModel.fromJson(x),
          ),
        ),
      );

  Map<String, dynamic> toJson() => {
        "levels": List<dynamic>.from(
          levels.map(
            (x) => x.toJson(),
          ),
        ),
      };
}
