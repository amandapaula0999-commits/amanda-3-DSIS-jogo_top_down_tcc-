#region Desenho

if (colisao_ativa) {
    draw_self();
} else if (global.cena.boss_etapa > 0 && global.cena.boss_tempo >= 102 && global.cena.boss_tempo < 116) {
    var queda = (global.cena.boss_tempo - 102) * 8;
    draw_sprite_ext(Spr_entulho_arena,0,x,y - altura - 18 + queda,
        image_xscale,image_yscale,0,c_white,1);
}

#endregion
