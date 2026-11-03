#region Segue o jogador e o mouse

// Só executa o código se tiver um dono válido
if (dono != noone && instance_exists(dono)) {

    // Usa a mesma mira; o jogador desenha a arma na frente do corpo.
    var _direcao_mouse = atacando ? ataque_direcao : point_direction(dono.x, dono.y - 12 * bunker_escala_protagonista(), mouse_x, mouse_y);
    depth = dono.depth - 100;
    // O jogador desenha a arma carregada no próprio Draw, garantindo a camada.
    visible = false;
    bunker_pose_bracos(id, _direcao_mouse, true);
    dono.takedown_pronto = false;
    dono.takedown_alvo_pronto = noone;
    if (bunker_jogo_bloqueado()) exit;
    if (global.inventario.equipamento_ativo != "cano" || dono.vida <= 0) {
        ataque_buffer = 0;
        atacando = false;
        ataque_tempo = 0;
        image_index = 0;
        exit;
    }
    var _dt_ataque = bunker_dt();
    ataque_buffer = max(0, ataque_buffer - _dt_ataque);
    // Guarda um clique nos últimos 120 ms para não perder o próximo golpe.
    if (mouse_check_button_pressed(mb_right)) ataque_buffer = 0.12;

    // Se não estiver atacando, mira no ponteiro do mouse
    if (!atacando) {

        // bunker_pose_bracos posiciona o sprite direcional no ombro.
        image_index = 0;
        image_speed = 0;

        // A pose direcional já foi encaixada no ombro por bunker_pose_bracos.

        #region Ataque com botão direito

        if (dono.furtivo && instance_exists(Obj_caracol)) {
            var alvo_furtivo = noone;
            var distancia_furtiva = 96.001;
            for (var furtivo_i = 0; furtivo_i < instance_number(Obj_caracol); furtivo_i++) {
                var candidata_furtiva = instance_find(Obj_caracol, furtivo_i);
                var distancia_candidata = point_distance(dono.x, dono.y, candidata_furtiva.x, candidata_furtiva.y);
                var angulo_atras = abs(angle_difference(candidata_furtiva.direcao_atual,
                    point_direction(candidata_furtiva.x, candidata_furtiva.y, dono.x, dono.y)));
                if (!candidata_furtiva.morrendo
                && candidata_furtiva.estado != "PERSEGUINDO"
                && candidata_furtiva.alerta < 60
                && distancia_candidata < distancia_furtiva
                && angulo_atras >= 100
                && collision_line(dono.x, dono.y, candidata_furtiva.x, candidata_furtiva.y, Obj_parede, false, true) == noone) {
                    alvo_furtivo = candidata_furtiva;
                    distancia_furtiva = distancia_candidata;
                }
            }
            if (instance_exists(alvo_furtivo)) {
                dono.takedown_pronto = true;
                dono.takedown_alvo_pronto = alvo_furtivo;
                if (mouse_check_button_pressed(mb_right)) {
                    if (!atacando) {
                        ataque_buffer = 0;
                        dono.takedown_ativo = true;
                        dono.takedown_alvo = alvo_furtivo;
                        dono.takedown_tempo = 0;
                        dono.takedown_duracao = 44;
                        dono.takedown_direcao = point_direction(alvo_furtivo.x, alvo_furtivo.y, dono.x, dono.y);
                        alvo_furtivo.estado = "TAKEDOWN";
                        alvo_furtivo.takedown_ativo = true;
                        alvo_furtivo.alerta = 0;
                        alvo_furtivo.image_speed = 0;
                        bunker_audio_tocar_efeito(Snd_finalizacao, 26, false);
                        bunker_emitir_ruido(dono.x, dono.y, 70, 28);
                        exit;
                    }
                }
            }
        }
        if (ataque_buffer > 0) {
            ataque_buffer = 0;
            atacando = true;
            bunker_emitir_ruido(x, y, 210, 55);

            // Mantém o GIF da direção selecionada durante todo o golpe.
            image_index = 0;
            ataque_tempo = 0;
            ataque_direcao = _direcao_mouse;
            ataque_atingiu = false;
            ataque_ponta_valida = false;
            ataque_pixels_anteriores = [];
            ataque_recarga = 0; // A própria animação define o intervalo (0,24 s).
        }

        #endregion


	}
    if (atacando) {
        // Avança todos os quadros cruzados mesmo se o FPS cair.
        var _quadro_anterior = floor(image_index);
        ataque_tempo += _dt_ataque;
        var _quadro_alvo = min(2, floor(ataque_tempo * 12.5));
        for (var _q = _quadro_anterior; _q <= _quadro_alvo; _q++) {
            image_index = _q;
            bunker_cano_impacto(id);
        }
        if (ataque_tempo >= 3 / 12.5) {
            atacando = false;
            image_index = 0;
        }
    }
} else {
    visible = true;
    sprite_index = Spr_cano_chao;
    image_angle = 0;
    image_index = 0;
    image_xscale = escala_visual;
    image_yscale = escala_visual;
}

#endregion
