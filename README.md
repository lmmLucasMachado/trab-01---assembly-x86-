# Trabalho de paradigmas

Programa em assembly x86 que realiza todas as operações aritméticas funcamentais (adição, subtração, multiplicação
e divisão) em ponto fixo, além de computar a raiz quadrada com aproximação de 3 casas decimais após a virgula.


## Execução

Para realizar a execução e necessário intalar alguns pacotes e com estes pacotes intalados executar os comandos para execução:

```
sudo apt install nasm
```

```
sudo apt install as31 nasm
```

```
sudo apt install gcc-multilib
```

### Executar:

```
 Abra o Terminal do Ubuntu (Ctrl + Alt + T)
```

```
 Va até a pasta onde baixou o programa e execute os comandos abaixo
```

```
nasm -f elf64 teste2.asm
```

```
gcc -m64 -g -no-pie -o teste2 teste2.o
```

```
./teste2 
```

## Restricoes

- Somente aceita numeros em formato de float (1.0)
- Para raiz quadrada e consistente para os valores entre 1 e 1000.

## Ambiente utilizado para o desenvolvimento 

- Ubuntu 18.4
