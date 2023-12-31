$DOCKER = if (Get-Command podman -ErrorAction SilentlyContinue) { "podman" } `
	elseif (Get-Command docker -ErrorAction SilentlyContinue) { "docker" } `
	else { throw "Neither podman nor docker could be found." }

& $DOCKER build --tag zmk --file Dockerfile . || throw "Failed to build docker image."

$TIMESTAMP = (Get-Date -Format "yyyyMMddHHmm")
$COMMIT = (& git rev-parse --short HEAD)

./bin/Update-Version.ps1

& $DOCKER run --rm -it --name zmk `
	-v "${PWD}/firmware:/app/firmware" `
	-v "${PWD}/config:/app/config:ro" `
	-e "TIMESTAMP=${TIMESTAMP}" `
	-e "COMMIT=${COMMIT}" `
	zmk
