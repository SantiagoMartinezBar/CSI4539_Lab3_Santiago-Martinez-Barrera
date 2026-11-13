---
title: "Laboratoire 3 — Du C vulnérable au SPARK prouvé"
subtitle: "Brouillon assisté — comparaison C encore à compléter"
author: "Santiago Martinez Barrera"
date: "12 novembre 2026"
papersize: a4
geometry: margin=2.2cm
fontsize: 11pt
colorlinks: true
---

# 1. Introduction et module à sécuriser

Je cherche à protéger la frontière entre une entrée non fiable et un tampon de taille fixe. Au laboratoire 2, le contrôle de contrainte Ada permettait de traiter une entrée trop longue par une exception maîtrisée. Je prépare maintenant un module SPARK dont les contrats expriment les propriétés à démontrer avant l'exécution.

Je sépare le paquet `Input_Validator`, qui ne réalise aucune entrée/sortie, du harnais `Validate_Cli`, qui lit un fichier et affiche un résultat. Je conserve les chaînes du corpus comme des données et je ne les transmets à aucun interpréteur.

Je travaille pour l'instant avec une politique provisoire : j'accepte une longueur de 1 à 100 octets et uniquement les lettres ASCII, les chiffres, `_`, `-` et `.`. Je rejette l'entrée vide, les espaces, les caractères non ASCII et les autres octets. Je dois faire confirmer cette politique : les documents reçus décrivent une référence C, mais ne contiennent pas son fichier source. Je n'affirme donc pas encore l'équivalence avec la routine du cours.

# 2. Désignation SPARK et analyse de flux — E1, E2, T1

J'ai placé `SPARK_Mode => On` dans la spécification et le corps du paquet. Je garde les bibliothèques de fichiers et de console dans le harnais Ada ordinaire. Je construis le projet avec :

```sh
gprbuild -p -P validator.gpr
```

J'active `-gnata` pour vérifier les assertions et les contrats pendant les tests, `-gnato` pour les débordements arithmétiques et `-gnatwe` pour traiter les avertissements de compilation comme des erreurs. Je ne désactive aucun contrôle d'exécution.

Je lance ensuite `make flow`, qui utilise GNATprove en mode `flow`, avec `--report=all`, `--warnings=error` et `--checks-as-errors=on`. J'obtiens huit vérifications réussies et aucun avertissement. Je conserve la commande exacte et son code de sortie dans `evidence/flow.log`.

Je déclare `Global => null` parce que le module ne dépend d'aucun état global. Je déclare `Depends => (Result => Input)` parce que tous les éléments du résultat dépendent uniquement de l'entrée. Je donne au résultat une valeur complète dans chacune des branches, ce qui permet de vérifier son initialisation.

# 3. Contrats et preuve d'intégrité — E3, E4, T2

Je représente les index par `Buffer_Index`, borné de 1 à 100, et la longueur courante par `Input_Length`, borné de 0 à 100. Je définis `Allowed_Character` avec un prédicat dynamique et je rassemble les conditions de validation dans `Meets_Policy`.

Je distingue deux interfaces :

| Interface | Ce que je garantis |
|---|---|
| `Validate` | Je peux recevoir toute chaîne Ada valide. Je renvoie une acceptation exactement lorsque l'entrée respecte la politique. |
| `Copy_Valid` | J'exige `Meets_Policy (Input)` comme précondition. Je garantis une copie exacte dans le tampon et la conservation de la longueur. |

Je n'impose pas la conformité comme précondition de `Validate`, car sa fonction est précisément de rejeter une entrée non conforme. Je prouve la précondition de `Copy_Valid` dans la branche où je l'appelle.

Lorsque je rejette une entrée, je garantis `Accepted = False`, `Length = 0` et un tampon rempli d'espaces. Lorsque je l'accepte, je garantis une copie exacte, une longueur bornée et des caractères admissibles dans la portion utilisée. Je ne présente pas le tampon comme une chaîne C terminée par zéro : la longueur est explicite.

