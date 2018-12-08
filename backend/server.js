const express = require('express')
const app = express()
const port = 3002
const bodyParser = require('body-parser')

app.get('/', (req, res) => res.send('Hello World!'))
// app.use(bodyParser.urlencoded())
// app.use(bodyParser.json());

app.post('/callback', (req, res) => {
  console.log('callback')
  // console.log(req.body, req.params);
  res.sendStatus(200)
  // res.send('Hello World!')
})

app.listen(port, () => console.log(`Example app listening on port ${port}!`))