interacao_atualizar(id);

#region Atalhos

// Begin Step: captura a abertura antes dos Steps de movimento/combate.
if (keyboard_check_pressed(vk_f11)) window_set_fullscreen(!window_get_fullscreen());

// O atalho de teste funciona também com o jogador inativo no pause/diário.
if (keyboard_check_pressed(ord("P"))) {
    if (!mundo_pausado) congelar_mundo();
    acao_pendente = "avancar";
    exit;
}

#endregion

#region Retomar a partida

// Retoma no próximo quadro para não repetir o comando do menu no combate.
if (retomar_pendente) {
    retomar_pendente = false;
    limpar_menus();
    mundo_pausado = false;
    instance_activate_all();
    audio_resume_all();
    exit;
}
if (acao_pendente != "") exit;

#endregion

#region Leitura dos comandos

var apertou_escape = keyboard_check_pressed(vk_escape);
var apertou_j = keyboard_check_pressed(ord("J"));

#endregion

#region Configurações

if (global.interface.config_aberta) {
    var config_confirmar = keyboard_check_pressed(vk_enter) || keyboard_check_pressed(vk_space);
    if (keyboard_check_pressed(vk_up) || keyboard_check_pressed(ord("W"))) {
        global.interface.config_selecionado = (global.interface.config_selecionado + 2) mod 3;
    }
    if (keyboard_check_pressed(vk_down) || keyboard_check_pressed(ord("S"))) {
        global.interface.config_selecionado = (global.interface.config_selecionado + 1) mod 3;
    }
    if ((keyboard_check_pressed(vk_left) || keyboard_check_pressed(vk_right)
    || keyboard_check_pressed(ord("A")) || keyboard_check_pressed(ord("D")))
    && global.interface.config_selecionado < 2) {
        bunker_configuracao_alternar(global.interface.config_selecionado);
    }

    var config_mx = device_mouse_x_to_gui(0) * 1366 / display_get_gui_width();
    var config_my = device_mouse_y_to_gui(0) * 768 / display_get_gui_height();
    var config_ys = [270, 382, 494];
    for (var config_i = 0; config_i < 3; config_i++) {
        if (point_in_rectangle(config_mx, config_my, 330, config_ys[config_i] - 40, 1036, config_ys[config_i] + 40)) {
            global.interface.config_selecionado = config_i;
            if (mouse_check_button_pressed(mb_left)) config_confirmar = true;
        }
    }

    if (apertou_escape) {
        global.interface.config_aberta = false;
        global.interface.config_origem = "";
    } else if (config_confirmar) {
        if (global.interface.config_selecionado < 2) bunker_configuracao_alternar(global.interface.config_selecionado);
        else {
            global.interface.config_aberta = false;
            global.interface.config_origem = "";
        }
    }
    exit;
}

#endregion

#region Diário

if (global.interface.diario_aberto) {
    var total_anotacoes = array_length(global.progresso.evidencias);
    if (keyboard_check_pressed(vk_right) || keyboard_check_pressed(ord("D"))) global.interface.diario_pagina++;
    if (keyboard_check_pressed(vk_left) || keyboard_check_pressed(ord("A"))) global.interface.diario_pagina--;
    global.interface.diario_pagina = clamp(global.interface.diario_pagina, 0, max(0, total_anotacoes - 1));

    if (apertou_escape || apertou_j) {
        retomar_pendente = true;
    }
    exit;
}

#endregion

#region Menu de pausa

