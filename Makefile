NAME     = necbaas/baas-builder-base

PROXY = --build-arg http_proxy=$(http_proxy) --build-arg https_proxy=$(http_proxy)

.PHONY: 

build:
	docker image build $(PROXY) -t $(NAME) -f Dockerfile .

push:
	docker push $(NAME)

pull:
	docker pull $(NAME)

bash:
	docker container run -it --rm $(NAME) /bin/bash
