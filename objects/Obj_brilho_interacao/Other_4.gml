// Room Start: kits já coletados não existem mais; não deixam brilho órfão.
var tipo = tipo_alvo == "kit" ? Obj_kit_vida : Obj_porta;
for (var i = 0; i < instance_number(tipo); i++) {
    var candidato = instance_find(tipo, i);
    if (point_distance(x, y, candidato.x, candidato.y) < 1) {
        alvo = candidato;
        depth = candidato.depth + 1;
        break;
    }
}
if (!instance_exists(alvo)) instance_destroy();
