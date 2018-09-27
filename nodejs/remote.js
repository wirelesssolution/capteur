'use strict';

const log = require('../log');
const deviceFinder = require('../device-finder');
const tokens = require('../../lib/tokens');

exports.command = 'remote';
exports.description = 'create devices item of openhab';
exports.builder = {
	'sync': {
		type: 'boolean',
		description: 'Synchronize tokens'
	}
};

var fs = require('fs');
var itemfilepath = "/etc/openhab2/items/capteur_ir.items";
var thingfilepath = "/etc/openhab2/things/capteur_ir.things";
var itemfileContent = "";
var thingfileContent = "";
 

exports.handler = function(argv) {
  	  log.info('Discovering devices. Press Ctrl+C to stop.');
	log.plain();

	const browser = deviceFinder({
		cacheTime: 30
	}
			);
	browser.on('available', device => {
		try {
		if(device.management.address) {
	       			log.info('devices id ', device.id.replace(/^miio:/, ''));
	       			itemfileContent +=  "String	IR";
	       			itemfileContent += device.id.replace(/^miio:/, '');
	       			itemfileContent +=  "	\"IR Remote ";
	       			itemfileContent += device.id.replace(/^miio:/, '');
			       	itemfileContent +=  "\"  {channel=\"miio:unsupported:";
	       			itemfileContent += device.id.replace(/^miio:/, '');
				itemfileContent +=  ":actions#commands\"}\n";
	       			thingfileContent +=  "Thing miio:unsupported:";
	       			thingfileContent += device.id.replace(/^miio:/, '');
				thingfileContent +=  " \"Miio ";
	       			thingfileContent += device.id.replace(/^miio:/, '');
				thingfileContent +=  "\" [ host=\"";
				thingfileContent += device.management.address; 
				thingfileContent +=  "\", token=\"";
				thingfileContent += device.management.token;
				thingfileContent +=  "\" ]\n";
				log.info('IP', device.management.address);
	       			log.info('Token', device.management.token);
					}
	fs.writeFile(itemfilepath, itemfileContent, (err) => {
	    if (err) throw err;
    		console.log("The file was succesfully saved!");
	});    
	fs.writeFile(thingfilepath, thingfileContent, (err) => {
	    if (err) throw err;
    		console.log("The file was succesfully saved!");
	});    
		} 
		catch(ex) {
			log.error(ex);
		}

		const mgmt = device.management;
		if(argv.sync && mgmt.token && mgmt.autoToken) {
			tokens.update(device.id, mgmt.token)
				.catch(err => {
					log.error('Could not update token for', device.id, ':', err);
				});
		}
	});

	const doneHandler = () => {
	if(pending === 0) {
	if(! foundDevice) {
		log.warn('Could not find device');
	}
	process.exit(0); // eslint-disable-line
	}
	};
	setTimeout(doneHandler, 5000);
	browser.on('done', doneHandler);

};
