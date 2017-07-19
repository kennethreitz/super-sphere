build:
	rm -fr supersphere.love
	zip -r dist/supersphere.love assets lib *.lua

windows:

	mv conf.lua conf.default.lua
	mv conf.windows.lua conf.lua
	$(MAKE) build

	cd dist/windows && cat .love.exe ../supersphere.love > SuperSphere.exe
	cd dist/windows && zip -r supersphere.zip *

	mv conf.lua conf.windows.lua
	mv conf.default.lua conf.lua


android: build
	cd dist/android && ./gradlew build