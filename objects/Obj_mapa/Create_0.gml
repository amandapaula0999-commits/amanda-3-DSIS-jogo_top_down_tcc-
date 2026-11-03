#region Inicialização

// Nome, objetivo e roteiro de teste são propriedades da instância na Room.
jogo_preparar_sala();
tutorial_arma_iniciar(id);
tempo_apresentacao = 240;
fade_entrada = 1;
tempo_visual = 0;
tempo_tela = 0;
armadilha_tempo = -1;
explosao_tocou = false;
indicio_x=[];indicio_y=[];indicio_texto=[];indicio_registro=[];
indicio_perto=-1;indicio_mensagem="";indicio_tempo=0;
func_interacao_proxima="";func_mensagem_tempo=0;func_feedback_frame=0;
bunker_configurar_tela();
espera_segundos = 0;
queda_x = 256; queda_y = 250;
if(room==Room_Armadilha) {global.cena.ativa=false;tempo_apresentacao=0;}
if(room==Room_Corredor_N2) global.progresso.fase2_visitada=true;
if(room==Room_Ferramentas_N2) {global.progresso.visitou_ferramentas=true;tempo_apresentacao=0;}

if (room == Room1) global.inventario.chave_coletada = true;

#endregion
