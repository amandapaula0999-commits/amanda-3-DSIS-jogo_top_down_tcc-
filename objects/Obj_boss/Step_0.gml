#region Ativação e pausa

if (!encontro_ativo) { visible=false; image_speed=0; exit; }
// Controla o ataque, o efeito do ácido e a fuga do Boss.
speed = 0;
if (global.interface.pause_aberto || global.interface.config_aberta || global.cena.ativa
|| global.interface.dialogo_ativo || global.interface.diario_aberto || global.cena.vitoria_ativa) {
    image_speed = 0;
    exit;
}

#endregion

#region Temporizadores

var passo = bunker_passo();
feedback_tempo = max(0, feedback_tempo - passo);
if (feedback_tempo <= 0) tomou_dano = false;
onda_tempo = max(0, onda_tempo - passo);
contato_espera = max(0, contato_espera - passo);
acido_recarga = max(0, acido_recarga - passo);
visible = (room == Room1);
if (!visible) exit;

#endregion

#region Derrota e fuga

if (vida <= 0 && !fugindo && !morto && !saida_impacto) {
    vida = 0;
    fugindo = true;
    derrotado = false;
    vulneravel_tempo = 0;
    ataque_ativo = false;
    alarm[0] = -1;
    fuga_etapa = 0;
    fuga_tempo = 0;
    rota_tempo = 0;
    feedback_tempo = 120;
    feedback_texto = "ELE ESTÁ ROMPENDO A CONTENÇÃO!";
}
if (fugindo) {
    fuga_tempo += passo;
    var fuga_antes_x = x;
    var fuga_antes_y = y;
    if (fuga_etapa == 0) {
        // Contorna os móveis e se alinha à passagem inferior.
        boss_mover(id, mapa_ponto("boss_fuga_preparo").x, mapa_ponto("boss_fuga_preparo").y, 3.5 * passo, passo);
        if (point_distance(x, y, mapa_ponto("boss_fuga_preparo").x, mapa_ponto("boss_fuga_preparo").y) <= 8) {
            fuga_etapa = 1;
            fuga_preparo = 24;
        }
    } else if (fuga_etapa == 1) {
        fuga_preparo -= passo;
        if (fuga_preparo <= 0) fuga_etapa = 2;
    } else if (fuga_etapa == 2) {
        // Avança até os escombros da porta.
        boss_deslocar(id, mapa_ponto("boss_fuga_impacto").x, mapa_ponto("boss_fuga_impacto").y, 4.5 * passo);
        if (point_distance(x, y, mapa_ponto("boss_fuga_impacto").x, mapa_ponto("boss_fuga_impacto").y) <= 7 && !saida_impacto) {
            saida_impacto = true;
            if (instance_exists(global.cena.boss_bloqueio)) instance_destroy(global.cena.boss_bloqueio);
            global.cena.boss_bloqueio = noone;
            boss_concluir();
            fuga_etapa = 3;
            feedback_tempo = 70;
            feedback_texto = "PASSAGEM LIBERADA";
        }
    } else {
        // Atravessa a porta aberta antes de deixar de existir na arena.
        boss_deslocar(id, mapa_ponto("boss_fuga_saida").x, mapa_ponto("boss_fuga_saida").y, 3.5 * passo);
        if (point_distance(x, y, mapa_ponto("boss_fuga_saida").x, mapa_ponto("boss_fuga_saida").y) <= 6) {
            instance_destroy();
            exit;
        }
    }
    boss_animar(id, x-fuga_antes_x, y-fuga_antes_y, passo);
    exit;
}
if (morto) {
    // Defesa para instâncias legadas: a carcaça verdadeira fica no corredor.
    instance_destroy();
    exit;
}

#endregion

#region Dano por ácido

// Uma poça só causa dano uma vez; o chefe não espera que ela evapore.
// A máscara precisa da poça exclui cantos transparentes. Só os pés ativam a queda.
var acido = collision_rectangle(x-acido_pe_meia_largura, y+acido_pe_topo,
    x+acido_pe_meia_largura, y+acido_pe_base, Obj_acido, true, true);
em_acido = (acido != noone);
if (!derrotado && acido_recarga <= 0 && em_acido && acido != acido_ultimo) {
    acido_ultimo = acido;
    vida = max(0, vida - 35);
    derrotado = true;
    vulneravel_tempo = 270; // 4,5 segundos de oportunidade para atacar.
    esperando_levantar = false;
    alarm[0] = -1;
    ataque_ativo = false;
    ataque_tempo = 0;
    contato_espera = 60;
    tomou_dano = true;
    feedback_tempo = 80;
    feedback_texto = "-35  CARAPAÇA ABERTA!";
}
if (derrotado) {
    vulneravel_tempo = max(0, vulneravel_tempo - passo);
    sprite_index = Spr_boss_caido;
    image_index = 0;
    image_speed = 0;
    if (vulneravel_tempo <= 0) {
        derrotado = false;
        acido_recarga = 120;
        contato_espera = 60;
        ataque_intervalo = 90;
        feedback_tempo = 60;
        feedback_texto = "ELE SE LEVANTOU - AFASTE-SE";
    }
    exit;
}

#endregion

#region Ataque

if (!instance_exists(Obj_jogador)) exit;
var jogador = instance_find(Obj_jogador, 0);
if (jogador.vida <= 0) { image_speed = 0; exit; }
ataque_intervalo = max(0, ataque_intervalo - passo);
if (!ataque_ativo && ataque_intervalo <= 0
&& point_distance(x, y+35, jogador.x, jogador.y) <= impacto_raio+25
&& collision_line(x, y, jogador.x, jogador.y, Obj_parede, false, true) == noone) {
    ataque_ativo = true;
    ataque_tempo = 0;
    impacto_aplicado = false;
    impacto_x = x;
    impacto_y = y + 35;
}
if (ataque_ativo) {
    ataque_tempo += passo;
    sprite_index = Spr_parado_baixo;
    image_speed = 0;
    image_index = 0;
    if (ataque_tempo < 18) ataque_quadro = 0;
    else if (ataque_tempo < 35) ataque_quadro = 1;
    else if (ataque_tempo < 54) ataque_quadro = 2;
    else if (ataque_tempo < 66) ataque_quadro = 3;
    else if (ataque_tempo < 82) ataque_quadro = 4;
    else ataque_quadro = 5;
    if (ataque_tempo >= 66 && !impacto_aplicado) {
        impacto_aplicado = true;
        bunker_impacto(impacto_x, impacto_y, impacto_raio);
        onda_tempo = 22;
    }
    if (ataque_tempo >= 106) {
        ataque_ativo = false;
        ataque_intervalo = 105;
        contato_espera = 35;
        image_index = 0;
    }
    exit;
}

#endregion

#region Perseguição

var anterior_x = x;
var anterior_y = y;
boss_mover(id, jogador.x, jogador.y, 1.65 * passo, passo);
boss_animar(id, x-anterior_x, y-anterior_y, passo);

#endregion
