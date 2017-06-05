part of dartrunning;

class RunningView {


  final title = querySelector("#title");

  final welcome = querySelector("#welcome");

  final game = querySelector('#RunningGame');

  final gameover = querySelector('#gameover');

  final reasons = querySelector('#reasons');

  HtmlElement get startButton => querySelector('#start');
  HtmlElement get howToPlay => querySelector('#howToPlay');
  HtmlElement get about => querySelector('#about');
  HtmlElement get pause => querySelector('#pause');

  List<List<HtmlElement>> fields;

  void update(RunningGame model, { List<Map> scores: const [] }) {

    welcome.style.display = model.paused ? "block" : "none";
    gameover.innerHtml = model.gameOver ? "Game Over" : "";
    reasons.innerHtml = "";
    if (model.gameOver) {
      final crashed = model.gameOver ? "Crashed!!!!<br>" : "";
      reasons.innerHtml = "$crashed";
    }

    // Updates the field
    final field = model.field;
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