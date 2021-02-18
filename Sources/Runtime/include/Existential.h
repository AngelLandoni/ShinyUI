//
//  Existential.h
//  
//
//  Created by Angel Landoni on 15/2/21.
//

#ifndef Existential_h
#define Existential_h

#include <string.h>

#include "Metadata.h"

#define NUMBER_OF_BUFFERS_IN_EXISTENTIAL 3

struct Existential {
    WORD valueA;
    WORD valueB;
    WORD valueC;
    
    struct Metadata commondMetadata;
    
    void *witnessTablesPtr;
};

struct Existential map_to_existential(void const *existential);

#endif
