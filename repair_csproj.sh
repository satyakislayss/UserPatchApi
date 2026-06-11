#!/bin/bash

cp UserPatchApi.csproj UserPatchApi.csproj.pre_fix

# Fix Owin path
sed -i \
's|packages/Owin.1.0.0/lib/net40/Owin.dll|packages/Owin.1.0/lib/net40/Owin.dll|g' \
UserPatchApi.csproj

# Remove SQLite reference block
perl -0777 -i -pe '
s#<Reference Include="System\.Data\.SQLite">.*?</Reference>##sg
' UserPatchApi.csproj

# Add Mono.Data.Sqlite reference if missing
grep -q "Mono.Data.Sqlite" UserPatchApi.csproj || \
sed -i '/<Reference Include="System.Net.Http" \/>/a\
    <Reference Include="Mono.Data.Sqlite" />' UserPatchApi.csproj

rm -rf bin obj

echo "Done"
