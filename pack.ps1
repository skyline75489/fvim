# Packs FVim for Windows platforms

param([string[]]$plat=("win7-x64","win-x64"))
#param([string[]]$plat=("win7-x64","win-x64","linux-x64","osx-x64"))

New-Item -ItemType Directory -Force -Name publish -ErrorAction SilentlyContinue
Remove-Item -Recurse -Force bin\ -ErrorAction SilentlyContinue
Remove-Item publish\*

foreach($i in $plat) {
    dotnet publish -f netcoreapp3.1 -c Release --self-contained -r $i
    if ($i -eq "win-x64") {
# replace the coreclr hosting exe with an icon-patched one
        Copy-Item lib/fvim-win10.exe bin/Release/netcoreapp3.1/$i/publish/FVim.exe
# Avalonia 0.10.0-preview6 fix: manually copy ANGLE from win7-x64
        Copy-Item ~/.nuget/packages/avalonia.angle.windows.natives/2.1.0.2020091801/runtimes/win7-x64/native/av_libglesv2.dll bin/Release/netcoreapp3.1/$i/publish/
    } elseif ($i -eq "win7-x64") {
        Copy-Item lib/fvim-win7.exe bin/Release/netcoreapp3.1/$i/publish/FVim.exe
    }
    Compress-Archive -Path bin/Release/netcoreapp3.1/$i/publish/* -DestinationPath publish/fvim-$i.zip -Force
}

