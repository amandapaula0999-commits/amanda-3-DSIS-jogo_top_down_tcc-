#region Desempenho tick

function bunker_desempenho_tick() {
    // Ajusta a qualidade após uma queda ou recuperação prolongada de FPS.
    var leitura = fps_real;
    if (leitura > 0 && leitura < 28) {
        global.renderizacao.fps_baixo++;
        global.renderizacao.fps_bom = 0;
    } else if (leitura >= 48) {
        global.renderizacao.fps_bom++;
        global.renderizacao.fps_baixo = 0;
    } else {
        global.renderizacao.fps_baixo = max(0, global.renderizacao.fps_baixo - 1);
        global.renderizacao.fps_bom = max(0, global.renderizacao.fps_bom - 1);
    }

    if (global.config.qualidade_visual == 0 && global.renderizacao.fps_baixo >= 45) {
        global.config.qualidade_visual = 1;
        global.renderizacao.reconstruir_cenario = true;
    }
    if (global.config.qualidade_visual == 1 && global.renderizacao.fps_bom >= 300) {
        global.config.qualidade_visual = 0;
        global.renderizacao.reconstruir_cenario = true;
    }
}

#endregion
