'use strict';

const path = require('path');
var macaddress = require('macaddress');

exports.command = 'tokens <command>';
exports.description = 'Manage tokens of devices';
exports.builder = yargs => yargs.commandDir(path.join(__dirname, 'tokens'));
exports.handler = () => {};
var fs = require('fs');
var lineitemfilepath = "/etc/openhab2/items/linealert.items";
var caritemfilepath = "/etc/openhab2/items/mycar.items";
var itemfileContent = "";
var carfileContent = "";

macaddress.one('eth0', function (err, mac) {
	  console.log("Mac address for eth0: %s", mac);  
	  var itemfileContent = "";
	 itemfileContent +=  "String ulinealert \"User Line Alert\" <light>";
	 itemfileContent +=  "\n{mqtt=\">[track:/ci/smarthome/linealert/u/";
	 itemfileContent += mac.replace(/:/g,'').toUpperCase();
	 itemfileContent +=  "/alert:command:*:default]\"}";
	 itemfileContent +=  "\nString glinealert \"Group Line Alert\" <light>";
	 itemfileContent +=  "\n{mqtt=\">[track:/ci/smarthome/linealert/g/";
	 itemfileContent += mac.replace(/:/g,'').toUpperCase();
	 itemfileContent +=  "/alert:command:*:default]\"}";
	  console.log("Create File line alert at /etc/openhab2/items/linealert.items ===  %s", itemfileContent);  
	 carfileContent +=  "String	MyCarRAW	{ mqtt=\"<[track:/ci/smarthome/track/";
	 carfileContent += mac.replace(/:/g,'').toUpperCase();
	 carfileContent +=  "/location:state:default]\"}";
	  console.log("Create File MyCar  at /etc/openhab2/items/mycar.items ===  %s", carfileContent);  
	fs.writeFile(lineitemfilepath, itemfileContent, (err) => {
			    if (err) throw err;
			        		console.log("The file was succesfully saved!");
							});    
		fs.writeFile(caritemfilepath, carfileContent, (err) => {
				    if (err) throw err;
				        		console.log("The file was succesfully saved!");
								});

});
