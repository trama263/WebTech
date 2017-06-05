part of dartrunning;

class RunningView {

  RunningGame _model;
  final title = querySelector("#title");

  final welcome = querySelector("#welcome");

  final game = querySelector('#RunningGame');

  final gameover = querySelector('#gameover');

  final reasons = querySelector('#reasons');

  final points = querySelector('#points');

  final event = querySelector('#event');

  final lives = querySelector('#lives');
  final timer = querySelector('#timer');

  HtmlElement get playPauseButton => querySelector('#playPause');
  HtmlElement get howToPlay => querySelector('#howToPlay');
  HtmlElement get about => querySelector('#about');
  HtmlElement get pause => querySelector('#pause');
  HtmlElement get leftButton => querySelector('#leftButton');
  HtmlElement get rightButton=> querySelector('#rightButton');

  List<List<HtmlElement>> fields;

  //Konstruktor
  RunningView(this._model){

  }


  void update() {

    welcome.style.display = _model.paused ? "block" : "none";
    points.innerHtml = "Points: ${_model.points}";


    gameover.innerHtml = _model.gameOver ? "Game Over" : "";
    reasons.innerHtml = "";
    if (_model.gameOver) {
      final crashed = _model.gameOver ? "Crashed!!!!<br>" : "";
      reasons.innerHtml = "$crashed";
    }

    // Updates the field
    final field = _model.field;
    for (int row = 0; row < field.length; row++) {
      for (int col = 0; col < field[row].length; col++) {
        final td = fields[row][col];
        if (td != null) {
          td.classes.clear();
          if (field[row][col] == #obstacle) td.classes.add('obstacle');
          else if (field[row][col] == #runner) td.classes.add('runner');
          else if (field[row][col] == #empty) td.classes.add('empty');
        }
      }
    }
  }


  void generateField(RunningGame model) {
    final field = model.field;
    String table = "";
    for (int row = 0; row < field.length; row++) {
      table += "<tr>";
      for (int col = 0; col < field[row].length; col++) {
        final assignment = field[row][col];
        final pos = "field_${row}_${col}";
        table += "<td id='$pos' class='$assignment'></td>";
      }
      table += "</tr>";
    }
    game.innerHtml = table;

    fields = new List<List<HtmlElement>>(field.length);
    for (int row = 0; row < field.length; row++) {
      fields[row] = [];
      for (int col = 0; col < field[row].length; col++) {
        fields[row].add(game.querySelector("#field_${row}_${col}"));
      }
    }
  }





  /**
   * Sets a warning text in the highscore form.
   */
  void warn(String message) {
    document.querySelector('#highscorewarning').innerHtml = message;
  }
}