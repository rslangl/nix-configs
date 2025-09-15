# Test

Test environment to verify the nix configs.

## Usage

Build the test image:
```shell
nix build .#test-vm-image
```

Run the VM locally:
```shell
./run-vm.sh
```

Run assertions after boot:
```shell
./assert.sh
```
