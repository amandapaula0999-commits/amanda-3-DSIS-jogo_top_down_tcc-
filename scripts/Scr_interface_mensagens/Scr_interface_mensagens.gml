#region Interface fase2

function bunker_interface_fase2() {
    return room == Room_Corredor_N2 || room == Room_Funcionarios
        || room == Room_Manutencao_N2 || room == Room_Ferramentas_N2
        || room == Room_Laboratorio_N2;
}

#endregion

#region Fase2 mensagem

function bunker_fase2_mensagem(_texto, _comando) {
    return {texto: _texto, comando: _comando};
}

#endregion

#region Fase2 ferramentas texto

function bunker_fase2_ferramentas_texto(_frame, _perto) {
    switch (_frame) {
        case 0: return bunker_fase2_mensagem("Ferramentas comuns, bancadas e prateleiras. À primeira vista, nada de especial.", "");
        case 1: return bunker_fase2_mensagem("Espere... tem um pé de cabra pendurado na parede. Vou dar uma olhada.", "");
        case 2: return bunker_fase2_mensagem("Há um pé de cabra pendurado na parede.", "[E] EXAMINAR PÉ DE CABRA");
        case 3: return bunker_fase2_mensagem("Um pé de cabra. Pode ser útil para abrir passagens emperradas.", _perto == "suporte" ? "[E] COLETAR" : "APROXIME-SE DO PÉ DE CABRA PARA COLETAR");
        case 4: return bunker_fase2_mensagem("Pé de cabra adicionado ao inventário. Vou guardá-lo para abrir passagens emperradas.", "");
        case 5: return bunker_fase2_mensagem("O suporte está vazio. Já guardei o pé de cabra.", "");
        case 6: return bunker_fase2_mensagem("Bancada de manutenção.", "[E] EXAMINAR BANCADA");
        case 7: return bunker_fase2_mensagem("Uma bancada com ferramentas de manutenção.", "");
        case 8: return bunker_fase2_mensagem("Prateleiras da sala de ferramentas.", "[E] EXAMINAR PRATELEIRAS");
        case 9: return bunker_fase2_mensagem("Caixas e ferramentas organizadas nas prateleiras.", "");
    }
    return bunker_fase2_mensagem("", "");
}

#endregion

#region Fase2 conteudo

function bunker_fase2_conteudo(_m) {
    if (room == Room_Manutencao_N2) {
        var _fria = instance_find(Obj_porta_manutencao, 0);
        if (_fria != noone && !global.interface.pause_aberto && !global.interface.diario_aberto && !global.interface.config_aberta) {
            if (_fria.fala_etapa > 0) return bunker_fase2_mensagem(_fria.fala_texto, _fria.fala_espera > 0 ? "" : "E / ESPAÇO: CONTINUAR");
            if (_fria.esforco > 0) return bunker_fase2_mensagem("A porta está emperrada...", "SEGURE E: " + string(ceil(max(0, 3 - _fria.esforco))) + " s");
        }
    }
    if (room == Room_Laboratorio_N2) return lab11_conteudo(_m);
    if (!bunker_interface_fase2() || global.interface.pause_aberto || global.interface.config_aberta
        || global.interface.diario_aberto || global.cena.ativa || global.interface.dialogo_ativo
        || global.cena.vitoria_ativa) return bunker_fase2_mensagem("", "");

    var _j = instance_find(Obj_jogador, 0);
    if (_j == noone) return bunker_fase2_mensagem("", "");

    // Mostra uma caixa por quadro; a porta próxima tem prioridade.
    var _porta = noone;
    var _distancia = 1000000;
    for (var _i = 0; _i < instance_number(Obj_porta); _i++) {
        var _p = instance_find(Obj_porta, _i);
        if (!_p.ativa || _p.abrindo || !bunker_porta_em_alcance(_p, _j)) continue;
        var _d = point_distance(_p.x, _p.y, _j.x, _j.y);
        if (_d < _distancia) { _porta = _p; _distancia = _d; }
    }
    if (_porta != noone) {
        if (_porta.mensagem_tempo > 0) return bunker_fase2_mensagem(_porta.mensagem_bloqueio, "");
        return bunker_fase2_mensagem(_porta.rotulo, "[E] " + _porta.rotulo);
    }

    if (room == Room_Funcionarios) {
        if (_m.func_mensagem_tempo > 0) {
            switch (_m.func_feedback_frame) {
                case 4: return bunker_fase2_mensagem("Café quente: vida recuperada.", "");
                case 5: return bunker_fase2_mensagem("Já estou com a vida cheia.", "");
                case 6: return bunker_fase2_mensagem("Chave da sala de ferramentas adicionada ao inventário.", "");
                case 7: return bunker_fase2_mensagem("A caixinha está vazia. A chave já está comigo.", "");
                case 8: return bunker_fase2_mensagem("Dormitório trancado. Não tenho a chave desta porta.", "");
            }
        }
        switch (_m.func_interacao_proxima) {
            case "cafe": return bunker_fase2_mensagem("Cafeteira da sala de descanso.", "[E] TOMAR CAFÉ");
            case "chaves": return bunker_fase2_mensagem("Caixinha de chaves na parede.", "[E] EXAMINAR CHAVES");
            case "dormitorio": return bunker_fase2_mensagem("Porta do dormitório.", "[E] EXAMINAR PORTA");
        }
    }

    if (room == Room_Ferramentas_N2) {
        if (_m.ferramentas_mensagem_tempo > 0) return bunker_fase2_ferramentas_texto(_m.ferramentas_mensagem_quadro, _m.ferramentas_interacao_proxima);
        switch (_m.ferramentas_interacao_proxima) {
            case "suporte": return bunker_fase2_ferramentas_texto(global.inventario.pe_cabra ? 5 : (_m.ferramentas_suporte_examinado ? 3 : 2), _m.ferramentas_interacao_proxima);
            case "bancada": return bunker_fase2_ferramentas_texto(6, _m.ferramentas_interacao_proxima);
            case "prateleira": return bunker_fase2_ferramentas_texto(8, _m.ferramentas_interacao_proxima);
        }
    } else if (_m.tempo_apresentacao > 0) {
        return bunker_fase2_mensagem(_m.nome_area, _m.objetivo_area);
    }
    return bunker_fase2_mensagem("", "");
}

