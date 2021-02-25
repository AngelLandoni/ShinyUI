//
//  Metadata.c
//  
//
//  Created by Angel Landoni on 16/2/21.
//

#include "include/Metadata.h"

struct Metadata map_to_metadata(void const *metadata) {
    struct Metadata out;
    unsigned long offset = 0;
    
    // The value witness is at offset - 1 from the metadata pointer.
    // https://github.com/apple/swift/blob/main/docs/ABI/TypeMetadata.rst#protocol-metadata
    memcpy(&out.valueWitnessTable, metadata - sizeof(WORD), sizeof(WORD));
    
    // Extract the type.
    memcpy(&out.rawKind, metadata + offset, sizeof(WORD));
    
    // Alloc specific metadata for the type.
    // TODO
    
    return out;
}
