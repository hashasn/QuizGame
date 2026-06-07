/// In-memory score tracker for the single-player quiz — registered as a singleton in GetIt and shared across blocs.
class Score {
  int score = 0;
  void addScore(int inSCore) {
    score = score + inSCore;
  }

  int getScore() {
    return score;
  }

  void clearScore() {
    score = 0;
  }
}
