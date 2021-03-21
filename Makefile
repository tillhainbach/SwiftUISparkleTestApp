.PHONY: check-version \
    build \
    archive \
    check_build_number \
    clean \
    clean_build \
    prerelease \
    release \
    install \
    set_version \
    set_build_number \
    delete_release \
    run \
    gh-pages \
    deploy \
    zip-archive \
    header \
    uninstall \
    publish \
    uitest

PROJECT_NAME=SwiftUISparkleTestApp
SCRIPT_DIR=Build-Versioning-Scripts
INFO_PLIST=$(PROJECT_NAME)/Info.plist
VERSION = 

gh-pages:
	-git stash
	git checkout --orphan gh-pages
	git rm -rf .
	@echo "#Hello to $(PROJECT_NAME)" >> index.md
	git checkout main .gitignore
	-git checkout main README.md index.md
	git add .
	git commit -m "init gh-pages"
	git push --set-upstream origin gh-pages
	git checkout main
	-git stash pop

run: 
	open -a $(PROJECT_NAME).app

build:
	make header HEADER="Building $(PROJECT_NAME) "
	xcodebuild clean \
	    -project $(PROJECT_NAME).xcodeproj \
	    -configuration Release \
	    -alltargets
	
archive: build
	@make header HEADER="Archiving $(PROJECT_NAME)"
	xcodebuild archive \
	    -project $(PROJECT_NAME).xcodeproj \
	    -scheme $(PROJECT_NAME) \
	    -archivePath Archive/$(PROJECT_NAME).xcarchive

	xcodebuild \
	    -exportArchive \
	    -archivePath Archive/$(PROJECT_NAME).xcarchive \
	    -exportPath Product/ \
	    -exportOptionsPlist exportOptions.plist

install:
	@make header HEADER="Installing $(PROJECT_NAME)"
	-make uninstall
	cp -rf Product/$(PROJECT_NAME).app /Applications/ 

uninstall:
	$(eval CFBundleIdentifier := $(shell /usr/libexec/PlistBuddy \
	    -c "Print CFBundleIdentifier" \
	    /Applications/$(PROJECT_NAME).app/Contents/Info.plist))
	rm -rf /Applications/$(PROJECT_NAME).app
	rm -rf $(HOME)/Library/Containers/$(CFBundleIdentifier)

clean:
	rm -rf Archive/*
	rm -rf Product/*

clean_build:
	make clean
	make set_version VERSION=0.1.0
	make set_build_number BUILD_NUMBER=1
	make build
	make archive

header:
	@echo "\n`tput bold`*** $(HEADER) ***`tput sgr0`\n"

check-version:
ifndef VERSION
	$(error VERSION is not set)
endif

check_build_number:
ifndef BUILD_NUMBER
	$(error BUILD_NUMBER is not set)
endif

release: check-version
	make set_version VERSION=$(VERSION)
	$(SCRIPT_DIR)/Increment_Build_Number.sh $(PROJECT_NAME)
	zsh $(SCRIPT_DIR)/release.sh $(PROJECT_NAME)
	zsh $(SCRIPT_DIR)/publish-app.sh

publish: check-version
	@make header HEADER="Publishing $(PROJECT_NAME)"
	zsh $(SCRIPT_DIR)/publish-app.sh $(PROJECT_NAME)

deploy: check-version clean
	@make header HEADER="Deploying $(PROJECT_NAME)"
	make set_version VERSION=$(VERSION)
	$(SCRIPT_DIR)/Increment_Build_Number.sh $(PROJECT_NAME)
	make archive
	make zip-archive
	make publish
	@make header HEADER="DEPLOY SUCCEEDED"
		
zip-archive:
	@make header HEADER="Creating Zip-Archive for $(PROJECT_NAME)"
	zsh $(SCRIPT_DIR)/zip-archive.sh $(PROJECT_NAME)
	@make header HEADER="ZIP SUCCEEDED"

set_version: check-version
	zsh $(SCRIPT_DIR)/set_version.sh $(VERSION) $(PROJECT_NAME)

set_build_number: check_build_number
	zsh $(SCRIPT_DIR)/set_build_number.sh $(BUILD_NUMBER) $(PROJECT_NAME)

delete_release:
	-gh release delete "v$(VERSION)" -y
	-git push --delete origin "v$(VERSION)"
	
uitest:
	xcodebuild clean \
		-project $(PROJECT_NAME).xcodeproj \
		-scheme SwiftUISparkleTestApp \
		test

