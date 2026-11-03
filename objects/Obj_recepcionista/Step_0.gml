#region Atualização

if (global.cena.ativa || global.interface.diario_aberto) exit;
// Conversa obrigatória que libera a porta verde
if (fala_atual_num == 1) texto_completo = fala_1;
if (fala_atual_num == 2) texto_completo = fala_2;
if (fala_atual_num == 3) texto_completo = fala_3;
if (fala_atual_num == 4) texto_completo = fala_4;

var jogador = instance_nearest(x, y, Obj_jogador);
// E inicia a conversa; E ou Espaço completa e avança as falas.

if (!exibir_dialogo) {
    if (jogador != noone && point_distance(interacao_x, interacao_y, jogador.x, jogador.y) < raio_interacao
    && !global.interface.dialogo_ativo && bunker_interagir()) {
        exibir_dialogo = true;
        global.interface.dialogo_ativo = true;
        fala_atual_num = 1;
        char_index = 0;
        texto_atual = "";
    }
} else {
    if (bunker_dialogo_avancar()) {
        if (char_index < string_length(texto_completo)) {
            char_index = string_length(texto_completo);
            texto_atual = texto_completo;
        } else if (fala_atual_num < total_falas) {
            fala_atual_num++;
            char_index = 0;
            texto_atual = "";
        } else {
            exibir_dialogo = false;
            global.interface.dialogo_ativo = false;
            global.progresso.secretaria_orientou = true;
            fala_atual_num = 1;
            bunker_audio_tocar_efeito(Snd_item, 8, false);
        }
    }

    if (char_index < string_length(texto_completo)) {
        char_index = min(string_length(texto_completo),char_index + velocidade_texto * bunker_passo());
        texto_atual = string_copy(texto_completo, 1, floor(char_index));
    }
}

#endregion
