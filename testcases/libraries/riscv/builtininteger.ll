; ModuleID = 'llvm-link'
source_filename = "llvm-link"
target datalayout = "e-m:e-p:32:32-i64:64-n32-S128"
target triple = "riscv32"

%union.dwords = type { i64 }
%struct.anon = type { i32, i32 }

@.str = private unnamed_addr constant [74 x i8] c"/home/hahns/Schreibtisch/llvmta_testcases/libraries/builtinsint/absvdi2.c\00", align 1
@__func__.__absvdi2 = private unnamed_addr constant [10 x i8] c"__absvdi2\00", align 1
@.str.1 = private unnamed_addr constant [74 x i8] c"/home/hahns/Schreibtisch/llvmta_testcases/libraries/builtinsint/absvsi2.c\00", align 1
@__func__.__absvsi2 = private unnamed_addr constant [10 x i8] c"__absvsi2\00", align 1
@.str.2 = private unnamed_addr constant [74 x i8] c"/home/hahns/Schreibtisch/llvmta_testcases/libraries/builtinsint/addvdi3.c\00", align 1
@__func__.__addvdi3 = private unnamed_addr constant [10 x i8] c"__addvdi3\00", align 1
@.str.3 = private unnamed_addr constant [74 x i8] c"/home/hahns/Schreibtisch/llvmta_testcases/libraries/builtinsint/addvsi3.c\00", align 1
@__func__.__addvsi3 = private unnamed_addr constant [10 x i8] c"__addvsi3\00", align 1
@.str.8 = private unnamed_addr constant [74 x i8] c"/home/hahns/Schreibtisch/llvmta_testcases/libraries/builtinsint/mulvdi3.c\00", align 1
@__func__.__mulvdi3 = private unnamed_addr constant [10 x i8] c"__mulvdi3\00", align 1
@.str.9 = private unnamed_addr constant [74 x i8] c"/home/hahns/Schreibtisch/llvmta_testcases/libraries/builtinsint/mulvsi3.c\00", align 1
@__func__.__mulvsi3 = private unnamed_addr constant [10 x i8] c"__mulvsi3\00", align 1
@.str.12 = private unnamed_addr constant [74 x i8] c"/home/hahns/Schreibtisch/llvmta_testcases/libraries/builtinsint/subvdi3.c\00", align 1
@__func__.__subvdi3 = private unnamed_addr constant [10 x i8] c"__subvdi3\00", align 1
@.str.13 = private unnamed_addr constant [74 x i8] c"/home/hahns/Schreibtisch/llvmta_testcases/libraries/builtinsint/subvsi3.c\00", align 1
@__func__.__subvsi3 = private unnamed_addr constant [10 x i8] c"__subvsi3\00", align 1

; Function Attrs: noinline nounwind
define dso_local i64 @__absvdi2(i64 %a) #0 !dbg !115 {
entry:
  %a.addr = alloca i64, align 8
  %N = alloca i32, align 4
  %t = alloca i64, align 8
  store i64 %a, i64* %a.addr, align 8
  store i32 64, i32* %N, align 4, !dbg !117
  %0 = load i64, i64* %a.addr, align 8, !dbg !118
  %cmp = icmp eq i64 %0, -9223372036854775808, !dbg !119
  br i1 %cmp, label %if.then, label %if.end, !dbg !118

if.then:                                          ; preds = %entry
  call void @compilerrt_abort_impl(i8* getelementptr inbounds ([74 x i8], [74 x i8]* @.str, i32 0, i32 0), i32 26, i8* getelementptr inbounds ([10 x i8], [10 x i8]* @__func__.__absvdi2, i32 0, i32 0)) #3, !dbg !120
  unreachable, !dbg !120

if.end:                                           ; preds = %entry
  %1 = load i64, i64* %a.addr, align 8, !dbg !121
  %shr = ashr i64 %1, 63, !dbg !122
  store i64 %shr, i64* %t, align 8, !dbg !123
  %2 = load i64, i64* %a.addr, align 8, !dbg !124
  %3 = load i64, i64* %t, align 8, !dbg !125
  %xor = xor i64 %2, %3, !dbg !126
  %4 = load i64, i64* %t, align 8, !dbg !127
  %sub = sub nsw i64 %xor, %4, !dbg !128
  ret i64 %sub, !dbg !129
}

; Function Attrs: noinline nounwind
define dso_local i32 @__absvsi2(i32 %a) #0 !dbg !130 {
entry:
  %a.addr = alloca i32, align 4
  %N = alloca i32, align 4
  %t = alloca i32, align 4
  store i32 %a, i32* %a.addr, align 4
  store i32 32, i32* %N, align 4, !dbg !131
  %0 = load i32, i32* %a.addr, align 4, !dbg !132
  %cmp = icmp eq i32 %0, -2147483648, !dbg !133
  br i1 %cmp, label %if.then, label %if.end, !dbg !132

if.then:                                          ; preds = %entry
  call void @compilerrt_abort_impl(i8* getelementptr inbounds ([74 x i8], [74 x i8]* @.str.1, i32 0, i32 0), i32 26, i8* getelementptr inbounds ([10 x i8], [10 x i8]* @__func__.__absvsi2, i32 0, i32 0)) #3, !dbg !134
  unreachable, !dbg !134

if.end:                                           ; preds = %entry
  %1 = load i32, i32* %a.addr, align 4, !dbg !135
  %shr = ashr i32 %1, 31, !dbg !136
  store i32 %shr, i32* %t, align 4, !dbg !137
  %2 = load i32, i32* %a.addr, align 4, !dbg !138
  %3 = load i32, i32* %t, align 4, !dbg !139
  %xor = xor i32 %2, %3, !dbg !140
  %4 = load i32, i32* %t, align 4, !dbg !141
  %sub = sub nsw i32 %xor, %4, !dbg !142
  ret i32 %sub, !dbg !143
}

; Function Attrs: noinline nounwind
define dso_local i64 @__addvdi3(i64 %a, i64 %b) #0 !dbg !144 {
entry:
  %a.addr = alloca i64, align 8
  %b.addr = alloca i64, align 8
  %s = alloca i64, align 8
  store i64 %a, i64* %a.addr, align 8
  store i64 %b, i64* %b.addr, align 8
  %0 = load i64, i64* %a.addr, align 8, !dbg !145
  %1 = load i64, i64* %b.addr, align 8, !dbg !146
  %add = add i64 %0, %1, !dbg !147
  store i64 %add, i64* %s, align 8, !dbg !148
  %2 = load i64, i64* %b.addr, align 8, !dbg !149
  %cmp = icmp sge i64 %2, 0, !dbg !150
  br i1 %cmp, label %if.then, label %if.else, !dbg !149

if.then:                                          ; preds = %entry
  %3 = load i64, i64* %s, align 8, !dbg !151
  %4 = load i64, i64* %a.addr, align 8, !dbg !152
  %cmp1 = icmp slt i64 %3, %4, !dbg !153
  br i1 %cmp1, label %if.then2, label %if.end, !dbg !151

if.then2:                                         ; preds = %if.then
  call void @compilerrt_abort_impl(i8* getelementptr inbounds ([74 x i8], [74 x i8]* @.str.2, i32 0, i32 0), i32 28, i8* getelementptr inbounds ([10 x i8], [10 x i8]* @__func__.__addvdi3, i32 0, i32 0)) #3, !dbg !154
  unreachable, !dbg !154

if.end:                                           ; preds = %if.then
  br label %if.end6, !dbg !155

if.else:                                          ; preds = %entry
  %5 = load i64, i64* %s, align 8, !dbg !156
  %6 = load i64, i64* %a.addr, align 8, !dbg !157
  %cmp3 = icmp sge i64 %5, %6, !dbg !158
  br i1 %cmp3, label %if.then4, label %if.end5, !dbg !156

if.then4:                                         ; preds = %if.else
  call void @compilerrt_abort_impl(i8* getelementptr inbounds ([74 x i8], [74 x i8]* @.str.2, i32 0, i32 0), i32 33, i8* getelementptr inbounds ([10 x i8], [10 x i8]* @__func__.__addvdi3, i32 0, i32 0)) #3, !dbg !159
  unreachable, !dbg !159

if.end5:                                          ; preds = %if.else
  br label %if.end6

if.end6:                                          ; preds = %if.end5, %if.end
  %7 = load i64, i64* %s, align 8, !dbg !160
  ret i64 %7, !dbg !161
}

; Function Attrs: noinline nounwind
define dso_local i32 @__addvsi3(i32 %a, i32 %b) #0 !dbg !162 {
entry:
  %a.addr = alloca i32, align 4
  %b.addr = alloca i32, align 4
  %s = alloca i32, align 4
  store i32 %a, i32* %a.addr, align 4
  store i32 %b, i32* %b.addr, align 4
  %0 = load i32, i32* %a.addr, align 4, !dbg !163
  %1 = load i32, i32* %b.addr, align 4, !dbg !164
  %add = add i32 %0, %1, !dbg !165
  store i32 %add, i32* %s, align 4, !dbg !166
  %2 = load i32, i32* %b.addr, align 4, !dbg !167
  %cmp = icmp sge i32 %2, 0, !dbg !168
  br i1 %cmp, label %if.then, label %if.else, !dbg !167

if.then:                                          ; preds = %entry
  %3 = load i32, i32* %s, align 4, !dbg !169
  %4 = load i32, i32* %a.addr, align 4, !dbg !170
  %cmp1 = icmp slt i32 %3, %4, !dbg !171
  br i1 %cmp1, label %if.then2, label %if.end, !dbg !169

if.then2:                                         ; preds = %if.then
  call void @compilerrt_abort_impl(i8* getelementptr inbounds ([74 x i8], [74 x i8]* @.str.3, i32 0, i32 0), i32 28, i8* getelementptr inbounds ([10 x i8], [10 x i8]* @__func__.__addvsi3, i32 0, i32 0)) #3, !dbg !172
  unreachable, !dbg !172

if.end:                                           ; preds = %if.then
  br label %if.end6, !dbg !173

if.else:                                          ; preds = %entry
  %5 = load i32, i32* %s, align 4, !dbg !174
  %6 = load i32, i32* %a.addr, align 4, !dbg !175
  %cmp3 = icmp sge i32 %5, %6, !dbg !176
  br i1 %cmp3, label %if.then4, label %if.end5, !dbg !174

if.then4:                                         ; preds = %if.else
  call void @compilerrt_abort_impl(i8* getelementptr inbounds ([74 x i8], [74 x i8]* @.str.3, i32 0, i32 0), i32 33, i8* getelementptr inbounds ([10 x i8], [10 x i8]* @__func__.__addvsi3, i32 0, i32 0)) #3, !dbg !177
  unreachable, !dbg !177

if.end5:                                          ; preds = %if.else
  br label %if.end6

if.end6:                                          ; preds = %if.end5, %if.end
  %7 = load i32, i32* %s, align 4, !dbg !178
  ret i32 %7, !dbg !179
}

; Function Attrs: noinline nounwind
define dso_local i64 @__ashldi3(i64 %a, i32 %b) #0 !dbg !180 {
entry:
  %retval = alloca i64, align 8
  %a.addr = alloca i64, align 8
  %b.addr = alloca i32, align 4
  %bits_in_word = alloca i32, align 4
  %input = alloca %union.dwords, align 8
  %result = alloca %union.dwords, align 8
  store i64 %a, i64* %a.addr, align 8
  store i32 %b, i32* %b.addr, align 4
  store i32 32, i32* %bits_in_word, align 4, !dbg !181
  %0 = load i64, i64* %a.addr, align 8, !dbg !182
  %all = bitcast %union.dwords* %input to i64*, !dbg !183
  store i64 %0, i64* %all, align 8, !dbg !184
  %1 = load i32, i32* %b.addr, align 4, !dbg !185
  %and = and i32 %1, 32, !dbg !186
  %tobool = icmp ne i32 %and, 0, !dbg !186
  br i1 %tobool, label %if.then, label %if.else, !dbg !185

if.then:                                          ; preds = %entry
  %s = bitcast %union.dwords* %result to %struct.anon*, !dbg !187
  %low = getelementptr inbounds %struct.anon, %struct.anon* %s, i32 0, i32 0, !dbg !188
  store i32 0, i32* %low, align 8, !dbg !189
  %s1 = bitcast %union.dwords* %input to %struct.anon*, !dbg !190
  %low2 = getelementptr inbounds %struct.anon, %struct.anon* %s1, i32 0, i32 0, !dbg !191
  %2 = load i32, i32* %low2, align 8, !dbg !191
  %3 = load i32, i32* %b.addr, align 4, !dbg !192
  %sub = sub nsw i32 %3, 32, !dbg !193
  %shl = shl i32 %2, %sub, !dbg !194
  %s3 = bitcast %union.dwords* %result to %struct.anon*, !dbg !195
  %high = getelementptr inbounds %struct.anon, %struct.anon* %s3, i32 0, i32 1, !dbg !196
  store i32 %shl, i32* %high, align 4, !dbg !197
  br label %if.end18, !dbg !198

if.else:                                          ; preds = %entry
  %4 = load i32, i32* %b.addr, align 4, !dbg !199
  %cmp = icmp eq i32 %4, 0, !dbg !200
  br i1 %cmp, label %if.then4, label %if.end, !dbg !199

if.then4:                                         ; preds = %if.else
  %5 = load i64, i64* %a.addr, align 8, !dbg !201
  store i64 %5, i64* %retval, align 8, !dbg !202
  br label %return, !dbg !202

if.end:                                           ; preds = %if.else
  %s5 = bitcast %union.dwords* %input to %struct.anon*, !dbg !203
  %low6 = getelementptr inbounds %struct.anon, %struct.anon* %s5, i32 0, i32 0, !dbg !204
  %6 = load i32, i32* %low6, align 8, !dbg !204
  %7 = load i32, i32* %b.addr, align 4, !dbg !205
  %shl7 = shl i32 %6, %7, !dbg !206
  %s8 = bitcast %union.dwords* %result to %struct.anon*, !dbg !207
  %low9 = getelementptr inbounds %struct.anon, %struct.anon* %s8, i32 0, i32 0, !dbg !208
  store i32 %shl7, i32* %low9, align 8, !dbg !209
  %s10 = bitcast %union.dwords* %input to %struct.anon*, !dbg !210
  %high11 = getelementptr inbounds %struct.anon, %struct.anon* %s10, i32 0, i32 1, !dbg !211
  %8 = load i32, i32* %high11, align 4, !dbg !211
  %9 = load i32, i32* %b.addr, align 4, !dbg !212
  %shl12 = shl i32 %8, %9, !dbg !213
  %s13 = bitcast %union.dwords* %input to %struct.anon*, !dbg !214
  %low14 = getelementptr inbounds %struct.anon, %struct.anon* %s13, i32 0, i32 0, !dbg !215
  %10 = load i32, i32* %low14, align 8, !dbg !215
  %11 = load i32, i32* %b.addr, align 4, !dbg !216
  %sub15 = sub nsw i32 32, %11, !dbg !217
  %shr = lshr i32 %10, %sub15, !dbg !218
  %or = or i32 %shl12, %shr, !dbg !219
  %s16 = bitcast %union.dwords* %result to %struct.anon*, !dbg !220
  %high17 = getelementptr inbounds %struct.anon, %struct.anon* %s16, i32 0, i32 1, !dbg !221
  store i32 %or, i32* %high17, align 4, !dbg !222
  br label %if.end18

if.end18:                                         ; preds = %if.end, %if.then
  %all19 = bitcast %union.dwords* %result to i64*, !dbg !223
  %12 = load i64, i64* %all19, align 8, !dbg !223
  store i64 %12, i64* %retval, align 8, !dbg !224
  br label %return, !dbg !224

return:                                           ; preds = %if.end18, %if.then4
  %13 = load i64, i64* %retval, align 8, !dbg !225
  ret i64 %13, !dbg !225
}

; Function Attrs: noinline nounwind
define dso_local i64 @__ashrdi3(i64 %a, i32 %b) #0 !dbg !226 {
entry:
  %retval = alloca i64, align 8
  %a.addr = alloca i64, align 8
  %b.addr = alloca i32, align 4
  %bits_in_word = alloca i32, align 4
  %input = alloca %union.dwords, align 8
  %result = alloca %union.dwords, align 8
  store i64 %a, i64* %a.addr, align 8
  store i32 %b, i32* %b.addr, align 4
  store i32 32, i32* %bits_in_word, align 4, !dbg !227
  %0 = load i64, i64* %a.addr, align 8, !dbg !228
  %all = bitcast %union.dwords* %input to i64*, !dbg !229
  store i64 %0, i64* %all, align 8, !dbg !230
  %1 = load i32, i32* %b.addr, align 4, !dbg !231
  %and = and i32 %1, 32, !dbg !232
  %tobool = icmp ne i32 %and, 0, !dbg !232
  br i1 %tobool, label %if.then, label %if.else, !dbg !231

if.then:                                          ; preds = %entry
  %s = bitcast %union.dwords* %input to %struct.anon*, !dbg !233
  %high = getelementptr inbounds %struct.anon, %struct.anon* %s, i32 0, i32 1, !dbg !234
  %2 = load i32, i32* %high, align 4, !dbg !234
  %shr = ashr i32 %2, 31, !dbg !235
  %s1 = bitcast %union.dwords* %result to %struct.anon*, !dbg !236
  %high2 = getelementptr inbounds %struct.anon, %struct.anon* %s1, i32 0, i32 1, !dbg !237
  store i32 %shr, i32* %high2, align 4, !dbg !238
  %s3 = bitcast %union.dwords* %input to %struct.anon*, !dbg !239
  %high4 = getelementptr inbounds %struct.anon, %struct.anon* %s3, i32 0, i32 1, !dbg !240
  %3 = load i32, i32* %high4, align 4, !dbg !240
  %4 = load i32, i32* %b.addr, align 4, !dbg !241
  %sub = sub nsw i32 %4, 32, !dbg !242
  %shr5 = ashr i32 %3, %sub, !dbg !243
  %s6 = bitcast %union.dwords* %result to %struct.anon*, !dbg !244
  %low = getelementptr inbounds %struct.anon, %struct.anon* %s6, i32 0, i32 0, !dbg !245
  store i32 %shr5, i32* %low, align 8, !dbg !246
  br label %if.end21, !dbg !247

if.else:                                          ; preds = %entry
  %5 = load i32, i32* %b.addr, align 4, !dbg !248
  %cmp = icmp eq i32 %5, 0, !dbg !249
  br i1 %cmp, label %if.then7, label %if.end, !dbg !248

if.then7:                                         ; preds = %if.else
  %6 = load i64, i64* %a.addr, align 8, !dbg !250
  store i64 %6, i64* %retval, align 8, !dbg !251
  br label %return, !dbg !251

if.end:                                           ; preds = %if.else
  %s8 = bitcast %union.dwords* %input to %struct.anon*, !dbg !252
  %high9 = getelementptr inbounds %struct.anon, %struct.anon* %s8, i32 0, i32 1, !dbg !253
  %7 = load i32, i32* %high9, align 4, !dbg !253
  %8 = load i32, i32* %b.addr, align 4, !dbg !254
  %shr10 = ashr i32 %7, %8, !dbg !255
  %s11 = bitcast %union.dwords* %result to %struct.anon*, !dbg !256
  %high12 = getelementptr inbounds %struct.anon, %struct.anon* %s11, i32 0, i32 1, !dbg !257
  store i32 %shr10, i32* %high12, align 4, !dbg !258
  %s13 = bitcast %union.dwords* %input to %struct.anon*, !dbg !259
  %high14 = getelementptr inbounds %struct.anon, %struct.anon* %s13, i32 0, i32 1, !dbg !260
  %9 = load i32, i32* %high14, align 4, !dbg !260
  %10 = load i32, i32* %b.addr, align 4, !dbg !261
  %sub15 = sub nsw i32 32, %10, !dbg !262
  %shl = shl i32 %9, %sub15, !dbg !263
  %s16 = bitcast %union.dwords* %input to %struct.anon*, !dbg !264
  %low17 = getelementptr inbounds %struct.anon, %struct.anon* %s16, i32 0, i32 0, !dbg !265
  %11 = load i32, i32* %low17, align 8, !dbg !265
  %12 = load i32, i32* %b.addr, align 4, !dbg !266
  %shr18 = lshr i32 %11, %12, !dbg !267
  %or = or i32 %shl, %shr18, !dbg !268
  %s19 = bitcast %union.dwords* %result to %struct.anon*, !dbg !269
  %low20 = getelementptr inbounds %struct.anon, %struct.anon* %s19, i32 0, i32 0, !dbg !270
  store i32 %or, i32* %low20, align 8, !dbg !271
  br label %if.end21

if.end21:                                         ; preds = %if.end, %if.then
  %all22 = bitcast %union.dwords* %result to i64*, !dbg !272
  %13 = load i64, i64* %all22, align 8, !dbg !272
  store i64 %13, i64* %retval, align 8, !dbg !273
  br label %return, !dbg !273

return:                                           ; preds = %if.end21, %if.then7
  %14 = load i64, i64* %retval, align 8, !dbg !274
  ret i64 %14, !dbg !274
}

; Function Attrs: noinline nounwind
define dso_local i32 @__clzdi2(i64 %a) #0 !dbg !275 {
entry:
  %a.addr = alloca i64, align 8
  %x = alloca %union.dwords, align 8
  %f = alloca i32, align 4
  store i64 %a, i64* %a.addr, align 8
  %0 = load i64, i64* %a.addr, align 8, !dbg !276
  %all = bitcast %union.dwords* %x to i64*, !dbg !277
  store i64 %0, i64* %all, align 8, !dbg !278
  %s = bitcast %union.dwords* %x to %struct.anon*, !dbg !279
  %high = getelementptr inbounds %struct.anon, %struct.anon* %s, i32 0, i32 1, !dbg !280
  %1 = load i32, i32* %high, align 4, !dbg !280
  %cmp = icmp eq i32 %1, 0, !dbg !281
  %conv = zext i1 %cmp to i32, !dbg !281
  %sub = sub nsw i32 0, %conv, !dbg !282
  store i32 %sub, i32* %f, align 4, !dbg !283
  %s1 = bitcast %union.dwords* %x to %struct.anon*, !dbg !284
  %high2 = getelementptr inbounds %struct.anon, %struct.anon* %s1, i32 0, i32 1, !dbg !285
  %2 = load i32, i32* %high2, align 4, !dbg !285
  %3 = load i32, i32* %f, align 4, !dbg !286
  %neg = xor i32 %3, -1, !dbg !287
  %and = and i32 %2, %neg, !dbg !288
  %s3 = bitcast %union.dwords* %x to %struct.anon*, !dbg !289
  %low = getelementptr inbounds %struct.anon, %struct.anon* %s3, i32 0, i32 0, !dbg !290
  %4 = load i32, i32* %low, align 8, !dbg !290
  %5 = load i32, i32* %f, align 4, !dbg !291
  %and4 = and i32 %4, %5, !dbg !292
  %or = or i32 %and, %and4, !dbg !293
  %6 = call i32 @llvm.ctlz.i32(i32 %or, i1 true), !dbg !294
  %7 = load i32, i32* %f, align 4, !dbg !295
  %and5 = and i32 %7, 32, !dbg !296
  %add = add nsw i32 %6, %and5, !dbg !297
  ret i32 %add, !dbg !298
}

; Function Attrs: nounwind readnone speculatable
declare i32 @llvm.ctlz.i32(i32, i1) #1

; Function Attrs: noinline nounwind
define dso_local i32 @__clzsi2(i32 %a) #0 !dbg !299 {
entry:
  %a.addr = alloca i32, align 4
  %x = alloca i32, align 4
  %t = alloca i32, align 4
  %r = alloca i32, align 4
  store i32 %a, i32* %a.addr, align 4
  %0 = load i32, i32* %a.addr, align 4, !dbg !300
  store i32 %0, i32* %x, align 4, !dbg !301
  %1 = load i32, i32* %x, align 4, !dbg !302
  %and = and i32 %1, -65536, !dbg !303
  %cmp = icmp eq i32 %and, 0, !dbg !304
  %conv = zext i1 %cmp to i32, !dbg !304
  %shl = shl i32 %conv, 4, !dbg !305
  store i32 %shl, i32* %t, align 4, !dbg !306
  %2 = load i32, i32* %t, align 4, !dbg !307
  %sub = sub nsw i32 16, %2, !dbg !308
  %3 = load i32, i32* %x, align 4, !dbg !309
  %shr = lshr i32 %3, %sub, !dbg !309
  store i32 %shr, i32* %x, align 4, !dbg !309
  %4 = load i32, i32* %t, align 4, !dbg !310
  store i32 %4, i32* %r, align 4, !dbg !311
  %5 = load i32, i32* %x, align 4, !dbg !312
  %and1 = and i32 %5, 65280, !dbg !313
  %cmp2 = icmp eq i32 %and1, 0, !dbg !314
  %conv3 = zext i1 %cmp2 to i32, !dbg !314
  %shl4 = shl i32 %conv3, 3, !dbg !315
  store i32 %shl4, i32* %t, align 4, !dbg !316
  %6 = load i32, i32* %t, align 4, !dbg !317
  %sub5 = sub nsw i32 8, %6, !dbg !318
  %7 = load i32, i32* %x, align 4, !dbg !319
  %shr6 = lshr i32 %7, %sub5, !dbg !319
  store i32 %shr6, i32* %x, align 4, !dbg !319
  %8 = load i32, i32* %t, align 4, !dbg !320
  %9 = load i32, i32* %r, align 4, !dbg !321
  %add = add i32 %9, %8, !dbg !321
  store i32 %add, i32* %r, align 4, !dbg !321
  %10 = load i32, i32* %x, align 4, !dbg !322
  %and7 = and i32 %10, 240, !dbg !323
  %cmp8 = icmp eq i32 %and7, 0, !dbg !324
  %conv9 = zext i1 %cmp8 to i32, !dbg !324
  %shl10 = shl i32 %conv9, 2, !dbg !325
  store i32 %shl10, i32* %t, align 4, !dbg !326
  %11 = load i32, i32* %t, align 4, !dbg !327
  %sub11 = sub nsw i32 4, %11, !dbg !328
  %12 = load i32, i32* %x, align 4, !dbg !329
  %shr12 = lshr i32 %12, %sub11, !dbg !329
  store i32 %shr12, i32* %x, align 4, !dbg !329
  %13 = load i32, i32* %t, align 4, !dbg !330
  %14 = load i32, i32* %r, align 4, !dbg !331
  %add13 = add i32 %14, %13, !dbg !331
  store i32 %add13, i32* %r, align 4, !dbg !331
  %15 = load i32, i32* %x, align 4, !dbg !332
  %and14 = and i32 %15, 12, !dbg !333
  %cmp15 = icmp eq i32 %and14, 0, !dbg !334
  %conv16 = zext i1 %cmp15 to i32, !dbg !334
  %shl17 = shl i32 %conv16, 1, !dbg !335
  store i32 %shl17, i32* %t, align 4, !dbg !336
  %16 = load i32, i32* %t, align 4, !dbg !337
  %sub18 = sub nsw i32 2, %16, !dbg !338
  %17 = load i32, i32* %x, align 4, !dbg !339
  %shr19 = lshr i32 %17, %sub18, !dbg !339
  store i32 %shr19, i32* %x, align 4, !dbg !339
  %18 = load i32, i32* %t, align 4, !dbg !340
  %19 = load i32, i32* %r, align 4, !dbg !341
  %add20 = add i32 %19, %18, !dbg !341
  store i32 %add20, i32* %r, align 4, !dbg !341
  %20 = load i32, i32* %r, align 4, !dbg !342
  %21 = load i32, i32* %x, align 4, !dbg !343
  %sub21 = sub i32 2, %21, !dbg !344
  %22 = load i32, i32* %x, align 4, !dbg !345
  %and22 = and i32 %22, 2, !dbg !346
  %cmp23 = icmp eq i32 %and22, 0, !dbg !347
  %conv24 = zext i1 %cmp23 to i32, !dbg !347
  %sub25 = sub nsw i32 0, %conv24, !dbg !348
  %and26 = and i32 %sub21, %sub25, !dbg !349
  %add27 = add i32 %20, %and26, !dbg !350
  ret i32 %add27, !dbg !351
}

; Function Attrs: noinline nounwind
define dso_local i32 @__cmpdi2(i64 %a, i64 %b) #0 !dbg !352 {
entry:
  %retval = alloca i32, align 4
  %a.addr = alloca i64, align 8
  %b.addr = alloca i64, align 8
  %x = alloca %union.dwords, align 8
  %y = alloca %union.dwords, align 8
  store i64 %a, i64* %a.addr, align 8
  store i64 %b, i64* %b.addr, align 8
  %0 = load i64, i64* %a.addr, align 8, !dbg !353
  %all = bitcast %union.dwords* %x to i64*, !dbg !354
  store i64 %0, i64* %all, align 8, !dbg !355
  %1 = load i64, i64* %b.addr, align 8, !dbg !356
  %all1 = bitcast %union.dwords* %y to i64*, !dbg !357
  store i64 %1, i64* %all1, align 8, !dbg !358
  %s = bitcast %union.dwords* %x to %struct.anon*, !dbg !359
  %high = getelementptr inbounds %struct.anon, %struct.anon* %s, i32 0, i32 1, !dbg !360
  %2 = load i32, i32* %high, align 4, !dbg !360
  %s2 = bitcast %union.dwords* %y to %struct.anon*, !dbg !361
  %high3 = getelementptr inbounds %struct.anon, %struct.anon* %s2, i32 0, i32 1, !dbg !362
  %3 = load i32, i32* %high3, align 4, !dbg !362
  %cmp = icmp slt i32 %2, %3, !dbg !363
  br i1 %cmp, label %if.then, label %if.end, !dbg !364

if.then:                                          ; preds = %entry
  store i32 0, i32* %retval, align 4, !dbg !365
  br label %return, !dbg !365

if.end:                                           ; preds = %entry
  %s4 = bitcast %union.dwords* %x to %struct.anon*, !dbg !366
  %high5 = getelementptr inbounds %struct.anon, %struct.anon* %s4, i32 0, i32 1, !dbg !367
  %4 = load i32, i32* %high5, align 4, !dbg !367
  %s6 = bitcast %union.dwords* %y to %struct.anon*, !dbg !368
  %high7 = getelementptr inbounds %struct.anon, %struct.anon* %s6, i32 0, i32 1, !dbg !369
  %5 = load i32, i32* %high7, align 4, !dbg !369
  %cmp8 = icmp sgt i32 %4, %5, !dbg !370
  br i1 %cmp8, label %if.then9, label %if.end10, !dbg !371

if.then9:                                         ; preds = %if.end
  store i32 2, i32* %retval, align 4, !dbg !372
  br label %return, !dbg !372

if.end10:                                         ; preds = %if.end
  %s11 = bitcast %union.dwords* %x to %struct.anon*, !dbg !373
  %low = getelementptr inbounds %struct.anon, %struct.anon* %s11, i32 0, i32 0, !dbg !374
  %6 = load i32, i32* %low, align 8, !dbg !374
  %s12 = bitcast %union.dwords* %y to %struct.anon*, !dbg !375
  %low13 = getelementptr inbounds %struct.anon, %struct.anon* %s12, i32 0, i32 0, !dbg !376
  %7 = load i32, i32* %low13, align 8, !dbg !376
  %cmp14 = icmp ult i32 %6, %7, !dbg !377
  br i1 %cmp14, label %if.then15, label %if.end16, !dbg !378

if.then15:                                        ; preds = %if.end10
  store i32 0, i32* %retval, align 4, !dbg !379
  br label %return, !dbg !379

if.end16:                                         ; preds = %if.end10
  %s17 = bitcast %union.dwords* %x to %struct.anon*, !dbg !380
  %low18 = getelementptr inbounds %struct.anon, %struct.anon* %s17, i32 0, i32 0, !dbg !381
  %8 = load i32, i32* %low18, align 8, !dbg !381
  %s19 = bitcast %union.dwords* %y to %struct.anon*, !dbg !382
  %low20 = getelementptr inbounds %struct.anon, %struct.anon* %s19, i32 0, i32 0, !dbg !383
  %9 = load i32, i32* %low20, align 8, !dbg !383
  %cmp21 = icmp ugt i32 %8, %9, !dbg !384
  br i1 %cmp21, label %if.then22, label %if.end23, !dbg !385

if.then22:                                        ; preds = %if.end16
  store i32 2, i32* %retval, align 4, !dbg !386
  br label %return, !dbg !386

if.end23:                                         ; preds = %if.end16
  store i32 1, i32* %retval, align 4, !dbg !387
  br label %return, !dbg !387

return:                                           ; preds = %if.end23, %if.then22, %if.then15, %if.then9, %if.then
  %10 = load i32, i32* %retval, align 4, !dbg !388
  ret i32 %10, !dbg !388
}

; Function Attrs: noinline nounwind
define dso_local i32 @__ctzdi2(i64 %a) #0 !dbg !389 {
entry:
  %a.addr = alloca i64, align 8
  %x = alloca %union.dwords, align 8
  %f = alloca i32, align 4
  store i64 %a, i64* %a.addr, align 8
  %0 = load i64, i64* %a.addr, align 8, !dbg !390
  %all = bitcast %union.dwords* %x to i64*, !dbg !391
  store i64 %0, i64* %all, align 8, !dbg !392
  %s = bitcast %union.dwords* %x to %struct.anon*, !dbg !393
  %low = getelementptr inbounds %struct.anon, %struct.anon* %s, i32 0, i32 0, !dbg !394
  %1 = load i32, i32* %low, align 8, !dbg !394
  %cmp = icmp eq i32 %1, 0, !dbg !395
  %conv = zext i1 %cmp to i32, !dbg !395
  %sub = sub nsw i32 0, %conv, !dbg !396
  store i32 %sub, i32* %f, align 4, !dbg !397
  %s1 = bitcast %union.dwords* %x to %struct.anon*, !dbg !398
  %high = getelementptr inbounds %struct.anon, %struct.anon* %s1, i32 0, i32 1, !dbg !399
  %2 = load i32, i32* %high, align 4, !dbg !399
  %3 = load i32, i32* %f, align 4, !dbg !400
  %and = and i32 %2, %3, !dbg !401
  %s2 = bitcast %union.dwords* %x to %struct.anon*, !dbg !402
  %low3 = getelementptr inbounds %struct.anon, %struct.anon* %s2, i32 0, i32 0, !dbg !403
  %4 = load i32, i32* %low3, align 8, !dbg !403
  %5 = load i32, i32* %f, align 4, !dbg !404
  %neg = xor i32 %5, -1, !dbg !405
  %and4 = and i32 %4, %neg, !dbg !406
  %or = or i32 %and, %and4, !dbg !407
  %6 = call i32 @llvm.cttz.i32(i32 %or, i1 true), !dbg !408
  %7 = load i32, i32* %f, align 4, !dbg !409
  %and5 = and i32 %7, 32, !dbg !410
  %add = add nsw i32 %6, %and5, !dbg !411
  ret i32 %add, !dbg !412
}

; Function Attrs: nounwind readnone speculatable
declare i32 @llvm.cttz.i32(i32, i1) #1

