import express from 'express';
import cors from 'cors';
import { pool } from './config/db.js';

const app = express();
app.use(cors());
app.use(express.json());

app.get('/api/health', async (req, res) => {
  try {
    const [rows] = await pool.query('SELECT VERSION() AS version');
    res.json({ status: 'ok', database: rows[0].version });
  } catch (err) {
    console.error(err);
    res.status(500).json({ status: 'erreur', message: err.message });
  }
});

const port = process.env.PORT || 3000;
app.listen(port, () => {
  console.log(`Serveur MediSupport sur http://localhost:${port}`);
});