#endregion

#region Fase2 gui

function bunker_fase2_gui(_m) {
    var _caixa = bunker_fase2_conteudo(_m);
    var _gw = display_get_gui_width();
    var _gh = display_get_gui_height();
    gpu_set_blendmode(bm_normal);
    // Mantém os avisos no topo e as portas visíveis.
    var _rotulo_porta = false;
    for (var _i = 0; _i < instance_number(Obj_porta); _i++) {
        var _porta = instance_find(Obj_porta, _i);
        if (_caixa.comando == "[E] " + _porta.rotulo) _rotulo_porta = true;
    }
    if (room == Room_Manutencao_N2 && _caixa.texto == "Porta da sala de manutenção.")
        _rotulo_porta = true;
    if (!_rotulo_porta) bunker_aviso_gui(_caixa.texto, _caixa.comando);
    if (_m.fade_entrada > 0) {
        draw_set_alpha(_m.fade_entrada);
        draw_set_color(c_black);
        draw_rectangle(0, 0, _gw, _gh, false);
    }
    draw_set_alpha(1);
    draw_set_color(c_white);
    draw_set_font(-1);
    draw_set_halign(fa_left);
    draw_set_valign(fa_top);
}

#endregion

#region Aviso gui

function bunker_aviso_gui(_texto, _comando, _medida = "") {
    if (_texto == "" && _comando == "" && _medida == "") return;
    if (_comando == "[E] " + _texto) {
        _texto = "";
        _medida = "";
    }
    var _sx = display_get_gui_width() / 1366;
    var _sy = display_get_gui_height() / 768;
    var _escala = min(_sx, _sy);
    var _x = 310 * _sx;
    var _y = 16 * _sy;
    var _w = 746 * _sx;
    var _margem = 20 * _escala;
    var _largura = (_w - 2 * _margem) / _escala;
    draw_set_font(Font_de_fala);
    draw_set_halign(fa_left);
    draw_set_valign(fa_top);
    var _referencia = _medida != "" ? _medida : _texto;
    var _ht = _referencia == "" ? 0 : max(20, string_height_ext(_referencia, 24, _largura));
    var _hc = _comando == "" ? 0 : max(20, string_height_ext(_comando, 24, _largura));
    var _gap = _ht > 0 && _hc > 0 ? 10 : 0;
    var _h = max(48, 28 + _ht + _gap + _hc) * _escala;
    bunker_painel(_x, _y, _w, _h);
    draw_set_color(make_color_rgb(220, 223, 201));
    if (_texto != "") draw_text_ext_transformed(_x + _margem, _y + 14 * _escala,
        _texto, 24, _largura, _escala, _escala, 0);
    draw_set_color(make_color_rgb(180, 159, 110));
    if (_comando != "") draw_text_ext_transformed(_x + _margem,
        _y + (14 + _ht + _gap) * _escala, _comando, 24, _largura, _escala, _escala, 0);
    draw_set_alpha(1);
    draw_set_color(c_white);
    draw_set_font(-1);
    draw_set_halign(fa_left);
    draw_set_valign(fa_top);
}

#endregion

#region Entulho interface desenhar

function entulho_interface_desenhar() {
    if(global.interface.pause_aberto || global.interface.diario_aberto || global.interface.config_aberta || global.cena.ativa || global.cena.vitoria_ativa) return;
    if(!global.cena.entulho_perto && global.cena.entulho_mensagem_tempo<=0) return;
    var texto="[E] EXAMINAR ESCOMBROS";
    if(global.cena.entulho_mensagem_tempo>0) texto="O terremoto que me fez cair aqui também fez esta parte ser obstruída. Bloqueia minha passagem, devo achar outra forma de continuar.";
    bunker_aviso_gui(texto, "");
}

#endregion
