#region Atualização

// A poça dura tempo suficiente para atrair o chefe e some antes do respawn
if (global.interface.pause_aberto || global.interface.config_aberta || global.cena.ativa
|| global.interface.dialogo_ativo || global.interface.diario_aberto || global.cena.vitoria_ativa) exit;
var passo = bunker_passo();
duracao -= passo;
pulso += 0.08 * passo;
if (duracao < 90) alpha_acido = 0.78 * max(0, duracao / 90);
image_alpha = alpha_acido;
if (duracao <= 0) instance_destroy();

#endregion
