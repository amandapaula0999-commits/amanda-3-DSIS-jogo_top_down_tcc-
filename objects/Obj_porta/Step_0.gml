if (room == Room_Laboratorio_N2 && instance_exists(Obj_boss_cobra) && Obj_boss_cobra.estagio > 0) exit;
#region Atualização

// Usa a porta com E e salva o estado antes da troca de room
if (global.interface.pause_aberto || global.interface.diario_aberto || global.interface.config_aberta) exit;
if (porta_orientacao_recepcao(id)) exit;
if (variable_instance_exists(id,"tipo_passagem") && tipo_passagem!="porta") {
    passagem_atualizar(id);
    exit;
}
pulso_luz += 0.06 * bunker_passo();
if (mensagem_tempo > 0) mensagem_tempo = max(0,mensagem_tempo-bunker_passo());

visual_bunker = (
    room == Room_Desmoronada
    || room == Room_Corredor_Pos
    || room == Room_Corredor_N2
    || room == Room_Funcionarios
    || room == Room_Corredor
    || room == Room_Pesquisa
    || room == Room_Biblioteca
    || room == Room1
);
visual_restrita = visual_bunker && (room == Room1 || destino == Room1);

// Mostra o último quadro por 5/60 s antes de trocar de sala.
if (abrindo) {
    var sprite_animacao = visual_restrita ? Spr_porta_bunker_restrita : Spr_porta_bunker_comum;
    var quadro_final = sprite_get_number(sprite_animacao) - 1;
    if (quadro_porta < quadro_final) {
        quadro_porta = min(quadro_final, quadro_porta + velocidade_porta * bunker_passo());
    } else {
        espera_aberta = max(0,espera_aberta-bunker_passo());
        if (espera_aberta <= 0) {
            // Obj_mapa da próxima sala libera o controle no Create.
            if(variable_instance_exists(id,"saida_final") && saida_final) {
                abrindo=false;
                bunker_vitoria_iniciar(x,y);
            } else room_goto(destino);
        }
    }
    exit;
}

if (global.cena.ativa || global.interface.dialogo_ativo) exit;

var jogador = instance_nearest(x, y, Obj_jogador);
// As aberturas entre recepção e corredor são atravessadas a pé.
var passagem_aberta = (room == Room_Recepcao && destino == Room_Corredor_Recepcao)
    || (room == Room_Corredor_Recepcao && destino == Room_Recepcao && chave_exigida != "fechada");
if (ativa && bunker_porta_em_alcance(id, jogador)) {
    if (passagem_aberta || bunker_interagir()) {
        if (!passagem_liberada(id)) {
            mensagem_tempo=180;
            if (chave_exigida == "fechada") {
                mensagem_bloqueio = "ESTA PORTA ESTÁ TRANCADA.";
            } else if (chave_exigida == "laboratorio") {
                mensagem_bloqueio = "PRECISO DE UM CRACHÁ DE ACESSO PARA ENTRAR NA SALA DE PESQUISA.";
            } else if (chave_exigida == "pe_cabra") {
                mensagem_bloqueio = "PRECISO DO PÉ DE CABRA PARA ABRIR A SALA FRIA";
            } else if (chave_exigida == "ferramentas") {
                mensagem_bloqueio = "PRECISO DA CHAVE DA SALA DE FERRAMENTAS";
            } else if (chave_exigida == "cientista") {
                mensagem_bloqueio = "PRECISO DA CHAVE DO CIENTISTA";
            } else if (global.inventario.chave_escadaria) {
                mensagem_bloqueio = "PRECISO LIBERAR A SAÍDA DA ARENA";
            } else {
                mensagem_bloqueio = "PRECISO DA CHAVE DA SALA DO BOSS";
            }
            bunker_audio_tocar_efeito(Snd_luz_negada,15,false);
        } else if (requer_orientacao && !global.progresso.secretaria_orientou && !(global.config.portas_livres)) {
            mensagem_tempo = 150;
            bunker_audio_tocar_efeito(Snd_luz_negada, 15, false);
        } else {
            global.jogador.vida = jogador.vida;
            global.inventario.caixas_municao = jogador.caixas_mecanicas;
            duto_registrar_saida(destino);
            mapa_agendar_entrada(destino,ponto_destino);
            bunker_audio_tocar_efeito(Snd_porta, 12, false);
            if (visual_bunker && !visual_estatico) {
                ativa = false;
                abrindo = true;
                quadro_porta = 0;
                espera_aberta = 5;
                global.cena.ativa = true;
            } else {
                room_goto(destino);
            }
        }
    }
}

#endregion
