# MLD — notation textuelle (clé primaire entre _tirets bas_, clé étrangère précédée de #)


## 01 — Administration et organisation

- types_structures ( _id_, code, libelle, description, actif, created_at, updated_at )
- structures ( _id_, #type_structure_id, #parent_id, code, nom, description, actif, archivee, created_at, updated_at )
- departements ( _id_, #structure_id, code, nom, description, est_actif, created_at, updated_at )
- postes ( _id_, code, libelle, description, actif, created_at, updated_at )
- postes_structures ( _id_, #structure_id, #poste_id, description, actif, created_at, updated_at )
- affectations_postes ( _id_, #poste_structure_id, #personne_id, date_debut, date_fin, motif, created_at, updated_at )

## 02 — Ressources humaines

- personnes ( _id_, nom, prenoms, sexe, date_naissance, lieu_naissance, nationalite, telephone, email, adresse, photo, created_at, updated_at )
- etudiants ( _id_, #personne_id, matricule, date_premiere_inscription, statut, observations, #promotion_id, created_at, updated_at )
- professeurs ( _id_, #personne_id, matricule, grade, specialite, date_recrutement, statut, observations, created_at, updated_at )
- administrateurs ( _id_, #personne_id, matricule, fonction, statut, created_at, updated_at )
- users ( _id_, name, email, password, #administrateur_id, … )

## 03 — Structure pédagogique

- filieres ( _id_, #departement_id, code, nom, description, actif, created_at, updated_at )
- departement_filiere ( _#departement_id_, _#filiere_id_, created_at, updated_at )
- classes ( _id_, #niveau_etude_id, code, nom, description, capacite, actif, created_at, updated_at )
- classe_filiere ( _#classe_id_, _#filiere_id_, created_at, updated_at )
- niveaux_etude ( _id_, … )
- annees_universitaires ( _id_, … )
- promotions ( _id_, … )
- promotions_classes ( _id_, #classe_id, #annee_universitaire_id, #programme_id, actif, observations, created_at, updated_at )

## 04 — Programmes et inscriptions

- programmes ( _id_, #departement_id, code, nom, description, est_actif, created_at, updated_at )
- versions_programmes_pedagogiques ( _id_, #programme_id, #annee_universitaire_id, code, libelle, version, date_debut, date_fin, statut, created_at, updated_at )
- version_programme_unites ( _id_, #version_programme_id, #unite_enseignement_id, … )
- inscriptions_academiques ( _id_, #etudiant_id, #annee_universitaire_id, #niveau_etude_id, #classe_id, #version_programme_id, … )
- regles_pedagogiques ( _id_, #programme_id, #version_programme_id, … )

## 05 — Enseignements et évaluations

- semestres ( _id_, #niveau_etude_id, … )
- unites_enseignement ( _id_, #semestre_id, … )
- ecues ( _id_, #unite_enseignement_id, … )
- promotion_classe_unites ( _id_, #promotion_classe_id, #unite_enseignement_id, obligatoire, observations, created_at, updated_at )
- evaluations ( _id_, #ecue_id, #annee_universitaire_id, … )
- notes ( _id_, #evaluation_id, #inscription_academique_id, #saisie_par, … )
- sessions_rattrapage ( _id_, #annee_universitaire_id, … )
- notes_rattrapage ( _id_, #session_rattrapage_id, #ecue_id, #inscription_academique_id, #saisie_par, … )

## 06 — Résultats et progression

- resultats_ecues ( _id_, #inscription_academique_id, #ecue_id, … )
- resultats_unites ( _id_, #inscription_academique_id, #unite_enseignement_id, … )
- resultats_semestres ( _id_, #inscription_academique_id, #semestre_id, … )
- decisions_progression ( _id_, #inscription_academique_id, #decide_par, … )
- eligibilites_diplomes ( _id_, #inscription_academique_id, … )
- derogations_academiques ( _id_, #inscription_academique_id, #decide_par, #ecue_id, #unite_enseignement_id, … )

## 07 — Planification

- affectations_pedagogiques ( _id_, #promotion_classe_id, #ecue_id, #professeur_id, date_debut, date_fin, statut, observations, created_at, updated_at )
- emplois_du_temps ( _id_, #promotion_classe_id, #semestre_id, date_debut, date_fin, statut, description, created_at, updated_at )
- cours_plannifies ( _id_, #emploi_du_temps_id, #ecue_id, #professeur_id, #salle_id, #affectation_pedagogique_id, jour_semaine, creneau, date_debut, date_fin, statut, observations, created_at, updated_at )
- historique_cours_plannifies ( _id_, #cours_plannifie_id, … )
- salles ( _id_, code, nom, type, capacite, localisation, statut, description, created_at, updated_at )
- evenements ( _id_, … )

## 08 — Sécurité et modules

- roles ( _id_, … )
- permissions ( _id_, … )
- role_user ( _#user_id_, _#role_id_ )
- permission_role ( _#role_id_, _#permission_id_ )
- modules_plateforme ( _id_, … )
- structure_modules ( _id_, #structure_id, #module_plateforme_id, … )
