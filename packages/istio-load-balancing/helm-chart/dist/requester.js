const http = require('http')

setInterval(() => {
  http.get({
  hostname: 'listener',
  port: 3000,
  path: '/',
  agent: false // Create a new agent for each request
}, (res) => {
  console.log(res.statusCode);
});
}, 100);