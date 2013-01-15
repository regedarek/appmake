var app_dir = __dirname + '/../',
    tpl_dir = app_dir + 'tpl/',
    js_dir = app_dir + 'js/',

    fs = require('fs'),
    dot = require('../js/lib/doT.js'),

    templates = {};

walk();
fs.writeFile(js_dir + 'templates.js', buildModule(templates));


function walk(subdir) {
  var dir = tpl_dir,
      files;

  if (subdir)
    dir += subdir;

  files = fs.readdirSync(dir);
  files.forEach(function (filename) {
    var stats = fs.statSync(dir + filename);

    if (stats.isDirectory()) {
      if (subdir) filename = subdir + filename;
      filename += '/';

      walk(filename);
    }

    if (!isHTML(filename))
      return;

    readFile(filename, subdir, fs.readFileSync(dir + filename));
  });
}

function readFile (filename, dir, data) {
  var name = filename.split('.').slice(0, -1).join('.'),
      compiled = dot.template(data).toString().replace(/^function anonymous/, 'function ');

  if (dir)
    name = dir + name;

  templates[name] = compiled;
}

function isHTML(name) {
  if (!~name.indexOf('.'))
    return false;

  return name.split('.').slice(-1)[0].toLowerCase() === 'html';
}

function buildModule() {
  var content = [],
      n;

  for (n in templates)
    content.push('"' + n + '": ' + templates[n]);

  return ['module.exports = {', content.join(','), '};'].join('').replace(/(\n|\r|\r\n)/, '');
}