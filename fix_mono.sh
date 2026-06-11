#!/bin/bash

echo "=== Fixing UserPatchApi for Mono ==="

# Backup
cp UserPatchApi.csproj UserPatchApi.csproj.bak

# Fix Owin path
sed -i 's|packages/Owin.1.0.0/lib/net40/Owin.dll|packages/Owin.1.0/lib/net40/Owin.dll|g' UserPatchApi.csproj

# Remove System.Web.Http.Owin reference block
perl -0777 -i -pe '
s#<Reference Include="System\.Web\.Http\.Owin, Version=5\.2\.9\.0, Culture=neutral">.*?</Reference>\s*##sg
' UserPatchApi.csproj

# Remove broken System.Data.SQLite reference block
perl -0777 -i -pe '
s#<Reference Include="System\.Data\.SQLite">.*?</Reference>\s*##sg
' UserPatchApi.csproj

# Add System.Data if missing
grep -q '<Reference Include="System.Data"' UserPatchApi.csproj || \
sed -i '/<Reference Include="System.Core" \/>/a\    <Reference Include="System.Data" />' UserPatchApi.csproj

# Add Mono.Data.Sqlite if installed
if find /usr/lib/mono -name "Mono.Data.Sqlite.dll" | grep -q .; then
    sed -i '/<Reference Include="System.Data" \/>/a\    <Reference Include="Mono.Data.Sqlite" />' UserPatchApi.csproj
fi

# Replace namespaces in source files
find Database Repositories -name "*.cs" -exec sed -i \
's/using System.Data.SQLite;/using Mono.Data.Sqlite;/g' {} \;

find Database Repositories -name "*.cs" -exec sed -i \
's/SQLiteConnection/SqliteConnection/g' {} \;

echo "=== Cleaning ==="
rm -rf bin obj

echo "=== Done ==="
echo "Now run:"
echo "msbuild UserPatchApi.csproj /p:Configuration=Debug"
