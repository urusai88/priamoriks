В качестве базы данных в этом сценарии используется sqlite
Фронтенд на flutter. Уже собранный фронтенд в репозитории
Бекенд на Laravel

1) git clone https://github.com/urusai88/priamoriks.git
2) cd priamoriks
3) composer install
4) php artisan app:env_sqlite
5) php artisan key:generate --ansi
6) php artisan app:create_database
7) php artisan migrate:fresh
8) php artisan db:seed
9) php artisan serve

Страница доступна по адресу http://127.0.0.1:8000/
