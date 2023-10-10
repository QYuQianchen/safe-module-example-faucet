## Faucet module

This is a minimum code to demostrate how to create a module.

This faucet module that can send out 0.1 ETH with an interval of minimum 1 hr. Any account can execute a faucet transfer from a Safe if condition meets, but nothing else, i.e. other assets in the Safe are safe and no arbitrary Safe tx can be executed. Module enables one particular kind of Safe tx to a broader range of audience without giving away its owner privilege to random account.

## Usage

### Build

```shell
$ forge build
```

### Test

```shell
$ forge test
```

### Deploy and test manually in local anvil

Create some safes locally and observe the change in balances
``` shell
$ make run-local
```
> make call-faucet module=0x610178da211fef7d417bc0e6fed39f05609ad788 safe=0x72b73547860768eff7162be8ce0c35e20f2a2d23
> make call-faucet module=0x610178da211fef7d417bc0e6fed39f05609ad788 safe=0x592ff0716a8804b5a0d4df7fe2f912655f0a2261
> make call-faucet module=0x610178da211fef7d417bc0e6fed39f05609ad788 safe=0x5a03127a42d3a883d65ceb42f198df2ae69e0970

Check the current balance of the deployer wallet

``` shell
$ cast balance 0xf39fd6e51aad88f6f4ce6ab8827279cfffb92266
> 9999052995048495457510
```

Run the command suggested in the previous command
```shell
$ make call-faucet module=0x610178da211fef7d417bc0e6fed39f05609ad788 safe=0x72b73547860768eff7162be8ce0c35e20f2a2d23
```
Check the change in balance of the deployer wallet

``` shell
$ cast balance 0xf39fd6e51aad88f6f4ce6ab8827279cfffb92266
> 9999152736742069413151
```
You can see that the balance gets increased by 0.1 ETH