
/**
 * Module dependencies.
 */

var express = require('express')
  , http = require('http')
  , mysql = require("mysql")
  , path = require('path');

var app = express();

// all environments
app.set('port', process.env.PORT || 3000);
app.use(express.logger('dev'));
app.use(express.bodyParser());
app.use(express.methodOverride());
app.use(app.router);
app.use(express.static(path.join(__dirname, 'public')));

// development only
if ('development' == app.get('env')) {
  app.use(express.errorHandler());
}
var con = mysql.createConnection({
	  host: "10.122.97.223",
	  user: "webuser",
	  password: "webuser123",
	  database: "COREDB"
	});
app.get('/', function(request, response){
	
	var document = { docName: "fileName", docType: "PDF" };
	con.query('INSERT INTO docBank SET ?', document, function(err,res){
	  if(err) throw err;
	  else{
		  var doc_Id = res.insertId
		  console.log('Last insert ID:', doc_Id);
	  }
	  
	});
	response.writeHead(200, {
		"Content-Type" : "text/html"
	});
	response.write("Record Inserted");
	response.end();
	
});

http.createServer(app).listen(app.get('port'), function(){
  console.log('Express server listening on port ' + app.get('port'));
});
