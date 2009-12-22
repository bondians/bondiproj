/* Automatically generated.  Do not edit */
/* See the mkopcodec.awk script for details. */
#if !defined(SQLITE_OMIT_EXPLAIN) || !defined(NDEBUG) || defined(VDBE_PROFILE) || defined(SQLITE_DEBUG)
const char *const sqlite3OpcodeNames[] = { "?",
 /*   1 */ "ReadCookie",
 /*   2 */ "AutoCommit",
 /*   3 */ "Found",
 /*   4 */ "NullRow",
 /*   5 */ "MoveLe",
 /*   6 */ "Variable",
 /*   7 */ "Pull",
 /*   8 */ "Sort",
 /*   9 */ "IfNot",
 /*  10 */ "Gosub",
 /*  11 */ "NotFound",
 /*  12 */ "MoveLt",
 /*  13 */ "Rowid",
 /*  14 */ "CreateIndex",
 /*  15 */ "Push",
 /*  16 */ "Explain",
 /*  17 */ "Statement",
 /*  18 */ "Callback",
 /*  19 */ "MemLoad",
 /*  20 */ "DropIndex",
 /*  21 */ "Null",
 /*  22 */ "ToInt",
 /*  23 */ "Int64",
 /*  24 */ "LoadAnalysis",
 /*  25 */ "IdxInsert",
 /*  26 */ "Next",
 /*  27 */ "SetNumColumns",
 /*  28 */ "ToNumeric",
 /*  29 */ "MemInt",
 /*  30 */ "Dup",
 /*  31 */ "Rewind",
 /*  32 */ "Last",
 /*  33 */ "MustBeInt",
 /*  34 */ "MoveGe",
 /*  35 */ "String",
 /*  36 */ "ForceInt",
 /*  37 */ "Close",
 /*  38 */ "AggFinal",
 /*  39 */ "AbsValue",
 /*  40 */ "RowData",
 /*  41 */ "IdxRowid",
 /*  42 */ "MoveGt",
 /*  43 */ "OpenPseudo",
 /*  44 */ "Halt",
 /*  45 */ "MemMove",
 /*  46 */ "NewRowid",
 /*  47 */ "IdxLT",
 /*  48 */ "Distinct",
 /*  49 */ "MemMax",
 /*  50 */ "Function",
 /*  51 */ "IntegrityCk",
 /*  52 */ "FifoWrite",
 /*  53 */ "NotExists",
 /*  54 */ "MemStore",
 /*  55 */ "IdxDelete",
 /*  56 */ "Vacuum",
 /*  57 */ "If",
 /*  58 */ "Destroy",
 /*  59 */ "AggStep",
 /*  60 */ "Clear",
 /*  61 */ "Insert",
 /*  62 */ "IdxGE",
 /*  63 */ "MakeRecord",
 /*  64 */ "SetCookie",
 /*  65 */ "Prev",
 /*  66 */ "ContextPush",
 /*  67 */ "Or",
 /*  68 */ "And",
 /*  69 */ "Not",
 /*  70 */ "DropTrigger",
 /*  71 */ "IdxGT",
 /*  72 */ "MemNull",
 /*  73 */ "IsNull",
 /*  74 */ "NotNull",
 /*  75 */ "Ne",
 /*  76 */ "Eq",
 /*  77 */ "Gt",
 /*  78 */ "Le",
 /*  79 */ "Lt",
 /*  80 */ "Ge",
 /*  81 */ "Return",
 /*  82 */ "BitAnd",
 /*  83 */ "BitOr",
 /*  84 */ "ShiftLeft",
 /*  85 */ "ShiftRight",
 /*  86 */ "Add",
 /*  87 */ "Subtract",
 /*  88 */ "Multiply",
 /*  89 */ "Divide",
 /*  90 */ "Remainder",
 /*  91 */ "Concat",
 /*  92 */ "Negative",
 /*  93 */ "OpenWrite",
 /*  94 */ "BitNot",
 /*  95 */ "String8",
 /*  96 */ "Integer",
 /*  97 */ "Transaction",
 /*  98 */ "OpenVirtual",
 /*  99 */ "CollSeq",
 /* 100 */ "ToBlob",
 /* 101 */ "Sequence",
 /* 102 */ "ContextPop",
 /* 103 */ "CreateTable",
 /* 104 */ "AddImm",
 /* 105 */ "ToText",
 /* 106 */ "IdxIsNull",
 /* 107 */ "DropTable",
 /* 108 */ "IsUnique",
 /* 109 */ "Noop",
 /* 110 */ "RowKey",
 /* 111 */ "Expire",
 /* 112 */ "FifoRead",
 /* 113 */ "Delete",
 /* 114 */ "IfMemPos",
 /* 115 */ "MemIncr",
 /* 116 */ "Blob",
 /* 117 */ "MakeIdxRec",
 /* 118 */ "Goto",
 /* 119 */ "ParseSchema",
 /* 120 */ "Pop",
 /* 121 */ "VerifyCookie",
 /* 122 */ "Column",
 /* 123 */ "OpenRead",
 /* 124 */ "ResetCount",
 /* 125 */ "NotUsed_125",
 /* 126 */ "NotUsed_126",
 /* 127 */ "NotUsed_127",
 /* 128 */ "NotUsed_128",
 /* 129 */ "NotUsed_129",
 /* 130 */ "NotUsed_130",
 /* 131 */ "NotUsed_131",
 /* 132 */ "NotUsed_132",
 /* 133 */ "Real",
 /* 134 */ "HexBlob",
};
#endif