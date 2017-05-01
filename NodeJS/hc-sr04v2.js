var five = require("johnny-five");
var board = new five.Board();

var express = require('express');
var app = express();
var server = app.listen(3000);

var distanciaEmCm = 0.00;
var distanciaEmIn = 0.00;
var texto = "";
var podePostar;
var sleep = require("sleep");

var firebase = require("firebase");

firebase.initializeApp({
  serviceAccount: "credentials-IOT.json",
  databaseURL: "https://fiapiot-73238.firebaseio.com/"
});

var db = firebase.database();
var date = new Date().toLocaleString().split(" ");
var dateAux = date[0].split("-");
var formatDate = dateAux[2] + "/" + dateAux[1] + "/" + dateAux[0];


board.on("ready", function() {
    var proximity = new five.Proximity({
        controller: "HCSR04",
        pin: 7
    });

    proximity.on("data", function() {
       date = new Date().toLocaleString().split(" ");
       dateAux = date[0].split("-");
       formatDate = dateAux[2] + "/" + dateAux[1] + "/" + dateAux[0];       

       console.log("Proximity: ");
        console.log("  cm  : ", this.cm);
        console.log("  in  : ", this.in);
        console.log("  podePostar  : ", podePostar);
        console.log("-----------------");
        distanciaEmCm = this.cm;
        distanciaEmIn = this.in;


//true
//3
//postou

       if (distanciaEmCm < 6 && podePostar){
            console.log(" ######################  Postando no FireBase #####################");
            db.ref("/").push( {
            //data: date[0],
            data: formatDate,
            hora: date[1]
       })
        podePostar = false;

    }else if(distanciaEmCm >= 15){
           //console.log("Não estou Postando");
           podePostar = true;
       }  
    });
    sleep.sleep(2);
    proximity.on("change", function() {
  //      console.log("The obstruction has moved.");
    });


    app.get('/limpar', function (req,res) {

         db.ref("/").set( {
            
       })
    });
});


