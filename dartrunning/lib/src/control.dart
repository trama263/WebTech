part of dartrunning;

const obstaclesSpeed = const Duration(milliseconds: 750);

const acceleration = 0.05;

class RunningController {

  RunningGame game = new RunningGame(gameHeight, gameWidth);

  final view = new RunningView();

  Timer runnerTrigger;
  Timer obstaclesTrigger;


  RunningController() {

    view.generateField(game);

    // New game is started by user
    view.startButton.onClick.listen((_) {
      if (runnerTrigger != null) runnerTrigger.cancel();
      if (obstaclesTrigger != null) obstaclesTrigger.cancel();
      obstaclesTrigger = new Timer.periodic(obstaclesSpeed, (_) => _moveObstacles());
      game.start();
      view.update(game);
    });

    // Steering of the snake
    window.onKeyDown.listen((KeyboardEvent ev) {
      if (game.paused) return;
      switch (ev.keyCode) {
        case KeyCode.LEFT:  game.runner.moveLeft();_moveRunner(); break;
        case KeyCode.RIGHT: game.runner.moveRight();_moveRunner(); break;
       // case KeyCode.UP:    game.runner.headUp(); break;
        //case KeyCode.DOWN:  game.runner.headDown(); break;
      }
    });
  }


  /**
   * Handles Game Over.
   */
  dynamic _gameOver() async {
    runnerTrigger.cancel();
    obstaclesTrigger.cancel();

    game.stop();
    view.update(game);

    // Handle cancel button
    document.querySelector('#close')?.onClick?.listen((_) => _newGame());
  }

  /**
   * Initiates a new game.
   */
  dynamic _newGame() async {
    view.closeForm();
    game = new RunningGame(gameHeight, gameWidth);
  }


  void _moveObstacles() {
    if (game.gameOver) { _gameOver(); return; }
    game.moveObstacles();
    view.update(game);
  }


  void _moveRunner() {
    if (game.gameOver) { _gameOver(); return; }

    //final obstacles = game.obstaclesCounter;
    game.moveRunner();
    //if (game.obstaclesCounter > obstacles) { _increaseRunnerSpeed(); }
    if (game.gameOver) return;
    view.update(game);
  }


  void _increaseGameSpeed() {
    runnerTrigger.cancel();
    //final newSpeed = runnerSpeed * pow(1.0 - acceleration, game.obstaclesCounter);
    //runnerTrigger = new Timer.periodic(newSpeed, (_) => _moveRunner());
  }


}
