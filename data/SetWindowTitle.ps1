param ([Int]$proc, [String]$title)

Add-Type -TypeDefinition @"
using System;
using System.Runtime.InteropServices;

public static class Win32 {
  [DllImport("User32.dll", EntryPoint="SetWindowText")]
  public static extern int SetWindowText(IntPtr hWnd, string strTitle);
}
"@

Get-Process -Id $proc | %{[Win32]::SetWindowText($_.mainWindowHandle, $title)}
