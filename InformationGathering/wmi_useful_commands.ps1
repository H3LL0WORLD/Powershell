# Antivirus
Get-WmiObject -Namespace 'ROOT\SecurityCenter2' -CLass AntivirusProduct | Select DisplayName, InstanceGuid, PathToSignedProductExe, PathToSignedReportingExe, ProductState, Timestamp
# HotFixes
Get-WmiObject Win32_QuickFixEngineering | Select HotFixID, Description, InstalledOn
# Software instalado
Get-WmiObject Win32_Product | Select Description, InstallDate, InstallLocation, PackageCache, Vendor, Version
# Información del Sistema Operativo
Get-WmiObject Win32_OperatingSystem | Select Name, Version, InstallDate, LastBootUpTime, LocalDateTime, Manufacturer, RegisteredUser, ServicePackMajorVersion, SystemDirectory
# Información de los volumenes
Get-WmiObject Win32_Volume | Select Label, DeviceID, DriveLetter, FileSystem, Capacity, FreeSpace
# Cuentas de Usuario
Get-WmiObject Win32_UserAccount | Select AccountType, Description, Disabled, Domain, FullName, InstallDate, LocalAccount, Lockout, Name, PasswordChangeable, PasswordRequired, SID, SIDType, Status
# Adaptadores de Red
Get-WmiObject Win32_NetworkAdapter | Select Name, DeviceID, Installed, InstallDate, Manufacturer, AdapterType, MACAddress, NetConnectionID, NetEnabled, PhysicalAdapter, Speed, MaxSpeed, TimeOfLastReset
# Conecciones de Red
Get-WmiObject Win32_NetworkAdapterConfiguration | ? {$_.IPAddress}
# Bateria
Get-WmiObject Win32_Battery
# GPU
Get-WmiObject Win32_VideoController
# Discos Logicos
Get-WmiObject Win32_LogicalDisk
# Particiones
Get-WmiObject Win32_DiskPartition
# Procesador
Get-WmiObject Win32_Processor
# Información del ordenador: marca, modelo, etc...
Get-WmiObject Win32_ComputerSystem
# RAM
Get-WmiObject Win32_PhysicalMemory
# Full RAM
Get-WmiObject Win32_PhysicalMemoryArray
# WinSAT Scores
Get-WmiObject Win32_WinSAT
# Programas que se ejecutan al iniciar el sistema
Get-WmiObject Win32_StartupCommand
