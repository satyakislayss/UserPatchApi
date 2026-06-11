#!/bin/bash

set -e

echo "=== Installing missing WebApi packages ==="

mono ~/nuget.exe install Microsoft.AspNet.WebApi.Client -Version 5.2.9 -OutputDirectory packages || true
mono ~/nuget.exe install Microsoft.AspNet.WebApi.Owin -Version 5.2.9 -OutputDirectory packages || true

echo
echo "=== Searching for Formatting DLL ==="
find packages -name "System.Net.Http.Formatting.dll"

echo
echo "=== Searching for OWIN DLL ==="
find packages -name "System.Web.Http.Owin.dll"

FORMATTING_DLL=$(find packages -name "System.Net.Http.Formatting.dll" | head -1)

if [ -z "$FORMATTING_DLL" ]; then
    echo "ERROR: System.Net.Http.Formatting.dll not found"
    exit 1
fi

echo
echo "=== Updating UserPatchApi.csproj ==="

if ! grep -q "System.Net.Http.Formatting" UserPatchApi.csproj; then
    sed -i "/<Reference Include=\"System.Web.Http/a\\
    <Reference Include=\"System.Net.Http.Formatting\">\\
      <HintPath>${FORMATTING_DLL}</HintPath>\\
    </Reference>" UserPatchApi.csproj
fi

echo
echo "=== Cleaning ==="
rm -rf bin obj

echo
echo "=== Building ==="
msbuild UserPatchApi.csproj /p:Configuration=Debug

echo
echo "=== DLLs copied to output ==="
find bin/Debug -name "*.dll" | sort

echo
echo "=== Ready to run ==="
echo "cd bin/Debug && mono UserPatchApi.exe"
