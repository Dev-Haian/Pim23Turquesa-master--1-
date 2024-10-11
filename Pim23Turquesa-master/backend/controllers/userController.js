// controllers/userController.js
const User = require('../models/user'); // Importa o modelo de usuário
const bcrypt = require('bcrypt');
const jwt = require('jsonwebtoken');

// Registro de usuário
exports.register = async (req, res) => {
  const { name, email, password, cpf, birthDate, phone } = req.body;

  try {
    const user = new User({ name, email, password, cpf, birthDate, phone });
    await user.save();
    res.status(201).json({ message: 'Usuário criado com sucesso!' });
  } catch (error) {
    res.status(400).json({ error: error.message });
  }
};

// Login de usuário
exports.login = async (req, res) => {
  const { email, password } = req.body;

  try {
    const user = await User.findOne({ email });
    if (!user) {
      return res.status(404).json({ message: 'Usuário não encontrado!' });
    }

    const isMatch = await bcrypt.compare(password, user.password);
    if (!isMatch) {
      return res.status(400).json({ message: 'Senha incorreta!' });
    }

    // Criação do token JWT
    const token = jwt.sign({ id: user._id }, '1a0b7d8001295cd720f4bb37db02e0328673e3597ef3abd2a9aca33b45ecbc76', { expiresIn: '1h' });
    res.json({ token });
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
};
