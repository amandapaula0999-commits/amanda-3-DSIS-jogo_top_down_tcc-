#region Inicialização

// Verifica o golpe uma vez no End Step e remove a hitbox.
dano = 4;
visible = false;
speed = 0;
velocidade = 0;
rotacao_velocidade = 0;
em_voo = true;
impacto_registrado = false;
inicial_pendente = false;
inicial_x = x;
inicial_y = y;
raio_colisao = 9;
// O End Step executa uma única varredura e destrói esta hitbox.

#endregion
