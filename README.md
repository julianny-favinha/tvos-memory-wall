# **Memory Wall** - *Photastic*

Repositório para o Challenge de AppleTV de 2018.
Apple Developer Academy @ Instituto de Pesquisas Eldorado.

## Introdução

O Memory Wall é um aplicativo para AppleTV onde você pode relembrar momentos a partir de suas fotos. Com o login do Facebook, você pode escolher quais álbuns exibir, de uma forma interativa, customizada do jeito que você quiser.

## Equipe
E-mail pessoal
* **Giovani:**    giovani.x.pereira@gmail.com
* **Ju:**         julianny.favinha@gmail.com
* **Thales:**     thales.gaddini@outlook.com
* **Valeska:**    paulofonseca.h@gmail.com

## Docs do Projeto
* [Guiding Questions]()
* [Canvas]()

## GIT
[Modelo Ideal de Uso do GIT](http://nvie.com/posts/a-successful-git-branching-model/)

Convenções:
* Ordem de operações (no geral)
    1. **Sempre antes de tudo baixe primeiro**, use ` git pull `
        * Muitas vezes pode ser necessários fazer commit antes disso
    2. Faça o desejado (mudanças/commit/envio ao servidor)
* 3 Ramos (branchs)
    * **Master**: releases e aplicativos funcionais
    * **Dev**: código íntegro e compilável
    * **Feature**: implementações em desenvolvimento
        * Duas pessoas nunca devem mexer em um sks ao mesmo tempo
        * Cada um cria a **sua** branch a partir da **Dev**
            * Uma para cada feature/modificação no código
            * **EVITE** mexer fora do seu scopo/objetivo
            * **EVITE** mexer em modificações de outros
            * Se necessário **converse com a pessoa ou equipe**
        * Após término em código compilável merge na **Dev**
            1. Mude para a branch **Dev** `git checkout Dev`
            2. Faça merge com a sua feature `git merge nome_da_minha_feature`
                * o Merge é tipo um "inclua", ele adiciona o branch informado na branch atual
        * A forma como você administra esta branch (implementa, commita, manda/envia ao repositório) é decisão sua
        * **Esta branch não deve ser enviada ao servidor!!** (preferencialmente)
* Pegando as atualizações do colega:
    1. Commit suas modificações `git commit`
    2. Pule para a branch **Dev** `git checkout Dev`
    3. Baixe as atualizações `git pull`
    4. Volte para sua branch `git checkout minha_branch`
    5. De merge nela com a **Dev** `git merge Dev`
        * Lembrando que *merge é um "inclua"*, na linha acima você inclui a **Dev** na sua branch
* Resolução de Conflitos
    * Feita local
    * **Não exite em chamar ajuda nesses casos**

## SCRUM
Scrum Master: Thales
Sprint: 2 dias

Reunião Diária: 10min às **9h**

Sprint Planning
  * Escolha e planejamento do que será feito no Sprint
  * Divisão de Tarefas
  * **Reunião Diária**
      * Informar a equipe sobre o que esta acontecendo: o que fez, o que vai fazer e se tem algum impedimento

1. Sprint
    * Realização do planejado
2. Sprint Review
    * Discussão sobre o que foi feito de bom e ruim com lições aprendidas
    * Revisão dos PBIs do projeto
3. Sprint Retrospective
    * Feedback e discussão sobre o grupo e sua organização
    * Revisão do tabalho em **grupo**
4. Repete: Inicia um novo ciclo
