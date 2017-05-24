# AV_Demineur

Salut Madjoh

Je viens de terminer l'application démineur. Je n'ai pas utiliser de bibliothèque externe donc pour installer il de cloner ce repertoire git :
  - $ git init
  - $ git clone https://github.com/arnaud2G/AV_Demineur.git
  
Le jeux fonctionne dans les 3 difficultés connues du démineur mais pourrait également marcher en mode custom ou l'utilisateur donnerait le nombre de ligne/colonne/bombe

L'application à 3 ecrans : le menu (MenuViewController), les règles (seulement dans le storyboard) et le jeux (GameViewController)

La classe Case (mauvaise nom car case existe déjà) défini le modèle de chaque cas avec particulièrement sa valeur dans le jeux (statu) et la valeur affectée par l'utilisateur (flag)
La classe CaseView s'occupe de renseigner la description graphique d'une case
La classe GameManager s'occupe de la gestion du jeux, de l'initialisation jusqu'à la fin de la partie.
La classe GameViewController fait le lien entre la vue, le GameManger et les Case

Le graphique n'a pas été travaillé sur les écran de Menu et Règle. Seul le terrain de jeux a été travaillé en utilisant un CustomLayout qui permet d'optimiser le terrain par rapport à l'ecran.

J'ai réalisé le travail en 5 fois (environ 6-7 heures) :
2*45 min pour déblayer le terrain et réflechir à l'architecture
3 heures pour coder le mécanisme du jeux en mode facile
1 heure pour créer le custom layout pour permettre le fonctionnement des modes mediums et hard
30 minutes de refacto

Pour moi le gros point à améliorer est le chénage lorsque l'utilisateur tombe sur un 0. Ma méthode n'ai pas optimisé, des cases sont testées plusieurs fois (du au fait que je lance les tests en parrallèle)
Plus généralement la partie retournement des mines pourraient être plus découpée.

Voila. J'espère que le jeux vous plaiera. J'attends vos retours et reste à votre dispositions.

Arnaud (meilleurs score en facile : 22s)