if (global.interface.pause_aberto) {
    var pause_dt = bunker_dt();
    var pause_esquerda = keyboard_check_pressed(vk_left) || keyboard_check_pressed(ord("A"));
    var pause_direita = keyboard_check_pressed(vk_right) || keyboard_check_pressed(ord("D"));
    var pause_cima = keyboard_check_pressed(vk_up) || keyboard_check_pressed(ord("W"));
    var pause_baixo = keyboard_check_pressed(vk_down) || keyboard_check_pressed(ord("S"));
    var pause_confirmar = keyboard_check_pressed(vk_enter) || keyboard_check_pressed(vk_space);

    // O pause aceita D-pad, analógico e botão principal do controle.
    var pause_pad = -1;
    for (var pause_dispositivo = 0; pause_dispositivo < gamepad_get_device_count(); pause_dispositivo++) {
        if (gamepad_is_connected(pause_dispositivo)) { pause_pad = pause_dispositivo; break; }
    }
    if (pause_pad != pause_pad_anterior) {
        pause_pad_eixo_x = 0;
        pause_pad_eixo_y = 0;
        pause_pad_anterior = pause_pad;
    }
    if (pause_pad >= 0) {
        var pause_ax = gamepad_axis_value(pause_pad, gp_axislh);
        var pause_ay = gamepad_axis_value(pause_pad, gp_axislv);
        var pause_novo_x = abs(pause_ax) > 0.55 ? sign(pause_ax) : (abs(pause_ax) < 0.25 ? 0 : pause_pad_eixo_x);
        var pause_novo_y = abs(pause_ay) > 0.55 ? sign(pause_ay) : (abs(pause_ay) < 0.25 ? 0 : pause_pad_eixo_y);
        pause_esquerda = pause_esquerda || gamepad_button_check_pressed(pause_pad, gp_padl)
            || (pause_novo_x == -1 && pause_pad_eixo_x != -1);
        pause_direita = pause_direita || gamepad_button_check_pressed(pause_pad, gp_padr)
            || (pause_novo_x == 1 && pause_pad_eixo_x != 1);
        pause_cima = pause_cima || gamepad_button_check_pressed(pause_pad, gp_padu)
            || (pause_novo_y == -1 && pause_pad_eixo_y != -1);
        pause_baixo = pause_baixo || gamepad_button_check_pressed(pause_pad, gp_padd)
            || (pause_novo_y == 1 && pause_pad_eixo_y != 1);
        pause_confirmar = pause_confirmar || gamepad_button_check_pressed(pause_pad, gp_face1);
        pause_pad_eixo_x = pause_novo_x;
        pause_pad_eixo_y = pause_novo_y;
    }

    // Mesma geometria do Draw: três cartões à direita e SAIR à esquerda.
    var pause_cartoes = bunker_pause_cartoes();
    var pause_cartao_x = pause_cartoes[0];
    var pause_cartao_y = pause_cartoes[1];
    var pause_cartao_limite = pause_cartoes[2];
    var pause_cartao_largura = pause_cartoes[3];
    var pause_cartao_escala = pause_cartoes[5];
    var pause_hover_altura = pause_cartoes[6];
    var pause_mx = device_mouse_x_to_gui(0);
    var pause_my = device_mouse_y_to_gui(0);
    var pause_clique = mouse_check_button_pressed(mb_left);
    var pause_mouse_moveu = abs(pause_mx - pause_mouse_anterior_x) + abs(pause_my - pause_mouse_anterior_y) > 1;
    pause_mouse_anterior_x = pause_mx;
    pause_mouse_anterior_y = pause_my;
    var pause_layout = bunker_pause_layout(display_get_gui_width(), display_get_gui_height());
    pause_mx = (pause_mx - pause_layout[1]) / pause_layout[0];
    pause_my = (pause_my - pause_layout[2]) / pause_layout[0];
    if (pause_mouse_moveu || pause_clique) pause_input_mouse = true;
    if (pause_esquerda || pause_direita || pause_cima || pause_baixo || pause_confirmar) pause_input_mouse = false;

    if (pause_input_mouse) {
        global.interface.pause_selecionado = -1;
        for (var pause_i = 0; pause_i < 4; pause_i++) {
            var pause_topo = pause_cartao_y[pause_i] - pause_hover_altura * pause_animacao_cartao[pause_i] - 5;
            if (point_in_rectangle(pause_mx, pause_my, pause_cartao_x[pause_i], pause_topo,
                pause_cartao_x[pause_i] + pause_cartao_largura[pause_i] * pause_cartao_escala[pause_i],
                pause_cartao_limite[pause_i])) {
                global.interface.pause_selecionado = pause_i;
                if (pause_clique) pause_confirmar = true;
            }
        }
    } else {
        if (global.interface.pause_selecionado < 0 && (pause_esquerda || pause_direita || pause_cima || pause_baixo || pause_confirmar)) global.interface.pause_selecionado = 0;
        if (pause_esquerda && global.interface.pause_selecionado < 3) global.interface.pause_selecionado = 3;
        else if (pause_direita && global.interface.pause_selecionado == 3) global.interface.pause_selecionado = 0;
        else if (pause_cima && global.interface.pause_selecionado < 3) global.interface.pause_selecionado = (global.interface.pause_selecionado + 2) mod 3;
        else if (pause_baixo && global.interface.pause_selecionado < 3) global.interface.pause_selecionado = (global.interface.pause_selecionado + 1) mod 3;
    }

    // A mesma curva suave do menu principal puxa qualquer cartão selecionado.
    var pause_suavidade = 1 - power(0.000001, pause_dt);
    for (var pause_anim_i = 0; pause_anim_i < 4; pause_anim_i++) {
        pause_animacao_cartao[pause_anim_i] = lerp(pause_animacao_cartao[pause_anim_i],
            pause_anim_i == global.interface.pause_selecionado ? 1 : 0, pause_suavidade);
    }

    if (apertou_escape) {
        retomar_pendente = true;
        exit;
    }

    if (pause_confirmar) {
        switch (global.interface.pause_selecionado) {
            case 0:
                retomar_pendente = true;
                break;
            case 1:
                acao_pendente = "reiniciar";
                break;
            case 2:
                global.interface.config_aberta = true;
                global.interface.config_origem = "pause";
                global.interface.config_selecionado = 0;
                break;
            case 3:
                acao_pendente = "menu";
                break;
        }
    }
    exit;
}

#endregion

#region Abrir menus

// Finalizações furtivas, diálogos e cenas continuam impedindo novos menus.
var jogador = instance_find(Obj_jogador, 0);
if (jogador == noone || jogador.takedown_ativo) exit;

if (apertou_j && !global.cena.ativa && !global.interface.dialogo_ativo) {
    global.interface.diario_aberto = true;
    global.interface.diario_pagina = max(0, array_length(global.progresso.evidencias) - 1);
    congelar_mundo();
    exit;
}

if (apertou_escape && !global.cena.ativa && !global.interface.dialogo_ativo) {
    global.interface.pause_aberto = true;
    global.interface.pause_selecionado = 0;
    pause_animacao_cartao = [0, 0, 0, 0];
    pause_input_mouse = false;
    pause_mouse_anterior_x = device_mouse_x_to_gui(0);
    pause_mouse_anterior_y = device_mouse_y_to_gui(0);
    congelar_mundo();
    exit;
}

#endregion
