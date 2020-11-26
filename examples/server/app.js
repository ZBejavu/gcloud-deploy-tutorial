const express = require('express')
const app = express()
const path = require('path')
const morgan = require('morgan');

app.use(express.static("../client/build"));
app.use(express.json())
app.use(morgan("tiny"));

app.use('/api', require('./routes'))

app.get("*", (req, res) => {
    res.sendFile(path.resolve(__dirname, "../client/build", "index.html"));
});

module.exports = app;

// DO NOT USE HELMET IN APP.JS, only in the sub routes 