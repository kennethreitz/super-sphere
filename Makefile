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
	cp dist/supersphere.love dist/android/game.love
	cd dist/android && ./gradlew build
	mv dist/android/app/build/outputs/apk/app-debug.apk dist/android/supersphere.apk
	rm -fr dist/android/game.love