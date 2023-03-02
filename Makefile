GITHUB_BRANCH_DEFAULT := development
GITHUB_BRANCH := $(if $(GITHUB_BRANCH_OVERRIDE),$(GITHUB_BRANCH_OVERRIDE),$(GITHUB_BRANCH_DEFAULT))
GITHUB_REPO ?= github.com/v3io/helm-charts

HELM ?= helm
HELM_REPO_DEFAULT := https://v3io.github.io/helm-charts
HELM_REPO_ROOT := $(if $(HELM_REPO_OVERRIDE),$(HELM_REPO_OVERRIDE),$(HELM_REPO_DEFAULT))
WORKDIR := stable
HELM_PACKAGE_ARGS ?=
INDEX_DIR ?= 
HELM_REPO := $(HELM_REPO_ROOT)/$(WORKDIR)
CHART_NAME := $(if $(CHART_NAME),$(CHART_NAME),chart-name)
CHART_VERSION_OVERRIDE := $(if $(CHART_VERSION_OVERRIDE),$(CHART_VERSION_OVERRIDE),none)
PUBLISH_REPO := $(if $(PUBLISH_CREDS),https://$(PUBLISH_CREDS)@$(GITHUB_REPO).git,git@$(GITHUB_REPO))


#### Some examples:
# make print-versions
# make helm-publish-all 																	- release all charts from current branch
# CHART_NAME=presto make helm-publish-stable-specific-v2 									- release specific chart from current branch
# DEPRECATED - make helm-publish 															- release all changes from development
# GITHUB_BRANCH_OVERRIDE=integ_2.8 make helm-publish 										- release all changes from integ_2.8
# GITHUB_BRANCH_OVERRIDE=integ_2.8 CHART_NAME=pipelines make helm-publish-stable-specific 	- release only pipelines from integ_2.8

.PHONY: stable
stable: WORKDIR = stable
stable: check-helm repo-helm update-req package-all index
	@echo "Done"

.PHONY: stable-specific
stable-specific: WORKDIR = stable
stable-specific: check-helm repo-helm update-req-specific package-specific index
	@echo "Done"

.PHONY: demo
demo: WORKDIR = demo
demo: check-helm repo-helm update-req package-all index
	@echo "Done"

.PHONY: demo-specific
demo-specific: WORKDIR = demo
demo-specific: check-helm repo-helm update-req-specific package-specific index
	@echo "Done"

.PHONY: incubator
incubator: WORKDIR = incubator
incubator: check-helm repo-helm update-req package-all index
	@echo "Done"

.PHONY: incubator-specific
incubator-specific: WORKDIR = incubator
incubator-specific: check-helm repo-helm update-req-specific package-specific index
	@echo "Done"

.PHONY: cleanup-tmp-workspace
cleanup-tmp-workspace:
	@rm -rf /tmp/v3io-helm-charts*
	@echo "Cleaned up /tmp/v3io-helm-charts"


.PHONY: helm-publish-all
helm-publish-all: check-helm cleanup-tmp-workspace
helm-publish-all:
	@echo "Preparing to release a new index from $(GITHUB_BRANCH)"
	@git clone -b gh-pages --single-branch $(PUBLISH_REPO) /tmp/v3io-helm-charts
	@INDEX_DIR=/tmp/v3io-helm-charts HELM_PACKAGE_ARGS="-d /tmp/v3io-helm-charts/stable" make stable
	@INDEX_DIR=/tmp/v3io-helm-charts HELM_PACKAGE_ARGS="-d /tmp/v3io-helm-charts/demo" make demo
	@INDEX_DIR=/tmp/v3io-helm-charts HELM_PACKAGE_ARGS="-d /tmp/v3io-helm-charts/incubator" make incubator

	@REF_SHA=$$(git rev-parse HEAD) && \
		cd /tmp/v3io-helm-charts && \
		git add --force stable/*tgz && \
		git add stable/* && \
		git commit --message "Merging stable commit $$REF_SHA" && \
		git add --force demo/*tgz && \
		git add demo/* && \
		git commit --message "Merging demo commit $$REF_SHA" && \
		git add --force incubator/*tgz && \
		git add incubator/* && \
		git commit --message "Merging incubator commit $$REF_SHA" && \
		git push
	@echo "New index released!"
helm-publish-all: cleanup-tmp-workspace


# wont work, use helm-publish-all
.PHONY: helm-publish
helm-publish: check-helm cleanup-tmp-workspace
helm-publish:
	@echo "Preparing to release a new index from $(GITHUB_BRANCH)"
	@git clone $(PUBLISH_REPO) /tmp/v3io-helm-charts
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
	@git clone $(PUBLISH_REPO) /tmp/v3io-helm-charts
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
	@git clone $(PUBLISH_REPO) /tmp/v3io-helm-charts
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

.PHONY: helm-publish-stable-specific-v2
helm-publish-stable-specific-v2: cleanup-tmp-workspace
helm-publish-stable-specific-v2:
	@echo "Preparing to release a new stable index for $(CHART_NAME) from $(GITHUB_BRANCH)"
	@git clone -b gh-pages --single-branch $(PUBLISH_REPO) /tmp/v3io-helm-charts
	@INDEX_DIR=/tmp/v3io-helm-charts HELM_PACKAGE_ARGS="-d /tmp/v3io-helm-charts/stable" make stable-specific
	@REF_SHA=$$(git rev-parse HEAD) && \
		cd /tmp/v3io-helm-charts && \
		git add --force stable/$(CHART_NAME)*tgz && \
		git add stable/index.yaml && \
		git commit --message "Merging $$CHART_NAME from $$REF_SHA" && \
		git push
	@echo "New index released!"
helm-publish-stable-specific-v2: cleanup-tmp-workspace

.PHONY: helm-publish-stable-specific
helm-publish-stable-specific: cleanup-tmp-workspace
helm-publish-stable-specific:
	@echo "Preparing to release a new stable index for $(CHART_NAME) from $(GITHUB_BRANCH)"
	@git clone $(PUBLISH_REPO) /tmp/v3io-helm-charts
	@cp -r /tmp/v3io-helm-charts /tmp/v3io-helm-charts-2
	@cd /tmp/v3io-helm-charts-2 && \
		git checkout $(GITHUB_BRANCH) && \
		REF_SHA=$$(git log $(GITHUB_BRANCH) -1 | head -1) && \
		make stable-specific && \
		cd /tmp/v3io-helm-charts && \
		git checkout gh-pages && \
		mv /tmp/v3io-helm-charts-2/stable/$(CHART_NAME)-*tgz /tmp/v3io-helm-charts/stable/ && \
		make index && \
		git add --force stable/$(CHART_NAME)-*tgz && \
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
update-req: check-helm
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
update-req-specific: check-helm
	@echo "Updating $(CHART_NAME) chart requirements"
	@cd $(WORKDIR) && if [ -e "$(CHART_NAME)/requirements.yaml" ]; then \
	    $(HELM) dependency build $(CHART_NAME) ; \
	    if [ "$$?" != "0" ]; then \
            echo "Chart $(CHART_NAME) failed dependency build" ; \
            exit 103 ; \
        fi ; \
    fi

.PHONY: package-all
package-all: check-helm
	@echo "Packing charts"
	@cd $(WORKDIR) && for chart in $$(ls -d */); do \
		$(HELM) lint $$chart ; \
		if [ "$$?" != "0" ]; then \
			echo "Chart $$chart failed lint" ; \
			exit 101 ; \
		fi ; \
		$(HELM) package $(HELM_PACKAGE_ARGS) $$chart ; \
		if [ "$$?" != "0" ]; then \
			echo "Chart $$chart failed package" ; \
			exit 102 ; \
		fi ; \
	done

