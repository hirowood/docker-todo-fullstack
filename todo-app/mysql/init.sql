CREATE DATABASE IF NOT EXISTS todo_development;
CREATE DATABASE IF NOT EXISTS todo_test;

GRANT ALL PRIVILEGES ON todo_development.* TO 'todo_user'@'%';
GRANT ALL PRIVILEGES ON todo_test.* TO 'todo_user'@'%';
FLUSH PRIVILEGES;
