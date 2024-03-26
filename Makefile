.DEFAULT_GOAL:=help
.PHONY: all help clean release major minor patch
.PRECIOUS:
SHELL:=/bin/bash

VERSION:=$(shell git describe --abbrev=0 --tags)
CURRENT_BRANCH:=$(shell git rev-parse --abbrev-ref HEAD)

help:
	@echo -e "\033[33mUsage:\033[0m\n  make TARGET\n\n\033[33mTargets:\033[0m"
	@grep -E '^[a-zA-Z0-9_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "  \033[32m%-7s\033[0m %s\n", $$1, $$2}'

git_commit:
	@git add .
	@git commit -a -m "Auto" || true

git_push: git_commit
	@git push --all
	@git push --tags

build:
	go build -o ipsec_exporter ./cmd/ipsec_exporter

bootstrap:
	git remote add cloudalchemy https://github.com/cloudalchemy/ansible-node-exporter.git || :
	git remote add binbashar https://github.com/binbashar/ansible-node-exporter.git || :
	git remote add superbet-group https://github.com/superbet-group/sre.ansible-role-on-prem-node-exporter || :
	git remote add RatioformIT https://github.com/RatioformIT/ansible-node-exporter.git || :
	git remote add artefactual-labs https://github.com/artefactual-labs/ansible-node-exporter.git || :
	git remote add sdarwin https://github.com/sdarwin/ansible-node-exporter.git || :

	git pull --all

worktree:
	git worktree add ../ansible-node-exporter.cloudalchemy; cd ../ansible-node-exporter.cloudalchemy; git checkout cloudalchemy/master || :
	git worktree add ../ansible-node-exporter.binbashar; cd ../ansible-node-exporter.binbashar; git checkout binbashar/master || :
	git worktree add ../ansible-node-exporter.superbet-group; cd ../ansible-node-exporter.superbet-group; git checkout superbet-group/master || :
	git worktree add ../ansible-node-exporter.RatioformIT; cd ../ansible-node-exporter.RatioformIT; git checkout RatioformIT/master || :
	git worktree add ../ansible-node-exporter.artefactual-labs; cd ../ansible-node-exporter.artefactual-labs; git checkout artefactual-labs/master || :
	git worktree add ../ansible-node-exporter.sdarwin; cd ../ansible-node-exporter.sdarwin; git checkout sdarwin/master || :
