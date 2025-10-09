import { createServer } from 'http';

const PORT = process.env.PORT || 8000;
const SECRET = process.env.HELLO || 'No secret loaded';

const server = createServer((req, res) => {
  if (req.url === '/') {
    res.writeHead(200, { 'Content-Type': 'application/json' });
    res.end(JSON.stringify({ message: 'Hello from DevSecOps API!', secret: SECRET }));
  } else {
    res.writeHead(404);
    res.end('Not Found');
  }
});

server.listen(PORT, () => {
  console.log(`🚀 Server running at http://localhost:${PORT}`);
  console.log(`🔐 Loaded secret: ${SECRET}`);
});

