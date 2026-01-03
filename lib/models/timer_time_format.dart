String formatTimeInHM(int timeElapsed, int timeGoal) {
  return '${timeElapsed ~/ 60 ~/ 60}h ${timeElapsed ~/ 60 % 60}m / ${timeGoal ~/ 60 ~/ 60}h ${timeGoal ~/ 60 % 60}m';
}

String formatTimeInMS(int timeElapsed, int timeGoal) {
  int time = timeGoal - timeElapsed;
  int minutes = time ~/ 60;
  int seconds = time % 60;
  return '${minutes < 10 ? '0$minutes' : minutes} : ${seconds < 10 ? '0$seconds' : seconds}';
}
