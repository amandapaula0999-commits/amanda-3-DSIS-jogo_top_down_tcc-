#region Mapa ponto

// O layout fica no editor de salas.
function mapa_ponto(_nome) {
    for (var i=0;i<instance_number(Obj_ponto_mapa);i++) {
        var p=instance_find(Obj_ponto_mapa,i);
        if(p.identificador==_nome) return p;
    }
    show_error("Ponto ausente na room: " + room_get_name(room) + " / " + _nome,true);
    return noone;
}

#endregion

#region Mapa distancia

function mapa_distancia(_ator,_nome) {
    var p=mapa_ponto(_nome);
    return point_distance(_ator.x,_ator.y,p.x,p.y);
}

#endregion

#region Mapa agendar entrada

function mapa_agendar_entrada(_sala,_ponto) {
    global.transicao.sala_destino=_sala;
    global.transicao.ponto=_ponto;
}

#endregion

#region Mapa reunir indicios

function mapa_reunir_indicios(_mapa) {
    for(var i=0;i<instance_number(Obj_ponto_mapa);i++) {
        var p=instance_find(Obj_ponto_mapa,i);
        if(p.tipo!="indicio") continue;
        var n=p.indice;
        _mapa.indicio_x[n]=p.x;_mapa.indicio_y[n]=p.y;
        _mapa.indicio_texto[n]=p.texto;
        _mapa.indicio_registro[n]={codigo:p.codigo,local:_mapa.nome_area,titulo:p.titulo,
            observacao:p.texto,avaliacao:p.avaliacao,procedimento:p.procedimento,vinculo:p.vinculo};
    }
}

#endregion
