#include <stdio.h>

typedef 
struct MapaStruct{} MapaStruct;

typedef
struct PrzekStruct{} PrzekStruct;

extern "C" int mapa( int* mapa, unsigned char* image, MapaStruct* par);
extern "C" int przekroj( int* mapa,  unsigned char* image, PrzekStruct* przek );

int main( void )
{
  return 0;
}


