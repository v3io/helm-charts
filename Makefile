HELM=helm
HELM_REPO_DEFAULT := https://v3io.github.io/helm-charts
HELM_REPO_ROOT := $(if $(HELM_REPO_OVERRIDE),$(HELM_REPO_OVERRIDE),$(HELM_REPO_DEFAULT))
WORKDIR := stable

.PHONY: stable
stable: WORKDIR = stable

stable: repo-helm update-req package-all index
	@echo "Done"

.PHONY: demo
demo: WORKDIR = demo

demo: repo-helm update-req package-all index
	@echo "Done"

.PHONY: incubator
incubator: WORKDIR = incubator

incubator: repo-helm update-req package-all index
	@echo "Done"

helm-publish:
	@echo "Preparing to release a new index"
	@rm -rf /tmp/v3io-helm-charts
	@git clone git@github.com:v3io/helm-charts /tmp/v3io-helm-charts
	@cd /tmp/v3io-helm-charts && \
		git checkout gh-pages && \
		git merge development --message "Merge development into gh-pages" && \
		REF_SHA=$$(git log development -1 | head -1) && \
		make stable && \
		git add --force stable/*tgz && \
		git add stable/* && \
		git commit --message "Merging stable $$REF_SHA" && \
		make demo && \
		git add --force demo/*tgz && \
		git add demo/* && \
		git commit --message "Merging demo $$REF_SHA" && \
		make incubator && \
		git add --force incubator/*tgz && \
		git add incubator/* && \
		git commit --message "Merging incubator $$REF_SHA" && \
		git push
	@rm -rf /tmp/v3io-helm-charts
	@echo "New index released!"

print-versions:
	@cd $(WORKDIR) && for chart in $$(ls -d */); do \
		CHART_VERSION=$$(grep version $$chart/Chart.yaml | cut -f2 -d:) ;\
		echo "# $$chart -->$$CHART_VERSION" ;\
		if [ -e "$$chart/requirements.yaml" ]; then \
			echo "depends on:" ;\
			echo "$$(grep -v alias $$chart/requirements.yaml | grep -A 1 name | grep -ve '^--')" ; \
		fi \
	done

update-req:
	@echo "Updating chart requirements"
	@cd $(WORKDIR) && for chart in $$(ls); do \
		if [ -e "$$chart/requirements.yaml" ]; then \
			echo "Updating '$$chart' requirements" ; \
			$(HELM) dependency build $$chart ; \
			if [ "$$?" != "0" ]; then \
				echo "Chart $$chart failed dependency build" ; \
				exit 103 ; \
			fi ; \
		fi ; \
	done

package-all:
	@echo "Packing charts"
	@cd $(WORKDIR) && for chart in $$(ls -d */); do \
		$(HELM) lint $$chart ; \
		if [ "$$?" != "0" ]; then \
			echo "Chart $$chart failed lint" ; \
			exit 101 ; \
		fi ; \
		$(HELM) package $$chart ; \
		if [ "$$?" != "0" ]; then \
			echo "Chart $$chart failed package" ; \
			exit 102 ; \
		fi ; \
	done

index:
	@echo "Generating index.yaml"
	$(HELM) repo index --merge $(WORKDIR)/index.yaml --url $(HELM_REPO_ROOT)/$(WORKDIR) $(WORKDIR)
	@if [ "$$?" != "0" ]; then \
		echo "Failed repo index" ; \
		exit 111 ; \
	fi ; \

repo-helm: check-helm
HELM_REPO := $(HELM_REPO_ROOT)/$(WORKDIR)
$(debug $(shell $(HELM) repo add v3io-$(WORKDIR) $(HELM_REPO)))

check-helm:
	@echo "Checking if helm command exists"
	@$(HELM) home &> /dev/null
	@if [ "$$?" != "0" ]; then \
		echo "Missing helm command" ; \
		exit 2 ; \
	fi
