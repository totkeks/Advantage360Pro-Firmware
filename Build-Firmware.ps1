$imageName = "advantage360pro-firmware-builder"

$runtime = if (Get-Command podman -ErrorAction SilentlyContinue) { "podman" } `
	elseif (Get-Command docker -ErrorAction SilentlyContinue) { "docker" } `
	else { throw "Neither podman nor docker could be found." }

& $runtime build --tag $imageName --file Dockerfile . || $(throw "Failed to build docker image.")

$timestamp = (Get-Date -Format "yyyyMMddHHmm")
$commit = (& git rev-parse --short HEAD)

./bin/Update-Version.ps1

& $runtime run --rm -it --name $imageName `
	-v "${PWD}/firmware:/workspace/firmware" `
	-v "${PWD}/config:/workspace/config:ro" `
	-e "TIMESTAMP=${timestamp}" `
	-e "COMMIT=${commit}" `
	$imageName /bin/bash || $(throw "Failed to build firmware.")

# Create links to the latest firmware files here, because symlinks from WSL don't work in Windows
New-Item -ItemType HardLink -Path firmware/left.uf2 -Target firmware/$timestamp-$commit-left.uf2 -Force
New-Item -ItemType HardLink -Path firmware/right.uf2 -Target firmware/$timestamp-$commit-right.uf2 -Force
