#region Pausa e tempo

if (bunker_jogo_bloqueado()) {
    image_speed = 0;
    exit;
}
var passo = bunker_passo();
if (bunker_alarme_passo(id,passo)) event_perform(ev_alarm,0);

#endregion

#region Posição inicial

if (conferir_nascimento) {
    inimigo_conferir_nascimento(id);
    alvo_x = x; alvo_y = y;
    posicao_inicial_x = x; posicao_inicial_y = y;
    patrulha_alvo_x = x; patrulha_alvo_y = y;
}

#endregion

#region Dano e morte

if (feedback_tempo > 0) feedback_tempo = max(0, feedback_tempo - passo);
if (takedown_ativo) {
    estado = "TAKEDOWN";
    alerta = 0;
    image_speed = 0;
    sprite_index = Spr_inimigo_parado_baixo;
    image_index = 0;
    exit;
}
if (vida <= 0 && variable_instance_exists(id,"guarda_arquivo") && guarda_arquivo) global.progresso.arquivo_livre=true;
if (vida <= 0 && !morrendo) {
    vida = 0;
    morrendo = true;
    estado = "DERROTADO";
    sprite_index = Spr_inimigo_morte;
    image_index = 0;
    image_speed = 0;
    tomou_dano = false;
}
if (morrendo) {
    morte_frame = min(3, morte_frame + 0.105 * passo);
    image_index = floor(morte_frame);
    if (morte_frame >= 3) {
        morte_espera += passo;
        if (morte_espera > 24) image_alpha = max(0, image_alpha - 0.035 * passo);
        if (image_alpha <= 0) instance_destroy();
    }
    exit;
}

#endregion

#region Percepção do jogador

if (!instance_exists(Obj_jogador)) exit;
var jogador = instance_find(Obj_jogador, 0);
var dist = point_distance(x, y, jogador.x, jogador.y);
velocidade = max(0, jogador.max_vel - 1);
velocidade_chase = velocidade;
if (caracol_ataque_atualizar(id, jogador, passo)) exit;
var vendo = bunker_visivel(x, y, direcao_atual, jogador.x, jogador.y, jogador.furtivo);
var ouvindo_passos = jogador.ruido_passos > 0 && dist <= jogador.ruido_passos
    && collision_line(x, y, jogador.x, jogador.y, Obj_parede, false, true) == noone;
if (vendo) {
    alerta = min(100, alerta + (jogador.furtivo ? 1.8 : 3.3) * passo);
    alvo_x = jogador.x;
    alvo_y = jogador.y;
    memoria_visual = 105;
} else {
    alerta = max(0, alerta - 0.7 * passo);
    if (memoria_visual > 0) memoria_visual = max(0, memoria_visual - passo);
}
if (ouvindo_passos && !vendo && estado != "PERSEGUINDO") {
    alerta = min(99, alerta + 1.4 * passo);
    alvo_x = jogador.x;
    alvo_y = jogador.y;
    estado = "INVESTIGANDO";
    busca_tempo = 150;
}
// Ruídos revelam a origem do som, sem revelar a posição futura do jogador.
if (global.ruido.tempo > 0 && ultimo_ruido != global.ruido.serial
&& point_distance(x, y, global.ruido.x, global.ruido.y) <= global.ruido.raio) {
    ultimo_ruido = global.ruido.serial;
    alvo_x = global.ruido.x;
    alvo_y = global.ruido.y;
    alerta = max(alerta, 55);
    if (estado != "PERSEGUINDO") estado = "INVESTIGANDO";
    busca_tempo = 180;
}
if (tomou_dano && estado != "PERSEGUINDO") {
    estado = "INVESTIGANDO";
    busca_tempo = 180;
    alerta = max(alerta, 65);
}
if (alerta >= 100) estado = "PERSEGUINDO";
if (estado == "PERSEGUINDO" && memoria_visual <= 0) {
    estado = "INVESTIGANDO";
    busca_tempo = 180;
}

#endregion

