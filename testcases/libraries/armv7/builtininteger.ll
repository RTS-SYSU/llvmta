; ModuleID = 'llvm-link'
source_filename = "llvm-link"
target datalayout = "e-m:e-p:32:32-Fi8-i64:64-v128:64:128-a:0:32-n32-S64"
target triple = "armv7-unknown-unknown"

%union.dwords = type { i64 }
%struct.anon = type { i32, i32 }

@.str = private unnamed_addr constant [10 x i8] c"absvdi2.c\00", align 1
@__func__.__absvdi2 = private unnamed_addr constant [10 x i8] c"__absvdi2\00", align 1
@.str.1 = private unnamed_addr constant [10 x i8] c"absvsi2.c\00", align 1
@__func__.__absvsi2 = private unnamed_addr constant [10 x i8] c"__absvsi2\00", align 1
@.str.2 = private unnamed_addr constant [10 x i8] c"addvdi3.c\00", align 1
@__func__.__addvdi3 = private unnamed_addr constant [10 x i8] c"__addvdi3\00", align 1
@.str.3 = private unnamed_addr constant [10 x i8] c"addvsi3.c\00", align 1
@__func__.__addvsi3 = private unnamed_addr constant [10 x i8] c"__addvsi3\00", align 1
@.str.8 = private unnamed_addr constant [10 x i8] c"mulvdi3.c\00", align 1
@__func__.__mulvdi3 = private unnamed_addr constant [10 x i8] c"__mulvdi3\00", align 1
@.str.9 = private unnamed_addr constant [10 x i8] c"mulvsi3.c\00", align 1
@__func__.__mulvsi3 = private unnamed_addr constant [10 x i8] c"__mulvsi3\00", align 1
@.str.12 = private unnamed_addr constant [10 x i8] c"subvdi3.c\00", align 1
@__func__.__subvdi3 = private unnamed_addr constant [10 x i8] c"__subvdi3\00", align 1
@.str.13 = private unnamed_addr constant [10 x i8] c"subvsi3.c\00", align 1
@__func__.__subvsi3 = private unnamed_addr constant [10 x i8] c"__subvsi3\00", align 1

@__aeabi_llsl = dso_local alias void (...), bitcast (i64 (i64, i32)* @__ashldi3 to void (...)*)
@__aeabi_lasr = dso_local alias void (...), bitcast (i64 (i64, i32)* @__ashrdi3 to void (...)*)
@__aeabi_idiv = dso_local alias void (...), bitcast (i32 (i32, i32)* @__divsi3 to void (...)*)
@__aeabi_llsr = dso_local alias void (...), bitcast (i64 (i64, i32)* @__lshrdi3 to void (...)*)
@__aeabi_uidiv = dso_local alias void (...), bitcast (i32 (i32, i32)* @__udivsi3 to void (...)*)

; Function Attrs: noinline nounwind
define dso_local arm_aapcscc i64 @__absvdi2(i64 %a) #0 !dbg !116 {
entry:
  %a.addr = alloca i64, align 8
  %N = alloca i32, align 4
  %t = alloca i64, align 8
  store i64 %a, i64* %a.addr, align 8
  store i32 64, i32* %N, align 4, !dbg !118
  %0 = load i64, i64* %a.addr, align 8, !dbg !119
  %cmp = icmp eq i64 %0, -9223372036854775808, !dbg !120
  br i1 %cmp, label %if.then, label %if.end, !dbg !119

if.then:                                          ; preds = %entry
  call arm_aapcs_vfpcc void @compilerrt_abort_impl(i8* getelementptr inbounds ([10 x i8], [10 x i8]* @.str, i32 0, i32 0), i32 26, i8* getelementptr inbounds ([10 x i8], [10 x i8]* @__func__.__absvdi2, i32 0, i32 0)) #3, !dbg !121
  unreachable, !dbg !121

if.end:                                           ; preds = %entry
  %1 = load i64, i64* %a.addr, align 8, !dbg !122
  %shr = ashr i64 %1, 63, !dbg !123
  store i64 %shr, i64* %t, align 8, !dbg !124
  %2 = load i64, i64* %a.addr, align 8, !dbg !125
  %3 = load i64, i64* %t, align 8, !dbg !126
  %xor = xor i64 %2, %3, !dbg !127
  %4 = load i64, i64* %t, align 8, !dbg !128
  %sub = sub nsw i64 %xor, %4, !dbg !129
  ret i64 %sub, !dbg !130
}

; Function Attrs: noinline nounwind
define dso_local arm_aapcscc i32 @__absvsi2(i32 %a) #0 !dbg !131 {
entry:
  %a.addr = alloca i32, align 4
  %N = alloca i32, align 4
  %t = alloca i32, align 4
  store i32 %a, i32* %a.addr, align 4
  store i32 32, i32* %N, align 4, !dbg !132
  %0 = load i32, i32* %a.addr, align 4, !dbg !133
  %cmp = icmp eq i32 %0, -2147483648, !dbg !134
  br i1 %cmp, label %if.then, label %if.end, !dbg !133

if.then:                                          ; preds = %entry
  call arm_aapcs_vfpcc void @compilerrt_abort_impl(i8* getelementptr inbounds ([10 x i8], [10 x i8]* @.str.1, i32 0, i32 0), i32 26, i8* getelementptr inbounds ([10 x i8], [10 x i8]* @__func__.__absvsi2, i32 0, i32 0)) #3, !dbg !135
  unreachable, !dbg !135

if.end:                                           ; preds = %entry
  %1 = load i32, i32* %a.addr, align 4, !dbg !136
  %shr = ashr i32 %1, 31, !dbg !137
  store i32 %shr, i32* %t, align 4, !dbg !138
  %2 = load i32, i32* %a.addr, align 4, !dbg !139
  %3 = load i32, i32* %t, align 4, !dbg !140
  %xor = xor i32 %2, %3, !dbg !141
  %4 = load i32, i32* %t, align 4, !dbg !142
  %sub = sub nsw i32 %xor, %4, !dbg !143
  ret i32 %sub, !dbg !144
}

; Function Attrs: noinline nounwind
define dso_local arm_aapcscc i64 @__addvdi3(i64 %a, i64 %b) #0 !dbg !145 {
entry:
  %a.addr = alloca i64, align 8
  %b.addr = alloca i64, align 8
  %s = alloca i64, align 8
  store i64 %a, i64* %a.addr, align 8
  store i64 %b, i64* %b.addr, align 8
  %0 = load i64, i64* %a.addr, align 8, !dbg !146
  %1 = load i64, i64* %b.addr, align 8, !dbg !147
  %add = add i64 %0, %1, !dbg !148
  store i64 %add, i64* %s, align 8, !dbg !149
  %2 = load i64, i64* %b.addr, align 8, !dbg !150
  %cmp = icmp sge i64 %2, 0, !dbg !151
  br i1 %cmp, label %if.then, label %if.else, !dbg !150

if.then:                                          ; preds = %entry
  %3 = load i64, i64* %s, align 8, !dbg !152
  %4 = load i64, i64* %a.addr, align 8, !dbg !153
  %cmp1 = icmp slt i64 %3, %4, !dbg !154
  br i1 %cmp1, label %if.then2, label %if.end, !dbg !152

if.then2:                                         ; preds = %if.then
  call arm_aapcs_vfpcc void @compilerrt_abort_impl(i8* getelementptr inbounds ([10 x i8], [10 x i8]* @.str.2, i32 0, i32 0), i32 28, i8* getelementptr inbounds ([10 x i8], [10 x i8]* @__func__.__addvdi3, i32 0, i32 0)) #3, !dbg !155
  unreachable, !dbg !155

if.end:                                           ; preds = %if.then
  br label %if.end6, !dbg !156

if.else:                                          ; preds = %entry
  %5 = load i64, i64* %s, align 8, !dbg !157
  %6 = load i64, i64* %a.addr, align 8, !dbg !158
  %cmp3 = icmp sge i64 %5, %6, !dbg !159
  br i1 %cmp3, label %if.then4, label %if.end5, !dbg !157

if.then4:                                         ; preds = %if.else
  call arm_aapcs_vfpcc void @compilerrt_abort_impl(i8* getelementptr inbounds ([10 x i8], [10 x i8]* @.str.2, i32 0, i32 0), i32 33, i8* getelementptr inbounds ([10 x i8], [10 x i8]* @__func__.__addvdi3, i32 0, i32 0)) #3, !dbg !160
  unreachable, !dbg !160

if.end5:                                          ; preds = %if.else
  br label %if.end6

if.end6:                                          ; preds = %if.end5, %if.end
  %7 = load i64, i64* %s, align 8, !dbg !161
  ret i64 %7, !dbg !162
}

; Function Attrs: noinline nounwind
define dso_local arm_aapcscc i32 @__addvsi3(i32 %a, i32 %b) #0 !dbg !163 {
entry:
  %a.addr = alloca i32, align 4
  %b.addr = alloca i32, align 4
  %s = alloca i32, align 4
  store i32 %a, i32* %a.addr, align 4
  store i32 %b, i32* %b.addr, align 4
  %0 = load i32, i32* %a.addr, align 4, !dbg !164
  %1 = load i32, i32* %b.addr, align 4, !dbg !165
  %add = add i32 %0, %1, !dbg !166
  store i32 %add, i32* %s, align 4, !dbg !167
  %2 = load i32, i32* %b.addr, align 4, !dbg !168
  %cmp = icmp sge i32 %2, 0, !dbg !169
  br i1 %cmp, label %if.then, label %if.else, !dbg !168

if.then:                                          ; preds = %entry
  %3 = load i32, i32* %s, align 4, !dbg !170
  %4 = load i32, i32* %a.addr, align 4, !dbg !171
  %cmp1 = icmp slt i32 %3, %4, !dbg !172
  br i1 %cmp1, label %if.then2, label %if.end, !dbg !170

if.then2:                                         ; preds = %if.then
  call arm_aapcs_vfpcc void @compilerrt_abort_impl(i8* getelementptr inbounds ([10 x i8], [10 x i8]* @.str.3, i32 0, i32 0), i32 28, i8* getelementptr inbounds ([10 x i8], [10 x i8]* @__func__.__addvsi3, i32 0, i32 0)) #3, !dbg !173
  unreachable, !dbg !173

if.end:                                           ; preds = %if.then
  br label %if.end6, !dbg !174

if.else:                                          ; preds = %entry
  %5 = load i32, i32* %s, align 4, !dbg !175
  %6 = load i32, i32* %a.addr, align 4, !dbg !176
  %cmp3 = icmp sge i32 %5, %6, !dbg !177
  br i1 %cmp3, label %if.then4, label %if.end5, !dbg !175

if.then4:                                         ; preds = %if.else
  call arm_aapcs_vfpcc void @compilerrt_abort_impl(i8* getelementptr inbounds ([10 x i8], [10 x i8]* @.str.3, i32 0, i32 0), i32 33, i8* getelementptr inbounds ([10 x i8], [10 x i8]* @__func__.__addvsi3, i32 0, i32 0)) #3, !dbg !178
  unreachable, !dbg !178

if.end5:                                          ; preds = %if.else
  br label %if.end6

if.end6:                                          ; preds = %if.end5, %if.end
  %7 = load i32, i32* %s, align 4, !dbg !179
  ret i32 %7, !dbg !180
}

; Function Attrs: noinline nounwind
define dso_local arm_aapcscc i64 @__ashldi3(i64 %a, i32 %b) #0 !dbg !181 {
entry:
  %retval = alloca i64, align 8
  %a.addr = alloca i64, align 8
  %b.addr = alloca i32, align 4
  %bits_in_word = alloca i32, align 4
  %input = alloca %union.dwords, align 8
  %result = alloca %union.dwords, align 8
  store i64 %a, i64* %a.addr, align 8
  store i32 %b, i32* %b.addr, align 4
  store i32 32, i32* %bits_in_word, align 4, !dbg !182
  %0 = load i64, i64* %a.addr, align 8, !dbg !183
  %all = bitcast %union.dwords* %input to i64*, !dbg !184
  store i64 %0, i64* %all, align 8, !dbg !185
  %1 = load i32, i32* %b.addr, align 4, !dbg !186
  %and = and i32 %1, 32, !dbg !187
  %tobool = icmp ne i32 %and, 0, !dbg !187
  br i1 %tobool, label %if.then, label %if.else, !dbg !186

if.then:                                          ; preds = %entry
  %s = bitcast %union.dwords* %result to %struct.anon*, !dbg !188
  %low = getelementptr inbounds %struct.anon, %struct.anon* %s, i32 0, i32 0, !dbg !189
  store i32 0, i32* %low, align 8, !dbg !190
  %s1 = bitcast %union.dwords* %input to %struct.anon*, !dbg !191
  %low2 = getelementptr inbounds %struct.anon, %struct.anon* %s1, i32 0, i32 0, !dbg !192
  %2 = load i32, i32* %low2, align 8, !dbg !192
  %3 = load i32, i32* %b.addr, align 4, !dbg !193
  %sub = sub nsw i32 %3, 32, !dbg !194
  %shl = shl i32 %2, %sub, !dbg !195
  %s3 = bitcast %union.dwords* %result to %struct.anon*, !dbg !196
  %high = getelementptr inbounds %struct.anon, %struct.anon* %s3, i32 0, i32 1, !dbg !197
  store i32 %shl, i32* %high, align 4, !dbg !198
  br label %if.end18, !dbg !199

if.else:                                          ; preds = %entry
  %4 = load i32, i32* %b.addr, align 4, !dbg !200
  %cmp = icmp eq i32 %4, 0, !dbg !201
  br i1 %cmp, label %if.then4, label %if.end, !dbg !200

if.then4:                                         ; preds = %if.else
  %5 = load i64, i64* %a.addr, align 8, !dbg !202
  store i64 %5, i64* %retval, align 8, !dbg !203
  br label %return, !dbg !203

if.end:                                           ; preds = %if.else
  %s5 = bitcast %union.dwords* %input to %struct.anon*, !dbg !204
  %low6 = getelementptr inbounds %struct.anon, %struct.anon* %s5, i32 0, i32 0, !dbg !205
  %6 = load i32, i32* %low6, align 8, !dbg !205
  %7 = load i32, i32* %b.addr, align 4, !dbg !206
  %shl7 = shl i32 %6, %7, !dbg !207
  %s8 = bitcast %union.dwords* %result to %struct.anon*, !dbg !208
  %low9 = getelementptr inbounds %struct.anon, %struct.anon* %s8, i32 0, i32 0, !dbg !209
  store i32 %shl7, i32* %low9, align 8, !dbg !210
  %s10 = bitcast %union.dwords* %input to %struct.anon*, !dbg !211
  %high11 = getelementptr inbounds %struct.anon, %struct.anon* %s10, i32 0, i32 1, !dbg !212
  %8 = load i32, i32* %high11, align 4, !dbg !212
  %9 = load i32, i32* %b.addr, align 4, !dbg !213
  %shl12 = shl i32 %8, %9, !dbg !214
  %s13 = bitcast %union.dwords* %input to %struct.anon*, !dbg !215
  %low14 = getelementptr inbounds %struct.anon, %struct.anon* %s13, i32 0, i32 0, !dbg !216
  %10 = load i32, i32* %low14, align 8, !dbg !216
  %11 = load i32, i32* %b.addr, align 4, !dbg !217
  %sub15 = sub nsw i32 32, %11, !dbg !218
  %shr = lshr i32 %10, %sub15, !dbg !219
  %or = or i32 %shl12, %shr, !dbg !220
  %s16 = bitcast %union.dwords* %result to %struct.anon*, !dbg !221
  %high17 = getelementptr inbounds %struct.anon, %struct.anon* %s16, i32 0, i32 1, !dbg !222
  store i32 %or, i32* %high17, align 4, !dbg !223
  br label %if.end18

if.end18:                                         ; preds = %if.end, %if.then
  %all19 = bitcast %union.dwords* %result to i64*, !dbg !224
  %12 = load i64, i64* %all19, align 8, !dbg !224
  store i64 %12, i64* %retval, align 8, !dbg !225
  br label %return, !dbg !225

return:                                           ; preds = %if.end18, %if.then4
  %13 = load i64, i64* %retval, align 8, !dbg !226
  ret i64 %13, !dbg !226
}

; Function Attrs: noinline nounwind
define dso_local arm_aapcscc i64 @__ashrdi3(i64 %a, i32 %b) #0 !dbg !227 {
entry:
  %retval = alloca i64, align 8
  %a.addr = alloca i64, align 8
  %b.addr = alloca i32, align 4
  %bits_in_word = alloca i32, align 4
  %input = alloca %union.dwords, align 8
  %result = alloca %union.dwords, align 8
  store i64 %a, i64* %a.addr, align 8
  store i32 %b, i32* %b.addr, align 4
  store i32 32, i32* %bits_in_word, align 4, !dbg !228
  %0 = load i64, i64* %a.addr, align 8, !dbg !229
  %all = bitcast %union.dwords* %input to i64*, !dbg !230
  store i64 %0, i64* %all, align 8, !dbg !231
  %1 = load i32, i32* %b.addr, align 4, !dbg !232
  %and = and i32 %1, 32, !dbg !233
  %tobool = icmp ne i32 %and, 0, !dbg !233
  br i1 %tobool, label %if.then, label %if.else, !dbg !232

if.then:                                          ; preds = %entry
  %s = bitcast %union.dwords* %input to %struct.anon*, !dbg !234
  %high = getelementptr inbounds %struct.anon, %struct.anon* %s, i32 0, i32 1, !dbg !235
  %2 = load i32, i32* %high, align 4, !dbg !235
  %shr = ashr i32 %2, 31, !dbg !236
  %s1 = bitcast %union.dwords* %result to %struct.anon*, !dbg !237
  %high2 = getelementptr inbounds %struct.anon, %struct.anon* %s1, i32 0, i32 1, !dbg !238
  store i32 %shr, i32* %high2, align 4, !dbg !239
  %s3 = bitcast %union.dwords* %input to %struct.anon*, !dbg !240
  %high4 = getelementptr inbounds %struct.anon, %struct.anon* %s3, i32 0, i32 1, !dbg !241
  %3 = load i32, i32* %high4, align 4, !dbg !241
  %4 = load i32, i32* %b.addr, align 4, !dbg !242
  %sub = sub nsw i32 %4, 32, !dbg !243
  %shr5 = ashr i32 %3, %sub, !dbg !244
  %s6 = bitcast %union.dwords* %result to %struct.anon*, !dbg !245
  %low = getelementptr inbounds %struct.anon, %struct.anon* %s6, i32 0, i32 0, !dbg !246
  store i32 %shr5, i32* %low, align 8, !dbg !247
  br label %if.end21, !dbg !248

if.else:                                          ; preds = %entry
  %5 = load i32, i32* %b.addr, align 4, !dbg !249
  %cmp = icmp eq i32 %5, 0, !dbg !250
  br i1 %cmp, label %if.then7, label %if.end, !dbg !249

if.then7:                                         ; preds = %if.else
  %6 = load i64, i64* %a.addr, align 8, !dbg !251
  store i64 %6, i64* %retval, align 8, !dbg !252
  br label %return, !dbg !252

if.end:                                           ; preds = %if.else
  %s8 = bitcast %union.dwords* %input to %struct.anon*, !dbg !253
  %high9 = getelementptr inbounds %struct.anon, %struct.anon* %s8, i32 0, i32 1, !dbg !254
  %7 = load i32, i32* %high9, align 4, !dbg !254
  %8 = load i32, i32* %b.addr, align 4, !dbg !255
  %shr10 = ashr i32 %7, %8, !dbg !256
  %s11 = bitcast %union.dwords* %result to %struct.anon*, !dbg !257
  %high12 = getelementptr inbounds %struct.anon, %struct.anon* %s11, i32 0, i32 1, !dbg !258
  store i32 %shr10, i32* %high12, align 4, !dbg !259
  %s13 = bitcast %union.dwords* %input to %struct.anon*, !dbg !260
  %high14 = getelementptr inbounds %struct.anon, %struct.anon* %s13, i32 0, i32 1, !dbg !261
  %9 = load i32, i32* %high14, align 4, !dbg !261
  %10 = load i32, i32* %b.addr, align 4, !dbg !262
  %sub15 = sub nsw i32 32, %10, !dbg !263
  %shl = shl i32 %9, %sub15, !dbg !264
  %s16 = bitcast %union.dwords* %input to %struct.anon*, !dbg !265
  %low17 = getelementptr inbounds %struct.anon, %struct.anon* %s16, i32 0, i32 0, !dbg !266
  %11 = load i32, i32* %low17, align 8, !dbg !266
  %12 = load i32, i32* %b.addr, align 4, !dbg !267
  %shr18 = lshr i32 %11, %12, !dbg !268
  %or = or i32 %shl, %shr18, !dbg !269
  %s19 = bitcast %union.dwords* %result to %struct.anon*, !dbg !270
  %low20 = getelementptr inbounds %struct.anon, %struct.anon* %s19, i32 0, i32 0, !dbg !271
  store i32 %or, i32* %low20, align 8, !dbg !272
  br label %if.end21

if.end21:                                         ; preds = %if.end, %if.then
  %all22 = bitcast %union.dwords* %result to i64*, !dbg !273
  %13 = load i64, i64* %all22, align 8, !dbg !273
  store i64 %13, i64* %retval, align 8, !dbg !274
  br label %return, !dbg !274

return:                                           ; preds = %if.end21, %if.then7
  %14 = load i64, i64* %retval, align 8, !dbg !275
  ret i64 %14, !dbg !275
}

; Function Attrs: noinline nounwind
define dso_local arm_aapcscc i32 @__clzdi2(i64 %a) #0 !dbg !276 {
entry:
  %a.addr = alloca i64, align 8
  %x = alloca %union.dwords, align 8
  %f = alloca i32, align 4
  store i64 %a, i64* %a.addr, align 8
  %0 = load i64, i64* %a.addr, align 8, !dbg !277
  %all = bitcast %union.dwords* %x to i64*, !dbg !278
  store i64 %0, i64* %all, align 8, !dbg !279
  %s = bitcast %union.dwords* %x to %struct.anon*, !dbg !280
  %high = getelementptr inbounds %struct.anon, %struct.anon* %s, i32 0, i32 1, !dbg !281
  %1 = load i32, i32* %high, align 4, !dbg !281
  %cmp = icmp eq i32 %1, 0, !dbg !282
  %conv = zext i1 %cmp to i32, !dbg !282
  %sub = sub nsw i32 0, %conv, !dbg !283
  store i32 %sub, i32* %f, align 4, !dbg !284
  %s1 = bitcast %union.dwords* %x to %struct.anon*, !dbg !285
  %high2 = getelementptr inbounds %struct.anon, %struct.anon* %s1, i32 0, i32 1, !dbg !286
  %2 = load i32, i32* %high2, align 4, !dbg !286
  %3 = load i32, i32* %f, align 4, !dbg !287
  %neg = xor i32 %3, -1, !dbg !288
  %and = and i32 %2, %neg, !dbg !289
  %s3 = bitcast %union.dwords* %x to %struct.anon*, !dbg !290
  %low = getelementptr inbounds %struct.anon, %struct.anon* %s3, i32 0, i32 0, !dbg !291
  %4 = load i32, i32* %low, align 8, !dbg !291
  %5 = load i32, i32* %f, align 4, !dbg !292
  %and4 = and i32 %4, %5, !dbg !293
  %or = or i32 %and, %and4, !dbg !294
  %6 = call i32 @llvm.ctlz.i32(i32 %or, i1 false), !dbg !295
  %7 = load i32, i32* %f, align 4, !dbg !296
  %and5 = and i32 %7, 32, !dbg !297
  %add = add nsw i32 %6, %and5, !dbg !298
  ret i32 %add, !dbg !299
}

; Function Attrs: nounwind readnone speculatable
declare i32 @llvm.ctlz.i32(i32, i1 immarg) #1

; Function Attrs: noinline nounwind
define dso_local arm_aapcscc i32 @__clzsi2(i32 %a) #0 !dbg !300 {
entry:
  %a.addr = alloca i32, align 4
  %x = alloca i32, align 4
  %t = alloca i32, align 4
  %r = alloca i32, align 4
  store i32 %a, i32* %a.addr, align 4
  %0 = load i32, i32* %a.addr, align 4, !dbg !301
  store i32 %0, i32* %x, align 4, !dbg !302
  %1 = load i32, i32* %x, align 4, !dbg !303
  %and = and i32 %1, -65536, !dbg !304
  %cmp = icmp eq i32 %and, 0, !dbg !305
  %conv = zext i1 %cmp to i32, !dbg !305
  %shl = shl i32 %conv, 4, !dbg !306
  store i32 %shl, i32* %t, align 4, !dbg !307
  %2 = load i32, i32* %t, align 4, !dbg !308
  %sub = sub nsw i32 16, %2, !dbg !309
  %3 = load i32, i32* %x, align 4, !dbg !310
  %shr = lshr i32 %3, %sub, !dbg !310
  store i32 %shr, i32* %x, align 4, !dbg !310
  %4 = load i32, i32* %t, align 4, !dbg !311
  store i32 %4, i32* %r, align 4, !dbg !312
  %5 = load i32, i32* %x, align 4, !dbg !313
  %and1 = and i32 %5, 65280, !dbg !314
  %cmp2 = icmp eq i32 %and1, 0, !dbg !315
  %conv3 = zext i1 %cmp2 to i32, !dbg !315
  %shl4 = shl i32 %conv3, 3, !dbg !316
  store i32 %shl4, i32* %t, align 4, !dbg !317
  %6 = load i32, i32* %t, align 4, !dbg !318
  %sub5 = sub nsw i32 8, %6, !dbg !319
  %7 = load i32, i32* %x, align 4, !dbg !320
  %shr6 = lshr i32 %7, %sub5, !dbg !320
  store i32 %shr6, i32* %x, align 4, !dbg !320
  %8 = load i32, i32* %t, align 4, !dbg !321
  %9 = load i32, i32* %r, align 4, !dbg !322
  %add = add i32 %9, %8, !dbg !322
  store i32 %add, i32* %r, align 4, !dbg !322
  %10 = load i32, i32* %x, align 4, !dbg !323
  %and7 = and i32 %10, 240, !dbg !324
  %cmp8 = icmp eq i32 %and7, 0, !dbg !325
  %conv9 = zext i1 %cmp8 to i32, !dbg !325
  %shl10 = shl i32 %conv9, 2, !dbg !326
  store i32 %shl10, i32* %t, align 4, !dbg !327
  %11 = load i32, i32* %t, align 4, !dbg !328
  %sub11 = sub nsw i32 4, %11, !dbg !329
  %12 = load i32, i32* %x, align 4, !dbg !330
  %shr12 = lshr i32 %12, %sub11, !dbg !330
  store i32 %shr12, i32* %x, align 4, !dbg !330
  %13 = load i32, i32* %t, align 4, !dbg !331
  %14 = load i32, i32* %r, align 4, !dbg !332
  %add13 = add i32 %14, %13, !dbg !332
  store i32 %add13, i32* %r, align 4, !dbg !332
  %15 = load i32, i32* %x, align 4, !dbg !333
  %and14 = and i32 %15, 12, !dbg !334
  %cmp15 = icmp eq i32 %and14, 0, !dbg !335
  %conv16 = zext i1 %cmp15 to i32, !dbg !335
  %shl17 = shl i32 %conv16, 1, !dbg !336
  store i32 %shl17, i32* %t, align 4, !dbg !337
  %16 = load i32, i32* %t, align 4, !dbg !338
  %sub18 = sub nsw i32 2, %16, !dbg !339
  %17 = load i32, i32* %x, align 4, !dbg !340
  %shr19 = lshr i32 %17, %sub18, !dbg !340
  store i32 %shr19, i32* %x, align 4, !dbg !340
  %18 = load i32, i32* %t, align 4, !dbg !341
  %19 = load i32, i32* %r, align 4, !dbg !342
  %add20 = add i32 %19, %18, !dbg !342
  store i32 %add20, i32* %r, align 4, !dbg !342
  %20 = load i32, i32* %r, align 4, !dbg !343
  %21 = load i32, i32* %x, align 4, !dbg !344
  %sub21 = sub i32 2, %21, !dbg !345
  %22 = load i32, i32* %x, align 4, !dbg !346
  %and22 = and i32 %22, 2, !dbg !347
  %cmp23 = icmp eq i32 %and22, 0, !dbg !348
  %conv24 = zext i1 %cmp23 to i32, !dbg !348
  %sub25 = sub nsw i32 0, %conv24, !dbg !349
  %and26 = and i32 %sub21, %sub25, !dbg !350
  %add27 = add i32 %20, %and26, !dbg !351
  ret i32 %add27, !dbg !352
}

; Function Attrs: noinline nounwind
define dso_local arm_aapcscc i32 @__cmpdi2(i64 %a, i64 %b) #0 !dbg !353 {
entry:
  %retval = alloca i32, align 4
  %a.addr = alloca i64, align 8
  %b.addr = alloca i64, align 8
  %x = alloca %union.dwords, align 8
  %y = alloca %union.dwords, align 8
  store i64 %a, i64* %a.addr, align 8
  store i64 %b, i64* %b.addr, align 8
  %0 = load i64, i64* %a.addr, align 8, !dbg !354
  %all = bitcast %union.dwords* %x to i64*, !dbg !355
  store i64 %0, i64* %all, align 8, !dbg !356
  %1 = load i64, i64* %b.addr, align 8, !dbg !357
  %all1 = bitcast %union.dwords* %y to i64*, !dbg !358
  store i64 %1, i64* %all1, align 8, !dbg !359
  %s = bitcast %union.dwords* %x to %struct.anon*, !dbg !360
  %high = getelementptr inbounds %struct.anon, %struct.anon* %s, i32 0, i32 1, !dbg !361
  %2 = load i32, i32* %high, align 4, !dbg !361
  %s2 = bitcast %union.dwords* %y to %struct.anon*, !dbg !362
  %high3 = getelementptr inbounds %struct.anon, %struct.anon* %s2, i32 0, i32 1, !dbg !363
  %3 = load i32, i32* %high3, align 4, !dbg !363
  %cmp = icmp slt i32 %2, %3, !dbg !364
  br i1 %cmp, label %if.then, label %if.end, !dbg !365

if.then:                                          ; preds = %entry
  store i32 0, i32* %retval, align 4, !dbg !366
  br label %return, !dbg !366

if.end:                                           ; preds = %entry
  %s4 = bitcast %union.dwords* %x to %struct.anon*, !dbg !367
  %high5 = getelementptr inbounds %struct.anon, %struct.anon* %s4, i32 0, i32 1, !dbg !368
  %4 = load i32, i32* %high5, align 4, !dbg !368
  %s6 = bitcast %union.dwords* %y to %struct.anon*, !dbg !369
  %high7 = getelementptr inbounds %struct.anon, %struct.anon* %s6, i32 0, i32 1, !dbg !370
  %5 = load i32, i32* %high7, align 4, !dbg !370
  %cmp8 = icmp sgt i32 %4, %5, !dbg !371
  br i1 %cmp8, label %if.then9, label %if.end10, !dbg !372

if.then9:                                         ; preds = %if.end
  store i32 2, i32* %retval, align 4, !dbg !373
  br label %return, !dbg !373

if.end10:                                         ; preds = %if.end
  %s11 = bitcast %union.dwords* %x to %struct.anon*, !dbg !374
  %low = getelementptr inbounds %struct.anon, %struct.anon* %s11, i32 0, i32 0, !dbg !375
  %6 = load i32, i32* %low, align 8, !dbg !375
  %s12 = bitcast %union.dwords* %y to %struct.anon*, !dbg !376
  %low13 = getelementptr inbounds %struct.anon, %struct.anon* %s12, i32 0, i32 0, !dbg !377
  %7 = load i32, i32* %low13, align 8, !dbg !377
  %cmp14 = icmp ult i32 %6, %7, !dbg !378
  br i1 %cmp14, label %if.then15, label %if.end16, !dbg !379

if.then15:                                        ; preds = %if.end10
  store i32 0, i32* %retval, align 4, !dbg !380
  br label %return, !dbg !380

if.end16:                                         ; preds = %if.end10
  %s17 = bitcast %union.dwords* %x to %struct.anon*, !dbg !381
  %low18 = getelementptr inbounds %struct.anon, %struct.anon* %s17, i32 0, i32 0, !dbg !382
  %8 = load i32, i32* %low18, align 8, !dbg !382
  %s19 = bitcast %union.dwords* %y to %struct.anon*, !dbg !383
  %low20 = getelementptr inbounds %struct.anon, %struct.anon* %s19, i32 0, i32 0, !dbg !384
  %9 = load i32, i32* %low20, align 8, !dbg !384
  %cmp21 = icmp ugt i32 %8, %9, !dbg !385
  br i1 %cmp21, label %if.then22, label %if.end23, !dbg !386

if.then22:                                        ; preds = %if.end16
  store i32 2, i32* %retval, align 4, !dbg !387
  br label %return, !dbg !387

if.end23:                                         ; preds = %if.end16
  store i32 1, i32* %retval, align 4, !dbg !388
  br label %return, !dbg !388

return:                                           ; preds = %if.end23, %if.then22, %if.then15, %if.then9, %if.then
  %10 = load i32, i32* %retval, align 4, !dbg !389
  ret i32 %10, !dbg !389
}

; Function Attrs: noinline nounwind
define dso_local arm_aapcscc i32 @__aeabi_lcmp(i64 %a, i64 %b) #0 !dbg !390 {
entry:
  %a.addr = alloca i64, align 8
  %b.addr = alloca i64, align 8
  store i64 %a, i64* %a.addr, align 8
  store i64 %b, i64* %b.addr, align 8
  %0 = load i64, i64* %a.addr, align 8, !dbg !391
  %1 = load i64, i64* %b.addr, align 8, !dbg !392
  %call = call arm_aapcscc i32 @__cmpdi2(i64 %0, i64 %1) #4, !dbg !393
  %sub = sub nsw i32 %call, 1, !dbg !394
  ret i32 %sub, !dbg !395
}

; Function Attrs: noinline nounwind
define dso_local arm_aapcscc i32 @__ctzdi2(i64 %a) #0 !dbg !396 {
entry:
  %a.addr = alloca i64, align 8
  %x = alloca %union.dwords, align 8
  %f = alloca i32, align 4
  store i64 %a, i64* %a.addr, align 8
  %0 = load i64, i64* %a.addr, align 8, !dbg !397
  %all = bitcast %union.dwords* %x to i64*, !dbg !398
  store i64 %0, i64* %all, align 8, !dbg !399
  %s = bitcast %union.dwords* %x to %struct.anon*, !dbg !400
  %low = getelementptr inbounds %struct.anon, %struct.anon* %s, i32 0, i32 0, !dbg !401
  %1 = load i32, i32* %low, align 8, !dbg !401
  %cmp = icmp eq i32 %1, 0, !dbg !402
  %conv = zext i1 %cmp to i32, !dbg !402
  %sub = sub nsw i32 0, %conv, !dbg !403
  store i32 %sub, i32* %f, align 4, !dbg !404
  %s1 = bitcast %union.dwords* %x to %struct.anon*, !dbg !405
  %high = getelementptr inbounds %struct.anon, %struct.anon* %s1, i32 0, i32 1, !dbg !406
  %2 = load i32, i32* %high, align 4, !dbg !406
  %3 = load i32, i32* %f, align 4, !dbg !407
  %and = and i32 %2, %3, !dbg !408
  %s2 = bitcast %union.dwords* %x to %struct.anon*, !dbg !409
  %low3 = getelementptr inbounds %struct.anon, %struct.anon* %s2, i32 0, i32 0, !dbg !410
  %4 = load i32, i32* %low3, align 8, !dbg !410
  %5 = load i32, i32* %f, align 4, !dbg !411
  %neg = xor i32 %5, -1, !dbg !412
  %and4 = and i32 %4, %neg, !dbg !413
  %or = or i32 %and, %and4, !dbg !414
  %6 = call i32 @llvm.cttz.i32(i32 %or, i1 false), !dbg !415
  %7 = load i32, i32* %f, align 4, !dbg !416
  %and5 = and i32 %7, 32, !dbg !417
  %add = add nsw i32 %6, %and5, !dbg !418
  ret i32 %add, !dbg !419
}

