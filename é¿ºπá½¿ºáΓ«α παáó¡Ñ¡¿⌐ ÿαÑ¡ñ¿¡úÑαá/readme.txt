Résolution de l'équation de schrodinger. calcul des états propres et des énergies propres d'un hamiltonien.-----------------------------------------------------------------------------------------------------------
Url     : http://codes-sources.commentcamarche.net/source/37617-resolution-de-l-equation-de-schrodinger-calcul-des-etats-propres-et-des-energies-propres-d-un-hamiltonienAuteur  : JnBizDate    : 05/08/2013
Licence :
=========

Ce document intitulé « Résolution de l'équation de schrodinger. calcul des états propres et des énergies propres d'un hamiltonien. » issu de CommentCaMarche
(codes-sources.commentcamarche.net) est mis à disposition sous les termes de
la licence Creative Commons. Vous pouvez copier, modifier des copies de cette
source, dans les conditions fixées par la licence, tant que cette note
apparaît clairement.

Description :
=============

Ce programme est un premier exemple de l'utilisation de la Class TMatrix.
<br /
>
<br />Au programme donc: 
<br />-Calcul des &eacute;nergies propres et des &
eacute;tats propres d'un syst&egrave;me quantique &agrave; une dimension pour di
ff&eacute;rents potentiels.
<br />-R&eacute;solution de l'&eacute;quation de Sc
hrodinger d&eacute;pendante du temps et affichage de l'&eacute;volution de la fo
nction d'onde.
<br />
<br />Ce programme sert &agrave; montrer l'utilisation d
e la class TMatrix, de nombreuses fonctions y sont utilis&eacute;es, notamment p
our la construction de matrices, les op&eacute;rations &eacute;l&eacute;mentaire
s, la diagonalisation de matrices et les diff&eacute;rents types de repr&eacute;
sentation de matrices. Il montre en outre que de simples calculs matriciels peuv
ent remplacer des boucles for.
<br /><a name='source-exemple'></a><h2> Source /
 Exemple : </h2>
<br /><pre class='code' data-mode='basic'>
zip, contient éga
lement l'unité Matrix
</pre>
<br /><a name='conclusion'></a><h2> Conclusion : 
</h2>
<br />Il s'agit en fait de r&eacute;soudre l'&eacute;quation i*hb*d(psi)
/dt=H(psi) o&ugrave; hb est la constante de planck, psi la fonction d'onde (un v
ecteur complexe d&eacute;pendant du temps) et H est une matrice repr&eacute;sent
ant le hamiltonien du syst&egrave;me. Cela ce fait simplement &agrave; partir de
 la diagonalisation de H qui est sym&eacute;trique.
<br />S'agissant d'une &eac
ute;quation qui contient des complexes, on est oblig&eacute; de traiter les part
ies r&eacute;elles et imaginaires des vecteurs ind&eacute;pendemment. Bien enten
du, la notation sera all&eacute;g&eacute;e lorsque j'aurais int&eacute;gr&eacute
; les complexes dans la class TMatrix.
