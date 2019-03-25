GRANT ALL PRIVILEGES ON *.* TO 'root'@'%' IDENTIFIED BY '{{ .Values.rootUser.password }}' WITH GRANT OPTION;
