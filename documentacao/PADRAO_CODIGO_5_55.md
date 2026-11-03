# Código padronizado — versão 5.55

Base: projeto completo 5.54.

## Alterações

- Os 127 arquivos GML usam regiões com títulos curtos em português.
- Eventos grandes foram divididos por responsabilidade, como movimento, colisão, coleta e diálogo.
- As marcações com barras e traços foram trocadas por `#region Nome` e `#endregion`.
- Comentários extensos foram resumidos. Comentários úteis sobre unidades de tempo, ordem dos eventos e regras de colisão foram mantidos.
- Foram corrigidos erros de escrita nos comentários. Os nomes de recursos, funções e variáveis foram preservados.

As linhas inteiras de comentário passaram de 351 para 249. As novas regiões totalizam 277, incluindo as regiões internas dos eventos.

## Exemplo do checkpoint

```gml
#region Ativação do checkpoint

// Se o checkpoint salvo no jogador ainda não for este objeto
if (other.checkpoint_x != x || other.checkpoint_y != y) {
    // Salva este ponto para o jogador renascer.
    other.checkpoint_x = x;
    other.checkpoint_y = y;
    checkpoint_gravar(room,x,y);
    bunker_audio_tocar_efeito(Snd_checkpoint, 14, false);
}

#endregion
```

## Padrão para continuar o projeto

1. Use uma região por função ou por bloco de responsabilidade do evento.
2. Dê um nome curto à região, como `Movimento e colisão`.
3. Escreva comentários curtos para explicar uma regra importante.
4. Evite repetir a instrução em palavras ou incluir o histórico das versões no comentário.
5. Mantenha informações úteis, como a unidade de um temporizador ou o motivo de uma proteção de colisão.

## O que foi preservado

O jogo continua com as salas, sprites, sons, diálogos, controles, valores, nomes e instruções da versão 5.54. A organização com regiões só muda a leitura e o recolhimento dos blocos no editor.

## Verificação

Os tokens de código dos 127 arquivos foram comparados com os do ZIP original, preservando também os textos entre aspas. A comparação ignora somente comentários, regiões e espaços. Todos são idênticos.

Também foram conferidos o fechamento das regiões e os arquivos de metadados. Os demais arquivos da base foram comparados byte a byte antes da atualização do LEIA_ME, VERSAO e número de versão do Windows.

Esta é uma verificação estática. Compilação e execução no GameMaker pendentes.
