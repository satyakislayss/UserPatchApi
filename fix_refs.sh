#!/bin/bash

cp UserPatchApi.csproj UserPatchApi.csproj.before_refs

# Fix OWIN dll path
sed -i \
's|packages/Microsoft.AspNet.WebApi.OwinSelfHost.5.2.9/lib/net45/System.Web.Http.Owin.dll|packages/Microsoft.AspNet.WebApi.Owin.5.2.9/lib/net45/System.Web.Http.Owin.dll|g' \
UserPatchApi.csproj

# Add System.Data if missing
grep -q 'Include="System.Data"' UserPatchApi.csproj || \
sed -i '/<Reference Include="System.Core" \/>/a\
    <Reference Include="System.Data" />' UserPatchApi.csproj

# Add System.Configuration if missing
grep -q 'Include="System.Configuration"' UserPatchApi.csproj || \
sed -i '/<Reference Include="System.Data" \/>/a\
    <Reference Include="System.Configuration" />' UserPatchApi.csproj

rm -rf obj bin

echo "References fixed."
