# Bilan_DB_Gestion_Iter — Dossier de modélisation de la base de données

Projet **gestion_iter** (Laravel 13 · PHP 8.3.30 · MySQL 8.4.3) — base `gestion_universitaire` : 59 tables, 78 clés étrangères.

## Contenu

| Dossier / fichier | Contenu |
|---|---|
| `Bilan_DB_Gestion_Iter_Dossier_complet.pdf` | Tous les livrables en un seul PDF, avec signets |
| `00_Presentation_et_inventaire/` | Présentation, conventions, inventaire des 59 tables |
| `01_MCD_Merise/` | MCD 01 à 09 : PDF, diagrammes (PNG/SVG/PDF), sources `.dot`, entités et associations (XLSX/CSV) |
| `02_MLD/` | MLD par domaine et global : PDF, diagrammes, notation textuelle `.md` |
| `03_MPD/` | MPD : PDF, diagrammes, script SQL de référence |
| `04_UML/` | 7 diagrammes de classes par domaine + diagramme global (46 classes) |
| `05_Dictionnaire_de_donnees/` | Dictionnaire des colonnes et des tables : PDF, XLSX, CSV |
| `06_Regles_de_gestion/` | RG01–RG43 et règles déduites du schéma : PDF, XLSX, CSV |
| `07_Annexes/` | Volumétrie, points de vigilance, éléments à compléter |

Dans chaque dossier : `diagrammes/` (PNG pour insertion, SVG et PDF vectoriels) et `sources/` (fichiers Graphviz `.dot` modifiables).

## Conventions et limites (à mentionner dans le mémoire)

- **Confirmés par l'audit** : noms des tables, colonnes citées, clés primaires/étrangères, contraintes UNIQUE, règles de gestion RG01–RG43, cardinalités §5 et §7.1.
- **Proposés** : types SQL, longueurs, nullabilités (convention Laravel), cardinalités « déduites des clés étrangères », méthodes UML de relation (Eloquent), règles RS01–RS14.
- **À récupérer** : colonnes marquées « … » (tables partielles), valeurs par défaut, index, règles ON DELETE/ON UPDATE (sauf SET NULL de `historique_cours_plannifies`). Voir `07_Annexes`.
- Le script `.sql` est un document de référence : il ne doit pas être exécuté sur la base existante.
- Aucune table, migration, modèle ou fonctionnalité existante n'est modifiée.

## Régénérer / modifier un diagramme

`dot -Tpng sources/MCD_01_Administration_et_organisation.dot -o MCD_01.png` (Graphviz).