#region Patrulha e perseguição

var antes_x = x;
var antes_y = y;
switch (estado) {
    case "PATRULHA":
        // Alterna destinos diagonais para variar a patrulha.
        if (tempo_parado > 0) tempo_parado = max(0, tempo_parado - passo);
        patrulha_tempo = max(0, patrulha_tempo - passo);
        if (patrulha_tempo <= 0 || point_distance(x, y, patrulha_alvo_x, patrulha_alvo_y) < 14) {
            var patrulha_direcoes = [0, 35, 80, 125, 170, 215, 260, 305];
            var indice_rota = (patrulha_indice + floor(abs(x + y)) mod 8) mod 8;
            var distancia_rota = 90 + ((floor(abs(x * 7 + y * 11)) + patrulha_indice * 29) mod 150);
            direcao_atual = patrulha_direcoes[indice_rota];
            patrulha_alvo_x = clamp(x + lengthdir_x(distancia_rota, direcao_atual), 72, room_width - 72);
            patrulha_alvo_y = clamp(y + lengthdir_y(distancia_rota, direcao_atual), 88, room_height - 72);
            if(variable_instance_exists(id,"guarda_arquivo") && guarda_arquivo) {
                patrulha_alvo_x=clamp(patrulha_alvo_x,1150,1280);
                patrulha_alvo_y=clamp(patrulha_alvo_y,430,600);
            }
            patrulha_indice = (patrulha_indice + 3) mod 8;
            patrulha_tempo = 110 + (patrulha_indice * 17);
            tempo_parado = 12 + (patrulha_indice mod 24);
        }
        if (tempo_parado <= 0) bunker_caracol_mover(patrulha_alvo_x, patrulha_alvo_y, velocidade, passo);
        break;
    case "PERSEGUINDO":
        bunker_caracol_mover(alvo_x, alvo_y, velocidade_chase, passo);
        break;
    case "INVESTIGANDO":
        var busca_anterior = busca_tempo;
        busca_tempo = max(0, busca_tempo - passo);
        if (point_distance(x, y, alvo_x, alvo_y) > 12) {
            bunker_caracol_mover(alvo_x, alvo_y, velocidade, passo);
        } else if (floor(busca_anterior / 40) > floor(busca_tempo / 40)) direcao_atual = (direcao_atual + 90) mod 360;
        if (busca_tempo <= 0 && !vendo) estado = "VOLTANDO";
        break;
    case "VOLTANDO":
        bunker_caracol_mover(posicao_inicial_x, posicao_inicial_y, velocidade, passo);
        if (point_distance(x, y, posicao_inicial_x, posicao_inicial_y) < 8) {
            estado = "PATRULHA";
            tempo_parado = 80;
        }
        break;
}

#endregion

#region Animação

speed = 0;
var dx = x - antes_x;
var dy = y - antes_y;
var movendo = abs(dx) + abs(dy) > 0.01;
if (movendo) direcao_atual = point_direction(antes_x, antes_y, x, y);
lado_anim = floor((direcao_atual + 45) / 90) mod 4;
// Troca entre caminhada e repouso sem reiniciar a animação.
var sprite_alvo = Spr_inimigo_parado_baixo;
switch (lado_anim) {
    case 0: sprite_alvo = movendo ? Spr_inimigo_andando_direita : Spr_inimigo_parado_direita; break;
    case 1: sprite_alvo = movendo ? Spr_inimigo_andando_cima : Spr_inimigo_parado_cima; break;
    case 2: sprite_alvo = movendo ? Spr_inimigo_andando_esquerda : Spr_inimigo_parado_esquerda; break;
    case 3: sprite_alvo = movendo ? Spr_inimigo_andando_baixo : Spr_inimigo_parado_baixo; break;
}
if (sprite_index != sprite_alvo) {
    sprite_index = sprite_alvo;
    image_index = 0;
}
bunker_animacao_passo(id, movendo ? 1 : 0, passo);
if (!movendo) image_index = 0;

#endregion
