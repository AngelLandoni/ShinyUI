//
//  Metadata.h
//  
//
//  Created by Angel Landoni on 16/2/21.
//

#ifndef Metadata_h
#define Metadata_h

#include <stdio.h>
#include <string.h>

#include "Types.h"

struct Metadata {
    // Pointer to the value witness table.
    void *valueWitnessTable;
    // The type of metadata (struct, class, existential etc.)
    unsigned int rawKind;
};

struct Metadata map_to_metadata(void const *metadata);

#endif
