# AES Encryption example

[](https://github.com/PlugFox/aes_encryption_example/raw/master/assets/logo_512.png)

## Simple AES 128 GSM encryption & decryption example

Simple encryption of file using AES-128-GCM with a 128-bit key, 128-bit nonce, and 128-bit MAC

```dart
import 'dart:io' as io;

import 'package:cryptography/cryptography.dart' as crypto;
import 'package:path/path.dart' as path;

const _$nonceLength = 16; // initialization vector, iv, salt, nonce, etc.
const _$macLength = 16; // message authentication code, mac, tag, etc.

Future<void> encrypt(io.File source, io.File encrypted, String key) async {
  assert([128, 192, 256].contains(key.length * 8), 'Key length must be 128, 192, or 256 bits');
  assert(128 == _$nonceLength * 8, 'Nonce length should be 128 bits');
  assert(128 == _$macLength * 8, 'MAC length must be 128 bits');
  assert(source.existsSync(), 'File does not exist');
  final algorithm = crypto.AesGcm.with128bits(nonceLength: _$nonceLength);
  final secretKey = await algorithm.newSecretKeyFromBytes(key.codeUnits);
  final message = source.readAsBytesSync();
  final secretBox = await algorithm.encrypt(
    message,
    secretKey: secretKey,
    nonce: algorithm.newNonce(),
  );
  final sink = encrypted.openWrite(mode: io.FileMode.writeOnly)
    ..add(secretBox.nonce)
    ..add(secretBox.cipherText)
    ..add(secretBox.mac.bytes);
  await sink.flush();
  await sink.close();
}
```

Simple decryption of a file using AES-128-GCM with a 128-bit key, 128-bit nonce, and 128-bit MAC

```dart
import 'dart:io' as io;

import 'package:cryptography/cryptography.dart' as crypto;
import 'package:path/path.dart' as path;

const _$nonceLength = 16; // initialization vector, iv, salt, nonce, etc.
const _$macLength = 16; // message authentication code, mac, tag, etc.

Future<void> decrypt(io.File encrypted, io.File decrypted, String key) async {
  assert([128, 192, 256].contains(key.length * 8), 'Key length must be 128, 192, or 256 bits');
  assert(128 == _$nonceLength * 8, 'Nonce length should be 128 bits');
  assert(128 == _$macLength * 8, 'MAC length must be 128 bits');
  assert(encrypted.existsSync(), 'File does not exist');
  final algorithm = crypto.AesGcm.with128bits(nonceLength: _$nonceLength);
  final secretBox = crypto.SecretBox.fromConcatenation(
    source.readAsBytesSync(),
    nonceLength: _$nonceLength,
    macLength: _$macLength,
  );
  final bytes = await algorithm.decrypt(
    secretBox,
    secretKey: await algorithm.newSecretKeyFromBytes(key.codeUnits),
  );
  decrypted.writeAsBytesSync(bytes);
}
```

## Chunked and streamed encryption algorithm

Splitting into chunks will allow us to encrypt even very large files in several threads or isolates.
For example, we can divide the load among the processor cores, where each isolate will be responsible for its file chunk offset.
We can also store and transfer encrypted chunks as a single file or split them into parts.

Encryption:

1. Set constants for Chunk size, Nonce (IV) length, and MAC length
2. Get the secret key
3. Prepare temporary file for encrypted data into %TEMP% directory
4. The open source file for reading as a Uint8List Stream
5. Split the bytes stream into chunks of size `chunkSize`
6. Encrypt each chunk and write to a temporary file,
   adding the nonce to the beginning of each chunk and the MAC to the end of each chunk
7. Close the temporary file
8. Rename the temporary file to the encrypted file
9. Call output callback with the encrypted file

Decryption:

1. Set constants for Chunk size, Nonce (IV) length, and MAC length
2. Get the secret key
3. Prepare temporary file for decrypted data into %TEMP% directory
4. The open encrypted file for reading as a Uint8List Stream
5. Split the bytes stream into chunks of size `nonceLength` + `chunkSize` + `macLength`
6. Decrypt each chunk and write to a temporary file
7. Close the temporary file
8. Rename the temporary file to the decrypted file
9. Call output callback with the decrypted file
