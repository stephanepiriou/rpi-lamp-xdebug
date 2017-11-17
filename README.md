rpi-lamp-xdebug
=================

Out-of-the-box LAMP image (PHP+MySQL) for Raspberry Pi (based raspbian)


Usage
-----

To create the image `stephanepiriou/rpi-lamp-xdebug` under your repo, execute the following command on the rpi-lamp-xdebug folder:

	docker build -t 'your-repo-here'/rpi-lamp-xdebug .

You can now push your new image to the registry:

	docker push 'your-repo-here'/rpi-lamp-xdebug


## ENV

> ### <u>Debian</u>
>
> **DEBIAN_FRONTEND** = (`interactive` **or** `noninteractive`) post-install (default : `noninteractive`)

> ### <u>MySQL</u>
>
> **MYSQL_PASS** = (default : randomized)

> ### <u>PHP</u>
>
> **PHP_UPLOAD_MAX_FILESIZE** = Maximum size (default : `50M`)
>
> **PHP_POST_MAX_SIZE** = Maximum size (default : `50M`)

> ### <u>Xdebug</u>
>
> **ZEND_EXTENSION** = Place of xdebug.so (default : `/usr/lib/php5/20100525+lfs/xdebug.so`)
>
> **REMOTE_ENABLE** = (`1` **or** `0`) (default : `1`)
>
> **REMOTE_HANDLER** = (default : `dbgp`)
>
> **REMOTE_MODE** = Debug mode (`jit` **or** `req`) (default : `jit`)
>
> **REMOTE_HOST** = Remote host address (default : `127.0.0.1`)
>
> **REMOTE_PORT** = Remote port, to mirror in IDE setting (default : `9000`)
>
> **IDEKEY** = IDE key code to enter in IDE (`netbeans`, `phpstorm`,…) (default : `phpstorm`)



Running your LAMP docker image
------------------------------

Start your image binding the external ports 80 and 3306 in all interfaces to your container:

	docker run -d -p 80:80 -p 3306:3306 rpi-lamp-xdebug

Test your deployment:

	curl http://localhost/

Hello world!


Loading your custom PHP application
-----------------------------------

In order to replace the "Hello World" application that comes bundled with this docker image,
create a new `Dockerfile` in an empty folder with the following contents:

	FROM stephanepiriou/rpi-lamp-xdebug:latest
	RUN rm -fr /app && git clone https://github.com/username/customapp.git /app
	EXPOSE 80 3306
	CMD ["/run.sh"]

replacing `https://github.com/username/customapp.git` with your application's GIT repository.
After that, build the new `Dockerfile`:

	docker build -t username/my-lamp-app .

And test it:

	docker run -d -p 80:80 -p 3306:3306 username/my-lamp-app

Test your deployment:

	curl http://localhost/

That's it!


Connecting to the bundled MySQL server from within the container
----------------------------------------------------------------

The bundled MySQL server has a `root` user with no password for local connections.
Simply connect from your PHP code with this user:

	<?php
	$mysql = new mysqli("localhost", "root");
	echo "MySQL Server info: ".$mysql->host_info;
	?>


Connecting to the bundled MySQL server from outside the container
-----------------------------------------------------------------

The first time that you run your container, a new user `admin` with all privileges 
will be created in MySQL with a random password. To get the password, check the logs
of the container by running:

	docker logs $CONTAINER_ID

You will see an output like the following:

	========================================================================
	You can now connect to this MySQL Server using:
	
	    mysql -uadmin -p47nnf4FweaKu -h<host> -P<port>
	
	Please remember to change the above password as soon as possible!
	MySQL user 'root' has no password but only allows local connections
	========================================================================

In this case, `47nnf4FweaKu` is the password allocated to the `admin` user.

You can then connect to MySQL:

	 mysql -uadmin -p47nnf4FweaKu

Remember that the `root` user does not allow connections from outside the container - 
you should use this `admin` user instead!


Setting a specific password for the MySQL server admin account
--------------------------------------------------------------

If you want to use a preset password instead of a random generated one, you can
set the environment variable `MYSQL_PASS` to your specific password when running the container:

	docker run -d -p 80:80 -p 3306:3306 -e MYSQL_PASS="mypass" stephanepiriou/rpi-lamp-xdebug

You can now test your new admin password:

	mysql -uadmin -p"mypass"


Disabling .htaccess
--------------------

`.htaccess` is enabled by default. To disable `.htaccess`, you can remove the following contents from `Dockerfile`

	# config to enable .htaccess
	ADD apache_default /etc/apache2/sites-available/000-default.conf
	RUN a2enmod rewrite

**based http://www.tutum.co**



## Configuring xdebug

Xdebug is activated by default. See above [ENV](#ENV)