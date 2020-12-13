```golang
// 参考 https://levelup.gitconnected.com/a-short-guide-to-encryption-using-go-da97c928259f
// 参考 https://levelup.gitconnected.com/a-short-guide-to-encryption-using-go-da97c928259f
package main

import (
	"bufio"
	"crypto/aes"
	"crypto/cipher"
	"crypto/rand"
	"fmt"
	"io"
	"io/ioutil"
	"log"
	"os"
)

func main() {
	args()
}
func args() {
	if len(os.Args) == 1 {
		fmt.Print("Hello World")
		os.Exit(0)
	}
	if os.Args[1] == "crypt" {
		cryptOrdecrypt("crypt")
	} else if os.Args[1] == "decrypt" {
		cryptOrdecrypt("decrypt")
	} else {
		fmt.Print("Hello World")
	}
}

func cryptOrdecrypt(flag string) {
	var key []byte
	var plaintextFilePath string
	var ciphertexFiletPath string
	plaintextFilePath = "key.md"
	ciphertexFiletPath = "key.md"
	key = getKey()
	if flag == "crypt" {
		crypt(key, plaintextFilePath, ciphertexFiletPath)
	} else if flag == "decrypt" {
		decrypt(key, plaintextFilePath, ciphertexFiletPath)
	}

}
func getFilePath() (filePath string) {
	fmt.Print("Input file path:")
	fmt.Scanln(&filePath)
	return
}
func getKey() (key []byte) {
	var keyString string
	fmt.Print("Input key value: ")
	// fmt.Scanln(&keyString) // 此方式 输入不能含有空格
	input := bufio.NewScanner(os.Stdin)
	input.Scan()
	if len(input.Text()) < 24 {
		log.Println("The key should be 16 bytes or 32 bytes")
		os.Exit(1)
	}
	keyString = input.Text()[0:24]

	// The key should be 16 bytes (AES-128), 24 bytes (AES-192) or
	// 32 bytes (AES-256)
	// key, err := ioutil.ReadFile("key.txt")
	// if err != nil {
	// 	log.Fatal(err)
	// }

	key = []byte(keyString)
	return
}
func crypt(key []byte, plaintextFilePath, ciphertexFiletPath string) {
	plaintext, err := ioutil.ReadFile(plaintextFilePath)
	if err != nil {
		log.Fatal(err)
	}

	block, err := aes.NewCipher(key)
	if err != nil {
		log.Panic(err)
	}

	gcm, err := cipher.NewGCM(block)
	if err != nil {
		log.Panic(err)
	}

	// Never use more than 2^32 random nonces with a given key
	// because of the risk of repeat.
	nonce := make([]byte, gcm.NonceSize())
	if _, err := io.ReadFull(rand.Reader, nonce); err != nil {
		log.Fatal(err)
	}

	ciphertext := gcm.Seal(nonce, nonce, plaintext, nil)
	// Save back to file
	err = ioutil.WriteFile(ciphertexFiletPath, ciphertext, 0777)
	if err != nil {
		log.Panic(err)
	}
}
func decrypt(key []byte, plaintextFilePath, ciphertexFiletPath string) {

	ciphertext, err := ioutil.ReadFile(ciphertexFiletPath)
	if err != nil {
		log.Fatal(err)
	}

	block, err := aes.NewCipher(key)
	if err != nil {
		log.Panic(err)
	}

	gcm, err := cipher.NewGCM(block)
	if err != nil {
		log.Panic(err)
	}

	nonce := ciphertext[:gcm.NonceSize()]
	ciphertext = ciphertext[gcm.NonceSize():]
	plaintext, err := gcm.Open(nil, nonce, ciphertext, nil)
	if err != nil {
		log.Panic(err)
	}

	// Save back to file
	err = ioutil.WriteFile(plaintextFilePath, plaintext, 0777)
	if err != nil {
		log.Panic(err)
	}
}


```