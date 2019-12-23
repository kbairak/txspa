import React, { useState, useEffect } from 'react';

function App() {
  let [username, setUsername] = useState(null);
  let [error, setError] = useState(false);
  async function fetchUsername() {
    try {
      const response = await fetch('/_/jwt/');
      const body = await response.json();
      setUsername(body.username);
    } catch (e) {
      setError(true);
    }
  }
  useEffect(() => { fetchUsername(); }, []);
  if (! error) {
    return (<h1>
      Hello { username || 'from React' }
    </h1>);
  } else {
    return (<h1 style={{color: 'red'}}>
      Error!!!
    </h1>);
  }
}

export default App;
