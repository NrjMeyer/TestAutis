# Vaincre l'autisme
### Powered by sulu

How to install :

#### 1) Database

Create a database in your favorite sql administrator, and complete the field `database_name` and `database_password` in the `app/config/parameters.yml` file

#### 2) Populate the database

```bash

# Run this command to populate the database
bin/adminconsole sulu:build dev

```

#### 3) Run the server

```bash
# To run the admin on port 8000
bin/adminconsole server:start

# To run the front server on port 8001
bin/websiteconsole server:start

# Replace start by stop to stop the server on both command

```

Default login and password are admin / admin
