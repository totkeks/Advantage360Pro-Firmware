$imageName = "advantage360pro-firmware-builder"

$runtime = if (Get-Command podman -ErrorAction SilentlyContinue) { "podman" } `
	elseif (Get-Command docker -ErrorAction SilentlyContinue) { "docker" } `
	else { throw "Neither podman nor docker could be found." }

& $runtime build --tag $imageName --file Dockerfile . || throw "Failed to build docker image."

$timestamp = (Get-Date -Format "yyyyMMddHHmm")
$commit = (& git rev-parse --short HEAD)

./bin/Update-Version.ps1

& $runtime run --rm -it --name $imageName `
	-v "${PWD}/firmware:/app/firmware" `
	-v "${PWD}/config:/app/config:ro" `
	-e "TIMESTAMP=${timestamp}" `
	-e "COMMIT=${commit}" `
	$imageName
