@echo off
REM only show echo output, not the commands as well

echo Download and install the required dependencies for the project on Windows...

echo Install espeak-ng... (use Repair and Next to skip, if it is already installed)
REM curl -L "https://github.com/espeak-ng/espeak-ng/releases/download/1.51/espeak-ng-X64.msi" --output "espeak-ng-X64.msi"
REM espeak-ng-X64.msi
REM del espeak-ng-X64.msi

REM first try a specific python version, revert to system python
python3.12 -m venv venv
if %ERRORLEVEL% NEQ 0 echo "Trying alternative Python command." & python -m venv venv
if %ERRORLEVEL% NEQ 0 echo "ERROR: cannot create venv!" & exit /b

call .\venv\Scripts\activate
REM there's no point continuing if the venv isn't activating
if %ERRORLEVEL% NEQ 0 echo "ERROR: cannot activate venv!" & exit /b
pip install -r requirements_cuda.txt

echo Downloading Llama...
curl -L "https://github.com/ggerganov/llama.cpp/releases/download/b2839/cudart-llama-bin-win-cu12.2.0-x64.zip" --output "cudart-llama-bin-win-cu12.2.0-x64.zip"
curl -L "https://github.com/ggerganov/llama.cpp/releases/download/b2839/llama-b2839-bin-win-cuda-cu12.2.0-x64.zip" --output "llama-b2839-bin-win-cuda-cu12.2.0-x64.zip"
echo Unzipping Llama...
tar -xf cudart-llama-bin-win-cu12.2.0-x64.zip -C submodules\llama.cpp
tar -xf llama-b2839-bin-win-cuda-cu12.2.0-x64.zip -C submodules\llama.cpp

echo Downloading Whisper...
curl -L "https://github.com/ggerganov/whisper.cpp/releases/download/v1.5.4/whisper-cublas-12.2.0-bin-x64.zip" --output "whisper-cublas-12.2.0-bin-x64.zip"
echo Unzipping Whisper...
tar -xf whisper-cublas-12.2.0-bin-x64.zip -C submodules\whisper.cpp

echo Cleaning up...
del whisper-cublas-12.2.0-bin-x64.zip
del cudart-llama-bin-win-cu12.2.0-x64.zip
del llama-b2839-bin-win-cuda-cu12.2.0-x64.zip

REM Download ASR and LLM Models
echo Downloading Models...
curl -L "https://huggingface.co/distil-whisper/distil-medium.en/resolve/main/ggml-medium-32-2.en.bin" --output  "models\ggml-medium-32-2.en.bin"
curl -L "https://huggingface.co/bartowski/Meta-Llama-3-8B-Instruct-GGUF/resolve/main/Meta-Llama-3-8B-Instruct-Q6_K.gguf?download=true" --output "models\Meta-Llama-3-8B-Instruct-Q6_K.gguf"

echo Done!