.PHONY: package-specific
package-specific: check-helm
	@echo "Packing chart"
	@cd $(WORKDIR); \
	if [ "$(CHART_VERSION_OVERRIDE)" != "none" ]; then \
        cp $(CHART_NAME)/Chart.yaml $(CHART_NAME)/Chart.yaml.old; \
        awk '{if ($$1=="version:") {$$2="$(CHART_VERSION_OVERRIDE)"; print $$0} else print $$0}' $(CHART_NAME)/Chart.yaml > $(CHART_NAME)/tmp; \
        mv $(CHART_NAME)/tmp $(CHART_NAME)/Chart.yaml; \
    fi ; \
	$(HELM) lint $(CHART_NAME); \
	if [ "$$?" != "0" ]; then \
        echo "Chart $(CHART_NAME) failed lint" ; \
        if [ "$(CHART_VERSION_OVERRIDE)" != "none" ]; then \
            mv $(CHART_NAME)/Chart.yaml.old $(CHART_NAME)/Chart.yaml; \
        fi ; \
        exit 103 ; \
    fi ; \
    $(HELM) package $(HELM_PACKAGE_ARGS) $(CHART_NAME) && if [ "$$?" != "0" ]; then \
        echo "Chart $(CHART_NAME) failed package" ; \
        if [ "$(CHART_VERSION_OVERRIDE)" != "none" ]; then \
            mv $(CHART_NAME)/Chart.yaml.old $(CHART_NAME)/Chart.yaml; \
        fi ; \
        exit 103 ; \
    fi ; \
    if [ "$(CHART_VERSION_OVERRIDE)" != "none" ]; then \
        mv $(CHART_NAME)/Chart.yaml.old $(CHART_NAME)/Chart.yaml; \
    fi ; \

.PHONY: index
index:
	@echo "Generating index.yaml"
	@if [ "$(INDEX_DIR)" != "" ]; then \
		cd $(INDEX_DIR); \
	fi ; \
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
	@$(HELM) help &> /dev/null
	@if [ "$$?" != "0" ]; then \
		echo "Missing helm command" ; \
		exit 2 ; \
	fi
	@HELM_VERSION=$$($(HELM) version --short --client) && \
	if [[ "$$HELM_VERSION" != *"v3"* ]]; then \
		echo "Helm version must be 3" ; \
		exit 2 ; \
	fi
	@echo "Helm command exists"

.PHONY: lint
lint:
	@echo "Linting all charts"
	@HELM=$(HELM) ./hack/scripts/lint.sh

.PHONY: repo-add
repo-add:
	helm repo add stable https://charts.helm.sh/stable
	helm repo add nuclio https://nuclio.github.io/nuclio/charts
	helm repo add v3io-stable https://v3io.github.io/helm-charts/stable
	helm repo add minio https://charts.min.io/
	helm repo add spark-operator https://googlecloudplatform.github.io/spark-on-k8s-operator
	helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
	helm repo add codecentric https://codecentric.github.io/helm-charts
