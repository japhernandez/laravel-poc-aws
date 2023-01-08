const express = require('express')
const app = express();

app.get('/api/health', (req, res) => {
  res.json("Welcome to AWS")
})

app.listen(3000, console.log("Running on port: " + 3000))
