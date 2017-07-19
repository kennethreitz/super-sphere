build:
	rm -fr supersphere.love
	zip -r dist/supersphere.love assets lib *.lua


mac: build
	mv dist/supersphere.love dist/macos/Super\ Sphere.app/Contents/Resources/supersphere.love
	cd dist/macos && zip -r supersphere-app-OSX.zip *
	rm -fr dist/macos/Super\ Sphere.app/Contents/Resources/supersphere.love

windows:

	mv conf.lua conf.default.lua
	mv conf.windows.lua conf.lua
	$(MAKE) build

	cd dist/windows && cat .love.exe ../supersphere.love > SuperSphere.exe
	cd dist/windows && zip -r supersphere-WIN.zip *

	mv conf.lua conf.windows.lua
	mv conf.default.lua conf.lua


android: build
	cp dist/supersphere.love dist/android/game.love
	cd dist/android && ./gradlew build
	mv dist/android/app/build/outputs/apk/app-debug.apk dist/android/supersphere-ANDROID.apk
	rm -fr dist/android/game.love