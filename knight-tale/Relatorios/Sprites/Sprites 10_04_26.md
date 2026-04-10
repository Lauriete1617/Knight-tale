# Relatório script player #

**Marilu** | **10/04/26**

Eu parei de produzir sprites por um tempo para agilizar a parte tecnica do jogo, então, percebi uma coisa:
- 2 personagems jogáveis;
- Atualmente cinco items, o que provavelmente vai aumentar depois;
- Várias animações de andar com cada item na mão;

Até o momento, estávamos fazendo animações com items e corpos acoplados no mesmo sprite. Então, teriamos que fazer muitos sprites para cada personagem com movimentos diferentes enquanto segura cada um dos items. 
Seria muito trabalho, muitas animações, atrasaria o jogo, teria que adicionar muita coisa nos scripts, em outras palavras, muito ineficaz e até não profissional. 
O objetivo do jogo é aprender, não ser realmente profissional, mas também não dá para aprender sendo desleixado.

Pensei, como os desenvolvedores profissionais de jogos com multiplos personagems e items fazem? Percebi que eles provavelmente fazem animações separadas e depois sobrepoem. Olhando para trás, é algo bem óbivio.
Portando, o que vou fazer:
- Separar as animações de corpo e item;
- Manter o movimento dos items como se tivessem sendo segurado durante um movimento;
- Sobrepor as animações na cena;
- Sincronizar o começo e fim das animações no script;

O que deu pra ver como resultado já:
- Diminuiu drásticamente a quantidade de animações;
- Agora posso reutilizar as animações do mesmo item em ambos os personagems;
- Até o código ficou mais simples;
