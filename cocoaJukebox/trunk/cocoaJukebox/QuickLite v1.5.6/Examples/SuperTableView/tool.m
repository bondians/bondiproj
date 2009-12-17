#import <Foundation/Foundation.h>
#import "SqliteBenchMark.h"

int main(int argc, const char *argv[])
{
    NSAutoreleasePool * pool;
    SqliteBenchMark * benchMark;
    unsigned long i, j;
    BOOL firstLoop = YES;
    NSMutableString * result;
    NSMutableString * header;
    float seconds;

    pool = [[NSAutoreleasePool alloc] init];
    result = [[NSMutableString alloc] init];
    header = [[NSMutableString alloc] initWithString:@"\t"];
    benchMark = [[SqliteBenchMark alloc] initWithDelegate:nil];
    [benchMark setIndexingType:SPTV_IndexBefore];
    for(i = 10000; i <= 100000; i += 10000) { // Number of records
        [result appendFormat:@"%ld\t", i];
        NSLog(@"records %ld", i);
        for(j = 2; j < 15; j += 2) { //  Number of columns
            NSLog(@"columns %ld", j);
            if(firstLoop) {
                [header appendFormat:@"%ld\t", j];
            }
            [benchMark setNumberOfRecords:i];
            [benchMark setNumberOfColumns:j];
            [benchMark setNumberOfIndexedColumns:j];
            [benchMark startBenchMark];
            seconds = (float)[benchMark insertingSeconds];
            [result appendFormat:@"%f\t", seconds];
            NSLog(@"time %f", seconds);
            [pool release];
            pool = [[NSAutoreleasePool alloc] init];
        }
        [result writeToFile:@"/tmp/tmp_SqliteResult.txt" atomically:YES];
        firstLoop = NO;
        [result appendString:@"\n"];
    }
    [header appendString:@"\n"];
    [result insertString:header atIndex:0];

    [result writeToFile:@"/tmp/SqliteResult.txt" atomically:YES];
    [pool release];
    return 0;
}
