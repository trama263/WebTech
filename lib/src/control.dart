part of dartrunning;

//A [obstaclesSpeed] of 1000ms means 1 movement per second.
const gameSpeed = const Duration(milliseconds: 750);

const acceleration = 0.25;

class RunningController {

  RunningGame _game;
  final _view;

  Timer runnerTrigger;
  Timer obstaclesTrigger;
  Stopwatch _stopwatch = new Stopwatch();

  void start() {
    if (runnerTrigger != null) runnerTrigger.cancel();
    if (obstaclesTrigger != null) obstaclesTrigger.cancel();
    obstaclesTrigger = new Timer.periodic(gameSpeed, (_) => _moveObstacles());
    _game.start();
    if (!this._stopwatch.isRunning) this._stopwatch.start();
    _view.update();
  }

  void pause(){
    if (_game.gameOver) { gameOver(); return; }
    this._stopwatch.stop();
    _game.pause();
    _view.update();
  }

  void gameOver() {
    this._stopwatch.stop();
    runnerTrigger.cancel();
    obstaclesTrigger.cancel();

    _game.stop();
    _view.update();

    // Handle cancel button
    document.querySelector('#close')?.onClick?.listen((_) => _newGame());
  }

  RunningController(this._game,this._view) {
    _view.generateField(_game);

    // New game is started by user
   _view.playPauseButton.onClick.listen((_) {
      if(_game.paused){
        start();
      }else if (_game.running){
        pause();
      }else if (_game.gameOver){
        gameOver();
      }else{
        return;
      }
    });

    _view.leftButton.onClick.listen((_) {
      if (_game.paused) return;
      _game.runner.moveLeft();
      _moveRunner();
    });

    _view.rightButton.onClick.listen((_) {
      if (_game.paused) return;
      _game.runner.moveRight();
      _moveRunner();
    });





    // Timer
    Timer timer = new Timer.periodic(new Duration(milliseconds: 100), (t) {
      final millis = this._stopwatch.elapsedMilliseconds;
      final secs = (millis / 1000).floor();
      final rest = millis - secs * 1000;
      if (this._stopwatch.isRunning) querySelector('#timer').text = "${secs}.${rest} Sekunden";
    });
  }




  /**
   * Initiates a new game.
   */
  dynamic _newGame() async {
    _view.closeForm();
    _game = new RunningGame(gameHeight, gameWidth);
  }


  void _moveObstacles() {
    if (_game.gameOver) { gameOver(); return; }
    _game.moveObstacles();
    _view.update();
  }


  void _moveRunner() {
    if (_game.gameOver) { gameOver(); return; }

    //final obstacles = game.obstaclesCounter;
    _game.moveRunner();
    //if (game.obstaclesCounter > obstacles) { _increaseRunnerSpeed(); }
    if (_game.gameOver) return;
    _view.update();
  }


  void _increaseGameSpeed() {
    obstaclesTrigger.cancel();
    final newSpeed = gameSpeed * acceleration;
    obstaclesTrigger = new Timer.periodic(newSpeed, (_) => _moveObstacles());

  }
}
