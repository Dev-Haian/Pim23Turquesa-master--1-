// models/funcionarios.js
const mongoose = require('mongoose');

// Definir o esquema do funcionário
const FuncionarioSchema = new mongoose.Schema({
  nome: { type: String, required: true },
  cargo: { type: String, required: true },
  imagemUrl: { type: String, required: true },
  franquiaId: { type: mongoose.Schema.Types.ObjectId, ref: 'franquias', required: true }, // Relaciona com a franquia
});

// Criar o modelo
const Funcionario = mongoose.model('funcionarios', FuncionarioSchema);

module.exports = Funcionario;
