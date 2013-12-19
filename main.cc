#include <stdio.h>

extern "C" int func(char *a);

int main(void)
{
  char text[]="Ala ma kota";
  int result;
  
  printf("Ci±g znakowy: %s\n", text);
  result=func(text);
  printf("Ci±g znakowy: %s\n", text);
  
  return 0;
}
