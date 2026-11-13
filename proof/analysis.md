# Analyse de mon échec de preuve — T3 / E5

J'isole mon expérience dans `proof/before/` et `proof/after/` pour ne pas affaiblir le validateur de production. Je garde le même corps dans les deux variantes : j'initialise un tampon de 100 caractères, puis j'écris un marqueur à l'index `Size`. Cette écriture ne lance aucune commande et ne constitue pas une attaque.

## Avant

J'autorise `Size <= 101` dans la précondition, alors que le tampon est indexé de 1 à 100. J'exécute `make diagnostic`, qui lance GNATprove en mode `prove`, niveau 2, avec contre-exemples activés et vérifications non prouvées traitées comme erreurs.

Je lis dans `evidence/diagnostic-before.log` :

```text
high: array index check might fail
Data (Size) := 'A';
e.g. when Size = 101
possible fix: add precondition (Size in 1 .. 100)
EXIT_STATUS=1
```

Je classe cet échec comme une **propriété fausse pour le domaine autorisé**. La valeur 101 satisfait mon ancienne précondition et ne désigne aucun élément du tampon. Je ne peux pas résoudre ce défaut en donnant simplement davantage de temps au prouveur. La sortie mentionne aussi une limite de temps; je m'appuie sur le contre-exemple concret pour établir le défaut.

## Après

Je resserre la précondition à `Size <= 100`; le type `Positive` impose déjà la borne inférieure 1. Je ne modifie pas le corps. GNATprove prouve alors les quatre vérifications rapportées, avec un code de sortie nul. Je conserve la sortie dans `evidence/diagnostic-after.log`.

Je distingue cet exemple d'un invariant intermédiaire manquant : ici, le contrat autorisait réellement une écriture hors limites. Dans le validateur principal, `Copy_Valid` exige une entrée conforme et `Validate` prouve cette précondition avant de l'appeler.