; Function Attrs: noinline nounwind
define dso_local i32 @__ctzsi2(i32 %a) #0 !dbg !413 {
entry:
  %a.addr = alloca i32, align 4
  %x = alloca i32, align 4
  %t = alloca i32, align 4
  %r = alloca i32, align 4
  store i32 %a, i32* %a.addr, align 4
  %0 = load i32, i32* %a.addr, align 4, !dbg !414
  store i32 %0, i32* %x, align 4, !dbg !415
  %1 = load i32, i32* %x, align 4, !dbg !416
  %and = and i32 %1, 65535, !dbg !417
  %cmp = icmp eq i32 %and, 0, !dbg !418
  %conv = zext i1 %cmp to i32, !dbg !418
  %shl = shl i32 %conv, 4, !dbg !419
  store i32 %shl, i32* %t, align 4, !dbg !420
  %2 = load i32, i32* %t, align 4, !dbg !421
  %3 = load i32, i32* %x, align 4, !dbg !422
  %shr = lshr i32 %3, %2, !dbg !422
  store i32 %shr, i32* %x, align 4, !dbg !422
  %4 = load i32, i32* %t, align 4, !dbg !423
  store i32 %4, i32* %r, align 4, !dbg !424
  %5 = load i32, i32* %x, align 4, !dbg !425
  %and1 = and i32 %5, 255, !dbg !426
  %cmp2 = icmp eq i32 %and1, 0, !dbg !427
  %conv3 = zext i1 %cmp2 to i32, !dbg !427
  %shl4 = shl i32 %conv3, 3, !dbg !428
  store i32 %shl4, i32* %t, align 4, !dbg !429
  %6 = load i32, i32* %t, align 4, !dbg !430
  %7 = load i32, i32* %x, align 4, !dbg !431
  %shr5 = lshr i32 %7, %6, !dbg !431
  store i32 %shr5, i32* %x, align 4, !dbg !431
  %8 = load i32, i32* %t, align 4, !dbg !432
  %9 = load i32, i32* %r, align 4, !dbg !433
  %add = add i32 %9, %8, !dbg !433
  store i32 %add, i32* %r, align 4, !dbg !433
  %10 = load i32, i32* %x, align 4, !dbg !434
  %and6 = and i32 %10, 15, !dbg !435
  %cmp7 = icmp eq i32 %and6, 0, !dbg !436
  %conv8 = zext i1 %cmp7 to i32, !dbg !436
  %shl9 = shl i32 %conv8, 2, !dbg !437
  store i32 %shl9, i32* %t, align 4, !dbg !438
  %11 = load i32, i32* %t, align 4, !dbg !439
  %12 = load i32, i32* %x, align 4, !dbg !440
  %shr10 = lshr i32 %12, %11, !dbg !440
  store i32 %shr10, i32* %x, align 4, !dbg !440
  %13 = load i32, i32* %t, align 4, !dbg !441
  %14 = load i32, i32* %r, align 4, !dbg !442
  %add11 = add i32 %14, %13, !dbg !442
  store i32 %add11, i32* %r, align 4, !dbg !442
  %15 = load i32, i32* %x, align 4, !dbg !443
  %and12 = and i32 %15, 3, !dbg !444
  %cmp13 = icmp eq i32 %and12, 0, !dbg !445
  %conv14 = zext i1 %cmp13 to i32, !dbg !445
  %shl15 = shl i32 %conv14, 1, !dbg !446
  store i32 %shl15, i32* %t, align 4, !dbg !447
  %16 = load i32, i32* %t, align 4, !dbg !448
  %17 = load i32, i32* %x, align 4, !dbg !449
  %shr16 = lshr i32 %17, %16, !dbg !449
  store i32 %shr16, i32* %x, align 4, !dbg !449
  %18 = load i32, i32* %x, align 4, !dbg !450
  %and17 = and i32 %18, 3, !dbg !450
  store i32 %and17, i32* %x, align 4, !dbg !450
  %19 = load i32, i32* %t, align 4, !dbg !451
  %20 = load i32, i32* %r, align 4, !dbg !452
  %add18 = add i32 %20, %19, !dbg !452
  store i32 %add18, i32* %r, align 4, !dbg !452
  %21 = load i32, i32* %r, align 4, !dbg !453
  %22 = load i32, i32* %x, align 4, !dbg !454
  %shr19 = lshr i32 %22, 1, !dbg !455
  %sub = sub i32 2, %shr19, !dbg !456
  %23 = load i32, i32* %x, align 4, !dbg !457
  %and20 = and i32 %23, 1, !dbg !458
  %cmp21 = icmp eq i32 %and20, 0, !dbg !459
  %conv22 = zext i1 %cmp21 to i32, !dbg !459
  %sub23 = sub nsw i32 0, %conv22, !dbg !460
  %and24 = and i32 %sub, %sub23, !dbg !461
  %add25 = add i32 %21, %and24, !dbg !462
  ret i32 %add25, !dbg !463
}

; Function Attrs: noinline nounwind
define dso_local i64 @__divdi3(i64 %a, i64 %b) #0 !dbg !464 {
entry:
  %a.addr = alloca i64, align 8
  %b.addr = alloca i64, align 8
  %bits_in_dword_m1 = alloca i32, align 4
  %s_a = alloca i64, align 8
  %s_b = alloca i64, align 8
  store i64 %a, i64* %a.addr, align 8
  store i64 %b, i64* %b.addr, align 8
  store i32 63, i32* %bits_in_dword_m1, align 4, !dbg !465
  %0 = load i64, i64* %a.addr, align 8, !dbg !466
  %shr = ashr i64 %0, 63, !dbg !467
  store i64 %shr, i64* %s_a, align 8, !dbg !468
  %1 = load i64, i64* %b.addr, align 8, !dbg !469
  %shr1 = ashr i64 %1, 63, !dbg !470
  store i64 %shr1, i64* %s_b, align 8, !dbg !471
  %2 = load i64, i64* %a.addr, align 8, !dbg !472
  %3 = load i64, i64* %s_a, align 8, !dbg !473
  %xor = xor i64 %2, %3, !dbg !474
  %4 = load i64, i64* %s_a, align 8, !dbg !475
  %sub = sub nsw i64 %xor, %4, !dbg !476
  store i64 %sub, i64* %a.addr, align 8, !dbg !477
  %5 = load i64, i64* %b.addr, align 8, !dbg !478
  %6 = load i64, i64* %s_b, align 8, !dbg !479
  %xor2 = xor i64 %5, %6, !dbg !480
  %7 = load i64, i64* %s_b, align 8, !dbg !481
  %sub3 = sub nsw i64 %xor2, %7, !dbg !482
  store i64 %sub3, i64* %b.addr, align 8, !dbg !483
  %8 = load i64, i64* %s_b, align 8, !dbg !484
  %9 = load i64, i64* %s_a, align 8, !dbg !485
  %xor4 = xor i64 %9, %8, !dbg !485
  store i64 %xor4, i64* %s_a, align 8, !dbg !485
  %10 = load i64, i64* %a.addr, align 8, !dbg !486
  %11 = load i64, i64* %b.addr, align 8, !dbg !487
  %call = call i64 @__udivmoddi4(i64 %10, i64 %11, i64* null) #4, !dbg !488
  %12 = load i64, i64* %s_a, align 8, !dbg !489
  %xor5 = xor i64 %call, %12, !dbg !490
  %13 = load i64, i64* %s_a, align 8, !dbg !491
  %sub6 = sub i64 %xor5, %13, !dbg !492
  ret i64 %sub6, !dbg !493
}

; Function Attrs: noinline nounwind
define dso_local i64 @__divmoddi4(i64 %a, i64 %b, i64* %rem) #0 !dbg !494 {
entry:
  %a.addr = alloca i64, align 8
  %b.addr = alloca i64, align 8
  %rem.addr = alloca i64*, align 4
  %d = alloca i64, align 8
  store i64 %a, i64* %a.addr, align 8
  store i64 %b, i64* %b.addr, align 8
  store i64* %rem, i64** %rem.addr, align 4
  %0 = load i64, i64* %a.addr, align 8, !dbg !495
  %1 = load i64, i64* %b.addr, align 8, !dbg !496
  %call = call i64 @__divdi3(i64 %0, i64 %1) #4, !dbg !497
  store i64 %call, i64* %d, align 8, !dbg !498
  %2 = load i64, i64* %a.addr, align 8, !dbg !499
  %3 = load i64, i64* %d, align 8, !dbg !500
  %4 = load i64, i64* %b.addr, align 8, !dbg !501
  %mul = mul nsw i64 %3, %4, !dbg !502
  %sub = sub nsw i64 %2, %mul, !dbg !503
  %5 = load i64*, i64** %rem.addr, align 4, !dbg !504
  store i64 %sub, i64* %5, align 8, !dbg !505
  %6 = load i64, i64* %d, align 8, !dbg !506
  ret i64 %6, !dbg !507
}

; Function Attrs: noinline nounwind
define dso_local i32 @__divmodsi4(i32 %a, i32 %b, i32* %rem) #0 !dbg !508 {
entry:
  %a.addr = alloca i32, align 4
  %b.addr = alloca i32, align 4
  %rem.addr = alloca i32*, align 4
  %d = alloca i32, align 4
  store i32 %a, i32* %a.addr, align 4
  store i32 %b, i32* %b.addr, align 4
  store i32* %rem, i32** %rem.addr, align 4
  %0 = load i32, i32* %a.addr, align 4, !dbg !509
  %1 = load i32, i32* %b.addr, align 4, !dbg !510
  %call = call i32 @__divsi3(i32 %0, i32 %1) #4, !dbg !511
  store i32 %call, i32* %d, align 4, !dbg !512
  %2 = load i32, i32* %a.addr, align 4, !dbg !513
  %3 = load i32, i32* %d, align 4, !dbg !514
  %4 = load i32, i32* %b.addr, align 4, !dbg !515
  %mul = mul nsw i32 %3, %4, !dbg !516
  %sub = sub nsw i32 %2, %mul, !dbg !517
  %5 = load i32*, i32** %rem.addr, align 4, !dbg !518
  store i32 %sub, i32* %5, align 4, !dbg !519
  %6 = load i32, i32* %d, align 4, !dbg !520
  ret i32 %6, !dbg !521
}

; Function Attrs: noinline nounwind
define dso_local i32 @__divsi3(i32 %a, i32 %b) #0 !dbg !522 {
entry:
  %a.addr = alloca i32, align 4
  %b.addr = alloca i32, align 4
  %bits_in_word_m1 = alloca i32, align 4
  %s_a = alloca i32, align 4
  %s_b = alloca i32, align 4
  store i32 %a, i32* %a.addr, align 4
  store i32 %b, i32* %b.addr, align 4
  store i32 31, i32* %bits_in_word_m1, align 4, !dbg !523
  %0 = load i32, i32* %a.addr, align 4, !dbg !524
  %shr = ashr i32 %0, 31, !dbg !525
  store i32 %shr, i32* %s_a, align 4, !dbg !526
  %1 = load i32, i32* %b.addr, align 4, !dbg !527
  %shr1 = ashr i32 %1, 31, !dbg !528
  store i32 %shr1, i32* %s_b, align 4, !dbg !529
  %2 = load i32, i32* %a.addr, align 4, !dbg !530
  %3 = load i32, i32* %s_a, align 4, !dbg !531
  %xor = xor i32 %2, %3, !dbg !532
  %4 = load i32, i32* %s_a, align 4, !dbg !533
  %sub = sub nsw i32 %xor, %4, !dbg !534
  store i32 %sub, i32* %a.addr, align 4, !dbg !535
  %5 = load i32, i32* %b.addr, align 4, !dbg !536
  %6 = load i32, i32* %s_b, align 4, !dbg !537
  %xor2 = xor i32 %5, %6, !dbg !538
  %7 = load i32, i32* %s_b, align 4, !dbg !539
  %sub3 = sub nsw i32 %xor2, %7, !dbg !540
  store i32 %sub3, i32* %b.addr, align 4, !dbg !541
  %8 = load i32, i32* %s_b, align 4, !dbg !542
  %9 = load i32, i32* %s_a, align 4, !dbg !543
  %xor4 = xor i32 %9, %8, !dbg !543
  store i32 %xor4, i32* %s_a, align 4, !dbg !543
  %10 = load i32, i32* %a.addr, align 4, !dbg !544
  %11 = load i32, i32* %b.addr, align 4, !dbg !545
  %div = udiv i32 %10, %11, !dbg !546
  %12 = load i32, i32* %s_a, align 4, !dbg !547
  %xor5 = xor i32 %div, %12, !dbg !548
  %13 = load i32, i32* %s_a, align 4, !dbg !549
  %sub6 = sub i32 %xor5, %13, !dbg !550
  ret i32 %sub6, !dbg !551
}

; Function Attrs: noinline nounwind
define dso_local i32 @__ffsdi2(i64 %a) #0 !dbg !552 {
entry:
  %retval = alloca i32, align 4
  %a.addr = alloca i64, align 8
  %x = alloca %union.dwords, align 8
  store i64 %a, i64* %a.addr, align 8
  %0 = load i64, i64* %a.addr, align 8, !dbg !553
  %all = bitcast %union.dwords* %x to i64*, !dbg !554
  store i64 %0, i64* %all, align 8, !dbg !555
  %s = bitcast %union.dwords* %x to %struct.anon*, !dbg !556
  %low = getelementptr inbounds %struct.anon, %struct.anon* %s, i32 0, i32 0, !dbg !557
  %1 = load i32, i32* %low, align 8, !dbg !557
  %cmp = icmp eq i32 %1, 0, !dbg !558
  br i1 %cmp, label %if.then, label %if.end6, !dbg !559

if.then:                                          ; preds = %entry
  %s1 = bitcast %union.dwords* %x to %struct.anon*, !dbg !560
  %high = getelementptr inbounds %struct.anon, %struct.anon* %s1, i32 0, i32 1, !dbg !561
  %2 = load i32, i32* %high, align 4, !dbg !561
  %cmp2 = icmp eq i32 %2, 0, !dbg !562
  br i1 %cmp2, label %if.then3, label %if.end, !dbg !563

if.then3:                                         ; preds = %if.then
  store i32 0, i32* %retval, align 4, !dbg !564
  br label %return, !dbg !564

if.end:                                           ; preds = %if.then
  %s4 = bitcast %union.dwords* %x to %struct.anon*, !dbg !565
  %high5 = getelementptr inbounds %struct.anon, %struct.anon* %s4, i32 0, i32 1, !dbg !566
  %3 = load i32, i32* %high5, align 4, !dbg !566
  %4 = call i32 @llvm.cttz.i32(i32 %3, i1 true), !dbg !567
  %add = add i32 %4, 33, !dbg !568
  store i32 %add, i32* %retval, align 4, !dbg !569
  br label %return, !dbg !569

if.end6:                                          ; preds = %entry
  %s7 = bitcast %union.dwords* %x to %struct.anon*, !dbg !570
  %low8 = getelementptr inbounds %struct.anon, %struct.anon* %s7, i32 0, i32 0, !dbg !571
  %5 = load i32, i32* %low8, align 8, !dbg !571
  %6 = call i32 @llvm.cttz.i32(i32 %5, i1 true), !dbg !572
  %add9 = add nsw i32 %6, 1, !dbg !573
  store i32 %add9, i32* %retval, align 4, !dbg !574
  br label %return, !dbg !574

return:                                           ; preds = %if.end6, %if.end, %if.then3
  %7 = load i32, i32* %retval, align 4, !dbg !575
  ret i32 %7, !dbg !575
}

; Function Attrs: noinline nounwind
define dso_local i32 @__ffssi2(i32 %a) #0 !dbg !576 {
entry:
  %retval = alloca i32, align 4
  %a.addr = alloca i32, align 4
  store i32 %a, i32* %a.addr, align 4
  %0 = load i32, i32* %a.addr, align 4, !dbg !577
  %cmp = icmp eq i32 %0, 0, !dbg !578
  br i1 %cmp, label %if.then, label %if.end, !dbg !577

if.then:                                          ; preds = %entry
  store i32 0, i32* %retval, align 4, !dbg !579
  br label %return, !dbg !579

if.end:                                           ; preds = %entry
  %1 = load i32, i32* %a.addr, align 4, !dbg !580
  %2 = call i32 @llvm.cttz.i32(i32 %1, i1 true), !dbg !581
  %add = add nsw i32 %2, 1, !dbg !582
  store i32 %add, i32* %retval, align 4, !dbg !583
  br label %return, !dbg !583

return:                                           ; preds = %if.end, %if.then
  %3 = load i32, i32* %retval, align 4, !dbg !584
  ret i32 %3, !dbg !584
}

; Function Attrs: noinline noreturn nounwind
define weak hidden void @compilerrt_abort_impl(i8* %file, i32 %line, i8* %function) #2 !dbg !585 {
entry:
  %file.addr = alloca i8*, align 4
  %line.addr = alloca i32, align 4
  %function.addr = alloca i8*, align 4
  store i8* %file, i8** %file.addr, align 4
  store i32 %line, i32* %line.addr, align 4
  store i8* %function, i8** %function.addr, align 4
  unreachable, !dbg !586
}

; Function Attrs: noinline nounwind
define dso_local i64 @__lshrdi3(i64 %a, i32 %b) #0 !dbg !587 {
entry:
  %retval = alloca i64, align 8
  %a.addr = alloca i64, align 8
  %b.addr = alloca i32, align 4
  %bits_in_word = alloca i32, align 4
  %input = alloca %union.dwords, align 8
  %result = alloca %union.dwords, align 8
  store i64 %a, i64* %a.addr, align 8
  store i32 %b, i32* %b.addr, align 4
  store i32 32, i32* %bits_in_word, align 4, !dbg !588
  %0 = load i64, i64* %a.addr, align 8, !dbg !589
  %all = bitcast %union.dwords* %input to i64*, !dbg !590
  store i64 %0, i64* %all, align 8, !dbg !591
  %1 = load i32, i32* %b.addr, align 4, !dbg !592
  %and = and i32 %1, 32, !dbg !593
  %tobool = icmp ne i32 %and, 0, !dbg !593
  br i1 %tobool, label %if.then, label %if.else, !dbg !592

if.then:                                          ; preds = %entry
  %s = bitcast %union.dwords* %result to %struct.anon*, !dbg !594
  %high = getelementptr inbounds %struct.anon, %struct.anon* %s, i32 0, i32 1, !dbg !595
  store i32 0, i32* %high, align 4, !dbg !596
  %s1 = bitcast %union.dwords* %input to %struct.anon*, !dbg !597
  %high2 = getelementptr inbounds %struct.anon, %struct.anon* %s1, i32 0, i32 1, !dbg !598
  %2 = load i32, i32* %high2, align 4, !dbg !598
  %3 = load i32, i32* %b.addr, align 4, !dbg !599
  %sub = sub nsw i32 %3, 32, !dbg !600
  %shr = lshr i32 %2, %sub, !dbg !601
  %s3 = bitcast %union.dwords* %result to %struct.anon*, !dbg !602
  %low = getelementptr inbounds %struct.anon, %struct.anon* %s3, i32 0, i32 0, !dbg !603
  store i32 %shr, i32* %low, align 8, !dbg !604
  br label %if.end18, !dbg !605

if.else:                                          ; preds = %entry
  %4 = load i32, i32* %b.addr, align 4, !dbg !606
  %cmp = icmp eq i32 %4, 0, !dbg !607
  br i1 %cmp, label %if.then4, label %if.end, !dbg !606

if.then4:                                         ; preds = %if.else
  %5 = load i64, i64* %a.addr, align 8, !dbg !608
  store i64 %5, i64* %retval, align 8, !dbg !609
  br label %return, !dbg !609

if.end:                                           ; preds = %if.else
  %s5 = bitcast %union.dwords* %input to %struct.anon*, !dbg !610
  %high6 = getelementptr inbounds %struct.anon, %struct.anon* %s5, i32 0, i32 1, !dbg !611
  %6 = load i32, i32* %high6, align 4, !dbg !611
  %7 = load i32, i32* %b.addr, align 4, !dbg !612
  %shr7 = lshr i32 %6, %7, !dbg !613
  %s8 = bitcast %union.dwords* %result to %struct.anon*, !dbg !614
  %high9 = getelementptr inbounds %struct.anon, %struct.anon* %s8, i32 0, i32 1, !dbg !615
  store i32 %shr7, i32* %high9, align 4, !dbg !616
  %s10 = bitcast %union.dwords* %input to %struct.anon*, !dbg !617
  %high11 = getelementptr inbounds %struct.anon, %struct.anon* %s10, i32 0, i32 1, !dbg !618
  %8 = load i32, i32* %high11, align 4, !dbg !618
  %9 = load i32, i32* %b.addr, align 4, !dbg !619
  %sub12 = sub nsw i32 32, %9, !dbg !620
  %shl = shl i32 %8, %sub12, !dbg !621
  %s13 = bitcast %union.dwords* %input to %struct.anon*, !dbg !622
  %low14 = getelementptr inbounds %struct.anon, %struct.anon* %s13, i32 0, i32 0, !dbg !623
  %10 = load i32, i32* %low14, align 8, !dbg !623
  %11 = load i32, i32* %b.addr, align 4, !dbg !624
  %shr15 = lshr i32 %10, %11, !dbg !625
  %or = or i32 %shl, %shr15, !dbg !626
  %s16 = bitcast %union.dwords* %result to %struct.anon*, !dbg !627
  %low17 = getelementptr inbounds %struct.anon, %struct.anon* %s16, i32 0, i32 0, !dbg !628
  store i32 %or, i32* %low17, align 8, !dbg !629
  br label %if.end18

if.end18:                                         ; preds = %if.end, %if.then
  %all19 = bitcast %union.dwords* %result to i64*, !dbg !630
  %12 = load i64, i64* %all19, align 8, !dbg !630
  store i64 %12, i64* %retval, align 8, !dbg !631
  br label %return, !dbg !631

return:                                           ; preds = %if.end18, %if.then4
  %13 = load i64, i64* %retval, align 8, !dbg !632
  ret i64 %13, !dbg !632
}

; Function Attrs: noinline nounwind
define dso_local i64 @__moddi3(i64 %a, i64 %b) #0 !dbg !633 {
entry:
  %a.addr = alloca i64, align 8
  %b.addr = alloca i64, align 8
  %bits_in_dword_m1 = alloca i32, align 4
  %s = alloca i64, align 8
  %r = alloca i64, align 8
  store i64 %a, i64* %a.addr, align 8
  store i64 %b, i64* %b.addr, align 8
  store i32 63, i32* %bits_in_dword_m1, align 4, !dbg !634
  %0 = load i64, i64* %b.addr, align 8, !dbg !635
  %shr = ashr i64 %0, 63, !dbg !636
  store i64 %shr, i64* %s, align 8, !dbg !637
  %1 = load i64, i64* %b.addr, align 8, !dbg !638
  %2 = load i64, i64* %s, align 8, !dbg !639
  %xor = xor i64 %1, %2, !dbg !640
  %3 = load i64, i64* %s, align 8, !dbg !641
  %sub = sub nsw i64 %xor, %3, !dbg !642
  store i64 %sub, i64* %b.addr, align 8, !dbg !643
  %4 = load i64, i64* %a.addr, align 8, !dbg !644
  %shr1 = ashr i64 %4, 63, !dbg !645
  store i64 %shr1, i64* %s, align 8, !dbg !646
  %5 = load i64, i64* %a.addr, align 8, !dbg !647
  %6 = load i64, i64* %s, align 8, !dbg !648
  %xor2 = xor i64 %5, %6, !dbg !649
  %7 = load i64, i64* %s, align 8, !dbg !650
  %sub3 = sub nsw i64 %xor2, %7, !dbg !651
  store i64 %sub3, i64* %a.addr, align 8, !dbg !652
  %8 = load i64, i64* %a.addr, align 8, !dbg !653
  %9 = load i64, i64* %b.addr, align 8, !dbg !654
  %call = call i64 @__udivmoddi4(i64 %8, i64 %9, i64* %r) #4, !dbg !655
  %10 = load i64, i64* %r, align 8, !dbg !656
  %11 = load i64, i64* %s, align 8, !dbg !657
  %xor4 = xor i64 %10, %11, !dbg !658
  %12 = load i64, i64* %s, align 8, !dbg !659
  %sub5 = sub nsw i64 %xor4, %12, !dbg !660
  ret i64 %sub5, !dbg !661
}

; Function Attrs: noinline nounwind
define dso_local i32 @__modsi3(i32 %a, i32 %b) #0 !dbg !662 {
entry:
  %a.addr = alloca i32, align 4
  %b.addr = alloca i32, align 4
  store i32 %a, i32* %a.addr, align 4
  store i32 %b, i32* %b.addr, align 4
  %0 = load i32, i32* %a.addr, align 4, !dbg !663
  %1 = load i32, i32* %a.addr, align 4, !dbg !664
  %2 = load i32, i32* %b.addr, align 4, !dbg !665
  %call = call i32 @__divsi3(i32 %1, i32 %2) #4, !dbg !666
  %3 = load i32, i32* %b.addr, align 4, !dbg !667
  %mul = mul nsw i32 %call, %3, !dbg !668
  %sub = sub nsw i32 %0, %mul, !dbg !669
  ret i32 %sub, !dbg !670
}

; Function Attrs: noinline nounwind
define dso_local i64 @__mulvdi3(i64 %a, i64 %b) #0 !dbg !671 {
entry:
  %retval = alloca i64, align 8
  %a.addr = alloca i64, align 8
  %b.addr = alloca i64, align 8
  %N = alloca i32, align 4
  %MIN = alloca i64, align 8
  %MAX = alloca i64, align 8
  %sa = alloca i64, align 8
  %abs_a = alloca i64, align 8
  %sb = alloca i64, align 8
  %abs_b = alloca i64, align 8
  store i64 %a, i64* %a.addr, align 8
  store i64 %b, i64* %b.addr, align 8
  store i32 64, i32* %N, align 4, !dbg !672
  store i64 -9223372036854775808, i64* %MIN, align 8, !dbg !673
  store i64 9223372036854775807, i64* %MAX, align 8, !dbg !674
  %0 = load i64, i64* %a.addr, align 8, !dbg !675
  %cmp = icmp eq i64 %0, -9223372036854775808, !dbg !676
  br i1 %cmp, label %if.then, label %if.end4, !dbg !675

if.then:                                          ; preds = %entry
  %1 = load i64, i64* %b.addr, align 8, !dbg !677
  %cmp1 = icmp eq i64 %1, 0, !dbg !678
  br i1 %cmp1, label %if.then3, label %lor.lhs.false, !dbg !679

lor.lhs.false:                                    ; preds = %if.then
  %2 = load i64, i64* %b.addr, align 8, !dbg !680
  %cmp2 = icmp eq i64 %2, 1, !dbg !681
  br i1 %cmp2, label %if.then3, label %if.end, !dbg !677

if.then3:                                         ; preds = %lor.lhs.false, %if.then
  %3 = load i64, i64* %a.addr, align 8, !dbg !682
  %4 = load i64, i64* %b.addr, align 8, !dbg !683
  %mul = mul nsw i64 %3, %4, !dbg !684
  store i64 %mul, i64* %retval, align 8, !dbg !685
  br label %return, !dbg !685

if.end:                                           ; preds = %lor.lhs.false
  call void @compilerrt_abort_impl(i8* getelementptr inbounds ([74 x i8], [74 x i8]* @.str.8, i32 0, i32 0), i32 31, i8* getelementptr inbounds ([10 x i8], [10 x i8]* @__func__.__mulvdi3, i32 0, i32 0)) #3, !dbg !686
  unreachable, !dbg !686

if.end4:                                          ; preds = %entry
  %5 = load i64, i64* %b.addr, align 8, !dbg !687
  %cmp5 = icmp eq i64 %5, -9223372036854775808, !dbg !688
  br i1 %cmp5, label %if.then6, label %if.end13, !dbg !687

if.then6:                                         ; preds = %if.end4
  %6 = load i64, i64* %a.addr, align 8, !dbg !689
  %cmp7 = icmp eq i64 %6, 0, !dbg !690
  br i1 %cmp7, label %if.then10, label %lor.lhs.false8, !dbg !691

lor.lhs.false8:                                   ; preds = %if.then6
  %7 = load i64, i64* %a.addr, align 8, !dbg !692
  %cmp9 = icmp eq i64 %7, 1, !dbg !693
  br i1 %cmp9, label %if.then10, label %if.end12, !dbg !689

if.then10:                                        ; preds = %lor.lhs.false8, %if.then6
  %8 = load i64, i64* %a.addr, align 8, !dbg !694
  %9 = load i64, i64* %b.addr, align 8, !dbg !695
  %mul11 = mul nsw i64 %8, %9, !dbg !696
  store i64 %mul11, i64* %retval, align 8, !dbg !697
  br label %return, !dbg !697

if.end12:                                         ; preds = %lor.lhs.false8
  call void @compilerrt_abort_impl(i8* getelementptr inbounds ([74 x i8], [74 x i8]* @.str.8, i32 0, i32 0), i32 37, i8* getelementptr inbounds ([10 x i8], [10 x i8]* @__func__.__mulvdi3, i32 0, i32 0)) #3, !dbg !698
  unreachable, !dbg !698

if.end13:                                         ; preds = %if.end4
  %10 = load i64, i64* %a.addr, align 8, !dbg !699
  %shr = ashr i64 %10, 63, !dbg !700
  store i64 %shr, i64* %sa, align 8, !dbg !701
  %11 = load i64, i64* %a.addr, align 8, !dbg !702
  %12 = load i64, i64* %sa, align 8, !dbg !703
  %xor = xor i64 %11, %12, !dbg !704
  %13 = load i64, i64* %sa, align 8, !dbg !705
  %sub = sub nsw i64 %xor, %13, !dbg !706
  store i64 %sub, i64* %abs_a, align 8, !dbg !707
  %14 = load i64, i64* %b.addr, align 8, !dbg !708
  %shr14 = ashr i64 %14, 63, !dbg !709
  store i64 %shr14, i64* %sb, align 8, !dbg !710
  %15 = load i64, i64* %b.addr, align 8, !dbg !711
  %16 = load i64, i64* %sb, align 8, !dbg !712
  %xor15 = xor i64 %15, %16, !dbg !713
  %17 = load i64, i64* %sb, align 8, !dbg !714
  %sub16 = sub nsw i64 %xor15, %17, !dbg !715
  store i64 %sub16, i64* %abs_b, align 8, !dbg !716
  %18 = load i64, i64* %abs_a, align 8, !dbg !717
  %cmp17 = icmp slt i64 %18, 2, !dbg !718
  br i1 %cmp17, label %if.then20, label %lor.lhs.false18, !dbg !719

lor.lhs.false18:                                  ; preds = %if.end13
  %19 = load i64, i64* %abs_b, align 8, !dbg !720
  %cmp19 = icmp slt i64 %19, 2, !dbg !721
  br i1 %cmp19, label %if.then20, label %if.end22, !dbg !717

if.then20:                                        ; preds = %lor.lhs.false18, %if.end13
  %20 = load i64, i64* %a.addr, align 8, !dbg !722
  %21 = load i64, i64* %b.addr, align 8, !dbg !723
  %mul21 = mul nsw i64 %20, %21, !dbg !724
  store i64 %mul21, i64* %retval, align 8, !dbg !725
  br label %return, !dbg !725

if.end22:                                         ; preds = %lor.lhs.false18
  %22 = load i64, i64* %sa, align 8, !dbg !726
  %23 = load i64, i64* %sb, align 8, !dbg !727
  %cmp23 = icmp eq i64 %22, %23, !dbg !728
  br i1 %cmp23, label %if.then24, label %if.else, !dbg !726

if.then24:                                        ; preds = %if.end22
  %24 = load i64, i64* %abs_a, align 8, !dbg !729
  %25 = load i64, i64* %abs_b, align 8, !dbg !730
  %div = sdiv i64 9223372036854775807, %25, !dbg !731
  %cmp25 = icmp sgt i64 %24, %div, !dbg !732
  br i1 %cmp25, label %if.then26, label %if.end27, !dbg !729

if.then26:                                        ; preds = %if.then24
  call void @compilerrt_abort_impl(i8* getelementptr inbounds ([74 x i8], [74 x i8]* @.str.8, i32 0, i32 0), i32 48, i8* getelementptr inbounds ([10 x i8], [10 x i8]* @__func__.__mulvdi3, i32 0, i32 0)) #3, !dbg !733
  unreachable, !dbg !733

if.end27:                                         ; preds = %if.then24
  br label %if.end33, !dbg !734

if.else:                                          ; preds = %if.end22
  %26 = load i64, i64* %abs_a, align 8, !dbg !735
  %27 = load i64, i64* %abs_b, align 8, !dbg !736
  %sub28 = sub nsw i64 0, %27, !dbg !737
  %div29 = sdiv i64 -9223372036854775808, %sub28, !dbg !738
  %cmp30 = icmp sgt i64 %26, %div29, !dbg !739
  br i1 %cmp30, label %if.then31, label %if.end32, !dbg !735

if.then31:                                        ; preds = %if.else
  call void @compilerrt_abort_impl(i8* getelementptr inbounds ([74 x i8], [74 x i8]* @.str.8, i32 0, i32 0), i32 53, i8* getelementptr inbounds ([10 x i8], [10 x i8]* @__func__.__mulvdi3, i32 0, i32 0)) #3, !dbg !740
  unreachable, !dbg !740

if.end32:                                         ; preds = %if.else
  br label %if.end33

if.end33:                                         ; preds = %if.end32, %if.end27
  %28 = load i64, i64* %a.addr, align 8, !dbg !741
  %29 = load i64, i64* %b.addr, align 8, !dbg !742
  %mul34 = mul nsw i64 %28, %29, !dbg !743
  store i64 %mul34, i64* %retval, align 8, !dbg !744
  br label %return, !dbg !744

return:                                           ; preds = %if.end33, %if.then20, %if.then10, %if.then3
  %30 = load i64, i64* %retval, align 8, !dbg !745
  ret i64 %30, !dbg !745
}

; Function Attrs: noinline nounwind
define dso_local i32 @__mulvsi3(i32 %a, i32 %b) #0 !dbg !746 {
entry:
  %retval = alloca i32, align 4
  %a.addr = alloca i32, align 4
  %b.addr = alloca i32, align 4
  %N = alloca i32, align 4
  %MIN = alloca i32, align 4
  %MAX = alloca i32, align 4
  %sa = alloca i32, align 4
  %abs_a = alloca i32, align 4
  %sb = alloca i32, align 4
  %abs_b = alloca i32, align 4
  store i32 %a, i32* %a.addr, align 4
  store i32 %b, i32* %b.addr, align 4
  store i32 32, i32* %N, align 4, !dbg !747
  store i32 -2147483648, i32* %MIN, align 4, !dbg !748
  store i32 2147483647, i32* %MAX, align 4, !dbg !749
  %0 = load i32, i32* %a.addr, align 4, !dbg !750
  %cmp = icmp eq i32 %0, -2147483648, !dbg !751
  br i1 %cmp, label %if.then, label %if.end4, !dbg !750

if.then:                                          ; preds = %entry
  %1 = load i32, i32* %b.addr, align 4, !dbg !752
  %cmp1 = icmp eq i32 %1, 0, !dbg !753
  br i1 %cmp1, label %if.then3, label %lor.lhs.false, !dbg !754

lor.lhs.false:                                    ; preds = %if.then
  %2 = load i32, i32* %b.addr, align 4, !dbg !755
  %cmp2 = icmp eq i32 %2, 1, !dbg !756
  br i1 %cmp2, label %if.then3, label %if.end, !dbg !752

if.then3:                                         ; preds = %lor.lhs.false, %if.then
  %3 = load i32, i32* %a.addr, align 4, !dbg !757
  %4 = load i32, i32* %b.addr, align 4, !dbg !758
  %mul = mul nsw i32 %3, %4, !dbg !759
  store i32 %mul, i32* %retval, align 4, !dbg !760
  br label %return, !dbg !760

if.end:                                           ; preds = %lor.lhs.false
  call void @compilerrt_abort_impl(i8* getelementptr inbounds ([74 x i8], [74 x i8]* @.str.9, i32 0, i32 0), i32 31, i8* getelementptr inbounds ([10 x i8], [10 x i8]* @__func__.__mulvsi3, i32 0, i32 0)) #3, !dbg !761
  unreachable, !dbg !761

if.end4:                                          ; preds = %entry
  %5 = load i32, i32* %b.addr, align 4, !dbg !762
  %cmp5 = icmp eq i32 %5, -2147483648, !dbg !763
  br i1 %cmp5, label %if.then6, label %if.end13, !dbg !762

if.then6:                                         ; preds = %if.end4
  %6 = load i32, i32* %a.addr, align 4, !dbg !764
  %cmp7 = icmp eq i32 %6, 0, !dbg !765
  br i1 %cmp7, label %if.then10, label %lor.lhs.false8, !dbg !766

lor.lhs.false8:                                   ; preds = %if.then6
  %7 = load i32, i32* %a.addr, align 4, !dbg !767
  %cmp9 = icmp eq i32 %7, 1, !dbg !768
  br i1 %cmp9, label %if.then10, label %if.end12, !dbg !764

if.then10:                                        ; preds = %lor.lhs.false8, %if.then6
  %8 = load i32, i32* %a.addr, align 4, !dbg !769
  %9 = load i32, i32* %b.addr, align 4, !dbg !770
  %mul11 = mul nsw i32 %8, %9, !dbg !771
  store i32 %mul11, i32* %retval, align 4, !dbg !772
  br label %return, !dbg !772

