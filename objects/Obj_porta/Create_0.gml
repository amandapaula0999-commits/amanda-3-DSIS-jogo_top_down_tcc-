#region Inicialização

// Destino, rótulo e limites locais são propriedades editáveis na Room.
mensagem_tempo = 0;
orientacao_falando = false;
orientacao_aviso_armado = true;
orientacao_texto = "É melhor falar com a secretária primeiro. Ainda não sei exatamente para onde devo ir.";
pulso_luz = random(100);
abrindo = false;
quadro_porta = 0;
velocidade_porta = 0.34;
espera_aberta = 5;
tempo_duto = 0;
mensagem_bloqueio = "FALE COM A SECRETARIA PRIMEIRO";
if (tipo_passagem == "escada" && room == Room_Corredor_Pos && global.config.encerrar_na_escadaria)
    rotulo = "ESCADARIA / FIM DESTA VERSÃO";
if (porta_boss) global.cena.boss_porta = id;

#endregion
