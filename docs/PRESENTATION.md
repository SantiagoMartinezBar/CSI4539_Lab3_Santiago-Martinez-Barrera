# Mon script de présentation — laboratoire 3

Je prépare cette présentation avant la démonstration et je m'entraîne à expliquer le code sans assistance d'IA. Je garde les durées comme repères : environ quinze minutes de démonstration, puis cinq minutes de questions. Je ne présente pas la comparaison C comme terminée.

## Avant de commencer

Je suis les étapes de `docs/RUN_ON_MAC.md` et je vérifie tout avant la séance. Je garde VS Code ouvert avec `src/input_validator.ads`, `src/input_validator.adb` et `proof/analysis.md`. Je garde le terminal Linux prêt dans `/project`. Je répartis les parties avec mon partenaire selon nos contributions réelles.

## 1. Mon objectif — environ une minute

« Bonjour. Dans ce laboratoire, je passe du contrôle de contrainte à l'exécution à une vérification formelle d'un module de validation d'entrée. Mon objectif est d'accepter une entrée conforme et de rejeter une entrée non conforme avant toute copie dans le tampon.

J'ai séparé le validateur SPARK des entrées et sorties. Le paquet contient la politique et la copie; le harnais lit un fichier et affiche le résultat. Je peux ainsi identifier précisément ce que je prouve.

Ma politique actuelle accepte entre un et cent octets : les lettres ASCII, les chiffres, le soulignement, le tiret et le point. Cette politique reste à confirmer avec la référence du cours. »

## 2. Mon interface et mes contrats — environ trois minutes

Je montre `src/input_validator.ads` dans VS Code.

« Je définis une longueur maximale de cent. Mon sous-type d'index va de un à cent, et ma longueur courante va de zéro à cent.

La fonction `Is_Allowed` définit les caractères autorisés. `Meets_Policy` combine le contrôle de longueur et le contrôle de tous les caractères. Le sous-type `Allowed_Character` exprime également cette règle par un prédicat dynamique.

Je distingue `Validate` et `Copy_Valid`. `Validate` doit pouvoir recevoir une entrée quelconque pour décider de son acceptation : je ne lui impose donc pas une entrée déjà conforme. En revanche, `Copy_Valid` exige cette conformité comme précondition. Je ne l'appelle qu'après avoir vérifié la politique.

Dans mes postconditions, je garantis que le résultat accepté correspond exactement à la politique. Si l'entrée est acceptée, je conserve sa longueur et son contenu. Si elle est rejetée, la longueur devient zéro et le tampon contient uniquement des espaces.

`Global => null` signifie que le module n'utilise aucun état global. `Depends => (Result => Input)` signifie que le résultat dépend uniquement de l'entrée. »

Je montre ensuite `src/input_validator.adb`.

« Je garde une branche pour l'entrée conforme et une branche pour le rejet. J'initialise entièrement le résultat dans les deux cas. Je garde le tampon comme une chaîne Ada de longueur fixe, et je conserve séparément la longueur réellement utilisée. »

## 3. Ma construction et mes tests — environ trois minutes

Je lance :

```sh
make test
```

« Je construis le projet avec les contrats et assertions activés. Mes essais directs couvrent les deux cent cinquante-six valeurs d'octet, cent deux longueurs, l'entrée vide et des chaînes dont le premier index n'est pas un. Je rejoue aussi seize fichiers du corpus dans le harnais. Je vérifie les sorties et les codes de retour attendus. »

Je lance chaque commande séparément :

```sh
./bin/validate_cli corpus/03-name.bin
./bin/validate_cli corpus/05-100.bin
./bin/validate_cli corpus/06-101.bin
./bin/validate_cli corpus/09-format.bin
./bin/validate_cli corpus/13-nul.bin
```

« Je vois une acceptation pour le nom valide et pour la limite de cent octets. Avec cent un octets, je vois un rejet. La chaîne de format et l'octet nul sont aussi rejetés par ma politique.

Je lis ces fichiers comme des données. Je ne supprime pas leurs fins de ligne et je n'interprète pas leur contenu. Le code de retour un signifie ici un rejet attendu; le code deux indique une erreur du harnais, par exemple un fichier absent. »

## 4. Mon analyse de flux et ma preuve — environ trois minutes

Je lance :