if.end12:                                         ; preds = %lor.lhs.false8
  call void @compilerrt_abort_impl(i8* getelementptr inbounds ([74 x i8], [74 x i8]* @.str.9, i32 0, i32 0), i32 37, i8* getelementptr inbounds ([10 x i8], [10 x i8]* @__func__.__mulvsi3, i32 0, i32 0)) #3, !dbg !773
  unreachable, !dbg !773

if.end13:                                         ; preds = %if.end4
  %10 = load i32, i32* %a.addr, align 4, !dbg !774
  %shr = ashr i32 %10, 31, !dbg !775
  store i32 %shr, i32* %sa, align 4, !dbg !776
  %11 = load i32, i32* %a.addr, align 4, !dbg !777
  %12 = load i32, i32* %sa, align 4, !dbg !778
  %xor = xor i32 %11, %12, !dbg !779
  %13 = load i32, i32* %sa, align 4, !dbg !780
  %sub = sub nsw i32 %xor, %13, !dbg !781
  store i32 %sub, i32* %abs_a, align 4, !dbg !782
  %14 = load i32, i32* %b.addr, align 4, !dbg !783
  %shr14 = ashr i32 %14, 31, !dbg !784
  store i32 %shr14, i32* %sb, align 4, !dbg !785
  %15 = load i32, i32* %b.addr, align 4, !dbg !786
  %16 = load i32, i32* %sb, align 4, !dbg !787
  %xor15 = xor i32 %15, %16, !dbg !788
  %17 = load i32, i32* %sb, align 4, !dbg !789
  %sub16 = sub nsw i32 %xor15, %17, !dbg !790
  store i32 %sub16, i32* %abs_b, align 4, !dbg !791
  %18 = load i32, i32* %abs_a, align 4, !dbg !792
  %cmp17 = icmp slt i32 %18, 2, !dbg !793
  br i1 %cmp17, label %if.then20, label %lor.lhs.false18, !dbg !794

lor.lhs.false18:                                  ; preds = %if.end13
  %19 = load i32, i32* %abs_b, align 4, !dbg !795
  %cmp19 = icmp slt i32 %19, 2, !dbg !796
  br i1 %cmp19, label %if.then20, label %if.end22, !dbg !792

if.then20:                                        ; preds = %lor.lhs.false18, %if.end13
  %20 = load i32, i32* %a.addr, align 4, !dbg !797
  %21 = load i32, i32* %b.addr, align 4, !dbg !798
  %mul21 = mul nsw i32 %20, %21, !dbg !799
  store i32 %mul21, i32* %retval, align 4, !dbg !800
  br label %return, !dbg !800

if.end22:                                         ; preds = %lor.lhs.false18
  %22 = load i32, i32* %sa, align 4, !dbg !801
  %23 = load i32, i32* %sb, align 4, !dbg !802
  %cmp23 = icmp eq i32 %22, %23, !dbg !803
  br i1 %cmp23, label %if.then24, label %if.else, !dbg !801

if.then24:                                        ; preds = %if.end22
  %24 = load i32, i32* %abs_a, align 4, !dbg !804
  %25 = load i32, i32* %abs_b, align 4, !dbg !805
  %div = sdiv i32 2147483647, %25, !dbg !806
  %cmp25 = icmp sgt i32 %24, %div, !dbg !807
  br i1 %cmp25, label %if.then26, label %if.end27, !dbg !804

if.then26:                                        ; preds = %if.then24
  call void @compilerrt_abort_impl(i8* getelementptr inbounds ([74 x i8], [74 x i8]* @.str.9, i32 0, i32 0), i32 48, i8* getelementptr inbounds ([10 x i8], [10 x i8]* @__func__.__mulvsi3, i32 0, i32 0)) #3, !dbg !808
  unreachable, !dbg !808

if.end27:                                         ; preds = %if.then24
  br label %if.end33, !dbg !809

if.else:                                          ; preds = %if.end22
  %26 = load i32, i32* %abs_a, align 4, !dbg !810
  %27 = load i32, i32* %abs_b, align 4, !dbg !811
  %sub28 = sub nsw i32 0, %27, !dbg !812
  %div29 = sdiv i32 -2147483648, %sub28, !dbg !813
  %cmp30 = icmp sgt i32 %26, %div29, !dbg !814
  br i1 %cmp30, label %if.then31, label %if.end32, !dbg !810

if.then31:                                        ; preds = %if.else
  call void @compilerrt_abort_impl(i8* getelementptr inbounds ([74 x i8], [74 x i8]* @.str.9, i32 0, i32 0), i32 53, i8* getelementptr inbounds ([10 x i8], [10 x i8]* @__func__.__mulvsi3, i32 0, i32 0)) #3, !dbg !815
  unreachable, !dbg !815

if.end32:                                         ; preds = %if.else
  br label %if.end33

if.end33:                                         ; preds = %if.end32, %if.end27
  %28 = load i32, i32* %a.addr, align 4, !dbg !816
  %29 = load i32, i32* %b.addr, align 4, !dbg !817
  %mul34 = mul nsw i32 %28, %29, !dbg !818
  store i32 %mul34, i32* %retval, align 4, !dbg !819
  br label %return, !dbg !819

return:                                           ; preds = %if.end33, %if.then20, %if.then10, %if.then3
  %30 = load i32, i32* %retval, align 4, !dbg !820
  ret i32 %30, !dbg !820
}

; Function Attrs: noinline nounwind
define dso_local i32 @__paritydi2(i64 %a) #0 !dbg !821 {
entry:
  %a.addr = alloca i64, align 8
  %x = alloca %union.dwords, align 8
  store i64 %a, i64* %a.addr, align 8
  %0 = load i64, i64* %a.addr, align 8, !dbg !822
  %all = bitcast %union.dwords* %x to i64*, !dbg !823
  store i64 %0, i64* %all, align 8, !dbg !824
  %s = bitcast %union.dwords* %x to %struct.anon*, !dbg !825
  %high = getelementptr inbounds %struct.anon, %struct.anon* %s, i32 0, i32 1, !dbg !826
  %1 = load i32, i32* %high, align 4, !dbg !826
  %s1 = bitcast %union.dwords* %x to %struct.anon*, !dbg !827
  %low = getelementptr inbounds %struct.anon, %struct.anon* %s1, i32 0, i32 0, !dbg !828
  %2 = load i32, i32* %low, align 8, !dbg !828
  %xor = xor i32 %1, %2, !dbg !829
  %call = call i32 @__paritysi2(i32 %xor) #4, !dbg !830
  ret i32 %call, !dbg !831
}

; Function Attrs: noinline nounwind
define dso_local i32 @__paritysi2(i32 %a) #0 !dbg !832 {
entry:
  %a.addr = alloca i32, align 4
  %x = alloca i32, align 4
  store i32 %a, i32* %a.addr, align 4
  %0 = load i32, i32* %a.addr, align 4, !dbg !833
  store i32 %0, i32* %x, align 4, !dbg !834
  %1 = load i32, i32* %x, align 4, !dbg !835
  %shr = lshr i32 %1, 16, !dbg !836
  %2 = load i32, i32* %x, align 4, !dbg !837
  %xor = xor i32 %2, %shr, !dbg !837
  store i32 %xor, i32* %x, align 4, !dbg !837
  %3 = load i32, i32* %x, align 4, !dbg !838
  %shr1 = lshr i32 %3, 8, !dbg !839
  %4 = load i32, i32* %x, align 4, !dbg !840
  %xor2 = xor i32 %4, %shr1, !dbg !840
  store i32 %xor2, i32* %x, align 4, !dbg !840
  %5 = load i32, i32* %x, align 4, !dbg !841
  %shr3 = lshr i32 %5, 4, !dbg !842
  %6 = load i32, i32* %x, align 4, !dbg !843
  %xor4 = xor i32 %6, %shr3, !dbg !843
  store i32 %xor4, i32* %x, align 4, !dbg !843
  %7 = load i32, i32* %x, align 4, !dbg !844
  %and = and i32 %7, 15, !dbg !845
  %shr5 = ashr i32 27030, %and, !dbg !846
  %and6 = and i32 %shr5, 1, !dbg !847
  ret i32 %and6, !dbg !848
}

; Function Attrs: noinline nounwind
define dso_local i32 @__popcountdi2(i64 %a) #0 !dbg !849 {
entry:
  %a.addr = alloca i64, align 8
  %x2 = alloca i64, align 8
  %x = alloca i32, align 4
  store i64 %a, i64* %a.addr, align 8
  %0 = load i64, i64* %a.addr, align 8, !dbg !850
  store i64 %0, i64* %x2, align 8, !dbg !851
  %1 = load i64, i64* %x2, align 8, !dbg !852
  %2 = load i64, i64* %x2, align 8, !dbg !853
  %shr = lshr i64 %2, 1, !dbg !854
  %and = and i64 %shr, 6148914691236517205, !dbg !855
  %sub = sub i64 %1, %and, !dbg !856
  store i64 %sub, i64* %x2, align 8, !dbg !857
  %3 = load i64, i64* %x2, align 8, !dbg !858
  %shr1 = lshr i64 %3, 2, !dbg !859
  %and2 = and i64 %shr1, 3689348814741910323, !dbg !860
  %4 = load i64, i64* %x2, align 8, !dbg !861
  %and3 = and i64 %4, 3689348814741910323, !dbg !862
  %add = add i64 %and2, %and3, !dbg !863
  store i64 %add, i64* %x2, align 8, !dbg !864
  %5 = load i64, i64* %x2, align 8, !dbg !865
  %6 = load i64, i64* %x2, align 8, !dbg !866
  %shr4 = lshr i64 %6, 4, !dbg !867
  %add5 = add i64 %5, %shr4, !dbg !868
  %and6 = and i64 %add5, 1085102592571150095, !dbg !869
  store i64 %and6, i64* %x2, align 8, !dbg !870
  %7 = load i64, i64* %x2, align 8, !dbg !871
  %8 = load i64, i64* %x2, align 8, !dbg !872
  %shr7 = lshr i64 %8, 32, !dbg !873
  %add8 = add i64 %7, %shr7, !dbg !874
  %conv = trunc i64 %add8 to i32, !dbg !875
  store i32 %conv, i32* %x, align 4, !dbg !876
  %9 = load i32, i32* %x, align 4, !dbg !877
  %10 = load i32, i32* %x, align 4, !dbg !878
  %shr9 = lshr i32 %10, 16, !dbg !879
  %add10 = add i32 %9, %shr9, !dbg !880
  store i32 %add10, i32* %x, align 4, !dbg !881
  %11 = load i32, i32* %x, align 4, !dbg !882
  %12 = load i32, i32* %x, align 4, !dbg !883
  %shr11 = lshr i32 %12, 8, !dbg !884
  %add12 = add i32 %11, %shr11, !dbg !885
  %and13 = and i32 %add12, 127, !dbg !886
  ret i32 %and13, !dbg !887
}

; Function Attrs: noinline nounwind
define dso_local i32 @__popcountsi2(i32 %a) #0 !dbg !888 {
entry:
  %a.addr = alloca i32, align 4
  %x = alloca i32, align 4
  store i32 %a, i32* %a.addr, align 4
  %0 = load i32, i32* %a.addr, align 4, !dbg !889
  store i32 %0, i32* %x, align 4, !dbg !890
  %1 = load i32, i32* %x, align 4, !dbg !891
  %2 = load i32, i32* %x, align 4, !dbg !892
  %shr = lshr i32 %2, 1, !dbg !893
  %and = and i32 %shr, 1431655765, !dbg !894
  %sub = sub i32 %1, %and, !dbg !895
  store i32 %sub, i32* %x, align 4, !dbg !896
  %3 = load i32, i32* %x, align 4, !dbg !897
  %shr1 = lshr i32 %3, 2, !dbg !898
  %and2 = and i32 %shr1, 858993459, !dbg !899
  %4 = load i32, i32* %x, align 4, !dbg !900
  %and3 = and i32 %4, 858993459, !dbg !901
  %add = add i32 %and2, %and3, !dbg !902
  store i32 %add, i32* %x, align 4, !dbg !903
  %5 = load i32, i32* %x, align 4, !dbg !904
  %6 = load i32, i32* %x, align 4, !dbg !905
  %shr4 = lshr i32 %6, 4, !dbg !906
  %add5 = add i32 %5, %shr4, !dbg !907
  %and6 = and i32 %add5, 252645135, !dbg !908
  store i32 %and6, i32* %x, align 4, !dbg !909
  %7 = load i32, i32* %x, align 4, !dbg !910
  %8 = load i32, i32* %x, align 4, !dbg !911
  %shr7 = lshr i32 %8, 16, !dbg !912
  %add8 = add i32 %7, %shr7, !dbg !913
  store i32 %add8, i32* %x, align 4, !dbg !914
  %9 = load i32, i32* %x, align 4, !dbg !915
  %10 = load i32, i32* %x, align 4, !dbg !916
  %shr9 = lshr i32 %10, 8, !dbg !917
  %add10 = add i32 %9, %shr9, !dbg !918
  %and11 = and i32 %add10, 63, !dbg !919
  ret i32 %and11, !dbg !920
}

; Function Attrs: noinline nounwind
define dso_local i64 @__subvdi3(i64 %a, i64 %b) #0 !dbg !921 {
entry:
  %a.addr = alloca i64, align 8
  %b.addr = alloca i64, align 8
  %s = alloca i64, align 8
  store i64 %a, i64* %a.addr, align 8
  store i64 %b, i64* %b.addr, align 8
  %0 = load i64, i64* %a.addr, align 8, !dbg !922
  %1 = load i64, i64* %b.addr, align 8, !dbg !923
  %sub = sub i64 %0, %1, !dbg !924
  store i64 %sub, i64* %s, align 8, !dbg !925
  %2 = load i64, i64* %b.addr, align 8, !dbg !926
  %cmp = icmp sge i64 %2, 0, !dbg !927
  br i1 %cmp, label %if.then, label %if.else, !dbg !926

if.then:                                          ; preds = %entry
  %3 = load i64, i64* %s, align 8, !dbg !928
  %4 = load i64, i64* %a.addr, align 8, !dbg !929
  %cmp1 = icmp sgt i64 %3, %4, !dbg !930
  br i1 %cmp1, label %if.then2, label %if.end, !dbg !928

if.then2:                                         ; preds = %if.then
  call void @compilerrt_abort_impl(i8* getelementptr inbounds ([74 x i8], [74 x i8]* @.str.12, i32 0, i32 0), i32 28, i8* getelementptr inbounds ([10 x i8], [10 x i8]* @__func__.__subvdi3, i32 0, i32 0)) #3, !dbg !931
  unreachable, !dbg !931

if.end:                                           ; preds = %if.then
  br label %if.end6, !dbg !932

if.else:                                          ; preds = %entry
  %5 = load i64, i64* %s, align 8, !dbg !933
  %6 = load i64, i64* %a.addr, align 8, !dbg !934
  %cmp3 = icmp sle i64 %5, %6, !dbg !935
  br i1 %cmp3, label %if.then4, label %if.end5, !dbg !933

if.then4:                                         ; preds = %if.else
  call void @compilerrt_abort_impl(i8* getelementptr inbounds ([74 x i8], [74 x i8]* @.str.12, i32 0, i32 0), i32 33, i8* getelementptr inbounds ([10 x i8], [10 x i8]* @__func__.__subvdi3, i32 0, i32 0)) #3, !dbg !936
  unreachable, !dbg !936

if.end5:                                          ; preds = %if.else
  br label %if.end6

if.end6:                                          ; preds = %if.end5, %if.end
  %7 = load i64, i64* %s, align 8, !dbg !937
  ret i64 %7, !dbg !938
}

; Function Attrs: noinline nounwind
define dso_local i32 @__subvsi3(i32 %a, i32 %b) #0 !dbg !939 {
entry:
  %a.addr = alloca i32, align 4
  %b.addr = alloca i32, align 4
  %s = alloca i32, align 4
  store i32 %a, i32* %a.addr, align 4
  store i32 %b, i32* %b.addr, align 4
  %0 = load i32, i32* %a.addr, align 4, !dbg !940
  %1 = load i32, i32* %b.addr, align 4, !dbg !941
  %sub = sub i32 %0, %1, !dbg !942
  store i32 %sub, i32* %s, align 4, !dbg !943
  %2 = load i32, i32* %b.addr, align 4, !dbg !944
  %cmp = icmp sge i32 %2, 0, !dbg !945
  br i1 %cmp, label %if.then, label %if.else, !dbg !944

if.then:                                          ; preds = %entry
  %3 = load i32, i32* %s, align 4, !dbg !946
  %4 = load i32, i32* %a.addr, align 4, !dbg !947
  %cmp1 = icmp sgt i32 %3, %4, !dbg !948
  br i1 %cmp1, label %if.then2, label %if.end, !dbg !946

if.then2:                                         ; preds = %if.then
  call void @compilerrt_abort_impl(i8* getelementptr inbounds ([74 x i8], [74 x i8]* @.str.13, i32 0, i32 0), i32 28, i8* getelementptr inbounds ([10 x i8], [10 x i8]* @__func__.__subvsi3, i32 0, i32 0)) #3, !dbg !949
  unreachable, !dbg !949

if.end:                                           ; preds = %if.then
  br label %if.end6, !dbg !950

if.else:                                          ; preds = %entry
  %5 = load i32, i32* %s, align 4, !dbg !951
  %6 = load i32, i32* %a.addr, align 4, !dbg !952
  %cmp3 = icmp sle i32 %5, %6, !dbg !953
  br i1 %cmp3, label %if.then4, label %if.end5, !dbg !951

if.then4:                                         ; preds = %if.else
  call void @compilerrt_abort_impl(i8* getelementptr inbounds ([74 x i8], [74 x i8]* @.str.13, i32 0, i32 0), i32 33, i8* getelementptr inbounds ([10 x i8], [10 x i8]* @__func__.__subvsi3, i32 0, i32 0)) #3, !dbg !954
  unreachable, !dbg !954

if.end5:                                          ; preds = %if.else
  br label %if.end6

if.end6:                                          ; preds = %if.end5, %if.end
  %7 = load i32, i32* %s, align 4, !dbg !955
  ret i32 %7, !dbg !956
}

; Function Attrs: noinline nounwind
define dso_local i32 @__ucmpdi2(i64 %a, i64 %b) #0 !dbg !957 {
entry:
  %retval = alloca i32, align 4
  %a.addr = alloca i64, align 8
  %b.addr = alloca i64, align 8
  %x = alloca %union.dwords, align 8
  %y = alloca %union.dwords, align 8
  store i64 %a, i64* %a.addr, align 8
  store i64 %b, i64* %b.addr, align 8
  %0 = load i64, i64* %a.addr, align 8, !dbg !958
  %all = bitcast %union.dwords* %x to i64*, !dbg !959
  store i64 %0, i64* %all, align 8, !dbg !960
  %1 = load i64, i64* %b.addr, align 8, !dbg !961
  %all1 = bitcast %union.dwords* %y to i64*, !dbg !962
  store i64 %1, i64* %all1, align 8, !dbg !963
  %s = bitcast %union.dwords* %x to %struct.anon*, !dbg !964
  %high = getelementptr inbounds %struct.anon, %struct.anon* %s, i32 0, i32 1, !dbg !965
  %2 = load i32, i32* %high, align 4, !dbg !965
  %s2 = bitcast %union.dwords* %y to %struct.anon*, !dbg !966
  %high3 = getelementptr inbounds %struct.anon, %struct.anon* %s2, i32 0, i32 1, !dbg !967
  %3 = load i32, i32* %high3, align 4, !dbg !967
  %cmp = icmp ult i32 %2, %3, !dbg !968
  br i1 %cmp, label %if.then, label %if.end, !dbg !969

if.then:                                          ; preds = %entry
  store i32 0, i32* %retval, align 4, !dbg !970
  br label %return, !dbg !970

if.end:                                           ; preds = %entry
  %s4 = bitcast %union.dwords* %x to %struct.anon*, !dbg !971
  %high5 = getelementptr inbounds %struct.anon, %struct.anon* %s4, i32 0, i32 1, !dbg !972
  %4 = load i32, i32* %high5, align 4, !dbg !972
  %s6 = bitcast %union.dwords* %y to %struct.anon*, !dbg !973
  %high7 = getelementptr inbounds %struct.anon, %struct.anon* %s6, i32 0, i32 1, !dbg !974
  %5 = load i32, i32* %high7, align 4, !dbg !974
  %cmp8 = icmp ugt i32 %4, %5, !dbg !975
  br i1 %cmp8, label %if.then9, label %if.end10, !dbg !976

if.then9:                                         ; preds = %if.end
  store i32 2, i32* %retval, align 4, !dbg !977
  br label %return, !dbg !977

if.end10:                                         ; preds = %if.end
  %s11 = bitcast %union.dwords* %x to %struct.anon*, !dbg !978
  %low = getelementptr inbounds %struct.anon, %struct.anon* %s11, i32 0, i32 0, !dbg !979
  %6 = load i32, i32* %low, align 8, !dbg !979
  %s12 = bitcast %union.dwords* %y to %struct.anon*, !dbg !980
  %low13 = getelementptr inbounds %struct.anon, %struct.anon* %s12, i32 0, i32 0, !dbg !981
  %7 = load i32, i32* %low13, align 8, !dbg !981
  %cmp14 = icmp ult i32 %6, %7, !dbg !982
  br i1 %cmp14, label %if.then15, label %if.end16, !dbg !983

if.then15:                                        ; preds = %if.end10
  store i32 0, i32* %retval, align 4, !dbg !984
  br label %return, !dbg !984

if.end16:                                         ; preds = %if.end10
  %s17 = bitcast %union.dwords* %x to %struct.anon*, !dbg !985
  %low18 = getelementptr inbounds %struct.anon, %struct.anon* %s17, i32 0, i32 0, !dbg !986
  %8 = load i32, i32* %low18, align 8, !dbg !986
  %s19 = bitcast %union.dwords* %y to %struct.anon*, !dbg !987
  %low20 = getelementptr inbounds %struct.anon, %struct.anon* %s19, i32 0, i32 0, !dbg !988
  %9 = load i32, i32* %low20, align 8, !dbg !988
  %cmp21 = icmp ugt i32 %8, %9, !dbg !989
  br i1 %cmp21, label %if.then22, label %if.end23, !dbg !990

if.then22:                                        ; preds = %if.end16
  store i32 2, i32* %retval, align 4, !dbg !991
  br label %return, !dbg !991

if.end23:                                         ; preds = %if.end16
  store i32 1, i32* %retval, align 4, !dbg !992
  br label %return, !dbg !992

return:                                           ; preds = %if.end23, %if.then22, %if.then15, %if.then9, %if.then
  %10 = load i32, i32* %retval, align 4, !dbg !993
  ret i32 %10, !dbg !993
}

; Function Attrs: noinline nounwind
define dso_local i64 @__udivdi3(i64 %a, i64 %b) #0 !dbg !994 {
entry:
  %a.addr = alloca i64, align 8
  %b.addr = alloca i64, align 8
  store i64 %a, i64* %a.addr, align 8
  store i64 %b, i64* %b.addr, align 8
  %0 = load i64, i64* %a.addr, align 8, !dbg !995
  %1 = load i64, i64* %b.addr, align 8, !dbg !996
  %call = call i64 @__udivmoddi4(i64 %0, i64 %1, i64* null) #4, !dbg !997
  ret i64 %call, !dbg !998
}

; Function Attrs: noinline nounwind
define dso_local i64 @__udivmoddi4(i64 %a, i64 %b, i64* %rem) #0 !dbg !999 {
entry:
  %retval = alloca i64, align 8
  %a.addr = alloca i64, align 8
  %b.addr = alloca i64, align 8
  %rem.addr = alloca i64*, align 4
  %n_uword_bits = alloca i32, align 4
  %n_udword_bits = alloca i32, align 4
  %n = alloca %union.dwords, align 8
  %d = alloca %union.dwords, align 8
  %q = alloca %union.dwords, align 8
  %r = alloca %union.dwords, align 8
  %sr = alloca i32, align 4
  %carry = alloca i32, align 4
  %s353 = alloca i64, align 8
  store i64 %a, i64* %a.addr, align 8
  store i64 %b, i64* %b.addr, align 8
  store i64* %rem, i64** %rem.addr, align 4
  store i32 32, i32* %n_uword_bits, align 4, !dbg !1000
  store i32 64, i32* %n_udword_bits, align 4, !dbg !1001
  %0 = load i64, i64* %a.addr, align 8, !dbg !1002
  %all = bitcast %union.dwords* %n to i64*, !dbg !1003
  store i64 %0, i64* %all, align 8, !dbg !1004
  %1 = load i64, i64* %b.addr, align 8, !dbg !1005
  %all1 = bitcast %union.dwords* %d to i64*, !dbg !1006
  store i64 %1, i64* %all1, align 8, !dbg !1007
  %s = bitcast %union.dwords* %n to %struct.anon*, !dbg !1008
  %high = getelementptr inbounds %struct.anon, %struct.anon* %s, i32 0, i32 1, !dbg !1009
  %2 = load i32, i32* %high, align 4, !dbg !1009
  %cmp = icmp eq i32 %2, 0, !dbg !1010
  br i1 %cmp, label %if.then, label %if.end23, !dbg !1011

if.then:                                          ; preds = %entry
  %s2 = bitcast %union.dwords* %d to %struct.anon*, !dbg !1012
  %high3 = getelementptr inbounds %struct.anon, %struct.anon* %s2, i32 0, i32 1, !dbg !1013
  %3 = load i32, i32* %high3, align 4, !dbg !1013
  %cmp4 = icmp eq i32 %3, 0, !dbg !1014
  br i1 %cmp4, label %if.then5, label %if.end16, !dbg !1015

if.then5:                                         ; preds = %if.then
  %4 = load i64*, i64** %rem.addr, align 4, !dbg !1016
  %tobool = icmp ne i64* %4, null, !dbg !1016
  br i1 %tobool, label %if.then6, label %if.end, !dbg !1016

if.then6:                                         ; preds = %if.then5
  %s7 = bitcast %union.dwords* %n to %struct.anon*, !dbg !1017
  %low = getelementptr inbounds %struct.anon, %struct.anon* %s7, i32 0, i32 0, !dbg !1018
  %5 = load i32, i32* %low, align 8, !dbg !1018
  %s8 = bitcast %union.dwords* %d to %struct.anon*, !dbg !1019
  %low9 = getelementptr inbounds %struct.anon, %struct.anon* %s8, i32 0, i32 0, !dbg !1020
  %6 = load i32, i32* %low9, align 8, !dbg !1020
  %rem10 = urem i32 %5, %6, !dbg !1021
  %conv = zext i32 %rem10 to i64, !dbg !1022
  %7 = load i64*, i64** %rem.addr, align 4, !dbg !1023
  store i64 %conv, i64* %7, align 8, !dbg !1024
  br label %if.end, !dbg !1025

if.end:                                           ; preds = %if.then6, %if.then5
  %s11 = bitcast %union.dwords* %n to %struct.anon*, !dbg !1026
  %low12 = getelementptr inbounds %struct.anon, %struct.anon* %s11, i32 0, i32 0, !dbg !1027
  %8 = load i32, i32* %low12, align 8, !dbg !1027
  %s13 = bitcast %union.dwords* %d to %struct.anon*, !dbg !1028
  %low14 = getelementptr inbounds %struct.anon, %struct.anon* %s13, i32 0, i32 0, !dbg !1029
  %9 = load i32, i32* %low14, align 8, !dbg !1029
  %div = udiv i32 %8, %9, !dbg !1030
  %conv15 = zext i32 %div to i64, !dbg !1031
  store i64 %conv15, i64* %retval, align 8, !dbg !1032
  br label %return, !dbg !1032

if.end16:                                         ; preds = %if.then
  %10 = load i64*, i64** %rem.addr, align 4, !dbg !1033
  %tobool17 = icmp ne i64* %10, null, !dbg !1033
  br i1 %tobool17, label %if.then18, label %if.end22, !dbg !1033

if.then18:                                        ; preds = %if.end16
  %s19 = bitcast %union.dwords* %n to %struct.anon*, !dbg !1034
  %low20 = getelementptr inbounds %struct.anon, %struct.anon* %s19, i32 0, i32 0, !dbg !1035
  %11 = load i32, i32* %low20, align 8, !dbg !1035
  %conv21 = zext i32 %11 to i64, !dbg !1036
  %12 = load i64*, i64** %rem.addr, align 4, !dbg !1037
  store i64 %conv21, i64* %12, align 8, !dbg !1038
  br label %if.end22, !dbg !1039

if.end22:                                         ; preds = %if.then18, %if.end16
  store i64 0, i64* %retval, align 8, !dbg !1040
  br label %return, !dbg !1040

if.end23:                                         ; preds = %entry
  %s24 = bitcast %union.dwords* %d to %struct.anon*, !dbg !1041
  %low25 = getelementptr inbounds %struct.anon, %struct.anon* %s24, i32 0, i32 0, !dbg !1042
  %13 = load i32, i32* %low25, align 8, !dbg !1042
  %cmp26 = icmp eq i32 %13, 0, !dbg !1043
  br i1 %cmp26, label %if.then28, label %if.else, !dbg !1044

if.then28:                                        ; preds = %if.end23
  %s29 = bitcast %union.dwords* %d to %struct.anon*, !dbg !1045
  %high30 = getelementptr inbounds %struct.anon, %struct.anon* %s29, i32 0, i32 1, !dbg !1046
  %14 = load i32, i32* %high30, align 4, !dbg !1046
  %cmp31 = icmp eq i32 %14, 0, !dbg !1047
  br i1 %cmp31, label %if.then33, label %if.end49, !dbg !1048

if.then33:                                        ; preds = %if.then28
  %15 = load i64*, i64** %rem.addr, align 4, !dbg !1049
  %tobool34 = icmp ne i64* %15, null, !dbg !1049
  br i1 %tobool34, label %if.then35, label %if.end42, !dbg !1049

if.then35:                                        ; preds = %if.then33
  %s36 = bitcast %union.dwords* %n to %struct.anon*, !dbg !1050
  %high37 = getelementptr inbounds %struct.anon, %struct.anon* %s36, i32 0, i32 1, !dbg !1051
  %16 = load i32, i32* %high37, align 4, !dbg !1051
  %s38 = bitcast %union.dwords* %d to %struct.anon*, !dbg !1052
  %low39 = getelementptr inbounds %struct.anon, %struct.anon* %s38, i32 0, i32 0, !dbg !1053
  %17 = load i32, i32* %low39, align 8, !dbg !1053
  %rem40 = urem i32 %16, %17, !dbg !1054
  %conv41 = zext i32 %rem40 to i64, !dbg !1055
  %18 = load i64*, i64** %rem.addr, align 4, !dbg !1056
  store i64 %conv41, i64* %18, align 8, !dbg !1057
  br label %if.end42, !dbg !1058

if.end42:                                         ; preds = %if.then35, %if.then33
  %s43 = bitcast %union.dwords* %n to %struct.anon*, !dbg !1059
  %high44 = getelementptr inbounds %struct.anon, %struct.anon* %s43, i32 0, i32 1, !dbg !1060
  %19 = load i32, i32* %high44, align 4, !dbg !1060
  %s45 = bitcast %union.dwords* %d to %struct.anon*, !dbg !1061
  %low46 = getelementptr inbounds %struct.anon, %struct.anon* %s45, i32 0, i32 0, !dbg !1062
  %20 = load i32, i32* %low46, align 8, !dbg !1062
  %div47 = udiv i32 %19, %20, !dbg !1063
  %conv48 = zext i32 %div47 to i64, !dbg !1064
  store i64 %conv48, i64* %retval, align 8, !dbg !1065
  br label %return, !dbg !1065

if.end49:                                         ; preds = %if.then28
  %s50 = bitcast %union.dwords* %n to %struct.anon*, !dbg !1066
  %low51 = getelementptr inbounds %struct.anon, %struct.anon* %s50, i32 0, i32 0, !dbg !1067
  %21 = load i32, i32* %low51, align 8, !dbg !1067
  %cmp52 = icmp eq i32 %21, 0, !dbg !1068
  br i1 %cmp52, label %if.then54, label %if.end74, !dbg !1069

if.then54:                                        ; preds = %if.end49
  %22 = load i64*, i64** %rem.addr, align 4, !dbg !1070
  %tobool55 = icmp ne i64* %22, null, !dbg !1070
  br i1 %tobool55, label %if.then56, label %if.end67, !dbg !1070

if.then56:                                        ; preds = %if.then54
  %s57 = bitcast %union.dwords* %n to %struct.anon*, !dbg !1071
  %high58 = getelementptr inbounds %struct.anon, %struct.anon* %s57, i32 0, i32 1, !dbg !1072
  %23 = load i32, i32* %high58, align 4, !dbg !1072
  %s59 = bitcast %union.dwords* %d to %struct.anon*, !dbg !1073
  %high60 = getelementptr inbounds %struct.anon, %struct.anon* %s59, i32 0, i32 1, !dbg !1074
  %24 = load i32, i32* %high60, align 4, !dbg !1074
  %rem61 = urem i32 %23, %24, !dbg !1075
  %s62 = bitcast %union.dwords* %r to %struct.anon*, !dbg !1076
  %high63 = getelementptr inbounds %struct.anon, %struct.anon* %s62, i32 0, i32 1, !dbg !1077
  store i32 %rem61, i32* %high63, align 4, !dbg !1078
  %s64 = bitcast %union.dwords* %r to %struct.anon*, !dbg !1079
  %low65 = getelementptr inbounds %struct.anon, %struct.anon* %s64, i32 0, i32 0, !dbg !1080
  store i32 0, i32* %low65, align 8, !dbg !1081
  %all66 = bitcast %union.dwords* %r to i64*, !dbg !1082
  %25 = load i64, i64* %all66, align 8, !dbg !1082
  %26 = load i64*, i64** %rem.addr, align 4, !dbg !1083
  store i64 %25, i64* %26, align 8, !dbg !1084
  br label %if.end67, !dbg !1085

if.end67:                                         ; preds = %if.then56, %if.then54
  %s68 = bitcast %union.dwords* %n to %struct.anon*, !dbg !1086
  %high69 = getelementptr inbounds %struct.anon, %struct.anon* %s68, i32 0, i32 1, !dbg !1087
  %27 = load i32, i32* %high69, align 4, !dbg !1087
  %s70 = bitcast %union.dwords* %d to %struct.anon*, !dbg !1088
  %high71 = getelementptr inbounds %struct.anon, %struct.anon* %s70, i32 0, i32 1, !dbg !1089
  %28 = load i32, i32* %high71, align 4, !dbg !1089
  %div72 = udiv i32 %27, %28, !dbg !1090
  %conv73 = zext i32 %div72 to i64, !dbg !1091
  store i64 %conv73, i64* %retval, align 8, !dbg !1092
  br label %return, !dbg !1092

if.end74:                                         ; preds = %if.end49
  %s75 = bitcast %union.dwords* %d to %struct.anon*, !dbg !1093
  %high76 = getelementptr inbounds %struct.anon, %struct.anon* %s75, i32 0, i32 1, !dbg !1094
  %29 = load i32, i32* %high76, align 4, !dbg !1094
  %s77 = bitcast %union.dwords* %d to %struct.anon*, !dbg !1095
  %high78 = getelementptr inbounds %struct.anon, %struct.anon* %s77, i32 0, i32 1, !dbg !1096
  %30 = load i32, i32* %high78, align 4, !dbg !1096
  %sub = sub i32 %30, 1, !dbg !1097
  %and = and i32 %29, %sub, !dbg !1098
  %cmp79 = icmp eq i32 %and, 0, !dbg !1099
  br i1 %cmp79, label %if.then81, label %if.end103, !dbg !1100

if.then81:                                        ; preds = %if.end74
  %31 = load i64*, i64** %rem.addr, align 4, !dbg !1101
  %tobool82 = icmp ne i64* %31, null, !dbg !1101
  br i1 %tobool82, label %if.then83, label %if.end97, !dbg !1101

