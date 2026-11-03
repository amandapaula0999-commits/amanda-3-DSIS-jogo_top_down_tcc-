#region Final da atualização

if (bunker_jogo_bloqueado()) exit;
var passo_voo = bunker_passo();
if (variable_instance_exists(id,"tempo_alarme0") && tempo_alarme0 >= 0) passo_voo=min(passo_voo,tempo_alarme0);
bunker_projetil_passo(id,passo_voo);
if (!instance_exists(id)) exit;
if (bunker_alarme_passo(id,passo_voo)) event_perform(ev_alarm,0);

#endregion
