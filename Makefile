.DEFAULT_GOAL:=help
.PHONY: all help clean release major minor patch update
.PRECIOUS:
.ONESHELL:
SHELL:=/bin/bash
VERSION_MK:=0.0.1

VERSION:=$(shell git describe --abbrev=0 --tags 2> /dev/null)
CURRENT_BRANCH:=$(shell git rev-parse --abbrev-ref HEAD 2> /dev/null)
NAME:=$(shell [ -e .registry ] && cat .registry)
MKNAME:=$(firstword $(MAKEFILE_LIST))

all:
	@echo ==============================================
	@[ -n "$$PRE_COMMIT" ] && echo "-n PRE_COMMIT $$PRE_COMMIT"
	@[ -z "$$PRE_COMMIT" ] && echo "-z PRE_COMMIT ask"
	@echo MAKEFILE_LIST: ${MAKEFILE_LIST}
	@echo MAKE: $(MAKE)
	@echo MAKEFILE_LIST_CHILD: ${MAKEFILE_LIST_CHILD}
	@echo ==============================================

-include mkfiles/*.mk

bootstrap_common::
	@[ -n "$$PRE" ] && exit 0

git_commit_common::
	@[ -n "$$PRE" ] && exit 0
	@echo === git commit common =====================================
	@git add .
	@[ -n "$$PRE_COMMIT" ] && (git commit -a -m "$$PRE_COMMIT" || true)
	@[ -n "$$PRE_COMMIT" ] && (git commit -a || true)

git_push_common:: git_commit_common
	@[ -n "$$PRE" ] && exit 0
	@echo === git push common =======================================
	@git push --all 2>/dev/null || true
	@git push --tags 2>/dev/null || true

patch_common::
	@echo === patch common ==========================================
	make release V=patch


MAKEFILE_LIST_CHILD:=`find ./mkfiles/ \( -name 'Makefile' -o -name '*.mk' ! -name 'null.mk' ! -name 'include.mk' \) 2> /dev/null`

# self-documented makefile
help: ## Help
#	@echo ${MAKEFILE_LIST}
#	@echo $(MAKEFILE_LIST_CHILD)
	@awk 'BEGIN {FS = ":.*?## "} /^[a-zA-Z_-]+:.*?## / {sub("\\\\n",sprintf("\n%22c"," "), $$2);printf "\033[36m%-20s\033[0m %s\n", $$1, $$2}' ${MAKEFILE_LIST}
#	@echo ""
#	@echo "Files:"
#	@for file in $(MAKEFILE_LIST_CHILD); do echo "	$$file"; awk 'BEGIN {FS = ":.*?## "} /^[a-zA-Z_-]+:.*?## / {sub("\\\\n",sprintf("\n%22c"," "), $$2);printf "\033[36m%-20s\033[0m %s\n", $$1, $$2}' $$file; done
#	@echo ""
#	@echo ""

clean: ## Clean

git_commit: git_commit_common
	@echo === git commit ============================================

git_push: git_push_common
	@echo === git push ===================================================

V?=minor
release: git_push
	@echo === advbumpversion $(V) ========================================
	@advbumpversion $(V)
	
	@echo === checkout to master with submodules =========================
	@git submodule foreach git checkout master
	@git checkout master
	
	@echo === commit before merge ========================================
	@git add .
	@git commit -a -m "Auto before_merge commit submodules" || :
	
	@echo === merge ======================================================
	@git merge --no-edit --commit -X theirs develop || ( git add . ; git commit -a -m Auto )
	
	@echo === commit after merger ========================================
	@git add .
	@git commit -a -m "Auto after_merge commit submodules" || :
	
	@echo === advbumpversion build and push ==============================
	@advbumpversion build
	
	@git push --all
	@git push --tags
	
	@git submodule foreach git checkout develop || :
	@git checkout develop

checkout_develop:
	@git submodule foreach git checkout develop || :
	@git checkout develop

checkout_master:
	@git submodule foreach git checkout master || :
	@git checkout master

dev:
	@advbumpversion build

major:
	make release V=major

minor:
	make release V=minor

patch: patch_common

init:
	git pull --all
	git pull --tags
	git submodule init
	git submodule update
	@git submodule foreach git checkout $(CURRENT_BRANCH)
	@if [[ "$(CURRENT_BRANCH)" == "develop" ]]; \
	then \
	  echo "Develop branch"; \
	  git fetch origin master:master; \
	  git submodule foreach git fetch origin master:master || :; \
	  git submodule foreach git pull origin develop || :; \
	fi
	@if [[ "$(CURRENT_BRANCH)" == "master" ]]; \
	then \
	  echo "Master"; \
	  git fetch origin develop:develop; \
	  git submodule foreach git fetch origin develop:develop || :; \
	  git submodule foreach git pull origin master || :; \
	fi
	@git submodule foreach git branch -u origin/master master
	@git submodule foreach git branch -u origin/develop develop
	@git submodule foreach git pull
	#git submodule update --init

bootstrap: bootstrap_common

#### Makefile: # FORCE
#### FORCE:
update:
	@curl -s file:///home/max/1/Makefile -o $(MKNAME).tmp
	@cmp -s $(MKNAME) $(MKNAME).tmp && rm -f $(MKNAME).tmp || (echo UPDATE; mv -f $(MKNAME).tmp $(MKNAME))
