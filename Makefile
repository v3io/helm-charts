GITHUB_BRANCH_DEFAULT := development
GITHUB_BRANCH := $(if $(GITHUB_BRANCH_OVERRIDE),$(GITHUB_BRANCH_OVERRIDE),$(GITHUB_BRANCH_DEFAULT))

HELM=helm
HELM_REPO_DEFAULT := https://v3io.github.io/helm-charts
HELM_REPO_ROOT := $(if $(HELM_REPO_OVERRIDE),$(HELM_REPO_OVERRIDE),$(HELM_REPO_DEFAULT))
WORKDIR := stable
HELM_REPO := $(HELM_REPO_ROOT)/$(WORKDIR)
CHART_NAME := $(if $(CHART_NAME),$(CHART_NAME),chart-name)


#### Some exmamples:
# make print-versions
# make helm-publish - release all changes from development
# GITHUB_BRANCH_OVERRIDE=integ_2.8 make helm-publish - release all changes from integ_2.8
# GITHUB_BRANCH_OVERRIDE=integ_2.8 CHART_NAME=pipelines make helm-publish-stable-specific - release only pipelines from integ_2.8

.PHONY: stable
stable: WORKDIR = stable
stable: repo-helm update-req package-all index
	@echo "Done"

.PHONY: stable-specific
stable-specific: WORKDIR = stable
stable-specific: repo-helm update-req-specific package-specific index
	@echo "Done"

.PHONY: demo
demo: WORKDIR = demo
demo: repo-helm update-req package-all index
	@echo "Done"

.PHONY: demo-specific
demo-specific: WORKDIR = demo
demo-specific: repo-helm update-req-specific package-specific index
	@echo "Done"

.PHONY: incubator
incubator: WORKDIR = incubator
incubator: repo-helm update-req package-all index
	@echo "Done"

.PHONY: incubator-specific
incubator-specific: WORKDIR = incubator
incubator-specific: repo-helm update-req-specific package-specific index
	@echo "Done"

.PHONY: cleanup-tmp-workspace
cleanup-tmp-workspace:
	@rm -rf /tmp/v3io-helm-charts
	@echo "Cleaned up /tmp/v3io-helm-charts"

.PHONY: helm-publish
helm-publish: cleanup-tmp-workspace
helm-publish:
	@echo "Preparing to release a new index from $(GITHUB_BRANCH)"
	@git clone git@github.com:v3io/helm-charts /tmp/v3io-helm-charts
	@cd /tmp/v3io-helm-charts && \
		git checkout $(GITHUB_BRANCH) && \
		git checkout gh-pages && \
		git merge $(GITHUB_BRANCH) --message "Merging $(GITHUB_BRANCH) into gh-pages" && \
		REF_SHA=$$(git log $(GITHUB_BRANCH) -1 | head -1) && \
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
	@echo "New index released!"
helm-publish: cleanup-tmp-workspace

.PHONY: helm-publish-demo-specific
helm-publish-demo-specific: cleanup-tmp-workspace
helm-publish-demo-specific:
	@echo "Preparing to release a new demo index for $(CHART_NAME) from $(GITHUB_BRANCH)"
	@git clone git@github.com:v3io/helm-charts /tmp/v3io-helm-charts
	@cd /tmp/v3io-helm-charts && \
		git checkout $(GITHUB_BRANCH) && \
		git checkout gh-pages && \
		git merge $(GITHUB_BRANCH) --message "Merging $(GITHUB_BRANCH) into gh-pages" && \
		REF_SHA=$$(git log $(GITHUB_BRANCH) -1 | head -1) && \
		make demo-specific && \
		git add --force demo/$(CHART_NAME)-*tgz && \
		git add demo/$(CHART_NAME) && \
		git add demo/index.yaml && \
		git commit --message "Merging $$CHART_NAME from $$REF_SHA" && \
		git push
	@echo "New index released!"
helm-publish-demo-specific: cleanup-tmp-workspace

