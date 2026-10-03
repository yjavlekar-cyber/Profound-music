const express = require('express');
const { Pool } = require('pg');
const cors = require('cors');
const app = express();
const port = 3000;

app.use(cors());
app.use(express.json());

const pool = new Pool({
  user: process.env.DB_USER || 'profound_user',
  host: process.env.DB_HOST || 'db',
  database: process.env.DB_NAME || 'profound_db',
  password: process.env.DB_PASSWORD || 'REMOVED_SECRET',
  port: 5432,
});

// ── Health Check ──
app.get('/api/health', async (req, res) => {
  try {
    await pool.query('SELECT 1');
    res.status(200).json({ status: 'healthy', uptime: process.uptime(), database: 'connected' });
  } catch (err) {
    res.status(503).json({ status: 'unhealthy', database: 'disconnected' });
  }
});

app.get('/api/artist', async (req, res) => {
  try {
    const result = await pool.query('SELECT name, genre, bio FROM artist_info LIMIT 1');
    res.json(result.rows[0]);
  } catch (err) {
    res.status(500).json({ error: "Database connection failed" });
  }
});

app.post('/api/subscribe', async (req, res) => {
    const { email } = req.body;
    if (!email) return res.status(400).json({ error: "Email is required" });
    
    try {
        await pool.query('INSERT INTO subscribers (email) VALUES ($1)', [email]);
        res.status(201).json({ message: "Welcome to the Inner Circle!" });
    } catch (err) {
        if (err.code === '23505') { // Unique violation
            res.status(400).json({ error: "You are already in the circle!" });
        } else {
            res.status(500).json({ error: "Subscription failed" });
        }
    }
});

app.listen(port, () => {
  console.log(`Backend listening at http://localhost:${port}`);
});