; Function Attrs: nounwind readnone speculatable
declare i32 @llvm.cttz.i32(i32, i1 immarg) #1

; Function Attrs: noinline nounwind
define dso_local arm_aapcscc i32 @__ctzsi2(i32 %a) #0 !dbg !420 {
entry:
  %a.addr = alloca i32, align 4
  %x = alloca i32, align 4
  %t = alloca i32, align 4
  %r = alloca i32, align 4
  store i32 %a, i32* %a.addr, align 4
  %0 = load i32, i32* %a.addr, align 4, !dbg !421
  store i32 %0, i32* %x, align 4, !dbg !422
  %1 = load i32, i32* %x, align 4, !dbg !423
  %and = and i32 %1, 65535, !dbg !424
  %cmp = icmp eq i32 %and, 0, !dbg !425
  %conv = zext i1 %cmp to i32, !dbg !425
  %shl = shl i32 %conv, 4, !dbg !426
  store i32 %shl, i32* %t, align 4, !dbg !427
  %2 = load i32, i32* %t, align 4, !dbg !428
  %3 = load i32, i32* %x, align 4, !dbg !429
  %shr = lshr i32 %3, %2, !dbg !429
  store i32 %shr, i32* %x, align 4, !dbg !429
  %4 = load i32, i32* %t, align 4, !dbg !430
  store i32 %4, i32* %r, align 4, !dbg !431
  %5 = load i32, i32* %x, align 4, !dbg !432
  %and1 = and i32 %5, 255, !dbg !433
  %cmp2 = icmp eq i32 %and1, 0, !dbg !434
  %conv3 = zext i1 %cmp2 to i32, !dbg !434
  %shl4 = shl i32 %conv3, 3, !dbg !435
  store i32 %shl4, i32* %t, align 4, !dbg !436
  %6 = load i32, i32* %t, align 4, !dbg !437
  %7 = load i32, i32* %x, align 4, !dbg !438
  %shr5 = lshr i32 %7, %6, !dbg !438
  store i32 %shr5, i32* %x, align 4, !dbg !438
  %8 = load i32, i32* %t, align 4, !dbg !439
  %9 = load i32, i32* %r, align 4, !dbg !440
  %add = add i32 %9, %8, !dbg !440
  store i32 %add, i32* %r, align 4, !dbg !440
  %10 = load i32, i32* %x, align 4, !dbg !441
  %and6 = and i32 %10, 15, !dbg !442
  %cmp7 = icmp eq i32 %and6, 0, !dbg !443
  %conv8 = zext i1 %cmp7 to i32, !dbg !443
  %shl9 = shl i32 %conv8, 2, !dbg !444
  store i32 %shl9, i32* %t, align 4, !dbg !445
  %11 = load i32, i32* %t, align 4, !dbg !446
  %12 = load i32, i32* %x, align 4, !dbg !447
  %shr10 = lshr i32 %12, %11, !dbg !447
  store i32 %shr10, i32* %x, align 4, !dbg !447
  %13 = load i32, i32* %t, align 4, !dbg !448
  %14 = load i32, i32* %r, align 4, !dbg !449
  %add11 = add i32 %14, %13, !dbg !449
  store i32 %add11, i32* %r, align 4, !dbg !449
  %15 = load i32, i32* %x, align 4, !dbg !450
  %and12 = and i32 %15, 3, !dbg !451
  %cmp13 = icmp eq i32 %and12, 0, !dbg !452
  %conv14 = zext i1 %cmp13 to i32, !dbg !452
  %shl15 = shl i32 %conv14, 1, !dbg !453
  store i32 %shl15, i32* %t, align 4, !dbg !454
  %16 = load i32, i32* %t, align 4, !dbg !455
  %17 = load i32, i32* %x, align 4, !dbg !456
  %shr16 = lshr i32 %17, %16, !dbg !456
  store i32 %shr16, i32* %x, align 4, !dbg !456
  %18 = load i32, i32* %x, align 4, !dbg !457
  %and17 = and i32 %18, 3, !dbg !457
  store i32 %and17, i32* %x, align 4, !dbg !457
  %19 = load i32, i32* %t, align 4, !dbg !458
  %20 = load i32, i32* %r, align 4, !dbg !459
  %add18 = add i32 %20, %19, !dbg !459
  store i32 %add18, i32* %r, align 4, !dbg !459
  %21 = load i32, i32* %r, align 4, !dbg !460
  %22 = load i32, i32* %x, align 4, !dbg !461
  %shr19 = lshr i32 %22, 1, !dbg !462
  %sub = sub i32 2, %shr19, !dbg !463
  %23 = load i32, i32* %x, align 4, !dbg !464
  %and20 = and i32 %23, 1, !dbg !465
  %cmp21 = icmp eq i32 %and20, 0, !dbg !466
  %conv22 = zext i1 %cmp21 to i32, !dbg !466
  %sub23 = sub nsw i32 0, %conv22, !dbg !467
  %and24 = and i32 %sub, %sub23, !dbg !468
  %add25 = add i32 %21, %and24, !dbg !469
  ret i32 %add25, !dbg !470
}

; Function Attrs: noinline nounwind
define dso_local arm_aapcscc i64 @__divdi3(i64 %a, i64 %b) #0 !dbg !471 {
entry:
  %a.addr = alloca i64, align 8
  %b.addr = alloca i64, align 8
  %bits_in_dword_m1 = alloca i32, align 4
  %s_a = alloca i64, align 8
  %s_b = alloca i64, align 8
  store i64 %a, i64* %a.addr, align 8
  store i64 %b, i64* %b.addr, align 8
  store i32 63, i32* %bits_in_dword_m1, align 4, !dbg !472
  %0 = load i64, i64* %a.addr, align 8, !dbg !473
  %shr = ashr i64 %0, 63, !dbg !474
  store i64 %shr, i64* %s_a, align 8, !dbg !475
  %1 = load i64, i64* %b.addr, align 8, !dbg !476
  %shr1 = ashr i64 %1, 63, !dbg !477
  store i64 %shr1, i64* %s_b, align 8, !dbg !478
  %2 = load i64, i64* %a.addr, align 8, !dbg !479
  %3 = load i64, i64* %s_a, align 8, !dbg !480
  %xor = xor i64 %2, %3, !dbg !481
  %4 = load i64, i64* %s_a, align 8, !dbg !482
  %sub = sub nsw i64 %xor, %4, !dbg !483
  store i64 %sub, i64* %a.addr, align 8, !dbg !484
  %5 = load i64, i64* %b.addr, align 8, !dbg !485
  %6 = load i64, i64* %s_b, align 8, !dbg !486
  %xor2 = xor i64 %5, %6, !dbg !487
  %7 = load i64, i64* %s_b, align 8, !dbg !488
  %sub3 = sub nsw i64 %xor2, %7, !dbg !489
  store i64 %sub3, i64* %b.addr, align 8, !dbg !490
  %8 = load i64, i64* %s_b, align 8, !dbg !491
  %9 = load i64, i64* %s_a, align 8, !dbg !492
  %xor4 = xor i64 %9, %8, !dbg !492
  store i64 %xor4, i64* %s_a, align 8, !dbg !492
  %10 = load i64, i64* %a.addr, align 8, !dbg !493
  %11 = load i64, i64* %b.addr, align 8, !dbg !494
  %call = call arm_aapcscc i64 @__udivmoddi4(i64 %10, i64 %11, i64* null) #4, !dbg !495
  %12 = load i64, i64* %s_a, align 8, !dbg !496
  %xor5 = xor i64 %call, %12, !dbg !497
  %13 = load i64, i64* %s_a, align 8, !dbg !498
  %sub6 = sub i64 %xor5, %13, !dbg !499
  ret i64 %sub6, !dbg !500
}

; Function Attrs: noinline nounwind
define dso_local arm_aapcscc i64 @__divmoddi4(i64 %a, i64 %b, i64* %rem) #0 !dbg !501 {
entry:
  %a.addr = alloca i64, align 8
  %b.addr = alloca i64, align 8
  %rem.addr = alloca i64*, align 4
  %d = alloca i64, align 8
  store i64 %a, i64* %a.addr, align 8
  store i64 %b, i64* %b.addr, align 8
  store i64* %rem, i64** %rem.addr, align 4
  %0 = load i64, i64* %a.addr, align 8, !dbg !502
  %1 = load i64, i64* %b.addr, align 8, !dbg !503
  %call = call arm_aapcscc i64 @__divdi3(i64 %0, i64 %1) #4, !dbg !504
  store i64 %call, i64* %d, align 8, !dbg !505
  %2 = load i64, i64* %a.addr, align 8, !dbg !506
  %3 = load i64, i64* %d, align 8, !dbg !507
  %4 = load i64, i64* %b.addr, align 8, !dbg !508
  %mul = mul nsw i64 %3, %4, !dbg !509
  %sub = sub nsw i64 %2, %mul, !dbg !510
  %5 = load i64*, i64** %rem.addr, align 4, !dbg !511
  store i64 %sub, i64* %5, align 8, !dbg !512
  %6 = load i64, i64* %d, align 8, !dbg !513
  ret i64 %6, !dbg !514
}

; Function Attrs: noinline nounwind
define dso_local arm_aapcscc i32 @__divmodsi4(i32 %a, i32 %b, i32* %rem) #0 !dbg !515 {
entry:
  %a.addr = alloca i32, align 4
  %b.addr = alloca i32, align 4
  %rem.addr = alloca i32*, align 4
  %d = alloca i32, align 4
  store i32 %a, i32* %a.addr, align 4
  store i32 %b, i32* %b.addr, align 4
  store i32* %rem, i32** %rem.addr, align 4
  %0 = load i32, i32* %a.addr, align 4, !dbg !516
  %1 = load i32, i32* %b.addr, align 4, !dbg !517
  %call = call arm_aapcscc i32 @__divsi3(i32 %0, i32 %1) #4, !dbg !518
  store i32 %call, i32* %d, align 4, !dbg !519
  %2 = load i32, i32* %a.addr, align 4, !dbg !520
  %3 = load i32, i32* %d, align 4, !dbg !521
  %4 = load i32, i32* %b.addr, align 4, !dbg !522
  %mul = mul nsw i32 %3, %4, !dbg !523
  %sub = sub nsw i32 %2, %mul, !dbg !524
  %5 = load i32*, i32** %rem.addr, align 4, !dbg !525
  store i32 %sub, i32* %5, align 4, !dbg !526
  %6 = load i32, i32* %d, align 4, !dbg !527
  ret i32 %6, !dbg !528
}

; Function Attrs: noinline nounwind
define dso_local arm_aapcscc i32 @__divsi3(i32 %a, i32 %b) #0 !dbg !529 {
entry:
  %a.addr = alloca i32, align 4
  %b.addr = alloca i32, align 4
  %bits_in_word_m1 = alloca i32, align 4
  %s_a = alloca i32, align 4
  %s_b = alloca i32, align 4
  store i32 %a, i32* %a.addr, align 4
  store i32 %b, i32* %b.addr, align 4
  store i32 31, i32* %bits_in_word_m1, align 4, !dbg !530
  %0 = load i32, i32* %a.addr, align 4, !dbg !531
  %shr = ashr i32 %0, 31, !dbg !532
  store i32 %shr, i32* %s_a, align 4, !dbg !533
  %1 = load i32, i32* %b.addr, align 4, !dbg !534
  %shr1 = ashr i32 %1, 31, !dbg !535
  store i32 %shr1, i32* %s_b, align 4, !dbg !536
  %2 = load i32, i32* %a.addr, align 4, !dbg !537
  %3 = load i32, i32* %s_a, align 4, !dbg !538
  %xor = xor i32 %2, %3, !dbg !539
  %4 = load i32, i32* %s_a, align 4, !dbg !540
  %sub = sub nsw i32 %xor, %4, !dbg !541
  store i32 %sub, i32* %a.addr, align 4, !dbg !542
  %5 = load i32, i32* %b.addr, align 4, !dbg !543
  %6 = load i32, i32* %s_b, align 4, !dbg !544
  %xor2 = xor i32 %5, %6, !dbg !545
  %7 = load i32, i32* %s_b, align 4, !dbg !546
  %sub3 = sub nsw i32 %xor2, %7, !dbg !547
  store i32 %sub3, i32* %b.addr, align 4, !dbg !548
  %8 = load i32, i32* %s_b, align 4, !dbg !549
  %9 = load i32, i32* %s_a, align 4, !dbg !550
  %xor4 = xor i32 %9, %8, !dbg !550
  store i32 %xor4, i32* %s_a, align 4, !dbg !550
  %10 = load i32, i32* %a.addr, align 4, !dbg !551
  %11 = load i32, i32* %b.addr, align 4, !dbg !552
  %div = udiv i32 %10, %11, !dbg !553
  %12 = load i32, i32* %s_a, align 4, !dbg !554
  %xor5 = xor i32 %div, %12, !dbg !555
  %13 = load i32, i32* %s_a, align 4, !dbg !556
  %sub6 = sub i32 %xor5, %13, !dbg !557
  ret i32 %sub6, !dbg !558
}

; Function Attrs: noinline nounwind
define dso_local arm_aapcscc i32 @__ffsdi2(i64 %a) #0 !dbg !559 {
entry:
  %retval = alloca i32, align 4
  %a.addr = alloca i64, align 8
  %x = alloca %union.dwords, align 8
  store i64 %a, i64* %a.addr, align 8
  %0 = load i64, i64* %a.addr, align 8, !dbg !560
  %all = bitcast %union.dwords* %x to i64*, !dbg !561
  store i64 %0, i64* %all, align 8, !dbg !562
  %s = bitcast %union.dwords* %x to %struct.anon*, !dbg !563
  %low = getelementptr inbounds %struct.anon, %struct.anon* %s, i32 0, i32 0, !dbg !564
  %1 = load i32, i32* %low, align 8, !dbg !564
  %cmp = icmp eq i32 %1, 0, !dbg !565
  br i1 %cmp, label %if.then, label %if.end6, !dbg !566

if.then:                                          ; preds = %entry
  %s1 = bitcast %union.dwords* %x to %struct.anon*, !dbg !567
  %high = getelementptr inbounds %struct.anon, %struct.anon* %s1, i32 0, i32 1, !dbg !568
  %2 = load i32, i32* %high, align 4, !dbg !568
  %cmp2 = icmp eq i32 %2, 0, !dbg !569
  br i1 %cmp2, label %if.then3, label %if.end, !dbg !570

if.then3:                                         ; preds = %if.then
  store i32 0, i32* %retval, align 4, !dbg !571
  br label %return, !dbg !571

if.end:                                           ; preds = %if.then
  %s4 = bitcast %union.dwords* %x to %struct.anon*, !dbg !572
  %high5 = getelementptr inbounds %struct.anon, %struct.anon* %s4, i32 0, i32 1, !dbg !573
  %3 = load i32, i32* %high5, align 4, !dbg !573
  %4 = call i32 @llvm.cttz.i32(i32 %3, i1 false), !dbg !574
  %add = add i32 %4, 33, !dbg !575
  store i32 %add, i32* %retval, align 4, !dbg !576
  br label %return, !dbg !576

if.end6:                                          ; preds = %entry
  %s7 = bitcast %union.dwords* %x to %struct.anon*, !dbg !577
  %low8 = getelementptr inbounds %struct.anon, %struct.anon* %s7, i32 0, i32 0, !dbg !578
  %5 = load i32, i32* %low8, align 8, !dbg !578
  %6 = call i32 @llvm.cttz.i32(i32 %5, i1 false), !dbg !579
  %add9 = add nsw i32 %6, 1, !dbg !580
  store i32 %add9, i32* %retval, align 4, !dbg !581
  br label %return, !dbg !581

return:                                           ; preds = %if.end6, %if.end, %if.then3
  %7 = load i32, i32* %retval, align 4, !dbg !582
  ret i32 %7, !dbg !582
}

; Function Attrs: noinline nounwind
define dso_local arm_aapcscc i32 @__ffssi2(i32 %a) #0 !dbg !583 {
entry:
  %retval = alloca i32, align 4
  %a.addr = alloca i32, align 4
  store i32 %a, i32* %a.addr, align 4
  %0 = load i32, i32* %a.addr, align 4, !dbg !584
  %cmp = icmp eq i32 %0, 0, !dbg !585
  br i1 %cmp, label %if.then, label %if.end, !dbg !584

if.then:                                          ; preds = %entry
  store i32 0, i32* %retval, align 4, !dbg !586
  br label %return, !dbg !586

if.end:                                           ; preds = %entry
  %1 = load i32, i32* %a.addr, align 4, !dbg !587
  %2 = call i32 @llvm.cttz.i32(i32 %1, i1 false), !dbg !588
  %add = add nsw i32 %2, 1, !dbg !589
  store i32 %add, i32* %retval, align 4, !dbg !590
  br label %return, !dbg !590

return:                                           ; preds = %if.end, %if.then
  %3 = load i32, i32* %retval, align 4, !dbg !591
  ret i32 %3, !dbg !591
}

; Function Attrs: noinline noreturn nounwind
define weak hidden arm_aapcs_vfpcc void @compilerrt_abort_impl(i8* %file, i32 %line, i8* %function) #2 !dbg !592 {
entry:
  %file.addr = alloca i8*, align 4
  %line.addr = alloca i32, align 4
  %function.addr = alloca i8*, align 4
  store i8* %file, i8** %file.addr, align 4
  store i32 %line, i32* %line.addr, align 4
  store i8* %function, i8** %function.addr, align 4
  unreachable, !dbg !593
}

; Function Attrs: noinline nounwind
define dso_local arm_aapcscc i64 @__lshrdi3(i64 %a, i32 %b) #0 !dbg !594 {
entry:
  %retval = alloca i64, align 8
  %a.addr = alloca i64, align 8
  %b.addr = alloca i32, align 4
  %bits_in_word = alloca i32, align 4
  %input = alloca %union.dwords, align 8
  %result = alloca %union.dwords, align 8
  store i64 %a, i64* %a.addr, align 8
  store i32 %b, i32* %b.addr, align 4
  store i32 32, i32* %bits_in_word, align 4, !dbg !595
  %0 = load i64, i64* %a.addr, align 8, !dbg !596
  %all = bitcast %union.dwords* %input to i64*, !dbg !597
  store i64 %0, i64* %all, align 8, !dbg !598
  %1 = load i32, i32* %b.addr, align 4, !dbg !599
  %and = and i32 %1, 32, !dbg !600
  %tobool = icmp ne i32 %and, 0, !dbg !600
  br i1 %tobool, label %if.then, label %if.else, !dbg !599

if.then:                                          ; preds = %entry
  %s = bitcast %union.dwords* %result to %struct.anon*, !dbg !601
  %high = getelementptr inbounds %struct.anon, %struct.anon* %s, i32 0, i32 1, !dbg !602
  store i32 0, i32* %high, align 4, !dbg !603
  %s1 = bitcast %union.dwords* %input to %struct.anon*, !dbg !604
  %high2 = getelementptr inbounds %struct.anon, %struct.anon* %s1, i32 0, i32 1, !dbg !605
  %2 = load i32, i32* %high2, align 4, !dbg !605
  %3 = load i32, i32* %b.addr, align 4, !dbg !606
  %sub = sub nsw i32 %3, 32, !dbg !607
  %shr = lshr i32 %2, %sub, !dbg !608
  %s3 = bitcast %union.dwords* %result to %struct.anon*, !dbg !609
  %low = getelementptr inbounds %struct.anon, %struct.anon* %s3, i32 0, i32 0, !dbg !610
  store i32 %shr, i32* %low, align 8, !dbg !611
  br label %if.end18, !dbg !612

if.else:                                          ; preds = %entry
  %4 = load i32, i32* %b.addr, align 4, !dbg !613
  %cmp = icmp eq i32 %4, 0, !dbg !614
  br i1 %cmp, label %if.then4, label %if.end, !dbg !613

if.then4:                                         ; preds = %if.else
  %5 = load i64, i64* %a.addr, align 8, !dbg !615
  store i64 %5, i64* %retval, align 8, !dbg !616
  br label %return, !dbg !616

if.end:                                           ; preds = %if.else
  %s5 = bitcast %union.dwords* %input to %struct.anon*, !dbg !617
  %high6 = getelementptr inbounds %struct.anon, %struct.anon* %s5, i32 0, i32 1, !dbg !618
  %6 = load i32, i32* %high6, align 4, !dbg !618
  %7 = load i32, i32* %b.addr, align 4, !dbg !619
  %shr7 = lshr i32 %6, %7, !dbg !620
  %s8 = bitcast %union.dwords* %result to %struct.anon*, !dbg !621
  %high9 = getelementptr inbounds %struct.anon, %struct.anon* %s8, i32 0, i32 1, !dbg !622
  store i32 %shr7, i32* %high9, align 4, !dbg !623
  %s10 = bitcast %union.dwords* %input to %struct.anon*, !dbg !624
  %high11 = getelementptr inbounds %struct.anon, %struct.anon* %s10, i32 0, i32 1, !dbg !625
  %8 = load i32, i32* %high11, align 4, !dbg !625
  %9 = load i32, i32* %b.addr, align 4, !dbg !626
  %sub12 = sub nsw i32 32, %9, !dbg !627
  %shl = shl i32 %8, %sub12, !dbg !628
  %s13 = bitcast %union.dwords* %input to %struct.anon*, !dbg !629
  %low14 = getelementptr inbounds %struct.anon, %struct.anon* %s13, i32 0, i32 0, !dbg !630
  %10 = load i32, i32* %low14, align 8, !dbg !630
  %11 = load i32, i32* %b.addr, align 4, !dbg !631
  %shr15 = lshr i32 %10, %11, !dbg !632
  %or = or i32 %shl, %shr15, !dbg !633
  %s16 = bitcast %union.dwords* %result to %struct.anon*, !dbg !634
  %low17 = getelementptr inbounds %struct.anon, %struct.anon* %s16, i32 0, i32 0, !dbg !635
  store i32 %or, i32* %low17, align 8, !dbg !636
  br label %if.end18

if.end18:                                         ; preds = %if.end, %if.then
  %all19 = bitcast %union.dwords* %result to i64*, !dbg !637
  %12 = load i64, i64* %all19, align 8, !dbg !637
  store i64 %12, i64* %retval, align 8, !dbg !638
  br label %return, !dbg !638

return:                                           ; preds = %if.end18, %if.then4
  %13 = load i64, i64* %retval, align 8, !dbg !639
  ret i64 %13, !dbg !639
}

; Function Attrs: noinline nounwind
define dso_local arm_aapcscc i64 @__moddi3(i64 %a, i64 %b) #0 !dbg !640 {
entry:
  %a.addr = alloca i64, align 8
  %b.addr = alloca i64, align 8
  %bits_in_dword_m1 = alloca i32, align 4
  %s = alloca i64, align 8
  %r = alloca i64, align 8
  store i64 %a, i64* %a.addr, align 8
  store i64 %b, i64* %b.addr, align 8
  store i32 63, i32* %bits_in_dword_m1, align 4, !dbg !641
  %0 = load i64, i64* %b.addr, align 8, !dbg !642
  %shr = ashr i64 %0, 63, !dbg !643
  store i64 %shr, i64* %s, align 8, !dbg !644
  %1 = load i64, i64* %b.addr, align 8, !dbg !645
  %2 = load i64, i64* %s, align 8, !dbg !646
  %xor = xor i64 %1, %2, !dbg !647
  %3 = load i64, i64* %s, align 8, !dbg !648
  %sub = sub nsw i64 %xor, %3, !dbg !649
  store i64 %sub, i64* %b.addr, align 8, !dbg !650
  %4 = load i64, i64* %a.addr, align 8, !dbg !651
  %shr1 = ashr i64 %4, 63, !dbg !652
  store i64 %shr1, i64* %s, align 8, !dbg !653
  %5 = load i64, i64* %a.addr, align 8, !dbg !654
  %6 = load i64, i64* %s, align 8, !dbg !655
  %xor2 = xor i64 %5, %6, !dbg !656
  %7 = load i64, i64* %s, align 8, !dbg !657
  %sub3 = sub nsw i64 %xor2, %7, !dbg !658
  store i64 %sub3, i64* %a.addr, align 8, !dbg !659
  %8 = load i64, i64* %a.addr, align 8, !dbg !660
  %9 = load i64, i64* %b.addr, align 8, !dbg !661
  %call = call arm_aapcscc i64 @__udivmoddi4(i64 %8, i64 %9, i64* %r) #4, !dbg !662
  %10 = load i64, i64* %r, align 8, !dbg !663
  %11 = load i64, i64* %s, align 8, !dbg !664
  %xor4 = xor i64 %10, %11, !dbg !665
  %12 = load i64, i64* %s, align 8, !dbg !666
  %sub5 = sub nsw i64 %xor4, %12, !dbg !667
  ret i64 %sub5, !dbg !668
}

; Function Attrs: noinline nounwind
define dso_local arm_aapcscc i32 @__modsi3(i32 %a, i32 %b) #0 !dbg !669 {
entry:
  %a.addr = alloca i32, align 4
  %b.addr = alloca i32, align 4
  store i32 %a, i32* %a.addr, align 4
  store i32 %b, i32* %b.addr, align 4
  %0 = load i32, i32* %a.addr, align 4, !dbg !670
  %1 = load i32, i32* %a.addr, align 4, !dbg !671
  %2 = load i32, i32* %b.addr, align 4, !dbg !672
  %call = call arm_aapcscc i32 @__divsi3(i32 %1, i32 %2) #4, !dbg !673
  %3 = load i32, i32* %b.addr, align 4, !dbg !674
  %mul = mul nsw i32 %call, %3, !dbg !675
  %sub = sub nsw i32 %0, %mul, !dbg !676
  ret i32 %sub, !dbg !677
}

; Function Attrs: noinline nounwind
define dso_local arm_aapcscc i64 @__mulvdi3(i64 %a, i64 %b) #0 !dbg !678 {
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
  store i32 64, i32* %N, align 4, !dbg !679
  store i64 -9223372036854775808, i64* %MIN, align 8, !dbg !680
  store i64 9223372036854775807, i64* %MAX, align 8, !dbg !681
  %0 = load i64, i64* %a.addr, align 8, !dbg !682
  %cmp = icmp eq i64 %0, -9223372036854775808, !dbg !683
  br i1 %cmp, label %if.then, label %if.end4, !dbg !682

if.then:                                          ; preds = %entry
  %1 = load i64, i64* %b.addr, align 8, !dbg !684
  %cmp1 = icmp eq i64 %1, 0, !dbg !685
  br i1 %cmp1, label %if.then3, label %lor.lhs.false, !dbg !686

lor.lhs.false:                                    ; preds = %if.then
  %2 = load i64, i64* %b.addr, align 8, !dbg !687
  %cmp2 = icmp eq i64 %2, 1, !dbg !688
  br i1 %cmp2, label %if.then3, label %if.end, !dbg !684

if.then3:                                         ; preds = %lor.lhs.false, %if.then
  %3 = load i64, i64* %a.addr, align 8, !dbg !689
  %4 = load i64, i64* %b.addr, align 8, !dbg !690
  %mul = mul nsw i64 %3, %4, !dbg !691
  store i64 %mul, i64* %retval, align 8, !dbg !692
  br label %return, !dbg !692

if.end:                                           ; preds = %lor.lhs.false
  call arm_aapcs_vfpcc void @compilerrt_abort_impl(i8* getelementptr inbounds ([10 x i8], [10 x i8]* @.str.8, i32 0, i32 0), i32 31, i8* getelementptr inbounds ([10 x i8], [10 x i8]* @__func__.__mulvdi3, i32 0, i32 0)) #3, !dbg !693
  unreachable, !dbg !693

if.end4:                                          ; preds = %entry
  %5 = load i64, i64* %b.addr, align 8, !dbg !694
  %cmp5 = icmp eq i64 %5, -9223372036854775808, !dbg !695
  br i1 %cmp5, label %if.then6, label %if.end13, !dbg !694

if.then6:                                         ; preds = %if.end4
  %6 = load i64, i64* %a.addr, align 8, !dbg !696
  %cmp7 = icmp eq i64 %6, 0, !dbg !697
  br i1 %cmp7, label %if.then10, label %lor.lhs.false8, !dbg !698

lor.lhs.false8:                                   ; preds = %if.then6
  %7 = load i64, i64* %a.addr, align 8, !dbg !699
  %cmp9 = icmp eq i64 %7, 1, !dbg !700
  br i1 %cmp9, label %if.then10, label %if.end12, !dbg !696

if.then10:                                        ; preds = %lor.lhs.false8, %if.then6
  %8 = load i64, i64* %a.addr, align 8, !dbg !701
  %9 = load i64, i64* %b.addr, align 8, !dbg !702
  %mul11 = mul nsw i64 %8, %9, !dbg !703
  store i64 %mul11, i64* %retval, align 8, !dbg !704
  br label %return, !dbg !704

if.end12:                                         ; preds = %lor.lhs.false8
  call arm_aapcs_vfpcc void @compilerrt_abort_impl(i8* getelementptr inbounds ([10 x i8], [10 x i8]* @.str.8, i32 0, i32 0), i32 37, i8* getelementptr inbounds ([10 x i8], [10 x i8]* @__func__.__mulvdi3, i32 0, i32 0)) #3, !dbg !705
  unreachable, !dbg !705

if.end13:                                         ; preds = %if.end4
  %10 = load i64, i64* %a.addr, align 8, !dbg !706
  %shr = ashr i64 %10, 63, !dbg !707
  store i64 %shr, i64* %sa, align 8, !dbg !708
  %11 = load i64, i64* %a.addr, align 8, !dbg !709
  %12 = load i64, i64* %sa, align 8, !dbg !710
  %xor = xor i64 %11, %12, !dbg !711
  %13 = load i64, i64* %sa, align 8, !dbg !712
  %sub = sub nsw i64 %xor, %13, !dbg !713
  store i64 %sub, i64* %abs_a, align 8, !dbg !714
  %14 = load i64, i64* %b.addr, align 8, !dbg !715
  %shr14 = ashr i64 %14, 63, !dbg !716
  store i64 %shr14, i64* %sb, align 8, !dbg !717
  %15 = load i64, i64* %b.addr, align 8, !dbg !718
  %16 = load i64, i64* %sb, align 8, !dbg !719
  %xor15 = xor i64 %15, %16, !dbg !720
  %17 = load i64, i64* %sb, align 8, !dbg !721
  %sub16 = sub nsw i64 %xor15, %17, !dbg !722
  store i64 %sub16, i64* %abs_b, align 8, !dbg !723
  %18 = load i64, i64* %abs_a, align 8, !dbg !724
  %cmp17 = icmp slt i64 %18, 2, !dbg !725
  br i1 %cmp17, label %if.then20, label %lor.lhs.false18, !dbg !726

lor.lhs.false18:                                  ; preds = %if.end13
  %19 = load i64, i64* %abs_b, align 8, !dbg !727
  %cmp19 = icmp slt i64 %19, 2, !dbg !728
  br i1 %cmp19, label %if.then20, label %if.end22, !dbg !724

if.then20:                                        ; preds = %lor.lhs.false18, %if.end13
  %20 = load i64, i64* %a.addr, align 8, !dbg !729
  %21 = load i64, i64* %b.addr, align 8, !dbg !730
  %mul21 = mul nsw i64 %20, %21, !dbg !731
  store i64 %mul21, i64* %retval, align 8, !dbg !732
  br label %return, !dbg !732

if.end22:                                         ; preds = %lor.lhs.false18
  %22 = load i64, i64* %sa, align 8, !dbg !733
  %23 = load i64, i64* %sb, align 8, !dbg !734
  %cmp23 = icmp eq i64 %22, %23, !dbg !735
  br i1 %cmp23, label %if.then24, label %if.else, !dbg !733

if.then24:                                        ; preds = %if.end22
  %24 = load i64, i64* %abs_a, align 8, !dbg !736
  %25 = load i64, i64* %abs_b, align 8, !dbg !737
  %div = sdiv i64 9223372036854775807, %25, !dbg !738
  %cmp25 = icmp sgt i64 %24, %div, !dbg !739
  br i1 %cmp25, label %if.then26, label %if.end27, !dbg !736

if.then26:                                        ; preds = %if.then24
  call arm_aapcs_vfpcc void @compilerrt_abort_impl(i8* getelementptr inbounds ([10 x i8], [10 x i8]* @.str.8, i32 0, i32 0), i32 48, i8* getelementptr inbounds ([10 x i8], [10 x i8]* @__func__.__mulvdi3, i32 0, i32 0)) #3, !dbg !740
  unreachable, !dbg !740

if.end27:                                         ; preds = %if.then24
  br label %if.end33, !dbg !741

if.else:                                          ; preds = %if.end22
  %26 = load i64, i64* %abs_a, align 8, !dbg !742
  %27 = load i64, i64* %abs_b, align 8, !dbg !743
  %sub28 = sub nsw i64 0, %27, !dbg !744
  %div29 = sdiv i64 -9223372036854775808, %sub28, !dbg !745
  %cmp30 = icmp sgt i64 %26, %div29, !dbg !746
  br i1 %cmp30, label %if.then31, label %if.end32, !dbg !742

if.then31:                                        ; preds = %if.else
  call arm_aapcs_vfpcc void @compilerrt_abort_impl(i8* getelementptr inbounds ([10 x i8], [10 x i8]* @.str.8, i32 0, i32 0), i32 53, i8* getelementptr inbounds ([10 x i8], [10 x i8]* @__func__.__mulvdi3, i32 0, i32 0)) #3, !dbg !747
  unreachable, !dbg !747

if.end32:                                         ; preds = %if.else
  br label %if.end33

if.end33:                                         ; preds = %if.end32, %if.end27
  %28 = load i64, i64* %a.addr, align 8, !dbg !748
  %29 = load i64, i64* %b.addr, align 8, !dbg !749
  %mul34 = mul nsw i64 %28, %29, !dbg !750
  store i64 %mul34, i64* %retval, align 8, !dbg !751
  br label %return, !dbg !751

return:                                           ; preds = %if.end33, %if.then20, %if.then10, %if.then3
  %30 = load i64, i64* %retval, align 8, !dbg !752
  ret i64 %30, !dbg !752
}

; Function Attrs: noinline nounwind
define dso_local arm_aapcscc i32 @__mulvsi3(i32 %a, i32 %b) #0 !dbg !753 {
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
  store i32 32, i32* %N, align 4, !dbg !754
  store i32 -2147483648, i32* %MIN, align 4, !dbg !755
  store i32 2147483647, i32* %MAX, align 4, !dbg !756
  %0 = load i32, i32* %a.addr, align 4, !dbg !757
  %cmp = icmp eq i32 %0, -2147483648, !dbg !758
  br i1 %cmp, label %if.then, label %if.end4, !dbg !757

if.then:                                          ; preds = %entry
  %1 = load i32, i32* %b.addr, align 4, !dbg !759
  %cmp1 = icmp eq i32 %1, 0, !dbg !760
  br i1 %cmp1, label %if.then3, label %lor.lhs.false, !dbg !761