.PHONY: helm-publish-incubator-specific
helm-publish-incubator-specific: cleanup-tmp-workspace
helm-publish-incubator-specific:
	@echo "Preparing to release a new incubator index for $(CHART_NAME) from $(GITHUB_BRANCH)"
	@rm -rf /tmp/v3io-helm-charts
	@git clone git@github.com:v3io/helm-charts /tmp/v3io-helm-charts
	@cd /tmp/v3io-helm-charts && \
		git checkout $(GITHUB_BRANCH) && \
		git checkout gh-pages && \
		git merge $(GITHUB_BRANCH) --message "Merging $(GITHUB_BRANCH) into gh-pages" && \
		REF_SHA=$$(git log $(GITHUB_BRANCH) -1 | head -1) && \
		make incubator-specific && \
		git add --force incubator/$(CHART_NAME)-*tgz && \
		git add incubator/$(CHART_NAME) && \
		git add incubator/index.yaml && \
		git commit --message "Merging $$CHART_NAME from $$REF_SHA" && \
		git push
	@echo "New index released!"
helm-publish-incubator-specific: cleanup-tmp-workspace

.PHONY: helm-publish-stable-specific
helm-publish-stable-specific: cleanup-tmp-workspace
helm-publish-stable-specific:
	@echo "Preparing to release a new stable index for $(CHART_NAME) from $(GITHUB_BRANCH)"
	@git clone git@github.com:v3io/helm-charts /tmp/v3io-helm-charts
	@cd /tmp/v3io-helm-charts && \
		git checkout $(GITHUB_BRANCH) && \
		git checkout gh-pages && \
		git merge $(GITHUB_BRANCH) --message "Merging $(GITHUB_BRANCH) into gh-pages" && \
		REF_SHA=$$(git log $(GITHUB_BRANCH) -1 | head -1) && \
		make stable-specific && \
		git add --force stable/$(CHART_NAME)-*tgz && \
		git add stable/$(CHART_NAME) && \
		git add stable/index.yaml && \
		git commit --message "Merging $$CHART_NAME from $$REF_SHA" && \
		git push
	@echo "New index released!"
helm-publish-stable-specific: cleanup-tmp-workspace

.PHONY: print-versions
print-versions:
	@cd $(WORKDIR) && for chart in $$(ls -d */); do \
		CHART_VERSION=$$(grep version $$chart/Chart.yaml | cut -f2 -d:) ;\
		echo "# $$chart -->$$CHART_VERSION" ;\
		if [ -e "$$chart/requirements.yaml" ]; then \
			echo "depends on:" ;\
			echo "$$(grep -v alias $$chart/requirements.yaml | grep -A 1 name | grep -ve '^--')" ; \
		fi \
	done

.PHONY: update-req
update-req:
	@echo "Updating all charts requirements"
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

.PHONY: update-req-specific
update-req-specific:
	@echo "Updating $(CHART_NAME) chart requirements"
	@cd $(WORKDIR) && if [ -e "$(CHART_NAME)/requirements.yaml" ]; then \
	    $(HELM) dependency build $(CHART_NAME) ; \
	    if [ "$$?" != "0" ]; then \
            echo "Chart $(CHART_NAME) failed dependency build" ; \
            exit 103 ; \
        fi ; \
    fi

.PHONY: package-all
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

.PHONY: package-specific
package-specific:
	@echo "Packing chart"
	@cd $(WORKDIR) && $(HELM) lint $(CHART_NAME) && if [ "$$?" != "0" ]; then \
            echo "Chart $(CHART_NAME) failed lint" ; \
            exit 103 ; \
        fi ; \
        $(HELM) package $(CHART_NAME) && if [ "$$?" != "0" ]; then \
            echo "Chart $(CHART_NAME) failed package" ; \
            exit 103 ; \
        fi ; \

.PHONY: index
index:
	@echo "Generating index.yaml"
	$(HELM) repo index --merge $(WORKDIR)/index.yaml --url $(HELM_REPO_ROOT)/$(WORKDIR) $(WORKDIR)
	@if [ "$$?" != "0" ]; then \
		echo "Failed repo index" ; \
		exit 111 ; \
	fi ; \

.PHONY: repo-helm
repo-helm: check-helm
	$(info $(shell $(HELM) repo add v3io-$(WORKDIR) $(HELM_REPO)))

.PHONY: check-helm
check-helm:
	@echo "Checking if helm command exists"
	@$(HELM) home &> /dev/null
	@if [ "$$?" != "0" ]; then \
		echo "Missing helm command" ; \
		exit 2 ; \
	fi
	@echo "Helm command exists"
