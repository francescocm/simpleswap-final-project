# SimpleSwap - Proyecto Final de Smart Contracts

**Autor:** Francesco Centarti Maestu

## Descripción

El contrato `SimpleSwap.sol` permite a los usuarios realizar las siguientes acciones en un pool de liquidez de tokens ERC-20:

- Añadir liquidez a un par de tokens.
- Retirar la liquidez previamente añadida.
- Intercambiar (swap) un token por otro.
- Consultar el precio de un token en términos del otro.
- Calcular la cantidad de tokens que se recibirán en un intercambio.

## Contratos Desplegados y Verificados en Sepolia

- **Token A (TKA):** `0xf5AA0c09261b6d96c7C24d604E07C670837Cb8e2`
  - [Ver en Etherscan](https://sepolia.etherscan.io/address/0xf5AA0c09261b6d96c7C24d604E07C670837Cb8e2#code)

- **Token B (TKB):** `0x311C04Ddc758D04a5981D86345Fa838C4237d8ce`
  - [Ver en Etherscan](https://sepolia.etherscan.io/address/0x311C04Ddc758D04a5981D86345Fa838C4237d8ce#code)

- **SimpleSwap Contract:** `0xC301960101d93D7E4a41108d58c626dd27CbCB69`
  - [Ver en Etherscan](https://sepolia.etherscan.io/address/0xC301960101d93D7E4a41108d58c626dd27CbCB69#code)

---

## Interfaz del Contrato (API)

A continuación se detallan las funciones principales del contrato `SimpleSwap`:

### `addLiquidity(...)`
Añade liquidez al pool para un par de tokens.

### `removeLiquidity(...)`
Retira liquidez del pool.

### `swapExactTokensForTokens(...)`
Intercambia una cantidad exacta de tokens de entrada por tokens de salida.

### `getPrice(...)`
Devuelve el precio de un token en términos de otro.

### `getAmountOut(...)`
Calcula la cantidad de tokens de salida que se recibirán en un swap.
