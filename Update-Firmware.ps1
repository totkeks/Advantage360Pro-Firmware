# Constants from device firmware
$volumeName = "ADV360PRO"
$leftName = "Adv360 Pro"
$rightName = "Adv360 Pro rt"
$currentFirmwareFile = "CURRENT.UF2"

# Constants for Windows event handling
$deviceArrivalEvent = 2
$query = "SELECT * FROM Win32_VolumeChangeEvent WHERE EventType = $deviceArrivalEvent"
$eventIdentifier = "volumeChange"

$waitTimeout = 30

function DetermineKeyboardSide ($firmware) {
	switch -regex ($firmware) {
		$rightName { "right"; break }
		$leftName { "left"; break }
		default { $null }
	}
}

function WaitForDevice {
	if ($null -eq ($changeEvent = Wait-Event -SourceIdentifier $eventIdentifier -Timeout $waitTimeout)) {
		Write-Error "Timed out waiting for device"
	}

	$driveLetter = $changeEvent.SourceEventArgs.NewEvent.DriveName
	$device = Get-CimInstance -Class Win32_LogicalDisk -Filter "DeviceID = '$driveLetter'"

	if ($device.VolumeName -ne $volumeName) {
		Write-Error "Found device $($device.VolumeName), but expected $volumeName"
	}

	$changeEvent | Remove-Event
	$driveLetter
}

function UpdateFirmware ($driveLetter) {
	$firmwarePath = Join-Path -Path $driveLetter -ChildPath $currentFirmwareFile
	$currentFirmware = Get-Content $firmwarePath -Raw

	if ($null -eq ($side = DetermineKeyboardSide $currentFirmware)) {
		Write-Error "Could not determine keyboard side"
	}

	Write-Output "Found $side side on $driveLetter"

	$currentFirmwareHash = Get-FileHash $firmwarePath
	$newFirmwareHash = Get-FileHash "firmware/$side.uf2"

	if ($currentFirmwareHash.Hash -eq $newFirmwareHash.Hash) {
		Write-Output "Firmware is already up to date, skipping update"
	}
	else {
		Write-Output "Copying firmware..."
		Copy-Item -Path "firmware/$side.uf2" -Destination $driveLetter
		Write-Output "Done"
	}
}

try {
	Register-CimIndicationEvent -Query $query -SourceIdentifier $eventIdentifier

	Write-Output "Press Mod + Macro3 to put the right side into bootloader mode"
	$driveLetter = WaitForDevice
	UpdateFirmware $driveLetter

	Write-Output "Press Mod + Macro1 to put the left side into bootloader mode"
	$driveLetter = WaitForDevice
	UpdateFirmware $driveLetter

	Write-Output "Reset the both sides, left then right, to complete the update"
}
finally {
	Remove-Event -SourceIdentifier $eventIdentifier -ErrorAction SilentlyContinue
	Unregister-Event -SourceIdentifier $eventIdentifier -ErrorAction SilentlyContinue
}

