#include <stdio.h>

__attribute__ ((constructor)) void foo(void) {
	printf("Before main bosssss....\n");
}

int main() {
	printf("Main function boyyss....");
}
