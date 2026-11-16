SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;
DROP TABLE IF EXISTS conversations_assistant, passages_documents, articles_connaissance,
  alertes, previsions, mouvements_stock, lots, produits, fournisseurs, historique_tickets,
  commentaires, tickets, parametres_sla, utilisateurs, categories, services;
SET FOREIGN_KEY_CHECKS = 1;

CREATE TABLE services (
  id INT AUTO_INCREMENT PRIMARY KEY,
  nom VARCHAR(100) NOT NULL UNIQUE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE categories (
  id INT AUTO_INCREMENT PRIMARY KEY,
  nom VARCHAR(100) NOT NULL UNIQUE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE utilisateurs (
  id INT AUTO_INCREMENT PRIMARY KEY,
  nom VARCHAR(100) NOT NULL,
  email VARCHAR(150) NOT NULL UNIQUE,
  mot_de_passe VARCHAR(255) NOT NULL,
  role ENUM('employé','technicien','responsable') NOT NULL,
  service_id INT NULL,
  actif TINYINT(1) NOT NULL DEFAULT 1,
  cree_le DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (service_id) REFERENCES services(id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE parametres_sla (
  id INT AUTO_INCREMENT PRIMARY KEY,
  urgence ENUM('faible','normale','urgente') NOT NULL UNIQUE,
  delai_heures INT NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE fournisseurs (
  id INT AUTO_INCREMENT PRIMARY KEY,
  nom VARCHAR(150) NOT NULL,
  telephone VARCHAR(30) NULL,
  email VARCHAR(150) NULL,
  delai_livraison_jours INT NOT NULL DEFAULT 3
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE produits (
  id INT AUTO_INCREMENT PRIMARY KEY,
  nom VARCHAR(150) NOT NULL UNIQUE,
  unite VARCHAR(50) NOT NULL,
  seuil_alerte INT NOT NULL DEFAULT 0,
  fournisseur_id INT NULL,
  actif TINYINT(1) NOT NULL DEFAULT 1,
  FOREIGN KEY (fournisseur_id) REFERENCES fournisseurs(id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE lots (
  id INT AUTO_INCREMENT PRIMARY KEY,
  produit_id INT NOT NULL,
  quantite_recue INT NOT NULL,
  quantite_restante INT NOT NULL,
  date_reception DATE NOT NULL,
  date_peremption DATE NULL,
  INDEX idx_lots_peremption (date_peremption),
  FOREIGN KEY (produit_id) REFERENCES produits(id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE tickets (
  id INT AUTO_INCREMENT PRIMARY KEY,
  titre VARCHAR(150) NOT NULL,
  description TEXT NOT NULL,
  urgence ENUM('faible','normale','urgente') NOT NULL DEFAULT 'normale',
  statut ENUM('ouvert','en cours','résolu','clôturé') NOT NULL DEFAULT 'ouvert',
  service_id INT NULL,
  categorie_id INT NULL,
  demandeur_id INT NULL,
  technicien_id INT NULL,
  produit_id INT NULL,
  cree_le DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  echeance_sla DATETIME NULL,
  resolu_le DATETIME NULL,
  solution TEXT NULL,
  embedding LONGTEXT NULL,
  cree_hors_ligne TINYINT(1) NOT NULL DEFAULT 0,
  INDEX idx_tickets_statut (statut),
  INDEX idx_tickets_cree_le (cree_le),
  FOREIGN KEY (service_id) REFERENCES services(id),
  FOREIGN KEY (categorie_id) REFERENCES categories(id),
  FOREIGN KEY (demandeur_id) REFERENCES utilisateurs(id),
  FOREIGN KEY (technicien_id) REFERENCES utilisateurs(id),
  FOREIGN KEY (produit_id) REFERENCES produits(id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE commentaires (
  id INT AUTO_INCREMENT PRIMARY KEY,
  ticket_id INT NOT NULL,
  auteur_id INT NOT NULL,
  texte TEXT NOT NULL,
  interne TINYINT(1) NOT NULL DEFAULT 0,
  cree_le DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (ticket_id) REFERENCES tickets(id) ON DELETE CASCADE,
  FOREIGN KEY (auteur_id) REFERENCES utilisateurs(id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE historique_tickets (
  id INT AUTO_INCREMENT PRIMARY KEY,
  ticket_id INT NOT NULL,
  utilisateur_id INT NULL,
  action VARCHAR(100) NOT NULL,
  ancienne_valeur VARCHAR(255) NULL,
  nouvelle_valeur VARCHAR(255) NULL,
  `date` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (ticket_id) REFERENCES tickets(id) ON DELETE CASCADE,
  FOREIGN KEY (utilisateur_id) REFERENCES utilisateurs(id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE mouvements_stock (
  id INT AUTO_INCREMENT PRIMARY KEY,
  produit_id INT NOT NULL,
  lot_id INT NULL,
  type ENUM('entrée','sortie','correction') NOT NULL,
  quantite INT NOT NULL,
  motif VARCHAR(150) NULL,
  service_id INT NULL,
  ticket_id INT NULL,
  utilisateur_id INT NULL,
  `date` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  INDEX idx_mouv_produit_date (produit_id, `date`),
  FOREIGN KEY (produit_id) REFERENCES produits(id),
  FOREIGN KEY (lot_id) REFERENCES lots(id),
  FOREIGN KEY (service_id) REFERENCES services(id),
  FOREIGN KEY (ticket_id) REFERENCES tickets(id) ON DELETE SET NULL,
  FOREIGN KEY (utilisateur_id) REFERENCES utilisateurs(id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE previsions (
  id INT AUTO_INCREMENT PRIMARY KEY,
  produit_id INT NOT NULL,
  methode VARCHAR(50) NOT NULL,
  rupture_estimee DATE NULL,
  erreur_mae DECIMAL(10,3) NULL,
  retenue TINYINT(1) NOT NULL DEFAULT 0,
  calculee_le DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (produit_id) REFERENCES produits(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE alertes (
  id INT AUTO_INCREMENT PRIMARY KEY,
  type ENUM('pannes','stock') NOT NULL,
  description VARCHAR(500) NOT NULL,
  reference_id INT NULL,
  etat ENUM('nouvelle','vue','traitée') NOT NULL DEFAULT 'nouvelle',
  cree_le DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE articles_connaissance (
  id INT AUTO_INCREMENT PRIMARY KEY,
  titre VARCHAR(200) NOT NULL,
  probleme TEXT NOT NULL,
  solution TEXT NOT NULL,
  categorie_id INT NULL,
  etat ENUM('brouillon','à valider','validé') NOT NULL DEFAULT 'brouillon',
  ticket_source_id INT NULL,
  auteur_id INT NULL,
  embedding LONGTEXT NULL,
  FOREIGN KEY (categorie_id) REFERENCES categories(id),
  FOREIGN KEY (ticket_source_id) REFERENCES tickets(id) ON DELETE SET NULL,
  FOREIGN KEY (auteur_id) REFERENCES utilisateurs(id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE passages_documents (
  id INT AUTO_INCREMENT PRIMARY KEY,
  titre_document VARCHAR(200) NOT NULL,
  texte TEXT NOT NULL,
  embedding LONGTEXT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE conversations_assistant (
  id INT AUTO_INCREMENT PRIMARY KEY,
  utilisateur_id INT NOT NULL,
  question TEXT NOT NULL,
  reponse TEXT NULL,
  sources VARCHAR(500) NULL,
  utile TINYINT(1) NULL,
  `date` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (utilisateur_id) REFERENCES utilisateurs(id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;