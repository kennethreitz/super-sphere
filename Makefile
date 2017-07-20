run: build
	love dist/supersphere.love

build:
	rm -fr supersphere.love
	zip -r dist/supersphere.love assets lib *.lua

ios:
	mv conf.lua conf.default.lua
	mv conf.mobile.lua conf.lua
	$(MAKE) build

	mv conf.lua conf.mobile.lua
	mv conf.default.lua conf.lua

mac: build
	mv dist/supersphere.love dist/macos/Super\ Sphere.app/Contents/Resources/supersphere.love
	cd dist/macos && zip -r supersphere-app-OSX.zip *
	mv dist/macos/supersphere-app-OSX.zip dist/
	rm -fr dist/macos/Super\ Sphere.app/Contents/Resources/supersphere.love

windows:
	mv conf.lua conf.default.lua
	mv conf.windows.lua conf.lua
	$(MAKE) build

	mv conf.lua conf.windows.lua
	mv conf.default.lua conf.lua

	cd dist/windows && cat .love.exe ../supersphere.love > SuperSphere.exe
	cd dist/windows && zip -r supersphere-WIN.zip *
	mv dist/windows/supersphere-WIN.zip dist/
	rm -fr dist/supersphere.love
	rm -fr dist/windows/SuperSphere.exe

android:
	mv conf.lua conf.default.lua
	mv conf.mobile.lua conf.lua
	$(MAKE) build

	mv conf.lua conf.mobile.lua
	mv conf.default.lua conf.lua

	cp dist/supersphere.love dist/android/app/src/main/assets/game.love
	cd dist/android && ./gradlew build
	mv dist/android/app/build/outputs/apk/app-debug.apk dist/supersphere-ANDROID.apk
	rm -fr dist/android/app/src/main/assets/game.love
