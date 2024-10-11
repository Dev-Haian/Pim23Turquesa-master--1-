// server.js

const express = require('express');
const app = express();
const port = 3000;
const mongoose = require('mongoose');
const dotenv = require('dotenv');
const franquiasRoute = require('./routes/franquias_route');
const userRoutes = require('./routes/user_route');
const services_route = require('./routes/services_route');
const funcionariosRoutes = require('./routes/funcionarios_route');
const Avaliacao = require('./models/avaliacao'); // Certifique-se de que o caminho esteja correto

dotenv.config();

// Substitua pela URL de conexão do seu MongoDB Atlas
mongoose.connect('mongodb+srv://stellaaraujo:PimTurquesa@clusterpim.0v20e.mongodb.net/?retryWrites=true&w=majority&appName=ClusterPIM', {
}).then(() => {
  console.log('Conectado ao MongoDB Atlas');
}).catch((error) => {
  console.error('Erro ao conectar ao MongoDB:', error);
});

// Middleware para lidar com JSON
app.use(express.json());

// Usa as rotas existentes
app.use('/franquias', franquiasRoute);
app.use('/user', userRoutes);
app.use('/services', services_route);
app.use('/funcionarios', funcionariosRoutes);

// Rota para receber avaliações
app.post('/avaliacao', async (req, res) => {
  const { userId, notaServico, notaProfissional, notaUnidade } = req.body;

  try {
    const novaAvaliacao = new Avaliacao({
      userId,
      notaServico,
      notaProfissional,
      notaUnidade,
    });

    await novaAvaliacao.save();
    res.status(201).json({ message: 'Avaliação enviada com sucesso' });
  } catch (error) {
    console.error('Erro ao salvar avaliação:', error);
    res.status(500).json({ message: 'Erro ao salvar avaliação', error });
  }
});

// Servidor escutando na porta 3000
app.listen(port, () => {
  console.log(`Servidor rodando na porta ${port}`);
});