if.then83:                                        ; preds = %if.then81
  %s84 = bitcast %union.dwords* %n to %struct.anon*, !dbg !1102
  %low85 = getelementptr inbounds %struct.anon, %struct.anon* %s84, i32 0, i32 0, !dbg !1103
  %32 = load i32, i32* %low85, align 8, !dbg !1103
  %s86 = bitcast %union.dwords* %r to %struct.anon*, !dbg !1104
  %low87 = getelementptr inbounds %struct.anon, %struct.anon* %s86, i32 0, i32 0, !dbg !1105
  store i32 %32, i32* %low87, align 8, !dbg !1106
  %s88 = bitcast %union.dwords* %n to %struct.anon*, !dbg !1107
  %high89 = getelementptr inbounds %struct.anon, %struct.anon* %s88, i32 0, i32 1, !dbg !1108
  %33 = load i32, i32* %high89, align 4, !dbg !1108
  %s90 = bitcast %union.dwords* %d to %struct.anon*, !dbg !1109
  %high91 = getelementptr inbounds %struct.anon, %struct.anon* %s90, i32 0, i32 1, !dbg !1110
  %34 = load i32, i32* %high91, align 4, !dbg !1110
  %sub92 = sub i32 %34, 1, !dbg !1111
  %and93 = and i32 %33, %sub92, !dbg !1112
  %s94 = bitcast %union.dwords* %r to %struct.anon*, !dbg !1113
  %high95 = getelementptr inbounds %struct.anon, %struct.anon* %s94, i32 0, i32 1, !dbg !1114
  store i32 %and93, i32* %high95, align 4, !dbg !1115
  %all96 = bitcast %union.dwords* %r to i64*, !dbg !1116
  %35 = load i64, i64* %all96, align 8, !dbg !1116
  %36 = load i64*, i64** %rem.addr, align 4, !dbg !1117
  store i64 %35, i64* %36, align 8, !dbg !1118
  br label %if.end97, !dbg !1119

if.end97:                                         ; preds = %if.then83, %if.then81
  %s98 = bitcast %union.dwords* %n to %struct.anon*, !dbg !1120
  %high99 = getelementptr inbounds %struct.anon, %struct.anon* %s98, i32 0, i32 1, !dbg !1121
  %37 = load i32, i32* %high99, align 4, !dbg !1121
  %s100 = bitcast %union.dwords* %d to %struct.anon*, !dbg !1122
  %high101 = getelementptr inbounds %struct.anon, %struct.anon* %s100, i32 0, i32 1, !dbg !1123
  %38 = load i32, i32* %high101, align 4, !dbg !1123
  %39 = call i32 @llvm.cttz.i32(i32 %38, i1 true), !dbg !1124
  %shr = lshr i32 %37, %39, !dbg !1125
  %conv102 = zext i32 %shr to i64, !dbg !1126
  store i64 %conv102, i64* %retval, align 8, !dbg !1127
  br label %return, !dbg !1127

if.end103:                                        ; preds = %if.end74
  %s104 = bitcast %union.dwords* %d to %struct.anon*, !dbg !1128
  %high105 = getelementptr inbounds %struct.anon, %struct.anon* %s104, i32 0, i32 1, !dbg !1129
  %40 = load i32, i32* %high105, align 4, !dbg !1129
  %41 = call i32 @llvm.ctlz.i32(i32 %40, i1 true), !dbg !1130
  %s106 = bitcast %union.dwords* %n to %struct.anon*, !dbg !1131
  %high107 = getelementptr inbounds %struct.anon, %struct.anon* %s106, i32 0, i32 1, !dbg !1132
  %42 = load i32, i32* %high107, align 4, !dbg !1132
  %43 = call i32 @llvm.ctlz.i32(i32 %42, i1 true), !dbg !1133
  %sub108 = sub nsw i32 %41, %43, !dbg !1134
  store i32 %sub108, i32* %sr, align 4, !dbg !1135
  %44 = load i32, i32* %sr, align 4, !dbg !1136
  %cmp109 = icmp ugt i32 %44, 30, !dbg !1137
  br i1 %cmp109, label %if.then111, label %if.end116, !dbg !1136

if.then111:                                       ; preds = %if.end103
  %45 = load i64*, i64** %rem.addr, align 4, !dbg !1138
  %tobool112 = icmp ne i64* %45, null, !dbg !1138
  br i1 %tobool112, label %if.then113, label %if.end115, !dbg !1138

if.then113:                                       ; preds = %if.then111
  %all114 = bitcast %union.dwords* %n to i64*, !dbg !1139
  %46 = load i64, i64* %all114, align 8, !dbg !1139
  %47 = load i64*, i64** %rem.addr, align 4, !dbg !1140
  store i64 %46, i64* %47, align 8, !dbg !1141
  br label %if.end115, !dbg !1142

if.end115:                                        ; preds = %if.then113, %if.then111
  store i64 0, i64* %retval, align 8, !dbg !1143
  br label %return, !dbg !1143

if.end116:                                        ; preds = %if.end103
  %48 = load i32, i32* %sr, align 4, !dbg !1144
  %inc = add i32 %48, 1, !dbg !1144
  store i32 %inc, i32* %sr, align 4, !dbg !1144
  %s117 = bitcast %union.dwords* %q to %struct.anon*, !dbg !1145
  %low118 = getelementptr inbounds %struct.anon, %struct.anon* %s117, i32 0, i32 0, !dbg !1146
  store i32 0, i32* %low118, align 8, !dbg !1147
  %s119 = bitcast %union.dwords* %n to %struct.anon*, !dbg !1148
  %low120 = getelementptr inbounds %struct.anon, %struct.anon* %s119, i32 0, i32 0, !dbg !1149
  %49 = load i32, i32* %low120, align 8, !dbg !1149
  %50 = load i32, i32* %sr, align 4, !dbg !1150
  %sub121 = sub i32 32, %50, !dbg !1151
  %shl = shl i32 %49, %sub121, !dbg !1152
  %s122 = bitcast %union.dwords* %q to %struct.anon*, !dbg !1153
  %high123 = getelementptr inbounds %struct.anon, %struct.anon* %s122, i32 0, i32 1, !dbg !1154
  store i32 %shl, i32* %high123, align 4, !dbg !1155
  %s124 = bitcast %union.dwords* %n to %struct.anon*, !dbg !1156
  %high125 = getelementptr inbounds %struct.anon, %struct.anon* %s124, i32 0, i32 1, !dbg !1157
  %51 = load i32, i32* %high125, align 4, !dbg !1157
  %52 = load i32, i32* %sr, align 4, !dbg !1158
  %shr126 = lshr i32 %51, %52, !dbg !1159
  %s127 = bitcast %union.dwords* %r to %struct.anon*, !dbg !1160
  %high128 = getelementptr inbounds %struct.anon, %struct.anon* %s127, i32 0, i32 1, !dbg !1161
  store i32 %shr126, i32* %high128, align 4, !dbg !1162
  %s129 = bitcast %union.dwords* %n to %struct.anon*, !dbg !1163
  %high130 = getelementptr inbounds %struct.anon, %struct.anon* %s129, i32 0, i32 1, !dbg !1164
  %53 = load i32, i32* %high130, align 4, !dbg !1164
  %54 = load i32, i32* %sr, align 4, !dbg !1165
  %sub131 = sub i32 32, %54, !dbg !1166
  %shl132 = shl i32 %53, %sub131, !dbg !1167
  %s133 = bitcast %union.dwords* %n to %struct.anon*, !dbg !1168
  %low134 = getelementptr inbounds %struct.anon, %struct.anon* %s133, i32 0, i32 0, !dbg !1169
  %55 = load i32, i32* %low134, align 8, !dbg !1169
  %56 = load i32, i32* %sr, align 4, !dbg !1170
  %shr135 = lshr i32 %55, %56, !dbg !1171
  %or = or i32 %shl132, %shr135, !dbg !1172
  %s136 = bitcast %union.dwords* %r to %struct.anon*, !dbg !1173
  %low137 = getelementptr inbounds %struct.anon, %struct.anon* %s136, i32 0, i32 0, !dbg !1174
  store i32 %or, i32* %low137, align 8, !dbg !1175
  br label %if.end317, !dbg !1176

if.else:                                          ; preds = %if.end23
  %s138 = bitcast %union.dwords* %d to %struct.anon*, !dbg !1177
  %high139 = getelementptr inbounds %struct.anon, %struct.anon* %s138, i32 0, i32 1, !dbg !1178
  %57 = load i32, i32* %high139, align 4, !dbg !1178
  %cmp140 = icmp eq i32 %57, 0, !dbg !1179
  br i1 %cmp140, label %if.then142, label %if.else263, !dbg !1180

if.then142:                                       ; preds = %if.else
  %s143 = bitcast %union.dwords* %d to %struct.anon*, !dbg !1181
  %low144 = getelementptr inbounds %struct.anon, %struct.anon* %s143, i32 0, i32 0, !dbg !1182
  %58 = load i32, i32* %low144, align 8, !dbg !1182
  %s145 = bitcast %union.dwords* %d to %struct.anon*, !dbg !1183
  %low146 = getelementptr inbounds %struct.anon, %struct.anon* %s145, i32 0, i32 0, !dbg !1184
  %59 = load i32, i32* %low146, align 8, !dbg !1184
  %sub147 = sub i32 %59, 1, !dbg !1185
  %and148 = and i32 %58, %sub147, !dbg !1186
  %cmp149 = icmp eq i32 %and148, 0, !dbg !1187
  br i1 %cmp149, label %if.then151, label %if.end187, !dbg !1188

if.then151:                                       ; preds = %if.then142
  %60 = load i64*, i64** %rem.addr, align 4, !dbg !1189
  %tobool152 = icmp ne i64* %60, null, !dbg !1189
  br i1 %tobool152, label %if.then153, label %if.end161, !dbg !1189

if.then153:                                       ; preds = %if.then151
  %s154 = bitcast %union.dwords* %n to %struct.anon*, !dbg !1190
  %low155 = getelementptr inbounds %struct.anon, %struct.anon* %s154, i32 0, i32 0, !dbg !1191
  %61 = load i32, i32* %low155, align 8, !dbg !1191
  %s156 = bitcast %union.dwords* %d to %struct.anon*, !dbg !1192
  %low157 = getelementptr inbounds %struct.anon, %struct.anon* %s156, i32 0, i32 0, !dbg !1193
  %62 = load i32, i32* %low157, align 8, !dbg !1193
  %sub158 = sub i32 %62, 1, !dbg !1194
  %and159 = and i32 %61, %sub158, !dbg !1195
  %conv160 = zext i32 %and159 to i64, !dbg !1196
  %63 = load i64*, i64** %rem.addr, align 4, !dbg !1197
  store i64 %conv160, i64* %63, align 8, !dbg !1198
  br label %if.end161, !dbg !1199

if.end161:                                        ; preds = %if.then153, %if.then151
  %s162 = bitcast %union.dwords* %d to %struct.anon*, !dbg !1200
  %low163 = getelementptr inbounds %struct.anon, %struct.anon* %s162, i32 0, i32 0, !dbg !1201
  %64 = load i32, i32* %low163, align 8, !dbg !1201
  %cmp164 = icmp eq i32 %64, 1, !dbg !1202
  br i1 %cmp164, label %if.then166, label %if.end168, !dbg !1203

if.then166:                                       ; preds = %if.end161
  %all167 = bitcast %union.dwords* %n to i64*, !dbg !1204
  %65 = load i64, i64* %all167, align 8, !dbg !1204
  store i64 %65, i64* %retval, align 8, !dbg !1205
  br label %return, !dbg !1205

if.end168:                                        ; preds = %if.end161
  %s169 = bitcast %union.dwords* %d to %struct.anon*, !dbg !1206
  %low170 = getelementptr inbounds %struct.anon, %struct.anon* %s169, i32 0, i32 0, !dbg !1207
  %66 = load i32, i32* %low170, align 8, !dbg !1207
  %67 = call i32 @llvm.cttz.i32(i32 %66, i1 true), !dbg !1208
  store i32 %67, i32* %sr, align 4, !dbg !1209
  %s171 = bitcast %union.dwords* %n to %struct.anon*, !dbg !1210
  %high172 = getelementptr inbounds %struct.anon, %struct.anon* %s171, i32 0, i32 1, !dbg !1211
  %68 = load i32, i32* %high172, align 4, !dbg !1211
  %69 = load i32, i32* %sr, align 4, !dbg !1212
  %shr173 = lshr i32 %68, %69, !dbg !1213
  %s174 = bitcast %union.dwords* %q to %struct.anon*, !dbg !1214
  %high175 = getelementptr inbounds %struct.anon, %struct.anon* %s174, i32 0, i32 1, !dbg !1215
  store i32 %shr173, i32* %high175, align 4, !dbg !1216
  %s176 = bitcast %union.dwords* %n to %struct.anon*, !dbg !1217
  %high177 = getelementptr inbounds %struct.anon, %struct.anon* %s176, i32 0, i32 1, !dbg !1218
  %70 = load i32, i32* %high177, align 4, !dbg !1218
  %71 = load i32, i32* %sr, align 4, !dbg !1219
  %sub178 = sub i32 32, %71, !dbg !1220
  %shl179 = shl i32 %70, %sub178, !dbg !1221
  %s180 = bitcast %union.dwords* %n to %struct.anon*, !dbg !1222
  %low181 = getelementptr inbounds %struct.anon, %struct.anon* %s180, i32 0, i32 0, !dbg !1223
  %72 = load i32, i32* %low181, align 8, !dbg !1223
  %73 = load i32, i32* %sr, align 4, !dbg !1224
  %shr182 = lshr i32 %72, %73, !dbg !1225
  %or183 = or i32 %shl179, %shr182, !dbg !1226
  %s184 = bitcast %union.dwords* %q to %struct.anon*, !dbg !1227
  %low185 = getelementptr inbounds %struct.anon, %struct.anon* %s184, i32 0, i32 0, !dbg !1228
  store i32 %or183, i32* %low185, align 8, !dbg !1229
  %all186 = bitcast %union.dwords* %q to i64*, !dbg !1230
  %74 = load i64, i64* %all186, align 8, !dbg !1230
  store i64 %74, i64* %retval, align 8, !dbg !1231
  br label %return, !dbg !1231

if.end187:                                        ; preds = %if.then142
  %s188 = bitcast %union.dwords* %d to %struct.anon*, !dbg !1232
  %low189 = getelementptr inbounds %struct.anon, %struct.anon* %s188, i32 0, i32 0, !dbg !1233
  %75 = load i32, i32* %low189, align 8, !dbg !1233
  %76 = call i32 @llvm.ctlz.i32(i32 %75, i1 true), !dbg !1234
  %add = add i32 33, %76, !dbg !1235
  %s190 = bitcast %union.dwords* %n to %struct.anon*, !dbg !1236
  %high191 = getelementptr inbounds %struct.anon, %struct.anon* %s190, i32 0, i32 1, !dbg !1237
  %77 = load i32, i32* %high191, align 4, !dbg !1237
  %78 = call i32 @llvm.ctlz.i32(i32 %77, i1 true), !dbg !1238
  %sub192 = sub i32 %add, %78, !dbg !1239
  store i32 %sub192, i32* %sr, align 4, !dbg !1240
  %79 = load i32, i32* %sr, align 4, !dbg !1241
  %cmp193 = icmp eq i32 %79, 32, !dbg !1242
  br i1 %cmp193, label %if.then195, label %if.else208, !dbg !1241

if.then195:                                       ; preds = %if.end187
  %s196 = bitcast %union.dwords* %q to %struct.anon*, !dbg !1243
  %low197 = getelementptr inbounds %struct.anon, %struct.anon* %s196, i32 0, i32 0, !dbg !1244
  store i32 0, i32* %low197, align 8, !dbg !1245
  %s198 = bitcast %union.dwords* %n to %struct.anon*, !dbg !1246
  %low199 = getelementptr inbounds %struct.anon, %struct.anon* %s198, i32 0, i32 0, !dbg !1247
  %80 = load i32, i32* %low199, align 8, !dbg !1247
  %s200 = bitcast %union.dwords* %q to %struct.anon*, !dbg !1248
  %high201 = getelementptr inbounds %struct.anon, %struct.anon* %s200, i32 0, i32 1, !dbg !1249
  store i32 %80, i32* %high201, align 4, !dbg !1250
  %s202 = bitcast %union.dwords* %r to %struct.anon*, !dbg !1251
  %high203 = getelementptr inbounds %struct.anon, %struct.anon* %s202, i32 0, i32 1, !dbg !1252
  store i32 0, i32* %high203, align 4, !dbg !1253
  %s204 = bitcast %union.dwords* %n to %struct.anon*, !dbg !1254
  %high205 = getelementptr inbounds %struct.anon, %struct.anon* %s204, i32 0, i32 1, !dbg !1255
  %81 = load i32, i32* %high205, align 4, !dbg !1255
  %s206 = bitcast %union.dwords* %r to %struct.anon*, !dbg !1256
  %low207 = getelementptr inbounds %struct.anon, %struct.anon* %s206, i32 0, i32 0, !dbg !1257
  store i32 %81, i32* %low207, align 8, !dbg !1258
  br label %if.end262, !dbg !1259

if.else208:                                       ; preds = %if.end187
  %82 = load i32, i32* %sr, align 4, !dbg !1260
  %cmp209 = icmp ult i32 %82, 32, !dbg !1261
  br i1 %cmp209, label %if.then211, label %if.else235, !dbg !1260

if.then211:                                       ; preds = %if.else208
  %s212 = bitcast %union.dwords* %q to %struct.anon*, !dbg !1262
  %low213 = getelementptr inbounds %struct.anon, %struct.anon* %s212, i32 0, i32 0, !dbg !1263
  store i32 0, i32* %low213, align 8, !dbg !1264
  %s214 = bitcast %union.dwords* %n to %struct.anon*, !dbg !1265
  %low215 = getelementptr inbounds %struct.anon, %struct.anon* %s214, i32 0, i32 0, !dbg !1266
  %83 = load i32, i32* %low215, align 8, !dbg !1266
  %84 = load i32, i32* %sr, align 4, !dbg !1267
  %sub216 = sub i32 32, %84, !dbg !1268
  %shl217 = shl i32 %83, %sub216, !dbg !1269
  %s218 = bitcast %union.dwords* %q to %struct.anon*, !dbg !1270
  %high219 = getelementptr inbounds %struct.anon, %struct.anon* %s218, i32 0, i32 1, !dbg !1271
  store i32 %shl217, i32* %high219, align 4, !dbg !1272
  %s220 = bitcast %union.dwords* %n to %struct.anon*, !dbg !1273
  %high221 = getelementptr inbounds %struct.anon, %struct.anon* %s220, i32 0, i32 1, !dbg !1274
  %85 = load i32, i32* %high221, align 4, !dbg !1274
  %86 = load i32, i32* %sr, align 4, !dbg !1275
  %shr222 = lshr i32 %85, %86, !dbg !1276
  %s223 = bitcast %union.dwords* %r to %struct.anon*, !dbg !1277
  %high224 = getelementptr inbounds %struct.anon, %struct.anon* %s223, i32 0, i32 1, !dbg !1278
  store i32 %shr222, i32* %high224, align 4, !dbg !1279
  %s225 = bitcast %union.dwords* %n to %struct.anon*, !dbg !1280
  %high226 = getelementptr inbounds %struct.anon, %struct.anon* %s225, i32 0, i32 1, !dbg !1281
  %87 = load i32, i32* %high226, align 4, !dbg !1281
  %88 = load i32, i32* %sr, align 4, !dbg !1282
  %sub227 = sub i32 32, %88, !dbg !1283
  %shl228 = shl i32 %87, %sub227, !dbg !1284
  %s229 = bitcast %union.dwords* %n to %struct.anon*, !dbg !1285
  %low230 = getelementptr inbounds %struct.anon, %struct.anon* %s229, i32 0, i32 0, !dbg !1286
  %89 = load i32, i32* %low230, align 8, !dbg !1286
  %90 = load i32, i32* %sr, align 4, !dbg !1287
  %shr231 = lshr i32 %89, %90, !dbg !1288
  %or232 = or i32 %shl228, %shr231, !dbg !1289
  %s233 = bitcast %union.dwords* %r to %struct.anon*, !dbg !1290
  %low234 = getelementptr inbounds %struct.anon, %struct.anon* %s233, i32 0, i32 0, !dbg !1291
  store i32 %or232, i32* %low234, align 8, !dbg !1292
  br label %if.end261, !dbg !1293

if.else235:                                       ; preds = %if.else208
  %s236 = bitcast %union.dwords* %n to %struct.anon*, !dbg !1294
  %low237 = getelementptr inbounds %struct.anon, %struct.anon* %s236, i32 0, i32 0, !dbg !1295
  %91 = load i32, i32* %low237, align 8, !dbg !1295
  %92 = load i32, i32* %sr, align 4, !dbg !1296
  %sub238 = sub i32 64, %92, !dbg !1297
  %shl239 = shl i32 %91, %sub238, !dbg !1298
  %s240 = bitcast %union.dwords* %q to %struct.anon*, !dbg !1299
  %low241 = getelementptr inbounds %struct.anon, %struct.anon* %s240, i32 0, i32 0, !dbg !1300
  store i32 %shl239, i32* %low241, align 8, !dbg !1301
  %s242 = bitcast %union.dwords* %n to %struct.anon*, !dbg !1302
  %high243 = getelementptr inbounds %struct.anon, %struct.anon* %s242, i32 0, i32 1, !dbg !1303
  %93 = load i32, i32* %high243, align 4, !dbg !1303
  %94 = load i32, i32* %sr, align 4, !dbg !1304
  %sub244 = sub i32 64, %94, !dbg !1305
  %shl245 = shl i32 %93, %sub244, !dbg !1306
  %s246 = bitcast %union.dwords* %n to %struct.anon*, !dbg !1307
  %low247 = getelementptr inbounds %struct.anon, %struct.anon* %s246, i32 0, i32 0, !dbg !1308
  %95 = load i32, i32* %low247, align 8, !dbg !1308
  %96 = load i32, i32* %sr, align 4, !dbg !1309
  %sub248 = sub i32 %96, 32, !dbg !1310
  %shr249 = lshr i32 %95, %sub248, !dbg !1311
  %or250 = or i32 %shl245, %shr249, !dbg !1312
  %s251 = bitcast %union.dwords* %q to %struct.anon*, !dbg !1313
  %high252 = getelementptr inbounds %struct.anon, %struct.anon* %s251, i32 0, i32 1, !dbg !1314
  store i32 %or250, i32* %high252, align 4, !dbg !1315
  %s253 = bitcast %union.dwords* %r to %struct.anon*, !dbg !1316
  %high254 = getelementptr inbounds %struct.anon, %struct.anon* %s253, i32 0, i32 1, !dbg !1317
  store i32 0, i32* %high254, align 4, !dbg !1318
  %s255 = bitcast %union.dwords* %n to %struct.anon*, !dbg !1319
  %high256 = getelementptr inbounds %struct.anon, %struct.anon* %s255, i32 0, i32 1, !dbg !1320
  %97 = load i32, i32* %high256, align 4, !dbg !1320
  %98 = load i32, i32* %sr, align 4, !dbg !1321
  %sub257 = sub i32 %98, 32, !dbg !1322
  %shr258 = lshr i32 %97, %sub257, !dbg !1323
  %s259 = bitcast %union.dwords* %r to %struct.anon*, !dbg !1324
  %low260 = getelementptr inbounds %struct.anon, %struct.anon* %s259, i32 0, i32 0, !dbg !1325
  store i32 %shr258, i32* %low260, align 8, !dbg !1326
  br label %if.end261

if.end261:                                        ; preds = %if.else235, %if.then211
  br label %if.end262

if.end262:                                        ; preds = %if.end261, %if.then195
  br label %if.end316, !dbg !1327

if.else263:                                       ; preds = %if.else
  %s264 = bitcast %union.dwords* %d to %struct.anon*, !dbg !1328
  %high265 = getelementptr inbounds %struct.anon, %struct.anon* %s264, i32 0, i32 1, !dbg !1329
  %99 = load i32, i32* %high265, align 4, !dbg !1329
  %100 = call i32 @llvm.ctlz.i32(i32 %99, i1 true), !dbg !1330
  %s266 = bitcast %union.dwords* %n to %struct.anon*, !dbg !1331
  %high267 = getelementptr inbounds %struct.anon, %struct.anon* %s266, i32 0, i32 1, !dbg !1332
  %101 = load i32, i32* %high267, align 4, !dbg !1332
  %102 = call i32 @llvm.ctlz.i32(i32 %101, i1 true), !dbg !1333
  %sub268 = sub nsw i32 %100, %102, !dbg !1334
  store i32 %sub268, i32* %sr, align 4, !dbg !1335
  %103 = load i32, i32* %sr, align 4, !dbg !1336
  %cmp269 = icmp ugt i32 %103, 31, !dbg !1337
  br i1 %cmp269, label %if.then271, label %if.end276, !dbg !1336

if.then271:                                       ; preds = %if.else263
  %104 = load i64*, i64** %rem.addr, align 4, !dbg !1338
  %tobool272 = icmp ne i64* %104, null, !dbg !1338
  br i1 %tobool272, label %if.then273, label %if.end275, !dbg !1338

if.then273:                                       ; preds = %if.then271
  %all274 = bitcast %union.dwords* %n to i64*, !dbg !1339
  %105 = load i64, i64* %all274, align 8, !dbg !1339
  %106 = load i64*, i64** %rem.addr, align 4, !dbg !1340
  store i64 %105, i64* %106, align 8, !dbg !1341
  br label %if.end275, !dbg !1342

if.end275:                                        ; preds = %if.then273, %if.then271
  store i64 0, i64* %retval, align 8, !dbg !1343
  br label %return, !dbg !1343

if.end276:                                        ; preds = %if.else263
  %107 = load i32, i32* %sr, align 4, !dbg !1344
  %inc277 = add i32 %107, 1, !dbg !1344
  store i32 %inc277, i32* %sr, align 4, !dbg !1344
  %s278 = bitcast %union.dwords* %q to %struct.anon*, !dbg !1345
  %low279 = getelementptr inbounds %struct.anon, %struct.anon* %s278, i32 0, i32 0, !dbg !1346
  store i32 0, i32* %low279, align 8, !dbg !1347
  %108 = load i32, i32* %sr, align 4, !dbg !1348
  %cmp280 = icmp eq i32 %108, 32, !dbg !1349
  br i1 %cmp280, label %if.then282, label %if.else293, !dbg !1348

if.then282:                                       ; preds = %if.end276
  %s283 = bitcast %union.dwords* %n to %struct.anon*, !dbg !1350
  %low284 = getelementptr inbounds %struct.anon, %struct.anon* %s283, i32 0, i32 0, !dbg !1351
  %109 = load i32, i32* %low284, align 8, !dbg !1351
  %s285 = bitcast %union.dwords* %q to %struct.anon*, !dbg !1352
  %high286 = getelementptr inbounds %struct.anon, %struct.anon* %s285, i32 0, i32 1, !dbg !1353
  store i32 %109, i32* %high286, align 4, !dbg !1354
  %s287 = bitcast %union.dwords* %r to %struct.anon*, !dbg !1355
  %high288 = getelementptr inbounds %struct.anon, %struct.anon* %s287, i32 0, i32 1, !dbg !1356
  store i32 0, i32* %high288, align 4, !dbg !1357
  %s289 = bitcast %union.dwords* %n to %struct.anon*, !dbg !1358
  %high290 = getelementptr inbounds %struct.anon, %struct.anon* %s289, i32 0, i32 1, !dbg !1359
  %110 = load i32, i32* %high290, align 4, !dbg !1359
  %s291 = bitcast %union.dwords* %r to %struct.anon*, !dbg !1360
  %low292 = getelementptr inbounds %struct.anon, %struct.anon* %s291, i32 0, i32 0, !dbg !1361
  store i32 %110, i32* %low292, align 8, !dbg !1362
  br label %if.end315, !dbg !1363

if.else293:                                       ; preds = %if.end276
  %s294 = bitcast %union.dwords* %n to %struct.anon*, !dbg !1364
  %low295 = getelementptr inbounds %struct.anon, %struct.anon* %s294, i32 0, i32 0, !dbg !1365
  %111 = load i32, i32* %low295, align 8, !dbg !1365
  %112 = load i32, i32* %sr, align 4, !dbg !1366
  %sub296 = sub i32 32, %112, !dbg !1367
  %shl297 = shl i32 %111, %sub296, !dbg !1368
  %s298 = bitcast %union.dwords* %q to %struct.anon*, !dbg !1369
  %high299 = getelementptr inbounds %struct.anon, %struct.anon* %s298, i32 0, i32 1, !dbg !1370
  store i32 %shl297, i32* %high299, align 4, !dbg !1371
  %s300 = bitcast %union.dwords* %n to %struct.anon*, !dbg !1372
  %high301 = getelementptr inbounds %struct.anon, %struct.anon* %s300, i32 0, i32 1, !dbg !1373
  %113 = load i32, i32* %high301, align 4, !dbg !1373
  %114 = load i32, i32* %sr, align 4, !dbg !1374
  %shr302 = lshr i32 %113, %114, !dbg !1375
  %s303 = bitcast %union.dwords* %r to %struct.anon*, !dbg !1376
  %high304 = getelementptr inbounds %struct.anon, %struct.anon* %s303, i32 0, i32 1, !dbg !1377
  store i32 %shr302, i32* %high304, align 4, !dbg !1378
  %s305 = bitcast %union.dwords* %n to %struct.anon*, !dbg !1379
  %high306 = getelementptr inbounds %struct.anon, %struct.anon* %s305, i32 0, i32 1, !dbg !1380
  %115 = load i32, i32* %high306, align 4, !dbg !1380
  %116 = load i32, i32* %sr, align 4, !dbg !1381
  %sub307 = sub i32 32, %116, !dbg !1382
  %shl308 = shl i32 %115, %sub307, !dbg !1383
  %s309 = bitcast %union.dwords* %n to %struct.anon*, !dbg !1384
  %low310 = getelementptr inbounds %struct.anon, %struct.anon* %s309, i32 0, i32 0, !dbg !1385
  %117 = load i32, i32* %low310, align 8, !dbg !1385
  %118 = load i32, i32* %sr, align 4, !dbg !1386
  %shr311 = lshr i32 %117, %118, !dbg !1387
  %or312 = or i32 %shl308, %shr311, !dbg !1388
  %s313 = bitcast %union.dwords* %r to %struct.anon*, !dbg !1389
  %low314 = getelementptr inbounds %struct.anon, %struct.anon* %s313, i32 0, i32 0, !dbg !1390
  store i32 %or312, i32* %low314, align 8, !dbg !1391
  br label %if.end315

if.end315:                                        ; preds = %if.else293, %if.then282
  br label %if.end316

if.end316:                                        ; preds = %if.end315, %if.end262
  br label %if.end317

if.end317:                                        ; preds = %if.end316, %if.end116
  store i32 0, i32* %carry, align 4, !dbg !1392
  br label %for.cond, !dbg !1393

for.cond:                                         ; preds = %for.inc, %if.end317
  %119 = load i32, i32* %sr, align 4, !dbg !1394
  %cmp318 = icmp ugt i32 %119, 0, !dbg !1395
  br i1 %cmp318, label %for.body, label %for.end, !dbg !1393

for.body:                                         ; preds = %for.cond
  %s320 = bitcast %union.dwords* %r to %struct.anon*, !dbg !1396
  %high321 = getelementptr inbounds %struct.anon, %struct.anon* %s320, i32 0, i32 1, !dbg !1397
  %120 = load i32, i32* %high321, align 4, !dbg !1397
  %shl322 = shl i32 %120, 1, !dbg !1398
  %s323 = bitcast %union.dwords* %r to %struct.anon*, !dbg !1399
  %low324 = getelementptr inbounds %struct.anon, %struct.anon* %s323, i32 0, i32 0, !dbg !1400
  %121 = load i32, i32* %low324, align 8, !dbg !1400
  %shr325 = lshr i32 %121, 31, !dbg !1401
  %or326 = or i32 %shl322, %shr325, !dbg !1402
  %s327 = bitcast %union.dwords* %r to %struct.anon*, !dbg !1403
  %high328 = getelementptr inbounds %struct.anon, %struct.anon* %s327, i32 0, i32 1, !dbg !1404
  store i32 %or326, i32* %high328, align 4, !dbg !1405
  %s329 = bitcast %union.dwords* %r to %struct.anon*, !dbg !1406
  %low330 = getelementptr inbounds %struct.anon, %struct.anon* %s329, i32 0, i32 0, !dbg !1407
  %122 = load i32, i32* %low330, align 8, !dbg !1407
  %shl331 = shl i32 %122, 1, !dbg !1408
  %s332 = bitcast %union.dwords* %q to %struct.anon*, !dbg !1409
  %high333 = getelementptr inbounds %struct.anon, %struct.anon* %s332, i32 0, i32 1, !dbg !1410
  %123 = load i32, i32* %high333, align 4, !dbg !1410
  %shr334 = lshr i32 %123, 31, !dbg !1411
  %or335 = or i32 %shl331, %shr334, !dbg !1412
  %s336 = bitcast %union.dwords* %r to %struct.anon*, !dbg !1413
  %low337 = getelementptr inbounds %struct.anon, %struct.anon* %s336, i32 0, i32 0, !dbg !1414
  store i32 %or335, i32* %low337, align 8, !dbg !1415
  %s338 = bitcast %union.dwords* %q to %struct.anon*, !dbg !1416
  %high339 = getelementptr inbounds %struct.anon, %struct.anon* %s338, i32 0, i32 1, !dbg !1417
  %124 = load i32, i32* %high339, align 4, !dbg !1417
  %shl340 = shl i32 %124, 1, !dbg !1418
  %s341 = bitcast %union.dwords* %q to %struct.anon*, !dbg !1419
  %low342 = getelementptr inbounds %struct.anon, %struct.anon* %s341, i32 0, i32 0, !dbg !1420
  %125 = load i32, i32* %low342, align 8, !dbg !1420
  %shr343 = lshr i32 %125, 31, !dbg !1421
  %or344 = or i32 %shl340, %shr343, !dbg !1422
  %s345 = bitcast %union.dwords* %q to %struct.anon*, !dbg !1423
  %high346 = getelementptr inbounds %struct.anon, %struct.anon* %s345, i32 0, i32 1, !dbg !1424
  store i32 %or344, i32* %high346, align 4, !dbg !1425
  %s347 = bitcast %union.dwords* %q to %struct.anon*, !dbg !1426
  %low348 = getelementptr inbounds %struct.anon, %struct.anon* %s347, i32 0, i32 0, !dbg !1427
  %126 = load i32, i32* %low348, align 8, !dbg !1427
  %shl349 = shl i32 %126, 1, !dbg !1428
  %127 = load i32, i32* %carry, align 4, !dbg !1429
  %or350 = or i32 %shl349, %127, !dbg !1430
  %s351 = bitcast %union.dwords* %q to %struct.anon*, !dbg !1431
  %low352 = getelementptr inbounds %struct.anon, %struct.anon* %s351, i32 0, i32 0, !dbg !1432
  store i32 %or350, i32* %low352, align 8, !dbg !1433
  %all354 = bitcast %union.dwords* %d to i64*, !dbg !1434
  %128 = load i64, i64* %all354, align 8, !dbg !1434
  %all355 = bitcast %union.dwords* %r to i64*, !dbg !1435
  %129 = load i64, i64* %all355, align 8, !dbg !1435
  %sub356 = sub i64 %128, %129, !dbg !1436
  %sub357 = sub i64 %sub356, 1, !dbg !1437
  %shr358 = ashr i64 %sub357, 63, !dbg !1438
  store i64 %shr358, i64* %s353, align 8, !dbg !1439
  %130 = load i64, i64* %s353, align 8, !dbg !1440
  %and359 = and i64 %130, 1, !dbg !1441
  %conv360 = trunc i64 %and359 to i32, !dbg !1440
  store i32 %conv360, i32* %carry, align 4, !dbg !1442
  %all361 = bitcast %union.dwords* %d to i64*, !dbg !1443
  %131 = load i64, i64* %all361, align 8, !dbg !1443
  %132 = load i64, i64* %s353, align 8, !dbg !1444
  %and362 = and i64 %131, %132, !dbg !1445
  %all363 = bitcast %union.dwords* %r to i64*, !dbg !1446
  %133 = load i64, i64* %all363, align 8, !dbg !1447
  %sub364 = sub i64 %133, %and362, !dbg !1447
  store i64 %sub364, i64* %all363, align 8, !dbg !1447
  br label %for.inc, !dbg !1448

