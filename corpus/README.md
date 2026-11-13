# Corpus commun provisoire

Je réutilise les classes d'entrées du laboratoire 2 et j'ajoute les cas nécessaires au laboratoire 3 : vide, bornes 99/100/101, tailles 160/517, format, métacaractères, guillemets, octet nul, fin de ligne, UTF-8 et espace. Je génère seize fichiers exacts avec `make test`; je ne les ouvre jamais avec un interpréteur de commandes.

Je vérifie chaque octet, sans suppression de la fin de ligne ni troncature silencieuse. Le harnais lit au maximum 101 octets : toute entrée plus grande atteint cette borne de rejet. Les fichiers utilisent l'extension `.bin` pour garder les octets nuls et les tailles exactes.

Je conserve les résultats Ada réels dans `evidence/cases.json` et `evidence/comparison.md`. Je laisse la colonne C non exécutée tant que la référence n'est pas disponible.
