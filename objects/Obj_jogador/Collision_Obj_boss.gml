#region Colisão com boss

if (!other.encontro_ativo) exit;
// Dano de contato com o chefe
if (global.interface.pause_aberto || global.interface.config_aberta || global.cena.ativa || global.interface.dialogo_ativo || global.interface.diario_aberto) exit;
if (!invulneravel && !other.morto && !other.fugindo && other.vida > 0
&& !other.derrotado && !other.ataque_ativo && other.contato_espera <= 0) {
    vida = max(0, vida - 12);
    global.jogador.vida = vida;
    invulneravel = true;
    image_alpha = 0.35;
    bunker_alarme_definir(id, 90);

    var direcao_empurrao = point_direction(other.x, other.y, x, y);
    bunker_deslocar_seguro(id, lengthdir_x(18,direcao_empurrao), lengthdir_y(18,direcao_empurrao));
}

#endregion