lor.lhs.false:                                    ; preds = %if.then
  %2 = load i32, i32* %b.addr, align 4, !dbg !762
  %cmp2 = icmp eq i32 %2, 1, !dbg !763
  br i1 %cmp2, label %if.then3, label %if.end, !dbg !759

if.then3:                                         ; preds = %lor.lhs.false, %if.then
  %3 = load i32, i32* %a.addr, align 4, !dbg !764
  %4 = load i32, i32* %b.addr, align 4, !dbg !765
  %mul = mul nsw i32 %3, %4, !dbg !766
  store i32 %mul, i32* %retval, align 4, !dbg !767
  br label %return, !dbg !767

if.end:                                           ; preds = %lor.lhs.false
  call arm_aapcs_vfpcc void @compilerrt_abort_impl(i8* getelementptr inbounds ([10 x i8], [10 x i8]* @.str.9, i32 0, i32 0), i32 31, i8* getelementptr inbounds ([10 x i8], [10 x i8]* @__func__.__mulvsi3, i32 0, i32 0)) #3, !dbg !768
  unreachable, !dbg !768

if.end4:                                          ; preds = %entry
  %5 = load i32, i32* %b.addr, align 4, !dbg !769
  %cmp5 = icmp eq i32 %5, -2147483648, !dbg !770
  br i1 %cmp5, label %if.then6, label %if.end13, !dbg !769

if.then6:                                         ; preds = %if.end4
  %6 = load i32, i32* %a.addr, align 4, !dbg !771
  %cmp7 = icmp eq i32 %6, 0, !dbg !772
  br i1 %cmp7, label %if.then10, label %lor.lhs.false8, !dbg !773

lor.lhs.false8:                                   ; preds = %if.then6
  %7 = load i32, i32* %a.addr, align 4, !dbg !774
  %cmp9 = icmp eq i32 %7, 1, !dbg !775
  br i1 %cmp9, label %if.then10, label %if.end12, !dbg !771

if.then10:                                        ; preds = %lor.lhs.false8, %if.then6
  %8 = load i32, i32* %a.addr, align 4, !dbg !776
  %9 = load i32, i32* %b.addr, align 4, !dbg !777
  %mul11 = mul nsw i32 %8, %9, !dbg !778
  store i32 %mul11, i32* %retval, align 4, !dbg !779
  br label %return, !dbg !779

if.end12:                                         ; preds = %lor.lhs.false8
  call arm_aapcs_vfpcc void @compilerrt_abort_impl(i8* getelementptr inbounds ([10 x i8], [10 x i8]* @.str.9, i32 0, i32 0), i32 37, i8* getelementptr inbounds ([10 x i8], [10 x i8]* @__func__.__mulvsi3, i32 0, i32 0)) #3, !dbg !780
  unreachable, !dbg !780

if.end13:                                         ; preds = %if.end4
  %10 = load i32, i32* %a.addr, align 4, !dbg !781
  %shr = ashr i32 %10, 31, !dbg !782
  store i32 %shr, i32* %sa, align 4, !dbg !783
  %11 = load i32, i32* %a.addr, align 4, !dbg !784
  %12 = load i32, i32* %sa, align 4, !dbg !785
  %xor = xor i32 %11, %12, !dbg !786
  %13 = load i32, i32* %sa, align 4, !dbg !787
  %sub = sub nsw i32 %xor, %13, !dbg !788
  store i32 %sub, i32* %abs_a, align 4, !dbg !789
  %14 = load i32, i32* %b.addr, align 4, !dbg !790
  %shr14 = ashr i32 %14, 31, !dbg !791
  store i32 %shr14, i32* %sb, align 4, !dbg !792
  %15 = load i32, i32* %b.addr, align 4, !dbg !793
  %16 = load i32, i32* %sb, align 4, !dbg !794
  %xor15 = xor i32 %15, %16, !dbg !795
  %17 = load i32, i32* %sb, align 4, !dbg !796
  %sub16 = sub nsw i32 %xor15, %17, !dbg !797
  store i32 %sub16, i32* %abs_b, align 4, !dbg !798
  %18 = load i32, i32* %abs_a, align 4, !dbg !799
  %cmp17 = icmp slt i32 %18, 2, !dbg !800
  br i1 %cmp17, label %if.then20, label %lor.lhs.false18, !dbg !801

lor.lhs.false18:                                  ; preds = %if.end13
  %19 = load i32, i32* %abs_b, align 4, !dbg !802
  %cmp19 = icmp slt i32 %19, 2, !dbg !803
  br i1 %cmp19, label %if.then20, label %if.end22, !dbg !799

if.then20:                                        ; preds = %lor.lhs.false18, %if.end13
  %20 = load i32, i32* %a.addr, align 4, !dbg !804
  %21 = load i32, i32* %b.addr, align 4, !dbg !805
  %mul21 = mul nsw i32 %20, %21, !dbg !806
  store i32 %mul21, i32* %retval, align 4, !dbg !807
  br label %return, !dbg !807

if.end22:                                         ; preds = %lor.lhs.false18
  %22 = load i32, i32* %sa, align 4, !dbg !808
  %23 = load i32, i32* %sb, align 4, !dbg !809
  %cmp23 = icmp eq i32 %22, %23, !dbg !810
  br i1 %cmp23, label %if.then24, label %if.else, !dbg !808

if.then24:                                        ; preds = %if.end22
  %24 = load i32, i32* %abs_a, align 4, !dbg !811
  %25 = load i32, i32* %abs_b, align 4, !dbg !812
  %div = sdiv i32 2147483647, %25, !dbg !813
  %cmp25 = icmp sgt i32 %24, %div, !dbg !814
  br i1 %cmp25, label %if.then26, label %if.end27, !dbg !811

if.then26:                                        ; preds = %if.then24
  call arm_aapcs_vfpcc void @compilerrt_abort_impl(i8* getelementptr inbounds ([10 x i8], [10 x i8]* @.str.9, i32 0, i32 0), i32 48, i8* getelementptr inbounds ([10 x i8], [10 x i8]* @__func__.__mulvsi3, i32 0, i32 0)) #3, !dbg !815
  unreachable, !dbg !815

if.end27:                                         ; preds = %if.then24
  br label %if.end33, !dbg !816

if.else:                                          ; preds = %if.end22
  %26 = load i32, i32* %abs_a, align 4, !dbg !817
  %27 = load i32, i32* %abs_b, align 4, !dbg !818
  %sub28 = sub nsw i32 0, %27, !dbg !819
  %div29 = sdiv i32 -2147483648, %sub28, !dbg !820
  %cmp30 = icmp sgt i32 %26, %div29, !dbg !821
  br i1 %cmp30, label %if.then31, label %if.end32, !dbg !817

if.then31:                                        ; preds = %if.else
  call arm_aapcs_vfpcc void @compilerrt_abort_impl(i8* getelementptr inbounds ([10 x i8], [10 x i8]* @.str.9, i32 0, i32 0), i32 53, i8* getelementptr inbounds ([10 x i8], [10 x i8]* @__func__.__mulvsi3, i32 0, i32 0)) #3, !dbg !822
  unreachable, !dbg !822

if.end32:                                         ; preds = %if.else
  br label %if.end33

if.end33:                                         ; preds = %if.end32, %if.end27
  %28 = load i32, i32* %a.addr, align 4, !dbg !823
  %29 = load i32, i32* %b.addr, align 4, !dbg !824
  %mul34 = mul nsw i32 %28, %29, !dbg !825
  store i32 %mul34, i32* %retval, align 4, !dbg !826
  br label %return, !dbg !826

return:                                           ; preds = %if.end33, %if.then20, %if.then10, %if.then3
  %30 = load i32, i32* %retval, align 4, !dbg !827
  ret i32 %30, !dbg !827
}

; Function Attrs: noinline nounwind
define dso_local arm_aapcscc i32 @__paritydi2(i64 %a) #0 !dbg !828 {
entry:
  %a.addr = alloca i64, align 8
  %x = alloca %union.dwords, align 8
  store i64 %a, i64* %a.addr, align 8
  %0 = load i64, i64* %a.addr, align 8, !dbg !829
  %all = bitcast %union.dwords* %x to i64*, !dbg !830
  store i64 %0, i64* %all, align 8, !dbg !831
  %s = bitcast %union.dwords* %x to %struct.anon*, !dbg !832
  %high = getelementptr inbounds %struct.anon, %struct.anon* %s, i32 0, i32 1, !dbg !833
  %1 = load i32, i32* %high, align 4, !dbg !833
  %s1 = bitcast %union.dwords* %x to %struct.anon*, !dbg !834
  %low = getelementptr inbounds %struct.anon, %struct.anon* %s1, i32 0, i32 0, !dbg !835
  %2 = load i32, i32* %low, align 8, !dbg !835
  %xor = xor i32 %1, %2, !dbg !836
  %call = call arm_aapcscc i32 @__paritysi2(i32 %xor) #4, !dbg !837
  ret i32 %call, !dbg !838
}

; Function Attrs: noinline nounwind
define dso_local arm_aapcscc i32 @__paritysi2(i32 %a) #0 !dbg !839 {
entry:
  %a.addr = alloca i32, align 4
  %x = alloca i32, align 4
  store i32 %a, i32* %a.addr, align 4
  %0 = load i32, i32* %a.addr, align 4, !dbg !840
  store i32 %0, i32* %x, align 4, !dbg !841
  %1 = load i32, i32* %x, align 4, !dbg !842
  %shr = lshr i32 %1, 16, !dbg !843
  %2 = load i32, i32* %x, align 4, !dbg !844
  %xor = xor i32 %2, %shr, !dbg !844
  store i32 %xor, i32* %x, align 4, !dbg !844
  %3 = load i32, i32* %x, align 4, !dbg !845
  %shr1 = lshr i32 %3, 8, !dbg !846
  %4 = load i32, i32* %x, align 4, !dbg !847
  %xor2 = xor i32 %4, %shr1, !dbg !847
  store i32 %xor2, i32* %x, align 4, !dbg !847
  %5 = load i32, i32* %x, align 4, !dbg !848
  %shr3 = lshr i32 %5, 4, !dbg !849
  %6 = load i32, i32* %x, align 4, !dbg !850
  %xor4 = xor i32 %6, %shr3, !dbg !850
  store i32 %xor4, i32* %x, align 4, !dbg !850
  %7 = load i32, i32* %x, align 4, !dbg !851
  %and = and i32 %7, 15, !dbg !852
  %shr5 = ashr i32 27030, %and, !dbg !853
  %and6 = and i32 %shr5, 1, !dbg !854
  ret i32 %and6, !dbg !855
}

; Function Attrs: noinline nounwind
define dso_local arm_aapcscc i32 @__popcountdi2(i64 %a) #0 !dbg !856 {
entry:
  %a.addr = alloca i64, align 8
  %x2 = alloca i64, align 8
  %x = alloca i32, align 4
  store i64 %a, i64* %a.addr, align 8
  %0 = load i64, i64* %a.addr, align 8, !dbg !857
  store i64 %0, i64* %x2, align 8, !dbg !858
  %1 = load i64, i64* %x2, align 8, !dbg !859
  %2 = load i64, i64* %x2, align 8, !dbg !860
  %shr = lshr i64 %2, 1, !dbg !861
  %and = and i64 %shr, 6148914691236517205, !dbg !862
  %sub = sub i64 %1, %and, !dbg !863
  store i64 %sub, i64* %x2, align 8, !dbg !864
  %3 = load i64, i64* %x2, align 8, !dbg !865
  %shr1 = lshr i64 %3, 2, !dbg !866
  %and2 = and i64 %shr1, 3689348814741910323, !dbg !867
  %4 = load i64, i64* %x2, align 8, !dbg !868
  %and3 = and i64 %4, 3689348814741910323, !dbg !869
  %add = add i64 %and2, %and3, !dbg !870
  store i64 %add, i64* %x2, align 8, !dbg !871
  %5 = load i64, i64* %x2, align 8, !dbg !872
  %6 = load i64, i64* %x2, align 8, !dbg !873
  %shr4 = lshr i64 %6, 4, !dbg !874
  %add5 = add i64 %5, %shr4, !dbg !875
  %and6 = and i64 %add5, 1085102592571150095, !dbg !876
  store i64 %and6, i64* %x2, align 8, !dbg !877
  %7 = load i64, i64* %x2, align 8, !dbg !878
  %8 = load i64, i64* %x2, align 8, !dbg !879
  %shr7 = lshr i64 %8, 32, !dbg !880
  %add8 = add i64 %7, %shr7, !dbg !881
  %conv = trunc i64 %add8 to i32, !dbg !882
  store i32 %conv, i32* %x, align 4, !dbg !883
  %9 = load i32, i32* %x, align 4, !dbg !884
  %10 = load i32, i32* %x, align 4, !dbg !885
  %shr9 = lshr i32 %10, 16, !dbg !886
  %add10 = add i32 %9, %shr9, !dbg !887
  store i32 %add10, i32* %x, align 4, !dbg !888
  %11 = load i32, i32* %x, align 4, !dbg !889
  %12 = load i32, i32* %x, align 4, !dbg !890
  %shr11 = lshr i32 %12, 8, !dbg !891
  %add12 = add i32 %11, %shr11, !dbg !892
  %and13 = and i32 %add12, 127, !dbg !893
  ret i32 %and13, !dbg !894
}

; Function Attrs: noinline nounwind
define dso_local arm_aapcscc i32 @__popcountsi2(i32 %a) #0 !dbg !895 {
entry:
  %a.addr = alloca i32, align 4
  %x = alloca i32, align 4
  store i32 %a, i32* %a.addr, align 4
  %0 = load i32, i32* %a.addr, align 4, !dbg !896
  store i32 %0, i32* %x, align 4, !dbg !897
  %1 = load i32, i32* %x, align 4, !dbg !898
  %2 = load i32, i32* %x, align 4, !dbg !899
  %shr = lshr i32 %2, 1, !dbg !900
  %and = and i32 %shr, 1431655765, !dbg !901
  %sub = sub i32 %1, %and, !dbg !902
  store i32 %sub, i32* %x, align 4, !dbg !903
  %3 = load i32, i32* %x, align 4, !dbg !904
  %shr1 = lshr i32 %3, 2, !dbg !905
  %and2 = and i32 %shr1, 858993459, !dbg !906
  %4 = load i32, i32* %x, align 4, !dbg !907
  %and3 = and i32 %4, 858993459, !dbg !908
  %add = add i32 %and2, %and3, !dbg !909
  store i32 %add, i32* %x, align 4, !dbg !910
  %5 = load i32, i32* %x, align 4, !dbg !911
  %6 = load i32, i32* %x, align 4, !dbg !912
  %shr4 = lshr i32 %6, 4, !dbg !913
  %add5 = add i32 %5, %shr4, !dbg !914
  %and6 = and i32 %add5, 252645135, !dbg !915
  store i32 %and6, i32* %x, align 4, !dbg !916
  %7 = load i32, i32* %x, align 4, !dbg !917
  %8 = load i32, i32* %x, align 4, !dbg !918
  %shr7 = lshr i32 %8, 16, !dbg !919
  %add8 = add i32 %7, %shr7, !dbg !920
  store i32 %add8, i32* %x, align 4, !dbg !921
  %9 = load i32, i32* %x, align 4, !dbg !922
  %10 = load i32, i32* %x, align 4, !dbg !923
  %shr9 = lshr i32 %10, 8, !dbg !924
  %add10 = add i32 %9, %shr9, !dbg !925
  %and11 = and i32 %add10, 63, !dbg !926
  ret i32 %and11, !dbg !927
}

; Function Attrs: noinline nounwind
define dso_local arm_aapcscc i64 @__subvdi3(i64 %a, i64 %b) #0 !dbg !928 {
entry:
  %a.addr = alloca i64, align 8
  %b.addr = alloca i64, align 8
  %s = alloca i64, align 8
  store i64 %a, i64* %a.addr, align 8
  store i64 %b, i64* %b.addr, align 8
  %0 = load i64, i64* %a.addr, align 8, !dbg !929
  %1 = load i64, i64* %b.addr, align 8, !dbg !930
  %sub = sub i64 %0, %1, !dbg !931
  store i64 %sub, i64* %s, align 8, !dbg !932
  %2 = load i64, i64* %b.addr, align 8, !dbg !933
  %cmp = icmp sge i64 %2, 0, !dbg !934
  br i1 %cmp, label %if.then, label %if.else, !dbg !933

if.then:                                          ; preds = %entry
  %3 = load i64, i64* %s, align 8, !dbg !935
  %4 = load i64, i64* %a.addr, align 8, !dbg !936
  %cmp1 = icmp sgt i64 %3, %4, !dbg !937
  br i1 %cmp1, label %if.then2, label %if.end, !dbg !935

if.then2:                                         ; preds = %if.then
  call arm_aapcs_vfpcc void @compilerrt_abort_impl(i8* getelementptr inbounds ([10 x i8], [10 x i8]* @.str.12, i32 0, i32 0), i32 28, i8* getelementptr inbounds ([10 x i8], [10 x i8]* @__func__.__subvdi3, i32 0, i32 0)) #3, !dbg !938
  unreachable, !dbg !938

if.end:                                           ; preds = %if.then
  br label %if.end6, !dbg !939

if.else:                                          ; preds = %entry
  %5 = load i64, i64* %s, align 8, !dbg !940
  %6 = load i64, i64* %a.addr, align 8, !dbg !941
  %cmp3 = icmp sle i64 %5, %6, !dbg !942
  br i1 %cmp3, label %if.then4, label %if.end5, !dbg !940

if.then4:                                         ; preds = %if.else
  call arm_aapcs_vfpcc void @compilerrt_abort_impl(i8* getelementptr inbounds ([10 x i8], [10 x i8]* @.str.12, i32 0, i32 0), i32 33, i8* getelementptr inbounds ([10 x i8], [10 x i8]* @__func__.__subvdi3, i32 0, i32 0)) #3, !dbg !943
  unreachable, !dbg !943

if.end5:                                          ; preds = %if.else
  br label %if.end6

if.end6:                                          ; preds = %if.end5, %if.end
  %7 = load i64, i64* %s, align 8, !dbg !944
  ret i64 %7, !dbg !945
}

; Function Attrs: noinline nounwind
define dso_local arm_aapcscc i32 @__subvsi3(i32 %a, i32 %b) #0 !dbg !946 {
entry:
  %a.addr = alloca i32, align 4
  %b.addr = alloca i32, align 4
  %s = alloca i32, align 4
  store i32 %a, i32* %a.addr, align 4
  store i32 %b, i32* %b.addr, align 4
  %0 = load i32, i32* %a.addr, align 4, !dbg !947
  %1 = load i32, i32* %b.addr, align 4, !dbg !948
  %sub = sub i32 %0, %1, !dbg !949
  store i32 %sub, i32* %s, align 4, !dbg !950
  %2 = load i32, i32* %b.addr, align 4, !dbg !951
  %cmp = icmp sge i32 %2, 0, !dbg !952
  br i1 %cmp, label %if.then, label %if.else, !dbg !951

if.then:                                          ; preds = %entry
  %3 = load i32, i32* %s, align 4, !dbg !953
  %4 = load i32, i32* %a.addr, align 4, !dbg !954
  %cmp1 = icmp sgt i32 %3, %4, !dbg !955
  br i1 %cmp1, label %if.then2, label %if.end, !dbg !953

if.then2:                                         ; preds = %if.then
  call arm_aapcs_vfpcc void @compilerrt_abort_impl(i8* getelementptr inbounds ([10 x i8], [10 x i8]* @.str.13, i32 0, i32 0), i32 28, i8* getelementptr inbounds ([10 x i8], [10 x i8]* @__func__.__subvsi3, i32 0, i32 0)) #3, !dbg !956
  unreachable, !dbg !956

if.end:                                           ; preds = %if.then
  br label %if.end6, !dbg !957

if.else:                                          ; preds = %entry
  %5 = load i32, i32* %s, align 4, !dbg !958
  %6 = load i32, i32* %a.addr, align 4, !dbg !959
  %cmp3 = icmp sle i32 %5, %6, !dbg !960
  br i1 %cmp3, label %if.then4, label %if.end5, !dbg !958

if.then4:                                         ; preds = %if.else
  call arm_aapcs_vfpcc void @compilerrt_abort_impl(i8* getelementptr inbounds ([10 x i8], [10 x i8]* @.str.13, i32 0, i32 0), i32 33, i8* getelementptr inbounds ([10 x i8], [10 x i8]* @__func__.__subvsi3, i32 0, i32 0)) #3, !dbg !961
  unreachable, !dbg !961

if.end5:                                          ; preds = %if.else
  br label %if.end6

if.end6:                                          ; preds = %if.end5, %if.end
  %7 = load i32, i32* %s, align 4, !dbg !962
  ret i32 %7, !dbg !963
}

; Function Attrs: noinline nounwind
define dso_local arm_aapcscc i32 @__ucmpdi2(i64 %a, i64 %b) #0 !dbg !964 {
entry:
  %retval = alloca i32, align 4
  %a.addr = alloca i64, align 8
  %b.addr = alloca i64, align 8
  %x = alloca %union.dwords, align 8
  %y = alloca %union.dwords, align 8
  store i64 %a, i64* %a.addr, align 8
  store i64 %b, i64* %b.addr, align 8
  %0 = load i64, i64* %a.addr, align 8, !dbg !965
  %all = bitcast %union.dwords* %x to i64*, !dbg !966
  store i64 %0, i64* %all, align 8, !dbg !967
  %1 = load i64, i64* %b.addr, align 8, !dbg !968
  %all1 = bitcast %union.dwords* %y to i64*, !dbg !969
  store i64 %1, i64* %all1, align 8, !dbg !970
  %s = bitcast %union.dwords* %x to %struct.anon*, !dbg !971
  %high = getelementptr inbounds %struct.anon, %struct.anon* %s, i32 0, i32 1, !dbg !972
  %2 = load i32, i32* %high, align 4, !dbg !972
  %s2 = bitcast %union.dwords* %y to %struct.anon*, !dbg !973
  %high3 = getelementptr inbounds %struct.anon, %struct.anon* %s2, i32 0, i32 1, !dbg !974
  %3 = load i32, i32* %high3, align 4, !dbg !974
  %cmp = icmp ult i32 %2, %3, !dbg !975
  br i1 %cmp, label %if.then, label %if.end, !dbg !976

if.then:                                          ; preds = %entry
  store i32 0, i32* %retval, align 4, !dbg !977
  br label %return, !dbg !977

if.end:                                           ; preds = %entry
  %s4 = bitcast %union.dwords* %x to %struct.anon*, !dbg !978
  %high5 = getelementptr inbounds %struct.anon, %struct.anon* %s4, i32 0, i32 1, !dbg !979
  %4 = load i32, i32* %high5, align 4, !dbg !979
  %s6 = bitcast %union.dwords* %y to %struct.anon*, !dbg !980
  %high7 = getelementptr inbounds %struct.anon, %struct.anon* %s6, i32 0, i32 1, !dbg !981
  %5 = load i32, i32* %high7, align 4, !dbg !981
  %cmp8 = icmp ugt i32 %4, %5, !dbg !982
  br i1 %cmp8, label %if.then9, label %if.end10, !dbg !983

if.then9:                                         ; preds = %if.end
  store i32 2, i32* %retval, align 4, !dbg !984
  br label %return, !dbg !984

if.end10:                                         ; preds = %if.end
  %s11 = bitcast %union.dwords* %x to %struct.anon*, !dbg !985
  %low = getelementptr inbounds %struct.anon, %struct.anon* %s11, i32 0, i32 0, !dbg !986
  %6 = load i32, i32* %low, align 8, !dbg !986
  %s12 = bitcast %union.dwords* %y to %struct.anon*, !dbg !987
  %low13 = getelementptr inbounds %struct.anon, %struct.anon* %s12, i32 0, i32 0, !dbg !988
  %7 = load i32, i32* %low13, align 8, !dbg !988
  %cmp14 = icmp ult i32 %6, %7, !dbg !989
  br i1 %cmp14, label %if.then15, label %if.end16, !dbg !990

if.then15:                                        ; preds = %if.end10
  store i32 0, i32* %retval, align 4, !dbg !991
  br label %return, !dbg !991

if.end16:                                         ; preds = %if.end10
  %s17 = bitcast %union.dwords* %x to %struct.anon*, !dbg !992
  %low18 = getelementptr inbounds %struct.anon, %struct.anon* %s17, i32 0, i32 0, !dbg !993
  %8 = load i32, i32* %low18, align 8, !dbg !993
  %s19 = bitcast %union.dwords* %y to %struct.anon*, !dbg !994
  %low20 = getelementptr inbounds %struct.anon, %struct.anon* %s19, i32 0, i32 0, !dbg !995
  %9 = load i32, i32* %low20, align 8, !dbg !995
  %cmp21 = icmp ugt i32 %8, %9, !dbg !996
  br i1 %cmp21, label %if.then22, label %if.end23, !dbg !997

if.then22:                                        ; preds = %if.end16
  store i32 2, i32* %retval, align 4, !dbg !998
  br label %return, !dbg !998

if.end23:                                         ; preds = %if.end16
  store i32 1, i32* %retval, align 4, !dbg !999
  br label %return, !dbg !999

return:                                           ; preds = %if.end23, %if.then22, %if.then15, %if.then9, %if.then
  %10 = load i32, i32* %retval, align 4, !dbg !1000
  ret i32 %10, !dbg !1000
}

; Function Attrs: noinline nounwind
define dso_local arm_aapcscc i32 @__aeabi_ulcmp(i64 %a, i64 %b) #0 !dbg !1001 {
entry:
  %a.addr = alloca i64, align 8
  %b.addr = alloca i64, align 8
  store i64 %a, i64* %a.addr, align 8
  store i64 %b, i64* %b.addr, align 8
  %0 = load i64, i64* %a.addr, align 8, !dbg !1002
  %1 = load i64, i64* %b.addr, align 8, !dbg !1003
  %call = call arm_aapcscc i32 @__ucmpdi2(i64 %0, i64 %1) #4, !dbg !1004
  %sub = sub nsw i32 %call, 1, !dbg !1005
  ret i32 %sub, !dbg !1006
}

; Function Attrs: noinline nounwind
define dso_local arm_aapcscc i64 @__udivdi3(i64 %a, i64 %b) #0 !dbg !1007 {
entry:
  %a.addr = alloca i64, align 8
  %b.addr = alloca i64, align 8
  store i64 %a, i64* %a.addr, align 8
  store i64 %b, i64* %b.addr, align 8
  %0 = load i64, i64* %a.addr, align 8, !dbg !1008
  %1 = load i64, i64* %b.addr, align 8, !dbg !1009
  %call = call arm_aapcscc i64 @__udivmoddi4(i64 %0, i64 %1, i64* null) #4, !dbg !1010
  ret i64 %call, !dbg !1011
}

; Function Attrs: noinline nounwind
define dso_local arm_aapcscc i64 @__udivmoddi4(i64 %a, i64 %b, i64* %rem) #0 !dbg !1012 {
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
  store i32 32, i32* %n_uword_bits, align 4, !dbg !1013
  store i32 64, i32* %n_udword_bits, align 4, !dbg !1014
  %0 = load i64, i64* %a.addr, align 8, !dbg !1015
  %all = bitcast %union.dwords* %n to i64*, !dbg !1016
  store i64 %0, i64* %all, align 8, !dbg !1017
  %1 = load i64, i64* %b.addr, align 8, !dbg !1018
  %all1 = bitcast %union.dwords* %d to i64*, !dbg !1019
  store i64 %1, i64* %all1, align 8, !dbg !1020
  %s = bitcast %union.dwords* %n to %struct.anon*, !dbg !1021
  %high = getelementptr inbounds %struct.anon, %struct.anon* %s, i32 0, i32 1, !dbg !1022
  %2 = load i32, i32* %high, align 4, !dbg !1022
  %cmp = icmp eq i32 %2, 0, !dbg !1023
  br i1 %cmp, label %if.then, label %if.end23, !dbg !1024

if.then:                                          ; preds = %entry
  %s2 = bitcast %union.dwords* %d to %struct.anon*, !dbg !1025
  %high3 = getelementptr inbounds %struct.anon, %struct.anon* %s2, i32 0, i32 1, !dbg !1026
  %3 = load i32, i32* %high3, align 4, !dbg !1026
  %cmp4 = icmp eq i32 %3, 0, !dbg !1027
  br i1 %cmp4, label %if.then5, label %if.end16, !dbg !1028

if.then5:                                         ; preds = %if.then
  %4 = load i64*, i64** %rem.addr, align 4, !dbg !1029
  %tobool = icmp ne i64* %4, null, !dbg !1029
  br i1 %tobool, label %if.then6, label %if.end, !dbg !1029

if.then6:                                         ; preds = %if.then5
  %s7 = bitcast %union.dwords* %n to %struct.anon*, !dbg !1030
  %low = getelementptr inbounds %struct.anon, %struct.anon* %s7, i32 0, i32 0, !dbg !1031
  %5 = load i32, i32* %low, align 8, !dbg !1031
  %s8 = bitcast %union.dwords* %d to %struct.anon*, !dbg !1032
  %low9 = getelementptr inbounds %struct.anon, %struct.anon* %s8, i32 0, i32 0, !dbg !1033
  %6 = load i32, i32* %low9, align 8, !dbg !1033
  %rem10 = urem i32 %5, %6, !dbg !1034
  %conv = zext i32 %rem10 to i64, !dbg !1035
  %7 = load i64*, i64** %rem.addr, align 4, !dbg !1036
  store i64 %conv, i64* %7, align 8, !dbg !1037
  br label %if.end, !dbg !1038

if.end:                                           ; preds = %if.then6, %if.then5
  %s11 = bitcast %union.dwords* %n to %struct.anon*, !dbg !1039
  %low12 = getelementptr inbounds %struct.anon, %struct.anon* %s11, i32 0, i32 0, !dbg !1040
  %8 = load i32, i32* %low12, align 8, !dbg !1040
  %s13 = bitcast %union.dwords* %d to %struct.anon*, !dbg !1041
  %low14 = getelementptr inbounds %struct.anon, %struct.anon* %s13, i32 0, i32 0, !dbg !1042
  %9 = load i32, i32* %low14, align 8, !dbg !1042
  %div = udiv i32 %8, %9, !dbg !1043
  %conv15 = zext i32 %div to i64, !dbg !1044
  store i64 %conv15, i64* %retval, align 8, !dbg !1045
  br label %return, !dbg !1045

if.end16:                                         ; preds = %if.then
  %10 = load i64*, i64** %rem.addr, align 4, !dbg !1046
  %tobool17 = icmp ne i64* %10, null, !dbg !1046
  br i1 %tobool17, label %if.then18, label %if.end22, !dbg !1046

if.then18:                                        ; preds = %if.end16
  %s19 = bitcast %union.dwords* %n to %struct.anon*, !dbg !1047
  %low20 = getelementptr inbounds %struct.anon, %struct.anon* %s19, i32 0, i32 0, !dbg !1048
  %11 = load i32, i32* %low20, align 8, !dbg !1048
  %conv21 = zext i32 %11 to i64, !dbg !1049
  %12 = load i64*, i64** %rem.addr, align 4, !dbg !1050
  store i64 %conv21, i64* %12, align 8, !dbg !1051
  br label %if.end22, !dbg !1052

if.end22:                                         ; preds = %if.then18, %if.end16
  store i64 0, i64* %retval, align 8, !dbg !1053
  br label %return, !dbg !1053

if.end23:                                         ; preds = %entry
  %s24 = bitcast %union.dwords* %d to %struct.anon*, !dbg !1054
  %low25 = getelementptr inbounds %struct.anon, %struct.anon* %s24, i32 0, i32 0, !dbg !1055
  %13 = load i32, i32* %low25, align 8, !dbg !1055
  %cmp26 = icmp eq i32 %13, 0, !dbg !1056
  br i1 %cmp26, label %if.then28, label %if.else, !dbg !1057

if.then28:                                        ; preds = %if.end23
  %s29 = bitcast %union.dwords* %d to %struct.anon*, !dbg !1058
  %high30 = getelementptr inbounds %struct.anon, %struct.anon* %s29, i32 0, i32 1, !dbg !1059
  %14 = load i32, i32* %high30, align 4, !dbg !1059
  %cmp31 = icmp eq i32 %14, 0, !dbg !1060
  br i1 %cmp31, label %if.then33, label %if.end49, !dbg !1061

if.then33:                                        ; preds = %if.then28
  %15 = load i64*, i64** %rem.addr, align 4, !dbg !1062
  %tobool34 = icmp ne i64* %15, null, !dbg !1062
  br i1 %tobool34, label %if.then35, label %if.end42, !dbg !1062

if.then35:                                        ; preds = %if.then33
  %s36 = bitcast %union.dwords* %n to %struct.anon*, !dbg !1063
  %high37 = getelementptr inbounds %struct.anon, %struct.anon* %s36, i32 0, i32 1, !dbg !1064
  %16 = load i32, i32* %high37, align 4, !dbg !1064
  %s38 = bitcast %union.dwords* %d to %struct.anon*, !dbg !1065
  %low39 = getelementptr inbounds %struct.anon, %struct.anon* %s38, i32 0, i32 0, !dbg !1066
  %17 = load i32, i32* %low39, align 8, !dbg !1066
  %rem40 = urem i32 %16, %17, !dbg !1067
  %conv41 = zext i32 %rem40 to i64, !dbg !1068
  %18 = load i64*, i64** %rem.addr, align 4, !dbg !1069
  store i64 %conv41, i64* %18, align 8, !dbg !1070
  br label %if.end42, !dbg !1071

if.end42:                                         ; preds = %if.then35, %if.then33
  %s43 = bitcast %union.dwords* %n to %struct.anon*, !dbg !1072
  %high44 = getelementptr inbounds %struct.anon, %struct.anon* %s43, i32 0, i32 1, !dbg !1073
  %19 = load i32, i32* %high44, align 4, !dbg !1073
  %s45 = bitcast %union.dwords* %d to %struct.anon*, !dbg !1074
  %low46 = getelementptr inbounds %struct.anon, %struct.anon* %s45, i32 0, i32 0, !dbg !1075
  %20 = load i32, i32* %low46, align 8, !dbg !1075
  %div47 = udiv i32 %19, %20, !dbg !1076
  %conv48 = zext i32 %div47 to i64, !dbg !1077
  store i64 %conv48, i64* %retval, align 8, !dbg !1078
  br label %return, !dbg !1078

if.end49:                                         ; preds = %if.then28
  %s50 = bitcast %union.dwords* %n to %struct.anon*, !dbg !1079
  %low51 = getelementptr inbounds %struct.anon, %struct.anon* %s50, i32 0, i32 0, !dbg !1080
  %21 = load i32, i32* %low51, align 8, !dbg !1080
  %cmp52 = icmp eq i32 %21, 0, !dbg !1081
  br i1 %cmp52, label %if.then54, label %if.end74, !dbg !1082

if.then54:                                        ; preds = %if.end49
  %22 = load i64*, i64** %rem.addr, align 4, !dbg !1083
  %tobool55 = icmp ne i64* %22, null, !dbg !1083
  br i1 %tobool55, label %if.then56, label %if.end67, !dbg !1083

