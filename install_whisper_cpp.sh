#!/bin/bash
set -e

INSTALL_DIR="/opt/whisper.cpp"

echo ""
echo "🧠 Installing whisper.cpp to $INSTALL_DIR"
echo ""

# Install dependencies
echo "📦 Installing dependencies..."
sudo apt update
sudo apt install -y git cmake build-essential libopenblas-dev curl

# Clone whisper.cpp repository
if [ ! -d "$INSTALL_DIR" ]; then
    echo "📥 Cloning whisper.cpp repository..."
    sudo git clone https://github.com/ggml-org/whisper.cpp.git "$INSTALL_DIR"
else
    echo "✅ whisper.cpp already exists at: $INSTALL_DIR"
fi

# Fix permissions
OWNER=$(stat -c "%U" "$INSTALL_DIR")
if [ "$OWNER" != "$USER" ]; then
    echo "🔐 Changing ownership of $INSTALL_DIR to $USER"
    sudo chown -R "$USER:$USER" "$INSTALL_DIR"
fi

# Build whisper.cpp
cd "$INSTALL_DIR"
echo "🧹 Cleaning old build (if any)..."
rm -rf build

echo "🔧 Building with CMake (OpenBLAS enabled)..."
cmake -B build -DCMAKE_BUILD_TYPE=Release -DWHISPER_OPENBLAS=ON
cmake --build build --parallel

echo ""
echo "✅ Build complete. Executable: $INSTALL_DIR/build/bin/whisper-cli"
