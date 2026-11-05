-- ======================================================================
-- gestion_iter — MPD de RÉFÉRENCE (documentation / modélisation)
-- Généré le 5 novembre 2026 à partir du dossier technique « Bilan_DB_Gestion_Iter ».
--
-- AVERTISSEMENT
--  * Ce script NE DOIT PAS être exécuté sur la base existante : il documente le schéma.
--  * Noms de tables, colonnes, clés primaires/étrangères et contraintes UNIQUE : issus de l'audit.
--  * Types SQL, longueurs, nullabilité : PROPOSÉS selon les conventions Laravel (non fournis par l'audit),
--    à valider contre le schéma MySQL réel (SHOW CREATE TABLE).
--  * Règles ON DELETE / ON UPDATE : seule la règle SET NULL de historique_cours_plannifies est confirmée ;
--    les autres FK sont laissées à la valeur MySQL par défaut (NO ACTION / RESTRICT).
--  * Tables techniques Laravel (cache, jobs, sessions...) et table résiduelle non reproduites.
-- ======================================================================

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- TypeStructure — domaine 01 : Administration et organisation
CREATE TABLE `types_structures` (
  `id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  `code` VARCHAR(255) NOT NULL,
  `libelle` VARCHAR(255) NOT NULL,
  `description` TEXT NULL,
  `actif` TINYINT(1) NOT NULL,
  `created_at` TIMESTAMP NULL,
  `updated_at` TIMESTAMP NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Structure — domaine 01 : Administration et organisation
-- parent_id permet une hiérarchie de structures (association réflexive).
CREATE TABLE `structures` (
  `id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  `type_structure_id` BIGINT UNSIGNED NOT NULL,
  `parent_id` BIGINT UNSIGNED NULL,
  `code` VARCHAR(255) NOT NULL,
  `nom` VARCHAR(255) NOT NULL,
  `description` TEXT NULL,
  `actif` TINYINT(1) NOT NULL,
  `archivee` TINYINT(1) NOT NULL,
  `created_at` TIMESTAMP NULL,
  `updated_at` TIMESTAMP NULL,
  PRIMARY KEY (`id`),
  CONSTRAINT `fk_structures_type_structure_id` FOREIGN KEY (`type_structure_id`) REFERENCES `types_structures` (`id`),
  CONSTRAINT `fk_structures_parent_id` FOREIGN KEY (`parent_id`) REFERENCES `structures` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Departement — domaine 01 : Administration et organisation
CREATE TABLE `departements` (
  `id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  `structure_id` BIGINT UNSIGNED NOT NULL,
  `code` VARCHAR(255) NOT NULL,
  `nom` VARCHAR(255) NOT NULL,
  `description` TEXT NULL,
  `est_actif` TINYINT(1) NOT NULL,
  `created_at` TIMESTAMP NULL,
  `updated_at` TIMESTAMP NULL,
  PRIMARY KEY (`id`),
  CONSTRAINT `fk_departements_structure_id` FOREIGN KEY (`structure_id`) REFERENCES `structures` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Poste — domaine 01 : Administration et organisation
CREATE TABLE `postes` (
  `id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  `code` VARCHAR(255) NOT NULL,
  `libelle` VARCHAR(255) NOT NULL,
  `description` TEXT NULL,
  `actif` TINYINT(1) NOT NULL,
  `created_at` TIMESTAMP NULL,
  `updated_at` TIMESTAMP NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- PosteStructure — domaine 01 : Administration et organisation
CREATE TABLE `postes_structures` (
  `id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  `structure_id` BIGINT UNSIGNED NOT NULL,
  `poste_id` BIGINT UNSIGNED NOT NULL,
  `description` TEXT NULL,
  `actif` TINYINT(1) NOT NULL,
  `created_at` TIMESTAMP NULL,
  `updated_at` TIMESTAMP NULL,
  PRIMARY KEY (`id`),
  CONSTRAINT `uq_postes_structures_structure_poste` UNIQUE (`structure_id`, `poste_id`),
  CONSTRAINT `fk_postes_structures_structure_id` FOREIGN KEY (`structure_id`) REFERENCES `structures` (`id`),
  CONSTRAINT `fk_postes_structures_poste_id` FOREIGN KEY (`poste_id`) REFERENCES `postes` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Personne — domaine 02 : Ressources humaines
CREATE TABLE `personnes` (
  `id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  `nom` VARCHAR(255) NOT NULL,
  `prenoms` VARCHAR(255) NOT NULL,
  `sexe` VARCHAR(255) NOT NULL,
  `date_naissance` DATE NOT NULL,
  `lieu_naissance` VARCHAR(255) NOT NULL,
  `nationalite` VARCHAR(255) NOT NULL,
  `telephone` VARCHAR(255) NOT NULL,
  `email` VARCHAR(255) NOT NULL,
  `adresse` VARCHAR(255) NOT NULL,
  `photo` VARCHAR(255) NULL,
  `created_at` TIMESTAMP NULL,
  `updated_at` TIMESTAMP NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- AffectationPoste — domaine 01 : Administration et organisation
CREATE TABLE `affectations_postes` (
  `id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  `poste_structure_id` BIGINT UNSIGNED NOT NULL,
  `personne_id` BIGINT UNSIGNED NOT NULL,
  `date_debut` DATE NOT NULL,
  `date_fin` DATE NULL,
  `motif` TEXT NULL,
  `created_at` TIMESTAMP NULL,
  `updated_at` TIMESTAMP NULL,
  PRIMARY KEY (`id`),
  CONSTRAINT `fk_affectations_postes_poste_structure_id` FOREIGN KEY (`poste_structure_id`) REFERENCES `postes_structures` (`id`),
  CONSTRAINT `fk_affectations_postes_personne_id` FOREIGN KEY (`personne_id`) REFERENCES `personnes` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Promotion — domaine 03 : Structure pédagogique
-- ATTENTION : définition incomplète dans l'audit — colonnes restantes à récupérer.
-- Table métier utilisée par les profils étudiants ; à ne pas confondre avec promotions_classes.
CREATE TABLE `promotions` (
  `id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Etudiant — domaine 02 : Ressources humaines
CREATE TABLE `etudiants` (
  `id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  `personne_id` BIGINT UNSIGNED NOT NULL,
  `matricule` VARCHAR(255) NOT NULL,
  `date_premiere_inscription` DATE NOT NULL,
  `statut` VARCHAR(255) NOT NULL,
  `observations` TEXT NULL,
  `promotion_id` BIGINT UNSIGNED NULL,
  `created_at` TIMESTAMP NULL,
  `updated_at` TIMESTAMP NULL,
  PRIMARY KEY (`id`),
  CONSTRAINT `fk_etudiants_personne_id` FOREIGN KEY (`personne_id`) REFERENCES `personnes` (`id`),
  CONSTRAINT `fk_etudiants_promotion_id` FOREIGN KEY (`promotion_id`) REFERENCES `promotions` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Professeur — domaine 02 : Ressources humaines
CREATE TABLE `professeurs` (
  `id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  `personne_id` BIGINT UNSIGNED NOT NULL,
  `matricule` VARCHAR(255) NOT NULL,
  `grade` VARCHAR(255) NOT NULL,
  `specialite` VARCHAR(255) NOT NULL,
  `date_recrutement` DATE NOT NULL,
  `statut` VARCHAR(255) NOT NULL,
  `observations` TEXT NULL,
  `created_at` TIMESTAMP NULL,
  `updated_at` TIMESTAMP NULL,
  PRIMARY KEY (`id`),
  CONSTRAINT `fk_professeurs_personne_id` FOREIGN KEY (`personne_id`) REFERENCES `personnes` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Administrateur — domaine 02 : Ressources humaines
CREATE TABLE `administrateurs` (
  `id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  `personne_id` BIGINT UNSIGNED NOT NULL,
  `matricule` VARCHAR(255) NOT NULL,
  `fonction` VARCHAR(255) NOT NULL,
  `statut` VARCHAR(255) NOT NULL,
  `created_at` TIMESTAMP NULL,
  `updated_at` TIMESTAMP NULL,
  PRIMARY KEY (`id`),
  CONSTRAINT `fk_administrateurs_personne_id` FOREIGN KEY (`personne_id`) REFERENCES `personnes` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- User — domaine 02 : Ressources humaines
-- ATTENTION : définition incomplète dans l'audit — colonnes restantes à récupérer.
-- Un administrateur peut exister sans compte ; étudiants et professeurs n'ont pas de compte (RG38–RG43).
CREATE TABLE `users` (
  `id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(255) NOT NULL,
  `email` VARCHAR(255) NOT NULL,
  `password` VARCHAR(255) NOT NULL,
  `administrateur_id` BIGINT UNSIGNED NOT NULL,
  PRIMARY KEY (`id`),
  CONSTRAINT `fk_users_administrateur_id` FOREIGN KEY (`administrateur_id`) REFERENCES `administrateurs` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Filiere — domaine 03 : Structure pédagogique
-- departement_id est nullable et NULL pour toutes les lignes observées ; la relation fonctionnelle passe par departement_filiere.
CREATE TABLE `filieres` (
  `id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  `departement_id` BIGINT UNSIGNED NULL,
  `code` VARCHAR(255) NOT NULL,
  `nom` VARCHAR(255) NOT NULL,
  `description` TEXT NULL,
  `actif` TINYINT(1) NOT NULL,
  `created_at` TIMESTAMP NULL,
  `updated_at` TIMESTAMP NULL,
  PRIMARY KEY (`id`),
  CONSTRAINT `fk_filieres_departement_id` FOREIGN KEY (`departement_id`) REFERENCES `departements` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- DepartementFiliere — domaine 03 : Structure pédagogique
-- Association plusieurs-à-plusieurs Département–Filière.
CREATE TABLE `departement_filiere` (
  `departement_id` BIGINT UNSIGNED NOT NULL,
  `filiere_id` BIGINT UNSIGNED NOT NULL,
  `created_at` TIMESTAMP NULL,
  `updated_at` TIMESTAMP NULL,
  PRIMARY KEY (`departement_id`, `filiere_id`),
  CONSTRAINT `fk_departement_filiere_departement_id` FOREIGN KEY (`departement_id`) REFERENCES `departements` (`id`),
  CONSTRAINT `fk_departement_filiere_filiere_id` FOREIGN KEY (`filiere_id`) REFERENCES `filieres` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- NiveauEtude — domaine 03 : Structure pédagogique
-- ATTENTION : définition incomplète dans l'audit — colonnes restantes à récupérer.
-- Valeurs métier identifiées : L1, L2, L3, M1, M2.
CREATE TABLE `niveaux_etude` (
  `id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Classe — domaine 03 : Structure pédagogique
CREATE TABLE `classes` (
  `id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  `niveau_etude_id` BIGINT UNSIGNED NOT NULL,
  `code` VARCHAR(255) NOT NULL,
  `nom` VARCHAR(255) NOT NULL,
  `description` TEXT NULL,
  `capacite` INT UNSIGNED NOT NULL,
  `actif` TINYINT(1) NOT NULL,
  `created_at` TIMESTAMP NULL,
  `updated_at` TIMESTAMP NULL,
  PRIMARY KEY (`id`),
  CONSTRAINT `fk_classes_niveau_etude_id` FOREIGN KEY (`niveau_etude_id`) REFERENCES `niveaux_etude` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ClasseFiliere — domaine 03 : Structure pédagogique
-- Association plusieurs-à-plusieurs Classe–Filière.
CREATE TABLE `classe_filiere` (
  `classe_id` BIGINT UNSIGNED NOT NULL,
  `filiere_id` BIGINT UNSIGNED NOT NULL,
  `created_at` TIMESTAMP NULL,
  `updated_at` TIMESTAMP NULL,
  PRIMARY KEY (`classe_id`, `filiere_id`),
  CONSTRAINT `fk_classe_filiere_classe_id` FOREIGN KEY (`classe_id`) REFERENCES `classes` (`id`),
  CONSTRAINT `fk_classe_filiere_filiere_id` FOREIGN KEY (`filiere_id`) REFERENCES `filieres` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- AnneeUniversitaire — domaine 03 : Structure pédagogique
-- ATTENTION : définition incomplète dans l'audit — colonnes restantes à récupérer.
-- Noms physiques exacts à confirmer.
CREATE TABLE `annees_universitaires` (
  `id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Programme — domaine 04 : Programmes et inscriptions
CREATE TABLE `programmes` (
  `id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  `departement_id` BIGINT UNSIGNED NOT NULL,
  `code` VARCHAR(255) NOT NULL,
  `nom` VARCHAR(255) NOT NULL,
  `description` TEXT NULL,
  `est_actif` TINYINT(1) NOT NULL,
  `created_at` TIMESTAMP NULL,
  `updated_at` TIMESTAMP NULL,
  PRIMARY KEY (`id`),
  CONSTRAINT `fk_programmes_departement_id` FOREIGN KEY (`departement_id`) REFERENCES `departements` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- PromotionClasse — domaine 03 : Structure pédagogique
-- Promotion annuelle = une classe pour une année universitaire (RG12, RG13).
CREATE TABLE `promotions_classes` (
  `id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  `classe_id` BIGINT UNSIGNED NOT NULL,
  `annee_universitaire_id` BIGINT UNSIGNED NOT NULL,
  `programme_id` BIGINT UNSIGNED NULL,
  `actif` TINYINT(1) NOT NULL,
  `observations` TEXT NULL,
  `created_at` TIMESTAMP NULL,
  `updated_at` TIMESTAMP NULL,
  PRIMARY KEY (`id`),
  CONSTRAINT `uq_promotions_classes_classe_annee_universitaire` UNIQUE (`classe_id`, `annee_universitaire_id`),
  CONSTRAINT `fk_promotions_classes_classe_id` FOREIGN KEY (`classe_id`) REFERENCES `classes` (`id`),
  CONSTRAINT `fk_promotions_classes_annee_universitaire_id` FOREIGN KEY (`annee_universitaire_id`) REFERENCES `annees_universitaires` (`id`),
  CONSTRAINT `fk_promotions_classes_programme_id` FOREIGN KEY (`programme_id`) REFERENCES `programmes` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- VersionProgrammePedagogique — domaine 04 : Programmes et inscriptions
CREATE TABLE `versions_programmes_pedagogiques` (
  `id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  `programme_id` BIGINT UNSIGNED NOT NULL,
  `annee_universitaire_id` BIGINT UNSIGNED NOT NULL,
  `code` VARCHAR(255) NOT NULL,
  `libelle` VARCHAR(255) NOT NULL,
  `version` VARCHAR(255) NOT NULL,
  `date_debut` DATE NOT NULL,
  `date_fin` DATE NULL,
  `statut` VARCHAR(255) NOT NULL,
  `created_at` TIMESTAMP NULL,
  `updated_at` TIMESTAMP NULL,
  PRIMARY KEY (`id`),
  CONSTRAINT `uq_versions_programmes_pedagogiques_programme_annee_universitair` UNIQUE (`programme_id`, `annee_universitaire_id`, `version`),
  CONSTRAINT `fk_versions_programmes_pedagogiques_programme_id` FOREIGN KEY (`programme_id`) REFERENCES `programmes` (`id`),
  CONSTRAINT `fk_versions_programmes_pedagogiques_annee_universitaire_id` FOREIGN KEY (`annee_universitaire_id`) REFERENCES `annees_universitaires` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Semestre — domaine 05 : Enseignements et évaluations
-- ATTENTION : définition incomplète dans l'audit — colonnes restantes à récupérer.
CREATE TABLE `semestres` (
  `id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  `niveau_etude_id` BIGINT UNSIGNED NOT NULL,
  PRIMARY KEY (`id`),
  CONSTRAINT `fk_semestres_niveau_etude_id` FOREIGN KEY (`niveau_etude_id`) REFERENCES `niveaux_etude` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- UniteEnseignement — domaine 05 : Enseignements et évaluations
-- ATTENTION : définition incomplète dans l'audit — colonnes restantes à récupérer.
CREATE TABLE `unites_enseignement` (
  `id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  `semestre_id` BIGINT UNSIGNED NOT NULL,
  PRIMARY KEY (`id`),
  CONSTRAINT `fk_unites_enseignement_semestre_id` FOREIGN KEY (`semestre_id`) REFERENCES `semestres` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- VersionProgrammeUnite — domaine 04 : Programmes et inscriptions
-- ATTENTION : définition incomplète dans l'audit — colonnes restantes à récupérer.
-- Association Version de programme–Unité d'enseignement.
CREATE TABLE `version_programme_unites` (
  `id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  `version_programme_id` BIGINT UNSIGNED NOT NULL,
  `unite_enseignement_id` BIGINT UNSIGNED NOT NULL,
  PRIMARY KEY (`id`),
  CONSTRAINT `fk_version_programme_unites_version_programme_id` FOREIGN KEY (`version_programme_id`) REFERENCES `versions_programmes_pedagogiques` (`id`),
  CONSTRAINT `fk_version_programme_unites_unite_enseignement_id` FOREIGN KEY (`unite_enseignement_id`) REFERENCES `unites_enseignement` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- InscriptionAcademique — domaine 04 : Programmes et inscriptions
-- ATTENTION : définition incomplète dans l'audit — colonnes restantes à récupérer.
-- Le champ programme_id a été retiré par migration ; l'inscription référence une version de programme (RG21).
CREATE TABLE `inscriptions_academiques` (
  `id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  `etudiant_id` BIGINT UNSIGNED NOT NULL,
  `annee_universitaire_id` BIGINT UNSIGNED NOT NULL,
  `niveau_etude_id` BIGINT UNSIGNED NOT NULL,
  `classe_id` BIGINT UNSIGNED NOT NULL,
  `version_programme_id` BIGINT UNSIGNED NOT NULL,
  PRIMARY KEY (`id`),
  CONSTRAINT `fk_inscriptions_academiques_etudiant_id` FOREIGN KEY (`etudiant_id`) REFERENCES `etudiants` (`id`),
  CONSTRAINT `fk_inscriptions_academiques_annee_universitaire_id` FOREIGN KEY (`annee_universitaire_id`) REFERENCES `annees_universitaires` (`id`),
  CONSTRAINT `fk_inscriptions_academiques_niveau_etude_id` FOREIGN KEY (`niveau_etude_id`) REFERENCES `niveaux_etude` (`id`),
  CONSTRAINT `fk_inscriptions_academiques_classe_id` FOREIGN KEY (`classe_id`) REFERENCES `classes` (`id`),
  CONSTRAINT `fk_inscriptions_academiques_version_programme_id` FOREIGN KEY (`version_programme_id`) REFERENCES `versions_programmes_pedagogiques` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ReglePedagogique — domaine 04 : Programmes et inscriptions
-- ATTENTION : définition incomplète dans l'audit — colonnes restantes à récupérer.
CREATE TABLE `regles_pedagogiques` (
  `id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  `programme_id` BIGINT UNSIGNED NULL,
  `version_programme_id` BIGINT UNSIGNED NULL,
  PRIMARY KEY (`id`),
  CONSTRAINT `fk_regles_pedagogiques_programme_id` FOREIGN KEY (`programme_id`) REFERENCES `programmes` (`id`),
  CONSTRAINT `fk_regles_pedagogiques_version_programme_id` FOREIGN KEY (`version_programme_id`) REFERENCES `versions_programmes_pedagogiques` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Ecue — domaine 05 : Enseignements et évaluations
-- ATTENTION : définition incomplète dans l'audit — colonnes restantes à récupérer.
CREATE TABLE `ecues` (
  `id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  `unite_enseignement_id` BIGINT UNSIGNED NULL,
  PRIMARY KEY (`id`),
  CONSTRAINT `fk_ecues_unite_enseignement_id` FOREIGN KEY (`unite_enseignement_id`) REFERENCES `unites_enseignement` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- PromotionClasseUnite — domaine 05 : Enseignements et évaluations
-- Association Promotion annuelle–Unité d'enseignement, porteuse de « obligatoire » et « observations ».
CREATE TABLE `promotion_classe_unites` (
  `id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  `promotion_classe_id` BIGINT UNSIGNED NOT NULL,
  `unite_enseignement_id` BIGINT UNSIGNED NOT NULL,
  `obligatoire` TINYINT(1) NOT NULL,
  `observations` TEXT NULL,
  `created_at` TIMESTAMP NULL,
  `updated_at` TIMESTAMP NULL,
  PRIMARY KEY (`id`),
  CONSTRAINT `fk_promotion_classe_unites_promotion_classe_id` FOREIGN KEY (`promotion_classe_id`) REFERENCES `promotions_classes` (`id`),
  CONSTRAINT `fk_promotion_classe_unites_unite_enseignement_id` FOREIGN KEY (`unite_enseignement_id`) REFERENCES `unites_enseignement` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Evaluation — domaine 05 : Enseignements et évaluations
-- ATTENTION : définition incomplète dans l'audit — colonnes restantes à récupérer.
CREATE TABLE `evaluations` (
  `id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  `ecue_id` BIGINT UNSIGNED NOT NULL,
  `annee_universitaire_id` BIGINT UNSIGNED NOT NULL,
  PRIMARY KEY (`id`),
  CONSTRAINT `fk_evaluations_ecue_id` FOREIGN KEY (`ecue_id`) REFERENCES `ecues` (`id`),
  CONSTRAINT `fk_evaluations_annee_universitaire_id` FOREIGN KEY (`annee_universitaire_id`) REFERENCES `annees_universitaires` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Note — domaine 05 : Enseignements et évaluations
-- ATTENTION : définition incomplète dans l'audit — colonnes restantes à récupérer.
CREATE TABLE `notes` (
  `id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  `evaluation_id` BIGINT UNSIGNED NOT NULL,
  `inscription_academique_id` BIGINT UNSIGNED NOT NULL,
  `saisie_par` BIGINT UNSIGNED NULL,
  PRIMARY KEY (`id`),
  CONSTRAINT `fk_notes_evaluation_id` FOREIGN KEY (`evaluation_id`) REFERENCES `evaluations` (`id`),
  CONSTRAINT `fk_notes_inscription_academique_id` FOREIGN KEY (`inscription_academique_id`) REFERENCES `inscriptions_academiques` (`id`),
  CONSTRAINT `fk_notes_saisie_par` FOREIGN KEY (`saisie_par`) REFERENCES `administrateurs` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- SessionRattrapage — domaine 05 : Enseignements et évaluations
-- ATTENTION : définition incomplète dans l'audit — colonnes restantes à récupérer.
CREATE TABLE `sessions_rattrapage` (
  `id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  `annee_universitaire_id` BIGINT UNSIGNED NOT NULL,
  PRIMARY KEY (`id`),
  CONSTRAINT `fk_sessions_rattrapage_annee_universitaire_id` FOREIGN KEY (`annee_universitaire_id`) REFERENCES `annees_universitaires` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- NoteRattrapage — domaine 05 : Enseignements et évaluations
-- ATTENTION : définition incomplète dans l'audit — colonnes restantes à récupérer.
CREATE TABLE `notes_rattrapage` (
  `id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  `session_rattrapage_id` BIGINT UNSIGNED NOT NULL,
  `ecue_id` BIGINT UNSIGNED NOT NULL,
  `inscription_academique_id` BIGINT UNSIGNED NOT NULL,
  `saisie_par` BIGINT UNSIGNED NULL,
  PRIMARY KEY (`id`),
  CONSTRAINT `fk_notes_rattrapage_session_rattrapage_id` FOREIGN KEY (`session_rattrapage_id`) REFERENCES `sessions_rattrapage` (`id`),
  CONSTRAINT `fk_notes_rattrapage_ecue_id` FOREIGN KEY (`ecue_id`) REFERENCES `ecues` (`id`),
  CONSTRAINT `fk_notes_rattrapage_inscription_academique_id` FOREIGN KEY (`inscription_academique_id`) REFERENCES `inscriptions_academiques` (`id`),
  CONSTRAINT `fk_notes_rattrapage_saisie_par` FOREIGN KEY (`saisie_par`) REFERENCES `administrateurs` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ResultatEcue — domaine 06 : Résultats et progression
-- ATTENTION : définition incomplète dans l'audit — colonnes restantes à récupérer.
CREATE TABLE `resultats_ecues` (
  `id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  `inscription_academique_id` BIGINT UNSIGNED NOT NULL,
  `ecue_id` BIGINT UNSIGNED NOT NULL,
  PRIMARY KEY (`id`),
  CONSTRAINT `fk_resultats_ecues_inscription_academique_id` FOREIGN KEY (`inscription_academique_id`) REFERENCES `inscriptions_academiques` (`id`),
  CONSTRAINT `fk_resultats_ecues_ecue_id` FOREIGN KEY (`ecue_id`) REFERENCES `ecues` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ResultatUnite — domaine 06 : Résultats et progression
-- ATTENTION : définition incomplète dans l'audit — colonnes restantes à récupérer.
CREATE TABLE `resultats_unites` (
  `id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  `inscription_academique_id` BIGINT UNSIGNED NOT NULL,
  `unite_enseignement_id` BIGINT UNSIGNED NOT NULL,
  PRIMARY KEY (`id`),
  CONSTRAINT `fk_resultats_unites_inscription_academique_id` FOREIGN KEY (`inscription_academique_id`) REFERENCES `inscriptions_academiques` (`id`),
  CONSTRAINT `fk_resultats_unites_unite_enseignement_id` FOREIGN KEY (`unite_enseignement_id`) REFERENCES `unites_enseignement` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ResultatSemestre — domaine 06 : Résultats et progression
-- ATTENTION : définition incomplète dans l'audit — colonnes restantes à récupérer.
CREATE TABLE `resultats_semestres` (
  `id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  `inscription_academique_id` BIGINT UNSIGNED NOT NULL,
  `semestre_id` BIGINT UNSIGNED NOT NULL,
  PRIMARY KEY (`id`),
  CONSTRAINT `fk_resultats_semestres_inscription_academique_id` FOREIGN KEY (`inscription_academique_id`) REFERENCES `inscriptions_academiques` (`id`),
  CONSTRAINT `fk_resultats_semestres_semestre_id` FOREIGN KEY (`semestre_id`) REFERENCES `semestres` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- DecisionProgression — domaine 06 : Résultats et progression
-- ATTENTION : définition incomplète dans l'audit — colonnes restantes à récupérer.
CREATE TABLE `decisions_progression` (
  `id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  `inscription_academique_id` BIGINT UNSIGNED NOT NULL,
  `decide_par` BIGINT UNSIGNED NOT NULL,
  PRIMARY KEY (`id`),
  CONSTRAINT `fk_decisions_progression_inscription_academique_id` FOREIGN KEY (`inscription_academique_id`) REFERENCES `inscriptions_academiques` (`id`),
  CONSTRAINT `fk_decisions_progression_decide_par` FOREIGN KEY (`decide_par`) REFERENCES `administrateurs` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- EligibiliteDiplome — domaine 06 : Résultats et progression
-- ATTENTION : définition incomplète dans l'audit — colonnes restantes à récupérer.
CREATE TABLE `eligibilites_diplomes` (
  `id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  `inscription_academique_id` BIGINT UNSIGNED NOT NULL,
  PRIMARY KEY (`id`),
  CONSTRAINT `fk_eligibilites_diplomes_inscription_academique_id` FOREIGN KEY (`inscription_academique_id`) REFERENCES `inscriptions_academiques` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- DerogationAcademique — domaine 06 : Résultats et progression
-- ATTENTION : définition incomplète dans l'audit — colonnes restantes à récupérer.
CREATE TABLE `derogations_academiques` (
  `id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  `inscription_academique_id` BIGINT UNSIGNED NOT NULL,
  `decide_par` BIGINT UNSIGNED NULL,
  `ecue_id` BIGINT UNSIGNED NULL,
  `unite_enseignement_id` BIGINT UNSIGNED NULL,
  PRIMARY KEY (`id`),
  CONSTRAINT `fk_derogations_academiques_inscription_academique_id` FOREIGN KEY (`inscription_academique_id`) REFERENCES `inscriptions_academiques` (`id`),
  CONSTRAINT `fk_derogations_academiques_decide_par` FOREIGN KEY (`decide_par`) REFERENCES `administrateurs` (`id`),
  CONSTRAINT `fk_derogations_academiques_ecue_id` FOREIGN KEY (`ecue_id`) REFERENCES `ecues` (`id`),
  CONSTRAINT `fk_derogations_academiques_unite_enseignement_id` FOREIGN KEY (`unite_enseignement_id`) REFERENCES `unites_enseignement` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- AffectationPedagogique — domaine 07 : Planification
CREATE TABLE `affectations_pedagogiques` (
  `id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  `promotion_classe_id` BIGINT UNSIGNED NOT NULL,
  `ecue_id` BIGINT UNSIGNED NOT NULL,
  `professeur_id` BIGINT UNSIGNED NOT NULL,
  `date_debut` DATE NOT NULL,
  `date_fin` DATE NULL,
  `statut` VARCHAR(255) NOT NULL,
  `observations` TEXT NULL,
  `created_at` TIMESTAMP NULL,
  `updated_at` TIMESTAMP NULL,
  PRIMARY KEY (`id`),
  CONSTRAINT `fk_affectations_pedagogiques_promotion_classe_id` FOREIGN KEY (`promotion_classe_id`) REFERENCES `promotions_classes` (`id`),
  CONSTRAINT `fk_affectations_pedagogiques_ecue_id` FOREIGN KEY (`ecue_id`) REFERENCES `ecues` (`id`),
  CONSTRAINT `fk_affectations_pedagogiques_professeur_id` FOREIGN KEY (`professeur_id`) REFERENCES `professeurs` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- EmploiDuTemps — domaine 07 : Planification
CREATE TABLE `emplois_du_temps` (
  `id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  `promotion_classe_id` BIGINT UNSIGNED NOT NULL,
  `semestre_id` BIGINT UNSIGNED NOT NULL,
  `date_debut` DATE NOT NULL,
  `date_fin` DATE NULL,
  `statut` VARCHAR(255) NOT NULL,
  `description` TEXT NULL,
  `created_at` TIMESTAMP NULL,
  `updated_at` TIMESTAMP NULL,
  PRIMARY KEY (`id`),
  CONSTRAINT `fk_emplois_du_temps_promotion_classe_id` FOREIGN KEY (`promotion_classe_id`) REFERENCES `promotions_classes` (`id`),
  CONSTRAINT `fk_emplois_du_temps_semestre_id` FOREIGN KEY (`semestre_id`) REFERENCES `semestres` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Salle — domaine 07 : Planification
CREATE TABLE `salles` (
  `id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  `code` VARCHAR(255) NOT NULL,
  `nom` VARCHAR(255) NOT NULL,
  `type` VARCHAR(255) NOT NULL,
  `capacite` INT UNSIGNED NOT NULL,
  `localisation` VARCHAR(255) NOT NULL,
  `statut` VARCHAR(255) NOT NULL,
  `description` TEXT NULL,
  `created_at` TIMESTAMP NULL,
  `updated_at` TIMESTAMP NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- CoursPlannifie — domaine 07 : Planification
-- Orthographe « plannifie » conservée telle qu'en base.
CREATE TABLE `cours_plannifies` (
  `id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  `emploi_du_temps_id` BIGINT UNSIGNED NOT NULL,
  `ecue_id` BIGINT UNSIGNED NOT NULL,
  `professeur_id` BIGINT UNSIGNED NOT NULL,
  `salle_id` BIGINT UNSIGNED NOT NULL,
  `affectation_pedagogique_id` BIGINT UNSIGNED NULL,
  `jour_semaine` VARCHAR(255) NOT NULL,
  `creneau` VARCHAR(255) NOT NULL,
  `date_debut` DATE NOT NULL,
  `date_fin` DATE NULL,
  `statut` VARCHAR(255) NOT NULL,
  `observations` TEXT NULL,
  `created_at` TIMESTAMP NULL,
  `updated_at` TIMESTAMP NULL,
  PRIMARY KEY (`id`),
  CONSTRAINT `fk_cours_plannifies_emploi_du_temps_id` FOREIGN KEY (`emploi_du_temps_id`) REFERENCES `emplois_du_temps` (`id`),
  CONSTRAINT `fk_cours_plannifies_ecue_id` FOREIGN KEY (`ecue_id`) REFERENCES `ecues` (`id`),
  CONSTRAINT `fk_cours_plannifies_professeur_id` FOREIGN KEY (`professeur_id`) REFERENCES `professeurs` (`id`),
  CONSTRAINT `fk_cours_plannifies_salle_id` FOREIGN KEY (`salle_id`) REFERENCES `salles` (`id`),
  CONSTRAINT `fk_cours_plannifies_affectation_pedagogique_id` FOREIGN KEY (`affectation_pedagogique_id`) REFERENCES `affectations_pedagogiques` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- HistoriqueCoursPlannifie — domaine 07 : Planification
-- ATTENTION : définition incomplète dans l'audit — colonnes restantes à récupérer.
-- La suppression du cours référencé peut mettre cette référence à NULL (ON DELETE SET NULL).
CREATE TABLE `historique_cours_plannifies` (
  `id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  `cours_plannifie_id` BIGINT UNSIGNED NULL,
  PRIMARY KEY (`id`),
  CONSTRAINT `fk_historique_cours_plannifies_cours_plannifie_id` FOREIGN KEY (`cours_plannifie_id`) REFERENCES `cours_plannifies` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Evenement — domaine 07 : Planification
-- ATTENTION : définition incomplète dans l'audit — colonnes restantes à récupérer.
-- Structure physique complète à récupérer.
CREATE TABLE `evenements` (
  `id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Role — domaine 08 : Sécurité et modules
-- ATTENTION : définition incomplète dans l'audit — colonnes restantes à récupérer.
CREATE TABLE `roles` (
  `id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Permission — domaine 08 : Sécurité et modules
-- ATTENTION : définition incomplète dans l'audit — colonnes restantes à récupérer.
CREATE TABLE `permissions` (
  `id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- RoleUser — domaine 08 : Sécurité et modules
CREATE TABLE `role_user` (
  `user_id` BIGINT UNSIGNED NOT NULL,
  `role_id` BIGINT UNSIGNED NOT NULL,
  PRIMARY KEY (`user_id`, `role_id`),
  CONSTRAINT `fk_role_user_user_id` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`),
  CONSTRAINT `fk_role_user_role_id` FOREIGN KEY (`role_id`) REFERENCES `roles` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- PermissionRole — domaine 08 : Sécurité et modules
CREATE TABLE `permission_role` (
  `role_id` BIGINT UNSIGNED NOT NULL,
  `permission_id` BIGINT UNSIGNED NOT NULL,
  PRIMARY KEY (`role_id`, `permission_id`),
  CONSTRAINT `fk_permission_role_role_id` FOREIGN KEY (`role_id`) REFERENCES `roles` (`id`),
  CONSTRAINT `fk_permission_role_permission_id` FOREIGN KEY (`permission_id`) REFERENCES `permissions` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ModulePlateforme — domaine 08 : Sécurité et modules
-- ATTENTION : définition incomplète dans l'audit — colonnes restantes à récupérer.
CREATE TABLE `modules_plateforme` (
  `id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- StructureModule — domaine 08 : Sécurité et modules
-- ATTENTION : définition incomplète dans l'audit — colonnes restantes à récupérer.
-- Association Structure–Module de plateforme.
CREATE TABLE `structure_modules` (
  `id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  `structure_id` BIGINT UNSIGNED NOT NULL,
  `module_plateforme_id` BIGINT UNSIGNED NOT NULL,
  PRIMARY KEY (`id`),
  CONSTRAINT `fk_structure_modules_structure_id` FOREIGN KEY (`structure_id`) REFERENCES `structures` (`id`),
  CONSTRAINT `fk_structure_modules_module_plateforme_id` FOREIGN KEY (`module_plateforme_id`) REFERENCES `modules_plateforme` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

SET FOREIGN_KEY_CHECKS = 1;