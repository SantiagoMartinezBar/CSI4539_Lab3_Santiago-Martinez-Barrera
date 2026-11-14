# Je lance ma démonstration sur mon Mac

## 1. Je récupère la dernière version

1. J'ouvre GitHub Desktop.
2. Je sélectionne **CSI4539_Lab3_Santiago-Martinez-Barrera**.
3. Je clique sur **Fetch origin**, puis sur **Pull origin** si ce bouton apparaît.
4. Je clique sur **Repository → Open in Visual Studio Code**.

Si je n'ai pas encore cloné le dépôt, j'utilise **File → Clone Repository → URL**, puis cette adresse :

```text
https://github.com/SantiagoMartinezBar/CSI4539_Lab3_Santiago-Martinez-Barrera.git
```

## 2. Je prépare Docker Desktop avant la séance

1. J'ouvre `https://www.docker.com/products/docker-desktop/`.
2. Je télécharge Docker Desktop pour mon Mac. Je peux voir mon type de processeur dans **menu Apple → À propos de ce Mac** : Apple Silicon pour M1/M2/M3/M4 ou autre puce Apple; Intel pour un processeur Intel.
3. J'installe et j'ouvre Docker Desktop.
4. J'attends que Docker indique que son moteur fonctionne.

Je garde plusieurs gigaoctets libres et une connexion Internet pour la préparation initiale. Le premier lancement télécharge la chaîne de compilation et de preuve; je ne découvre pas cette étape pendant la présentation. Sur Apple Silicon, je lance les outils Linux x86_64 par l'émulation de Docker; leur vitesse dépend de mon Mac.

## 3. J'ouvre le bon terminal

Dans VS Code, je clique sur **Terminal → New Terminal**. Ce terminal doit être ouvert dans le dossier du dépôt. Je vérifie :

```sh
pwd
ls
```

Je dois voir notamment `Makefile`, `src`, `corpus` et `scripts`. Si je ne les vois pas, j'ouvre le dossier Lab 3 avec **File → Open Folder**, puis je crée un nouveau terminal.

Je ne tape aucun chemin `/workspace/...` dans mon terminal Mac : ce chemin appartenait au cloud.

## 4. Je lance l'environnement Linux

Je copie cette ligne dans le terminal VS Code et j'appuie sur Entrée :

```sh
bash scripts/mac_demo.sh
```

Je laisse l'installation se terminer. J'attends le message :

```text
Je suis dans le terminal Linux du laboratoire 3.
```

Mon invite commence alors par `lab3-linux:` et mon dossier est `/project`. Je tape les commandes suivantes **dans ce même terminal Linux**. Je garde Docker Desktop ouvert.

Le lanceur garde les outils dans un volume Docker nommé `csi4539-lab3-tools`. Les fichiers du projet sont partagés avec mon Mac : mes modifications VS Code sont visibles dans Linux. Chaque nouveau lancement réinstalle les petits paquets du conteneur; la grosse chaîne Alire est conservée dans le volume. Je prévois donc une connexion réseau au démarrage.

## 5. Je vérifie tout avant la présentation

Je tape :

```sh
make check
```

Je laisse la commande finir. Elle compile, teste le programme, analyse les flux, prouve les contrats et vérifie un échec volontaire avant sa correction. Les messages d'échec de la variante `before` sont attendus. La variante `after` doit réussir et la commande complète doit se terminer sans erreur Make.

## 6. Je montre mon programme pendant la présentation

Je lance chaque commande séparément, puis j'explique sa sortie :

```sh
make test
```

Je dois voir deux messages `PASS` : les tests directs du paquet et les seize cas de corpus avec le cas de fichier absent.

```sh
./bin/validate_cli corpus/03-name.bin
```

Je dois voir `ACCEPT 17`.

```sh
./bin/validate_cli corpus/05-100.bin
```

Je dois voir `ACCEPT 100`.

```sh
./bin/validate_cli corpus/06-101.bin
```

Je dois voir `REJECT`. Ce résultat est attendu.

```sh
./bin/validate_cli corpus/09-format.bin
```

Je dois voir `REJECT`.

```sh
./bin/validate_cli corpus/13-nul.bin
```

Je dois voir `REJECT`.

Je montre ensuite les étapes de vérification :

```sh
make flow
```

Je dois voir `all checks proved (8 checks)`.

```sh
make prove
```

Je dois voir `all checks proved (24 checks)`. J'ouvre `evidence/proof-summary.txt` dans VS Code pour montrer les catégories : treize contrôles d'exécution, trois contrats et huit vérifications de flux/terminaison.

```sh
make diagnostic
```

Je montre le contre-exemple `Size = 101`, puis la réussite des quatre vérifications après correction.

## 7. Je quitte après la démonstration

Je tape :

```sh
exit
```

Je reviens au terminal Mac. Pour recommencer plus tard, je relance `bash scripts/mac_demo.sh` depuis le dossier du dépôt.

## Si quelque chose ne fonctionne pas

| Message ou situation | Ce que je fais |
|---|---|
| `docker: command not found` | J'installe Docker Desktop puis je redémarre le terminal VS Code. |
| Docker ne répond pas | J'ouvre Docker Desktop et j'attends le démarrage du moteur. |
| `scripts/mac_demo.sh: No such file` | Je récupère la dernière version et je vérifie que j'ai ouvert le dossier Lab 3. |
| `gnatprove: command not found` sur mon Mac | Je lance le conteneur et je tape les commandes de preuve dans `lab3-linux:`. |
| Le téléchargement échoue | Je vérifie ma connexion et je réessaie le lanceur avant la séance. |
| Le terminal affiche `REJECT` | Je vérifie le cas choisi : c'est le résultat attendu pour les fichiers hors politique. |
| La comparaison C est demandée | J'explique qu'elle reste incomplète; je ne présente pas les seuls résultats Ada comme une comparaison. |

Je ne lance pas `make report` dans cet environnement de démonstration : il n'installe pas Pandoc ou LaTeX. Je peux ouvrir directement le PDF ou le document Word déjà généré.
