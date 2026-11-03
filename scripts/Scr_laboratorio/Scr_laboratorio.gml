#region Lab11 entrar

// Sala 11. Arte pré-carregada na Room; este script contém apenas lógica/texto.
function lab11_entrar(_m) {
    _m.lab11_pontos=[];
    for(var i=0;i<instance_number(Obj_ponto_mapa);i++) {
        var p=instance_find(Obj_ponto_mapa,i);
        if(p.tipo=="laboratorio") _m.lab11_pontos[p.indice]=[p.x,p.y,p.texto];
    }
    _m.lab11_perto = -1;
    _m.lab11_leitura = -1;
    _m.lab11_pagina = 0;
    _m.lab11_input = 12;
    _m.lab11_soltar_dialogo = false;

}

#endregion

#region Lab11 step

function lab11_step(_m) {
    if (global.interface.pause_aberto || global.interface.config_aberta || global.interface.diario_aberto || global.transicao.duto_ativo) return;
    var _j = instance_find(Obj_jogador,0);
    if (_j == noone || _j.vida <= 0) return;
    if (_m.lab11_input > 0) {
        _m.lab11_input = max(0,_m.lab11_input - bunker_passo());
        if (_m.lab11_input <= 0 && _m.lab11_soltar_dialogo) {
            _m.lab11_soltar_dialogo = false;
            global.interface.dialogo_ativo = false;
        }
        return;
    }
    if (_m.lab11_leitura >= 0) {
        if (bunker_dialogo_avancar()) {
            _m.lab11_pagina++;
            _m.lab11_input = 12;
            if (_m.lab11_pagina >= 2) {
                global.progresso.laboratorio_leituras[_m.lab11_leitura] = true;
                _m.lab11_leitura = -1;
                // Mantém um breve intervalo antes de devolver o controle ao jogador.
                _m.lab11_soltar_dialogo = true;
            }
        }
        return;
    }
    if (global.cena.ativa || global.interface.dialogo_ativo) return;
    _m.lab11_perto = -1;
    var _melhor = 35;
    for (var _i=0; _i<array_length(_m.lab11_pontos); _i++) {
        var _p = _m.lab11_pontos[_i];
        var _d = point_distance(_j.x,_j.y,_p[0],_p[1]);
        if (_d < _melhor) { _melhor = _d; _m.lab11_perto = _i; }
    }
    if (_m.lab11_perto >= 0 && bunker_interagir()) {
        _m.lab11_leitura = _m.lab11_perto;
        _m.lab11_pagina = 0;
        _m.lab11_input = 12;
        global.interface.dialogo_ativo = true;
    }
}

#endregion

#region Lab11 texto

function lab11_texto(_especie,_pagina) {
    switch (_especie) {
        case 0: return _pagina == 0
            ? "Formigas... As cápsulas registram força, resistência e comportamento coletivo. São as mesmas características das criaturas que encontrei."
            : "Queriam transferir essa força para um corpo humano? Ou criar seres que obedecessem como uma colônia? Não consigo saber só olhando.";
        case 1: return _pagina == 0
            ? "Caracóis. A carapaça e o tecido viscoso lembram os inimigos lá fora. Estes espécimes parecem ser a origem da pesquisa."
            : "Proteção e regeneração... Isso serviria para sobreviver em confrontos. Mas será que procuravam uma arma ou alguma outra forma de vida?";
        case 2: return _pagina == 0
            ? "Lagartos. O registro compara músculos e ossos com uma estrutura humana. As criaturas deste laboratório são resultado dessas pesquisas."
            : "Estavam tentando criar novas raças meio-humanas? Quanto dessas criaturas ainda é humano? Preciso de mais registros antes de concluir qualquer coisa.";
        case 3: return _pagina == 0
            ? "Cobras... Este espécime ainda cabe na cápsula, mas a ficha prevê um crescimento muito maior. Há uma indicação: contenção profunda."
            : "A anotação manda reforçar portas e evitar vibrações. Se há um exemplar adulto em outro setor, o que eu enfrentei até agora pode ter sido só o começo.";
        case 4: return _pagina == 0
            ? "O terminal reúne quatro linhas de pesquisa: formigas, caracóis, lagartos e cobras. Há comparações de resistência, coordenação e adaptação a tecido humano."
            : "Uso em confrontos? Criação de uma nova raça? As páginas sobre a finalidade foram apagadas. Só restou uma transferência para a contenção profunda.";
    }
    return "";
}

#endregion

#region Lab11 conteudo

function lab11_conteudo(_m) {
    if (global.interface.pause_aberto || global.interface.config_aberta || global.interface.diario_aberto || global.transicao.duto_ativo)
        return bunker_fase2_mensagem("", "");
    if (_m.lab11_leitura >= 0) return bunker_fase2_mensagem(
        lab11_texto(_m.lab11_leitura,_m.lab11_pagina),"E / ESPAÇO: CONTINUAR");
    if (global.cena.ativa || global.interface.dialogo_ativo) return bunker_fase2_mensagem("", "");
    var _j = instance_find(Obj_jogador,0);
    if (_j == noone) return bunker_fase2_mensagem("", "");
    var _saida = instance_find(Obj_porta,0);
    if (_saida != noone && bunker_porta_em_alcance(_saida,_j))
        return bunker_fase2_mensagem("Voltar ao corredor do nível 2.","[E] SAIR DO LABORATÓRIO");
    if (_m.lab11_perto >= 0) {
        var _nome = _m.lab11_pontos[_m.lab11_perto][2];
        return bunker_fase2_mensagem(_nome,"[E] " + (global.progresso.laboratorio_leituras[_m.lab11_perto] ? "RELER REGISTRO" : "EXAMINAR"));
    }
    if (_m.tempo_apresentacao > 0) return bunker_fase2_mensagem(
        "SALA 11 / LABORATÓRIO — Há criaturas soltas entre as cápsulas.","EXAMINE OS ESPÉCIMES E O TERMINAL COM E");
    return bunker_fase2_mensagem("", "");
}

#endregion
