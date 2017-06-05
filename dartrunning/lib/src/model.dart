part of dartrunning;

class Runner {

  RunningGame _game;

  /**
   * Horizontal vertical column movement of this runner. Can be -1, 0, 1.
   */
  int _dc;

  /**
   * Runner consists only of one body element
   */
  var _body = {};

  Runner.on(this._game){
    final height = _game.height;
    final width = _game.width;
    _body =
    { 'row' : height - 2,     'col' : width ~/2 }
    ;
  }

  void move(){
    final newcol = _body['col'] + _dc;
    _body['col'] = newcol;
  }


  void moveLeft(){
    //check if runner would run outside the field
    if(_body['col'] - 1 < 0){
      _dc = 0;
    }else {
      _dc = -1;
    }
  }

  void moveRight(){
    if(_body['col'] + 1 > _game.width - 1){
      _dc = 0;
    }else {
      _dc = 1;
    }
  }

  Map<String, int> get body => _body;


  void printRunner(){
    print("*");
  }
}

class Obstacle {

  int _row, _column;

  /**
   * vertical movement of the obstacle; it always moves down
   */
  int _dr;

  final RunningGame _game;


  Obstacle.on(this._game, this._row, this._column){
    _dr = 1;
  }


  int get row => _row;
  int get col => _column;

  Map<String, int> get pos => {'row' : _row, 'col' : _column};

  void moveDown(){
    if(_row + _dr == _game.height-1) {
      _row = 0;
    }else{
      _row += _dr;
    }
  }


  void printObstacle(){

  }
}

class RunningGame {

  int _width, _height = null;

  int _level = null;


  var _field = [];

  bool levelStart;
  bool levelCompleted;
  int _speed;

  Runner _runner;

  /**
   * List of obstacles
   */
  var _obstacles = [];

  Symbol _gamestate;

  /**
   * Indicates whether game is stopped.
   */
  bool get gameOver => _gamestate == #gameOver;

  /**
   * Indicates whether game is running.
   */
  bool get running => _gamestate == #running;

  bool get paused => _gamestate == #paused;

  /**
   * Starts the game.
   */
  void start() { _gamestate = #running; }

  /**
   * Stops the game.
   */

  void pause() {_gamestate = #paused;}

  void stop() {_gamestate = #gameOver;}



  int get width => this._width;

  int get height => this._height;
  Runner get runner => _runner;


  List<Obstacle> get obstacles => _obstacles;
  RunningGame(this._height, this._width){
    start();

    this._runner = new Runner.on(this);


    _obstacles = [
      //  1. line
      new Obstacle.on(this, 0, 0),
      //  2. line
      new Obstacle.on(this, 1, 0), new Obstacle.on(this, 1, 1), new Obstacle.on(this, 1, 2), new Obstacle.on(this, 1, 3),
      //  3. line
      new Obstacle.on(this, 2, 0), new Obstacle.on(this, 2, 1),
      //  4. line

      //  5. line

      //  6. line
      new Obstacle.on(this, 5, 16), new Obstacle.on(this, 5, 17), new Obstacle.on(this, 5, 18), new Obstacle.on(this, 5, 19),
      //  7. line

      //  8. line

      //  9. line

      // 10. line

      // 11. line
      new Obstacle.on(this, 10, 0), new Obstacle.on(this, 10, 1), new Obstacle.on(this, 10, 2), new Obstacle.on(this, 10, 3),
      // 12. line

      // 13. line

      // 14. line

      // 15. line
      new Obstacle.on(this, 14, 16), new Obstacle.on(this, 14, 17), new Obstacle.on(this, 14, 18), new Obstacle.on(this, 14, 19),
      // 16. line

      // 17. line

      // 18. line

      // 19. line
      new Obstacle.on(this, 18, 0), new Obstacle.on(this, 18, 19),
      // 20. line
      new Obstacle.on(this, 19, 0), new Obstacle.on(this, 19, 19)
    ];
    pause();

  }

  List<List<Symbol>> get field {
    var _field = new Iterable.generate(_height, (row) {
      return new Iterable.generate(_width, (col) => #empty).toList();
    }).toList();
    _obstacles.forEach((m) {
      if (m.row < height && m.col < width)
        _field[m.row][m.col] = #obstacle;
      else
        print (m);
    });

    final r = _runner.body['row'];
    final c = _runner.body['col'];
    _field[r][c] = #runner;

    return _field;
  }

  void moveRunner(){
    if (running) this._runner.move();
  }

  /**
   * Feld nach unten bewegen
   */
  void moveObstacles() {
    if (running) _obstacles.forEach((o) => o.moveDown());

    final runnerRow = _runner.body['row'];
    final runnerCol = _runner.body['col'];

    final obstacle = this._obstacles.where((m) => m.row == runnerRow &&m.col == runnerCol);

    if(!obstacle.isEmpty){
      stop();
    }
  }

  /**
   * PowerUps oder einsammeln
   */
  void pickUp(){

  }

  /**
   * PowerUp im Spiel hinzufügen
   */
  void addPowerUp(){

  }

  void movePowerUp(){

  }

  int get level => _level;

  String toString() => field.map((row) => row.join(" ")).join("\n");
}