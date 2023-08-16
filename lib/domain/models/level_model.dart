class LevelModel {
  final String id;
  final int level;
  final String name;
  final List<int> coinsPos;
  final List<EnemyModel> enemies;
  final int finishPos;
  final int playerPos;
  final List<int> wallsPos;
  final String creationDate;

  LevelModel({
    required this.id,
    required this.level,
    required this.name,
    required this.coinsPos,
    required this.enemies,
    required this.finishPos,
    required this.playerPos,
    required this.wallsPos,
    required this.creationDate,
  });

  LevelModel copyWith({
    String? id,
    int? level,
    String? name,
    List<int>? coinsPos,
    List<EnemyModel>? enemies,
    int? playerPos,
    int? finishPos,
    List<int>? wallsPos,
    String? creationDate,
  }) =>
      LevelModel(
        id: id ?? this.id,
        level: level ?? this.level,
        name: name ?? this.name,
        coinsPos: coinsPos ?? this.coinsPos,
        enemies: enemies ?? this.enemies,
        playerPos: playerPos ?? this.playerPos,
        finishPos: finishPos ?? this.finishPos,
        wallsPos: wallsPos ?? this.wallsPos,
        creationDate: creationDate ?? this.creationDate,
      );

  factory LevelModel.fromJson(Map<String, dynamic> json) => LevelModel(
        id: json["id"],
        level: json["level"],
        name: json["name"],
        coinsPos: List<int>.from(json["coinsPos"].map((x) => x)),
        enemies: List<EnemyModel>.from(
            json["enemies"].map((x) => EnemyModel.fromJson(x))),
        playerPos: json["playerPos"],
        finishPos: json["finishPos"],
        wallsPos: List<int>.from(json["wallsPos"].map((x) => x)),
        creationDate: json["creationDate"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "level": level,
        "name": name,
        "coinsPos": List<dynamic>.from(coinsPos.map((x) => x)),
        "enemies": List<dynamic>.from(enemies.map((x) => x.toJson())),
        "playerPos": playerPos,
        "finishPos": finishPos,
        "wallsPos": List<dynamic>.from(wallsPos.map((x) => x)),
        "creationDate": creationDate,
      };
}

class EnemyModel {
  final int id;
  final List<int> enemiesPos;
  final int speed;

  EnemyModel({
    required this.id,
    required this.enemiesPos,
    required this.speed,
  });

  EnemyModel copyWith({
    int? id,
    List<int>? enemiesPos,
    int? speed,
  }) =>
      EnemyModel(
        id: id ?? this.id,
        enemiesPos: enemiesPos ?? this.enemiesPos,
        speed: speed ?? this.speed,
      );

  factory EnemyModel.fromJson(Map<String, dynamic> json) => EnemyModel(
        id: json["id"],
        enemiesPos: List<int>.from(
          json["enemiesPos"].map((x) => x),
        ),
        speed: json["speed"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "enemiesPos": List<dynamic>.from(
          enemiesPos.map((x) => x),
        ),
        "speed": speed,
      };
}


// {
// "id":3,
// "name":"hdahsh",
// "coinsPos":[3,5,6,7,8,9,6,5],
// "enemies":[
//     {
//         "id":0,
//         "enemiesPos":[5,7,5,4,2,1,3,4,5,6],
//         "speed":1
//     },
//     {
//         "id":1,
//         "enemiesPos":[5,7,5,4,2,1,3,4,5,6],
//         "speed":2
//     },
//     {
//         "id":2,
//         "enemiesPos":[5,7,5,4,2],
//         "speed":3
//     },
//     {
//         "id":3,
//         "enemiesPos":[5,7,5,4,2,1,3,4,5,6],
//         "speed":1
//     }
//     ],
// "finishPos":4,
// "wallsPos":[4,6,5],
// "creationDate":"hjasdhashdas"
// }