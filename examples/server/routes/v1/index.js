const { Request, Response, Router } = require("express");

const router = Router();

const unknownEndpoint = (req, res) => {
  res.status(404).send({ error: "unknown endpoint" });
};
router.use("/endpoint", require("./endpoint"));
router.use(unknownEndpoint);
module.exports = router;
