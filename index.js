const express = require('express');
const bodyParser = require('body-parser');
const { Pool } = require('pg');

const app = express();
const port = process.env.PORT || 5444;

app.use(bodyParser.json());

const pool = new Pool({
  connectionString: "postgres://prljzunu:hAz59andTcEoGHnn4mmkrUKJTln8JpTP@berry.db.elephantsql.com/prljzunu",
});

pool.connect()
  .then(() => {
    console.log('Conectado ao banco de dados PostgreSQL');
  })
  .catch((error) => {
    console.error('Erro ao conectar ao banco de dados:', error);
  });

// Rota para cadastrar um novo usuário
app.post('/cadastro', async (req, res) => {
  try {
    const { email, senha, tipo } = req.body;

    const emailExiste = await pool.query('SELECT * FROM Usuario WHERE email = $1', [email]);

    if (emailExiste.rows.length > 0) {
      return res.status(400).json({ error: 'E-mail já cadastrado.' });
    }

    const result = await pool.query(
      'INSERT INTO Usuario (email, senha, tipo) VALUES ($1, $2, $3) RETURNING *',
      [email, senha, tipo]
    );

    res.status(201).json(result.rows[0]);
  } catch (error) {
    console.error('Erro ao cadastrar usuário', error);
    res.status(500).json({ error: 'Erro interno do servidor' });
  }
});

// Rota para fazer login
app.post('/login', async (req, res) => {
  try {
    const { email, senha } = req.body;

    const result = await pool.query('SELECT * FROM Usuario WHERE email = $1 AND senha = $2', [email, senha]);

    if (result.rows.length > 0) {
      res.status(200).json({ message: 'Login bem-sucedido' });
    } else {
      res.status(401).json({ error: 'Credenciais inválidas' });
    }
  } catch (error) {
    console.error('Erro ao fazer login', error);
    res.status(500).json({ error: 'Erro interno do servidor' });
  }
});

app.listen(port, () => {
  console.log(`Servidor rodando em http://localhost:${port}`);
});
