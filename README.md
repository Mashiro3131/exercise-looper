# exercise-looper

# Strategie de commits

# Stack de technologies

# Deployement

# Base de données
le script de creation de DB et des tables est present dans /exercice_looper_ws/db_schema/exercice_looper.sql



## Deployer l’API
### Installation des dépendances

Install global des gems nécessaires à l'api :

```bash
gem install rack
gem install puma
gem install mysql2
```

### Configuration des variables d'environment

copier et remplir les variables d'environmnet dans le fichier .env.example vers un fichier .env , dans /exercice_looper_ws

```text
DB_USER=
DB_PASSWORD=
DB_HOST=
DB_NAME=
```

#### Démarrage de l’API

Depuis la racine du projet avec le fichier de config rack :

```bash
puma ws_config.ru
```

L’API est disponible sur (par defaut) :

```text
http://localhost:9292
```

## Deployer la documentation en local
### Installation des dépendances
Verifier si python est installé
 ```bash
 python --version
```

Installer mkdocs
 ```bash
 pip install mkdocs
```

Dans le dossier de la documentation lancer le serveur mkdocs

```bash
 cd Documentation/exercice_looper_documentation
```

```bash
 mkdocs serve
```