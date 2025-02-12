import React, { useState, useEffect } from 'react'
import axios from 'axios'

const App = () => {
  const [data, setdata] = useState([])
 
  useEffect(() => {
    const fetchData = async () => {
      const response = await axios.get('http://localhost:3000/data')
      const data = await response.data
      setdata(data)
    }


    fetchData()
  }, [])
  console.log(data)
  return (
    <div>
      <h1>Hello World!</h1>
      <ul>
        {data.map((item, index) => (
          <li key={index}>{item.name}</li>
        ))}
      </ul>
    </div>
  )
}

export default App