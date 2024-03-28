### Deploy Whitelist package

```
gnokey maketx addpkg \
--pkgpath "gno.land/p/demo/whitelist" \
--pkgdir "./examples/whitelist/p" \
--gas-fee 10000000ugnot \
--gas-wanted 800000 \
--broadcast \
--chainid dev \
--remote localhost:26657 \
Dev
```

### Deploy WhitelistFactory Realm

```
gnokey maketx addpkg \
--pkgpath "gno.land/r/demo/whitelist" \
--pkgdir "./examples/whitelist/r" \
--gas-fee 10000000ugnot \
--gas-wanted 800000 \
--broadcast \
--chainid dev \
--remote localhost:26657 \
Dev
```

### Create new whitelist instance

```
gnokey maketx call \
--pkgpath "gno.land/r/demo/whitelist" \
--func "NewWhitelist" \
--args "First whitelist!" \
--args 1691588726 \
--args 10 \
--gas-fee 10000000ugnot \
--gas-wanted 800000 \
--broadcast  \
--remote localhost:26657 \
Dev
```

### Sign up to whitelist

```
gnokey maketx call \
--pkgpath "gno.land/r/demo/whitelist" \
--func "SignUpToWhitelist" \
--args 0 \
--gas-fee 10000000ugnot \
--gas-wanted 800000 \
--broadcast  \
--remote localhost:26657 \
Dev
```
