build:
	rm -fr supersphere.love
	zip -r dist/supersphere.love assets lib *.lua

android:
	cd dist/android && ./gradlew build