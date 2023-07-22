PRODUCT_NAME := EngineerMemo

.PHONY: setup
setup:
	$(MAKE) install-template
	$(MAKE) install-bundler
	$(MAKE) install-mint-packages
	$(MAKE) generate-files
	$(MAKE) generate-consts
	$(MAKE) generate-test-mock
	$(MAKE) generate-xcodeproj
	$(MAKE) generate-snapshot-md
	$(MAKE) retrieve_development_certificates
	$(MAKE) open

.PHONY: install-template
install-template:
	sh Scripts/Template/template.sh

.PHONY: install-bundler
install-bundler:
	bundle install

.PHONY: install-mint-packages
install-mint-packages:
	mint bootstrap --overwrite y

.PHONY: generate-consts
generate-consts:
	mint run swiftgen config run --config swiftgen.yml

.PHONY: generate-test-mock
generate-test-mock:
	mint run mockolo mockolo --sourcedirs ${PRODUCT_NAME} \
		--destination ${PRODUCT_NAME}TestSupport/TestMock/MockResults.swift \
		--testable-imports ${PRODUCT_NAME} \
		--mock-final

.PHONY: generate-xcodeproj
generate-xcodeproj:
	mint run xcodegen --use-cache

.PHONY: generate-files
generate-files:
	mkdir -p EngineerMemo/Shared/Resources/Generated
	mkdir -p EngineerMemoTestSupport/TestMock

.PHONY: generate-snapshot-md
generate-snapshot-md:
	ruby Scripts/Snapshot/screenshots-preview-generator-for-snapshot.rb

.PHONY: retrieve_development_certificates
retrieve_development_certificates:
	bundle exec fastlane retrieve_development_certificates

.PHONY: open
open:
	open ./$(PRODUCT_NAME).xcodeproj

.PHONY: clean
clean:
	sudo rm -rf ~/Library/Developer/Xcode/DerivedData/*
	sudo rm -rf ~/Library/Developer/Xcode/Archives/*
	sudo rm -rf ~/Library/Caches/*
	sudo rm -rf ~/Library/Logs/iOS\ Simulator
	sudo rm -rf ~/Library/Developer/Xcode/iOS\ DeviceSupport/*