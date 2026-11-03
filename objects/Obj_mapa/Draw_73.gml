#region Final do desenho

// Aplica a iluminação no Draw End, antes da interface.
gpu_set_blendmode(bm_normal);
draw_set_alpha(1);
draw_set_color(c_black);
var sombra = 0.30;
if (room == Room_Corredor_Pos) sombra = 0; // Sombras integradas na arte.
if (room == Room_Biblioteca || room == Room_Pesquisa || room == Room_Desmoronada || room == Room_Corredor) sombra = 0; // Paleta já sombreada no sprite.
// O cenário já tem sombras; evita escurecer duas vezes.
if (room == Room_Manutencao_N2 || room == Room_Funcionarios) sombra = 0;
if (room == Room_Laboratorio_N2 || room == Room_Corredor_N2 || room == Room_Ferramentas_N2) sombra = 0;
if (room == Room_Externa) sombra = 0.08;
if (room == Room_Recepcao) sombra = 0; // Luz acolhedora já faz parte do sprite.
if (room == Room_Armadilha) sombra = 0; // Usa as cores do sprite.
if (room == Room1) sombra = 0; // O sombreado já faz parte do cenário.
draw_set_alpha(sombra);
draw_rectangle(0, 0, room_width, room_height, false);
draw_set_alpha(1);
draw_set_color(c_white);
gpu_set_blendmode(bm_normal);

#endregion
