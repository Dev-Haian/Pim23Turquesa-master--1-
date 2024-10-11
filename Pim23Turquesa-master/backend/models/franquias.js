const mongoose = require('mongoose');

// Definir o esquema da franquia
const FranquiaSchema = new mongoose.Schema({
  nome: { type: String, required: true },
  endereco: { type: String, required: true },
  horario: { type: String, required: true },
  imagemUrl: { type: String, required: true },
});

// Criar o modelo
const Franquia = mongoose.model('franquias', FranquiaSchema);

module.exports = Franquia;
