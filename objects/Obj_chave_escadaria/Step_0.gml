#region Atualização

if(global.interface.pause_aberto || global.interface.diario_aberto || global.cena.ativa || global.interface.dialogo_ativo) exit;
var jogador=instance_nearest(x,y,Obj_jogador);
if(jogador!=noone && point_distance(x,y,jogador.x,jogador.y)<=42 && bunker_interagir()) {
    global.inventario.chave_escadaria=true;
    bunker_audio_tocar_efeito(Snd_item,10,false);
    boss_iniciar();
    instance_destroy();
}

#endregion