```sh
make flow
```

« Je vérifie d'abord les flux. J'obtiens huit vérifications réussies et aucun avertissement. Cette étape vérifie notamment l'initialisation, les dépendances et la terminaison rapportée par l'outil. »

Je lance :

```sh
make prove
```

Je montre ensuite `evidence/proof-summary.txt` dans VS Code.

« J'obtiens vingt-quatre vérifications réussies au total. Dans ce total, treize portent sur les erreurs d'exécution, trois sur les contrats fonctionnels et huit sur le flux et la terminaison. Je n'ai aucune vérification non prouvée et je n'utilise aucun `Assume` ni aucune désactivation de contrôle.

Je distingue mes essais de la preuve. Les essais couvrent les cas que j'ai exécutés. La preuve établit les propriétés vérifiées du paquet pour toutes les entrées couvertes par sa sémantique et ses contrats. Elle ne prouve pas le système d'exploitation ou la lecture des fichiers. »

## 5. Mon échec de preuve et sa correction — environ trois minutes

Je montre `proof/before/proof_copy.ads` et `proof/before/proof_copy.adb`, puis je lance :

```sh
make diagnostic
```

« J'ai isolé un petit exemple de défaut de borne. J'autorise d'abord une taille allant jusqu'à cent un alors que mon tampon s'arrête à cent. GNATprove signale une écriture potentiellement hors limites et propose le contre-exemple `Size = 101`.

Je classe cet échec comme une propriété fausse sur le domaine autorisé. Cent un satisfait la précondition mais n'est pas un index valide. Augmenter le temps du prouveur ne corrigerait pas ce défaut.

Dans la version après correction, je resserre la précondition à cent. Je garde le même corps et j'obtiens les quatre vérifications réussies. Le script vérifie à la fois l'échec attendu avant et la réussite après. »

## 6. Mes limites et ce qu'il reste à faire — environ une minute

« J'ai terminé les vérifications du module SPARK et les essais Ada décrits ici. La comparaison C/SPARK reste incomplète : je n'ai pas reçu le fichier C décrit dans l'énoncé. Je ne peux donc pas montrer honnêtement les résultats des deux versions sur le même corpus. Je dois obtenir cette référence, confirmer sa politique et compléter le tableau L3-A.

Mon paquet n'est pas un validateur universel. Par exemple, j'autorise le point, donc je ne peux pas affirmer que j'interdis les chemins avec deux points successifs. Je dois adapter et reprouver les contrats selon le contexte du projet final. »

## Mes réponses de préparation aux questions possibles

**Pourquoi SPARK plutôt que seulement des tests ?**

« Je garde les tests pour vérifier les exécutions concrètes et le harnais. J'utilise la preuve pour les propriétés générales du paquet. Je ne déduis pas l'absence de défaut de quelques tests réussis. »

**Pourquoi n'y a-t-il pas de précondition de conformité sur `Validate` ?**

« Je dois pouvoir rejeter une entrée incorrecte. Une précondition de conformité sur cette interface ferait porter cette obligation à l'appelant et réduirait le rôle de mon validateur. »

**Pourquoi mon tampon contient-il des espaces si le prédicat ne les autorise pas ?**

« Mon tampon est de type `String`, et sa partie inutilisée sert de stockage initialisé. Le sous-type `Allowed_Character` ne s'applique pas directement à ce tampon. Je vérifie l'admissibilité avec `Is_Allowed` et je la garantis pour la portion acceptée dans les contrats. »

**Que se passe-t-il avec un fichier beaucoup plus long que cent un octets ?**

« Je lis au plus cent un octets. Cette taille dépasse déjà la limite, donc je rejette le fichier. Je ne réduis pas une entrée trop longue à une taille acceptée. »

**Une entrée rejetée provoque-t-elle une exception ?**

« Une entrée hors politique est un résultat normal : je renvoie `Accepted = False`. Le harnais utilise un code de sortie un pour ce rejet. Je réserve le code deux aux erreurs de lecture ou aux autres erreurs du harnais. »

**Que dois-je dire sur l'usage de l'IA ?**

« J'ai déclaré l'assistance d'OpenAI Codex dans mon rapport. Je dois comprendre et justifier le travail présenté; je ne présente pas les commits d'assistance comme des contributions personnelles non assistées. »
