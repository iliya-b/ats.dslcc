
clean: ;

docker-images:
	docker build -t aic.dslcc -f Dockerfile .

