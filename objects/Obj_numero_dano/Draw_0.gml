// Somente texto dinâmico, com a fonte já usada no feedback da fase 1.
var fonte_anterior = draw_get_font();
var cor_anterior = draw_get_color();
var alpha_anterior = draw_get_alpha();
var h_anterior = draw_get_halign();
var v_anterior = draw_get_valign();
draw_set_font(Font_de_fala);
draw_set_halign(fa_center);
draw_set_valign(fa_bottom);
draw_set_alpha(clamp((duracao - tempo) / 0.20, 0, 1));
draw_set_color(c_black);
draw_text(x + 1, y + 1, texto);
draw_set_color(make_color_rgb(216,185,115));
draw_text(x, y, texto);
draw_set_font(fonte_anterior);
draw_set_color(cor_anterior);
draw_set_alpha(alpha_anterior);
draw_set_halign(h_anterior);
draw_set_valign(v_anterior);
