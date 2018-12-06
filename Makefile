NAME     = necbaas/baas-builder-base

.PHONY: 

build:
	docker image build -t $(NAME) -f Dockerfile .

push:
	docker push $(NAME)

pull:
	docker pull $(NAME)

bash:
	docker container run -it --rm $(NAME) /bin/bash
