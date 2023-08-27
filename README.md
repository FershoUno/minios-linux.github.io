# Site minios.dev
To translate the site into your language, you can use the files in the locale folder.
Edit the translation file in json format by replacing the Russian translation strings with your language, and rename the file so that it has your locale name in lowercase letters. The easiest way to do this is to have ChatGPT translate the language file into your language, and then correct any inaccuracies in the translation.
Install the python3-bs4 package:
```
apt install -y python3-bs4
```
Run ``translate.py`` with the following parameters:
```
python3 translate.py -h index.html -j ru.json
python3 translate.py -h download-template.html -j ru.json
```
Then run the download file generation for all distributions:
```
bash download-page-gen.sh
```
Then you need to translate the parts of the page that the script didn't translate (unfortunately, in its current form, the script is unable to translate all strings because it does not accept strings with spaces at the beginning and end of the line) and add links on the index.html pages of all languages to your language (approximately line 262).