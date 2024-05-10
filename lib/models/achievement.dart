enum AchievementType {
  betsWon,
  leaguesJoined,
}

class Achievement {
  final String id;
  final String name;
  final num currentAmount;
  final num amountNeeded;
  final bool isCompleted;
  final num? rewardPoints;
  final String? rewardCosmetic;
  final AchievementType achievementType;

  Achievement({
    required this.id,
    required this.name,
    required this.currentAmount,
    required this.isCompleted,
    required this.amountNeeded,
    this.rewardPoints,
    this.rewardCosmetic,
    required this.achievementType,
  });
}
