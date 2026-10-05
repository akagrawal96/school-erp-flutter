# Android release signing

Release builds are signed with the upload keystore described by
`android/key.properties`. Neither file is ever committed.

Without `key.properties`, release builds fall back to the debug key so that
`flutter run --release` works locally. **Such builds cannot be uploaded to the
Play Store.**

## One-time: create the upload keystore

Store the keystore and passwords in the team password manager. Losing it means
contacting Google Play support to reset the upload key.

```bash
keytool -genkey -v -keystore upload-keystore.jks -keyalg RSA -keysize 2048 -validity 10000 -alias upload
```

Keep `upload-keystore.jks` **outside** the repository.

## `android/key.properties`

```properties
storePassword=<password>
keyPassword=<password>
keyAlias=upload
storeFile=<absolute path to upload-keystore.jks>
```

## CI

In CI, the keystore is stored base64-encoded in a secret, decoded at build time,
and `key.properties` is written from secrets. This is configured when release
pipelines are added.

## White-label apps

Each white-label app is a separate Play Store listing with its own
application ID. It may share the upload key or use its own; decide per client
contract.
