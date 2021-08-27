# Sinatra Memo App

This is a simple Memo application powered by Sinatra

## Usage

1. Create database
Start PostgreSQL and execute the following SQL
( If [PostgreSQL](https://www.postgresql.org/) is not installed in your execution environment, please install it. )
```sql
CREATE DATABASE sinatra_memo_app;
```

2. Connect sinatra_memo_app database and execute
```sql
CREATE TABLE memos (id SERIAL PRIMARY KEY, title text, content text);
```

3. Clone this repository

```shell
git clone https://github.com/tksmasaki/sinatra-memo-app.git
```

4. Change to the repository directory and install gems

```shell
bundle install
```

5. And run with

```shell
rackup -p 4567
```

6. View at [http://localhost:4567](http://localhost:4567)
7. You can do the following
   - Create new memo
   - Edit memo
   - Delete memo
