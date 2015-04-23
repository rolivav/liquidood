(c-declare #<<end-of-c-declare

#include <stdio.h>
#include <stdlib.h>

void myfunc (int a) {
  printf ("ASDF: %d\n", a);
}


int x;
int y;
int z;

void processs_coordinates () {
  // Todo el codigo
}

int getX () {
  return x;
}

int getY () {
  return y;
}

end-of-c-declare
)

(define myfunc (c-lambda (int) void "myfunc"))


(define printf/ret (c-lambda (char-string) int
			     #<<end-c-lambda

printf ("hey!\n");
printf ("%s\n", ___arg1);
___result = 3;

end-c-lambda
))


(define malloc/s (c-lambda (unsigned-long) (pointer void) "malloc"))

(define processCoordinates (c-lambda () void "process_coordinates"))

(define getX (c-lambda () int "getX"))

(define getY (c-lambda () int "getY"))
