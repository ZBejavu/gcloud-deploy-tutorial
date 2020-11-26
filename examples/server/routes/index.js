const express = require('express')
const helmet = require('helmet');
const api = express.Router();
api.use(helmet());

api.use("/v1", require("./v1"));

module.exports = api;
