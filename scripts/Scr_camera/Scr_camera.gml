#region Configurar tela

function bunker_configurar_tela() {
    // Ajusta a câmera à proporção da tela sem esticar os sprites.
    var tela_w = window_get_width();
    var tela_h = window_get_height();
    if (tela_w <= 0 || tela_h <= 0) {
        tela_w = display_get_width();
        tela_h = display_get_height();
    }
    if (tela_w <= 0 || tela_h <= 0) return;

    if (room == Room_Saida_Final) {
        // Mesma escala nos dois eixos, com a sala inteira centralizada.
        var escala_saida = min(tela_w / room_width, tela_h / room_height);
        if (escala_saida >= 1) escala_saida = floor(escala_saida);
        global.camera.largura = tela_w / escala_saida;
        global.camera.altura = tela_h / escala_saida;
        view_set_wport(0,tela_w);
        view_set_hport(0,tela_h);
        view_set_xport(0,0);
        view_set_yport(0,0);
        display_set_gui_size(1366,768);
        bunker_camera_saida();
        gpu_set_texfilter(false);
        return;
    }

    var proporcao = tela_w / tela_h;
    var vista_h = 540;
    var vista_w = clamp(floor(vista_h * proporcao), 640, 960);
    if (proporcao >= 1.70) vista_w = 960;

    // Ajusta a câmera ao tamanho da sala.
    if (room == Room_Externa || room == Room_Corredor_Recepcao || room == Room_Saida_Final || room == Room_Corredor_Pos || room == Room_Biblioteca || room == Room_Pesquisa || room == Room_Corredor || room == Room_Desmoronada || room == Room_Recepcao || room == Room_Laboratorio_N2 || room == Room_Ferramentas_N2 || room == Room_Manutencao_N2 || room == Room_Funcionarios || room == Room_Corredor_N2) {
        var ajuste_sala = min(1, min(room_width / vista_w, room_height / vista_h));
        vista_w = floor(vista_w * ajuste_sala);
        vista_h = floor(vista_h * ajuste_sala);
    }
    global.camera.largura = vista_w;
    global.camera.altura = vista_h;
    // Atualiza o viewport e a câmera sem esticar a imagem.
    var camera_atual = view_get_camera(0);
    var zoom_atual = max(1, global.camera.zoom);
    if (camera_atual != -1) camera_set_view_size(camera_atual, max(320, floor(vista_w / zoom_atual)), max(240, floor(vista_h / zoom_atual)));
    view_set_wport(0, tela_w);
    view_set_hport(0, tela_h);
    view_set_xport(0, 0);
    view_set_yport(0, 0);
    display_set_gui_size(1366, 768);
    if (room == Room_Armadilha && camera_atual != -1) {
        // A câmera cria as margens da sala; o viewport cobre a tela.
        var escala_espera = max(1, floor(min(tela_w/512,tela_h/384)));
        global.camera.largura = tela_w / escala_espera;
        global.camera.altura = tela_h / escala_espera;
        camera_set_view_size(camera_atual,global.camera.largura,global.camera.altura);
        camera_set_view_pos(camera_atual,
            floor((room_width-global.camera.largura)*0.5),
            floor((room_height-global.camera.altura)*0.5));
        gpu_set_texfilter(false);
    }
}

#endregion

#region Camera cinematica

function bunker_camera_cinematica() {
    if (bunker_camera_cobra()) return;
    if (room == Room_Saida_Final) { bunker_camera_saida(); return; }
    if (!(global.cena.vitoria_ativa)
        && !(global.cena.boss_etapa > 0)) return;
    var camera_atual = view_get_camera(0);
    if (camera_atual == -1) return;
    var vw = max(320, floor(global.camera.largura / max(1, global.camera.zoom)));
    var vh = max(240, floor(global.camera.altura / max(1, global.camera.zoom)));
    camera_set_view_size(camera_atual, vw, vh);
    var foco_x = global.camera.foco_x;
    var foco_y = global.camera.foco_y;
    camera_set_view_pos(camera_atual, clamp(foco_x - vw * 0.5, 0, max(0, room_width - vw)), clamp(foco_y - vh * 0.5, 0, max(0, room_height - vh)));
}

#endregion

#region Camera atualizar

function bunker_camera_atualizar() {
    if (bunker_camera_cobra()) return;
    if (room == Room_Saida_Final) { bunker_camera_saida(); return; }
    // Durante a finalização, a câmera acompanha o centro dos personagens.
    var camera_atual = view_get_camera(0);
    if (camera_atual == -1 || !instance_exists(Obj_jogador)) return;
    if (room == Room_Armadilha) {
        // Mantém as margens; não aplica o clamp da câmera que segue o jogador.
        camera_set_view_size(camera_atual,global.camera.largura,global.camera.altura);
        camera_set_view_pos(camera_atual,
            floor((room_width-global.camera.largura)*0.5),
            floor((room_height-global.camera.altura)*0.5));
        return;
    }

    var jogador_camera = instance_find(Obj_jogador, 0);
    var foco_x = jogador_camera.x;
    var foco_y = jogador_camera.y;
    if (jogador_camera.takedown_ativo && instance_exists(jogador_camera.takedown_alvo)) {
        foco_x = (jogador_camera.x + jogador_camera.takedown_alvo.x) * 0.5;
        foco_y = (jogador_camera.y + jogador_camera.takedown_alvo.y) * 0.5;
    }

    var zoom_atual = max(1, global.camera.zoom);
    var vw = max(320, floor(global.camera.largura / zoom_atual));
    var vh = max(240, floor(global.camera.altura / zoom_atual));
    camera_set_view_size(camera_atual, vw, vh);
    camera_set_view_pos(camera_atual,
        clamp(foco_x - vw * 0.5, 0, max(0, room_width - vw)),
        clamp(foco_y - vh * 0.5, 0, max(0, room_height - vh)));
}

#endregion

#region Câmera da saída
function bunker_camera_saida() {
    var cam = view_get_camera(0);
    if (cam == -1) return;
    camera_set_view_size(cam,global.camera.largura,global.camera.altura);
    camera_set_view_pos(cam,
        (room_width-global.camera.largura)*0.5,
        (room_height-global.camera.altura)*0.5);
}
#endregion

#region Cena da cobra
function bunker_camera_cobra() {
    if (room != Room_Laboratorio_N2 || !instance_exists(Obj_boss_cobra)) return false;
    var chefe = instance_find(Obj_boss_cobra,0);
    if (chefe.estagio != 1) return false;
    var cam = view_get_camera(0);
    if (cam == -1) return false;
    var t = chefe.surgimento;
    var mistura = t < 60 ? clamp(t/60,0,1) : (t < 204 ? 1 : 1-clamp((t-204)/45,0,1));
    mistura = mistura*mistura*(3-2*mistura);
    var perto_w = chefe.cam_w/2.5;
    var perto_h = chefe.cam_h/2.5;
    camera_set_view_size(cam,lerp(chefe.cam_w,perto_w,mistura),lerp(chefe.cam_h,perto_h,mistura));
    camera_set_view_pos(cam,lerp(chefe.cam_x,0,mistura),lerp(chefe.cam_y,302-perto_h*0.5,mistura));
    return true;
}
#endregion
