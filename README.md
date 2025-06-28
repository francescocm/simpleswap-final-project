# SimpleSwap: Proyecto Final de Módulo 3

**Autor:** Francesco Centarti Maestu

## Descripción General

SimpleSwap es un smart contract que implementa la funcionalidad principal de un par de liquidez al estilo Uniswap V2. Permite a los usuarios realizar tres operaciones fundamentales: añadir liquidez, retirar liquidez e intercambiar tokens. El diseño se centra en la simplicidad y en el cumplimiento de las especificaciones proporcionadas.

El proyecto consta de tres contratos inteligentes desplegados:

-   `TokenA.sol`: Un token de prueba ERC-20 (TKA).
-   `TokenB.sol`: Un token de prueba ERC-20 (TKB).
-   `SimpleSwap.sol`: El contrato principal que gestiona el pool de liquidez y las operaciones de intercambio.

## Contratos Desplegados en Sepolia

Todos los contratos han sido desplegados y verificados exitosamente en la red de prueba Sepolia.

-   **TokenA (TKA):** `0xf5AA0c09261b6d96c7C24d604E07C670837Cb8e2`
    -   [Ver en Etherscan](https://sepolia.etherscan.io/address/0xf5AA0c09261b6d96c7C24d604E07C670837Cb8e2#code)

-   **TokenB (TKB):** `0x311C04Ddc758D04a5981D86345Fa838C4237d8ce`
    -   [Ver en Etherscan](https://sepolia.etherscan.io/address/0x311C04Ddc758D04a5981D86345Fa838C4237d8ce#code)

-   **SimpleSwap:** `0xC301960101d93D7E4a41108d58c626dd27CbCB69`
    -   [Ver en Etherscan](https://sepolia.etherscan.io/address/0xC301960101d93D7E4a41108d58c626dd27CbCB69#code)

## Funcionalidad y Características

El contrato `SimpleSwap` implementa la siguiente interfaz pública:

-   **`addLiquidity`**: Permite a los usuarios depositar un par de tokens para proporcionar liquidez al pool.
-   **`removeLiquidity`**: Permite a los proveedores de liquidez retirar su parte correspondiente de los tokens del pool.
-   **`swapExactTokensForTokens`**: Facilita el intercambio de una cantidad exacta de un token de entrada por la máxima cantidad posible de un token de salida.
-   **`getPrice`**: Devuelve el precio instantáneo de un token en términos de otro, escalado a 18 decimales.
-   **`getAmountOut`**: Una función pura que calcula la cantidad de salida para una cantidad de entrada dada, ideal para previsualizar intercambios en una interfaz.

## Decisiones de Diseño y Buenas Prácticas

Para asegurar la calidad y seguridad del contrato, se tomaron las siguientes decisiones clave:

-   **Seguridad (Patrón Checks-Effects-Interactions):** Todas las funciones que modifican el estado e interactúan con otros contratos (`addLiquidity`, `removeLiquidity`, `swapExactTokensForTokens`) siguen rigurosamente este patrón de seguridad. Las validaciones (`require`) se realizan primero (Checks), seguidas de las actualizaciones del estado interno (Effects), y finalmente se realizan las llamadas a contratos externos (`transfer`, `transferFrom`) (Interactions). Esto es una medida crítica para prevenir vulnerabilidades de re-entrada.

-   **Manejo de la Liquidez:** Se implementó un sistema de seguimiento de liquidez simple pero efectivo. Se utiliza un `mapping` para registrar la liquidez aportada por cada usuario y otro `mapping` para la liquidez total del pool, lo que permite cálculos de retiro proporcionales y correctos, un punto clave que fue depurado para pasar las pruebas del verificador.

-   **Cumplimiento con la Consigna:** El contrato se adhiere estrictamente a las funciones y lógicas solicitadas, sin añadir funcionalidades extra como comisiones (`fees`) para mantener la simplicidad y la eficiencia, tal como se recomendó.

## Verificación

El contrato ha sido probado exitosamente y ha superado todas las aserciones del verificador oficial en la red Sepolia.

-   **Dirección del Contrato Verificador:** `0x9f8f02dab384dddf1591c3366069da3fb0018220`
-   **Prueba de Ejecución (Transacción Exitosa):** `0x65e041f4d0cfa318b2b0bc3504670e61880cbc027bf794a603e2ac80eb5aaf03`
    -   [Ver Transacción en Etherscan](https://sepolia.etherscan.io/tx/0x65e041f4d0cfa318b2b0bc3504670e61880cbc027bf794a603e2ac80eb5aaf03)
