const express = require('express')
const app = express()
const cors = require('cors');
const port = 3000


const corsOptions = {
    origin: '*', // Allow from all origins
    methods: 'GET,HEAD,PUT,PATCH,POST,DELETE', // Allow all HTTP methods
    credentials: true, // Allow sending cookies
    allowedHeaders: 'Content-Type, Authorization' // Allow specific headers
   };

app.use(cors(corsOptions));

app.get('/', (req, res) => {
  res.send('Hello World!')
})

app.get('/data', cors(), (_req, res) => {
    const data = [{name: 'Alice'}, {name: 'Bob'}, {name: 'Charlie'}, {name: 'David'}, {name: 'Eve'}, {name: 'Frank'}, {name: 'Grace'}, {name: 'Hannah'}, {name: 'Ivan'}, {name: 'Judy'}, {name: 'Kevin'}, {name: 'Linda'}, {name: 'Mallory'}, {name: 'Nancy'}, {name: 'Oscar'}, {name: 'Peggy'}, {name: 'Quentin'}, {name: 'Romeo'}, {name: 'Sue'}, {name: 'Trent'}, {name: 'Ursula'}, {name: 'Victor'}, {name: 'Walter'}, {name: 'Xander'}, {name: 'Yvonne'}, {name: 'Zelda'}]
    res.json(data)
  })

app.listen(port, () => {
  console.log(`Example app listening on port ${port}`)
})