if.then56:                                        ; preds = %if.then54
  %s57 = bitcast %union.dwords* %n to %struct.anon*, !dbg !1084
  %high58 = getelementptr inbounds %struct.anon, %struct.anon* %s57, i32 0, i32 1, !dbg !1085
  %23 = load i32, i32* %high58, align 4, !dbg !1085
  %s59 = bitcast %union.dwords* %d to %struct.anon*, !dbg !1086
  %high60 = getelementptr inbounds %struct.anon, %struct.anon* %s59, i32 0, i32 1, !dbg !1087
  %24 = load i32, i32* %high60, align 4, !dbg !1087
  %rem61 = urem i32 %23, %24, !dbg !1088
  %s62 = bitcast %union.dwords* %r to %struct.anon*, !dbg !1089
  %high63 = getelementptr inbounds %struct.anon, %struct.anon* %s62, i32 0, i32 1, !dbg !1090
  store i32 %rem61, i32* %high63, align 4, !dbg !1091
  %s64 = bitcast %union.dwords* %r to %struct.anon*, !dbg !1092
  %low65 = getelementptr inbounds %struct.anon, %struct.anon* %s64, i32 0, i32 0, !dbg !1093
  store i32 0, i32* %low65, align 8, !dbg !1094
  %all66 = bitcast %union.dwords* %r to i64*, !dbg !1095
  %25 = load i64, i64* %all66, align 8, !dbg !1095
  %26 = load i64*, i64** %rem.addr, align 4, !dbg !1096
  store i64 %25, i64* %26, align 8, !dbg !1097
  br label %if.end67, !dbg !1098

if.end67:                                         ; preds = %if.then56, %if.then54
  %s68 = bitcast %union.dwords* %n to %struct.anon*, !dbg !1099
  %high69 = getelementptr inbounds %struct.anon, %struct.anon* %s68, i32 0, i32 1, !dbg !1100
  %27 = load i32, i32* %high69, align 4, !dbg !1100
  %s70 = bitcast %union.dwords* %d to %struct.anon*, !dbg !1101
  %high71 = getelementptr inbounds %struct.anon, %struct.anon* %s70, i32 0, i32 1, !dbg !1102
  %28 = load i32, i32* %high71, align 4, !dbg !1102
  %div72 = udiv i32 %27, %28, !dbg !1103
  %conv73 = zext i32 %div72 to i64, !dbg !1104
  store i64 %conv73, i64* %retval, align 8, !dbg !1105
  br label %return, !dbg !1105

if.end74:                                         ; preds = %if.end49
  %s75 = bitcast %union.dwords* %d to %struct.anon*, !dbg !1106
  %high76 = getelementptr inbounds %struct.anon, %struct.anon* %s75, i32 0, i32 1, !dbg !1107
  %29 = load i32, i32* %high76, align 4, !dbg !1107
  %s77 = bitcast %union.dwords* %d to %struct.anon*, !dbg !1108
  %high78 = getelementptr inbounds %struct.anon, %struct.anon* %s77, i32 0, i32 1, !dbg !1109
  %30 = load i32, i32* %high78, align 4, !dbg !1109
  %sub = sub i32 %30, 1, !dbg !1110
  %and = and i32 %29, %sub, !dbg !1111
  %cmp79 = icmp eq i32 %and, 0, !dbg !1112
  br i1 %cmp79, label %if.then81, label %if.end103, !dbg !1113

if.then81:                                        ; preds = %if.end74
  %31 = load i64*, i64** %rem.addr, align 4, !dbg !1114
  %tobool82 = icmp ne i64* %31, null, !dbg !1114
  br i1 %tobool82, label %if.then83, label %if.end97, !dbg !1114

if.then83:                                        ; preds = %if.then81
  %s84 = bitcast %union.dwords* %n to %struct.anon*, !dbg !1115
  %low85 = getelementptr inbounds %struct.anon, %struct.anon* %s84, i32 0, i32 0, !dbg !1116
  %32 = load i32, i32* %low85, align 8, !dbg !1116
  %s86 = bitcast %union.dwords* %r to %struct.anon*, !dbg !1117
  %low87 = getelementptr inbounds %struct.anon, %struct.anon* %s86, i32 0, i32 0, !dbg !1118
  store i32 %32, i32* %low87, align 8, !dbg !1119
  %s88 = bitcast %union.dwords* %n to %struct.anon*, !dbg !1120
  %high89 = getelementptr inbounds %struct.anon, %struct.anon* %s88, i32 0, i32 1, !dbg !1121
  %33 = load i32, i32* %high89, align 4, !dbg !1121
  %s90 = bitcast %union.dwords* %d to %struct.anon*, !dbg !1122
  %high91 = getelementptr inbounds %struct.anon, %struct.anon* %s90, i32 0, i32 1, !dbg !1123
  %34 = load i32, i32* %high91, align 4, !dbg !1123
  %sub92 = sub i32 %34, 1, !dbg !1124
  %and93 = and i32 %33, %sub92, !dbg !1125
  %s94 = bitcast %union.dwords* %r to %struct.anon*, !dbg !1126
  %high95 = getelementptr inbounds %struct.anon, %struct.anon* %s94, i32 0, i32 1, !dbg !1127
  store i32 %and93, i32* %high95, align 4, !dbg !1128
  %all96 = bitcast %union.dwords* %r to i64*, !dbg !1129
  %35 = load i64, i64* %all96, align 8, !dbg !1129
  %36 = load i64*, i64** %rem.addr, align 4, !dbg !1130
  store i64 %35, i64* %36, align 8, !dbg !1131
  br label %if.end97, !dbg !1132

if.end97:                                         ; preds = %if.then83, %if.then81
  %s98 = bitcast %union.dwords* %n to %struct.anon*, !dbg !1133
  %high99 = getelementptr inbounds %struct.anon, %struct.anon* %s98, i32 0, i32 1, !dbg !1134
  %37 = load i32, i32* %high99, align 4, !dbg !1134
  %s100 = bitcast %union.dwords* %d to %struct.anon*, !dbg !1135
  %high101 = getelementptr inbounds %struct.anon, %struct.anon* %s100, i32 0, i32 1, !dbg !1136
  %38 = load i32, i32* %high101, align 4, !dbg !1136
  %39 = call i32 @llvm.cttz.i32(i32 %38, i1 false), !dbg !1137
  %shr = lshr i32 %37, %39, !dbg !1138
  %conv102 = zext i32 %shr to i64, !dbg !1139
  store i64 %conv102, i64* %retval, align 8, !dbg !1140
  br label %return, !dbg !1140

if.end103:                                        ; preds = %if.end74
  %s104 = bitcast %union.dwords* %d to %struct.anon*, !dbg !1141
  %high105 = getelementptr inbounds %struct.anon, %struct.anon* %s104, i32 0, i32 1, !dbg !1142
  %40 = load i32, i32* %high105, align 4, !dbg !1142
  %41 = call i32 @llvm.ctlz.i32(i32 %40, i1 false), !dbg !1143
  %s106 = bitcast %union.dwords* %n to %struct.anon*, !dbg !1144
  %high107 = getelementptr inbounds %struct.anon, %struct.anon* %s106, i32 0, i32 1, !dbg !1145
  %42 = load i32, i32* %high107, align 4, !dbg !1145
  %43 = call i32 @llvm.ctlz.i32(i32 %42, i1 false), !dbg !1146
  %sub108 = sub nsw i32 %41, %43, !dbg !1147
  store i32 %sub108, i32* %sr, align 4, !dbg !1148
  %44 = load i32, i32* %sr, align 4, !dbg !1149
  %cmp109 = icmp ugt i32 %44, 30, !dbg !1150
  br i1 %cmp109, label %if.then111, label %if.end116, !dbg !1149

if.then111:                                       ; preds = %if.end103
  %45 = load i64*, i64** %rem.addr, align 4, !dbg !1151
  %tobool112 = icmp ne i64* %45, null, !dbg !1151
  br i1 %tobool112, label %if.then113, label %if.end115, !dbg !1151

if.then113:                                       ; preds = %if.then111
  %all114 = bitcast %union.dwords* %n to i64*, !dbg !1152
  %46 = load i64, i64* %all114, align 8, !dbg !1152
  %47 = load i64*, i64** %rem.addr, align 4, !dbg !1153
  store i64 %46, i64* %47, align 8, !dbg !1154
  br label %if.end115, !dbg !1155

if.end115:                                        ; preds = %if.then113, %if.then111
  store i64 0, i64* %retval, align 8, !dbg !1156
  br label %return, !dbg !1156

if.end116:                                        ; preds = %if.end103
  %48 = load i32, i32* %sr, align 4, !dbg !1157
  %inc = add i32 %48, 1, !dbg !1157
  store i32 %inc, i32* %sr, align 4, !dbg !1157
  %s117 = bitcast %union.dwords* %q to %struct.anon*, !dbg !1158
  %low118 = getelementptr inbounds %struct.anon, %struct.anon* %s117, i32 0, i32 0, !dbg !1159
  store i32 0, i32* %low118, align 8, !dbg !1160
  %s119 = bitcast %union.dwords* %n to %struct.anon*, !dbg !1161
  %low120 = getelementptr inbounds %struct.anon, %struct.anon* %s119, i32 0, i32 0, !dbg !1162
  %49 = load i32, i32* %low120, align 8, !dbg !1162
  %50 = load i32, i32* %sr, align 4, !dbg !1163
  %sub121 = sub i32 32, %50, !dbg !1164
  %shl = shl i32 %49, %sub121, !dbg !1165
  %s122 = bitcast %union.dwords* %q to %struct.anon*, !dbg !1166
  %high123 = getelementptr inbounds %struct.anon, %struct.anon* %s122, i32 0, i32 1, !dbg !1167
  store i32 %shl, i32* %high123, align 4, !dbg !1168
  %s124 = bitcast %union.dwords* %n to %struct.anon*, !dbg !1169
  %high125 = getelementptr inbounds %struct.anon, %struct.anon* %s124, i32 0, i32 1, !dbg !1170
  %51 = load i32, i32* %high125, align 4, !dbg !1170
  %52 = load i32, i32* %sr, align 4, !dbg !1171
  %shr126 = lshr i32 %51, %52, !dbg !1172
  %s127 = bitcast %union.dwords* %r to %struct.anon*, !dbg !1173
  %high128 = getelementptr inbounds %struct.anon, %struct.anon* %s127, i32 0, i32 1, !dbg !1174
  store i32 %shr126, i32* %high128, align 4, !dbg !1175
  %s129 = bitcast %union.dwords* %n to %struct.anon*, !dbg !1176
  %high130 = getelementptr inbounds %struct.anon, %struct.anon* %s129, i32 0, i32 1, !dbg !1177
  %53 = load i32, i32* %high130, align 4, !dbg !1177
  %54 = load i32, i32* %sr, align 4, !dbg !1178
  %sub131 = sub i32 32, %54, !dbg !1179
  %shl132 = shl i32 %53, %sub131, !dbg !1180
  %s133 = bitcast %union.dwords* %n to %struct.anon*, !dbg !1181
  %low134 = getelementptr inbounds %struct.anon, %struct.anon* %s133, i32 0, i32 0, !dbg !1182
  %55 = load i32, i32* %low134, align 8, !dbg !1182
  %56 = load i32, i32* %sr, align 4, !dbg !1183
  %shr135 = lshr i32 %55, %56, !dbg !1184
  %or = or i32 %shl132, %shr135, !dbg !1185
  %s136 = bitcast %union.dwords* %r to %struct.anon*, !dbg !1186
  %low137 = getelementptr inbounds %struct.anon, %struct.anon* %s136, i32 0, i32 0, !dbg !1187
  store i32 %or, i32* %low137, align 8, !dbg !1188
  br label %if.end317, !dbg !1189

if.else:                                          ; preds = %if.end23
  %s138 = bitcast %union.dwords* %d to %struct.anon*, !dbg !1190
  %high139 = getelementptr inbounds %struct.anon, %struct.anon* %s138, i32 0, i32 1, !dbg !1191
  %57 = load i32, i32* %high139, align 4, !dbg !1191
  %cmp140 = icmp eq i32 %57, 0, !dbg !1192
  br i1 %cmp140, label %if.then142, label %if.else263, !dbg !1193

if.then142:                                       ; preds = %if.else
  %s143 = bitcast %union.dwords* %d to %struct.anon*, !dbg !1194
  %low144 = getelementptr inbounds %struct.anon, %struct.anon* %s143, i32 0, i32 0, !dbg !1195
  %58 = load i32, i32* %low144, align 8, !dbg !1195
  %s145 = bitcast %union.dwords* %d to %struct.anon*, !dbg !1196
  %low146 = getelementptr inbounds %struct.anon, %struct.anon* %s145, i32 0, i32 0, !dbg !1197
  %59 = load i32, i32* %low146, align 8, !dbg !1197
  %sub147 = sub i32 %59, 1, !dbg !1198
  %and148 = and i32 %58, %sub147, !dbg !1199
  %cmp149 = icmp eq i32 %and148, 0, !dbg !1200
  br i1 %cmp149, label %if.then151, label %if.end187, !dbg !1201

if.then151:                                       ; preds = %if.then142
  %60 = load i64*, i64** %rem.addr, align 4, !dbg !1202
  %tobool152 = icmp ne i64* %60, null, !dbg !1202
  br i1 %tobool152, label %if.then153, label %if.end161, !dbg !1202

if.then153:                                       ; preds = %if.then151
  %s154 = bitcast %union.dwords* %n to %struct.anon*, !dbg !1203
  %low155 = getelementptr inbounds %struct.anon, %struct.anon* %s154, i32 0, i32 0, !dbg !1204
  %61 = load i32, i32* %low155, align 8, !dbg !1204
  %s156 = bitcast %union.dwords* %d to %struct.anon*, !dbg !1205
  %low157 = getelementptr inbounds %struct.anon, %struct.anon* %s156, i32 0, i32 0, !dbg !1206
  %62 = load i32, i32* %low157, align 8, !dbg !1206
  %sub158 = sub i32 %62, 1, !dbg !1207
  %and159 = and i32 %61, %sub158, !dbg !1208
  %conv160 = zext i32 %and159 to i64, !dbg !1209
  %63 = load i64*, i64** %rem.addr, align 4, !dbg !1210
  store i64 %conv160, i64* %63, align 8, !dbg !1211
  br label %if.end161, !dbg !1212

if.end161:                                        ; preds = %if.then153, %if.then151
  %s162 = bitcast %union.dwords* %d to %struct.anon*, !dbg !1213
  %low163 = getelementptr inbounds %struct.anon, %struct.anon* %s162, i32 0, i32 0, !dbg !1214
  %64 = load i32, i32* %low163, align 8, !dbg !1214
  %cmp164 = icmp eq i32 %64, 1, !dbg !1215
  br i1 %cmp164, label %if.then166, label %if.end168, !dbg !1216

if.then166:                                       ; preds = %if.end161
  %all167 = bitcast %union.dwords* %n to i64*, !dbg !1217
  %65 = load i64, i64* %all167, align 8, !dbg !1217
  store i64 %65, i64* %retval, align 8, !dbg !1218
  br label %return, !dbg !1218

if.end168:                                        ; preds = %if.end161
  %s169 = bitcast %union.dwords* %d to %struct.anon*, !dbg !1219
  %low170 = getelementptr inbounds %struct.anon, %struct.anon* %s169, i32 0, i32 0, !dbg !1220
  %66 = load i32, i32* %low170, align 8, !dbg !1220
  %67 = call i32 @llvm.cttz.i32(i32 %66, i1 false), !dbg !1221
  store i32 %67, i32* %sr, align 4, !dbg !1222
  %s171 = bitcast %union.dwords* %n to %struct.anon*, !dbg !1223
  %high172 = getelementptr inbounds %struct.anon, %struct.anon* %s171, i32 0, i32 1, !dbg !1224
  %68 = load i32, i32* %high172, align 4, !dbg !1224
  %69 = load i32, i32* %sr, align 4, !dbg !1225
  %shr173 = lshr i32 %68, %69, !dbg !1226
  %s174 = bitcast %union.dwords* %q to %struct.anon*, !dbg !1227
  %high175 = getelementptr inbounds %struct.anon, %struct.anon* %s174, i32 0, i32 1, !dbg !1228
  store i32 %shr173, i32* %high175, align 4, !dbg !1229
  %s176 = bitcast %union.dwords* %n to %struct.anon*, !dbg !1230
  %high177 = getelementptr inbounds %struct.anon, %struct.anon* %s176, i32 0, i32 1, !dbg !1231
  %70 = load i32, i32* %high177, align 4, !dbg !1231
  %71 = load i32, i32* %sr, align 4, !dbg !1232
  %sub178 = sub i32 32, %71, !dbg !1233
  %shl179 = shl i32 %70, %sub178, !dbg !1234
  %s180 = bitcast %union.dwords* %n to %struct.anon*, !dbg !1235
  %low181 = getelementptr inbounds %struct.anon, %struct.anon* %s180, i32 0, i32 0, !dbg !1236
  %72 = load i32, i32* %low181, align 8, !dbg !1236
  %73 = load i32, i32* %sr, align 4, !dbg !1237
  %shr182 = lshr i32 %72, %73, !dbg !1238
  %or183 = or i32 %shl179, %shr182, !dbg !1239
  %s184 = bitcast %union.dwords* %q to %struct.anon*, !dbg !1240
  %low185 = getelementptr inbounds %struct.anon, %struct.anon* %s184, i32 0, i32 0, !dbg !1241
  store i32 %or183, i32* %low185, align 8, !dbg !1242
  %all186 = bitcast %union.dwords* %q to i64*, !dbg !1243
  %74 = load i64, i64* %all186, align 8, !dbg !1243
  store i64 %74, i64* %retval, align 8, !dbg !1244
  br label %return, !dbg !1244

if.end187:                                        ; preds = %if.then142
  %s188 = bitcast %union.dwords* %d to %struct.anon*, !dbg !1245
  %low189 = getelementptr inbounds %struct.anon, %struct.anon* %s188, i32 0, i32 0, !dbg !1246
  %75 = load i32, i32* %low189, align 8, !dbg !1246
  %76 = call i32 @llvm.ctlz.i32(i32 %75, i1 false), !dbg !1247
  %add = add i32 33, %76, !dbg !1248
  %s190 = bitcast %union.dwords* %n to %struct.anon*, !dbg !1249
  %high191 = getelementptr inbounds %struct.anon, %struct.anon* %s190, i32 0, i32 1, !dbg !1250
  %77 = load i32, i32* %high191, align 4, !dbg !1250
  %78 = call i32 @llvm.ctlz.i32(i32 %77, i1 false), !dbg !1251
  %sub192 = sub i32 %add, %78, !dbg !1252
  store i32 %sub192, i32* %sr, align 4, !dbg !1253
  %79 = load i32, i32* %sr, align 4, !dbg !1254
  %cmp193 = icmp eq i32 %79, 32, !dbg !1255
  br i1 %cmp193, label %if.then195, label %if.else208, !dbg !1254

if.then195:                                       ; preds = %if.end187
  %s196 = bitcast %union.dwords* %q to %struct.anon*, !dbg !1256
  %low197 = getelementptr inbounds %struct.anon, %struct.anon* %s196, i32 0, i32 0, !dbg !1257
  store i32 0, i32* %low197, align 8, !dbg !1258
  %s198 = bitcast %union.dwords* %n to %struct.anon*, !dbg !1259
  %low199 = getelementptr inbounds %struct.anon, %struct.anon* %s198, i32 0, i32 0, !dbg !1260
  %80 = load i32, i32* %low199, align 8, !dbg !1260
  %s200 = bitcast %union.dwords* %q to %struct.anon*, !dbg !1261
  %high201 = getelementptr inbounds %struct.anon, %struct.anon* %s200, i32 0, i32 1, !dbg !1262
  store i32 %80, i32* %high201, align 4, !dbg !1263
  %s202 = bitcast %union.dwords* %r to %struct.anon*, !dbg !1264
  %high203 = getelementptr inbounds %struct.anon, %struct.anon* %s202, i32 0, i32 1, !dbg !1265
  store i32 0, i32* %high203, align 4, !dbg !1266
  %s204 = bitcast %union.dwords* %n to %struct.anon*, !dbg !1267
  %high205 = getelementptr inbounds %struct.anon, %struct.anon* %s204, i32 0, i32 1, !dbg !1268
  %81 = load i32, i32* %high205, align 4, !dbg !1268
  %s206 = bitcast %union.dwords* %r to %struct.anon*, !dbg !1269
  %low207 = getelementptr inbounds %struct.anon, %struct.anon* %s206, i32 0, i32 0, !dbg !1270
  store i32 %81, i32* %low207, align 8, !dbg !1271
  br label %if.end262, !dbg !1272

if.else208:                                       ; preds = %if.end187
  %82 = load i32, i32* %sr, align 4, !dbg !1273
  %cmp209 = icmp ult i32 %82, 32, !dbg !1274
  br i1 %cmp209, label %if.then211, label %if.else235, !dbg !1273

if.then211:                                       ; preds = %if.else208
  %s212 = bitcast %union.dwords* %q to %struct.anon*, !dbg !1275
  %low213 = getelementptr inbounds %struct.anon, %struct.anon* %s212, i32 0, i32 0, !dbg !1276
  store i32 0, i32* %low213, align 8, !dbg !1277
  %s214 = bitcast %union.dwords* %n to %struct.anon*, !dbg !1278
  %low215 = getelementptr inbounds %struct.anon, %struct.anon* %s214, i32 0, i32 0, !dbg !1279
  %83 = load i32, i32* %low215, align 8, !dbg !1279
  %84 = load i32, i32* %sr, align 4, !dbg !1280
  %sub216 = sub i32 32, %84, !dbg !1281
  %shl217 = shl i32 %83, %sub216, !dbg !1282
  %s218 = bitcast %union.dwords* %q to %struct.anon*, !dbg !1283
  %high219 = getelementptr inbounds %struct.anon, %struct.anon* %s218, i32 0, i32 1, !dbg !1284
  store i32 %shl217, i32* %high219, align 4, !dbg !1285
  %s220 = bitcast %union.dwords* %n to %struct.anon*, !dbg !1286
  %high221 = getelementptr inbounds %struct.anon, %struct.anon* %s220, i32 0, i32 1, !dbg !1287
  %85 = load i32, i32* %high221, align 4, !dbg !1287
  %86 = load i32, i32* %sr, align 4, !dbg !1288
  %shr222 = lshr i32 %85, %86, !dbg !1289
  %s223 = bitcast %union.dwords* %r to %struct.anon*, !dbg !1290
  %high224 = getelementptr inbounds %struct.anon, %struct.anon* %s223, i32 0, i32 1, !dbg !1291
  store i32 %shr222, i32* %high224, align 4, !dbg !1292
  %s225 = bitcast %union.dwords* %n to %struct.anon*, !dbg !1293
  %high226 = getelementptr inbounds %struct.anon, %struct.anon* %s225, i32 0, i32 1, !dbg !1294
  %87 = load i32, i32* %high226, align 4, !dbg !1294
  %88 = load i32, i32* %sr, align 4, !dbg !1295
  %sub227 = sub i32 32, %88, !dbg !1296
  %shl228 = shl i32 %87, %sub227, !dbg !1297
  %s229 = bitcast %union.dwords* %n to %struct.anon*, !dbg !1298
  %low230 = getelementptr inbounds %struct.anon, %struct.anon* %s229, i32 0, i32 0, !dbg !1299
  %89 = load i32, i32* %low230, align 8, !dbg !1299
  %90 = load i32, i32* %sr, align 4, !dbg !1300
  %shr231 = lshr i32 %89, %90, !dbg !1301
  %or232 = or i32 %shl228, %shr231, !dbg !1302
  %s233 = bitcast %union.dwords* %r to %struct.anon*, !dbg !1303
  %low234 = getelementptr inbounds %struct.anon, %struct.anon* %s233, i32 0, i32 0, !dbg !1304
  store i32 %or232, i32* %low234, align 8, !dbg !1305
  br label %if.end261, !dbg !1306

if.else235:                                       ; preds = %if.else208
  %s236 = bitcast %union.dwords* %n to %struct.anon*, !dbg !1307
  %low237 = getelementptr inbounds %struct.anon, %struct.anon* %s236, i32 0, i32 0, !dbg !1308
  %91 = load i32, i32* %low237, align 8, !dbg !1308
  %92 = load i32, i32* %sr, align 4, !dbg !1309
  %sub238 = sub i32 64, %92, !dbg !1310
  %shl239 = shl i32 %91, %sub238, !dbg !1311
  %s240 = bitcast %union.dwords* %q to %struct.anon*, !dbg !1312
  %low241 = getelementptr inbounds %struct.anon, %struct.anon* %s240, i32 0, i32 0, !dbg !1313
  store i32 %shl239, i32* %low241, align 8, !dbg !1314
  %s242 = bitcast %union.dwords* %n to %struct.anon*, !dbg !1315
  %high243 = getelementptr inbounds %struct.anon, %struct.anon* %s242, i32 0, i32 1, !dbg !1316
  %93 = load i32, i32* %high243, align 4, !dbg !1316
  %94 = load i32, i32* %sr, align 4, !dbg !1317
  %sub244 = sub i32 64, %94, !dbg !1318
  %shl245 = shl i32 %93, %sub244, !dbg !1319
  %s246 = bitcast %union.dwords* %n to %struct.anon*, !dbg !1320
  %low247 = getelementptr inbounds %struct.anon, %struct.anon* %s246, i32 0, i32 0, !dbg !1321
  %95 = load i32, i32* %low247, align 8, !dbg !1321
  %96 = load i32, i32* %sr, align 4, !dbg !1322
  %sub248 = sub i32 %96, 32, !dbg !1323
  %shr249 = lshr i32 %95, %sub248, !dbg !1324
  %or250 = or i32 %shl245, %shr249, !dbg !1325
  %s251 = bitcast %union.dwords* %q to %struct.anon*, !dbg !1326
  %high252 = getelementptr inbounds %struct.anon, %struct.anon* %s251, i32 0, i32 1, !dbg !1327
  store i32 %or250, i32* %high252, align 4, !dbg !1328
  %s253 = bitcast %union.dwords* %r to %struct.anon*, !dbg !1329
  %high254 = getelementptr inbounds %struct.anon, %struct.anon* %s253, i32 0, i32 1, !dbg !1330
  store i32 0, i32* %high254, align 4, !dbg !1331
  %s255 = bitcast %union.dwords* %n to %struct.anon*, !dbg !1332
  %high256 = getelementptr inbounds %struct.anon, %struct.anon* %s255, i32 0, i32 1, !dbg !1333
  %97 = load i32, i32* %high256, align 4, !dbg !1333
  %98 = load i32, i32* %sr, align 4, !dbg !1334
  %sub257 = sub i32 %98, 32, !dbg !1335
  %shr258 = lshr i32 %97, %sub257, !dbg !1336
  %s259 = bitcast %union.dwords* %r to %struct.anon*, !dbg !1337
  %low260 = getelementptr inbounds %struct.anon, %struct.anon* %s259, i32 0, i32 0, !dbg !1338
  store i32 %shr258, i32* %low260, align 8, !dbg !1339
  br label %if.end261

if.end261:                                        ; preds = %if.else235, %if.then211
  br label %if.end262

if.end262:                                        ; preds = %if.end261, %if.then195
  br label %if.end316, !dbg !1340

if.else263:                                       ; preds = %if.else
  %s264 = bitcast %union.dwords* %d to %struct.anon*, !dbg !1341
  %high265 = getelementptr inbounds %struct.anon, %struct.anon* %s264, i32 0, i32 1, !dbg !1342
  %99 = load i32, i32* %high265, align 4, !dbg !1342
  %100 = call i32 @llvm.ctlz.i32(i32 %99, i1 false), !dbg !1343
  %s266 = bitcast %union.dwords* %n to %struct.anon*, !dbg !1344
  %high267 = getelementptr inbounds %struct.anon, %struct.anon* %s266, i32 0, i32 1, !dbg !1345
  %101 = load i32, i32* %high267, align 4, !dbg !1345
  %102 = call i32 @llvm.ctlz.i32(i32 %101, i1 false), !dbg !1346
  %sub268 = sub nsw i32 %100, %102, !dbg !1347
  store i32 %sub268, i32* %sr, align 4, !dbg !1348
  %103 = load i32, i32* %sr, align 4, !dbg !1349
  %cmp269 = icmp ugt i32 %103, 31, !dbg !1350
  br i1 %cmp269, label %if.then271, label %if.end276, !dbg !1349

if.then271:                                       ; preds = %if.else263
  %104 = load i64*, i64** %rem.addr, align 4, !dbg !1351
  %tobool272 = icmp ne i64* %104, null, !dbg !1351
  br i1 %tobool272, label %if.then273, label %if.end275, !dbg !1351

if.then273:                                       ; preds = %if.then271
  %all274 = bitcast %union.dwords* %n to i64*, !dbg !1352
  %105 = load i64, i64* %all274, align 8, !dbg !1352
  %106 = load i64*, i64** %rem.addr, align 4, !dbg !1353
  store i64 %105, i64* %106, align 8, !dbg !1354
  br label %if.end275, !dbg !1355

if.end275:                                        ; preds = %if.then273, %if.then271
  store i64 0, i64* %retval, align 8, !dbg !1356
  br label %return, !dbg !1356

if.end276:                                        ; preds = %if.else263
  %107 = load i32, i32* %sr, align 4, !dbg !1357
  %inc277 = add i32 %107, 1, !dbg !1357
  store i32 %inc277, i32* %sr, align 4, !dbg !1357
  %s278 = bitcast %union.dwords* %q to %struct.anon*, !dbg !1358
  %low279 = getelementptr inbounds %struct.anon, %struct.anon* %s278, i32 0, i32 0, !dbg !1359
  store i32 0, i32* %low279, align 8, !dbg !1360
  %108 = load i32, i32* %sr, align 4, !dbg !1361
  %cmp280 = icmp eq i32 %108, 32, !dbg !1362
  br i1 %cmp280, label %if.then282, label %if.else293, !dbg !1361

if.then282:                                       ; preds = %if.end276
  %s283 = bitcast %union.dwords* %n to %struct.anon*, !dbg !1363
  %low284 = getelementptr inbounds %struct.anon, %struct.anon* %s283, i32 0, i32 0, !dbg !1364
  %109 = load i32, i32* %low284, align 8, !dbg !1364
  %s285 = bitcast %union.dwords* %q to %struct.anon*, !dbg !1365
  %high286 = getelementptr inbounds %struct.anon, %struct.anon* %s285, i32 0, i32 1, !dbg !1366
  store i32 %109, i32* %high286, align 4, !dbg !1367
  %s287 = bitcast %union.dwords* %r to %struct.anon*, !dbg !1368
  %high288 = getelementptr inbounds %struct.anon, %struct.anon* %s287, i32 0, i32 1, !dbg !1369
  store i32 0, i32* %high288, align 4, !dbg !1370
  %s289 = bitcast %union.dwords* %n to %struct.anon*, !dbg !1371
  %high290 = getelementptr inbounds %struct.anon, %struct.anon* %s289, i32 0, i32 1, !dbg !1372
  %110 = load i32, i32* %high290, align 4, !dbg !1372
  %s291 = bitcast %union.dwords* %r to %struct.anon*, !dbg !1373
  %low292 = getelementptr inbounds %struct.anon, %struct.anon* %s291, i32 0, i32 0, !dbg !1374
  store i32 %110, i32* %low292, align 8, !dbg !1375
  br label %if.end315, !dbg !1376

if.else293:                                       ; preds = %if.end276
  %s294 = bitcast %union.dwords* %n to %struct.anon*, !dbg !1377
  %low295 = getelementptr inbounds %struct.anon, %struct.anon* %s294, i32 0, i32 0, !dbg !1378
  %111 = load i32, i32* %low295, align 8, !dbg !1378
  %112 = load i32, i32* %sr, align 4, !dbg !1379
  %sub296 = sub i32 32, %112, !dbg !1380
  %shl297 = shl i32 %111, %sub296, !dbg !1381
  %s298 = bitcast %union.dwords* %q to %struct.anon*, !dbg !1382
  %high299 = getelementptr inbounds %struct.anon, %struct.anon* %s298, i32 0, i32 1, !dbg !1383
  store i32 %shl297, i32* %high299, align 4, !dbg !1384
  %s300 = bitcast %union.dwords* %n to %struct.anon*, !dbg !1385
  %high301 = getelementptr inbounds %struct.anon, %struct.anon* %s300, i32 0, i32 1, !dbg !1386
  %113 = load i32, i32* %high301, align 4, !dbg !1386
  %114 = load i32, i32* %sr, align 4, !dbg !1387
  %shr302 = lshr i32 %113, %114, !dbg !1388
  %s303 = bitcast %union.dwords* %r to %struct.anon*, !dbg !1389
  %high304 = getelementptr inbounds %struct.anon, %struct.anon* %s303, i32 0, i32 1, !dbg !1390
  store i32 %shr302, i32* %high304, align 4, !dbg !1391
  %s305 = bitcast %union.dwords* %n to %struct.anon*, !dbg !1392
  %high306 = getelementptr inbounds %struct.anon, %struct.anon* %s305, i32 0, i32 1, !dbg !1393
  %115 = load i32, i32* %high306, align 4, !dbg !1393
  %116 = load i32, i32* %sr, align 4, !dbg !1394
  %sub307 = sub i32 32, %116, !dbg !1395
  %shl308 = shl i32 %115, %sub307, !dbg !1396
  %s309 = bitcast %union.dwords* %n to %struct.anon*, !dbg !1397
  %low310 = getelementptr inbounds %struct.anon, %struct.anon* %s309, i32 0, i32 0, !dbg !1398
  %117 = load i32, i32* %low310, align 8, !dbg !1398
  %118 = load i32, i32* %sr, align 4, !dbg !1399
  %shr311 = lshr i32 %117, %118, !dbg !1400
  %or312 = or i32 %shl308, %shr311, !dbg !1401
  %s313 = bitcast %union.dwords* %r to %struct.anon*, !dbg !1402
  %low314 = getelementptr inbounds %struct.anon, %struct.anon* %s313, i32 0, i32 0, !dbg !1403
  store i32 %or312, i32* %low314, align 8, !dbg !1404
  br label %if.end315

if.end315:                                        ; preds = %if.else293, %if.then282
  br label %if.end316

if.end316:                                        ; preds = %if.end315, %if.end262
  br label %if.end317

if.end317:                                        ; preds = %if.end316, %if.end116
  store i32 0, i32* %carry, align 4, !dbg !1405
  br label %for.cond, !dbg !1406

for.cond:                                         ; preds = %for.inc, %if.end317
  %119 = load i32, i32* %sr, align 4, !dbg !1407
  %cmp318 = icmp ugt i32 %119, 0, !dbg !1408
  br i1 %cmp318, label %for.body, label %for.end, !dbg !1406

