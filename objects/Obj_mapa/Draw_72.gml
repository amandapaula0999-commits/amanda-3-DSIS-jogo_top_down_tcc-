#region Preparar o desenho

// Draw Begin: elimina resíduos do frame/sala anterior em todo o render target.
if (room == Room_Armadilha || room == Room_Saida_Final) {
    draw_clear(c_black);
}

#endregion
