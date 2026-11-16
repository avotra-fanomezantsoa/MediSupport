# MediSupport

**L'intelligence au service de la gestion et de l'assistance.**

Plateforme web de gestion des incidents et des stocks avec assistant intelligent, conçue pour une clinique privée (exemple : la Clinique Saint-Louis).

## Présentation

Dans une clinique, les pannes informatiques ne sont pas suivies, le stock de consommables est constaté trop tard et les solutions aux problèmes déjà rencontrés ne sont pas conservées. MediSupport répond à ces trois problèmes :

- **Incidents** : les employés signalent un problème sous forme de ticket, les techniciens le traitent, le responsable suit tout.
- **Stock** : suivi des produits, des fournisseurs et des dates de péremption, avec prévision des ruptures.
- **Assistant** : une base de solutions et un assistant qui répond à partir des procédures de la clinique, en citant ses sources.

## Les trois rôles

| Rôle | Ce qu'il fait |
|---|---|
| Employé | Crée et suit ses tickets, consulte les solutions proposées, interroge l'assistant |
| Technicien | Traite les tickets, respecte les délais (SLA), enrichit la base de solutions |
| Responsable | Gère les comptes, le stock et les paramètres, suit le tableau de bord et les alertes |

## Fonctionnalités intelligentes

- Recherche de **tickets similaires par le sens**
- **Classement automatique** de la catégorie et de l'urgence
- **Prévision des ruptures de stock** avec comparaison de plusieurs méthodes
- **Détection d'anomalies** (pics de pannes, consommation inhabituelle)
- **Assistant avec sources** (RAG)
- **Mode hors-ligne** avec synchronisation

## Technologies

| Partie | Outil |
|---|---|
| Interface | React avec Vite |
| Serveur | Node.js avec Express |
| Base de données | MySQL (MariaDB avec XAMPP) |
| Service d'intelligence | Python avec FastAPI |

## Structure du projet

```
MediSupport/
  frontend/     Interface React
  backend/      API Node et Express
  ia-service/   Service Python (fonctions intelligentes)
```

## Prérequis

- Node.js 20 ou plus récent
- Python 3.10 ou plus récent
- MySQL 8 ou MariaDB 10.4 (par exemple avec XAMPP)
- Git

## Installation



## Auteur

FANOMEZANTSOA Avotriniaina Dinah, Génie Logiciel, École Supérieure Polytechnique d'Antsirabe.