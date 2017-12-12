IMG = pwn-kaname-changebyone
CTN = changebyone

build:
	docker build -t $(IMG) .

export: build
	mkdir -p export
	docker run --rm --entrypoint cat $(IMG) /srv/changebyone > export/changebyone
	cp src/changebyone.c src/changebyone.py export/

up: build
	docker run -d -p 5796:5796 --name $(CTN) $(IMG)

down:
	-docker rm -f $(CTN)

logs:
	docker logs -f $(CTN)

clean: down
	-docker rmi $(IMG)
	rm -rf export

.PHONY: build export up down logs clean
