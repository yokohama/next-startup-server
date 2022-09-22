#アプリ作時の初回のみ実行かつinuxでしか動かない。
#cloneして開発をする場合は不要です。
new:
	touch Gemfile
	touch Gemfile.lock
	#docker compose run api rails new . --force --api --d=postgresql -T -B --skip-webpack-install
	docker compose run api rails new . --force --database=postgresql
	ls -la |sed 's/[\t ]\+/\t/g' | cut -f9 | xargs sudo chown -R ${USER}.${USER}
	echo "$$_database_yml" > config/database.yml
	echo gem \'dotenv-rails\' >> Gemfile
	docker compose run api bundle install
	echo "$$_dot_env" > .env
	docker compose up db -d
	docker compose run api sh -c 'sleep 3 && rake db:create'
	docker compose down

define _database_yml
default: &default
  adapter: postgresql
  encoding: unicode
  pool: <%= ENV.fetch("RAILS_MAX_THREADS") { 5 } %>
  timeout: 5000

development:
  <<: *default
  host: <%= ENV['DATABASE_HOST'] %>
  username: <%= ENV['DATABASE_USER'] %>
  password: <%= ENV['DATABASE_PASSWORD'] %>
  database: <%= ENV['DATABASE_NAME'] %>

test:
  <<: *default
  host: <%= ENV['DATABASE_HOST'] %>
  username: <%= ENV['DATABASE_USER'] %>
  password: <%= ENV['DATABASE_PASSWORD'] %>
  database: <%= ENV['DATABASE_NAME'] %>

production:
  <<: *default
  host: <%= ENV['DATABASE_HOST'] %>
  username: <%= ENV['DATABASE_USER'] %>
  password: <%= ENV['DATABASE_PASSWORD'] %>
  database: <%= ENV['DATABASE_NAME'] %>
endef
export _database_yml

define _dot_env
DATABASE_HOST=db
DATABASE_USER=postgres
DATABASE_PASSWORD=password
DATABASE_NAME=local_db
endef
export _dot_env

build:
	docker compose build

up:
	docker compose up

down:
	docker compose down
