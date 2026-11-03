#region Pause layout

function bunker_pause_layout(_gw, _gh) {
    var _s = max(0.01, min(_gw * 0.92 / 1376, _gh * 0.92 / 768));
    return [_s, round(_gw * 0.5 - 688 * _s), round(_gh * 0.5 - 384 * _s)];
}

#endregion

#region Pause cartoes

function bunker_pause_cartoes() {
    return [[780, 780, 780, 174], [182, 255, 325, 255],
        [238, 307, 376, 307], [320, 320, 320, 224],
        [110, 110, 110, 104], [1.45, 1.45, 1.45, 1.35], 12];
}

#endregion

#region Pause recorte

function bunker_pause_recorte() {
    var _p = [[618,288],[659,291],[858,307],[889,315],[1258,309],
        [1283,315],[1304,334],[1296,448],[1325,453],[1354,469],
        [1360,489],[1353,508],[1324,522],[1291,520],[1286,637],
        [1277,656],[1264,666],[903,656],[874,649],[590,626],
        [574,613],[565,595],[567,557],[593,335],[602,311],[611,297]];
    var _faixas = [];
    for (var _y = 288; _y < 666; _y++) {
        var _xs = [];
        for (var _i = 0; _i < array_length(_p); _i++) {
            var _a = _p[_i];
            var _b = _p[(_i + 1) % array_length(_p)];
            var _ym = _y + 0.5;
            if ((_a[1] <= _ym && _b[1] > _ym) || (_b[1] <= _ym && _a[1] > _ym)) {
                var _x = _a[0] + (_ym - _a[1]) * (_b[0] - _a[0]) / (_b[1] - _a[1]);
                // Inserção ordenada: também lida com concavidades no contorno.
                var _j = array_length(_xs);
                _xs[_j] = _x;
                while (_j > 0 && _xs[_j - 1] > _x) {
                    _xs[_j] = _xs[_j - 1];
                    _j--;
                }
                _xs[_j] = _x;
            }
        }
        for (var _k = 0; _k + 1 < array_length(_xs); _k += 2) {
            var _l = ceil(_xs[_k]);
            var _r = floor(_xs[_k + 1]);
            if (_r > _l) _faixas[array_length(_faixas)] = [_l, _y, _r - _l];
        }
    }
    return _faixas;
}

#endregion

#region Pause couro

function bunker_pause_couro(_faixas, _ox, _oy, _s) {
    for (var _i = 0; _i < array_length(_faixas); _i++) {
        var _f = _faixas[_i];
        // Limites inteiros compartilhados evitam frestas entre linhas na GUI.
        var _y1 = round(_oy + _f[1] * _s);
        var _y2 = round(_oy + (_f[1] + 1) * _s);
        if (_y2 > _y1) draw_sprite_part_ext(Spr_menu_fundo, 0, _f[0], _f[1], _f[2], 1,
            _ox + _f[0] * _s, _y1, _s, _y2 - _y1, c_white, 1);
    }
}

#endregion

#region Cartao bloco

function bunker_cartao_bloco(_x,_y,_sx,_sy,_h,_a,_b,_c,_d,_cor) {
    _b=max(0,_b);_d=min(_h,_d);
    if(_d<=_b || _c<=_a) return;
    draw_set_color(_cor);
    draw_rectangle(round(_x+_a*_sx),round(_y+_b*_sy),round(_x+_c*_sx),round(_y+_d*_sy),false);
}

#endregion

#region Cartao letras

