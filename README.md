# Fonctions outils utilisées pendant la thèse

## Calcul des vitesse de déplacement et interpolation

La fonction `motion` permet de calculer la vitesse de déplacement entre deux images radar successives, et la fonction `interp` permet d'interpoler autant d'images qu'on veut entre les deux.

### Vitesse de déplacement

Arguments

  - `i1` : l'image radar au temps t
  - `i2` : l'image radar au temps t+1
  - `rg.vx=-10:10`, `rg.vy=-10:10` : défintion de la zone de recherche, donc limite de la vitesse

Sortie

  - Un vecteur de longueur deux (vx, vy), l'axe des x correpond aux colonnes de la matrice, l'axe des y aux lignes


### Interpolation

Arguments

  - `i1` : l'image radar au temps t
  - `i2` : l'image radar au temps t+1
  - `search=expand.grid(-12:12, -12:12)` : défintion de la zone de recherche (dépend de la vitesse max)
  - `n` : nombre de pas de temps à interpoler entre t et t+1

Sortie

  - Un `array` de taille `(nrow(i1), ncol(i1), n+1)`

## Définitions des évènements de pluie et de temps sec

La fonction `blocs` permet de séparer une chronique catégorisée en blocs (évènements). 

Arguments

  - `x` la variable à classer en blocs qui doit être un facteur (sec/pluie)
  - `var.num` la variable numérique sur laquelle les caractéristiques des blocs seront calculées (intensité de pluie)
  - `lags` un vecteur contenant pour chaque classe de `x` le nombre de mesures consécutives d'un autre groupe maximum qui sera intégré à la classe en question

Sorties

  - Un `data.frame` où chaque ligne représente un évènement, les variables sont la position, la catégorie, la longueur (en nombre de mesure), et si une variable numérique a été renseignée on a aussi le cumul, le maximum et la moyenne.

