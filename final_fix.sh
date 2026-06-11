#!/bin/bash

echo "=== Fixing ConfigurationManager ==="

# Add System.Configuration reference if missing
grep -q 'System.Configuration' UserPatchApi.csproj || \
sed -i '/<Reference Include="System.Data" \/>/a\    <Reference Include="System.Configuration" />' UserPatchApi.csproj

echo "=== Fixing missing using statements ==="

grep -q "using System.Configuration;" Database/DatabaseConfig.cs || \
sed -i '1i using System.Configuration;' Database/DatabaseConfig.cs

grep -q "using System.Configuration;" Program.cs || \
sed -i '1i using System.Configuration;' Program.cs

echo "=== Checking OWIN SelfHost DLL ==="

find packages -name "System.Web.Http.Owin.dll"

echo "=== Cleaning build artifacts ==="

rm -rf bin obj

echo ""
echo "Done."
echo ""
echo "Now run:"
echo "find packages -name \"System.Web.Http.Owin.dll\""
echo ""
echo "and paste the result."
