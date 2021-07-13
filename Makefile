###############################
# Common defaults/definitions #
###############################

comma := ,

# Checks two given strings for equality.
eq = $(if $(or $(1),$(2)),$(and $(findstring $(1),$(2)),\
                                $(findstring $(2),$(1))),1)



######################
# Project parameters #
######################

MAINLINE_BRANCH := master
CURRENT_BRANCH := $(shell git branch | grep \* | cut -d ' ' -f2)
JEKYLL_VERSION=latest
NODE_VER=latest
IMAGE_NAME := registry.gitlab.com/karamba-project/karma-info.io



###########
# Aliases #
###########

# Squash changes of the current Git branch onto another Git branch.
#
# Usage:
#	make squash

squash: git.squash

# Build all project files.
#
# Usage:
#	make build

build: jekyll.build

# Run project.
#
# Usage:
#	make run

run: jekyll.run


###################
# jekyll commands #
###################

# Build jekyll static site.
#
# Usage:
#	make jekyll.build

jekyll.build:
	docker run --rm -v=$(PWD):/srv/jekyll \
		-v $(PWD)/.bundle:/usr/local/bundle \
		-it jekyll/jekyll:$(JEKYLL_VERSION) \
		jekyll build --verbose

# Run serving of jekyll static site.
#
# Usage:
#	make run.
jekyll.run:
	docker run --rm --name jekill-static -v="$(PWD):/srv/jekyll" \
		-v $(PWD)/.bundle:/usr/local/bundle \
		-p 4000:4000 -it \
		jekyll/jekyll:$(JEKYLL_VERSION) jekyll serve --watch --drafts




###################
# Docker commands #
###################

# Authenticate to GitLab Container Registry where project Docker images
# are stored.
#
# Usage:
#	make docker.auth [user=<gitlab-username>] [pass-stdin=(no|yes)]

docker.auth:
	docker login $(word 1,$(subst /, ,$(IMAGE_NAME))) \
		$(if $(call eq,$(user),),,--username=$(user)) \
		$(if $(call eq,$(pass-stdin),yes),--password-stdin,)

# Build docker image
#
# Usage:
#	make docker.build [IMAGE=(<empty>|<docker-image-postfix>)]
#	                  [TAG=(dev|<tag>)]
#	                  [no-cache=(no|yes)]

docker-build-image-name = $(IMAGE_NAME)$(if $(call eq,$(IMAGE),),,/$(IMAGE))
docker-build-dir = .

docker.build:
	docker build --network=host --force-rm \
		$(if $(call eq,$(no-cache),yes),--no-cache --pull,) \
		-t $(docker-build-image-name):$(if $(call eq,$(TAG),),dev,$(TAG)) \
		$(docker-build-dir)/


# Pull project Docker images from GitLab Container Registry.
#
# Usage:
#	make docker.pull [IMAGE=(<empty>|db/mysql|<docker-image-postfix>)]
#	                 [TAGS=(dev|@all|<t1>[,<t2>...])]

docker-pull-image-name = $(IMAGE_NAME)$(if $(call eq,$(IMAGE),),,/$(IMAGE))
docker-pull-tags = $(if $(call eq,$(TAGS),),dev,$(TAGS))

docker.pull:
ifeq ($(docker-pull-tags),@all)
	docker pull $(docker-pull-image-name) --all-tags
else
	$(foreach tag, $(subst $(comma), ,$(docker-pull-tags)),\
		$(call docker.pull.do, $(tag)))
endif
define docker.pull.do
	$(eval tag := $(strip $(1)))
	docker pull $(docker-pull-image-name):$(tag)
endef


# Push project Docker images to GitLab Container Registry.
#
# Usage:
#	make docker.push [IMAGE=(<empty>|<docker-image-postfix>)]
#	                 [TAGS=(dev|<t1>[,<t2>...])]

docker-push-image-name = $(IMAGE_NAME)$(if $(call eq,$(IMAGE),),,/$(IMAGE))
docker-push-tags = $(if $(call eq,$(TAGS),),dev,$(TAGS))

docker.push:
	$(foreach tag, $(subst $(comma), ,$(docker-push-tags)),\
		$(call docker.push.do, $(tag)))
define docker.push.do
	$(eval tag := $(strip $(1)))
	docker push $(docker-push-image-name):$(tag)
endef




################
# Git commands #
################

# Squash changes of the current Git branch onto another Git branch.
#
# WARNING: You must merge `onto` branch in the current branch before squash!
#
# Usage:
#	make git.squash [onto=(<mainline-git-branch>|<git-branch>)]
#	                [del=(no|yes)]
#	                [upstream=(origin|<git-remote>)]

onto ?= $(MAINLINE_BRANCH)
upstream ?= origin

git.squash:
ifeq ($(CURRENT_BRANCH),$(onto))
	echo "--> Current branch is '$(onto)' already" && false
endif
	git checkout $(onto)
	git branch -m $(CURRENT_BRANCH) orig-$(CURRENT_BRANCH)
	git checkout -b $(CURRENT_BRANCH)
	git branch --set-upstream-to $(upstream)/$(CURRENT_BRANCH)
	git merge --squash orig-$(CURRENT_BRANCH)
ifeq ($(del),yes)
	git branch -d orig-$(CURRENT_BRANCH)
endif




##################
# .PHONY section #
##################

.PHONY: squash docker.build \
        git.squash