for.inc:                                          ; preds = %for.body
  %134 = load i32, i32* %sr, align 4, !dbg !1449
  %dec = add i32 %134, -1, !dbg !1449
  store i32 %dec, i32* %sr, align 4, !dbg !1449
  br label %for.cond, !dbg !1393, !llvm.loop !1450

for.end:                                          ; preds = %for.cond
  %all365 = bitcast %union.dwords* %q to i64*, !dbg !1451
  %135 = load i64, i64* %all365, align 8, !dbg !1451
  %shl366 = shl i64 %135, 1, !dbg !1452
  %136 = load i32, i32* %carry, align 4, !dbg !1453
  %conv367 = zext i32 %136 to i64, !dbg !1453
  %or368 = or i64 %shl366, %conv367, !dbg !1454
  %all369 = bitcast %union.dwords* %q to i64*, !dbg !1455
  store i64 %or368, i64* %all369, align 8, !dbg !1456
  %137 = load i64*, i64** %rem.addr, align 4, !dbg !1457
  %tobool370 = icmp ne i64* %137, null, !dbg !1457
  br i1 %tobool370, label %if.then371, label %if.end373, !dbg !1457

if.then371:                                       ; preds = %for.end
  %all372 = bitcast %union.dwords* %r to i64*, !dbg !1458
  %138 = load i64, i64* %all372, align 8, !dbg !1458
  %139 = load i64*, i64** %rem.addr, align 4, !dbg !1459
  store i64 %138, i64* %139, align 8, !dbg !1460
  br label %if.end373, !dbg !1461

if.end373:                                        ; preds = %if.then371, %for.end
  %all374 = bitcast %union.dwords* %q to i64*, !dbg !1462
  %140 = load i64, i64* %all374, align 8, !dbg !1462
  store i64 %140, i64* %retval, align 8, !dbg !1463
  br label %return, !dbg !1463

return:                                           ; preds = %if.end373, %if.end275, %if.end168, %if.then166, %if.end115, %if.end97, %if.end67, %if.end42, %if.end22, %if.end
  %141 = load i64, i64* %retval, align 8, !dbg !1464
  ret i64 %141, !dbg !1464
}

; Function Attrs: noinline nounwind
define dso_local i32 @__udivmodsi4(i32 %a, i32 %b, i32* %rem) #0 !dbg !1465 {
entry:
  %a.addr = alloca i32, align 4
  %b.addr = alloca i32, align 4
  %rem.addr = alloca i32*, align 4
  %d = alloca i32, align 4
  store i32 %a, i32* %a.addr, align 4
  store i32 %b, i32* %b.addr, align 4
  store i32* %rem, i32** %rem.addr, align 4
  %0 = load i32, i32* %a.addr, align 4, !dbg !1466
  %1 = load i32, i32* %b.addr, align 4, !dbg !1467
  %call = call i32 @__udivsi3(i32 %0, i32 %1) #4, !dbg !1468
  store i32 %call, i32* %d, align 4, !dbg !1469
  %2 = load i32, i32* %a.addr, align 4, !dbg !1470
  %3 = load i32, i32* %d, align 4, !dbg !1471
  %4 = load i32, i32* %b.addr, align 4, !dbg !1472
  %mul = mul i32 %3, %4, !dbg !1473
  %sub = sub i32 %2, %mul, !dbg !1474
  %5 = load i32*, i32** %rem.addr, align 4, !dbg !1475
  store i32 %sub, i32* %5, align 4, !dbg !1476
  %6 = load i32, i32* %d, align 4, !dbg !1477
  ret i32 %6, !dbg !1478
}

; Function Attrs: noinline nounwind
define dso_local i32 @__udivsi3(i32 %n, i32 %d) #0 !dbg !1479 {
entry:
  %retval = alloca i32, align 4
  %n.addr = alloca i32, align 4
  %d.addr = alloca i32, align 4
  %n_uword_bits = alloca i32, align 4
  %q = alloca i32, align 4
  %r = alloca i32, align 4
  %sr = alloca i32, align 4
  %carry = alloca i32, align 4
  %s = alloca i32, align 4
  store i32 %n, i32* %n.addr, align 4
  store i32 %d, i32* %d.addr, align 4
  store i32 32, i32* %n_uword_bits, align 4, !dbg !1480
  %0 = load i32, i32* %d.addr, align 4, !dbg !1481
  %cmp = icmp eq i32 %0, 0, !dbg !1482
  br i1 %cmp, label %if.then, label %if.end, !dbg !1481

if.then:                                          ; preds = %entry
  store i32 0, i32* %retval, align 4, !dbg !1483
  br label %return, !dbg !1483

if.end:                                           ; preds = %entry
  %1 = load i32, i32* %n.addr, align 4, !dbg !1484
  %cmp1 = icmp eq i32 %1, 0, !dbg !1485
  br i1 %cmp1, label %if.then2, label %if.end3, !dbg !1484

if.then2:                                         ; preds = %if.end
  store i32 0, i32* %retval, align 4, !dbg !1486
  br label %return, !dbg !1486

if.end3:                                          ; preds = %if.end
  %2 = load i32, i32* %d.addr, align 4, !dbg !1487
  %3 = call i32 @llvm.ctlz.i32(i32 %2, i1 true), !dbg !1488
  %4 = load i32, i32* %n.addr, align 4, !dbg !1489
  %5 = call i32 @llvm.ctlz.i32(i32 %4, i1 true), !dbg !1490
  %sub = sub nsw i32 %3, %5, !dbg !1491
  store i32 %sub, i32* %sr, align 4, !dbg !1492
  %6 = load i32, i32* %sr, align 4, !dbg !1493
  %cmp4 = icmp ugt i32 %6, 31, !dbg !1494
  br i1 %cmp4, label %if.then5, label %if.end6, !dbg !1493

if.then5:                                         ; preds = %if.end3
  store i32 0, i32* %retval, align 4, !dbg !1495
  br label %return, !dbg !1495

if.end6:                                          ; preds = %if.end3
  %7 = load i32, i32* %sr, align 4, !dbg !1496
  %cmp7 = icmp eq i32 %7, 31, !dbg !1497
  br i1 %cmp7, label %if.then8, label %if.end9, !dbg !1496

if.then8:                                         ; preds = %if.end6
  %8 = load i32, i32* %n.addr, align 4, !dbg !1498
  store i32 %8, i32* %retval, align 4, !dbg !1499
  br label %return, !dbg !1499

if.end9:                                          ; preds = %if.end6
  %9 = load i32, i32* %sr, align 4, !dbg !1500
  %inc = add i32 %9, 1, !dbg !1500
  store i32 %inc, i32* %sr, align 4, !dbg !1500
  %10 = load i32, i32* %n.addr, align 4, !dbg !1501
  %11 = load i32, i32* %sr, align 4, !dbg !1502
  %sub10 = sub i32 32, %11, !dbg !1503
  %shl = shl i32 %10, %sub10, !dbg !1504
  store i32 %shl, i32* %q, align 4, !dbg !1505
  %12 = load i32, i32* %n.addr, align 4, !dbg !1506
  %13 = load i32, i32* %sr, align 4, !dbg !1507
  %shr = lshr i32 %12, %13, !dbg !1508
  store i32 %shr, i32* %r, align 4, !dbg !1509
  store i32 0, i32* %carry, align 4, !dbg !1510
  br label %for.cond, !dbg !1511

for.cond:                                         ; preds = %for.inc, %if.end9
  %14 = load i32, i32* %sr, align 4, !dbg !1512
  %cmp11 = icmp ugt i32 %14, 0, !dbg !1513
  br i1 %cmp11, label %for.body, label %for.end, !dbg !1511

for.body:                                         ; preds = %for.cond
  %15 = load i32, i32* %r, align 4, !dbg !1514
  %shl12 = shl i32 %15, 1, !dbg !1515
  %16 = load i32, i32* %q, align 4, !dbg !1516
  %shr13 = lshr i32 %16, 31, !dbg !1517
  %or = or i32 %shl12, %shr13, !dbg !1518
  store i32 %or, i32* %r, align 4, !dbg !1519
  %17 = load i32, i32* %q, align 4, !dbg !1520
  %shl14 = shl i32 %17, 1, !dbg !1521
  %18 = load i32, i32* %carry, align 4, !dbg !1522
  %or15 = or i32 %shl14, %18, !dbg !1523
  store i32 %or15, i32* %q, align 4, !dbg !1524
  %19 = load i32, i32* %d.addr, align 4, !dbg !1525
  %20 = load i32, i32* %r, align 4, !dbg !1526
  %sub16 = sub i32 %19, %20, !dbg !1527
  %sub17 = sub i32 %sub16, 1, !dbg !1528
  %shr18 = ashr i32 %sub17, 31, !dbg !1529
  store i32 %shr18, i32* %s, align 4, !dbg !1530
  %21 = load i32, i32* %s, align 4, !dbg !1531
  %and = and i32 %21, 1, !dbg !1532
  store i32 %and, i32* %carry, align 4, !dbg !1533
  %22 = load i32, i32* %d.addr, align 4, !dbg !1534
  %23 = load i32, i32* %s, align 4, !dbg !1535
  %and19 = and i32 %22, %23, !dbg !1536
  %24 = load i32, i32* %r, align 4, !dbg !1537
  %sub20 = sub i32 %24, %and19, !dbg !1537
  store i32 %sub20, i32* %r, align 4, !dbg !1537
  br label %for.inc, !dbg !1538

for.inc:                                          ; preds = %for.body
  %25 = load i32, i32* %sr, align 4, !dbg !1539
  %dec = add i32 %25, -1, !dbg !1539
  store i32 %dec, i32* %sr, align 4, !dbg !1539
  br label %for.cond, !dbg !1511, !llvm.loop !1540

for.end:                                          ; preds = %for.cond
  %26 = load i32, i32* %q, align 4, !dbg !1541
  %shl21 = shl i32 %26, 1, !dbg !1542
  %27 = load i32, i32* %carry, align 4, !dbg !1543
  %or22 = or i32 %shl21, %27, !dbg !1544
  store i32 %or22, i32* %q, align 4, !dbg !1545
  %28 = load i32, i32* %q, align 4, !dbg !1546
  store i32 %28, i32* %retval, align 4, !dbg !1547
  br label %return, !dbg !1547

return:                                           ; preds = %for.end, %if.then8, %if.then5, %if.then2, %if.then
  %29 = load i32, i32* %retval, align 4, !dbg !1548
  ret i32 %29, !dbg !1548
}

; Function Attrs: noinline nounwind
define dso_local i64 @__umoddi3(i64 %a, i64 %b) #0 !dbg !1549 {
entry:
  %a.addr = alloca i64, align 8
  %b.addr = alloca i64, align 8
  %r = alloca i64, align 8
  store i64 %a, i64* %a.addr, align 8
  store i64 %b, i64* %b.addr, align 8
  %0 = load i64, i64* %a.addr, align 8, !dbg !1550
  %1 = load i64, i64* %b.addr, align 8, !dbg !1551
  %call = call i64 @__udivmoddi4(i64 %0, i64 %1, i64* %r) #4, !dbg !1552
  %2 = load i64, i64* %r, align 8, !dbg !1553
  ret i64 %2, !dbg !1554
}

; Function Attrs: noinline nounwind
define dso_local i32 @__umodsi3(i32 %a, i32 %b) #0 !dbg !1555 {
entry:
  %a.addr = alloca i32, align 4
  %b.addr = alloca i32, align 4
  store i32 %a, i32* %a.addr, align 4
  store i32 %b, i32* %b.addr, align 4
  %0 = load i32, i32* %a.addr, align 4, !dbg !1556
  %1 = load i32, i32* %a.addr, align 4, !dbg !1557
  %2 = load i32, i32* %b.addr, align 4, !dbg !1558
  %call = call i32 @__udivsi3(i32 %1, i32 %2) #4, !dbg !1559
  %3 = load i32, i32* %b.addr, align 4, !dbg !1560
  %mul = mul i32 %call, %3, !dbg !1561
  %sub = sub i32 %0, %mul, !dbg !1562
  ret i32 %sub, !dbg !1563
}

attributes #0 = { noinline nounwind "correctly-rounded-divide-sqrt-fp-math"="false" "disable-tail-calls"="false" "less-precise-fpmad"="false" "no-frame-pointer-elim"="true" "no-frame-pointer-elim-non-leaf" "no-infs-fp-math"="false" "no-jump-tables"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="false" "stack-protector-buffer-size"="8" "target-features"="+d,+f,+m" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #1 = { nounwind readnone speculatable }
attributes #2 = { noinline noreturn nounwind "correctly-rounded-divide-sqrt-fp-math"="false" "disable-tail-calls"="false" "less-precise-fpmad"="false" "no-frame-pointer-elim"="true" "no-frame-pointer-elim-non-leaf" "no-infs-fp-math"="false" "no-jump-tables"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="false" "stack-protector-buffer-size"="8" "target-features"="+d,+f,+m" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #3 = { nobuiltin noreturn }
attributes #4 = { nobuiltin }

!llvm.dbg.cu = !{!0, !3, !5, !7, !9, !11, !13, !15, !17, !19, !21, !23, !25, !27, !29, !31, !33, !35, !37, !39, !41, !43, !45, !47, !49, !51, !53, !55, !57, !59, !61, !63, !65, !67, !69, !71, !73, !75, !77, !79, !81, !83, !85, !87, !89, !91, !93, !95, !97, !99, !101, !103, !105, !107, !109}
!llvm.ident = !{!111, !111, !111, !111, !111, !111, !111, !111, !111, !111, !111, !111, !111, !111, !111, !111, !111, !111, !111, !111, !111, !111, !111, !111, !111, !111, !111, !111, !111, !111, !111, !111, !111, !111, !111, !111, !111, !111, !111, !111, !111, !111, !111, !111, !111, !111, !111, !111, !111, !111, !111, !111, !111, !111, !111}
!llvm.module.flags = !{!112, !113, !114}

