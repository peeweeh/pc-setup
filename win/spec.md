# Windows setup

Run `install.ps1` in an elevated Windows PowerShell session. It provides:

1. **Light**: core applications, development tools, Nerd Fonts and Hermes Agent.
2. **Heavy**: Light plus cloud software, Docker, games and other large packages.
3. **Optimizations**: privacy policies and optional background-task review.
4. **All**: Heavy followed by optimizations.

The application installer uses Chocolatey with package checksum verification.
It preserves the existing Windows-specific application selection and adds
available macOS counterparts, including Helium, Comet and Claude. Hermes is
installed using its official Windows shell installer, unless already present.
The Heavy tier installs NVIDIA packages when detected; AMD drivers are manual.
Package failures are reported and make the installer exit unsuccessfully.
Office and the Perplexity desktop app are not installed automatically; use
the vendor's installer or Microsoft Store where available.
Select FiraCode Nerd Font Mono or Hack Nerd Font Mono in your terminal settings
to display Nerd Font icons.

For a local checkout, individual tiers can be run with:

```powershell
.\win\windows_install.ps1 -Tier light
.\win\windows_install.ps1 -Tier heavy
```

The optimizer targets Windows 10 version 1809 or later and Windows 11 Pro,
Enterprise, Education and Server editions. It stops on unsupported editions,
including Home; review privacy options in Windows Settings instead. It saves
affected registry values under `%LOCALAPPDATA%\pc-setup` before requesting:

- Diagnostic data off on Enterprise, Education and Server, or Required on Pro.
  Microsoft recommends Required when relying on Windows Update because off
  prevents update-failure diagnostic reporting.
- Advertising ID off and Delivery Optimization HTTP-only (no peer sharing).
- Cross-device clipboard sync and online speech recognition off.
- Windows web search restricted; policy alone may not prevent all web traffic.

The script lists Customer Experience Improvement Program scheduled tasks and
asks before disabling each enabled task. It does not disable other tasks,
services, Defender or updates, delete data, change visual effects or change the
power plan. Effectiveness depends on the Windows version, edition and management
policies; a registry write does not prove a policy is effective. Restart and
check the effective policies and Windows Settings. Required Windows services,
Delivery Optimization metadata and third-party apps can still send data.

If a change fails, the backup is retained and the script returns an error.
Repeat runs retain the original values and approved task states. Restore from
the same Windows account with:

```powershell
.\win\windows_optimize.ps1 -Restore
```

Restoration also supports backups from the previous power/visual optimizer,
including after running the current optimizer. It restores the saved power plan
and visual settings only when such a legacy backup exists. Restart afterward.

References: [Microsoft diagnostic data](https://learn.microsoft.com/en-us/windows/privacy/configure-windows-diagnostic-data-in-your-organization),
[privacy policies](https://learn.microsoft.com/en-us/windows/client-management/mdm/policy-csp-privacy),
[Delivery Optimization](https://learn.microsoft.com/en-us/windows/deployment/do/waas-delivery-optimization-reference),
and [Windows connections and search](https://learn.microsoft.com/en-us/windows/privacy/manage-connections-from-windows-operating-system-components-to-microsoft-services).

`dev_setup.ps1` remains available separately. The legacy `privacy_tweaks.ps1`
is not part of any menu option and should be reviewed before running: it changes
services, permissions and privacy settings and deletes diagnostic data.
VS Code profiles manage extensions; no extensions are installed by the menu.

Run the isolated installer tests with:

```powershell
powershell -NoProfile -File .\win\test_install.ps1
```
