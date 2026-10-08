# Exercise Looper
Exercise Looper est une application web permettant de créer et gérer des questionnaires composés de différents types de questions.

## Dépendances
Le projet utilise Ruby avec Rack et Puma ainsi qu'une base de données MySQL/MariaDB.

Installer les dépendances nécessaires:
```bash
gem install rack
gem install puma
gem install mysql2
gem install dotenv
```

## Base de données
Le script permettant de créer la base de données se trouve dans:
```text
exercice_looper_ws/db_schema/exercice_looper.sql
```

Pour importer la base de données:
```bash
mysql -u root -p < exercice_looper_ws/db_schema/exercice_looper.sql
```

Créer ensuite le fichier `.env` à partir du fichier `.env.example`:
```bash
cp exercice_looper_ws/.env.example exercice_looper_ws/.env
```

Puis compléter les informations de connexion à la base de données:
```env
DB_USER=
DB_PASSWORD=
DB_HOST=
DB_NAME=exercice_looper_db
```

## Lancer le serveur
Depuis la racine du projet:
```bash
cd exercice_looper_ws
puma config.ru
```

L'application est ensuite accessible à l'adresse:
```text
http://localhost:9292
```

## Documentation
La documentation du projet utilise MkDocs.

Installer MkDocs:
```bash
python -m pip install mkdocs
```

Pour lancer la documentation:
```bash
cd Documentation/exercice_looper_documentation
mkdocs serve
```

La documentation est ensuite accessible à l'adresse indiquée dans le terminal.

## Stratégie de commits
Les commits suivent la convention suivante:
```text
feat: nouvelle fonctionnalité
fix: correction d'un bug
refactor: modification du code sans changement fonctionnel
docs: modification de la documentation
chore: maintenance du projet
```

## Exercice Looper Production
Le projet se base sur: https://exercice-looper.mycpnv.ch