!0 = distinct !DICompileUnit(language: DW_LANG_C99, file: !1, producer: "clang version 7.0.0 (tags/RELEASE_700/final)", isOptimized: false, runtimeVersion: 0, emissionKind: LineTablesOnly, enums: !2)
!1 = !DIFile(filename: "/home/hahns/Schreibtisch/llvmta_testcases/libraries/builtinsint/absvdi2.c", directory: "/home/hahns/Schreibtisch/llvmta_testcases/tmp.cHjaumB4jN")
!2 = !{}
!3 = distinct !DICompileUnit(language: DW_LANG_C99, file: !4, producer: "clang version 7.0.0 (tags/RELEASE_700/final)", isOptimized: false, runtimeVersion: 0, emissionKind: LineTablesOnly, enums: !2)
!4 = !DIFile(filename: "/home/hahns/Schreibtisch/llvmta_testcases/libraries/builtinsint/absvsi2.c", directory: "/home/hahns/Schreibtisch/llvmta_testcases/tmp.cHjaumB4jN")
!5 = distinct !DICompileUnit(language: DW_LANG_C99, file: !6, producer: "clang version 7.0.0 (tags/RELEASE_700/final)", isOptimized: false, runtimeVersion: 0, emissionKind: LineTablesOnly, enums: !2)
!6 = !DIFile(filename: "/home/hahns/Schreibtisch/llvmta_testcases/libraries/builtinsint/absvti2.c", directory: "/home/hahns/Schreibtisch/llvmta_testcases/tmp.cHjaumB4jN")
!7 = distinct !DICompileUnit(language: DW_LANG_C99, file: !8, producer: "clang version 7.0.0 (tags/RELEASE_700/final)", isOptimized: false, runtimeVersion: 0, emissionKind: LineTablesOnly, enums: !2)
!8 = !DIFile(filename: "/home/hahns/Schreibtisch/llvmta_testcases/libraries/builtinsint/addvdi3.c", directory: "/home/hahns/Schreibtisch/llvmta_testcases/tmp.cHjaumB4jN")
!9 = distinct !DICompileUnit(language: DW_LANG_C99, file: !10, producer: "clang version 7.0.0 (tags/RELEASE_700/final)", isOptimized: false, runtimeVersion: 0, emissionKind: LineTablesOnly, enums: !2)
!10 = !DIFile(filename: "/home/hahns/Schreibtisch/llvmta_testcases/libraries/builtinsint/addvsi3.c", directory: "/home/hahns/Schreibtisch/llvmta_testcases/tmp.cHjaumB4jN")
!11 = distinct !DICompileUnit(language: DW_LANG_C99, file: !12, producer: "clang version 7.0.0 (tags/RELEASE_700/final)", isOptimized: false, runtimeVersion: 0, emissionKind: LineTablesOnly, enums: !2)
!12 = !DIFile(filename: "/home/hahns/Schreibtisch/llvmta_testcases/libraries/builtinsint/addvti3.c", directory: "/home/hahns/Schreibtisch/llvmta_testcases/tmp.cHjaumB4jN")
!13 = distinct !DICompileUnit(language: DW_LANG_C99, file: !14, producer: "clang version 7.0.0 (tags/RELEASE_700/final)", isOptimized: false, runtimeVersion: 0, emissionKind: LineTablesOnly, enums: !2)
!14 = !DIFile(filename: "/home/hahns/Schreibtisch/llvmta_testcases/libraries/builtinsint/ashldi3.c", directory: "/home/hahns/Schreibtisch/llvmta_testcases/tmp.cHjaumB4jN")
!15 = distinct !DICompileUnit(language: DW_LANG_C99, file: !16, producer: "clang version 7.0.0 (tags/RELEASE_700/final)", isOptimized: false, runtimeVersion: 0, emissionKind: LineTablesOnly, enums: !2)
!16 = !DIFile(filename: "/home/hahns/Schreibtisch/llvmta_testcases/libraries/builtinsint/ashlti3.c", directory: "/home/hahns/Schreibtisch/llvmta_testcases/tmp.cHjaumB4jN")
!17 = distinct !DICompileUnit(language: DW_LANG_C99, file: !18, producer: "clang version 7.0.0 (tags/RELEASE_700/final)", isOptimized: false, runtimeVersion: 0, emissionKind: LineTablesOnly, enums: !2)
!18 = !DIFile(filename: "/home/hahns/Schreibtisch/llvmta_testcases/libraries/builtinsint/ashrdi3.c", directory: "/home/hahns/Schreibtisch/llvmta_testcases/tmp.cHjaumB4jN")
!19 = distinct !DICompileUnit(language: DW_LANG_C99, file: !20, producer: "clang version 7.0.0 (tags/RELEASE_700/final)", isOptimized: false, runtimeVersion: 0, emissionKind: LineTablesOnly, enums: !2)
!20 = !DIFile(filename: "/home/hahns/Schreibtisch/llvmta_testcases/libraries/builtinsint/ashrti3.c", directory: "/home/hahns/Schreibtisch/llvmta_testcases/tmp.cHjaumB4jN")
!21 = distinct !DICompileUnit(language: DW_LANG_C99, file: !22, producer: "clang version 7.0.0 (tags/RELEASE_700/final)", isOptimized: false, runtimeVersion: 0, emissionKind: LineTablesOnly, enums: !2)
!22 = !DIFile(filename: "/home/hahns/Schreibtisch/llvmta_testcases/libraries/builtinsint/clzdi2.c", directory: "/home/hahns/Schreibtisch/llvmta_testcases/tmp.cHjaumB4jN")
!23 = distinct !DICompileUnit(language: DW_LANG_C99, file: !24, producer: "clang version 7.0.0 (tags/RELEASE_700/final)", isOptimized: false, runtimeVersion: 0, emissionKind: LineTablesOnly, enums: !2)
!24 = !DIFile(filename: "/home/hahns/Schreibtisch/llvmta_testcases/libraries/builtinsint/clzsi2.c", directory: "/home/hahns/Schreibtisch/llvmta_testcases/tmp.cHjaumB4jN")
!25 = distinct !DICompileUnit(language: DW_LANG_C99, file: !26, producer: "clang version 7.0.0 (tags/RELEASE_700/final)", isOptimized: false, runtimeVersion: 0, emissionKind: LineTablesOnly, enums: !2)
!26 = !DIFile(filename: "/home/hahns/Schreibtisch/llvmta_testcases/libraries/builtinsint/clzti2.c", directory: "/home/hahns/Schreibtisch/llvmta_testcases/tmp.cHjaumB4jN")
!27 = distinct !DICompileUnit(language: DW_LANG_C99, file: !28, producer: "clang version 7.0.0 (tags/RELEASE_700/final)", isOptimized: false, runtimeVersion: 0, emissionKind: LineTablesOnly, enums: !2)
!28 = !DIFile(filename: "/home/hahns/Schreibtisch/llvmta_testcases/libraries/builtinsint/cmpdi2.c", directory: "/home/hahns/Schreibtisch/llvmta_testcases/tmp.cHjaumB4jN")
!29 = distinct !DICompileUnit(language: DW_LANG_C99, file: !30, producer: "clang version 7.0.0 (tags/RELEASE_700/final)", isOptimized: false, runtimeVersion: 0, emissionKind: LineTablesOnly, enums: !2)
!30 = !DIFile(filename: "/home/hahns/Schreibtisch/llvmta_testcases/libraries/builtinsint/cmpti2.c", directory: "/home/hahns/Schreibtisch/llvmta_testcases/tmp.cHjaumB4jN")
!31 = distinct !DICompileUnit(language: DW_LANG_C99, file: !32, producer: "clang version 7.0.0 (tags/RELEASE_700/final)", isOptimized: false, runtimeVersion: 0, emissionKind: LineTablesOnly, enums: !2)
!32 = !DIFile(filename: "/home/hahns/Schreibtisch/llvmta_testcases/libraries/builtinsint/ctzdi2.c", directory: "/home/hahns/Schreibtisch/llvmta_testcases/tmp.cHjaumB4jN")
!33 = distinct !DICompileUnit(language: DW_LANG_C99, file: !34, producer: "clang version 7.0.0 (tags/RELEASE_700/final)", isOptimized: false, runtimeVersion: 0, emissionKind: LineTablesOnly, enums: !2)
!34 = !DIFile(filename: "/home/hahns/Schreibtisch/llvmta_testcases/libraries/builtinsint/ctzsi2.c", directory: "/home/hahns/Schreibtisch/llvmta_testcases/tmp.cHjaumB4jN")
!35 = distinct !DICompileUnit(language: DW_LANG_C99, file: !36, producer: "clang version 7.0.0 (tags/RELEASE_700/final)", isOptimized: false, runtimeVersion: 0, emissionKind: LineTablesOnly, enums: !2)
!36 = !DIFile(filename: "/home/hahns/Schreibtisch/llvmta_testcases/libraries/builtinsint/ctzti2.c", directory: "/home/hahns/Schreibtisch/llvmta_testcases/tmp.cHjaumB4jN")
!37 = distinct !DICompileUnit(language: DW_LANG_C99, file: !38, producer: "clang version 7.0.0 (tags/RELEASE_700/final)", isOptimized: false, runtimeVersion: 0, emissionKind: LineTablesOnly, enums: !2)
!38 = !DIFile(filename: "/home/hahns/Schreibtisch/llvmta_testcases/libraries/builtinsint/divdi3.c", directory: "/home/hahns/Schreibtisch/llvmta_testcases/tmp.cHjaumB4jN")
!39 = distinct !DICompileUnit(language: DW_LANG_C99, file: !40, producer: "clang version 7.0.0 (tags/RELEASE_700/final)", isOptimized: false, runtimeVersion: 0, emissionKind: LineTablesOnly, enums: !2)
!40 = !DIFile(filename: "/home/hahns/Schreibtisch/llvmta_testcases/libraries/builtinsint/divmoddi4.c", directory: "/home/hahns/Schreibtisch/llvmta_testcases/tmp.cHjaumB4jN")
!41 = distinct !DICompileUnit(language: DW_LANG_C99, file: !42, producer: "clang version 7.0.0 (tags/RELEASE_700/final)", isOptimized: false, runtimeVersion: 0, emissionKind: LineTablesOnly, enums: !2)
!42 = !DIFile(filename: "/home/hahns/Schreibtisch/llvmta_testcases/libraries/builtinsint/divmodsi4.c", directory: "/home/hahns/Schreibtisch/llvmta_testcases/tmp.cHjaumB4jN")
!43 = distinct !DICompileUnit(language: DW_LANG_C99, file: !44, producer: "clang version 7.0.0 (tags/RELEASE_700/final)", isOptimized: false, runtimeVersion: 0, emissionKind: LineTablesOnly, enums: !2)
!44 = !DIFile(filename: "/home/hahns/Schreibtisch/llvmta_testcases/libraries/builtinsint/divsi3.c", directory: "/home/hahns/Schreibtisch/llvmta_testcases/tmp.cHjaumB4jN")
!45 = distinct !DICompileUnit(language: DW_LANG_C99, file: !46, producer: "clang version 7.0.0 (tags/RELEASE_700/final)", isOptimized: false, runtimeVersion: 0, emissionKind: LineTablesOnly, enums: !2)
!46 = !DIFile(filename: "/home/hahns/Schreibtisch/llvmta_testcases/libraries/builtinsint/divti3.c", directory: "/home/hahns/Schreibtisch/llvmta_testcases/tmp.cHjaumB4jN")
!47 = distinct !DICompileUnit(language: DW_LANG_C99, file: !48, producer: "clang version 7.0.0 (tags/RELEASE_700/final)", isOptimized: false, runtimeVersion: 0, emissionKind: LineTablesOnly, enums: !2)
!48 = !DIFile(filename: "/home/hahns/Schreibtisch/llvmta_testcases/libraries/builtinsint/ffsdi2.c", directory: "/home/hahns/Schreibtisch/llvmta_testcases/tmp.cHjaumB4jN")
!49 = distinct !DICompileUnit(language: DW_LANG_C99, file: !50, producer: "clang version 7.0.0 (tags/RELEASE_700/final)", isOptimized: false, runtimeVersion: 0, emissionKind: LineTablesOnly, enums: !2)
!50 = !DIFile(filename: "/home/hahns/Schreibtisch/llvmta_testcases/libraries/builtinsint/ffssi2.c", directory: "/home/hahns/Schreibtisch/llvmta_testcases/tmp.cHjaumB4jN")
!51 = distinct !DICompileUnit(language: DW_LANG_C99, file: !52, producer: "clang version 7.0.0 (tags/RELEASE_700/final)", isOptimized: false, runtimeVersion: 0, emissionKind: LineTablesOnly, enums: !2)
!52 = !DIFile(filename: "/home/hahns/Schreibtisch/llvmta_testcases/libraries/builtinsint/ffsti2.c", directory: "/home/hahns/Schreibtisch/llvmta_testcases/tmp.cHjaumB4jN")
!53 = distinct !DICompileUnit(language: DW_LANG_C99, file: !54, producer: "clang version 7.0.0 (tags/RELEASE_700/final)", isOptimized: false, runtimeVersion: 0, emissionKind: LineTablesOnly, enums: !2)
!54 = !DIFile(filename: "/home/hahns/Schreibtisch/llvmta_testcases/libraries/builtinsint/int_util.c", directory: "/home/hahns/Schreibtisch/llvmta_testcases/tmp.cHjaumB4jN")
!55 = distinct !DICompileUnit(language: DW_LANG_C99, file: !56, producer: "clang version 7.0.0 (tags/RELEASE_700/final)", isOptimized: false, runtimeVersion: 0, emissionKind: LineTablesOnly, enums: !2)
!56 = !DIFile(filename: "/home/hahns/Schreibtisch/llvmta_testcases/libraries/builtinsint/lshrdi3.c", directory: "/home/hahns/Schreibtisch/llvmta_testcases/tmp.cHjaumB4jN")
!57 = distinct !DICompileUnit(language: DW_LANG_C99, file: !58, producer: "clang version 7.0.0 (tags/RELEASE_700/final)", isOptimized: false, runtimeVersion: 0, emissionKind: LineTablesOnly, enums: !2)
!58 = !DIFile(filename: "/home/hahns/Schreibtisch/llvmta_testcases/libraries/builtinsint/lshrti3.c", directory: "/home/hahns/Schreibtisch/llvmta_testcases/tmp.cHjaumB4jN")
!59 = distinct !DICompileUnit(language: DW_LANG_C99, file: !60, producer: "clang version 7.0.0 (tags/RELEASE_700/final)", isOptimized: false, runtimeVersion: 0, emissionKind: LineTablesOnly, enums: !2)
!60 = !DIFile(filename: "/home/hahns/Schreibtisch/llvmta_testcases/libraries/builtinsint/moddi3.c", directory: "/home/hahns/Schreibtisch/llvmta_testcases/tmp.cHjaumB4jN")
!61 = distinct !DICompileUnit(language: DW_LANG_C99, file: !62, producer: "clang version 7.0.0 (tags/RELEASE_700/final)", isOptimized: false, runtimeVersion: 0, emissionKind: LineTablesOnly, enums: !2)
!62 = !DIFile(filename: "/home/hahns/Schreibtisch/llvmta_testcases/libraries/builtinsint/modsi3.c", directory: "/home/hahns/Schreibtisch/llvmta_testcases/tmp.cHjaumB4jN")
!63 = distinct !DICompileUnit(language: DW_LANG_C99, file: !64, producer: "clang version 7.0.0 (tags/RELEASE_700/final)", isOptimized: false, runtimeVersion: 0, emissionKind: LineTablesOnly, enums: !2)
!64 = !DIFile(filename: "/home/hahns/Schreibtisch/llvmta_testcases/libraries/builtinsint/modti3.c", directory: "/home/hahns/Schreibtisch/llvmta_testcases/tmp.cHjaumB4jN")
!65 = distinct !DICompileUnit(language: DW_LANG_C99, file: !66, producer: "clang version 7.0.0 (tags/RELEASE_700/final)", isOptimized: false, runtimeVersion: 0, emissionKind: LineTablesOnly, enums: !2)
!66 = !DIFile(filename: "/home/hahns/Schreibtisch/llvmta_testcases/libraries/builtinsint/mulvdi3.c", directory: "/home/hahns/Schreibtisch/llvmta_testcases/tmp.cHjaumB4jN")
!67 = distinct !DICompileUnit(language: DW_LANG_C99, file: !68, producer: "clang version 7.0.0 (tags/RELEASE_700/final)", isOptimized: false, runtimeVersion: 0, emissionKind: LineTablesOnly, enums: !2)
!68 = !DIFile(filename: "/home/hahns/Schreibtisch/llvmta_testcases/libraries/builtinsint/mulvsi3.c", directory: "/home/hahns/Schreibtisch/llvmta_testcases/tmp.cHjaumB4jN")
!69 = distinct !DICompileUnit(language: DW_LANG_C99, file: !70, producer: "clang version 7.0.0 (tags/RELEASE_700/final)", isOptimized: false, runtimeVersion: 0, emissionKind: LineTablesOnly, enums: !2)
!70 = !DIFile(filename: "/home/hahns/Schreibtisch/llvmta_testcases/libraries/builtinsint/mulvti3.c", directory: "/home/hahns/Schreibtisch/llvmta_testcases/tmp.cHjaumB4jN")
!71 = distinct !DICompileUnit(language: DW_LANG_C99, file: !72, producer: "clang version 7.0.0 (tags/RELEASE_700/final)", isOptimized: false, runtimeVersion: 0, emissionKind: LineTablesOnly, enums: !2)
!72 = !DIFile(filename: "/home/hahns/Schreibtisch/llvmta_testcases/libraries/builtinsint/paritydi2.c", directory: "/home/hahns/Schreibtisch/llvmta_testcases/tmp.cHjaumB4jN")
!73 = distinct !DICompileUnit(language: DW_LANG_C99, file: !74, producer: "clang version 7.0.0 (tags/RELEASE_700/final)", isOptimized: false, runtimeVersion: 0, emissionKind: LineTablesOnly, enums: !2)
!74 = !DIFile(filename: "/home/hahns/Schreibtisch/llvmta_testcases/libraries/builtinsint/paritysi2.c", directory: "/home/hahns/Schreibtisch/llvmta_testcases/tmp.cHjaumB4jN")
!75 = distinct !DICompileUnit(language: DW_LANG_C99, file: !76, producer: "clang version 7.0.0 (tags/RELEASE_700/final)", isOptimized: false, runtimeVersion: 0, emissionKind: LineTablesOnly, enums: !2)
!76 = !DIFile(filename: "/home/hahns/Schreibtisch/llvmta_testcases/libraries/builtinsint/parityti2.c", directory: "/home/hahns/Schreibtisch/llvmta_testcases/tmp.cHjaumB4jN")
!77 = distinct !DICompileUnit(language: DW_LANG_C99, file: !78, producer: "clang version 7.0.0 (tags/RELEASE_700/final)", isOptimized: false, runtimeVersion: 0, emissionKind: LineTablesOnly, enums: !2)
!78 = !DIFile(filename: "/home/hahns/Schreibtisch/llvmta_testcases/libraries/builtinsint/popcountdi2.c", directory: "/home/hahns/Schreibtisch/llvmta_testcases/tmp.cHjaumB4jN")
!79 = distinct !DICompileUnit(language: DW_LANG_C99, file: !80, producer: "clang version 7.0.0 (tags/RELEASE_700/final)", isOptimized: false, runtimeVersion: 0, emissionKind: LineTablesOnly, enums: !2)
!80 = !DIFile(filename: "/home/hahns/Schreibtisch/llvmta_testcases/libraries/builtinsint/popcountsi2.c", directory: "/home/hahns/Schreibtisch/llvmta_testcases/tmp.cHjaumB4jN")
!81 = distinct !DICompileUnit(language: DW_LANG_C99, file: !82, producer: "clang version 7.0.0 (tags/RELEASE_700/final)", isOptimized: false, runtimeVersion: 0, emissionKind: LineTablesOnly, enums: !2)
!82 = !DIFile(filename: "/home/hahns/Schreibtisch/llvmta_testcases/libraries/builtinsint/popcountti2.c", directory: "/home/hahns/Schreibtisch/llvmta_testcases/tmp.cHjaumB4jN")
!83 = distinct !DICompileUnit(language: DW_LANG_C99, file: !84, producer: "clang version 7.0.0 (tags/RELEASE_700/final)", isOptimized: false, runtimeVersion: 0, emissionKind: LineTablesOnly, enums: !2)
!84 = !DIFile(filename: "/home/hahns/Schreibtisch/llvmta_testcases/libraries/builtinsint/subvdi3.c", directory: "/home/hahns/Schreibtisch/llvmta_testcases/tmp.cHjaumB4jN")
!85 = distinct !DICompileUnit(language: DW_LANG_C99, file: !86, producer: "clang version 7.0.0 (tags/RELEASE_700/final)", isOptimized: false, runtimeVersion: 0, emissionKind: LineTablesOnly, enums: !2)
!86 = !DIFile(filename: "/home/hahns/Schreibtisch/llvmta_testcases/libraries/builtinsint/subvsi3.c", directory: "/home/hahns/Schreibtisch/llvmta_testcases/tmp.cHjaumB4jN")
!87 = distinct !DICompileUnit(language: DW_LANG_C99, file: !88, producer: "clang version 7.0.0 (tags/RELEASE_700/final)", isOptimized: false, runtimeVersion: 0, emissionKind: LineTablesOnly, enums: !2)
!88 = !DIFile(filename: "/home/hahns/Schreibtisch/llvmta_testcases/libraries/builtinsint/subvti3.c", directory: "/home/hahns/Schreibtisch/llvmta_testcases/tmp.cHjaumB4jN")
!89 = distinct !DICompileUnit(language: DW_LANG_C99, file: !90, producer: "clang version 7.0.0 (tags/RELEASE_700/final)", isOptimized: false, runtimeVersion: 0, emissionKind: LineTablesOnly, enums: !2)
!90 = !DIFile(filename: "/home/hahns/Schreibtisch/llvmta_testcases/libraries/builtinsint/ucmpdi2.c", directory: "/home/hahns/Schreibtisch/llvmta_testcases/tmp.cHjaumB4jN")
!91 = distinct !DICompileUnit(language: DW_LANG_C99, file: !92, producer: "clang version 7.0.0 (tags/RELEASE_700/final)", isOptimized: false, runtimeVersion: 0, emissionKind: LineTablesOnly, enums: !2)
!92 = !DIFile(filename: "/home/hahns/Schreibtisch/llvmta_testcases/libraries/builtinsint/ucmpti2.c", directory: "/home/hahns/Schreibtisch/llvmta_testcases/tmp.cHjaumB4jN")
!93 = distinct !DICompileUnit(language: DW_LANG_C99, file: !94, producer: "clang version 7.0.0 (tags/RELEASE_700/final)", isOptimized: false, runtimeVersion: 0, emissionKind: LineTablesOnly, enums: !2)
!94 = !DIFile(filename: "/home/hahns/Schreibtisch/llvmta_testcases/libraries/builtinsint/udivdi3.c", directory: "/home/hahns/Schreibtisch/llvmta_testcases/tmp.cHjaumB4jN")
!95 = distinct !DICompileUnit(language: DW_LANG_C99, file: !96, producer: "clang version 7.0.0 (tags/RELEASE_700/final)", isOptimized: false, runtimeVersion: 0, emissionKind: LineTablesOnly, enums: !2)
!96 = !DIFile(filename: "/home/hahns/Schreibtisch/llvmta_testcases/libraries/builtinsint/udivmoddi4.c", directory: "/home/hahns/Schreibtisch/llvmta_testcases/tmp.cHjaumB4jN")
!97 = distinct !DICompileUnit(language: DW_LANG_C99, file: !98, producer: "clang version 7.0.0 (tags/RELEASE_700/final)", isOptimized: false, runtimeVersion: 0, emissionKind: LineTablesOnly, enums: !2)
!98 = !DIFile(filename: "/home/hahns/Schreibtisch/llvmta_testcases/libraries/builtinsint/udivmodsi4.c", directory: "/home/hahns/Schreibtisch/llvmta_testcases/tmp.cHjaumB4jN")
!99 = distinct !DICompileUnit(language: DW_LANG_C99, file: !100, producer: "clang version 7.0.0 (tags/RELEASE_700/final)", isOptimized: false, runtimeVersion: 0, emissionKind: LineTablesOnly, enums: !2)
!100 = !DIFile(filename: "/home/hahns/Schreibtisch/llvmta_testcases/libraries/builtinsint/udivmodti4.c", directory: "/home/hahns/Schreibtisch/llvmta_testcases/tmp.cHjaumB4jN")
!101 = distinct !DICompileUnit(language: DW_LANG_C99, file: !102, producer: "clang version 7.0.0 (tags/RELEASE_700/final)", isOptimized: false, runtimeVersion: 0, emissionKind: LineTablesOnly, enums: !2)
!102 = !DIFile(filename: "/home/hahns/Schreibtisch/llvmta_testcases/libraries/builtinsint/udivsi3.c", directory: "/home/hahns/Schreibtisch/llvmta_testcases/tmp.cHjaumB4jN")
!103 = distinct !DICompileUnit(language: DW_LANG_C99, file: !104, producer: "clang version 7.0.0 (tags/RELEASE_700/final)", isOptimized: false, runtimeVersion: 0, emissionKind: LineTablesOnly, enums: !2)
!104 = !DIFile(filename: "/home/hahns/Schreibtisch/llvmta_testcases/libraries/builtinsint/udivti3.c", directory: "/home/hahns/Schreibtisch/llvmta_testcases/tmp.cHjaumB4jN")
!105 = distinct !DICompileUnit(language: DW_LANG_C99, file: !106, producer: "clang version 7.0.0 (tags/RELEASE_700/final)", isOptimized: false, runtimeVersion: 0, emissionKind: LineTablesOnly, enums: !2)
!106 = !DIFile(filename: "/home/hahns/Schreibtisch/llvmta_testcases/libraries/builtinsint/umoddi3.c", directory: "/home/hahns/Schreibtisch/llvmta_testcases/tmp.cHjaumB4jN")
!107 = distinct !DICompileUnit(language: DW_LANG_C99, file: !108, producer: "clang version 7.0.0 (tags/RELEASE_700/final)", isOptimized: false, runtimeVersion: 0, emissionKind: LineTablesOnly, enums: !2)
!108 = !DIFile(filename: "/home/hahns/Schreibtisch/llvmta_testcases/libraries/builtinsint/umodsi3.c", directory: "/home/hahns/Schreibtisch/llvmta_testcases/tmp.cHjaumB4jN")
!109 = distinct !DICompileUnit(language: DW_LANG_C99, file: !110, producer: "clang version 7.0.0 (tags/RELEASE_700/final)", isOptimized: false, runtimeVersion: 0, emissionKind: LineTablesOnly, enums: !2)
!110 = !DIFile(filename: "/home/hahns/Schreibtisch/llvmta_testcases/libraries/builtinsint/umodti3.c", directory: "/home/hahns/Schreibtisch/llvmta_testcases/tmp.cHjaumB4jN")
!111 = !{!"clang version 7.0.0 (tags/RELEASE_700/final)"}
!112 = !{i32 2, !"Dwarf Version", i32 4}
!113 = !{i32 2, !"Debug Info Version", i32 3}
!114 = !{i32 1, !"wchar_size", i32 4}
!115 = distinct !DISubprogram(name: "__absvdi2", scope: !1, file: !1, line: 22, type: !116, isLocal: false, isDefinition: true, scopeLine: 23, flags: DIFlagPrototyped, isOptimized: false, unit: !0, retainedNodes: !2)
!116 = !DISubroutineType(types: !2)
!117 = !DILocation(line: 24, column: 15, scope: !115)
!118 = !DILocation(line: 25, column: 9, scope: !115)
!119 = !DILocation(line: 25, column: 11, scope: !115)
!120 = !DILocation(line: 26, column: 9, scope: !115)
!121 = !DILocation(line: 27, column: 22, scope: !115)
!122 = !DILocation(line: 27, column: 24, scope: !115)
!123 = !DILocation(line: 27, column: 18, scope: !115)
!124 = !DILocation(line: 28, column: 13, scope: !115)
!125 = !DILocation(line: 28, column: 17, scope: !115)
!126 = !DILocation(line: 28, column: 15, scope: !115)
!127 = !DILocation(line: 28, column: 22, scope: !115)
!128 = !DILocation(line: 28, column: 20, scope: !115)
!129 = !DILocation(line: 28, column: 5, scope: !115)
!130 = distinct !DISubprogram(name: "__absvsi2", scope: !4, file: !4, line: 22, type: !116, isLocal: false, isDefinition: true, scopeLine: 23, flags: DIFlagPrototyped, isOptimized: false, unit: !3, retainedNodes: !2)
!131 = !DILocation(line: 24, column: 15, scope: !130)
!132 = !DILocation(line: 25, column: 9, scope: !130)
!133 = !DILocation(line: 25, column: 11, scope: !130)
!134 = !DILocation(line: 26, column: 9, scope: !130)
!135 = !DILocation(line: 27, column: 22, scope: !130)
!136 = !DILocation(line: 27, column: 24, scope: !130)
!137 = !DILocation(line: 27, column: 18, scope: !130)
!138 = !DILocation(line: 28, column: 13, scope: !130)
!139 = !DILocation(line: 28, column: 17, scope: !130)
!140 = !DILocation(line: 28, column: 15, scope: !130)
!141 = !DILocation(line: 28, column: 22, scope: !130)
!142 = !DILocation(line: 28, column: 20, scope: !130)
!143 = !DILocation(line: 28, column: 5, scope: !130)
!144 = distinct !DISubprogram(name: "__addvdi3", scope: !8, file: !8, line: 22, type: !116, isLocal: false, isDefinition: true, scopeLine: 23, flags: DIFlagPrototyped, isOptimized: false, unit: !7, retainedNodes: !2)
!145 = !DILocation(line: 24, column: 25, scope: !144)
!146 = !DILocation(line: 24, column: 38, scope: !144)
!147 = !DILocation(line: 24, column: 27, scope: !144)
!148 = !DILocation(line: 24, column: 12, scope: !144)
!149 = !DILocation(line: 25, column: 9, scope: !144)
!150 = !DILocation(line: 25, column: 11, scope: !144)
!151 = !DILocation(line: 27, column: 13, scope: !144)
!152 = !DILocation(line: 27, column: 17, scope: !144)
!153 = !DILocation(line: 27, column: 15, scope: !144)
!154 = !DILocation(line: 28, column: 13, scope: !144)
!155 = !DILocation(line: 29, column: 5, scope: !144)
!156 = !DILocation(line: 32, column: 13, scope: !144)
!157 = !DILocation(line: 32, column: 18, scope: !144)
!158 = !DILocation(line: 32, column: 15, scope: !144)
!159 = !DILocation(line: 33, column: 13, scope: !144)
!160 = !DILocation(line: 35, column: 12, scope: !144)
!161 = !DILocation(line: 35, column: 5, scope: !144)
!162 = distinct !DISubprogram(name: "__addvsi3", scope: !10, file: !10, line: 22, type: !116, isLocal: false, isDefinition: true, scopeLine: 23, flags: DIFlagPrototyped, isOptimized: false, unit: !9, retainedNodes: !2)
!163 = !DILocation(line: 24, column: 25, scope: !162)
!164 = !DILocation(line: 24, column: 38, scope: !162)
!165 = !DILocation(line: 24, column: 27, scope: !162)
!166 = !DILocation(line: 24, column: 12, scope: !162)
!167 = !DILocation(line: 25, column: 9, scope: !162)
!168 = !DILocation(line: 25, column: 11, scope: !162)
!169 = !DILocation(line: 27, column: 13, scope: !162)
!170 = !DILocation(line: 27, column: 17, scope: !162)
!171 = !DILocation(line: 27, column: 15, scope: !162)
!172 = !DILocation(line: 28, column: 13, scope: !162)
!173 = !DILocation(line: 29, column: 5, scope: !162)
!174 = !DILocation(line: 32, column: 13, scope: !162)
!175 = !DILocation(line: 32, column: 18, scope: !162)
!176 = !DILocation(line: 32, column: 15, scope: !162)
!177 = !DILocation(line: 33, column: 13, scope: !162)
!178 = !DILocation(line: 35, column: 12, scope: !162)
!179 = !DILocation(line: 35, column: 5, scope: !162)
!180 = distinct !DISubprogram(name: "__ashldi3", scope: !14, file: !14, line: 24, type: !116, isLocal: false, isDefinition: true, scopeLine: 25, flags: DIFlagPrototyped, isOptimized: false, unit: !13, retainedNodes: !2)
!181 = !DILocation(line: 26, column: 15, scope: !180)
!182 = !DILocation(line: 29, column: 17, scope: !180)
!183 = !DILocation(line: 29, column: 11, scope: !180)
!184 = !DILocation(line: 29, column: 15, scope: !180)
!185 = !DILocation(line: 30, column: 9, scope: !180)
!186 = !DILocation(line: 30, column: 11, scope: !180)
!187 = !DILocation(line: 32, column: 16, scope: !180)
!188 = !DILocation(line: 32, column: 18, scope: !180)
!189 = !DILocation(line: 32, column: 22, scope: !180)
!190 = !DILocation(line: 33, column: 31, scope: !180)
!191 = !DILocation(line: 33, column: 33, scope: !180)
!192 = !DILocation(line: 33, column: 41, scope: !180)
!193 = !DILocation(line: 33, column: 43, scope: !180)
!194 = !DILocation(line: 33, column: 37, scope: !180)
!195 = !DILocation(line: 33, column: 16, scope: !180)
!196 = !DILocation(line: 33, column: 18, scope: !180)
!197 = !DILocation(line: 33, column: 23, scope: !180)
!198 = !DILocation(line: 34, column: 5, scope: !180)
!199 = !DILocation(line: 37, column: 13, scope: !180)
!200 = !DILocation(line: 37, column: 15, scope: !180)
!201 = !DILocation(line: 38, column: 20, scope: !180)
!202 = !DILocation(line: 38, column: 13, scope: !180)
!203 = !DILocation(line: 39, column: 31, scope: !180)
!204 = !DILocation(line: 39, column: 33, scope: !180)
!205 = !DILocation(line: 39, column: 40, scope: !180)
!206 = !DILocation(line: 39, column: 37, scope: !180)
!207 = !DILocation(line: 39, column: 16, scope: !180)
!208 = !DILocation(line: 39, column: 18, scope: !180)
!209 = !DILocation(line: 39, column: 23, scope: !180)
!210 = !DILocation(line: 40, column: 32, scope: !180)
!211 = !DILocation(line: 40, column: 34, scope: !180)
!212 = !DILocation(line: 40, column: 42, scope: !180)
!213 = !DILocation(line: 40, column: 39, scope: !180)
!214 = !DILocation(line: 40, column: 54, scope: !180)
!215 = !DILocation(line: 40, column: 56, scope: !180)
!216 = !DILocation(line: 40, column: 79, scope: !180)
!217 = !DILocation(line: 40, column: 77, scope: !180)
!218 = !DILocation(line: 40, column: 60, scope: !180)
!219 = !DILocation(line: 40, column: 45, scope: !180)
!220 = !DILocation(line: 40, column: 16, scope: !180)
!221 = !DILocation(line: 40, column: 18, scope: !180)
!222 = !DILocation(line: 40, column: 23, scope: !180)
!223 = !DILocation(line: 42, column: 19, scope: !180)
!224 = !DILocation(line: 42, column: 5, scope: !180)
!225 = !DILocation(line: 43, column: 1, scope: !180)
!226 = distinct !DISubprogram(name: "__ashrdi3", scope: !18, file: !18, line: 24, type: !116, isLocal: false, isDefinition: true, scopeLine: 25, flags: DIFlagPrototyped, isOptimized: false, unit: !17, retainedNodes: !2)
!227 = !DILocation(line: 26, column: 15, scope: !226)
!228 = !DILocation(line: 29, column: 17, scope: !226)
!229 = !DILocation(line: 29, column: 11, scope: !226)
!230 = !DILocation(line: 29, column: 15, scope: !226)
!231 = !DILocation(line: 30, column: 9, scope: !226)
!232 = !DILocation(line: 30, column: 11, scope: !226)
!233 = !DILocation(line: 33, column: 31, scope: !226)
!234 = !DILocation(line: 33, column: 33, scope: !226)
!235 = !DILocation(line: 33, column: 38, scope: !226)
!236 = !DILocation(line: 33, column: 16, scope: !226)
!237 = !DILocation(line: 33, column: 18, scope: !226)
!238 = !DILocation(line: 33, column: 23, scope: !226)
!239 = !DILocation(line: 34, column: 30, scope: !226)
!240 = !DILocation(line: 34, column: 32, scope: !226)
!241 = !DILocation(line: 34, column: 41, scope: !226)
!242 = !DILocation(line: 34, column: 43, scope: !226)
!243 = !DILocation(line: 34, column: 37, scope: !226)
!244 = !DILocation(line: 34, column: 16, scope: !226)
!245 = !DILocation(line: 34, column: 18, scope: !226)
!246 = !DILocation(line: 34, column: 22, scope: !226)
!247 = !DILocation(line: 35, column: 5, scope: !226)
!248 = !DILocation(line: 38, column: 13, scope: !226)
!249 = !DILocation(line: 38, column: 15, scope: !226)
!250 = !DILocation(line: 39, column: 20, scope: !226)
!251 = !DILocation(line: 39, column: 13, scope: !226)
!252 = !DILocation(line: 40, column: 32, scope: !226)
!253 = !DILocation(line: 40, column: 34, scope: !226)
!254 = !DILocation(line: 40, column: 42, scope: !226)
!255 = !DILocation(line: 40, column: 39, scope: !226)
!256 = !DILocation(line: 40, column: 16, scope: !226)
!257 = !DILocation(line: 40, column: 18, scope: !226)
!258 = !DILocation(line: 40, column: 24, scope: !226)
!259 = !DILocation(line: 41, column: 31, scope: !226)
!260 = !DILocation(line: 41, column: 33, scope: !226)
!261 = !DILocation(line: 41, column: 57, scope: !226)
!262 = !DILocation(line: 41, column: 55, scope: !226)
!263 = !DILocation(line: 41, column: 38, scope: !226)
!264 = !DILocation(line: 41, column: 70, scope: !226)
!265 = !DILocation(line: 41, column: 72, scope: !226)
!266 = !DILocation(line: 41, column: 79, scope: !226)
!267 = !DILocation(line: 41, column: 76, scope: !226)
!268 = !DILocation(line: 41, column: 61, scope: !226)
!269 = !DILocation(line: 41, column: 16, scope: !226)
!270 = !DILocation(line: 41, column: 18, scope: !226)
!271 = !DILocation(line: 41, column: 22, scope: !226)
!272 = !DILocation(line: 43, column: 19, scope: !226)
!273 = !DILocation(line: 43, column: 5, scope: !226)
!274 = !DILocation(line: 44, column: 1, scope: !226)
!275 = distinct !DISubprogram(name: "__clzdi2", scope: !22, file: !22, line: 22, type: !116, isLocal: false, isDefinition: true, scopeLine: 23, flags: DIFlagPrototyped, isOptimized: false, unit: !21, retainedNodes: !2)
!276 = !DILocation(line: 25, column: 13, scope: !275)
!277 = !DILocation(line: 25, column: 7, scope: !275)
!278 = !DILocation(line: 25, column: 11, scope: !275)
!279 = !DILocation(line: 26, column: 26, scope: !275)
!280 = !DILocation(line: 26, column: 28, scope: !275)
!281 = !DILocation(line: 26, column: 33, scope: !275)
!282 = !DILocation(line: 26, column: 22, scope: !275)
!283 = !DILocation(line: 26, column: 18, scope: !275)
!284 = !DILocation(line: 27, column: 29, scope: !275)
!285 = !DILocation(line: 27, column: 31, scope: !275)
!286 = !DILocation(line: 27, column: 39, scope: !275)
!287 = !DILocation(line: 27, column: 38, scope: !275)
!288 = !DILocation(line: 27, column: 36, scope: !275)
!289 = !DILocation(line: 27, column: 47, scope: !275)
!290 = !DILocation(line: 27, column: 49, scope: !275)
!291 = !DILocation(line: 27, column: 55, scope: !275)
!292 = !DILocation(line: 27, column: 53, scope: !275)
!293 = !DILocation(line: 27, column: 42, scope: !275)
!294 = !DILocation(line: 27, column: 12, scope: !275)
!295 = !DILocation(line: 28, column: 13, scope: !275)
!296 = !DILocation(line: 28, column: 15, scope: !275)
!297 = !DILocation(line: 27, column: 59, scope: !275)
!298 = !DILocation(line: 27, column: 5, scope: !275)
!299 = distinct !DISubprogram(name: "__clzsi2", scope: !24, file: !24, line: 22, type: !116, isLocal: false, isDefinition: true, scopeLine: 23, flags: DIFlagPrototyped, isOptimized: false, unit: !23, retainedNodes: !2)
!300 = !DILocation(line: 24, column: 24, scope: !299)
!301 = !DILocation(line: 24, column: 12, scope: !299)
!302 = !DILocation(line: 25, column: 18, scope: !299)
!303 = !DILocation(line: 25, column: 20, scope: !299)
!304 = !DILocation(line: 25, column: 34, scope: !299)
!305 = !DILocation(line: 25, column: 40, scope: !299)
!306 = !DILocation(line: 25, column: 12, scope: !299)
!307 = !DILocation(line: 26, column: 16, scope: !299)
!308 = !DILocation(line: 26, column: 14, scope: !299)
!309 = !DILocation(line: 26, column: 7, scope: !299)
!310 = !DILocation(line: 27, column: 16, scope: !299)
!311 = !DILocation(line: 27, column: 12, scope: !299)
!312 = !DILocation(line: 29, column: 11, scope: !299)
!313 = !DILocation(line: 29, column: 13, scope: !299)
!314 = !DILocation(line: 29, column: 23, scope: !299)
!315 = !DILocation(line: 29, column: 29, scope: !299)
!316 = !DILocation(line: 29, column: 7, scope: !299)
!317 = !DILocation(line: 30, column: 15, scope: !299)
!318 = !DILocation(line: 30, column: 13, scope: !299)
!319 = !DILocation(line: 30, column: 7, scope: !299)
!320 = !DILocation(line: 31, column: 10, scope: !299)
!321 = !DILocation(line: 31, column: 7, scope: !299)
!322 = !DILocation(line: 33, column: 11, scope: !299)
!323 = !DILocation(line: 33, column: 13, scope: !299)
!324 = !DILocation(line: 33, column: 21, scope: !299)
!325 = !DILocation(line: 33, column: 27, scope: !299)
!326 = !DILocation(line: 33, column: 7, scope: !299)
!327 = !DILocation(line: 34, column: 15, scope: !299)
!328 = !DILocation(line: 34, column: 13, scope: !299)
!329 = !DILocation(line: 34, column: 7, scope: !299)
!330 = !DILocation(line: 35, column: 10, scope: !299)
!331 = !DILocation(line: 35, column: 7, scope: !299)
!332 = !DILocation(line: 37, column: 11, scope: !299)
!333 = !DILocation(line: 37, column: 13, scope: !299)
!334 = !DILocation(line: 37, column: 20, scope: !299)
!335 = !DILocation(line: 37, column: 26, scope: !299)
!336 = !DILocation(line: 37, column: 7, scope: !299)
!337 = !DILocation(line: 38, column: 15, scope: !299)
!338 = !DILocation(line: 38, column: 13, scope: !299)
!339 = !DILocation(line: 38, column: 7, scope: !299)
!340 = !DILocation(line: 39, column: 10, scope: !299)
!341 = !DILocation(line: 39, column: 7, scope: !299)
!342 = !DILocation(line: 52, column: 12, scope: !299)
!343 = !DILocation(line: 52, column: 22, scope: !299)
!344 = !DILocation(line: 52, column: 20, scope: !299)
!345 = !DILocation(line: 52, column: 30, scope: !299)
!346 = !DILocation(line: 52, column: 32, scope: !299)
!347 = !DILocation(line: 52, column: 37, scope: !299)
!348 = !DILocation(line: 52, column: 27, scope: !299)
!349 = !DILocation(line: 52, column: 25, scope: !299)
!350 = !DILocation(line: 52, column: 14, scope: !299)
!351 = !DILocation(line: 52, column: 5, scope: !299)
!352 = distinct !DISubprogram(name: "__cmpdi2", scope: !28, file: !28, line: 23, type: !116, isLocal: false, isDefinition: true, scopeLine: 24, flags: DIFlagPrototyped, isOptimized: false, unit: !27, retainedNodes: !2)
!353 = !DILocation(line: 26, column: 13, scope: !352)
!354 = !DILocation(line: 26, column: 7, scope: !352)
!355 = !DILocation(line: 26, column: 11, scope: !352)
!356 = !DILocation(line: 28, column: 13, scope: !352)
!357 = !DILocation(line: 28, column: 7, scope: !352)
!358 = !DILocation(line: 28, column: 11, scope: !352)
!359 = !DILocation(line: 29, column: 11, scope: !352)
!360 = !DILocation(line: 29, column: 13, scope: !352)
!361 = !DILocation(line: 29, column: 22, scope: !352)
!362 = !DILocation(line: 29, column: 24, scope: !352)
!363 = !DILocation(line: 29, column: 18, scope: !352)
!364 = !DILocation(line: 29, column: 9, scope: !352)
!365 = !DILocation(line: 30, column: 9, scope: !352)
!366 = !DILocation(line: 31, column: 11, scope: !352)
!367 = !DILocation(line: 31, column: 13, scope: !352)
!368 = !DILocation(line: 31, column: 22, scope: !352)
!369 = !DILocation(line: 31, column: 24, scope: !352)
!370 = !DILocation(line: 31, column: 18, scope: !352)
!371 = !DILocation(line: 31, column: 9, scope: !352)
!372 = !DILocation(line: 32, column: 9, scope: !352)
!373 = !DILocation(line: 33, column: 11, scope: !352)
!374 = !DILocation(line: 33, column: 13, scope: !352)
!375 = !DILocation(line: 33, column: 21, scope: !352)
!376 = !DILocation(line: 33, column: 23, scope: !352)
!377 = !DILocation(line: 33, column: 17, scope: !352)
!378 = !DILocation(line: 33, column: 9, scope: !352)
!379 = !DILocation(line: 34, column: 9, scope: !352)
!380 = !DILocation(line: 35, column: 11, scope: !352)
!381 = !DILocation(line: 35, column: 13, scope: !352)
!382 = !DILocation(line: 35, column: 21, scope: !352)
!383 = !DILocation(line: 35, column: 23, scope: !352)
!384 = !DILocation(line: 35, column: 17, scope: !352)
!385 = !DILocation(line: 35, column: 9, scope: !352)
!386 = !DILocation(line: 36, column: 9, scope: !352)
!387 = !DILocation(line: 37, column: 5, scope: !352)
!388 = !DILocation(line: 38, column: 1, scope: !352)
!389 = distinct !DISubprogram(name: "__ctzdi2", scope: !32, file: !32, line: 22, type: !116, isLocal: false, isDefinition: true, scopeLine: 23, flags: DIFlagPrototyped, isOptimized: false, unit: !31, retainedNodes: !2)
!390 = !DILocation(line: 25, column: 13, scope: !389)
!391 = !DILocation(line: 25, column: 7, scope: !389)
!392 = !DILocation(line: 25, column: 11, scope: !389)
!393 = !DILocation(line: 26, column: 26, scope: !389)
!394 = !DILocation(line: 26, column: 28, scope: !389)
!395 = !DILocation(line: 26, column: 32, scope: !389)
!396 = !DILocation(line: 26, column: 22, scope: !389)
!397 = !DILocation(line: 26, column: 18, scope: !389)
!398 = !DILocation(line: 27, column: 29, scope: !389)
!399 = !DILocation(line: 27, column: 31, scope: !389)
!400 = !DILocation(line: 27, column: 38, scope: !389)
!401 = !DILocation(line: 27, column: 36, scope: !389)
!402 = !DILocation(line: 27, column: 46, scope: !389)
!403 = !DILocation(line: 27, column: 48, scope: !389)
!404 = !DILocation(line: 27, column: 55, scope: !389)
!405 = !DILocation(line: 27, column: 54, scope: !389)
!406 = !DILocation(line: 27, column: 52, scope: !389)
!407 = !DILocation(line: 27, column: 41, scope: !389)
!408 = !DILocation(line: 27, column: 12, scope: !389)
!409 = !DILocation(line: 28, column: 16, scope: !389)
!410 = !DILocation(line: 28, column: 18, scope: !389)
!411 = !DILocation(line: 27, column: 59, scope: !389)
!412 = !DILocation(line: 27, column: 5, scope: !389)
!413 = distinct !DISubprogram(name: "__ctzsi2", scope: !34, file: !34, line: 22, type: !116, isLocal: false, isDefinition: true, scopeLine: 23, flags: DIFlagPrototyped, isOptimized: false, unit: !33, retainedNodes: !2)
!414 = !DILocation(line: 24, column: 24, scope: !413)
!415 = !DILocation(line: 24, column: 12, scope: !413)
!416 = !DILocation(line: 25, column: 18, scope: !413)
!417 = !DILocation(line: 25, column: 20, scope: !413)
!418 = !DILocation(line: 25, column: 34, scope: !413)
!419 = !DILocation(line: 25, column: 40, scope: !413)
!420 = !DILocation(line: 25, column: 12, scope: !413)
!421 = !DILocation(line: 26, column: 11, scope: !413)
!422 = !DILocation(line: 26, column: 7, scope: !413)
!423 = !DILocation(line: 27, column: 16, scope: !413)
!424 = !DILocation(line: 27, column: 12, scope: !413)
!425 = !DILocation(line: 29, column: 11, scope: !413)
!426 = !DILocation(line: 29, column: 13, scope: !413)
!427 = !DILocation(line: 29, column: 23, scope: !413)
!428 = !DILocation(line: 29, column: 29, scope: !413)
!429 = !DILocation(line: 29, column: 7, scope: !413)
!430 = !DILocation(line: 30, column: 11, scope: !413)
!431 = !DILocation(line: 30, column: 7, scope: !413)
!432 = !DILocation(line: 31, column: 10, scope: !413)
!433 = !DILocation(line: 31, column: 7, scope: !413)
!434 = !DILocation(line: 33, column: 11, scope: !413)
!435 = !DILocation(line: 33, column: 13, scope: !413)
!436 = !DILocation(line: 33, column: 21, scope: !413)
!437 = !DILocation(line: 33, column: 27, scope: !413)
!438 = !DILocation(line: 33, column: 7, scope: !413)
!439 = !DILocation(line: 34, column: 11, scope: !413)
!440 = !DILocation(line: 34, column: 7, scope: !413)
!441 = !DILocation(line: 35, column: 10, scope: !413)
!442 = !DILocation(line: 35, column: 7, scope: !413)
!443 = !DILocation(line: 37, column: 11, scope: !413)
!444 = !DILocation(line: 37, column: 13, scope: !413)
!445 = !DILocation(line: 37, column: 20, scope: !413)
!446 = !DILocation(line: 37, column: 26, scope: !413)
!447 = !DILocation(line: 37, column: 7, scope: !413)
!448 = !DILocation(line: 38, column: 11, scope: !413)
!449 = !DILocation(line: 38, column: 7, scope: !413)
!450 = !DILocation(line: 39, column: 7, scope: !413)
!451 = !DILocation(line: 40, column: 10, scope: !413)
!452 = !DILocation(line: 40, column: 7, scope: !413)
!453 = !DILocation(line: 56, column: 12, scope: !413)
!454 = !DILocation(line: 56, column: 23, scope: !413)
!455 = !DILocation(line: 56, column: 25, scope: !413)
!456 = !DILocation(line: 56, column: 20, scope: !413)
!457 = !DILocation(line: 56, column: 37, scope: !413)
!458 = !DILocation(line: 56, column: 39, scope: !413)
!459 = !DILocation(line: 56, column: 44, scope: !413)
!460 = !DILocation(line: 56, column: 34, scope: !413)
!461 = !DILocation(line: 56, column: 32, scope: !413)
!462 = !DILocation(line: 56, column: 14, scope: !413)
!463 = !DILocation(line: 56, column: 5, scope: !413)
!464 = distinct !DISubprogram(name: "__divdi3", scope: !38, file: !38, line: 20, type: !116, isLocal: false, isDefinition: true, scopeLine: 21, flags: DIFlagPrototyped, isOptimized: false, unit: !37, retainedNodes: !2)
!465 = !DILocation(line: 22, column: 15, scope: !464)
!466 = !DILocation(line: 23, column: 18, scope: !464)
!467 = !DILocation(line: 23, column: 20, scope: !464)
!468 = !DILocation(line: 23, column: 12, scope: !464)
!469 = !DILocation(line: 24, column: 18, scope: !464)
!470 = !DILocation(line: 24, column: 20, scope: !464)
!471 = !DILocation(line: 24, column: 12, scope: !464)
!472 = !DILocation(line: 25, column: 10, scope: !464)
!473 = !DILocation(line: 25, column: 14, scope: !464)
!474 = !DILocation(line: 25, column: 12, scope: !464)
!475 = !DILocation(line: 25, column: 21, scope: !464)
!476 = !DILocation(line: 25, column: 19, scope: !464)
!477 = !DILocation(line: 25, column: 7, scope: !464)
!478 = !DILocation(line: 26, column: 10, scope: !464)
!479 = !DILocation(line: 26, column: 14, scope: !464)
!480 = !DILocation(line: 26, column: 12, scope: !464)
!481 = !DILocation(line: 26, column: 21, scope: !464)
!482 = !DILocation(line: 26, column: 19, scope: !464)
!483 = !DILocation(line: 26, column: 7, scope: !464)
!484 = !DILocation(line: 27, column: 12, scope: !464)
!485 = !DILocation(line: 27, column: 9, scope: !464)
!486 = !DILocation(line: 28, column: 26, scope: !464)
!487 = !DILocation(line: 28, column: 29, scope: !464)
!488 = !DILocation(line: 28, column: 13, scope: !464)
!489 = !DILocation(line: 28, column: 46, scope: !464)
!490 = !DILocation(line: 28, column: 44, scope: !464)
!491 = !DILocation(line: 28, column: 53, scope: !464)
!492 = !DILocation(line: 28, column: 51, scope: !464)
!493 = !DILocation(line: 28, column: 5, scope: !464)
!494 = distinct !DISubprogram(name: "__divmoddi4", scope: !40, file: !40, line: 20, type: !116, isLocal: false, isDefinition: true, scopeLine: 21, flags: DIFlagPrototyped, isOptimized: false, unit: !39, retainedNodes: !2)
!495 = !DILocation(line: 22, column: 23, scope: !494)
!496 = !DILocation(line: 22, column: 25, scope: !494)
!497 = !DILocation(line: 22, column: 14, scope: !494)
!498 = !DILocation(line: 22, column: 10, scope: !494)
!499 = !DILocation(line: 23, column: 10, scope: !494)
!500 = !DILocation(line: 23, column: 15, scope: !494)
!501 = !DILocation(line: 23, column: 17, scope: !494)
!502 = !DILocation(line: 23, column: 16, scope: !494)
!503 = !DILocation(line: 23, column: 12, scope: !494)
!504 = !DILocation(line: 23, column: 4, scope: !494)
!505 = !DILocation(line: 23, column: 8, scope: !494)
!506 = !DILocation(line: 24, column: 10, scope: !494)
!507 = !DILocation(line: 24, column: 3, scope: !494)
!508 = distinct !DISubprogram(name: "__divmodsi4", scope: !42, file: !42, line: 20, type: !116, isLocal: false, isDefinition: true, scopeLine: 21, flags: DIFlagPrototyped, isOptimized: false, unit: !41, retainedNodes: !2)
!509 = !DILocation(line: 22, column: 23, scope: !508)
!510 = !DILocation(line: 22, column: 25, scope: !508)
!511 = !DILocation(line: 22, column: 14, scope: !508)
!512 = !DILocation(line: 22, column: 10, scope: !508)
!513 = !DILocation(line: 23, column: 10, scope: !508)
!514 = !DILocation(line: 23, column: 15, scope: !508)
!515 = !DILocation(line: 23, column: 17, scope: !508)
!516 = !DILocation(line: 23, column: 16, scope: !508)
!517 = !DILocation(line: 23, column: 12, scope: !508)
!518 = !DILocation(line: 23, column: 4, scope: !508)
!519 = !DILocation(line: 23, column: 8, scope: !508)
!520 = !DILocation(line: 24, column: 10, scope: !508)
!521 = !DILocation(line: 24, column: 3, scope: !508)
!522 = distinct !DISubprogram(name: "__divsi3", scope: !44, file: !44, line: 22, type: !116, isLocal: false, isDefinition: true, scopeLine: 23, flags: DIFlagPrototyped, isOptimized: false, unit: !43, retainedNodes: !2)
!523 = !DILocation(line: 24, column: 15, scope: !522)
!524 = !DILocation(line: 25, column: 18, scope: !522)
!525 = !DILocation(line: 25, column: 20, scope: !522)
!526 = !DILocation(line: 25, column: 12, scope: !522)
!527 = !DILocation(line: 26, column: 18, scope: !522)
!528 = !DILocation(line: 26, column: 20, scope: !522)
!529 = !DILocation(line: 26, column: 12, scope: !522)
!530 = !DILocation(line: 27, column: 10, scope: !522)
!531 = !DILocation(line: 27, column: 14, scope: !522)
!532 = !DILocation(line: 27, column: 12, scope: !522)
!533 = !DILocation(line: 27, column: 21, scope: !522)
!534 = !DILocation(line: 27, column: 19, scope: !522)
!535 = !DILocation(line: 27, column: 7, scope: !522)
!536 = !DILocation(line: 28, column: 10, scope: !522)
!537 = !DILocation(line: 28, column: 14, scope: !522)
!538 = !DILocation(line: 28, column: 12, scope: !522)
!539 = !DILocation(line: 28, column: 21, scope: !522)
!540 = !DILocation(line: 28, column: 19, scope: !522)
!541 = !DILocation(line: 28, column: 7, scope: !522)
!542 = !DILocation(line: 29, column: 12, scope: !522)
!543 = !DILocation(line: 29, column: 9, scope: !522)
!544 = !DILocation(line: 36, column: 21, scope: !522)
!545 = !DILocation(line: 36, column: 31, scope: !522)
!546 = !DILocation(line: 36, column: 22, scope: !522)
!547 = !DILocation(line: 36, column: 35, scope: !522)
!548 = !DILocation(line: 36, column: 33, scope: !522)
!549 = !DILocation(line: 36, column: 42, scope: !522)
!550 = !DILocation(line: 36, column: 40, scope: !522)
!551 = !DILocation(line: 36, column: 5, scope: !522)
!552 = distinct !DISubprogram(name: "__ffsdi2", scope: !48, file: !48, line: 22, type: !116, isLocal: false, isDefinition: true, scopeLine: 23, flags: DIFlagPrototyped, isOptimized: false, unit: !47, retainedNodes: !2)
!553 = !DILocation(line: 25, column: 13, scope: !552)
!554 = !DILocation(line: 25, column: 7, scope: !552)
!555 = !DILocation(line: 25, column: 11, scope: !552)
!556 = !DILocation(line: 26, column: 11, scope: !552)
!557 = !DILocation(line: 26, column: 13, scope: !552)
!558 = !DILocation(line: 26, column: 17, scope: !552)
!559 = !DILocation(line: 26, column: 9, scope: !552)
!560 = !DILocation(line: 28, column: 15, scope: !552)
!561 = !DILocation(line: 28, column: 17, scope: !552)
!562 = !DILocation(line: 28, column: 22, scope: !552)
!563 = !DILocation(line: 28, column: 13, scope: !552)
!564 = !DILocation(line: 29, column: 13, scope: !552)
!565 = !DILocation(line: 30, column: 32, scope: !552)
!566 = !DILocation(line: 30, column: 34, scope: !552)
!567 = !DILocation(line: 30, column: 16, scope: !552)
!568 = !DILocation(line: 30, column: 40, scope: !552)
!569 = !DILocation(line: 30, column: 9, scope: !552)
!570 = !DILocation(line: 32, column: 28, scope: !552)
!571 = !DILocation(line: 32, column: 30, scope: !552)
!572 = !DILocation(line: 32, column: 12, scope: !552)
!573 = !DILocation(line: 32, column: 35, scope: !552)
!574 = !DILocation(line: 32, column: 5, scope: !552)
!575 = !DILocation(line: 33, column: 1, scope: !552)
!576 = distinct !DISubprogram(name: "__ffssi2", scope: !50, file: !50, line: 22, type: !116, isLocal: false, isDefinition: true, scopeLine: 23, flags: DIFlagPrototyped, isOptimized: false, unit: !49, retainedNodes: !2)
!577 = !DILocation(line: 24, column: 9, scope: !576)
!578 = !DILocation(line: 24, column: 11, scope: !576)
!579 = !DILocation(line: 26, column: 9, scope: !576)
!580 = !DILocation(line: 28, column: 26, scope: !576)
!581 = !DILocation(line: 28, column: 12, scope: !576)
!582 = !DILocation(line: 28, column: 29, scope: !576)
!583 = !DILocation(line: 28, column: 5, scope: !576)
!584 = !DILocation(line: 29, column: 1, scope: !576)
!585 = distinct !DISubprogram(name: "compilerrt_abort_impl", scope: !54, file: !54, line: 57, type: !116, isLocal: false, isDefinition: true, scopeLine: 57, flags: DIFlagPrototyped, isOptimized: false, unit: !53, retainedNodes: !2)
!586 = !DILocation(line: 59, column: 1, scope: !585)
!587 = distinct !DISubprogram(name: "__lshrdi3", scope: !56, file: !56, line: 24, type: !116, isLocal: false, isDefinition: true, scopeLine: 25, flags: DIFlagPrototyped, isOptimized: false, unit: !55, retainedNodes: !2)
!588 = !DILocation(line: 26, column: 15, scope: !587)
!589 = !DILocation(line: 29, column: 17, scope: !587)
!590 = !DILocation(line: 29, column: 11, scope: !587)
!591 = !DILocation(line: 29, column: 15, scope: !587)
!592 = !DILocation(line: 30, column: 9, scope: !587)
!593 = !DILocation(line: 30, column: 11, scope: !587)
!594 = !DILocation(line: 32, column: 16, scope: !587)
!595 = !DILocation(line: 32, column: 18, scope: !587)
!596 = !DILocation(line: 32, column: 23, scope: !587)
!597 = !DILocation(line: 33, column: 30, scope: !587)
!598 = !DILocation(line: 33, column: 32, scope: !587)
!599 = !DILocation(line: 33, column: 41, scope: !587)
!600 = !DILocation(line: 33, column: 43, scope: !587)
!601 = !DILocation(line: 33, column: 37, scope: !587)
!602 = !DILocation(line: 33, column: 16, scope: !587)
!603 = !DILocation(line: 33, column: 18, scope: !587)
!604 = !DILocation(line: 33, column: 22, scope: !587)
!605 = !DILocation(line: 34, column: 5, scope: !587)
!606 = !DILocation(line: 37, column: 13, scope: !587)
!607 = !DILocation(line: 37, column: 15, scope: !587)
!608 = !DILocation(line: 38, column: 20, scope: !587)
!609 = !DILocation(line: 38, column: 13, scope: !587)
!610 = !DILocation(line: 39, column: 32, scope: !587)
!611 = !DILocation(line: 39, column: 34, scope: !587)
!612 = !DILocation(line: 39, column: 42, scope: !587)
!613 = !DILocation(line: 39, column: 39, scope: !587)
!614 = !DILocation(line: 39, column: 16, scope: !587)
!615 = !DILocation(line: 39, column: 18, scope: !587)
!616 = !DILocation(line: 39, column: 24, scope: !587)
!617 = !DILocation(line: 40, column: 31, scope: !587)
!618 = !DILocation(line: 40, column: 33, scope: !587)
!619 = !DILocation(line: 40, column: 57, scope: !587)
!620 = !DILocation(line: 40, column: 55, scope: !587)
!621 = !DILocation(line: 40, column: 38, scope: !587)
!622 = !DILocation(line: 40, column: 70, scope: !587)
!623 = !DILocation(line: 40, column: 72, scope: !587)
!624 = !DILocation(line: 40, column: 79, scope: !587)
!625 = !DILocation(line: 40, column: 76, scope: !587)
!626 = !DILocation(line: 40, column: 61, scope: !587)
!627 = !DILocation(line: 40, column: 16, scope: !587)
!628 = !DILocation(line: 40, column: 18, scope: !587)
!629 = !DILocation(line: 40, column: 22, scope: !587)
!630 = !DILocation(line: 42, column: 19, scope: !587)
!631 = !DILocation(line: 42, column: 5, scope: !587)
!632 = !DILocation(line: 43, column: 1, scope: !587)
!633 = distinct !DISubprogram(name: "__moddi3", scope: !60, file: !60, line: 20, type: !116, isLocal: false, isDefinition: true, scopeLine: 21, flags: DIFlagPrototyped, isOptimized: false, unit: !59, retainedNodes: !2)
!634 = !DILocation(line: 22, column: 15, scope: !633)
!635 = !DILocation(line: 23, column: 16, scope: !633)
!636 = !DILocation(line: 23, column: 18, scope: !633)
!637 = !DILocation(line: 23, column: 12, scope: !633)
!638 = !DILocation(line: 24, column: 10, scope: !633)
!639 = !DILocation(line: 24, column: 14, scope: !633)
!640 = !DILocation(line: 24, column: 12, scope: !633)
!641 = !DILocation(line: 24, column: 19, scope: !633)
!642 = !DILocation(line: 24, column: 17, scope: !633)
!643 = !DILocation(line: 24, column: 7, scope: !633)
!644 = !DILocation(line: 25, column: 9, scope: !633)
!645 = !DILocation(line: 25, column: 11, scope: !633)
!646 = !DILocation(line: 25, column: 7, scope: !633)
!647 = !DILocation(line: 26, column: 10, scope: !633)
!648 = !DILocation(line: 26, column: 14, scope: !633)
!649 = !DILocation(line: 26, column: 12, scope: !633)
!650 = !DILocation(line: 26, column: 19, scope: !633)
!651 = !DILocation(line: 26, column: 17, scope: !633)
!652 = !DILocation(line: 26, column: 7, scope: !633)
!653 = !DILocation(line: 28, column: 18, scope: !633)
!654 = !DILocation(line: 28, column: 21, scope: !633)
!655 = !DILocation(line: 28, column: 5, scope: !633)
!656 = !DILocation(line: 29, column: 21, scope: !633)
!657 = !DILocation(line: 29, column: 25, scope: !633)
!658 = !DILocation(line: 29, column: 23, scope: !633)
!659 = !DILocation(line: 29, column: 30, scope: !633)
!660 = !DILocation(line: 29, column: 28, scope: !633)
!661 = !DILocation(line: 29, column: 5, scope: !633)
!662 = distinct !DISubprogram(name: "__modsi3", scope: !62, file: !62, line: 20, type: !116, isLocal: false, isDefinition: true, scopeLine: 21, flags: DIFlagPrototyped, isOptimized: false, unit: !61, retainedNodes: !2)
!663 = !DILocation(line: 22, column: 12, scope: !662)
!664 = !DILocation(line: 22, column: 25, scope: !662)
!665 = !DILocation(line: 22, column: 28, scope: !662)
!666 = !DILocation(line: 22, column: 16, scope: !662)
!667 = !DILocation(line: 22, column: 33, scope: !662)
!668 = !DILocation(line: 22, column: 31, scope: !662)
!669 = !DILocation(line: 22, column: 14, scope: !662)
!670 = !DILocation(line: 22, column: 5, scope: !662)
!671 = distinct !DISubprogram(name: "__mulvdi3", scope: !66, file: !66, line: 22, type: !116, isLocal: false, isDefinition: true, scopeLine: 23, flags: DIFlagPrototyped, isOptimized: false, unit: !65, retainedNodes: !2)
!672 = !DILocation(line: 24, column: 15, scope: !671)
!673 = !DILocation(line: 25, column: 18, scope: !671)
!674 = !DILocation(line: 26, column: 18, scope: !671)
!675 = !DILocation(line: 27, column: 9, scope: !671)
!676 = !DILocation(line: 27, column: 11, scope: !671)
!677 = !DILocation(line: 29, column: 13, scope: !671)
!678 = !DILocation(line: 29, column: 15, scope: !671)
!679 = !DILocation(line: 29, column: 20, scope: !671)
!680 = !DILocation(line: 29, column: 23, scope: !671)
!681 = !DILocation(line: 29, column: 25, scope: !671)
!682 = !DILocation(line: 30, column: 20, scope: !671)
!683 = !DILocation(line: 30, column: 24, scope: !671)
!684 = !DILocation(line: 30, column: 22, scope: !671)
!685 = !DILocation(line: 30, column: 13, scope: !671)
!686 = !DILocation(line: 31, column: 9, scope: !671)
!687 = !DILocation(line: 33, column: 9, scope: !671)
!688 = !DILocation(line: 33, column: 11, scope: !671)
!689 = !DILocation(line: 35, column: 13, scope: !671)
!690 = !DILocation(line: 35, column: 15, scope: !671)
!691 = !DILocation(line: 35, column: 20, scope: !671)
!692 = !DILocation(line: 35, column: 23, scope: !671)
!693 = !DILocation(line: 35, column: 25, scope: !671)
!694 = !DILocation(line: 36, column: 20, scope: !671)
!695 = !DILocation(line: 36, column: 24, scope: !671)
!696 = !DILocation(line: 36, column: 22, scope: !671)
!697 = !DILocation(line: 36, column: 13, scope: !671)
!698 = !DILocation(line: 37, column: 9, scope: !671)
!699 = !DILocation(line: 39, column: 17, scope: !671)
!700 = !DILocation(line: 39, column: 19, scope: !671)
!701 = !DILocation(line: 39, column: 12, scope: !671)
!702 = !DILocation(line: 40, column: 21, scope: !671)
!703 = !DILocation(line: 40, column: 25, scope: !671)
!704 = !DILocation(line: 40, column: 23, scope: !671)
!705 = !DILocation(line: 40, column: 31, scope: !671)
!706 = !DILocation(line: 40, column: 29, scope: !671)
!707 = !DILocation(line: 40, column: 12, scope: !671)
!708 = !DILocation(line: 41, column: 17, scope: !671)
!709 = !DILocation(line: 41, column: 19, scope: !671)
!710 = !DILocation(line: 41, column: 12, scope: !671)
!711 = !DILocation(line: 42, column: 21, scope: !671)
!712 = !DILocation(line: 42, column: 25, scope: !671)
!713 = !DILocation(line: 42, column: 23, scope: !671)
!714 = !DILocation(line: 42, column: 31, scope: !671)
!715 = !DILocation(line: 42, column: 29, scope: !671)
!716 = !DILocation(line: 42, column: 12, scope: !671)
!717 = !DILocation(line: 43, column: 9, scope: !671)
!718 = !DILocation(line: 43, column: 15, scope: !671)
!719 = !DILocation(line: 43, column: 19, scope: !671)
!720 = !DILocation(line: 43, column: 22, scope: !671)
!721 = !DILocation(line: 43, column: 28, scope: !671)
!722 = !DILocation(line: 44, column: 16, scope: !671)
!723 = !DILocation(line: 44, column: 20, scope: !671)
!724 = !DILocation(line: 44, column: 18, scope: !671)
!725 = !DILocation(line: 44, column: 9, scope: !671)
!726 = !DILocation(line: 45, column: 9, scope: !671)
!727 = !DILocation(line: 45, column: 15, scope: !671)
!728 = !DILocation(line: 45, column: 12, scope: !671)
!729 = !DILocation(line: 47, column: 13, scope: !671)
!730 = !DILocation(line: 47, column: 27, scope: !671)
!731 = !DILocation(line: 47, column: 25, scope: !671)
!732 = !DILocation(line: 47, column: 19, scope: !671)
!733 = !DILocation(line: 48, column: 13, scope: !671)
!734 = !DILocation(line: 49, column: 5, scope: !671)
!735 = !DILocation(line: 52, column: 13, scope: !671)
!736 = !DILocation(line: 52, column: 28, scope: !671)
!737 = !DILocation(line: 52, column: 27, scope: !671)
!738 = !DILocation(line: 52, column: 25, scope: !671)
!739 = !DILocation(line: 52, column: 19, scope: !671)
!740 = !DILocation(line: 53, column: 13, scope: !671)
!741 = !DILocation(line: 55, column: 12, scope: !671)
!742 = !DILocation(line: 55, column: 16, scope: !671)
!743 = !DILocation(line: 55, column: 14, scope: !671)
!744 = !DILocation(line: 55, column: 5, scope: !671)
!745 = !DILocation(line: 56, column: 1, scope: !671)
!746 = distinct !DISubprogram(name: "__mulvsi3", scope: !68, file: !68, line: 22, type: !116, isLocal: false, isDefinition: true, scopeLine: 23, flags: DIFlagPrototyped, isOptimized: false, unit: !67, retainedNodes: !2)
!747 = !DILocation(line: 24, column: 15, scope: !746)
!748 = !DILocation(line: 25, column: 18, scope: !746)
!749 = !DILocation(line: 26, column: 18, scope: !746)
!750 = !DILocation(line: 27, column: 9, scope: !746)
!751 = !DILocation(line: 27, column: 11, scope: !746)
!752 = !DILocation(line: 29, column: 13, scope: !746)
!753 = !DILocation(line: 29, column: 15, scope: !746)
!754 = !DILocation(line: 29, column: 20, scope: !746)
!755 = !DILocation(line: 29, column: 23, scope: !746)
!756 = !DILocation(line: 29, column: 25, scope: !746)
!757 = !DILocation(line: 30, column: 20, scope: !746)
!758 = !DILocation(line: 30, column: 24, scope: !746)
!759 = !DILocation(line: 30, column: 22, scope: !746)
!760 = !DILocation(line: 30, column: 13, scope: !746)
!761 = !DILocation(line: 31, column: 9, scope: !746)
!762 = !DILocation(line: 33, column: 9, scope: !746)
!763 = !DILocation(line: 33, column: 11, scope: !746)
!764 = !DILocation(line: 35, column: 13, scope: !746)
!765 = !DILocation(line: 35, column: 15, scope: !746)
!766 = !DILocation(line: 35, column: 20, scope: !746)
!767 = !DILocation(line: 35, column: 23, scope: !746)
!768 = !DILocation(line: 35, column: 25, scope: !746)
!769 = !DILocation(line: 36, column: 20, scope: !746)
!770 = !DILocation(line: 36, column: 24, scope: !746)
!771 = !DILocation(line: 36, column: 22, scope: !746)
!772 = !DILocation(line: 36, column: 13, scope: !746)
!773 = !DILocation(line: 37, column: 9, scope: !746)
!774 = !DILocation(line: 39, column: 17, scope: !746)
!775 = !DILocation(line: 39, column: 19, scope: !746)
!776 = !DILocation(line: 39, column: 12, scope: !746)
!777 = !DILocation(line: 40, column: 21, scope: !746)
!778 = !DILocation(line: 40, column: 25, scope: !746)
!779 = !DILocation(line: 40, column: 23, scope: !746)
!780 = !DILocation(line: 40, column: 31, scope: !746)
!781 = !DILocation(line: 40, column: 29, scope: !746)
!782 = !DILocation(line: 40, column: 12, scope: !746)
!783 = !DILocation(line: 41, column: 17, scope: !746)
!784 = !DILocation(line: 41, column: 19, scope: !746)
!785 = !DILocation(line: 41, column: 12, scope: !746)
!786 = !DILocation(line: 42, column: 21, scope: !746)
!787 = !DILocation(line: 42, column: 25, scope: !746)
!788 = !DILocation(line: 42, column: 23, scope: !746)
!789 = !DILocation(line: 42, column: 31, scope: !746)
!790 = !DILocation(line: 42, column: 29, scope: !746)
!791 = !DILocation(line: 42, column: 12, scope: !746)
!792 = !DILocation(line: 43, column: 9, scope: !746)
!793 = !DILocation(line: 43, column: 15, scope: !746)
!794 = !DILocation(line: 43, column: 19, scope: !746)
!795 = !DILocation(line: 43, column: 22, scope: !746)
!796 = !DILocation(line: 43, column: 28, scope: !746)
!797 = !DILocation(line: 44, column: 16, scope: !746)
!798 = !DILocation(line: 44, column: 20, scope: !746)
!799 = !DILocation(line: 44, column: 18, scope: !746)
!800 = !DILocation(line: 44, column: 9, scope: !746)
!801 = !DILocation(line: 45, column: 9, scope: !746)
!802 = !DILocation(line: 45, column: 15, scope: !746)
!803 = !DILocation(line: 45, column: 12, scope: !746)
!804 = !DILocation(line: 47, column: 13, scope: !746)
!805 = !DILocation(line: 47, column: 27, scope: !746)
!806 = !DILocation(line: 47, column: 25, scope: !746)
!807 = !DILocation(line: 47, column: 19, scope: !746)
!808 = !DILocation(line: 48, column: 13, scope: !746)
!809 = !DILocation(line: 49, column: 5, scope: !746)
!810 = !DILocation(line: 52, column: 13, scope: !746)
!811 = !DILocation(line: 52, column: 28, scope: !746)
!812 = !DILocation(line: 52, column: 27, scope: !746)
!813 = !DILocation(line: 52, column: 25, scope: !746)
!814 = !DILocation(line: 52, column: 19, scope: !746)
!815 = !DILocation(line: 53, column: 13, scope: !746)
!816 = !DILocation(line: 55, column: 12, scope: !746)
!817 = !DILocation(line: 55, column: 16, scope: !746)
!818 = !DILocation(line: 55, column: 14, scope: !746)
!819 = !DILocation(line: 55, column: 5, scope: !746)
!820 = !DILocation(line: 56, column: 1, scope: !746)
!821 = distinct !DISubprogram(name: "__paritydi2", scope: !72, file: !72, line: 20, type: !116, isLocal: false, isDefinition: true, scopeLine: 21, flags: DIFlagPrototyped, isOptimized: false, unit: !71, retainedNodes: !2)
!822 = !DILocation(line: 23, column: 13, scope: !821)
!823 = !DILocation(line: 23, column: 7, scope: !821)
!824 = !DILocation(line: 23, column: 11, scope: !821)
!825 = !DILocation(line: 24, column: 26, scope: !821)
!826 = !DILocation(line: 24, column: 28, scope: !821)
!827 = !DILocation(line: 24, column: 37, scope: !821)
!828 = !DILocation(line: 24, column: 39, scope: !821)
!829 = !DILocation(line: 24, column: 33, scope: !821)
!830 = !DILocation(line: 24, column: 12, scope: !821)
!831 = !DILocation(line: 24, column: 5, scope: !821)
!832 = distinct !DISubprogram(name: "__paritysi2", scope: !74, file: !74, line: 20, type: !116, isLocal: false, isDefinition: true, scopeLine: 21, flags: DIFlagPrototyped, isOptimized: false, unit: !73, retainedNodes: !2)
!833 = !DILocation(line: 22, column: 24, scope: !832)
!834 = !DILocation(line: 22, column: 12, scope: !832)
!835 = !DILocation(line: 23, column: 10, scope: !832)
!836 = !DILocation(line: 23, column: 12, scope: !832)
!837 = !DILocation(line: 23, column: 7, scope: !832)
!838 = !DILocation(line: 24, column: 10, scope: !832)
!839 = !DILocation(line: 24, column: 12, scope: !832)
!840 = !DILocation(line: 24, column: 7, scope: !832)
!841 = !DILocation(line: 25, column: 10, scope: !832)
!842 = !DILocation(line: 25, column: 12, scope: !832)
!843 = !DILocation(line: 25, column: 7, scope: !832)
!844 = !DILocation(line: 26, column: 24, scope: !832)
!845 = !DILocation(line: 26, column: 26, scope: !832)
!846 = !DILocation(line: 26, column: 20, scope: !832)
!847 = !DILocation(line: 26, column: 34, scope: !832)
!848 = !DILocation(line: 26, column: 5, scope: !832)
!849 = distinct !DISubprogram(name: "__popcountdi2", scope: !78, file: !78, line: 20, type: !116, isLocal: false, isDefinition: true, scopeLine: 21, flags: DIFlagPrototyped, isOptimized: false, unit: !77, retainedNodes: !2)
!850 = !DILocation(line: 22, column: 25, scope: !849)
!851 = !DILocation(line: 22, column: 12, scope: !849)
!852 = !DILocation(line: 23, column: 10, scope: !849)
!853 = !DILocation(line: 23, column: 17, scope: !849)
!854 = !DILocation(line: 23, column: 20, scope: !849)
!855 = !DILocation(line: 23, column: 26, scope: !849)
!856 = !DILocation(line: 23, column: 13, scope: !849)
!857 = !DILocation(line: 23, column: 8, scope: !849)
!858 = !DILocation(line: 25, column: 12, scope: !849)
!859 = !DILocation(line: 25, column: 15, scope: !849)
!860 = !DILocation(line: 25, column: 21, scope: !849)
!861 = !DILocation(line: 25, column: 49, scope: !849)
!862 = !DILocation(line: 25, column: 52, scope: !849)
!863 = !DILocation(line: 25, column: 46, scope: !849)
!864 = !DILocation(line: 25, column: 8, scope: !849)
!865 = !DILocation(line: 27, column: 11, scope: !849)
!866 = !DILocation(line: 27, column: 17, scope: !849)
!867 = !DILocation(line: 27, column: 20, scope: !849)
!868 = !DILocation(line: 27, column: 14, scope: !849)
!869 = !DILocation(line: 27, column: 27, scope: !849)
!870 = !DILocation(line: 27, column: 8, scope: !849)
!871 = !DILocation(line: 29, column: 25, scope: !849)
!872 = !DILocation(line: 29, column: 31, scope: !849)
!873 = !DILocation(line: 29, column: 34, scope: !849)
!874 = !DILocation(line: 29, column: 28, scope: !849)
!875 = !DILocation(line: 29, column: 16, scope: !849)
!876 = !DILocation(line: 29, column: 12, scope: !849)
!877 = !DILocation(line: 32, column: 9, scope: !849)
!878 = !DILocation(line: 32, column: 14, scope: !849)
!879 = !DILocation(line: 32, column: 16, scope: !849)
!880 = !DILocation(line: 32, column: 11, scope: !849)
!881 = !DILocation(line: 32, column: 7, scope: !849)
!882 = !DILocation(line: 35, column: 13, scope: !849)
!883 = !DILocation(line: 35, column: 18, scope: !849)
!884 = !DILocation(line: 35, column: 20, scope: !849)
!885 = !DILocation(line: 35, column: 15, scope: !849)
!886 = !DILocation(line: 35, column: 27, scope: !849)
!887 = !DILocation(line: 35, column: 5, scope: !849)
!888 = distinct !DISubprogram(name: "__popcountsi2", scope: !80, file: !80, line: 20, type: !116, isLocal: false, isDefinition: true, scopeLine: 21, flags: DIFlagPrototyped, isOptimized: false, unit: !79, retainedNodes: !2)
!889 = !DILocation(line: 22, column: 24, scope: !888)
!890 = !DILocation(line: 22, column: 12, scope: !888)
!891 = !DILocation(line: 23, column: 9, scope: !888)
!892 = !DILocation(line: 23, column: 15, scope: !888)
!893 = !DILocation(line: 23, column: 17, scope: !888)
!894 = !DILocation(line: 23, column: 23, scope: !888)
!895 = !DILocation(line: 23, column: 11, scope: !888)
!896 = !DILocation(line: 23, column: 7, scope: !888)
!897 = !DILocation(line: 25, column: 11, scope: !888)
!898 = !DILocation(line: 25, column: 13, scope: !888)
!899 = !DILocation(line: 25, column: 19, scope: !888)
!900 = !DILocation(line: 25, column: 36, scope: !888)
!901 = !DILocation(line: 25, column: 38, scope: !888)
!902 = !DILocation(line: 25, column: 33, scope: !888)
!903 = !DILocation(line: 25, column: 7, scope: !888)
!904 = !DILocation(line: 27, column: 10, scope: !888)
!905 = !DILocation(line: 27, column: 15, scope: !888)
!906 = !DILocation(line: 27, column: 17, scope: !888)
!907 = !DILocation(line: 27, column: 12, scope: !888)
!908 = !DILocation(line: 27, column: 24, scope: !888)
!909 = !DILocation(line: 27, column: 7, scope: !888)
!910 = !DILocation(line: 29, column: 10, scope: !888)
!911 = !DILocation(line: 29, column: 15, scope: !888)
!912 = !DILocation(line: 29, column: 17, scope: !888)
!913 = !DILocation(line: 29, column: 12, scope: !888)
!914 = !DILocation(line: 29, column: 7, scope: !888)
!915 = !DILocation(line: 32, column: 13, scope: !888)
!916 = !DILocation(line: 32, column: 18, scope: !888)
!917 = !DILocation(line: 32, column: 20, scope: !888)
!918 = !DILocation(line: 32, column: 15, scope: !888)
!919 = !DILocation(line: 32, column: 27, scope: !888)
!920 = !DILocation(line: 32, column: 5, scope: !888)
!921 = distinct !DISubprogram(name: "__subvdi3", scope: !84, file: !84, line: 22, type: !116, isLocal: false, isDefinition: true, scopeLine: 23, flags: DIFlagPrototyped, isOptimized: false, unit: !83, retainedNodes: !2)
!922 = !DILocation(line: 24, column: 25, scope: !921)
!923 = !DILocation(line: 24, column: 38, scope: !921)
!924 = !DILocation(line: 24, column: 27, scope: !921)
!925 = !DILocation(line: 24, column: 12, scope: !921)
!926 = !DILocation(line: 25, column: 9, scope: !921)
!927 = !DILocation(line: 25, column: 11, scope: !921)
!928 = !DILocation(line: 27, column: 13, scope: !921)
!929 = !DILocation(line: 27, column: 17, scope: !921)
!930 = !DILocation(line: 27, column: 15, scope: !921)
!931 = !DILocation(line: 28, column: 13, scope: !921)
!932 = !DILocation(line: 29, column: 5, scope: !921)
!933 = !DILocation(line: 32, column: 13, scope: !921)
!934 = !DILocation(line: 32, column: 18, scope: !921)
!935 = !DILocation(line: 32, column: 15, scope: !921)
!936 = !DILocation(line: 33, column: 13, scope: !921)
!937 = !DILocation(line: 35, column: 12, scope: !921)
!938 = !DILocation(line: 35, column: 5, scope: !921)
!939 = distinct !DISubprogram(name: "__subvsi3", scope: !86, file: !86, line: 22, type: !116, isLocal: false, isDefinition: true, scopeLine: 23, flags: DIFlagPrototyped, isOptimized: false, unit: !85, retainedNodes: !2)
!940 = !DILocation(line: 24, column: 25, scope: !939)
!941 = !DILocation(line: 24, column: 38, scope: !939)
!942 = !DILocation(line: 24, column: 27, scope: !939)
!943 = !DILocation(line: 24, column: 12, scope: !939)
!944 = !DILocation(line: 25, column: 9, scope: !939)
!945 = !DILocation(line: 25, column: 11, scope: !939)
!946 = !DILocation(line: 27, column: 13, scope: !939)
!947 = !DILocation(line: 27, column: 17, scope: !939)
!948 = !DILocation(line: 27, column: 15, scope: !939)
!949 = !DILocation(line: 28, column: 13, scope: !939)
!950 = !DILocation(line: 29, column: 5, scope: !939)
!951 = !DILocation(line: 32, column: 13, scope: !939)
!952 = !DILocation(line: 32, column: 18, scope: !939)
!953 = !DILocation(line: 32, column: 15, scope: !939)
!954 = !DILocation(line: 33, column: 13, scope: !939)
!955 = !DILocation(line: 35, column: 12, scope: !939)
!956 = !DILocation(line: 35, column: 5, scope: !939)
!957 = distinct !DISubprogram(name: "__ucmpdi2", scope: !90, file: !90, line: 23, type: !116, isLocal: false, isDefinition: true, scopeLine: 24, flags: DIFlagPrototyped, isOptimized: false, unit: !89, retainedNodes: !2)
!958 = !DILocation(line: 26, column: 13, scope: !957)
!959 = !DILocation(line: 26, column: 7, scope: !957)
!960 = !DILocation(line: 26, column: 11, scope: !957)
!961 = !DILocation(line: 28, column: 13, scope: !957)
!962 = !DILocation(line: 28, column: 7, scope: !957)
!963 = !DILocation(line: 28, column: 11, scope: !957)
!964 = !DILocation(line: 29, column: 11, scope: !957)
!965 = !DILocation(line: 29, column: 13, scope: !957)
!966 = !DILocation(line: 29, column: 22, scope: !957)
!967 = !DILocation(line: 29, column: 24, scope: !957)
!968 = !DILocation(line: 29, column: 18, scope: !957)
!969 = !DILocation(line: 29, column: 9, scope: !957)
!970 = !DILocation(line: 30, column: 9, scope: !957)
!971 = !DILocation(line: 31, column: 11, scope: !957)
!972 = !DILocation(line: 31, column: 13, scope: !957)
!973 = !DILocation(line: 31, column: 22, scope: !957)
!974 = !DILocation(line: 31, column: 24, scope: !957)
!975 = !DILocation(line: 31, column: 18, scope: !957)
!976 = !DILocation(line: 31, column: 9, scope: !957)
!977 = !DILocation(line: 32, column: 9, scope: !957)
!978 = !DILocation(line: 33, column: 11, scope: !957)
!979 = !DILocation(line: 33, column: 13, scope: !957)
!980 = !DILocation(line: 33, column: 21, scope: !957)
!981 = !DILocation(line: 33, column: 23, scope: !957)
!982 = !DILocation(line: 33, column: 17, scope: !957)
!983 = !DILocation(line: 33, column: 9, scope: !957)
!984 = !DILocation(line: 34, column: 9, scope: !957)
!985 = !DILocation(line: 35, column: 11, scope: !957)
!986 = !DILocation(line: 35, column: 13, scope: !957)
!987 = !DILocation(line: 35, column: 21, scope: !957)
!988 = !DILocation(line: 35, column: 23, scope: !957)
!989 = !DILocation(line: 35, column: 17, scope: !957)
!990 = !DILocation(line: 35, column: 9, scope: !957)
!991 = !DILocation(line: 36, column: 9, scope: !957)
!992 = !DILocation(line: 37, column: 5, scope: !957)
!993 = !DILocation(line: 38, column: 1, scope: !957)
!994 = distinct !DISubprogram(name: "__udivdi3", scope: !94, file: !94, line: 20, type: !116, isLocal: false, isDefinition: true, scopeLine: 21, flags: DIFlagPrototyped, isOptimized: false, unit: !93, retainedNodes: !2)
!995 = !DILocation(line: 22, column: 25, scope: !994)
!996 = !DILocation(line: 22, column: 28, scope: !994)
!997 = !DILocation(line: 22, column: 12, scope: !994)
!998 = !DILocation(line: 22, column: 5, scope: !994)
!999 = distinct !DISubprogram(name: "__udivmoddi4", scope: !96, file: !96, line: 24, type: !116, isLocal: false, isDefinition: true, scopeLine: 25, flags: DIFlagPrototyped, isOptimized: false, unit: !95, retainedNodes: !2)
!1000 = !DILocation(line: 26, column: 20, scope: !999)
!1001 = !DILocation(line: 27, column: 20, scope: !999)
!1002 = !DILocation(line: 29, column: 13, scope: !999)
!1003 = !DILocation(line: 29, column: 7, scope: !999)
!1004 = !DILocation(line: 29, column: 11, scope: !999)
!1005 = !DILocation(line: 31, column: 13, scope: !999)
!1006 = !DILocation(line: 31, column: 7, scope: !999)
!1007 = !DILocation(line: 31, column: 11, scope: !999)
!1008 = !DILocation(line: 36, column: 11, scope: !999)
!1009 = !DILocation(line: 36, column: 13, scope: !999)
!1010 = !DILocation(line: 36, column: 18, scope: !999)
!1011 = !DILocation(line: 36, column: 9, scope: !999)
!1012 = !DILocation(line: 38, column: 15, scope: !999)
!1013 = !DILocation(line: 38, column: 17, scope: !999)
!1014 = !DILocation(line: 38, column: 22, scope: !999)
!1015 = !DILocation(line: 38, column: 13, scope: !999)
!1016 = !DILocation(line: 44, column: 17, scope: !999)
!1017 = !DILocation(line: 45, column: 26, scope: !999)
!1018 = !DILocation(line: 45, column: 28, scope: !999)
!1019 = !DILocation(line: 45, column: 36, scope: !999)
!1020 = !DILocation(line: 45, column: 38, scope: !999)
!1021 = !DILocation(line: 45, column: 32, scope: !999)
!1022 = !DILocation(line: 45, column: 24, scope: !999)
!1023 = !DILocation(line: 45, column: 18, scope: !999)
!1024 = !DILocation(line: 45, column: 22, scope: !999)
!1025 = !DILocation(line: 45, column: 17, scope: !999)
!1026 = !DILocation(line: 46, column: 22, scope: !999)
!1027 = !DILocation(line: 46, column: 24, scope: !999)
!1028 = !DILocation(line: 46, column: 32, scope: !999)
!1029 = !DILocation(line: 46, column: 34, scope: !999)
!1030 = !DILocation(line: 46, column: 28, scope: !999)
!1031 = !DILocation(line: 46, column: 20, scope: !999)
!1032 = !DILocation(line: 46, column: 13, scope: !999)
!1033 = !DILocation(line: 52, column: 13, scope: !999)
!1034 = !DILocation(line: 53, column: 22, scope: !999)
!1035 = !DILocation(line: 53, column: 24, scope: !999)
!1036 = !DILocation(line: 53, column: 20, scope: !999)
!1037 = !DILocation(line: 53, column: 14, scope: !999)
!1038 = !DILocation(line: 53, column: 18, scope: !999)
!1039 = !DILocation(line: 53, column: 13, scope: !999)
!1040 = !DILocation(line: 54, column: 9, scope: !999)
!1041 = !DILocation(line: 57, column: 11, scope: !999)
!1042 = !DILocation(line: 57, column: 13, scope: !999)
!1043 = !DILocation(line: 57, column: 17, scope: !999)
!1044 = !DILocation(line: 57, column: 9, scope: !999)
!1045 = !DILocation(line: 59, column: 15, scope: !999)
!1046 = !DILocation(line: 59, column: 17, scope: !999)
!1047 = !DILocation(line: 59, column: 22, scope: !999)
!1048 = !DILocation(line: 59, column: 13, scope: !999)
!1049 = !DILocation(line: 65, column: 17, scope: !999)
!1050 = !DILocation(line: 66, column: 26, scope: !999)
!1051 = !DILocation(line: 66, column: 28, scope: !999)
!1052 = !DILocation(line: 66, column: 37, scope: !999)
!1053 = !DILocation(line: 66, column: 39, scope: !999)
!1054 = !DILocation(line: 66, column: 33, scope: !999)
!1055 = !DILocation(line: 66, column: 24, scope: !999)
!1056 = !DILocation(line: 66, column: 18, scope: !999)
!1057 = !DILocation(line: 66, column: 22, scope: !999)
!1058 = !DILocation(line: 66, column: 17, scope: !999)
!1059 = !DILocation(line: 67, column: 22, scope: !999)
!1060 = !DILocation(line: 67, column: 24, scope: !999)
!1061 = !DILocation(line: 67, column: 33, scope: !999)
!1062 = !DILocation(line: 67, column: 35, scope: !999)
!1063 = !DILocation(line: 67, column: 29, scope: !999)
!1064 = !DILocation(line: 67, column: 20, scope: !999)
!1065 = !DILocation(line: 67, column: 13, scope: !999)
!1066 = !DILocation(line: 70, column: 15, scope: !999)
!1067 = !DILocation(line: 70, column: 17, scope: !999)
!1068 = !DILocation(line: 70, column: 21, scope: !999)
!1069 = !DILocation(line: 70, column: 13, scope: !999)
!1070 = !DILocation(line: 76, column: 17, scope: !999)
!1071 = !DILocation(line: 78, column: 30, scope: !999)
!1072 = !DILocation(line: 78, column: 32, scope: !999)
!1073 = !DILocation(line: 78, column: 41, scope: !999)
!1074 = !DILocation(line: 78, column: 43, scope: !999)
!1075 = !DILocation(line: 78, column: 37, scope: !999)
!1076 = !DILocation(line: 78, column: 19, scope: !999)
!1077 = !DILocation(line: 78, column: 21, scope: !999)
!1078 = !DILocation(line: 78, column: 26, scope: !999)
!1079 = !DILocation(line: 79, column: 19, scope: !999)
!1080 = !DILocation(line: 79, column: 21, scope: !999)
!1081 = !DILocation(line: 79, column: 25, scope: !999)
!1082 = !DILocation(line: 80, column: 26, scope: !999)
!1083 = !DILocation(line: 80, column: 18, scope: !999)
!1084 = !DILocation(line: 80, column: 22, scope: !999)
!1085 = !DILocation(line: 81, column: 13, scope: !999)
!1086 = !DILocation(line: 82, column: 22, scope: !999)
!1087 = !DILocation(line: 82, column: 24, scope: !999)
!1088 = !DILocation(line: 82, column: 33, scope: !999)
!1089 = !DILocation(line: 82, column: 35, scope: !999)
!1090 = !DILocation(line: 82, column: 29, scope: !999)
!1091 = !DILocation(line: 82, column: 20, scope: !999)
!1092 = !DILocation(line: 82, column: 13, scope: !999)
!1093 = !DILocation(line: 88, column: 16, scope: !999)
!1094 = !DILocation(line: 88, column: 18, scope: !999)
!1095 = !DILocation(line: 88, column: 28, scope: !999)
!1096 = !DILocation(line: 88, column: 30, scope: !999)
!1097 = !DILocation(line: 88, column: 35, scope: !999)
!1098 = !DILocation(line: 88, column: 23, scope: !999)
!1099 = !DILocation(line: 88, column: 41, scope: !999)
!1100 = !DILocation(line: 88, column: 13, scope: !999)
!1101 = !DILocation(line: 90, column: 17, scope: !999)
!1102 = !DILocation(line: 92, column: 29, scope: !999)
!1103 = !DILocation(line: 92, column: 31, scope: !999)
!1104 = !DILocation(line: 92, column: 19, scope: !999)
!1105 = !DILocation(line: 92, column: 21, scope: !999)
!1106 = !DILocation(line: 92, column: 25, scope: !999)
!1107 = !DILocation(line: 93, column: 30, scope: !999)
!1108 = !DILocation(line: 93, column: 32, scope: !999)
!1109 = !DILocation(line: 93, column: 42, scope: !999)
!1110 = !DILocation(line: 93, column: 44, scope: !999)
!1111 = !DILocation(line: 93, column: 49, scope: !999)
!1112 = !DILocation(line: 93, column: 37, scope: !999)
!1113 = !DILocation(line: 93, column: 19, scope: !999)
!1114 = !DILocation(line: 93, column: 21, scope: !999)
!1115 = !DILocation(line: 93, column: 26, scope: !999)
!1116 = !DILocation(line: 94, column: 26, scope: !999)
!1117 = !DILocation(line: 94, column: 18, scope: !999)
!1118 = !DILocation(line: 94, column: 22, scope: !999)
!1119 = !DILocation(line: 95, column: 13, scope: !999)
!1120 = !DILocation(line: 96, column: 22, scope: !999)
!1121 = !DILocation(line: 96, column: 24, scope: !999)
!1122 = !DILocation(line: 96, column: 48, scope: !999)
!1123 = !DILocation(line: 96, column: 50, scope: !999)
!1124 = !DILocation(line: 96, column: 32, scope: !999)
!1125 = !DILocation(line: 96, column: 29, scope: !999)
!1126 = !DILocation(line: 96, column: 20, scope: !999)
!1127 = !DILocation(line: 96, column: 13, scope: !999)
!1128 = !DILocation(line: 102, column: 30, scope: !999)
!1129 = !DILocation(line: 102, column: 32, scope: !999)
!1130 = !DILocation(line: 102, column: 14, scope: !999)
!1131 = !DILocation(line: 102, column: 56, scope: !999)
!1132 = !DILocation(line: 102, column: 58, scope: !999)
!1133 = !DILocation(line: 102, column: 40, scope: !999)
!1134 = !DILocation(line: 102, column: 38, scope: !999)
!1135 = !DILocation(line: 102, column: 12, scope: !999)
!1136 = !DILocation(line: 104, column: 13, scope: !999)
!1137 = !DILocation(line: 104, column: 16, scope: !999)
!1138 = !DILocation(line: 106, column: 16, scope: !999)
!1139 = !DILocation(line: 107, column: 26, scope: !999)
!1140 = !DILocation(line: 107, column: 18, scope: !999)
!1141 = !DILocation(line: 107, column: 22, scope: !999)
!1142 = !DILocation(line: 107, column: 17, scope: !999)
!1143 = !DILocation(line: 108, column: 13, scope: !999)
!1144 = !DILocation(line: 110, column: 9, scope: !999)
!1145 = !DILocation(line: 113, column: 11, scope: !999)
!1146 = !DILocation(line: 113, column: 13, scope: !999)
!1147 = !DILocation(line: 113, column: 17, scope: !999)
!1148 = !DILocation(line: 114, column: 22, scope: !999)
!1149 = !DILocation(line: 114, column: 24, scope: !999)
!1150 = !DILocation(line: 114, column: 47, scope: !999)
!1151 = !DILocation(line: 114, column: 45, scope: !999)
!1152 = !DILocation(line: 114, column: 28, scope: !999)
!1153 = !DILocation(line: 114, column: 11, scope: !999)
!1154 = !DILocation(line: 114, column: 13, scope: !999)
!1155 = !DILocation(line: 114, column: 18, scope: !999)
!1156 = !DILocation(line: 116, column: 22, scope: !999)
!1157 = !DILocation(line: 116, column: 24, scope: !999)
!1158 = !DILocation(line: 116, column: 32, scope: !999)
!1159 = !DILocation(line: 116, column: 29, scope: !999)
!1160 = !DILocation(line: 116, column: 11, scope: !999)
!1161 = !DILocation(line: 116, column: 13, scope: !999)
!1162 = !DILocation(line: 116, column: 18, scope: !999)
!1163 = !DILocation(line: 117, column: 22, scope: !999)
!1164 = !DILocation(line: 117, column: 24, scope: !999)
!1165 = !DILocation(line: 117, column: 48, scope: !999)
!1166 = !DILocation(line: 117, column: 46, scope: !999)
!1167 = !DILocation(line: 117, column: 29, scope: !999)
!1168 = !DILocation(line: 117, column: 58, scope: !999)
!1169 = !DILocation(line: 117, column: 60, scope: !999)
!1170 = !DILocation(line: 117, column: 67, scope: !999)
!1171 = !DILocation(line: 117, column: 64, scope: !999)
!1172 = !DILocation(line: 117, column: 53, scope: !999)
!1173 = !DILocation(line: 117, column: 11, scope: !999)
!1174 = !DILocation(line: 117, column: 13, scope: !999)
!1175 = !DILocation(line: 117, column: 17, scope: !999)
!1176 = !DILocation(line: 118, column: 5, scope: !999)
!1177 = !DILocation(line: 121, column: 15, scope: !999)
!1178 = !DILocation(line: 121, column: 17, scope: !999)
!1179 = !DILocation(line: 121, column: 22, scope: !999)
!1180 = !DILocation(line: 121, column: 13, scope: !999)
!1181 = !DILocation(line: 127, column: 20, scope: !999)
!1182 = !DILocation(line: 127, column: 22, scope: !999)
!1183 = !DILocation(line: 127, column: 31, scope: !999)
!1184 = !DILocation(line: 127, column: 33, scope: !999)
!1185 = !DILocation(line: 127, column: 37, scope: !999)
!1186 = !DILocation(line: 127, column: 26, scope: !999)
!1187 = !DILocation(line: 127, column: 43, scope: !999)
!1188 = !DILocation(line: 127, column: 17, scope: !999)
!1189 = !DILocation(line: 129, column: 21, scope: !999)
!1190 = !DILocation(line: 130, column: 30, scope: !999)
!1191 = !DILocation(line: 130, column: 32, scope: !999)
!1192 = !DILocation(line: 130, column: 41, scope: !999)
!1193 = !DILocation(line: 130, column: 43, scope: !999)
!1194 = !DILocation(line: 130, column: 47, scope: !999)
!1195 = !DILocation(line: 130, column: 36, scope: !999)
!1196 = !DILocation(line: 130, column: 28, scope: !999)
!1197 = !DILocation(line: 130, column: 22, scope: !999)
!1198 = !DILocation(line: 130, column: 26, scope: !999)
!1199 = !DILocation(line: 130, column: 21, scope: !999)
!1200 = !DILocation(line: 131, column: 23, scope: !999)
!1201 = !DILocation(line: 131, column: 25, scope: !999)
!1202 = !DILocation(line: 131, column: 29, scope: !999)
!1203 = !DILocation(line: 131, column: 21, scope: !999)
!1204 = !DILocation(line: 132, column: 30, scope: !999)
!1205 = !DILocation(line: 132, column: 21, scope: !999)
!1206 = !DILocation(line: 133, column: 38, scope: !999)
!1207 = !DILocation(line: 133, column: 40, scope: !999)
!1208 = !DILocation(line: 133, column: 22, scope: !999)
!1209 = !DILocation(line: 133, column: 20, scope: !999)
!1210 = !DILocation(line: 134, column: 30, scope: !999)
!1211 = !DILocation(line: 134, column: 32, scope: !999)
!1212 = !DILocation(line: 134, column: 40, scope: !999)
!1213 = !DILocation(line: 134, column: 37, scope: !999)
!1214 = !DILocation(line: 134, column: 19, scope: !999)
!1215 = !DILocation(line: 134, column: 21, scope: !999)
!1216 = !DILocation(line: 134, column: 26, scope: !999)
!1217 = !DILocation(line: 135, column: 30, scope: !999)
!1218 = !DILocation(line: 135, column: 32, scope: !999)
!1219 = !DILocation(line: 135, column: 56, scope: !999)
!1220 = !DILocation(line: 135, column: 54, scope: !999)
!1221 = !DILocation(line: 135, column: 37, scope: !999)
!1222 = !DILocation(line: 135, column: 66, scope: !999)
!1223 = !DILocation(line: 135, column: 68, scope: !999)
!1224 = !DILocation(line: 135, column: 75, scope: !999)
!1225 = !DILocation(line: 135, column: 72, scope: !999)
!1226 = !DILocation(line: 135, column: 61, scope: !999)
!1227 = !DILocation(line: 135, column: 19, scope: !999)
!1228 = !DILocation(line: 135, column: 21, scope: !999)
!1229 = !DILocation(line: 135, column: 25, scope: !999)
!1230 = !DILocation(line: 136, column: 26, scope: !999)
!1231 = !DILocation(line: 136, column: 17, scope: !999)
!1232 = !DILocation(line: 142, column: 53, scope: !999)
!1233 = !DILocation(line: 142, column: 55, scope: !999)
!1234 = !DILocation(line: 142, column: 37, scope: !999)
!1235 = !DILocation(line: 142, column: 35, scope: !999)
!1236 = !DILocation(line: 142, column: 78, scope: !999)
!1237 = !DILocation(line: 142, column: 80, scope: !999)
!1238 = !DILocation(line: 142, column: 62, scope: !999)
!1239 = !DILocation(line: 142, column: 60, scope: !999)
!1240 = !DILocation(line: 142, column: 16, scope: !999)
!1241 = !DILocation(line: 147, column: 17, scope: !999)
!1242 = !DILocation(line: 147, column: 20, scope: !999)
!1243 = !DILocation(line: 149, column: 19, scope: !999)
!1244 = !DILocation(line: 149, column: 21, scope: !999)
!1245 = !DILocation(line: 149, column: 25, scope: !999)
!1246 = !DILocation(line: 150, column: 30, scope: !999)
!1247 = !DILocation(line: 150, column: 32, scope: !999)
!1248 = !DILocation(line: 150, column: 19, scope: !999)
!1249 = !DILocation(line: 150, column: 21, scope: !999)
!1250 = !DILocation(line: 150, column: 26, scope: !999)
!1251 = !DILocation(line: 151, column: 19, scope: !999)
!1252 = !DILocation(line: 151, column: 21, scope: !999)
!1253 = !DILocation(line: 151, column: 26, scope: !999)
!1254 = !DILocation(line: 152, column: 29, scope: !999)
!1255 = !DILocation(line: 152, column: 31, scope: !999)
!1256 = !DILocation(line: 152, column: 19, scope: !999)
!1257 = !DILocation(line: 152, column: 21, scope: !999)
!1258 = !DILocation(line: 152, column: 25, scope: !999)
!1259 = !DILocation(line: 153, column: 13, scope: !999)
!1260 = !DILocation(line: 154, column: 22, scope: !999)
!1261 = !DILocation(line: 154, column: 25, scope: !999)
!1262 = !DILocation(line: 156, column: 19, scope: !999)
!1263 = !DILocation(line: 156, column: 21, scope: !999)
!1264 = !DILocation(line: 156, column: 25, scope: !999)
!1265 = !DILocation(line: 157, column: 30, scope: !999)
!1266 = !DILocation(line: 157, column: 32, scope: !999)
!1267 = !DILocation(line: 157, column: 55, scope: !999)
!1268 = !DILocation(line: 157, column: 53, scope: !999)
!1269 = !DILocation(line: 157, column: 36, scope: !999)
!1270 = !DILocation(line: 157, column: 19, scope: !999)
!1271 = !DILocation(line: 157, column: 21, scope: !999)
!1272 = !DILocation(line: 157, column: 26, scope: !999)
!1273 = !DILocation(line: 158, column: 30, scope: !999)
!1274 = !DILocation(line: 158, column: 32, scope: !999)
!1275 = !DILocation(line: 158, column: 40, scope: !999)
!1276 = !DILocation(line: 158, column: 37, scope: !999)
!1277 = !DILocation(line: 158, column: 19, scope: !999)
!1278 = !DILocation(line: 158, column: 21, scope: !999)
!1279 = !DILocation(line: 158, column: 26, scope: !999)
!1280 = !DILocation(line: 159, column: 30, scope: !999)
!1281 = !DILocation(line: 159, column: 32, scope: !999)
!1282 = !DILocation(line: 159, column: 56, scope: !999)
!1283 = !DILocation(line: 159, column: 54, scope: !999)
!1284 = !DILocation(line: 159, column: 37, scope: !999)
!1285 = !DILocation(line: 159, column: 66, scope: !999)
!1286 = !DILocation(line: 159, column: 68, scope: !999)
!1287 = !DILocation(line: 159, column: 75, scope: !999)
!1288 = !DILocation(line: 159, column: 72, scope: !999)
!1289 = !DILocation(line: 159, column: 61, scope: !999)
!1290 = !DILocation(line: 159, column: 19, scope: !999)
!1291 = !DILocation(line: 159, column: 21, scope: !999)
!1292 = !DILocation(line: 159, column: 25, scope: !999)
!1293 = !DILocation(line: 160, column: 13, scope: !999)
!1294 = !DILocation(line: 163, column: 29, scope: !999)
!1295 = !DILocation(line: 163, column: 31, scope: !999)
!1296 = !DILocation(line: 163, column: 55, scope: !999)
!1297 = !DILocation(line: 163, column: 53, scope: !999)
!1298 = !DILocation(line: 163, column: 35, scope: !999)
!1299 = !DILocation(line: 163, column: 19, scope: !999)
!1300 = !DILocation(line: 163, column: 21, scope: !999)
!1301 = !DILocation(line: 163, column: 25, scope: !999)
!1302 = !DILocation(line: 164, column: 31, scope: !999)
!1303 = !DILocation(line: 164, column: 33, scope: !999)
!1304 = !DILocation(line: 164, column: 58, scope: !999)
!1305 = !DILocation(line: 164, column: 56, scope: !999)
!1306 = !DILocation(line: 164, column: 38, scope: !999)
!1307 = !DILocation(line: 165, column: 31, scope: !999)
!1308 = !DILocation(line: 165, column: 33, scope: !999)
!1309 = !DILocation(line: 165, column: 41, scope: !999)
!1310 = !DILocation(line: 165, column: 44, scope: !999)
!1311 = !DILocation(line: 165, column: 37, scope: !999)
!1312 = !DILocation(line: 164, column: 63, scope: !999)
!1313 = !DILocation(line: 164, column: 19, scope: !999)
!1314 = !DILocation(line: 164, column: 21, scope: !999)
!1315 = !DILocation(line: 164, column: 26, scope: !999)
!1316 = !DILocation(line: 166, column: 19, scope: !999)
!1317 = !DILocation(line: 166, column: 21, scope: !999)
!1318 = !DILocation(line: 166, column: 26, scope: !999)
!1319 = !DILocation(line: 167, column: 29, scope: !999)
!1320 = !DILocation(line: 167, column: 31, scope: !999)
!1321 = !DILocation(line: 167, column: 40, scope: !999)
!1322 = !DILocation(line: 167, column: 43, scope: !999)
!1323 = !DILocation(line: 167, column: 36, scope: !999)
!1324 = !DILocation(line: 167, column: 19, scope: !999)
!1325 = !DILocation(line: 167, column: 21, scope: !999)
!1326 = !DILocation(line: 167, column: 25, scope: !999)
!1327 = !DILocation(line: 169, column: 9, scope: !999)
!1328 = !DILocation(line: 176, column: 34, scope: !999)
!1329 = !DILocation(line: 176, column: 36, scope: !999)
!1330 = !DILocation(line: 176, column: 18, scope: !999)
!1331 = !DILocation(line: 176, column: 60, scope: !999)
!1332 = !DILocation(line: 176, column: 62, scope: !999)
!1333 = !DILocation(line: 176, column: 44, scope: !999)
!1334 = !DILocation(line: 176, column: 42, scope: !999)
!1335 = !DILocation(line: 176, column: 16, scope: !999)
!1336 = !DILocation(line: 178, column: 17, scope: !999)
!1337 = !DILocation(line: 178, column: 20, scope: !999)
!1338 = !DILocation(line: 180, column: 21, scope: !999)
!1339 = !DILocation(line: 181, column: 30, scope: !999)
!1340 = !DILocation(line: 181, column: 22, scope: !999)
!1341 = !DILocation(line: 181, column: 26, scope: !999)
!1342 = !DILocation(line: 181, column: 21, scope: !999)
!1343 = !DILocation(line: 182, column: 17, scope: !999)
!1344 = !DILocation(line: 184, column: 13, scope: !999)
!1345 = !DILocation(line: 187, column: 15, scope: !999)
!1346 = !DILocation(line: 187, column: 17, scope: !999)
!1347 = !DILocation(line: 187, column: 21, scope: !999)
!1348 = !DILocation(line: 188, column: 17, scope: !999)
!1349 = !DILocation(line: 188, column: 20, scope: !999)
!1350 = !DILocation(line: 190, column: 30, scope: !999)
!1351 = !DILocation(line: 190, column: 32, scope: !999)
!1352 = !DILocation(line: 190, column: 19, scope: !999)
!1353 = !DILocation(line: 190, column: 21, scope: !999)
!1354 = !DILocation(line: 190, column: 26, scope: !999)
!1355 = !DILocation(line: 191, column: 19, scope: !999)
!1356 = !DILocation(line: 191, column: 21, scope: !999)
!1357 = !DILocation(line: 191, column: 26, scope: !999)
!1358 = !DILocation(line: 192, column: 29, scope: !999)
!1359 = !DILocation(line: 192, column: 31, scope: !999)
!1360 = !DILocation(line: 192, column: 19, scope: !999)
!1361 = !DILocation(line: 192, column: 21, scope: !999)
!1362 = !DILocation(line: 192, column: 25, scope: !999)
!1363 = !DILocation(line: 193, column: 13, scope: !999)
!1364 = !DILocation(line: 196, column: 30, scope: !999)
!1365 = !DILocation(line: 196, column: 32, scope: !999)
!1366 = !DILocation(line: 196, column: 55, scope: !999)
!1367 = !DILocation(line: 196, column: 53, scope: !999)
!1368 = !DILocation(line: 196, column: 36, scope: !999)
!1369 = !DILocation(line: 196, column: 19, scope: !999)
!1370 = !DILocation(line: 196, column: 21, scope: !999)
!1371 = !DILocation(line: 196, column: 26, scope: !999)
!1372 = !DILocation(line: 197, column: 30, scope: !999)
!1373 = !DILocation(line: 197, column: 32, scope: !999)
!1374 = !DILocation(line: 197, column: 40, scope: !999)
!1375 = !DILocation(line: 197, column: 37, scope: !999)
!1376 = !DILocation(line: 197, column: 19, scope: !999)
!1377 = !DILocation(line: 197, column: 21, scope: !999)
!1378 = !DILocation(line: 197, column: 26, scope: !999)
!1379 = !DILocation(line: 198, column: 30, scope: !999)
!1380 = !DILocation(line: 198, column: 32, scope: !999)
!1381 = !DILocation(line: 198, column: 56, scope: !999)
!1382 = !DILocation(line: 198, column: 54, scope: !999)
!1383 = !DILocation(line: 198, column: 37, scope: !999)
!1384 = !DILocation(line: 198, column: 66, scope: !999)
!1385 = !DILocation(line: 198, column: 68, scope: !999)
!1386 = !DILocation(line: 198, column: 75, scope: !999)
!1387 = !DILocation(line: 198, column: 72, scope: !999)
!1388 = !DILocation(line: 198, column: 61, scope: !999)
!1389 = !DILocation(line: 198, column: 19, scope: !999)
!1390 = !DILocation(line: 198, column: 21, scope: !999)
!1391 = !DILocation(line: 198, column: 25, scope: !999)
!1392 = !DILocation(line: 208, column: 12, scope: !999)
!1393 = !DILocation(line: 209, column: 5, scope: !999)
!1394 = !DILocation(line: 209, column: 12, scope: !999)
!1395 = !DILocation(line: 209, column: 15, scope: !999)
!1396 = !DILocation(line: 212, column: 23, scope: !999)
!1397 = !DILocation(line: 212, column: 25, scope: !999)
!1398 = !DILocation(line: 212, column: 30, scope: !999)
!1399 = !DILocation(line: 212, column: 41, scope: !999)
!1400 = !DILocation(line: 212, column: 43, scope: !999)
!1401 = !DILocation(line: 212, column: 48, scope: !999)
!1402 = !DILocation(line: 212, column: 36, scope: !999)
!1403 = !DILocation(line: 212, column: 11, scope: !999)
!1404 = !DILocation(line: 212, column: 13, scope: !999)
!1405 = !DILocation(line: 212, column: 18, scope: !999)
!1406 = !DILocation(line: 213, column: 23, scope: !999)
!1407 = !DILocation(line: 213, column: 25, scope: !999)
!1408 = !DILocation(line: 213, column: 30, scope: !999)
!1409 = !DILocation(line: 213, column: 41, scope: !999)
!1410 = !DILocation(line: 213, column: 43, scope: !999)
!1411 = !DILocation(line: 213, column: 48, scope: !999)
!1412 = !DILocation(line: 213, column: 36, scope: !999)
!1413 = !DILocation(line: 213, column: 11, scope: !999)
!1414 = !DILocation(line: 213, column: 13, scope: !999)
!1415 = !DILocation(line: 213, column: 18, scope: !999)
!1416 = !DILocation(line: 214, column: 23, scope: !999)
!1417 = !DILocation(line: 214, column: 25, scope: !999)
!1418 = !DILocation(line: 214, column: 30, scope: !999)
!1419 = !DILocation(line: 214, column: 41, scope: !999)
!1420 = !DILocation(line: 214, column: 43, scope: !999)
!1421 = !DILocation(line: 214, column: 48, scope: !999)
!1422 = !DILocation(line: 214, column: 36, scope: !999)
!1423 = !DILocation(line: 214, column: 11, scope: !999)
!1424 = !DILocation(line: 214, column: 13, scope: !999)
!1425 = !DILocation(line: 214, column: 18, scope: !999)
!1426 = !DILocation(line: 215, column: 23, scope: !999)
!1427 = !DILocation(line: 215, column: 25, scope: !999)
!1428 = !DILocation(line: 215, column: 30, scope: !999)
!1429 = !DILocation(line: 215, column: 38, scope: !999)
!1430 = !DILocation(line: 215, column: 36, scope: !999)
!1431 = !DILocation(line: 215, column: 11, scope: !999)
!1432 = !DILocation(line: 215, column: 13, scope: !999)
!1433 = !DILocation(line: 215, column: 18, scope: !999)
!1434 = !DILocation(line: 223, column: 37, scope: !999)
!1435 = !DILocation(line: 223, column: 45, scope: !999)
!1436 = !DILocation(line: 223, column: 41, scope: !999)
!1437 = !DILocation(line: 223, column: 49, scope: !999)
!1438 = !DILocation(line: 223, column: 54, scope: !999)
!1439 = !DILocation(line: 223, column: 22, scope: !999)
!1440 = !DILocation(line: 224, column: 17, scope: !999)
!1441 = !DILocation(line: 224, column: 19, scope: !999)
!1442 = !DILocation(line: 224, column: 15, scope: !999)
!1443 = !DILocation(line: 225, column: 20, scope: !999)
!1444 = !DILocation(line: 225, column: 26, scope: !999)
!1445 = !DILocation(line: 225, column: 24, scope: !999)
!1446 = !DILocation(line: 225, column: 11, scope: !999)
!1447 = !DILocation(line: 225, column: 15, scope: !999)
!1448 = !DILocation(line: 226, column: 5, scope: !999)
!1449 = !DILocation(line: 209, column: 20, scope: !999)
!1450 = distinct !{!1450, !1393, !1448}
!1451 = !DILocation(line: 227, column: 16, scope: !999)
!1452 = !DILocation(line: 227, column: 20, scope: !999)
!1453 = !DILocation(line: 227, column: 28, scope: !999)
!1454 = !DILocation(line: 227, column: 26, scope: !999)
!1455 = !DILocation(line: 227, column: 7, scope: !999)
!1456 = !DILocation(line: 227, column: 11, scope: !999)
!1457 = !DILocation(line: 228, column: 9, scope: !999)
!1458 = !DILocation(line: 229, column: 18, scope: !999)
!1459 = !DILocation(line: 229, column: 10, scope: !999)
!1460 = !DILocation(line: 229, column: 14, scope: !999)
!1461 = !DILocation(line: 229, column: 9, scope: !999)
!1462 = !DILocation(line: 230, column: 14, scope: !999)
!1463 = !DILocation(line: 230, column: 5, scope: !999)
!1464 = !DILocation(line: 231, column: 1, scope: !999)
!1465 = distinct !DISubprogram(name: "__udivmodsi4", scope: !98, file: !98, line: 20, type: !116, isLocal: false, isDefinition: true, scopeLine: 21, flags: DIFlagPrototyped, isOptimized: false, unit: !97, retainedNodes: !2)
!1466 = !DILocation(line: 22, column: 24, scope: !1465)
!1467 = !DILocation(line: 22, column: 26, scope: !1465)
!1468 = !DILocation(line: 22, column: 14, scope: !1465)
!1469 = !DILocation(line: 22, column: 10, scope: !1465)
!1470 = !DILocation(line: 23, column: 10, scope: !1465)
!1471 = !DILocation(line: 23, column: 15, scope: !1465)
!1472 = !DILocation(line: 23, column: 17, scope: !1465)
!1473 = !DILocation(line: 23, column: 16, scope: !1465)
!1474 = !DILocation(line: 23, column: 12, scope: !1465)
!1475 = !DILocation(line: 23, column: 4, scope: !1465)
!1476 = !DILocation(line: 23, column: 8, scope: !1465)
!1477 = !DILocation(line: 24, column: 10, scope: !1465)
!1478 = !DILocation(line: 24, column: 3, scope: !1465)
!1479 = distinct !DISubprogram(name: "__udivsi3", scope: !102, file: !102, line: 25, type: !116, isLocal: false, isDefinition: true, scopeLine: 26, flags: DIFlagPrototyped, isOptimized: false, unit: !101, retainedNodes: !2)
!1480 = !DILocation(line: 27, column: 20, scope: !1479)
!1481 = !DILocation(line: 32, column: 9, scope: !1479)
!1482 = !DILocation(line: 32, column: 11, scope: !1479)
!1483 = !DILocation(line: 33, column: 9, scope: !1479)
!1484 = !DILocation(line: 34, column: 9, scope: !1479)
!1485 = !DILocation(line: 34, column: 11, scope: !1479)
!1486 = !DILocation(line: 35, column: 9, scope: !1479)
!1487 = !DILocation(line: 36, column: 24, scope: !1479)
!1488 = !DILocation(line: 36, column: 10, scope: !1479)
!1489 = !DILocation(line: 36, column: 43, scope: !1479)
!1490 = !DILocation(line: 36, column: 29, scope: !1479)
!1491 = !DILocation(line: 36, column: 27, scope: !1479)
!1492 = !DILocation(line: 36, column: 8, scope: !1479)
!1493 = !DILocation(line: 38, column: 9, scope: !1479)
!1494 = !DILocation(line: 38, column: 12, scope: !1479)
!1495 = !DILocation(line: 39, column: 9, scope: !1479)
!1496 = !DILocation(line: 40, column: 9, scope: !1479)
!1497 = !DILocation(line: 40, column: 12, scope: !1479)
!1498 = !DILocation(line: 41, column: 16, scope: !1479)
!1499 = !DILocation(line: 41, column: 9, scope: !1479)
!1500 = !DILocation(line: 42, column: 5, scope: !1479)
!1501 = !DILocation(line: 45, column: 9, scope: !1479)
!1502 = !DILocation(line: 45, column: 30, scope: !1479)
!1503 = !DILocation(line: 45, column: 28, scope: !1479)
!1504 = !DILocation(line: 45, column: 11, scope: !1479)
!1505 = !DILocation(line: 45, column: 7, scope: !1479)
!1506 = !DILocation(line: 46, column: 9, scope: !1479)
!1507 = !DILocation(line: 46, column: 14, scope: !1479)
!1508 = !DILocation(line: 46, column: 11, scope: !1479)
!1509 = !DILocation(line: 46, column: 7, scope: !1479)
!1510 = !DILocation(line: 47, column: 12, scope: !1479)
!1511 = !DILocation(line: 48, column: 5, scope: !1479)
!1512 = !DILocation(line: 48, column: 12, scope: !1479)
!1513 = !DILocation(line: 48, column: 15, scope: !1479)
!1514 = !DILocation(line: 51, column: 14, scope: !1479)
!1515 = !DILocation(line: 51, column: 16, scope: !1479)
!1516 = !DILocation(line: 51, column: 25, scope: !1479)
!1517 = !DILocation(line: 51, column: 27, scope: !1479)
!1518 = !DILocation(line: 51, column: 22, scope: !1479)
!1519 = !DILocation(line: 51, column: 11, scope: !1479)
!1520 = !DILocation(line: 52, column: 14, scope: !1479)
!1521 = !DILocation(line: 52, column: 16, scope: !1479)
!1522 = !DILocation(line: 52, column: 24, scope: !1479)
!1523 = !DILocation(line: 52, column: 22, scope: !1479)
!1524 = !DILocation(line: 52, column: 11, scope: !1479)
!1525 = !DILocation(line: 60, column: 35, scope: !1479)
!1526 = !DILocation(line: 60, column: 39, scope: !1479)
!1527 = !DILocation(line: 60, column: 37, scope: !1479)
!1528 = !DILocation(line: 60, column: 41, scope: !1479)
!1529 = !DILocation(line: 60, column: 46, scope: !1479)
!1530 = !DILocation(line: 60, column: 22, scope: !1479)
!1531 = !DILocation(line: 61, column: 17, scope: !1479)
!1532 = !DILocation(line: 61, column: 19, scope: !1479)
!1533 = !DILocation(line: 61, column: 15, scope: !1479)
!1534 = !DILocation(line: 62, column: 14, scope: !1479)
!1535 = !DILocation(line: 62, column: 18, scope: !1479)
!1536 = !DILocation(line: 62, column: 16, scope: !1479)
!1537 = !DILocation(line: 62, column: 11, scope: !1479)
!1538 = !DILocation(line: 63, column: 5, scope: !1479)
!1539 = !DILocation(line: 48, column: 20, scope: !1479)
!1540 = distinct !{!1540, !1511, !1538}
!1541 = !DILocation(line: 64, column: 10, scope: !1479)
!1542 = !DILocation(line: 64, column: 12, scope: !1479)
!1543 = !DILocation(line: 64, column: 20, scope: !1479)
!1544 = !DILocation(line: 64, column: 18, scope: !1479)
!1545 = !DILocation(line: 64, column: 7, scope: !1479)
!1546 = !DILocation(line: 65, column: 12, scope: !1479)
!1547 = !DILocation(line: 65, column: 5, scope: !1479)
!1548 = !DILocation(line: 66, column: 1, scope: !1479)
!1549 = distinct !DISubprogram(name: "__umoddi3", scope: !106, file: !106, line: 20, type: !116, isLocal: false, isDefinition: true, scopeLine: 21, flags: DIFlagPrototyped, isOptimized: false, unit: !105, retainedNodes: !2)
!1550 = !DILocation(line: 23, column: 18, scope: !1549)
!1551 = !DILocation(line: 23, column: 21, scope: !1549)
!1552 = !DILocation(line: 23, column: 5, scope: !1549)
!1553 = !DILocation(line: 24, column: 12, scope: !1549)
!1554 = !DILocation(line: 24, column: 5, scope: !1549)
!1555 = distinct !DISubprogram(name: "__umodsi3", scope: !108, file: !108, line: 20, type: !116, isLocal: false, isDefinition: true, scopeLine: 21, flags: DIFlagPrototyped, isOptimized: false, unit: !107, retainedNodes: !2)
!1556 = !DILocation(line: 22, column: 12, scope: !1555)
!1557 = !DILocation(line: 22, column: 26, scope: !1555)
!1558 = !DILocation(line: 22, column: 29, scope: !1555)
!1559 = !DILocation(line: 22, column: 16, scope: !1555)
!1560 = !DILocation(line: 22, column: 34, scope: !1555)
!1561 = !DILocation(line: 22, column: 32, scope: !1555)
!1562 = !DILocation(line: 22, column: 14, scope: !1555)
!1563 = !DILocation(line: 22, column: 5, scope: !1555)
