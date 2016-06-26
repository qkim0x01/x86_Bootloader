#define MAX_SCREEN (80*25*2)

int clear_screen();
int printk(char* string);

int main(void) {

	asm(".intel_syntax noprefix");
	char *string = "Hello World!";

	clear_screen();
	printk(string);
	asm
	(
		"cli\n\t"
		"hlt\n\t"
	);
	return 0;
}

int clear_screen() {
	int i = 0;
	volatile char *video = (char*)0xB8000;

	for(i = 0; i < MAX_SCREEN; i++) {
		*(video++) = 0;
	}
}

int printk(char* string) {
	volatile char *video = (char*)0xB8000;

	int len = 0;

	for(len = 0; string[len] != 0; len++) {
		*video++ = string[len];
		*video++ = 0x09;
	}

	return len;
}