for.body:                                         ; preds = %for.cond
  %s320 = bitcast %union.dwords* %r to %struct.anon*, !dbg !1409
  %high321 = getelementptr inbounds %struct.anon, %struct.anon* %s320, i32 0, i32 1, !dbg !1410
  %120 = load i32, i32* %high321, align 4, !dbg !1410
  %shl322 = shl i32 %120, 1, !dbg !1411
  %s323 = bitcast %union.dwords* %r to %struct.anon*, !dbg !1412
  %low324 = getelementptr inbounds %struct.anon, %struct.anon* %s323, i32 0, i32 0, !dbg !1413
  %121 = load i32, i32* %low324, align 8, !dbg !1413
  %shr325 = lshr i32 %121, 31, !dbg !1414
  %or326 = or i32 %shl322, %shr325, !dbg !1415
  %s327 = bitcast %union.dwords* %r to %struct.anon*, !dbg !1416
  %high328 = getelementptr inbounds %struct.anon, %struct.anon* %s327, i32 0, i32 1, !dbg !1417
  store i32 %or326, i32* %high328, align 4, !dbg !1418
  %s329 = bitcast %union.dwords* %r to %struct.anon*, !dbg !1419
  %low330 = getelementptr inbounds %struct.anon, %struct.anon* %s329, i32 0, i32 0, !dbg !1420
  %122 = load i32, i32* %low330, align 8, !dbg !1420
  %shl331 = shl i32 %122, 1, !dbg !1421
  %s332 = bitcast %union.dwords* %q to %struct.anon*, !dbg !1422
  %high333 = getelementptr inbounds %struct.anon, %struct.anon* %s332, i32 0, i32 1, !dbg !1423
  %123 = load i32, i32* %high333, align 4, !dbg !1423
  %shr334 = lshr i32 %123, 31, !dbg !1424
  %or335 = or i32 %shl331, %shr334, !dbg !1425
  %s336 = bitcast %union.dwords* %r to %struct.anon*, !dbg !1426
  %low337 = getelementptr inbounds %struct.anon, %struct.anon* %s336, i32 0, i32 0, !dbg !1427
  store i32 %or335, i32* %low337, align 8, !dbg !1428
  %s338 = bitcast %union.dwords* %q to %struct.anon*, !dbg !1429
  %high339 = getelementptr inbounds %struct.anon, %struct.anon* %s338, i32 0, i32 1, !dbg !1430
  %124 = load i32, i32* %high339, align 4, !dbg !1430
  %shl340 = shl i32 %124, 1, !dbg !1431
  %s341 = bitcast %union.dwords* %q to %struct.anon*, !dbg !1432
  %low342 = getelementptr inbounds %struct.anon, %struct.anon* %s341, i32 0, i32 0, !dbg !1433
  %125 = load i32, i32* %low342, align 8, !dbg !1433
  %shr343 = lshr i32 %125, 31, !dbg !1434
  %or344 = or i32 %shl340, %shr343, !dbg !1435
  %s345 = bitcast %union.dwords* %q to %struct.anon*, !dbg !1436
  %high346 = getelementptr inbounds %struct.anon, %struct.anon* %s345, i32 0, i32 1, !dbg !1437
  store i32 %or344, i32* %high346, align 4, !dbg !1438
  %s347 = bitcast %union.dwords* %q to %struct.anon*, !dbg !1439
  %low348 = getelementptr inbounds %struct.anon, %struct.anon* %s347, i32 0, i32 0, !dbg !1440
  %126 = load i32, i32* %low348, align 8, !dbg !1440
  %shl349 = shl i32 %126, 1, !dbg !1441
  %127 = load i32, i32* %carry, align 4, !dbg !1442
  %or350 = or i32 %shl349, %127, !dbg !1443
  %s351 = bitcast %union.dwords* %q to %struct.anon*, !dbg !1444
  %low352 = getelementptr inbounds %struct.anon, %struct.anon* %s351, i32 0, i32 0, !dbg !1445
  store i32 %or350, i32* %low352, align 8, !dbg !1446
  %all354 = bitcast %union.dwords* %d to i64*, !dbg !1447
  %128 = load i64, i64* %all354, align 8, !dbg !1447
  %all355 = bitcast %union.dwords* %r to i64*, !dbg !1448
  %129 = load i64, i64* %all355, align 8, !dbg !1448
  %sub356 = sub i64 %128, %129, !dbg !1449
  %sub357 = sub i64 %sub356, 1, !dbg !1450
  %shr358 = ashr i64 %sub357, 63, !dbg !1451
  store i64 %shr358, i64* %s353, align 8, !dbg !1452
  %130 = load i64, i64* %s353, align 8, !dbg !1453
  %and359 = and i64 %130, 1, !dbg !1454
  %conv360 = trunc i64 %and359 to i32, !dbg !1453
  store i32 %conv360, i32* %carry, align 4, !dbg !1455
  %all361 = bitcast %union.dwords* %d to i64*, !dbg !1456
  %131 = load i64, i64* %all361, align 8, !dbg !1456
  %132 = load i64, i64* %s353, align 8, !dbg !1457
  %and362 = and i64 %131, %132, !dbg !1458
  %all363 = bitcast %union.dwords* %r to i64*, !dbg !1459
  %133 = load i64, i64* %all363, align 8, !dbg !1460
  %sub364 = sub i64 %133, %and362, !dbg !1460
  store i64 %sub364, i64* %all363, align 8, !dbg !1460
  br label %for.inc, !dbg !1461

for.inc:                                          ; preds = %for.body
  %134 = load i32, i32* %sr, align 4, !dbg !1462
  %dec = add i32 %134, -1, !dbg !1462
  store i32 %dec, i32* %sr, align 4, !dbg !1462
  br label %for.cond, !dbg !1406, !llvm.loop !1463

for.end:                                          ; preds = %for.cond
  %all365 = bitcast %union.dwords* %q to i64*, !dbg !1464
  %135 = load i64, i64* %all365, align 8, !dbg !1464
  %shl366 = shl i64 %135, 1, !dbg !1465
  %136 = load i32, i32* %carry, align 4, !dbg !1466
  %conv367 = zext i32 %136 to i64, !dbg !1466
  %or368 = or i64 %shl366, %conv367, !dbg !1467
  %all369 = bitcast %union.dwords* %q to i64*, !dbg !1468
  store i64 %or368, i64* %all369, align 8, !dbg !1469
  %137 = load i64*, i64** %rem.addr, align 4, !dbg !1470
  %tobool370 = icmp ne i64* %137, null, !dbg !1470
  br i1 %tobool370, label %if.then371, label %if.end373, !dbg !1470

if.then371:                                       ; preds = %for.end
  %all372 = bitcast %union.dwords* %r to i64*, !dbg !1471
  %138 = load i64, i64* %all372, align 8, !dbg !1471
  %139 = load i64*, i64** %rem.addr, align 4, !dbg !1472
  store i64 %138, i64* %139, align 8, !dbg !1473
  br label %if.end373, !dbg !1474

if.end373:                                        ; preds = %if.then371, %for.end
  %all374 = bitcast %union.dwords* %q to i64*, !dbg !1475
  %140 = load i64, i64* %all374, align 8, !dbg !1475
  store i64 %140, i64* %retval, align 8, !dbg !1476
  br label %return, !dbg !1476

return:                                           ; preds = %if.end373, %if.end275, %if.end168, %if.then166, %if.end115, %if.end97, %if.end67, %if.end42, %if.end22, %if.end
  %141 = load i64, i64* %retval, align 8, !dbg !1477
  ret i64 %141, !dbg !1477
}

; Function Attrs: noinline nounwind
define dso_local arm_aapcscc i32 @__udivmodsi4(i32 %a, i32 %b, i32* %rem) #0 !dbg !1478 {
entry:
  %a.addr = alloca i32, align 4
  %b.addr = alloca i32, align 4
  %rem.addr = alloca i32*, align 4
  %d = alloca i32, align 4
  store i32 %a, i32* %a.addr, align 4
  store i32 %b, i32* %b.addr, align 4
  store i32* %rem, i32** %rem.addr, align 4
  %0 = load i32, i32* %a.addr, align 4, !dbg !1479
  %1 = load i32, i32* %b.addr, align 4, !dbg !1480
  %call = call arm_aapcscc i32 @__udivsi3(i32 %0, i32 %1) #4, !dbg !1481
  store i32 %call, i32* %d, align 4, !dbg !1482
  %2 = load i32, i32* %a.addr, align 4, !dbg !1483
  %3 = load i32, i32* %d, align 4, !dbg !1484
  %4 = load i32, i32* %b.addr, align 4, !dbg !1485
  %mul = mul i32 %3, %4, !dbg !1486
  %sub = sub i32 %2, %mul, !dbg !1487
  %5 = load i32*, i32** %rem.addr, align 4, !dbg !1488
  store i32 %sub, i32* %5, align 4, !dbg !1489
  %6 = load i32, i32* %d, align 4, !dbg !1490
  ret i32 %6, !dbg !1491
}

; Function Attrs: noinline nounwind
define dso_local arm_aapcscc i32 @__udivsi3(i32 %n, i32 %d) #0 !dbg !1492 {
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
  store i32 32, i32* %n_uword_bits, align 4, !dbg !1493
  %0 = load i32, i32* %d.addr, align 4, !dbg !1494
  %cmp = icmp eq i32 %0, 0, !dbg !1495
  br i1 %cmp, label %if.then, label %if.end, !dbg !1494

if.then:                                          ; preds = %entry
  store i32 0, i32* %retval, align 4, !dbg !1496
  br label %return, !dbg !1496

if.end:                                           ; preds = %entry
  %1 = load i32, i32* %n.addr, align 4, !dbg !1497
  %cmp1 = icmp eq i32 %1, 0, !dbg !1498
  br i1 %cmp1, label %if.then2, label %if.end3, !dbg !1497

if.then2:                                         ; preds = %if.end
  store i32 0, i32* %retval, align 4, !dbg !1499
  br label %return, !dbg !1499

if.end3:                                          ; preds = %if.end
  %2 = load i32, i32* %d.addr, align 4, !dbg !1500
  %3 = call i32 @llvm.ctlz.i32(i32 %2, i1 false), !dbg !1501
  %4 = load i32, i32* %n.addr, align 4, !dbg !1502
  %5 = call i32 @llvm.ctlz.i32(i32 %4, i1 false), !dbg !1503
  %sub = sub nsw i32 %3, %5, !dbg !1504
  store i32 %sub, i32* %sr, align 4, !dbg !1505
  %6 = load i32, i32* %sr, align 4, !dbg !1506
  %cmp4 = icmp ugt i32 %6, 31, !dbg !1507
  br i1 %cmp4, label %if.then5, label %if.end6, !dbg !1506

if.then5:                                         ; preds = %if.end3
  store i32 0, i32* %retval, align 4, !dbg !1508
  br label %return, !dbg !1508

if.end6:                                          ; preds = %if.end3
  %7 = load i32, i32* %sr, align 4, !dbg !1509
  %cmp7 = icmp eq i32 %7, 31, !dbg !1510
  br i1 %cmp7, label %if.then8, label %if.end9, !dbg !1509

if.then8:                                         ; preds = %if.end6
  %8 = load i32, i32* %n.addr, align 4, !dbg !1511
  store i32 %8, i32* %retval, align 4, !dbg !1512
  br label %return, !dbg !1512

if.end9:                                          ; preds = %if.end6
  %9 = load i32, i32* %sr, align 4, !dbg !1513
  %inc = add i32 %9, 1, !dbg !1513
  store i32 %inc, i32* %sr, align 4, !dbg !1513
  %10 = load i32, i32* %n.addr, align 4, !dbg !1514
  %11 = load i32, i32* %sr, align 4, !dbg !1515
  %sub10 = sub i32 32, %11, !dbg !1516
  %shl = shl i32 %10, %sub10, !dbg !1517
  store i32 %shl, i32* %q, align 4, !dbg !1518
  %12 = load i32, i32* %n.addr, align 4, !dbg !1519
  %13 = load i32, i32* %sr, align 4, !dbg !1520
  %shr = lshr i32 %12, %13, !dbg !1521
  store i32 %shr, i32* %r, align 4, !dbg !1522
  store i32 0, i32* %carry, align 4, !dbg !1523
  br label %for.cond, !dbg !1524

for.cond:                                         ; preds = %for.inc, %if.end9
  %14 = load i32, i32* %sr, align 4, !dbg !1525
  %cmp11 = icmp ugt i32 %14, 0, !dbg !1526
  br i1 %cmp11, label %for.body, label %for.end, !dbg !1524

for.body:                                         ; preds = %for.cond
  %15 = load i32, i32* %r, align 4, !dbg !1527
  %shl12 = shl i32 %15, 1, !dbg !1528
  %16 = load i32, i32* %q, align 4, !dbg !1529
  %shr13 = lshr i32 %16, 31, !dbg !1530
  %or = or i32 %shl12, %shr13, !dbg !1531
  store i32 %or, i32* %r, align 4, !dbg !1532
  %17 = load i32, i32* %q, align 4, !dbg !1533
  %shl14 = shl i32 %17, 1, !dbg !1534
  %18 = load i32, i32* %carry, align 4, !dbg !1535
  %or15 = or i32 %shl14, %18, !dbg !1536
  store i32 %or15, i32* %q, align 4, !dbg !1537
  %19 = load i32, i32* %d.addr, align 4, !dbg !1538
  %20 = load i32, i32* %r, align 4, !dbg !1539
  %sub16 = sub i32 %19, %20, !dbg !1540
  %sub17 = sub i32 %sub16, 1, !dbg !1541
  %shr18 = ashr i32 %sub17, 31, !dbg !1542
  store i32 %shr18, i32* %s, align 4, !dbg !1543
  %21 = load i32, i32* %s, align 4, !dbg !1544
  %and = and i32 %21, 1, !dbg !1545
  store i32 %and, i32* %carry, align 4, !dbg !1546
  %22 = load i32, i32* %d.addr, align 4, !dbg !1547
  %23 = load i32, i32* %s, align 4, !dbg !1548
  %and19 = and i32 %22, %23, !dbg !1549
  %24 = load i32, i32* %r, align 4, !dbg !1550
  %sub20 = sub i32 %24, %and19, !dbg !1550
  store i32 %sub20, i32* %r, align 4, !dbg !1550
  br label %for.inc, !dbg !1551

for.inc:                                          ; preds = %for.body
  %25 = load i32, i32* %sr, align 4, !dbg !1552
  %dec = add i32 %25, -1, !dbg !1552
  store i32 %dec, i32* %sr, align 4, !dbg !1552
  br label %for.cond, !dbg !1524, !llvm.loop !1553

for.end:                                          ; preds = %for.cond
  %26 = load i32, i32* %q, align 4, !dbg !1554
  %shl21 = shl i32 %26, 1, !dbg !1555
  %27 = load i32, i32* %carry, align 4, !dbg !1556
  %or22 = or i32 %shl21, %27, !dbg !1557
  store i32 %or22, i32* %q, align 4, !dbg !1558
  %28 = load i32, i32* %q, align 4, !dbg !1559
  store i32 %28, i32* %retval, align 4, !dbg !1560
  br label %return, !dbg !1560

return:                                           ; preds = %for.end, %if.then8, %if.then5, %if.then2, %if.then
  %29 = load i32, i32* %retval, align 4, !dbg !1561
  ret i32 %29, !dbg !1561
}

; Function Attrs: noinline nounwind
define dso_local arm_aapcscc i64 @__umoddi3(i64 %a, i64 %b) #0 !dbg !1562 {
entry:
  %a.addr = alloca i64, align 8
  %b.addr = alloca i64, align 8
  %r = alloca i64, align 8
  store i64 %a, i64* %a.addr, align 8
  store i64 %b, i64* %b.addr, align 8
  %0 = load i64, i64* %a.addr, align 8, !dbg !1563
  %1 = load i64, i64* %b.addr, align 8, !dbg !1564
  %call = call arm_aapcscc i64 @__udivmoddi4(i64 %0, i64 %1, i64* %r) #4, !dbg !1565
  %2 = load i64, i64* %r, align 8, !dbg !1566
  ret i64 %2, !dbg !1567
}

; Function Attrs: noinline nounwind
define dso_local arm_aapcscc i32 @__umodsi3(i32 %a, i32 %b) #0 !dbg !1568 {
entry:
  %a.addr = alloca i32, align 4
  %b.addr = alloca i32, align 4
  store i32 %a, i32* %a.addr, align 4
  store i32 %b, i32* %b.addr, align 4
  %0 = load i32, i32* %a.addr, align 4, !dbg !1569
  %1 = load i32, i32* %a.addr, align 4, !dbg !1570
  %2 = load i32, i32* %b.addr, align 4, !dbg !1571
  %call = call arm_aapcscc i32 @__udivsi3(i32 %1, i32 %2) #4, !dbg !1572
  %3 = load i32, i32* %b.addr, align 4, !dbg !1573
  %mul = mul i32 %call, %3, !dbg !1574
  %sub = sub i32 %0, %mul, !dbg !1575
  ret i32 %sub, !dbg !1576
}

attributes #0 = { noinline nounwind "correctly-rounded-divide-sqrt-fp-math"="false" "disable-tail-calls"="false" "less-precise-fpmad"="false" "min-legal-vector-width"="0" "no-frame-pointer-elim"="true" "no-frame-pointer-elim-non-leaf" "no-infs-fp-math"="false" "no-jump-tables"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="false" "stack-protector-buffer-size"="8" "target-cpu"="generic" "target-features"="+armv7-a,+d32,+dsp,+fp64,+fpregs,+neon,+strict-align,+vfp2,+vfp2d16,+vfp2d16sp,+vfp2sp,+vfp3,+vfp3d16,+vfp3d16sp,+vfp3sp,-thumb-mode" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #1 = { nounwind readnone speculatable }
attributes #2 = { noinline noreturn nounwind "correctly-rounded-divide-sqrt-fp-math"="false" "disable-tail-calls"="false" "less-precise-fpmad"="false" "min-legal-vector-width"="0" "no-frame-pointer-elim"="true" "no-frame-pointer-elim-non-leaf" "no-infs-fp-math"="false" "no-jump-tables"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="false" "stack-protector-buffer-size"="8" "target-cpu"="generic" "target-features"="+armv7-a,+d32,+dsp,+fp64,+fpregs,+neon,+strict-align,+vfp2,+vfp2d16,+vfp2d16sp,+vfp2sp,+vfp3,+vfp3d16,+vfp3d16sp,+vfp3sp,-thumb-mode" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #3 = { nobuiltin noreturn }
attributes #4 = { nobuiltin }

!llvm.dbg.cu = !{!0, !3, !5, !7, !9, !11, !13, !15, !17, !19, !21, !23, !25, !27, !29, !31, !33, !35, !37, !39, !41, !43, !45, !47, !49, !51, !53, !55, !57, !59, !61, !63, !65, !67, !69, !71, !73, !75, !77, !79, !81, !83, !85, !87, !89, !91, !93, !95, !97, !99, !101, !103, !105, !107, !109}
!llvm.ident = !{!111, !111, !111, !111, !111, !111, !111, !111, !111, !111, !111, !111, !111, !111, !111, !111, !111, !111, !111, !111, !111, !111, !111, !111, !111, !111, !111, !111, !111, !111, !111, !111, !111, !111, !111, !111, !111, !111, !111, !111, !111, !111, !111, !111, !111, !111, !111, !111, !111, !111, !111, !111, !111, !111, !111}
!llvm.module.flags = !{!112, !113, !114, !115}

