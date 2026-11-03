#region Áudio recurso

function bunker_audio_recurso(_estado) {
    switch (_estado) {
        case "NORMAL": return Snd_menu_empresa;
        case "EXPLORACAO": return Snd_ambiente_bunker;
        case "TENSAO": return Snd_tensao;
        case "COMBATE": return Snd_combate;
    }
    return -1;
}

#endregion

#region Áudio tocar efeito

function bunker_audio_tocar_efeito(_recurso, _prioridade, _loop) {
    var instancia_efeito = audio_play_sound(_recurso, _prioridade, _loop);
    var efeito_mudo = global.config.efeitos_mudos;
    if (instancia_efeito != -1) audio_sound_gain(instancia_efeito, efeito_mudo ? 0 : 1, 0);
    return instancia_efeito;
}

#endregion

#region Áudio aplicar configuração

function bunker_audio_aplicar_configuracao() {
    if (global.audio.musica_instancia != -1
    && audio_is_playing(global.audio.musica_instancia)) {
        var musica_muda = global.config.musica_muda;
        audio_sound_gain(global.audio.musica_instancia, musica_muda ? 0 : global.audio.ganho, 0);
    }
}

#endregion

#region Áudio parar

function bunker_audio_parar() {
    // Parar pelo recurso elimina inclusive eventuais cópias herdadas.
    audio_stop_sound(Snd_menu_empresa);
    audio_stop_sound(Snd_ambiente_bunker);
    audio_stop_sound(Snd_tensao);
    audio_stop_sound(Snd_combate);
    global.audio.musica_instancia = -1;
    global.audio.trilha_recurso = -1;
    global.audio.ganho = 0;
}

#endregion

#region Áudio forcar

function bunker_audio_forcar(_estado) {
    bunker_audio_parar();
    global.audio.estado = _estado;
    global.audio.desejado = _estado;
    var recurso = bunker_audio_recurso(_estado);
    if (recurso != -1) {
        global.audio.musica_instancia = audio_play_sound(recurso, 1, true);
        global.audio.trilha_recurso = recurso;
        audio_sound_gain(global.audio.musica_instancia, 0, 0);
    }
}

#endregion

#region Áudio contexto

function bunker_audio_contexto() {
    if (global.cena.vitoria_ativa) return "SILENCIO";
    if (room == Room_Corredor_Recepcao || room == Room_Menu || room == Room_Externa || room == Room_Recepcao) return "NORMAL";
    if (room == Room_Armadilha) {
        if (global.cena.armadilha_explodiu) return "SILENCIO";
        return "NORMAL";
    }
    if (instance_exists(Obj_boss_cobra) && Obj_boss_cobra.estagio > 0) return "COMBATE";
    if (instance_exists(Obj_homem_lagarto) || instance_exists(Obj_caracol_lab)) return "COMBATE";
    if (room == Room1 && !global.progresso.boss_derrotado && instance_exists(Obj_boss)) return "COMBATE";
    var resultado = "EXPLORACAO";
    for (var i = 0; i < instance_number(Obj_caracol); i++) {
        var inimigo = instance_find(Obj_caracol, i);
        if (inimigo.morrendo || inimigo.vida <= 0) continue;
        if (inimigo.estado == "PERSEGUINDO") return "COMBATE";
        if (inimigo.alerta >= 25 || inimigo.estado == "INVESTIGANDO") resultado = "TENSAO";
    }
    return resultado;
}

#endregion

#region Áudio atualizar

function bunker_audio_atualizar(_desejado) {
    global.audio.desejado = _desejado;
    if (global.audio.estado != _desejado) {
        global.audio.ganho = max(0, global.audio.ganho - 0.055);
        if (global.audio.musica_instancia != -1) {
            var musica_muda_transicao = global.config.musica_muda;
            audio_sound_gain(global.audio.musica_instancia, musica_muda_transicao ? 0 : global.audio.ganho, 0);
        }
        // O novo loop só começa depois que o anterior foi encerrado.
        if (global.audio.ganho <= 0) bunker_audio_forcar(_desejado);
    } else {
        var recurso = bunker_audio_recurso(_desejado);
        if (recurso == -1) return;
        if (global.audio.musica_instancia == -1 || !audio_is_playing(global.audio.musica_instancia)) {
            bunker_audio_forcar(_desejado);
        }
        var alvo = (_desejado == "NORMAL") ? 0.44 : 0.34;
        global.audio.ganho = min(alvo, global.audio.ganho + 0.025);
        var musica_muda_alvo = global.config.musica_muda;
        audio_sound_gain(global.audio.musica_instancia, musica_muda_alvo ? 0 : global.audio.ganho, 0);
    }
}

#endregion
