#!/bin/bash

cp UserPatchApi.csproj UserPatchApi.csproj.before_restore

python3 << 'PY'
from pathlib import Path

f = Path("UserPatchApi.csproj")
txt = f.read_text()

txt = txt.replace(
'''<Reference Include="System.Net.Http" />''',
'''<Reference Include="System.Data" />
    <Reference Include="System.Configuration" />
    <Reference Include="System.Net.Http" />
    <Reference Include="Mono.Data.Sqlite" />'''
)

import re

txt = re.sub(
r'<Reference Include="System\.Web\.Http\.Owin.*?</Reference>',
'''<Reference Include="System.Web.Http.Owin">
      <HintPath>packages/Microsoft.AspNet.WebApi.Owin.5.2.9/lib/net45/System.Web.Http.Owin.dll</HintPath>
    </Reference>''',
txt,
flags=re.S
)

txt = re.sub(
r'<Reference Include="Owin">.*?</Reference>',
'''<Reference Include="Owin">
      <HintPath>packages/Owin.1.0/lib/net40/Owin.dll</HintPath>
    </Reference>''',
txt,
flags=re.S
)

txt = re.sub(
r'<Reference Include="System\.Data\.SQLite">.*?</Reference>',
'',
txt,
flags=re.S
)

f.write_text(txt)
print("csproj restored")
PY

