HELM=helm
HELM_REPO_ROOT=https://v3io.github.io/helm-charts
WORKDIR := stable

.PHONY: stable
stable: WORKDIR = stable

stable: repo-helm update-req package-all index
	@echo "Done"

.PHONY: demo
demo: WORKDIR = demo

demo: repo-helm update-req package-all index
	@echo "Done"

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
	$(HELM) repo index --merge $(WORKDIR)/index.yaml --url $(HELM_REPO) $(WORKDIR)
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