function bunker_cartao_letras(_tipo) {
    if(_tipo==0) return [[7, 2, 2, 2, 18, 18, 12, 0], [14, 17, 17, 17, 17, 17, 14, 0], [15, 16, 16, 23, 17, 17, 15, 0], [14, 17, 17, 31, 17, 17, 17, 0], [30, 17, 17, 30, 20, 18, 17, 0]];
    if(_tipo==1) return [[15, 16, 16, 16, 16, 16, 15, 0], [14, 17, 17, 17, 17, 17, 14, 0], [17, 25, 25, 21, 19, 19, 17, 0], [31, 4, 4, 4, 4, 4, 4, 0], [30, 17, 17, 30, 20, 18, 17, 0], [14, 17, 17, 17, 17, 17, 14, 0], [16, 16, 16, 16, 16, 16, 31, 0], [31, 16, 16, 30, 16, 16, 31, 0], [15, 16, 16, 14, 1, 1, 30, 0]];
    if(_tipo==2) return [[15, 16, 16, 16, 16, 16, 15, 0], [14, 17, 17, 17, 17, 17, 14, 0], [17, 25, 25, 21, 19, 19, 17, 0], [31, 16, 16, 30, 16, 16, 16, 0], [31, 4, 4, 4, 4, 4, 31, 0], [15, 16, 16, 23, 17, 17, 15, 0], [17, 17, 17, 17, 17, 17, 14, 0], [30, 17, 17, 30, 20, 18, 17, 0], [14, 17, 17, 31, 17, 17, 17, 0], [15, 16, 16, 16, 16, 16, 15, 1], [14, 17, 17, 17, 17, 17, 14, 2], [31, 16, 16, 30, 16, 16, 31, 0], [15, 16, 16, 14, 1, 1, 30, 0]];
    if(_tipo==3) return [[15, 16, 16, 14, 1, 1, 30, 0], [14, 17, 17, 31, 17, 17, 17, 0], [31, 4, 4, 4, 4, 4, 31, 0], [30, 17, 17, 30, 20, 18, 17, 0]];
    if(_tipo==4) return [[15, 16, 16, 16, 16, 16, 15, 0], [14, 17, 17, 17, 17, 17, 14, 0], [17, 25, 25, 21, 19, 19, 17, 0], [31, 4, 4, 4, 4, 4, 4, 0], [31, 4, 4, 4, 4, 4, 31, 0], [17, 25, 25, 21, 19, 19, 17, 0], [17, 17, 17, 17, 17, 17, 14, 0], [14, 17, 17, 31, 17, 17, 17, 0], [30, 17, 17, 30, 20, 18, 17, 0]];
    if(_tipo==5) return [[30, 17, 17, 30, 20, 18, 17, 0], [31, 16, 16, 30, 16, 16, 31, 0], [15, 16, 16, 16, 16, 16, 15, 0], [14, 17, 17, 17, 17, 17, 14, 0], [17, 27, 21, 21, 17, 17, 17, 0], [31, 16, 16, 30, 16, 16, 31, 0], [15, 16, 16, 16, 16, 16, 15, 1], [14, 17, 17, 31, 17, 17, 17, 0], [30, 17, 17, 30, 20, 18, 17, 0]];
    return [];
}

#endregion

#region Cartao desenhar

