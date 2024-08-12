# Squared

![image](https://github.com/robertleifke/tesseract/assets/44106773/1f69d1e1-e4a5-4760-b785-34645fb1871e)

The smart contract suite for Squared, a CFMM that that executes an option strategy for which liquidity providers earn *yield* for underwriting "Squeeth" on on any token. The CFMM, Squared is designed to interact with Numo and other oracle-free lending markets. 

</details>

---

## Set up

*requires [foundry](https://book.getfoundry.sh)*
### Build

Build the contracts:

```sh
$ forge build
```

### Clean

Delete the build artifacts and cache directories:

```sh
$ forge clean
```

### Compile

Compile the contracts:

```sh
$ forge build
```

### Coverage

Get a test coverage report:

```sh
$ forge coverage
```

### Deploy

Deploy to Anvil:

```sh
$ forge script script/Deploy.s.sol --broadcast --fork-url http://localhost:8545
```


### Format

Format the contracts:

```sh
$ forge fmt
```

### Gas Usage

Get a gas report:

```sh
$ forge test --gas-report
```

| Contract         |           |
|------------------|-----------|
| Deployment Cost  | Deployment Size |
| 900917           | 3996      |
| Function Name    | min   | avg  | median | max  | # calls |
|------------------|-------|------|--------|------|---------|
| checkQuintic     | 387   | 6578 | 395    | 20406| 5       |


### Lint

Lint the contracts:

```sh
$ bun run lint
```

### Test

Run the tests:

```sh
$ forge test
```

Generate test coverage and output result to the terminal:

```sh
$ bun run test:coverage
```

Generate test coverage with lcov report (you'll have to open the `./coverage/index.html` file in your browser, to do so
simply copy paste the path):

```sh
$ bun run test:coverage:report
```

## License

This project is licensed under MIT.
