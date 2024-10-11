# Python virtual environment

#### If you are running Python 3.4+, you can use the venv module:
```shell
python3 -m venv _python
```

#### This command creates a venv in the specified directory and copies pip into it as well.

#### Activate:
```shell
source _python/bin/activate
```

#### Deactivate:
```shell
deactivate
```

#### List all available versions
```shell
pyenv install -l
```

#### Install a compatible version:
```shell
pyenv install 3.12.7
```

#### Set it for the project:
```shell
pyenv local 3.12.7
```

#### Create requirements.txt:
```shell
pip3 freeze > requirements.txt
```

#### Install packages:
```shell
pip3 install -r requirements.txt
```

#### Package your Python script
Add `pyinstaller` to your requirements file.

```shell
pip3 install pyinstaller
```
#### Build the app
```shell
pyinstaller --add-data "aws.png:." --add-data "lambda.sh:." --onefile --windowed --hidden-import=PIL lambda-gui.py
```
After running the command, PyInstaller will generate a dist folder containing the standalone executable file for your script. 

For debugging, run the application from the terminal instead of double-clicking the app:
```shell
cd dist
./lambda-gui.app/Contents/MacOS/lambda-gui
```

#### Alternative build with the spec file
```shell
pyinstaller lambda-gui.spec
```
