# Projet de communications numériques (TS229)

## Desciption générale
Tous les fichiers utiles à ce projet sont disponibles aux adresses suivantes :

* [Le sujet complet du TP](https://github.com/rtajan/TS229/blob/master/doc/sujet/sujet.pdf)

* Les différentes tâches à effectuer : 
[Tâche 1](https://github.com/rtajan/TS229/blob/master/doc/sujet/tache1.pdf) 
[Tâche 2](https://github.com/rtajan/TS229/blob/master/doc/sujet/tache2.pdf) 
[Tâche 3](https://github.com/rtajan/TS229/blob/master/doc/sujet/tache3.pdf) 
[Tâche 4](https://github.com/rtajan/TS229/blob/master/doc/sujet/tache4.pdf)
[Tâche 5](https://github.com/rtajan/TS229/blob/master/doc/sujet/tache5.pdf)
[Tâche 6](https://github.com/rtajan/TS229/blob/master/doc/sujet/tache6.pdf)
[Tâche 7](https://github.com/rtajan/TS229/blob/master/doc/sujet/tache7.pdf)
[Tâche 8](https://github.com/rtajan/TS229/blob/master/doc/sujet/tache8.pdf)
[Tâche 9](https://github.com/rtajan/TS229/blob/master/doc/sujet/tache9.pdf)
[Tâche 10](https://github.com/rtajan/TS229/blob/master/doc/sujet/tache10.pdf) 
[Tâche 11](https://github.com/rtajan/TS229/blob/master/doc/sujet/tache11.pdf)
[Tâche 12](https://github.com/rtajan/TS229/blob/master/doc/sujet/tache12.pdf)  

* [Des trames avant démodulation](https://thor.enseirb-matmeca.fr/ruby/submissions/2075/download/9f9a0fd1a51c10addd79dd4fab8d3b48b26238829ffb0f5a1d427c5e94e68deb)

* [Des messages ADSB](https://thor.enseirb-matmeca.fr/ruby/submissions/2076/download/127286e770a32ee45991d65a0c86b87f246149abd85f10f805b654bec27cbddc)

* [Une documentation technique sur ADSB](https://thor.enseirb-matmeca.fr/ruby/submissions/2077/download/326c5324ffb1f58b86481b5ece787d3f2fd61b3e07d2a663b02f6312e0647c57) (concerne surtout les tâches annexes)

**Ne pas mettre les données sur votre dépôt Git !**

## Utilisation de Git

 Afin de faciliter le co-développement pendant ce projet, vous aurez à utiliser le système de gestion de version GIT. 

### Ce qui doit être fait lors de votre première séance
Lors de votre première séance, vous commencerez par **cloner** votre répertoire avec la commande suivante

```
git clone https://<user>@thor.enseirb-matmeca.fr/git/<repo>
```

où `<user>` et `<repo>` sont vos login et le nom de votre dépôt Git (cf. votre compte sur Thor)

**Immédiatement après avoir cloné** votre dépôt Git, mettre à jour votre fichier de configuration Git

``` 
ssh ssh.enseirb-matmeca.fr /net/ens/renault/local/bin/init-gitconfig.sh > ~/.gitconfig
```

### Ce qui doit être fait lors à chaque séance

**Pousser** votre travail sur le serveur distant au **minimum à la fin de chaque séance** 

``` 
git push origin master
```

Chaque commit devra **impérativement** comporter un message informatif (git commit). Voir [ce tutoriel](https://chris.beams.io/posts/git-commit/) pour un guide de bonnes pratiques concernant les commits.

### Aide pour Git
Si vous n'êtes pas à l'aise avec l'utilisation de Git, il est **impératif** de suivre le tutoriel [suivant](http://www.labri.fr/perso/renault/working/teaching/projets/git.php).

## Date butoir et rendu
Pour le rendu, utiliser l'interface **Devoirs/Assignments** de vos comptes sur Thor. Vous devez rendre, pour ce TP : 

* un rapport dans un fichier nommé : rapport_ts229_1920.pdf

* vos codes compressés dans une archive nommée : archive_ts229_1920.tar.gz

**Vos codes et rapports doivent être rendus avant le 25 octobre 2019.**
