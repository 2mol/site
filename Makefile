.PHONY: help devbuild deploy

.DEFAULT: devbuild
devbuild: ## Watch for changes, build, and serve on localhost.
	hugo server -D

deploy: ## Build, commit, and push to deployment target.
	hugo
	cd public/
	git add *
	git commit -m 'deploy'
	git push
	cd ..

help: ## Show this help.
	@fgrep -h "##" $(MAKEFILE_LIST) | fgrep -v fgrep | sed -e 's/\\$$//' | sed -e 's/##//'

