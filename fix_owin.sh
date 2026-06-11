#!/bin/bash

sed -i '/System.Web.Http.Owin/,+2d' UserPatchApi.csproj

sed -i '/System.Web.Http.dll/a\
    <Reference Include="System.Web.Http.Owin">\
      <HintPath>packages/Microsoft.AspNet.WebApi.Owin.5.2.9/lib/net45/System.Web.Http.Owin.dll</HintPath>\
    </Reference>' UserPatchApi.csproj

rm -rf bin obj

echo "Done."
