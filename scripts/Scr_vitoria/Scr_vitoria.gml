#region Vitoria iniciar

function bunker_vitoria_iniciar(_foco_x, _foco_y) {
    global.interface.creditos_ativos = room == Room_Corredor_Pos && global.config.encerrar_na_escadaria;
    global.cena.vitoria_ativa = true;
    global.cena.vitoria_tempo = 0;
    global.interface.creditos_scroll = 0;
    global.camera.zoom = 1;
    global.camera.foco_x = _foco_x;
    global.camera.foco_y = _foco_y;
    global.cena.ativa = true;
    global.cena.saida_aberta = true;
    global.renderizacao.reconstruir_cenario = true;
}

#endregion

#region Vitoria atualizar

function bunker_vitoria_atualizar() {
    if (!global.cena.vitoria_ativa) return;
    global.cena.vitoria_tempo += bunker_passo();
    if (global.cena.vitoria_tempo < 52) {
        global.camera.zoom = 1 + 0.32 * clamp(global.cena.vitoria_tempo / 52, 0, 1);
    } else if (global.cena.vitoria_tempo < 94) {
        global.camera.zoom = 1.32;
    } else {
        global.camera.zoom = 1;
    }
    if (global.cena.vitoria_tempo > 250) global.interface.creditos_scroll += 0.52 * bunker_passo();
    bunker_camera_cinematica();
    if (global.cena.vitoria_tempo > 720 && (keyboard_check_pressed(vk_enter) || keyboard_check_pressed(vk_escape))) {
        global.cena.vitoria_ativa = false;
        global.interface.creditos_ativos = false;
        global.cena.ativa = false;
        global.camera.zoom = 1;
        room_goto(Room_Menu);
    }
}

#endregion
