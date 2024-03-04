// set server port. SERVER_PORT varibale will come from Dockerfile
var port = process.env.CUSTOM_SERVER_PORT;
if (!port) {
  port = 3000;
}

// set internal communication url
global.internalURL = "http://localhost:" + port;

var path = require('path');
var express = require('express');
var app = express();
var bodyParser = require("body-parser");
var fs = require("fs");
app.use(bodyParser.json());
app.disable('x-powered-by');
app.use(bodyParser.urlencoded({
  extended: true
}));
//
//var RateLimit = require('express-rate-limit');
//var limiter = RateLimit({
//  windowMs: 1*60*1000, // 1 minute
//  max: 5
//});
//
//// apply rate limiter to all requests
//app.use(limiter);
var context_path = "";
// if (context_path) {
// var index_file_path = path.join(__dirname, 'dist/index.html');
// let content = fs.readFileSync(index_file_path, "utf8");
// // content = content.replace('<base href="/">', '<base href="/' + context_path + '/">');
// fs.writeFileSync(index_file_path, content);
// }
 app.use(function (req, res, next) {

   // Website you wish to allow to connect
//   res.setHeader('Access-Control-Allow-Origin', req.protocol + '://' + req.get('host'));
   res.setHeader('Access-Control-Allow-Origin', "*");

   // Request methods you wish to allow
//   res.setHeader('Access-Control-Allow-Methods', 'GET, POST, PUT, OPTIONS, PATCH, DELETE');
   res.setHeader('Access-Control-Allow-Methods', 'GET, POST, DELETE');

   // Request headers you wish to allow
   res.setHeader('Access-Control-Allow-Headers', 'content-type,access_token');
//   res.setHeader('Clear-Site-Data', '*');
   res.setHeader('Cache-Control', 'no-cache, no-store, must-revalidate');
   res.setHeader('Pragma', 'no-cache');
   res.setHeader('Expires', '0');

   // Set to true if you need the website to include cookies in the requests sent
   // to the API (e.g. in case you use sessions)
//   res.setHeader('Access-Control-Allow-Credentials', true);

   // Request headers indicate that the MIME types advertised in the Content-Type headers should not be changed and be followed
//   res.setHeader('X-Content-Type-Options', 'nosniff');

   // Request headers for X-frame options
//   res.setHeader('X-Frame-Options', 'deny');

   // HTTP header governs which referrer information, sent in the Referer header, should be included with requests made.
//   res.setHeader('Referrer-Policy', 'no-referrer-when-downgrade');

   // Http header for allowing feature of browser
//   res.setHeader('Feature-Policy', "geolocation 'self';");

   // tops pages from loading when they detect reflected cross-site scripting (XSS) attacks
   // res.setHeader('X-XSS-Protection', '1; mode=block');

   // content security policy not allowing unsafe inline
   // res.setHeader('Content-Security-Policy', "default-src 'self'; style-src 'self' https://maxcdn.bootstrapcdn.com 'unsafe-inline'; img-src 'self' data: https://cdn.cidaas.de https://res.cloudinary.com; font-src 'self' https://fonts.gstatic.com https://maxcdn.bootstrapcdn.com; script-src 'unsafe-inline' 'self' https://cdnjs.cloudflare.com https://maxcdn.bootstrapcdn.com https://code.jquery.com; frame-src https://www.rehau.com https://gateway-rehau-webbucket.s3-eu-west-1.amazonaws.com;");
   if (req.path.endsWith('.js')) {
    if (req.headers.referer && req.headers.referer.includes("zeeconnect.in")) {
        res.setHeader('Cache-Control', 'no-store');
        next();
    } else {
        res.status(403).send('Unauthorized');
    }
} else if (req.path.endsWith('.json')) {
  if (req.headers.referer && req.headers.referer.includes("zeeconnect.in")) {
      res.setHeader('Cache-Control', 'no-store');
      next();
  } else {
      res.status(403).send('Unauthorized');
  }
}
else{
  next();
}
 });

app.get("/ping", function (req, res) {
  res.json({
    data: "pong! Atul"
  });
});

var router = express.Router(express);
app.use("/" + context_path, router);

const dist_dir = "public-flutter";
router.use(express.static(path.join(__dirname, dist_dir), {
  maxAge: "0"
}));

// Catch all other routes and return the index file
router.get('*', (req, res) => {

  res.sendFile(path.join(__dirname, dist_dir + '/index.html'));
});

var server = app.listen(port, function () {
  console.log("server on " + port);
});
