var fs = require('fs');
var path = require('path');
var http = require('http');
var express = require('express');
var reload = require('reload')
var bodyParser = require('body-parser')


var app = express();

app.use('/reveal.js', express.static(path.resolve(__dirname + '/reveal.js')));
app.use('/Font-Awesome', express.static(path.resolve(__dirname + '/Font-Awesome')));
app.use('/slides', express.static(path.resolve(__dirname + '/slides')));
app.use('/reload', express.static(path.resolve(__dirname + '/node_modules/reload')));
app.use('/www', express.static(path.resolve(__dirname + '/www')));

// app.get('/', function (req, res) {
//   res.send('Hello World!');
// });

var publicDir = path.join(__dirname, '')


app.set('port', process.env.PORT || 3000)
app.use(bodyParser.json()) //parses json, multi-part (file), url-encoded

app.get('/', function(req, res) {
  res.sendFile(path.join(publicDir, 'index.html'))
})

var server = http.createServer(app)

//reload code here
//optional reload delay and wait argument can be given to reload, refer to [API](https://github.com/jprichardson/reload#api) below
// reload(server, app, [reloadDelay], [wait])
reload(server, app, 800, true)

server.listen(app.get('port'), function(){
  console.log("Web server listening on port " + app.get('port'));
});


// app.use('/', express.static(path.resolve(__dirname)));
//
//
// var server = app.listen(3000, function () {
//   var host = server.address().address;
//   var port = server.address().port;
//   console.log('Example app listening at http://localhost:%s', port);
//   console.log('Reveal.js demo at: http://localhost:%s/reveal_demo.html', port);
// });
