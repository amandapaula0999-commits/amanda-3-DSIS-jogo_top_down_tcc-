// Teste de lógica: executa o subconjunto compatível com JS dos scripts GML reais.
// Não substitui a compilação nem a execução no GameMaker.
const fs=require('fs'), vm=require('vm'), assert=require('assert');
const engine={global:{},room:10,room_width:640,room_height:360,Room1:90,noone:-4,
 variable_global_exists(n){return Object.hasOwn(engine.global,n)},
 variable_instance_exists(o,n){return Object.hasOwn(o,n)},
 room_get_name(r){return 'Room_'+r}, ini_open(){},ini_write_string(){},ini_write_real(){},ini_close(){},
 instance_activate_all(){},audio_resume_all(){},room_restart(){engine.restarted=true},room_goto(r){engine.destination=r}};
vm.createContext(engine);
const path=require('path');
const root=path.resolve(__dirname,'../..');
let source=fs.readFileSync(path.join(root,'scripts/Scr_estado_jogo/Scr_estado_jogo.gml'),'utf8');
const progressao=['Scr_checkpoints','Scr_passagens'].map(name =>
 fs.readFileSync(path.join(root,'scripts',name,name+'.gml'),'utf8')).join('\n');
for(const name of ['checkpoint_gravar','checkpoint_reiniciar','passagem_liberada']) {
 const start=progressao.indexOf('function '+name+'(');
 const end=progressao.indexOf('\n}',start)+2;
 source+='\n'+progressao.slice(start,end);
}
vm.runInContext(source,engine);
const g=engine.global, results=[];
function test(name,fn){fn();results.push('PASSOU: '+name)}
test('Inicialização antes dos eventos, campos do estado definidos',()=>{
 const fields={"config": ["musica_muda", "efeitos_mudos", "qualidade_visual", "portas_livres", "encerrar_na_escadaria"], "progresso": ["armadilha_concluida", "boss_derrotado", "secretaria_orientou", "visitou_ferramentas", "deposito_ajuda_ouvida", "funcionarios_chaves_coletadas", "camara_fria_aberta", "arquivo_livre", "fase2_visitada", "coletas_municao", "evidencias", "laboratorio_inimigos_derrotados", "laboratorio_leituras"], "inventario": ["cano", "arma_pregos", "cartao_pesquisa", "pe_cabra", "chave_ferramentas", "chave_arquivo", "chave_escadaria", "chave_coletada", "equipamento_ativo", "pregos_carregados", "pregos_reserva", "caixas_municao"], "jogador": ["vida"], "checkpoint": ["sala", "x", "y", "gravar_na_entrada", "respawn_pendente"], "transicao": ["sala_destino", "x", "y", "queda_pendente", "duto_ativo"], "interface": ["dialogo_ativo", "diario_aberto", "diario_pagina", "pause_aberto", "pause_selecionado", "config_aberta", "config_origem", "config_selecionado", "creditos_scroll", "creditos_ativos"], "cena": ["ativa", "armadilha_explodiu", "vitoria_ativa", "vitoria_tempo", "saida_aberta", "boss_etapa", "boss_tempo", "boss_instancia", "boss_porta", "boss_bloqueio", "boss_foco_inicial_x", "boss_foco_inicial_y", "entulho_perto", "entulho_mensagem_tempo"], "camera": ["zoom", "foco_x", "foco_y", "largura", "altura"], "audio": ["estado", "desejado", "ganho", "musica_instancia", "trilha_recurso"], "ruido": ["serial", "tempo", "x", "y", "raio"], "renderizacao": ["fps_baixo", "fps_bom", "reconstruir_cenario"], "recursos": ["cano_geometria"]};
 assert.equal(Object.keys(g).length,13);
 for(const [group,names] of Object.entries(fields)) for(const name of names) assert(Object.hasOwn(g[group],name),group+'.'+name);
 assert.equal(g.jogador.vida,100);assert.equal(g.checkpoint.sala,-1);
});
test('Inicialização repetida não apaga progresso ou inventário',()=>{
 g.inventario.pe_cabra=true;g.inventario.chave_escadaria=true;g.jogador.vida=42;
 g.progresso.evidencias.push({codigo:'teste'});engine.jogo_estado_iniciar(false);
 assert(g.inventario.pe_cabra);assert.equal(g.jogador.vida,42);assert.equal(g.progresso.evidencias.length,1);
});
test('Troca de sala limpa bloqueios temporários e preserva entrada e checkpoint',()=>{
 engine.checkpoint_gravar(20,123,234);g.transicao.sala_destino=30;g.transicao.x=80;
 g.transicao.queda_pendente=true;g.checkpoint.gravar_na_entrada=true;
 g.interface.dialogo_ativo=true;g.cena.ativa=true;g.ruido.tempo=100;
 engine.jogo_preparar_sala();
 assert(g.inventario.pe_cabra);assert.equal(g.jogador.vida,42);assert.equal(g.checkpoint.sala,20);
 assert.equal(g.transicao.sala_destino,30);assert.equal(g.transicao.x,80);
 assert(g.transicao.queda_pendente);assert(g.checkpoint.gravar_na_entrada);
 assert(!g.interface.dialogo_ativo);assert(!g.cena.ativa);assert.equal(g.ruido.tempo,0);
 assert.equal(g.camera.foco_x,320);assert.equal(g.camera.foco_y,180);
});
test('Morte retorna ao checkpoint em outra sala, mantendo os itens',()=>{
 engine.checkpoint_reiniciar();assert.equal(engine.destination,20);
 assert.equal(g.transicao.x,123);assert.equal(g.transicao.y,234);
 assert.equal(g.jogador.vida,100);assert(g.checkpoint.respawn_pendente);assert(g.inventario.pe_cabra);
});
test('Morte na sala do checkpoint reinicia a mesma sala',()=>{
 engine.room=20;engine.checkpoint_reiniciar();assert(engine.restarted);
});
test('Portas de ferramentas e laboratório mantêm requisitos mesmo em modo teste',()=>{
 g.config.portas_livres=true;
 assert(!engine.passagem_liberada({chave_exigida:'ferramentas'}));
 g.inventario.chave_ferramentas=true;assert(engine.passagem_liberada({chave_exigida:'ferramentas'}));
 assert(!engine.passagem_liberada({chave_exigida:'laboratorio'}));
 g.inventario.cartao_pesquisa=true;assert(engine.passagem_liberada({chave_exigida:'laboratorio'}));
});
test('Escadaria exige chave e Boss vencido quando as travas normais estão ativas',()=>{
 g.config.portas_livres=false;g.inventario.chave_escadaria=true;g.progresso.boss_derrotado=false;
 assert(!engine.passagem_liberada({chave_exigida:'escadaria'}));
 g.progresso.boss_derrotado=true;assert(engine.passagem_liberada({chave_exigida:'escadaria'}));
});
test('Nova partida reinicia progresso, arrays e inventário, conservando preferências',()=>{
 const oldEvidence=g.progresso.evidencias,cache=g.recursos;
 g.config.musica_muda=true;g.config.efeitos_mudos=true;
 engine.jogo_estado_iniciar(true);
 assert(!g.inventario.pe_cabra);assert(!g.inventario.chave_escadaria);assert.equal(g.progresso.evidencias.length,0);
 assert.notEqual(g.progresso.evidencias,oldEvidence);assert.equal(g.checkpoint.sala,-1);
 assert(g.config.musica_muda);assert(g.config.efeitos_mudos);assert.equal(g.recursos,cache);
 assert.equal(g.inventario.pregos_carregados,4);assert.equal(g.transicao.sala_destino,-1);
});
console.log(results.join('\n'));
