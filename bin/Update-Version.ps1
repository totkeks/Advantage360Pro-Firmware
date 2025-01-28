$TIMESTAMP ??= (Get-Date -Format "yyyyMMddHHmm")
$COMMIT ??= (& git rev-parse --short HEAD)
$BRANCH ??= (& git rev-parse --abbrev-ref HEAD)

function ConvertTo-ZMKKeyBehaviour (
	[string]$string
) {
	$result = foreach ($char in $string.ToCharArray()) {
		switch -regex ($char) {
			"[A-Za-z]" { "<&kp $([char]::ToUpper($char))>" }
			"[0-9]" { "<&kp N$char>" }
			"\." { "<&kp DOT>" }
			"-" { "<&kp MINUS>" }
			"`n" { "<&kp RET>" }
		}
	}
	$result -join ", "
}

$version = "$TIMESTAMP-$BRANCH-$COMMIT"
$versionBindings = ConvertTo-ZMKKeyBehaviour $version
"Version $version$versionBindings"

$macro = @"
macro_ver: macro_ver {
	compatible = "zmk,behavior-macro";
	#binding-cells = <0>;
	bindings = $versionBindings;
};
"@

Set-Content -Path "config/version.dtsi" -Value $macro -Force
