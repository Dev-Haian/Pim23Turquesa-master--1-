// routes/funcionarios.js
const express = require('express');
const router = express.Router();
const Funcionario = require('../models/funcionarios');

// Rota POST para criar um novo funcionário
router.post('/', async (req, res) => {
  const { nome, cargo, imagemUrl, franquiaId } = req.body;

  try {
    const novoFuncionario = new Funcionario({ nome, cargo, imagemUrl, franquiaId });
    await novoFuncionario.save();
    res.status(201).json(novoFuncionario);
  } catch (error) {
    res.status(400).json({ message: 'Erro ao criar funcionário' });
  }
});

// Rota GET para buscar todos os funcionários de uma franquia
router.get('/franquia/:franquiaId', async (req, res) => {
  try {
    const funcionarios = await Funcionario.find({ franquiaId: req.params.franquiaId });
    res.json(funcionarios);
  } catch (error) {
    res.status(500).json({ message: 'Erro ao buscar funcionários' });
  }
});

module.exports = router;
