# Script to change the desktop wallpaper depending on the resolution of the monitor.
# Change the resolution at the bottom of this script to your first resolution and provide the wallpaper name
# If the script detects a different resolution, it will load and display the second wallpaper.
# 0: Tile 1: Center 2: Stretch 3: No Change
Add-Type @”
using System;
using System.Runtime.InteropServices;
using Microsoft.Win32;
namespace Wallpaper
{
public enum Style : int
{
Tile, Center, Stretch, NoChange
}
public class Setter {
public const int SetDesktopWallpaper = 20;
public const int UpdateIniFile = 0x01;
public const int SendWinIniChange = 0x02;
[DllImport(“user32.dll”, SetLastError = true, CharSet = CharSet.Auto)]
private static extern int SystemParametersInfo (int uAction, int uParam, string lpvParam, int fuWinIni);
public static void SetWallpaper ( string path, Wallpaper.Style style ) {
SystemParametersInfo( SetDesktopWallpaper, 0, path, UpdateIniFile | SendWinIniChange );
RegistryKey key = Registry.CurrentUser.OpenSubKey(“Control Panel\\Desktop”, true);
switch( style )
{
case Style.Stretch :
key.SetValue(@”WallpaperStyle”, “2”) ;
key.SetValue(@”TileWallpaper”, “0”) ;
break;
case Style.Center :
key.SetValue(@”WallpaperStyle”, “1”) ;
key.SetValue(@”TileWallpaper”, “0”) ;
break;
case Style.Tile :
key.SetValue(@”WallpaperStyle”, “1”) ;
key.SetValue(@”TileWallpaper”, “1”) ;
break;
case Style.NoChange :
break;
}
key.Close();
}
}
}
“@
# And this part of the script is pretty much the same. Do a quick check on the resolution and choose a wallpaper based on the result
$CurrentRes = (Get-WmiObject -Class Win32_VideoController).VideoModeDescription;
If (($CurrentRes.Trim()).Contains(“1440 x 900”))
{
[Wallpaper.Setter]::SetWallpaper( ‘C:\Wallpaper\1440×900.jpg’, 0 )
}
else
{
[Wallpaper.Setter]::SetWallpaper( ‘C:\Wallpaper\1920×1200.jpg’, 0 )
}