J'exécute `make prove`, soit GNATprove en mode `prove`, niveau 2. Je conserve `evidence/prove.log` et `evidence/proof-summary.txt`. J'obtiens :

| Catégorie | Résultat observé |
|---|---:|
| Vérifications d'exécution | 13 sur 13 prouvées |
| Contrats fonctionnels | 3 sur 3 prouvés |
| Initialisation et dépendances | 6 sur 6 établies par le flux |
| Terminaison | 2 sur 2 établies |
| Total rapporté | 24 sur 24 |
| Vérifications non prouvées | 0 |
| Hypothèses `Assume` | 0 |

Je distingue ces catégories : le total 24 ne représente pas 24 contrôles d'exécution. J'ai 13 contrôles d'exécution déchargés, et les autres portent sur les contrats et l'analyse de flux. J'utilise GNATprove FSF 16.1.0 et CVC5 1.3.2 pour la preuve du module. Les versions détaillées figurent dans `evidence/tools.log`.

Je considère la postcondition d'acceptation comme une propriété fonctionnelle candidate au bonus E7 : aucune entrée hors de ma politique provisoire n'est acceptée. Je dois toutefois faire confirmer la politique attendue avant d'en tirer une conclusion sur les exigences fonctionnelles du cours.

# 4. Analyse d'un échec de preuve — E5, T3

J'ai isolé un exemple volontaire dans `proof/before/`. Je déclare un tampon indexé de 1 à 100 et un paramètre `Size : Positive`. Je laisse initialement le contrat autoriser `Size <= 101`, puis j'écris un caractère à l'index `Size`.

Je lance `make diagnostic`. Dans `evidence/diagnostic-before.log`, je lis :

```text
high: array index check might fail
Data (Size) := 'A';
e.g. when Size = 101
```

Je classe cet échec comme une propriété fausse sur le domaine autorisé. La valeur 101 respecte la précondition et sort du tampon. Je ne peux pas justifier le code en augmentant le temps de preuve : je dois changer le domaine ou le code. Je resserre donc la précondition à `Size <= 100`, sans changer le corps. Dans `proof/after/`, GNATprove prouve les quatre vérifications rapportées et termine avec un code nul.

Je conserve les deux versions et les deux traces pour rendre le diagnostic rejouable. Je développe la distinction entre propriété fausse, information intermédiaire manquante et spécification insuffisante dans `proof/analysis.md`. Je précise que cet exemple expérimental réduit le défaut de borne à son expression minimale; je ne prétends pas qu'il provient d'un programme C que je n'ai pas reçu.

# 5. Comparaison C / Ada-SPARK — L3-A, E6, T4

J'ai préparé seize fichiers communs couvrant les entrées valides, les bornes 99/100/101, les longueurs excessives, les chaînes de format, les métacaractères, les guillemets, les octets nuls, la fin de ligne et l'UTF-8. Je génère les fichiers sans normaliser leur contenu. Je peux donc rejouer exactement les mêmes octets sur les deux versions lorsque la référence sera disponible.

J'ai exécuté tous les cas sur le harnais Ada, avec les contrats activés. J'obtiens les acceptations et rejets attendus pour les seize cas. Je vérifie aussi un fichier absent : je reçois un état `ERROR` et le code de sortie 2. Je conserve les résultats complets dans `evidence/cases.json` et dans le tableau en annexe.

