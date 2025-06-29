#!/bin/bash
set -e

INSTALL_DIR="/opt/llama.cpp"

echo ""
echo "🧠 Installing llama.cpp to $INSTALL_DIR"
echo ""

# Install dependencies
echo "📦 Installing dependencies..."
sudo apt update
sudo apt install -y git cmake build-essential libopenblas-dev curl

# Clone repository
if [ ! -d "$INSTALL_DIR" ]; then
    echo "📥 Cloning llama.cpp repository..."
    sudo git clone https://github.com/ggml-org/llama.cpp.git "$INSTALL_DIR"
else
    echo "✅ llama.cpp already exists: $INSTALL_DIR"
fi

# Fix ownership
OWNER=$(stat -c "%U" "$INSTALL_DIR")
if [ "$OWNER" != "$USER" ]; then
    echo "🔐 Changing ownership of $INSTALL_DIR to $USER"
    sudo chown -R "$USER:$USER" "$INSTALL_DIR"
fi

# Build llama.cpp
cd "$INSTALL_DIR"
echo "🧹 Cleaning old build (if any)..."
rm -rf build

echo "🔧 Compiling with CMake (OpenBLAS enabled)..."
cmake -B build -DCMAKE_BUILD_TYPE=Release -DLLAMA_BLAS=ON -DLLAMA_BLAS_VENDOR=OpenBLAS
cmake --build build --parallel

echo ""
echo "✅ Build complete. Executable located at: $INSTALL_DIR/build/bin/llama-cli"


