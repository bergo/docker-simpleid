# Docker SimpleID

Docker Image for [SimpleID](https://github.com/simpleid/simpleid). Build to use behind an HTTPS-Proxy.

Create an identity from [user template](https://github.com/simpleid/simpleid/tree/release-1.0.2/identities), customize `config.php` and build the image:

	docker build -t simpleid .

Run the container. 

	docker run -v `pwd`/identities:/data/simpleid/identities --restart=always -d --name simpleid -p 127.0.0.1:80:80 simpleid