function bunker_cartao_desenhar(_tipo,_x,_y,_sx,_sy,_w,_h,_selecionado) {
    gpu_set_texfilter(false);draw_set_alpha(1);
    var _borda=make_color_rgb(27,19,14);
    var _ouro=make_color_rgb(195,147,65);
    var _luz=make_color_rgb(241,206,142);
    var _papel=make_color_rgb(194,165,117);
    var _base=make_color_rgb(45,67,78);
    var _sombra=make_color_rgb(25,41,51);
    var _texto=make_color_rgb(249,225,178);
    if(_tipo==1 || _tipo==5) {_base=_papel;_sombra=make_color_rgb(153,119,74);_texto=make_color_rgb(49,33,23);}
    if(_tipo==2) {_base=make_color_rgb(139,114,60);_sombra=make_color_rgb(95,74,34);}
    if(_tipo==3) {_base=make_color_rgb(126,49,35);_sombra=make_color_rgb(78,31,23);}
    // Cartão opaco até a borda: também serve à animação de saída em tela cheia.
    bunker_cartao_bloco(_x,_y,_sx,_sy,_h,0,0,_w,110,_borda);
    bunker_cartao_bloco(_x,_y,_sx,_sy,_h,3,3,_w-3,107,_sombra);
    bunker_cartao_bloco(_x,_y,_sx,_sy,_h,4,4,_w-6,103,_base);
    bunker_cartao_bloco(_x,_y,_sx,_sy,_h,4,3,_w-4,5,_selecionado ? _luz : _ouro);
    bunker_cartao_bloco(_x,_y,_sx,_sy,_h,3,5,5,103,_ouro);
    bunker_cartao_bloco(_x,_y,_sx,_sy,_h,6,36,_w-8,38,_sombra);
    bunker_cartao_bloco(_x,_y,_sx,_sy,_h,9,40,_w-10,41,_ouro);
    // Marcas discretas no papel/crachá, sempre longe das letras.
    for(var _i=0;_i<14;_i++) {
        var _px=10+((_i*43) % (_w-24));var _py=48+((_i*17) % 43);
        bunker_cartao_bloco(_x,_y,_sx,_sy,_h,_px,_py,_px+4,_py+2,_sombra);
    }
    for(var _costura=12;_costura<_w-12;_costura+=16)
        bunker_cartao_bloco(_x,_y,_sx,_sy,_h,_costura,96,_costura+7,98,_ouro);
    // Pequeno emblema com a mesma tinta e moldura do título.
    bunker_cartao_bloco(_x,_y,_sx,_sy,_h,10,8,35,33,_borda);
    bunker_cartao_bloco(_x,_y,_sx,_sy,_h,12,10,33,31,_ouro);
    bunker_cartao_bloco(_x,_y,_sx,_sy,_h,14,12,31,29,_sombra);
    var _icone=[0,0,0,0,0,0,0];
    if(_tipo==0 || _tipo==4) _icone=[16,24,28,30,28,24,16];
    if(_tipo==1) _icone=[14,31,21,31,17,0,0];
    if(_tipo==2) _icone=[10,31,14,27,14,31,10];
    if(_tipo==3) _icone=[24,20,23,21,23,20,24];
    if(_tipo==5) _icone=[14,17,16,23,21,5,2];
    for(var _iy=0;_iy<7;_iy++) for(var _ix=0;_ix<5;_ix++)
        if((_icone[_iy] & (1 << (4-_ix)))!=0)
            bunker_cartao_bloco(_x,_y,_sx,_sy,_h,17+_ix*2,13+_iy*2,19+_ix*2,15+_iy*2,_luz);
    // Letra de bloco 5x7, com cedilha e til próprios: a mesma nos dois menus.
    var _letras=bunker_cartao_letras(_tipo);
    var _inicio=floor((40+_w-(array_length(_letras)*18-3))*0.5);
    for(var _li=0;_li<array_length(_letras);_li++) {
        var _g=_letras[_li];var _gx=_inicio+_li*18;
        for(var _gy=0;_gy<7;_gy++) {
            var _col=0;
            while(_col<5) {
                if((_g[_gy] & (1 << (4-_col)))==0) {_col++;continue;}
                var _comeco=_col;
                while(_col<5 && (_g[_gy] & (1 << (4-_col)))!=0) _col++;
                bunker_cartao_bloco(_x,_y,_sx,_sy,_h,_gx+_comeco*3+1,10+_gy*3,_gx+_col*3+1,13+_gy*3,_sombra);
                bunker_cartao_bloco(_x,_y,_sx,_sy,_h,_gx+_comeco*3,9+_gy*3,_gx+_col*3,12+_gy*3,_texto);
            }
        }
        if(_g[7]==1) bunker_cartao_bloco(_x,_y,_sx,_sy,_h,_gx+6,30,_gx+9,33,_texto);
        if(_g[7]==2) {
            bunker_cartao_bloco(_x,_y,_sx,_sy,_h,_gx+3,5,_gx+8,7,_texto);
            bunker_cartao_bloco(_x,_y,_sx,_sy,_h,_gx+8,6,_gx+12,8,_texto);
        }
    }
    draw_set_color(c_white);draw_set_alpha(1);
}

#endregion
