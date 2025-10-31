#include "root.h"
#include <stdio.h>

int main() {
  double value = 10.0;
  double convertedValue = m_to_km(value);
  printf("Converted value: %f meters\n", convertedValue);
  return 0;
}
