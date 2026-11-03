#region Arquivo liberado

function arquivo_liberado() {
    if(global.progresso.arquivo_livre) return true;
    for(var i=0;i<instance_number(Obj_caracol);i++) {
        var inimigo=instance_find(Obj_caracol,i);
        if(variable_instance_exists(inimigo,"guarda_arquivo") && inimigo.guarda_arquivo && inimigo.vida>0) return false;
    }
    if(room==Room_Biblioteca) {global.progresso.arquivo_livre=true;return true;}
    return false;
}

#endregion

#region Boss iniciar

function boss_iniciar() {
    if(room!=Room1 || global.progresso.boss_derrotado) return;
    var chefe=instance_find(Obj_boss,0);
    if(chefe==noone || chefe.encontro_ativo) return;
    chefe.encontro_ativo=true;chefe.visible=true;
    global.cena.boss_instancia=chefe;
    global.cena.boss_etapa=1;global.cena.boss_tempo=0;
    global.cena.ativa=true;global.camera.zoom=1;
    var _j = instance_find(Obj_jogador,0);
    global.cena.boss_foco_inicial_x = instance_exists(_j) ? _j.x : chefe.x;
    global.cena.boss_foco_inicial_y = instance_exists(_j) ? _j.y : chefe.y;
    global.camera.foco_x=global.cena.boss_foco_inicial_x;
    global.camera.foco_y=global.cena.boss_foco_inicial_y;
    global.cena.saida_aberta=false;
    // Fecha logicamente já na coleta; os escombros chegam durante a cena.
    if(instance_exists(global.cena.boss_porta) && !(global.config.portas_livres)) global.cena.boss_porta.ativa=false;
}

#endregion

#region Boss concluir

function boss_concluir() {
    global.progresso.boss_derrotado=true;global.cena.saida_aberta=true;
    global.cena.boss_etapa=0;global.cena.ativa=false;global.camera.zoom=1;
    if(instance_exists(global.cena.boss_porta)) global.cena.boss_porta.ativa=true;
    global.renderizacao.reconstruir_cenario=true;
    bunker_audio_tocar_efeito(Snd_impacto_boss,30,false);
}

#endregion

#region Progressao atualizar

function progressao_atualizar() {
    if(global.interface.pause_aberto || global.interface.diario_aberto || global.interface.config_aberta) return;
    global.cena.entulho_perto=false;
    if(global.cena.entulho_mensagem_tempo>0) global.cena.entulho_mensagem_tempo = max(0,global.cena.entulho_mensagem_tempo - bunker_passo());
    if(global.cena.boss_etapa>0) {
        var tempo_anterior = global.cena.boss_tempo;
        global.cena.boss_tempo += bunker_passo();
        var t=global.cena.boss_tempo;
        var b=global.cena.boss_instancia;
        var foco=mapa_ponto("boss_foco_porta");
        if(instance_exists(b)) {
            var golpe = max(0,t-40);
            b.ataque_ativo=t>=40 && golpe<106;b.ataque_tempo=min(golpe,106);
            b.impacto_x=b.x;b.impacto_y=b.y+35;
            b.sprite_index=Spr_parado_baixo;b.image_speed=0;b.image_index=0;
            if(tempo_anterior < 106 && t >= 106) {b.onda_tempo=22;bunker_audio_tocar_efeito(Snd_impacto_boss,30,false);}
            if(t>106) b.onda_tempo=max(0,22-(t-106));
        }
        // Aproximação, golpe completo, porta trancada e retorno ao jogador.
        var _u=clamp(t/40,0,1); _u=_u*_u*(3-2*_u);
        global.camera.foco_x=lerp(global.cena.boss_foco_inicial_x,b.x_inicial,_u);
        global.camera.foco_y=lerp(global.cena.boss_foco_inicial_y,b.y_inicial,_u);
        global.camera.zoom=lerp(1,1.6,_u);
        if(t>146) {
            _u=clamp((t-146)/36,0,1); _u=_u*_u*(3-2*_u);
            global.camera.foco_x=lerp(b.x_inicial,foco.x,_u);
            global.camera.foco_y=lerp(b.y_inicial,foco.y,_u);
        }
        if(t>224) {
            var _j=instance_find(Obj_jogador,0);
            _u=clamp((t-224)/40,0,1); _u=_u*_u*(3-2*_u);
            if(instance_exists(_j)) {
                global.camera.foco_x=lerp(foco.x,_j.x,_u);
                global.camera.foco_y=lerp(foco.y,_j.y,_u);
            }
            global.camera.zoom=lerp(1.6,1,_u);
        }
        if(tempo_anterior < 192 && t >= 192 && !instance_exists(global.cena.boss_bloqueio)) {
            global.cena.boss_bloqueio=instance_find(Obj_bloqueio_arena,0);
            if(instance_exists(global.cena.boss_bloqueio)) {
                global.cena.boss_bloqueio.colisao_ativa=true;
                global.cena.boss_bloqueio.sprite_index=Spr_entulho_arena;
                global.cena.boss_bloqueio.mask_index=Spr_entulho_arena;
            }
            if(instance_exists(global.cena.boss_porta)) global.cena.boss_porta.ativa=false;
            bunker_audio_tocar_efeito(Snd_impacto_boss,28,false);
        }
        if(t>=264) {
            global.cena.boss_etapa=0;global.cena.ativa=false;global.camera.zoom=1;
            if(instance_exists(b)) {b.ataque_ativo=false;b.ataque_intervalo=100;b.onda_tempo=0;}
        }
        return;
    }
    if(global.cena.ativa || global.interface.dialogo_ativo || global.cena.vitoria_ativa) return;
    var j=instance_nearest(0,0,Obj_jogador);
    if(j==noone) return;
    if(room==Room_Corredor) global.cena.entulho_perto=mapa_distancia(j,"aviso_entulho")<=45;
    if(room==Room_Corredor_Pos) global.cena.entulho_perto=mapa_distancia(j,"aviso_entulho")<=45;
    if(global.cena.entulho_perto && bunker_interagir()) global.cena.entulho_mensagem_tempo=420;
}

#endregion
