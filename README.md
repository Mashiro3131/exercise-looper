# Exercise Looper

Exercise Looper est une application web permettant de créer et gérer des questionnaires composés de différents types de questions.

## Prérequis

- Ruby et RubyGems installés.
- MySQL ou MariaDB installé, avec le serveur démarré et la commande `mysql` disponible dans le terminal.
- Python et pip installés pour lancer la documentation MkDocs.

## Dépendances

Le projet utilise Ruby avec Rack et Puma ainsi qu'une base de données MySQL/MariaDB.

Installer les dépendances nécessaires :

```bash
gem install rack
gem install rackup
gem install puma
gem install mysql2
gem install dotenv
```

## Base de données

Le script permettant de créer la base de données se trouve dans :

```text
exercice_looper/db_schema/exercice_looper.sql
```

Depuis la racine du projet, importer la base de données :

```bash
mysql -u root -p < exercice_looper/db_schema/exercice_looper.sql
```

Toujours depuis la racine du projet, créer le fichier `.env` à partir du fichier `.env.example` :

```bash
cp exercice_looper/.env.example exercice_looper/.env
```

Puis compléter les informations de connexion dans `exercice_looper/.env` :

```env
DB_USER=
DB_PASSWORD=
DB_HOST=
DB_NAME=exercice_looper_db
```

## Lancer le serveur

Depuis la racine du projet :

```bash
cd exercice_looper
rackup
```

L'application est ensuite accessible à l'adresse : [http://127.0.0.1:9292](http://127.0.0.1:9292).

Garder ce terminal ouvert pendant l'utilisation de l'application.

## Documentation

La documentation du projet utilise MkDocs.

Installer MkDocs :

```bash
python -m pip install mkdocs
```

Dans un autre terminal, depuis la racine du projet, lancer la documentation :

```bash
cd Documentation/exercice_looper_documentation
mkdocs serve
```

La documentation est ensuite accessible à l'adresse indiquée dans le terminal.


## Projet de référence

Le projet se base sur : [https://exercice-looper.mycpnv.ch](https://exercice-looper.mycpnv.ch).

## Interface d'origine

Le dossier `exercice_looper_ui_original` contient l'interface d'origine du site de référence. Il est conservé uniquement comme base pour les styles et la mise en page.

Ce dossier ne fait pas partie de l'application développée et n'est pas nécessaire à son exécution. Le code de l'application se trouve dans le dossier `exercice_looper`.
