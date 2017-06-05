import 'package:runningdart/runningdart.dart';

void main() {
  RunningGame model = new RunningGame(gameHeight, gameWidth);
  RunningView view = new RunningView(model);
  RunningController controller = new RunningController(model, view);
}