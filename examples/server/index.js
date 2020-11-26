const app = require('./app');
require('dotenv').config();
const port = process.env.SERVER_PORT || 8080

app.listen(port, () => {
  console.log(`Example app listening at http://localhost:${port}`)
})