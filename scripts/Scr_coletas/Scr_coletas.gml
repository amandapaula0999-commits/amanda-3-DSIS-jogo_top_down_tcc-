#region Tem id

function bunker_tem_id(_lista, _id) {
    for (var i = 0; i < array_length(_lista); i++) {
        if (_lista[i] == _id) return true;
    }
    return false;
}

#endregion

#region Coletar municao

function bunker_coletar_municao(_id, _quantidade) {
    if (bunker_tem_id(global.progresso.coletas_municao, _id)) return false;
    global.progresso.coletas_municao[array_length(global.progresso.coletas_municao)] = _id;
    global.inventario.pregos_reserva += max(0, floor(_quantidade));
    return true;
}

#endregion

#region Evidencia indice

function bunker_evidencia_indice(_id) {
    for (var i = 0; i < array_length(global.progresso.evidencias); i++) {
        if (global.progresso.evidencias[i].codigo == _id) return i;
    }
    return -1;
}

#endregion

#region Registrar

function bunker_registrar(_registro) {
    if (bunker_evidencia_indice(_registro.codigo) >= 0) return false;
    global.progresso.evidencias[array_length(global.progresso.evidencias)] = _registro;
    return true;
}

#endregion

// Quantidades únicas para coleta, HUD e recarga.
function bunker_capacidade_pregos() { return 15; }
function bunker_pregos_por_caixa() { return 14; }

// Repõe os consumíveis no cenário antes de carregar a nova tentativa.
function bunker_coletas_repor_apos_morte() {
    kits_vida_repor_apos_morte();
    global.progresso.coletas_municao = [];
}
