#region Surgimento
if (estagio == 0) exit;
if (estagio == 1) {
    if (surgimento >= 60) {
        var quadro = clamp(floor((surgimento-60)/18),0,7);
        draw_sprite(Spr_cobra_surgindo,quadro,15,220);
    }
} else draw_self();
#endregion