J'ai ajouté des essais directs du paquet pour chacune des 256 valeurs d'octet et pour 102 longueurs, ainsi que pour l'entrée vide et des chaînes dont le premier index n'est pas 1. J'ai aussi vérifié une chaîne commençant à `Integer'Last`. Je conserve cette sortie dans `evidence/unit.log`.

**Je laisse T4 incomplet.** Je n'ai pas reçu la référence C décrite dans l'énoncé. Je ne peux donc ni mesurer son comportement, ni affirmer une corruption mémoire, ni garantir une interface équivalente. Je dois obtenir ce fichier ou l'accord du responsable du cours pour reprendre une routine antérieure. Je conserverai ensuite le C intact, j'ajouterai un harnais adapté et je remplirai la colonne C à partir de ses sorties réelles.

Je peux déjà expliciter les conventions à comparer : en C, une chaîne dépend habituellement du terminateur nul et la capacité n'est pas encodée dans un pointeur; en Ada, une chaîne possède des bornes et sa longueur est disponible. Une entrée avec un octet nul peut donc avoir une signification différente dans les deux interfaces. Je dois documenter cette différence lors du choix du harnais C plutôt que de comparer silencieusement deux entrées différentes.

# 6. Portée et limites

Je prouve les propriétés du paquet SPARK sous la sémantique du langage et les contrats indiqués. Je ne prouve pas le système d'exploitation, la lecture des fichiers, le compilateur, les bibliothèques du harnais ou les délais d'exécution. Je garde ces limites distinctes des garanties démontrées sur le paquet.

Je lis au maximum 101 octets dans le harnais : une entrée de plus de 100 octets atteint toujours une longueur rejetée, sans troncature vers une valeur acceptée. Je n'affiche jamais le contenu comme une chaîne de format et je ne l'interprète pas comme une commande.

Je ne transforme pas la liste de caractères autorisés en garantie universelle. Par exemple, ma politique autorise le point et n'interdit pas `..`; je ne présente donc pas ce module comme un validateur de chemins de fichiers. Je dois préciser le contexte métier avant de réutiliser le paquet dans le projet final.

# 7. Travail d'équipe et état de remise

Je conserve mes décisions et mes vérifications dans `JOURNAL.md`. Je dois encore inscrire le nom de mon partenaire, les rôles réellement exercés, la rotation par rapport au laboratoire 2 et les contributions personnelles. Je ne déduis pas ces éléments de commits produits automatiquement.

| Essai | État que je peux justifier | Preuve |
|---|---|---|
| T1 | Je construis le projet et j'obtiens un flux propre. | `evidence/flow.log` |
| T2 | Je décharge les 24 vérifications rapportées. | `evidence/proof-summary.txt` |
| T3 | Je reproduis un contre-exemple et sa correction. | `evidence/diagnostic-*.log` |
| T4 | J'ai testé Ada; je dois obtenir et tester le C. | `evidence/cases.json` |
| T5 | Je prouve la postcondition de la politique provisoire. | `evidence/prove.log` |

Je dois également confirmer avec le responsable du cours l'utilisation d'un dépôt Lab 3 séparé, puisque l'énoncé demande de réutiliser le dépôt d'équipe. Je n'atteste aucune présence à la démonstration et je ne présente pas ce brouillon comme une remise finale complète.

# 8. Sources et usage des outils d'IA

Je m'appuie sur l'énoncé *CEG4799/CSI4539A Lab3, Automne 2026*, version 1.0, et sur la présentation de l'assistant fournie avec ce travail. Je conserve ces documents dans `docs/source/`. Je m'appuie aussi sur les classes d'entrées du corpus du laboratoire 2. Pour approfondir les notions, je dois consulter les chapitres du manuel *Introduction to SPARK* et la documentation GNATprove indiqués dans l'énoncé.

J'ai utilisé OpenAI Codex, avec le modèle GPT-6 indiqué par la session, le 12 novembre 2026 pour préparer le dépôt, proposer les contrats et le code, installer la chaîne, exécuter les tests et les preuves, et rédiger ce brouillon. Je déclare cette assistance et je dois relire, comprendre et pouvoir justifier chaque élément avant de le remettre. Je n'utiliserai pas l'outil pendant la démonstration.

# Annexe — Mes résultats sur les seize cas communs

Je reproduis ci-dessous le tableau généré à partir des exécutions réelles. Je conserve la colonne C explicitement non exécutée.
