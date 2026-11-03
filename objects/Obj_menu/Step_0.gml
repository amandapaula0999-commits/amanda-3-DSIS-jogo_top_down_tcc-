#region Áudio e tela

// Controla os comandos do menu e a animação de saída.
bunker_audio_atualizar("NORMAL");
var dt = bunker_dt();
if (keyboard_check_pressed(vk_f11)) window_set_fullscreen(!window_get_fullscreen());

#endregion

#region Encerrar o jogo

// Nenhuma outra ação pode interromper a saída.
if (saindo_jogo) {
    saida_tempo = min(saida_tempo + dt, saida_extrair_duracao + saida_zoom_duracao);
    // Tempo sozinho não fecha: a cobertura precisa ter sido desenhada.
    if (saida_coberta_desenhada && !saida_encerrada) {
        saida_coberta_tempo += dt;
        if (saida_coberta_tempo >= 0.15) {
            saida_encerrada = true;
            game_end();
        }
    }
    exit;
}

#endregion

#region Iniciar a partida

if (bloqueio_input > 0) bloqueio_input = max(0,bloqueio_input - bunker_passo());
pulso += dt * 4.8;
if (iniciando_jogo) {
    tempo_transicao += dt * 60;
    if (tempo_transicao >= 120) {
        mapa_agendar_entrada(Room_Externa,"inicio");
        room_goto(Room_Externa);
    }
    exit;
}

#endregion

#region Teclado e controle

var esquerda = keyboard_check_pressed(vk_left) || keyboard_check_pressed(ord("A"));
var direita = keyboard_check_pressed(vk_right) || keyboard_check_pressed(ord("D"));
var cima = keyboard_check_pressed(vk_up) || keyboard_check_pressed(ord("W"));
var baixo = keyboard_check_pressed(vk_down) || keyboard_check_pressed(ord("S"));
var confirmar = keyboard_check_pressed(vk_enter) || keyboard_check_pressed(vk_space);
var voltar = keyboard_check_pressed(vk_escape);
var pad = -1;
for (var dispositivo = 0; dispositivo < gamepad_get_device_count(); dispositivo++) {
    if (gamepad_is_connected(dispositivo)) { pad = dispositivo; break; }
}
if (pad != pad_anterior) { pad_eixo_x = 0; pad_eixo_y = 0; pad_anterior = pad; }
if (pad >= 0) {
    var eixo_x = gamepad_axis_value(pad, gp_axislh);
    var eixo_y = gamepad_axis_value(pad, gp_axislv);
    var novo_x = abs(eixo_x) > 0.55 ? sign(eixo_x) : (abs(eixo_x) < 0.25 ? 0 : pad_eixo_x);
    var novo_y = abs(eixo_y) > 0.55 ? sign(eixo_y) : (abs(eixo_y) < 0.25 ? 0 : pad_eixo_y);
    esquerda = esquerda || gamepad_button_check_pressed(pad, gp_padl) || (novo_x == -1 && pad_eixo_x != -1);
    direita = direita || gamepad_button_check_pressed(pad, gp_padr) || (novo_x == 1 && pad_eixo_x != 1);
    cima = cima || gamepad_button_check_pressed(pad, gp_padu) || (novo_y == -1 && pad_eixo_y != -1);
    baixo = baixo || gamepad_button_check_pressed(pad, gp_padd) || (novo_y == 1 && pad_eixo_y != 1);
    confirmar = confirmar || gamepad_button_check_pressed(pad, gp_face1);
    voltar = voltar || gamepad_button_check_pressed(pad, gp_face2);
    pad_eixo_x = novo_x;
    pad_eixo_y = novo_y;
}

#endregion

#region Mouse

var mx = device_mouse_x_to_gui(0);
var my = device_mouse_y_to_gui(0);
var clique = mouse_check_button_pressed(mb_left);
var mouse_moveu = abs(mx - mouse_anterior_x) + abs(my - mouse_anterior_y) > 1;
mouse_anterior_x = mx;
mouse_anterior_y = my;
if (mouse_moveu || clique) input_mouse = true;
// Um mouse parado não rouba a seleção do teclado/controle.
if (esquerda || direita || cima || baixo || confirmar || voltar) input_mouse = false;

#endregion

#region Configurações e comandos

if (global.interface.config_aberta) {
    if (cima) global.interface.config_selecionado = (global.interface.config_selecionado + 2) mod 3;
    if (baixo) global.interface.config_selecionado = (global.interface.config_selecionado + 1) mod 3;
    if ((esquerda || direita) && global.interface.config_selecionado < 2) bunker_configuracao_alternar(global.interface.config_selecionado);
    if (input_mouse) {
        var config_ys = [270, 382, 494];
        for (var config_i = 0; config_i < 3; config_i++) {
            if (point_in_rectangle(mx, my, 330, config_ys[config_i] - 40, 1036, config_ys[config_i] + 40)) {
                global.interface.config_selecionado = config_i;
                if (clique) confirmar = true;
            }
        }
    }
    if (voltar || (confirmar && global.interface.config_selecionado == 2)) {
        global.interface.config_aberta = false;
        global.interface.config_origem = "";
        bloqueio_input = 6;
    } else if (confirmar) bunker_configuracao_alternar(global.interface.config_selecionado);
    exit;
}
if (mostrar_controles) {
    if (voltar || confirmar || clique) { mostrar_controles = false; bloqueio_input = 6; }
    exit;
}

#endregion

#region Selecionar uma opção

if (bloqueio_input <= 0) {
    var anterior = selecionado;
    if (input_mouse) {
        selecionado = -1;
        for (var i = 0; i < quantidade_opcoes; i++) {
            // União do repouso e da posição animada evita oscilação no hover.
            var topo = cartao_y[i] - hover_altura * animacao_cartao[i] - 5;
            if (point_in_rectangle(mx, my, cartao_x[i], topo,
                cartao_x[i] + cartao_largura[i] * cartao_escala[i], i==3 ? 404+(mx-596)*22/229 : cartao_limite[i])) {
                selecionado = i;
                if (clique) confirmar = true;
            }
        }
    } else {
        if (selecionado < 0 && (esquerda || direita || cima || baixo || confirmar)) selecionado = 0;
        if (esquerda && selecionado < 3) selecionado = 3;
        else if (direita && selecionado == 3) selecionado = 0;
        else if (cima && selecionado >= 0 && selecionado < 3) selecionado = (selecionado + 2) mod 3;
        else if (baixo && selecionado >= 0 && selecionado < 3) selecionado = (selecionado + 1) mod 3;
    }
    if (confirmar && selecionado >= 0) {
        switch (selecionado) {
            case 0: iniciando_jogo = true; tempo_transicao = 0; break;
            case 1: mostrar_controles = true; break;
            case 2:
                global.interface.config_aberta = true;
                global.interface.config_origem = "menu";
                global.interface.config_selecionado = 0;
                break;
            case 3:
                saindo_jogo = true;
                saida_tempo = 0;
                saida_y_inicial = cartao_y[3] - hover_altura * animacao_cartao[3];
                saida_coberta_desenhada = false;
                saida_coberta_tempo = 0;
                break;
        }
    }
    if (selecionado != anterior) pulso = 0;
}

#endregion

#region Animar os cartões

// Mesma curva independente de FPS nos quatro cartões, na subida e na volta.
var suavidade = 1 - power(0.000001, dt);
for (var j = 0; j < quantidade_opcoes; j++) {
    animacao_cartao[j] = lerp(animacao_cartao[j], j == selecionado ? 1 : 0, suavidade);
}

#endregion
