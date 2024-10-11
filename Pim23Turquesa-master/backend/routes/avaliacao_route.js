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
