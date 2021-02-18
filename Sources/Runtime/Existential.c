//
//  Existential.c
//  
//
//  Created by Angel Landoni on 15/2/21.
//

#include "include/Existential.h"

struct Existential map_to_existential(void const *existential) {
    const unsigned long wordSize = sizeof(WORD);
    struct Existential out;
    
    unsigned long offset = 0;
    
    // Copy value buffers into the struct.
    memcpy(&out, existential, wordSize * NUMBER_OF_BUFFERS_IN_EXISTENTIAL);
    offset += wordSize * NUMBER_OF_BUFFERS_IN_EXISTENTIAL;
    
    // Copy metadata.
    void *metadataAddress = NULL;
    memcpy(&metadataAddress, existential + offset, wordSize);
    offset += wordSize;
    
    struct Metadata metadata = map_to_metadata(metadataAddress);
    
    out.commondMetadata = metadata;
    
    // Copy witness table.
    void *witnessTablesPtr = NULL;
    memcpy(&witnessTablesPtr, existential + offset, wordSize);
    
    out.witnessTablesPtr = witnessTablesPtr;
    
    return out;
}
