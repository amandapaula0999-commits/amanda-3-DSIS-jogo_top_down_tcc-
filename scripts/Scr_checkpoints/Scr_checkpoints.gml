#region Checkpoint gravar

function checkpoint_gravar(_sala,_x,_y) {
    global.checkpoint.sala=_sala;
    global.checkpoint.x=_x;
    global.checkpoint.y=_y;
    ini_open("checkpoint_v5.ini");
    ini_write_string("checkpoint","sala",room_get_name(_sala));
    ini_write_real("checkpoint","x",_x);
    ini_write_real("checkpoint","y",_y);
    ini_close();
}

#endregion

#region Checkpoint reiniciar

function checkpoint_reiniciar() {
    global.transicao.ponto="";
    global.interface.pause_aberto=false;global.interface.diario_aberto=false;
    global.interface.dialogo_ativo=false;global.cena.ativa=false;global.transicao.duto_ativo=false;
    global.jogador.vida=100;
    global.checkpoint.respawn_pendente=true;
    instance_activate_all();audio_resume_all();
    if(global.checkpoint.sala!=-1) {
        global.transicao.sala_destino=global.checkpoint.sala;
        global.transicao.x=global.checkpoint.x;global.transicao.y=global.checkpoint.y;
        if(room==global.checkpoint.sala) room_restart();
        else room_goto(global.checkpoint.sala);
    } else { global.transicao.sala_destino=-1;room_restart(); }
}

#endregion
