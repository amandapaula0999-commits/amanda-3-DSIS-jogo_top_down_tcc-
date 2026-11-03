#region Encontro
if (global.interface.pause_aberto || global.interface.diario_aberto || global.interface.config_aberta || global.interface.dialogo_ativo) exit;
if (estagio == 0) {
    if (!global.progresso.laboratorio_inimigos_derrotados[1]) exit;
    estagio = 1; visible = true; global.cena.ativa = true;
    var cam = view_get_camera(0);
    if (cam != -1) {
        cam_x = camera_get_view_x(cam); cam_y = camera_get_view_y(cam);
        cam_w = camera_get_view_width(cam); cam_h = camera_get_view_height(cam);
    }
    bunker_audio_tocar_efeito(Snd_impacto_boss,28,false);
}
if (estagio == 1) {
    surgimento += bunker_passo();
    if (surgimento >= 249) {
        x = 96; y = 326; image_index = 0;
        estagio = 2; global.cena.ativa = false;
    }
    exit;
}
if (vida <= 0) {
    global.progresso.cobra_derrotado = true;
    bunker_audio_tocar_efeito(Snd_finalizacao,8,false);
    instance_destroy(); exit;
}
if (cobra_combate_atualizar(id)) exit;
var antes_x = x; var antes_y = y;
lagarto_atualizar(id);
if (global.cena.ativa) exit;
var dx = x-antes_x; var dy = y-antes_y;
if (abs(dx)+abs(dy)>0.01) {
    var lado = floor((point_direction(0,0,dx,dy)+45)/90) mod 4;
    var spr = cobra_sprite_movimento(lado);
    if (sprite_index != spr) { sprite_index = spr; image_index = 0; }
    image_index = (image_index+bunker_passo()*0.12) mod 4;
}
#endregion
