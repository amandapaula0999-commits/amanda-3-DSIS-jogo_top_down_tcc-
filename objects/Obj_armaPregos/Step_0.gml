#region Segue o jogador e o mouse

if (dono != noone && instance_exists(dono)) {

    // Posiciona a arma na mão e na frente do jogador.
    var _escala_dono = bunker_escala_protagonista();
    var _direcao_mouse = point_direction(dono.x, dono.y - 12 * _escala_dono, mouse_x, mouse_y);
    depth = dono.depth - 100;
    visible = false;
    bunker_pose_bracos(id, _direcao_mouse, false);
    if (bunker_jogo_bloqueado()) exit;
    if (bunker_alarme_passo(id,bunker_passo())) event_perform(ev_alarm,0);
    if (global.inventario.equipamento_ativo != "pistola") exit;

    image_speed = 0;

    #region Disparar o prego (botão direito)

    if (mouse_check_button_pressed(mb_right)) {
        if (!recarregando && pode_atirar) {
            if (municao_atual > 0) {

                // Calcula a saída do disparo na ponta do cano
                var _bocas = [[16,22],[29,14],[16,22],[2,14]];
                var _boca = _bocas[image_index];
                var _dx_boca = (_boca[0] - 16) * escala_visual;
                var _dy_boca = (_boca[1] - 16) * escala_visual;
                var _ponta_x = x + lengthdir_x(_dx_boca, image_angle) - lengthdir_y(_dy_boca, image_angle);
                var _ponta_y = y + lengthdir_y(_dx_boca, image_angle) + lengthdir_x(_dy_boca, image_angle);

                var _raio_prego = 2; // Espessura do prego, não a diagonal inteira do sprite.
                var _dir_tiro = point_direction(_ponta_x, _ponta_y, mouse_x, mouse_y);
                var _prego = bunker_lancar_prego(dono, _ponta_x, _ponta_y, _dir_tiro, _raio_prego);
                if (!instance_exists(_prego)) exit;
                municao_atual -= 1;
                _prego.dano = 5; // Define o dano da bala
                global.inventario.pregos_carregados = municao_atual;
                if (municao_atual <= 0) pode_atirar = false;
                bunker_audio_tocar_efeito(Snd_pistola_pregos, 20, false);
                bunker_emitir_ruido(x, y, 560, 110);

            }
        }
    }

    #endregion

    #region Sistema de recarga (botão esquerdo)

    if (mouse_check_button_pressed(mb_left) && !recarregando) {
        if (global.inventario.pregos_reserva > 0 && municao_atual < municao_maxima) {

            recarregando = true; // Trava o disparo durante a recarga
            pode_atirar = false;

            // Define o tempo da recarga (30 unidades de 60 Hz = 0.5s)
            bunker_alarme_definir(id, 30);

        }
    }

    #endregion

    // Sincroniza a munição da arma com o inventário.
    if (!recarregando && municao_atual != global.inventario.pregos_carregados) {
        municao_atual = clamp(global.inventario.pregos_carregados, 0, municao_maxima);
        global.inventario.pregos_carregados = municao_atual;
        pode_atirar = (municao_atual > 0);
    }

} else {
    visible = true;
    sprite_index = Spr_arma_pregos_chao;
    image_index = 0;
    image_angle = 0;
    image_xscale = escala_visual;
    image_yscale = escala_visual;
}

#endregion
