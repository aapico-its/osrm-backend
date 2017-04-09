#!/usr/bin/env node

var exec = require('child_process').exec;
var fs = require('fs');

var name = process.argv[2];
var cmd = process.argv.slice(3).join(' ');
var start = +new Date();
exec(cmd, (err) => {
    if (err) return console.log(err);
    var stop = +new Date();
    var time = (stop - start) / 1000.;
    fs.appendFileSync('/tmp/osrm.timings', `${name}\t${time}`, 'utf-8');
});

