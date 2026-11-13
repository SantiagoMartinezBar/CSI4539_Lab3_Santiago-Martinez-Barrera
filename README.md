# Laboratoire 3 — Validation d'entrée en SPARK

Je prépare un validateur défensif indépendant des entrées/sorties. Je conserve l'énoncé et les diapositives dans `docs/source/`. Je garde les chaînes de test comme des données : je ne les passe à aucun interpréteur.

## Politique provisoire

J'accepte de 1 à 100 octets parmi `A-Z`, `a-z`, `0-9`, `_`, `-` et `.`. Je rejette les autres entrées, y compris l'entrée vide, les octets nuls et les caractères non ASCII. Je dois faire confirmer cette politique et obtenir la référence C décrite dans l'énoncé avant de finaliser L3-A.

## Commandes

Je place GNAT, GPRbuild et GNATprove dans mon `PATH`, puis j'exécute depuis ce dossier :

```sh
make test
make flow
make prove
make diagnostic
make report
```

Je peux installer la chaîne Linux avec `bash scripts/setup_tools.sh`, puis activer `source .tools/activate.sh`. Sur Mac, je privilégie la machine Linux du cours pour la preuve. Je peux consulter et modifier tous les fichiers depuis VS Code.

## Organisation et limites

| Dossier | Ce que j'y conserve |
|---|---|
| `src/` | Je définis le paquet SPARK réutilisable pour le projet final. |
| `harness/` | Je garde la lecture des fichiers et l'affichage hors SPARK. |
| `tests/` et `corpus/` | Je vérifie les bornes et les caractères sur des données inertes. |
| `proof/` | Je conserve les sorties réelles des analyses et un échec volontaire isolé. |
| `reference/` | Je documente le fichier C manquant. |
| `report/` | Je rédige mon rapport et je génère le PDF. |

Je ne considère pas la compilation ou les tests comme une preuve formelle. Je distingue les sorties GNATprove des essais dynamiques et je conserve les points non terminés dans le rapport. Je n'invente ni présence à la démonstration ni contribution d'un partenaire.
