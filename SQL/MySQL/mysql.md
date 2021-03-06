# MySQL

- [Database](#database)
  - [Create a new database with specific charset](#create-a-new-database-with-specific-charset)
  - [Backup and restore database](#backup-and-restore-database)
  - [Get the charset of database](#get-the-charset-of-database)
  - [Change databases's charset to UTF](#change-databases-charset-to-utf)
- [Users](#users)
  - [Get a list of all users](#get-a-list-of-all-users)
  - [Create a new user and grant him rights](#create-a-new-user-and-grant-him-rights)
  - [Grant user rights for procedures](#grant-user-rights-for-procedures)
  - [View some user privileges](#view-some-user-privileges)
- [Get a list of all stored procedures](#get-a-list-of-all-stored-procedures)
- [Tables](#tables)
  - [Add new field](#add-new-field)
  - [Make some field to be unique](#make-some-field-to-be-unique)
  - [Add NOT NULL constraint](#add-not-null-constraint)
  - [Add a foreign key](#add-a-foreign-key)

## Database

### Create a new database with specific charset

``` sql
CREATE DATABASE DATABASE-NAME CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
```

### Backup and restore database

Save the `.sql` dump in your home folder:

``` cmd
mysqldump -u root -p database-name --routines -r ~/backup.sql
```

Drop and restore the database from this backup on another host:

``` cmd
mysql -u root -p
```

``` sql
DROP DATABASE database-name;
CREATE DATABASE database-name CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
GRANT ALL ON database-name.* TO 'someuser'@'localhost';
use database-name;
SOURCE ~/backup.sql;
```

### Get the charset of database

``` sql
SELECT default_character_set_name FROM information_schema.SCHEMATA WHERE schema_name = "YOUR-DATABASE-NAME";
```

```
+---------------------------------+
| default_character_set_name      |
+---------------------------------+
| latin1                          |
+---------------------------------+
```

### Change databases charset to UTF

``` sql
ALTER DATABASE your-database-name CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
```

And you will also need to change it for existing tables:

``` sql
ALTER TABLE your-table-name CONVERT TO CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
```

UTF-8 is a variable-length encoding. In the case of UTF-8, this means that storing one code point requires one to four bytes. However, MySQL's encoding called "utf8" only stores a maximum of three bytes per code point.

So if you want your column to support storing characters lying outside the BMP (and you usually want to), such as emoji, use "utf8mb4".

## Users

### Get a list of all users

``` sql
SELECT User FROM mysql.user;
```

### Create a new user and grant him rights

``` sql
CREATE USER 'NEW-USER'@'localhost' IDENTIFIED BY 'PASSWORD';
GRANT ALL ON DATABASE-NAME.* TO 'NEW-USER'@'localhost';
```

### Grant user rights for procedures

So he could use `mysqldump`, for example.

``` sql
GRANT SELECT ON mysql.proc to 'USERNAME'@'localhost';
```

### View some user privileges

``` sql
SHOW GRANTS FOR 'USERNAME'@'localhost';
```

``` sql
+--------------------------------------------------------------------+
| Grants for USERNAME@localhost                                      |
+--------------------------------------------------------------------+
| GRANT USAGE ON *.* TO 'USERNAME'@'localhost'                       |
| GRANT ALL PRIVILEGES ON `DATABASE`.* TO 'USERNAME'@'localhost'     |
| GRANT SELECT ON `mysql`.`proc` TO 'USERNAME'@'localhost'           |
+--------------------------------------------------------------------+
3 rows in set (0.00 sec)
```

## Get a list of all stored procedures

...and functions for the current database:

```sql
SELECT name, type FROM mysql.proc WHERE db = database();
```

## Fields

### Add new field

``` sql
ALTER TABLE table-name ADD new-field-name VARCHAR(50) AFTER some-existing-field;
```

### Make some field to be unique

``` sql
ALTER TABLE table-name ADD UNIQUE (column-name);
```

### Add NOT NULL constraint

``` sql
ALTER TABLE table-name MODIFY column-name INT NOT NULL;
```

### Add a foreign key

``` sql
ALTER TABLE this-table ADD CONSTRAINT `this-other` FOREIGN KEY (`column-from-this-table`) REFERENCES `other-table` (`column-from-other-table`);
```
