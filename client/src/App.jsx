import React, { useState, useEffect } from 'react'
import axios from 'axios'

const App = () => {
  const [data, setdata] = useState([])
  const [number, setNumber] = useState(0);


  useEffect(() => {
    const fetchData = async () => {
      const response = await axios.get('http://localhost:3000/data')
      const data = await response.data
      setdata(data)
    }


    fetchData()
  }, [])
  console.log(data)

	const handleClick = () => {
		setNumber(number + 1)
	}
  return (
  <>
    <div>
      <h1>Hello World!</h1>
      <ul>
        {data.map((item, index) => (
          <li key={index}>{item.name}</li>
        ))}
      </ul>
    </div>
	<div> 
	  <p> The counter is : {number}</p>
	  </div>
	  <button onClick={handleClick}>
	Click me to increase the counter :)
	  </button>
		<main>
      this is a main taged para
		</main>
</>
  )
}

export default App