!0 = distinct !DICompileUnit(language: DW_LANG_C99, file: !1, producer: "clang version 9.0.0 (tags/RELEASE_900/final)", isOptimized: false, runtimeVersion: 0, emissionKind: LineTablesOnly, enums: !2, nameTableKind: None)
!1 = !DIFile(filename: "absvdi2.c", directory: "/llvmta_testcases/libraries/builtinsint")
!2 = !{}
!3 = distinct !DICompileUnit(language: DW_LANG_C99, file: !4, producer: "clang version 9.0.0 (tags/RELEASE_900/final)", isOptimized: false, runtimeVersion: 0, emissionKind: LineTablesOnly, enums: !2, nameTableKind: None)
!4 = !DIFile(filename: "absvsi2.c", directory: "/llvmta_testcases/libraries/builtinsint")
!5 = distinct !DICompileUnit(language: DW_LANG_C99, file: !6, producer: "clang version 9.0.0 (tags/RELEASE_900/final)", isOptimized: false, runtimeVersion: 0, emissionKind: LineTablesOnly, enums: !2, nameTableKind: None)
!6 = !DIFile(filename: "absvti2.c", directory: "/llvmta_testcases/libraries/builtinsint")
!7 = distinct !DICompileUnit(language: DW_LANG_C99, file: !8, producer: "clang version 9.0.0 (tags/RELEASE_900/final)", isOptimized: false, runtimeVersion: 0, emissionKind: LineTablesOnly, enums: !2, nameTableKind: None)
!8 = !DIFile(filename: "addvdi3.c", directory: "/llvmta_testcases/libraries/builtinsint")
!9 = distinct !DICompileUnit(language: DW_LANG_C99, file: !10, producer: "clang version 9.0.0 (tags/RELEASE_900/final)", isOptimized: false, runtimeVersion: 0, emissionKind: LineTablesOnly, enums: !2, nameTableKind: None)
!10 = !DIFile(filename: "addvsi3.c", directory: "/llvmta_testcases/libraries/builtinsint")
!11 = distinct !DICompileUnit(language: DW_LANG_C99, file: !12, producer: "clang version 9.0.0 (tags/RELEASE_900/final)", isOptimized: false, runtimeVersion: 0, emissionKind: LineTablesOnly, enums: !2, nameTableKind: None)
!12 = !DIFile(filename: "addvti3.c", directory: "/llvmta_testcases/libraries/builtinsint")
!13 = distinct !DICompileUnit(language: DW_LANG_C99, file: !14, producer: "clang version 9.0.0 (tags/RELEASE_900/final)", isOptimized: false, runtimeVersion: 0, emissionKind: LineTablesOnly, enums: !2, nameTableKind: None)
!14 = !DIFile(filename: "ashldi3.c", directory: "/llvmta_testcases/libraries/builtinsint")
!15 = distinct !DICompileUnit(language: DW_LANG_C99, file: !16, producer: "clang version 9.0.0 (tags/RELEASE_900/final)", isOptimized: false, runtimeVersion: 0, emissionKind: LineTablesOnly, enums: !2, nameTableKind: None)
!16 = !DIFile(filename: "ashlti3.c", directory: "/llvmta_testcases/libraries/builtinsint")
!17 = distinct !DICompileUnit(language: DW_LANG_C99, file: !18, producer: "clang version 9.0.0 (tags/RELEASE_900/final)", isOptimized: false, runtimeVersion: 0, emissionKind: LineTablesOnly, enums: !2, nameTableKind: None)
!18 = !DIFile(filename: "ashrdi3.c", directory: "/llvmta_testcases/libraries/builtinsint")
!19 = distinct !DICompileUnit(language: DW_LANG_C99, file: !20, producer: "clang version 9.0.0 (tags/RELEASE_900/final)", isOptimized: false, runtimeVersion: 0, emissionKind: LineTablesOnly, enums: !2, nameTableKind: None)
!20 = !DIFile(filename: "ashrti3.c", directory: "/llvmta_testcases/libraries/builtinsint")
!21 = distinct !DICompileUnit(language: DW_LANG_C99, file: !22, producer: "clang version 9.0.0 (tags/RELEASE_900/final)", isOptimized: false, runtimeVersion: 0, emissionKind: LineTablesOnly, enums: !2, nameTableKind: None)
!22 = !DIFile(filename: "clzdi2.c", directory: "/llvmta_testcases/libraries/builtinsint")
!23 = distinct !DICompileUnit(language: DW_LANG_C99, file: !24, producer: "clang version 9.0.0 (tags/RELEASE_900/final)", isOptimized: false, runtimeVersion: 0, emissionKind: LineTablesOnly, enums: !2, nameTableKind: None)
!24 = !DIFile(filename: "clzsi2.c", directory: "/llvmta_testcases/libraries/builtinsint")
!25 = distinct !DICompileUnit(language: DW_LANG_C99, file: !26, producer: "clang version 9.0.0 (tags/RELEASE_900/final)", isOptimized: false, runtimeVersion: 0, emissionKind: LineTablesOnly, enums: !2, nameTableKind: None)
!26 = !DIFile(filename: "clzti2.c", directory: "/llvmta_testcases/libraries/builtinsint")
!27 = distinct !DICompileUnit(language: DW_LANG_C99, file: !28, producer: "clang version 9.0.0 (tags/RELEASE_900/final)", isOptimized: false, runtimeVersion: 0, emissionKind: LineTablesOnly, enums: !2, nameTableKind: None)
!28 = !DIFile(filename: "cmpdi2.c", directory: "/llvmta_testcases/libraries/builtinsint")
!29 = distinct !DICompileUnit(language: DW_LANG_C99, file: !30, producer: "clang version 9.0.0 (tags/RELEASE_900/final)", isOptimized: false, runtimeVersion: 0, emissionKind: LineTablesOnly, enums: !2, nameTableKind: None)
!30 = !DIFile(filename: "cmpti2.c", directory: "/llvmta_testcases/libraries/builtinsint")
!31 = distinct !DICompileUnit(language: DW_LANG_C99, file: !32, producer: "clang version 9.0.0 (tags/RELEASE_900/final)", isOptimized: false, runtimeVersion: 0, emissionKind: LineTablesOnly, enums: !2, nameTableKind: None)
!32 = !DIFile(filename: "ctzdi2.c", directory: "/llvmta_testcases/libraries/builtinsint")
!33 = distinct !DICompileUnit(language: DW_LANG_C99, file: !34, producer: "clang version 9.0.0 (tags/RELEASE_900/final)", isOptimized: false, runtimeVersion: 0, emissionKind: LineTablesOnly, enums: !2, nameTableKind: None)
!34 = !DIFile(filename: "ctzsi2.c", directory: "/llvmta_testcases/libraries/builtinsint")
!35 = distinct !DICompileUnit(language: DW_LANG_C99, file: !36, producer: "clang version 9.0.0 (tags/RELEASE_900/final)", isOptimized: false, runtimeVersion: 0, emissionKind: LineTablesOnly, enums: !2, nameTableKind: None)
!36 = !DIFile(filename: "ctzti2.c", directory: "/llvmta_testcases/libraries/builtinsint")
!37 = distinct !DICompileUnit(language: DW_LANG_C99, file: !38, producer: "clang version 9.0.0 (tags/RELEASE_900/final)", isOptimized: false, runtimeVersion: 0, emissionKind: LineTablesOnly, enums: !2, nameTableKind: None)
!38 = !DIFile(filename: "divdi3.c", directory: "/llvmta_testcases/libraries/builtinsint")
!39 = distinct !DICompileUnit(language: DW_LANG_C99, file: !40, producer: "clang version 9.0.0 (tags/RELEASE_900/final)", isOptimized: false, runtimeVersion: 0, emissionKind: LineTablesOnly, enums: !2, nameTableKind: None)
!40 = !DIFile(filename: "divmoddi4.c", directory: "/llvmta_testcases/libraries/builtinsint")
!41 = distinct !DICompileUnit(language: DW_LANG_C99, file: !42, producer: "clang version 9.0.0 (tags/RELEASE_900/final)", isOptimized: false, runtimeVersion: 0, emissionKind: LineTablesOnly, enums: !2, nameTableKind: None)
!42 = !DIFile(filename: "divmodsi4.c", directory: "/llvmta_testcases/libraries/builtinsint")
!43 = distinct !DICompileUnit(language: DW_LANG_C99, file: !44, producer: "clang version 9.0.0 (tags/RELEASE_900/final)", isOptimized: false, runtimeVersion: 0, emissionKind: LineTablesOnly, enums: !2, nameTableKind: None)
!44 = !DIFile(filename: "divsi3.c", directory: "/llvmta_testcases/libraries/builtinsint")
!45 = distinct !DICompileUnit(language: DW_LANG_C99, file: !46, producer: "clang version 9.0.0 (tags/RELEASE_900/final)", isOptimized: false, runtimeVersion: 0, emissionKind: LineTablesOnly, enums: !2, nameTableKind: None)
!46 = !DIFile(filename: "divti3.c", directory: "/llvmta_testcases/libraries/builtinsint")
!47 = distinct !DICompileUnit(language: DW_LANG_C99, file: !48, producer: "clang version 9.0.0 (tags/RELEASE_900/final)", isOptimized: false, runtimeVersion: 0, emissionKind: LineTablesOnly, enums: !2, nameTableKind: None)
!48 = !DIFile(filename: "ffsdi2.c", directory: "/llvmta_testcases/libraries/builtinsint")
!49 = distinct !DICompileUnit(language: DW_LANG_C99, file: !50, producer: "clang version 9.0.0 (tags/RELEASE_900/final)", isOptimized: false, runtimeVersion: 0, emissionKind: LineTablesOnly, enums: !2, nameTableKind: None)
!50 = !DIFile(filename: "ffssi2.c", directory: "/llvmta_testcases/libraries/builtinsint")
!51 = distinct !DICompileUnit(language: DW_LANG_C99, file: !52, producer: "clang version 9.0.0 (tags/RELEASE_900/final)", isOptimized: false, runtimeVersion: 0, emissionKind: LineTablesOnly, enums: !2, nameTableKind: None)
!52 = !DIFile(filename: "ffsti2.c", directory: "/llvmta_testcases/libraries/builtinsint")
!53 = distinct !DICompileUnit(language: DW_LANG_C99, file: !54, producer: "clang version 9.0.0 (tags/RELEASE_900/final)", isOptimized: false, runtimeVersion: 0, emissionKind: LineTablesOnly, enums: !2, nameTableKind: None)
!54 = !DIFile(filename: "int_util.c", directory: "/llvmta_testcases/libraries/builtinsint")
!55 = distinct !DICompileUnit(language: DW_LANG_C99, file: !56, producer: "clang version 9.0.0 (tags/RELEASE_900/final)", isOptimized: false, runtimeVersion: 0, emissionKind: LineTablesOnly, enums: !2, nameTableKind: None)
!56 = !DIFile(filename: "lshrdi3.c", directory: "/llvmta_testcases/libraries/builtinsint")
!57 = distinct !DICompileUnit(language: DW_LANG_C99, file: !58, producer: "clang version 9.0.0 (tags/RELEASE_900/final)", isOptimized: false, runtimeVersion: 0, emissionKind: LineTablesOnly, enums: !2, nameTableKind: None)
!58 = !DIFile(filename: "lshrti3.c", directory: "/llvmta_testcases/libraries/builtinsint")
!59 = distinct !DICompileUnit(language: DW_LANG_C99, file: !60, producer: "clang version 9.0.0 (tags/RELEASE_900/final)", isOptimized: false, runtimeVersion: 0, emissionKind: LineTablesOnly, enums: !2, nameTableKind: None)
!60 = !DIFile(filename: "moddi3.c", directory: "/llvmta_testcases/libraries/builtinsint")
!61 = distinct !DICompileUnit(language: DW_LANG_C99, file: !62, producer: "clang version 9.0.0 (tags/RELEASE_900/final)", isOptimized: false, runtimeVersion: 0, emissionKind: LineTablesOnly, enums: !2, nameTableKind: None)
!62 = !DIFile(filename: "modsi3.c", directory: "/llvmta_testcases/libraries/builtinsint")
!63 = distinct !DICompileUnit(language: DW_LANG_C99, file: !64, producer: "clang version 9.0.0 (tags/RELEASE_900/final)", isOptimized: false, runtimeVersion: 0, emissionKind: LineTablesOnly, enums: !2, nameTableKind: None)
!64 = !DIFile(filename: "modti3.c", directory: "/llvmta_testcases/libraries/builtinsint")
!65 = distinct !DICompileUnit(language: DW_LANG_C99, file: !66, producer: "clang version 9.0.0 (tags/RELEASE_900/final)", isOptimized: false, runtimeVersion: 0, emissionKind: LineTablesOnly, enums: !2, nameTableKind: None)
!66 = !DIFile(filename: "mulvdi3.c", directory: "/llvmta_testcases/libraries/builtinsint")
!67 = distinct !DICompileUnit(language: DW_LANG_C99, file: !68, producer: "clang version 9.0.0 (tags/RELEASE_900/final)", isOptimized: false, runtimeVersion: 0, emissionKind: LineTablesOnly, enums: !2, nameTableKind: None)
!68 = !DIFile(filename: "mulvsi3.c", directory: "/llvmta_testcases/libraries/builtinsint")
!69 = distinct !DICompileUnit(language: DW_LANG_C99, file: !70, producer: "clang version 9.0.0 (tags/RELEASE_900/final)", isOptimized: false, runtimeVersion: 0, emissionKind: LineTablesOnly, enums: !2, nameTableKind: None)
!70 = !DIFile(filename: "mulvti3.c", directory: "/llvmta_testcases/libraries/builtinsint")
!71 = distinct !DICompileUnit(language: DW_LANG_C99, file: !72, producer: "clang version 9.0.0 (tags/RELEASE_900/final)", isOptimized: false, runtimeVersion: 0, emissionKind: LineTablesOnly, enums: !2, nameTableKind: None)
!72 = !DIFile(filename: "paritydi2.c", directory: "/llvmta_testcases/libraries/builtinsint")
!73 = distinct !DICompileUnit(language: DW_LANG_C99, file: !74, producer: "clang version 9.0.0 (tags/RELEASE_900/final)", isOptimized: false, runtimeVersion: 0, emissionKind: LineTablesOnly, enums: !2, nameTableKind: None)
!74 = !DIFile(filename: "paritysi2.c", directory: "/llvmta_testcases/libraries/builtinsint")
!75 = distinct !DICompileUnit(language: DW_LANG_C99, file: !76, producer: "clang version 9.0.0 (tags/RELEASE_900/final)", isOptimized: false, runtimeVersion: 0, emissionKind: LineTablesOnly, enums: !2, nameTableKind: None)
!76 = !DIFile(filename: "parityti2.c", directory: "/llvmta_testcases/libraries/builtinsint")
!77 = distinct !DICompileUnit(language: DW_LANG_C99, file: !78, producer: "clang version 9.0.0 (tags/RELEASE_900/final)", isOptimized: false, runtimeVersion: 0, emissionKind: LineTablesOnly, enums: !2, nameTableKind: None)
!78 = !DIFile(filename: "popcountdi2.c", directory: "/llvmta_testcases/libraries/builtinsint")
!79 = distinct !DICompileUnit(language: DW_LANG_C99, file: !80, producer: "clang version 9.0.0 (tags/RELEASE_900/final)", isOptimized: false, runtimeVersion: 0, emissionKind: LineTablesOnly, enums: !2, nameTableKind: None)
!80 = !DIFile(filename: "popcountsi2.c", directory: "/llvmta_testcases/libraries/builtinsint")
!81 = distinct !DICompileUnit(language: DW_LANG_C99, file: !82, producer: "clang version 9.0.0 (tags/RELEASE_900/final)", isOptimized: false, runtimeVersion: 0, emissionKind: LineTablesOnly, enums: !2, nameTableKind: None)
!82 = !DIFile(filename: "popcountti2.c", directory: "/llvmta_testcases/libraries/builtinsint")
!83 = distinct !DICompileUnit(language: DW_LANG_C99, file: !84, producer: "clang version 9.0.0 (tags/RELEASE_900/final)", isOptimized: false, runtimeVersion: 0, emissionKind: LineTablesOnly, enums: !2, nameTableKind: None)
!84 = !DIFile(filename: "subvdi3.c", directory: "/llvmta_testcases/libraries/builtinsint")
!85 = distinct !DICompileUnit(language: DW_LANG_C99, file: !86, producer: "clang version 9.0.0 (tags/RELEASE_900/final)", isOptimized: false, runtimeVersion: 0, emissionKind: LineTablesOnly, enums: !2, nameTableKind: None)
!86 = !DIFile(filename: "subvsi3.c", directory: "/llvmta_testcases/libraries/builtinsint")
!87 = distinct !DICompileUnit(language: DW_LANG_C99, file: !88, producer: "clang version 9.0.0 (tags/RELEASE_900/final)", isOptimized: false, runtimeVersion: 0, emissionKind: LineTablesOnly, enums: !2, nameTableKind: None)
!88 = !DIFile(filename: "subvti3.c", directory: "/llvmta_testcases/libraries/builtinsint")
!89 = distinct !DICompileUnit(language: DW_LANG_C99, file: !90, producer: "clang version 9.0.0 (tags/RELEASE_900/final)", isOptimized: false, runtimeVersion: 0, emissionKind: LineTablesOnly, enums: !2, nameTableKind: None)
!90 = !DIFile(filename: "ucmpdi2.c", directory: "/llvmta_testcases/libraries/builtinsint")
!91 = distinct !DICompileUnit(language: DW_LANG_C99, file: !92, producer: "clang version 9.0.0 (tags/RELEASE_900/final)", isOptimized: false, runtimeVersion: 0, emissionKind: LineTablesOnly, enums: !2, nameTableKind: None)
!92 = !DIFile(filename: "ucmpti2.c", directory: "/llvmta_testcases/libraries/builtinsint")
!93 = distinct !DICompileUnit(language: DW_LANG_C99, file: !94, producer: "clang version 9.0.0 (tags/RELEASE_900/final)", isOptimized: false, runtimeVersion: 0, emissionKind: LineTablesOnly, enums: !2, nameTableKind: None)
!94 = !DIFile(filename: "udivdi3.c", directory: "/llvmta_testcases/libraries/builtinsint")
!95 = distinct !DICompileUnit(language: DW_LANG_C99, file: !96, producer: "clang version 9.0.0 (tags/RELEASE_900/final)", isOptimized: false, runtimeVersion: 0, emissionKind: LineTablesOnly, enums: !2, nameTableKind: None)
!96 = !DIFile(filename: "udivmoddi4.c", directory: "/llvmta_testcases/libraries/builtinsint")
!97 = distinct !DICompileUnit(language: DW_LANG_C99, file: !98, producer: "clang version 9.0.0 (tags/RELEASE_900/final)", isOptimized: false, runtimeVersion: 0, emissionKind: LineTablesOnly, enums: !2, nameTableKind: None)
!98 = !DIFile(filename: "udivmodsi4.c", directory: "/llvmta_testcases/libraries/builtinsint")
!99 = distinct !DICompileUnit(language: DW_LANG_C99, file: !100, producer: "clang version 9.0.0 (tags/RELEASE_900/final)", isOptimized: false, runtimeVersion: 0, emissionKind: LineTablesOnly, enums: !2, nameTableKind: None)
!100 = !DIFile(filename: "udivmodti4.c", directory: "/llvmta_testcases/libraries/builtinsint")
!101 = distinct !DICompileUnit(language: DW_LANG_C99, file: !102, producer: "clang version 9.0.0 (tags/RELEASE_900/final)", isOptimized: false, runtimeVersion: 0, emissionKind: LineTablesOnly, enums: !2, nameTableKind: None)
!102 = !DIFile(filename: "udivsi3.c", directory: "/llvmta_testcases/libraries/builtinsint")
!103 = distinct !DICompileUnit(language: DW_LANG_C99, file: !104, producer: "clang version 9.0.0 (tags/RELEASE_900/final)", isOptimized: false, runtimeVersion: 0, emissionKind: LineTablesOnly, enums: !2, nameTableKind: None)
!104 = !DIFile(filename: "udivti3.c", directory: "/llvmta_testcases/libraries/builtinsint")
!105 = distinct !DICompileUnit(language: DW_LANG_C99, file: !106, producer: "clang version 9.0.0 (tags/RELEASE_900/final)", isOptimized: false, runtimeVersion: 0, emissionKind: LineTablesOnly, enums: !2, nameTableKind: None)
!106 = !DIFile(filename: "umoddi3.c", directory: "/llvmta_testcases/libraries/builtinsint")
!107 = distinct !DICompileUnit(language: DW_LANG_C99, file: !108, producer: "clang version 9.0.0 (tags/RELEASE_900/final)", isOptimized: false, runtimeVersion: 0, emissionKind: LineTablesOnly, enums: !2, nameTableKind: None)
!108 = !DIFile(filename: "umodsi3.c", directory: "/llvmta_testcases/libraries/builtinsint")
!109 = distinct !DICompileUnit(language: DW_LANG_C99, file: !110, producer: "clang version 9.0.0 (tags/RELEASE_900/final)", isOptimized: false, runtimeVersion: 0, emissionKind: LineTablesOnly, enums: !2, nameTableKind: None)
!110 = !DIFile(filename: "umodti3.c", directory: "/llvmta_testcases/libraries/builtinsint")
!111 = !{!"clang version 9.0.0 (tags/RELEASE_900/final)"}
!112 = !{i32 2, !"Dwarf Version", i32 4}
!113 = !{i32 2, !"Debug Info Version", i32 3}
!114 = !{i32 1, !"wchar_size", i32 4}
!115 = !{i32 1, !"min_enum_size", i32 4}
!116 = distinct !DISubprogram(name: "__absvdi2", scope: !1, file: !1, line: 22, type: !117, scopeLine: 23, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !0, retainedNodes: !2)
!117 = !DISubroutineType(types: !2)
!118 = !DILocation(line: 24, column: 15, scope: !116)
!119 = !DILocation(line: 25, column: 9, scope: !116)
!120 = !DILocation(line: 25, column: 11, scope: !116)
!121 = !DILocation(line: 26, column: 9, scope: !116)
!122 = !DILocation(line: 27, column: 22, scope: !116)
!123 = !DILocation(line: 27, column: 24, scope: !116)
!124 = !DILocation(line: 27, column: 18, scope: !116)
!125 = !DILocation(line: 28, column: 13, scope: !116)
!126 = !DILocation(line: 28, column: 17, scope: !116)
!127 = !DILocation(line: 28, column: 15, scope: !116)
!128 = !DILocation(line: 28, column: 22, scope: !116)
!129 = !DILocation(line: 28, column: 20, scope: !116)
!130 = !DILocation(line: 28, column: 5, scope: !116)
!131 = distinct !DISubprogram(name: "__absvsi2", scope: !4, file: !4, line: 22, type: !117, scopeLine: 23, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !3, retainedNodes: !2)
!132 = !DILocation(line: 24, column: 15, scope: !131)
!133 = !DILocation(line: 25, column: 9, scope: !131)
!134 = !DILocation(line: 25, column: 11, scope: !131)
!135 = !DILocation(line: 26, column: 9, scope: !131)
!136 = !DILocation(line: 27, column: 22, scope: !131)
!137 = !DILocation(line: 27, column: 24, scope: !131)
!138 = !DILocation(line: 27, column: 18, scope: !131)
!139 = !DILocation(line: 28, column: 13, scope: !131)
!140 = !DILocation(line: 28, column: 17, scope: !131)
!141 = !DILocation(line: 28, column: 15, scope: !131)
!142 = !DILocation(line: 28, column: 22, scope: !131)
!143 = !DILocation(line: 28, column: 20, scope: !131)
!144 = !DILocation(line: 28, column: 5, scope: !131)
!145 = distinct !DISubprogram(name: "__addvdi3", scope: !8, file: !8, line: 22, type: !117, scopeLine: 23, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !7, retainedNodes: !2)
!146 = !DILocation(line: 24, column: 25, scope: !145)
!147 = !DILocation(line: 24, column: 38, scope: !145)
!148 = !DILocation(line: 24, column: 27, scope: !145)
!149 = !DILocation(line: 24, column: 12, scope: !145)
!150 = !DILocation(line: 25, column: 9, scope: !145)
!151 = !DILocation(line: 25, column: 11, scope: !145)
!152 = !DILocation(line: 27, column: 13, scope: !145)
!153 = !DILocation(line: 27, column: 17, scope: !145)
!154 = !DILocation(line: 27, column: 15, scope: !145)
!155 = !DILocation(line: 28, column: 13, scope: !145)
!156 = !DILocation(line: 29, column: 5, scope: !145)
!157 = !DILocation(line: 32, column: 13, scope: !145)
!158 = !DILocation(line: 32, column: 18, scope: !145)
!159 = !DILocation(line: 32, column: 15, scope: !145)
!160 = !DILocation(line: 33, column: 13, scope: !145)
!161 = !DILocation(line: 35, column: 12, scope: !145)
!162 = !DILocation(line: 35, column: 5, scope: !145)
!163 = distinct !DISubprogram(name: "__addvsi3", scope: !10, file: !10, line: 22, type: !117, scopeLine: 23, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !9, retainedNodes: !2)
!164 = !DILocation(line: 24, column: 25, scope: !163)
!165 = !DILocation(line: 24, column: 38, scope: !163)
!166 = !DILocation(line: 24, column: 27, scope: !163)
!167 = !DILocation(line: 24, column: 12, scope: !163)
!168 = !DILocation(line: 25, column: 9, scope: !163)
!169 = !DILocation(line: 25, column: 11, scope: !163)
!170 = !DILocation(line: 27, column: 13, scope: !163)
!171 = !DILocation(line: 27, column: 17, scope: !163)
!172 = !DILocation(line: 27, column: 15, scope: !163)
!173 = !DILocation(line: 28, column: 13, scope: !163)
!174 = !DILocation(line: 29, column: 5, scope: !163)
!175 = !DILocation(line: 32, column: 13, scope: !163)
!176 = !DILocation(line: 32, column: 18, scope: !163)
!177 = !DILocation(line: 32, column: 15, scope: !163)
!178 = !DILocation(line: 33, column: 13, scope: !163)
!179 = !DILocation(line: 35, column: 12, scope: !163)
!180 = !DILocation(line: 35, column: 5, scope: !163)
!181 = distinct !DISubprogram(name: "__ashldi3", scope: !14, file: !14, line: 24, type: !117, scopeLine: 25, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !13, retainedNodes: !2)
!182 = !DILocation(line: 26, column: 15, scope: !181)
!183 = !DILocation(line: 29, column: 17, scope: !181)
!184 = !DILocation(line: 29, column: 11, scope: !181)
!185 = !DILocation(line: 29, column: 15, scope: !181)
!186 = !DILocation(line: 30, column: 9, scope: !181)
!187 = !DILocation(line: 30, column: 11, scope: !181)
!188 = !DILocation(line: 32, column: 16, scope: !181)
!189 = !DILocation(line: 32, column: 18, scope: !181)
!190 = !DILocation(line: 32, column: 22, scope: !181)
!191 = !DILocation(line: 33, column: 31, scope: !181)
!192 = !DILocation(line: 33, column: 33, scope: !181)
!193 = !DILocation(line: 33, column: 41, scope: !181)
!194 = !DILocation(line: 33, column: 43, scope: !181)
!195 = !DILocation(line: 33, column: 37, scope: !181)
!196 = !DILocation(line: 33, column: 16, scope: !181)
!197 = !DILocation(line: 33, column: 18, scope: !181)
!198 = !DILocation(line: 33, column: 23, scope: !181)
!199 = !DILocation(line: 34, column: 5, scope: !181)
!200 = !DILocation(line: 37, column: 13, scope: !181)
!201 = !DILocation(line: 37, column: 15, scope: !181)
!202 = !DILocation(line: 38, column: 20, scope: !181)
!203 = !DILocation(line: 38, column: 13, scope: !181)
!204 = !DILocation(line: 39, column: 31, scope: !181)
!205 = !DILocation(line: 39, column: 33, scope: !181)
!206 = !DILocation(line: 39, column: 40, scope: !181)
!207 = !DILocation(line: 39, column: 37, scope: !181)
!208 = !DILocation(line: 39, column: 16, scope: !181)
!209 = !DILocation(line: 39, column: 18, scope: !181)
!210 = !DILocation(line: 39, column: 23, scope: !181)
!211 = !DILocation(line: 40, column: 32, scope: !181)
!212 = !DILocation(line: 40, column: 34, scope: !181)
!213 = !DILocation(line: 40, column: 42, scope: !181)
!214 = !DILocation(line: 40, column: 39, scope: !181)
!215 = !DILocation(line: 40, column: 54, scope: !181)
!216 = !DILocation(line: 40, column: 56, scope: !181)
!217 = !DILocation(line: 40, column: 79, scope: !181)
!218 = !DILocation(line: 40, column: 77, scope: !181)
!219 = !DILocation(line: 40, column: 60, scope: !181)
!220 = !DILocation(line: 40, column: 45, scope: !181)
!221 = !DILocation(line: 40, column: 16, scope: !181)
!222 = !DILocation(line: 40, column: 18, scope: !181)
!223 = !DILocation(line: 40, column: 23, scope: !181)
!224 = !DILocation(line: 42, column: 19, scope: !181)
!225 = !DILocation(line: 42, column: 5, scope: !181)
!226 = !DILocation(line: 43, column: 1, scope: !181)
!227 = distinct !DISubprogram(name: "__ashrdi3", scope: !18, file: !18, line: 24, type: !117, scopeLine: 25, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !17, retainedNodes: !2)
!228 = !DILocation(line: 26, column: 15, scope: !227)
!229 = !DILocation(line: 29, column: 17, scope: !227)
!230 = !DILocation(line: 29, column: 11, scope: !227)
!231 = !DILocation(line: 29, column: 15, scope: !227)
!232 = !DILocation(line: 30, column: 9, scope: !227)
!233 = !DILocation(line: 30, column: 11, scope: !227)
!234 = !DILocation(line: 33, column: 31, scope: !227)
!235 = !DILocation(line: 33, column: 33, scope: !227)
!236 = !DILocation(line: 33, column: 38, scope: !227)
!237 = !DILocation(line: 33, column: 16, scope: !227)
!238 = !DILocation(line: 33, column: 18, scope: !227)
!239 = !DILocation(line: 33, column: 23, scope: !227)
!240 = !DILocation(line: 34, column: 30, scope: !227)
!241 = !DILocation(line: 34, column: 32, scope: !227)
!242 = !DILocation(line: 34, column: 41, scope: !227)
!243 = !DILocation(line: 34, column: 43, scope: !227)
!244 = !DILocation(line: 34, column: 37, scope: !227)
!245 = !DILocation(line: 34, column: 16, scope: !227)
!246 = !DILocation(line: 34, column: 18, scope: !227)
!247 = !DILocation(line: 34, column: 22, scope: !227)
!248 = !DILocation(line: 35, column: 5, scope: !227)
!249 = !DILocation(line: 38, column: 13, scope: !227)
!250 = !DILocation(line: 38, column: 15, scope: !227)
!251 = !DILocation(line: 39, column: 20, scope: !227)
!252 = !DILocation(line: 39, column: 13, scope: !227)
!253 = !DILocation(line: 40, column: 32, scope: !227)
!254 = !DILocation(line: 40, column: 34, scope: !227)
!255 = !DILocation(line: 40, column: 42, scope: !227)
!256 = !DILocation(line: 40, column: 39, scope: !227)
!257 = !DILocation(line: 40, column: 16, scope: !227)
!258 = !DILocation(line: 40, column: 18, scope: !227)
!259 = !DILocation(line: 40, column: 24, scope: !227)
!260 = !DILocation(line: 41, column: 31, scope: !227)
!261 = !DILocation(line: 41, column: 33, scope: !227)
!262 = !DILocation(line: 41, column: 57, scope: !227)
!263 = !DILocation(line: 41, column: 55, scope: !227)
!264 = !DILocation(line: 41, column: 38, scope: !227)
!265 = !DILocation(line: 41, column: 70, scope: !227)
!266 = !DILocation(line: 41, column: 72, scope: !227)
!267 = !DILocation(line: 41, column: 79, scope: !227)
!268 = !DILocation(line: 41, column: 76, scope: !227)
!269 = !DILocation(line: 41, column: 61, scope: !227)
!270 = !DILocation(line: 41, column: 16, scope: !227)
!271 = !DILocation(line: 41, column: 18, scope: !227)
!272 = !DILocation(line: 41, column: 22, scope: !227)
!273 = !DILocation(line: 43, column: 19, scope: !227)
!274 = !DILocation(line: 43, column: 5, scope: !227)
!275 = !DILocation(line: 44, column: 1, scope: !227)
!276 = distinct !DISubprogram(name: "__clzdi2", scope: !22, file: !22, line: 22, type: !117, scopeLine: 23, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !21, retainedNodes: !2)
!277 = !DILocation(line: 25, column: 13, scope: !276)
!278 = !DILocation(line: 25, column: 7, scope: !276)
!279 = !DILocation(line: 25, column: 11, scope: !276)
!280 = !DILocation(line: 26, column: 26, scope: !276)
!281 = !DILocation(line: 26, column: 28, scope: !276)
!282 = !DILocation(line: 26, column: 33, scope: !276)
!283 = !DILocation(line: 26, column: 22, scope: !276)
!284 = !DILocation(line: 26, column: 18, scope: !276)
!285 = !DILocation(line: 27, column: 29, scope: !276)
!286 = !DILocation(line: 27, column: 31, scope: !276)
!287 = !DILocation(line: 27, column: 39, scope: !276)
!288 = !DILocation(line: 27, column: 38, scope: !276)
!289 = !DILocation(line: 27, column: 36, scope: !276)
!290 = !DILocation(line: 27, column: 47, scope: !276)
!291 = !DILocation(line: 27, column: 49, scope: !276)
!292 = !DILocation(line: 27, column: 55, scope: !276)
!293 = !DILocation(line: 27, column: 53, scope: !276)
!294 = !DILocation(line: 27, column: 42, scope: !276)
!295 = !DILocation(line: 27, column: 12, scope: !276)
!296 = !DILocation(line: 28, column: 13, scope: !276)
!297 = !DILocation(line: 28, column: 15, scope: !276)
!298 = !DILocation(line: 27, column: 59, scope: !276)
!299 = !DILocation(line: 27, column: 5, scope: !276)
!300 = distinct !DISubprogram(name: "__clzsi2", scope: !24, file: !24, line: 22, type: !117, scopeLine: 23, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !23, retainedNodes: !2)
!301 = !DILocation(line: 24, column: 24, scope: !300)
!302 = !DILocation(line: 24, column: 12, scope: !300)
!303 = !DILocation(line: 25, column: 18, scope: !300)
!304 = !DILocation(line: 25, column: 20, scope: !300)
!305 = !DILocation(line: 25, column: 34, scope: !300)
!306 = !DILocation(line: 25, column: 40, scope: !300)
!307 = !DILocation(line: 25, column: 12, scope: !300)
!308 = !DILocation(line: 26, column: 16, scope: !300)
!309 = !DILocation(line: 26, column: 14, scope: !300)
!310 = !DILocation(line: 26, column: 7, scope: !300)
!311 = !DILocation(line: 27, column: 16, scope: !300)
!312 = !DILocation(line: 27, column: 12, scope: !300)
!313 = !DILocation(line: 29, column: 11, scope: !300)
!314 = !DILocation(line: 29, column: 13, scope: !300)
!315 = !DILocation(line: 29, column: 23, scope: !300)
!316 = !DILocation(line: 29, column: 29, scope: !300)
!317 = !DILocation(line: 29, column: 7, scope: !300)
!318 = !DILocation(line: 30, column: 15, scope: !300)
!319 = !DILocation(line: 30, column: 13, scope: !300)
!320 = !DILocation(line: 30, column: 7, scope: !300)
!321 = !DILocation(line: 31, column: 10, scope: !300)
!322 = !DILocation(line: 31, column: 7, scope: !300)
!323 = !DILocation(line: 33, column: 11, scope: !300)
!324 = !DILocation(line: 33, column: 13, scope: !300)
!325 = !DILocation(line: 33, column: 21, scope: !300)
!326 = !DILocation(line: 33, column: 27, scope: !300)
!327 = !DILocation(line: 33, column: 7, scope: !300)
!328 = !DILocation(line: 34, column: 15, scope: !300)
!329 = !DILocation(line: 34, column: 13, scope: !300)
!330 = !DILocation(line: 34, column: 7, scope: !300)
!331 = !DILocation(line: 35, column: 10, scope: !300)
!332 = !DILocation(line: 35, column: 7, scope: !300)
!333 = !DILocation(line: 37, column: 11, scope: !300)
!334 = !DILocation(line: 37, column: 13, scope: !300)
!335 = !DILocation(line: 37, column: 20, scope: !300)
!336 = !DILocation(line: 37, column: 26, scope: !300)
!337 = !DILocation(line: 37, column: 7, scope: !300)
!338 = !DILocation(line: 38, column: 15, scope: !300)
!339 = !DILocation(line: 38, column: 13, scope: !300)
!340 = !DILocation(line: 38, column: 7, scope: !300)
!341 = !DILocation(line: 39, column: 10, scope: !300)
!342 = !DILocation(line: 39, column: 7, scope: !300)
!343 = !DILocation(line: 52, column: 12, scope: !300)
!344 = !DILocation(line: 52, column: 22, scope: !300)
!345 = !DILocation(line: 52, column: 20, scope: !300)
!346 = !DILocation(line: 52, column: 30, scope: !300)
!347 = !DILocation(line: 52, column: 32, scope: !300)
!348 = !DILocation(line: 52, column: 37, scope: !300)
!349 = !DILocation(line: 52, column: 27, scope: !300)
!350 = !DILocation(line: 52, column: 25, scope: !300)
!351 = !DILocation(line: 52, column: 14, scope: !300)
!352 = !DILocation(line: 52, column: 5, scope: !300)
!353 = distinct !DISubprogram(name: "__cmpdi2", scope: !28, file: !28, line: 23, type: !117, scopeLine: 24, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !27, retainedNodes: !2)
!354 = !DILocation(line: 26, column: 13, scope: !353)
!355 = !DILocation(line: 26, column: 7, scope: !353)
!356 = !DILocation(line: 26, column: 11, scope: !353)
!357 = !DILocation(line: 28, column: 13, scope: !353)
!358 = !DILocation(line: 28, column: 7, scope: !353)
!359 = !DILocation(line: 28, column: 11, scope: !353)
!360 = !DILocation(line: 29, column: 11, scope: !353)
!361 = !DILocation(line: 29, column: 13, scope: !353)
!362 = !DILocation(line: 29, column: 22, scope: !353)
!363 = !DILocation(line: 29, column: 24, scope: !353)
!364 = !DILocation(line: 29, column: 18, scope: !353)
!365 = !DILocation(line: 29, column: 9, scope: !353)
!366 = !DILocation(line: 30, column: 9, scope: !353)
!367 = !DILocation(line: 31, column: 11, scope: !353)
!368 = !DILocation(line: 31, column: 13, scope: !353)
!369 = !DILocation(line: 31, column: 22, scope: !353)
!370 = !DILocation(line: 31, column: 24, scope: !353)
!371 = !DILocation(line: 31, column: 18, scope: !353)
!372 = !DILocation(line: 31, column: 9, scope: !353)
!373 = !DILocation(line: 32, column: 9, scope: !353)
!374 = !DILocation(line: 33, column: 11, scope: !353)
!375 = !DILocation(line: 33, column: 13, scope: !353)
!376 = !DILocation(line: 33, column: 21, scope: !353)
!377 = !DILocation(line: 33, column: 23, scope: !353)
!378 = !DILocation(line: 33, column: 17, scope: !353)
!379 = !DILocation(line: 33, column: 9, scope: !353)
!380 = !DILocation(line: 34, column: 9, scope: !353)
!381 = !DILocation(line: 35, column: 11, scope: !353)
!382 = !DILocation(line: 35, column: 13, scope: !353)
!383 = !DILocation(line: 35, column: 21, scope: !353)
!384 = !DILocation(line: 35, column: 23, scope: !353)
!385 = !DILocation(line: 35, column: 17, scope: !353)
!386 = !DILocation(line: 35, column: 9, scope: !353)
!387 = !DILocation(line: 36, column: 9, scope: !353)
!388 = !DILocation(line: 37, column: 5, scope: !353)
!389 = !DILocation(line: 38, column: 1, scope: !353)
!390 = distinct !DISubprogram(name: "__aeabi_lcmp", scope: !28, file: !28, line: 46, type: !117, scopeLine: 47, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !27, retainedNodes: !2)
!391 = !DILocation(line: 48, column: 18, scope: !390)
!392 = !DILocation(line: 48, column: 21, scope: !390)
!393 = !DILocation(line: 48, column: 9, scope: !390)
!394 = !DILocation(line: 48, column: 24, scope: !390)
!395 = !DILocation(line: 48, column: 2, scope: !390)
!396 = distinct !DISubprogram(name: "__ctzdi2", scope: !32, file: !32, line: 22, type: !117, scopeLine: 23, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !31, retainedNodes: !2)
!397 = !DILocation(line: 25, column: 13, scope: !396)
!398 = !DILocation(line: 25, column: 7, scope: !396)
!399 = !DILocation(line: 25, column: 11, scope: !396)
!400 = !DILocation(line: 26, column: 26, scope: !396)
!401 = !DILocation(line: 26, column: 28, scope: !396)
!402 = !DILocation(line: 26, column: 32, scope: !396)
!403 = !DILocation(line: 26, column: 22, scope: !396)
!404 = !DILocation(line: 26, column: 18, scope: !396)
!405 = !DILocation(line: 27, column: 29, scope: !396)
!406 = !DILocation(line: 27, column: 31, scope: !396)
!407 = !DILocation(line: 27, column: 38, scope: !396)
!408 = !DILocation(line: 27, column: 36, scope: !396)
!409 = !DILocation(line: 27, column: 46, scope: !396)
!410 = !DILocation(line: 27, column: 48, scope: !396)
!411 = !DILocation(line: 27, column: 55, scope: !396)
!412 = !DILocation(line: 27, column: 54, scope: !396)
!413 = !DILocation(line: 27, column: 52, scope: !396)
!414 = !DILocation(line: 27, column: 41, scope: !396)
!415 = !DILocation(line: 27, column: 12, scope: !396)
!416 = !DILocation(line: 28, column: 16, scope: !396)
!417 = !DILocation(line: 28, column: 18, scope: !396)
!418 = !DILocation(line: 27, column: 59, scope: !396)
!419 = !DILocation(line: 27, column: 5, scope: !396)
!420 = distinct !DISubprogram(name: "__ctzsi2", scope: !34, file: !34, line: 22, type: !117, scopeLine: 23, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !33, retainedNodes: !2)
!421 = !DILocation(line: 24, column: 24, scope: !420)
!422 = !DILocation(line: 24, column: 12, scope: !420)
!423 = !DILocation(line: 25, column: 18, scope: !420)
!424 = !DILocation(line: 25, column: 20, scope: !420)
!425 = !DILocation(line: 25, column: 34, scope: !420)
!426 = !DILocation(line: 25, column: 40, scope: !420)
!427 = !DILocation(line: 25, column: 12, scope: !420)
!428 = !DILocation(line: 26, column: 11, scope: !420)
!429 = !DILocation(line: 26, column: 7, scope: !420)
!430 = !DILocation(line: 27, column: 16, scope: !420)
!431 = !DILocation(line: 27, column: 12, scope: !420)
!432 = !DILocation(line: 29, column: 11, scope: !420)
!433 = !DILocation(line: 29, column: 13, scope: !420)
!434 = !DILocation(line: 29, column: 23, scope: !420)
!435 = !DILocation(line: 29, column: 29, scope: !420)
!436 = !DILocation(line: 29, column: 7, scope: !420)
!437 = !DILocation(line: 30, column: 11, scope: !420)
!438 = !DILocation(line: 30, column: 7, scope: !420)
!439 = !DILocation(line: 31, column: 10, scope: !420)
!440 = !DILocation(line: 31, column: 7, scope: !420)
!441 = !DILocation(line: 33, column: 11, scope: !420)
!442 = !DILocation(line: 33, column: 13, scope: !420)
!443 = !DILocation(line: 33, column: 21, scope: !420)
!444 = !DILocation(line: 33, column: 27, scope: !420)
!445 = !DILocation(line: 33, column: 7, scope: !420)
!446 = !DILocation(line: 34, column: 11, scope: !420)
!447 = !DILocation(line: 34, column: 7, scope: !420)
!448 = !DILocation(line: 35, column: 10, scope: !420)
!449 = !DILocation(line: 35, column: 7, scope: !420)
!450 = !DILocation(line: 37, column: 11, scope: !420)
!451 = !DILocation(line: 37, column: 13, scope: !420)
!452 = !DILocation(line: 37, column: 20, scope: !420)
!453 = !DILocation(line: 37, column: 26, scope: !420)
!454 = !DILocation(line: 37, column: 7, scope: !420)
!455 = !DILocation(line: 38, column: 11, scope: !420)
!456 = !DILocation(line: 38, column: 7, scope: !420)
!457 = !DILocation(line: 39, column: 7, scope: !420)
!458 = !DILocation(line: 40, column: 10, scope: !420)
!459 = !DILocation(line: 40, column: 7, scope: !420)
!460 = !DILocation(line: 56, column: 12, scope: !420)
!461 = !DILocation(line: 56, column: 23, scope: !420)
!462 = !DILocation(line: 56, column: 25, scope: !420)
!463 = !DILocation(line: 56, column: 20, scope: !420)
!464 = !DILocation(line: 56, column: 37, scope: !420)
!465 = !DILocation(line: 56, column: 39, scope: !420)
!466 = !DILocation(line: 56, column: 44, scope: !420)
!467 = !DILocation(line: 56, column: 34, scope: !420)
!468 = !DILocation(line: 56, column: 32, scope: !420)
!469 = !DILocation(line: 56, column: 14, scope: !420)
!470 = !DILocation(line: 56, column: 5, scope: !420)
!471 = distinct !DISubprogram(name: "__divdi3", scope: !38, file: !38, line: 20, type: !117, scopeLine: 21, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !37, retainedNodes: !2)
!472 = !DILocation(line: 22, column: 15, scope: !471)
!473 = !DILocation(line: 23, column: 18, scope: !471)
!474 = !DILocation(line: 23, column: 20, scope: !471)
!475 = !DILocation(line: 23, column: 12, scope: !471)
!476 = !DILocation(line: 24, column: 18, scope: !471)
!477 = !DILocation(line: 24, column: 20, scope: !471)
!478 = !DILocation(line: 24, column: 12, scope: !471)
!479 = !DILocation(line: 25, column: 10, scope: !471)
!480 = !DILocation(line: 25, column: 14, scope: !471)
!481 = !DILocation(line: 25, column: 12, scope: !471)
!482 = !DILocation(line: 25, column: 21, scope: !471)
!483 = !DILocation(line: 25, column: 19, scope: !471)
!484 = !DILocation(line: 25, column: 7, scope: !471)
!485 = !DILocation(line: 26, column: 10, scope: !471)
!486 = !DILocation(line: 26, column: 14, scope: !471)
!487 = !DILocation(line: 26, column: 12, scope: !471)
!488 = !DILocation(line: 26, column: 21, scope: !471)
!489 = !DILocation(line: 26, column: 19, scope: !471)
!490 = !DILocation(line: 26, column: 7, scope: !471)
!491 = !DILocation(line: 27, column: 12, scope: !471)
!492 = !DILocation(line: 27, column: 9, scope: !471)
!493 = !DILocation(line: 28, column: 26, scope: !471)
!494 = !DILocation(line: 28, column: 29, scope: !471)
!495 = !DILocation(line: 28, column: 13, scope: !471)
!496 = !DILocation(line: 28, column: 46, scope: !471)
!497 = !DILocation(line: 28, column: 44, scope: !471)
!498 = !DILocation(line: 28, column: 53, scope: !471)
!499 = !DILocation(line: 28, column: 51, scope: !471)
!500 = !DILocation(line: 28, column: 5, scope: !471)
!501 = distinct !DISubprogram(name: "__divmoddi4", scope: !40, file: !40, line: 20, type: !117, scopeLine: 21, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !39, retainedNodes: !2)
!502 = !DILocation(line: 22, column: 23, scope: !501)
!503 = !DILocation(line: 22, column: 25, scope: !501)
!504 = !DILocation(line: 22, column: 14, scope: !501)
!505 = !DILocation(line: 22, column: 10, scope: !501)
!506 = !DILocation(line: 23, column: 10, scope: !501)
!507 = !DILocation(line: 23, column: 15, scope: !501)
!508 = !DILocation(line: 23, column: 17, scope: !501)
!509 = !DILocation(line: 23, column: 16, scope: !501)
!510 = !DILocation(line: 23, column: 12, scope: !501)
!511 = !DILocation(line: 23, column: 4, scope: !501)
!512 = !DILocation(line: 23, column: 8, scope: !501)
!513 = !DILocation(line: 24, column: 10, scope: !501)
!514 = !DILocation(line: 24, column: 3, scope: !501)
!515 = distinct !DISubprogram(name: "__divmodsi4", scope: !42, file: !42, line: 20, type: !117, scopeLine: 21, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !41, retainedNodes: !2)
!516 = !DILocation(line: 22, column: 23, scope: !515)
!517 = !DILocation(line: 22, column: 25, scope: !515)
!518 = !DILocation(line: 22, column: 14, scope: !515)
!519 = !DILocation(line: 22, column: 10, scope: !515)
!520 = !DILocation(line: 23, column: 10, scope: !515)
!521 = !DILocation(line: 23, column: 15, scope: !515)
!522 = !DILocation(line: 23, column: 17, scope: !515)
!523 = !DILocation(line: 23, column: 16, scope: !515)
!524 = !DILocation(line: 23, column: 12, scope: !515)
!525 = !DILocation(line: 23, column: 4, scope: !515)
!526 = !DILocation(line: 23, column: 8, scope: !515)
!527 = !DILocation(line: 24, column: 10, scope: !515)
!528 = !DILocation(line: 24, column: 3, scope: !515)
!529 = distinct !DISubprogram(name: "__divsi3", scope: !44, file: !44, line: 22, type: !117, scopeLine: 23, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !43, retainedNodes: !2)
!530 = !DILocation(line: 24, column: 15, scope: !529)
!531 = !DILocation(line: 25, column: 18, scope: !529)
!532 = !DILocation(line: 25, column: 20, scope: !529)
!533 = !DILocation(line: 25, column: 12, scope: !529)
!534 = !DILocation(line: 26, column: 18, scope: !529)
!535 = !DILocation(line: 26, column: 20, scope: !529)
!536 = !DILocation(line: 26, column: 12, scope: !529)
!537 = !DILocation(line: 27, column: 10, scope: !529)
!538 = !DILocation(line: 27, column: 14, scope: !529)
!539 = !DILocation(line: 27, column: 12, scope: !529)
!540 = !DILocation(line: 27, column: 21, scope: !529)
!541 = !DILocation(line: 27, column: 19, scope: !529)
!542 = !DILocation(line: 27, column: 7, scope: !529)
!543 = !DILocation(line: 28, column: 10, scope: !529)
!544 = !DILocation(line: 28, column: 14, scope: !529)
!545 = !DILocation(line: 28, column: 12, scope: !529)
!546 = !DILocation(line: 28, column: 21, scope: !529)
!547 = !DILocation(line: 28, column: 19, scope: !529)
!548 = !DILocation(line: 28, column: 7, scope: !529)
!549 = !DILocation(line: 29, column: 12, scope: !529)
!550 = !DILocation(line: 29, column: 9, scope: !529)
!551 = !DILocation(line: 36, column: 21, scope: !529)
!552 = !DILocation(line: 36, column: 31, scope: !529)
!553 = !DILocation(line: 36, column: 22, scope: !529)
!554 = !DILocation(line: 36, column: 35, scope: !529)
!555 = !DILocation(line: 36, column: 33, scope: !529)
!556 = !DILocation(line: 36, column: 42, scope: !529)
!557 = !DILocation(line: 36, column: 40, scope: !529)
!558 = !DILocation(line: 36, column: 5, scope: !529)
!559 = distinct !DISubprogram(name: "__ffsdi2", scope: !48, file: !48, line: 22, type: !117, scopeLine: 23, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !47, retainedNodes: !2)
!560 = !DILocation(line: 25, column: 13, scope: !559)
!561 = !DILocation(line: 25, column: 7, scope: !559)
!562 = !DILocation(line: 25, column: 11, scope: !559)
!563 = !DILocation(line: 26, column: 11, scope: !559)
!564 = !DILocation(line: 26, column: 13, scope: !559)
!565 = !DILocation(line: 26, column: 17, scope: !559)
!566 = !DILocation(line: 26, column: 9, scope: !559)
!567 = !DILocation(line: 28, column: 15, scope: !559)
!568 = !DILocation(line: 28, column: 17, scope: !559)
!569 = !DILocation(line: 28, column: 22, scope: !559)
!570 = !DILocation(line: 28, column: 13, scope: !559)
!571 = !DILocation(line: 29, column: 13, scope: !559)
!572 = !DILocation(line: 30, column: 32, scope: !559)
!573 = !DILocation(line: 30, column: 34, scope: !559)
!574 = !DILocation(line: 30, column: 16, scope: !559)
!575 = !DILocation(line: 30, column: 40, scope: !559)
!576 = !DILocation(line: 30, column: 9, scope: !559)
!577 = !DILocation(line: 32, column: 28, scope: !559)
!578 = !DILocation(line: 32, column: 30, scope: !559)
!579 = !DILocation(line: 32, column: 12, scope: !559)
!580 = !DILocation(line: 32, column: 35, scope: !559)
!581 = !DILocation(line: 32, column: 5, scope: !559)
!582 = !DILocation(line: 33, column: 1, scope: !559)
!583 = distinct !DISubprogram(name: "__ffssi2", scope: !50, file: !50, line: 22, type: !117, scopeLine: 23, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !49, retainedNodes: !2)
!584 = !DILocation(line: 24, column: 9, scope: !583)
!585 = !DILocation(line: 24, column: 11, scope: !583)
!586 = !DILocation(line: 26, column: 9, scope: !583)
!587 = !DILocation(line: 28, column: 26, scope: !583)
!588 = !DILocation(line: 28, column: 12, scope: !583)
!589 = !DILocation(line: 28, column: 29, scope: !583)
!590 = !DILocation(line: 28, column: 5, scope: !583)
!591 = !DILocation(line: 29, column: 1, scope: !583)
!592 = distinct !DISubprogram(name: "compilerrt_abort_impl", scope: !54, file: !54, line: 57, type: !117, scopeLine: 57, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !53, retainedNodes: !2)
!593 = !DILocation(line: 59, column: 1, scope: !592)
!594 = distinct !DISubprogram(name: "__lshrdi3", scope: !56, file: !56, line: 24, type: !117, scopeLine: 25, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !55, retainedNodes: !2)
!595 = !DILocation(line: 26, column: 15, scope: !594)
!596 = !DILocation(line: 29, column: 17, scope: !594)
!597 = !DILocation(line: 29, column: 11, scope: !594)
!598 = !DILocation(line: 29, column: 15, scope: !594)
!599 = !DILocation(line: 30, column: 9, scope: !594)
!600 = !DILocation(line: 30, column: 11, scope: !594)
!601 = !DILocation(line: 32, column: 16, scope: !594)
!602 = !DILocation(line: 32, column: 18, scope: !594)
!603 = !DILocation(line: 32, column: 23, scope: !594)
!604 = !DILocation(line: 33, column: 30, scope: !594)
!605 = !DILocation(line: 33, column: 32, scope: !594)
!606 = !DILocation(line: 33, column: 41, scope: !594)
!607 = !DILocation(line: 33, column: 43, scope: !594)
!608 = !DILocation(line: 33, column: 37, scope: !594)
!609 = !DILocation(line: 33, column: 16, scope: !594)
!610 = !DILocation(line: 33, column: 18, scope: !594)
!611 = !DILocation(line: 33, column: 22, scope: !594)
!612 = !DILocation(line: 34, column: 5, scope: !594)
!613 = !DILocation(line: 37, column: 13, scope: !594)
!614 = !DILocation(line: 37, column: 15, scope: !594)
!615 = !DILocation(line: 38, column: 20, scope: !594)
!616 = !DILocation(line: 38, column: 13, scope: !594)
!617 = !DILocation(line: 39, column: 32, scope: !594)
!618 = !DILocation(line: 39, column: 34, scope: !594)
!619 = !DILocation(line: 39, column: 42, scope: !594)
!620 = !DILocation(line: 39, column: 39, scope: !594)
!621 = !DILocation(line: 39, column: 16, scope: !594)
!622 = !DILocation(line: 39, column: 18, scope: !594)
!623 = !DILocation(line: 39, column: 24, scope: !594)
!624 = !DILocation(line: 40, column: 31, scope: !594)
!625 = !DILocation(line: 40, column: 33, scope: !594)
!626 = !DILocation(line: 40, column: 57, scope: !594)
!627 = !DILocation(line: 40, column: 55, scope: !594)
!628 = !DILocation(line: 40, column: 38, scope: !594)
!629 = !DILocation(line: 40, column: 70, scope: !594)
!630 = !DILocation(line: 40, column: 72, scope: !594)
!631 = !DILocation(line: 40, column: 79, scope: !594)
!632 = !DILocation(line: 40, column: 76, scope: !594)
!633 = !DILocation(line: 40, column: 61, scope: !594)
!634 = !DILocation(line: 40, column: 16, scope: !594)
!635 = !DILocation(line: 40, column: 18, scope: !594)
!636 = !DILocation(line: 40, column: 22, scope: !594)
!637 = !DILocation(line: 42, column: 19, scope: !594)
!638 = !DILocation(line: 42, column: 5, scope: !594)
!639 = !DILocation(line: 43, column: 1, scope: !594)
!640 = distinct !DISubprogram(name: "__moddi3", scope: !60, file: !60, line: 20, type: !117, scopeLine: 21, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !59, retainedNodes: !2)
!641 = !DILocation(line: 22, column: 15, scope: !640)
!642 = !DILocation(line: 23, column: 16, scope: !640)
!643 = !DILocation(line: 23, column: 18, scope: !640)
!644 = !DILocation(line: 23, column: 12, scope: !640)
!645 = !DILocation(line: 24, column: 10, scope: !640)
!646 = !DILocation(line: 24, column: 14, scope: !640)
!647 = !DILocation(line: 24, column: 12, scope: !640)
!648 = !DILocation(line: 24, column: 19, scope: !640)
!649 = !DILocation(line: 24, column: 17, scope: !640)
!650 = !DILocation(line: 24, column: 7, scope: !640)
!651 = !DILocation(line: 25, column: 9, scope: !640)
!652 = !DILocation(line: 25, column: 11, scope: !640)
!653 = !DILocation(line: 25, column: 7, scope: !640)
!654 = !DILocation(line: 26, column: 10, scope: !640)
!655 = !DILocation(line: 26, column: 14, scope: !640)
!656 = !DILocation(line: 26, column: 12, scope: !640)
!657 = !DILocation(line: 26, column: 19, scope: !640)
!658 = !DILocation(line: 26, column: 17, scope: !640)
!659 = !DILocation(line: 26, column: 7, scope: !640)
!660 = !DILocation(line: 28, column: 18, scope: !640)
!661 = !DILocation(line: 28, column: 21, scope: !640)
!662 = !DILocation(line: 28, column: 5, scope: !640)
!663 = !DILocation(line: 29, column: 21, scope: !640)
!664 = !DILocation(line: 29, column: 25, scope: !640)
!665 = !DILocation(line: 29, column: 23, scope: !640)
!666 = !DILocation(line: 29, column: 30, scope: !640)
!667 = !DILocation(line: 29, column: 28, scope: !640)
!668 = !DILocation(line: 29, column: 5, scope: !640)
!669 = distinct !DISubprogram(name: "__modsi3", scope: !62, file: !62, line: 20, type: !117, scopeLine: 21, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !61, retainedNodes: !2)
!670 = !DILocation(line: 22, column: 12, scope: !669)
!671 = !DILocation(line: 22, column: 25, scope: !669)
!672 = !DILocation(line: 22, column: 28, scope: !669)
!673 = !DILocation(line: 22, column: 16, scope: !669)
!674 = !DILocation(line: 22, column: 33, scope: !669)
!675 = !DILocation(line: 22, column: 31, scope: !669)
!676 = !DILocation(line: 22, column: 14, scope: !669)
!677 = !DILocation(line: 22, column: 5, scope: !669)
!678 = distinct !DISubprogram(name: "__mulvdi3", scope: !66, file: !66, line: 22, type: !117, scopeLine: 23, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !65, retainedNodes: !2)
!679 = !DILocation(line: 24, column: 15, scope: !678)
!680 = !DILocation(line: 25, column: 18, scope: !678)
!681 = !DILocation(line: 26, column: 18, scope: !678)
!682 = !DILocation(line: 27, column: 9, scope: !678)
!683 = !DILocation(line: 27, column: 11, scope: !678)
!684 = !DILocation(line: 29, column: 13, scope: !678)
!685 = !DILocation(line: 29, column: 15, scope: !678)
!686 = !DILocation(line: 29, column: 20, scope: !678)
!687 = !DILocation(line: 29, column: 23, scope: !678)
!688 = !DILocation(line: 29, column: 25, scope: !678)
!689 = !DILocation(line: 30, column: 20, scope: !678)
!690 = !DILocation(line: 30, column: 24, scope: !678)
!691 = !DILocation(line: 30, column: 22, scope: !678)
!692 = !DILocation(line: 30, column: 13, scope: !678)
!693 = !DILocation(line: 31, column: 9, scope: !678)
!694 = !DILocation(line: 33, column: 9, scope: !678)
!695 = !DILocation(line: 33, column: 11, scope: !678)
!696 = !DILocation(line: 35, column: 13, scope: !678)
!697 = !DILocation(line: 35, column: 15, scope: !678)
!698 = !DILocation(line: 35, column: 20, scope: !678)
!699 = !DILocation(line: 35, column: 23, scope: !678)
!700 = !DILocation(line: 35, column: 25, scope: !678)
!701 = !DILocation(line: 36, column: 20, scope: !678)
!702 = !DILocation(line: 36, column: 24, scope: !678)
!703 = !DILocation(line: 36, column: 22, scope: !678)
!704 = !DILocation(line: 36, column: 13, scope: !678)
!705 = !DILocation(line: 37, column: 9, scope: !678)
!706 = !DILocation(line: 39, column: 17, scope: !678)
!707 = !DILocation(line: 39, column: 19, scope: !678)
!708 = !DILocation(line: 39, column: 12, scope: !678)
!709 = !DILocation(line: 40, column: 21, scope: !678)
!710 = !DILocation(line: 40, column: 25, scope: !678)
!711 = !DILocation(line: 40, column: 23, scope: !678)
!712 = !DILocation(line: 40, column: 31, scope: !678)
!713 = !DILocation(line: 40, column: 29, scope: !678)
!714 = !DILocation(line: 40, column: 12, scope: !678)
!715 = !DILocation(line: 41, column: 17, scope: !678)
!716 = !DILocation(line: 41, column: 19, scope: !678)
!717 = !DILocation(line: 41, column: 12, scope: !678)
!718 = !DILocation(line: 42, column: 21, scope: !678)
!719 = !DILocation(line: 42, column: 25, scope: !678)
!720 = !DILocation(line: 42, column: 23, scope: !678)
!721 = !DILocation(line: 42, column: 31, scope: !678)
!722 = !DILocation(line: 42, column: 29, scope: !678)
!723 = !DILocation(line: 42, column: 12, scope: !678)
!724 = !DILocation(line: 43, column: 9, scope: !678)
!725 = !DILocation(line: 43, column: 15, scope: !678)
!726 = !DILocation(line: 43, column: 19, scope: !678)
!727 = !DILocation(line: 43, column: 22, scope: !678)
!728 = !DILocation(line: 43, column: 28, scope: !678)
!729 = !DILocation(line: 44, column: 16, scope: !678)
!730 = !DILocation(line: 44, column: 20, scope: !678)
!731 = !DILocation(line: 44, column: 18, scope: !678)
!732 = !DILocation(line: 44, column: 9, scope: !678)
!733 = !DILocation(line: 45, column: 9, scope: !678)
!734 = !DILocation(line: 45, column: 15, scope: !678)
!735 = !DILocation(line: 45, column: 12, scope: !678)
!736 = !DILocation(line: 47, column: 13, scope: !678)
!737 = !DILocation(line: 47, column: 27, scope: !678)
!738 = !DILocation(line: 47, column: 25, scope: !678)
!739 = !DILocation(line: 47, column: 19, scope: !678)
!740 = !DILocation(line: 48, column: 13, scope: !678)
!741 = !DILocation(line: 49, column: 5, scope: !678)
!742 = !DILocation(line: 52, column: 13, scope: !678)
!743 = !DILocation(line: 52, column: 28, scope: !678)
!744 = !DILocation(line: 52, column: 27, scope: !678)
!745 = !DILocation(line: 52, column: 25, scope: !678)
!746 = !DILocation(line: 52, column: 19, scope: !678)
!747 = !DILocation(line: 53, column: 13, scope: !678)
!748 = !DILocation(line: 55, column: 12, scope: !678)
!749 = !DILocation(line: 55, column: 16, scope: !678)
!750 = !DILocation(line: 55, column: 14, scope: !678)
!751 = !DILocation(line: 55, column: 5, scope: !678)
!752 = !DILocation(line: 56, column: 1, scope: !678)
!753 = distinct !DISubprogram(name: "__mulvsi3", scope: !68, file: !68, line: 22, type: !117, scopeLine: 23, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !67, retainedNodes: !2)
!754 = !DILocation(line: 24, column: 15, scope: !753)
!755 = !DILocation(line: 25, column: 18, scope: !753)
!756 = !DILocation(line: 26, column: 18, scope: !753)
!757 = !DILocation(line: 27, column: 9, scope: !753)
!758 = !DILocation(line: 27, column: 11, scope: !753)
!759 = !DILocation(line: 29, column: 13, scope: !753)
!760 = !DILocation(line: 29, column: 15, scope: !753)
!761 = !DILocation(line: 29, column: 20, scope: !753)
!762 = !DILocation(line: 29, column: 23, scope: !753)
!763 = !DILocation(line: 29, column: 25, scope: !753)
!764 = !DILocation(line: 30, column: 20, scope: !753)
!765 = !DILocation(line: 30, column: 24, scope: !753)
!766 = !DILocation(line: 30, column: 22, scope: !753)
!767 = !DILocation(line: 30, column: 13, scope: !753)
!768 = !DILocation(line: 31, column: 9, scope: !753)
!769 = !DILocation(line: 33, column: 9, scope: !753)
!770 = !DILocation(line: 33, column: 11, scope: !753)
!771 = !DILocation(line: 35, column: 13, scope: !753)
!772 = !DILocation(line: 35, column: 15, scope: !753)
!773 = !DILocation(line: 35, column: 20, scope: !753)
!774 = !DILocation(line: 35, column: 23, scope: !753)
!775 = !DILocation(line: 35, column: 25, scope: !753)
!776 = !DILocation(line: 36, column: 20, scope: !753)
!777 = !DILocation(line: 36, column: 24, scope: !753)
!778 = !DILocation(line: 36, column: 22, scope: !753)
!779 = !DILocation(line: 36, column: 13, scope: !753)
!780 = !DILocation(line: 37, column: 9, scope: !753)
!781 = !DILocation(line: 39, column: 17, scope: !753)
!782 = !DILocation(line: 39, column: 19, scope: !753)
!783 = !DILocation(line: 39, column: 12, scope: !753)
!784 = !DILocation(line: 40, column: 21, scope: !753)
!785 = !DILocation(line: 40, column: 25, scope: !753)
!786 = !DILocation(line: 40, column: 23, scope: !753)
!787 = !DILocation(line: 40, column: 31, scope: !753)
!788 = !DILocation(line: 40, column: 29, scope: !753)
!789 = !DILocation(line: 40, column: 12, scope: !753)
!790 = !DILocation(line: 41, column: 17, scope: !753)
!791 = !DILocation(line: 41, column: 19, scope: !753)
!792 = !DILocation(line: 41, column: 12, scope: !753)
!793 = !DILocation(line: 42, column: 21, scope: !753)
!794 = !DILocation(line: 42, column: 25, scope: !753)
!795 = !DILocation(line: 42, column: 23, scope: !753)
!796 = !DILocation(line: 42, column: 31, scope: !753)
!797 = !DILocation(line: 42, column: 29, scope: !753)
!798 = !DILocation(line: 42, column: 12, scope: !753)
!799 = !DILocation(line: 43, column: 9, scope: !753)
!800 = !DILocation(line: 43, column: 15, scope: !753)
!801 = !DILocation(line: 43, column: 19, scope: !753)
!802 = !DILocation(line: 43, column: 22, scope: !753)
!803 = !DILocation(line: 43, column: 28, scope: !753)
!804 = !DILocation(line: 44, column: 16, scope: !753)
!805 = !DILocation(line: 44, column: 20, scope: !753)
!806 = !DILocation(line: 44, column: 18, scope: !753)
!807 = !DILocation(line: 44, column: 9, scope: !753)
!808 = !DILocation(line: 45, column: 9, scope: !753)
!809 = !DILocation(line: 45, column: 15, scope: !753)
!810 = !DILocation(line: 45, column: 12, scope: !753)
!811 = !DILocation(line: 47, column: 13, scope: !753)
!812 = !DILocation(line: 47, column: 27, scope: !753)
!813 = !DILocation(line: 47, column: 25, scope: !753)
!814 = !DILocation(line: 47, column: 19, scope: !753)
!815 = !DILocation(line: 48, column: 13, scope: !753)
!816 = !DILocation(line: 49, column: 5, scope: !753)
!817 = !DILocation(line: 52, column: 13, scope: !753)
!818 = !DILocation(line: 52, column: 28, scope: !753)
!819 = !DILocation(line: 52, column: 27, scope: !753)
!820 = !DILocation(line: 52, column: 25, scope: !753)
!821 = !DILocation(line: 52, column: 19, scope: !753)
!822 = !DILocation(line: 53, column: 13, scope: !753)
!823 = !DILocation(line: 55, column: 12, scope: !753)
!824 = !DILocation(line: 55, column: 16, scope: !753)
!825 = !DILocation(line: 55, column: 14, scope: !753)
!826 = !DILocation(line: 55, column: 5, scope: !753)
!827 = !DILocation(line: 56, column: 1, scope: !753)
!828 = distinct !DISubprogram(name: "__paritydi2", scope: !72, file: !72, line: 20, type: !117, scopeLine: 21, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !71, retainedNodes: !2)
!829 = !DILocation(line: 23, column: 13, scope: !828)
!830 = !DILocation(line: 23, column: 7, scope: !828)
!831 = !DILocation(line: 23, column: 11, scope: !828)
!832 = !DILocation(line: 24, column: 26, scope: !828)
!833 = !DILocation(line: 24, column: 28, scope: !828)
!834 = !DILocation(line: 24, column: 37, scope: !828)
!835 = !DILocation(line: 24, column: 39, scope: !828)
!836 = !DILocation(line: 24, column: 33, scope: !828)
!837 = !DILocation(line: 24, column: 12, scope: !828)
!838 = !DILocation(line: 24, column: 5, scope: !828)
!839 = distinct !DISubprogram(name: "__paritysi2", scope: !74, file: !74, line: 20, type: !117, scopeLine: 21, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !73, retainedNodes: !2)
!840 = !DILocation(line: 22, column: 24, scope: !839)
!841 = !DILocation(line: 22, column: 12, scope: !839)
!842 = !DILocation(line: 23, column: 10, scope: !839)
!843 = !DILocation(line: 23, column: 12, scope: !839)
!844 = !DILocation(line: 23, column: 7, scope: !839)
!845 = !DILocation(line: 24, column: 10, scope: !839)
!846 = !DILocation(line: 24, column: 12, scope: !839)
!847 = !DILocation(line: 24, column: 7, scope: !839)
!848 = !DILocation(line: 25, column: 10, scope: !839)
!849 = !DILocation(line: 25, column: 12, scope: !839)
!850 = !DILocation(line: 25, column: 7, scope: !839)
!851 = !DILocation(line: 26, column: 24, scope: !839)
!852 = !DILocation(line: 26, column: 26, scope: !839)
!853 = !DILocation(line: 26, column: 20, scope: !839)
!854 = !DILocation(line: 26, column: 34, scope: !839)
!855 = !DILocation(line: 26, column: 5, scope: !839)
!856 = distinct !DISubprogram(name: "__popcountdi2", scope: !78, file: !78, line: 20, type: !117, scopeLine: 21, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !77, retainedNodes: !2)
!857 = !DILocation(line: 22, column: 25, scope: !856)
!858 = !DILocation(line: 22, column: 12, scope: !856)
!859 = !DILocation(line: 23, column: 10, scope: !856)
!860 = !DILocation(line: 23, column: 17, scope: !856)
!861 = !DILocation(line: 23, column: 20, scope: !856)
!862 = !DILocation(line: 23, column: 26, scope: !856)
!863 = !DILocation(line: 23, column: 13, scope: !856)
!864 = !DILocation(line: 23, column: 8, scope: !856)
!865 = !DILocation(line: 25, column: 12, scope: !856)
!866 = !DILocation(line: 25, column: 15, scope: !856)
!867 = !DILocation(line: 25, column: 21, scope: !856)
!868 = !DILocation(line: 25, column: 49, scope: !856)
!869 = !DILocation(line: 25, column: 52, scope: !856)
!870 = !DILocation(line: 25, column: 46, scope: !856)
!871 = !DILocation(line: 25, column: 8, scope: !856)
!872 = !DILocation(line: 27, column: 11, scope: !856)
!873 = !DILocation(line: 27, column: 17, scope: !856)
!874 = !DILocation(line: 27, column: 20, scope: !856)
!875 = !DILocation(line: 27, column: 14, scope: !856)
!876 = !DILocation(line: 27, column: 27, scope: !856)
!877 = !DILocation(line: 27, column: 8, scope: !856)
!878 = !DILocation(line: 29, column: 25, scope: !856)
!879 = !DILocation(line: 29, column: 31, scope: !856)
!880 = !DILocation(line: 29, column: 34, scope: !856)
!881 = !DILocation(line: 29, column: 28, scope: !856)
!882 = !DILocation(line: 29, column: 16, scope: !856)
!883 = !DILocation(line: 29, column: 12, scope: !856)
!884 = !DILocation(line: 32, column: 9, scope: !856)
!885 = !DILocation(line: 32, column: 14, scope: !856)
!886 = !DILocation(line: 32, column: 16, scope: !856)
!887 = !DILocation(line: 32, column: 11, scope: !856)
!888 = !DILocation(line: 32, column: 7, scope: !856)
!889 = !DILocation(line: 35, column: 13, scope: !856)
!890 = !DILocation(line: 35, column: 18, scope: !856)
!891 = !DILocation(line: 35, column: 20, scope: !856)
!892 = !DILocation(line: 35, column: 15, scope: !856)
!893 = !DILocation(line: 35, column: 27, scope: !856)
!894 = !DILocation(line: 35, column: 5, scope: !856)
!895 = distinct !DISubprogram(name: "__popcountsi2", scope: !80, file: !80, line: 20, type: !117, scopeLine: 21, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !79, retainedNodes: !2)
!896 = !DILocation(line: 22, column: 24, scope: !895)
!897 = !DILocation(line: 22, column: 12, scope: !895)
!898 = !DILocation(line: 23, column: 9, scope: !895)
!899 = !DILocation(line: 23, column: 15, scope: !895)
!900 = !DILocation(line: 23, column: 17, scope: !895)
!901 = !DILocation(line: 23, column: 23, scope: !895)
!902 = !DILocation(line: 23, column: 11, scope: !895)
!903 = !DILocation(line: 23, column: 7, scope: !895)
!904 = !DILocation(line: 25, column: 11, scope: !895)
!905 = !DILocation(line: 25, column: 13, scope: !895)
!906 = !DILocation(line: 25, column: 19, scope: !895)
!907 = !DILocation(line: 25, column: 36, scope: !895)
!908 = !DILocation(line: 25, column: 38, scope: !895)
!909 = !DILocation(line: 25, column: 33, scope: !895)
!910 = !DILocation(line: 25, column: 7, scope: !895)
!911 = !DILocation(line: 27, column: 10, scope: !895)
!912 = !DILocation(line: 27, column: 15, scope: !895)
!913 = !DILocation(line: 27, column: 17, scope: !895)
!914 = !DILocation(line: 27, column: 12, scope: !895)
!915 = !DILocation(line: 27, column: 24, scope: !895)
!916 = !DILocation(line: 27, column: 7, scope: !895)
!917 = !DILocation(line: 29, column: 10, scope: !895)
!918 = !DILocation(line: 29, column: 15, scope: !895)
!919 = !DILocation(line: 29, column: 17, scope: !895)
!920 = !DILocation(line: 29, column: 12, scope: !895)
!921 = !DILocation(line: 29, column: 7, scope: !895)
!922 = !DILocation(line: 32, column: 13, scope: !895)
!923 = !DILocation(line: 32, column: 18, scope: !895)
!924 = !DILocation(line: 32, column: 20, scope: !895)
!925 = !DILocation(line: 32, column: 15, scope: !895)
!926 = !DILocation(line: 32, column: 27, scope: !895)
!927 = !DILocation(line: 32, column: 5, scope: !895)
!928 = distinct !DISubprogram(name: "__subvdi3", scope: !84, file: !84, line: 22, type: !117, scopeLine: 23, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !83, retainedNodes: !2)
!929 = !DILocation(line: 24, column: 25, scope: !928)
!930 = !DILocation(line: 24, column: 38, scope: !928)
!931 = !DILocation(line: 24, column: 27, scope: !928)
!932 = !DILocation(line: 24, column: 12, scope: !928)
!933 = !DILocation(line: 25, column: 9, scope: !928)
!934 = !DILocation(line: 25, column: 11, scope: !928)
!935 = !DILocation(line: 27, column: 13, scope: !928)
!936 = !DILocation(line: 27, column: 17, scope: !928)
!937 = !DILocation(line: 27, column: 15, scope: !928)
!938 = !DILocation(line: 28, column: 13, scope: !928)
!939 = !DILocation(line: 29, column: 5, scope: !928)
!940 = !DILocation(line: 32, column: 13, scope: !928)
!941 = !DILocation(line: 32, column: 18, scope: !928)
!942 = !DILocation(line: 32, column: 15, scope: !928)
!943 = !DILocation(line: 33, column: 13, scope: !928)
!944 = !DILocation(line: 35, column: 12, scope: !928)
!945 = !DILocation(line: 35, column: 5, scope: !928)
!946 = distinct !DISubprogram(name: "__subvsi3", scope: !86, file: !86, line: 22, type: !117, scopeLine: 23, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !85, retainedNodes: !2)
!947 = !DILocation(line: 24, column: 25, scope: !946)
!948 = !DILocation(line: 24, column: 38, scope: !946)
!949 = !DILocation(line: 24, column: 27, scope: !946)
!950 = !DILocation(line: 24, column: 12, scope: !946)
!951 = !DILocation(line: 25, column: 9, scope: !946)
!952 = !DILocation(line: 25, column: 11, scope: !946)
!953 = !DILocation(line: 27, column: 13, scope: !946)
!954 = !DILocation(line: 27, column: 17, scope: !946)
!955 = !DILocation(line: 27, column: 15, scope: !946)
!956 = !DILocation(line: 28, column: 13, scope: !946)
!957 = !DILocation(line: 29, column: 5, scope: !946)
!958 = !DILocation(line: 32, column: 13, scope: !946)
!959 = !DILocation(line: 32, column: 18, scope: !946)
!960 = !DILocation(line: 32, column: 15, scope: !946)
!961 = !DILocation(line: 33, column: 13, scope: !946)
!962 = !DILocation(line: 35, column: 12, scope: !946)
!963 = !DILocation(line: 35, column: 5, scope: !946)
!964 = distinct !DISubprogram(name: "__ucmpdi2", scope: !90, file: !90, line: 23, type: !117, scopeLine: 24, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !89, retainedNodes: !2)
!965 = !DILocation(line: 26, column: 13, scope: !964)
!966 = !DILocation(line: 26, column: 7, scope: !964)
!967 = !DILocation(line: 26, column: 11, scope: !964)
!968 = !DILocation(line: 28, column: 13, scope: !964)
!969 = !DILocation(line: 28, column: 7, scope: !964)
!970 = !DILocation(line: 28, column: 11, scope: !964)
!971 = !DILocation(line: 29, column: 11, scope: !964)
!972 = !DILocation(line: 29, column: 13, scope: !964)
!973 = !DILocation(line: 29, column: 22, scope: !964)
!974 = !DILocation(line: 29, column: 24, scope: !964)
!975 = !DILocation(line: 29, column: 18, scope: !964)
!976 = !DILocation(line: 29, column: 9, scope: !964)
!977 = !DILocation(line: 30, column: 9, scope: !964)
!978 = !DILocation(line: 31, column: 11, scope: !964)
!979 = !DILocation(line: 31, column: 13, scope: !964)
!980 = !DILocation(line: 31, column: 22, scope: !964)
!981 = !DILocation(line: 31, column: 24, scope: !964)
!982 = !DILocation(line: 31, column: 18, scope: !964)
!983 = !DILocation(line: 31, column: 9, scope: !964)
!984 = !DILocation(line: 32, column: 9, scope: !964)
!985 = !DILocation(line: 33, column: 11, scope: !964)
!986 = !DILocation(line: 33, column: 13, scope: !964)
!987 = !DILocation(line: 33, column: 21, scope: !964)
!988 = !DILocation(line: 33, column: 23, scope: !964)
!989 = !DILocation(line: 33, column: 17, scope: !964)
!990 = !DILocation(line: 33, column: 9, scope: !964)
!991 = !DILocation(line: 34, column: 9, scope: !964)
!992 = !DILocation(line: 35, column: 11, scope: !964)
!993 = !DILocation(line: 35, column: 13, scope: !964)
!994 = !DILocation(line: 35, column: 21, scope: !964)
!995 = !DILocation(line: 35, column: 23, scope: !964)
!996 = !DILocation(line: 35, column: 17, scope: !964)
!997 = !DILocation(line: 35, column: 9, scope: !964)
!998 = !DILocation(line: 36, column: 9, scope: !964)
!999 = !DILocation(line: 37, column: 5, scope: !964)
!1000 = !DILocation(line: 38, column: 1, scope: !964)
!1001 = distinct !DISubprogram(name: "__aeabi_ulcmp", scope: !90, file: !90, line: 46, type: !117, scopeLine: 47, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !89, retainedNodes: !2)
!1002 = !DILocation(line: 48, column: 19, scope: !1001)
!1003 = !DILocation(line: 48, column: 22, scope: !1001)
!1004 = !DILocation(line: 48, column: 9, scope: !1001)
!1005 = !DILocation(line: 48, column: 25, scope: !1001)
!1006 = !DILocation(line: 48, column: 2, scope: !1001)
!1007 = distinct !DISubprogram(name: "__udivdi3", scope: !94, file: !94, line: 20, type: !117, scopeLine: 21, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !93, retainedNodes: !2)
!1008 = !DILocation(line: 22, column: 25, scope: !1007)
!1009 = !DILocation(line: 22, column: 28, scope: !1007)
!1010 = !DILocation(line: 22, column: 12, scope: !1007)
!1011 = !DILocation(line: 22, column: 5, scope: !1007)
!1012 = distinct !DISubprogram(name: "__udivmoddi4", scope: !96, file: !96, line: 24, type: !117, scopeLine: 25, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !95, retainedNodes: !2)
!1013 = !DILocation(line: 26, column: 20, scope: !1012)
!1014 = !DILocation(line: 27, column: 20, scope: !1012)
!1015 = !DILocation(line: 29, column: 13, scope: !1012)
!1016 = !DILocation(line: 29, column: 7, scope: !1012)
!1017 = !DILocation(line: 29, column: 11, scope: !1012)
!1018 = !DILocation(line: 31, column: 13, scope: !1012)
!1019 = !DILocation(line: 31, column: 7, scope: !1012)
!1020 = !DILocation(line: 31, column: 11, scope: !1012)
!1021 = !DILocation(line: 36, column: 11, scope: !1012)
!1022 = !DILocation(line: 36, column: 13, scope: !1012)
!1023 = !DILocation(line: 36, column: 18, scope: !1012)
!1024 = !DILocation(line: 36, column: 9, scope: !1012)
!1025 = !DILocation(line: 38, column: 15, scope: !1012)
!1026 = !DILocation(line: 38, column: 17, scope: !1012)
!1027 = !DILocation(line: 38, column: 22, scope: !1012)
!1028 = !DILocation(line: 38, column: 13, scope: !1012)
!1029 = !DILocation(line: 44, column: 17, scope: !1012)
!1030 = !DILocation(line: 45, column: 26, scope: !1012)
!1031 = !DILocation(line: 45, column: 28, scope: !1012)
!1032 = !DILocation(line: 45, column: 36, scope: !1012)
!1033 = !DILocation(line: 45, column: 38, scope: !1012)
!1034 = !DILocation(line: 45, column: 32, scope: !1012)
!1035 = !DILocation(line: 45, column: 24, scope: !1012)
!1036 = !DILocation(line: 45, column: 18, scope: !1012)
!1037 = !DILocation(line: 45, column: 22, scope: !1012)
!1038 = !DILocation(line: 45, column: 17, scope: !1012)
!1039 = !DILocation(line: 46, column: 22, scope: !1012)
!1040 = !DILocation(line: 46, column: 24, scope: !1012)
!1041 = !DILocation(line: 46, column: 32, scope: !1012)
!1042 = !DILocation(line: 46, column: 34, scope: !1012)
!1043 = !DILocation(line: 46, column: 28, scope: !1012)
!1044 = !DILocation(line: 46, column: 20, scope: !1012)
!1045 = !DILocation(line: 46, column: 13, scope: !1012)
!1046 = !DILocation(line: 52, column: 13, scope: !1012)
!1047 = !DILocation(line: 53, column: 22, scope: !1012)
!1048 = !DILocation(line: 53, column: 24, scope: !1012)
!1049 = !DILocation(line: 53, column: 20, scope: !1012)
!1050 = !DILocation(line: 53, column: 14, scope: !1012)
!1051 = !DILocation(line: 53, column: 18, scope: !1012)
!1052 = !DILocation(line: 53, column: 13, scope: !1012)
!1053 = !DILocation(line: 54, column: 9, scope: !1012)
!1054 = !DILocation(line: 57, column: 11, scope: !1012)
!1055 = !DILocation(line: 57, column: 13, scope: !1012)
!1056 = !DILocation(line: 57, column: 17, scope: !1012)
!1057 = !DILocation(line: 57, column: 9, scope: !1012)
!1058 = !DILocation(line: 59, column: 15, scope: !1012)
!1059 = !DILocation(line: 59, column: 17, scope: !1012)
!1060 = !DILocation(line: 59, column: 22, scope: !1012)
!1061 = !DILocation(line: 59, column: 13, scope: !1012)
!1062 = !DILocation(line: 65, column: 17, scope: !1012)
!1063 = !DILocation(line: 66, column: 26, scope: !1012)
!1064 = !DILocation(line: 66, column: 28, scope: !1012)
!1065 = !DILocation(line: 66, column: 37, scope: !1012)
!1066 = !DILocation(line: 66, column: 39, scope: !1012)
!1067 = !DILocation(line: 66, column: 33, scope: !1012)
!1068 = !DILocation(line: 66, column: 24, scope: !1012)
!1069 = !DILocation(line: 66, column: 18, scope: !1012)
!1070 = !DILocation(line: 66, column: 22, scope: !1012)
!1071 = !DILocation(line: 66, column: 17, scope: !1012)
!1072 = !DILocation(line: 67, column: 22, scope: !1012)
!1073 = !DILocation(line: 67, column: 24, scope: !1012)
!1074 = !DILocation(line: 67, column: 33, scope: !1012)
!1075 = !DILocation(line: 67, column: 35, scope: !1012)
!1076 = !DILocation(line: 67, column: 29, scope: !1012)
!1077 = !DILocation(line: 67, column: 20, scope: !1012)
!1078 = !DILocation(line: 67, column: 13, scope: !1012)
!1079 = !DILocation(line: 70, column: 15, scope: !1012)
!1080 = !DILocation(line: 70, column: 17, scope: !1012)
!1081 = !DILocation(line: 70, column: 21, scope: !1012)
!1082 = !DILocation(line: 70, column: 13, scope: !1012)
!1083 = !DILocation(line: 76, column: 17, scope: !1012)
!1084 = !DILocation(line: 78, column: 30, scope: !1012)
!1085 = !DILocation(line: 78, column: 32, scope: !1012)
!1086 = !DILocation(line: 78, column: 41, scope: !1012)
!1087 = !DILocation(line: 78, column: 43, scope: !1012)
!1088 = !DILocation(line: 78, column: 37, scope: !1012)
!1089 = !DILocation(line: 78, column: 19, scope: !1012)
!1090 = !DILocation(line: 78, column: 21, scope: !1012)
!1091 = !DILocation(line: 78, column: 26, scope: !1012)
!1092 = !DILocation(line: 79, column: 19, scope: !1012)
!1093 = !DILocation(line: 79, column: 21, scope: !1012)
!1094 = !DILocation(line: 79, column: 25, scope: !1012)
!1095 = !DILocation(line: 80, column: 26, scope: !1012)
!1096 = !DILocation(line: 80, column: 18, scope: !1012)
!1097 = !DILocation(line: 80, column: 22, scope: !1012)
!1098 = !DILocation(line: 81, column: 13, scope: !1012)
!1099 = !DILocation(line: 82, column: 22, scope: !1012)
!1100 = !DILocation(line: 82, column: 24, scope: !1012)
!1101 = !DILocation(line: 82, column: 33, scope: !1012)
!1102 = !DILocation(line: 82, column: 35, scope: !1012)
!1103 = !DILocation(line: 82, column: 29, scope: !1012)
!1104 = !DILocation(line: 82, column: 20, scope: !1012)
!1105 = !DILocation(line: 82, column: 13, scope: !1012)
!1106 = !DILocation(line: 88, column: 16, scope: !1012)
!1107 = !DILocation(line: 88, column: 18, scope: !1012)
!1108 = !DILocation(line: 88, column: 28, scope: !1012)
!1109 = !DILocation(line: 88, column: 30, scope: !1012)
!1110 = !DILocation(line: 88, column: 35, scope: !1012)
!1111 = !DILocation(line: 88, column: 23, scope: !1012)
!1112 = !DILocation(line: 88, column: 41, scope: !1012)
!1113 = !DILocation(line: 88, column: 13, scope: !1012)
!1114 = !DILocation(line: 90, column: 17, scope: !1012)
!1115 = !DILocation(line: 92, column: 29, scope: !1012)
!1116 = !DILocation(line: 92, column: 31, scope: !1012)
!1117 = !DILocation(line: 92, column: 19, scope: !1012)
!1118 = !DILocation(line: 92, column: 21, scope: !1012)
!1119 = !DILocation(line: 92, column: 25, scope: !1012)
!1120 = !DILocation(line: 93, column: 30, scope: !1012)
!1121 = !DILocation(line: 93, column: 32, scope: !1012)
!1122 = !DILocation(line: 93, column: 42, scope: !1012)
!1123 = !DILocation(line: 93, column: 44, scope: !1012)
!1124 = !DILocation(line: 93, column: 49, scope: !1012)
!1125 = !DILocation(line: 93, column: 37, scope: !1012)
!1126 = !DILocation(line: 93, column: 19, scope: !1012)
!1127 = !DILocation(line: 93, column: 21, scope: !1012)
!1128 = !DILocation(line: 93, column: 26, scope: !1012)
!1129 = !DILocation(line: 94, column: 26, scope: !1012)
!1130 = !DILocation(line: 94, column: 18, scope: !1012)
!1131 = !DILocation(line: 94, column: 22, scope: !1012)
!1132 = !DILocation(line: 95, column: 13, scope: !1012)
!1133 = !DILocation(line: 96, column: 22, scope: !1012)
!1134 = !DILocation(line: 96, column: 24, scope: !1012)
!1135 = !DILocation(line: 96, column: 48, scope: !1012)
!1136 = !DILocation(line: 96, column: 50, scope: !1012)
!1137 = !DILocation(line: 96, column: 32, scope: !1012)
!1138 = !DILocation(line: 96, column: 29, scope: !1012)
!1139 = !DILocation(line: 96, column: 20, scope: !1012)
!1140 = !DILocation(line: 96, column: 13, scope: !1012)
!1141 = !DILocation(line: 102, column: 30, scope: !1012)
!1142 = !DILocation(line: 102, column: 32, scope: !1012)
!1143 = !DILocation(line: 102, column: 14, scope: !1012)
!1144 = !DILocation(line: 102, column: 56, scope: !1012)
!1145 = !DILocation(line: 102, column: 58, scope: !1012)
!1146 = !DILocation(line: 102, column: 40, scope: !1012)
!1147 = !DILocation(line: 102, column: 38, scope: !1012)
!1148 = !DILocation(line: 102, column: 12, scope: !1012)
!1149 = !DILocation(line: 104, column: 13, scope: !1012)
!1150 = !DILocation(line: 104, column: 16, scope: !1012)
!1151 = !DILocation(line: 106, column: 16, scope: !1012)
!1152 = !DILocation(line: 107, column: 26, scope: !1012)
!1153 = !DILocation(line: 107, column: 18, scope: !1012)
!1154 = !DILocation(line: 107, column: 22, scope: !1012)
!1155 = !DILocation(line: 107, column: 17, scope: !1012)
!1156 = !DILocation(line: 108, column: 13, scope: !1012)
!1157 = !DILocation(line: 110, column: 9, scope: !1012)
!1158 = !DILocation(line: 113, column: 11, scope: !1012)
!1159 = !DILocation(line: 113, column: 13, scope: !1012)
!1160 = !DILocation(line: 113, column: 17, scope: !1012)
!1161 = !DILocation(line: 114, column: 22, scope: !1012)
!1162 = !DILocation(line: 114, column: 24, scope: !1012)
!1163 = !DILocation(line: 114, column: 47, scope: !1012)
!1164 = !DILocation(line: 114, column: 45, scope: !1012)
!1165 = !DILocation(line: 114, column: 28, scope: !1012)
!1166 = !DILocation(line: 114, column: 11, scope: !1012)
!1167 = !DILocation(line: 114, column: 13, scope: !1012)
!1168 = !DILocation(line: 114, column: 18, scope: !1012)
!1169 = !DILocation(line: 116, column: 22, scope: !1012)
!1170 = !DILocation(line: 116, column: 24, scope: !1012)
!1171 = !DILocation(line: 116, column: 32, scope: !1012)
!1172 = !DILocation(line: 116, column: 29, scope: !1012)
!1173 = !DILocation(line: 116, column: 11, scope: !1012)
!1174 = !DILocation(line: 116, column: 13, scope: !1012)
!1175 = !DILocation(line: 116, column: 18, scope: !1012)
!1176 = !DILocation(line: 117, column: 22, scope: !1012)
!1177 = !DILocation(line: 117, column: 24, scope: !1012)
!1178 = !DILocation(line: 117, column: 48, scope: !1012)
!1179 = !DILocation(line: 117, column: 46, scope: !1012)
!1180 = !DILocation(line: 117, column: 29, scope: !1012)
!1181 = !DILocation(line: 117, column: 58, scope: !1012)
!1182 = !DILocation(line: 117, column: 60, scope: !1012)
!1183 = !DILocation(line: 117, column: 67, scope: !1012)
!1184 = !DILocation(line: 117, column: 64, scope: !1012)
!1185 = !DILocation(line: 117, column: 53, scope: !1012)
!1186 = !DILocation(line: 117, column: 11, scope: !1012)
!1187 = !DILocation(line: 117, column: 13, scope: !1012)
!1188 = !DILocation(line: 117, column: 17, scope: !1012)
!1189 = !DILocation(line: 118, column: 5, scope: !1012)
!1190 = !DILocation(line: 121, column: 15, scope: !1012)
!1191 = !DILocation(line: 121, column: 17, scope: !1012)
!1192 = !DILocation(line: 121, column: 22, scope: !1012)
!1193 = !DILocation(line: 121, column: 13, scope: !1012)
!1194 = !DILocation(line: 127, column: 20, scope: !1012)
!1195 = !DILocation(line: 127, column: 22, scope: !1012)
!1196 = !DILocation(line: 127, column: 31, scope: !1012)
!1197 = !DILocation(line: 127, column: 33, scope: !1012)
!1198 = !DILocation(line: 127, column: 37, scope: !1012)
!1199 = !DILocation(line: 127, column: 26, scope: !1012)
!1200 = !DILocation(line: 127, column: 43, scope: !1012)
!1201 = !DILocation(line: 127, column: 17, scope: !1012)
!1202 = !DILocation(line: 129, column: 21, scope: !1012)
!1203 = !DILocation(line: 130, column: 30, scope: !1012)
!1204 = !DILocation(line: 130, column: 32, scope: !1012)
!1205 = !DILocation(line: 130, column: 41, scope: !1012)
!1206 = !DILocation(line: 130, column: 43, scope: !1012)
!1207 = !DILocation(line: 130, column: 47, scope: !1012)
!1208 = !DILocation(line: 130, column: 36, scope: !1012)
!1209 = !DILocation(line: 130, column: 28, scope: !1012)
!1210 = !DILocation(line: 130, column: 22, scope: !1012)
!1211 = !DILocation(line: 130, column: 26, scope: !1012)
!1212 = !DILocation(line: 130, column: 21, scope: !1012)
!1213 = !DILocation(line: 131, column: 23, scope: !1012)
!1214 = !DILocation(line: 131, column: 25, scope: !1012)
!1215 = !DILocation(line: 131, column: 29, scope: !1012)
!1216 = !DILocation(line: 131, column: 21, scope: !1012)
!1217 = !DILocation(line: 132, column: 30, scope: !1012)
!1218 = !DILocation(line: 132, column: 21, scope: !1012)
!1219 = !DILocation(line: 133, column: 38, scope: !1012)
!1220 = !DILocation(line: 133, column: 40, scope: !1012)
!1221 = !DILocation(line: 133, column: 22, scope: !1012)
!1222 = !DILocation(line: 133, column: 20, scope: !1012)
!1223 = !DILocation(line: 134, column: 30, scope: !1012)
!1224 = !DILocation(line: 134, column: 32, scope: !1012)
!1225 = !DILocation(line: 134, column: 40, scope: !1012)
!1226 = !DILocation(line: 134, column: 37, scope: !1012)
!1227 = !DILocation(line: 134, column: 19, scope: !1012)
!1228 = !DILocation(line: 134, column: 21, scope: !1012)
!1229 = !DILocation(line: 134, column: 26, scope: !1012)
!1230 = !DILocation(line: 135, column: 30, scope: !1012)
!1231 = !DILocation(line: 135, column: 32, scope: !1012)
!1232 = !DILocation(line: 135, column: 56, scope: !1012)
!1233 = !DILocation(line: 135, column: 54, scope: !1012)
!1234 = !DILocation(line: 135, column: 37, scope: !1012)
!1235 = !DILocation(line: 135, column: 66, scope: !1012)
!1236 = !DILocation(line: 135, column: 68, scope: !1012)
!1237 = !DILocation(line: 135, column: 75, scope: !1012)
!1238 = !DILocation(line: 135, column: 72, scope: !1012)
!1239 = !DILocation(line: 135, column: 61, scope: !1012)
!1240 = !DILocation(line: 135, column: 19, scope: !1012)
!1241 = !DILocation(line: 135, column: 21, scope: !1012)
!1242 = !DILocation(line: 135, column: 25, scope: !1012)
!1243 = !DILocation(line: 136, column: 26, scope: !1012)
!1244 = !DILocation(line: 136, column: 17, scope: !1012)
!1245 = !DILocation(line: 142, column: 53, scope: !1012)
!1246 = !DILocation(line: 142, column: 55, scope: !1012)
!1247 = !DILocation(line: 142, column: 37, scope: !1012)
!1248 = !DILocation(line: 142, column: 35, scope: !1012)
!1249 = !DILocation(line: 142, column: 78, scope: !1012)
!1250 = !DILocation(line: 142, column: 80, scope: !1012)
!1251 = !DILocation(line: 142, column: 62, scope: !1012)
!1252 = !DILocation(line: 142, column: 60, scope: !1012)
!1253 = !DILocation(line: 142, column: 16, scope: !1012)
!1254 = !DILocation(line: 147, column: 17, scope: !1012)
!1255 = !DILocation(line: 147, column: 20, scope: !1012)
!1256 = !DILocation(line: 149, column: 19, scope: !1012)
!1257 = !DILocation(line: 149, column: 21, scope: !1012)
!1258 = !DILocation(line: 149, column: 25, scope: !1012)
!1259 = !DILocation(line: 150, column: 30, scope: !1012)
!1260 = !DILocation(line: 150, column: 32, scope: !1012)
!1261 = !DILocation(line: 150, column: 19, scope: !1012)
!1262 = !DILocation(line: 150, column: 21, scope: !1012)
!1263 = !DILocation(line: 150, column: 26, scope: !1012)
!1264 = !DILocation(line: 151, column: 19, scope: !1012)
!1265 = !DILocation(line: 151, column: 21, scope: !1012)
!1266 = !DILocation(line: 151, column: 26, scope: !1012)
!1267 = !DILocation(line: 152, column: 29, scope: !1012)
!1268 = !DILocation(line: 152, column: 31, scope: !1012)
!1269 = !DILocation(line: 152, column: 19, scope: !1012)
!1270 = !DILocation(line: 152, column: 21, scope: !1012)
!1271 = !DILocation(line: 152, column: 25, scope: !1012)
!1272 = !DILocation(line: 153, column: 13, scope: !1012)
!1273 = !DILocation(line: 154, column: 22, scope: !1012)
!1274 = !DILocation(line: 154, column: 25, scope: !1012)
!1275 = !DILocation(line: 156, column: 19, scope: !1012)
!1276 = !DILocation(line: 156, column: 21, scope: !1012)
!1277 = !DILocation(line: 156, column: 25, scope: !1012)
!1278 = !DILocation(line: 157, column: 30, scope: !1012)
!1279 = !DILocation(line: 157, column: 32, scope: !1012)
!1280 = !DILocation(line: 157, column: 55, scope: !1012)
!1281 = !DILocation(line: 157, column: 53, scope: !1012)
!1282 = !DILocation(line: 157, column: 36, scope: !1012)
!1283 = !DILocation(line: 157, column: 19, scope: !1012)
!1284 = !DILocation(line: 157, column: 21, scope: !1012)
!1285 = !DILocation(line: 157, column: 26, scope: !1012)
!1286 = !DILocation(line: 158, column: 30, scope: !1012)
!1287 = !DILocation(line: 158, column: 32, scope: !1012)
!1288 = !DILocation(line: 158, column: 40, scope: !1012)
!1289 = !DILocation(line: 158, column: 37, scope: !1012)
!1290 = !DILocation(line: 158, column: 19, scope: !1012)
!1291 = !DILocation(line: 158, column: 21, scope: !1012)
!1292 = !DILocation(line: 158, column: 26, scope: !1012)
!1293 = !DILocation(line: 159, column: 30, scope: !1012)
!1294 = !DILocation(line: 159, column: 32, scope: !1012)
!1295 = !DILocation(line: 159, column: 56, scope: !1012)
!1296 = !DILocation(line: 159, column: 54, scope: !1012)
!1297 = !DILocation(line: 159, column: 37, scope: !1012)
!1298 = !DILocation(line: 159, column: 66, scope: !1012)
!1299 = !DILocation(line: 159, column: 68, scope: !1012)
!1300 = !DILocation(line: 159, column: 75, scope: !1012)
!1301 = !DILocation(line: 159, column: 72, scope: !1012)
!1302 = !DILocation(line: 159, column: 61, scope: !1012)
!1303 = !DILocation(line: 159, column: 19, scope: !1012)
!1304 = !DILocation(line: 159, column: 21, scope: !1012)
!1305 = !DILocation(line: 159, column: 25, scope: !1012)
!1306 = !DILocation(line: 160, column: 13, scope: !1012)
!1307 = !DILocation(line: 163, column: 29, scope: !1012)
!1308 = !DILocation(line: 163, column: 31, scope: !1012)
!1309 = !DILocation(line: 163, column: 55, scope: !1012)
!1310 = !DILocation(line: 163, column: 53, scope: !1012)
!1311 = !DILocation(line: 163, column: 35, scope: !1012)
!1312 = !DILocation(line: 163, column: 19, scope: !1012)
!1313 = !DILocation(line: 163, column: 21, scope: !1012)
!1314 = !DILocation(line: 163, column: 25, scope: !1012)
!1315 = !DILocation(line: 164, column: 31, scope: !1012)
!1316 = !DILocation(line: 164, column: 33, scope: !1012)
!1317 = !DILocation(line: 164, column: 58, scope: !1012)
!1318 = !DILocation(line: 164, column: 56, scope: !1012)
!1319 = !DILocation(line: 164, column: 38, scope: !1012)
!1320 = !DILocation(line: 165, column: 31, scope: !1012)
!1321 = !DILocation(line: 165, column: 33, scope: !1012)
!1322 = !DILocation(line: 165, column: 41, scope: !1012)
!1323 = !DILocation(line: 165, column: 44, scope: !1012)
!1324 = !DILocation(line: 165, column: 37, scope: !1012)
!1325 = !DILocation(line: 164, column: 63, scope: !1012)
!1326 = !DILocation(line: 164, column: 19, scope: !1012)
!1327 = !DILocation(line: 164, column: 21, scope: !1012)
!1328 = !DILocation(line: 164, column: 26, scope: !1012)
!1329 = !DILocation(line: 166, column: 19, scope: !1012)
!1330 = !DILocation(line: 166, column: 21, scope: !1012)
!1331 = !DILocation(line: 166, column: 26, scope: !1012)
!1332 = !DILocation(line: 167, column: 29, scope: !1012)
!1333 = !DILocation(line: 167, column: 31, scope: !1012)
!1334 = !DILocation(line: 167, column: 40, scope: !1012)
!1335 = !DILocation(line: 167, column: 43, scope: !1012)
!1336 = !DILocation(line: 167, column: 36, scope: !1012)
!1337 = !DILocation(line: 167, column: 19, scope: !1012)
!1338 = !DILocation(line: 167, column: 21, scope: !1012)
!1339 = !DILocation(line: 167, column: 25, scope: !1012)
!1340 = !DILocation(line: 169, column: 9, scope: !1012)
!1341 = !DILocation(line: 176, column: 34, scope: !1012)
!1342 = !DILocation(line: 176, column: 36, scope: !1012)
!1343 = !DILocation(line: 176, column: 18, scope: !1012)
!1344 = !DILocation(line: 176, column: 60, scope: !1012)
!1345 = !DILocation(line: 176, column: 62, scope: !1012)
!1346 = !DILocation(line: 176, column: 44, scope: !1012)
!1347 = !DILocation(line: 176, column: 42, scope: !1012)
!1348 = !DILocation(line: 176, column: 16, scope: !1012)
!1349 = !DILocation(line: 178, column: 17, scope: !1012)
!1350 = !DILocation(line: 178, column: 20, scope: !1012)
!1351 = !DILocation(line: 180, column: 21, scope: !1012)
!1352 = !DILocation(line: 181, column: 30, scope: !1012)
!1353 = !DILocation(line: 181, column: 22, scope: !1012)
!1354 = !DILocation(line: 181, column: 26, scope: !1012)
!1355 = !DILocation(line: 181, column: 21, scope: !1012)
!1356 = !DILocation(line: 182, column: 17, scope: !1012)
!1357 = !DILocation(line: 184, column: 13, scope: !1012)
!1358 = !DILocation(line: 187, column: 15, scope: !1012)
!1359 = !DILocation(line: 187, column: 17, scope: !1012)
!1360 = !DILocation(line: 187, column: 21, scope: !1012)
!1361 = !DILocation(line: 188, column: 17, scope: !1012)
!1362 = !DILocation(line: 188, column: 20, scope: !1012)
!1363 = !DILocation(line: 190, column: 30, scope: !1012)
!1364 = !DILocation(line: 190, column: 32, scope: !1012)
!1365 = !DILocation(line: 190, column: 19, scope: !1012)
!1366 = !DILocation(line: 190, column: 21, scope: !1012)
!1367 = !DILocation(line: 190, column: 26, scope: !1012)
!1368 = !DILocation(line: 191, column: 19, scope: !1012)
!1369 = !DILocation(line: 191, column: 21, scope: !1012)
!1370 = !DILocation(line: 191, column: 26, scope: !1012)
!1371 = !DILocation(line: 192, column: 29, scope: !1012)
!1372 = !DILocation(line: 192, column: 31, scope: !1012)
!1373 = !DILocation(line: 192, column: 19, scope: !1012)
!1374 = !DILocation(line: 192, column: 21, scope: !1012)
!1375 = !DILocation(line: 192, column: 25, scope: !1012)
!1376 = !DILocation(line: 193, column: 13, scope: !1012)
!1377 = !DILocation(line: 196, column: 30, scope: !1012)
!1378 = !DILocation(line: 196, column: 32, scope: !1012)
!1379 = !DILocation(line: 196, column: 55, scope: !1012)
!1380 = !DILocation(line: 196, column: 53, scope: !1012)
!1381 = !DILocation(line: 196, column: 36, scope: !1012)
!1382 = !DILocation(line: 196, column: 19, scope: !1012)
!1383 = !DILocation(line: 196, column: 21, scope: !1012)
!1384 = !DILocation(line: 196, column: 26, scope: !1012)
!1385 = !DILocation(line: 197, column: 30, scope: !1012)
!1386 = !DILocation(line: 197, column: 32, scope: !1012)
!1387 = !DILocation(line: 197, column: 40, scope: !1012)
!1388 = !DILocation(line: 197, column: 37, scope: !1012)
!1389 = !DILocation(line: 197, column: 19, scope: !1012)
!1390 = !DILocation(line: 197, column: 21, scope: !1012)
!1391 = !DILocation(line: 197, column: 26, scope: !1012)
!1392 = !DILocation(line: 198, column: 30, scope: !1012)
!1393 = !DILocation(line: 198, column: 32, scope: !1012)
!1394 = !DILocation(line: 198, column: 56, scope: !1012)
!1395 = !DILocation(line: 198, column: 54, scope: !1012)
!1396 = !DILocation(line: 198, column: 37, scope: !1012)
!1397 = !DILocation(line: 198, column: 66, scope: !1012)
!1398 = !DILocation(line: 198, column: 68, scope: !1012)
!1399 = !DILocation(line: 198, column: 75, scope: !1012)
!1400 = !DILocation(line: 198, column: 72, scope: !1012)
!1401 = !DILocation(line: 198, column: 61, scope: !1012)
!1402 = !DILocation(line: 198, column: 19, scope: !1012)
!1403 = !DILocation(line: 198, column: 21, scope: !1012)
!1404 = !DILocation(line: 198, column: 25, scope: !1012)
!1405 = !DILocation(line: 208, column: 12, scope: !1012)
!1406 = !DILocation(line: 209, column: 5, scope: !1012)
!1407 = !DILocation(line: 209, column: 12, scope: !1012)
!1408 = !DILocation(line: 209, column: 15, scope: !1012)
!1409 = !DILocation(line: 212, column: 23, scope: !1012)
!1410 = !DILocation(line: 212, column: 25, scope: !1012)
!1411 = !DILocation(line: 212, column: 30, scope: !1012)
!1412 = !DILocation(line: 212, column: 41, scope: !1012)
!1413 = !DILocation(line: 212, column: 43, scope: !1012)
!1414 = !DILocation(line: 212, column: 48, scope: !1012)
!1415 = !DILocation(line: 212, column: 36, scope: !1012)
!1416 = !DILocation(line: 212, column: 11, scope: !1012)
!1417 = !DILocation(line: 212, column: 13, scope: !1012)
!1418 = !DILocation(line: 212, column: 18, scope: !1012)
!1419 = !DILocation(line: 213, column: 23, scope: !1012)
!1420 = !DILocation(line: 213, column: 25, scope: !1012)
!1421 = !DILocation(line: 213, column: 30, scope: !1012)
!1422 = !DILocation(line: 213, column: 41, scope: !1012)
!1423 = !DILocation(line: 213, column: 43, scope: !1012)
!1424 = !DILocation(line: 213, column: 48, scope: !1012)
!1425 = !DILocation(line: 213, column: 36, scope: !1012)
!1426 = !DILocation(line: 213, column: 11, scope: !1012)
!1427 = !DILocation(line: 213, column: 13, scope: !1012)
!1428 = !DILocation(line: 213, column: 18, scope: !1012)
!1429 = !DILocation(line: 214, column: 23, scope: !1012)
!1430 = !DILocation(line: 214, column: 25, scope: !1012)
!1431 = !DILocation(line: 214, column: 30, scope: !1012)
!1432 = !DILocation(line: 214, column: 41, scope: !1012)
!1433 = !DILocation(line: 214, column: 43, scope: !1012)
!1434 = !DILocation(line: 214, column: 48, scope: !1012)
!1435 = !DILocation(line: 214, column: 36, scope: !1012)
!1436 = !DILocation(line: 214, column: 11, scope: !1012)
!1437 = !DILocation(line: 214, column: 13, scope: !1012)
!1438 = !DILocation(line: 214, column: 18, scope: !1012)
!1439 = !DILocation(line: 215, column: 23, scope: !1012)
!1440 = !DILocation(line: 215, column: 25, scope: !1012)
!1441 = !DILocation(line: 215, column: 30, scope: !1012)
!1442 = !DILocation(line: 215, column: 38, scope: !1012)
!1443 = !DILocation(line: 215, column: 36, scope: !1012)
!1444 = !DILocation(line: 215, column: 11, scope: !1012)
!1445 = !DILocation(line: 215, column: 13, scope: !1012)
!1446 = !DILocation(line: 215, column: 18, scope: !1012)
!1447 = !DILocation(line: 223, column: 37, scope: !1012)
!1448 = !DILocation(line: 223, column: 45, scope: !1012)
!1449 = !DILocation(line: 223, column: 41, scope: !1012)
!1450 = !DILocation(line: 223, column: 49, scope: !1012)
!1451 = !DILocation(line: 223, column: 54, scope: !1012)
!1452 = !DILocation(line: 223, column: 22, scope: !1012)
!1453 = !DILocation(line: 224, column: 17, scope: !1012)
!1454 = !DILocation(line: 224, column: 19, scope: !1012)
!1455 = !DILocation(line: 224, column: 15, scope: !1012)
!1456 = !DILocation(line: 225, column: 20, scope: !1012)
!1457 = !DILocation(line: 225, column: 26, scope: !1012)
!1458 = !DILocation(line: 225, column: 24, scope: !1012)
!1459 = !DILocation(line: 225, column: 11, scope: !1012)
!1460 = !DILocation(line: 225, column: 15, scope: !1012)
!1461 = !DILocation(line: 226, column: 5, scope: !1012)
!1462 = !DILocation(line: 209, column: 20, scope: !1012)
!1463 = distinct !{!1463, !1406, !1461}
!1464 = !DILocation(line: 227, column: 16, scope: !1012)
!1465 = !DILocation(line: 227, column: 20, scope: !1012)
!1466 = !DILocation(line: 227, column: 28, scope: !1012)
!1467 = !DILocation(line: 227, column: 26, scope: !1012)
!1468 = !DILocation(line: 227, column: 7, scope: !1012)
!1469 = !DILocation(line: 227, column: 11, scope: !1012)
!1470 = !DILocation(line: 228, column: 9, scope: !1012)
!1471 = !DILocation(line: 229, column: 18, scope: !1012)
!1472 = !DILocation(line: 229, column: 10, scope: !1012)
!1473 = !DILocation(line: 229, column: 14, scope: !1012)
!1474 = !DILocation(line: 229, column: 9, scope: !1012)
!1475 = !DILocation(line: 230, column: 14, scope: !1012)
!1476 = !DILocation(line: 230, column: 5, scope: !1012)
!1477 = !DILocation(line: 231, column: 1, scope: !1012)
!1478 = distinct !DISubprogram(name: "__udivmodsi4", scope: !98, file: !98, line: 20, type: !117, scopeLine: 21, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !97, retainedNodes: !2)
!1479 = !DILocation(line: 22, column: 24, scope: !1478)
!1480 = !DILocation(line: 22, column: 26, scope: !1478)
!1481 = !DILocation(line: 22, column: 14, scope: !1478)
!1482 = !DILocation(line: 22, column: 10, scope: !1478)
!1483 = !DILocation(line: 23, column: 10, scope: !1478)
!1484 = !DILocation(line: 23, column: 15, scope: !1478)
!1485 = !DILocation(line: 23, column: 17, scope: !1478)
!1486 = !DILocation(line: 23, column: 16, scope: !1478)
!1487 = !DILocation(line: 23, column: 12, scope: !1478)
!1488 = !DILocation(line: 23, column: 4, scope: !1478)
!1489 = !DILocation(line: 23, column: 8, scope: !1478)
!1490 = !DILocation(line: 24, column: 10, scope: !1478)
!1491 = !DILocation(line: 24, column: 3, scope: !1478)
!1492 = distinct !DISubprogram(name: "__udivsi3", scope: !102, file: !102, line: 25, type: !117, scopeLine: 26, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !101, retainedNodes: !2)
!1493 = !DILocation(line: 27, column: 20, scope: !1492)
!1494 = !DILocation(line: 32, column: 9, scope: !1492)
!1495 = !DILocation(line: 32, column: 11, scope: !1492)
!1496 = !DILocation(line: 33, column: 9, scope: !1492)
!1497 = !DILocation(line: 34, column: 9, scope: !1492)
!1498 = !DILocation(line: 34, column: 11, scope: !1492)
!1499 = !DILocation(line: 35, column: 9, scope: !1492)
!1500 = !DILocation(line: 36, column: 24, scope: !1492)
!1501 = !DILocation(line: 36, column: 10, scope: !1492)
!1502 = !DILocation(line: 36, column: 43, scope: !1492)
!1503 = !DILocation(line: 36, column: 29, scope: !1492)
!1504 = !DILocation(line: 36, column: 27, scope: !1492)
!1505 = !DILocation(line: 36, column: 8, scope: !1492)
!1506 = !DILocation(line: 38, column: 9, scope: !1492)
!1507 = !DILocation(line: 38, column: 12, scope: !1492)
!1508 = !DILocation(line: 39, column: 9, scope: !1492)
!1509 = !DILocation(line: 40, column: 9, scope: !1492)
!1510 = !DILocation(line: 40, column: 12, scope: !1492)
!1511 = !DILocation(line: 41, column: 16, scope: !1492)
!1512 = !DILocation(line: 41, column: 9, scope: !1492)
!1513 = !DILocation(line: 42, column: 5, scope: !1492)
!1514 = !DILocation(line: 45, column: 9, scope: !1492)
!1515 = !DILocation(line: 45, column: 30, scope: !1492)
!1516 = !DILocation(line: 45, column: 28, scope: !1492)
!1517 = !DILocation(line: 45, column: 11, scope: !1492)
!1518 = !DILocation(line: 45, column: 7, scope: !1492)
!1519 = !DILocation(line: 46, column: 9, scope: !1492)
!1520 = !DILocation(line: 46, column: 14, scope: !1492)
!1521 = !DILocation(line: 46, column: 11, scope: !1492)
!1522 = !DILocation(line: 46, column: 7, scope: !1492)
!1523 = !DILocation(line: 47, column: 12, scope: !1492)
!1524 = !DILocation(line: 48, column: 5, scope: !1492)
!1525 = !DILocation(line: 48, column: 12, scope: !1492)
!1526 = !DILocation(line: 48, column: 15, scope: !1492)
!1527 = !DILocation(line: 51, column: 14, scope: !1492)
!1528 = !DILocation(line: 51, column: 16, scope: !1492)
!1529 = !DILocation(line: 51, column: 25, scope: !1492)
!1530 = !DILocation(line: 51, column: 27, scope: !1492)
!1531 = !DILocation(line: 51, column: 22, scope: !1492)
!1532 = !DILocation(line: 51, column: 11, scope: !1492)
!1533 = !DILocation(line: 52, column: 14, scope: !1492)
!1534 = !DILocation(line: 52, column: 16, scope: !1492)
!1535 = !DILocation(line: 52, column: 24, scope: !1492)
!1536 = !DILocation(line: 52, column: 22, scope: !1492)
!1537 = !DILocation(line: 52, column: 11, scope: !1492)
!1538 = !DILocation(line: 60, column: 35, scope: !1492)
!1539 = !DILocation(line: 60, column: 39, scope: !1492)
!1540 = !DILocation(line: 60, column: 37, scope: !1492)
!1541 = !DILocation(line: 60, column: 41, scope: !1492)
!1542 = !DILocation(line: 60, column: 46, scope: !1492)
!1543 = !DILocation(line: 60, column: 22, scope: !1492)
!1544 = !DILocation(line: 61, column: 17, scope: !1492)
!1545 = !DILocation(line: 61, column: 19, scope: !1492)
!1546 = !DILocation(line: 61, column: 15, scope: !1492)
!1547 = !DILocation(line: 62, column: 14, scope: !1492)
!1548 = !DILocation(line: 62, column: 18, scope: !1492)
!1549 = !DILocation(line: 62, column: 16, scope: !1492)
!1550 = !DILocation(line: 62, column: 11, scope: !1492)
!1551 = !DILocation(line: 63, column: 5, scope: !1492)
!1552 = !DILocation(line: 48, column: 20, scope: !1492)
!1553 = distinct !{!1553, !1524, !1551}
!1554 = !DILocation(line: 64, column: 10, scope: !1492)
!1555 = !DILocation(line: 64, column: 12, scope: !1492)
!1556 = !DILocation(line: 64, column: 20, scope: !1492)
!1557 = !DILocation(line: 64, column: 18, scope: !1492)
!1558 = !DILocation(line: 64, column: 7, scope: !1492)
!1559 = !DILocation(line: 65, column: 12, scope: !1492)
!1560 = !DILocation(line: 65, column: 5, scope: !1492)
!1561 = !DILocation(line: 66, column: 1, scope: !1492)
!1562 = distinct !DISubprogram(name: "__umoddi3", scope: !106, file: !106, line: 20, type: !117, scopeLine: 21, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !105, retainedNodes: !2)
!1563 = !DILocation(line: 23, column: 18, scope: !1562)
!1564 = !DILocation(line: 23, column: 21, scope: !1562)
!1565 = !DILocation(line: 23, column: 5, scope: !1562)
!1566 = !DILocation(line: 24, column: 12, scope: !1562)
!1567 = !DILocation(line: 24, column: 5, scope: !1562)
!1568 = distinct !DISubprogram(name: "__umodsi3", scope: !108, file: !108, line: 20, type: !117, scopeLine: 21, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !107, retainedNodes: !2)
!1569 = !DILocation(line: 22, column: 12, scope: !1568)
!1570 = !DILocation(line: 22, column: 26, scope: !1568)
!1571 = !DILocation(line: 22, column: 29, scope: !1568)
!1572 = !DILocation(line: 22, column: 16, scope: !1568)
!1573 = !DILocation(line: 22, column: 34, scope: !1568)
!1574 = !DILocation(line: 22, column: 32, scope: !1568)
!1575 = !DILocation(line: 22, column: 14, scope: !1568)
!1576 = !DILocation(line: 22, column: 5, scope: !1568)
