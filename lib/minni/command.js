// Generated by CoffeeScript 1.3.1
(function() {
  var printLine;

  printLine = function(line) {
    return process.stdout.write(line + '\n');
  };

  exports.run = function() {
    return require('./repl');
  };

}).call(this);