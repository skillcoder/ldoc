APPNAME   = ldoc
BLDBRANCH = $(shell git rev-parse --abbrev-ref HEAD)
BLDVER    = $(shell git name-rev --tags --name-only $(BLDBRANCH) | cut -d "^" -f 1)
CRDIR=skillc0der
IMG=$(APPNAME):$(BLDVER)

define tagimg
	$(if $(filter "$(BLDVER)", "undefined"), echo "undefined branch tag for tag"; exit 2)
	docker tag $(IMG) $(CRDIR)/$(IMG)
endef

define pushimg
	$(if $(filter "$(BLDVER)", "undefined"), echo "undefined branch tag for tag"; exit 3)
	docker push $(CRDIR)/$(IMG)
endef

image:
	docker build --target builder --tag ldoc-builder .
	docker build --target application --tag $(IMG) .

docker-login:
	@echo "+ $@"
	docker login

tag-image:
	@echo "+ $@ $(BLDVER)"
	$(call tagimg,$(BLDVER))

push-image: docker-login
	@echo "+ $@ $(BLDVER)"
	$(call pushimg,$(BLDVER))

run:
	docker run --rm -it $(IMG) ash

runb:
	docker run --rm -it ldoc-builder ash

ver:
	@echo "+ $@ $(BLDVER)"

release: image tag-image push-image
	@echo "+ $@ $(BLDVER)"
	echo $(CRDIR)/$(IMG)

.PHONY: all image docker-login tag-image push-image run runb ver release
