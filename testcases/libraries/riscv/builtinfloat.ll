; ModuleID = 'llvm-link'
source_filename = "llvm-link"
target datalayout = "e-m:e-p:32:32-i64:64-n32-S128"
target triple = "riscv32"

%union.anon.0 = type { double }
%union.anon.0.0 = type { float }
%union.anon = type { i16 }
%union.long_double_bits = type { fp128 }
%struct.uqwords = type { %union.udwords, %union.udwords }
%union.udwords = type { i64 }
%struct.anon = type { i32, i32 }
%union.float_bits = type { i32 }

@__floatdidf.low = private unnamed_addr constant { double } { double 0x4330000000000000 }, align 8
@__floatundidf.high = private unnamed_addr constant { double } { double 0x4530000000000000 }, align 8
@__floatundidf.low = private unnamed_addr constant { double } { double 0x4330000000000000 }, align 8
@.str = private unnamed_addr constant [76 x i8] c"/home/hahns/Schreibtisch/llvmta_testcases/libraries/builtinsfloat/negvdi2.c\00", align 1
@__func__.__negvdi2 = private unnamed_addr constant [10 x i8] c"__negvdi2\00", align 1
@.str.50 = private unnamed_addr constant [76 x i8] c"/home/hahns/Schreibtisch/llvmta_testcases/libraries/builtinsfloat/negvsi2.c\00", align 1
@__func__.__negvsi2 = private unnamed_addr constant [10 x i8] c"__negvsi2\00", align 1

@__cmpdf2 = dso_local alias void (...), bitcast (i32 (double, double)* @__ledf2 to void (...)*)
@__cmpsf2 = dso_local alias void (...), bitcast (i32 (float, float)* @__lesf2 to void (...)*)

; Function Attrs: noinline nounwind
define dso_local double @__adddf3(double %a, double %b) #0 !dbg !177 {
entry:
  %a.addr = alloca double, align 8
  %b.addr = alloca double, align 8
  store double %a, double* %a.addr, align 8
  store double %b, double* %b.addr, align 8
  %0 = load double, double* %a.addr, align 8, !dbg !179
  %1 = load double, double* %b.addr, align 8, !dbg !180
  %call = call double @__addXf3__(double %0, double %1) #4, !dbg !181
  ret double %call, !dbg !182
}

; Function Attrs: noinline nounwind
define internal double @__addXf3__(double %a, double %b) #0 !dbg !183 {
entry:
  %retval = alloca double, align 8
  %a.addr = alloca double, align 8
  %b.addr = alloca double, align 8
  %aRep = alloca i64, align 8
  %bRep = alloca i64, align 8
  %aAbs = alloca i64, align 8
  %bAbs = alloca i64, align 8
  %temp = alloca i64, align 8
  %aExponent = alloca i32, align 4
  %bExponent = alloca i32, align 4
  %aSignificand = alloca i64, align 8
  %bSignificand = alloca i64, align 8
  %resultSign = alloca i64, align 8
  %subtraction = alloca i8, align 1
  %align = alloca i32, align 4
  %sticky = alloca i8, align 1
  %shift = alloca i32, align 4
  %sticky105 = alloca i8, align 1
  %shift125 = alloca i32, align 4
  %sticky127 = alloca i8, align 1
  %roundGuardSticky = alloca i32, align 4
  %result = alloca i64, align 8
  store double %a, double* %a.addr, align 8
  store double %b, double* %b.addr, align 8
  %0 = load double, double* %a.addr, align 8, !dbg !185
  %call = call i64 @toRep(double %0) #4, !dbg !186
  store i64 %call, i64* %aRep, align 8, !dbg !187
  %1 = load double, double* %b.addr, align 8, !dbg !188
  %call1 = call i64 @toRep(double %1) #4, !dbg !189
  store i64 %call1, i64* %bRep, align 8, !dbg !190
  %2 = load i64, i64* %aRep, align 8, !dbg !191
  %and = and i64 %2, 9223372036854775807, !dbg !192
  store i64 %and, i64* %aAbs, align 8, !dbg !193
  %3 = load i64, i64* %bRep, align 8, !dbg !194
  %and2 = and i64 %3, 9223372036854775807, !dbg !195
  store i64 %and2, i64* %bAbs, align 8, !dbg !196
  %4 = load i64, i64* %aAbs, align 8, !dbg !197
  %sub = sub i64 %4, 1, !dbg !198
  %cmp = icmp uge i64 %sub, 9218868437227405311, !dbg !199
  br i1 %cmp, label %if.then, label %lor.lhs.false, !dbg !200

lor.lhs.false:                                    ; preds = %entry
  %5 = load i64, i64* %bAbs, align 8, !dbg !201
  %sub3 = sub i64 %5, 1, !dbg !202
  %cmp4 = icmp uge i64 %sub3, 9218868437227405311, !dbg !203
  br i1 %cmp4, label %if.then, label %if.end38, !dbg !197

if.then:                                          ; preds = %lor.lhs.false, %entry
  %6 = load i64, i64* %aAbs, align 8, !dbg !204
  %cmp5 = icmp ugt i64 %6, 9218868437227405312, !dbg !205
  br i1 %cmp5, label %if.then6, label %if.end, !dbg !204

if.then6:                                         ; preds = %if.then
  %7 = load double, double* %a.addr, align 8, !dbg !206
  %call7 = call i64 @toRep(double %7) #4, !dbg !207
  %or = or i64 %call7, 2251799813685248, !dbg !208
  %call8 = call double @fromRep(i64 %or) #4, !dbg !209
  store double %call8, double* %retval, align 8, !dbg !210
  br label %return, !dbg !210

if.end:                                           ; preds = %if.then
  %8 = load i64, i64* %bAbs, align 8, !dbg !211
  %cmp9 = icmp ugt i64 %8, 9218868437227405312, !dbg !212
  br i1 %cmp9, label %if.then10, label %if.end14, !dbg !211

if.then10:                                        ; preds = %if.end
  %9 = load double, double* %b.addr, align 8, !dbg !213
  %call11 = call i64 @toRep(double %9) #4, !dbg !214
  %or12 = or i64 %call11, 2251799813685248, !dbg !215
  %call13 = call double @fromRep(i64 %or12) #4, !dbg !216
  store double %call13, double* %retval, align 8, !dbg !217
  br label %return, !dbg !217

if.end14:                                         ; preds = %if.end
  %10 = load i64, i64* %aAbs, align 8, !dbg !218
  %cmp15 = icmp eq i64 %10, 9218868437227405312, !dbg !219
  br i1 %cmp15, label %if.then16, label %if.end22, !dbg !218

if.then16:                                        ; preds = %if.end14
  %11 = load double, double* %a.addr, align 8, !dbg !220
  %call17 = call i64 @toRep(double %11) #4, !dbg !221
  %12 = load double, double* %b.addr, align 8, !dbg !222
  %call18 = call i64 @toRep(double %12) #4, !dbg !223
  %xor = xor i64 %call17, %call18, !dbg !224
  %cmp19 = icmp eq i64 %xor, -9223372036854775808, !dbg !225
  br i1 %cmp19, label %if.then20, label %if.else, !dbg !226

if.then20:                                        ; preds = %if.then16
  %call21 = call double @fromRep(i64 9221120237041090560) #4, !dbg !227
  store double %call21, double* %retval, align 8, !dbg !228
  br label %return, !dbg !228

if.else:                                          ; preds = %if.then16
  %13 = load double, double* %a.addr, align 8, !dbg !229
  store double %13, double* %retval, align 8, !dbg !230
  br label %return, !dbg !230

if.end22:                                         ; preds = %if.end14
  %14 = load i64, i64* %bAbs, align 8, !dbg !231
  %cmp23 = icmp eq i64 %14, 9218868437227405312, !dbg !232
  br i1 %cmp23, label %if.then24, label %if.end25, !dbg !231

if.then24:                                        ; preds = %if.end22
  %15 = load double, double* %b.addr, align 8, !dbg !233
  store double %15, double* %retval, align 8, !dbg !234
  br label %return, !dbg !234

if.end25:                                         ; preds = %if.end22
  %16 = load i64, i64* %aAbs, align 8, !dbg !235
  %tobool = icmp ne i64 %16, 0, !dbg !235
  br i1 %tobool, label %if.end34, label %if.then26, !dbg !236

if.then26:                                        ; preds = %if.end25
  %17 = load i64, i64* %bAbs, align 8, !dbg !237
  %tobool27 = icmp ne i64 %17, 0, !dbg !237
  br i1 %tobool27, label %if.else33, label %if.then28, !dbg !238

if.then28:                                        ; preds = %if.then26
  %18 = load double, double* %a.addr, align 8, !dbg !239
  %call29 = call i64 @toRep(double %18) #4, !dbg !240
  %19 = load double, double* %b.addr, align 8, !dbg !241
  %call30 = call i64 @toRep(double %19) #4, !dbg !242
  %and31 = and i64 %call29, %call30, !dbg !243
  %call32 = call double @fromRep(i64 %and31) #4, !dbg !244
  store double %call32, double* %retval, align 8, !dbg !245
  br label %return, !dbg !245

if.else33:                                        ; preds = %if.then26
  %20 = load double, double* %b.addr, align 8, !dbg !246
  store double %20, double* %retval, align 8, !dbg !247
  br label %return, !dbg !247

if.end34:                                         ; preds = %if.end25
  %21 = load i64, i64* %bAbs, align 8, !dbg !248
  %tobool35 = icmp ne i64 %21, 0, !dbg !248
  br i1 %tobool35, label %if.end37, label %if.then36, !dbg !249

if.then36:                                        ; preds = %if.end34
  %22 = load double, double* %a.addr, align 8, !dbg !250
  store double %22, double* %retval, align 8, !dbg !251
  br label %return, !dbg !251

if.end37:                                         ; preds = %if.end34
  br label %if.end38, !dbg !252

if.end38:                                         ; preds = %if.end37, %lor.lhs.false
  %23 = load i64, i64* %bAbs, align 8, !dbg !253
  %24 = load i64, i64* %aAbs, align 8, !dbg !254
  %cmp39 = icmp ugt i64 %23, %24, !dbg !255
  br i1 %cmp39, label %if.then40, label %if.end41, !dbg !253

if.then40:                                        ; preds = %if.end38
  %25 = load i64, i64* %aRep, align 8, !dbg !256
  store i64 %25, i64* %temp, align 8, !dbg !257
  %26 = load i64, i64* %bRep, align 8, !dbg !258
  store i64 %26, i64* %aRep, align 8, !dbg !259
  %27 = load i64, i64* %temp, align 8, !dbg !260
  store i64 %27, i64* %bRep, align 8, !dbg !261
  br label %if.end41, !dbg !262

if.end41:                                         ; preds = %if.then40, %if.end38
  %28 = load i64, i64* %aRep, align 8, !dbg !263
  %shr = lshr i64 %28, 52, !dbg !264
  %and42 = and i64 %shr, 2047, !dbg !265
  %conv = trunc i64 %and42 to i32, !dbg !263
  store i32 %conv, i32* %aExponent, align 4, !dbg !266
  %29 = load i64, i64* %bRep, align 8, !dbg !267
  %shr43 = lshr i64 %29, 52, !dbg !268
  %and44 = and i64 %shr43, 2047, !dbg !269
  %conv45 = trunc i64 %and44 to i32, !dbg !267
  store i32 %conv45, i32* %bExponent, align 4, !dbg !270
  %30 = load i64, i64* %aRep, align 8, !dbg !271
  %and46 = and i64 %30, 4503599627370495, !dbg !272
  store i64 %and46, i64* %aSignificand, align 8, !dbg !273
  %31 = load i64, i64* %bRep, align 8, !dbg !274
  %and47 = and i64 %31, 4503599627370495, !dbg !275
  store i64 %and47, i64* %bSignificand, align 8, !dbg !276
  %32 = load i32, i32* %aExponent, align 4, !dbg !277
  %cmp48 = icmp eq i32 %32, 0, !dbg !278
  br i1 %cmp48, label %if.then50, label %if.end52, !dbg !277

if.then50:                                        ; preds = %if.end41
  %call51 = call i32 @normalize(i64* %aSignificand) #4, !dbg !279
  store i32 %call51, i32* %aExponent, align 4, !dbg !280
  br label %if.end52, !dbg !281

if.end52:                                         ; preds = %if.then50, %if.end41
  %33 = load i32, i32* %bExponent, align 4, !dbg !282
  %cmp53 = icmp eq i32 %33, 0, !dbg !283
  br i1 %cmp53, label %if.then55, label %if.end57, !dbg !282

if.then55:                                        ; preds = %if.end52
  %call56 = call i32 @normalize(i64* %bSignificand) #4, !dbg !284
  store i32 %call56, i32* %bExponent, align 4, !dbg !285
  br label %if.end57, !dbg !286

if.end57:                                         ; preds = %if.then55, %if.end52
  %34 = load i64, i64* %aRep, align 8, !dbg !287
  %and58 = and i64 %34, -9223372036854775808, !dbg !288
  store i64 %and58, i64* %resultSign, align 8, !dbg !289
  %35 = load i64, i64* %aRep, align 8, !dbg !290
  %36 = load i64, i64* %bRep, align 8, !dbg !291
  %xor59 = xor i64 %35, %36, !dbg !292
  %and60 = and i64 %xor59, -9223372036854775808, !dbg !293
  %tobool61 = icmp ne i64 %and60, 0, !dbg !294
  %frombool = zext i1 %tobool61 to i8, !dbg !295
  store i8 %frombool, i8* %subtraction, align 1, !dbg !295
  %37 = load i64, i64* %aSignificand, align 8, !dbg !296
  %or62 = or i64 %37, 4503599627370496, !dbg !297
  %shl = shl i64 %or62, 3, !dbg !298
  store i64 %shl, i64* %aSignificand, align 8, !dbg !299
  %38 = load i64, i64* %bSignificand, align 8, !dbg !300
  %or63 = or i64 %38, 4503599627370496, !dbg !301
  %shl64 = shl i64 %or63, 3, !dbg !302
  store i64 %shl64, i64* %bSignificand, align 8, !dbg !303
  %39 = load i32, i32* %aExponent, align 4, !dbg !304
  %40 = load i32, i32* %bExponent, align 4, !dbg !305
  %sub65 = sub nsw i32 %39, %40, !dbg !306
  store i32 %sub65, i32* %align, align 4, !dbg !307
  %41 = load i32, i32* %align, align 4, !dbg !308
  %tobool66 = icmp ne i32 %41, 0, !dbg !308
  br i1 %tobool66, label %if.then67, label %if.end82, !dbg !308

if.then67:                                        ; preds = %if.end57
  %42 = load i32, i32* %align, align 4, !dbg !309
  %cmp68 = icmp ult i32 %42, 64, !dbg !310
  br i1 %cmp68, label %if.then70, label %if.else80, !dbg !309

if.then70:                                        ; preds = %if.then67
  %43 = load i64, i64* %bSignificand, align 8, !dbg !311
  %44 = load i32, i32* %align, align 4, !dbg !312
  %sub71 = sub i32 64, %44, !dbg !313
  %sh_prom = zext i32 %sub71 to i64, !dbg !314
  %shl72 = shl i64 %43, %sh_prom, !dbg !314
  %tobool73 = icmp ne i64 %shl72, 0, !dbg !311
  %frombool74 = zext i1 %tobool73 to i8, !dbg !315
  store i8 %frombool74, i8* %sticky, align 1, !dbg !315
  %45 = load i64, i64* %bSignificand, align 8, !dbg !316
  %46 = load i32, i32* %align, align 4, !dbg !317
  %sh_prom75 = zext i32 %46 to i64, !dbg !318
  %shr76 = lshr i64 %45, %sh_prom75, !dbg !318
  %47 = load i8, i8* %sticky, align 1, !dbg !319
  %tobool77 = trunc i8 %47 to i1, !dbg !319
  %conv78 = zext i1 %tobool77 to i64, !dbg !319
  %or79 = or i64 %shr76, %conv78, !dbg !320
  store i64 %or79, i64* %bSignificand, align 8, !dbg !321
  br label %if.end81, !dbg !322

if.else80:                                        ; preds = %if.then67
  store i64 1, i64* %bSignificand, align 8, !dbg !323
  br label %if.end81

if.end81:                                         ; preds = %if.else80, %if.then70
  br label %if.end82, !dbg !324

if.end82:                                         ; preds = %if.end81, %if.end57
  %48 = load i8, i8* %subtraction, align 1, !dbg !325
  %tobool83 = trunc i8 %48 to i1, !dbg !325
  br i1 %tobool83, label %if.then84, label %if.else101, !dbg !325

if.then84:                                        ; preds = %if.end82
  %49 = load i64, i64* %bSignificand, align 8, !dbg !326
  %50 = load i64, i64* %aSignificand, align 8, !dbg !327
  %sub85 = sub i64 %50, %49, !dbg !327
  store i64 %sub85, i64* %aSignificand, align 8, !dbg !327
  %51 = load i64, i64* %aSignificand, align 8, !dbg !328
  %cmp86 = icmp eq i64 %51, 0, !dbg !329
  br i1 %cmp86, label %if.then88, label %if.end90, !dbg !328

if.then88:                                        ; preds = %if.then84
  %call89 = call double @fromRep(i64 0) #4, !dbg !330
  store double %call89, double* %retval, align 8, !dbg !331
  br label %return, !dbg !331

if.end90:                                         ; preds = %if.then84
  %52 = load i64, i64* %aSignificand, align 8, !dbg !332
  %cmp91 = icmp ult i64 %52, 36028797018963968, !dbg !333
  br i1 %cmp91, label %if.then93, label %if.end100, !dbg !332

if.then93:                                        ; preds = %if.end90
  %53 = load i64, i64* %aSignificand, align 8, !dbg !334
  %call94 = call i32 @rep_clz(i64 %53) #4, !dbg !335
  %call95 = call i32 @rep_clz(i64 36028797018963968) #4, !dbg !336
  %sub96 = sub nsw i32 %call94, %call95, !dbg !337
  store i32 %sub96, i32* %shift, align 4, !dbg !338
  %54 = load i32, i32* %shift, align 4, !dbg !339
  %55 = load i64, i64* %aSignificand, align 8, !dbg !340
  %sh_prom97 = zext i32 %54 to i64, !dbg !340
  %shl98 = shl i64 %55, %sh_prom97, !dbg !340
  store i64 %shl98, i64* %aSignificand, align 8, !dbg !340
  %56 = load i32, i32* %shift, align 4, !dbg !341
  %57 = load i32, i32* %aExponent, align 4, !dbg !342
  %sub99 = sub nsw i32 %57, %56, !dbg !342
  store i32 %sub99, i32* %aExponent, align 4, !dbg !342
  br label %if.end100, !dbg !343

if.end100:                                        ; preds = %if.then93, %if.end90
  br label %if.end115, !dbg !344

if.else101:                                       ; preds = %if.end82
  %58 = load i64, i64* %bSignificand, align 8, !dbg !345
  %59 = load i64, i64* %aSignificand, align 8, !dbg !346
  %add = add i64 %59, %58, !dbg !346
  store i64 %add, i64* %aSignificand, align 8, !dbg !346
  %60 = load i64, i64* %aSignificand, align 8, !dbg !347
  %and102 = and i64 %60, 72057594037927936, !dbg !348
  %tobool103 = icmp ne i64 %and102, 0, !dbg !348
  br i1 %tobool103, label %if.then104, label %if.end114, !dbg !347

if.then104:                                       ; preds = %if.else101
  %61 = load i64, i64* %aSignificand, align 8, !dbg !349
  %and106 = and i64 %61, 1, !dbg !350
  %tobool107 = icmp ne i64 %and106, 0, !dbg !349
  %frombool108 = zext i1 %tobool107 to i8, !dbg !351
  store i8 %frombool108, i8* %sticky105, align 1, !dbg !351
  %62 = load i64, i64* %aSignificand, align 8, !dbg !352
  %shr109 = lshr i64 %62, 1, !dbg !353
  %63 = load i8, i8* %sticky105, align 1, !dbg !354
  %tobool110 = trunc i8 %63 to i1, !dbg !354
  %conv111 = zext i1 %tobool110 to i64, !dbg !354
  %or112 = or i64 %shr109, %conv111, !dbg !355
  store i64 %or112, i64* %aSignificand, align 8, !dbg !356
  %64 = load i32, i32* %aExponent, align 4, !dbg !357
  %add113 = add nsw i32 %64, 1, !dbg !357
  store i32 %add113, i32* %aExponent, align 4, !dbg !357
  br label %if.end114, !dbg !358

if.end114:                                        ; preds = %if.then104, %if.else101
  br label %if.end115

if.end115:                                        ; preds = %if.end114, %if.end100
  %65 = load i32, i32* %aExponent, align 4, !dbg !359
  %cmp116 = icmp sge i32 %65, 2047, !dbg !360
  br i1 %cmp116, label %if.then118, label %if.end121, !dbg !359

if.then118:                                       ; preds = %if.end115
  %66 = load i64, i64* %resultSign, align 8, !dbg !361
  %or119 = or i64 9218868437227405312, %66, !dbg !362
  %call120 = call double @fromRep(i64 %or119) #4, !dbg !363
  store double %call120, double* %retval, align 8, !dbg !364
  br label %return, !dbg !364

if.end121:                                        ; preds = %if.end115
  %67 = load i32, i32* %aExponent, align 4, !dbg !365
  %cmp122 = icmp sle i32 %67, 0, !dbg !366
  br i1 %cmp122, label %if.then124, label %if.end138, !dbg !365

if.then124:                                       ; preds = %if.end121
  %68 = load i32, i32* %aExponent, align 4, !dbg !367
  %sub126 = sub nsw i32 1, %68, !dbg !368
  store i32 %sub126, i32* %shift125, align 4, !dbg !369
  %69 = load i64, i64* %aSignificand, align 8, !dbg !370
  %70 = load i32, i32* %shift125, align 4, !dbg !371
  %sub128 = sub i32 64, %70, !dbg !372
  %sh_prom129 = zext i32 %sub128 to i64, !dbg !373
  %shl130 = shl i64 %69, %sh_prom129, !dbg !373
  %tobool131 = icmp ne i64 %shl130, 0, !dbg !370
  %frombool132 = zext i1 %tobool131 to i8, !dbg !374
  store i8 %frombool132, i8* %sticky127, align 1, !dbg !374
  %71 = load i64, i64* %aSignificand, align 8, !dbg !375
  %72 = load i32, i32* %shift125, align 4, !dbg !376
  %sh_prom133 = zext i32 %72 to i64, !dbg !377
  %shr134 = lshr i64 %71, %sh_prom133, !dbg !377
  %73 = load i8, i8* %sticky127, align 1, !dbg !378
  %tobool135 = trunc i8 %73 to i1, !dbg !378
  %conv136 = zext i1 %tobool135 to i64, !dbg !378
  %or137 = or i64 %shr134, %conv136, !dbg !379
  store i64 %or137, i64* %aSignificand, align 8, !dbg !380
  store i32 0, i32* %aExponent, align 4, !dbg !381
  br label %if.end138, !dbg !382

if.end138:                                        ; preds = %if.then124, %if.end121
  %74 = load i64, i64* %aSignificand, align 8, !dbg !383
  %and139 = and i64 %74, 7, !dbg !384
  %conv140 = trunc i64 %and139 to i32, !dbg !383
  store i32 %conv140, i32* %roundGuardSticky, align 4, !dbg !385
  %75 = load i64, i64* %aSignificand, align 8, !dbg !386
  %shr141 = lshr i64 %75, 3, !dbg !387
  %and142 = and i64 %shr141, 4503599627370495, !dbg !388
  store i64 %and142, i64* %result, align 8, !dbg !389
  %76 = load i32, i32* %aExponent, align 4, !dbg !390
  %conv143 = sext i32 %76 to i64, !dbg !391
  %shl144 = shl i64 %conv143, 52, !dbg !392
  %77 = load i64, i64* %result, align 8, !dbg !393
  %or145 = or i64 %77, %shl144, !dbg !393
  store i64 %or145, i64* %result, align 8, !dbg !393
  %78 = load i64, i64* %resultSign, align 8, !dbg !394
  %79 = load i64, i64* %result, align 8, !dbg !395
  %or146 = or i64 %79, %78, !dbg !395
  store i64 %or146, i64* %result, align 8, !dbg !395
  %80 = load i32, i32* %roundGuardSticky, align 4, !dbg !396
  %cmp147 = icmp sgt i32 %80, 4, !dbg !397
  br i1 %cmp147, label %if.then149, label %if.end150, !dbg !396

if.then149:                                       ; preds = %if.end138
  %81 = load i64, i64* %result, align 8, !dbg !398
  %inc = add i64 %81, 1, !dbg !398
  store i64 %inc, i64* %result, align 8, !dbg !398
  br label %if.end150, !dbg !399

if.end150:                                        ; preds = %if.then149, %if.end138
  %82 = load i32, i32* %roundGuardSticky, align 4, !dbg !400
  %cmp151 = icmp eq i32 %82, 4, !dbg !401
  br i1 %cmp151, label %if.then153, label %if.end156, !dbg !400

if.then153:                                       ; preds = %if.end150
  %83 = load i64, i64* %result, align 8, !dbg !402
  %and154 = and i64 %83, 1, !dbg !403
  %84 = load i64, i64* %result, align 8, !dbg !404
  %add155 = add i64 %84, %and154, !dbg !404
  store i64 %add155, i64* %result, align 8, !dbg !404
  br label %if.end156, !dbg !405

if.end156:                                        ; preds = %if.then153, %if.end150
  %85 = load i64, i64* %result, align 8, !dbg !406
  %call157 = call double @fromRep(i64 %85) #4, !dbg !407
  store double %call157, double* %retval, align 8, !dbg !408
  br label %return, !dbg !408

return:                                           ; preds = %if.end156, %if.then118, %if.then88, %if.then36, %if.else33, %if.then28, %if.then24, %if.else, %if.then20, %if.then10, %if.then6
  %86 = load double, double* %retval, align 8, !dbg !409
  ret double %86, !dbg !409
}

; Function Attrs: noinline nounwind
define internal i64 @toRep(double %x) #0 !dbg !410 {
entry:
  %x.addr = alloca double, align 8
  %rep = alloca %union.anon.0, align 8
  store double %x, double* %x.addr, align 8
  %f = bitcast %union.anon.0* %rep to double*, !dbg !412
  %0 = load double, double* %x.addr, align 8, !dbg !413
  store double %0, double* %f, align 8, !dbg !412
  %i = bitcast %union.anon.0* %rep to i64*, !dbg !414
  %1 = load i64, i64* %i, align 8, !dbg !414
  ret i64 %1, !dbg !415
}

; Function Attrs: noinline nounwind
define internal double @fromRep(i64 %x) #0 !dbg !416 {
entry:
  %x.addr = alloca i64, align 8
  %rep = alloca %union.anon.0, align 8
  store i64 %x, i64* %x.addr, align 8
  %i = bitcast %union.anon.0* %rep to i64*, !dbg !417
  %0 = load i64, i64* %x.addr, align 8, !dbg !418
  store i64 %0, i64* %i, align 8, !dbg !417
  %f = bitcast %union.anon.0* %rep to double*, !dbg !419
  %1 = load double, double* %f, align 8, !dbg !419
  ret double %1, !dbg !420
}

; Function Attrs: noinline nounwind
define internal i32 @normalize(i64* %significand) #0 !dbg !421 {
entry:
  %significand.addr = alloca i64*, align 4
  %shift = alloca i32, align 4
  store i64* %significand, i64** %significand.addr, align 4
  %0 = load i64*, i64** %significand.addr, align 4, !dbg !422
  %1 = load i64, i64* %0, align 8, !dbg !423
  %call = call i32 @rep_clz(i64 %1) #4, !dbg !424
  %call1 = call i32 @rep_clz(i64 4503599627370496) #4, !dbg !425
  %sub = sub nsw i32 %call, %call1, !dbg !426
  store i32 %sub, i32* %shift, align 4, !dbg !427
  %2 = load i32, i32* %shift, align 4, !dbg !428
  %3 = load i64*, i64** %significand.addr, align 4, !dbg !429
  %4 = load i64, i64* %3, align 8, !dbg !430
  %sh_prom = zext i32 %2 to i64, !dbg !430
  %shl = shl i64 %4, %sh_prom, !dbg !430
  store i64 %shl, i64* %3, align 8, !dbg !430
  %5 = load i32, i32* %shift, align 4, !dbg !431
  %sub2 = sub nsw i32 1, %5, !dbg !432
  ret i32 %sub2, !dbg !433
}

; Function Attrs: noinline nounwind
define internal i32 @rep_clz(i64 %a) #0 !dbg !434 {
entry:
  %retval = alloca i32, align 4
  %a.addr = alloca i64, align 8
  store i64 %a, i64* %a.addr, align 8
  %0 = load i64, i64* %a.addr, align 8, !dbg !435
  %and = and i64 %0, -4294967296, !dbg !436
  %tobool = icmp ne i64 %and, 0, !dbg !436
  br i1 %tobool, label %if.then, label %if.else, !dbg !435

if.then:                                          ; preds = %entry
  %1 = load i64, i64* %a.addr, align 8, !dbg !437
  %shr = lshr i64 %1, 32, !dbg !438
  %conv = trunc i64 %shr to i32, !dbg !437
  %2 = call i32 @llvm.ctlz.i32(i32 %conv, i1 true), !dbg !439
  store i32 %2, i32* %retval, align 4, !dbg !440
  br label %return, !dbg !440

if.else:                                          ; preds = %entry
  %3 = load i64, i64* %a.addr, align 8, !dbg !441
  %and1 = and i64 %3, 4294967295, !dbg !442
  %conv2 = trunc i64 %and1 to i32, !dbg !441
  %4 = call i32 @llvm.ctlz.i32(i32 %conv2, i1 true), !dbg !443
  %add = add nsw i32 32, %4, !dbg !444
  store i32 %add, i32* %retval, align 4, !dbg !445
  br label %return, !dbg !445

return:                                           ; preds = %if.else, %if.then
  %5 = load i32, i32* %retval, align 4, !dbg !446
  ret i32 %5, !dbg !446
}

; Function Attrs: nounwind readnone speculatable
declare i32 @llvm.ctlz.i32(i32, i1) #1

; Function Attrs: noinline nounwind
define dso_local float @__addsf3(float %a, float %b) #0 !dbg !447 {
entry:
  %a.addr = alloca float, align 4
  %b.addr = alloca float, align 4
  store float %a, float* %a.addr, align 4
  store float %b, float* %b.addr, align 4
  %0 = load float, float* %a.addr, align 4, !dbg !448
  %1 = load float, float* %b.addr, align 4, !dbg !449
  %call = call float @__addXf3__.1(float %0, float %1) #4, !dbg !450
  ret float %call, !dbg !451
}

; Function Attrs: noinline nounwind
define internal float @__addXf3__.1(float %a, float %b) #0 !dbg !452 {
entry:
  %retval = alloca float, align 4
  %a.addr = alloca float, align 4
  %b.addr = alloca float, align 4
  %aRep = alloca i32, align 4
  %bRep = alloca i32, align 4
  %aAbs = alloca i32, align 4
  %bAbs = alloca i32, align 4
  %temp = alloca i32, align 4
  %aExponent = alloca i32, align 4
  %bExponent = alloca i32, align 4
  %aSignificand = alloca i32, align 4
  %bSignificand = alloca i32, align 4
  %resultSign = alloca i32, align 4
  %subtraction = alloca i8, align 1
  %align = alloca i32, align 4
  %sticky = alloca i8, align 1
  %shift = alloca i32, align 4
  %sticky98 = alloca i8, align 1
  %shift118 = alloca i32, align 4
  %sticky120 = alloca i8, align 1
  %roundGuardSticky = alloca i32, align 4
  %result = alloca i32, align 4
  store float %a, float* %a.addr, align 4
  store float %b, float* %b.addr, align 4
  %0 = load float, float* %a.addr, align 4, !dbg !453
  %call = call i32 @toRep.2(float %0) #4, !dbg !454
  store i32 %call, i32* %aRep, align 4, !dbg !455
  %1 = load float, float* %b.addr, align 4, !dbg !456
  %call1 = call i32 @toRep.2(float %1) #4, !dbg !457
  store i32 %call1, i32* %bRep, align 4, !dbg !458
  %2 = load i32, i32* %aRep, align 4, !dbg !459
  %and = and i32 %2, 2147483647, !dbg !460
  store i32 %and, i32* %aAbs, align 4, !dbg !461
  %3 = load i32, i32* %bRep, align 4, !dbg !462
  %and2 = and i32 %3, 2147483647, !dbg !463
  store i32 %and2, i32* %bAbs, align 4, !dbg !464
  %4 = load i32, i32* %aAbs, align 4, !dbg !465
  %sub = sub i32 %4, 1, !dbg !466
  %cmp = icmp uge i32 %sub, 2139095039, !dbg !467
  br i1 %cmp, label %if.then, label %lor.lhs.false, !dbg !468

lor.lhs.false:                                    ; preds = %entry
  %5 = load i32, i32* %bAbs, align 4, !dbg !469
  %sub3 = sub i32 %5, 1, !dbg !470
  %cmp4 = icmp uge i32 %sub3, 2139095039, !dbg !471
  br i1 %cmp4, label %if.then, label %if.end38, !dbg !465

if.then:                                          ; preds = %lor.lhs.false, %entry
  %6 = load i32, i32* %aAbs, align 4, !dbg !472
  %cmp5 = icmp ugt i32 %6, 2139095040, !dbg !473
  br i1 %cmp5, label %if.then6, label %if.end, !dbg !472

if.then6:                                         ; preds = %if.then
  %7 = load float, float* %a.addr, align 4, !dbg !474
  %call7 = call i32 @toRep.2(float %7) #4, !dbg !475
  %or = or i32 %call7, 4194304, !dbg !476
  %call8 = call float @fromRep.3(i32 %or) #4, !dbg !477
  store float %call8, float* %retval, align 4, !dbg !478
  br label %return, !dbg !478

if.end:                                           ; preds = %if.then
  %8 = load i32, i32* %bAbs, align 4, !dbg !479
  %cmp9 = icmp ugt i32 %8, 2139095040, !dbg !480
  br i1 %cmp9, label %if.then10, label %if.end14, !dbg !479

if.then10:                                        ; preds = %if.end
  %9 = load float, float* %b.addr, align 4, !dbg !481
  %call11 = call i32 @toRep.2(float %9) #4, !dbg !482
  %or12 = or i32 %call11, 4194304, !dbg !483
  %call13 = call float @fromRep.3(i32 %or12) #4, !dbg !484
  store float %call13, float* %retval, align 4, !dbg !485
  br label %return, !dbg !485

if.end14:                                         ; preds = %if.end
  %10 = load i32, i32* %aAbs, align 4, !dbg !486
  %cmp15 = icmp eq i32 %10, 2139095040, !dbg !487
  br i1 %cmp15, label %if.then16, label %if.end22, !dbg !486

if.then16:                                        ; preds = %if.end14
  %11 = load float, float* %a.addr, align 4, !dbg !488
  %call17 = call i32 @toRep.2(float %11) #4, !dbg !489
  %12 = load float, float* %b.addr, align 4, !dbg !490
  %call18 = call i32 @toRep.2(float %12) #4, !dbg !491
  %xor = xor i32 %call17, %call18, !dbg !492
  %cmp19 = icmp eq i32 %xor, -2147483648, !dbg !493
  br i1 %cmp19, label %if.then20, label %if.else, !dbg !494

if.then20:                                        ; preds = %if.then16
  %call21 = call float @fromRep.3(i32 2143289344) #4, !dbg !495
  store float %call21, float* %retval, align 4, !dbg !496
  br label %return, !dbg !496

if.else:                                          ; preds = %if.then16
  %13 = load float, float* %a.addr, align 4, !dbg !497
  store float %13, float* %retval, align 4, !dbg !498
  br label %return, !dbg !498

if.end22:                                         ; preds = %if.end14
  %14 = load i32, i32* %bAbs, align 4, !dbg !499
  %cmp23 = icmp eq i32 %14, 2139095040, !dbg !500
  br i1 %cmp23, label %if.then24, label %if.end25, !dbg !499

if.then24:                                        ; preds = %if.end22
  %15 = load float, float* %b.addr, align 4, !dbg !501
  store float %15, float* %retval, align 4, !dbg !502
  br label %return, !dbg !502

if.end25:                                         ; preds = %if.end22
  %16 = load i32, i32* %aAbs, align 4, !dbg !503
  %tobool = icmp ne i32 %16, 0, !dbg !503
  br i1 %tobool, label %if.end34, label %if.then26, !dbg !504

if.then26:                                        ; preds = %if.end25
  %17 = load i32, i32* %bAbs, align 4, !dbg !505
  %tobool27 = icmp ne i32 %17, 0, !dbg !505
  br i1 %tobool27, label %if.else33, label %if.then28, !dbg !506

if.then28:                                        ; preds = %if.then26
  %18 = load float, float* %a.addr, align 4, !dbg !507
  %call29 = call i32 @toRep.2(float %18) #4, !dbg !508
  %19 = load float, float* %b.addr, align 4, !dbg !509
  %call30 = call i32 @toRep.2(float %19) #4, !dbg !510
  %and31 = and i32 %call29, %call30, !dbg !511
  %call32 = call float @fromRep.3(i32 %and31) #4, !dbg !512
  store float %call32, float* %retval, align 4, !dbg !513
  br label %return, !dbg !513

if.else33:                                        ; preds = %if.then26
  %20 = load float, float* %b.addr, align 4, !dbg !514
  store float %20, float* %retval, align 4, !dbg !515
  br label %return, !dbg !515

if.end34:                                         ; preds = %if.end25
  %21 = load i32, i32* %bAbs, align 4, !dbg !516
  %tobool35 = icmp ne i32 %21, 0, !dbg !516
  br i1 %tobool35, label %if.end37, label %if.then36, !dbg !517

if.then36:                                        ; preds = %if.end34
  %22 = load float, float* %a.addr, align 4, !dbg !518
  store float %22, float* %retval, align 4, !dbg !519
  br label %return, !dbg !519

if.end37:                                         ; preds = %if.end34
  br label %if.end38, !dbg !520

if.end38:                                         ; preds = %if.end37, %lor.lhs.false
  %23 = load i32, i32* %bAbs, align 4, !dbg !521
  %24 = load i32, i32* %aAbs, align 4, !dbg !522
  %cmp39 = icmp ugt i32 %23, %24, !dbg !523
  br i1 %cmp39, label %if.then40, label %if.end41, !dbg !521

if.then40:                                        ; preds = %if.end38
  %25 = load i32, i32* %aRep, align 4, !dbg !524
  store i32 %25, i32* %temp, align 4, !dbg !525
  %26 = load i32, i32* %bRep, align 4, !dbg !526
  store i32 %26, i32* %aRep, align 4, !dbg !527
  %27 = load i32, i32* %temp, align 4, !dbg !528
  store i32 %27, i32* %bRep, align 4, !dbg !529
  br label %if.end41, !dbg !530

if.end41:                                         ; preds = %if.then40, %if.end38
  %28 = load i32, i32* %aRep, align 4, !dbg !531
  %shr = lshr i32 %28, 23, !dbg !532
  %and42 = and i32 %shr, 255, !dbg !533
  store i32 %and42, i32* %aExponent, align 4, !dbg !534
  %29 = load i32, i32* %bRep, align 4, !dbg !535
  %shr43 = lshr i32 %29, 23, !dbg !536
  %and44 = and i32 %shr43, 255, !dbg !537
  store i32 %and44, i32* %bExponent, align 4, !dbg !538
  %30 = load i32, i32* %aRep, align 4, !dbg !539
  %and45 = and i32 %30, 8388607, !dbg !540
  store i32 %and45, i32* %aSignificand, align 4, !dbg !541
  %31 = load i32, i32* %bRep, align 4, !dbg !542
  %and46 = and i32 %31, 8388607, !dbg !543
  store i32 %and46, i32* %bSignificand, align 4, !dbg !544
  %32 = load i32, i32* %aExponent, align 4, !dbg !545
  %cmp47 = icmp eq i32 %32, 0, !dbg !546
  br i1 %cmp47, label %if.then48, label %if.end50, !dbg !545

if.then48:                                        ; preds = %if.end41
  %call49 = call i32 @normalize.4(i32* %aSignificand) #4, !dbg !547
  store i32 %call49, i32* %aExponent, align 4, !dbg !548
  br label %if.end50, !dbg !549

if.end50:                                         ; preds = %if.then48, %if.end41
  %33 = load i32, i32* %bExponent, align 4, !dbg !550
  %cmp51 = icmp eq i32 %33, 0, !dbg !551
  br i1 %cmp51, label %if.then52, label %if.end54, !dbg !550

if.then52:                                        ; preds = %if.end50
  %call53 = call i32 @normalize.4(i32* %bSignificand) #4, !dbg !552
  store i32 %call53, i32* %bExponent, align 4, !dbg !553
  br label %if.end54, !dbg !554

if.end54:                                         ; preds = %if.then52, %if.end50
  %34 = load i32, i32* %aRep, align 4, !dbg !555
  %and55 = and i32 %34, -2147483648, !dbg !556
  store i32 %and55, i32* %resultSign, align 4, !dbg !557
  %35 = load i32, i32* %aRep, align 4, !dbg !558
  %36 = load i32, i32* %bRep, align 4, !dbg !559
  %xor56 = xor i32 %35, %36, !dbg !560
  %and57 = and i32 %xor56, -2147483648, !dbg !561
  %tobool58 = icmp ne i32 %and57, 0, !dbg !562
  %frombool = zext i1 %tobool58 to i8, !dbg !563
  store i8 %frombool, i8* %subtraction, align 1, !dbg !563
  %37 = load i32, i32* %aSignificand, align 4, !dbg !564
  %or59 = or i32 %37, 8388608, !dbg !565
  %shl = shl i32 %or59, 3, !dbg !566
  store i32 %shl, i32* %aSignificand, align 4, !dbg !567
  %38 = load i32, i32* %bSignificand, align 4, !dbg !568
  %or60 = or i32 %38, 8388608, !dbg !569
  %shl61 = shl i32 %or60, 3, !dbg !570
  store i32 %shl61, i32* %bSignificand, align 4, !dbg !571
  %39 = load i32, i32* %aExponent, align 4, !dbg !572
  %40 = load i32, i32* %bExponent, align 4, !dbg !573
  %sub62 = sub nsw i32 %39, %40, !dbg !574
  store i32 %sub62, i32* %align, align 4, !dbg !575
  %41 = load i32, i32* %align, align 4, !dbg !576
  %tobool63 = icmp ne i32 %41, 0, !dbg !576
  br i1 %tobool63, label %if.then64, label %if.end76, !dbg !576

if.then64:                                        ; preds = %if.end54
  %42 = load i32, i32* %align, align 4, !dbg !577
  %cmp65 = icmp ult i32 %42, 32, !dbg !578
  br i1 %cmp65, label %if.then66, label %if.else74, !dbg !577

if.then66:                                        ; preds = %if.then64
  %43 = load i32, i32* %bSignificand, align 4, !dbg !579
  %44 = load i32, i32* %align, align 4, !dbg !580
  %sub67 = sub i32 32, %44, !dbg !581
  %shl68 = shl i32 %43, %sub67, !dbg !582
  %tobool69 = icmp ne i32 %shl68, 0, !dbg !579
  %frombool70 = zext i1 %tobool69 to i8, !dbg !583
  store i8 %frombool70, i8* %sticky, align 1, !dbg !583
  %45 = load i32, i32* %bSignificand, align 4, !dbg !584
  %46 = load i32, i32* %align, align 4, !dbg !585
  %shr71 = lshr i32 %45, %46, !dbg !586
  %47 = load i8, i8* %sticky, align 1, !dbg !587
  %tobool72 = trunc i8 %47 to i1, !dbg !587
  %conv = zext i1 %tobool72 to i32, !dbg !587
  %or73 = or i32 %shr71, %conv, !dbg !588
  store i32 %or73, i32* %bSignificand, align 4, !dbg !589
  br label %if.end75, !dbg !590

if.else74:                                        ; preds = %if.then64
  store i32 1, i32* %bSignificand, align 4, !dbg !591
  br label %if.end75

if.end75:                                         ; preds = %if.else74, %if.then66
  br label %if.end76, !dbg !592

if.end76:                                         ; preds = %if.end75, %if.end54
  %48 = load i8, i8* %subtraction, align 1, !dbg !593
  %tobool77 = trunc i8 %48 to i1, !dbg !593
  br i1 %tobool77, label %if.then78, label %if.else94, !dbg !593

if.then78:                                        ; preds = %if.end76
  %49 = load i32, i32* %bSignificand, align 4, !dbg !594
  %50 = load i32, i32* %aSignificand, align 4, !dbg !595
  %sub79 = sub i32 %50, %49, !dbg !595
  store i32 %sub79, i32* %aSignificand, align 4, !dbg !595
  %51 = load i32, i32* %aSignificand, align 4, !dbg !596
  %cmp80 = icmp eq i32 %51, 0, !dbg !597
  br i1 %cmp80, label %if.then82, label %if.end84, !dbg !596

if.then82:                                        ; preds = %if.then78
  %call83 = call float @fromRep.3(i32 0) #4, !dbg !598
  store float %call83, float* %retval, align 4, !dbg !599
  br label %return, !dbg !599

if.end84:                                         ; preds = %if.then78
  %52 = load i32, i32* %aSignificand, align 4, !dbg !600
  %cmp85 = icmp ult i32 %52, 67108864, !dbg !601
  br i1 %cmp85, label %if.then87, label %if.end93, !dbg !600

if.then87:                                        ; preds = %if.end84
  %53 = load i32, i32* %aSignificand, align 4, !dbg !602
  %call88 = call i32 @rep_clz.5(i32 %53) #4, !dbg !603
  %call89 = call i32 @rep_clz.5(i32 67108864) #4, !dbg !604
  %sub90 = sub nsw i32 %call88, %call89, !dbg !605
  store i32 %sub90, i32* %shift, align 4, !dbg !606
  %54 = load i32, i32* %shift, align 4, !dbg !607
  %55 = load i32, i32* %aSignificand, align 4, !dbg !608
  %shl91 = shl i32 %55, %54, !dbg !608
  store i32 %shl91, i32* %aSignificand, align 4, !dbg !608
  %56 = load i32, i32* %shift, align 4, !dbg !609
  %57 = load i32, i32* %aExponent, align 4, !dbg !610
  %sub92 = sub nsw i32 %57, %56, !dbg !610
  store i32 %sub92, i32* %aExponent, align 4, !dbg !610
  br label %if.end93, !dbg !611

if.end93:                                         ; preds = %if.then87, %if.end84
  br label %if.end108, !dbg !612

if.else94:                                        ; preds = %if.end76
  %58 = load i32, i32* %bSignificand, align 4, !dbg !613
  %59 = load i32, i32* %aSignificand, align 4, !dbg !614
  %add = add i32 %59, %58, !dbg !614
  store i32 %add, i32* %aSignificand, align 4, !dbg !614
  %60 = load i32, i32* %aSignificand, align 4, !dbg !615
  %and95 = and i32 %60, 134217728, !dbg !616
  %tobool96 = icmp ne i32 %and95, 0, !dbg !616
  br i1 %tobool96, label %if.then97, label %if.end107, !dbg !615

if.then97:                                        ; preds = %if.else94
  %61 = load i32, i32* %aSignificand, align 4, !dbg !617
  %and99 = and i32 %61, 1, !dbg !618
  %tobool100 = icmp ne i32 %and99, 0, !dbg !617
  %frombool101 = zext i1 %tobool100 to i8, !dbg !619
  store i8 %frombool101, i8* %sticky98, align 1, !dbg !619
  %62 = load i32, i32* %aSignificand, align 4, !dbg !620
  %shr102 = lshr i32 %62, 1, !dbg !621
  %63 = load i8, i8* %sticky98, align 1, !dbg !622
  %tobool103 = trunc i8 %63 to i1, !dbg !622
  %conv104 = zext i1 %tobool103 to i32, !dbg !622
  %or105 = or i32 %shr102, %conv104, !dbg !623
  store i32 %or105, i32* %aSignificand, align 4, !dbg !624
  %64 = load i32, i32* %aExponent, align 4, !dbg !625
  %add106 = add nsw i32 %64, 1, !dbg !625
  store i32 %add106, i32* %aExponent, align 4, !dbg !625
  br label %if.end107, !dbg !626

if.end107:                                        ; preds = %if.then97, %if.else94
  br label %if.end108

if.end108:                                        ; preds = %if.end107, %if.end93
  %65 = load i32, i32* %aExponent, align 4, !dbg !627
  %cmp109 = icmp sge i32 %65, 255, !dbg !628
  br i1 %cmp109, label %if.then111, label %if.end114, !dbg !627

if.then111:                                       ; preds = %if.end108
  %66 = load i32, i32* %resultSign, align 4, !dbg !629
  %or112 = or i32 2139095040, %66, !dbg !630
  %call113 = call float @fromRep.3(i32 %or112) #4, !dbg !631
  store float %call113, float* %retval, align 4, !dbg !632
  br label %return, !dbg !632

if.end114:                                        ; preds = %if.end108
  %67 = load i32, i32* %aExponent, align 4, !dbg !633
  %cmp115 = icmp sle i32 %67, 0, !dbg !634
  br i1 %cmp115, label %if.then117, label %if.end129, !dbg !633

if.then117:                                       ; preds = %if.end114
  %68 = load i32, i32* %aExponent, align 4, !dbg !635
  %sub119 = sub nsw i32 1, %68, !dbg !636
  store i32 %sub119, i32* %shift118, align 4, !dbg !637
  %69 = load i32, i32* %aSignificand, align 4, !dbg !638
  %70 = load i32, i32* %shift118, align 4, !dbg !639
  %sub121 = sub i32 32, %70, !dbg !640
  %shl122 = shl i32 %69, %sub121, !dbg !641
  %tobool123 = icmp ne i32 %shl122, 0, !dbg !638
  %frombool124 = zext i1 %tobool123 to i8, !dbg !642
  store i8 %frombool124, i8* %sticky120, align 1, !dbg !642
  %71 = load i32, i32* %aSignificand, align 4, !dbg !643
  %72 = load i32, i32* %shift118, align 4, !dbg !644
  %shr125 = lshr i32 %71, %72, !dbg !645
  %73 = load i8, i8* %sticky120, align 1, !dbg !646
  %tobool126 = trunc i8 %73 to i1, !dbg !646
  %conv127 = zext i1 %tobool126 to i32, !dbg !646
  %or128 = or i32 %shr125, %conv127, !dbg !647
  store i32 %or128, i32* %aSignificand, align 4, !dbg !648
  store i32 0, i32* %aExponent, align 4, !dbg !649
  br label %if.end129, !dbg !650

if.end129:                                        ; preds = %if.then117, %if.end114
  %74 = load i32, i32* %aSignificand, align 4, !dbg !651
  %and130 = and i32 %74, 7, !dbg !652
  store i32 %and130, i32* %roundGuardSticky, align 4, !dbg !653
  %75 = load i32, i32* %aSignificand, align 4, !dbg !654
  %shr131 = lshr i32 %75, 3, !dbg !655
  %and132 = and i32 %shr131, 8388607, !dbg !656
  store i32 %and132, i32* %result, align 4, !dbg !657
  %76 = load i32, i32* %aExponent, align 4, !dbg !658
  %shl133 = shl i32 %76, 23, !dbg !659
  %77 = load i32, i32* %result, align 4, !dbg !660
  %or134 = or i32 %77, %shl133, !dbg !660
  store i32 %or134, i32* %result, align 4, !dbg !660
  %78 = load i32, i32* %resultSign, align 4, !dbg !661
  %79 = load i32, i32* %result, align 4, !dbg !662
  %or135 = or i32 %79, %78, !dbg !662
  store i32 %or135, i32* %result, align 4, !dbg !662
  %80 = load i32, i32* %roundGuardSticky, align 4, !dbg !663
  %cmp136 = icmp sgt i32 %80, 4, !dbg !664
  br i1 %cmp136, label %if.then138, label %if.end139, !dbg !663

if.then138:                                       ; preds = %if.end129
  %81 = load i32, i32* %result, align 4, !dbg !665
  %inc = add i32 %81, 1, !dbg !665
  store i32 %inc, i32* %result, align 4, !dbg !665
  br label %if.end139, !dbg !666

if.end139:                                        ; preds = %if.then138, %if.end129
  %82 = load i32, i32* %roundGuardSticky, align 4, !dbg !667
  %cmp140 = icmp eq i32 %82, 4, !dbg !668
  br i1 %cmp140, label %if.then142, label %if.end145, !dbg !667

if.then142:                                       ; preds = %if.end139
  %83 = load i32, i32* %result, align 4, !dbg !669
  %and143 = and i32 %83, 1, !dbg !670
  %84 = load i32, i32* %result, align 4, !dbg !671
  %add144 = add i32 %84, %and143, !dbg !671
  store i32 %add144, i32* %result, align 4, !dbg !671
  br label %if.end145, !dbg !672

if.end145:                                        ; preds = %if.then142, %if.end139
  %85 = load i32, i32* %result, align 4, !dbg !673
  %call146 = call float @fromRep.3(i32 %85) #4, !dbg !674
  store float %call146, float* %retval, align 4, !dbg !675
  br label %return, !dbg !675

return:                                           ; preds = %if.end145, %if.then111, %if.then82, %if.then36, %if.else33, %if.then28, %if.then24, %if.else, %if.then20, %if.then10, %if.then6
  %86 = load float, float* %retval, align 4, !dbg !676
  ret float %86, !dbg !676
}

; Function Attrs: noinline nounwind
define internal i32 @toRep.2(float %x) #0 !dbg !677 {
entry:
  %x.addr = alloca float, align 4
  %rep = alloca %union.anon.0.0, align 4
  store float %x, float* %x.addr, align 4
  %f = bitcast %union.anon.0.0* %rep to float*, !dbg !678
  %0 = load float, float* %x.addr, align 4, !dbg !679
  store float %0, float* %f, align 4, !dbg !678
  %i = bitcast %union.anon.0.0* %rep to i32*, !dbg !680
  %1 = load i32, i32* %i, align 4, !dbg !680
  ret i32 %1, !dbg !681
}

; Function Attrs: noinline nounwind
define internal float @fromRep.3(i32 %x) #0 !dbg !682 {
entry:
  %x.addr = alloca i32, align 4
  %rep = alloca %union.anon.0.0, align 4
  store i32 %x, i32* %x.addr, align 4
  %i = bitcast %union.anon.0.0* %rep to i32*, !dbg !683
  %0 = load i32, i32* %x.addr, align 4, !dbg !684
  store i32 %0, i32* %i, align 4, !dbg !683
  %f = bitcast %union.anon.0.0* %rep to float*, !dbg !685
  %1 = load float, float* %f, align 4, !dbg !685
  ret float %1, !dbg !686
}

; Function Attrs: noinline nounwind
define internal i32 @normalize.4(i32* %significand) #0 !dbg !687 {
entry:
  %significand.addr = alloca i32*, align 4
  %shift = alloca i32, align 4
  store i32* %significand, i32** %significand.addr, align 4
  %0 = load i32*, i32** %significand.addr, align 4, !dbg !688
  %1 = load i32, i32* %0, align 4, !dbg !689
  %call = call i32 @rep_clz.5(i32 %1) #4, !dbg !690
  %call1 = call i32 @rep_clz.5(i32 8388608) #4, !dbg !691
  %sub = sub nsw i32 %call, %call1, !dbg !692
  store i32 %sub, i32* %shift, align 4, !dbg !693
  %2 = load i32, i32* %shift, align 4, !dbg !694
  %3 = load i32*, i32** %significand.addr, align 4, !dbg !695
  %4 = load i32, i32* %3, align 4, !dbg !696
  %shl = shl i32 %4, %2, !dbg !696
  store i32 %shl, i32* %3, align 4, !dbg !696
  %5 = load i32, i32* %shift, align 4, !dbg !697
  %sub2 = sub nsw i32 1, %5, !dbg !698
  ret i32 %sub2, !dbg !699
}

; Function Attrs: noinline nounwind
define internal i32 @rep_clz.5(i32 %a) #0 !dbg !700 {
entry:
  %a.addr = alloca i32, align 4
  store i32 %a, i32* %a.addr, align 4
  %0 = load i32, i32* %a.addr, align 4, !dbg !701
  %1 = call i32 @llvm.ctlz.i32(i32 %0, i1 true), !dbg !702
  ret i32 %1, !dbg !703
}

; Function Attrs: noinline nounwind
define dso_local i32 @__ledf2(double %a, double %b) #0 !dbg !704 {
entry:
  %retval = alloca i32, align 4
  %a.addr = alloca double, align 8
  %b.addr = alloca double, align 8
  %aInt = alloca i64, align 8
  %bInt = alloca i64, align 8
  %aAbs = alloca i64, align 8
  %bAbs = alloca i64, align 8
  store double %a, double* %a.addr, align 8
  store double %b, double* %b.addr, align 8
  %0 = load double, double* %a.addr, align 8, !dbg !705
  %call = call i64 @toRep.6(double %0) #4, !dbg !706
  store i64 %call, i64* %aInt, align 8, !dbg !707
  %1 = load double, double* %b.addr, align 8, !dbg !708
  %call1 = call i64 @toRep.6(double %1) #4, !dbg !709
  store i64 %call1, i64* %bInt, align 8, !dbg !710
  %2 = load i64, i64* %aInt, align 8, !dbg !711
  %and = and i64 %2, 9223372036854775807, !dbg !712
  store i64 %and, i64* %aAbs, align 8, !dbg !713
  %3 = load i64, i64* %bInt, align 8, !dbg !714
  %and2 = and i64 %3, 9223372036854775807, !dbg !715
  store i64 %and2, i64* %bAbs, align 8, !dbg !716
  %4 = load i64, i64* %aAbs, align 8, !dbg !717
  %cmp = icmp ugt i64 %4, 9218868437227405312, !dbg !718
  br i1 %cmp, label %if.then, label %lor.lhs.false, !dbg !719

lor.lhs.false:                                    ; preds = %entry
  %5 = load i64, i64* %bAbs, align 8, !dbg !720
  %cmp3 = icmp ugt i64 %5, 9218868437227405312, !dbg !721
  br i1 %cmp3, label %if.then, label %if.end, !dbg !717

if.then:                                          ; preds = %lor.lhs.false, %entry
  store i32 1, i32* %retval, align 4, !dbg !722
  br label %return, !dbg !722

if.end:                                           ; preds = %lor.lhs.false
  %6 = load i64, i64* %aAbs, align 8, !dbg !723
  %7 = load i64, i64* %bAbs, align 8, !dbg !724
  %or = or i64 %6, %7, !dbg !725
  %cmp4 = icmp eq i64 %or, 0, !dbg !726
  br i1 %cmp4, label %if.then5, label %if.end6, !dbg !727

if.then5:                                         ; preds = %if.end
  store i32 0, i32* %retval, align 4, !dbg !728
  br label %return, !dbg !728

if.end6:                                          ; preds = %if.end
  %8 = load i64, i64* %aInt, align 8, !dbg !729
  %9 = load i64, i64* %bInt, align 8, !dbg !730
  %and7 = and i64 %8, %9, !dbg !731
  %cmp8 = icmp sge i64 %and7, 0, !dbg !732
  br i1 %cmp8, label %if.then9, label %if.else15, !dbg !733

if.then9:                                         ; preds = %if.end6
  %10 = load i64, i64* %aInt, align 8, !dbg !734
  %11 = load i64, i64* %bInt, align 8, !dbg !735
  %cmp10 = icmp slt i64 %10, %11, !dbg !736
  br i1 %cmp10, label %if.then11, label %if.else, !dbg !734

if.then11:                                        ; preds = %if.then9
  store i32 -1, i32* %retval, align 4, !dbg !737
  br label %return, !dbg !737

if.else:                                          ; preds = %if.then9
  %12 = load i64, i64* %aInt, align 8, !dbg !738
  %13 = load i64, i64* %bInt, align 8, !dbg !739
  %cmp12 = icmp eq i64 %12, %13, !dbg !740
  br i1 %cmp12, label %if.then13, label %if.else14, !dbg !738

if.then13:                                        ; preds = %if.else
  store i32 0, i32* %retval, align 4, !dbg !741
  br label %return, !dbg !741

if.else14:                                        ; preds = %if.else
  store i32 1, i32* %retval, align 4, !dbg !742
  br label %return, !dbg !742

if.else15:                                        ; preds = %if.end6
  %14 = load i64, i64* %aInt, align 8, !dbg !743
  %15 = load i64, i64* %bInt, align 8, !dbg !744
  %cmp16 = icmp sgt i64 %14, %15, !dbg !745
  br i1 %cmp16, label %if.then17, label %if.else18, !dbg !743

if.then17:                                        ; preds = %if.else15
  store i32 -1, i32* %retval, align 4, !dbg !746
  br label %return, !dbg !746

if.else18:                                        ; preds = %if.else15
  %16 = load i64, i64* %aInt, align 8, !dbg !747
  %17 = load i64, i64* %bInt, align 8, !dbg !748
  %cmp19 = icmp eq i64 %16, %17, !dbg !749
  br i1 %cmp19, label %if.then20, label %if.else21, !dbg !747

if.then20:                                        ; preds = %if.else18
  store i32 0, i32* %retval, align 4, !dbg !750
  br label %return, !dbg !750

if.else21:                                        ; preds = %if.else18
  store i32 1, i32* %retval, align 4, !dbg !751
  br label %return, !dbg !751

return:                                           ; preds = %if.else21, %if.then20, %if.then17, %if.else14, %if.then13, %if.then11, %if.then5, %if.then
  %18 = load i32, i32* %retval, align 4, !dbg !752
  ret i32 %18, !dbg !752
}

; Function Attrs: noinline nounwind
define internal i64 @toRep.6(double %x) #0 !dbg !753 {
entry:
  %x.addr = alloca double, align 8
  %rep = alloca %union.anon.0, align 8
  store double %x, double* %x.addr, align 8
  %f = bitcast %union.anon.0* %rep to double*, !dbg !754
  %0 = load double, double* %x.addr, align 8, !dbg !755
  store double %0, double* %f, align 8, !dbg !754
  %i = bitcast %union.anon.0* %rep to i64*, !dbg !756
  %1 = load i64, i64* %i, align 8, !dbg !756
  ret i64 %1, !dbg !757
}

; Function Attrs: noinline nounwind
define dso_local i32 @__gedf2(double %a, double %b) #0 !dbg !758 {
entry:
  %retval = alloca i32, align 4
  %a.addr = alloca double, align 8
  %b.addr = alloca double, align 8
  %aInt = alloca i64, align 8
  %bInt = alloca i64, align 8
  %aAbs = alloca i64, align 8
  %bAbs = alloca i64, align 8
  store double %a, double* %a.addr, align 8
  store double %b, double* %b.addr, align 8
  %0 = load double, double* %a.addr, align 8, !dbg !759
  %call = call i64 @toRep.6(double %0) #4, !dbg !760
  store i64 %call, i64* %aInt, align 8, !dbg !761
  %1 = load double, double* %b.addr, align 8, !dbg !762
  %call1 = call i64 @toRep.6(double %1) #4, !dbg !763
  store i64 %call1, i64* %bInt, align 8, !dbg !764
  %2 = load i64, i64* %aInt, align 8, !dbg !765
  %and = and i64 %2, 9223372036854775807, !dbg !766
  store i64 %and, i64* %aAbs, align 8, !dbg !767
  %3 = load i64, i64* %bInt, align 8, !dbg !768
  %and2 = and i64 %3, 9223372036854775807, !dbg !769
  store i64 %and2, i64* %bAbs, align 8, !dbg !770
  %4 = load i64, i64* %aAbs, align 8, !dbg !771
  %cmp = icmp ugt i64 %4, 9218868437227405312, !dbg !772
  br i1 %cmp, label %if.then, label %lor.lhs.false, !dbg !773

lor.lhs.false:                                    ; preds = %entry
  %5 = load i64, i64* %bAbs, align 8, !dbg !774
  %cmp3 = icmp ugt i64 %5, 9218868437227405312, !dbg !775
  br i1 %cmp3, label %if.then, label %if.end, !dbg !771

if.then:                                          ; preds = %lor.lhs.false, %entry
  store i32 -1, i32* %retval, align 4, !dbg !776
  br label %return, !dbg !776

if.end:                                           ; preds = %lor.lhs.false
  %6 = load i64, i64* %aAbs, align 8, !dbg !777
  %7 = load i64, i64* %bAbs, align 8, !dbg !778
  %or = or i64 %6, %7, !dbg !779
  %cmp4 = icmp eq i64 %or, 0, !dbg !780
  br i1 %cmp4, label %if.then5, label %if.end6, !dbg !781

if.then5:                                         ; preds = %if.end
  store i32 0, i32* %retval, align 4, !dbg !782
  br label %return, !dbg !782

if.end6:                                          ; preds = %if.end
  %8 = load i64, i64* %aInt, align 8, !dbg !783
  %9 = load i64, i64* %bInt, align 8, !dbg !784
  %and7 = and i64 %8, %9, !dbg !785
  %cmp8 = icmp sge i64 %and7, 0, !dbg !786
  br i1 %cmp8, label %if.then9, label %if.else15, !dbg !787

if.then9:                                         ; preds = %if.end6
  %10 = load i64, i64* %aInt, align 8, !dbg !788
  %11 = load i64, i64* %bInt, align 8, !dbg !789
  %cmp10 = icmp slt i64 %10, %11, !dbg !790
  br i1 %cmp10, label %if.then11, label %if.else, !dbg !788

if.then11:                                        ; preds = %if.then9
  store i32 -1, i32* %retval, align 4, !dbg !791
  br label %return, !dbg !791

if.else:                                          ; preds = %if.then9
  %12 = load i64, i64* %aInt, align 8, !dbg !792
  %13 = load i64, i64* %bInt, align 8, !dbg !793
  %cmp12 = icmp eq i64 %12, %13, !dbg !794
  br i1 %cmp12, label %if.then13, label %if.else14, !dbg !792

if.then13:                                        ; preds = %if.else
  store i32 0, i32* %retval, align 4, !dbg !795
  br label %return, !dbg !795

if.else14:                                        ; preds = %if.else
  store i32 1, i32* %retval, align 4, !dbg !796
  br label %return, !dbg !796

if.else15:                                        ; preds = %if.end6
  %14 = load i64, i64* %aInt, align 8, !dbg !797
  %15 = load i64, i64* %bInt, align 8, !dbg !798
  %cmp16 = icmp sgt i64 %14, %15, !dbg !799
  br i1 %cmp16, label %if.then17, label %if.else18, !dbg !797

if.then17:                                        ; preds = %if.else15
  store i32 -1, i32* %retval, align 4, !dbg !800
  br label %return, !dbg !800

if.else18:                                        ; preds = %if.else15
  %16 = load i64, i64* %aInt, align 8, !dbg !801
  %17 = load i64, i64* %bInt, align 8, !dbg !802
  %cmp19 = icmp eq i64 %16, %17, !dbg !803
  br i1 %cmp19, label %if.then20, label %if.else21, !dbg !801

if.then20:                                        ; preds = %if.else18
  store i32 0, i32* %retval, align 4, !dbg !804
  br label %return, !dbg !804

if.else21:                                        ; preds = %if.else18
  store i32 1, i32* %retval, align 4, !dbg !805
  br label %return, !dbg !805

return:                                           ; preds = %if.else21, %if.then20, %if.then17, %if.else14, %if.then13, %if.then11, %if.then5, %if.then
  %18 = load i32, i32* %retval, align 4, !dbg !806
  ret i32 %18, !dbg !806
}

; Function Attrs: noinline nounwind
define dso_local i32 @__unorddf2(double %a, double %b) #0 !dbg !807 {
entry:
  %a.addr = alloca double, align 8
  %b.addr = alloca double, align 8
  %aAbs = alloca i64, align 8
  %bAbs = alloca i64, align 8
  store double %a, double* %a.addr, align 8
  store double %b, double* %b.addr, align 8
  %0 = load double, double* %a.addr, align 8, !dbg !808
  %call = call i64 @toRep.6(double %0) #4, !dbg !809
  %and = and i64 %call, 9223372036854775807, !dbg !810
  store i64 %and, i64* %aAbs, align 8, !dbg !811
  %1 = load double, double* %b.addr, align 8, !dbg !812
  %call1 = call i64 @toRep.6(double %1) #4, !dbg !813
  %and2 = and i64 %call1, 9223372036854775807, !dbg !814
  store i64 %and2, i64* %bAbs, align 8, !dbg !815
  %2 = load i64, i64* %aAbs, align 8, !dbg !816
  %cmp = icmp ugt i64 %2, 9218868437227405312, !dbg !817
  br i1 %cmp, label %lor.end, label %lor.rhs, !dbg !818

lor.rhs:                                          ; preds = %entry
  %3 = load i64, i64* %bAbs, align 8, !dbg !819
  %cmp3 = icmp ugt i64 %3, 9218868437227405312, !dbg !820
  br label %lor.end, !dbg !818

lor.end:                                          ; preds = %lor.rhs, %entry
  %4 = phi i1 [ true, %entry ], [ %cmp3, %lor.rhs ]
  %lor.ext = zext i1 %4 to i32, !dbg !818
  ret i32 %lor.ext, !dbg !821
}

; Function Attrs: noinline nounwind
define dso_local i32 @__eqdf2(double %a, double %b) #0 !dbg !822 {
entry:
  %a.addr = alloca double, align 8
  %b.addr = alloca double, align 8
  store double %a, double* %a.addr, align 8
  store double %b, double* %b.addr, align 8
  %0 = load double, double* %a.addr, align 8, !dbg !823
  %1 = load double, double* %b.addr, align 8, !dbg !824
  %call = call i32 @__ledf2(double %0, double %1) #4, !dbg !825
  ret i32 %call, !dbg !826
}

; Function Attrs: noinline nounwind
define dso_local i32 @__ltdf2(double %a, double %b) #0 !dbg !827 {
entry:
  %a.addr = alloca double, align 8
  %b.addr = alloca double, align 8
  store double %a, double* %a.addr, align 8
  store double %b, double* %b.addr, align 8
  %0 = load double, double* %a.addr, align 8, !dbg !828
  %1 = load double, double* %b.addr, align 8, !dbg !829
  %call = call i32 @__ledf2(double %0, double %1) #4, !dbg !830
  ret i32 %call, !dbg !831
}

; Function Attrs: noinline nounwind
define dso_local i32 @__nedf2(double %a, double %b) #0 !dbg !832 {
entry:
  %a.addr = alloca double, align 8
  %b.addr = alloca double, align 8
  store double %a, double* %a.addr, align 8
  store double %b, double* %b.addr, align 8
  %0 = load double, double* %a.addr, align 8, !dbg !833
  %1 = load double, double* %b.addr, align 8, !dbg !834
  %call = call i32 @__ledf2(double %0, double %1) #4, !dbg !835
  ret i32 %call, !dbg !836
}

; Function Attrs: noinline nounwind
define dso_local i32 @__gtdf2(double %a, double %b) #0 !dbg !837 {
entry:
  %a.addr = alloca double, align 8
  %b.addr = alloca double, align 8
  store double %a, double* %a.addr, align 8
  store double %b, double* %b.addr, align 8
  %0 = load double, double* %a.addr, align 8, !dbg !838
  %1 = load double, double* %b.addr, align 8, !dbg !839
  %call = call i32 @__gedf2(double %0, double %1) #4, !dbg !840
  ret i32 %call, !dbg !841
}

; Function Attrs: noinline nounwind
define dso_local i32 @__lesf2(float %a, float %b) #0 !dbg !842 {
entry:
  %retval = alloca i32, align 4
  %a.addr = alloca float, align 4
  %b.addr = alloca float, align 4
  %aInt = alloca i32, align 4
  %bInt = alloca i32, align 4
  %aAbs = alloca i32, align 4
  %bAbs = alloca i32, align 4
  store float %a, float* %a.addr, align 4
  store float %b, float* %b.addr, align 4
  %0 = load float, float* %a.addr, align 4, !dbg !843
  %call = call i32 @toRep.7(float %0) #4, !dbg !844
  store i32 %call, i32* %aInt, align 4, !dbg !845
  %1 = load float, float* %b.addr, align 4, !dbg !846
  %call1 = call i32 @toRep.7(float %1) #4, !dbg !847
  store i32 %call1, i32* %bInt, align 4, !dbg !848
  %2 = load i32, i32* %aInt, align 4, !dbg !849
  %and = and i32 %2, 2147483647, !dbg !850
  store i32 %and, i32* %aAbs, align 4, !dbg !851
  %3 = load i32, i32* %bInt, align 4, !dbg !852
  %and2 = and i32 %3, 2147483647, !dbg !853
  store i32 %and2, i32* %bAbs, align 4, !dbg !854
  %4 = load i32, i32* %aAbs, align 4, !dbg !855
  %cmp = icmp ugt i32 %4, 2139095040, !dbg !856
  br i1 %cmp, label %if.then, label %lor.lhs.false, !dbg !857

lor.lhs.false:                                    ; preds = %entry
  %5 = load i32, i32* %bAbs, align 4, !dbg !858
  %cmp3 = icmp ugt i32 %5, 2139095040, !dbg !859
  br i1 %cmp3, label %if.then, label %if.end, !dbg !855

if.then:                                          ; preds = %lor.lhs.false, %entry
  store i32 1, i32* %retval, align 4, !dbg !860
  br label %return, !dbg !860

if.end:                                           ; preds = %lor.lhs.false
  %6 = load i32, i32* %aAbs, align 4, !dbg !861
  %7 = load i32, i32* %bAbs, align 4, !dbg !862
  %or = or i32 %6, %7, !dbg !863
  %cmp4 = icmp eq i32 %or, 0, !dbg !864
  br i1 %cmp4, label %if.then5, label %if.end6, !dbg !865

if.then5:                                         ; preds = %if.end
  store i32 0, i32* %retval, align 4, !dbg !866
  br label %return, !dbg !866

if.end6:                                          ; preds = %if.end
  %8 = load i32, i32* %aInt, align 4, !dbg !867
  %9 = load i32, i32* %bInt, align 4, !dbg !868
  %and7 = and i32 %8, %9, !dbg !869
  %cmp8 = icmp sge i32 %and7, 0, !dbg !870
  br i1 %cmp8, label %if.then9, label %if.else15, !dbg !871

if.then9:                                         ; preds = %if.end6
  %10 = load i32, i32* %aInt, align 4, !dbg !872
  %11 = load i32, i32* %bInt, align 4, !dbg !873
  %cmp10 = icmp slt i32 %10, %11, !dbg !874
  br i1 %cmp10, label %if.then11, label %if.else, !dbg !872

if.then11:                                        ; preds = %if.then9
  store i32 -1, i32* %retval, align 4, !dbg !875
  br label %return, !dbg !875

if.else:                                          ; preds = %if.then9
  %12 = load i32, i32* %aInt, align 4, !dbg !876
  %13 = load i32, i32* %bInt, align 4, !dbg !877
  %cmp12 = icmp eq i32 %12, %13, !dbg !878
  br i1 %cmp12, label %if.then13, label %if.else14, !dbg !876

if.then13:                                        ; preds = %if.else
  store i32 0, i32* %retval, align 4, !dbg !879
  br label %return, !dbg !879

if.else14:                                        ; preds = %if.else
  store i32 1, i32* %retval, align 4, !dbg !880
  br label %return, !dbg !880

if.else15:                                        ; preds = %if.end6
  %14 = load i32, i32* %aInt, align 4, !dbg !881
  %15 = load i32, i32* %bInt, align 4, !dbg !882
  %cmp16 = icmp sgt i32 %14, %15, !dbg !883
  br i1 %cmp16, label %if.then17, label %if.else18, !dbg !881

if.then17:                                        ; preds = %if.else15
  store i32 -1, i32* %retval, align 4, !dbg !884
  br label %return, !dbg !884

if.else18:                                        ; preds = %if.else15
  %16 = load i32, i32* %aInt, align 4, !dbg !885
  %17 = load i32, i32* %bInt, align 4, !dbg !886
  %cmp19 = icmp eq i32 %16, %17, !dbg !887
  br i1 %cmp19, label %if.then20, label %if.else21, !dbg !885

if.then20:                                        ; preds = %if.else18
  store i32 0, i32* %retval, align 4, !dbg !888
  br label %return, !dbg !888

if.else21:                                        ; preds = %if.else18
  store i32 1, i32* %retval, align 4, !dbg !889
  br label %return, !dbg !889

return:                                           ; preds = %if.else21, %if.then20, %if.then17, %if.else14, %if.then13, %if.then11, %if.then5, %if.then
  %18 = load i32, i32* %retval, align 4, !dbg !890
  ret i32 %18, !dbg !890
}

; Function Attrs: noinline nounwind
define internal i32 @toRep.7(float %x) #0 !dbg !891 {
entry:
  %x.addr = alloca float, align 4
  %rep = alloca %union.anon.0.0, align 4
  store float %x, float* %x.addr, align 4
  %f = bitcast %union.anon.0.0* %rep to float*, !dbg !892
  %0 = load float, float* %x.addr, align 4, !dbg !893
  store float %0, float* %f, align 4, !dbg !892
  %i = bitcast %union.anon.0.0* %rep to i32*, !dbg !894
  %1 = load i32, i32* %i, align 4, !dbg !894
  ret i32 %1, !dbg !895
}

; Function Attrs: noinline nounwind
define dso_local i32 @__gesf2(float %a, float %b) #0 !dbg !896 {
entry:
  %retval = alloca i32, align 4
  %a.addr = alloca float, align 4
  %b.addr = alloca float, align 4
  %aInt = alloca i32, align 4
  %bInt = alloca i32, align 4
  %aAbs = alloca i32, align 4
  %bAbs = alloca i32, align 4
  store float %a, float* %a.addr, align 4
  store float %b, float* %b.addr, align 4
  %0 = load float, float* %a.addr, align 4, !dbg !897
  %call = call i32 @toRep.7(float %0) #4, !dbg !898
  store i32 %call, i32* %aInt, align 4, !dbg !899
  %1 = load float, float* %b.addr, align 4, !dbg !900
  %call1 = call i32 @toRep.7(float %1) #4, !dbg !901
  store i32 %call1, i32* %bInt, align 4, !dbg !902
  %2 = load i32, i32* %aInt, align 4, !dbg !903
  %and = and i32 %2, 2147483647, !dbg !904
  store i32 %and, i32* %aAbs, align 4, !dbg !905
  %3 = load i32, i32* %bInt, align 4, !dbg !906
  %and2 = and i32 %3, 2147483647, !dbg !907
  store i32 %and2, i32* %bAbs, align 4, !dbg !908
  %4 = load i32, i32* %aAbs, align 4, !dbg !909
  %cmp = icmp ugt i32 %4, 2139095040, !dbg !910
  br i1 %cmp, label %if.then, label %lor.lhs.false, !dbg !911

lor.lhs.false:                                    ; preds = %entry
  %5 = load i32, i32* %bAbs, align 4, !dbg !912
  %cmp3 = icmp ugt i32 %5, 2139095040, !dbg !913
  br i1 %cmp3, label %if.then, label %if.end, !dbg !909

if.then:                                          ; preds = %lor.lhs.false, %entry
  store i32 -1, i32* %retval, align 4, !dbg !914
  br label %return, !dbg !914

if.end:                                           ; preds = %lor.lhs.false
  %6 = load i32, i32* %aAbs, align 4, !dbg !915
  %7 = load i32, i32* %bAbs, align 4, !dbg !916
  %or = or i32 %6, %7, !dbg !917
  %cmp4 = icmp eq i32 %or, 0, !dbg !918
  br i1 %cmp4, label %if.then5, label %if.end6, !dbg !919

if.then5:                                         ; preds = %if.end
  store i32 0, i32* %retval, align 4, !dbg !920
  br label %return, !dbg !920

if.end6:                                          ; preds = %if.end
  %8 = load i32, i32* %aInt, align 4, !dbg !921
  %9 = load i32, i32* %bInt, align 4, !dbg !922
  %and7 = and i32 %8, %9, !dbg !923
  %cmp8 = icmp sge i32 %and7, 0, !dbg !924
  br i1 %cmp8, label %if.then9, label %if.else15, !dbg !925

if.then9:                                         ; preds = %if.end6
  %10 = load i32, i32* %aInt, align 4, !dbg !926
  %11 = load i32, i32* %bInt, align 4, !dbg !927
  %cmp10 = icmp slt i32 %10, %11, !dbg !928
  br i1 %cmp10, label %if.then11, label %if.else, !dbg !926

if.then11:                                        ; preds = %if.then9
  store i32 -1, i32* %retval, align 4, !dbg !929
  br label %return, !dbg !929

if.else:                                          ; preds = %if.then9
  %12 = load i32, i32* %aInt, align 4, !dbg !930
  %13 = load i32, i32* %bInt, align 4, !dbg !931
  %cmp12 = icmp eq i32 %12, %13, !dbg !932
  br i1 %cmp12, label %if.then13, label %if.else14, !dbg !930

if.then13:                                        ; preds = %if.else
  store i32 0, i32* %retval, align 4, !dbg !933
  br label %return, !dbg !933

if.else14:                                        ; preds = %if.else
  store i32 1, i32* %retval, align 4, !dbg !934
  br label %return, !dbg !934

if.else15:                                        ; preds = %if.end6
  %14 = load i32, i32* %aInt, align 4, !dbg !935
  %15 = load i32, i32* %bInt, align 4, !dbg !936
  %cmp16 = icmp sgt i32 %14, %15, !dbg !937
  br i1 %cmp16, label %if.then17, label %if.else18, !dbg !935

if.then17:                                        ; preds = %if.else15
  store i32 -1, i32* %retval, align 4, !dbg !938
  br label %return, !dbg !938

if.else18:                                        ; preds = %if.else15
  %16 = load i32, i32* %aInt, align 4, !dbg !939
  %17 = load i32, i32* %bInt, align 4, !dbg !940
  %cmp19 = icmp eq i32 %16, %17, !dbg !941
  br i1 %cmp19, label %if.then20, label %if.else21, !dbg !939

if.then20:                                        ; preds = %if.else18
  store i32 0, i32* %retval, align 4, !dbg !942
  br label %return, !dbg !942

if.else21:                                        ; preds = %if.else18
  store i32 1, i32* %retval, align 4, !dbg !943
  br label %return, !dbg !943

return:                                           ; preds = %if.else21, %if.then20, %if.then17, %if.else14, %if.then13, %if.then11, %if.then5, %if.then
  %18 = load i32, i32* %retval, align 4, !dbg !944
  ret i32 %18, !dbg !944
}

; Function Attrs: noinline nounwind
define dso_local i32 @__unordsf2(float %a, float %b) #0 !dbg !945 {
entry:
  %a.addr = alloca float, align 4
  %b.addr = alloca float, align 4
  %aAbs = alloca i32, align 4
  %bAbs = alloca i32, align 4
  store float %a, float* %a.addr, align 4
  store float %b, float* %b.addr, align 4
  %0 = load float, float* %a.addr, align 4, !dbg !946
  %call = call i32 @toRep.7(float %0) #4, !dbg !947
  %and = and i32 %call, 2147483647, !dbg !948
  store i32 %and, i32* %aAbs, align 4, !dbg !949
  %1 = load float, float* %b.addr, align 4, !dbg !950
  %call1 = call i32 @toRep.7(float %1) #4, !dbg !951
  %and2 = and i32 %call1, 2147483647, !dbg !952
  store i32 %and2, i32* %bAbs, align 4, !dbg !953
  %2 = load i32, i32* %aAbs, align 4, !dbg !954
  %cmp = icmp ugt i32 %2, 2139095040, !dbg !955
  br i1 %cmp, label %lor.end, label %lor.rhs, !dbg !956

lor.rhs:                                          ; preds = %entry
  %3 = load i32, i32* %bAbs, align 4, !dbg !957
  %cmp3 = icmp ugt i32 %3, 2139095040, !dbg !958
  br label %lor.end, !dbg !956

lor.end:                                          ; preds = %lor.rhs, %entry
  %4 = phi i1 [ true, %entry ], [ %cmp3, %lor.rhs ]
  %lor.ext = zext i1 %4 to i32, !dbg !956
  ret i32 %lor.ext, !dbg !959
}

; Function Attrs: noinline nounwind
define dso_local i32 @__eqsf2(float %a, float %b) #0 !dbg !960 {
entry:
  %a.addr = alloca float, align 4
  %b.addr = alloca float, align 4
  store float %a, float* %a.addr, align 4
  store float %b, float* %b.addr, align 4
  %0 = load float, float* %a.addr, align 4, !dbg !961
  %1 = load float, float* %b.addr, align 4, !dbg !962
  %call = call i32 @__lesf2(float %0, float %1) #4, !dbg !963
  ret i32 %call, !dbg !964
}

; Function Attrs: noinline nounwind
define dso_local i32 @__ltsf2(float %a, float %b) #0 !dbg !965 {
entry:
  %a.addr = alloca float, align 4
  %b.addr = alloca float, align 4
  store float %a, float* %a.addr, align 4
  store float %b, float* %b.addr, align 4
  %0 = load float, float* %a.addr, align 4, !dbg !966
  %1 = load float, float* %b.addr, align 4, !dbg !967
  %call = call i32 @__lesf2(float %0, float %1) #4, !dbg !968
  ret i32 %call, !dbg !969
}

; Function Attrs: noinline nounwind
define dso_local i32 @__nesf2(float %a, float %b) #0 !dbg !970 {
entry:
  %a.addr = alloca float, align 4
  %b.addr = alloca float, align 4
  store float %a, float* %a.addr, align 4
  store float %b, float* %b.addr, align 4
  %0 = load float, float* %a.addr, align 4, !dbg !971
  %1 = load float, float* %b.addr, align 4, !dbg !972
  %call = call i32 @__lesf2(float %0, float %1) #4, !dbg !973
  ret i32 %call, !dbg !974
}

; Function Attrs: noinline nounwind
define dso_local i32 @__gtsf2(float %a, float %b) #0 !dbg !975 {
entry:
  %a.addr = alloca float, align 4
  %b.addr = alloca float, align 4
  store float %a, float* %a.addr, align 4
  store float %b, float* %b.addr, align 4
  %0 = load float, float* %a.addr, align 4, !dbg !976
  %1 = load float, float* %b.addr, align 4, !dbg !977
  %call = call i32 @__gesf2(float %0, float %1) #4, !dbg !978
  ret i32 %call, !dbg !979
}

; Function Attrs: noinline nounwind
define dso_local double @__divdf3(double %a, double %b) #0 !dbg !980 {
entry:
  %retval = alloca double, align 8
  %a.addr = alloca double, align 8
  %b.addr = alloca double, align 8
  %aExponent = alloca i32, align 4
  %bExponent = alloca i32, align 4
  %quotientSign = alloca i64, align 8
  %aSignificand = alloca i64, align 8
  %bSignificand = alloca i64, align 8
  %scale = alloca i32, align 4
  %aAbs = alloca i64, align 8
  %bAbs = alloca i64, align 8
  %quotientExponent = alloca i32, align 4
  %q31b = alloca i32, align 4
  %recip32 = alloca i32, align 4
  %correction32 = alloca i32, align 4
  %q63blo = alloca i32, align 4
  %correction = alloca i64, align 8
  %reciprocal = alloca i64, align 8
  %cHi = alloca i32, align 4
  %cLo = alloca i32, align 4
  %quotient = alloca i64, align 8
  %quotientLo = alloca i64, align 8
  %residual = alloca i64, align 8
  %writtenExponent = alloca i32, align 4
  %round = alloca i8, align 1
  %absResult = alloca i64, align 8
  %result = alloca double, align 8
  store double %a, double* %a.addr, align 8
  store double %b, double* %b.addr, align 8
  %0 = load double, double* %a.addr, align 8, !dbg !981
  %call = call i64 @toRep.8(double %0) #4, !dbg !982
  %shr = lshr i64 %call, 52, !dbg !983
  %and = and i64 %shr, 2047, !dbg !984
  %conv = trunc i64 %and to i32, !dbg !982
  store i32 %conv, i32* %aExponent, align 4, !dbg !985
  %1 = load double, double* %b.addr, align 8, !dbg !986
  %call1 = call i64 @toRep.8(double %1) #4, !dbg !987
  %shr2 = lshr i64 %call1, 52, !dbg !988
  %and3 = and i64 %shr2, 2047, !dbg !989
  %conv4 = trunc i64 %and3 to i32, !dbg !987
  store i32 %conv4, i32* %bExponent, align 4, !dbg !990
  %2 = load double, double* %a.addr, align 8, !dbg !991
  %call5 = call i64 @toRep.8(double %2) #4, !dbg !992
  %3 = load double, double* %b.addr, align 8, !dbg !993
  %call6 = call i64 @toRep.8(double %3) #4, !dbg !994
  %xor = xor i64 %call5, %call6, !dbg !995
  %and7 = and i64 %xor, -9223372036854775808, !dbg !996
  store i64 %and7, i64* %quotientSign, align 8, !dbg !997
  %4 = load double, double* %a.addr, align 8, !dbg !998
  %call8 = call i64 @toRep.8(double %4) #4, !dbg !999
  %and9 = and i64 %call8, 4503599627370495, !dbg !1000
  store i64 %and9, i64* %aSignificand, align 8, !dbg !1001
  %5 = load double, double* %b.addr, align 8, !dbg !1002
  %call10 = call i64 @toRep.8(double %5) #4, !dbg !1003
  %and11 = and i64 %call10, 4503599627370495, !dbg !1004
  store i64 %and11, i64* %bSignificand, align 8, !dbg !1005
  store i32 0, i32* %scale, align 4, !dbg !1006
  %6 = load i32, i32* %aExponent, align 4, !dbg !1007
  %sub = sub i32 %6, 1, !dbg !1008
  %cmp = icmp uge i32 %sub, 2046, !dbg !1009
  br i1 %cmp, label %if.then, label %lor.lhs.false, !dbg !1010

lor.lhs.false:                                    ; preds = %entry
  %7 = load i32, i32* %bExponent, align 4, !dbg !1011
  %sub13 = sub i32 %7, 1, !dbg !1012
  %cmp14 = icmp uge i32 %sub13, 2046, !dbg !1013
  br i1 %cmp14, label %if.then, label %if.end70, !dbg !1007

if.then:                                          ; preds = %lor.lhs.false, %entry
  %8 = load double, double* %a.addr, align 8, !dbg !1014
  %call16 = call i64 @toRep.8(double %8) #4, !dbg !1015
  %and17 = and i64 %call16, 9223372036854775807, !dbg !1016
  store i64 %and17, i64* %aAbs, align 8, !dbg !1017
  %9 = load double, double* %b.addr, align 8, !dbg !1018
  %call18 = call i64 @toRep.8(double %9) #4, !dbg !1019
  %and19 = and i64 %call18, 9223372036854775807, !dbg !1020
  store i64 %and19, i64* %bAbs, align 8, !dbg !1021
  %10 = load i64, i64* %aAbs, align 8, !dbg !1022
  %cmp20 = icmp ugt i64 %10, 9218868437227405312, !dbg !1023
  br i1 %cmp20, label %if.then22, label %if.end, !dbg !1022

if.then22:                                        ; preds = %if.then
  %11 = load double, double* %a.addr, align 8, !dbg !1024
  %call23 = call i64 @toRep.8(double %11) #4, !dbg !1025
  %or = or i64 %call23, 2251799813685248, !dbg !1026
  %call24 = call double @fromRep.9(i64 %or) #4, !dbg !1027
  store double %call24, double* %retval, align 8, !dbg !1028
  br label %return, !dbg !1028

if.end:                                           ; preds = %if.then
  %12 = load i64, i64* %bAbs, align 8, !dbg !1029
  %cmp25 = icmp ugt i64 %12, 9218868437227405312, !dbg !1030
  br i1 %cmp25, label %if.then27, label %if.end31, !dbg !1029

if.then27:                                        ; preds = %if.end
  %13 = load double, double* %b.addr, align 8, !dbg !1031
  %call28 = call i64 @toRep.8(double %13) #4, !dbg !1032
  %or29 = or i64 %call28, 2251799813685248, !dbg !1033
  %call30 = call double @fromRep.9(i64 %or29) #4, !dbg !1034
  store double %call30, double* %retval, align 8, !dbg !1035
  br label %return, !dbg !1035

if.end31:                                         ; preds = %if.end
  %14 = load i64, i64* %aAbs, align 8, !dbg !1036
  %cmp32 = icmp eq i64 %14, 9218868437227405312, !dbg !1037
  br i1 %cmp32, label %if.then34, label %if.end41, !dbg !1036

if.then34:                                        ; preds = %if.end31
  %15 = load i64, i64* %bAbs, align 8, !dbg !1038
  %cmp35 = icmp eq i64 %15, 9218868437227405312, !dbg !1039
  br i1 %cmp35, label %if.then37, label %if.else, !dbg !1038

if.then37:                                        ; preds = %if.then34
  %call38 = call double @fromRep.9(i64 9221120237041090560) #4, !dbg !1040
  store double %call38, double* %retval, align 8, !dbg !1041
  br label %return, !dbg !1041

if.else:                                          ; preds = %if.then34
  %16 = load i64, i64* %aAbs, align 8, !dbg !1042
  %17 = load i64, i64* %quotientSign, align 8, !dbg !1043
  %or39 = or i64 %16, %17, !dbg !1044
  %call40 = call double @fromRep.9(i64 %or39) #4, !dbg !1045
  store double %call40, double* %retval, align 8, !dbg !1046
  br label %return, !dbg !1046

if.end41:                                         ; preds = %if.end31
  %18 = load i64, i64* %bAbs, align 8, !dbg !1047
  %cmp42 = icmp eq i64 %18, 9218868437227405312, !dbg !1048
  br i1 %cmp42, label %if.then44, label %if.end46, !dbg !1047

if.then44:                                        ; preds = %if.end41
  %19 = load i64, i64* %quotientSign, align 8, !dbg !1049
  %call45 = call double @fromRep.9(i64 %19) #4, !dbg !1050
  store double %call45, double* %retval, align 8, !dbg !1051
  br label %return, !dbg !1051

if.end46:                                         ; preds = %if.end41
  %20 = load i64, i64* %aAbs, align 8, !dbg !1052
  %tobool = icmp ne i64 %20, 0, !dbg !1052
  br i1 %tobool, label %if.end53, label %if.then47, !dbg !1053

if.then47:                                        ; preds = %if.end46
  %21 = load i64, i64* %bAbs, align 8, !dbg !1054
  %tobool48 = icmp ne i64 %21, 0, !dbg !1054
  br i1 %tobool48, label %if.else51, label %if.then49, !dbg !1055

if.then49:                                        ; preds = %if.then47
  %call50 = call double @fromRep.9(i64 9221120237041090560) #4, !dbg !1056
  store double %call50, double* %retval, align 8, !dbg !1057
  br label %return, !dbg !1057

if.else51:                                        ; preds = %if.then47
  %22 = load i64, i64* %quotientSign, align 8, !dbg !1058
  %call52 = call double @fromRep.9(i64 %22) #4, !dbg !1059
  store double %call52, double* %retval, align 8, !dbg !1060
  br label %return, !dbg !1060

if.end53:                                         ; preds = %if.end46
  %23 = load i64, i64* %bAbs, align 8, !dbg !1061
  %tobool54 = icmp ne i64 %23, 0, !dbg !1061
  br i1 %tobool54, label %if.end58, label %if.then55, !dbg !1062

if.then55:                                        ; preds = %if.end53
  %24 = load i64, i64* %quotientSign, align 8, !dbg !1063
  %or56 = or i64 9218868437227405312, %24, !dbg !1064
  %call57 = call double @fromRep.9(i64 %or56) #4, !dbg !1065
  store double %call57, double* %retval, align 8, !dbg !1066
  br label %return, !dbg !1066

if.end58:                                         ; preds = %if.end53
  %25 = load i64, i64* %aAbs, align 8, !dbg !1067
  %cmp59 = icmp ult i64 %25, 4503599627370496, !dbg !1068
  br i1 %cmp59, label %if.then61, label %if.end63, !dbg !1067

if.then61:                                        ; preds = %if.end58
  %call62 = call i32 @normalize.10(i64* %aSignificand) #4, !dbg !1069
  %26 = load i32, i32* %scale, align 4, !dbg !1070
  %add = add nsw i32 %26, %call62, !dbg !1070
  store i32 %add, i32* %scale, align 4, !dbg !1070
  br label %if.end63, !dbg !1071

if.end63:                                         ; preds = %if.then61, %if.end58
  %27 = load i64, i64* %bAbs, align 8, !dbg !1072
  %cmp64 = icmp ult i64 %27, 4503599627370496, !dbg !1073
  br i1 %cmp64, label %if.then66, label %if.end69, !dbg !1072

if.then66:                                        ; preds = %if.end63
  %call67 = call i32 @normalize.10(i64* %bSignificand) #4, !dbg !1074
  %28 = load i32, i32* %scale, align 4, !dbg !1075
  %sub68 = sub nsw i32 %28, %call67, !dbg !1075
  store i32 %sub68, i32* %scale, align 4, !dbg !1075
  br label %if.end69, !dbg !1076

if.end69:                                         ; preds = %if.then66, %if.end63
  br label %if.end70, !dbg !1077

if.end70:                                         ; preds = %if.end69, %lor.lhs.false
  %29 = load i64, i64* %aSignificand, align 8, !dbg !1078
  %or71 = or i64 %29, 4503599627370496, !dbg !1078
  store i64 %or71, i64* %aSignificand, align 8, !dbg !1078
  %30 = load i64, i64* %bSignificand, align 8, !dbg !1079
  %or72 = or i64 %30, 4503599627370496, !dbg !1079
  store i64 %or72, i64* %bSignificand, align 8, !dbg !1079
  %31 = load i32, i32* %aExponent, align 4, !dbg !1080
  %32 = load i32, i32* %bExponent, align 4, !dbg !1081
  %sub73 = sub i32 %31, %32, !dbg !1082
  %33 = load i32, i32* %scale, align 4, !dbg !1083
  %add74 = add i32 %sub73, %33, !dbg !1084
  store i32 %add74, i32* %quotientExponent, align 4, !dbg !1085
  %34 = load i64, i64* %bSignificand, align 8, !dbg !1086
  %shr75 = lshr i64 %34, 21, !dbg !1087
  %conv76 = trunc i64 %shr75 to i32, !dbg !1086
  store i32 %conv76, i32* %q31b, align 4, !dbg !1088
  %35 = load i32, i32* %q31b, align 4, !dbg !1089
  %sub77 = sub i32 1963258675, %35, !dbg !1090
  store i32 %sub77, i32* %recip32, align 4, !dbg !1091
  %36 = load i32, i32* %recip32, align 4, !dbg !1092
  %conv78 = zext i32 %36 to i64, !dbg !1093
  %37 = load i32, i32* %q31b, align 4, !dbg !1094
  %conv79 = zext i32 %37 to i64, !dbg !1094
  %mul = mul i64 %conv78, %conv79, !dbg !1095
  %shr80 = lshr i64 %mul, 32, !dbg !1096
  %sub81 = sub i64 0, %shr80, !dbg !1097
  %conv82 = trunc i64 %sub81 to i32, !dbg !1097
  store i32 %conv82, i32* %correction32, align 4, !dbg !1098
  %38 = load i32, i32* %recip32, align 4, !dbg !1099
  %conv83 = zext i32 %38 to i64, !dbg !1100
  %39 = load i32, i32* %correction32, align 4, !dbg !1101
  %conv84 = zext i32 %39 to i64, !dbg !1101
  %mul85 = mul i64 %conv83, %conv84, !dbg !1102
  %shr86 = lshr i64 %mul85, 31, !dbg !1103
  %conv87 = trunc i64 %shr86 to i32, !dbg !1100
  store i32 %conv87, i32* %recip32, align 4, !dbg !1104
  %40 = load i32, i32* %recip32, align 4, !dbg !1105
  %conv88 = zext i32 %40 to i64, !dbg !1106
  %41 = load i32, i32* %q31b, align 4, !dbg !1107
  %conv89 = zext i32 %41 to i64, !dbg !1107
  %mul90 = mul i64 %conv88, %conv89, !dbg !1108
  %shr91 = lshr i64 %mul90, 32, !dbg !1109
  %sub92 = sub i64 0, %shr91, !dbg !1110
  %conv93 = trunc i64 %sub92 to i32, !dbg !1110
  store i32 %conv93, i32* %correction32, align 4, !dbg !1111
  %42 = load i32, i32* %recip32, align 4, !dbg !1112
  %conv94 = zext i32 %42 to i64, !dbg !1113
  %43 = load i32, i32* %correction32, align 4, !dbg !1114
  %conv95 = zext i32 %43 to i64, !dbg !1114
  %mul96 = mul i64 %conv94, %conv95, !dbg !1115
  %shr97 = lshr i64 %mul96, 31, !dbg !1116
  %conv98 = trunc i64 %shr97 to i32, !dbg !1113
  store i32 %conv98, i32* %recip32, align 4, !dbg !1117
  %44 = load i32, i32* %recip32, align 4, !dbg !1118
  %conv99 = zext i32 %44 to i64, !dbg !1119
  %45 = load i32, i32* %q31b, align 4, !dbg !1120
  %conv100 = zext i32 %45 to i64, !dbg !1120
  %mul101 = mul i64 %conv99, %conv100, !dbg !1121
  %shr102 = lshr i64 %mul101, 32, !dbg !1122
  %sub103 = sub i64 0, %shr102, !dbg !1123
  %conv104 = trunc i64 %sub103 to i32, !dbg !1123
  store i32 %conv104, i32* %correction32, align 4, !dbg !1124
  %46 = load i32, i32* %recip32, align 4, !dbg !1125
  %conv105 = zext i32 %46 to i64, !dbg !1126
  %47 = load i32, i32* %correction32, align 4, !dbg !1127
  %conv106 = zext i32 %47 to i64, !dbg !1127
  %mul107 = mul i64 %conv105, %conv106, !dbg !1128
  %shr108 = lshr i64 %mul107, 31, !dbg !1129
  %conv109 = trunc i64 %shr108 to i32, !dbg !1126
  store i32 %conv109, i32* %recip32, align 4, !dbg !1130
  %48 = load i32, i32* %recip32, align 4, !dbg !1131
  %dec = add i32 %48, -1, !dbg !1131
  store i32 %dec, i32* %recip32, align 4, !dbg !1131
  %49 = load i64, i64* %bSignificand, align 8, !dbg !1132
  %shl = shl i64 %49, 11, !dbg !1133
  %conv110 = trunc i64 %shl to i32, !dbg !1132
  store i32 %conv110, i32* %q63blo, align 4, !dbg !1134
  %50 = load i32, i32* %recip32, align 4, !dbg !1135
  %conv111 = zext i32 %50 to i64, !dbg !1136
  %51 = load i32, i32* %q31b, align 4, !dbg !1137
  %conv112 = zext i32 %51 to i64, !dbg !1137
  %mul113 = mul i64 %conv111, %conv112, !dbg !1138
  %52 = load i32, i32* %recip32, align 4, !dbg !1139
  %conv114 = zext i32 %52 to i64, !dbg !1140
  %53 = load i32, i32* %q63blo, align 4, !dbg !1141
  %conv115 = zext i32 %53 to i64, !dbg !1141
  %mul116 = mul i64 %conv114, %conv115, !dbg !1142
  %shr117 = lshr i64 %mul116, 32, !dbg !1143
  %add118 = add i64 %mul113, %shr117, !dbg !1144
  %sub119 = sub i64 0, %add118, !dbg !1145
  store i64 %sub119, i64* %correction, align 8, !dbg !1146
  %54 = load i64, i64* %correction, align 8, !dbg !1147
  %shr120 = lshr i64 %54, 32, !dbg !1148
  %conv121 = trunc i64 %shr120 to i32, !dbg !1147
  store i32 %conv121, i32* %cHi, align 4, !dbg !1149
  %55 = load i64, i64* %correction, align 8, !dbg !1150
  %conv122 = trunc i64 %55 to i32, !dbg !1150
  store i32 %conv122, i32* %cLo, align 4, !dbg !1151
  %56 = load i32, i32* %recip32, align 4, !dbg !1152
  %conv123 = zext i32 %56 to i64, !dbg !1153
  %57 = load i32, i32* %cHi, align 4, !dbg !1154
  %conv124 = zext i32 %57 to i64, !dbg !1154
  %mul125 = mul i64 %conv123, %conv124, !dbg !1155
  %58 = load i32, i32* %recip32, align 4, !dbg !1156
  %conv126 = zext i32 %58 to i64, !dbg !1157
  %59 = load i32, i32* %cLo, align 4, !dbg !1158
  %conv127 = zext i32 %59 to i64, !dbg !1158
  %mul128 = mul i64 %conv126, %conv127, !dbg !1159
  %shr129 = lshr i64 %mul128, 32, !dbg !1160
  %add130 = add i64 %mul125, %shr129, !dbg !1161
  store i64 %add130, i64* %reciprocal, align 8, !dbg !1162
  %60 = load i64, i64* %reciprocal, align 8, !dbg !1163
  %sub131 = sub i64 %60, 2, !dbg !1163
  store i64 %sub131, i64* %reciprocal, align 8, !dbg !1163
  %61 = load i64, i64* %aSignificand, align 8, !dbg !1164
  %shl132 = shl i64 %61, 2, !dbg !1165
  %62 = load i64, i64* %reciprocal, align 8, !dbg !1166
  call void @wideMultiply(i64 %shl132, i64 %62, i64* %quotient, i64* %quotientLo) #4, !dbg !1167
  %63 = load i64, i64* %quotient, align 8, !dbg !1168
  %cmp133 = icmp ult i64 %63, 9007199254740992, !dbg !1169
  br i1 %cmp133, label %if.then135, label %if.else140, !dbg !1168

if.then135:                                       ; preds = %if.end70
  %64 = load i64, i64* %aSignificand, align 8, !dbg !1170
  %shl136 = shl i64 %64, 53, !dbg !1171
  %65 = load i64, i64* %quotient, align 8, !dbg !1172
  %66 = load i64, i64* %bSignificand, align 8, !dbg !1173
  %mul137 = mul i64 %65, %66, !dbg !1174
  %sub138 = sub i64 %shl136, %mul137, !dbg !1175
  store i64 %sub138, i64* %residual, align 8, !dbg !1176
  %67 = load i32, i32* %quotientExponent, align 4, !dbg !1177
  %dec139 = add nsw i32 %67, -1, !dbg !1177
  store i32 %dec139, i32* %quotientExponent, align 4, !dbg !1177
  br label %if.end145, !dbg !1178

if.else140:                                       ; preds = %if.end70
  %68 = load i64, i64* %quotient, align 8, !dbg !1179
  %shr141 = lshr i64 %68, 1, !dbg !1179
  store i64 %shr141, i64* %quotient, align 8, !dbg !1179
  %69 = load i64, i64* %aSignificand, align 8, !dbg !1180
  %shl142 = shl i64 %69, 52, !dbg !1181
  %70 = load i64, i64* %quotient, align 8, !dbg !1182
  %71 = load i64, i64* %bSignificand, align 8, !dbg !1183
  %mul143 = mul i64 %70, %71, !dbg !1184
  %sub144 = sub i64 %shl142, %mul143, !dbg !1185
  store i64 %sub144, i64* %residual, align 8, !dbg !1186
  br label %if.end145

if.end145:                                        ; preds = %if.else140, %if.then135
  %72 = load i32, i32* %quotientExponent, align 4, !dbg !1187
  %add146 = add nsw i32 %72, 1023, !dbg !1188
  store i32 %add146, i32* %writtenExponent, align 4, !dbg !1189
  %73 = load i32, i32* %writtenExponent, align 4, !dbg !1190
  %cmp147 = icmp sge i32 %73, 2047, !dbg !1191
  br i1 %cmp147, label %if.then149, label %if.else152, !dbg !1190

if.then149:                                       ; preds = %if.end145
  %74 = load i64, i64* %quotientSign, align 8, !dbg !1192
  %or150 = or i64 9218868437227405312, %74, !dbg !1193
  %call151 = call double @fromRep.9(i64 %or150) #4, !dbg !1194
  store double %call151, double* %retval, align 8, !dbg !1195
  br label %return, !dbg !1195

if.else152:                                       ; preds = %if.end145
  %75 = load i32, i32* %writtenExponent, align 4, !dbg !1196
  %cmp153 = icmp slt i32 %75, 1, !dbg !1197
  br i1 %cmp153, label %if.then155, label %if.else157, !dbg !1196

if.then155:                                       ; preds = %if.else152
  %76 = load i64, i64* %quotientSign, align 8, !dbg !1198
  %call156 = call double @fromRep.9(i64 %76) #4, !dbg !1199
  store double %call156, double* %retval, align 8, !dbg !1200
  br label %return, !dbg !1200

if.else157:                                       ; preds = %if.else152
  %77 = load i64, i64* %residual, align 8, !dbg !1201
  %shl158 = shl i64 %77, 1, !dbg !1202
  %78 = load i64, i64* %bSignificand, align 8, !dbg !1203
  %cmp159 = icmp ugt i64 %shl158, %78, !dbg !1204
  %frombool = zext i1 %cmp159 to i8, !dbg !1205
  store i8 %frombool, i8* %round, align 1, !dbg !1205
  %79 = load i64, i64* %quotient, align 8, !dbg !1206
  %and161 = and i64 %79, 4503599627370495, !dbg !1207
  store i64 %and161, i64* %absResult, align 8, !dbg !1208
  %80 = load i32, i32* %writtenExponent, align 4, !dbg !1209
  %conv162 = sext i32 %80 to i64, !dbg !1210
  %shl163 = shl i64 %conv162, 52, !dbg !1211
  %81 = load i64, i64* %absResult, align 8, !dbg !1212
  %or164 = or i64 %81, %shl163, !dbg !1212
  store i64 %or164, i64* %absResult, align 8, !dbg !1212
  %82 = load i8, i8* %round, align 1, !dbg !1213
  %tobool165 = trunc i8 %82 to i1, !dbg !1213
  %conv166 = zext i1 %tobool165 to i64, !dbg !1213
  %83 = load i64, i64* %absResult, align 8, !dbg !1214
  %add167 = add i64 %83, %conv166, !dbg !1214
  store i64 %add167, i64* %absResult, align 8, !dbg !1214
  %84 = load i64, i64* %absResult, align 8, !dbg !1215
  %85 = load i64, i64* %quotientSign, align 8, !dbg !1216
  %or168 = or i64 %84, %85, !dbg !1217
  %call169 = call double @fromRep.9(i64 %or168) #4, !dbg !1218
  store double %call169, double* %result, align 8, !dbg !1219
  %86 = load double, double* %result, align 8, !dbg !1220
  store double %86, double* %retval, align 8, !dbg !1221
  br label %return, !dbg !1221

return:                                           ; preds = %if.else157, %if.then155, %if.then149, %if.then55, %if.else51, %if.then49, %if.then44, %if.else, %if.then37, %if.then27, %if.then22
  %87 = load double, double* %retval, align 8, !dbg !1222
  ret double %87, !dbg !1222
}

; Function Attrs: noinline nounwind
define internal i64 @toRep.8(double %x) #0 !dbg !1223 {
entry:
  %x.addr = alloca double, align 8
  %rep = alloca %union.anon.0, align 8
  store double %x, double* %x.addr, align 8
  %f = bitcast %union.anon.0* %rep to double*, !dbg !1224
  %0 = load double, double* %x.addr, align 8, !dbg !1225
  store double %0, double* %f, align 8, !dbg !1224
  %i = bitcast %union.anon.0* %rep to i64*, !dbg !1226
  %1 = load i64, i64* %i, align 8, !dbg !1226
  ret i64 %1, !dbg !1227
}

; Function Attrs: noinline nounwind
define internal double @fromRep.9(i64 %x) #0 !dbg !1228 {
entry:
  %x.addr = alloca i64, align 8
  %rep = alloca %union.anon.0, align 8
  store i64 %x, i64* %x.addr, align 8
  %i = bitcast %union.anon.0* %rep to i64*, !dbg !1229
  %0 = load i64, i64* %x.addr, align 8, !dbg !1230
  store i64 %0, i64* %i, align 8, !dbg !1229
  %f = bitcast %union.anon.0* %rep to double*, !dbg !1231
  %1 = load double, double* %f, align 8, !dbg !1231
  ret double %1, !dbg !1232
}

; Function Attrs: noinline nounwind
define internal i32 @normalize.10(i64* %significand) #0 !dbg !1233 {
entry:
  %significand.addr = alloca i64*, align 4
  %shift = alloca i32, align 4
  store i64* %significand, i64** %significand.addr, align 4
  %0 = load i64*, i64** %significand.addr, align 4, !dbg !1234
  %1 = load i64, i64* %0, align 8, !dbg !1235
  %call = call i32 @rep_clz.11(i64 %1) #4, !dbg !1236
  %call1 = call i32 @rep_clz.11(i64 4503599627370496) #4, !dbg !1237
  %sub = sub nsw i32 %call, %call1, !dbg !1238
  store i32 %sub, i32* %shift, align 4, !dbg !1239
  %2 = load i32, i32* %shift, align 4, !dbg !1240
  %3 = load i64*, i64** %significand.addr, align 4, !dbg !1241
  %4 = load i64, i64* %3, align 8, !dbg !1242
  %sh_prom = zext i32 %2 to i64, !dbg !1242
  %shl = shl i64 %4, %sh_prom, !dbg !1242
  store i64 %shl, i64* %3, align 8, !dbg !1242
  %5 = load i32, i32* %shift, align 4, !dbg !1243
  %sub2 = sub nsw i32 1, %5, !dbg !1244
  ret i32 %sub2, !dbg !1245
}

; Function Attrs: noinline nounwind
define internal void @wideMultiply(i64 %a, i64 %b, i64* %hi, i64* %lo) #0 !dbg !1246 {
entry:
  %a.addr = alloca i64, align 8
  %b.addr = alloca i64, align 8
  %hi.addr = alloca i64*, align 4
  %lo.addr = alloca i64*, align 4
  %plolo = alloca i64, align 8
  %plohi = alloca i64, align 8
  %philo = alloca i64, align 8
  %phihi = alloca i64, align 8
  %r0 = alloca i64, align 8
  %r1 = alloca i64, align 8
  store i64 %a, i64* %a.addr, align 8
  store i64 %b, i64* %b.addr, align 8
  store i64* %hi, i64** %hi.addr, align 4
  store i64* %lo, i64** %lo.addr, align 4
  %0 = load i64, i64* %a.addr, align 8, !dbg !1247
  %and = and i64 %0, 4294967295, !dbg !1247
  %1 = load i64, i64* %b.addr, align 8, !dbg !1248
  %and1 = and i64 %1, 4294967295, !dbg !1248
  %mul = mul i64 %and, %and1, !dbg !1249
  store i64 %mul, i64* %plolo, align 8, !dbg !1250
  %2 = load i64, i64* %a.addr, align 8, !dbg !1251
  %and2 = and i64 %2, 4294967295, !dbg !1251
  %3 = load i64, i64* %b.addr, align 8, !dbg !1252
  %shr = lshr i64 %3, 32, !dbg !1252
  %mul3 = mul i64 %and2, %shr, !dbg !1253
  store i64 %mul3, i64* %plohi, align 8, !dbg !1254
  %4 = load i64, i64* %a.addr, align 8, !dbg !1255
  %shr4 = lshr i64 %4, 32, !dbg !1255
  %5 = load i64, i64* %b.addr, align 8, !dbg !1256
  %and5 = and i64 %5, 4294967295, !dbg !1256
  %mul6 = mul i64 %shr4, %and5, !dbg !1257
  store i64 %mul6, i64* %philo, align 8, !dbg !1258
  %6 = load i64, i64* %a.addr, align 8, !dbg !1259
  %shr7 = lshr i64 %6, 32, !dbg !1259
  %7 = load i64, i64* %b.addr, align 8, !dbg !1260
  %shr8 = lshr i64 %7, 32, !dbg !1260
  %mul9 = mul i64 %shr7, %shr8, !dbg !1261
  store i64 %mul9, i64* %phihi, align 8, !dbg !1262
  %8 = load i64, i64* %plolo, align 8, !dbg !1263
  %and10 = and i64 %8, 4294967295, !dbg !1263
  store i64 %and10, i64* %r0, align 8, !dbg !1264
  %9 = load i64, i64* %plolo, align 8, !dbg !1265
  %shr11 = lshr i64 %9, 32, !dbg !1265
  %10 = load i64, i64* %plohi, align 8, !dbg !1266
  %and12 = and i64 %10, 4294967295, !dbg !1266
  %add = add i64 %shr11, %and12, !dbg !1267
  %11 = load i64, i64* %philo, align 8, !dbg !1268
  %and13 = and i64 %11, 4294967295, !dbg !1268
  %add14 = add i64 %add, %and13, !dbg !1269
  store i64 %add14, i64* %r1, align 8, !dbg !1270
  %12 = load i64, i64* %r0, align 8, !dbg !1271
  %13 = load i64, i64* %r1, align 8, !dbg !1272
  %shl = shl i64 %13, 32, !dbg !1273
  %add15 = add i64 %12, %shl, !dbg !1274
  %14 = load i64*, i64** %lo.addr, align 4, !dbg !1275
  store i64 %add15, i64* %14, align 8, !dbg !1276
  %15 = load i64, i64* %plohi, align 8, !dbg !1277
  %shr16 = lshr i64 %15, 32, !dbg !1277
  %16 = load i64, i64* %philo, align 8, !dbg !1278
  %shr17 = lshr i64 %16, 32, !dbg !1278
  %add18 = add i64 %shr16, %shr17, !dbg !1279
  %17 = load i64, i64* %r1, align 8, !dbg !1280
  %shr19 = lshr i64 %17, 32, !dbg !1280
  %add20 = add i64 %add18, %shr19, !dbg !1281
  %18 = load i64, i64* %phihi, align 8, !dbg !1282
  %add21 = add i64 %add20, %18, !dbg !1283
  %19 = load i64*, i64** %hi.addr, align 4, !dbg !1284
  store i64 %add21, i64* %19, align 8, !dbg !1285
  ret void, !dbg !1286
}

; Function Attrs: noinline nounwind
define internal i32 @rep_clz.11(i64 %a) #0 !dbg !1287 {
entry:
  %retval = alloca i32, align 4
  %a.addr = alloca i64, align 8
  store i64 %a, i64* %a.addr, align 8
  %0 = load i64, i64* %a.addr, align 8, !dbg !1288
  %and = and i64 %0, -4294967296, !dbg !1289
  %tobool = icmp ne i64 %and, 0, !dbg !1289
  br i1 %tobool, label %if.then, label %if.else, !dbg !1288

if.then:                                          ; preds = %entry
  %1 = load i64, i64* %a.addr, align 8, !dbg !1290
  %shr = lshr i64 %1, 32, !dbg !1291
  %conv = trunc i64 %shr to i32, !dbg !1290
  %2 = call i32 @llvm.ctlz.i32(i32 %conv, i1 true), !dbg !1292
  store i32 %2, i32* %retval, align 4, !dbg !1293
  br label %return, !dbg !1293

if.else:                                          ; preds = %entry
  %3 = load i64, i64* %a.addr, align 8, !dbg !1294
  %and1 = and i64 %3, 4294967295, !dbg !1295
  %conv2 = trunc i64 %and1 to i32, !dbg !1294
  %4 = call i32 @llvm.ctlz.i32(i32 %conv2, i1 true), !dbg !1296
  %add = add nsw i32 32, %4, !dbg !1297
  store i32 %add, i32* %retval, align 4, !dbg !1298
  br label %return, !dbg !1298

return:                                           ; preds = %if.else, %if.then
  %5 = load i32, i32* %retval, align 4, !dbg !1299
  ret i32 %5, !dbg !1299
}

; Function Attrs: noinline nounwind
define dso_local float @__divsf3(float %a, float %b) #0 !dbg !1300 {
entry:
  %retval = alloca float, align 4
  %a.addr = alloca float, align 4
  %b.addr = alloca float, align 4
  %aExponent = alloca i32, align 4
  %bExponent = alloca i32, align 4
  %quotientSign = alloca i32, align 4
  %aSignificand = alloca i32, align 4
  %bSignificand = alloca i32, align 4
  %scale = alloca i32, align 4
  %aAbs = alloca i32, align 4
  %bAbs = alloca i32, align 4
  %quotientExponent = alloca i32, align 4
  %q31b = alloca i32, align 4
  %reciprocal = alloca i32, align 4
  %correction = alloca i32, align 4
  %quotient = alloca i32, align 4
  %residual = alloca i32, align 4
  %writtenExponent = alloca i32, align 4
  %round = alloca i8, align 1
  %absResult = alloca i32, align 4
  store float %a, float* %a.addr, align 4
  store float %b, float* %b.addr, align 4
  %0 = load float, float* %a.addr, align 4, !dbg !1301
  %call = call i32 @toRep.12(float %0) #4, !dbg !1302
  %shr = lshr i32 %call, 23, !dbg !1303
  %and = and i32 %shr, 255, !dbg !1304
  store i32 %and, i32* %aExponent, align 4, !dbg !1305
  %1 = load float, float* %b.addr, align 4, !dbg !1306
  %call1 = call i32 @toRep.12(float %1) #4, !dbg !1307
  %shr2 = lshr i32 %call1, 23, !dbg !1308
  %and3 = and i32 %shr2, 255, !dbg !1309
  store i32 %and3, i32* %bExponent, align 4, !dbg !1310
  %2 = load float, float* %a.addr, align 4, !dbg !1311
  %call4 = call i32 @toRep.12(float %2) #4, !dbg !1312
  %3 = load float, float* %b.addr, align 4, !dbg !1313
  %call5 = call i32 @toRep.12(float %3) #4, !dbg !1314
  %xor = xor i32 %call4, %call5, !dbg !1315
  %and6 = and i32 %xor, -2147483648, !dbg !1316
  store i32 %and6, i32* %quotientSign, align 4, !dbg !1317
  %4 = load float, float* %a.addr, align 4, !dbg !1318
  %call7 = call i32 @toRep.12(float %4) #4, !dbg !1319
  %and8 = and i32 %call7, 8388607, !dbg !1320
  store i32 %and8, i32* %aSignificand, align 4, !dbg !1321
  %5 = load float, float* %b.addr, align 4, !dbg !1322
  %call9 = call i32 @toRep.12(float %5) #4, !dbg !1323
  %and10 = and i32 %call9, 8388607, !dbg !1324
  store i32 %and10, i32* %bSignificand, align 4, !dbg !1325
  store i32 0, i32* %scale, align 4, !dbg !1326
  %6 = load i32, i32* %aExponent, align 4, !dbg !1327
  %sub = sub i32 %6, 1, !dbg !1328
  %cmp = icmp uge i32 %sub, 254, !dbg !1329
  br i1 %cmp, label %if.then, label %lor.lhs.false, !dbg !1330

lor.lhs.false:                                    ; preds = %entry
  %7 = load i32, i32* %bExponent, align 4, !dbg !1331
  %sub11 = sub i32 %7, 1, !dbg !1332
  %cmp12 = icmp uge i32 %sub11, 254, !dbg !1333
  br i1 %cmp12, label %if.then, label %if.end60, !dbg !1327

if.then:                                          ; preds = %lor.lhs.false, %entry
  %8 = load float, float* %a.addr, align 4, !dbg !1334
  %call13 = call i32 @toRep.12(float %8) #4, !dbg !1335
  %and14 = and i32 %call13, 2147483647, !dbg !1336
  store i32 %and14, i32* %aAbs, align 4, !dbg !1337
  %9 = load float, float* %b.addr, align 4, !dbg !1338
  %call15 = call i32 @toRep.12(float %9) #4, !dbg !1339
  %and16 = and i32 %call15, 2147483647, !dbg !1340
  store i32 %and16, i32* %bAbs, align 4, !dbg !1341
  %10 = load i32, i32* %aAbs, align 4, !dbg !1342
  %cmp17 = icmp ugt i32 %10, 2139095040, !dbg !1343
  br i1 %cmp17, label %if.then18, label %if.end, !dbg !1342

if.then18:                                        ; preds = %if.then
  %11 = load float, float* %a.addr, align 4, !dbg !1344
  %call19 = call i32 @toRep.12(float %11) #4, !dbg !1345
  %or = or i32 %call19, 4194304, !dbg !1346
  %call20 = call float @fromRep.13(i32 %or) #4, !dbg !1347
  store float %call20, float* %retval, align 4, !dbg !1348
  br label %return, !dbg !1348

if.end:                                           ; preds = %if.then
  %12 = load i32, i32* %bAbs, align 4, !dbg !1349
  %cmp21 = icmp ugt i32 %12, 2139095040, !dbg !1350
  br i1 %cmp21, label %if.then22, label %if.end26, !dbg !1349

if.then22:                                        ; preds = %if.end
  %13 = load float, float* %b.addr, align 4, !dbg !1351
  %call23 = call i32 @toRep.12(float %13) #4, !dbg !1352
  %or24 = or i32 %call23, 4194304, !dbg !1353
  %call25 = call float @fromRep.13(i32 %or24) #4, !dbg !1354
  store float %call25, float* %retval, align 4, !dbg !1355
  br label %return, !dbg !1355

if.end26:                                         ; preds = %if.end
  %14 = load i32, i32* %aAbs, align 4, !dbg !1356
  %cmp27 = icmp eq i32 %14, 2139095040, !dbg !1357
  br i1 %cmp27, label %if.then28, label %if.end34, !dbg !1356

if.then28:                                        ; preds = %if.end26
  %15 = load i32, i32* %bAbs, align 4, !dbg !1358
  %cmp29 = icmp eq i32 %15, 2139095040, !dbg !1359
  br i1 %cmp29, label %if.then30, label %if.else, !dbg !1358

if.then30:                                        ; preds = %if.then28
  %call31 = call float @fromRep.13(i32 2143289344) #4, !dbg !1360
  store float %call31, float* %retval, align 4, !dbg !1361
  br label %return, !dbg !1361

if.else:                                          ; preds = %if.then28
  %16 = load i32, i32* %aAbs, align 4, !dbg !1362
  %17 = load i32, i32* %quotientSign, align 4, !dbg !1363
  %or32 = or i32 %16, %17, !dbg !1364
  %call33 = call float @fromRep.13(i32 %or32) #4, !dbg !1365
  store float %call33, float* %retval, align 4, !dbg !1366
  br label %return, !dbg !1366

if.end34:                                         ; preds = %if.end26
  %18 = load i32, i32* %bAbs, align 4, !dbg !1367
  %cmp35 = icmp eq i32 %18, 2139095040, !dbg !1368
  br i1 %cmp35, label %if.then36, label %if.end38, !dbg !1367

if.then36:                                        ; preds = %if.end34
  %19 = load i32, i32* %quotientSign, align 4, !dbg !1369
  %call37 = call float @fromRep.13(i32 %19) #4, !dbg !1370
  store float %call37, float* %retval, align 4, !dbg !1371
  br label %return, !dbg !1371

if.end38:                                         ; preds = %if.end34
  %20 = load i32, i32* %aAbs, align 4, !dbg !1372
  %tobool = icmp ne i32 %20, 0, !dbg !1372
  br i1 %tobool, label %if.end45, label %if.then39, !dbg !1373

if.then39:                                        ; preds = %if.end38
  %21 = load i32, i32* %bAbs, align 4, !dbg !1374
  %tobool40 = icmp ne i32 %21, 0, !dbg !1374
  br i1 %tobool40, label %if.else43, label %if.then41, !dbg !1375

if.then41:                                        ; preds = %if.then39
  %call42 = call float @fromRep.13(i32 2143289344) #4, !dbg !1376
  store float %call42, float* %retval, align 4, !dbg !1377
  br label %return, !dbg !1377

if.else43:                                        ; preds = %if.then39
  %22 = load i32, i32* %quotientSign, align 4, !dbg !1378
  %call44 = call float @fromRep.13(i32 %22) #4, !dbg !1379
  store float %call44, float* %retval, align 4, !dbg !1380
  br label %return, !dbg !1380

if.end45:                                         ; preds = %if.end38
  %23 = load i32, i32* %bAbs, align 4, !dbg !1381
  %tobool46 = icmp ne i32 %23, 0, !dbg !1381
  br i1 %tobool46, label %if.end50, label %if.then47, !dbg !1382

if.then47:                                        ; preds = %if.end45
  %24 = load i32, i32* %quotientSign, align 4, !dbg !1383
  %or48 = or i32 2139095040, %24, !dbg !1384
  %call49 = call float @fromRep.13(i32 %or48) #4, !dbg !1385
  store float %call49, float* %retval, align 4, !dbg !1386
  br label %return, !dbg !1386

if.end50:                                         ; preds = %if.end45
  %25 = load i32, i32* %aAbs, align 4, !dbg !1387
  %cmp51 = icmp ult i32 %25, 8388608, !dbg !1388
  br i1 %cmp51, label %if.then52, label %if.end54, !dbg !1387

if.then52:                                        ; preds = %if.end50
  %call53 = call i32 @normalize.14(i32* %aSignificand) #4, !dbg !1389
  %26 = load i32, i32* %scale, align 4, !dbg !1390
  %add = add nsw i32 %26, %call53, !dbg !1390
  store i32 %add, i32* %scale, align 4, !dbg !1390
  br label %if.end54, !dbg !1391

if.end54:                                         ; preds = %if.then52, %if.end50
  %27 = load i32, i32* %bAbs, align 4, !dbg !1392
  %cmp55 = icmp ult i32 %27, 8388608, !dbg !1393
  br i1 %cmp55, label %if.then56, label %if.end59, !dbg !1392

if.then56:                                        ; preds = %if.end54
  %call57 = call i32 @normalize.14(i32* %bSignificand) #4, !dbg !1394
  %28 = load i32, i32* %scale, align 4, !dbg !1395
  %sub58 = sub nsw i32 %28, %call57, !dbg !1395
  store i32 %sub58, i32* %scale, align 4, !dbg !1395
  br label %if.end59, !dbg !1396

if.end59:                                         ; preds = %if.then56, %if.end54
  br label %if.end60, !dbg !1397

if.end60:                                         ; preds = %if.end59, %lor.lhs.false
  %29 = load i32, i32* %aSignificand, align 4, !dbg !1398
  %or61 = or i32 %29, 8388608, !dbg !1398
  store i32 %or61, i32* %aSignificand, align 4, !dbg !1398
  %30 = load i32, i32* %bSignificand, align 4, !dbg !1399
  %or62 = or i32 %30, 8388608, !dbg !1399
  store i32 %or62, i32* %bSignificand, align 4, !dbg !1399
  %31 = load i32, i32* %aExponent, align 4, !dbg !1400
  %32 = load i32, i32* %bExponent, align 4, !dbg !1401
  %sub63 = sub i32 %31, %32, !dbg !1402
  %33 = load i32, i32* %scale, align 4, !dbg !1403
  %add64 = add i32 %sub63, %33, !dbg !1404
  store i32 %add64, i32* %quotientExponent, align 4, !dbg !1405
  %34 = load i32, i32* %bSignificand, align 4, !dbg !1406
  %shl = shl i32 %34, 8, !dbg !1407
  store i32 %shl, i32* %q31b, align 4, !dbg !1408
  %35 = load i32, i32* %q31b, align 4, !dbg !1409
  %sub65 = sub i32 1963258675, %35, !dbg !1410
  store i32 %sub65, i32* %reciprocal, align 4, !dbg !1411
  %36 = load i32, i32* %reciprocal, align 4, !dbg !1412
  %conv = zext i32 %36 to i64, !dbg !1413
  %37 = load i32, i32* %q31b, align 4, !dbg !1414
  %conv66 = zext i32 %37 to i64, !dbg !1414
  %mul = mul i64 %conv, %conv66, !dbg !1415
  %shr67 = lshr i64 %mul, 32, !dbg !1416
  %sub68 = sub i64 0, %shr67, !dbg !1417
  %conv69 = trunc i64 %sub68 to i32, !dbg !1417
  store i32 %conv69, i32* %correction, align 4, !dbg !1418
  %38 = load i32, i32* %reciprocal, align 4, !dbg !1419
  %conv70 = zext i32 %38 to i64, !dbg !1420
  %39 = load i32, i32* %correction, align 4, !dbg !1421
  %conv71 = zext i32 %39 to i64, !dbg !1421
  %mul72 = mul i64 %conv70, %conv71, !dbg !1422
  %shr73 = lshr i64 %mul72, 31, !dbg !1423
  %conv74 = trunc i64 %shr73 to i32, !dbg !1420
  store i32 %conv74, i32* %reciprocal, align 4, !dbg !1424
  %40 = load i32, i32* %reciprocal, align 4, !dbg !1425
  %conv75 = zext i32 %40 to i64, !dbg !1426
  %41 = load i32, i32* %q31b, align 4, !dbg !1427
  %conv76 = zext i32 %41 to i64, !dbg !1427
  %mul77 = mul i64 %conv75, %conv76, !dbg !1428
  %shr78 = lshr i64 %mul77, 32, !dbg !1429
  %sub79 = sub i64 0, %shr78, !dbg !1430
  %conv80 = trunc i64 %sub79 to i32, !dbg !1430
  store i32 %conv80, i32* %correction, align 4, !dbg !1431
  %42 = load i32, i32* %reciprocal, align 4, !dbg !1432
  %conv81 = zext i32 %42 to i64, !dbg !1433
  %43 = load i32, i32* %correction, align 4, !dbg !1434
  %conv82 = zext i32 %43 to i64, !dbg !1434
  %mul83 = mul i64 %conv81, %conv82, !dbg !1435
  %shr84 = lshr i64 %mul83, 31, !dbg !1436
  %conv85 = trunc i64 %shr84 to i32, !dbg !1433
  store i32 %conv85, i32* %reciprocal, align 4, !dbg !1437
  %44 = load i32, i32* %reciprocal, align 4, !dbg !1438
  %conv86 = zext i32 %44 to i64, !dbg !1439
  %45 = load i32, i32* %q31b, align 4, !dbg !1440
  %conv87 = zext i32 %45 to i64, !dbg !1440
  %mul88 = mul i64 %conv86, %conv87, !dbg !1441
  %shr89 = lshr i64 %mul88, 32, !dbg !1442
  %sub90 = sub i64 0, %shr89, !dbg !1443
  %conv91 = trunc i64 %sub90 to i32, !dbg !1443
  store i32 %conv91, i32* %correction, align 4, !dbg !1444
  %46 = load i32, i32* %reciprocal, align 4, !dbg !1445
  %conv92 = zext i32 %46 to i64, !dbg !1446
  %47 = load i32, i32* %correction, align 4, !dbg !1447
  %conv93 = zext i32 %47 to i64, !dbg !1447
  %mul94 = mul i64 %conv92, %conv93, !dbg !1448
  %shr95 = lshr i64 %mul94, 31, !dbg !1449
  %conv96 = trunc i64 %shr95 to i32, !dbg !1446
  store i32 %conv96, i32* %reciprocal, align 4, !dbg !1450
  %48 = load i32, i32* %reciprocal, align 4, !dbg !1451
  %sub97 = sub i32 %48, 2, !dbg !1451
  store i32 %sub97, i32* %reciprocal, align 4, !dbg !1451
  %49 = load i32, i32* %reciprocal, align 4, !dbg !1452
  %conv98 = zext i32 %49 to i64, !dbg !1453
  %50 = load i32, i32* %aSignificand, align 4, !dbg !1454
  %shl99 = shl i32 %50, 1, !dbg !1455
  %conv100 = zext i32 %shl99 to i64, !dbg !1456
  %mul101 = mul i64 %conv98, %conv100, !dbg !1457
  %shr102 = lshr i64 %mul101, 32, !dbg !1458
  %conv103 = trunc i64 %shr102 to i32, !dbg !1453
  store i32 %conv103, i32* %quotient, align 4, !dbg !1459
  %51 = load i32, i32* %quotient, align 4, !dbg !1460
  %cmp104 = icmp ult i32 %51, 16777216, !dbg !1461
  br i1 %cmp104, label %if.then106, label %if.else110, !dbg !1460

if.then106:                                       ; preds = %if.end60
  %52 = load i32, i32* %aSignificand, align 4, !dbg !1462
  %shl107 = shl i32 %52, 24, !dbg !1463
  %53 = load i32, i32* %quotient, align 4, !dbg !1464
  %54 = load i32, i32* %bSignificand, align 4, !dbg !1465
  %mul108 = mul i32 %53, %54, !dbg !1466
  %sub109 = sub i32 %shl107, %mul108, !dbg !1467
  store i32 %sub109, i32* %residual, align 4, !dbg !1468
  %55 = load i32, i32* %quotientExponent, align 4, !dbg !1469
  %dec = add nsw i32 %55, -1, !dbg !1469
  store i32 %dec, i32* %quotientExponent, align 4, !dbg !1469
  br label %if.end115, !dbg !1470

if.else110:                                       ; preds = %if.end60
  %56 = load i32, i32* %quotient, align 4, !dbg !1471
  %shr111 = lshr i32 %56, 1, !dbg !1471
  store i32 %shr111, i32* %quotient, align 4, !dbg !1471
  %57 = load i32, i32* %aSignificand, align 4, !dbg !1472
  %shl112 = shl i32 %57, 23, !dbg !1473
  %58 = load i32, i32* %quotient, align 4, !dbg !1474
  %59 = load i32, i32* %bSignificand, align 4, !dbg !1475
  %mul113 = mul i32 %58, %59, !dbg !1476
  %sub114 = sub i32 %shl112, %mul113, !dbg !1477
  store i32 %sub114, i32* %residual, align 4, !dbg !1478
  br label %if.end115

if.end115:                                        ; preds = %if.else110, %if.then106
  %60 = load i32, i32* %quotientExponent, align 4, !dbg !1479
  %add116 = add nsw i32 %60, 127, !dbg !1480
  store i32 %add116, i32* %writtenExponent, align 4, !dbg !1481
  %61 = load i32, i32* %writtenExponent, align 4, !dbg !1482
  %cmp117 = icmp sge i32 %61, 255, !dbg !1483
  br i1 %cmp117, label %if.then119, label %if.else122, !dbg !1482

if.then119:                                       ; preds = %if.end115
  %62 = load i32, i32* %quotientSign, align 4, !dbg !1484
  %or120 = or i32 2139095040, %62, !dbg !1485
  %call121 = call float @fromRep.13(i32 %or120) #4, !dbg !1486
  store float %call121, float* %retval, align 4, !dbg !1487
  br label %return, !dbg !1487

if.else122:                                       ; preds = %if.end115
  %63 = load i32, i32* %writtenExponent, align 4, !dbg !1488
  %cmp123 = icmp slt i32 %63, 1, !dbg !1489
  br i1 %cmp123, label %if.then125, label %if.else127, !dbg !1488

if.then125:                                       ; preds = %if.else122
  %64 = load i32, i32* %quotientSign, align 4, !dbg !1490
  %call126 = call float @fromRep.13(i32 %64) #4, !dbg !1491
  store float %call126, float* %retval, align 4, !dbg !1492
  br label %return, !dbg !1492

if.else127:                                       ; preds = %if.else122
  %65 = load i32, i32* %residual, align 4, !dbg !1493
  %shl128 = shl i32 %65, 1, !dbg !1494
  %66 = load i32, i32* %bSignificand, align 4, !dbg !1495
  %cmp129 = icmp ugt i32 %shl128, %66, !dbg !1496
  %frombool = zext i1 %cmp129 to i8, !dbg !1497
  store i8 %frombool, i8* %round, align 1, !dbg !1497
  %67 = load i32, i32* %quotient, align 4, !dbg !1498
  %and131 = and i32 %67, 8388607, !dbg !1499
  store i32 %and131, i32* %absResult, align 4, !dbg !1500
  %68 = load i32, i32* %writtenExponent, align 4, !dbg !1501
  %shl132 = shl i32 %68, 23, !dbg !1502
  %69 = load i32, i32* %absResult, align 4, !dbg !1503
  %or133 = or i32 %69, %shl132, !dbg !1503
  store i32 %or133, i32* %absResult, align 4, !dbg !1503
  %70 = load i8, i8* %round, align 1, !dbg !1504
  %tobool134 = trunc i8 %70 to i1, !dbg !1504
  %conv135 = zext i1 %tobool134 to i32, !dbg !1504
  %71 = load i32, i32* %absResult, align 4, !dbg !1505
  %add136 = add i32 %71, %conv135, !dbg !1505
  store i32 %add136, i32* %absResult, align 4, !dbg !1505
  %72 = load i32, i32* %absResult, align 4, !dbg !1506
  %73 = load i32, i32* %quotientSign, align 4, !dbg !1507
  %or137 = or i32 %72, %73, !dbg !1508
  %call138 = call float @fromRep.13(i32 %or137) #4, !dbg !1509
  store float %call138, float* %retval, align 4, !dbg !1510
  br label %return, !dbg !1510

return:                                           ; preds = %if.else127, %if.then125, %if.then119, %if.then47, %if.else43, %if.then41, %if.then36, %if.else, %if.then30, %if.then22, %if.then18
  %74 = load float, float* %retval, align 4, !dbg !1511
  ret float %74, !dbg !1511
}

; Function Attrs: noinline nounwind
define internal i32 @toRep.12(float %x) #0 !dbg !1512 {
entry:
  %x.addr = alloca float, align 4
  %rep = alloca %union.anon.0.0, align 4
  store float %x, float* %x.addr, align 4
  %f = bitcast %union.anon.0.0* %rep to float*, !dbg !1513
  %0 = load float, float* %x.addr, align 4, !dbg !1514
  store float %0, float* %f, align 4, !dbg !1513
  %i = bitcast %union.anon.0.0* %rep to i32*, !dbg !1515
  %1 = load i32, i32* %i, align 4, !dbg !1515
  ret i32 %1, !dbg !1516
}

; Function Attrs: noinline nounwind
define internal float @fromRep.13(i32 %x) #0 !dbg !1517 {
entry:
  %x.addr = alloca i32, align 4
  %rep = alloca %union.anon.0.0, align 4
  store i32 %x, i32* %x.addr, align 4
  %i = bitcast %union.anon.0.0* %rep to i32*, !dbg !1518
  %0 = load i32, i32* %x.addr, align 4, !dbg !1519
  store i32 %0, i32* %i, align 4, !dbg !1518
  %f = bitcast %union.anon.0.0* %rep to float*, !dbg !1520
  %1 = load float, float* %f, align 4, !dbg !1520
  ret float %1, !dbg !1521
}

; Function Attrs: noinline nounwind
define internal i32 @normalize.14(i32* %significand) #0 !dbg !1522 {
entry:
  %significand.addr = alloca i32*, align 4
  %shift = alloca i32, align 4
  store i32* %significand, i32** %significand.addr, align 4
  %0 = load i32*, i32** %significand.addr, align 4, !dbg !1523
  %1 = load i32, i32* %0, align 4, !dbg !1524
  %call = call i32 @rep_clz.15(i32 %1) #4, !dbg !1525
  %call1 = call i32 @rep_clz.15(i32 8388608) #4, !dbg !1526
  %sub = sub nsw i32 %call, %call1, !dbg !1527
  store i32 %sub, i32* %shift, align 4, !dbg !1528
  %2 = load i32, i32* %shift, align 4, !dbg !1529
  %3 = load i32*, i32** %significand.addr, align 4, !dbg !1530
  %4 = load i32, i32* %3, align 4, !dbg !1531
  %shl = shl i32 %4, %2, !dbg !1531
  store i32 %shl, i32* %3, align 4, !dbg !1531
  %5 = load i32, i32* %shift, align 4, !dbg !1532
  %sub2 = sub nsw i32 1, %5, !dbg !1533
  ret i32 %sub2, !dbg !1534
}

; Function Attrs: noinline nounwind
define internal i32 @rep_clz.15(i32 %a) #0 !dbg !1535 {
entry:
  %a.addr = alloca i32, align 4
  store i32 %a, i32* %a.addr, align 4
  %0 = load i32, i32* %a.addr, align 4, !dbg !1536
  %1 = call i32 @llvm.ctlz.i32(i32 %0, i1 true), !dbg !1537
  ret i32 %1, !dbg !1538
}

; Function Attrs: noinline nounwind
define dso_local float @__extendhfsf2(i16 zeroext %a) #0 !dbg !1539 {
entry:
  %a.addr = alloca i16, align 2
  store i16 %a, i16* %a.addr, align 2
  %0 = load i16, i16* %a.addr, align 2, !dbg !1540
  %call = call float @__extendXfYf2__(i16 zeroext %0) #4, !dbg !1541
  ret float %call, !dbg !1542
}

; Function Attrs: noinline nounwind
define internal float @__extendXfYf2__(i16 zeroext %a) #0 !dbg !1543 {
entry:
  %a.addr = alloca i16, align 2
  %srcBits = alloca i32, align 4
  %srcExpBits = alloca i32, align 4
  %srcInfExp = alloca i32, align 4
  %srcExpBias = alloca i32, align 4
  %srcMinNormal = alloca i16, align 2
  %srcInfinity = alloca i16, align 2
  %srcSignMask = alloca i16, align 2
  %srcAbsMask = alloca i16, align 2
  %srcQNaN = alloca i16, align 2
  %srcNaNCode = alloca i16, align 2
  %dstBits = alloca i32, align 4
  %dstExpBits = alloca i32, align 4
  %dstInfExp = alloca i32, align 4
  %dstExpBias = alloca i32, align 4
  %dstMinNormal = alloca i32, align 4
  %aRep = alloca i16, align 2
  %aAbs = alloca i16, align 2
  %sign = alloca i16, align 2
  %absResult = alloca i32, align 4
  %scale = alloca i32, align 4
  %resultExponent = alloca i32, align 4
  %result = alloca i32, align 4
  store i16 %a, i16* %a.addr, align 2
  store i32 16, i32* %srcBits, align 4, !dbg !1545
  store i32 5, i32* %srcExpBits, align 4, !dbg !1546
  store i32 31, i32* %srcInfExp, align 4, !dbg !1547
  store i32 15, i32* %srcExpBias, align 4, !dbg !1548
  store i16 1024, i16* %srcMinNormal, align 2, !dbg !1549
  store i16 31744, i16* %srcInfinity, align 2, !dbg !1550
  store i16 -32768, i16* %srcSignMask, align 2, !dbg !1551
  store i16 32767, i16* %srcAbsMask, align 2, !dbg !1552
  store i16 512, i16* %srcQNaN, align 2, !dbg !1553
  store i16 511, i16* %srcNaNCode, align 2, !dbg !1554
  store i32 32, i32* %dstBits, align 4, !dbg !1555
  store i32 8, i32* %dstExpBits, align 4, !dbg !1556
  store i32 255, i32* %dstInfExp, align 4, !dbg !1557
  store i32 127, i32* %dstExpBias, align 4, !dbg !1558
  store i32 8388608, i32* %dstMinNormal, align 4, !dbg !1559
  %0 = load i16, i16* %a.addr, align 2, !dbg !1560
  %call = call zeroext i16 @srcToRep(i16 zeroext %0) #4, !dbg !1561
  store i16 %call, i16* %aRep, align 2, !dbg !1562
  %1 = load i16, i16* %aRep, align 2, !dbg !1563
  %conv = zext i16 %1 to i32, !dbg !1563
  %and = and i32 %conv, 32767, !dbg !1564
  %conv1 = trunc i32 %and to i16, !dbg !1563
  store i16 %conv1, i16* %aAbs, align 2, !dbg !1565
  %2 = load i16, i16* %aRep, align 2, !dbg !1566
  %conv2 = zext i16 %2 to i32, !dbg !1566
  %and3 = and i32 %conv2, 32768, !dbg !1567
  %conv4 = trunc i32 %and3 to i16, !dbg !1566
  store i16 %conv4, i16* %sign, align 2, !dbg !1568
  %3 = load i16, i16* %aAbs, align 2, !dbg !1569
  %conv5 = zext i16 %3 to i32, !dbg !1569
  %sub = sub nsw i32 %conv5, 1024, !dbg !1570
  %conv6 = trunc i32 %sub to i16, !dbg !1571
  %conv7 = zext i16 %conv6 to i32, !dbg !1571
  %cmp = icmp slt i32 %conv7, 30720, !dbg !1572
  br i1 %cmp, label %if.then, label %if.else, !dbg !1571

if.then:                                          ; preds = %entry
  %4 = load i16, i16* %aAbs, align 2, !dbg !1573
  %conv9 = zext i16 %4 to i32, !dbg !1574
  %shl = shl i32 %conv9, 13, !dbg !1575
  store i32 %shl, i32* %absResult, align 4, !dbg !1576
  %5 = load i32, i32* %absResult, align 4, !dbg !1577
  %add = add i32 %5, 939524096, !dbg !1577
  store i32 %add, i32* %absResult, align 4, !dbg !1577
  br label %if.end34, !dbg !1578

if.else:                                          ; preds = %entry
  %6 = load i16, i16* %aAbs, align 2, !dbg !1579
  %conv10 = zext i16 %6 to i32, !dbg !1579
  %cmp11 = icmp sge i32 %conv10, 31744, !dbg !1580
  br i1 %cmp11, label %if.then13, label %if.else21, !dbg !1579

if.then13:                                        ; preds = %if.else
  store i32 2139095040, i32* %absResult, align 4, !dbg !1581
  %7 = load i16, i16* %aAbs, align 2, !dbg !1582
  %conv14 = zext i16 %7 to i32, !dbg !1582
  %and15 = and i32 %conv14, 512, !dbg !1583
  %shl16 = shl i32 %and15, 13, !dbg !1584
  %8 = load i32, i32* %absResult, align 4, !dbg !1585
  %or = or i32 %8, %shl16, !dbg !1585
  store i32 %or, i32* %absResult, align 4, !dbg !1585
  %9 = load i16, i16* %aAbs, align 2, !dbg !1586
  %conv17 = zext i16 %9 to i32, !dbg !1586
  %and18 = and i32 %conv17, 511, !dbg !1587
  %shl19 = shl i32 %and18, 13, !dbg !1588
  %10 = load i32, i32* %absResult, align 4, !dbg !1589
  %or20 = or i32 %10, %shl19, !dbg !1589
  store i32 %or20, i32* %absResult, align 4, !dbg !1589
  br label %if.end33, !dbg !1590

if.else21:                                        ; preds = %if.else
  %11 = load i16, i16* %aAbs, align 2, !dbg !1591
  %tobool = icmp ne i16 %11, 0, !dbg !1591
  br i1 %tobool, label %if.then22, label %if.else32, !dbg !1591

if.then22:                                        ; preds = %if.else21
  %12 = load i16, i16* %aAbs, align 2, !dbg !1592
  %conv23 = zext i16 %12 to i32, !dbg !1592
  %13 = call i32 @llvm.ctlz.i32(i32 %conv23, i1 true), !dbg !1593
  %sub24 = sub nsw i32 %13, 21, !dbg !1594
  store i32 %sub24, i32* %scale, align 4, !dbg !1595
  %14 = load i16, i16* %aAbs, align 2, !dbg !1596
  %conv25 = zext i16 %14 to i32, !dbg !1597
  %15 = load i32, i32* %scale, align 4, !dbg !1598
  %add26 = add nsw i32 13, %15, !dbg !1599
  %shl27 = shl i32 %conv25, %add26, !dbg !1600
  store i32 %shl27, i32* %absResult, align 4, !dbg !1601
  %16 = load i32, i32* %absResult, align 4, !dbg !1602
  %xor = xor i32 %16, 8388608, !dbg !1602
  store i32 %xor, i32* %absResult, align 4, !dbg !1602
  %17 = load i32, i32* %scale, align 4, !dbg !1603
  %sub28 = sub nsw i32 112, %17, !dbg !1604
  %add29 = add nsw i32 %sub28, 1, !dbg !1605
  store i32 %add29, i32* %resultExponent, align 4, !dbg !1606
  %18 = load i32, i32* %resultExponent, align 4, !dbg !1607
  %shl30 = shl i32 %18, 23, !dbg !1608
  %19 = load i32, i32* %absResult, align 4, !dbg !1609
  %or31 = or i32 %19, %shl30, !dbg !1609
  store i32 %or31, i32* %absResult, align 4, !dbg !1609
  br label %if.end, !dbg !1610

if.else32:                                        ; preds = %if.else21
  store i32 0, i32* %absResult, align 4, !dbg !1611
  br label %if.end

if.end:                                           ; preds = %if.else32, %if.then22
  br label %if.end33

if.end33:                                         ; preds = %if.end, %if.then13
  br label %if.end34

if.end34:                                         ; preds = %if.end33, %if.then
  %20 = load i32, i32* %absResult, align 4, !dbg !1612
  %21 = load i16, i16* %sign, align 2, !dbg !1613
  %conv35 = zext i16 %21 to i32, !dbg !1614
  %shl36 = shl i32 %conv35, 16, !dbg !1615
  %or37 = or i32 %20, %shl36, !dbg !1616
  store i32 %or37, i32* %result, align 4, !dbg !1617
  %22 = load i32, i32* %result, align 4, !dbg !1618
  %call38 = call float @dstFromRep(i32 %22) #4, !dbg !1619
  ret float %call38, !dbg !1620
}

; Function Attrs: noinline nounwind
define internal zeroext i16 @srcToRep(i16 zeroext %x) #0 !dbg !1621 {
entry:
  %x.addr = alloca i16, align 2
  %rep = alloca %union.anon, align 2
  store i16 %x, i16* %x.addr, align 2
  %f = bitcast %union.anon* %rep to i16*, !dbg !1623
  %0 = load i16, i16* %x.addr, align 2, !dbg !1624
  store i16 %0, i16* %f, align 2, !dbg !1623
  %i = bitcast %union.anon* %rep to i16*, !dbg !1625
  %1 = load i16, i16* %i, align 2, !dbg !1625
  ret i16 %1, !dbg !1626
}

; Function Attrs: noinline nounwind
define internal float @dstFromRep(i32 %x) #0 !dbg !1627 {
entry:
  %x.addr = alloca i32, align 4
  %rep = alloca %union.anon.0.0, align 4
  store i32 %x, i32* %x.addr, align 4
  %i = bitcast %union.anon.0.0* %rep to i32*, !dbg !1628
  %0 = load i32, i32* %x.addr, align 4, !dbg !1629
  store i32 %0, i32* %i, align 4, !dbg !1628
  %f = bitcast %union.anon.0.0* %rep to float*, !dbg !1630
  %1 = load float, float* %f, align 4, !dbg !1630
  ret float %1, !dbg !1631
}

; Function Attrs: noinline nounwind
define dso_local float @__gnu_h2f_ieee(i16 zeroext %a) #0 !dbg !1632 {
entry:
  %a.addr = alloca i16, align 2
  store i16 %a, i16* %a.addr, align 2
  %0 = load i16, i16* %a.addr, align 2, !dbg !1633
  %call = call float @__extendhfsf2(i16 zeroext %0) #4, !dbg !1634
  ret float %call, !dbg !1635
}

; Function Attrs: noinline nounwind
define dso_local double @__extendsfdf2(float %a) #0 !dbg !1636 {
entry:
  %a.addr = alloca float, align 4
  store float %a, float* %a.addr, align 4
  %0 = load float, float* %a.addr, align 4, !dbg !1637
  %call = call double @__extendXfYf2__.16(float %0) #4, !dbg !1638
  ret double %call, !dbg !1639
}

; Function Attrs: noinline nounwind
define internal double @__extendXfYf2__.16(float %a) #0 !dbg !1640 {
entry:
  %a.addr = alloca float, align 4
  %srcBits = alloca i32, align 4
  %srcExpBits = alloca i32, align 4
  %srcInfExp = alloca i32, align 4
  %srcExpBias = alloca i32, align 4
  %srcMinNormal = alloca i32, align 4
  %srcInfinity = alloca i32, align 4
  %srcSignMask = alloca i32, align 4
  %srcAbsMask = alloca i32, align 4
  %srcQNaN = alloca i32, align 4
  %srcNaNCode = alloca i32, align 4
  %dstBits = alloca i32, align 4
  %dstExpBits = alloca i32, align 4
  %dstInfExp = alloca i32, align 4
  %dstExpBias = alloca i32, align 4
  %dstMinNormal = alloca i64, align 8
  %aRep = alloca i32, align 4
  %aAbs = alloca i32, align 4
  %sign = alloca i32, align 4
  %absResult = alloca i64, align 8
  %scale = alloca i32, align 4
  %resultExponent = alloca i32, align 4
  %result = alloca i64, align 8
  store float %a, float* %a.addr, align 4
  store i32 32, i32* %srcBits, align 4, !dbg !1641
  store i32 8, i32* %srcExpBits, align 4, !dbg !1642
  store i32 255, i32* %srcInfExp, align 4, !dbg !1643
  store i32 127, i32* %srcExpBias, align 4, !dbg !1644
  store i32 8388608, i32* %srcMinNormal, align 4, !dbg !1645
  store i32 2139095040, i32* %srcInfinity, align 4, !dbg !1646
  store i32 -2147483648, i32* %srcSignMask, align 4, !dbg !1647
  store i32 2147483647, i32* %srcAbsMask, align 4, !dbg !1648
  store i32 4194304, i32* %srcQNaN, align 4, !dbg !1649
  store i32 4194303, i32* %srcNaNCode, align 4, !dbg !1650
  store i32 64, i32* %dstBits, align 4, !dbg !1651
  store i32 11, i32* %dstExpBits, align 4, !dbg !1652
  store i32 2047, i32* %dstInfExp, align 4, !dbg !1653
  store i32 1023, i32* %dstExpBias, align 4, !dbg !1654
  store i64 4503599627370496, i64* %dstMinNormal, align 8, !dbg !1655
  %0 = load float, float* %a.addr, align 4, !dbg !1656
  %call = call i32 @srcToRep.17(float %0) #4, !dbg !1657
  store i32 %call, i32* %aRep, align 4, !dbg !1658
  %1 = load i32, i32* %aRep, align 4, !dbg !1659
  %and = and i32 %1, 2147483647, !dbg !1660
  store i32 %and, i32* %aAbs, align 4, !dbg !1661
  %2 = load i32, i32* %aRep, align 4, !dbg !1662
  %and1 = and i32 %2, -2147483648, !dbg !1663
  store i32 %and1, i32* %sign, align 4, !dbg !1664
  %3 = load i32, i32* %aAbs, align 4, !dbg !1665
  %sub = sub i32 %3, 8388608, !dbg !1666
  %cmp = icmp ult i32 %sub, 2130706432, !dbg !1667
  br i1 %cmp, label %if.then, label %if.else, !dbg !1668

if.then:                                          ; preds = %entry
  %4 = load i32, i32* %aAbs, align 4, !dbg !1669
  %conv = zext i32 %4 to i64, !dbg !1670
  %shl = shl i64 %conv, 29, !dbg !1671
  store i64 %shl, i64* %absResult, align 8, !dbg !1672
  %5 = load i64, i64* %absResult, align 8, !dbg !1673
  %add = add i64 %5, 4035225266123964416, !dbg !1673
  store i64 %add, i64* %absResult, align 8, !dbg !1673
  br label %if.end25, !dbg !1674

if.else:                                          ; preds = %entry
  %6 = load i32, i32* %aAbs, align 4, !dbg !1675
  %cmp2 = icmp uge i32 %6, 2139095040, !dbg !1676
  br i1 %cmp2, label %if.then4, label %if.else12, !dbg !1675

if.then4:                                         ; preds = %if.else
  store i64 9218868437227405312, i64* %absResult, align 8, !dbg !1677
  %7 = load i32, i32* %aAbs, align 4, !dbg !1678
  %and5 = and i32 %7, 4194304, !dbg !1679
  %conv6 = zext i32 %and5 to i64, !dbg !1680
  %shl7 = shl i64 %conv6, 29, !dbg !1681
  %8 = load i64, i64* %absResult, align 8, !dbg !1682
  %or = or i64 %8, %shl7, !dbg !1682
  store i64 %or, i64* %absResult, align 8, !dbg !1682
  %9 = load i32, i32* %aAbs, align 4, !dbg !1683
  %and8 = and i32 %9, 4194303, !dbg !1684
  %conv9 = zext i32 %and8 to i64, !dbg !1685
  %shl10 = shl i64 %conv9, 29, !dbg !1686
  %10 = load i64, i64* %absResult, align 8, !dbg !1687
  %or11 = or i64 %10, %shl10, !dbg !1687
  store i64 %or11, i64* %absResult, align 8, !dbg !1687
  br label %if.end24, !dbg !1688

if.else12:                                        ; preds = %if.else
  %11 = load i32, i32* %aAbs, align 4, !dbg !1689
  %tobool = icmp ne i32 %11, 0, !dbg !1689
  br i1 %tobool, label %if.then13, label %if.else23, !dbg !1689

if.then13:                                        ; preds = %if.else12
  %12 = load i32, i32* %aAbs, align 4, !dbg !1690
  %13 = call i32 @llvm.ctlz.i32(i32 %12, i1 true), !dbg !1691
  %sub14 = sub nsw i32 %13, 8, !dbg !1692
  store i32 %sub14, i32* %scale, align 4, !dbg !1693
  %14 = load i32, i32* %aAbs, align 4, !dbg !1694
  %conv15 = zext i32 %14 to i64, !dbg !1695
  %15 = load i32, i32* %scale, align 4, !dbg !1696
  %add16 = add nsw i32 29, %15, !dbg !1697
  %sh_prom = zext i32 %add16 to i64, !dbg !1698
  %shl17 = shl i64 %conv15, %sh_prom, !dbg !1698
  store i64 %shl17, i64* %absResult, align 8, !dbg !1699
  %16 = load i64, i64* %absResult, align 8, !dbg !1700
  %xor = xor i64 %16, 4503599627370496, !dbg !1700
  store i64 %xor, i64* %absResult, align 8, !dbg !1700
  %17 = load i32, i32* %scale, align 4, !dbg !1701
  %sub18 = sub nsw i32 896, %17, !dbg !1702
  %add19 = add nsw i32 %sub18, 1, !dbg !1703
  store i32 %add19, i32* %resultExponent, align 4, !dbg !1704
  %18 = load i32, i32* %resultExponent, align 4, !dbg !1705
  %conv20 = sext i32 %18 to i64, !dbg !1706
  %shl21 = shl i64 %conv20, 52, !dbg !1707
  %19 = load i64, i64* %absResult, align 8, !dbg !1708
  %or22 = or i64 %19, %shl21, !dbg !1708
  store i64 %or22, i64* %absResult, align 8, !dbg !1708
  br label %if.end, !dbg !1709

if.else23:                                        ; preds = %if.else12
  store i64 0, i64* %absResult, align 8, !dbg !1710
  br label %if.end

if.end:                                           ; preds = %if.else23, %if.then13
  br label %if.end24

if.end24:                                         ; preds = %if.end, %if.then4
  br label %if.end25

if.end25:                                         ; preds = %if.end24, %if.then
  %20 = load i64, i64* %absResult, align 8, !dbg !1711
  %21 = load i32, i32* %sign, align 4, !dbg !1712
  %conv26 = zext i32 %21 to i64, !dbg !1713
  %shl27 = shl i64 %conv26, 32, !dbg !1714
  %or28 = or i64 %20, %shl27, !dbg !1715
  store i64 %or28, i64* %result, align 8, !dbg !1716
  %22 = load i64, i64* %result, align 8, !dbg !1717
  %call29 = call double @dstFromRep.18(i64 %22) #4, !dbg !1718
  ret double %call29, !dbg !1719
}

; Function Attrs: noinline nounwind
define internal i32 @srcToRep.17(float %x) #0 !dbg !1720 {
entry:
  %x.addr = alloca float, align 4
  %rep = alloca %union.anon.0.0, align 4
  store float %x, float* %x.addr, align 4
  %f = bitcast %union.anon.0.0* %rep to float*, !dbg !1721
  %0 = load float, float* %x.addr, align 4, !dbg !1722
  store float %0, float* %f, align 4, !dbg !1721
  %i = bitcast %union.anon.0.0* %rep to i32*, !dbg !1723
  %1 = load i32, i32* %i, align 4, !dbg !1723
  ret i32 %1, !dbg !1724
}

; Function Attrs: noinline nounwind
define internal double @dstFromRep.18(i64 %x) #0 !dbg !1725 {
entry:
  %x.addr = alloca i64, align 8
  %rep = alloca %union.anon.0, align 8
  store i64 %x, i64* %x.addr, align 8
  %i = bitcast %union.anon.0* %rep to i64*, !dbg !1726
  %0 = load i64, i64* %x.addr, align 8, !dbg !1727
  store i64 %0, i64* %i, align 8, !dbg !1726
  %f = bitcast %union.anon.0* %rep to double*, !dbg !1728
  %1 = load double, double* %f, align 8, !dbg !1728
  ret double %1, !dbg !1729
}

; Function Attrs: noinline nounwind
define dso_local i64 @__fixdfdi(double %a) #0 !dbg !1730 {
entry:
  %retval = alloca i64, align 8
  %a.addr = alloca double, align 8
  store double %a, double* %a.addr, align 8
  %0 = load double, double* %a.addr, align 8, !dbg !1731
  %cmp = fcmp olt double %0, 0.000000e+00, !dbg !1732
  br i1 %cmp, label %if.then, label %if.end, !dbg !1731

if.then:                                          ; preds = %entry
  %1 = load double, double* %a.addr, align 8, !dbg !1733
  %sub = fsub double -0.000000e+00, %1, !dbg !1734
  %call = call i64 @__fixunsdfdi(double %sub) #4, !dbg !1735
  %sub1 = sub i64 0, %call, !dbg !1736
  store i64 %sub1, i64* %retval, align 8, !dbg !1737
  br label %return, !dbg !1737

if.end:                                           ; preds = %entry
  %2 = load double, double* %a.addr, align 8, !dbg !1738
  %call2 = call i64 @__fixunsdfdi(double %2) #4, !dbg !1739
  store i64 %call2, i64* %retval, align 8, !dbg !1740
  br label %return, !dbg !1740

return:                                           ; preds = %if.end, %if.then
  %3 = load i64, i64* %retval, align 8, !dbg !1741
  ret i64 %3, !dbg !1741
}

; Function Attrs: noinline nounwind
define dso_local i32 @__fixdfsi(double %a) #0 !dbg !1742 {
entry:
  %a.addr = alloca double, align 8
  store double %a, double* %a.addr, align 8
  %0 = load double, double* %a.addr, align 8, !dbg !1743
  %call = call i32 @__fixint(double %0) #4, !dbg !1744
  ret i32 %call, !dbg !1745
}

; Function Attrs: noinline nounwind
define internal i32 @__fixint(double %a) #0 !dbg !1746 {
entry:
  %retval = alloca i32, align 4
  %a.addr = alloca double, align 8
  %fixint_max = alloca i32, align 4
  %fixint_min = alloca i32, align 4
  %aRep = alloca i64, align 8
  %aAbs = alloca i64, align 8
  %sign = alloca i32, align 4
  %exponent = alloca i32, align 4
  %significand = alloca i64, align 8
  store double %a, double* %a.addr, align 8
  store i32 2147483647, i32* %fixint_max, align 4, !dbg !1748
  store i32 -2147483648, i32* %fixint_min, align 4, !dbg !1749
  %0 = load double, double* %a.addr, align 8, !dbg !1750
  %call = call i64 @toRep.19(double %0) #4, !dbg !1751
  store i64 %call, i64* %aRep, align 8, !dbg !1752
  %1 = load i64, i64* %aRep, align 8, !dbg !1753
  %and = and i64 %1, 9223372036854775807, !dbg !1754
  store i64 %and, i64* %aAbs, align 8, !dbg !1755
  %2 = load i64, i64* %aRep, align 8, !dbg !1756
  %and1 = and i64 %2, -9223372036854775808, !dbg !1757
  %tobool = icmp ne i64 %and1, 0, !dbg !1756
  %3 = zext i1 %tobool to i64, !dbg !1756
  %cond = select i1 %tobool, i32 -1, i32 1, !dbg !1756
  store i32 %cond, i32* %sign, align 4, !dbg !1758
  %4 = load i64, i64* %aAbs, align 8, !dbg !1759
  %shr = lshr i64 %4, 52, !dbg !1760
  %sub = sub i64 %shr, 1023, !dbg !1761
  %conv = trunc i64 %sub to i32, !dbg !1762
  store i32 %conv, i32* %exponent, align 4, !dbg !1763
  %5 = load i64, i64* %aAbs, align 8, !dbg !1764
  %and2 = and i64 %5, 4503599627370495, !dbg !1765
  %or = or i64 %and2, 4503599627370496, !dbg !1766
  store i64 %or, i64* %significand, align 8, !dbg !1767
  %6 = load i32, i32* %exponent, align 4, !dbg !1768
  %cmp = icmp slt i32 %6, 0, !dbg !1769
  br i1 %cmp, label %if.then, label %if.end, !dbg !1768

if.then:                                          ; preds = %entry
  store i32 0, i32* %retval, align 4, !dbg !1770
  br label %return, !dbg !1770

if.end:                                           ; preds = %entry
  %7 = load i32, i32* %exponent, align 4, !dbg !1771
  %cmp4 = icmp uge i32 %7, 32, !dbg !1772
  br i1 %cmp4, label %if.then6, label %if.end10, !dbg !1773

if.then6:                                         ; preds = %if.end
  %8 = load i32, i32* %sign, align 4, !dbg !1774
  %cmp7 = icmp eq i32 %8, 1, !dbg !1775
  %9 = zext i1 %cmp7 to i64, !dbg !1774
  %cond9 = select i1 %cmp7, i32 2147483647, i32 -2147483648, !dbg !1774
  store i32 %cond9, i32* %retval, align 4, !dbg !1776
  br label %return, !dbg !1776

if.end10:                                         ; preds = %if.end
  %10 = load i32, i32* %exponent, align 4, !dbg !1777
  %cmp11 = icmp slt i32 %10, 52, !dbg !1778
  br i1 %cmp11, label %if.then13, label %if.else, !dbg !1777

if.then13:                                        ; preds = %if.end10
  %11 = load i32, i32* %sign, align 4, !dbg !1779
  %conv14 = sext i32 %11 to i64, !dbg !1779
  %12 = load i64, i64* %significand, align 8, !dbg !1780
  %13 = load i32, i32* %exponent, align 4, !dbg !1781
  %sub15 = sub nsw i32 52, %13, !dbg !1782
  %sh_prom = zext i32 %sub15 to i64, !dbg !1783
  %shr16 = lshr i64 %12, %sh_prom, !dbg !1783
  %mul = mul i64 %conv14, %shr16, !dbg !1784
  %conv17 = trunc i64 %mul to i32, !dbg !1779
  store i32 %conv17, i32* %retval, align 4, !dbg !1785
  br label %return, !dbg !1785

if.else:                                          ; preds = %if.end10
  %14 = load i32, i32* %sign, align 4, !dbg !1786
  %15 = load i64, i64* %significand, align 8, !dbg !1787
  %conv18 = trunc i64 %15 to i32, !dbg !1788
  %16 = load i32, i32* %exponent, align 4, !dbg !1789
  %sub19 = sub nsw i32 %16, 52, !dbg !1790
  %shl = shl i32 %conv18, %sub19, !dbg !1791
  %mul20 = mul nsw i32 %14, %shl, !dbg !1792
  store i32 %mul20, i32* %retval, align 4, !dbg !1793
  br label %return, !dbg !1793

return:                                           ; preds = %if.else, %if.then13, %if.then6, %if.then
  %17 = load i32, i32* %retval, align 4, !dbg !1794
  ret i32 %17, !dbg !1794
}

; Function Attrs: noinline nounwind
define internal i64 @toRep.19(double %x) #0 !dbg !1795 {
entry:
  %x.addr = alloca double, align 8
  %rep = alloca %union.anon.0, align 8
  store double %x, double* %x.addr, align 8
  %f = bitcast %union.anon.0* %rep to double*, !dbg !1796
  %0 = load double, double* %x.addr, align 8, !dbg !1797
  store double %0, double* %f, align 8, !dbg !1796
  %i = bitcast %union.anon.0* %rep to i64*, !dbg !1798
  %1 = load i64, i64* %i, align 8, !dbg !1798
  ret i64 %1, !dbg !1799
}

; Function Attrs: noinline nounwind
define dso_local i64 @__fixsfdi(float %a) #0 !dbg !1800 {
entry:
  %retval = alloca i64, align 8
  %a.addr = alloca float, align 4
  store float %a, float* %a.addr, align 4
  %0 = load float, float* %a.addr, align 4, !dbg !1801
  %cmp = fcmp olt float %0, 0.000000e+00, !dbg !1802
  br i1 %cmp, label %if.then, label %if.end, !dbg !1801

if.then:                                          ; preds = %entry
  %1 = load float, float* %a.addr, align 4, !dbg !1803
  %sub = fsub float -0.000000e+00, %1, !dbg !1804
  %call = call i64 @__fixunssfdi(float %sub) #4, !dbg !1805
  %sub1 = sub i64 0, %call, !dbg !1806
  store i64 %sub1, i64* %retval, align 8, !dbg !1807
  br label %return, !dbg !1807

if.end:                                           ; preds = %entry
  %2 = load float, float* %a.addr, align 4, !dbg !1808
  %call2 = call i64 @__fixunssfdi(float %2) #4, !dbg !1809
  store i64 %call2, i64* %retval, align 8, !dbg !1810
  br label %return, !dbg !1810

return:                                           ; preds = %if.end, %if.then
  %3 = load i64, i64* %retval, align 8, !dbg !1811
  ret i64 %3, !dbg !1811
}

; Function Attrs: noinline nounwind
define dso_local i32 @__fixsfsi(float %a) #0 !dbg !1812 {
entry:
  %a.addr = alloca float, align 4
  store float %a, float* %a.addr, align 4
  %0 = load float, float* %a.addr, align 4, !dbg !1813
  %call = call i32 @__fixint.20(float %0) #4, !dbg !1814
  ret i32 %call, !dbg !1815
}

; Function Attrs: noinline nounwind
define internal i32 @__fixint.20(float %a) #0 !dbg !1816 {
entry:
  %retval = alloca i32, align 4
  %a.addr = alloca float, align 4
  %fixint_max = alloca i32, align 4
  %fixint_min = alloca i32, align 4
  %aRep = alloca i32, align 4
  %aAbs = alloca i32, align 4
  %sign = alloca i32, align 4
  %exponent = alloca i32, align 4
  %significand = alloca i32, align 4
  store float %a, float* %a.addr, align 4
  store i32 2147483647, i32* %fixint_max, align 4, !dbg !1817
  store i32 -2147483648, i32* %fixint_min, align 4, !dbg !1818
  %0 = load float, float* %a.addr, align 4, !dbg !1819
  %call = call i32 @toRep.21(float %0) #4, !dbg !1820
  store i32 %call, i32* %aRep, align 4, !dbg !1821
  %1 = load i32, i32* %aRep, align 4, !dbg !1822
  %and = and i32 %1, 2147483647, !dbg !1823
  store i32 %and, i32* %aAbs, align 4, !dbg !1824
  %2 = load i32, i32* %aRep, align 4, !dbg !1825
  %and1 = and i32 %2, -2147483648, !dbg !1826
  %tobool = icmp ne i32 %and1, 0, !dbg !1825
  %3 = zext i1 %tobool to i64, !dbg !1825
  %cond = select i1 %tobool, i32 -1, i32 1, !dbg !1825
  store i32 %cond, i32* %sign, align 4, !dbg !1827
  %4 = load i32, i32* %aAbs, align 4, !dbg !1828
  %shr = lshr i32 %4, 23, !dbg !1829
  %sub = sub i32 %shr, 127, !dbg !1830
  store i32 %sub, i32* %exponent, align 4, !dbg !1831
  %5 = load i32, i32* %aAbs, align 4, !dbg !1832
  %and2 = and i32 %5, 8388607, !dbg !1833
  %or = or i32 %and2, 8388608, !dbg !1834
  store i32 %or, i32* %significand, align 4, !dbg !1835
  %6 = load i32, i32* %exponent, align 4, !dbg !1836
  %cmp = icmp slt i32 %6, 0, !dbg !1837
  br i1 %cmp, label %if.then, label %if.end, !dbg !1836

if.then:                                          ; preds = %entry
  store i32 0, i32* %retval, align 4, !dbg !1838
  br label %return, !dbg !1838

if.end:                                           ; preds = %entry
  %7 = load i32, i32* %exponent, align 4, !dbg !1839
  %cmp3 = icmp uge i32 %7, 32, !dbg !1840
  br i1 %cmp3, label %if.then4, label %if.end7, !dbg !1841

if.then4:                                         ; preds = %if.end
  %8 = load i32, i32* %sign, align 4, !dbg !1842
  %cmp5 = icmp eq i32 %8, 1, !dbg !1843
  %9 = zext i1 %cmp5 to i64, !dbg !1842
  %cond6 = select i1 %cmp5, i32 2147483647, i32 -2147483648, !dbg !1842
  store i32 %cond6, i32* %retval, align 4, !dbg !1844
  br label %return, !dbg !1844

if.end7:                                          ; preds = %if.end
  %10 = load i32, i32* %exponent, align 4, !dbg !1845
  %cmp8 = icmp slt i32 %10, 23, !dbg !1846
  br i1 %cmp8, label %if.then9, label %if.else, !dbg !1845

if.then9:                                         ; preds = %if.end7
  %11 = load i32, i32* %sign, align 4, !dbg !1847
  %12 = load i32, i32* %significand, align 4, !dbg !1848
  %13 = load i32, i32* %exponent, align 4, !dbg !1849
  %sub10 = sub nsw i32 23, %13, !dbg !1850
  %shr11 = lshr i32 %12, %sub10, !dbg !1851
  %mul = mul i32 %11, %shr11, !dbg !1852
  store i32 %mul, i32* %retval, align 4, !dbg !1853
  br label %return, !dbg !1853

if.else:                                          ; preds = %if.end7
  %14 = load i32, i32* %sign, align 4, !dbg !1854
  %15 = load i32, i32* %significand, align 4, !dbg !1855
  %16 = load i32, i32* %exponent, align 4, !dbg !1856
  %sub12 = sub nsw i32 %16, 23, !dbg !1857
  %shl = shl i32 %15, %sub12, !dbg !1858
  %mul13 = mul nsw i32 %14, %shl, !dbg !1859
  store i32 %mul13, i32* %retval, align 4, !dbg !1860
  br label %return, !dbg !1860

return:                                           ; preds = %if.else, %if.then9, %if.then4, %if.then
  %17 = load i32, i32* %retval, align 4, !dbg !1861
  ret i32 %17, !dbg !1861
}

; Function Attrs: noinline nounwind
define internal i32 @toRep.21(float %x) #0 !dbg !1862 {
entry:
  %x.addr = alloca float, align 4
  %rep = alloca %union.anon.0.0, align 4
  store float %x, float* %x.addr, align 4
  %f = bitcast %union.anon.0.0* %rep to float*, !dbg !1863
  %0 = load float, float* %x.addr, align 4, !dbg !1864
  store float %0, float* %f, align 4, !dbg !1863
  %i = bitcast %union.anon.0.0* %rep to i32*, !dbg !1865
  %1 = load i32, i32* %i, align 4, !dbg !1865
  ret i32 %1, !dbg !1866
}

; Function Attrs: noinline nounwind
define dso_local i64 @__fixunsdfdi(double %a) #0 !dbg !1867 {
entry:
  %retval = alloca i64, align 8
  %a.addr = alloca double, align 8
  %high = alloca i32, align 4
  %low = alloca i32, align 4
  store double %a, double* %a.addr, align 8
  %0 = load double, double* %a.addr, align 8, !dbg !1868
  %cmp = fcmp ole double %0, 0.000000e+00, !dbg !1869
  br i1 %cmp, label %if.then, label %if.end, !dbg !1868

if.then:                                          ; preds = %entry
  store i64 0, i64* %retval, align 8, !dbg !1870
  br label %return, !dbg !1870

if.end:                                           ; preds = %entry
  %1 = load double, double* %a.addr, align 8, !dbg !1871
  %div = fdiv double %1, 0x41F0000000000000, !dbg !1872
  %conv = fptoui double %div to i32, !dbg !1871
  store i32 %conv, i32* %high, align 4, !dbg !1873
  %2 = load double, double* %a.addr, align 8, !dbg !1874
  %3 = load i32, i32* %high, align 4, !dbg !1875
  %conv1 = uitofp i32 %3 to double, !dbg !1876
  %mul = fmul double %conv1, 0x41F0000000000000, !dbg !1877
  %sub = fsub double %2, %mul, !dbg !1878
  %conv2 = fptoui double %sub to i32, !dbg !1874
  store i32 %conv2, i32* %low, align 4, !dbg !1879
  %4 = load i32, i32* %high, align 4, !dbg !1880
  %conv3 = zext i32 %4 to i64, !dbg !1881
  %shl = shl i64 %conv3, 32, !dbg !1882
  %5 = load i32, i32* %low, align 4, !dbg !1883
  %conv4 = zext i32 %5 to i64, !dbg !1883
  %or = or i64 %shl, %conv4, !dbg !1884
  store i64 %or, i64* %retval, align 8, !dbg !1885
  br label %return, !dbg !1885

return:                                           ; preds = %if.end, %if.then
  %6 = load i64, i64* %retval, align 8, !dbg !1886
  ret i64 %6, !dbg !1886
}

; Function Attrs: noinline nounwind
define dso_local i32 @__fixunsdfsi(double %a) #0 !dbg !1887 {
entry:
  %a.addr = alloca double, align 8
  store double %a, double* %a.addr, align 8
  %0 = load double, double* %a.addr, align 8, !dbg !1888
  %call = call i32 @__fixuint(double %0) #4, !dbg !1889
  ret i32 %call, !dbg !1890
}

; Function Attrs: noinline nounwind
define internal i32 @__fixuint(double %a) #0 !dbg !1891 {
entry:
  %retval = alloca i32, align 4
  %a.addr = alloca double, align 8
  %aRep = alloca i64, align 8
  %aAbs = alloca i64, align 8
  %sign = alloca i32, align 4
  %exponent = alloca i32, align 4
  %significand = alloca i64, align 8
  store double %a, double* %a.addr, align 8
  %0 = load double, double* %a.addr, align 8, !dbg !1893
  %call = call i64 @toRep.24(double %0) #4, !dbg !1894
  store i64 %call, i64* %aRep, align 8, !dbg !1895
  %1 = load i64, i64* %aRep, align 8, !dbg !1896
  %and = and i64 %1, 9223372036854775807, !dbg !1897
  store i64 %and, i64* %aAbs, align 8, !dbg !1898
  %2 = load i64, i64* %aRep, align 8, !dbg !1899
  %and1 = and i64 %2, -9223372036854775808, !dbg !1900
  %tobool = icmp ne i64 %and1, 0, !dbg !1899
  %3 = zext i1 %tobool to i64, !dbg !1899
  %cond = select i1 %tobool, i32 -1, i32 1, !dbg !1899
  store i32 %cond, i32* %sign, align 4, !dbg !1901
  %4 = load i64, i64* %aAbs, align 8, !dbg !1902
  %shr = lshr i64 %4, 52, !dbg !1903
  %sub = sub i64 %shr, 1023, !dbg !1904
  %conv = trunc i64 %sub to i32, !dbg !1905
  store i32 %conv, i32* %exponent, align 4, !dbg !1906
  %5 = load i64, i64* %aAbs, align 8, !dbg !1907
  %and2 = and i64 %5, 4503599627370495, !dbg !1908
  %or = or i64 %and2, 4503599627370496, !dbg !1909
  store i64 %or, i64* %significand, align 8, !dbg !1910
  %6 = load i32, i32* %sign, align 4, !dbg !1911
  %cmp = icmp eq i32 %6, -1, !dbg !1912
  br i1 %cmp, label %if.then, label %lor.lhs.false, !dbg !1913

lor.lhs.false:                                    ; preds = %entry
  %7 = load i32, i32* %exponent, align 4, !dbg !1914
  %cmp4 = icmp slt i32 %7, 0, !dbg !1915
  br i1 %cmp4, label %if.then, label %if.end, !dbg !1911

if.then:                                          ; preds = %lor.lhs.false, %entry
  store i32 0, i32* %retval, align 4, !dbg !1916
  br label %return, !dbg !1916

if.end:                                           ; preds = %lor.lhs.false
  %8 = load i32, i32* %exponent, align 4, !dbg !1917
  %cmp6 = icmp uge i32 %8, 32, !dbg !1918
  br i1 %cmp6, label %if.then8, label %if.end9, !dbg !1919

if.then8:                                         ; preds = %if.end
  store i32 -1, i32* %retval, align 4, !dbg !1920
  br label %return, !dbg !1920

if.end9:                                          ; preds = %if.end
  %9 = load i32, i32* %exponent, align 4, !dbg !1921
  %cmp10 = icmp slt i32 %9, 52, !dbg !1922
  br i1 %cmp10, label %if.then12, label %if.else, !dbg !1921

if.then12:                                        ; preds = %if.end9
  %10 = load i64, i64* %significand, align 8, !dbg !1923
  %11 = load i32, i32* %exponent, align 4, !dbg !1924
  %sub13 = sub nsw i32 52, %11, !dbg !1925
  %sh_prom = zext i32 %sub13 to i64, !dbg !1926
  %shr14 = lshr i64 %10, %sh_prom, !dbg !1926
  %conv15 = trunc i64 %shr14 to i32, !dbg !1923
  store i32 %conv15, i32* %retval, align 4, !dbg !1927
  br label %return, !dbg !1927

if.else:                                          ; preds = %if.end9
  %12 = load i64, i64* %significand, align 8, !dbg !1928
  %conv16 = trunc i64 %12 to i32, !dbg !1929
  %13 = load i32, i32* %exponent, align 4, !dbg !1930
  %sub17 = sub nsw i32 %13, 52, !dbg !1931
  %shl = shl i32 %conv16, %sub17, !dbg !1932
  store i32 %shl, i32* %retval, align 4, !dbg !1933
  br label %return, !dbg !1933

return:                                           ; preds = %if.else, %if.then12, %if.then8, %if.then
  %14 = load i32, i32* %retval, align 4, !dbg !1934
  ret i32 %14, !dbg !1934
}

; Function Attrs: noinline nounwind
define internal i64 @toRep.24(double %x) #0 !dbg !1935 {
entry:
  %x.addr = alloca double, align 8
  %rep = alloca %union.anon.0, align 8
  store double %x, double* %x.addr, align 8
  %f = bitcast %union.anon.0* %rep to double*, !dbg !1936
  %0 = load double, double* %x.addr, align 8, !dbg !1937
  store double %0, double* %f, align 8, !dbg !1936
  %i = bitcast %union.anon.0* %rep to i64*, !dbg !1938
  %1 = load i64, i64* %i, align 8, !dbg !1938
  ret i64 %1, !dbg !1939
}

; Function Attrs: noinline nounwind
define dso_local i64 @__fixunssfdi(float %a) #0 !dbg !1940 {
entry:
  %retval = alloca i64, align 8
  %a.addr = alloca float, align 4
  %da = alloca double, align 8
  %high = alloca i32, align 4
  %low = alloca i32, align 4
  store float %a, float* %a.addr, align 4
  %0 = load float, float* %a.addr, align 4, !dbg !1941
  %cmp = fcmp ole float %0, 0.000000e+00, !dbg !1942
  br i1 %cmp, label %if.then, label %if.end, !dbg !1941

if.then:                                          ; preds = %entry
  store i64 0, i64* %retval, align 8, !dbg !1943
  br label %return, !dbg !1943

if.end:                                           ; preds = %entry
  %1 = load float, float* %a.addr, align 4, !dbg !1944
  %conv = fpext float %1 to double, !dbg !1944
  store double %conv, double* %da, align 8, !dbg !1945
  %2 = load double, double* %da, align 8, !dbg !1946
  %div = fdiv double %2, 0x41F0000000000000, !dbg !1947
  %conv1 = fptoui double %div to i32, !dbg !1946
  store i32 %conv1, i32* %high, align 4, !dbg !1948
  %3 = load double, double* %da, align 8, !dbg !1949
  %4 = load i32, i32* %high, align 4, !dbg !1950
  %conv2 = uitofp i32 %4 to double, !dbg !1951
  %mul = fmul double %conv2, 0x41F0000000000000, !dbg !1952
  %sub = fsub double %3, %mul, !dbg !1953
  %conv3 = fptoui double %sub to i32, !dbg !1949
  store i32 %conv3, i32* %low, align 4, !dbg !1954
  %5 = load i32, i32* %high, align 4, !dbg !1955
  %conv4 = zext i32 %5 to i64, !dbg !1956
  %shl = shl i64 %conv4, 32, !dbg !1957
  %6 = load i32, i32* %low, align 4, !dbg !1958
  %conv5 = zext i32 %6 to i64, !dbg !1958
  %or = or i64 %shl, %conv5, !dbg !1959
  store i64 %or, i64* %retval, align 8, !dbg !1960
  br label %return, !dbg !1960

return:                                           ; preds = %if.end, %if.then
  %7 = load i64, i64* %retval, align 8, !dbg !1961
  ret i64 %7, !dbg !1961
}

; Function Attrs: noinline nounwind
define dso_local i32 @__fixunssfsi(float %a) #0 !dbg !1962 {
entry:
  %a.addr = alloca float, align 4
  store float %a, float* %a.addr, align 4
  %0 = load float, float* %a.addr, align 4, !dbg !1963
  %call = call i32 @__fixuint.27(float %0) #4, !dbg !1964
  ret i32 %call, !dbg !1965
}

; Function Attrs: noinline nounwind
define internal i32 @__fixuint.27(float %a) #0 !dbg !1966 {
entry:
  %retval = alloca i32, align 4
  %a.addr = alloca float, align 4
  %aRep = alloca i32, align 4
  %aAbs = alloca i32, align 4
  %sign = alloca i32, align 4
  %exponent = alloca i32, align 4
  %significand = alloca i32, align 4
  store float %a, float* %a.addr, align 4
  %0 = load float, float* %a.addr, align 4, !dbg !1967
  %call = call i32 @toRep.28(float %0) #4, !dbg !1968
  store i32 %call, i32* %aRep, align 4, !dbg !1969
  %1 = load i32, i32* %aRep, align 4, !dbg !1970
  %and = and i32 %1, 2147483647, !dbg !1971
  store i32 %and, i32* %aAbs, align 4, !dbg !1972
  %2 = load i32, i32* %aRep, align 4, !dbg !1973
  %and1 = and i32 %2, -2147483648, !dbg !1974
  %tobool = icmp ne i32 %and1, 0, !dbg !1973
  %3 = zext i1 %tobool to i64, !dbg !1973
  %cond = select i1 %tobool, i32 -1, i32 1, !dbg !1973
  store i32 %cond, i32* %sign, align 4, !dbg !1975
  %4 = load i32, i32* %aAbs, align 4, !dbg !1976
  %shr = lshr i32 %4, 23, !dbg !1977
  %sub = sub i32 %shr, 127, !dbg !1978
  store i32 %sub, i32* %exponent, align 4, !dbg !1979
  %5 = load i32, i32* %aAbs, align 4, !dbg !1980
  %and2 = and i32 %5, 8388607, !dbg !1981
  %or = or i32 %and2, 8388608, !dbg !1982
  store i32 %or, i32* %significand, align 4, !dbg !1983
  %6 = load i32, i32* %sign, align 4, !dbg !1984
  %cmp = icmp eq i32 %6, -1, !dbg !1985
  br i1 %cmp, label %if.then, label %lor.lhs.false, !dbg !1986

lor.lhs.false:                                    ; preds = %entry
  %7 = load i32, i32* %exponent, align 4, !dbg !1987
  %cmp3 = icmp slt i32 %7, 0, !dbg !1988
  br i1 %cmp3, label %if.then, label %if.end, !dbg !1984

if.then:                                          ; preds = %lor.lhs.false, %entry
  store i32 0, i32* %retval, align 4, !dbg !1989
  br label %return, !dbg !1989

if.end:                                           ; preds = %lor.lhs.false
  %8 = load i32, i32* %exponent, align 4, !dbg !1990
  %cmp4 = icmp uge i32 %8, 32, !dbg !1991
  br i1 %cmp4, label %if.then5, label %if.end6, !dbg !1992

if.then5:                                         ; preds = %if.end
  store i32 -1, i32* %retval, align 4, !dbg !1993
  br label %return, !dbg !1993

if.end6:                                          ; preds = %if.end
  %9 = load i32, i32* %exponent, align 4, !dbg !1994
  %cmp7 = icmp slt i32 %9, 23, !dbg !1995
  br i1 %cmp7, label %if.then8, label %if.else, !dbg !1994

if.then8:                                         ; preds = %if.end6
  %10 = load i32, i32* %significand, align 4, !dbg !1996
  %11 = load i32, i32* %exponent, align 4, !dbg !1997
  %sub9 = sub nsw i32 23, %11, !dbg !1998
  %shr10 = lshr i32 %10, %sub9, !dbg !1999
  store i32 %shr10, i32* %retval, align 4, !dbg !2000
  br label %return, !dbg !2000

if.else:                                          ; preds = %if.end6
  %12 = load i32, i32* %significand, align 4, !dbg !2001
  %13 = load i32, i32* %exponent, align 4, !dbg !2002
  %sub11 = sub nsw i32 %13, 23, !dbg !2003
  %shl = shl i32 %12, %sub11, !dbg !2004
  store i32 %shl, i32* %retval, align 4, !dbg !2005
  br label %return, !dbg !2005

return:                                           ; preds = %if.else, %if.then8, %if.then5, %if.then
  %14 = load i32, i32* %retval, align 4, !dbg !2006
  ret i32 %14, !dbg !2006
}

; Function Attrs: noinline nounwind
define internal i32 @toRep.28(float %x) #0 !dbg !2007 {
entry:
  %x.addr = alloca float, align 4
  %rep = alloca %union.anon.0.0, align 4
  store float %x, float* %x.addr, align 4
  %f = bitcast %union.anon.0.0* %rep to float*, !dbg !2008
  %0 = load float, float* %x.addr, align 4, !dbg !2009
  store float %0, float* %f, align 4, !dbg !2008
  %i = bitcast %union.anon.0.0* %rep to i32*, !dbg !2010
  %1 = load i32, i32* %i, align 4, !dbg !2010
  ret i32 %1, !dbg !2011
}

; Function Attrs: noinline nounwind
define dso_local i64 @__fixunsxfdi(fp128 %a) #0 !dbg !2012 {
entry:
  %retval = alloca i64, align 8
  %a.addr = alloca fp128, align 16
  %fb = alloca %union.long_double_bits, align 16
  %e = alloca i32, align 4
  store fp128 %a, fp128* %a.addr, align 16
  %0 = load fp128, fp128* %a.addr, align 16, !dbg !2013
  %f = bitcast %union.long_double_bits* %fb to fp128*, !dbg !2014
  store fp128 %0, fp128* %f, align 16, !dbg !2015
  %u = bitcast %union.long_double_bits* %fb to %struct.uqwords*, !dbg !2016
  %high = getelementptr inbounds %struct.uqwords, %struct.uqwords* %u, i32 0, i32 1, !dbg !2017
  %s = bitcast %union.udwords* %high to %struct.anon*, !dbg !2018
  %low = getelementptr inbounds %struct.anon, %struct.anon* %s, i32 0, i32 0, !dbg !2019
  %1 = load i32, i32* %low, align 8, !dbg !2019
  %and = and i32 %1, 32767, !dbg !2020
  %sub = sub i32 %and, 16383, !dbg !2021
  store i32 %sub, i32* %e, align 4, !dbg !2022
  %2 = load i32, i32* %e, align 4, !dbg !2023
  %cmp = icmp slt i32 %2, 0, !dbg !2024
  br i1 %cmp, label %if.then, label %lor.lhs.false, !dbg !2025

lor.lhs.false:                                    ; preds = %entry
  %u1 = bitcast %union.long_double_bits* %fb to %struct.uqwords*, !dbg !2026
  %high2 = getelementptr inbounds %struct.uqwords, %struct.uqwords* %u1, i32 0, i32 1, !dbg !2027
  %s3 = bitcast %union.udwords* %high2 to %struct.anon*, !dbg !2028
  %low4 = getelementptr inbounds %struct.anon, %struct.anon* %s3, i32 0, i32 0, !dbg !2029
  %3 = load i32, i32* %low4, align 8, !dbg !2029
  %and5 = and i32 %3, 32768, !dbg !2030
  %tobool = icmp ne i32 %and5, 0, !dbg !2030
  br i1 %tobool, label %if.then, label %if.end, !dbg !2023

if.then:                                          ; preds = %lor.lhs.false, %entry
  store i64 0, i64* %retval, align 8, !dbg !2031
  br label %return, !dbg !2031

if.end:                                           ; preds = %lor.lhs.false
  %4 = load i32, i32* %e, align 4, !dbg !2032
  %cmp6 = icmp ugt i32 %4, 64, !dbg !2033
  br i1 %cmp6, label %if.then7, label %if.end8, !dbg !2034

if.then7:                                         ; preds = %if.end
  store i64 -1, i64* %retval, align 8, !dbg !2035
  br label %return, !dbg !2035

if.end8:                                          ; preds = %if.end
  %u9 = bitcast %union.long_double_bits* %fb to %struct.uqwords*, !dbg !2036
  %low10 = getelementptr inbounds %struct.uqwords, %struct.uqwords* %u9, i32 0, i32 0, !dbg !2037
  %all = bitcast %union.udwords* %low10 to i64*, !dbg !2038
  %5 = load i64, i64* %all, align 16, !dbg !2038
  %6 = load i32, i32* %e, align 4, !dbg !2039
  %sub11 = sub nsw i32 63, %6, !dbg !2040
  %sh_prom = zext i32 %sub11 to i64, !dbg !2041
  %shr = lshr i64 %5, %sh_prom, !dbg !2041
  store i64 %shr, i64* %retval, align 8, !dbg !2042
  br label %return, !dbg !2042

return:                                           ; preds = %if.end8, %if.then7, %if.then
  %7 = load i64, i64* %retval, align 8, !dbg !2043
  ret i64 %7, !dbg !2043
}

; Function Attrs: noinline nounwind
define dso_local i32 @__fixunsxfsi(fp128 %a) #0 !dbg !2044 {
entry:
  %retval = alloca i32, align 4
  %a.addr = alloca fp128, align 16
  %fb = alloca %union.long_double_bits, align 16
  %e = alloca i32, align 4
  store fp128 %a, fp128* %a.addr, align 16
  %0 = load fp128, fp128* %a.addr, align 16, !dbg !2045
  %f = bitcast %union.long_double_bits* %fb to fp128*, !dbg !2046
  store fp128 %0, fp128* %f, align 16, !dbg !2047
  %u = bitcast %union.long_double_bits* %fb to %struct.uqwords*, !dbg !2048
  %high = getelementptr inbounds %struct.uqwords, %struct.uqwords* %u, i32 0, i32 1, !dbg !2049
  %s = bitcast %union.udwords* %high to %struct.anon*, !dbg !2050
  %low = getelementptr inbounds %struct.anon, %struct.anon* %s, i32 0, i32 0, !dbg !2051
  %1 = load i32, i32* %low, align 8, !dbg !2051
  %and = and i32 %1, 32767, !dbg !2052
  %sub = sub i32 %and, 16383, !dbg !2053
  store i32 %sub, i32* %e, align 4, !dbg !2054
  %2 = load i32, i32* %e, align 4, !dbg !2055
  %cmp = icmp slt i32 %2, 0, !dbg !2056
  br i1 %cmp, label %if.then, label %lor.lhs.false, !dbg !2057

lor.lhs.false:                                    ; preds = %entry
  %u1 = bitcast %union.long_double_bits* %fb to %struct.uqwords*, !dbg !2058
  %high2 = getelementptr inbounds %struct.uqwords, %struct.uqwords* %u1, i32 0, i32 1, !dbg !2059
  %s3 = bitcast %union.udwords* %high2 to %struct.anon*, !dbg !2060
  %low4 = getelementptr inbounds %struct.anon, %struct.anon* %s3, i32 0, i32 0, !dbg !2061
  %3 = load i32, i32* %low4, align 8, !dbg !2061
  %and5 = and i32 %3, 32768, !dbg !2062
  %tobool = icmp ne i32 %and5, 0, !dbg !2062
  br i1 %tobool, label %if.then, label %if.end, !dbg !2055

if.then:                                          ; preds = %lor.lhs.false, %entry
  store i32 0, i32* %retval, align 4, !dbg !2063
  br label %return, !dbg !2063

if.end:                                           ; preds = %lor.lhs.false
  %4 = load i32, i32* %e, align 4, !dbg !2064
  %cmp6 = icmp ugt i32 %4, 32, !dbg !2065
  br i1 %cmp6, label %if.then7, label %if.end8, !dbg !2066

if.then7:                                         ; preds = %if.end
  store i32 -1, i32* %retval, align 4, !dbg !2067
  br label %return, !dbg !2067

if.end8:                                          ; preds = %if.end
  %u9 = bitcast %union.long_double_bits* %fb to %struct.uqwords*, !dbg !2068
  %low10 = getelementptr inbounds %struct.uqwords, %struct.uqwords* %u9, i32 0, i32 0, !dbg !2069
  %s11 = bitcast %union.udwords* %low10 to %struct.anon*, !dbg !2070
  %high12 = getelementptr inbounds %struct.anon, %struct.anon* %s11, i32 0, i32 1, !dbg !2071
  %5 = load i32, i32* %high12, align 4, !dbg !2071
  %6 = load i32, i32* %e, align 4, !dbg !2072
  %sub13 = sub nsw i32 31, %6, !dbg !2073
  %shr = lshr i32 %5, %sub13, !dbg !2074
  store i32 %shr, i32* %retval, align 4, !dbg !2075
  br label %return, !dbg !2075

return:                                           ; preds = %if.end8, %if.then7, %if.then
  %7 = load i32, i32* %retval, align 4, !dbg !2076
  ret i32 %7, !dbg !2076
}

; Function Attrs: noinline nounwind
define dso_local i64 @__fixxfdi(fp128 %a) #0 !dbg !2077 {
entry:
  %retval = alloca i64, align 8
  %a.addr = alloca fp128, align 16
  %di_max = alloca i64, align 8
  %di_min = alloca i64, align 8
  %fb = alloca %union.long_double_bits, align 16
  %e = alloca i32, align 4
  %s5 = alloca i64, align 8
  %r = alloca i64, align 8
  store fp128 %a, fp128* %a.addr, align 16
  store i64 9223372036854775807, i64* %di_max, align 8, !dbg !2078
  store i64 -9223372036854775808, i64* %di_min, align 8, !dbg !2079
  %0 = load fp128, fp128* %a.addr, align 16, !dbg !2080
  %f = bitcast %union.long_double_bits* %fb to fp128*, !dbg !2081
  store fp128 %0, fp128* %f, align 16, !dbg !2082
  %u = bitcast %union.long_double_bits* %fb to %struct.uqwords*, !dbg !2083
  %high = getelementptr inbounds %struct.uqwords, %struct.uqwords* %u, i32 0, i32 1, !dbg !2084
  %s = bitcast %union.udwords* %high to %struct.anon*, !dbg !2085
  %low = getelementptr inbounds %struct.anon, %struct.anon* %s, i32 0, i32 0, !dbg !2086
  %1 = load i32, i32* %low, align 8, !dbg !2086
  %and = and i32 %1, 32767, !dbg !2087
  %sub = sub i32 %and, 16383, !dbg !2088
  store i32 %sub, i32* %e, align 4, !dbg !2089
  %2 = load i32, i32* %e, align 4, !dbg !2090
  %cmp = icmp slt i32 %2, 0, !dbg !2091
  br i1 %cmp, label %if.then, label %if.end, !dbg !2090

if.then:                                          ; preds = %entry
  store i64 0, i64* %retval, align 8, !dbg !2092
  br label %return, !dbg !2092

if.end:                                           ; preds = %entry
  %3 = load i32, i32* %e, align 4, !dbg !2093
  %cmp1 = icmp uge i32 %3, 64, !dbg !2094
  br i1 %cmp1, label %if.then2, label %if.end4, !dbg !2095

if.then2:                                         ; preds = %if.end
  %4 = load fp128, fp128* %a.addr, align 16, !dbg !2096
  %cmp3 = fcmp ogt fp128 %4, 0xL00000000000000000000000000000000, !dbg !2097
  %5 = zext i1 %cmp3 to i64, !dbg !2096
  %cond = select i1 %cmp3, i64 9223372036854775807, i64 -9223372036854775808, !dbg !2096
  store i64 %cond, i64* %retval, align 8, !dbg !2098
  br label %return, !dbg !2098

if.end4:                                          ; preds = %if.end
  %u6 = bitcast %union.long_double_bits* %fb to %struct.uqwords*, !dbg !2099
  %high7 = getelementptr inbounds %struct.uqwords, %struct.uqwords* %u6, i32 0, i32 1, !dbg !2100
  %s8 = bitcast %union.udwords* %high7 to %struct.anon*, !dbg !2101
  %low9 = getelementptr inbounds %struct.anon, %struct.anon* %s8, i32 0, i32 0, !dbg !2102
  %6 = load i32, i32* %low9, align 8, !dbg !2102
  %and10 = and i32 %6, 32768, !dbg !2103
  %shr = lshr i32 %and10, 15, !dbg !2104
  %sub11 = sub nsw i32 0, %shr, !dbg !2105
  %conv = sext i32 %sub11 to i64, !dbg !2105
  store i64 %conv, i64* %s5, align 8, !dbg !2106
  %u12 = bitcast %union.long_double_bits* %fb to %struct.uqwords*, !dbg !2107
  %low13 = getelementptr inbounds %struct.uqwords, %struct.uqwords* %u12, i32 0, i32 0, !dbg !2108
  %all = bitcast %union.udwords* %low13 to i64*, !dbg !2109
  %7 = load i64, i64* %all, align 16, !dbg !2109
  store i64 %7, i64* %r, align 8, !dbg !2110
  %8 = load i64, i64* %r, align 8, !dbg !2111
  %9 = load i32, i32* %e, align 4, !dbg !2112
  %sub14 = sub nsw i32 63, %9, !dbg !2113
  %sh_prom = zext i32 %sub14 to i64, !dbg !2114
  %shr15 = lshr i64 %8, %sh_prom, !dbg !2114
  store i64 %shr15, i64* %r, align 8, !dbg !2115
  %10 = load i64, i64* %r, align 8, !dbg !2116
  %11 = load i64, i64* %s5, align 8, !dbg !2117
  %xor = xor i64 %10, %11, !dbg !2118
  %12 = load i64, i64* %s5, align 8, !dbg !2119
  %sub16 = sub nsw i64 %xor, %12, !dbg !2120
  store i64 %sub16, i64* %retval, align 8, !dbg !2121
  br label %return, !dbg !2121

return:                                           ; preds = %if.end4, %if.then2, %if.then
  %13 = load i64, i64* %retval, align 8, !dbg !2122
  ret i64 %13, !dbg !2122
}

; Function Attrs: noinline nounwind
define dso_local double @__floatdidf(i64 %a) #0 !dbg !2123 {
entry:
  %a.addr = alloca i64, align 8
  %low = alloca %union.udwords, align 8
  %high = alloca double, align 8
  %result = alloca double, align 8
  store i64 %a, i64* %a.addr, align 8
  %0 = bitcast %union.udwords* %low to i8*, !dbg !2124
  call void @llvm.memcpy.p0i8.p0i8.i32(i8* align 8 %0, i8* align 8 bitcast ({ double }* @__floatdidf.low to i8*), i32 8, i1 false), !dbg !2124
  %1 = load i64, i64* %a.addr, align 8, !dbg !2125
  %shr = ashr i64 %1, 32, !dbg !2126
  %conv = trunc i64 %shr to i32, !dbg !2127
  %conv1 = sitofp i32 %conv to double, !dbg !2127
  %mul = fmul double %conv1, 0x41F0000000000000, !dbg !2128
  store double %mul, double* %high, align 8, !dbg !2129
  %2 = load i64, i64* %a.addr, align 8, !dbg !2130
  %and = and i64 %2, 4294967295, !dbg !2131
  %x = bitcast %union.udwords* %low to i64*, !dbg !2132
  %3 = load i64, i64* %x, align 8, !dbg !2133
  %or = or i64 %3, %and, !dbg !2133
  store i64 %or, i64* %x, align 8, !dbg !2133
  %4 = load double, double* %high, align 8, !dbg !2134
  %sub = fsub double %4, 0x4330000000000000, !dbg !2135
  %d = bitcast %union.udwords* %low to double*, !dbg !2136
  %5 = load double, double* %d, align 8, !dbg !2136
  %add = fadd double %sub, %5, !dbg !2137
  store double %add, double* %result, align 8, !dbg !2138
  %6 = load double, double* %result, align 8, !dbg !2139
  ret double %6, !dbg !2140
}

; Function Attrs: argmemonly nounwind
declare void @llvm.memcpy.p0i8.p0i8.i32(i8* nocapture writeonly, i8* nocapture readonly, i32, i1) #2

; Function Attrs: noinline nounwind
define dso_local float @__floatdisf(i64 %a) #0 !dbg !2141 {
entry:
  %retval = alloca float, align 4
  %a.addr = alloca i64, align 8
  %N = alloca i32, align 4
  %s = alloca i64, align 8
  %sd = alloca i32, align 4
  %e = alloca i32, align 4
  %fb = alloca %union.float_bits, align 4
  store i64 %a, i64* %a.addr, align 8
  %0 = load i64, i64* %a.addr, align 8, !dbg !2142
  %cmp = icmp eq i64 %0, 0, !dbg !2143
  br i1 %cmp, label %if.then, label %if.end, !dbg !2142

if.then:                                          ; preds = %entry
  store float 0.000000e+00, float* %retval, align 4, !dbg !2144
  br label %return, !dbg !2144

if.end:                                           ; preds = %entry
  store i32 64, i32* %N, align 4, !dbg !2145
  %1 = load i64, i64* %a.addr, align 8, !dbg !2146
  %shr = ashr i64 %1, 63, !dbg !2147
  store i64 %shr, i64* %s, align 8, !dbg !2148
  %2 = load i64, i64* %a.addr, align 8, !dbg !2149
  %3 = load i64, i64* %s, align 8, !dbg !2150
  %xor = xor i64 %2, %3, !dbg !2151
  %4 = load i64, i64* %s, align 8, !dbg !2152
  %sub = sub nsw i64 %xor, %4, !dbg !2153
  store i64 %sub, i64* %a.addr, align 8, !dbg !2154
  %5 = load i64, i64* %a.addr, align 8, !dbg !2155
  %6 = call i64 @llvm.ctlz.i64(i64 %5, i1 true), !dbg !2156
  %cast = trunc i64 %6 to i32, !dbg !2156
  %sub1 = sub i32 64, %cast, !dbg !2157
  store i32 %sub1, i32* %sd, align 4, !dbg !2158
  %7 = load i32, i32* %sd, align 4, !dbg !2159
  %sub2 = sub nsw i32 %7, 1, !dbg !2160
  store i32 %sub2, i32* %e, align 4, !dbg !2161
  %8 = load i32, i32* %sd, align 4, !dbg !2162
  %cmp3 = icmp sgt i32 %8, 24, !dbg !2163
  br i1 %cmp3, label %if.then4, label %if.else, !dbg !2162

if.then4:                                         ; preds = %if.end
  %9 = load i32, i32* %sd, align 4, !dbg !2164
  switch i32 %9, label %sw.default [
    i32 25, label %sw.bb
    i32 26, label %sw.bb5
  ], !dbg !2165

sw.bb:                                            ; preds = %if.then4
  %10 = load i64, i64* %a.addr, align 8, !dbg !2166
  %shl = shl i64 %10, 1, !dbg !2166
  store i64 %shl, i64* %a.addr, align 8, !dbg !2166
  br label %sw.epilog, !dbg !2167

sw.bb5:                                           ; preds = %if.then4
  br label %sw.epilog, !dbg !2168

sw.default:                                       ; preds = %if.then4
  %11 = load i64, i64* %a.addr, align 8, !dbg !2169
  %12 = load i32, i32* %sd, align 4, !dbg !2170
  %sub6 = sub nsw i32 %12, 26, !dbg !2171
  %sh_prom = zext i32 %sub6 to i64, !dbg !2172
  %shr7 = lshr i64 %11, %sh_prom, !dbg !2172
  %13 = load i64, i64* %a.addr, align 8, !dbg !2173
  %14 = load i32, i32* %sd, align 4, !dbg !2174
  %sub8 = sub i32 90, %14, !dbg !2175
  %sh_prom9 = zext i32 %sub8 to i64, !dbg !2176
  %shr10 = lshr i64 -1, %sh_prom9, !dbg !2176
  %and = and i64 %13, %shr10, !dbg !2177
  %cmp11 = icmp ne i64 %and, 0, !dbg !2178
  %conv = zext i1 %cmp11 to i32, !dbg !2178
  %conv12 = sext i32 %conv to i64, !dbg !2179
  %or = or i64 %shr7, %conv12, !dbg !2180
  store i64 %or, i64* %a.addr, align 8, !dbg !2181
  br label %sw.epilog, !dbg !2182

sw.epilog:                                        ; preds = %sw.default, %sw.bb5, %sw.bb
  %15 = load i64, i64* %a.addr, align 8, !dbg !2183
  %and13 = and i64 %15, 4, !dbg !2184
  %cmp14 = icmp ne i64 %and13, 0, !dbg !2185
  %conv15 = zext i1 %cmp14 to i32, !dbg !2185
  %conv16 = sext i32 %conv15 to i64, !dbg !2186
  %16 = load i64, i64* %a.addr, align 8, !dbg !2187
  %or17 = or i64 %16, %conv16, !dbg !2187
  store i64 %or17, i64* %a.addr, align 8, !dbg !2187
  %17 = load i64, i64* %a.addr, align 8, !dbg !2188
  %inc = add nsw i64 %17, 1, !dbg !2188
  store i64 %inc, i64* %a.addr, align 8, !dbg !2188
  %18 = load i64, i64* %a.addr, align 8, !dbg !2189
  %shr18 = ashr i64 %18, 2, !dbg !2189
  store i64 %shr18, i64* %a.addr, align 8, !dbg !2189
  %19 = load i64, i64* %a.addr, align 8, !dbg !2190
  %and19 = and i64 %19, 16777216, !dbg !2191
  %tobool = icmp ne i64 %and19, 0, !dbg !2191
  br i1 %tobool, label %if.then20, label %if.end23, !dbg !2190

if.then20:                                        ; preds = %sw.epilog
  %20 = load i64, i64* %a.addr, align 8, !dbg !2192
  %shr21 = ashr i64 %20, 1, !dbg !2192
  store i64 %shr21, i64* %a.addr, align 8, !dbg !2192
  %21 = load i32, i32* %e, align 4, !dbg !2193
  %inc22 = add nsw i32 %21, 1, !dbg !2193
  store i32 %inc22, i32* %e, align 4, !dbg !2193
  br label %if.end23, !dbg !2194

if.end23:                                         ; preds = %if.then20, %sw.epilog
  br label %if.end27, !dbg !2195

if.else:                                          ; preds = %if.end
  %22 = load i32, i32* %sd, align 4, !dbg !2196
  %sub24 = sub nsw i32 24, %22, !dbg !2197
  %23 = load i64, i64* %a.addr, align 8, !dbg !2198
  %sh_prom25 = zext i32 %sub24 to i64, !dbg !2198
  %shl26 = shl i64 %23, %sh_prom25, !dbg !2198
  store i64 %shl26, i64* %a.addr, align 8, !dbg !2198
  br label %if.end27

if.end27:                                         ; preds = %if.else, %if.end23
  %24 = load i64, i64* %s, align 8, !dbg !2199
  %conv28 = trunc i64 %24 to i32, !dbg !2200
  %and29 = and i32 %conv28, -2147483648, !dbg !2201
  %25 = load i32, i32* %e, align 4, !dbg !2202
  %add = add nsw i32 %25, 127, !dbg !2203
  %shl30 = shl i32 %add, 23, !dbg !2204
  %or31 = or i32 %and29, %shl30, !dbg !2205
  %26 = load i64, i64* %a.addr, align 8, !dbg !2206
  %conv32 = trunc i64 %26 to i32, !dbg !2207
  %and33 = and i32 %conv32, 8388607, !dbg !2208
  %or34 = or i32 %or31, %and33, !dbg !2209
  %u = bitcast %union.float_bits* %fb to i32*, !dbg !2210
  store i32 %or34, i32* %u, align 4, !dbg !2211
  %f = bitcast %union.float_bits* %fb to float*, !dbg !2212
  %27 = load float, float* %f, align 4, !dbg !2212
  store float %27, float* %retval, align 4, !dbg !2213
  br label %return, !dbg !2213

return:                                           ; preds = %if.end27, %if.then
  %28 = load float, float* %retval, align 4, !dbg !2214
  ret float %28, !dbg !2214
}

; Function Attrs: nounwind readnone speculatable
declare i64 @llvm.ctlz.i64(i64, i1) #1

; Function Attrs: noinline nounwind
define dso_local fp128 @__floatdixf(i64 %a) #0 !dbg !2215 {
entry:
  %retval = alloca fp128, align 16
  %a.addr = alloca i64, align 8
  %N = alloca i32, align 4
  %s = alloca i64, align 8
  %clz = alloca i32, align 4
  %e = alloca i32, align 4
  %fb = alloca %union.long_double_bits, align 16
  store i64 %a, i64* %a.addr, align 8
  %0 = load i64, i64* %a.addr, align 8, !dbg !2216
  %cmp = icmp eq i64 %0, 0, !dbg !2217
  br i1 %cmp, label %if.then, label %if.end, !dbg !2216

if.then:                                          ; preds = %entry
  store fp128 0xL00000000000000000000000000000000, fp128* %retval, align 16, !dbg !2218
  br label %return, !dbg !2218

if.end:                                           ; preds = %entry
  store i32 64, i32* %N, align 4, !dbg !2219
  %1 = load i64, i64* %a.addr, align 8, !dbg !2220
  %shr = ashr i64 %1, 63, !dbg !2221
  store i64 %shr, i64* %s, align 8, !dbg !2222
  %2 = load i64, i64* %a.addr, align 8, !dbg !2223
  %3 = load i64, i64* %s, align 8, !dbg !2224
  %xor = xor i64 %2, %3, !dbg !2225
  %4 = load i64, i64* %s, align 8, !dbg !2226
  %sub = sub nsw i64 %xor, %4, !dbg !2227
  store i64 %sub, i64* %a.addr, align 8, !dbg !2228
  %5 = load i64, i64* %a.addr, align 8, !dbg !2229
  %6 = call i64 @llvm.ctlz.i64(i64 %5, i1 true), !dbg !2230
  %cast = trunc i64 %6 to i32, !dbg !2230
  store i32 %cast, i32* %clz, align 4, !dbg !2231
  %7 = load i32, i32* %clz, align 4, !dbg !2232
  %sub1 = sub i32 63, %7, !dbg !2233
  store i32 %sub1, i32* %e, align 4, !dbg !2234
  %8 = load i64, i64* %s, align 8, !dbg !2235
  %conv = trunc i64 %8 to i32, !dbg !2236
  %and = and i32 %conv, 32768, !dbg !2237
  %9 = load i32, i32* %e, align 4, !dbg !2238
  %add = add nsw i32 %9, 16383, !dbg !2239
  %or = or i32 %and, %add, !dbg !2240
  %u = bitcast %union.long_double_bits* %fb to %struct.uqwords*, !dbg !2241
  %high = getelementptr inbounds %struct.uqwords, %struct.uqwords* %u, i32 0, i32 1, !dbg !2242
  %s2 = bitcast %union.udwords* %high to %struct.anon*, !dbg !2243
  %low = getelementptr inbounds %struct.anon, %struct.anon* %s2, i32 0, i32 0, !dbg !2244
  store i32 %or, i32* %low, align 8, !dbg !2245
  %10 = load i64, i64* %a.addr, align 8, !dbg !2246
  %11 = load i32, i32* %clz, align 4, !dbg !2247
  %sh_prom = zext i32 %11 to i64, !dbg !2248
  %shl = shl i64 %10, %sh_prom, !dbg !2248
  %u3 = bitcast %union.long_double_bits* %fb to %struct.uqwords*, !dbg !2249
  %low4 = getelementptr inbounds %struct.uqwords, %struct.uqwords* %u3, i32 0, i32 0, !dbg !2250
  %all = bitcast %union.udwords* %low4 to i64*, !dbg !2251
  store i64 %shl, i64* %all, align 16, !dbg !2252
  %f = bitcast %union.long_double_bits* %fb to fp128*, !dbg !2253
  %12 = load fp128, fp128* %f, align 16, !dbg !2253
  store fp128 %12, fp128* %retval, align 16, !dbg !2254
  br label %return, !dbg !2254

return:                                           ; preds = %if.end, %if.then
  %13 = load fp128, fp128* %retval, align 16, !dbg !2255
  ret fp128 %13, !dbg !2255
}

; Function Attrs: noinline nounwind
define dso_local double @__floatsidf(i32 %a) #0 !dbg !2256 {
entry:
  %retval = alloca double, align 8
  %a.addr = alloca i32, align 4
  %aWidth = alloca i32, align 4
  %sign = alloca i64, align 8
  %exponent = alloca i32, align 4
  %result = alloca i64, align 8
  %shift = alloca i32, align 4
  store i32 %a, i32* %a.addr, align 4
  store i32 32, i32* %aWidth, align 4, !dbg !2257
  %0 = load i32, i32* %a.addr, align 4, !dbg !2258
  %cmp = icmp eq i32 %0, 0, !dbg !2259
  br i1 %cmp, label %if.then, label %if.end, !dbg !2258

if.then:                                          ; preds = %entry
  %call = call double @fromRep.29(i64 0) #4, !dbg !2260
  store double %call, double* %retval, align 8, !dbg !2261
  br label %return, !dbg !2261

if.end:                                           ; preds = %entry
  store i64 0, i64* %sign, align 8, !dbg !2262
  %1 = load i32, i32* %a.addr, align 4, !dbg !2263
  %cmp1 = icmp slt i32 %1, 0, !dbg !2264
  br i1 %cmp1, label %if.then2, label %if.end3, !dbg !2263

if.then2:                                         ; preds = %if.end
  store i64 -9223372036854775808, i64* %sign, align 8, !dbg !2265
  %2 = load i32, i32* %a.addr, align 4, !dbg !2266
  %sub = sub nsw i32 0, %2, !dbg !2267
  store i32 %sub, i32* %a.addr, align 4, !dbg !2268
  br label %if.end3, !dbg !2269

if.end3:                                          ; preds = %if.then2, %if.end
  %3 = load i32, i32* %a.addr, align 4, !dbg !2270
  %4 = call i32 @llvm.ctlz.i32(i32 %3, i1 true), !dbg !2271
  %sub4 = sub nsw i32 31, %4, !dbg !2272
  store i32 %sub4, i32* %exponent, align 4, !dbg !2273
  %5 = load i32, i32* %exponent, align 4, !dbg !2274
  %sub5 = sub nsw i32 52, %5, !dbg !2275
  store i32 %sub5, i32* %shift, align 4, !dbg !2276
  %6 = load i32, i32* %a.addr, align 4, !dbg !2277
  %conv = zext i32 %6 to i64, !dbg !2278
  %7 = load i32, i32* %shift, align 4, !dbg !2279
  %sh_prom = zext i32 %7 to i64, !dbg !2280
  %shl = shl i64 %conv, %sh_prom, !dbg !2280
  %xor = xor i64 %shl, 4503599627370496, !dbg !2281
  store i64 %xor, i64* %result, align 8, !dbg !2282
  %8 = load i32, i32* %exponent, align 4, !dbg !2283
  %add = add nsw i32 %8, 1023, !dbg !2284
  %conv6 = sext i32 %add to i64, !dbg !2285
  %shl7 = shl i64 %conv6, 52, !dbg !2286
  %9 = load i64, i64* %result, align 8, !dbg !2287
  %add8 = add i64 %9, %shl7, !dbg !2287
  store i64 %add8, i64* %result, align 8, !dbg !2287
  %10 = load i64, i64* %result, align 8, !dbg !2288
  %11 = load i64, i64* %sign, align 8, !dbg !2289
  %or = or i64 %10, %11, !dbg !2290
  %call9 = call double @fromRep.29(i64 %or) #4, !dbg !2291
  store double %call9, double* %retval, align 8, !dbg !2292
  br label %return, !dbg !2292

return:                                           ; preds = %if.end3, %if.then
  %12 = load double, double* %retval, align 8, !dbg !2293
  ret double %12, !dbg !2293
}

; Function Attrs: noinline nounwind
define internal double @fromRep.29(i64 %x) #0 !dbg !2294 {
entry:
  %x.addr = alloca i64, align 8
  %rep = alloca %union.anon.0, align 8
  store i64 %x, i64* %x.addr, align 8
  %i = bitcast %union.anon.0* %rep to i64*, !dbg !2295
  %0 = load i64, i64* %x.addr, align 8, !dbg !2296
  store i64 %0, i64* %i, align 8, !dbg !2295
  %f = bitcast %union.anon.0* %rep to double*, !dbg !2297
  %1 = load double, double* %f, align 8, !dbg !2297
  ret double %1, !dbg !2298
}

; Function Attrs: noinline nounwind
define dso_local float @__floatsisf(i32 %a) #0 !dbg !2299 {
entry:
  %retval = alloca float, align 4
  %a.addr = alloca i32, align 4
  %aWidth = alloca i32, align 4
  %sign = alloca i32, align 4
  %exponent = alloca i32, align 4
  %result = alloca i32, align 4
  %shift = alloca i32, align 4
  %shift8 = alloca i32, align 4
  %round = alloca i32, align 4
  store i32 %a, i32* %a.addr, align 4
  store i32 32, i32* %aWidth, align 4, !dbg !2300
  %0 = load i32, i32* %a.addr, align 4, !dbg !2301
  %cmp = icmp eq i32 %0, 0, !dbg !2302
  br i1 %cmp, label %if.then, label %if.end, !dbg !2301

if.then:                                          ; preds = %entry
  %call = call float @fromRep.30(i32 0) #4, !dbg !2303
  store float %call, float* %retval, align 4, !dbg !2304
  br label %return, !dbg !2304

if.end:                                           ; preds = %entry
  store i32 0, i32* %sign, align 4, !dbg !2305
  %1 = load i32, i32* %a.addr, align 4, !dbg !2306
  %cmp1 = icmp slt i32 %1, 0, !dbg !2307
  br i1 %cmp1, label %if.then2, label %if.end3, !dbg !2306

if.then2:                                         ; preds = %if.end
  store i32 -2147483648, i32* %sign, align 4, !dbg !2308
  %2 = load i32, i32* %a.addr, align 4, !dbg !2309
  %sub = sub nsw i32 0, %2, !dbg !2310
  store i32 %sub, i32* %a.addr, align 4, !dbg !2311
  br label %if.end3, !dbg !2312

if.end3:                                          ; preds = %if.then2, %if.end
  %3 = load i32, i32* %a.addr, align 4, !dbg !2313
  %4 = call i32 @llvm.ctlz.i32(i32 %3, i1 true), !dbg !2314
  %sub4 = sub nsw i32 31, %4, !dbg !2315
  store i32 %sub4, i32* %exponent, align 4, !dbg !2316
  %5 = load i32, i32* %exponent, align 4, !dbg !2317
  %cmp5 = icmp sle i32 %5, 23, !dbg !2318
  br i1 %cmp5, label %if.then6, label %if.else, !dbg !2317

if.then6:                                         ; preds = %if.end3
  %6 = load i32, i32* %exponent, align 4, !dbg !2319
  %sub7 = sub nsw i32 23, %6, !dbg !2320
  store i32 %sub7, i32* %shift, align 4, !dbg !2321
  %7 = load i32, i32* %a.addr, align 4, !dbg !2322
  %8 = load i32, i32* %shift, align 4, !dbg !2323
  %shl = shl i32 %7, %8, !dbg !2324
  %xor = xor i32 %shl, 8388608, !dbg !2325
  store i32 %xor, i32* %result, align 4, !dbg !2326
  br label %if.end19, !dbg !2327

if.else:                                          ; preds = %if.end3
  %9 = load i32, i32* %exponent, align 4, !dbg !2328
  %sub9 = sub nsw i32 %9, 23, !dbg !2329
  store i32 %sub9, i32* %shift8, align 4, !dbg !2330
  %10 = load i32, i32* %a.addr, align 4, !dbg !2331
  %11 = load i32, i32* %shift8, align 4, !dbg !2332
  %shr = lshr i32 %10, %11, !dbg !2333
  %xor10 = xor i32 %shr, 8388608, !dbg !2334
  store i32 %xor10, i32* %result, align 4, !dbg !2335
  %12 = load i32, i32* %a.addr, align 4, !dbg !2336
  %13 = load i32, i32* %shift8, align 4, !dbg !2337
  %sub11 = sub i32 32, %13, !dbg !2338
  %shl12 = shl i32 %12, %sub11, !dbg !2339
  store i32 %shl12, i32* %round, align 4, !dbg !2340
  %14 = load i32, i32* %round, align 4, !dbg !2341
  %cmp13 = icmp ugt i32 %14, -2147483648, !dbg !2342
  br i1 %cmp13, label %if.then14, label %if.end15, !dbg !2341

if.then14:                                        ; preds = %if.else
  %15 = load i32, i32* %result, align 4, !dbg !2343
  %inc = add i32 %15, 1, !dbg !2343
  store i32 %inc, i32* %result, align 4, !dbg !2343
  br label %if.end15, !dbg !2344

if.end15:                                         ; preds = %if.then14, %if.else
  %16 = load i32, i32* %round, align 4, !dbg !2345
  %cmp16 = icmp eq i32 %16, -2147483648, !dbg !2346
  br i1 %cmp16, label %if.then17, label %if.end18, !dbg !2345

if.then17:                                        ; preds = %if.end15
  %17 = load i32, i32* %result, align 4, !dbg !2347
  %and = and i32 %17, 1, !dbg !2348
  %18 = load i32, i32* %result, align 4, !dbg !2349
  %add = add i32 %18, %and, !dbg !2349
  store i32 %add, i32* %result, align 4, !dbg !2349
  br label %if.end18, !dbg !2350

if.end18:                                         ; preds = %if.then17, %if.end15
  br label %if.end19

if.end19:                                         ; preds = %if.end18, %if.then6
  %19 = load i32, i32* %exponent, align 4, !dbg !2351
  %add20 = add nsw i32 %19, 127, !dbg !2352
  %shl21 = shl i32 %add20, 23, !dbg !2353
  %20 = load i32, i32* %result, align 4, !dbg !2354
  %add22 = add i32 %20, %shl21, !dbg !2354
  store i32 %add22, i32* %result, align 4, !dbg !2354
  %21 = load i32, i32* %result, align 4, !dbg !2355
  %22 = load i32, i32* %sign, align 4, !dbg !2356
  %or = or i32 %21, %22, !dbg !2357
  %call23 = call float @fromRep.30(i32 %or) #4, !dbg !2358
  store float %call23, float* %retval, align 4, !dbg !2359
  br label %return, !dbg !2359

return:                                           ; preds = %if.end19, %if.then
  %23 = load float, float* %retval, align 4, !dbg !2360
  ret float %23, !dbg !2360
}

; Function Attrs: noinline nounwind
define internal float @fromRep.30(i32 %x) #0 !dbg !2361 {
entry:
  %x.addr = alloca i32, align 4
  %rep = alloca %union.anon.0.0, align 4
  store i32 %x, i32* %x.addr, align 4
  %i = bitcast %union.anon.0.0* %rep to i32*, !dbg !2362
  %0 = load i32, i32* %x.addr, align 4, !dbg !2363
  store i32 %0, i32* %i, align 4, !dbg !2362
  %f = bitcast %union.anon.0.0* %rep to float*, !dbg !2364
  %1 = load float, float* %f, align 4, !dbg !2364
  ret float %1, !dbg !2365
}

; Function Attrs: noinline nounwind
define dso_local double @__floatundidf(i64 %a) #0 !dbg !2366 {
entry:
  %a.addr = alloca i64, align 8
  %high = alloca %union.udwords, align 8
  %low = alloca %union.udwords, align 8
  %result = alloca double, align 8
  store i64 %a, i64* %a.addr, align 8
  %0 = bitcast %union.udwords* %high to i8*, !dbg !2367
  call void @llvm.memcpy.p0i8.p0i8.i32(i8* align 8 %0, i8* align 8 bitcast ({ double }* @__floatundidf.high to i8*), i32 8, i1 false), !dbg !2367
  %1 = bitcast %union.udwords* %low to i8*, !dbg !2368
  call void @llvm.memcpy.p0i8.p0i8.i32(i8* align 8 %1, i8* align 8 bitcast ({ double }* @__floatundidf.low to i8*), i32 8, i1 false), !dbg !2368
  %2 = load i64, i64* %a.addr, align 8, !dbg !2369
  %shr = lshr i64 %2, 32, !dbg !2370
  %x = bitcast %union.udwords* %high to i64*, !dbg !2371
  %3 = load i64, i64* %x, align 8, !dbg !2372
  %or = or i64 %3, %shr, !dbg !2372
  store i64 %or, i64* %x, align 8, !dbg !2372
  %4 = load i64, i64* %a.addr, align 8, !dbg !2373
  %and = and i64 %4, 4294967295, !dbg !2374
  %x1 = bitcast %union.udwords* %low to i64*, !dbg !2375
  %5 = load i64, i64* %x1, align 8, !dbg !2376
  %or2 = or i64 %5, %and, !dbg !2376
  store i64 %or2, i64* %x1, align 8, !dbg !2376
  %d = bitcast %union.udwords* %high to double*, !dbg !2377
  %6 = load double, double* %d, align 8, !dbg !2377
  %sub = fsub double %6, 0x4530000000100000, !dbg !2378
  %d3 = bitcast %union.udwords* %low to double*, !dbg !2379
  %7 = load double, double* %d3, align 8, !dbg !2379
  %add = fadd double %sub, %7, !dbg !2380
  store double %add, double* %result, align 8, !dbg !2381
  %8 = load double, double* %result, align 8, !dbg !2382
  ret double %8, !dbg !2383
}

; Function Attrs: noinline nounwind
define dso_local float @__floatundisf(i64 %a) #0 !dbg !2384 {
entry:
  %retval = alloca float, align 4
  %a.addr = alloca i64, align 8
  %N = alloca i32, align 4
  %sd = alloca i32, align 4
  %e = alloca i32, align 4
  %fb = alloca %union.float_bits, align 4
  store i64 %a, i64* %a.addr, align 8
  %0 = load i64, i64* %a.addr, align 8, !dbg !2385
  %cmp = icmp eq i64 %0, 0, !dbg !2386
  br i1 %cmp, label %if.then, label %if.end, !dbg !2385

if.then:                                          ; preds = %entry
  store float 0.000000e+00, float* %retval, align 4, !dbg !2387
  br label %return, !dbg !2387

if.end:                                           ; preds = %entry
  store i32 64, i32* %N, align 4, !dbg !2388
  %1 = load i64, i64* %a.addr, align 8, !dbg !2389
  %2 = call i64 @llvm.ctlz.i64(i64 %1, i1 true), !dbg !2390
  %cast = trunc i64 %2 to i32, !dbg !2390
  %sub = sub i32 64, %cast, !dbg !2391
  store i32 %sub, i32* %sd, align 4, !dbg !2392
  %3 = load i32, i32* %sd, align 4, !dbg !2393
  %sub1 = sub nsw i32 %3, 1, !dbg !2394
  store i32 %sub1, i32* %e, align 4, !dbg !2395
  %4 = load i32, i32* %sd, align 4, !dbg !2396
  %cmp2 = icmp sgt i32 %4, 24, !dbg !2397
  br i1 %cmp2, label %if.then3, label %if.else, !dbg !2396

if.then3:                                         ; preds = %if.end
  %5 = load i32, i32* %sd, align 4, !dbg !2398
  switch i32 %5, label %sw.default [
    i32 25, label %sw.bb
    i32 26, label %sw.bb4
  ], !dbg !2399

sw.bb:                                            ; preds = %if.then3
  %6 = load i64, i64* %a.addr, align 8, !dbg !2400
  %shl = shl i64 %6, 1, !dbg !2400
  store i64 %shl, i64* %a.addr, align 8, !dbg !2400
  br label %sw.epilog, !dbg !2401

sw.bb4:                                           ; preds = %if.then3
  br label %sw.epilog, !dbg !2402

sw.default:                                       ; preds = %if.then3
  %7 = load i64, i64* %a.addr, align 8, !dbg !2403
  %8 = load i32, i32* %sd, align 4, !dbg !2404
  %sub5 = sub nsw i32 %8, 26, !dbg !2405
  %sh_prom = zext i32 %sub5 to i64, !dbg !2406
  %shr = lshr i64 %7, %sh_prom, !dbg !2406
  %9 = load i64, i64* %a.addr, align 8, !dbg !2407
  %10 = load i32, i32* %sd, align 4, !dbg !2408
  %sub6 = sub i32 90, %10, !dbg !2409
  %sh_prom7 = zext i32 %sub6 to i64, !dbg !2410
  %shr8 = lshr i64 -1, %sh_prom7, !dbg !2410
  %and = and i64 %9, %shr8, !dbg !2411
  %cmp9 = icmp ne i64 %and, 0, !dbg !2412
  %conv = zext i1 %cmp9 to i32, !dbg !2412
  %conv10 = sext i32 %conv to i64, !dbg !2413
  %or = or i64 %shr, %conv10, !dbg !2414
  store i64 %or, i64* %a.addr, align 8, !dbg !2415
  br label %sw.epilog, !dbg !2416

sw.epilog:                                        ; preds = %sw.default, %sw.bb4, %sw.bb
  %11 = load i64, i64* %a.addr, align 8, !dbg !2417
  %and11 = and i64 %11, 4, !dbg !2418
  %cmp12 = icmp ne i64 %and11, 0, !dbg !2419
  %conv13 = zext i1 %cmp12 to i32, !dbg !2419
  %conv14 = sext i32 %conv13 to i64, !dbg !2420
  %12 = load i64, i64* %a.addr, align 8, !dbg !2421
  %or15 = or i64 %12, %conv14, !dbg !2421
  store i64 %or15, i64* %a.addr, align 8, !dbg !2421
  %13 = load i64, i64* %a.addr, align 8, !dbg !2422
  %inc = add i64 %13, 1, !dbg !2422
  store i64 %inc, i64* %a.addr, align 8, !dbg !2422
  %14 = load i64, i64* %a.addr, align 8, !dbg !2423
  %shr16 = lshr i64 %14, 2, !dbg !2423
  store i64 %shr16, i64* %a.addr, align 8, !dbg !2423
  %15 = load i64, i64* %a.addr, align 8, !dbg !2424
  %and17 = and i64 %15, 16777216, !dbg !2425
  %tobool = icmp ne i64 %and17, 0, !dbg !2425
  br i1 %tobool, label %if.then18, label %if.end21, !dbg !2424

if.then18:                                        ; preds = %sw.epilog
  %16 = load i64, i64* %a.addr, align 8, !dbg !2426
  %shr19 = lshr i64 %16, 1, !dbg !2426
  store i64 %shr19, i64* %a.addr, align 8, !dbg !2426
  %17 = load i32, i32* %e, align 4, !dbg !2427
  %inc20 = add nsw i32 %17, 1, !dbg !2427
  store i32 %inc20, i32* %e, align 4, !dbg !2427
  br label %if.end21, !dbg !2428

if.end21:                                         ; preds = %if.then18, %sw.epilog
  br label %if.end25, !dbg !2429

if.else:                                          ; preds = %if.end
  %18 = load i32, i32* %sd, align 4, !dbg !2430
  %sub22 = sub nsw i32 24, %18, !dbg !2431
  %19 = load i64, i64* %a.addr, align 8, !dbg !2432
  %sh_prom23 = zext i32 %sub22 to i64, !dbg !2432
  %shl24 = shl i64 %19, %sh_prom23, !dbg !2432
  store i64 %shl24, i64* %a.addr, align 8, !dbg !2432
  br label %if.end25

if.end25:                                         ; preds = %if.else, %if.end21
  %20 = load i32, i32* %e, align 4, !dbg !2433
  %add = add nsw i32 %20, 127, !dbg !2434
  %shl26 = shl i32 %add, 23, !dbg !2435
  %21 = load i64, i64* %a.addr, align 8, !dbg !2436
  %conv27 = trunc i64 %21 to i32, !dbg !2437
  %and28 = and i32 %conv27, 8388607, !dbg !2438
  %or29 = or i32 %shl26, %and28, !dbg !2439
  %u = bitcast %union.float_bits* %fb to i32*, !dbg !2440
  store i32 %or29, i32* %u, align 4, !dbg !2441
  %f = bitcast %union.float_bits* %fb to float*, !dbg !2442
  %22 = load float, float* %f, align 4, !dbg !2442
  store float %22, float* %retval, align 4, !dbg !2443
  br label %return, !dbg !2443

return:                                           ; preds = %if.end25, %if.then
  %23 = load float, float* %retval, align 4, !dbg !2444
  ret float %23, !dbg !2444
}

; Function Attrs: noinline nounwind
define dso_local fp128 @__floatundixf(i64 %a) #0 !dbg !2445 {
entry:
  %retval = alloca fp128, align 16
  %a.addr = alloca i64, align 8
  %N = alloca i32, align 4
  %clz = alloca i32, align 4
  %e = alloca i32, align 4
  %fb = alloca %union.long_double_bits, align 16
  store i64 %a, i64* %a.addr, align 8
  %0 = load i64, i64* %a.addr, align 8, !dbg !2446
  %cmp = icmp eq i64 %0, 0, !dbg !2447
  br i1 %cmp, label %if.then, label %if.end, !dbg !2446

if.then:                                          ; preds = %entry
  store fp128 0xL00000000000000000000000000000000, fp128* %retval, align 16, !dbg !2448
  br label %return, !dbg !2448

if.end:                                           ; preds = %entry
  store i32 64, i32* %N, align 4, !dbg !2449
  %1 = load i64, i64* %a.addr, align 8, !dbg !2450
  %2 = call i64 @llvm.ctlz.i64(i64 %1, i1 true), !dbg !2451
  %cast = trunc i64 %2 to i32, !dbg !2451
  store i32 %cast, i32* %clz, align 4, !dbg !2452
  %3 = load i32, i32* %clz, align 4, !dbg !2453
  %sub = sub i32 63, %3, !dbg !2454
  store i32 %sub, i32* %e, align 4, !dbg !2455
  %4 = load i32, i32* %e, align 4, !dbg !2456
  %add = add nsw i32 %4, 16383, !dbg !2457
  %u = bitcast %union.long_double_bits* %fb to %struct.uqwords*, !dbg !2458
  %high = getelementptr inbounds %struct.uqwords, %struct.uqwords* %u, i32 0, i32 1, !dbg !2459
  %s = bitcast %union.udwords* %high to %struct.anon*, !dbg !2460
  %low = getelementptr inbounds %struct.anon, %struct.anon* %s, i32 0, i32 0, !dbg !2461
  store i32 %add, i32* %low, align 8, !dbg !2462
  %5 = load i64, i64* %a.addr, align 8, !dbg !2463
  %6 = load i32, i32* %clz, align 4, !dbg !2464
  %sh_prom = zext i32 %6 to i64, !dbg !2465
  %shl = shl i64 %5, %sh_prom, !dbg !2465
  %u1 = bitcast %union.long_double_bits* %fb to %struct.uqwords*, !dbg !2466
  %low2 = getelementptr inbounds %struct.uqwords, %struct.uqwords* %u1, i32 0, i32 0, !dbg !2467
  %all = bitcast %union.udwords* %low2 to i64*, !dbg !2468
  store i64 %shl, i64* %all, align 16, !dbg !2469
  %f = bitcast %union.long_double_bits* %fb to fp128*, !dbg !2470
  %7 = load fp128, fp128* %f, align 16, !dbg !2470
  store fp128 %7, fp128* %retval, align 16, !dbg !2471
  br label %return, !dbg !2471

return:                                           ; preds = %if.end, %if.then
  %8 = load fp128, fp128* %retval, align 16, !dbg !2472
  ret fp128 %8, !dbg !2472
}

; Function Attrs: noinline nounwind
define dso_local double @__floatunsidf(i32 %a) #0 !dbg !2473 {
entry:
  %retval = alloca double, align 8
  %a.addr = alloca i32, align 4
  %aWidth = alloca i32, align 4
  %exponent = alloca i32, align 4
  %result = alloca i64, align 8
  %shift = alloca i32, align 4
  store i32 %a, i32* %a.addr, align 4
  store i32 32, i32* %aWidth, align 4, !dbg !2474
  %0 = load i32, i32* %a.addr, align 4, !dbg !2475
  %cmp = icmp eq i32 %0, 0, !dbg !2476
  br i1 %cmp, label %if.then, label %if.end, !dbg !2475

if.then:                                          ; preds = %entry
  %call = call double @fromRep.31(i64 0) #4, !dbg !2477
  store double %call, double* %retval, align 8, !dbg !2478
  br label %return, !dbg !2478

if.end:                                           ; preds = %entry
  %1 = load i32, i32* %a.addr, align 4, !dbg !2479
  %2 = call i32 @llvm.ctlz.i32(i32 %1, i1 true), !dbg !2480
  %sub = sub nsw i32 31, %2, !dbg !2481
  store i32 %sub, i32* %exponent, align 4, !dbg !2482
  %3 = load i32, i32* %exponent, align 4, !dbg !2483
  %sub1 = sub nsw i32 52, %3, !dbg !2484
  store i32 %sub1, i32* %shift, align 4, !dbg !2485
  %4 = load i32, i32* %a.addr, align 4, !dbg !2486
  %conv = zext i32 %4 to i64, !dbg !2487
  %5 = load i32, i32* %shift, align 4, !dbg !2488
  %sh_prom = zext i32 %5 to i64, !dbg !2489
  %shl = shl i64 %conv, %sh_prom, !dbg !2489
  %xor = xor i64 %shl, 4503599627370496, !dbg !2490
  store i64 %xor, i64* %result, align 8, !dbg !2491
  %6 = load i32, i32* %exponent, align 4, !dbg !2492
  %add = add nsw i32 %6, 1023, !dbg !2493
  %conv2 = sext i32 %add to i64, !dbg !2494
  %shl3 = shl i64 %conv2, 52, !dbg !2495
  %7 = load i64, i64* %result, align 8, !dbg !2496
  %add4 = add i64 %7, %shl3, !dbg !2496
  store i64 %add4, i64* %result, align 8, !dbg !2496
  %8 = load i64, i64* %result, align 8, !dbg !2497
  %call5 = call double @fromRep.31(i64 %8) #4, !dbg !2498
  store double %call5, double* %retval, align 8, !dbg !2499
  br label %return, !dbg !2499

return:                                           ; preds = %if.end, %if.then
  %9 = load double, double* %retval, align 8, !dbg !2500
  ret double %9, !dbg !2500
}

; Function Attrs: noinline nounwind
define internal double @fromRep.31(i64 %x) #0 !dbg !2501 {
entry:
  %x.addr = alloca i64, align 8
  %rep = alloca %union.anon.0, align 8
  store i64 %x, i64* %x.addr, align 8
  %i = bitcast %union.anon.0* %rep to i64*, !dbg !2502
  %0 = load i64, i64* %x.addr, align 8, !dbg !2503
  store i64 %0, i64* %i, align 8, !dbg !2502
  %f = bitcast %union.anon.0* %rep to double*, !dbg !2504
  %1 = load double, double* %f, align 8, !dbg !2504
  ret double %1, !dbg !2505
}

; Function Attrs: noinline nounwind
define dso_local float @__floatunsisf(i32 %a) #0 !dbg !2506 {
entry:
  %retval = alloca float, align 4
  %a.addr = alloca i32, align 4
  %aWidth = alloca i32, align 4
  %exponent = alloca i32, align 4
  %result = alloca i32, align 4
  %shift = alloca i32, align 4
  %shift4 = alloca i32, align 4
  %round = alloca i32, align 4
  store i32 %a, i32* %a.addr, align 4
  store i32 32, i32* %aWidth, align 4, !dbg !2507
  %0 = load i32, i32* %a.addr, align 4, !dbg !2508
  %cmp = icmp eq i32 %0, 0, !dbg !2509
  br i1 %cmp, label %if.then, label %if.end, !dbg !2508

if.then:                                          ; preds = %entry
  %call = call float @fromRep.32(i32 0) #4, !dbg !2510
  store float %call, float* %retval, align 4, !dbg !2511
  br label %return, !dbg !2511

if.end:                                           ; preds = %entry
  %1 = load i32, i32* %a.addr, align 4, !dbg !2512
  %2 = call i32 @llvm.ctlz.i32(i32 %1, i1 true), !dbg !2513
  %sub = sub nsw i32 31, %2, !dbg !2514
  store i32 %sub, i32* %exponent, align 4, !dbg !2515
  %3 = load i32, i32* %exponent, align 4, !dbg !2516
  %cmp1 = icmp sle i32 %3, 23, !dbg !2517
  br i1 %cmp1, label %if.then2, label %if.else, !dbg !2516

if.then2:                                         ; preds = %if.end
  %4 = load i32, i32* %exponent, align 4, !dbg !2518
  %sub3 = sub nsw i32 23, %4, !dbg !2519
  store i32 %sub3, i32* %shift, align 4, !dbg !2520
  %5 = load i32, i32* %a.addr, align 4, !dbg !2521
  %6 = load i32, i32* %shift, align 4, !dbg !2522
  %shl = shl i32 %5, %6, !dbg !2523
  %xor = xor i32 %shl, 8388608, !dbg !2524
  store i32 %xor, i32* %result, align 4, !dbg !2525
  br label %if.end15, !dbg !2526

if.else:                                          ; preds = %if.end
  %7 = load i32, i32* %exponent, align 4, !dbg !2527
  %sub5 = sub nsw i32 %7, 23, !dbg !2528
  store i32 %sub5, i32* %shift4, align 4, !dbg !2529
  %8 = load i32, i32* %a.addr, align 4, !dbg !2530
  %9 = load i32, i32* %shift4, align 4, !dbg !2531
  %shr = lshr i32 %8, %9, !dbg !2532
  %xor6 = xor i32 %shr, 8388608, !dbg !2533
  store i32 %xor6, i32* %result, align 4, !dbg !2534
  %10 = load i32, i32* %a.addr, align 4, !dbg !2535
  %11 = load i32, i32* %shift4, align 4, !dbg !2536
  %sub7 = sub i32 32, %11, !dbg !2537
  %shl8 = shl i32 %10, %sub7, !dbg !2538
  store i32 %shl8, i32* %round, align 4, !dbg !2539
  %12 = load i32, i32* %round, align 4, !dbg !2540
  %cmp9 = icmp ugt i32 %12, -2147483648, !dbg !2541
  br i1 %cmp9, label %if.then10, label %if.end11, !dbg !2540

if.then10:                                        ; preds = %if.else
  %13 = load i32, i32* %result, align 4, !dbg !2542
  %inc = add i32 %13, 1, !dbg !2542
  store i32 %inc, i32* %result, align 4, !dbg !2542
  br label %if.end11, !dbg !2543

if.end11:                                         ; preds = %if.then10, %if.else
  %14 = load i32, i32* %round, align 4, !dbg !2544
  %cmp12 = icmp eq i32 %14, -2147483648, !dbg !2545
  br i1 %cmp12, label %if.then13, label %if.end14, !dbg !2544

if.then13:                                        ; preds = %if.end11
  %15 = load i32, i32* %result, align 4, !dbg !2546
  %and = and i32 %15, 1, !dbg !2547
  %16 = load i32, i32* %result, align 4, !dbg !2548
  %add = add i32 %16, %and, !dbg !2548
  store i32 %add, i32* %result, align 4, !dbg !2548
  br label %if.end14, !dbg !2549

if.end14:                                         ; preds = %if.then13, %if.end11
  br label %if.end15

if.end15:                                         ; preds = %if.end14, %if.then2
  %17 = load i32, i32* %exponent, align 4, !dbg !2550
  %add16 = add nsw i32 %17, 127, !dbg !2551
  %shl17 = shl i32 %add16, 23, !dbg !2552
  %18 = load i32, i32* %result, align 4, !dbg !2553
  %add18 = add i32 %18, %shl17, !dbg !2553
  store i32 %add18, i32* %result, align 4, !dbg !2553
  %19 = load i32, i32* %result, align 4, !dbg !2554
  %call19 = call float @fromRep.32(i32 %19) #4, !dbg !2555
  store float %call19, float* %retval, align 4, !dbg !2556
  br label %return, !dbg !2556

return:                                           ; preds = %if.end15, %if.then
  %20 = load float, float* %retval, align 4, !dbg !2557
  ret float %20, !dbg !2557
}

; Function Attrs: noinline nounwind
define internal float @fromRep.32(i32 %x) #0 !dbg !2558 {
entry:
  %x.addr = alloca i32, align 4
  %rep = alloca %union.anon.0.0, align 4
  store i32 %x, i32* %x.addr, align 4
  %i = bitcast %union.anon.0.0* %rep to i32*, !dbg !2559
  %0 = load i32, i32* %x.addr, align 4, !dbg !2560
  store i32 %0, i32* %i, align 4, !dbg !2559
  %f = bitcast %union.anon.0.0* %rep to float*, !dbg !2561
  %1 = load float, float* %f, align 4, !dbg !2561
  ret float %1, !dbg !2562
}

; Function Attrs: noinline noreturn nounwind
define weak hidden void @compilerrt_abort_impl(i8* %file, i32 %line, i8* %function) #3 !dbg !2563 {
entry:
  %file.addr = alloca i8*, align 4
  %line.addr = alloca i32, align 4
  %function.addr = alloca i8*, align 4
  store i8* %file, i8** %file.addr, align 4
  store i32 %line, i32* %line.addr, align 4
  store i8* %function, i8** %function.addr, align 4
  unreachable, !dbg !2564
}

; Function Attrs: noinline nounwind
define dso_local double @__muldf3(double %a, double %b) #0 !dbg !2565 {
entry:
  %a.addr = alloca double, align 8
  %b.addr = alloca double, align 8
  store double %a, double* %a.addr, align 8
  store double %b, double* %b.addr, align 8
  %0 = load double, double* %a.addr, align 8, !dbg !2566
  %1 = load double, double* %b.addr, align 8, !dbg !2567
  %call = call double @__mulXf3__(double %0, double %1) #4, !dbg !2568
  ret double %call, !dbg !2569
}

; Function Attrs: noinline nounwind
define internal double @__mulXf3__(double %a, double %b) #0 !dbg !2570 {
entry:
  %retval = alloca double, align 8
  %a.addr = alloca double, align 8
  %b.addr = alloca double, align 8
  %aExponent = alloca i32, align 4
  %bExponent = alloca i32, align 4
  %productSign = alloca i64, align 8
  %aSignificand = alloca i64, align 8
  %bSignificand = alloca i64, align 8
  %scale = alloca i32, align 4
  %aAbs = alloca i64, align 8
  %bAbs = alloca i64, align 8
  %productHi = alloca i64, align 8
  %productLo = alloca i64, align 8
  %productExponent = alloca i32, align 4
  %shift = alloca i32, align 4
  store double %a, double* %a.addr, align 8
  store double %b, double* %b.addr, align 8
  %0 = load double, double* %a.addr, align 8, !dbg !2572
  %call = call i64 @toRep.33(double %0) #4, !dbg !2573
  %shr = lshr i64 %call, 52, !dbg !2574
  %and = and i64 %shr, 2047, !dbg !2575
  %conv = trunc i64 %and to i32, !dbg !2573
  store i32 %conv, i32* %aExponent, align 4, !dbg !2576
  %1 = load double, double* %b.addr, align 8, !dbg !2577
  %call1 = call i64 @toRep.33(double %1) #4, !dbg !2578
  %shr2 = lshr i64 %call1, 52, !dbg !2579
  %and3 = and i64 %shr2, 2047, !dbg !2580
  %conv4 = trunc i64 %and3 to i32, !dbg !2578
  store i32 %conv4, i32* %bExponent, align 4, !dbg !2581
  %2 = load double, double* %a.addr, align 8, !dbg !2582
  %call5 = call i64 @toRep.33(double %2) #4, !dbg !2583
  %3 = load double, double* %b.addr, align 8, !dbg !2584
  %call6 = call i64 @toRep.33(double %3) #4, !dbg !2585
  %xor = xor i64 %call5, %call6, !dbg !2586
  %and7 = and i64 %xor, -9223372036854775808, !dbg !2587
  store i64 %and7, i64* %productSign, align 8, !dbg !2588
  %4 = load double, double* %a.addr, align 8, !dbg !2589
  %call8 = call i64 @toRep.33(double %4) #4, !dbg !2590
  %and9 = and i64 %call8, 4503599627370495, !dbg !2591
  store i64 %and9, i64* %aSignificand, align 8, !dbg !2592
  %5 = load double, double* %b.addr, align 8, !dbg !2593
  %call10 = call i64 @toRep.33(double %5) #4, !dbg !2594
  %and11 = and i64 %call10, 4503599627370495, !dbg !2595
  store i64 %and11, i64* %bSignificand, align 8, !dbg !2596
  store i32 0, i32* %scale, align 4, !dbg !2597
  %6 = load i32, i32* %aExponent, align 4, !dbg !2598
  %sub = sub i32 %6, 1, !dbg !2599
  %cmp = icmp uge i32 %sub, 2046, !dbg !2600
  br i1 %cmp, label %if.then, label %lor.lhs.false, !dbg !2601

lor.lhs.false:                                    ; preds = %entry
  %7 = load i32, i32* %bExponent, align 4, !dbg !2602
  %sub13 = sub i32 %7, 1, !dbg !2603
  %cmp14 = icmp uge i32 %sub13, 2046, !dbg !2604
  br i1 %cmp14, label %if.then, label %if.end69, !dbg !2598

if.then:                                          ; preds = %lor.lhs.false, %entry
  %8 = load double, double* %a.addr, align 8, !dbg !2605
  %call16 = call i64 @toRep.33(double %8) #4, !dbg !2606
  %and17 = and i64 %call16, 9223372036854775807, !dbg !2607
  store i64 %and17, i64* %aAbs, align 8, !dbg !2608
  %9 = load double, double* %b.addr, align 8, !dbg !2609
  %call18 = call i64 @toRep.33(double %9) #4, !dbg !2610
  %and19 = and i64 %call18, 9223372036854775807, !dbg !2611
  store i64 %and19, i64* %bAbs, align 8, !dbg !2612
  %10 = load i64, i64* %aAbs, align 8, !dbg !2613
  %cmp20 = icmp ugt i64 %10, 9218868437227405312, !dbg !2614
  br i1 %cmp20, label %if.then22, label %if.end, !dbg !2613

if.then22:                                        ; preds = %if.then
  %11 = load double, double* %a.addr, align 8, !dbg !2615
  %call23 = call i64 @toRep.33(double %11) #4, !dbg !2616
  %or = or i64 %call23, 2251799813685248, !dbg !2617
  %call24 = call double @fromRep.34(i64 %or) #4, !dbg !2618
  store double %call24, double* %retval, align 8, !dbg !2619
  br label %return, !dbg !2619

if.end:                                           ; preds = %if.then
  %12 = load i64, i64* %bAbs, align 8, !dbg !2620
  %cmp25 = icmp ugt i64 %12, 9218868437227405312, !dbg !2621
  br i1 %cmp25, label %if.then27, label %if.end31, !dbg !2620

if.then27:                                        ; preds = %if.end
  %13 = load double, double* %b.addr, align 8, !dbg !2622
  %call28 = call i64 @toRep.33(double %13) #4, !dbg !2623
  %or29 = or i64 %call28, 2251799813685248, !dbg !2624
  %call30 = call double @fromRep.34(i64 %or29) #4, !dbg !2625
  store double %call30, double* %retval, align 8, !dbg !2626
  br label %return, !dbg !2626

if.end31:                                         ; preds = %if.end
  %14 = load i64, i64* %aAbs, align 8, !dbg !2627
  %cmp32 = icmp eq i64 %14, 9218868437227405312, !dbg !2628
  br i1 %cmp32, label %if.then34, label %if.end39, !dbg !2627

if.then34:                                        ; preds = %if.end31
  %15 = load i64, i64* %bAbs, align 8, !dbg !2629
  %tobool = icmp ne i64 %15, 0, !dbg !2629
  br i1 %tobool, label %if.then35, label %if.else, !dbg !2629

if.then35:                                        ; preds = %if.then34
  %16 = load i64, i64* %aAbs, align 8, !dbg !2630
  %17 = load i64, i64* %productSign, align 8, !dbg !2631
  %or36 = or i64 %16, %17, !dbg !2632
  %call37 = call double @fromRep.34(i64 %or36) #4, !dbg !2633
  store double %call37, double* %retval, align 8, !dbg !2634
  br label %return, !dbg !2634

if.else:                                          ; preds = %if.then34
  %call38 = call double @fromRep.34(i64 9221120237041090560) #4, !dbg !2635
  store double %call38, double* %retval, align 8, !dbg !2636
  br label %return, !dbg !2636

if.end39:                                         ; preds = %if.end31
  %18 = load i64, i64* %bAbs, align 8, !dbg !2637
  %cmp40 = icmp eq i64 %18, 9218868437227405312, !dbg !2638
  br i1 %cmp40, label %if.then42, label %if.end49, !dbg !2637

if.then42:                                        ; preds = %if.end39
  %19 = load i64, i64* %aAbs, align 8, !dbg !2639
  %tobool43 = icmp ne i64 %19, 0, !dbg !2639
  br i1 %tobool43, label %if.then44, label %if.else47, !dbg !2639

if.then44:                                        ; preds = %if.then42
  %20 = load i64, i64* %bAbs, align 8, !dbg !2640
  %21 = load i64, i64* %productSign, align 8, !dbg !2641
  %or45 = or i64 %20, %21, !dbg !2642
  %call46 = call double @fromRep.34(i64 %or45) #4, !dbg !2643
  store double %call46, double* %retval, align 8, !dbg !2644
  br label %return, !dbg !2644

if.else47:                                        ; preds = %if.then42
  %call48 = call double @fromRep.34(i64 9221120237041090560) #4, !dbg !2645
  store double %call48, double* %retval, align 8, !dbg !2646
  br label %return, !dbg !2646

if.end49:                                         ; preds = %if.end39
  %22 = load i64, i64* %aAbs, align 8, !dbg !2647
  %tobool50 = icmp ne i64 %22, 0, !dbg !2647
  br i1 %tobool50, label %if.end53, label %if.then51, !dbg !2648

if.then51:                                        ; preds = %if.end49
  %23 = load i64, i64* %productSign, align 8, !dbg !2649
  %call52 = call double @fromRep.34(i64 %23) #4, !dbg !2650
  store double %call52, double* %retval, align 8, !dbg !2651
  br label %return, !dbg !2651

if.end53:                                         ; preds = %if.end49
  %24 = load i64, i64* %bAbs, align 8, !dbg !2652
  %tobool54 = icmp ne i64 %24, 0, !dbg !2652
  br i1 %tobool54, label %if.end57, label %if.then55, !dbg !2653

if.then55:                                        ; preds = %if.end53
  %25 = load i64, i64* %productSign, align 8, !dbg !2654
  %call56 = call double @fromRep.34(i64 %25) #4, !dbg !2655
  store double %call56, double* %retval, align 8, !dbg !2656
  br label %return, !dbg !2656

if.end57:                                         ; preds = %if.end53
  %26 = load i64, i64* %aAbs, align 8, !dbg !2657
  %cmp58 = icmp ult i64 %26, 4503599627370496, !dbg !2658
  br i1 %cmp58, label %if.then60, label %if.end62, !dbg !2657

if.then60:                                        ; preds = %if.end57
  %call61 = call i32 @normalize.35(i64* %aSignificand) #4, !dbg !2659
  %27 = load i32, i32* %scale, align 4, !dbg !2660
  %add = add nsw i32 %27, %call61, !dbg !2660
  store i32 %add, i32* %scale, align 4, !dbg !2660
  br label %if.end62, !dbg !2661

if.end62:                                         ; preds = %if.then60, %if.end57
  %28 = load i64, i64* %bAbs, align 8, !dbg !2662
  %cmp63 = icmp ult i64 %28, 4503599627370496, !dbg !2663
  br i1 %cmp63, label %if.then65, label %if.end68, !dbg !2662

if.then65:                                        ; preds = %if.end62
  %call66 = call i32 @normalize.35(i64* %bSignificand) #4, !dbg !2664
  %29 = load i32, i32* %scale, align 4, !dbg !2665
  %add67 = add nsw i32 %29, %call66, !dbg !2665
  store i32 %add67, i32* %scale, align 4, !dbg !2665
  br label %if.end68, !dbg !2666

if.end68:                                         ; preds = %if.then65, %if.end62
  br label %if.end69, !dbg !2667

if.end69:                                         ; preds = %if.end68, %lor.lhs.false
  %30 = load i64, i64* %aSignificand, align 8, !dbg !2668
  %or70 = or i64 %30, 4503599627370496, !dbg !2668
  store i64 %or70, i64* %aSignificand, align 8, !dbg !2668
  %31 = load i64, i64* %bSignificand, align 8, !dbg !2669
  %or71 = or i64 %31, 4503599627370496, !dbg !2669
  store i64 %or71, i64* %bSignificand, align 8, !dbg !2669
  %32 = load i64, i64* %aSignificand, align 8, !dbg !2670
  %33 = load i64, i64* %bSignificand, align 8, !dbg !2671
  %shl = shl i64 %33, 11, !dbg !2672
  call void @wideMultiply.36(i64 %32, i64 %shl, i64* %productHi, i64* %productLo) #4, !dbg !2673
  %34 = load i32, i32* %aExponent, align 4, !dbg !2674
  %35 = load i32, i32* %bExponent, align 4, !dbg !2675
  %add72 = add i32 %34, %35, !dbg !2676
  %sub73 = sub i32 %add72, 1023, !dbg !2677
  %36 = load i32, i32* %scale, align 4, !dbg !2678
  %add74 = add i32 %sub73, %36, !dbg !2679
  store i32 %add74, i32* %productExponent, align 4, !dbg !2680
  %37 = load i64, i64* %productHi, align 8, !dbg !2681
  %and75 = and i64 %37, 4503599627370496, !dbg !2682
  %tobool76 = icmp ne i64 %and75, 0, !dbg !2682
  br i1 %tobool76, label %if.then77, label %if.else78, !dbg !2681

if.then77:                                        ; preds = %if.end69
  %38 = load i32, i32* %productExponent, align 4, !dbg !2683
  %inc = add nsw i32 %38, 1, !dbg !2683
  store i32 %inc, i32* %productExponent, align 4, !dbg !2683
  br label %if.end79, !dbg !2684

if.else78:                                        ; preds = %if.end69
  call void @wideLeftShift(i64* %productHi, i64* %productLo, i32 1) #4, !dbg !2685
  br label %if.end79

if.end79:                                         ; preds = %if.else78, %if.then77
  %39 = load i32, i32* %productExponent, align 4, !dbg !2686
  %cmp80 = icmp sge i32 %39, 2047, !dbg !2687
  br i1 %cmp80, label %if.then82, label %if.end85, !dbg !2686

if.then82:                                        ; preds = %if.end79
  %40 = load i64, i64* %productSign, align 8, !dbg !2688
  %or83 = or i64 9218868437227405312, %40, !dbg !2689
  %call84 = call double @fromRep.34(i64 %or83) #4, !dbg !2690
  store double %call84, double* %retval, align 8, !dbg !2691
  br label %return, !dbg !2691

if.end85:                                         ; preds = %if.end79
  %41 = load i32, i32* %productExponent, align 4, !dbg !2692
  %cmp86 = icmp sle i32 %41, 0, !dbg !2693
  br i1 %cmp86, label %if.then88, label %if.else97, !dbg !2692

if.then88:                                        ; preds = %if.end85
  %42 = load i32, i32* %productExponent, align 4, !dbg !2694
  %conv89 = zext i32 %42 to i64, !dbg !2695
  %sub90 = sub i64 1, %conv89, !dbg !2696
  %conv91 = trunc i64 %sub90 to i32, !dbg !2697
  store i32 %conv91, i32* %shift, align 4, !dbg !2698
  %43 = load i32, i32* %shift, align 4, !dbg !2699
  %cmp92 = icmp uge i32 %43, 64, !dbg !2700
  br i1 %cmp92, label %if.then94, label %if.end96, !dbg !2699

if.then94:                                        ; preds = %if.then88
  %44 = load i64, i64* %productSign, align 8, !dbg !2701
  %call95 = call double @fromRep.34(i64 %44) #4, !dbg !2702
  store double %call95, double* %retval, align 8, !dbg !2703
  br label %return, !dbg !2703

if.end96:                                         ; preds = %if.then88
  %45 = load i32, i32* %shift, align 4, !dbg !2704
  call void @wideRightShiftWithSticky(i64* %productHi, i64* %productLo, i32 %45) #4, !dbg !2705
  br label %if.end102, !dbg !2706

if.else97:                                        ; preds = %if.end85
  %46 = load i64, i64* %productHi, align 8, !dbg !2707
  %and98 = and i64 %46, 4503599627370495, !dbg !2707
  store i64 %and98, i64* %productHi, align 8, !dbg !2707
  %47 = load i32, i32* %productExponent, align 4, !dbg !2708
  %conv99 = sext i32 %47 to i64, !dbg !2709
  %shl100 = shl i64 %conv99, 52, !dbg !2710
  %48 = load i64, i64* %productHi, align 8, !dbg !2711
  %or101 = or i64 %48, %shl100, !dbg !2711
  store i64 %or101, i64* %productHi, align 8, !dbg !2711
  br label %if.end102

if.end102:                                        ; preds = %if.else97, %if.end96
  %49 = load i64, i64* %productSign, align 8, !dbg !2712
  %50 = load i64, i64* %productHi, align 8, !dbg !2713
  %or103 = or i64 %50, %49, !dbg !2713
  store i64 %or103, i64* %productHi, align 8, !dbg !2713
  %51 = load i64, i64* %productLo, align 8, !dbg !2714
  %cmp104 = icmp ugt i64 %51, -9223372036854775808, !dbg !2715
  br i1 %cmp104, label %if.then106, label %if.end108, !dbg !2714

if.then106:                                       ; preds = %if.end102
  %52 = load i64, i64* %productHi, align 8, !dbg !2716
  %inc107 = add i64 %52, 1, !dbg !2716
  store i64 %inc107, i64* %productHi, align 8, !dbg !2716
  br label %if.end108, !dbg !2717

if.end108:                                        ; preds = %if.then106, %if.end102
  %53 = load i64, i64* %productLo, align 8, !dbg !2718
  %cmp109 = icmp eq i64 %53, -9223372036854775808, !dbg !2719
  br i1 %cmp109, label %if.then111, label %if.end114, !dbg !2718

if.then111:                                       ; preds = %if.end108
  %54 = load i64, i64* %productHi, align 8, !dbg !2720
  %and112 = and i64 %54, 1, !dbg !2721
  %55 = load i64, i64* %productHi, align 8, !dbg !2722
  %add113 = add i64 %55, %and112, !dbg !2722
  store i64 %add113, i64* %productHi, align 8, !dbg !2722
  br label %if.end114, !dbg !2723

if.end114:                                        ; preds = %if.then111, %if.end108
  %56 = load i64, i64* %productHi, align 8, !dbg !2724
  %call115 = call double @fromRep.34(i64 %56) #4, !dbg !2725
  store double %call115, double* %retval, align 8, !dbg !2726
  br label %return, !dbg !2726

return:                                           ; preds = %if.end114, %if.then94, %if.then82, %if.then55, %if.then51, %if.else47, %if.then44, %if.else, %if.then35, %if.then27, %if.then22
  %57 = load double, double* %retval, align 8, !dbg !2727
  ret double %57, !dbg !2727
}

; Function Attrs: noinline nounwind
define internal i64 @toRep.33(double %x) #0 !dbg !2728 {
entry:
  %x.addr = alloca double, align 8
  %rep = alloca %union.anon.0, align 8
  store double %x, double* %x.addr, align 8
  %f = bitcast %union.anon.0* %rep to double*, !dbg !2729
  %0 = load double, double* %x.addr, align 8, !dbg !2730
  store double %0, double* %f, align 8, !dbg !2729
  %i = bitcast %union.anon.0* %rep to i64*, !dbg !2731
  %1 = load i64, i64* %i, align 8, !dbg !2731
  ret i64 %1, !dbg !2732
}

; Function Attrs: noinline nounwind
define internal double @fromRep.34(i64 %x) #0 !dbg !2733 {
entry:
  %x.addr = alloca i64, align 8
  %rep = alloca %union.anon.0, align 8
  store i64 %x, i64* %x.addr, align 8
  %i = bitcast %union.anon.0* %rep to i64*, !dbg !2734
  %0 = load i64, i64* %x.addr, align 8, !dbg !2735
  store i64 %0, i64* %i, align 8, !dbg !2734
  %f = bitcast %union.anon.0* %rep to double*, !dbg !2736
  %1 = load double, double* %f, align 8, !dbg !2736
  ret double %1, !dbg !2737
}

; Function Attrs: noinline nounwind
define internal i32 @normalize.35(i64* %significand) #0 !dbg !2738 {
entry:
  %significand.addr = alloca i64*, align 4
  %shift = alloca i32, align 4
  store i64* %significand, i64** %significand.addr, align 4
  %0 = load i64*, i64** %significand.addr, align 4, !dbg !2739
  %1 = load i64, i64* %0, align 8, !dbg !2740
  %call = call i32 @rep_clz.37(i64 %1) #4, !dbg !2741
  %call1 = call i32 @rep_clz.37(i64 4503599627370496) #4, !dbg !2742
  %sub = sub nsw i32 %call, %call1, !dbg !2743
  store i32 %sub, i32* %shift, align 4, !dbg !2744
  %2 = load i32, i32* %shift, align 4, !dbg !2745
  %3 = load i64*, i64** %significand.addr, align 4, !dbg !2746
  %4 = load i64, i64* %3, align 8, !dbg !2747
  %sh_prom = zext i32 %2 to i64, !dbg !2747
  %shl = shl i64 %4, %sh_prom, !dbg !2747
  store i64 %shl, i64* %3, align 8, !dbg !2747
  %5 = load i32, i32* %shift, align 4, !dbg !2748
  %sub2 = sub nsw i32 1, %5, !dbg !2749
  ret i32 %sub2, !dbg !2750
}

; Function Attrs: noinline nounwind
define internal void @wideMultiply.36(i64 %a, i64 %b, i64* %hi, i64* %lo) #0 !dbg !2751 {
entry:
  %a.addr = alloca i64, align 8
  %b.addr = alloca i64, align 8
  %hi.addr = alloca i64*, align 4
  %lo.addr = alloca i64*, align 4
  %plolo = alloca i64, align 8
  %plohi = alloca i64, align 8
  %philo = alloca i64, align 8
  %phihi = alloca i64, align 8
  %r0 = alloca i64, align 8
  %r1 = alloca i64, align 8
  store i64 %a, i64* %a.addr, align 8
  store i64 %b, i64* %b.addr, align 8
  store i64* %hi, i64** %hi.addr, align 4
  store i64* %lo, i64** %lo.addr, align 4
  %0 = load i64, i64* %a.addr, align 8, !dbg !2752
  %and = and i64 %0, 4294967295, !dbg !2752
  %1 = load i64, i64* %b.addr, align 8, !dbg !2753
  %and1 = and i64 %1, 4294967295, !dbg !2753
  %mul = mul i64 %and, %and1, !dbg !2754
  store i64 %mul, i64* %plolo, align 8, !dbg !2755
  %2 = load i64, i64* %a.addr, align 8, !dbg !2756
  %and2 = and i64 %2, 4294967295, !dbg !2756
  %3 = load i64, i64* %b.addr, align 8, !dbg !2757
  %shr = lshr i64 %3, 32, !dbg !2757
  %mul3 = mul i64 %and2, %shr, !dbg !2758
  store i64 %mul3, i64* %plohi, align 8, !dbg !2759
  %4 = load i64, i64* %a.addr, align 8, !dbg !2760
  %shr4 = lshr i64 %4, 32, !dbg !2760
  %5 = load i64, i64* %b.addr, align 8, !dbg !2761
  %and5 = and i64 %5, 4294967295, !dbg !2761
  %mul6 = mul i64 %shr4, %and5, !dbg !2762
  store i64 %mul6, i64* %philo, align 8, !dbg !2763
  %6 = load i64, i64* %a.addr, align 8, !dbg !2764
  %shr7 = lshr i64 %6, 32, !dbg !2764
  %7 = load i64, i64* %b.addr, align 8, !dbg !2765
  %shr8 = lshr i64 %7, 32, !dbg !2765
  %mul9 = mul i64 %shr7, %shr8, !dbg !2766
  store i64 %mul9, i64* %phihi, align 8, !dbg !2767
  %8 = load i64, i64* %plolo, align 8, !dbg !2768
  %and10 = and i64 %8, 4294967295, !dbg !2768
  store i64 %and10, i64* %r0, align 8, !dbg !2769
  %9 = load i64, i64* %plolo, align 8, !dbg !2770
  %shr11 = lshr i64 %9, 32, !dbg !2770
  %10 = load i64, i64* %plohi, align 8, !dbg !2771
  %and12 = and i64 %10, 4294967295, !dbg !2771
  %add = add i64 %shr11, %and12, !dbg !2772
  %11 = load i64, i64* %philo, align 8, !dbg !2773
  %and13 = and i64 %11, 4294967295, !dbg !2773
  %add14 = add i64 %add, %and13, !dbg !2774
  store i64 %add14, i64* %r1, align 8, !dbg !2775
  %12 = load i64, i64* %r0, align 8, !dbg !2776
  %13 = load i64, i64* %r1, align 8, !dbg !2777
  %shl = shl i64 %13, 32, !dbg !2778
  %add15 = add i64 %12, %shl, !dbg !2779
  %14 = load i64*, i64** %lo.addr, align 4, !dbg !2780
  store i64 %add15, i64* %14, align 8, !dbg !2781
  %15 = load i64, i64* %plohi, align 8, !dbg !2782
  %shr16 = lshr i64 %15, 32, !dbg !2782
  %16 = load i64, i64* %philo, align 8, !dbg !2783
  %shr17 = lshr i64 %16, 32, !dbg !2783
  %add18 = add i64 %shr16, %shr17, !dbg !2784
  %17 = load i64, i64* %r1, align 8, !dbg !2785
  %shr19 = lshr i64 %17, 32, !dbg !2785
  %add20 = add i64 %add18, %shr19, !dbg !2786
  %18 = load i64, i64* %phihi, align 8, !dbg !2787
  %add21 = add i64 %add20, %18, !dbg !2788
  %19 = load i64*, i64** %hi.addr, align 4, !dbg !2789
  store i64 %add21, i64* %19, align 8, !dbg !2790
  ret void, !dbg !2791
}

; Function Attrs: noinline nounwind
define internal void @wideLeftShift(i64* %hi, i64* %lo, i32 %count) #0 !dbg !2792 {
entry:
  %hi.addr = alloca i64*, align 4
  %lo.addr = alloca i64*, align 4
  %count.addr = alloca i32, align 4
  store i64* %hi, i64** %hi.addr, align 4
  store i64* %lo, i64** %lo.addr, align 4
  store i32 %count, i32* %count.addr, align 4
  %0 = load i64*, i64** %hi.addr, align 4, !dbg !2793
  %1 = load i64, i64* %0, align 8, !dbg !2794
  %2 = load i32, i32* %count.addr, align 4, !dbg !2795
  %sh_prom = zext i32 %2 to i64, !dbg !2796
  %shl = shl i64 %1, %sh_prom, !dbg !2796
  %3 = load i64*, i64** %lo.addr, align 4, !dbg !2797
  %4 = load i64, i64* %3, align 8, !dbg !2798
  %5 = load i32, i32* %count.addr, align 4, !dbg !2799
  %sub = sub i32 64, %5, !dbg !2800
  %sh_prom1 = zext i32 %sub to i64, !dbg !2801
  %shr = lshr i64 %4, %sh_prom1, !dbg !2801
  %or = or i64 %shl, %shr, !dbg !2802
  %6 = load i64*, i64** %hi.addr, align 4, !dbg !2803
  store i64 %or, i64* %6, align 8, !dbg !2804
  %7 = load i64*, i64** %lo.addr, align 4, !dbg !2805
  %8 = load i64, i64* %7, align 8, !dbg !2806
  %9 = load i32, i32* %count.addr, align 4, !dbg !2807
  %sh_prom2 = zext i32 %9 to i64, !dbg !2808
  %shl3 = shl i64 %8, %sh_prom2, !dbg !2808
  %10 = load i64*, i64** %lo.addr, align 4, !dbg !2809
  store i64 %shl3, i64* %10, align 8, !dbg !2810
  ret void, !dbg !2811
}

; Function Attrs: noinline nounwind
define internal void @wideRightShiftWithSticky(i64* %hi, i64* %lo, i32 %count) #0 !dbg !2812 {
entry:
  %hi.addr = alloca i64*, align 4
  %lo.addr = alloca i64*, align 4
  %count.addr = alloca i32, align 4
  %sticky = alloca i8, align 1
  %sticky12 = alloca i8, align 1
  %sticky26 = alloca i8, align 1
  store i64* %hi, i64** %hi.addr, align 4
  store i64* %lo, i64** %lo.addr, align 4
  store i32 %count, i32* %count.addr, align 4
  %0 = load i32, i32* %count.addr, align 4, !dbg !2813
  %cmp = icmp ult i32 %0, 64, !dbg !2814
  br i1 %cmp, label %if.then, label %if.else, !dbg !2813

if.then:                                          ; preds = %entry
  %1 = load i64*, i64** %lo.addr, align 4, !dbg !2815
  %2 = load i64, i64* %1, align 8, !dbg !2816
  %3 = load i32, i32* %count.addr, align 4, !dbg !2817
  %sub = sub i32 64, %3, !dbg !2818
  %sh_prom = zext i32 %sub to i64, !dbg !2819
  %shl = shl i64 %2, %sh_prom, !dbg !2819
  %tobool = icmp ne i64 %shl, 0, !dbg !2816
  %frombool = zext i1 %tobool to i8, !dbg !2820
  store i8 %frombool, i8* %sticky, align 1, !dbg !2820
  %4 = load i64*, i64** %hi.addr, align 4, !dbg !2821
  %5 = load i64, i64* %4, align 8, !dbg !2822
  %6 = load i32, i32* %count.addr, align 4, !dbg !2823
  %sub1 = sub i32 64, %6, !dbg !2824
  %sh_prom2 = zext i32 %sub1 to i64, !dbg !2825
  %shl3 = shl i64 %5, %sh_prom2, !dbg !2825
  %7 = load i64*, i64** %lo.addr, align 4, !dbg !2826
  %8 = load i64, i64* %7, align 8, !dbg !2827
  %9 = load i32, i32* %count.addr, align 4, !dbg !2828
  %sh_prom4 = zext i32 %9 to i64, !dbg !2829
  %shr = lshr i64 %8, %sh_prom4, !dbg !2829
  %or = or i64 %shl3, %shr, !dbg !2830
  %10 = load i8, i8* %sticky, align 1, !dbg !2831
  %tobool5 = trunc i8 %10 to i1, !dbg !2831
  %conv = zext i1 %tobool5 to i64, !dbg !2831
  %or6 = or i64 %or, %conv, !dbg !2832
  %11 = load i64*, i64** %lo.addr, align 4, !dbg !2833
  store i64 %or6, i64* %11, align 8, !dbg !2834
  %12 = load i64*, i64** %hi.addr, align 4, !dbg !2835
  %13 = load i64, i64* %12, align 8, !dbg !2836
  %14 = load i32, i32* %count.addr, align 4, !dbg !2837
  %sh_prom7 = zext i32 %14 to i64, !dbg !2838
  %shr8 = lshr i64 %13, %sh_prom7, !dbg !2838
  %15 = load i64*, i64** %hi.addr, align 4, !dbg !2839
  store i64 %shr8, i64* %15, align 8, !dbg !2840
  br label %if.end32, !dbg !2841

if.else:                                          ; preds = %entry
  %16 = load i32, i32* %count.addr, align 4, !dbg !2842
  %cmp9 = icmp ult i32 %16, 128, !dbg !2843
  br i1 %cmp9, label %if.then11, label %if.else25, !dbg !2842

if.then11:                                        ; preds = %if.else
  %17 = load i64*, i64** %hi.addr, align 4, !dbg !2844
  %18 = load i64, i64* %17, align 8, !dbg !2845
  %19 = load i32, i32* %count.addr, align 4, !dbg !2846
  %sub13 = sub i32 128, %19, !dbg !2847
  %sh_prom14 = zext i32 %sub13 to i64, !dbg !2848
  %shl15 = shl i64 %18, %sh_prom14, !dbg !2848
  %20 = load i64*, i64** %lo.addr, align 4, !dbg !2849
  %21 = load i64, i64* %20, align 8, !dbg !2850
  %or16 = or i64 %shl15, %21, !dbg !2851
  %tobool17 = icmp ne i64 %or16, 0, !dbg !2845
  %frombool18 = zext i1 %tobool17 to i8, !dbg !2852
  store i8 %frombool18, i8* %sticky12, align 1, !dbg !2852
  %22 = load i64*, i64** %hi.addr, align 4, !dbg !2853
  %23 = load i64, i64* %22, align 8, !dbg !2854
  %24 = load i32, i32* %count.addr, align 4, !dbg !2855
  %sub19 = sub i32 %24, 64, !dbg !2856
  %sh_prom20 = zext i32 %sub19 to i64, !dbg !2857
  %shr21 = lshr i64 %23, %sh_prom20, !dbg !2857
  %25 = load i8, i8* %sticky12, align 1, !dbg !2858
  %tobool22 = trunc i8 %25 to i1, !dbg !2858
  %conv23 = zext i1 %tobool22 to i64, !dbg !2858
  %or24 = or i64 %shr21, %conv23, !dbg !2859
  %26 = load i64*, i64** %lo.addr, align 4, !dbg !2860
  store i64 %or24, i64* %26, align 8, !dbg !2861
  %27 = load i64*, i64** %hi.addr, align 4, !dbg !2862
  store i64 0, i64* %27, align 8, !dbg !2863
  br label %if.end, !dbg !2864

if.else25:                                        ; preds = %if.else
  %28 = load i64*, i64** %hi.addr, align 4, !dbg !2865
  %29 = load i64, i64* %28, align 8, !dbg !2866
  %30 = load i64*, i64** %lo.addr, align 4, !dbg !2867
  %31 = load i64, i64* %30, align 8, !dbg !2868
  %or27 = or i64 %29, %31, !dbg !2869
  %tobool28 = icmp ne i64 %or27, 0, !dbg !2866
  %frombool29 = zext i1 %tobool28 to i8, !dbg !2870
  store i8 %frombool29, i8* %sticky26, align 1, !dbg !2870
  %32 = load i8, i8* %sticky26, align 1, !dbg !2871
  %tobool30 = trunc i8 %32 to i1, !dbg !2871
  %conv31 = zext i1 %tobool30 to i64, !dbg !2871
  %33 = load i64*, i64** %lo.addr, align 4, !dbg !2872
  store i64 %conv31, i64* %33, align 8, !dbg !2873
  %34 = load i64*, i64** %hi.addr, align 4, !dbg !2874
  store i64 0, i64* %34, align 8, !dbg !2875
  br label %if.end

if.end:                                           ; preds = %if.else25, %if.then11
  br label %if.end32

if.end32:                                         ; preds = %if.end, %if.then
  ret void, !dbg !2876
}

; Function Attrs: noinline nounwind
define internal i32 @rep_clz.37(i64 %a) #0 !dbg !2877 {
entry:
  %retval = alloca i32, align 4
  %a.addr = alloca i64, align 8
  store i64 %a, i64* %a.addr, align 8
  %0 = load i64, i64* %a.addr, align 8, !dbg !2878
  %and = and i64 %0, -4294967296, !dbg !2879
  %tobool = icmp ne i64 %and, 0, !dbg !2879
  br i1 %tobool, label %if.then, label %if.else, !dbg !2878

if.then:                                          ; preds = %entry
  %1 = load i64, i64* %a.addr, align 8, !dbg !2880
  %shr = lshr i64 %1, 32, !dbg !2881
  %conv = trunc i64 %shr to i32, !dbg !2880
  %2 = call i32 @llvm.ctlz.i32(i32 %conv, i1 true), !dbg !2882
  store i32 %2, i32* %retval, align 4, !dbg !2883
  br label %return, !dbg !2883

if.else:                                          ; preds = %entry
  %3 = load i64, i64* %a.addr, align 8, !dbg !2884
  %and1 = and i64 %3, 4294967295, !dbg !2885
  %conv2 = trunc i64 %and1 to i32, !dbg !2884
  %4 = call i32 @llvm.ctlz.i32(i32 %conv2, i1 true), !dbg !2886
  %add = add nsw i32 32, %4, !dbg !2887
  store i32 %add, i32* %retval, align 4, !dbg !2888
  br label %return, !dbg !2888

return:                                           ; preds = %if.else, %if.then
  %5 = load i32, i32* %retval, align 4, !dbg !2889
  ret i32 %5, !dbg !2889
}

; Function Attrs: noinline nounwind
define dso_local i64 @__muldi3(i64 %a, i64 %b) #0 !dbg !2890 {
entry:
  %a.addr = alloca i64, align 8
  %b.addr = alloca i64, align 8
  %x = alloca %union.udwords, align 8
  %y = alloca %union.udwords, align 8
  %r = alloca %union.udwords, align 8
  store i64 %a, i64* %a.addr, align 8
  store i64 %b, i64* %b.addr, align 8
  %0 = load i64, i64* %a.addr, align 8, !dbg !2891
  %all = bitcast %union.udwords* %x to i64*, !dbg !2892
  store i64 %0, i64* %all, align 8, !dbg !2893
  %1 = load i64, i64* %b.addr, align 8, !dbg !2894
  %all1 = bitcast %union.udwords* %y to i64*, !dbg !2895
  store i64 %1, i64* %all1, align 8, !dbg !2896
  %s = bitcast %union.udwords* %x to %struct.anon*, !dbg !2897
  %low = getelementptr inbounds %struct.anon, %struct.anon* %s, i32 0, i32 0, !dbg !2898
  %2 = load i32, i32* %low, align 8, !dbg !2898
  %s2 = bitcast %union.udwords* %y to %struct.anon*, !dbg !2899
  %low3 = getelementptr inbounds %struct.anon, %struct.anon* %s2, i32 0, i32 0, !dbg !2900
  %3 = load i32, i32* %low3, align 8, !dbg !2900
  %call = call i64 @__muldsi3(i32 %2, i32 %3) #4, !dbg !2901
  %all4 = bitcast %union.udwords* %r to i64*, !dbg !2902
  store i64 %call, i64* %all4, align 8, !dbg !2903
  %s5 = bitcast %union.udwords* %x to %struct.anon*, !dbg !2904
  %high = getelementptr inbounds %struct.anon, %struct.anon* %s5, i32 0, i32 1, !dbg !2905
  %4 = load i32, i32* %high, align 4, !dbg !2905
  %s6 = bitcast %union.udwords* %y to %struct.anon*, !dbg !2906
  %low7 = getelementptr inbounds %struct.anon, %struct.anon* %s6, i32 0, i32 0, !dbg !2907
  %5 = load i32, i32* %low7, align 8, !dbg !2907
  %mul = mul i32 %4, %5, !dbg !2908
  %s8 = bitcast %union.udwords* %x to %struct.anon*, !dbg !2909
  %low9 = getelementptr inbounds %struct.anon, %struct.anon* %s8, i32 0, i32 0, !dbg !2910
  %6 = load i32, i32* %low9, align 8, !dbg !2910
  %s10 = bitcast %union.udwords* %y to %struct.anon*, !dbg !2911
  %high11 = getelementptr inbounds %struct.anon, %struct.anon* %s10, i32 0, i32 1, !dbg !2912
  %7 = load i32, i32* %high11, align 4, !dbg !2912
  %mul12 = mul i32 %6, %7, !dbg !2913
  %add = add i32 %mul, %mul12, !dbg !2914
  %s13 = bitcast %union.udwords* %r to %struct.anon*, !dbg !2915
  %high14 = getelementptr inbounds %struct.anon, %struct.anon* %s13, i32 0, i32 1, !dbg !2916
  %8 = load i32, i32* %high14, align 4, !dbg !2917
  %add15 = add i32 %8, %add, !dbg !2917
  store i32 %add15, i32* %high14, align 4, !dbg !2917
  %all16 = bitcast %union.udwords* %r to i64*, !dbg !2918
  %9 = load i64, i64* %all16, align 8, !dbg !2918
  ret i64 %9, !dbg !2919
}

; Function Attrs: noinline nounwind
define internal i64 @__muldsi3(i32 %a, i32 %b) #0 !dbg !2920 {
entry:
  %a.addr = alloca i32, align 4
  %b.addr = alloca i32, align 4
  %r = alloca %union.udwords, align 8
  %bits_in_word_2 = alloca i32, align 4
  %lower_mask = alloca i32, align 4
  %t = alloca i32, align 4
  store i32 %a, i32* %a.addr, align 4
  store i32 %b, i32* %b.addr, align 4
  store i32 16, i32* %bits_in_word_2, align 4, !dbg !2921
  store i32 65535, i32* %lower_mask, align 4, !dbg !2922
  %0 = load i32, i32* %a.addr, align 4, !dbg !2923
  %and = and i32 %0, 65535, !dbg !2924
  %1 = load i32, i32* %b.addr, align 4, !dbg !2925
  %and1 = and i32 %1, 65535, !dbg !2926
  %mul = mul i32 %and, %and1, !dbg !2927
  %s = bitcast %union.udwords* %r to %struct.anon*, !dbg !2928
  %low = getelementptr inbounds %struct.anon, %struct.anon* %s, i32 0, i32 0, !dbg !2929
  store i32 %mul, i32* %low, align 8, !dbg !2930
  %s2 = bitcast %union.udwords* %r to %struct.anon*, !dbg !2931
  %low3 = getelementptr inbounds %struct.anon, %struct.anon* %s2, i32 0, i32 0, !dbg !2932
  %2 = load i32, i32* %low3, align 8, !dbg !2932
  %shr = lshr i32 %2, 16, !dbg !2933
  store i32 %shr, i32* %t, align 4, !dbg !2934
  %s4 = bitcast %union.udwords* %r to %struct.anon*, !dbg !2935
  %low5 = getelementptr inbounds %struct.anon, %struct.anon* %s4, i32 0, i32 0, !dbg !2936
  %3 = load i32, i32* %low5, align 8, !dbg !2937
  %and6 = and i32 %3, 65535, !dbg !2937
  store i32 %and6, i32* %low5, align 8, !dbg !2937
  %4 = load i32, i32* %a.addr, align 4, !dbg !2938
  %shr7 = lshr i32 %4, 16, !dbg !2939
  %5 = load i32, i32* %b.addr, align 4, !dbg !2940
  %and8 = and i32 %5, 65535, !dbg !2941
  %mul9 = mul i32 %shr7, %and8, !dbg !2942
  %6 = load i32, i32* %t, align 4, !dbg !2943
  %add = add i32 %6, %mul9, !dbg !2943
  store i32 %add, i32* %t, align 4, !dbg !2943
  %7 = load i32, i32* %t, align 4, !dbg !2944
  %and10 = and i32 %7, 65535, !dbg !2945
  %shl = shl i32 %and10, 16, !dbg !2946
  %s11 = bitcast %union.udwords* %r to %struct.anon*, !dbg !2947
  %low12 = getelementptr inbounds %struct.anon, %struct.anon* %s11, i32 0, i32 0, !dbg !2948
  %8 = load i32, i32* %low12, align 8, !dbg !2949
  %add13 = add i32 %8, %shl, !dbg !2949
  store i32 %add13, i32* %low12, align 8, !dbg !2949
  %9 = load i32, i32* %t, align 4, !dbg !2950
  %shr14 = lshr i32 %9, 16, !dbg !2951
  %s15 = bitcast %union.udwords* %r to %struct.anon*, !dbg !2952
  %high = getelementptr inbounds %struct.anon, %struct.anon* %s15, i32 0, i32 1, !dbg !2953
  store i32 %shr14, i32* %high, align 4, !dbg !2954
  %s16 = bitcast %union.udwords* %r to %struct.anon*, !dbg !2955
  %low17 = getelementptr inbounds %struct.anon, %struct.anon* %s16, i32 0, i32 0, !dbg !2956
  %10 = load i32, i32* %low17, align 8, !dbg !2956
  %shr18 = lshr i32 %10, 16, !dbg !2957
  store i32 %shr18, i32* %t, align 4, !dbg !2958
  %s19 = bitcast %union.udwords* %r to %struct.anon*, !dbg !2959
  %low20 = getelementptr inbounds %struct.anon, %struct.anon* %s19, i32 0, i32 0, !dbg !2960
  %11 = load i32, i32* %low20, align 8, !dbg !2961
  %and21 = and i32 %11, 65535, !dbg !2961
  store i32 %and21, i32* %low20, align 8, !dbg !2961
  %12 = load i32, i32* %b.addr, align 4, !dbg !2962
  %shr22 = lshr i32 %12, 16, !dbg !2963
  %13 = load i32, i32* %a.addr, align 4, !dbg !2964
  %and23 = and i32 %13, 65535, !dbg !2965
  %mul24 = mul i32 %shr22, %and23, !dbg !2966
  %14 = load i32, i32* %t, align 4, !dbg !2967
  %add25 = add i32 %14, %mul24, !dbg !2967
  store i32 %add25, i32* %t, align 4, !dbg !2967
  %15 = load i32, i32* %t, align 4, !dbg !2968
  %and26 = and i32 %15, 65535, !dbg !2969
  %shl27 = shl i32 %and26, 16, !dbg !2970
  %s28 = bitcast %union.udwords* %r to %struct.anon*, !dbg !2971
  %low29 = getelementptr inbounds %struct.anon, %struct.anon* %s28, i32 0, i32 0, !dbg !2972
  %16 = load i32, i32* %low29, align 8, !dbg !2973
  %add30 = add i32 %16, %shl27, !dbg !2973
  store i32 %add30, i32* %low29, align 8, !dbg !2973
  %17 = load i32, i32* %t, align 4, !dbg !2974
  %shr31 = lshr i32 %17, 16, !dbg !2975
  %s32 = bitcast %union.udwords* %r to %struct.anon*, !dbg !2976
  %high33 = getelementptr inbounds %struct.anon, %struct.anon* %s32, i32 0, i32 1, !dbg !2977
  %18 = load i32, i32* %high33, align 4, !dbg !2978
  %add34 = add i32 %18, %shr31, !dbg !2978
  store i32 %add34, i32* %high33, align 4, !dbg !2978
  %19 = load i32, i32* %a.addr, align 4, !dbg !2979
  %shr35 = lshr i32 %19, 16, !dbg !2980
  %20 = load i32, i32* %b.addr, align 4, !dbg !2981
  %shr36 = lshr i32 %20, 16, !dbg !2982
  %mul37 = mul i32 %shr35, %shr36, !dbg !2983
  %s38 = bitcast %union.udwords* %r to %struct.anon*, !dbg !2984
  %high39 = getelementptr inbounds %struct.anon, %struct.anon* %s38, i32 0, i32 1, !dbg !2985
  %21 = load i32, i32* %high39, align 4, !dbg !2986
  %add40 = add i32 %21, %mul37, !dbg !2986
  store i32 %add40, i32* %high39, align 4, !dbg !2986
  %all = bitcast %union.udwords* %r to i64*, !dbg !2987
  %22 = load i64, i64* %all, align 8, !dbg !2987
  ret i64 %22, !dbg !2988
}

; Function Attrs: noinline nounwind
define dso_local i64 @__mulodi4(i64 %a, i64 %b, i32* %overflow) #0 !dbg !2989 {
entry:
  %retval = alloca i64, align 8
  %a.addr = alloca i64, align 8
  %b.addr = alloca i64, align 8
  %overflow.addr = alloca i32*, align 4
  %N = alloca i32, align 4
  %MIN = alloca i64, align 8
  %MAX = alloca i64, align 8
  %result = alloca i64, align 8
  %sa = alloca i64, align 8
  %abs_a = alloca i64, align 8
  %sb = alloca i64, align 8
  %abs_b = alloca i64, align 8
  store i64 %a, i64* %a.addr, align 8
  store i64 %b, i64* %b.addr, align 8
  store i32* %overflow, i32** %overflow.addr, align 4
  store i32 64, i32* %N, align 4, !dbg !2990
  store i64 -9223372036854775808, i64* %MIN, align 8, !dbg !2991
  store i64 9223372036854775807, i64* %MAX, align 8, !dbg !2992
  %0 = load i32*, i32** %overflow.addr, align 4, !dbg !2993
  store i32 0, i32* %0, align 4, !dbg !2994
  %1 = load i64, i64* %a.addr, align 8, !dbg !2995
  %2 = load i64, i64* %b.addr, align 8, !dbg !2996
  %mul = mul nsw i64 %1, %2, !dbg !2997
  store i64 %mul, i64* %result, align 8, !dbg !2998
  %3 = load i64, i64* %a.addr, align 8, !dbg !2999
  %cmp = icmp eq i64 %3, -9223372036854775808, !dbg !3000
  br i1 %cmp, label %if.then, label %if.end4, !dbg !2999

if.then:                                          ; preds = %entry
  %4 = load i64, i64* %b.addr, align 8, !dbg !3001
  %cmp1 = icmp ne i64 %4, 0, !dbg !3002
  br i1 %cmp1, label %land.lhs.true, label %if.end, !dbg !3003

land.lhs.true:                                    ; preds = %if.then
  %5 = load i64, i64* %b.addr, align 8, !dbg !3004
  %cmp2 = icmp ne i64 %5, 1, !dbg !3005
  br i1 %cmp2, label %if.then3, label %if.end, !dbg !3001

if.then3:                                         ; preds = %land.lhs.true
  %6 = load i32*, i32** %overflow.addr, align 4, !dbg !3006
  store i32 1, i32* %6, align 4, !dbg !3007
  br label %if.end, !dbg !3008

if.end:                                           ; preds = %if.then3, %land.lhs.true, %if.then
  %7 = load i64, i64* %result, align 8, !dbg !3009
  store i64 %7, i64* %retval, align 8, !dbg !3010
  br label %return, !dbg !3010

if.end4:                                          ; preds = %entry
  %8 = load i64, i64* %b.addr, align 8, !dbg !3011
  %cmp5 = icmp eq i64 %8, -9223372036854775808, !dbg !3012
  br i1 %cmp5, label %if.then6, label %if.end12, !dbg !3011

if.then6:                                         ; preds = %if.end4
  %9 = load i64, i64* %a.addr, align 8, !dbg !3013
  %cmp7 = icmp ne i64 %9, 0, !dbg !3014
  br i1 %cmp7, label %land.lhs.true8, label %if.end11, !dbg !3015

land.lhs.true8:                                   ; preds = %if.then6
  %10 = load i64, i64* %a.addr, align 8, !dbg !3016
  %cmp9 = icmp ne i64 %10, 1, !dbg !3017
  br i1 %cmp9, label %if.then10, label %if.end11, !dbg !3013

if.then10:                                        ; preds = %land.lhs.true8
  %11 = load i32*, i32** %overflow.addr, align 4, !dbg !3018
  store i32 1, i32* %11, align 4, !dbg !3019
  br label %if.end11, !dbg !3020

if.end11:                                         ; preds = %if.then10, %land.lhs.true8, %if.then6
  %12 = load i64, i64* %result, align 8, !dbg !3021
  store i64 %12, i64* %retval, align 8, !dbg !3022
  br label %return, !dbg !3022

if.end12:                                         ; preds = %if.end4
  %13 = load i64, i64* %a.addr, align 8, !dbg !3023
  %shr = ashr i64 %13, 63, !dbg !3024
  store i64 %shr, i64* %sa, align 8, !dbg !3025
  %14 = load i64, i64* %a.addr, align 8, !dbg !3026
  %15 = load i64, i64* %sa, align 8, !dbg !3027
  %xor = xor i64 %14, %15, !dbg !3028
  %16 = load i64, i64* %sa, align 8, !dbg !3029
  %sub = sub nsw i64 %xor, %16, !dbg !3030
  store i64 %sub, i64* %abs_a, align 8, !dbg !3031
  %17 = load i64, i64* %b.addr, align 8, !dbg !3032
  %shr13 = ashr i64 %17, 63, !dbg !3033
  store i64 %shr13, i64* %sb, align 8, !dbg !3034
  %18 = load i64, i64* %b.addr, align 8, !dbg !3035
  %19 = load i64, i64* %sb, align 8, !dbg !3036
  %xor14 = xor i64 %18, %19, !dbg !3037
  %20 = load i64, i64* %sb, align 8, !dbg !3038
  %sub15 = sub nsw i64 %xor14, %20, !dbg !3039
  store i64 %sub15, i64* %abs_b, align 8, !dbg !3040
  %21 = load i64, i64* %abs_a, align 8, !dbg !3041
  %cmp16 = icmp slt i64 %21, 2, !dbg !3042
  br i1 %cmp16, label %if.then18, label %lor.lhs.false, !dbg !3043

lor.lhs.false:                                    ; preds = %if.end12
  %22 = load i64, i64* %abs_b, align 8, !dbg !3044
  %cmp17 = icmp slt i64 %22, 2, !dbg !3045
  br i1 %cmp17, label %if.then18, label %if.end19, !dbg !3041

if.then18:                                        ; preds = %lor.lhs.false, %if.end12
  %23 = load i64, i64* %result, align 8, !dbg !3046
  store i64 %23, i64* %retval, align 8, !dbg !3047
  br label %return, !dbg !3047

if.end19:                                         ; preds = %lor.lhs.false
  %24 = load i64, i64* %sa, align 8, !dbg !3048
  %25 = load i64, i64* %sb, align 8, !dbg !3049
  %cmp20 = icmp eq i64 %24, %25, !dbg !3050
  br i1 %cmp20, label %if.then21, label %if.else, !dbg !3048

if.then21:                                        ; preds = %if.end19
  %26 = load i64, i64* %abs_a, align 8, !dbg !3051
  %27 = load i64, i64* %abs_b, align 8, !dbg !3052
  %div = sdiv i64 9223372036854775807, %27, !dbg !3053
  %cmp22 = icmp sgt i64 %26, %div, !dbg !3054
  br i1 %cmp22, label %if.then23, label %if.end24, !dbg !3051

if.then23:                                        ; preds = %if.then21
  %28 = load i32*, i32** %overflow.addr, align 4, !dbg !3055
  store i32 1, i32* %28, align 4, !dbg !3056
  br label %if.end24, !dbg !3057

if.end24:                                         ; preds = %if.then23, %if.then21
  br label %if.end30, !dbg !3058

if.else:                                          ; preds = %if.end19
  %29 = load i64, i64* %abs_a, align 8, !dbg !3059
  %30 = load i64, i64* %abs_b, align 8, !dbg !3060
  %sub25 = sub nsw i64 0, %30, !dbg !3061
  %div26 = sdiv i64 -9223372036854775808, %sub25, !dbg !3062
  %cmp27 = icmp sgt i64 %29, %div26, !dbg !3063
  br i1 %cmp27, label %if.then28, label %if.end29, !dbg !3059

if.then28:                                        ; preds = %if.else
  %31 = load i32*, i32** %overflow.addr, align 4, !dbg !3064
  store i32 1, i32* %31, align 4, !dbg !3065
  br label %if.end29, !dbg !3066

if.end29:                                         ; preds = %if.then28, %if.else
  br label %if.end30

if.end30:                                         ; preds = %if.end29, %if.end24
  %32 = load i64, i64* %result, align 8, !dbg !3067
  store i64 %32, i64* %retval, align 8, !dbg !3068
  br label %return, !dbg !3068

return:                                           ; preds = %if.end30, %if.then18, %if.end11, %if.end
  %33 = load i64, i64* %retval, align 8, !dbg !3069
  ret i64 %33, !dbg !3069
}

; Function Attrs: noinline nounwind
define dso_local i32 @__mulosi4(i32 %a, i32 %b, i32* %overflow) #0 !dbg !3070 {
entry:
  %retval = alloca i32, align 4
  %a.addr = alloca i32, align 4
  %b.addr = alloca i32, align 4
  %overflow.addr = alloca i32*, align 4
  %N = alloca i32, align 4
  %MIN = alloca i32, align 4
  %MAX = alloca i32, align 4
  %result = alloca i32, align 4
  %sa = alloca i32, align 4
  %abs_a = alloca i32, align 4
  %sb = alloca i32, align 4
  %abs_b = alloca i32, align 4
  store i32 %a, i32* %a.addr, align 4
  store i32 %b, i32* %b.addr, align 4
  store i32* %overflow, i32** %overflow.addr, align 4
  store i32 32, i32* %N, align 4, !dbg !3071
  store i32 -2147483648, i32* %MIN, align 4, !dbg !3072
  store i32 2147483647, i32* %MAX, align 4, !dbg !3073
  %0 = load i32*, i32** %overflow.addr, align 4, !dbg !3074
  store i32 0, i32* %0, align 4, !dbg !3075
  %1 = load i32, i32* %a.addr, align 4, !dbg !3076
  %2 = load i32, i32* %b.addr, align 4, !dbg !3077
  %mul = mul nsw i32 %1, %2, !dbg !3078
  store i32 %mul, i32* %result, align 4, !dbg !3079
  %3 = load i32, i32* %a.addr, align 4, !dbg !3080
  %cmp = icmp eq i32 %3, -2147483648, !dbg !3081
  br i1 %cmp, label %if.then, label %if.end4, !dbg !3080

if.then:                                          ; preds = %entry
  %4 = load i32, i32* %b.addr, align 4, !dbg !3082
  %cmp1 = icmp ne i32 %4, 0, !dbg !3083
  br i1 %cmp1, label %land.lhs.true, label %if.end, !dbg !3084

land.lhs.true:                                    ; preds = %if.then
  %5 = load i32, i32* %b.addr, align 4, !dbg !3085
  %cmp2 = icmp ne i32 %5, 1, !dbg !3086
  br i1 %cmp2, label %if.then3, label %if.end, !dbg !3082

if.then3:                                         ; preds = %land.lhs.true
  %6 = load i32*, i32** %overflow.addr, align 4, !dbg !3087
  store i32 1, i32* %6, align 4, !dbg !3088
  br label %if.end, !dbg !3089

if.end:                                           ; preds = %if.then3, %land.lhs.true, %if.then
  %7 = load i32, i32* %result, align 4, !dbg !3090
  store i32 %7, i32* %retval, align 4, !dbg !3091
  br label %return, !dbg !3091

if.end4:                                          ; preds = %entry
  %8 = load i32, i32* %b.addr, align 4, !dbg !3092
  %cmp5 = icmp eq i32 %8, -2147483648, !dbg !3093
  br i1 %cmp5, label %if.then6, label %if.end12, !dbg !3092

if.then6:                                         ; preds = %if.end4
  %9 = load i32, i32* %a.addr, align 4, !dbg !3094
  %cmp7 = icmp ne i32 %9, 0, !dbg !3095
  br i1 %cmp7, label %land.lhs.true8, label %if.end11, !dbg !3096

land.lhs.true8:                                   ; preds = %if.then6
  %10 = load i32, i32* %a.addr, align 4, !dbg !3097
  %cmp9 = icmp ne i32 %10, 1, !dbg !3098
  br i1 %cmp9, label %if.then10, label %if.end11, !dbg !3094

if.then10:                                        ; preds = %land.lhs.true8
  %11 = load i32*, i32** %overflow.addr, align 4, !dbg !3099
  store i32 1, i32* %11, align 4, !dbg !3100
  br label %if.end11, !dbg !3101

if.end11:                                         ; preds = %if.then10, %land.lhs.true8, %if.then6
  %12 = load i32, i32* %result, align 4, !dbg !3102
  store i32 %12, i32* %retval, align 4, !dbg !3103
  br label %return, !dbg !3103

if.end12:                                         ; preds = %if.end4
  %13 = load i32, i32* %a.addr, align 4, !dbg !3104
  %shr = ashr i32 %13, 31, !dbg !3105
  store i32 %shr, i32* %sa, align 4, !dbg !3106
  %14 = load i32, i32* %a.addr, align 4, !dbg !3107
  %15 = load i32, i32* %sa, align 4, !dbg !3108
  %xor = xor i32 %14, %15, !dbg !3109
  %16 = load i32, i32* %sa, align 4, !dbg !3110
  %sub = sub nsw i32 %xor, %16, !dbg !3111
  store i32 %sub, i32* %abs_a, align 4, !dbg !3112
  %17 = load i32, i32* %b.addr, align 4, !dbg !3113
  %shr13 = ashr i32 %17, 31, !dbg !3114
  store i32 %shr13, i32* %sb, align 4, !dbg !3115
  %18 = load i32, i32* %b.addr, align 4, !dbg !3116
  %19 = load i32, i32* %sb, align 4, !dbg !3117
  %xor14 = xor i32 %18, %19, !dbg !3118
  %20 = load i32, i32* %sb, align 4, !dbg !3119
  %sub15 = sub nsw i32 %xor14, %20, !dbg !3120
  store i32 %sub15, i32* %abs_b, align 4, !dbg !3121
  %21 = load i32, i32* %abs_a, align 4, !dbg !3122
  %cmp16 = icmp slt i32 %21, 2, !dbg !3123
  br i1 %cmp16, label %if.then18, label %lor.lhs.false, !dbg !3124

lor.lhs.false:                                    ; preds = %if.end12
  %22 = load i32, i32* %abs_b, align 4, !dbg !3125
  %cmp17 = icmp slt i32 %22, 2, !dbg !3126
  br i1 %cmp17, label %if.then18, label %if.end19, !dbg !3122

if.then18:                                        ; preds = %lor.lhs.false, %if.end12
  %23 = load i32, i32* %result, align 4, !dbg !3127
  store i32 %23, i32* %retval, align 4, !dbg !3128
  br label %return, !dbg !3128

if.end19:                                         ; preds = %lor.lhs.false
  %24 = load i32, i32* %sa, align 4, !dbg !3129
  %25 = load i32, i32* %sb, align 4, !dbg !3130
  %cmp20 = icmp eq i32 %24, %25, !dbg !3131
  br i1 %cmp20, label %if.then21, label %if.else, !dbg !3129

if.then21:                                        ; preds = %if.end19
  %26 = load i32, i32* %abs_a, align 4, !dbg !3132
  %27 = load i32, i32* %abs_b, align 4, !dbg !3133
  %div = sdiv i32 2147483647, %27, !dbg !3134
  %cmp22 = icmp sgt i32 %26, %div, !dbg !3135
  br i1 %cmp22, label %if.then23, label %if.end24, !dbg !3132

if.then23:                                        ; preds = %if.then21
  %28 = load i32*, i32** %overflow.addr, align 4, !dbg !3136
  store i32 1, i32* %28, align 4, !dbg !3137
  br label %if.end24, !dbg !3138

if.end24:                                         ; preds = %if.then23, %if.then21
  br label %if.end30, !dbg !3139

if.else:                                          ; preds = %if.end19
  %29 = load i32, i32* %abs_a, align 4, !dbg !3140
  %30 = load i32, i32* %abs_b, align 4, !dbg !3141
  %sub25 = sub nsw i32 0, %30, !dbg !3142
  %div26 = sdiv i32 -2147483648, %sub25, !dbg !3143
  %cmp27 = icmp sgt i32 %29, %div26, !dbg !3144
  br i1 %cmp27, label %if.then28, label %if.end29, !dbg !3140

if.then28:                                        ; preds = %if.else
  %31 = load i32*, i32** %overflow.addr, align 4, !dbg !3145
  store i32 1, i32* %31, align 4, !dbg !3146
  br label %if.end29, !dbg !3147

if.end29:                                         ; preds = %if.then28, %if.else
  br label %if.end30

if.end30:                                         ; preds = %if.end29, %if.end24
  %32 = load i32, i32* %result, align 4, !dbg !3148
  store i32 %32, i32* %retval, align 4, !dbg !3149
  br label %return, !dbg !3149

return:                                           ; preds = %if.end30, %if.then18, %if.end11, %if.end
  %33 = load i32, i32* %retval, align 4, !dbg !3150
  ret i32 %33, !dbg !3150
}

; Function Attrs: noinline nounwind
define dso_local float @__mulsf3(float %a, float %b) #0 !dbg !3151 {
entry:
  %a.addr = alloca float, align 4
  %b.addr = alloca float, align 4
  store float %a, float* %a.addr, align 4
  store float %b, float* %b.addr, align 4
  %0 = load float, float* %a.addr, align 4, !dbg !3152
  %1 = load float, float* %b.addr, align 4, !dbg !3153
  %call = call float @__mulXf3__.38(float %0, float %1) #4, !dbg !3154
  ret float %call, !dbg !3155
}

; Function Attrs: noinline nounwind
define internal float @__mulXf3__.38(float %a, float %b) #0 !dbg !3156 {
entry:
  %retval = alloca float, align 4
  %a.addr = alloca float, align 4
  %b.addr = alloca float, align 4
  %aExponent = alloca i32, align 4
  %bExponent = alloca i32, align 4
  %productSign = alloca i32, align 4
  %aSignificand = alloca i32, align 4
  %bSignificand = alloca i32, align 4
  %scale = alloca i32, align 4
  %aAbs = alloca i32, align 4
  %bAbs = alloca i32, align 4
  %productHi = alloca i32, align 4
  %productLo = alloca i32, align 4
  %productExponent = alloca i32, align 4
  %shift = alloca i32, align 4
  store float %a, float* %a.addr, align 4
  store float %b, float* %b.addr, align 4
  %0 = load float, float* %a.addr, align 4, !dbg !3157
  %call = call i32 @toRep.39(float %0) #4, !dbg !3158
  %shr = lshr i32 %call, 23, !dbg !3159
  %and = and i32 %shr, 255, !dbg !3160
  store i32 %and, i32* %aExponent, align 4, !dbg !3161
  %1 = load float, float* %b.addr, align 4, !dbg !3162
  %call1 = call i32 @toRep.39(float %1) #4, !dbg !3163
  %shr2 = lshr i32 %call1, 23, !dbg !3164
  %and3 = and i32 %shr2, 255, !dbg !3165
  store i32 %and3, i32* %bExponent, align 4, !dbg !3166
  %2 = load float, float* %a.addr, align 4, !dbg !3167
  %call4 = call i32 @toRep.39(float %2) #4, !dbg !3168
  %3 = load float, float* %b.addr, align 4, !dbg !3169
  %call5 = call i32 @toRep.39(float %3) #4, !dbg !3170
  %xor = xor i32 %call4, %call5, !dbg !3171
  %and6 = and i32 %xor, -2147483648, !dbg !3172
  store i32 %and6, i32* %productSign, align 4, !dbg !3173
  %4 = load float, float* %a.addr, align 4, !dbg !3174
  %call7 = call i32 @toRep.39(float %4) #4, !dbg !3175
  %and8 = and i32 %call7, 8388607, !dbg !3176
  store i32 %and8, i32* %aSignificand, align 4, !dbg !3177
  %5 = load float, float* %b.addr, align 4, !dbg !3178
  %call9 = call i32 @toRep.39(float %5) #4, !dbg !3179
  %and10 = and i32 %call9, 8388607, !dbg !3180
  store i32 %and10, i32* %bSignificand, align 4, !dbg !3181
  store i32 0, i32* %scale, align 4, !dbg !3182
  %6 = load i32, i32* %aExponent, align 4, !dbg !3183
  %sub = sub i32 %6, 1, !dbg !3184
  %cmp = icmp uge i32 %sub, 254, !dbg !3185
  br i1 %cmp, label %if.then, label %lor.lhs.false, !dbg !3186

lor.lhs.false:                                    ; preds = %entry
  %7 = load i32, i32* %bExponent, align 4, !dbg !3187
  %sub11 = sub i32 %7, 1, !dbg !3188
  %cmp12 = icmp uge i32 %sub11, 254, !dbg !3189
  br i1 %cmp12, label %if.then, label %if.end60, !dbg !3183

if.then:                                          ; preds = %lor.lhs.false, %entry
  %8 = load float, float* %a.addr, align 4, !dbg !3190
  %call13 = call i32 @toRep.39(float %8) #4, !dbg !3191
  %and14 = and i32 %call13, 2147483647, !dbg !3192
  store i32 %and14, i32* %aAbs, align 4, !dbg !3193
  %9 = load float, float* %b.addr, align 4, !dbg !3194
  %call15 = call i32 @toRep.39(float %9) #4, !dbg !3195
  %and16 = and i32 %call15, 2147483647, !dbg !3196
  store i32 %and16, i32* %bAbs, align 4, !dbg !3197
  %10 = load i32, i32* %aAbs, align 4, !dbg !3198
  %cmp17 = icmp ugt i32 %10, 2139095040, !dbg !3199
  br i1 %cmp17, label %if.then18, label %if.end, !dbg !3198

if.then18:                                        ; preds = %if.then
  %11 = load float, float* %a.addr, align 4, !dbg !3200
  %call19 = call i32 @toRep.39(float %11) #4, !dbg !3201
  %or = or i32 %call19, 4194304, !dbg !3202
  %call20 = call float @fromRep.40(i32 %or) #4, !dbg !3203
  store float %call20, float* %retval, align 4, !dbg !3204
  br label %return, !dbg !3204

if.end:                                           ; preds = %if.then
  %12 = load i32, i32* %bAbs, align 4, !dbg !3205
  %cmp21 = icmp ugt i32 %12, 2139095040, !dbg !3206
  br i1 %cmp21, label %if.then22, label %if.end26, !dbg !3205

if.then22:                                        ; preds = %if.end
  %13 = load float, float* %b.addr, align 4, !dbg !3207
  %call23 = call i32 @toRep.39(float %13) #4, !dbg !3208
  %or24 = or i32 %call23, 4194304, !dbg !3209
  %call25 = call float @fromRep.40(i32 %or24) #4, !dbg !3210
  store float %call25, float* %retval, align 4, !dbg !3211
  br label %return, !dbg !3211

if.end26:                                         ; preds = %if.end
  %14 = load i32, i32* %aAbs, align 4, !dbg !3212
  %cmp27 = icmp eq i32 %14, 2139095040, !dbg !3213
  br i1 %cmp27, label %if.then28, label %if.end33, !dbg !3212

if.then28:                                        ; preds = %if.end26
  %15 = load i32, i32* %bAbs, align 4, !dbg !3214
  %tobool = icmp ne i32 %15, 0, !dbg !3214
  br i1 %tobool, label %if.then29, label %if.else, !dbg !3214

if.then29:                                        ; preds = %if.then28
  %16 = load i32, i32* %aAbs, align 4, !dbg !3215
  %17 = load i32, i32* %productSign, align 4, !dbg !3216
  %or30 = or i32 %16, %17, !dbg !3217
  %call31 = call float @fromRep.40(i32 %or30) #4, !dbg !3218
  store float %call31, float* %retval, align 4, !dbg !3219
  br label %return, !dbg !3219

if.else:                                          ; preds = %if.then28
  %call32 = call float @fromRep.40(i32 2143289344) #4, !dbg !3220
  store float %call32, float* %retval, align 4, !dbg !3221
  br label %return, !dbg !3221

if.end33:                                         ; preds = %if.end26
  %18 = load i32, i32* %bAbs, align 4, !dbg !3222
  %cmp34 = icmp eq i32 %18, 2139095040, !dbg !3223
  br i1 %cmp34, label %if.then35, label %if.end42, !dbg !3222

if.then35:                                        ; preds = %if.end33
  %19 = load i32, i32* %aAbs, align 4, !dbg !3224
  %tobool36 = icmp ne i32 %19, 0, !dbg !3224
  br i1 %tobool36, label %if.then37, label %if.else40, !dbg !3224

if.then37:                                        ; preds = %if.then35
  %20 = load i32, i32* %bAbs, align 4, !dbg !3225
  %21 = load i32, i32* %productSign, align 4, !dbg !3226
  %or38 = or i32 %20, %21, !dbg !3227
  %call39 = call float @fromRep.40(i32 %or38) #4, !dbg !3228
  store float %call39, float* %retval, align 4, !dbg !3229
  br label %return, !dbg !3229

if.else40:                                        ; preds = %if.then35
  %call41 = call float @fromRep.40(i32 2143289344) #4, !dbg !3230
  store float %call41, float* %retval, align 4, !dbg !3231
  br label %return, !dbg !3231

if.end42:                                         ; preds = %if.end33
  %22 = load i32, i32* %aAbs, align 4, !dbg !3232
  %tobool43 = icmp ne i32 %22, 0, !dbg !3232
  br i1 %tobool43, label %if.end46, label %if.then44, !dbg !3233

if.then44:                                        ; preds = %if.end42
  %23 = load i32, i32* %productSign, align 4, !dbg !3234
  %call45 = call float @fromRep.40(i32 %23) #4, !dbg !3235
  store float %call45, float* %retval, align 4, !dbg !3236
  br label %return, !dbg !3236

if.end46:                                         ; preds = %if.end42
  %24 = load i32, i32* %bAbs, align 4, !dbg !3237
  %tobool47 = icmp ne i32 %24, 0, !dbg !3237
  br i1 %tobool47, label %if.end50, label %if.then48, !dbg !3238

if.then48:                                        ; preds = %if.end46
  %25 = load i32, i32* %productSign, align 4, !dbg !3239
  %call49 = call float @fromRep.40(i32 %25) #4, !dbg !3240
  store float %call49, float* %retval, align 4, !dbg !3241
  br label %return, !dbg !3241

if.end50:                                         ; preds = %if.end46
  %26 = load i32, i32* %aAbs, align 4, !dbg !3242
  %cmp51 = icmp ult i32 %26, 8388608, !dbg !3243
  br i1 %cmp51, label %if.then52, label %if.end54, !dbg !3242

if.then52:                                        ; preds = %if.end50
  %call53 = call i32 @normalize.41(i32* %aSignificand) #4, !dbg !3244
  %27 = load i32, i32* %scale, align 4, !dbg !3245
  %add = add nsw i32 %27, %call53, !dbg !3245
  store i32 %add, i32* %scale, align 4, !dbg !3245
  br label %if.end54, !dbg !3246

if.end54:                                         ; preds = %if.then52, %if.end50
  %28 = load i32, i32* %bAbs, align 4, !dbg !3247
  %cmp55 = icmp ult i32 %28, 8388608, !dbg !3248
  br i1 %cmp55, label %if.then56, label %if.end59, !dbg !3247

if.then56:                                        ; preds = %if.end54
  %call57 = call i32 @normalize.41(i32* %bSignificand) #4, !dbg !3249
  %29 = load i32, i32* %scale, align 4, !dbg !3250
  %add58 = add nsw i32 %29, %call57, !dbg !3250
  store i32 %add58, i32* %scale, align 4, !dbg !3250
  br label %if.end59, !dbg !3251

if.end59:                                         ; preds = %if.then56, %if.end54
  br label %if.end60, !dbg !3252

if.end60:                                         ; preds = %if.end59, %lor.lhs.false
  %30 = load i32, i32* %aSignificand, align 4, !dbg !3253
  %or61 = or i32 %30, 8388608, !dbg !3253
  store i32 %or61, i32* %aSignificand, align 4, !dbg !3253
  %31 = load i32, i32* %bSignificand, align 4, !dbg !3254
  %or62 = or i32 %31, 8388608, !dbg !3254
  store i32 %or62, i32* %bSignificand, align 4, !dbg !3254
  %32 = load i32, i32* %aSignificand, align 4, !dbg !3255
  %33 = load i32, i32* %bSignificand, align 4, !dbg !3256
  %shl = shl i32 %33, 8, !dbg !3257
  call void @wideMultiply.42(i32 %32, i32 %shl, i32* %productHi, i32* %productLo) #4, !dbg !3258
  %34 = load i32, i32* %aExponent, align 4, !dbg !3259
  %35 = load i32, i32* %bExponent, align 4, !dbg !3260
  %add63 = add i32 %34, %35, !dbg !3261
  %sub64 = sub i32 %add63, 127, !dbg !3262
  %36 = load i32, i32* %scale, align 4, !dbg !3263
  %add65 = add i32 %sub64, %36, !dbg !3264
  store i32 %add65, i32* %productExponent, align 4, !dbg !3265
  %37 = load i32, i32* %productHi, align 4, !dbg !3266
  %and66 = and i32 %37, 8388608, !dbg !3267
  %tobool67 = icmp ne i32 %and66, 0, !dbg !3267
  br i1 %tobool67, label %if.then68, label %if.else69, !dbg !3266

if.then68:                                        ; preds = %if.end60
  %38 = load i32, i32* %productExponent, align 4, !dbg !3268
  %inc = add nsw i32 %38, 1, !dbg !3268
  store i32 %inc, i32* %productExponent, align 4, !dbg !3268
  br label %if.end70, !dbg !3269

if.else69:                                        ; preds = %if.end60
  call void @wideLeftShift.43(i32* %productHi, i32* %productLo, i32 1) #4, !dbg !3270
  br label %if.end70

if.end70:                                         ; preds = %if.else69, %if.then68
  %39 = load i32, i32* %productExponent, align 4, !dbg !3271
  %cmp71 = icmp sge i32 %39, 255, !dbg !3272
  br i1 %cmp71, label %if.then72, label %if.end75, !dbg !3271

if.then72:                                        ; preds = %if.end70
  %40 = load i32, i32* %productSign, align 4, !dbg !3273
  %or73 = or i32 2139095040, %40, !dbg !3274
  %call74 = call float @fromRep.40(i32 %or73) #4, !dbg !3275
  store float %call74, float* %retval, align 4, !dbg !3276
  br label %return, !dbg !3276

if.end75:                                         ; preds = %if.end70
  %41 = load i32, i32* %productExponent, align 4, !dbg !3277
  %cmp76 = icmp sle i32 %41, 0, !dbg !3278
  br i1 %cmp76, label %if.then77, label %if.else83, !dbg !3277

if.then77:                                        ; preds = %if.end75
  %42 = load i32, i32* %productExponent, align 4, !dbg !3279
  %sub78 = sub i32 1, %42, !dbg !3280
  store i32 %sub78, i32* %shift, align 4, !dbg !3281
  %43 = load i32, i32* %shift, align 4, !dbg !3282
  %cmp79 = icmp uge i32 %43, 32, !dbg !3283
  br i1 %cmp79, label %if.then80, label %if.end82, !dbg !3282

if.then80:                                        ; preds = %if.then77
  %44 = load i32, i32* %productSign, align 4, !dbg !3284
  %call81 = call float @fromRep.40(i32 %44) #4, !dbg !3285
  store float %call81, float* %retval, align 4, !dbg !3286
  br label %return, !dbg !3286

if.end82:                                         ; preds = %if.then77
  %45 = load i32, i32* %shift, align 4, !dbg !3287
  call void @wideRightShiftWithSticky.44(i32* %productHi, i32* %productLo, i32 %45) #4, !dbg !3288
  br label %if.end87, !dbg !3289

if.else83:                                        ; preds = %if.end75
  %46 = load i32, i32* %productHi, align 4, !dbg !3290
  %and84 = and i32 %46, 8388607, !dbg !3290
  store i32 %and84, i32* %productHi, align 4, !dbg !3290
  %47 = load i32, i32* %productExponent, align 4, !dbg !3291
  %shl85 = shl i32 %47, 23, !dbg !3292
  %48 = load i32, i32* %productHi, align 4, !dbg !3293
  %or86 = or i32 %48, %shl85, !dbg !3293
  store i32 %or86, i32* %productHi, align 4, !dbg !3293
  br label %if.end87

if.end87:                                         ; preds = %if.else83, %if.end82
  %49 = load i32, i32* %productSign, align 4, !dbg !3294
  %50 = load i32, i32* %productHi, align 4, !dbg !3295
  %or88 = or i32 %50, %49, !dbg !3295
  store i32 %or88, i32* %productHi, align 4, !dbg !3295
  %51 = load i32, i32* %productLo, align 4, !dbg !3296
  %cmp89 = icmp ugt i32 %51, -2147483648, !dbg !3297
  br i1 %cmp89, label %if.then90, label %if.end92, !dbg !3296

if.then90:                                        ; preds = %if.end87
  %52 = load i32, i32* %productHi, align 4, !dbg !3298
  %inc91 = add i32 %52, 1, !dbg !3298
  store i32 %inc91, i32* %productHi, align 4, !dbg !3298
  br label %if.end92, !dbg !3299

if.end92:                                         ; preds = %if.then90, %if.end87
  %53 = load i32, i32* %productLo, align 4, !dbg !3300
  %cmp93 = icmp eq i32 %53, -2147483648, !dbg !3301
  br i1 %cmp93, label %if.then94, label %if.end97, !dbg !3300

if.then94:                                        ; preds = %if.end92
  %54 = load i32, i32* %productHi, align 4, !dbg !3302
  %and95 = and i32 %54, 1, !dbg !3303
  %55 = load i32, i32* %productHi, align 4, !dbg !3304
  %add96 = add i32 %55, %and95, !dbg !3304
  store i32 %add96, i32* %productHi, align 4, !dbg !3304
  br label %if.end97, !dbg !3305

if.end97:                                         ; preds = %if.then94, %if.end92
  %56 = load i32, i32* %productHi, align 4, !dbg !3306
  %call98 = call float @fromRep.40(i32 %56) #4, !dbg !3307
  store float %call98, float* %retval, align 4, !dbg !3308
  br label %return, !dbg !3308

return:                                           ; preds = %if.end97, %if.then80, %if.then72, %if.then48, %if.then44, %if.else40, %if.then37, %if.else, %if.then29, %if.then22, %if.then18
  %57 = load float, float* %retval, align 4, !dbg !3309
  ret float %57, !dbg !3309
}

; Function Attrs: noinline nounwind
define internal i32 @toRep.39(float %x) #0 !dbg !3310 {
entry:
  %x.addr = alloca float, align 4
  %rep = alloca %union.anon.0.0, align 4
  store float %x, float* %x.addr, align 4
  %f = bitcast %union.anon.0.0* %rep to float*, !dbg !3311
  %0 = load float, float* %x.addr, align 4, !dbg !3312
  store float %0, float* %f, align 4, !dbg !3311
  %i = bitcast %union.anon.0.0* %rep to i32*, !dbg !3313
  %1 = load i32, i32* %i, align 4, !dbg !3313
  ret i32 %1, !dbg !3314
}

; Function Attrs: noinline nounwind
define internal float @fromRep.40(i32 %x) #0 !dbg !3315 {
entry:
  %x.addr = alloca i32, align 4
  %rep = alloca %union.anon.0.0, align 4
  store i32 %x, i32* %x.addr, align 4
  %i = bitcast %union.anon.0.0* %rep to i32*, !dbg !3316
  %0 = load i32, i32* %x.addr, align 4, !dbg !3317
  store i32 %0, i32* %i, align 4, !dbg !3316
  %f = bitcast %union.anon.0.0* %rep to float*, !dbg !3318
  %1 = load float, float* %f, align 4, !dbg !3318
  ret float %1, !dbg !3319
}

; Function Attrs: noinline nounwind
define internal i32 @normalize.41(i32* %significand) #0 !dbg !3320 {
entry:
  %significand.addr = alloca i32*, align 4
  %shift = alloca i32, align 4
  store i32* %significand, i32** %significand.addr, align 4
  %0 = load i32*, i32** %significand.addr, align 4, !dbg !3321
  %1 = load i32, i32* %0, align 4, !dbg !3322
  %call = call i32 @rep_clz.45(i32 %1) #4, !dbg !3323
  %call1 = call i32 @rep_clz.45(i32 8388608) #4, !dbg !3324
  %sub = sub nsw i32 %call, %call1, !dbg !3325
  store i32 %sub, i32* %shift, align 4, !dbg !3326
  %2 = load i32, i32* %shift, align 4, !dbg !3327
  %3 = load i32*, i32** %significand.addr, align 4, !dbg !3328
  %4 = load i32, i32* %3, align 4, !dbg !3329
  %shl = shl i32 %4, %2, !dbg !3329
  store i32 %shl, i32* %3, align 4, !dbg !3329
  %5 = load i32, i32* %shift, align 4, !dbg !3330
  %sub2 = sub nsw i32 1, %5, !dbg !3331
  ret i32 %sub2, !dbg !3332
}

; Function Attrs: noinline nounwind
define internal void @wideMultiply.42(i32 %a, i32 %b, i32* %hi, i32* %lo) #0 !dbg !3333 {
entry:
  %a.addr = alloca i32, align 4
  %b.addr = alloca i32, align 4
  %hi.addr = alloca i32*, align 4
  %lo.addr = alloca i32*, align 4
  %product = alloca i64, align 8
  store i32 %a, i32* %a.addr, align 4
  store i32 %b, i32* %b.addr, align 4
  store i32* %hi, i32** %hi.addr, align 4
  store i32* %lo, i32** %lo.addr, align 4
  %0 = load i32, i32* %a.addr, align 4, !dbg !3334
  %conv = zext i32 %0 to i64, !dbg !3335
  %1 = load i32, i32* %b.addr, align 4, !dbg !3336
  %conv1 = zext i32 %1 to i64, !dbg !3336
  %mul = mul i64 %conv, %conv1, !dbg !3337
  store i64 %mul, i64* %product, align 8, !dbg !3338
  %2 = load i64, i64* %product, align 8, !dbg !3339
  %shr = lshr i64 %2, 32, !dbg !3340
  %conv2 = trunc i64 %shr to i32, !dbg !3339
  %3 = load i32*, i32** %hi.addr, align 4, !dbg !3341
  store i32 %conv2, i32* %3, align 4, !dbg !3342
  %4 = load i64, i64* %product, align 8, !dbg !3343
  %conv3 = trunc i64 %4 to i32, !dbg !3343
  %5 = load i32*, i32** %lo.addr, align 4, !dbg !3344
  store i32 %conv3, i32* %5, align 4, !dbg !3345
  ret void, !dbg !3346
}

; Function Attrs: noinline nounwind
define internal void @wideLeftShift.43(i32* %hi, i32* %lo, i32 %count) #0 !dbg !3347 {
entry:
  %hi.addr = alloca i32*, align 4
  %lo.addr = alloca i32*, align 4
  %count.addr = alloca i32, align 4
  store i32* %hi, i32** %hi.addr, align 4
  store i32* %lo, i32** %lo.addr, align 4
  store i32 %count, i32* %count.addr, align 4
  %0 = load i32*, i32** %hi.addr, align 4, !dbg !3348
  %1 = load i32, i32* %0, align 4, !dbg !3349
  %2 = load i32, i32* %count.addr, align 4, !dbg !3350
  %shl = shl i32 %1, %2, !dbg !3351
  %3 = load i32*, i32** %lo.addr, align 4, !dbg !3352
  %4 = load i32, i32* %3, align 4, !dbg !3353
  %5 = load i32, i32* %count.addr, align 4, !dbg !3354
  %sub = sub i32 32, %5, !dbg !3355
  %shr = lshr i32 %4, %sub, !dbg !3356
  %or = or i32 %shl, %shr, !dbg !3357
  %6 = load i32*, i32** %hi.addr, align 4, !dbg !3358
  store i32 %or, i32* %6, align 4, !dbg !3359
  %7 = load i32*, i32** %lo.addr, align 4, !dbg !3360
  %8 = load i32, i32* %7, align 4, !dbg !3361
  %9 = load i32, i32* %count.addr, align 4, !dbg !3362
  %shl1 = shl i32 %8, %9, !dbg !3363
  %10 = load i32*, i32** %lo.addr, align 4, !dbg !3364
  store i32 %shl1, i32* %10, align 4, !dbg !3365
  ret void, !dbg !3366
}

; Function Attrs: noinline nounwind
define internal void @wideRightShiftWithSticky.44(i32* %hi, i32* %lo, i32 %count) #0 !dbg !3367 {
entry:
  %hi.addr = alloca i32*, align 4
  %lo.addr = alloca i32*, align 4
  %count.addr = alloca i32, align 4
  %sticky = alloca i8, align 1
  %sticky9 = alloca i8, align 1
  %sticky21 = alloca i8, align 1
  store i32* %hi, i32** %hi.addr, align 4
  store i32* %lo, i32** %lo.addr, align 4
  store i32 %count, i32* %count.addr, align 4
  %0 = load i32, i32* %count.addr, align 4, !dbg !3368
  %cmp = icmp ult i32 %0, 32, !dbg !3369
  br i1 %cmp, label %if.then, label %if.else, !dbg !3368

if.then:                                          ; preds = %entry
  %1 = load i32*, i32** %lo.addr, align 4, !dbg !3370
  %2 = load i32, i32* %1, align 4, !dbg !3371
  %3 = load i32, i32* %count.addr, align 4, !dbg !3372
  %sub = sub i32 32, %3, !dbg !3373
  %shl = shl i32 %2, %sub, !dbg !3374
  %tobool = icmp ne i32 %shl, 0, !dbg !3371
  %frombool = zext i1 %tobool to i8, !dbg !3375
  store i8 %frombool, i8* %sticky, align 1, !dbg !3375
  %4 = load i32*, i32** %hi.addr, align 4, !dbg !3376
  %5 = load i32, i32* %4, align 4, !dbg !3377
  %6 = load i32, i32* %count.addr, align 4, !dbg !3378
  %sub1 = sub i32 32, %6, !dbg !3379
  %shl2 = shl i32 %5, %sub1, !dbg !3380
  %7 = load i32*, i32** %lo.addr, align 4, !dbg !3381
  %8 = load i32, i32* %7, align 4, !dbg !3382
  %9 = load i32, i32* %count.addr, align 4, !dbg !3383
  %shr = lshr i32 %8, %9, !dbg !3384
  %or = or i32 %shl2, %shr, !dbg !3385
  %10 = load i8, i8* %sticky, align 1, !dbg !3386
  %tobool3 = trunc i8 %10 to i1, !dbg !3386
  %conv = zext i1 %tobool3 to i32, !dbg !3386
  %or4 = or i32 %or, %conv, !dbg !3387
  %11 = load i32*, i32** %lo.addr, align 4, !dbg !3388
  store i32 %or4, i32* %11, align 4, !dbg !3389
  %12 = load i32*, i32** %hi.addr, align 4, !dbg !3390
  %13 = load i32, i32* %12, align 4, !dbg !3391
  %14 = load i32, i32* %count.addr, align 4, !dbg !3392
  %shr5 = lshr i32 %13, %14, !dbg !3393
  %15 = load i32*, i32** %hi.addr, align 4, !dbg !3394
  store i32 %shr5, i32* %15, align 4, !dbg !3395
  br label %if.end27, !dbg !3396

if.else:                                          ; preds = %entry
  %16 = load i32, i32* %count.addr, align 4, !dbg !3397
  %cmp6 = icmp ult i32 %16, 64, !dbg !3398
  br i1 %cmp6, label %if.then8, label %if.else20, !dbg !3397

if.then8:                                         ; preds = %if.else
  %17 = load i32*, i32** %hi.addr, align 4, !dbg !3399
  %18 = load i32, i32* %17, align 4, !dbg !3400
  %19 = load i32, i32* %count.addr, align 4, !dbg !3401
  %sub10 = sub i32 64, %19, !dbg !3402
  %shl11 = shl i32 %18, %sub10, !dbg !3403
  %20 = load i32*, i32** %lo.addr, align 4, !dbg !3404
  %21 = load i32, i32* %20, align 4, !dbg !3405
  %or12 = or i32 %shl11, %21, !dbg !3406
  %tobool13 = icmp ne i32 %or12, 0, !dbg !3400
  %frombool14 = zext i1 %tobool13 to i8, !dbg !3407
  store i8 %frombool14, i8* %sticky9, align 1, !dbg !3407
  %22 = load i32*, i32** %hi.addr, align 4, !dbg !3408
  %23 = load i32, i32* %22, align 4, !dbg !3409
  %24 = load i32, i32* %count.addr, align 4, !dbg !3410
  %sub15 = sub i32 %24, 32, !dbg !3411
  %shr16 = lshr i32 %23, %sub15, !dbg !3412
  %25 = load i8, i8* %sticky9, align 1, !dbg !3413
  %tobool17 = trunc i8 %25 to i1, !dbg !3413
  %conv18 = zext i1 %tobool17 to i32, !dbg !3413
  %or19 = or i32 %shr16, %conv18, !dbg !3414
  %26 = load i32*, i32** %lo.addr, align 4, !dbg !3415
  store i32 %or19, i32* %26, align 4, !dbg !3416
  %27 = load i32*, i32** %hi.addr, align 4, !dbg !3417
  store i32 0, i32* %27, align 4, !dbg !3418
  br label %if.end, !dbg !3419

if.else20:                                        ; preds = %if.else
  %28 = load i32*, i32** %hi.addr, align 4, !dbg !3420
  %29 = load i32, i32* %28, align 4, !dbg !3421
  %30 = load i32*, i32** %lo.addr, align 4, !dbg !3422
  %31 = load i32, i32* %30, align 4, !dbg !3423
  %or22 = or i32 %29, %31, !dbg !3424
  %tobool23 = icmp ne i32 %or22, 0, !dbg !3421
  %frombool24 = zext i1 %tobool23 to i8, !dbg !3425
  store i8 %frombool24, i8* %sticky21, align 1, !dbg !3425
  %32 = load i8, i8* %sticky21, align 1, !dbg !3426
  %tobool25 = trunc i8 %32 to i1, !dbg !3426
  %conv26 = zext i1 %tobool25 to i32, !dbg !3426
  %33 = load i32*, i32** %lo.addr, align 4, !dbg !3427
  store i32 %conv26, i32* %33, align 4, !dbg !3428
  %34 = load i32*, i32** %hi.addr, align 4, !dbg !3429
  store i32 0, i32* %34, align 4, !dbg !3430
  br label %if.end

if.end:                                           ; preds = %if.else20, %if.then8
  br label %if.end27

if.end27:                                         ; preds = %if.end, %if.then
  ret void, !dbg !3431
}

; Function Attrs: noinline nounwind
define internal i32 @rep_clz.45(i32 %a) #0 !dbg !3432 {
entry:
  %a.addr = alloca i32, align 4
  store i32 %a, i32* %a.addr, align 4
  %0 = load i32, i32* %a.addr, align 4, !dbg !3433
  %1 = call i32 @llvm.ctlz.i32(i32 %0, i1 true), !dbg !3434
  ret i32 %1, !dbg !3435
}

; Function Attrs: noinline nounwind
define dso_local double @__negdf2(double %a) #0 !dbg !3436 {
entry:
  %a.addr = alloca double, align 8
  store double %a, double* %a.addr, align 8
  %0 = load double, double* %a.addr, align 8, !dbg !3437
  %call = call i64 @toRep.46(double %0) #4, !dbg !3438
  %xor = xor i64 %call, -9223372036854775808, !dbg !3439
  %call1 = call double @fromRep.47(i64 %xor) #4, !dbg !3440
  ret double %call1, !dbg !3441
}

; Function Attrs: noinline nounwind
define internal i64 @toRep.46(double %x) #0 !dbg !3442 {
entry:
  %x.addr = alloca double, align 8
  %rep = alloca %union.anon.0, align 8
  store double %x, double* %x.addr, align 8
  %f = bitcast %union.anon.0* %rep to double*, !dbg !3443
  %0 = load double, double* %x.addr, align 8, !dbg !3444
  store double %0, double* %f, align 8, !dbg !3443
  %i = bitcast %union.anon.0* %rep to i64*, !dbg !3445
  %1 = load i64, i64* %i, align 8, !dbg !3445
  ret i64 %1, !dbg !3446
}

; Function Attrs: noinline nounwind
define internal double @fromRep.47(i64 %x) #0 !dbg !3447 {
entry:
  %x.addr = alloca i64, align 8
  %rep = alloca %union.anon.0, align 8
  store i64 %x, i64* %x.addr, align 8
  %i = bitcast %union.anon.0* %rep to i64*, !dbg !3448
  %0 = load i64, i64* %x.addr, align 8, !dbg !3449
  store i64 %0, i64* %i, align 8, !dbg !3448
  %f = bitcast %union.anon.0* %rep to double*, !dbg !3450
  %1 = load double, double* %f, align 8, !dbg !3450
  ret double %1, !dbg !3451
}

; Function Attrs: noinline nounwind
define dso_local i64 @__negdi2(i64 %a) #0 !dbg !3452 {
entry:
  %a.addr = alloca i64, align 8
  store i64 %a, i64* %a.addr, align 8
  %0 = load i64, i64* %a.addr, align 8, !dbg !3453
  %sub = sub nsw i64 0, %0, !dbg !3454
  ret i64 %sub, !dbg !3455
}

; Function Attrs: noinline nounwind
define dso_local float @__negsf2(float %a) #0 !dbg !3456 {
entry:
  %a.addr = alloca float, align 4
  store float %a, float* %a.addr, align 4
  %0 = load float, float* %a.addr, align 4, !dbg !3457
  %call = call i32 @toRep.48(float %0) #4, !dbg !3458
  %xor = xor i32 %call, -2147483648, !dbg !3459
  %call1 = call float @fromRep.49(i32 %xor) #4, !dbg !3460
  ret float %call1, !dbg !3461
}

; Function Attrs: noinline nounwind
define internal i32 @toRep.48(float %x) #0 !dbg !3462 {
entry:
  %x.addr = alloca float, align 4
  %rep = alloca %union.anon.0.0, align 4
  store float %x, float* %x.addr, align 4
  %f = bitcast %union.anon.0.0* %rep to float*, !dbg !3463
  %0 = load float, float* %x.addr, align 4, !dbg !3464
  store float %0, float* %f, align 4, !dbg !3463
  %i = bitcast %union.anon.0.0* %rep to i32*, !dbg !3465
  %1 = load i32, i32* %i, align 4, !dbg !3465
  ret i32 %1, !dbg !3466
}

; Function Attrs: noinline nounwind
define internal float @fromRep.49(i32 %x) #0 !dbg !3467 {
entry:
  %x.addr = alloca i32, align 4
  %rep = alloca %union.anon.0.0, align 4
  store i32 %x, i32* %x.addr, align 4
  %i = bitcast %union.anon.0.0* %rep to i32*, !dbg !3468
  %0 = load i32, i32* %x.addr, align 4, !dbg !3469
  store i32 %0, i32* %i, align 4, !dbg !3468
  %f = bitcast %union.anon.0.0* %rep to float*, !dbg !3470
  %1 = load float, float* %f, align 4, !dbg !3470
  ret float %1, !dbg !3471
}

; Function Attrs: noinline nounwind
define dso_local i64 @__negvdi2(i64 %a) #0 !dbg !3472 {
entry:
  %a.addr = alloca i64, align 8
  %MIN = alloca i64, align 8
  store i64 %a, i64* %a.addr, align 8
  store i64 -9223372036854775808, i64* %MIN, align 8, !dbg !3473
  %0 = load i64, i64* %a.addr, align 8, !dbg !3474
  %cmp = icmp eq i64 %0, -9223372036854775808, !dbg !3475
  br i1 %cmp, label %if.then, label %if.end, !dbg !3474

if.then:                                          ; preds = %entry
  call void @compilerrt_abort_impl(i8* getelementptr inbounds ([76 x i8], [76 x i8]* @.str, i32 0, i32 0), i32 26, i8* getelementptr inbounds ([10 x i8], [10 x i8]* @__func__.__negvdi2, i32 0, i32 0)) #5, !dbg !3476
  unreachable, !dbg !3476

if.end:                                           ; preds = %entry
  %1 = load i64, i64* %a.addr, align 8, !dbg !3477
  %sub = sub nsw i64 0, %1, !dbg !3478
  ret i64 %sub, !dbg !3479
}

; Function Attrs: noinline nounwind
define dso_local i32 @__negvsi2(i32 %a) #0 !dbg !3480 {
entry:
  %a.addr = alloca i32, align 4
  %MIN = alloca i32, align 4
  store i32 %a, i32* %a.addr, align 4
  store i32 -2147483648, i32* %MIN, align 4, !dbg !3481
  %0 = load i32, i32* %a.addr, align 4, !dbg !3482
  %cmp = icmp eq i32 %0, -2147483648, !dbg !3483
  br i1 %cmp, label %if.then, label %if.end, !dbg !3482

if.then:                                          ; preds = %entry
  call void @compilerrt_abort_impl(i8* getelementptr inbounds ([76 x i8], [76 x i8]* @.str.50, i32 0, i32 0), i32 26, i8* getelementptr inbounds ([10 x i8], [10 x i8]* @__func__.__negvsi2, i32 0, i32 0)) #5, !dbg !3484
  unreachable, !dbg !3484

if.end:                                           ; preds = %entry
  %1 = load i32, i32* %a.addr, align 4, !dbg !3485
  %sub = sub nsw i32 0, %1, !dbg !3486
  ret i32 %sub, !dbg !3487
}

; Function Attrs: noinline nounwind
define dso_local double @__powidf2(double %a, i32 %b) #0 !dbg !3488 {
entry:
  %a.addr = alloca double, align 8
  %b.addr = alloca i32, align 4
  %recip = alloca i32, align 4
  %r = alloca double, align 8
  store double %a, double* %a.addr, align 8
  store i32 %b, i32* %b.addr, align 4
  %0 = load i32, i32* %b.addr, align 4, !dbg !3489
  %cmp = icmp slt i32 %0, 0, !dbg !3490
  %conv = zext i1 %cmp to i32, !dbg !3490
  store i32 %conv, i32* %recip, align 4, !dbg !3491
  store double 1.000000e+00, double* %r, align 8, !dbg !3492
  br label %while.body, !dbg !3493

while.body:                                       ; preds = %if.end4, %entry
  %1 = load i32, i32* %b.addr, align 4, !dbg !3494
  %and = and i32 %1, 1, !dbg !3495
  %tobool = icmp ne i32 %and, 0, !dbg !3495
  br i1 %tobool, label %if.then, label %if.end, !dbg !3494

if.then:                                          ; preds = %while.body
  %2 = load double, double* %a.addr, align 8, !dbg !3496
  %3 = load double, double* %r, align 8, !dbg !3497
  %mul = fmul double %3, %2, !dbg !3497
  store double %mul, double* %r, align 8, !dbg !3497
  br label %if.end, !dbg !3498

if.end:                                           ; preds = %if.then, %while.body
  %4 = load i32, i32* %b.addr, align 4, !dbg !3499
  %div = sdiv i32 %4, 2, !dbg !3499
  store i32 %div, i32* %b.addr, align 4, !dbg !3499
  %5 = load i32, i32* %b.addr, align 4, !dbg !3500
  %cmp1 = icmp eq i32 %5, 0, !dbg !3501
  br i1 %cmp1, label %if.then3, label %if.end4, !dbg !3500

if.then3:                                         ; preds = %if.end
  br label %while.end, !dbg !3502

if.end4:                                          ; preds = %if.end
  %6 = load double, double* %a.addr, align 8, !dbg !3503
  %7 = load double, double* %a.addr, align 8, !dbg !3504
  %mul5 = fmul double %7, %6, !dbg !3504
  store double %mul5, double* %a.addr, align 8, !dbg !3504
  br label %while.body, !dbg !3493, !llvm.loop !3505

while.end:                                        ; preds = %if.then3
  %8 = load i32, i32* %recip, align 4, !dbg !3507
  %tobool6 = icmp ne i32 %8, 0, !dbg !3507
  br i1 %tobool6, label %cond.true, label %cond.false, !dbg !3507

cond.true:                                        ; preds = %while.end
  %9 = load double, double* %r, align 8, !dbg !3508
  %div7 = fdiv double 1.000000e+00, %9, !dbg !3509
  br label %cond.end, !dbg !3507

cond.false:                                       ; preds = %while.end
  %10 = load double, double* %r, align 8, !dbg !3510
  br label %cond.end, !dbg !3507

cond.end:                                         ; preds = %cond.false, %cond.true
  %cond = phi double [ %div7, %cond.true ], [ %10, %cond.false ], !dbg !3507
  ret double %cond, !dbg !3511
}

; Function Attrs: noinline nounwind
define dso_local float @__powisf2(float %a, i32 %b) #0 !dbg !3512 {
entry:
  %a.addr = alloca float, align 4
  %b.addr = alloca i32, align 4
  %recip = alloca i32, align 4
  %r = alloca float, align 4
  store float %a, float* %a.addr, align 4
  store i32 %b, i32* %b.addr, align 4
  %0 = load i32, i32* %b.addr, align 4, !dbg !3513
  %cmp = icmp slt i32 %0, 0, !dbg !3514
  %conv = zext i1 %cmp to i32, !dbg !3514
  store i32 %conv, i32* %recip, align 4, !dbg !3515
  store float 1.000000e+00, float* %r, align 4, !dbg !3516
  br label %while.body, !dbg !3517

while.body:                                       ; preds = %if.end4, %entry
  %1 = load i32, i32* %b.addr, align 4, !dbg !3518
  %and = and i32 %1, 1, !dbg !3519
  %tobool = icmp ne i32 %and, 0, !dbg !3519
  br i1 %tobool, label %if.then, label %if.end, !dbg !3518

if.then:                                          ; preds = %while.body
  %2 = load float, float* %a.addr, align 4, !dbg !3520
  %3 = load float, float* %r, align 4, !dbg !3521
  %mul = fmul float %3, %2, !dbg !3521
  store float %mul, float* %r, align 4, !dbg !3521
  br label %if.end, !dbg !3522

if.end:                                           ; preds = %if.then, %while.body
  %4 = load i32, i32* %b.addr, align 4, !dbg !3523
  %div = sdiv i32 %4, 2, !dbg !3523
  store i32 %div, i32* %b.addr, align 4, !dbg !3523
  %5 = load i32, i32* %b.addr, align 4, !dbg !3524
  %cmp1 = icmp eq i32 %5, 0, !dbg !3525
  br i1 %cmp1, label %if.then3, label %if.end4, !dbg !3524

if.then3:                                         ; preds = %if.end
  br label %while.end, !dbg !3526

if.end4:                                          ; preds = %if.end
  %6 = load float, float* %a.addr, align 4, !dbg !3527
  %7 = load float, float* %a.addr, align 4, !dbg !3528
  %mul5 = fmul float %7, %6, !dbg !3528
  store float %mul5, float* %a.addr, align 4, !dbg !3528
  br label %while.body, !dbg !3517, !llvm.loop !3529

while.end:                                        ; preds = %if.then3
  %8 = load i32, i32* %recip, align 4, !dbg !3531
  %tobool6 = icmp ne i32 %8, 0, !dbg !3531
  br i1 %tobool6, label %cond.true, label %cond.false, !dbg !3531

cond.true:                                        ; preds = %while.end
  %9 = load float, float* %r, align 4, !dbg !3532
  %div7 = fdiv float 1.000000e+00, %9, !dbg !3533
  br label %cond.end, !dbg !3531

cond.false:                                       ; preds = %while.end
  %10 = load float, float* %r, align 4, !dbg !3534
  br label %cond.end, !dbg !3531

cond.end:                                         ; preds = %cond.false, %cond.true
  %cond = phi float [ %div7, %cond.true ], [ %10, %cond.false ], !dbg !3531
  ret float %cond, !dbg !3535
}

; Function Attrs: noinline nounwind
define dso_local fp128 @__powixf2(fp128 %a, i32 %b) #0 !dbg !3536 {
entry:
  %a.addr = alloca fp128, align 16
  %b.addr = alloca i32, align 4
  %recip = alloca i32, align 4
  %r = alloca fp128, align 16
  store fp128 %a, fp128* %a.addr, align 16
  store i32 %b, i32* %b.addr, align 4
  %0 = load i32, i32* %b.addr, align 4, !dbg !3537
  %cmp = icmp slt i32 %0, 0, !dbg !3538
  %conv = zext i1 %cmp to i32, !dbg !3538
  store i32 %conv, i32* %recip, align 4, !dbg !3539
  store fp128 0xL00000000000000003FFF000000000000, fp128* %r, align 16, !dbg !3540
  br label %while.body, !dbg !3541

while.body:                                       ; preds = %if.end4, %entry
  %1 = load i32, i32* %b.addr, align 4, !dbg !3542
  %and = and i32 %1, 1, !dbg !3543
  %tobool = icmp ne i32 %and, 0, !dbg !3543
  br i1 %tobool, label %if.then, label %if.end, !dbg !3542

if.then:                                          ; preds = %while.body
  %2 = load fp128, fp128* %a.addr, align 16, !dbg !3544
  %3 = load fp128, fp128* %r, align 16, !dbg !3545
  %mul = fmul fp128 %3, %2, !dbg !3545
  store fp128 %mul, fp128* %r, align 16, !dbg !3545
  br label %if.end, !dbg !3546

if.end:                                           ; preds = %if.then, %while.body
  %4 = load i32, i32* %b.addr, align 4, !dbg !3547
  %div = sdiv i32 %4, 2, !dbg !3547
  store i32 %div, i32* %b.addr, align 4, !dbg !3547
  %5 = load i32, i32* %b.addr, align 4, !dbg !3548
  %cmp1 = icmp eq i32 %5, 0, !dbg !3549
  br i1 %cmp1, label %if.then3, label %if.end4, !dbg !3548

if.then3:                                         ; preds = %if.end
  br label %while.end, !dbg !3550

if.end4:                                          ; preds = %if.end
  %6 = load fp128, fp128* %a.addr, align 16, !dbg !3551
  %7 = load fp128, fp128* %a.addr, align 16, !dbg !3552
  %mul5 = fmul fp128 %7, %6, !dbg !3552
  store fp128 %mul5, fp128* %a.addr, align 16, !dbg !3552
  br label %while.body, !dbg !3541, !llvm.loop !3553

while.end:                                        ; preds = %if.then3
  %8 = load i32, i32* %recip, align 4, !dbg !3555
  %tobool6 = icmp ne i32 %8, 0, !dbg !3555
  br i1 %tobool6, label %cond.true, label %cond.false, !dbg !3555

cond.true:                                        ; preds = %while.end
  %9 = load fp128, fp128* %r, align 16, !dbg !3556
  %div7 = fdiv fp128 0xL00000000000000003FFF000000000000, %9, !dbg !3557
  br label %cond.end, !dbg !3555

cond.false:                                       ; preds = %while.end
  %10 = load fp128, fp128* %r, align 16, !dbg !3558
  br label %cond.end, !dbg !3555

cond.end:                                         ; preds = %cond.false, %cond.true
  %cond = phi fp128 [ %div7, %cond.true ], [ %10, %cond.false ], !dbg !3555
  ret fp128 %cond, !dbg !3559
}

; Function Attrs: noinline nounwind
define dso_local double @__subdf3(double %a, double %b) #0 !dbg !3560 {
entry:
  %a.addr = alloca double, align 8
  %b.addr = alloca double, align 8
  store double %a, double* %a.addr, align 8
  store double %b, double* %b.addr, align 8
  %0 = load double, double* %a.addr, align 8, !dbg !3561
  %1 = load double, double* %b.addr, align 8, !dbg !3562
  %call = call i64 @toRep.51(double %1) #4, !dbg !3563
  %xor = xor i64 %call, -9223372036854775808, !dbg !3564
  %call1 = call double @fromRep.52(i64 %xor) #4, !dbg !3565
  %call2 = call double @__adddf3(double %0, double %call1) #4, !dbg !3566
  ret double %call2, !dbg !3567
}

; Function Attrs: noinline nounwind
define internal i64 @toRep.51(double %x) #0 !dbg !3568 {
entry:
  %x.addr = alloca double, align 8
  %rep = alloca %union.anon.0, align 8
  store double %x, double* %x.addr, align 8
  %f = bitcast %union.anon.0* %rep to double*, !dbg !3569
  %0 = load double, double* %x.addr, align 8, !dbg !3570
  store double %0, double* %f, align 8, !dbg !3569
  %i = bitcast %union.anon.0* %rep to i64*, !dbg !3571
  %1 = load i64, i64* %i, align 8, !dbg !3571
  ret i64 %1, !dbg !3572
}

; Function Attrs: noinline nounwind
define internal double @fromRep.52(i64 %x) #0 !dbg !3573 {
entry:
  %x.addr = alloca i64, align 8
  %rep = alloca %union.anon.0, align 8
  store i64 %x, i64* %x.addr, align 8
  %i = bitcast %union.anon.0* %rep to i64*, !dbg !3574
  %0 = load i64, i64* %x.addr, align 8, !dbg !3575
  store i64 %0, i64* %i, align 8, !dbg !3574
  %f = bitcast %union.anon.0* %rep to double*, !dbg !3576
  %1 = load double, double* %f, align 8, !dbg !3576
  ret double %1, !dbg !3577
}

; Function Attrs: noinline nounwind
define dso_local float @__subsf3(float %a, float %b) #0 !dbg !3578 {
entry:
  %a.addr = alloca float, align 4
  %b.addr = alloca float, align 4
  store float %a, float* %a.addr, align 4
  store float %b, float* %b.addr, align 4
  %0 = load float, float* %a.addr, align 4, !dbg !3579
  %1 = load float, float* %b.addr, align 4, !dbg !3580
  %call = call i32 @toRep.53(float %1) #4, !dbg !3581
  %xor = xor i32 %call, -2147483648, !dbg !3582
  %call1 = call float @fromRep.54(i32 %xor) #4, !dbg !3583
  %call2 = call float @__addsf3(float %0, float %call1) #4, !dbg !3584
  ret float %call2, !dbg !3585
}

; Function Attrs: noinline nounwind
define internal i32 @toRep.53(float %x) #0 !dbg !3586 {
entry:
  %x.addr = alloca float, align 4
  %rep = alloca %union.anon.0.0, align 4
  store float %x, float* %x.addr, align 4
  %f = bitcast %union.anon.0.0* %rep to float*, !dbg !3587
  %0 = load float, float* %x.addr, align 4, !dbg !3588
  store float %0, float* %f, align 4, !dbg !3587
  %i = bitcast %union.anon.0.0* %rep to i32*, !dbg !3589
  %1 = load i32, i32* %i, align 4, !dbg !3589
  ret i32 %1, !dbg !3590
}

; Function Attrs: noinline nounwind
define internal float @fromRep.54(i32 %x) #0 !dbg !3591 {
entry:
  %x.addr = alloca i32, align 4
  %rep = alloca %union.anon.0.0, align 4
  store i32 %x, i32* %x.addr, align 4
  %i = bitcast %union.anon.0.0* %rep to i32*, !dbg !3592
  %0 = load i32, i32* %x.addr, align 4, !dbg !3593
  store i32 %0, i32* %i, align 4, !dbg !3592
  %f = bitcast %union.anon.0.0* %rep to float*, !dbg !3594
  %1 = load float, float* %f, align 4, !dbg !3594
  ret float %1, !dbg !3595
}

; Function Attrs: noinline nounwind
define dso_local zeroext i16 @__truncdfhf2(double %a) #0 !dbg !3596 {
entry:
  %a.addr = alloca double, align 8
  store double %a, double* %a.addr, align 8
  %0 = load double, double* %a.addr, align 8, !dbg !3597
  %call = call zeroext i16 @__truncXfYf2__(double %0) #4, !dbg !3598
  ret i16 %call, !dbg !3599
}

; Function Attrs: noinline nounwind
define internal zeroext i16 @__truncXfYf2__(double %a) #0 !dbg !3600 {
entry:
  %a.addr = alloca double, align 8
  %srcBits = alloca i32, align 4
  %srcExpBits = alloca i32, align 4
  %srcInfExp = alloca i32, align 4
  %srcExpBias = alloca i32, align 4
  %srcMinNormal = alloca i64, align 8
  %srcSignificandMask = alloca i64, align 8
  %srcInfinity = alloca i64, align 8
  %srcSignMask = alloca i64, align 8
  %srcAbsMask = alloca i64, align 8
  %roundMask = alloca i64, align 8
  %halfway = alloca i64, align 8
  %srcQNaN = alloca i64, align 8
  %srcNaNCode = alloca i64, align 8
  %dstBits = alloca i32, align 4
  %dstExpBits = alloca i32, align 4
  %dstInfExp = alloca i32, align 4
  %dstExpBias = alloca i32, align 4
  %underflowExponent = alloca i32, align 4
  %overflowExponent = alloca i32, align 4
  %underflow = alloca i64, align 8
  %overflow = alloca i64, align 8
  %dstQNaN = alloca i16, align 2
  %dstNaNCode = alloca i16, align 2
  %aRep = alloca i64, align 8
  %aAbs = alloca i64, align 8
  %sign = alloca i64, align 8
  %absResult = alloca i16, align 2
  %roundBits = alloca i64, align 8
  %aExp = alloca i32, align 4
  %shift = alloca i32, align 4
  %significand = alloca i64, align 8
  %sticky = alloca i8, align 1
  %denormalizedSignificand = alloca i64, align 8
  %roundBits53 = alloca i64, align 8
  %result = alloca i16, align 2
  store double %a, double* %a.addr, align 8
  store i32 64, i32* %srcBits, align 4, !dbg !3602
  store i32 11, i32* %srcExpBits, align 4, !dbg !3603
  store i32 2047, i32* %srcInfExp, align 4, !dbg !3604
  store i32 1023, i32* %srcExpBias, align 4, !dbg !3605
  store i64 4503599627370496, i64* %srcMinNormal, align 8, !dbg !3606
  store i64 4503599627370495, i64* %srcSignificandMask, align 8, !dbg !3607
  store i64 9218868437227405312, i64* %srcInfinity, align 8, !dbg !3608
  store i64 -9223372036854775808, i64* %srcSignMask, align 8, !dbg !3609
  store i64 9223372036854775807, i64* %srcAbsMask, align 8, !dbg !3610
  store i64 4398046511103, i64* %roundMask, align 8, !dbg !3611
  store i64 2199023255552, i64* %halfway, align 8, !dbg !3612
  store i64 2251799813685248, i64* %srcQNaN, align 8, !dbg !3613
  store i64 2251799813685247, i64* %srcNaNCode, align 8, !dbg !3614
  store i32 16, i32* %dstBits, align 4, !dbg !3615
  store i32 5, i32* %dstExpBits, align 4, !dbg !3616
  store i32 31, i32* %dstInfExp, align 4, !dbg !3617
  store i32 15, i32* %dstExpBias, align 4, !dbg !3618
  store i32 1009, i32* %underflowExponent, align 4, !dbg !3619
  store i32 1039, i32* %overflowExponent, align 4, !dbg !3620
  store i64 4544132024016830464, i64* %underflow, align 8, !dbg !3621
  store i64 4679240012837945344, i64* %overflow, align 8, !dbg !3622
  store i16 512, i16* %dstQNaN, align 2, !dbg !3623
  store i16 511, i16* %dstNaNCode, align 2, !dbg !3624
  %0 = load double, double* %a.addr, align 8, !dbg !3625
  %call = call i64 @srcToRep.55(double %0) #4, !dbg !3626
  store i64 %call, i64* %aRep, align 8, !dbg !3627
  %1 = load i64, i64* %aRep, align 8, !dbg !3628
  %and = and i64 %1, 9223372036854775807, !dbg !3629
  store i64 %and, i64* %aAbs, align 8, !dbg !3630
  %2 = load i64, i64* %aRep, align 8, !dbg !3631
  %and1 = and i64 %2, -9223372036854775808, !dbg !3632
  store i64 %and1, i64* %sign, align 8, !dbg !3633
  %3 = load i64, i64* %aAbs, align 8, !dbg !3634
  %sub = sub i64 %3, 4544132024016830464, !dbg !3635
  %4 = load i64, i64* %aAbs, align 8, !dbg !3636
  %sub2 = sub i64 %4, 4679240012837945344, !dbg !3637
  %cmp = icmp ult i64 %sub, %sub2, !dbg !3638
  br i1 %cmp, label %if.then, label %if.else18, !dbg !3634

if.then:                                          ; preds = %entry
  %5 = load i64, i64* %aAbs, align 8, !dbg !3639
  %shr = lshr i64 %5, 42, !dbg !3640
  %conv = trunc i64 %shr to i16, !dbg !3639
  store i16 %conv, i16* %absResult, align 2, !dbg !3641
  %6 = load i16, i16* %absResult, align 2, !dbg !3642
  %conv3 = zext i16 %6 to i32, !dbg !3642
  %sub4 = sub nsw i32 %conv3, 1032192, !dbg !3642
  %conv5 = trunc i32 %sub4 to i16, !dbg !3642
  store i16 %conv5, i16* %absResult, align 2, !dbg !3642
  %7 = load i64, i64* %aAbs, align 8, !dbg !3643
  %and6 = and i64 %7, 4398046511103, !dbg !3644
  store i64 %and6, i64* %roundBits, align 8, !dbg !3645
  %8 = load i64, i64* %roundBits, align 8, !dbg !3646
  %cmp7 = icmp ugt i64 %8, 2199023255552, !dbg !3647
  br i1 %cmp7, label %if.then9, label %if.else, !dbg !3646

if.then9:                                         ; preds = %if.then
  %9 = load i16, i16* %absResult, align 2, !dbg !3648
  %inc = add i16 %9, 1, !dbg !3648
  store i16 %inc, i16* %absResult, align 2, !dbg !3648
  br label %if.end17, !dbg !3649

if.else:                                          ; preds = %if.then
  %10 = load i64, i64* %roundBits, align 8, !dbg !3650
  %cmp10 = icmp eq i64 %10, 2199023255552, !dbg !3651
  br i1 %cmp10, label %if.then12, label %if.end, !dbg !3650

if.then12:                                        ; preds = %if.else
  %11 = load i16, i16* %absResult, align 2, !dbg !3652
  %conv13 = zext i16 %11 to i32, !dbg !3652
  %and14 = and i32 %conv13, 1, !dbg !3653
  %12 = load i16, i16* %absResult, align 2, !dbg !3654
  %conv15 = zext i16 %12 to i32, !dbg !3654
  %add = add nsw i32 %conv15, %and14, !dbg !3654
  %conv16 = trunc i32 %add to i16, !dbg !3654
  store i16 %conv16, i16* %absResult, align 2, !dbg !3654
  br label %if.end, !dbg !3655

if.end:                                           ; preds = %if.then12, %if.else
  br label %if.end17

if.end17:                                         ; preds = %if.end, %if.then9
  br label %if.end73, !dbg !3656

if.else18:                                        ; preds = %entry
  %13 = load i64, i64* %aAbs, align 8, !dbg !3657
  %cmp19 = icmp ugt i64 %13, 9218868437227405312, !dbg !3658
  br i1 %cmp19, label %if.then21, label %if.else30, !dbg !3657

if.then21:                                        ; preds = %if.else18
  store i16 31744, i16* %absResult, align 2, !dbg !3659
  %14 = load i16, i16* %absResult, align 2, !dbg !3660
  %conv22 = zext i16 %14 to i32, !dbg !3660
  %or = or i32 %conv22, 512, !dbg !3660
  %conv23 = trunc i32 %or to i16, !dbg !3660
  store i16 %conv23, i16* %absResult, align 2, !dbg !3660
  %15 = load i64, i64* %aAbs, align 8, !dbg !3661
  %and24 = and i64 %15, 2251799813685247, !dbg !3662
  %shr25 = lshr i64 %and24, 42, !dbg !3663
  %and26 = and i64 %shr25, 511, !dbg !3664
  %16 = load i16, i16* %absResult, align 2, !dbg !3665
  %conv27 = zext i16 %16 to i64, !dbg !3665
  %or28 = or i64 %conv27, %and26, !dbg !3665
  %conv29 = trunc i64 %or28 to i16, !dbg !3665
  store i16 %conv29, i16* %absResult, align 2, !dbg !3665
  br label %if.end72, !dbg !3666

if.else30:                                        ; preds = %if.else18
  %17 = load i64, i64* %aAbs, align 8, !dbg !3667
  %cmp31 = icmp uge i64 %17, 4679240012837945344, !dbg !3668
  br i1 %cmp31, label %if.then33, label %if.else34, !dbg !3667

if.then33:                                        ; preds = %if.else30
  store i16 31744, i16* %absResult, align 2, !dbg !3669
  br label %if.end71, !dbg !3670

if.else34:                                        ; preds = %if.else30
  %18 = load i64, i64* %aAbs, align 8, !dbg !3671
  %shr35 = lshr i64 %18, 52, !dbg !3672
  %conv36 = trunc i64 %shr35 to i32, !dbg !3671
  store i32 %conv36, i32* %aExp, align 4, !dbg !3673
  %19 = load i32, i32* %aExp, align 4, !dbg !3674
  %sub37 = sub nsw i32 1008, %19, !dbg !3675
  %add38 = add nsw i32 %sub37, 1, !dbg !3676
  store i32 %add38, i32* %shift, align 4, !dbg !3677
  %20 = load i64, i64* %aRep, align 8, !dbg !3678
  %and39 = and i64 %20, 4503599627370495, !dbg !3679
  %or40 = or i64 %and39, 4503599627370496, !dbg !3680
  store i64 %or40, i64* %significand, align 8, !dbg !3681
  %21 = load i32, i32* %shift, align 4, !dbg !3682
  %cmp41 = icmp sgt i32 %21, 52, !dbg !3683
  br i1 %cmp41, label %if.then43, label %if.else44, !dbg !3682

if.then43:                                        ; preds = %if.else34
  store i16 0, i16* %absResult, align 2, !dbg !3684
  br label %if.end70, !dbg !3685

if.else44:                                        ; preds = %if.else34
  %22 = load i64, i64* %significand, align 8, !dbg !3686
  %23 = load i32, i32* %shift, align 4, !dbg !3687
  %sub45 = sub nsw i32 64, %23, !dbg !3688
  %sh_prom = zext i32 %sub45 to i64, !dbg !3689
  %shl = shl i64 %22, %sh_prom, !dbg !3689
  %tobool = icmp ne i64 %shl, 0, !dbg !3686
  %frombool = zext i1 %tobool to i8, !dbg !3690
  store i8 %frombool, i8* %sticky, align 1, !dbg !3690
  %24 = load i64, i64* %significand, align 8, !dbg !3691
  %25 = load i32, i32* %shift, align 4, !dbg !3692
  %sh_prom46 = zext i32 %25 to i64, !dbg !3693
  %shr47 = lshr i64 %24, %sh_prom46, !dbg !3693
  %26 = load i8, i8* %sticky, align 1, !dbg !3694
  %tobool48 = trunc i8 %26 to i1, !dbg !3694
  %conv49 = zext i1 %tobool48 to i64, !dbg !3694
  %or50 = or i64 %shr47, %conv49, !dbg !3695
  store i64 %or50, i64* %denormalizedSignificand, align 8, !dbg !3696
  %27 = load i64, i64* %denormalizedSignificand, align 8, !dbg !3697
  %shr51 = lshr i64 %27, 42, !dbg !3698
  %conv52 = trunc i64 %shr51 to i16, !dbg !3697
  store i16 %conv52, i16* %absResult, align 2, !dbg !3699
  %28 = load i64, i64* %denormalizedSignificand, align 8, !dbg !3700
  %and54 = and i64 %28, 4398046511103, !dbg !3701
  store i64 %and54, i64* %roundBits53, align 8, !dbg !3702
  %29 = load i64, i64* %roundBits53, align 8, !dbg !3703
  %cmp55 = icmp ugt i64 %29, 2199023255552, !dbg !3704
  br i1 %cmp55, label %if.then57, label %if.else59, !dbg !3703

if.then57:                                        ; preds = %if.else44
  %30 = load i16, i16* %absResult, align 2, !dbg !3705
  %inc58 = add i16 %30, 1, !dbg !3705
  store i16 %inc58, i16* %absResult, align 2, !dbg !3705
  br label %if.end69, !dbg !3706

if.else59:                                        ; preds = %if.else44
  %31 = load i64, i64* %roundBits53, align 8, !dbg !3707
  %cmp60 = icmp eq i64 %31, 2199023255552, !dbg !3708
  br i1 %cmp60, label %if.then62, label %if.end68, !dbg !3707

if.then62:                                        ; preds = %if.else59
  %32 = load i16, i16* %absResult, align 2, !dbg !3709
  %conv63 = zext i16 %32 to i32, !dbg !3709
  %and64 = and i32 %conv63, 1, !dbg !3710
  %33 = load i16, i16* %absResult, align 2, !dbg !3711
  %conv65 = zext i16 %33 to i32, !dbg !3711
  %add66 = add nsw i32 %conv65, %and64, !dbg !3711
  %conv67 = trunc i32 %add66 to i16, !dbg !3711
  store i16 %conv67, i16* %absResult, align 2, !dbg !3711
  br label %if.end68, !dbg !3712

if.end68:                                         ; preds = %if.then62, %if.else59
  br label %if.end69

if.end69:                                         ; preds = %if.end68, %if.then57
  br label %if.end70

if.end70:                                         ; preds = %if.end69, %if.then43
  br label %if.end71

if.end71:                                         ; preds = %if.end70, %if.then33
  br label %if.end72

if.end72:                                         ; preds = %if.end71, %if.then21
  br label %if.end73

if.end73:                                         ; preds = %if.end72, %if.end17
  %34 = load i16, i16* %absResult, align 2, !dbg !3713
  %conv74 = zext i16 %34 to i64, !dbg !3713
  %35 = load i64, i64* %sign, align 8, !dbg !3714
  %shr75 = lshr i64 %35, 48, !dbg !3715
  %or76 = or i64 %conv74, %shr75, !dbg !3716
  %conv77 = trunc i64 %or76 to i16, !dbg !3713
  store i16 %conv77, i16* %result, align 2, !dbg !3717
  %36 = load i16, i16* %result, align 2, !dbg !3718
  %call78 = call zeroext i16 @dstFromRep.56(i16 zeroext %36) #4, !dbg !3719
  ret i16 %call78, !dbg !3720
}

; Function Attrs: noinline nounwind
define internal i64 @srcToRep.55(double %x) #0 !dbg !3721 {
entry:
  %x.addr = alloca double, align 8
  %rep = alloca %union.anon.0, align 8
  store double %x, double* %x.addr, align 8
  %f = bitcast %union.anon.0* %rep to double*, !dbg !3723
  %0 = load double, double* %x.addr, align 8, !dbg !3724
  store double %0, double* %f, align 8, !dbg !3723
  %i = bitcast %union.anon.0* %rep to i64*, !dbg !3725
  %1 = load i64, i64* %i, align 8, !dbg !3725
  ret i64 %1, !dbg !3726
}

; Function Attrs: noinline nounwind
define internal zeroext i16 @dstFromRep.56(i16 zeroext %x) #0 !dbg !3727 {
entry:
  %x.addr = alloca i16, align 2
  %rep = alloca %union.anon, align 2
  store i16 %x, i16* %x.addr, align 2
  %i = bitcast %union.anon* %rep to i16*, !dbg !3728
  %0 = load i16, i16* %x.addr, align 2, !dbg !3729
  store i16 %0, i16* %i, align 2, !dbg !3728
  %f = bitcast %union.anon* %rep to i16*, !dbg !3730
  %1 = load i16, i16* %f, align 2, !dbg !3730
  ret i16 %1, !dbg !3731
}

; Function Attrs: noinline nounwind
define dso_local float @__truncdfsf2(double %a) #0 !dbg !3732 {
entry:
  %a.addr = alloca double, align 8
  store double %a, double* %a.addr, align 8
  %0 = load double, double* %a.addr, align 8, !dbg !3733
  %call = call float @__truncXfYf2__.57(double %0) #4, !dbg !3734
  ret float %call, !dbg !3735
}

; Function Attrs: noinline nounwind
define internal float @__truncXfYf2__.57(double %a) #0 !dbg !3736 {
entry:
  %a.addr = alloca double, align 8
  %srcBits = alloca i32, align 4
  %srcExpBits = alloca i32, align 4
  %srcInfExp = alloca i32, align 4
  %srcExpBias = alloca i32, align 4
  %srcMinNormal = alloca i64, align 8
  %srcSignificandMask = alloca i64, align 8
  %srcInfinity = alloca i64, align 8
  %srcSignMask = alloca i64, align 8
  %srcAbsMask = alloca i64, align 8
  %roundMask = alloca i64, align 8
  %halfway = alloca i64, align 8
  %srcQNaN = alloca i64, align 8
  %srcNaNCode = alloca i64, align 8
  %dstBits = alloca i32, align 4
  %dstExpBits = alloca i32, align 4
  %dstInfExp = alloca i32, align 4
  %dstExpBias = alloca i32, align 4
  %underflowExponent = alloca i32, align 4
  %overflowExponent = alloca i32, align 4
  %underflow = alloca i64, align 8
  %overflow = alloca i64, align 8
  %dstQNaN = alloca i32, align 4
  %dstNaNCode = alloca i32, align 4
  %aRep = alloca i64, align 8
  %aAbs = alloca i64, align 8
  %sign = alloca i64, align 8
  %absResult = alloca i32, align 4
  %roundBits = alloca i64, align 8
  %aExp = alloca i32, align 4
  %shift = alloca i32, align 4
  %significand = alloca i64, align 8
  %sticky = alloca i8, align 1
  %denormalizedSignificand = alloca i64, align 8
  %roundBits46 = alloca i64, align 8
  %result = alloca i32, align 4
  store double %a, double* %a.addr, align 8
  store i32 64, i32* %srcBits, align 4, !dbg !3737
  store i32 11, i32* %srcExpBits, align 4, !dbg !3738
  store i32 2047, i32* %srcInfExp, align 4, !dbg !3739
  store i32 1023, i32* %srcExpBias, align 4, !dbg !3740
  store i64 4503599627370496, i64* %srcMinNormal, align 8, !dbg !3741
  store i64 4503599627370495, i64* %srcSignificandMask, align 8, !dbg !3742
  store i64 9218868437227405312, i64* %srcInfinity, align 8, !dbg !3743
  store i64 -9223372036854775808, i64* %srcSignMask, align 8, !dbg !3744
  store i64 9223372036854775807, i64* %srcAbsMask, align 8, !dbg !3745
  store i64 536870911, i64* %roundMask, align 8, !dbg !3746
  store i64 268435456, i64* %halfway, align 8, !dbg !3747
  store i64 2251799813685248, i64* %srcQNaN, align 8, !dbg !3748
  store i64 2251799813685247, i64* %srcNaNCode, align 8, !dbg !3749
  store i32 32, i32* %dstBits, align 4, !dbg !3750
  store i32 8, i32* %dstExpBits, align 4, !dbg !3751
  store i32 255, i32* %dstInfExp, align 4, !dbg !3752
  store i32 127, i32* %dstExpBias, align 4, !dbg !3753
  store i32 897, i32* %underflowExponent, align 4, !dbg !3754
  store i32 1151, i32* %overflowExponent, align 4, !dbg !3755
  store i64 4039728865751334912, i64* %underflow, align 8, !dbg !3756
  store i64 5183643171103440896, i64* %overflow, align 8, !dbg !3757
  store i32 4194304, i32* %dstQNaN, align 4, !dbg !3758
  store i32 4194303, i32* %dstNaNCode, align 4, !dbg !3759
  %0 = load double, double* %a.addr, align 8, !dbg !3760
  %call = call i64 @srcToRep.58(double %0) #4, !dbg !3761
  store i64 %call, i64* %aRep, align 8, !dbg !3762
  %1 = load i64, i64* %aRep, align 8, !dbg !3763
  %and = and i64 %1, 9223372036854775807, !dbg !3764
  store i64 %and, i64* %aAbs, align 8, !dbg !3765
  %2 = load i64, i64* %aRep, align 8, !dbg !3766
  %and1 = and i64 %2, -9223372036854775808, !dbg !3767
  store i64 %and1, i64* %sign, align 8, !dbg !3768
  %3 = load i64, i64* %aAbs, align 8, !dbg !3769
  %sub = sub i64 %3, 4039728865751334912, !dbg !3770
  %4 = load i64, i64* %aAbs, align 8, !dbg !3771
  %sub2 = sub i64 %4, 5183643171103440896, !dbg !3772
  %cmp = icmp ult i64 %sub, %sub2, !dbg !3773
  br i1 %cmp, label %if.then, label %if.else13, !dbg !3769

if.then:                                          ; preds = %entry
  %5 = load i64, i64* %aAbs, align 8, !dbg !3774
  %shr = lshr i64 %5, 29, !dbg !3775
  %conv = trunc i64 %shr to i32, !dbg !3774
  store i32 %conv, i32* %absResult, align 4, !dbg !3776
  %6 = load i32, i32* %absResult, align 4, !dbg !3777
  %sub3 = sub i32 %6, -1073741824, !dbg !3777
  store i32 %sub3, i32* %absResult, align 4, !dbg !3777
  %7 = load i64, i64* %aAbs, align 8, !dbg !3778
  %and4 = and i64 %7, 536870911, !dbg !3779
  store i64 %and4, i64* %roundBits, align 8, !dbg !3780
  %8 = load i64, i64* %roundBits, align 8, !dbg !3781
  %cmp5 = icmp ugt i64 %8, 268435456, !dbg !3782
  br i1 %cmp5, label %if.then7, label %if.else, !dbg !3781

if.then7:                                         ; preds = %if.then
  %9 = load i32, i32* %absResult, align 4, !dbg !3783
  %inc = add i32 %9, 1, !dbg !3783
  store i32 %inc, i32* %absResult, align 4, !dbg !3783
  br label %if.end12, !dbg !3784

if.else:                                          ; preds = %if.then
  %10 = load i64, i64* %roundBits, align 8, !dbg !3785
  %cmp8 = icmp eq i64 %10, 268435456, !dbg !3786
  br i1 %cmp8, label %if.then10, label %if.end, !dbg !3785

if.then10:                                        ; preds = %if.else
  %11 = load i32, i32* %absResult, align 4, !dbg !3787
  %and11 = and i32 %11, 1, !dbg !3788
  %12 = load i32, i32* %absResult, align 4, !dbg !3789
  %add = add i32 %12, %and11, !dbg !3789
  store i32 %add, i32* %absResult, align 4, !dbg !3789
  br label %if.end, !dbg !3790

if.end:                                           ; preds = %if.then10, %if.else
  br label %if.end12

if.end12:                                         ; preds = %if.end, %if.then7
  br label %if.end63, !dbg !3791

if.else13:                                        ; preds = %entry
  %13 = load i64, i64* %aAbs, align 8, !dbg !3792
  %cmp14 = icmp ugt i64 %13, 9218868437227405312, !dbg !3793
  br i1 %cmp14, label %if.then16, label %if.else23, !dbg !3792

if.then16:                                        ; preds = %if.else13
  store i32 2139095040, i32* %absResult, align 4, !dbg !3794
  %14 = load i32, i32* %absResult, align 4, !dbg !3795
  %or = or i32 %14, 4194304, !dbg !3795
  store i32 %or, i32* %absResult, align 4, !dbg !3795
  %15 = load i64, i64* %aAbs, align 8, !dbg !3796
  %and17 = and i64 %15, 2251799813685247, !dbg !3797
  %shr18 = lshr i64 %and17, 29, !dbg !3798
  %and19 = and i64 %shr18, 4194303, !dbg !3799
  %16 = load i32, i32* %absResult, align 4, !dbg !3800
  %conv20 = zext i32 %16 to i64, !dbg !3800
  %or21 = or i64 %conv20, %and19, !dbg !3800
  %conv22 = trunc i64 %or21 to i32, !dbg !3800
  store i32 %conv22, i32* %absResult, align 4, !dbg !3800
  br label %if.end62, !dbg !3801

if.else23:                                        ; preds = %if.else13
  %17 = load i64, i64* %aAbs, align 8, !dbg !3802
  %cmp24 = icmp uge i64 %17, 5183643171103440896, !dbg !3803
  br i1 %cmp24, label %if.then26, label %if.else27, !dbg !3802

if.then26:                                        ; preds = %if.else23
  store i32 2139095040, i32* %absResult, align 4, !dbg !3804
  br label %if.end61, !dbg !3805

if.else27:                                        ; preds = %if.else23
  %18 = load i64, i64* %aAbs, align 8, !dbg !3806
  %shr28 = lshr i64 %18, 52, !dbg !3807
  %conv29 = trunc i64 %shr28 to i32, !dbg !3806
  store i32 %conv29, i32* %aExp, align 4, !dbg !3808
  %19 = load i32, i32* %aExp, align 4, !dbg !3809
  %sub30 = sub nsw i32 896, %19, !dbg !3810
  %add31 = add nsw i32 %sub30, 1, !dbg !3811
  store i32 %add31, i32* %shift, align 4, !dbg !3812
  %20 = load i64, i64* %aRep, align 8, !dbg !3813
  %and32 = and i64 %20, 4503599627370495, !dbg !3814
  %or33 = or i64 %and32, 4503599627370496, !dbg !3815
  store i64 %or33, i64* %significand, align 8, !dbg !3816
  %21 = load i32, i32* %shift, align 4, !dbg !3817
  %cmp34 = icmp sgt i32 %21, 52, !dbg !3818
  br i1 %cmp34, label %if.then36, label %if.else37, !dbg !3817

if.then36:                                        ; preds = %if.else27
  store i32 0, i32* %absResult, align 4, !dbg !3819
  br label %if.end60, !dbg !3820

if.else37:                                        ; preds = %if.else27
  %22 = load i64, i64* %significand, align 8, !dbg !3821
  %23 = load i32, i32* %shift, align 4, !dbg !3822
  %sub38 = sub nsw i32 64, %23, !dbg !3823
  %sh_prom = zext i32 %sub38 to i64, !dbg !3824
  %shl = shl i64 %22, %sh_prom, !dbg !3824
  %tobool = icmp ne i64 %shl, 0, !dbg !3821
  %frombool = zext i1 %tobool to i8, !dbg !3825
  store i8 %frombool, i8* %sticky, align 1, !dbg !3825
  %24 = load i64, i64* %significand, align 8, !dbg !3826
  %25 = load i32, i32* %shift, align 4, !dbg !3827
  %sh_prom39 = zext i32 %25 to i64, !dbg !3828
  %shr40 = lshr i64 %24, %sh_prom39, !dbg !3828
  %26 = load i8, i8* %sticky, align 1, !dbg !3829
  %tobool41 = trunc i8 %26 to i1, !dbg !3829
  %conv42 = zext i1 %tobool41 to i64, !dbg !3829
  %or43 = or i64 %shr40, %conv42, !dbg !3830
  store i64 %or43, i64* %denormalizedSignificand, align 8, !dbg !3831
  %27 = load i64, i64* %denormalizedSignificand, align 8, !dbg !3832
  %shr44 = lshr i64 %27, 29, !dbg !3833
  %conv45 = trunc i64 %shr44 to i32, !dbg !3832
  store i32 %conv45, i32* %absResult, align 4, !dbg !3834
  %28 = load i64, i64* %denormalizedSignificand, align 8, !dbg !3835
  %and47 = and i64 %28, 536870911, !dbg !3836
  store i64 %and47, i64* %roundBits46, align 8, !dbg !3837
  %29 = load i64, i64* %roundBits46, align 8, !dbg !3838
  %cmp48 = icmp ugt i64 %29, 268435456, !dbg !3839
  br i1 %cmp48, label %if.then50, label %if.else52, !dbg !3838

if.then50:                                        ; preds = %if.else37
  %30 = load i32, i32* %absResult, align 4, !dbg !3840
  %inc51 = add i32 %30, 1, !dbg !3840
  store i32 %inc51, i32* %absResult, align 4, !dbg !3840
  br label %if.end59, !dbg !3841

if.else52:                                        ; preds = %if.else37
  %31 = load i64, i64* %roundBits46, align 8, !dbg !3842
  %cmp53 = icmp eq i64 %31, 268435456, !dbg !3843
  br i1 %cmp53, label %if.then55, label %if.end58, !dbg !3842

if.then55:                                        ; preds = %if.else52
  %32 = load i32, i32* %absResult, align 4, !dbg !3844
  %and56 = and i32 %32, 1, !dbg !3845
  %33 = load i32, i32* %absResult, align 4, !dbg !3846
  %add57 = add i32 %33, %and56, !dbg !3846
  store i32 %add57, i32* %absResult, align 4, !dbg !3846
  br label %if.end58, !dbg !3847

if.end58:                                         ; preds = %if.then55, %if.else52
  br label %if.end59

if.end59:                                         ; preds = %if.end58, %if.then50
  br label %if.end60

if.end60:                                         ; preds = %if.end59, %if.then36
  br label %if.end61

if.end61:                                         ; preds = %if.end60, %if.then26
  br label %if.end62

if.end62:                                         ; preds = %if.end61, %if.then16
  br label %if.end63

if.end63:                                         ; preds = %if.end62, %if.end12
  %34 = load i32, i32* %absResult, align 4, !dbg !3848
  %conv64 = zext i32 %34 to i64, !dbg !3848
  %35 = load i64, i64* %sign, align 8, !dbg !3849
  %shr65 = lshr i64 %35, 32, !dbg !3850
  %or66 = or i64 %conv64, %shr65, !dbg !3851
  %conv67 = trunc i64 %or66 to i32, !dbg !3848
  store i32 %conv67, i32* %result, align 4, !dbg !3852
  %36 = load i32, i32* %result, align 4, !dbg !3853
  %call68 = call float @dstFromRep.59(i32 %36) #4, !dbg !3854
  ret float %call68, !dbg !3855
}

; Function Attrs: noinline nounwind
define internal i64 @srcToRep.58(double %x) #0 !dbg !3856 {
entry:
  %x.addr = alloca double, align 8
  %rep = alloca %union.anon.0, align 8
  store double %x, double* %x.addr, align 8
  %f = bitcast %union.anon.0* %rep to double*, !dbg !3857
  %0 = load double, double* %x.addr, align 8, !dbg !3858
  store double %0, double* %f, align 8, !dbg !3857
  %i = bitcast %union.anon.0* %rep to i64*, !dbg !3859
  %1 = load i64, i64* %i, align 8, !dbg !3859
  ret i64 %1, !dbg !3860
}

; Function Attrs: noinline nounwind
define internal float @dstFromRep.59(i32 %x) #0 !dbg !3861 {
entry:
  %x.addr = alloca i32, align 4
  %rep = alloca %union.anon.0.0, align 4
  store i32 %x, i32* %x.addr, align 4
  %i = bitcast %union.anon.0.0* %rep to i32*, !dbg !3862
  %0 = load i32, i32* %x.addr, align 4, !dbg !3863
  store i32 %0, i32* %i, align 4, !dbg !3862
  %f = bitcast %union.anon.0.0* %rep to float*, !dbg !3864
  %1 = load float, float* %f, align 4, !dbg !3864
  ret float %1, !dbg !3865
}

; Function Attrs: noinline nounwind
define dso_local zeroext i16 @__truncsfhf2(float %a) #0 !dbg !3866 {
entry:
  %a.addr = alloca float, align 4
  store float %a, float* %a.addr, align 4
  %0 = load float, float* %a.addr, align 4, !dbg !3867
  %call = call zeroext i16 @__truncXfYf2__.60(float %0) #4, !dbg !3868
  ret i16 %call, !dbg !3869
}

; Function Attrs: noinline nounwind
define internal zeroext i16 @__truncXfYf2__.60(float %a) #0 !dbg !3870 {
entry:
  %a.addr = alloca float, align 4
  %srcBits = alloca i32, align 4
  %srcExpBits = alloca i32, align 4
  %srcInfExp = alloca i32, align 4
  %srcExpBias = alloca i32, align 4
  %srcMinNormal = alloca i32, align 4
  %srcSignificandMask = alloca i32, align 4
  %srcInfinity = alloca i32, align 4
  %srcSignMask = alloca i32, align 4
  %srcAbsMask = alloca i32, align 4
  %roundMask = alloca i32, align 4
  %halfway = alloca i32, align 4
  %srcQNaN = alloca i32, align 4
  %srcNaNCode = alloca i32, align 4
  %dstBits = alloca i32, align 4
  %dstExpBits = alloca i32, align 4
  %dstInfExp = alloca i32, align 4
  %dstExpBias = alloca i32, align 4
  %underflowExponent = alloca i32, align 4
  %overflowExponent = alloca i32, align 4
  %underflow = alloca i32, align 4
  %overflow = alloca i32, align 4
  %dstQNaN = alloca i16, align 2
  %dstNaNCode = alloca i16, align 2
  %aRep = alloca i32, align 4
  %aAbs = alloca i32, align 4
  %sign = alloca i32, align 4
  %absResult = alloca i16, align 2
  %roundBits = alloca i32, align 4
  %aExp = alloca i32, align 4
  %shift = alloca i32, align 4
  %significand = alloca i32, align 4
  %sticky = alloca i8, align 1
  %denormalizedSignificand = alloca i32, align 4
  %roundBits51 = alloca i32, align 4
  %result = alloca i16, align 2
  store float %a, float* %a.addr, align 4
  store i32 32, i32* %srcBits, align 4, !dbg !3871
  store i32 8, i32* %srcExpBits, align 4, !dbg !3872
  store i32 255, i32* %srcInfExp, align 4, !dbg !3873
  store i32 127, i32* %srcExpBias, align 4, !dbg !3874
  store i32 8388608, i32* %srcMinNormal, align 4, !dbg !3875
  store i32 8388607, i32* %srcSignificandMask, align 4, !dbg !3876
  store i32 2139095040, i32* %srcInfinity, align 4, !dbg !3877
  store i32 -2147483648, i32* %srcSignMask, align 4, !dbg !3878
  store i32 2147483647, i32* %srcAbsMask, align 4, !dbg !3879
  store i32 8191, i32* %roundMask, align 4, !dbg !3880
  store i32 4096, i32* %halfway, align 4, !dbg !3881
  store i32 4194304, i32* %srcQNaN, align 4, !dbg !3882
  store i32 4194303, i32* %srcNaNCode, align 4, !dbg !3883
  store i32 16, i32* %dstBits, align 4, !dbg !3884
  store i32 5, i32* %dstExpBits, align 4, !dbg !3885
  store i32 31, i32* %dstInfExp, align 4, !dbg !3886
  store i32 15, i32* %dstExpBias, align 4, !dbg !3887
  store i32 113, i32* %underflowExponent, align 4, !dbg !3888
  store i32 143, i32* %overflowExponent, align 4, !dbg !3889
  store i32 947912704, i32* %underflow, align 4, !dbg !3890
  store i32 1199570944, i32* %overflow, align 4, !dbg !3891
  store i16 512, i16* %dstQNaN, align 2, !dbg !3892
  store i16 511, i16* %dstNaNCode, align 2, !dbg !3893
  %0 = load float, float* %a.addr, align 4, !dbg !3894
  %call = call i32 @srcToRep.61(float %0) #4, !dbg !3895
  store i32 %call, i32* %aRep, align 4, !dbg !3896
  %1 = load i32, i32* %aRep, align 4, !dbg !3897
  %and = and i32 %1, 2147483647, !dbg !3898
  store i32 %and, i32* %aAbs, align 4, !dbg !3899
  %2 = load i32, i32* %aRep, align 4, !dbg !3900
  %and1 = and i32 %2, -2147483648, !dbg !3901
  store i32 %and1, i32* %sign, align 4, !dbg !3902
  %3 = load i32, i32* %aAbs, align 4, !dbg !3903
  %sub = sub i32 %3, 947912704, !dbg !3904
  %4 = load i32, i32* %aAbs, align 4, !dbg !3905
  %sub2 = sub i32 %4, 1199570944, !dbg !3906
  %cmp = icmp ult i32 %sub, %sub2, !dbg !3907
  br i1 %cmp, label %if.then, label %if.else18, !dbg !3903

if.then:                                          ; preds = %entry
  %5 = load i32, i32* %aAbs, align 4, !dbg !3908
  %shr = lshr i32 %5, 13, !dbg !3909
  %conv = trunc i32 %shr to i16, !dbg !3908
  store i16 %conv, i16* %absResult, align 2, !dbg !3910
  %6 = load i16, i16* %absResult, align 2, !dbg !3911
  %conv3 = zext i16 %6 to i32, !dbg !3911
  %sub4 = sub nsw i32 %conv3, 114688, !dbg !3911
  %conv5 = trunc i32 %sub4 to i16, !dbg !3911
  store i16 %conv5, i16* %absResult, align 2, !dbg !3911
  %7 = load i32, i32* %aAbs, align 4, !dbg !3912
  %and6 = and i32 %7, 8191, !dbg !3913
  store i32 %and6, i32* %roundBits, align 4, !dbg !3914
  %8 = load i32, i32* %roundBits, align 4, !dbg !3915
  %cmp7 = icmp ugt i32 %8, 4096, !dbg !3916
  br i1 %cmp7, label %if.then9, label %if.else, !dbg !3915

if.then9:                                         ; preds = %if.then
  %9 = load i16, i16* %absResult, align 2, !dbg !3917
  %inc = add i16 %9, 1, !dbg !3917
  store i16 %inc, i16* %absResult, align 2, !dbg !3917
  br label %if.end17, !dbg !3918

if.else:                                          ; preds = %if.then
  %10 = load i32, i32* %roundBits, align 4, !dbg !3919
  %cmp10 = icmp eq i32 %10, 4096, !dbg !3920
  br i1 %cmp10, label %if.then12, label %if.end, !dbg !3919

if.then12:                                        ; preds = %if.else
  %11 = load i16, i16* %absResult, align 2, !dbg !3921
  %conv13 = zext i16 %11 to i32, !dbg !3921
  %and14 = and i32 %conv13, 1, !dbg !3922
  %12 = load i16, i16* %absResult, align 2, !dbg !3923
  %conv15 = zext i16 %12 to i32, !dbg !3923
  %add = add nsw i32 %conv15, %and14, !dbg !3923
  %conv16 = trunc i32 %add to i16, !dbg !3923
  store i16 %conv16, i16* %absResult, align 2, !dbg !3923
  br label %if.end, !dbg !3924

if.end:                                           ; preds = %if.then12, %if.else
  br label %if.end17

if.end17:                                         ; preds = %if.end, %if.then9
  br label %if.end71, !dbg !3925

if.else18:                                        ; preds = %entry
  %13 = load i32, i32* %aAbs, align 4, !dbg !3926
  %cmp19 = icmp ugt i32 %13, 2139095040, !dbg !3927
  br i1 %cmp19, label %if.then21, label %if.else30, !dbg !3926

if.then21:                                        ; preds = %if.else18
  store i16 31744, i16* %absResult, align 2, !dbg !3928
  %14 = load i16, i16* %absResult, align 2, !dbg !3929
  %conv22 = zext i16 %14 to i32, !dbg !3929
  %or = or i32 %conv22, 512, !dbg !3929
  %conv23 = trunc i32 %or to i16, !dbg !3929
  store i16 %conv23, i16* %absResult, align 2, !dbg !3929
  %15 = load i32, i32* %aAbs, align 4, !dbg !3930
  %and24 = and i32 %15, 4194303, !dbg !3931
  %shr25 = lshr i32 %and24, 13, !dbg !3932
  %and26 = and i32 %shr25, 511, !dbg !3933
  %16 = load i16, i16* %absResult, align 2, !dbg !3934
  %conv27 = zext i16 %16 to i32, !dbg !3934
  %or28 = or i32 %conv27, %and26, !dbg !3934
  %conv29 = trunc i32 %or28 to i16, !dbg !3934
  store i16 %conv29, i16* %absResult, align 2, !dbg !3934
  br label %if.end70, !dbg !3935

if.else30:                                        ; preds = %if.else18
  %17 = load i32, i32* %aAbs, align 4, !dbg !3936
  %cmp31 = icmp uge i32 %17, 1199570944, !dbg !3937
  br i1 %cmp31, label %if.then33, label %if.else34, !dbg !3936

if.then33:                                        ; preds = %if.else30
  store i16 31744, i16* %absResult, align 2, !dbg !3938
  br label %if.end69, !dbg !3939

if.else34:                                        ; preds = %if.else30
  %18 = load i32, i32* %aAbs, align 4, !dbg !3940
  %shr35 = lshr i32 %18, 23, !dbg !3941
  store i32 %shr35, i32* %aExp, align 4, !dbg !3942
  %19 = load i32, i32* %aExp, align 4, !dbg !3943
  %sub36 = sub nsw i32 112, %19, !dbg !3944
  %add37 = add nsw i32 %sub36, 1, !dbg !3945
  store i32 %add37, i32* %shift, align 4, !dbg !3946
  %20 = load i32, i32* %aRep, align 4, !dbg !3947
  %and38 = and i32 %20, 8388607, !dbg !3948
  %or39 = or i32 %and38, 8388608, !dbg !3949
  store i32 %or39, i32* %significand, align 4, !dbg !3950
  %21 = load i32, i32* %shift, align 4, !dbg !3951
  %cmp40 = icmp sgt i32 %21, 23, !dbg !3952
  br i1 %cmp40, label %if.then42, label %if.else43, !dbg !3951

if.then42:                                        ; preds = %if.else34
  store i16 0, i16* %absResult, align 2, !dbg !3953
  br label %if.end68, !dbg !3954

if.else43:                                        ; preds = %if.else34
  %22 = load i32, i32* %significand, align 4, !dbg !3955
  %23 = load i32, i32* %shift, align 4, !dbg !3956
  %sub44 = sub nsw i32 32, %23, !dbg !3957
  %shl = shl i32 %22, %sub44, !dbg !3958
  %tobool = icmp ne i32 %shl, 0, !dbg !3955
  %frombool = zext i1 %tobool to i8, !dbg !3959
  store i8 %frombool, i8* %sticky, align 1, !dbg !3959
  %24 = load i32, i32* %significand, align 4, !dbg !3960
  %25 = load i32, i32* %shift, align 4, !dbg !3961
  %shr45 = lshr i32 %24, %25, !dbg !3962
  %26 = load i8, i8* %sticky, align 1, !dbg !3963
  %tobool46 = trunc i8 %26 to i1, !dbg !3963
  %conv47 = zext i1 %tobool46 to i32, !dbg !3963
  %or48 = or i32 %shr45, %conv47, !dbg !3964
  store i32 %or48, i32* %denormalizedSignificand, align 4, !dbg !3965
  %27 = load i32, i32* %denormalizedSignificand, align 4, !dbg !3966
  %shr49 = lshr i32 %27, 13, !dbg !3967
  %conv50 = trunc i32 %shr49 to i16, !dbg !3966
  store i16 %conv50, i16* %absResult, align 2, !dbg !3968
  %28 = load i32, i32* %denormalizedSignificand, align 4, !dbg !3969
  %and52 = and i32 %28, 8191, !dbg !3970
  store i32 %and52, i32* %roundBits51, align 4, !dbg !3971
  %29 = load i32, i32* %roundBits51, align 4, !dbg !3972
  %cmp53 = icmp ugt i32 %29, 4096, !dbg !3973
  br i1 %cmp53, label %if.then55, label %if.else57, !dbg !3972

if.then55:                                        ; preds = %if.else43
  %30 = load i16, i16* %absResult, align 2, !dbg !3974
  %inc56 = add i16 %30, 1, !dbg !3974
  store i16 %inc56, i16* %absResult, align 2, !dbg !3974
  br label %if.end67, !dbg !3975

if.else57:                                        ; preds = %if.else43
  %31 = load i32, i32* %roundBits51, align 4, !dbg !3976
  %cmp58 = icmp eq i32 %31, 4096, !dbg !3977
  br i1 %cmp58, label %if.then60, label %if.end66, !dbg !3976

if.then60:                                        ; preds = %if.else57
  %32 = load i16, i16* %absResult, align 2, !dbg !3978
  %conv61 = zext i16 %32 to i32, !dbg !3978
  %and62 = and i32 %conv61, 1, !dbg !3979
  %33 = load i16, i16* %absResult, align 2, !dbg !3980
  %conv63 = zext i16 %33 to i32, !dbg !3980
  %add64 = add nsw i32 %conv63, %and62, !dbg !3980
  %conv65 = trunc i32 %add64 to i16, !dbg !3980
  store i16 %conv65, i16* %absResult, align 2, !dbg !3980
  br label %if.end66, !dbg !3981

if.end66:                                         ; preds = %if.then60, %if.else57
  br label %if.end67

if.end67:                                         ; preds = %if.end66, %if.then55
  br label %if.end68

if.end68:                                         ; preds = %if.end67, %if.then42
  br label %if.end69

if.end69:                                         ; preds = %if.end68, %if.then33
  br label %if.end70

if.end70:                                         ; preds = %if.end69, %if.then21
  br label %if.end71

if.end71:                                         ; preds = %if.end70, %if.end17
  %34 = load i16, i16* %absResult, align 2, !dbg !3982
  %conv72 = zext i16 %34 to i32, !dbg !3982
  %35 = load i32, i32* %sign, align 4, !dbg !3983
  %shr73 = lshr i32 %35, 16, !dbg !3984
  %or74 = or i32 %conv72, %shr73, !dbg !3985
  %conv75 = trunc i32 %or74 to i16, !dbg !3982
  store i16 %conv75, i16* %result, align 2, !dbg !3986
  %36 = load i16, i16* %result, align 2, !dbg !3987
  %call76 = call zeroext i16 @dstFromRep.62(i16 zeroext %36) #4, !dbg !3988
  ret i16 %call76, !dbg !3989
}

; Function Attrs: noinline nounwind
define internal i32 @srcToRep.61(float %x) #0 !dbg !3990 {
entry:
  %x.addr = alloca float, align 4
  %rep = alloca %union.anon.0.0, align 4
  store float %x, float* %x.addr, align 4
  %f = bitcast %union.anon.0.0* %rep to float*, !dbg !3991
  %0 = load float, float* %x.addr, align 4, !dbg !3992
  store float %0, float* %f, align 4, !dbg !3991
  %i = bitcast %union.anon.0.0* %rep to i32*, !dbg !3993
  %1 = load i32, i32* %i, align 4, !dbg !3993
  ret i32 %1, !dbg !3994
}

; Function Attrs: noinline nounwind
define internal zeroext i16 @dstFromRep.62(i16 zeroext %x) #0 !dbg !3995 {
entry:
  %x.addr = alloca i16, align 2
  %rep = alloca %union.anon, align 2
  store i16 %x, i16* %x.addr, align 2
  %i = bitcast %union.anon* %rep to i16*, !dbg !3996
  %0 = load i16, i16* %x.addr, align 2, !dbg !3997
  store i16 %0, i16* %i, align 2, !dbg !3996
  %f = bitcast %union.anon* %rep to i16*, !dbg !3998
  %1 = load i16, i16* %f, align 2, !dbg !3998
  ret i16 %1, !dbg !3999
}

; Function Attrs: noinline nounwind
define dso_local zeroext i16 @__gnu_f2h_ieee(float %a) #0 !dbg !4000 {
entry:
  %a.addr = alloca float, align 4
  store float %a, float* %a.addr, align 4
  %0 = load float, float* %a.addr, align 4, !dbg !4001
  %call = call zeroext i16 @__truncsfhf2(float %0) #4, !dbg !4002
  ret i16 %call, !dbg !4003
}

attributes #0 = { noinline nounwind "correctly-rounded-divide-sqrt-fp-math"="false" "disable-tail-calls"="false" "less-precise-fpmad"="false" "no-frame-pointer-elim"="true" "no-frame-pointer-elim-non-leaf" "no-infs-fp-math"="false" "no-jump-tables"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="false" "stack-protector-buffer-size"="8" "target-features"="+d,+f,+m" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #1 = { nounwind readnone speculatable }
attributes #2 = { argmemonly nounwind }
attributes #3 = { noinline noreturn nounwind "correctly-rounded-divide-sqrt-fp-math"="false" "disable-tail-calls"="false" "less-precise-fpmad"="false" "no-frame-pointer-elim"="true" "no-frame-pointer-elim-non-leaf" "no-infs-fp-math"="false" "no-jump-tables"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="false" "stack-protector-buffer-size"="8" "target-features"="+d,+f,+m" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #4 = { nobuiltin }
attributes #5 = { nobuiltin noreturn }

!llvm.dbg.cu = !{!0, !3, !5, !7, !9, !11, !13, !15, !17, !19, !21, !23, !25, !27, !29, !31, !33, !35, !37, !39, !41, !43, !45, !47, !49, !51, !53, !55, !57, !59, !61, !63, !65, !67, !69, !71, !73, !75, !77, !79, !81, !83, !85, !87, !89, !91, !93, !95, !97, !99, !101, !103, !105, !107, !109, !111, !113, !115, !117, !119, !121, !123, !125, !127, !129, !131, !133, !135, !137, !139, !141, !143, !145, !147, !149, !151, !153, !155, !157, !159, !161, !163, !165, !167, !169, !171}
!llvm.ident = !{!173, !173, !173, !173, !173, !173, !173, !173, !173, !173, !173, !173, !173, !173, !173, !173, !173, !173, !173, !173, !173, !173, !173, !173, !173, !173, !173, !173, !173, !173, !173, !173, !173, !173, !173, !173, !173, !173, !173, !173, !173, !173, !173, !173, !173, !173, !173, !173, !173, !173, !173, !173, !173, !173, !173, !173, !173, !173, !173, !173, !173, !173, !173, !173, !173, !173, !173, !173, !173, !173, !173, !173, !173, !173, !173, !173, !173, !173, !173, !173, !173, !173, !173, !173, !173, !173}
!llvm.module.flags = !{!174, !175, !176}

!0 = distinct !DICompileUnit(language: DW_LANG_C99, file: !1, producer: "clang version 7.0.0 (tags/RELEASE_700/final)", isOptimized: false, runtimeVersion: 0, emissionKind: LineTablesOnly, enums: !2)
!1 = !DIFile(filename: "/home/hahns/Schreibtisch/llvmta_testcases/libraries/builtinsfloat/adddf3.c", directory: "/home/hahns/Schreibtisch/llvmta_testcases/tmp.0b9rXPKPan")
!2 = !{}
!3 = distinct !DICompileUnit(language: DW_LANG_C99, file: !4, producer: "clang version 7.0.0 (tags/RELEASE_700/final)", isOptimized: false, runtimeVersion: 0, emissionKind: LineTablesOnly, enums: !2)
!4 = !DIFile(filename: "/home/hahns/Schreibtisch/llvmta_testcases/libraries/builtinsfloat/addsf3.c", directory: "/home/hahns/Schreibtisch/llvmta_testcases/tmp.0b9rXPKPan")
!5 = distinct !DICompileUnit(language: DW_LANG_C99, file: !6, producer: "clang version 7.0.0 (tags/RELEASE_700/final)", isOptimized: false, runtimeVersion: 0, emissionKind: LineTablesOnly, enums: !2)
!6 = !DIFile(filename: "/home/hahns/Schreibtisch/llvmta_testcases/libraries/builtinsfloat/addtf3.c", directory: "/home/hahns/Schreibtisch/llvmta_testcases/tmp.0b9rXPKPan")
!7 = distinct !DICompileUnit(language: DW_LANG_C99, file: !8, producer: "clang version 7.0.0 (tags/RELEASE_700/final)", isOptimized: false, runtimeVersion: 0, emissionKind: LineTablesOnly, enums: !2)
!8 = !DIFile(filename: "/home/hahns/Schreibtisch/llvmta_testcases/libraries/builtinsfloat/comparedf2.c", directory: "/home/hahns/Schreibtisch/llvmta_testcases/tmp.0b9rXPKPan")
!9 = distinct !DICompileUnit(language: DW_LANG_C99, file: !10, producer: "clang version 7.0.0 (tags/RELEASE_700/final)", isOptimized: false, runtimeVersion: 0, emissionKind: LineTablesOnly, enums: !2)
!10 = !DIFile(filename: "/home/hahns/Schreibtisch/llvmta_testcases/libraries/builtinsfloat/comparesf2.c", directory: "/home/hahns/Schreibtisch/llvmta_testcases/tmp.0b9rXPKPan")
!11 = distinct !DICompileUnit(language: DW_LANG_C99, file: !12, producer: "clang version 7.0.0 (tags/RELEASE_700/final)", isOptimized: false, runtimeVersion: 0, emissionKind: LineTablesOnly, enums: !2)
!12 = !DIFile(filename: "/home/hahns/Schreibtisch/llvmta_testcases/libraries/builtinsfloat/comparetf2.c", directory: "/home/hahns/Schreibtisch/llvmta_testcases/tmp.0b9rXPKPan")
!13 = distinct !DICompileUnit(language: DW_LANG_C99, file: !14, producer: "clang version 7.0.0 (tags/RELEASE_700/final)", isOptimized: false, runtimeVersion: 0, emissionKind: LineTablesOnly, enums: !2)
!14 = !DIFile(filename: "/home/hahns/Schreibtisch/llvmta_testcases/libraries/builtinsfloat/divdf3.c", directory: "/home/hahns/Schreibtisch/llvmta_testcases/tmp.0b9rXPKPan")
!15 = distinct !DICompileUnit(language: DW_LANG_C99, file: !16, producer: "clang version 7.0.0 (tags/RELEASE_700/final)", isOptimized: false, runtimeVersion: 0, emissionKind: LineTablesOnly, enums: !2)
!16 = !DIFile(filename: "/home/hahns/Schreibtisch/llvmta_testcases/libraries/builtinsfloat/divsf3.c", directory: "/home/hahns/Schreibtisch/llvmta_testcases/tmp.0b9rXPKPan")
!17 = distinct !DICompileUnit(language: DW_LANG_C99, file: !18, producer: "clang version 7.0.0 (tags/RELEASE_700/final)", isOptimized: false, runtimeVersion: 0, emissionKind: LineTablesOnly, enums: !2)
!18 = !DIFile(filename: "/home/hahns/Schreibtisch/llvmta_testcases/libraries/builtinsfloat/divtf3.c", directory: "/home/hahns/Schreibtisch/llvmta_testcases/tmp.0b9rXPKPan")
!19 = distinct !DICompileUnit(language: DW_LANG_C99, file: !20, producer: "clang version 7.0.0 (tags/RELEASE_700/final)", isOptimized: false, runtimeVersion: 0, emissionKind: LineTablesOnly, enums: !2)
!20 = !DIFile(filename: "/home/hahns/Schreibtisch/llvmta_testcases/libraries/builtinsfloat/extenddftf2.c", directory: "/home/hahns/Schreibtisch/llvmta_testcases/tmp.0b9rXPKPan")
!21 = distinct !DICompileUnit(language: DW_LANG_C99, file: !22, producer: "clang version 7.0.0 (tags/RELEASE_700/final)", isOptimized: false, runtimeVersion: 0, emissionKind: LineTablesOnly, enums: !2)
!22 = !DIFile(filename: "/home/hahns/Schreibtisch/llvmta_testcases/libraries/builtinsfloat/extendhfsf2.c", directory: "/home/hahns/Schreibtisch/llvmta_testcases/tmp.0b9rXPKPan")
!23 = distinct !DICompileUnit(language: DW_LANG_C99, file: !24, producer: "clang version 7.0.0 (tags/RELEASE_700/final)", isOptimized: false, runtimeVersion: 0, emissionKind: LineTablesOnly, enums: !2)
!24 = !DIFile(filename: "/home/hahns/Schreibtisch/llvmta_testcases/libraries/builtinsfloat/extendsfdf2.c", directory: "/home/hahns/Schreibtisch/llvmta_testcases/tmp.0b9rXPKPan")
!25 = distinct !DICompileUnit(language: DW_LANG_C99, file: !26, producer: "clang version 7.0.0 (tags/RELEASE_700/final)", isOptimized: false, runtimeVersion: 0, emissionKind: LineTablesOnly, enums: !2)
!26 = !DIFile(filename: "/home/hahns/Schreibtisch/llvmta_testcases/libraries/builtinsfloat/extendsftf2.c", directory: "/home/hahns/Schreibtisch/llvmta_testcases/tmp.0b9rXPKPan")
!27 = distinct !DICompileUnit(language: DW_LANG_C99, file: !28, producer: "clang version 7.0.0 (tags/RELEASE_700/final)", isOptimized: false, runtimeVersion: 0, emissionKind: LineTablesOnly, enums: !2)
!28 = !DIFile(filename: "/home/hahns/Schreibtisch/llvmta_testcases/libraries/builtinsfloat/fixdfdi.c", directory: "/home/hahns/Schreibtisch/llvmta_testcases/tmp.0b9rXPKPan")
!29 = distinct !DICompileUnit(language: DW_LANG_C99, file: !30, producer: "clang version 7.0.0 (tags/RELEASE_700/final)", isOptimized: false, runtimeVersion: 0, emissionKind: LineTablesOnly, enums: !2)
!30 = !DIFile(filename: "/home/hahns/Schreibtisch/llvmta_testcases/libraries/builtinsfloat/fixdfsi.c", directory: "/home/hahns/Schreibtisch/llvmta_testcases/tmp.0b9rXPKPan")
!31 = distinct !DICompileUnit(language: DW_LANG_C99, file: !32, producer: "clang version 7.0.0 (tags/RELEASE_700/final)", isOptimized: false, runtimeVersion: 0, emissionKind: LineTablesOnly, enums: !2)
!32 = !DIFile(filename: "/home/hahns/Schreibtisch/llvmta_testcases/libraries/builtinsfloat/fixdfti.c", directory: "/home/hahns/Schreibtisch/llvmta_testcases/tmp.0b9rXPKPan")
!33 = distinct !DICompileUnit(language: DW_LANG_C99, file: !34, producer: "clang version 7.0.0 (tags/RELEASE_700/final)", isOptimized: false, runtimeVersion: 0, emissionKind: LineTablesOnly, enums: !2)
!34 = !DIFile(filename: "/home/hahns/Schreibtisch/llvmta_testcases/libraries/builtinsfloat/fixsfdi.c", directory: "/home/hahns/Schreibtisch/llvmta_testcases/tmp.0b9rXPKPan")
!35 = distinct !DICompileUnit(language: DW_LANG_C99, file: !36, producer: "clang version 7.0.0 (tags/RELEASE_700/final)", isOptimized: false, runtimeVersion: 0, emissionKind: LineTablesOnly, enums: !2)
!36 = !DIFile(filename: "/home/hahns/Schreibtisch/llvmta_testcases/libraries/builtinsfloat/fixsfsi.c", directory: "/home/hahns/Schreibtisch/llvmta_testcases/tmp.0b9rXPKPan")
!37 = distinct !DICompileUnit(language: DW_LANG_C99, file: !38, producer: "clang version 7.0.0 (tags/RELEASE_700/final)", isOptimized: false, runtimeVersion: 0, emissionKind: LineTablesOnly, enums: !2)
!38 = !DIFile(filename: "/home/hahns/Schreibtisch/llvmta_testcases/libraries/builtinsfloat/fixsfti.c", directory: "/home/hahns/Schreibtisch/llvmta_testcases/tmp.0b9rXPKPan")
!39 = distinct !DICompileUnit(language: DW_LANG_C99, file: !40, producer: "clang version 7.0.0 (tags/RELEASE_700/final)", isOptimized: false, runtimeVersion: 0, emissionKind: LineTablesOnly, enums: !2)
!40 = !DIFile(filename: "/home/hahns/Schreibtisch/llvmta_testcases/libraries/builtinsfloat/fixtfdi.c", directory: "/home/hahns/Schreibtisch/llvmta_testcases/tmp.0b9rXPKPan")
!41 = distinct !DICompileUnit(language: DW_LANG_C99, file: !42, producer: "clang version 7.0.0 (tags/RELEASE_700/final)", isOptimized: false, runtimeVersion: 0, emissionKind: LineTablesOnly, enums: !2)
!42 = !DIFile(filename: "/home/hahns/Schreibtisch/llvmta_testcases/libraries/builtinsfloat/fixtfsi.c", directory: "/home/hahns/Schreibtisch/llvmta_testcases/tmp.0b9rXPKPan")
!43 = distinct !DICompileUnit(language: DW_LANG_C99, file: !44, producer: "clang version 7.0.0 (tags/RELEASE_700/final)", isOptimized: false, runtimeVersion: 0, emissionKind: LineTablesOnly, enums: !2)
!44 = !DIFile(filename: "/home/hahns/Schreibtisch/llvmta_testcases/libraries/builtinsfloat/fixtfti.c", directory: "/home/hahns/Schreibtisch/llvmta_testcases/tmp.0b9rXPKPan")
!45 = distinct !DICompileUnit(language: DW_LANG_C99, file: !46, producer: "clang version 7.0.0 (tags/RELEASE_700/final)", isOptimized: false, runtimeVersion: 0, emissionKind: LineTablesOnly, enums: !2)
!46 = !DIFile(filename: "/home/hahns/Schreibtisch/llvmta_testcases/libraries/builtinsfloat/fixunsdfdi.c", directory: "/home/hahns/Schreibtisch/llvmta_testcases/tmp.0b9rXPKPan")
!47 = distinct !DICompileUnit(language: DW_LANG_C99, file: !48, producer: "clang version 7.0.0 (tags/RELEASE_700/final)", isOptimized: false, runtimeVersion: 0, emissionKind: LineTablesOnly, enums: !2)
!48 = !DIFile(filename: "/home/hahns/Schreibtisch/llvmta_testcases/libraries/builtinsfloat/fixunsdfsi.c", directory: "/home/hahns/Schreibtisch/llvmta_testcases/tmp.0b9rXPKPan")
!49 = distinct !DICompileUnit(language: DW_LANG_C99, file: !50, producer: "clang version 7.0.0 (tags/RELEASE_700/final)", isOptimized: false, runtimeVersion: 0, emissionKind: LineTablesOnly, enums: !2)
!50 = !DIFile(filename: "/home/hahns/Schreibtisch/llvmta_testcases/libraries/builtinsfloat/fixunsdfti.c", directory: "/home/hahns/Schreibtisch/llvmta_testcases/tmp.0b9rXPKPan")
!51 = distinct !DICompileUnit(language: DW_LANG_C99, file: !52, producer: "clang version 7.0.0 (tags/RELEASE_700/final)", isOptimized: false, runtimeVersion: 0, emissionKind: LineTablesOnly, enums: !2)
!52 = !DIFile(filename: "/home/hahns/Schreibtisch/llvmta_testcases/libraries/builtinsfloat/fixunssfdi.c", directory: "/home/hahns/Schreibtisch/llvmta_testcases/tmp.0b9rXPKPan")
!53 = distinct !DICompileUnit(language: DW_LANG_C99, file: !54, producer: "clang version 7.0.0 (tags/RELEASE_700/final)", isOptimized: false, runtimeVersion: 0, emissionKind: LineTablesOnly, enums: !2)
!54 = !DIFile(filename: "/home/hahns/Schreibtisch/llvmta_testcases/libraries/builtinsfloat/fixunssfsi.c", directory: "/home/hahns/Schreibtisch/llvmta_testcases/tmp.0b9rXPKPan")
!55 = distinct !DICompileUnit(language: DW_LANG_C99, file: !56, producer: "clang version 7.0.0 (tags/RELEASE_700/final)", isOptimized: false, runtimeVersion: 0, emissionKind: LineTablesOnly, enums: !2)
!56 = !DIFile(filename: "/home/hahns/Schreibtisch/llvmta_testcases/libraries/builtinsfloat/fixunssfti.c", directory: "/home/hahns/Schreibtisch/llvmta_testcases/tmp.0b9rXPKPan")
!57 = distinct !DICompileUnit(language: DW_LANG_C99, file: !58, producer: "clang version 7.0.0 (tags/RELEASE_700/final)", isOptimized: false, runtimeVersion: 0, emissionKind: LineTablesOnly, enums: !2)
!58 = !DIFile(filename: "/home/hahns/Schreibtisch/llvmta_testcases/libraries/builtinsfloat/fixunstfdi.c", directory: "/home/hahns/Schreibtisch/llvmta_testcases/tmp.0b9rXPKPan")
!59 = distinct !DICompileUnit(language: DW_LANG_C99, file: !60, producer: "clang version 7.0.0 (tags/RELEASE_700/final)", isOptimized: false, runtimeVersion: 0, emissionKind: LineTablesOnly, enums: !2)
!60 = !DIFile(filename: "/home/hahns/Schreibtisch/llvmta_testcases/libraries/builtinsfloat/fixunstfsi.c", directory: "/home/hahns/Schreibtisch/llvmta_testcases/tmp.0b9rXPKPan")
!61 = distinct !DICompileUnit(language: DW_LANG_C99, file: !62, producer: "clang version 7.0.0 (tags/RELEASE_700/final)", isOptimized: false, runtimeVersion: 0, emissionKind: LineTablesOnly, enums: !2)
!62 = !DIFile(filename: "/home/hahns/Schreibtisch/llvmta_testcases/libraries/builtinsfloat/fixunstfti.c", directory: "/home/hahns/Schreibtisch/llvmta_testcases/tmp.0b9rXPKPan")
!63 = distinct !DICompileUnit(language: DW_LANG_C99, file: !64, producer: "clang version 7.0.0 (tags/RELEASE_700/final)", isOptimized: false, runtimeVersion: 0, emissionKind: LineTablesOnly, enums: !2)
!64 = !DIFile(filename: "/home/hahns/Schreibtisch/llvmta_testcases/libraries/builtinsfloat/fixunsxfdi.c", directory: "/home/hahns/Schreibtisch/llvmta_testcases/tmp.0b9rXPKPan")
!65 = distinct !DICompileUnit(language: DW_LANG_C99, file: !66, producer: "clang version 7.0.0 (tags/RELEASE_700/final)", isOptimized: false, runtimeVersion: 0, emissionKind: LineTablesOnly, enums: !2)
!66 = !DIFile(filename: "/home/hahns/Schreibtisch/llvmta_testcases/libraries/builtinsfloat/fixunsxfsi.c", directory: "/home/hahns/Schreibtisch/llvmta_testcases/tmp.0b9rXPKPan")
!67 = distinct !DICompileUnit(language: DW_LANG_C99, file: !68, producer: "clang version 7.0.0 (tags/RELEASE_700/final)", isOptimized: false, runtimeVersion: 0, emissionKind: LineTablesOnly, enums: !2)
!68 = !DIFile(filename: "/home/hahns/Schreibtisch/llvmta_testcases/libraries/builtinsfloat/fixunsxfti.c", directory: "/home/hahns/Schreibtisch/llvmta_testcases/tmp.0b9rXPKPan")
!69 = distinct !DICompileUnit(language: DW_LANG_C99, file: !70, producer: "clang version 7.0.0 (tags/RELEASE_700/final)", isOptimized: false, runtimeVersion: 0, emissionKind: LineTablesOnly, enums: !2)
!70 = !DIFile(filename: "/home/hahns/Schreibtisch/llvmta_testcases/libraries/builtinsfloat/fixxfdi.c", directory: "/home/hahns/Schreibtisch/llvmta_testcases/tmp.0b9rXPKPan")
!71 = distinct !DICompileUnit(language: DW_LANG_C99, file: !72, producer: "clang version 7.0.0 (tags/RELEASE_700/final)", isOptimized: false, runtimeVersion: 0, emissionKind: LineTablesOnly, enums: !2)
!72 = !DIFile(filename: "/home/hahns/Schreibtisch/llvmta_testcases/libraries/builtinsfloat/fixxfti.c", directory: "/home/hahns/Schreibtisch/llvmta_testcases/tmp.0b9rXPKPan")
!73 = distinct !DICompileUnit(language: DW_LANG_C99, file: !74, producer: "clang version 7.0.0 (tags/RELEASE_700/final)", isOptimized: false, runtimeVersion: 0, emissionKind: LineTablesOnly, enums: !2)
!74 = !DIFile(filename: "/home/hahns/Schreibtisch/llvmta_testcases/libraries/builtinsfloat/floatdidf.c", directory: "/home/hahns/Schreibtisch/llvmta_testcases/tmp.0b9rXPKPan")
!75 = distinct !DICompileUnit(language: DW_LANG_C99, file: !76, producer: "clang version 7.0.0 (tags/RELEASE_700/final)", isOptimized: false, runtimeVersion: 0, emissionKind: LineTablesOnly, enums: !2)
!76 = !DIFile(filename: "/home/hahns/Schreibtisch/llvmta_testcases/libraries/builtinsfloat/floatdisf.c", directory: "/home/hahns/Schreibtisch/llvmta_testcases/tmp.0b9rXPKPan")
!77 = distinct !DICompileUnit(language: DW_LANG_C99, file: !78, producer: "clang version 7.0.0 (tags/RELEASE_700/final)", isOptimized: false, runtimeVersion: 0, emissionKind: LineTablesOnly, enums: !2)
!78 = !DIFile(filename: "/home/hahns/Schreibtisch/llvmta_testcases/libraries/builtinsfloat/floatditf.c", directory: "/home/hahns/Schreibtisch/llvmta_testcases/tmp.0b9rXPKPan")
!79 = distinct !DICompileUnit(language: DW_LANG_C99, file: !80, producer: "clang version 7.0.0 (tags/RELEASE_700/final)", isOptimized: false, runtimeVersion: 0, emissionKind: LineTablesOnly, enums: !2)
!80 = !DIFile(filename: "/home/hahns/Schreibtisch/llvmta_testcases/libraries/builtinsfloat/floatdixf.c", directory: "/home/hahns/Schreibtisch/llvmta_testcases/tmp.0b9rXPKPan")
!81 = distinct !DICompileUnit(language: DW_LANG_C99, file: !82, producer: "clang version 7.0.0 (tags/RELEASE_700/final)", isOptimized: false, runtimeVersion: 0, emissionKind: LineTablesOnly, enums: !2)
!82 = !DIFile(filename: "/home/hahns/Schreibtisch/llvmta_testcases/libraries/builtinsfloat/floatsidf.c", directory: "/home/hahns/Schreibtisch/llvmta_testcases/tmp.0b9rXPKPan")
!83 = distinct !DICompileUnit(language: DW_LANG_C99, file: !84, producer: "clang version 7.0.0 (tags/RELEASE_700/final)", isOptimized: false, runtimeVersion: 0, emissionKind: LineTablesOnly, enums: !2)
!84 = !DIFile(filename: "/home/hahns/Schreibtisch/llvmta_testcases/libraries/builtinsfloat/floatsisf.c", directory: "/home/hahns/Schreibtisch/llvmta_testcases/tmp.0b9rXPKPan")
!85 = distinct !DICompileUnit(language: DW_LANG_C99, file: !86, producer: "clang version 7.0.0 (tags/RELEASE_700/final)", isOptimized: false, runtimeVersion: 0, emissionKind: LineTablesOnly, enums: !2)
!86 = !DIFile(filename: "/home/hahns/Schreibtisch/llvmta_testcases/libraries/builtinsfloat/floatsitf.c", directory: "/home/hahns/Schreibtisch/llvmta_testcases/tmp.0b9rXPKPan")
!87 = distinct !DICompileUnit(language: DW_LANG_C99, file: !88, producer: "clang version 7.0.0 (tags/RELEASE_700/final)", isOptimized: false, runtimeVersion: 0, emissionKind: LineTablesOnly, enums: !2)
!88 = !DIFile(filename: "/home/hahns/Schreibtisch/llvmta_testcases/libraries/builtinsfloat/floattidf.c", directory: "/home/hahns/Schreibtisch/llvmta_testcases/tmp.0b9rXPKPan")
!89 = distinct !DICompileUnit(language: DW_LANG_C99, file: !90, producer: "clang version 7.0.0 (tags/RELEASE_700/final)", isOptimized: false, runtimeVersion: 0, emissionKind: LineTablesOnly, enums: !2)
!90 = !DIFile(filename: "/home/hahns/Schreibtisch/llvmta_testcases/libraries/builtinsfloat/floattisf.c", directory: "/home/hahns/Schreibtisch/llvmta_testcases/tmp.0b9rXPKPan")
!91 = distinct !DICompileUnit(language: DW_LANG_C99, file: !92, producer: "clang version 7.0.0 (tags/RELEASE_700/final)", isOptimized: false, runtimeVersion: 0, emissionKind: LineTablesOnly, enums: !2)
!92 = !DIFile(filename: "/home/hahns/Schreibtisch/llvmta_testcases/libraries/builtinsfloat/floattitf.c", directory: "/home/hahns/Schreibtisch/llvmta_testcases/tmp.0b9rXPKPan")
!93 = distinct !DICompileUnit(language: DW_LANG_C99, file: !94, producer: "clang version 7.0.0 (tags/RELEASE_700/final)", isOptimized: false, runtimeVersion: 0, emissionKind: LineTablesOnly, enums: !2)
!94 = !DIFile(filename: "/home/hahns/Schreibtisch/llvmta_testcases/libraries/builtinsfloat/floattixf.c", directory: "/home/hahns/Schreibtisch/llvmta_testcases/tmp.0b9rXPKPan")
!95 = distinct !DICompileUnit(language: DW_LANG_C99, file: !96, producer: "clang version 7.0.0 (tags/RELEASE_700/final)", isOptimized: false, runtimeVersion: 0, emissionKind: LineTablesOnly, enums: !2)
!96 = !DIFile(filename: "/home/hahns/Schreibtisch/llvmta_testcases/libraries/builtinsfloat/floatundidf.c", directory: "/home/hahns/Schreibtisch/llvmta_testcases/tmp.0b9rXPKPan")
!97 = distinct !DICompileUnit(language: DW_LANG_C99, file: !98, producer: "clang version 7.0.0 (tags/RELEASE_700/final)", isOptimized: false, runtimeVersion: 0, emissionKind: LineTablesOnly, enums: !2)
!98 = !DIFile(filename: "/home/hahns/Schreibtisch/llvmta_testcases/libraries/builtinsfloat/floatundisf.c", directory: "/home/hahns/Schreibtisch/llvmta_testcases/tmp.0b9rXPKPan")
!99 = distinct !DICompileUnit(language: DW_LANG_C99, file: !100, producer: "clang version 7.0.0 (tags/RELEASE_700/final)", isOptimized: false, runtimeVersion: 0, emissionKind: LineTablesOnly, enums: !2)
!100 = !DIFile(filename: "/home/hahns/Schreibtisch/llvmta_testcases/libraries/builtinsfloat/floatunditf.c", directory: "/home/hahns/Schreibtisch/llvmta_testcases/tmp.0b9rXPKPan")
!101 = distinct !DICompileUnit(language: DW_LANG_C99, file: !102, producer: "clang version 7.0.0 (tags/RELEASE_700/final)", isOptimized: false, runtimeVersion: 0, emissionKind: LineTablesOnly, enums: !2)
!102 = !DIFile(filename: "/home/hahns/Schreibtisch/llvmta_testcases/libraries/builtinsfloat/floatundixf.c", directory: "/home/hahns/Schreibtisch/llvmta_testcases/tmp.0b9rXPKPan")
!103 = distinct !DICompileUnit(language: DW_LANG_C99, file: !104, producer: "clang version 7.0.0 (tags/RELEASE_700/final)", isOptimized: false, runtimeVersion: 0, emissionKind: LineTablesOnly, enums: !2)
!104 = !DIFile(filename: "/home/hahns/Schreibtisch/llvmta_testcases/libraries/builtinsfloat/floatunsidf.c", directory: "/home/hahns/Schreibtisch/llvmta_testcases/tmp.0b9rXPKPan")
!105 = distinct !DICompileUnit(language: DW_LANG_C99, file: !106, producer: "clang version 7.0.0 (tags/RELEASE_700/final)", isOptimized: false, runtimeVersion: 0, emissionKind: LineTablesOnly, enums: !2)
!106 = !DIFile(filename: "/home/hahns/Schreibtisch/llvmta_testcases/libraries/builtinsfloat/floatunsisf.c", directory: "/home/hahns/Schreibtisch/llvmta_testcases/tmp.0b9rXPKPan")
!107 = distinct !DICompileUnit(language: DW_LANG_C99, file: !108, producer: "clang version 7.0.0 (tags/RELEASE_700/final)", isOptimized: false, runtimeVersion: 0, emissionKind: LineTablesOnly, enums: !2)
!108 = !DIFile(filename: "/home/hahns/Schreibtisch/llvmta_testcases/libraries/builtinsfloat/floatunsitf.c", directory: "/home/hahns/Schreibtisch/llvmta_testcases/tmp.0b9rXPKPan")
!109 = distinct !DICompileUnit(language: DW_LANG_C99, file: !110, producer: "clang version 7.0.0 (tags/RELEASE_700/final)", isOptimized: false, runtimeVersion: 0, emissionKind: LineTablesOnly, enums: !2)
!110 = !DIFile(filename: "/home/hahns/Schreibtisch/llvmta_testcases/libraries/builtinsfloat/floatuntidf.c", directory: "/home/hahns/Schreibtisch/llvmta_testcases/tmp.0b9rXPKPan")
!111 = distinct !DICompileUnit(language: DW_LANG_C99, file: !112, producer: "clang version 7.0.0 (tags/RELEASE_700/final)", isOptimized: false, runtimeVersion: 0, emissionKind: LineTablesOnly, enums: !2)
!112 = !DIFile(filename: "/home/hahns/Schreibtisch/llvmta_testcases/libraries/builtinsfloat/floatuntisf.c", directory: "/home/hahns/Schreibtisch/llvmta_testcases/tmp.0b9rXPKPan")
!113 = distinct !DICompileUnit(language: DW_LANG_C99, file: !114, producer: "clang version 7.0.0 (tags/RELEASE_700/final)", isOptimized: false, runtimeVersion: 0, emissionKind: LineTablesOnly, enums: !2)
!114 = !DIFile(filename: "/home/hahns/Schreibtisch/llvmta_testcases/libraries/builtinsfloat/floatuntitf.c", directory: "/home/hahns/Schreibtisch/llvmta_testcases/tmp.0b9rXPKPan")
!115 = distinct !DICompileUnit(language: DW_LANG_C99, file: !116, producer: "clang version 7.0.0 (tags/RELEASE_700/final)", isOptimized: false, runtimeVersion: 0, emissionKind: LineTablesOnly, enums: !2)
!116 = !DIFile(filename: "/home/hahns/Schreibtisch/llvmta_testcases/libraries/builtinsfloat/floatuntixf.c", directory: "/home/hahns/Schreibtisch/llvmta_testcases/tmp.0b9rXPKPan")
!117 = distinct !DICompileUnit(language: DW_LANG_C99, file: !118, producer: "clang version 7.0.0 (tags/RELEASE_700/final)", isOptimized: false, runtimeVersion: 0, emissionKind: LineTablesOnly, enums: !2)
!118 = !DIFile(filename: "/home/hahns/Schreibtisch/llvmta_testcases/libraries/builtinsfloat/int_util.c", directory: "/home/hahns/Schreibtisch/llvmta_testcases/tmp.0b9rXPKPan")
!119 = distinct !DICompileUnit(language: DW_LANG_C99, file: !120, producer: "clang version 7.0.0 (tags/RELEASE_700/final)", isOptimized: false, runtimeVersion: 0, emissionKind: LineTablesOnly, enums: !2)
!120 = !DIFile(filename: "/home/hahns/Schreibtisch/llvmta_testcases/libraries/builtinsfloat/muldf3.c", directory: "/home/hahns/Schreibtisch/llvmta_testcases/tmp.0b9rXPKPan")
!121 = distinct !DICompileUnit(language: DW_LANG_C99, file: !122, producer: "clang version 7.0.0 (tags/RELEASE_700/final)", isOptimized: false, runtimeVersion: 0, emissionKind: LineTablesOnly, enums: !2)
!122 = !DIFile(filename: "/home/hahns/Schreibtisch/llvmta_testcases/libraries/builtinsfloat/muldi3.c", directory: "/home/hahns/Schreibtisch/llvmta_testcases/tmp.0b9rXPKPan")
!123 = distinct !DICompileUnit(language: DW_LANG_C99, file: !124, producer: "clang version 7.0.0 (tags/RELEASE_700/final)", isOptimized: false, runtimeVersion: 0, emissionKind: LineTablesOnly, enums: !2)
!124 = !DIFile(filename: "/home/hahns/Schreibtisch/llvmta_testcases/libraries/builtinsfloat/mulodi4.c", directory: "/home/hahns/Schreibtisch/llvmta_testcases/tmp.0b9rXPKPan")
!125 = distinct !DICompileUnit(language: DW_LANG_C99, file: !126, producer: "clang version 7.0.0 (tags/RELEASE_700/final)", isOptimized: false, runtimeVersion: 0, emissionKind: LineTablesOnly, enums: !2)
!126 = !DIFile(filename: "/home/hahns/Schreibtisch/llvmta_testcases/libraries/builtinsfloat/mulosi4.c", directory: "/home/hahns/Schreibtisch/llvmta_testcases/tmp.0b9rXPKPan")
!127 = distinct !DICompileUnit(language: DW_LANG_C99, file: !128, producer: "clang version 7.0.0 (tags/RELEASE_700/final)", isOptimized: false, runtimeVersion: 0, emissionKind: LineTablesOnly, enums: !2)
!128 = !DIFile(filename: "/home/hahns/Schreibtisch/llvmta_testcases/libraries/builtinsfloat/muloti4.c", directory: "/home/hahns/Schreibtisch/llvmta_testcases/tmp.0b9rXPKPan")
!129 = distinct !DICompileUnit(language: DW_LANG_C99, file: !130, producer: "clang version 7.0.0 (tags/RELEASE_700/final)", isOptimized: false, runtimeVersion: 0, emissionKind: LineTablesOnly, enums: !2)
!130 = !DIFile(filename: "/home/hahns/Schreibtisch/llvmta_testcases/libraries/builtinsfloat/mulsf3.c", directory: "/home/hahns/Schreibtisch/llvmta_testcases/tmp.0b9rXPKPan")
!131 = distinct !DICompileUnit(language: DW_LANG_C99, file: !132, producer: "clang version 7.0.0 (tags/RELEASE_700/final)", isOptimized: false, runtimeVersion: 0, emissionKind: LineTablesOnly, enums: !2)
!132 = !DIFile(filename: "/home/hahns/Schreibtisch/llvmta_testcases/libraries/builtinsfloat/multf3.c", directory: "/home/hahns/Schreibtisch/llvmta_testcases/tmp.0b9rXPKPan")
!133 = distinct !DICompileUnit(language: DW_LANG_C99, file: !134, producer: "clang version 7.0.0 (tags/RELEASE_700/final)", isOptimized: false, runtimeVersion: 0, emissionKind: LineTablesOnly, enums: !2)
!134 = !DIFile(filename: "/home/hahns/Schreibtisch/llvmta_testcases/libraries/builtinsfloat/multi3.c", directory: "/home/hahns/Schreibtisch/llvmta_testcases/tmp.0b9rXPKPan")
!135 = distinct !DICompileUnit(language: DW_LANG_C99, file: !136, producer: "clang version 7.0.0 (tags/RELEASE_700/final)", isOptimized: false, runtimeVersion: 0, emissionKind: LineTablesOnly, enums: !2)
!136 = !DIFile(filename: "/home/hahns/Schreibtisch/llvmta_testcases/libraries/builtinsfloat/negdf2.c", directory: "/home/hahns/Schreibtisch/llvmta_testcases/tmp.0b9rXPKPan")
!137 = distinct !DICompileUnit(language: DW_LANG_C99, file: !138, producer: "clang version 7.0.0 (tags/RELEASE_700/final)", isOptimized: false, runtimeVersion: 0, emissionKind: LineTablesOnly, enums: !2)
!138 = !DIFile(filename: "/home/hahns/Schreibtisch/llvmta_testcases/libraries/builtinsfloat/negdi2.c", directory: "/home/hahns/Schreibtisch/llvmta_testcases/tmp.0b9rXPKPan")
!139 = distinct !DICompileUnit(language: DW_LANG_C99, file: !140, producer: "clang version 7.0.0 (tags/RELEASE_700/final)", isOptimized: false, runtimeVersion: 0, emissionKind: LineTablesOnly, enums: !2)
!140 = !DIFile(filename: "/home/hahns/Schreibtisch/llvmta_testcases/libraries/builtinsfloat/negsf2.c", directory: "/home/hahns/Schreibtisch/llvmta_testcases/tmp.0b9rXPKPan")
!141 = distinct !DICompileUnit(language: DW_LANG_C99, file: !142, producer: "clang version 7.0.0 (tags/RELEASE_700/final)", isOptimized: false, runtimeVersion: 0, emissionKind: LineTablesOnly, enums: !2)
!142 = !DIFile(filename: "/home/hahns/Schreibtisch/llvmta_testcases/libraries/builtinsfloat/negti2.c", directory: "/home/hahns/Schreibtisch/llvmta_testcases/tmp.0b9rXPKPan")
!143 = distinct !DICompileUnit(language: DW_LANG_C99, file: !144, producer: "clang version 7.0.0 (tags/RELEASE_700/final)", isOptimized: false, runtimeVersion: 0, emissionKind: LineTablesOnly, enums: !2)
!144 = !DIFile(filename: "/home/hahns/Schreibtisch/llvmta_testcases/libraries/builtinsfloat/negvdi2.c", directory: "/home/hahns/Schreibtisch/llvmta_testcases/tmp.0b9rXPKPan")
!145 = distinct !DICompileUnit(language: DW_LANG_C99, file: !146, producer: "clang version 7.0.0 (tags/RELEASE_700/final)", isOptimized: false, runtimeVersion: 0, emissionKind: LineTablesOnly, enums: !2)
!146 = !DIFile(filename: "/home/hahns/Schreibtisch/llvmta_testcases/libraries/builtinsfloat/negvsi2.c", directory: "/home/hahns/Schreibtisch/llvmta_testcases/tmp.0b9rXPKPan")
!147 = distinct !DICompileUnit(language: DW_LANG_C99, file: !148, producer: "clang version 7.0.0 (tags/RELEASE_700/final)", isOptimized: false, runtimeVersion: 0, emissionKind: LineTablesOnly, enums: !2)
!148 = !DIFile(filename: "/home/hahns/Schreibtisch/llvmta_testcases/libraries/builtinsfloat/negvti2.c", directory: "/home/hahns/Schreibtisch/llvmta_testcases/tmp.0b9rXPKPan")
!149 = distinct !DICompileUnit(language: DW_LANG_C99, file: !150, producer: "clang version 7.0.0 (tags/RELEASE_700/final)", isOptimized: false, runtimeVersion: 0, emissionKind: LineTablesOnly, enums: !2)
!150 = !DIFile(filename: "/home/hahns/Schreibtisch/llvmta_testcases/libraries/builtinsfloat/powidf2.c", directory: "/home/hahns/Schreibtisch/llvmta_testcases/tmp.0b9rXPKPan")
!151 = distinct !DICompileUnit(language: DW_LANG_C99, file: !152, producer: "clang version 7.0.0 (tags/RELEASE_700/final)", isOptimized: false, runtimeVersion: 0, emissionKind: LineTablesOnly, enums: !2)
!152 = !DIFile(filename: "/home/hahns/Schreibtisch/llvmta_testcases/libraries/builtinsfloat/powisf2.c", directory: "/home/hahns/Schreibtisch/llvmta_testcases/tmp.0b9rXPKPan")
!153 = distinct !DICompileUnit(language: DW_LANG_C99, file: !154, producer: "clang version 7.0.0 (tags/RELEASE_700/final)", isOptimized: false, runtimeVersion: 0, emissionKind: LineTablesOnly, enums: !2)
!154 = !DIFile(filename: "/home/hahns/Schreibtisch/llvmta_testcases/libraries/builtinsfloat/powitf2.c", directory: "/home/hahns/Schreibtisch/llvmta_testcases/tmp.0b9rXPKPan")
!155 = distinct !DICompileUnit(language: DW_LANG_C99, file: !156, producer: "clang version 7.0.0 (tags/RELEASE_700/final)", isOptimized: false, runtimeVersion: 0, emissionKind: LineTablesOnly, enums: !2)
!156 = !DIFile(filename: "/home/hahns/Schreibtisch/llvmta_testcases/libraries/builtinsfloat/powixf2.c", directory: "/home/hahns/Schreibtisch/llvmta_testcases/tmp.0b9rXPKPan")
!157 = distinct !DICompileUnit(language: DW_LANG_C99, file: !158, producer: "clang version 7.0.0 (tags/RELEASE_700/final)", isOptimized: false, runtimeVersion: 0, emissionKind: LineTablesOnly, enums: !2)
!158 = !DIFile(filename: "/home/hahns/Schreibtisch/llvmta_testcases/libraries/builtinsfloat/subdf3.c", directory: "/home/hahns/Schreibtisch/llvmta_testcases/tmp.0b9rXPKPan")
!159 = distinct !DICompileUnit(language: DW_LANG_C99, file: !160, producer: "clang version 7.0.0 (tags/RELEASE_700/final)", isOptimized: false, runtimeVersion: 0, emissionKind: LineTablesOnly, enums: !2)
!160 = !DIFile(filename: "/home/hahns/Schreibtisch/llvmta_testcases/libraries/builtinsfloat/subsf3.c", directory: "/home/hahns/Schreibtisch/llvmta_testcases/tmp.0b9rXPKPan")
!161 = distinct !DICompileUnit(language: DW_LANG_C99, file: !162, producer: "clang version 7.0.0 (tags/RELEASE_700/final)", isOptimized: false, runtimeVersion: 0, emissionKind: LineTablesOnly, enums: !2)
!162 = !DIFile(filename: "/home/hahns/Schreibtisch/llvmta_testcases/libraries/builtinsfloat/subtf3.c", directory: "/home/hahns/Schreibtisch/llvmta_testcases/tmp.0b9rXPKPan")
!163 = distinct !DICompileUnit(language: DW_LANG_C99, file: !164, producer: "clang version 7.0.0 (tags/RELEASE_700/final)", isOptimized: false, runtimeVersion: 0, emissionKind: LineTablesOnly, enums: !2)
!164 = !DIFile(filename: "/home/hahns/Schreibtisch/llvmta_testcases/libraries/builtinsfloat/truncdfhf2.c", directory: "/home/hahns/Schreibtisch/llvmta_testcases/tmp.0b9rXPKPan")
!165 = distinct !DICompileUnit(language: DW_LANG_C99, file: !166, producer: "clang version 7.0.0 (tags/RELEASE_700/final)", isOptimized: false, runtimeVersion: 0, emissionKind: LineTablesOnly, enums: !2)
!166 = !DIFile(filename: "/home/hahns/Schreibtisch/llvmta_testcases/libraries/builtinsfloat/truncdfsf2.c", directory: "/home/hahns/Schreibtisch/llvmta_testcases/tmp.0b9rXPKPan")
!167 = distinct !DICompileUnit(language: DW_LANG_C99, file: !168, producer: "clang version 7.0.0 (tags/RELEASE_700/final)", isOptimized: false, runtimeVersion: 0, emissionKind: LineTablesOnly, enums: !2)
!168 = !DIFile(filename: "/home/hahns/Schreibtisch/llvmta_testcases/libraries/builtinsfloat/truncsfhf2.c", directory: "/home/hahns/Schreibtisch/llvmta_testcases/tmp.0b9rXPKPan")
!169 = distinct !DICompileUnit(language: DW_LANG_C99, file: !170, producer: "clang version 7.0.0 (tags/RELEASE_700/final)", isOptimized: false, runtimeVersion: 0, emissionKind: LineTablesOnly, enums: !2)
!170 = !DIFile(filename: "/home/hahns/Schreibtisch/llvmta_testcases/libraries/builtinsfloat/trunctfdf2.c", directory: "/home/hahns/Schreibtisch/llvmta_testcases/tmp.0b9rXPKPan")
!171 = distinct !DICompileUnit(language: DW_LANG_C99, file: !172, producer: "clang version 7.0.0 (tags/RELEASE_700/final)", isOptimized: false, runtimeVersion: 0, emissionKind: LineTablesOnly, enums: !2)
!172 = !DIFile(filename: "/home/hahns/Schreibtisch/llvmta_testcases/libraries/builtinsfloat/trunctfsf2.c", directory: "/home/hahns/Schreibtisch/llvmta_testcases/tmp.0b9rXPKPan")
!173 = !{!"clang version 7.0.0 (tags/RELEASE_700/final)"}
!174 = !{i32 2, !"Dwarf Version", i32 4}
!175 = !{i32 2, !"Debug Info Version", i32 3}
!176 = !{i32 1, !"wchar_size", i32 4}
!177 = distinct !DISubprogram(name: "__adddf3", scope: !1, file: !1, line: 20, type: !178, isLocal: false, isDefinition: true, scopeLine: 20, flags: DIFlagPrototyped, isOptimized: false, unit: !0, retainedNodes: !2)
!178 = !DISubroutineType(types: !2)
!179 = !DILocation(line: 21, column: 23, scope: !177)
!180 = !DILocation(line: 21, column: 26, scope: !177)
!181 = !DILocation(line: 21, column: 12, scope: !177)
!182 = !DILocation(line: 21, column: 5, scope: !177)
!183 = distinct !DISubprogram(name: "__addXf3__", scope: !184, file: !184, line: 17, type: !178, isLocal: true, isDefinition: true, scopeLine: 17, flags: DIFlagPrototyped, isOptimized: false, unit: !0, retainedNodes: !2)
!184 = !DIFile(filename: "/home/hahns/Schreibtisch/llvmta_testcases/libraries/builtinsfloat/fp_add_impl.inc", directory: "/home/hahns/Schreibtisch/llvmta_testcases/tmp.0b9rXPKPan")
!185 = !DILocation(line: 18, column: 24, scope: !183)
!186 = !DILocation(line: 18, column: 18, scope: !183)
!187 = !DILocation(line: 18, column: 11, scope: !183)
!188 = !DILocation(line: 19, column: 24, scope: !183)
!189 = !DILocation(line: 19, column: 18, scope: !183)
!190 = !DILocation(line: 19, column: 11, scope: !183)
!191 = !DILocation(line: 20, column: 24, scope: !183)
!192 = !DILocation(line: 20, column: 29, scope: !183)
!193 = !DILocation(line: 20, column: 17, scope: !183)
!194 = !DILocation(line: 21, column: 24, scope: !183)
!195 = !DILocation(line: 21, column: 29, scope: !183)
!196 = !DILocation(line: 21, column: 17, scope: !183)
!197 = !DILocation(line: 24, column: 9, scope: !183)
!198 = !DILocation(line: 24, column: 14, scope: !183)
!199 = !DILocation(line: 24, column: 25, scope: !183)
!200 = !DILocation(line: 24, column: 46, scope: !183)
!201 = !DILocation(line: 25, column: 9, scope: !183)
!202 = !DILocation(line: 25, column: 14, scope: !183)
!203 = !DILocation(line: 25, column: 25, scope: !183)
!204 = !DILocation(line: 27, column: 13, scope: !183)
!205 = !DILocation(line: 27, column: 18, scope: !183)
!206 = !DILocation(line: 27, column: 49, scope: !183)
!207 = !DILocation(line: 27, column: 43, scope: !183)
!208 = !DILocation(line: 27, column: 52, scope: !183)
!209 = !DILocation(line: 27, column: 35, scope: !183)
!210 = !DILocation(line: 27, column: 28, scope: !183)
!211 = !DILocation(line: 29, column: 13, scope: !183)
!212 = !DILocation(line: 29, column: 18, scope: !183)
!213 = !DILocation(line: 29, column: 49, scope: !183)
!214 = !DILocation(line: 29, column: 43, scope: !183)
!215 = !DILocation(line: 29, column: 52, scope: !183)
!216 = !DILocation(line: 29, column: 35, scope: !183)
!217 = !DILocation(line: 29, column: 28, scope: !183)
!218 = !DILocation(line: 31, column: 13, scope: !183)
!219 = !DILocation(line: 31, column: 18, scope: !183)
!220 = !DILocation(line: 33, column: 24, scope: !183)
!221 = !DILocation(line: 33, column: 18, scope: !183)
!222 = !DILocation(line: 33, column: 35, scope: !183)
!223 = !DILocation(line: 33, column: 29, scope: !183)
!224 = !DILocation(line: 33, column: 27, scope: !183)
!225 = !DILocation(line: 33, column: 39, scope: !183)
!226 = !DILocation(line: 33, column: 17, scope: !183)
!227 = !DILocation(line: 33, column: 58, scope: !183)
!228 = !DILocation(line: 33, column: 51, scope: !183)
!229 = !DILocation(line: 35, column: 25, scope: !183)
!230 = !DILocation(line: 35, column: 18, scope: !183)
!231 = !DILocation(line: 39, column: 13, scope: !183)
!232 = !DILocation(line: 39, column: 18, scope: !183)
!233 = !DILocation(line: 39, column: 36, scope: !183)
!234 = !DILocation(line: 39, column: 29, scope: !183)
!235 = !DILocation(line: 42, column: 14, scope: !183)
!236 = !DILocation(line: 42, column: 13, scope: !183)
!237 = !DILocation(line: 44, column: 18, scope: !183)
!238 = !DILocation(line: 44, column: 17, scope: !183)
!239 = !DILocation(line: 44, column: 45, scope: !183)
!240 = !DILocation(line: 44, column: 39, scope: !183)
!241 = !DILocation(line: 44, column: 56, scope: !183)
!242 = !DILocation(line: 44, column: 50, scope: !183)
!243 = !DILocation(line: 44, column: 48, scope: !183)
!244 = !DILocation(line: 44, column: 31, scope: !183)
!245 = !DILocation(line: 44, column: 24, scope: !183)
!246 = !DILocation(line: 45, column: 25, scope: !183)
!247 = !DILocation(line: 45, column: 18, scope: !183)
!248 = !DILocation(line: 49, column: 14, scope: !183)
!249 = !DILocation(line: 49, column: 13, scope: !183)
!250 = !DILocation(line: 49, column: 27, scope: !183)
!251 = !DILocation(line: 49, column: 20, scope: !183)
!252 = !DILocation(line: 50, column: 5, scope: !183)
!253 = !DILocation(line: 53, column: 9, scope: !183)
!254 = !DILocation(line: 53, column: 16, scope: !183)
!255 = !DILocation(line: 53, column: 14, scope: !183)
!256 = !DILocation(line: 54, column: 28, scope: !183)
!257 = !DILocation(line: 54, column: 21, scope: !183)
!258 = !DILocation(line: 55, column: 16, scope: !183)
!259 = !DILocation(line: 55, column: 14, scope: !183)
!260 = !DILocation(line: 56, column: 16, scope: !183)
!261 = !DILocation(line: 56, column: 14, scope: !183)
!262 = !DILocation(line: 57, column: 5, scope: !183)
!263 = !DILocation(line: 60, column: 21, scope: !183)
!264 = !DILocation(line: 60, column: 26, scope: !183)
!265 = !DILocation(line: 60, column: 45, scope: !183)
!266 = !DILocation(line: 60, column: 9, scope: !183)
!267 = !DILocation(line: 61, column: 21, scope: !183)
!268 = !DILocation(line: 61, column: 26, scope: !183)
!269 = !DILocation(line: 61, column: 45, scope: !183)
!270 = !DILocation(line: 61, column: 9, scope: !183)
!271 = !DILocation(line: 62, column: 26, scope: !183)
!272 = !DILocation(line: 62, column: 31, scope: !183)
!273 = !DILocation(line: 62, column: 11, scope: !183)
!274 = !DILocation(line: 63, column: 26, scope: !183)
!275 = !DILocation(line: 63, column: 31, scope: !183)
!276 = !DILocation(line: 63, column: 11, scope: !183)
!277 = !DILocation(line: 66, column: 9, scope: !183)
!278 = !DILocation(line: 66, column: 19, scope: !183)
!279 = !DILocation(line: 66, column: 37, scope: !183)
!280 = !DILocation(line: 66, column: 35, scope: !183)
!281 = !DILocation(line: 66, column: 25, scope: !183)
!282 = !DILocation(line: 67, column: 9, scope: !183)
!283 = !DILocation(line: 67, column: 19, scope: !183)
!284 = !DILocation(line: 67, column: 37, scope: !183)
!285 = !DILocation(line: 67, column: 35, scope: !183)
!286 = !DILocation(line: 67, column: 25, scope: !183)
!287 = !DILocation(line: 71, column: 30, scope: !183)
!288 = !DILocation(line: 71, column: 35, scope: !183)
!289 = !DILocation(line: 71, column: 17, scope: !183)
!290 = !DILocation(line: 72, column: 31, scope: !183)
!291 = !DILocation(line: 72, column: 38, scope: !183)
!292 = !DILocation(line: 72, column: 36, scope: !183)
!293 = !DILocation(line: 72, column: 44, scope: !183)
!294 = !DILocation(line: 72, column: 30, scope: !183)
!295 = !DILocation(line: 72, column: 16, scope: !183)
!296 = !DILocation(line: 78, column: 21, scope: !183)
!297 = !DILocation(line: 78, column: 34, scope: !183)
!298 = !DILocation(line: 78, column: 49, scope: !183)
!299 = !DILocation(line: 78, column: 18, scope: !183)
!300 = !DILocation(line: 79, column: 21, scope: !183)
!301 = !DILocation(line: 79, column: 34, scope: !183)
!302 = !DILocation(line: 79, column: 49, scope: !183)
!303 = !DILocation(line: 79, column: 18, scope: !183)
!304 = !DILocation(line: 83, column: 32, scope: !183)
!305 = !DILocation(line: 83, column: 44, scope: !183)
!306 = !DILocation(line: 83, column: 42, scope: !183)
!307 = !DILocation(line: 83, column: 24, scope: !183)
!308 = !DILocation(line: 84, column: 9, scope: !183)
!309 = !DILocation(line: 85, column: 13, scope: !183)
!310 = !DILocation(line: 85, column: 19, scope: !183)
!311 = !DILocation(line: 86, column: 33, scope: !183)
!312 = !DILocation(line: 86, column: 62, scope: !183)
!313 = !DILocation(line: 86, column: 60, scope: !183)
!314 = !DILocation(line: 86, column: 46, scope: !183)
!315 = !DILocation(line: 86, column: 24, scope: !183)
!316 = !DILocation(line: 87, column: 28, scope: !183)
!317 = !DILocation(line: 87, column: 44, scope: !183)
!318 = !DILocation(line: 87, column: 41, scope: !183)
!319 = !DILocation(line: 87, column: 52, scope: !183)
!320 = !DILocation(line: 87, column: 50, scope: !183)
!321 = !DILocation(line: 87, column: 26, scope: !183)
!322 = !DILocation(line: 88, column: 9, scope: !183)
!323 = !DILocation(line: 89, column: 26, scope: !183)
!324 = !DILocation(line: 91, column: 5, scope: !183)
!325 = !DILocation(line: 92, column: 9, scope: !183)
!326 = !DILocation(line: 93, column: 25, scope: !183)
!327 = !DILocation(line: 93, column: 22, scope: !183)
!328 = !DILocation(line: 95, column: 13, scope: !183)
!329 = !DILocation(line: 95, column: 26, scope: !183)
!330 = !DILocation(line: 95, column: 39, scope: !183)
!331 = !DILocation(line: 95, column: 32, scope: !183)
!332 = !DILocation(line: 99, column: 13, scope: !183)
!333 = !DILocation(line: 99, column: 26, scope: !183)
!334 = !DILocation(line: 100, column: 39, scope: !183)
!335 = !DILocation(line: 100, column: 31, scope: !183)
!336 = !DILocation(line: 100, column: 55, scope: !183)
!337 = !DILocation(line: 100, column: 53, scope: !183)
!338 = !DILocation(line: 100, column: 23, scope: !183)
!339 = !DILocation(line: 101, column: 30, scope: !183)
!340 = !DILocation(line: 101, column: 26, scope: !183)
!341 = !DILocation(line: 102, column: 26, scope: !183)
!342 = !DILocation(line: 102, column: 23, scope: !183)
!343 = !DILocation(line: 103, column: 9, scope: !183)
!344 = !DILocation(line: 104, column: 5, scope: !183)
!345 = !DILocation(line: 106, column: 25, scope: !183)
!346 = !DILocation(line: 106, column: 22, scope: !183)
!347 = !DILocation(line: 110, column: 13, scope: !183)
!348 = !DILocation(line: 110, column: 26, scope: !183)
!349 = !DILocation(line: 111, column: 33, scope: !183)
!350 = !DILocation(line: 111, column: 46, scope: !183)
!351 = !DILocation(line: 111, column: 24, scope: !183)
!352 = !DILocation(line: 112, column: 28, scope: !183)
!353 = !DILocation(line: 112, column: 41, scope: !183)
!354 = !DILocation(line: 112, column: 48, scope: !183)
!355 = !DILocation(line: 112, column: 46, scope: !183)
!356 = !DILocation(line: 112, column: 26, scope: !183)
!357 = !DILocation(line: 113, column: 23, scope: !183)
!358 = !DILocation(line: 114, column: 9, scope: !183)
!359 = !DILocation(line: 118, column: 9, scope: !183)
!360 = !DILocation(line: 118, column: 19, scope: !183)
!361 = !DILocation(line: 118, column: 59, scope: !183)
!362 = !DILocation(line: 118, column: 57, scope: !183)
!363 = !DILocation(line: 118, column: 42, scope: !183)
!364 = !DILocation(line: 118, column: 35, scope: !183)
!365 = !DILocation(line: 120, column: 9, scope: !183)
!366 = !DILocation(line: 120, column: 19, scope: !183)
!367 = !DILocation(line: 123, column: 31, scope: !183)
!368 = !DILocation(line: 123, column: 29, scope: !183)
!369 = !DILocation(line: 123, column: 19, scope: !183)
!370 = !DILocation(line: 124, column: 29, scope: !183)
!371 = !DILocation(line: 124, column: 58, scope: !183)
!372 = !DILocation(line: 124, column: 56, scope: !183)
!373 = !DILocation(line: 124, column: 42, scope: !183)
!374 = !DILocation(line: 124, column: 20, scope: !183)
!375 = !DILocation(line: 125, column: 24, scope: !183)
!376 = !DILocation(line: 125, column: 40, scope: !183)
!377 = !DILocation(line: 125, column: 37, scope: !183)
!378 = !DILocation(line: 125, column: 48, scope: !183)
!379 = !DILocation(line: 125, column: 46, scope: !183)
!380 = !DILocation(line: 125, column: 22, scope: !183)
!381 = !DILocation(line: 126, column: 19, scope: !183)
!382 = !DILocation(line: 127, column: 5, scope: !183)
!383 = !DILocation(line: 130, column: 34, scope: !183)
!384 = !DILocation(line: 130, column: 47, scope: !183)
!385 = !DILocation(line: 130, column: 15, scope: !183)
!386 = !DILocation(line: 133, column: 20, scope: !183)
!387 = !DILocation(line: 133, column: 33, scope: !183)
!388 = !DILocation(line: 133, column: 38, scope: !183)
!389 = !DILocation(line: 133, column: 11, scope: !183)
!390 = !DILocation(line: 136, column: 22, scope: !183)
!391 = !DILocation(line: 136, column: 15, scope: !183)
!392 = !DILocation(line: 136, column: 32, scope: !183)
!393 = !DILocation(line: 136, column: 12, scope: !183)
!394 = !DILocation(line: 137, column: 15, scope: !183)
!395 = !DILocation(line: 137, column: 12, scope: !183)
!396 = !DILocation(line: 141, column: 9, scope: !183)
!397 = !DILocation(line: 141, column: 26, scope: !183)
!398 = !DILocation(line: 141, column: 39, scope: !183)
!399 = !DILocation(line: 141, column: 33, scope: !183)
!400 = !DILocation(line: 142, column: 9, scope: !183)
!401 = !DILocation(line: 142, column: 26, scope: !183)
!402 = !DILocation(line: 142, column: 44, scope: !183)
!403 = !DILocation(line: 142, column: 51, scope: !183)
!404 = !DILocation(line: 142, column: 41, scope: !183)
!405 = !DILocation(line: 142, column: 34, scope: !183)
!406 = !DILocation(line: 143, column: 20, scope: !183)
!407 = !DILocation(line: 143, column: 12, scope: !183)
!408 = !DILocation(line: 143, column: 5, scope: !183)
!409 = !DILocation(line: 144, column: 1, scope: !183)
!410 = distinct !DISubprogram(name: "toRep", scope: !411, file: !411, line: 231, type: !178, isLocal: true, isDefinition: true, scopeLine: 231, flags: DIFlagPrototyped, isOptimized: false, unit: !0, retainedNodes: !2)
!411 = !DIFile(filename: "/home/hahns/Schreibtisch/llvmta_testcases/libraries/builtinsfloat/fp_lib.h", directory: "/home/hahns/Schreibtisch/llvmta_testcases/tmp.0b9rXPKPan")
!412 = !DILocation(line: 232, column: 44, scope: !410)
!413 = !DILocation(line: 232, column: 50, scope: !410)
!414 = !DILocation(line: 233, column: 16, scope: !410)
!415 = !DILocation(line: 233, column: 5, scope: !410)
!416 = distinct !DISubprogram(name: "fromRep", scope: !411, file: !411, line: 236, type: !178, isLocal: true, isDefinition: true, scopeLine: 236, flags: DIFlagPrototyped, isOptimized: false, unit: !0, retainedNodes: !2)
!417 = !DILocation(line: 237, column: 44, scope: !416)
!418 = !DILocation(line: 237, column: 50, scope: !416)
!419 = !DILocation(line: 238, column: 16, scope: !416)
!420 = !DILocation(line: 238, column: 5, scope: !416)
!421 = distinct !DISubprogram(name: "normalize", scope: !411, file: !411, line: 241, type: !178, isLocal: true, isDefinition: true, scopeLine: 241, flags: DIFlagPrototyped, isOptimized: false, unit: !0, retainedNodes: !2)
!422 = !DILocation(line: 242, column: 32, scope: !421)
!423 = !DILocation(line: 242, column: 31, scope: !421)
!424 = !DILocation(line: 242, column: 23, scope: !421)
!425 = !DILocation(line: 242, column: 47, scope: !421)
!426 = !DILocation(line: 242, column: 45, scope: !421)
!427 = !DILocation(line: 242, column: 15, scope: !421)
!428 = !DILocation(line: 243, column: 22, scope: !421)
!429 = !DILocation(line: 243, column: 6, scope: !421)
!430 = !DILocation(line: 243, column: 18, scope: !421)
!431 = !DILocation(line: 244, column: 16, scope: !421)
!432 = !DILocation(line: 244, column: 14, scope: !421)
!433 = !DILocation(line: 244, column: 5, scope: !421)
!434 = distinct !DISubprogram(name: "rep_clz", scope: !411, file: !411, line: 69, type: !178, isLocal: true, isDefinition: true, scopeLine: 69, flags: DIFlagPrototyped, isOptimized: false, unit: !0, retainedNodes: !2)
!435 = !DILocation(line: 73, column: 9, scope: !434)
!436 = !DILocation(line: 73, column: 11, scope: !434)
!437 = !DILocation(line: 74, column: 30, scope: !434)
!438 = !DILocation(line: 74, column: 32, scope: !434)
!439 = !DILocation(line: 74, column: 16, scope: !434)
!440 = !DILocation(line: 74, column: 9, scope: !434)
!441 = !DILocation(line: 76, column: 35, scope: !434)
!442 = !DILocation(line: 76, column: 37, scope: !434)
!443 = !DILocation(line: 76, column: 21, scope: !434)
!444 = !DILocation(line: 76, column: 19, scope: !434)
!445 = !DILocation(line: 76, column: 9, scope: !434)
!446 = !DILocation(line: 78, column: 1, scope: !434)
!447 = distinct !DISubprogram(name: "__addsf3", scope: !4, file: !4, line: 20, type: !178, isLocal: false, isDefinition: true, scopeLine: 20, flags: DIFlagPrototyped, isOptimized: false, unit: !3, retainedNodes: !2)
!448 = !DILocation(line: 21, column: 23, scope: !447)
!449 = !DILocation(line: 21, column: 26, scope: !447)
!450 = !DILocation(line: 21, column: 12, scope: !447)
!451 = !DILocation(line: 21, column: 5, scope: !447)
!452 = distinct !DISubprogram(name: "__addXf3__", scope: !184, file: !184, line: 17, type: !178, isLocal: true, isDefinition: true, scopeLine: 17, flags: DIFlagPrototyped, isOptimized: false, unit: !3, retainedNodes: !2)
!453 = !DILocation(line: 18, column: 24, scope: !452)
!454 = !DILocation(line: 18, column: 18, scope: !452)
!455 = !DILocation(line: 18, column: 11, scope: !452)
!456 = !DILocation(line: 19, column: 24, scope: !452)
!457 = !DILocation(line: 19, column: 18, scope: !452)
!458 = !DILocation(line: 19, column: 11, scope: !452)
!459 = !DILocation(line: 20, column: 24, scope: !452)
!460 = !DILocation(line: 20, column: 29, scope: !452)
!461 = !DILocation(line: 20, column: 17, scope: !452)
!462 = !DILocation(line: 21, column: 24, scope: !452)
!463 = !DILocation(line: 21, column: 29, scope: !452)
!464 = !DILocation(line: 21, column: 17, scope: !452)
!465 = !DILocation(line: 24, column: 9, scope: !452)
!466 = !DILocation(line: 24, column: 14, scope: !452)
!467 = !DILocation(line: 24, column: 25, scope: !452)
!468 = !DILocation(line: 24, column: 46, scope: !452)
!469 = !DILocation(line: 25, column: 9, scope: !452)
!470 = !DILocation(line: 25, column: 14, scope: !452)
!471 = !DILocation(line: 25, column: 25, scope: !452)
!472 = !DILocation(line: 27, column: 13, scope: !452)
!473 = !DILocation(line: 27, column: 18, scope: !452)
!474 = !DILocation(line: 27, column: 49, scope: !452)
!475 = !DILocation(line: 27, column: 43, scope: !452)
!476 = !DILocation(line: 27, column: 52, scope: !452)
!477 = !DILocation(line: 27, column: 35, scope: !452)
!478 = !DILocation(line: 27, column: 28, scope: !452)
!479 = !DILocation(line: 29, column: 13, scope: !452)
!480 = !DILocation(line: 29, column: 18, scope: !452)
!481 = !DILocation(line: 29, column: 49, scope: !452)
!482 = !DILocation(line: 29, column: 43, scope: !452)
!483 = !DILocation(line: 29, column: 52, scope: !452)
!484 = !DILocation(line: 29, column: 35, scope: !452)
!485 = !DILocation(line: 29, column: 28, scope: !452)
!486 = !DILocation(line: 31, column: 13, scope: !452)
!487 = !DILocation(line: 31, column: 18, scope: !452)
!488 = !DILocation(line: 33, column: 24, scope: !452)
!489 = !DILocation(line: 33, column: 18, scope: !452)
!490 = !DILocation(line: 33, column: 35, scope: !452)
!491 = !DILocation(line: 33, column: 29, scope: !452)
!492 = !DILocation(line: 33, column: 27, scope: !452)
!493 = !DILocation(line: 33, column: 39, scope: !452)
!494 = !DILocation(line: 33, column: 17, scope: !452)
!495 = !DILocation(line: 33, column: 58, scope: !452)
!496 = !DILocation(line: 33, column: 51, scope: !452)
!497 = !DILocation(line: 35, column: 25, scope: !452)
!498 = !DILocation(line: 35, column: 18, scope: !452)
!499 = !DILocation(line: 39, column: 13, scope: !452)
!500 = !DILocation(line: 39, column: 18, scope: !452)
!501 = !DILocation(line: 39, column: 36, scope: !452)
!502 = !DILocation(line: 39, column: 29, scope: !452)
!503 = !DILocation(line: 42, column: 14, scope: !452)
!504 = !DILocation(line: 42, column: 13, scope: !452)
!505 = !DILocation(line: 44, column: 18, scope: !452)
!506 = !DILocation(line: 44, column: 17, scope: !452)
!507 = !DILocation(line: 44, column: 45, scope: !452)
!508 = !DILocation(line: 44, column: 39, scope: !452)
!509 = !DILocation(line: 44, column: 56, scope: !452)
!510 = !DILocation(line: 44, column: 50, scope: !452)
!511 = !DILocation(line: 44, column: 48, scope: !452)
!512 = !DILocation(line: 44, column: 31, scope: !452)
!513 = !DILocation(line: 44, column: 24, scope: !452)
!514 = !DILocation(line: 45, column: 25, scope: !452)
!515 = !DILocation(line: 45, column: 18, scope: !452)
!516 = !DILocation(line: 49, column: 14, scope: !452)
!517 = !DILocation(line: 49, column: 13, scope: !452)
!518 = !DILocation(line: 49, column: 27, scope: !452)
!519 = !DILocation(line: 49, column: 20, scope: !452)
!520 = !DILocation(line: 50, column: 5, scope: !452)
!521 = !DILocation(line: 53, column: 9, scope: !452)
!522 = !DILocation(line: 53, column: 16, scope: !452)
!523 = !DILocation(line: 53, column: 14, scope: !452)
!524 = !DILocation(line: 54, column: 28, scope: !452)
!525 = !DILocation(line: 54, column: 21, scope: !452)
!526 = !DILocation(line: 55, column: 16, scope: !452)
!527 = !DILocation(line: 55, column: 14, scope: !452)
!528 = !DILocation(line: 56, column: 16, scope: !452)
!529 = !DILocation(line: 56, column: 14, scope: !452)
!530 = !DILocation(line: 57, column: 5, scope: !452)
!531 = !DILocation(line: 60, column: 21, scope: !452)
!532 = !DILocation(line: 60, column: 26, scope: !452)
!533 = !DILocation(line: 60, column: 45, scope: !452)
!534 = !DILocation(line: 60, column: 9, scope: !452)
!535 = !DILocation(line: 61, column: 21, scope: !452)
!536 = !DILocation(line: 61, column: 26, scope: !452)
!537 = !DILocation(line: 61, column: 45, scope: !452)
!538 = !DILocation(line: 61, column: 9, scope: !452)
!539 = !DILocation(line: 62, column: 26, scope: !452)
!540 = !DILocation(line: 62, column: 31, scope: !452)
!541 = !DILocation(line: 62, column: 11, scope: !452)
!542 = !DILocation(line: 63, column: 26, scope: !452)
!543 = !DILocation(line: 63, column: 31, scope: !452)
!544 = !DILocation(line: 63, column: 11, scope: !452)
!545 = !DILocation(line: 66, column: 9, scope: !452)
!546 = !DILocation(line: 66, column: 19, scope: !452)
!547 = !DILocation(line: 66, column: 37, scope: !452)
!548 = !DILocation(line: 66, column: 35, scope: !452)
!549 = !DILocation(line: 66, column: 25, scope: !452)
!550 = !DILocation(line: 67, column: 9, scope: !452)
!551 = !DILocation(line: 67, column: 19, scope: !452)
!552 = !DILocation(line: 67, column: 37, scope: !452)
!553 = !DILocation(line: 67, column: 35, scope: !452)
!554 = !DILocation(line: 67, column: 25, scope: !452)
!555 = !DILocation(line: 71, column: 30, scope: !452)
!556 = !DILocation(line: 71, column: 35, scope: !452)
!557 = !DILocation(line: 71, column: 17, scope: !452)
!558 = !DILocation(line: 72, column: 31, scope: !452)
!559 = !DILocation(line: 72, column: 38, scope: !452)
!560 = !DILocation(line: 72, column: 36, scope: !452)
!561 = !DILocation(line: 72, column: 44, scope: !452)
!562 = !DILocation(line: 72, column: 30, scope: !452)
!563 = !DILocation(line: 72, column: 16, scope: !452)
!564 = !DILocation(line: 78, column: 21, scope: !452)
!565 = !DILocation(line: 78, column: 34, scope: !452)
!566 = !DILocation(line: 78, column: 49, scope: !452)
!567 = !DILocation(line: 78, column: 18, scope: !452)
!568 = !DILocation(line: 79, column: 21, scope: !452)
!569 = !DILocation(line: 79, column: 34, scope: !452)
!570 = !DILocation(line: 79, column: 49, scope: !452)
!571 = !DILocation(line: 79, column: 18, scope: !452)
!572 = !DILocation(line: 83, column: 32, scope: !452)
!573 = !DILocation(line: 83, column: 44, scope: !452)
!574 = !DILocation(line: 83, column: 42, scope: !452)
!575 = !DILocation(line: 83, column: 24, scope: !452)
!576 = !DILocation(line: 84, column: 9, scope: !452)
!577 = !DILocation(line: 85, column: 13, scope: !452)
!578 = !DILocation(line: 85, column: 19, scope: !452)
!579 = !DILocation(line: 86, column: 33, scope: !452)
!580 = !DILocation(line: 86, column: 62, scope: !452)
!581 = !DILocation(line: 86, column: 60, scope: !452)
!582 = !DILocation(line: 86, column: 46, scope: !452)
!583 = !DILocation(line: 86, column: 24, scope: !452)
!584 = !DILocation(line: 87, column: 28, scope: !452)
!585 = !DILocation(line: 87, column: 44, scope: !452)
!586 = !DILocation(line: 87, column: 41, scope: !452)
!587 = !DILocation(line: 87, column: 52, scope: !452)
!588 = !DILocation(line: 87, column: 50, scope: !452)
!589 = !DILocation(line: 87, column: 26, scope: !452)
!590 = !DILocation(line: 88, column: 9, scope: !452)
!591 = !DILocation(line: 89, column: 26, scope: !452)
!592 = !DILocation(line: 91, column: 5, scope: !452)
!593 = !DILocation(line: 92, column: 9, scope: !452)
!594 = !DILocation(line: 93, column: 25, scope: !452)
!595 = !DILocation(line: 93, column: 22, scope: !452)
!596 = !DILocation(line: 95, column: 13, scope: !452)
!597 = !DILocation(line: 95, column: 26, scope: !452)
!598 = !DILocation(line: 95, column: 39, scope: !452)
!599 = !DILocation(line: 95, column: 32, scope: !452)
!600 = !DILocation(line: 99, column: 13, scope: !452)
!601 = !DILocation(line: 99, column: 26, scope: !452)
!602 = !DILocation(line: 100, column: 39, scope: !452)
!603 = !DILocation(line: 100, column: 31, scope: !452)
!604 = !DILocation(line: 100, column: 55, scope: !452)
!605 = !DILocation(line: 100, column: 53, scope: !452)
!606 = !DILocation(line: 100, column: 23, scope: !452)
!607 = !DILocation(line: 101, column: 30, scope: !452)
!608 = !DILocation(line: 101, column: 26, scope: !452)
!609 = !DILocation(line: 102, column: 26, scope: !452)
!610 = !DILocation(line: 102, column: 23, scope: !452)
!611 = !DILocation(line: 103, column: 9, scope: !452)
!612 = !DILocation(line: 104, column: 5, scope: !452)
!613 = !DILocation(line: 106, column: 25, scope: !452)
!614 = !DILocation(line: 106, column: 22, scope: !452)
!615 = !DILocation(line: 110, column: 13, scope: !452)
!616 = !DILocation(line: 110, column: 26, scope: !452)
!617 = !DILocation(line: 111, column: 33, scope: !452)
!618 = !DILocation(line: 111, column: 46, scope: !452)
!619 = !DILocation(line: 111, column: 24, scope: !452)
!620 = !DILocation(line: 112, column: 28, scope: !452)
!621 = !DILocation(line: 112, column: 41, scope: !452)
!622 = !DILocation(line: 112, column: 48, scope: !452)
!623 = !DILocation(line: 112, column: 46, scope: !452)
!624 = !DILocation(line: 112, column: 26, scope: !452)
!625 = !DILocation(line: 113, column: 23, scope: !452)
!626 = !DILocation(line: 114, column: 9, scope: !452)
!627 = !DILocation(line: 118, column: 9, scope: !452)
!628 = !DILocation(line: 118, column: 19, scope: !452)
!629 = !DILocation(line: 118, column: 59, scope: !452)
!630 = !DILocation(line: 118, column: 57, scope: !452)
!631 = !DILocation(line: 118, column: 42, scope: !452)
!632 = !DILocation(line: 118, column: 35, scope: !452)
!633 = !DILocation(line: 120, column: 9, scope: !452)
!634 = !DILocation(line: 120, column: 19, scope: !452)
!635 = !DILocation(line: 123, column: 31, scope: !452)
!636 = !DILocation(line: 123, column: 29, scope: !452)
!637 = !DILocation(line: 123, column: 19, scope: !452)
!638 = !DILocation(line: 124, column: 29, scope: !452)
!639 = !DILocation(line: 124, column: 58, scope: !452)
!640 = !DILocation(line: 124, column: 56, scope: !452)
!641 = !DILocation(line: 124, column: 42, scope: !452)
!642 = !DILocation(line: 124, column: 20, scope: !452)
!643 = !DILocation(line: 125, column: 24, scope: !452)
!644 = !DILocation(line: 125, column: 40, scope: !452)
!645 = !DILocation(line: 125, column: 37, scope: !452)
!646 = !DILocation(line: 125, column: 48, scope: !452)
!647 = !DILocation(line: 125, column: 46, scope: !452)
!648 = !DILocation(line: 125, column: 22, scope: !452)
!649 = !DILocation(line: 126, column: 19, scope: !452)
!650 = !DILocation(line: 127, column: 5, scope: !452)
!651 = !DILocation(line: 130, column: 34, scope: !452)
!652 = !DILocation(line: 130, column: 47, scope: !452)
!653 = !DILocation(line: 130, column: 15, scope: !452)
!654 = !DILocation(line: 133, column: 20, scope: !452)
!655 = !DILocation(line: 133, column: 33, scope: !452)
!656 = !DILocation(line: 133, column: 38, scope: !452)
!657 = !DILocation(line: 133, column: 11, scope: !452)
!658 = !DILocation(line: 136, column: 22, scope: !452)
!659 = !DILocation(line: 136, column: 32, scope: !452)
!660 = !DILocation(line: 136, column: 12, scope: !452)
!661 = !DILocation(line: 137, column: 15, scope: !452)
!662 = !DILocation(line: 137, column: 12, scope: !452)
!663 = !DILocation(line: 141, column: 9, scope: !452)
!664 = !DILocation(line: 141, column: 26, scope: !452)
!665 = !DILocation(line: 141, column: 39, scope: !452)
!666 = !DILocation(line: 141, column: 33, scope: !452)
!667 = !DILocation(line: 142, column: 9, scope: !452)
!668 = !DILocation(line: 142, column: 26, scope: !452)
!669 = !DILocation(line: 142, column: 44, scope: !452)
!670 = !DILocation(line: 142, column: 51, scope: !452)
!671 = !DILocation(line: 142, column: 41, scope: !452)
!672 = !DILocation(line: 142, column: 34, scope: !452)
!673 = !DILocation(line: 143, column: 20, scope: !452)
!674 = !DILocation(line: 143, column: 12, scope: !452)
!675 = !DILocation(line: 143, column: 5, scope: !452)
!676 = !DILocation(line: 144, column: 1, scope: !452)
!677 = distinct !DISubprogram(name: "toRep", scope: !411, file: !411, line: 231, type: !178, isLocal: true, isDefinition: true, scopeLine: 231, flags: DIFlagPrototyped, isOptimized: false, unit: !3, retainedNodes: !2)
!678 = !DILocation(line: 232, column: 44, scope: !677)
!679 = !DILocation(line: 232, column: 50, scope: !677)
!680 = !DILocation(line: 233, column: 16, scope: !677)
!681 = !DILocation(line: 233, column: 5, scope: !677)
!682 = distinct !DISubprogram(name: "fromRep", scope: !411, file: !411, line: 236, type: !178, isLocal: true, isDefinition: true, scopeLine: 236, flags: DIFlagPrototyped, isOptimized: false, unit: !3, retainedNodes: !2)
!683 = !DILocation(line: 237, column: 44, scope: !682)
!684 = !DILocation(line: 237, column: 50, scope: !682)
!685 = !DILocation(line: 238, column: 16, scope: !682)
!686 = !DILocation(line: 238, column: 5, scope: !682)
!687 = distinct !DISubprogram(name: "normalize", scope: !411, file: !411, line: 241, type: !178, isLocal: true, isDefinition: true, scopeLine: 241, flags: DIFlagPrototyped, isOptimized: false, unit: !3, retainedNodes: !2)
!688 = !DILocation(line: 242, column: 32, scope: !687)
!689 = !DILocation(line: 242, column: 31, scope: !687)
!690 = !DILocation(line: 242, column: 23, scope: !687)
!691 = !DILocation(line: 242, column: 47, scope: !687)
!692 = !DILocation(line: 242, column: 45, scope: !687)
!693 = !DILocation(line: 242, column: 15, scope: !687)
!694 = !DILocation(line: 243, column: 22, scope: !687)
!695 = !DILocation(line: 243, column: 6, scope: !687)
!696 = !DILocation(line: 243, column: 18, scope: !687)
!697 = !DILocation(line: 244, column: 16, scope: !687)
!698 = !DILocation(line: 244, column: 14, scope: !687)
!699 = !DILocation(line: 244, column: 5, scope: !687)
!700 = distinct !DISubprogram(name: "rep_clz", scope: !411, file: !411, line: 49, type: !178, isLocal: true, isDefinition: true, scopeLine: 49, flags: DIFlagPrototyped, isOptimized: false, unit: !3, retainedNodes: !2)
!701 = !DILocation(line: 50, column: 26, scope: !700)
!702 = !DILocation(line: 50, column: 12, scope: !700)
!703 = !DILocation(line: 50, column: 5, scope: !700)
!704 = distinct !DISubprogram(name: "__ledf2", scope: !8, file: !8, line: 51, type: !178, isLocal: false, isDefinition: true, scopeLine: 51, flags: DIFlagPrototyped, isOptimized: false, unit: !7, retainedNodes: !2)
!705 = !DILocation(line: 53, column: 31, scope: !704)
!706 = !DILocation(line: 53, column: 25, scope: !704)
!707 = !DILocation(line: 53, column: 18, scope: !704)
!708 = !DILocation(line: 54, column: 31, scope: !704)
!709 = !DILocation(line: 54, column: 25, scope: !704)
!710 = !DILocation(line: 54, column: 18, scope: !704)
!711 = !DILocation(line: 55, column: 24, scope: !704)
!712 = !DILocation(line: 55, column: 29, scope: !704)
!713 = !DILocation(line: 55, column: 17, scope: !704)
!714 = !DILocation(line: 56, column: 24, scope: !704)
!715 = !DILocation(line: 56, column: 29, scope: !704)
!716 = !DILocation(line: 56, column: 17, scope: !704)
!717 = !DILocation(line: 59, column: 9, scope: !704)
!718 = !DILocation(line: 59, column: 14, scope: !704)
!719 = !DILocation(line: 59, column: 23, scope: !704)
!720 = !DILocation(line: 59, column: 26, scope: !704)
!721 = !DILocation(line: 59, column: 31, scope: !704)
!722 = !DILocation(line: 59, column: 41, scope: !704)
!723 = !DILocation(line: 62, column: 10, scope: !704)
!724 = !DILocation(line: 62, column: 17, scope: !704)
!725 = !DILocation(line: 62, column: 15, scope: !704)
!726 = !DILocation(line: 62, column: 23, scope: !704)
!727 = !DILocation(line: 62, column: 9, scope: !704)
!728 = !DILocation(line: 62, column: 29, scope: !704)
!729 = !DILocation(line: 66, column: 10, scope: !704)
!730 = !DILocation(line: 66, column: 17, scope: !704)
!731 = !DILocation(line: 66, column: 15, scope: !704)
!732 = !DILocation(line: 66, column: 23, scope: !704)
!733 = !DILocation(line: 66, column: 9, scope: !704)
!734 = !DILocation(line: 67, column: 13, scope: !704)
!735 = !DILocation(line: 67, column: 20, scope: !704)
!736 = !DILocation(line: 67, column: 18, scope: !704)
!737 = !DILocation(line: 67, column: 26, scope: !704)
!738 = !DILocation(line: 68, column: 18, scope: !704)
!739 = !DILocation(line: 68, column: 26, scope: !704)
!740 = !DILocation(line: 68, column: 23, scope: !704)
!741 = !DILocation(line: 68, column: 32, scope: !704)
!742 = !DILocation(line: 69, column: 14, scope: !704)
!743 = !DILocation(line: 77, column: 13, scope: !704)
!744 = !DILocation(line: 77, column: 20, scope: !704)
!745 = !DILocation(line: 77, column: 18, scope: !704)
!746 = !DILocation(line: 77, column: 26, scope: !704)
!747 = !DILocation(line: 78, column: 18, scope: !704)
!748 = !DILocation(line: 78, column: 26, scope: !704)
!749 = !DILocation(line: 78, column: 23, scope: !704)
!750 = !DILocation(line: 78, column: 32, scope: !704)
!751 = !DILocation(line: 79, column: 14, scope: !704)
!752 = !DILocation(line: 81, column: 1, scope: !704)
!753 = distinct !DISubprogram(name: "toRep", scope: !411, file: !411, line: 231, type: !178, isLocal: true, isDefinition: true, scopeLine: 231, flags: DIFlagPrototyped, isOptimized: false, unit: !7, retainedNodes: !2)
!754 = !DILocation(line: 232, column: 44, scope: !753)
!755 = !DILocation(line: 232, column: 50, scope: !753)
!756 = !DILocation(line: 233, column: 16, scope: !753)
!757 = !DILocation(line: 233, column: 5, scope: !753)
!758 = distinct !DISubprogram(name: "__gedf2", scope: !8, file: !8, line: 96, type: !178, isLocal: false, isDefinition: true, scopeLine: 96, flags: DIFlagPrototyped, isOptimized: false, unit: !7, retainedNodes: !2)
!759 = !DILocation(line: 98, column: 31, scope: !758)
!760 = !DILocation(line: 98, column: 25, scope: !758)
!761 = !DILocation(line: 98, column: 18, scope: !758)
!762 = !DILocation(line: 99, column: 31, scope: !758)
!763 = !DILocation(line: 99, column: 25, scope: !758)
!764 = !DILocation(line: 99, column: 18, scope: !758)
!765 = !DILocation(line: 100, column: 24, scope: !758)
!766 = !DILocation(line: 100, column: 29, scope: !758)
!767 = !DILocation(line: 100, column: 17, scope: !758)
!768 = !DILocation(line: 101, column: 24, scope: !758)
!769 = !DILocation(line: 101, column: 29, scope: !758)
!770 = !DILocation(line: 101, column: 17, scope: !758)
!771 = !DILocation(line: 103, column: 9, scope: !758)
!772 = !DILocation(line: 103, column: 14, scope: !758)
!773 = !DILocation(line: 103, column: 23, scope: !758)
!774 = !DILocation(line: 103, column: 26, scope: !758)
!775 = !DILocation(line: 103, column: 31, scope: !758)
!776 = !DILocation(line: 103, column: 41, scope: !758)
!777 = !DILocation(line: 104, column: 10, scope: !758)
!778 = !DILocation(line: 104, column: 17, scope: !758)
!779 = !DILocation(line: 104, column: 15, scope: !758)
!780 = !DILocation(line: 104, column: 23, scope: !758)
!781 = !DILocation(line: 104, column: 9, scope: !758)
!782 = !DILocation(line: 104, column: 29, scope: !758)
!783 = !DILocation(line: 105, column: 10, scope: !758)
!784 = !DILocation(line: 105, column: 17, scope: !758)
!785 = !DILocation(line: 105, column: 15, scope: !758)
!786 = !DILocation(line: 105, column: 23, scope: !758)
!787 = !DILocation(line: 105, column: 9, scope: !758)
!788 = !DILocation(line: 106, column: 13, scope: !758)
!789 = !DILocation(line: 106, column: 20, scope: !758)
!790 = !DILocation(line: 106, column: 18, scope: !758)
!791 = !DILocation(line: 106, column: 26, scope: !758)
!792 = !DILocation(line: 107, column: 18, scope: !758)
!793 = !DILocation(line: 107, column: 26, scope: !758)
!794 = !DILocation(line: 107, column: 23, scope: !758)
!795 = !DILocation(line: 107, column: 32, scope: !758)
!796 = !DILocation(line: 108, column: 14, scope: !758)
!797 = !DILocation(line: 110, column: 13, scope: !758)
!798 = !DILocation(line: 110, column: 20, scope: !758)
!799 = !DILocation(line: 110, column: 18, scope: !758)
!800 = !DILocation(line: 110, column: 26, scope: !758)
!801 = !DILocation(line: 111, column: 18, scope: !758)
!802 = !DILocation(line: 111, column: 26, scope: !758)
!803 = !DILocation(line: 111, column: 23, scope: !758)
!804 = !DILocation(line: 111, column: 32, scope: !758)
!805 = !DILocation(line: 112, column: 14, scope: !758)
!806 = !DILocation(line: 114, column: 1, scope: !758)
!807 = distinct !DISubprogram(name: "__unorddf2", scope: !8, file: !8, line: 119, type: !178, isLocal: false, isDefinition: true, scopeLine: 119, flags: DIFlagPrototyped, isOptimized: false, unit: !7, retainedNodes: !2)
!808 = !DILocation(line: 120, column: 30, scope: !807)
!809 = !DILocation(line: 120, column: 24, scope: !807)
!810 = !DILocation(line: 120, column: 33, scope: !807)
!811 = !DILocation(line: 120, column: 17, scope: !807)
!812 = !DILocation(line: 121, column: 30, scope: !807)
!813 = !DILocation(line: 121, column: 24, scope: !807)
!814 = !DILocation(line: 121, column: 33, scope: !807)
!815 = !DILocation(line: 121, column: 17, scope: !807)
!816 = !DILocation(line: 122, column: 12, scope: !807)
!817 = !DILocation(line: 122, column: 17, scope: !807)
!818 = !DILocation(line: 122, column: 26, scope: !807)
!819 = !DILocation(line: 122, column: 29, scope: !807)
!820 = !DILocation(line: 122, column: 34, scope: !807)
!821 = !DILocation(line: 122, column: 5, scope: !807)
!822 = distinct !DISubprogram(name: "__eqdf2", scope: !8, file: !8, line: 128, type: !178, isLocal: false, isDefinition: true, scopeLine: 128, flags: DIFlagPrototyped, isOptimized: false, unit: !7, retainedNodes: !2)
!823 = !DILocation(line: 129, column: 20, scope: !822)
!824 = !DILocation(line: 129, column: 23, scope: !822)
!825 = !DILocation(line: 129, column: 12, scope: !822)
!826 = !DILocation(line: 129, column: 5, scope: !822)
!827 = distinct !DISubprogram(name: "__ltdf2", scope: !8, file: !8, line: 133, type: !178, isLocal: false, isDefinition: true, scopeLine: 133, flags: DIFlagPrototyped, isOptimized: false, unit: !7, retainedNodes: !2)
!828 = !DILocation(line: 134, column: 20, scope: !827)
!829 = !DILocation(line: 134, column: 23, scope: !827)
!830 = !DILocation(line: 134, column: 12, scope: !827)
!831 = !DILocation(line: 134, column: 5, scope: !827)
!832 = distinct !DISubprogram(name: "__nedf2", scope: !8, file: !8, line: 138, type: !178, isLocal: false, isDefinition: true, scopeLine: 138, flags: DIFlagPrototyped, isOptimized: false, unit: !7, retainedNodes: !2)
!833 = !DILocation(line: 139, column: 20, scope: !832)
!834 = !DILocation(line: 139, column: 23, scope: !832)
!835 = !DILocation(line: 139, column: 12, scope: !832)
!836 = !DILocation(line: 139, column: 5, scope: !832)
!837 = distinct !DISubprogram(name: "__gtdf2", scope: !8, file: !8, line: 143, type: !178, isLocal: false, isDefinition: true, scopeLine: 143, flags: DIFlagPrototyped, isOptimized: false, unit: !7, retainedNodes: !2)
!838 = !DILocation(line: 144, column: 20, scope: !837)
!839 = !DILocation(line: 144, column: 23, scope: !837)
!840 = !DILocation(line: 144, column: 12, scope: !837)
!841 = !DILocation(line: 144, column: 5, scope: !837)
!842 = distinct !DISubprogram(name: "__lesf2", scope: !10, file: !10, line: 51, type: !178, isLocal: false, isDefinition: true, scopeLine: 51, flags: DIFlagPrototyped, isOptimized: false, unit: !9, retainedNodes: !2)
!843 = !DILocation(line: 53, column: 31, scope: !842)
!844 = !DILocation(line: 53, column: 25, scope: !842)
!845 = !DILocation(line: 53, column: 18, scope: !842)
!846 = !DILocation(line: 54, column: 31, scope: !842)
!847 = !DILocation(line: 54, column: 25, scope: !842)
!848 = !DILocation(line: 54, column: 18, scope: !842)
!849 = !DILocation(line: 55, column: 24, scope: !842)
!850 = !DILocation(line: 55, column: 29, scope: !842)
!851 = !DILocation(line: 55, column: 17, scope: !842)
!852 = !DILocation(line: 56, column: 24, scope: !842)
!853 = !DILocation(line: 56, column: 29, scope: !842)
!854 = !DILocation(line: 56, column: 17, scope: !842)
!855 = !DILocation(line: 59, column: 9, scope: !842)
!856 = !DILocation(line: 59, column: 14, scope: !842)
!857 = !DILocation(line: 59, column: 23, scope: !842)
!858 = !DILocation(line: 59, column: 26, scope: !842)
!859 = !DILocation(line: 59, column: 31, scope: !842)
!860 = !DILocation(line: 59, column: 41, scope: !842)
!861 = !DILocation(line: 62, column: 10, scope: !842)
!862 = !DILocation(line: 62, column: 17, scope: !842)
!863 = !DILocation(line: 62, column: 15, scope: !842)
!864 = !DILocation(line: 62, column: 23, scope: !842)
!865 = !DILocation(line: 62, column: 9, scope: !842)
!866 = !DILocation(line: 62, column: 29, scope: !842)
!867 = !DILocation(line: 66, column: 10, scope: !842)
!868 = !DILocation(line: 66, column: 17, scope: !842)
!869 = !DILocation(line: 66, column: 15, scope: !842)
!870 = !DILocation(line: 66, column: 23, scope: !842)
!871 = !DILocation(line: 66, column: 9, scope: !842)
!872 = !DILocation(line: 67, column: 13, scope: !842)
!873 = !DILocation(line: 67, column: 20, scope: !842)
!874 = !DILocation(line: 67, column: 18, scope: !842)
!875 = !DILocation(line: 67, column: 26, scope: !842)
!876 = !DILocation(line: 68, column: 18, scope: !842)
!877 = !DILocation(line: 68, column: 26, scope: !842)
!878 = !DILocation(line: 68, column: 23, scope: !842)
!879 = !DILocation(line: 68, column: 32, scope: !842)
!880 = !DILocation(line: 69, column: 14, scope: !842)
!881 = !DILocation(line: 77, column: 13, scope: !842)
!882 = !DILocation(line: 77, column: 20, scope: !842)
!883 = !DILocation(line: 77, column: 18, scope: !842)
!884 = !DILocation(line: 77, column: 26, scope: !842)
!885 = !DILocation(line: 78, column: 18, scope: !842)
!886 = !DILocation(line: 78, column: 26, scope: !842)
!887 = !DILocation(line: 78, column: 23, scope: !842)
!888 = !DILocation(line: 78, column: 32, scope: !842)
!889 = !DILocation(line: 79, column: 14, scope: !842)
!890 = !DILocation(line: 81, column: 1, scope: !842)
!891 = distinct !DISubprogram(name: "toRep", scope: !411, file: !411, line: 231, type: !178, isLocal: true, isDefinition: true, scopeLine: 231, flags: DIFlagPrototyped, isOptimized: false, unit: !9, retainedNodes: !2)
!892 = !DILocation(line: 232, column: 44, scope: !891)
!893 = !DILocation(line: 232, column: 50, scope: !891)
!894 = !DILocation(line: 233, column: 16, scope: !891)
!895 = !DILocation(line: 233, column: 5, scope: !891)
!896 = distinct !DISubprogram(name: "__gesf2", scope: !10, file: !10, line: 96, type: !178, isLocal: false, isDefinition: true, scopeLine: 96, flags: DIFlagPrototyped, isOptimized: false, unit: !9, retainedNodes: !2)
!897 = !DILocation(line: 98, column: 31, scope: !896)
!898 = !DILocation(line: 98, column: 25, scope: !896)
!899 = !DILocation(line: 98, column: 18, scope: !896)
!900 = !DILocation(line: 99, column: 31, scope: !896)
!901 = !DILocation(line: 99, column: 25, scope: !896)
!902 = !DILocation(line: 99, column: 18, scope: !896)
!903 = !DILocation(line: 100, column: 24, scope: !896)
!904 = !DILocation(line: 100, column: 29, scope: !896)
!905 = !DILocation(line: 100, column: 17, scope: !896)
!906 = !DILocation(line: 101, column: 24, scope: !896)
!907 = !DILocation(line: 101, column: 29, scope: !896)
!908 = !DILocation(line: 101, column: 17, scope: !896)
!909 = !DILocation(line: 103, column: 9, scope: !896)
!910 = !DILocation(line: 103, column: 14, scope: !896)
!911 = !DILocation(line: 103, column: 23, scope: !896)
!912 = !DILocation(line: 103, column: 26, scope: !896)
!913 = !DILocation(line: 103, column: 31, scope: !896)
!914 = !DILocation(line: 103, column: 41, scope: !896)
!915 = !DILocation(line: 104, column: 10, scope: !896)
!916 = !DILocation(line: 104, column: 17, scope: !896)
!917 = !DILocation(line: 104, column: 15, scope: !896)
!918 = !DILocation(line: 104, column: 23, scope: !896)
!919 = !DILocation(line: 104, column: 9, scope: !896)
!920 = !DILocation(line: 104, column: 29, scope: !896)
!921 = !DILocation(line: 105, column: 10, scope: !896)
!922 = !DILocation(line: 105, column: 17, scope: !896)
!923 = !DILocation(line: 105, column: 15, scope: !896)
!924 = !DILocation(line: 105, column: 23, scope: !896)
!925 = !DILocation(line: 105, column: 9, scope: !896)
!926 = !DILocation(line: 106, column: 13, scope: !896)
!927 = !DILocation(line: 106, column: 20, scope: !896)
!928 = !DILocation(line: 106, column: 18, scope: !896)
!929 = !DILocation(line: 106, column: 26, scope: !896)
!930 = !DILocation(line: 107, column: 18, scope: !896)
!931 = !DILocation(line: 107, column: 26, scope: !896)
!932 = !DILocation(line: 107, column: 23, scope: !896)
!933 = !DILocation(line: 107, column: 32, scope: !896)
!934 = !DILocation(line: 108, column: 14, scope: !896)
!935 = !DILocation(line: 110, column: 13, scope: !896)
!936 = !DILocation(line: 110, column: 20, scope: !896)
!937 = !DILocation(line: 110, column: 18, scope: !896)
!938 = !DILocation(line: 110, column: 26, scope: !896)
!939 = !DILocation(line: 111, column: 18, scope: !896)
!940 = !DILocation(line: 111, column: 26, scope: !896)
!941 = !DILocation(line: 111, column: 23, scope: !896)
!942 = !DILocation(line: 111, column: 32, scope: !896)
!943 = !DILocation(line: 112, column: 14, scope: !896)
!944 = !DILocation(line: 114, column: 1, scope: !896)
!945 = distinct !DISubprogram(name: "__unordsf2", scope: !10, file: !10, line: 119, type: !178, isLocal: false, isDefinition: true, scopeLine: 119, flags: DIFlagPrototyped, isOptimized: false, unit: !9, retainedNodes: !2)
!946 = !DILocation(line: 120, column: 30, scope: !945)
!947 = !DILocation(line: 120, column: 24, scope: !945)
!948 = !DILocation(line: 120, column: 33, scope: !945)
!949 = !DILocation(line: 120, column: 17, scope: !945)
!950 = !DILocation(line: 121, column: 30, scope: !945)
!951 = !DILocation(line: 121, column: 24, scope: !945)
!952 = !DILocation(line: 121, column: 33, scope: !945)
!953 = !DILocation(line: 121, column: 17, scope: !945)
!954 = !DILocation(line: 122, column: 12, scope: !945)
!955 = !DILocation(line: 122, column: 17, scope: !945)
!956 = !DILocation(line: 122, column: 26, scope: !945)
!957 = !DILocation(line: 122, column: 29, scope: !945)
!958 = !DILocation(line: 122, column: 34, scope: !945)
!959 = !DILocation(line: 122, column: 5, scope: !945)
!960 = distinct !DISubprogram(name: "__eqsf2", scope: !10, file: !10, line: 128, type: !178, isLocal: false, isDefinition: true, scopeLine: 128, flags: DIFlagPrototyped, isOptimized: false, unit: !9, retainedNodes: !2)
!961 = !DILocation(line: 129, column: 20, scope: !960)
!962 = !DILocation(line: 129, column: 23, scope: !960)
!963 = !DILocation(line: 129, column: 12, scope: !960)
!964 = !DILocation(line: 129, column: 5, scope: !960)
!965 = distinct !DISubprogram(name: "__ltsf2", scope: !10, file: !10, line: 133, type: !178, isLocal: false, isDefinition: true, scopeLine: 133, flags: DIFlagPrototyped, isOptimized: false, unit: !9, retainedNodes: !2)
!966 = !DILocation(line: 134, column: 20, scope: !965)
!967 = !DILocation(line: 134, column: 23, scope: !965)
!968 = !DILocation(line: 134, column: 12, scope: !965)
!969 = !DILocation(line: 134, column: 5, scope: !965)
!970 = distinct !DISubprogram(name: "__nesf2", scope: !10, file: !10, line: 138, type: !178, isLocal: false, isDefinition: true, scopeLine: 138, flags: DIFlagPrototyped, isOptimized: false, unit: !9, retainedNodes: !2)
!971 = !DILocation(line: 139, column: 20, scope: !970)
!972 = !DILocation(line: 139, column: 23, scope: !970)
!973 = !DILocation(line: 139, column: 12, scope: !970)
!974 = !DILocation(line: 139, column: 5, scope: !970)
!975 = distinct !DISubprogram(name: "__gtsf2", scope: !10, file: !10, line: 143, type: !178, isLocal: false, isDefinition: true, scopeLine: 143, flags: DIFlagPrototyped, isOptimized: false, unit: !9, retainedNodes: !2)
!976 = !DILocation(line: 144, column: 20, scope: !975)
!977 = !DILocation(line: 144, column: 23, scope: !975)
!978 = !DILocation(line: 144, column: 12, scope: !975)
!979 = !DILocation(line: 144, column: 5, scope: !975)
!980 = distinct !DISubprogram(name: "__divdf3", scope: !14, file: !14, line: 25, type: !178, isLocal: false, isDefinition: true, scopeLine: 25, flags: DIFlagPrototyped, isOptimized: false, unit: !13, retainedNodes: !2)
!981 = !DILocation(line: 27, column: 42, scope: !980)
!982 = !DILocation(line: 27, column: 36, scope: !980)
!983 = !DILocation(line: 27, column: 45, scope: !980)
!984 = !DILocation(line: 27, column: 64, scope: !980)
!985 = !DILocation(line: 27, column: 24, scope: !980)
!986 = !DILocation(line: 28, column: 42, scope: !980)
!987 = !DILocation(line: 28, column: 36, scope: !980)
!988 = !DILocation(line: 28, column: 45, scope: !980)
!989 = !DILocation(line: 28, column: 64, scope: !980)
!990 = !DILocation(line: 28, column: 24, scope: !980)
!991 = !DILocation(line: 29, column: 39, scope: !980)
!992 = !DILocation(line: 29, column: 33, scope: !980)
!993 = !DILocation(line: 29, column: 50, scope: !980)
!994 = !DILocation(line: 29, column: 44, scope: !980)
!995 = !DILocation(line: 29, column: 42, scope: !980)
!996 = !DILocation(line: 29, column: 54, scope: !980)
!997 = !DILocation(line: 29, column: 17, scope: !980)
!998 = !DILocation(line: 31, column: 32, scope: !980)
!999 = !DILocation(line: 31, column: 26, scope: !980)
!1000 = !DILocation(line: 31, column: 35, scope: !980)
!1001 = !DILocation(line: 31, column: 11, scope: !980)
!1002 = !DILocation(line: 32, column: 32, scope: !980)
!1003 = !DILocation(line: 32, column: 26, scope: !980)
!1004 = !DILocation(line: 32, column: 35, scope: !980)
!1005 = !DILocation(line: 32, column: 11, scope: !980)
!1006 = !DILocation(line: 33, column: 9, scope: !980)
!1007 = !DILocation(line: 36, column: 9, scope: !980)
!1008 = !DILocation(line: 36, column: 18, scope: !980)
!1009 = !DILocation(line: 36, column: 22, scope: !980)
!1010 = !DILocation(line: 36, column: 40, scope: !980)
!1011 = !DILocation(line: 36, column: 43, scope: !980)
!1012 = !DILocation(line: 36, column: 52, scope: !980)
!1013 = !DILocation(line: 36, column: 56, scope: !980)
!1014 = !DILocation(line: 38, column: 34, scope: !980)
!1015 = !DILocation(line: 38, column: 28, scope: !980)
!1016 = !DILocation(line: 38, column: 37, scope: !980)
!1017 = !DILocation(line: 38, column: 21, scope: !980)
!1018 = !DILocation(line: 39, column: 34, scope: !980)
!1019 = !DILocation(line: 39, column: 28, scope: !980)
!1020 = !DILocation(line: 39, column: 37, scope: !980)
!1021 = !DILocation(line: 39, column: 21, scope: !980)
!1022 = !DILocation(line: 42, column: 13, scope: !980)
!1023 = !DILocation(line: 42, column: 18, scope: !980)
!1024 = !DILocation(line: 42, column: 49, scope: !980)
!1025 = !DILocation(line: 42, column: 43, scope: !980)
!1026 = !DILocation(line: 42, column: 52, scope: !980)
!1027 = !DILocation(line: 42, column: 35, scope: !980)
!1028 = !DILocation(line: 42, column: 28, scope: !980)
!1029 = !DILocation(line: 44, column: 13, scope: !980)
!1030 = !DILocation(line: 44, column: 18, scope: !980)
!1031 = !DILocation(line: 44, column: 49, scope: !980)
!1032 = !DILocation(line: 44, column: 43, scope: !980)
!1033 = !DILocation(line: 44, column: 52, scope: !980)
!1034 = !DILocation(line: 44, column: 35, scope: !980)
!1035 = !DILocation(line: 44, column: 28, scope: !980)
!1036 = !DILocation(line: 46, column: 13, scope: !980)
!1037 = !DILocation(line: 46, column: 18, scope: !980)
!1038 = !DILocation(line: 48, column: 17, scope: !980)
!1039 = !DILocation(line: 48, column: 22, scope: !980)
!1040 = !DILocation(line: 48, column: 40, scope: !980)
!1041 = !DILocation(line: 48, column: 33, scope: !980)
!1042 = !DILocation(line: 50, column: 33, scope: !980)
!1043 = !DILocation(line: 50, column: 40, scope: !980)
!1044 = !DILocation(line: 50, column: 38, scope: !980)
!1045 = !DILocation(line: 50, column: 25, scope: !980)
!1046 = !DILocation(line: 50, column: 18, scope: !980)
!1047 = !DILocation(line: 54, column: 13, scope: !980)
!1048 = !DILocation(line: 54, column: 18, scope: !980)
!1049 = !DILocation(line: 54, column: 44, scope: !980)
!1050 = !DILocation(line: 54, column: 36, scope: !980)
!1051 = !DILocation(line: 54, column: 29, scope: !980)
!1052 = !DILocation(line: 56, column: 14, scope: !980)
!1053 = !DILocation(line: 56, column: 13, scope: !980)
!1054 = !DILocation(line: 58, column: 18, scope: !980)
!1055 = !DILocation(line: 58, column: 17, scope: !980)
!1056 = !DILocation(line: 58, column: 31, scope: !980)
!1057 = !DILocation(line: 58, column: 24, scope: !980)
!1058 = !DILocation(line: 60, column: 33, scope: !980)
!1059 = !DILocation(line: 60, column: 25, scope: !980)
!1060 = !DILocation(line: 60, column: 18, scope: !980)
!1061 = !DILocation(line: 63, column: 14, scope: !980)
!1062 = !DILocation(line: 63, column: 13, scope: !980)
!1063 = !DILocation(line: 63, column: 44, scope: !980)
!1064 = !DILocation(line: 63, column: 42, scope: !980)
!1065 = !DILocation(line: 63, column: 27, scope: !980)
!1066 = !DILocation(line: 63, column: 20, scope: !980)
!1067 = !DILocation(line: 68, column: 13, scope: !980)
!1068 = !DILocation(line: 68, column: 18, scope: !980)
!1069 = !DILocation(line: 68, column: 42, scope: !980)
!1070 = !DILocation(line: 68, column: 39, scope: !980)
!1071 = !DILocation(line: 68, column: 33, scope: !980)
!1072 = !DILocation(line: 69, column: 13, scope: !980)
!1073 = !DILocation(line: 69, column: 18, scope: !980)
!1074 = !DILocation(line: 69, column: 42, scope: !980)
!1075 = !DILocation(line: 69, column: 39, scope: !980)
!1076 = !DILocation(line: 69, column: 33, scope: !980)
!1077 = !DILocation(line: 70, column: 5, scope: !980)
!1078 = !DILocation(line: 75, column: 18, scope: !980)
!1079 = !DILocation(line: 76, column: 18, scope: !980)
!1080 = !DILocation(line: 77, column: 28, scope: !980)
!1081 = !DILocation(line: 77, column: 40, scope: !980)
!1082 = !DILocation(line: 77, column: 38, scope: !980)
!1083 = !DILocation(line: 77, column: 52, scope: !980)
!1084 = !DILocation(line: 77, column: 50, scope: !980)
!1085 = !DILocation(line: 77, column: 9, scope: !980)
!1086 = !DILocation(line: 83, column: 27, scope: !980)
!1087 = !DILocation(line: 83, column: 40, scope: !980)
!1088 = !DILocation(line: 83, column: 20, scope: !980)
!1089 = !DILocation(line: 84, column: 47, scope: !980)
!1090 = !DILocation(line: 84, column: 45, scope: !980)
!1091 = !DILocation(line: 84, column: 14, scope: !980)
!1092 = !DILocation(line: 94, column: 32, scope: !980)
!1093 = !DILocation(line: 94, column: 22, scope: !980)
!1094 = !DILocation(line: 94, column: 42, scope: !980)
!1095 = !DILocation(line: 94, column: 40, scope: !980)
!1096 = !DILocation(line: 94, column: 47, scope: !980)
!1097 = !DILocation(line: 94, column: 20, scope: !980)
!1098 = !DILocation(line: 94, column: 18, scope: !980)
!1099 = !DILocation(line: 95, column: 25, scope: !980)
!1100 = !DILocation(line: 95, column: 15, scope: !980)
!1101 = !DILocation(line: 95, column: 35, scope: !980)
!1102 = !DILocation(line: 95, column: 33, scope: !980)
!1103 = !DILocation(line: 95, column: 48, scope: !980)
!1104 = !DILocation(line: 95, column: 13, scope: !980)
!1105 = !DILocation(line: 96, column: 32, scope: !980)
!1106 = !DILocation(line: 96, column: 22, scope: !980)
!1107 = !DILocation(line: 96, column: 42, scope: !980)
!1108 = !DILocation(line: 96, column: 40, scope: !980)
!1109 = !DILocation(line: 96, column: 47, scope: !980)
!1110 = !DILocation(line: 96, column: 20, scope: !980)
!1111 = !DILocation(line: 96, column: 18, scope: !980)
!1112 = !DILocation(line: 97, column: 25, scope: !980)
!1113 = !DILocation(line: 97, column: 15, scope: !980)
!1114 = !DILocation(line: 97, column: 35, scope: !980)
!1115 = !DILocation(line: 97, column: 33, scope: !980)
!1116 = !DILocation(line: 97, column: 48, scope: !980)
!1117 = !DILocation(line: 97, column: 13, scope: !980)
!1118 = !DILocation(line: 98, column: 32, scope: !980)
!1119 = !DILocation(line: 98, column: 22, scope: !980)
!1120 = !DILocation(line: 98, column: 42, scope: !980)
!1121 = !DILocation(line: 98, column: 40, scope: !980)
!1122 = !DILocation(line: 98, column: 47, scope: !980)
!1123 = !DILocation(line: 98, column: 20, scope: !980)
!1124 = !DILocation(line: 98, column: 18, scope: !980)
!1125 = !DILocation(line: 99, column: 25, scope: !980)
!1126 = !DILocation(line: 99, column: 15, scope: !980)
!1127 = !DILocation(line: 99, column: 35, scope: !980)
!1128 = !DILocation(line: 99, column: 33, scope: !980)
!1129 = !DILocation(line: 99, column: 48, scope: !980)
!1130 = !DILocation(line: 99, column: 13, scope: !980)
!1131 = !DILocation(line: 105, column: 12, scope: !980)
!1132 = !DILocation(line: 109, column: 29, scope: !980)
!1133 = !DILocation(line: 109, column: 42, scope: !980)
!1134 = !DILocation(line: 109, column: 20, scope: !980)
!1135 = !DILocation(line: 111, column: 30, scope: !980)
!1136 = !DILocation(line: 111, column: 20, scope: !980)
!1137 = !DILocation(line: 111, column: 38, scope: !980)
!1138 = !DILocation(line: 111, column: 37, scope: !980)
!1139 = !DILocation(line: 111, column: 56, scope: !980)
!1140 = !DILocation(line: 111, column: 46, scope: !980)
!1141 = !DILocation(line: 111, column: 64, scope: !980)
!1142 = !DILocation(line: 111, column: 63, scope: !980)
!1143 = !DILocation(line: 111, column: 71, scope: !980)
!1144 = !DILocation(line: 111, column: 43, scope: !980)
!1145 = !DILocation(line: 111, column: 18, scope: !980)
!1146 = !DILocation(line: 111, column: 16, scope: !980)
!1147 = !DILocation(line: 112, column: 20, scope: !980)
!1148 = !DILocation(line: 112, column: 31, scope: !980)
!1149 = !DILocation(line: 112, column: 14, scope: !980)
!1150 = !DILocation(line: 113, column: 20, scope: !980)
!1151 = !DILocation(line: 113, column: 14, scope: !980)
!1152 = !DILocation(line: 114, column: 28, scope: !980)
!1153 = !DILocation(line: 114, column: 18, scope: !980)
!1154 = !DILocation(line: 114, column: 36, scope: !980)
!1155 = !DILocation(line: 114, column: 35, scope: !980)
!1156 = !DILocation(line: 114, column: 53, scope: !980)
!1157 = !DILocation(line: 114, column: 43, scope: !980)
!1158 = !DILocation(line: 114, column: 61, scope: !980)
!1159 = !DILocation(line: 114, column: 60, scope: !980)
!1160 = !DILocation(line: 114, column: 65, scope: !980)
!1161 = !DILocation(line: 114, column: 40, scope: !980)
!1162 = !DILocation(line: 114, column: 16, scope: !980)
!1163 = !DILocation(line: 121, column: 16, scope: !980)
!1164 = !DILocation(line: 136, column: 18, scope: !980)
!1165 = !DILocation(line: 136, column: 31, scope: !980)
!1166 = !DILocation(line: 136, column: 37, scope: !980)
!1167 = !DILocation(line: 136, column: 5, scope: !980)
!1168 = !DILocation(line: 152, column: 9, scope: !980)
!1169 = !DILocation(line: 152, column: 18, scope: !980)
!1170 = !DILocation(line: 153, column: 21, scope: !980)
!1171 = !DILocation(line: 153, column: 34, scope: !980)
!1172 = !DILocation(line: 153, column: 43, scope: !980)
!1173 = !DILocation(line: 153, column: 54, scope: !980)
!1174 = !DILocation(line: 153, column: 52, scope: !980)
!1175 = !DILocation(line: 153, column: 41, scope: !980)
!1176 = !DILocation(line: 153, column: 18, scope: !980)
!1177 = !DILocation(line: 154, column: 25, scope: !980)
!1178 = !DILocation(line: 155, column: 5, scope: !980)
!1179 = !DILocation(line: 156, column: 18, scope: !980)
!1180 = !DILocation(line: 157, column: 21, scope: !980)
!1181 = !DILocation(line: 157, column: 34, scope: !980)
!1182 = !DILocation(line: 157, column: 43, scope: !980)
!1183 = !DILocation(line: 157, column: 54, scope: !980)
!1184 = !DILocation(line: 157, column: 52, scope: !980)
!1185 = !DILocation(line: 157, column: 41, scope: !980)
!1186 = !DILocation(line: 157, column: 18, scope: !980)
!1187 = !DILocation(line: 160, column: 33, scope: !980)
!1188 = !DILocation(line: 160, column: 50, scope: !980)
!1189 = !DILocation(line: 160, column: 15, scope: !980)
!1190 = !DILocation(line: 162, column: 9, scope: !980)
!1191 = !DILocation(line: 162, column: 25, scope: !980)
!1192 = !DILocation(line: 164, column: 33, scope: !980)
!1193 = !DILocation(line: 164, column: 31, scope: !980)
!1194 = !DILocation(line: 164, column: 16, scope: !980)
!1195 = !DILocation(line: 164, column: 9, scope: !980)
!1196 = !DILocation(line: 167, column: 14, scope: !980)
!1197 = !DILocation(line: 167, column: 30, scope: !980)
!1198 = !DILocation(line: 170, column: 24, scope: !980)
!1199 = !DILocation(line: 170, column: 16, scope: !980)
!1200 = !DILocation(line: 170, column: 9, scope: !980)
!1201 = !DILocation(line: 174, column: 29, scope: !980)
!1202 = !DILocation(line: 174, column: 38, scope: !980)
!1203 = !DILocation(line: 174, column: 46, scope: !980)
!1204 = !DILocation(line: 174, column: 44, scope: !980)
!1205 = !DILocation(line: 174, column: 20, scope: !980)
!1206 = !DILocation(line: 176, column: 27, scope: !980)
!1207 = !DILocation(line: 176, column: 36, scope: !980)
!1208 = !DILocation(line: 176, column: 15, scope: !980)
!1209 = !DILocation(line: 178, column: 29, scope: !980)
!1210 = !DILocation(line: 178, column: 22, scope: !980)
!1211 = !DILocation(line: 178, column: 45, scope: !980)
!1212 = !DILocation(line: 178, column: 19, scope: !980)
!1213 = !DILocation(line: 180, column: 22, scope: !980)
!1214 = !DILocation(line: 180, column: 19, scope: !980)
!1215 = !DILocation(line: 182, column: 39, scope: !980)
!1216 = !DILocation(line: 182, column: 51, scope: !980)
!1217 = !DILocation(line: 182, column: 49, scope: !980)
!1218 = !DILocation(line: 182, column: 31, scope: !980)
!1219 = !DILocation(line: 182, column: 22, scope: !980)
!1220 = !DILocation(line: 183, column: 16, scope: !980)
!1221 = !DILocation(line: 183, column: 9, scope: !980)
!1222 = !DILocation(line: 185, column: 1, scope: !980)
!1223 = distinct !DISubprogram(name: "toRep", scope: !411, file: !411, line: 231, type: !178, isLocal: true, isDefinition: true, scopeLine: 231, flags: DIFlagPrototyped, isOptimized: false, unit: !13, retainedNodes: !2)
!1224 = !DILocation(line: 232, column: 44, scope: !1223)
!1225 = !DILocation(line: 232, column: 50, scope: !1223)
!1226 = !DILocation(line: 233, column: 16, scope: !1223)
!1227 = !DILocation(line: 233, column: 5, scope: !1223)
!1228 = distinct !DISubprogram(name: "fromRep", scope: !411, file: !411, line: 236, type: !178, isLocal: true, isDefinition: true, scopeLine: 236, flags: DIFlagPrototyped, isOptimized: false, unit: !13, retainedNodes: !2)
!1229 = !DILocation(line: 237, column: 44, scope: !1228)
!1230 = !DILocation(line: 237, column: 50, scope: !1228)
!1231 = !DILocation(line: 238, column: 16, scope: !1228)
!1232 = !DILocation(line: 238, column: 5, scope: !1228)
!1233 = distinct !DISubprogram(name: "normalize", scope: !411, file: !411, line: 241, type: !178, isLocal: true, isDefinition: true, scopeLine: 241, flags: DIFlagPrototyped, isOptimized: false, unit: !13, retainedNodes: !2)
!1234 = !DILocation(line: 242, column: 32, scope: !1233)
!1235 = !DILocation(line: 242, column: 31, scope: !1233)
!1236 = !DILocation(line: 242, column: 23, scope: !1233)
!1237 = !DILocation(line: 242, column: 47, scope: !1233)
!1238 = !DILocation(line: 242, column: 45, scope: !1233)
!1239 = !DILocation(line: 242, column: 15, scope: !1233)
!1240 = !DILocation(line: 243, column: 22, scope: !1233)
!1241 = !DILocation(line: 243, column: 6, scope: !1233)
!1242 = !DILocation(line: 243, column: 18, scope: !1233)
!1243 = !DILocation(line: 244, column: 16, scope: !1233)
!1244 = !DILocation(line: 244, column: 14, scope: !1233)
!1245 = !DILocation(line: 244, column: 5, scope: !1233)
!1246 = distinct !DISubprogram(name: "wideMultiply", scope: !411, file: !411, line: 86, type: !178, isLocal: true, isDefinition: true, scopeLine: 86, flags: DIFlagPrototyped, isOptimized: false, unit: !13, retainedNodes: !2)
!1247 = !DILocation(line: 88, column: 28, scope: !1246)
!1248 = !DILocation(line: 88, column: 40, scope: !1246)
!1249 = !DILocation(line: 88, column: 38, scope: !1246)
!1250 = !DILocation(line: 88, column: 20, scope: !1246)
!1251 = !DILocation(line: 89, column: 28, scope: !1246)
!1252 = !DILocation(line: 89, column: 40, scope: !1246)
!1253 = !DILocation(line: 89, column: 38, scope: !1246)
!1254 = !DILocation(line: 89, column: 20, scope: !1246)
!1255 = !DILocation(line: 90, column: 28, scope: !1246)
!1256 = !DILocation(line: 90, column: 40, scope: !1246)
!1257 = !DILocation(line: 90, column: 38, scope: !1246)
!1258 = !DILocation(line: 90, column: 20, scope: !1246)
!1259 = !DILocation(line: 91, column: 28, scope: !1246)
!1260 = !DILocation(line: 91, column: 40, scope: !1246)
!1261 = !DILocation(line: 91, column: 38, scope: !1246)
!1262 = !DILocation(line: 91, column: 20, scope: !1246)
!1263 = !DILocation(line: 93, column: 25, scope: !1246)
!1264 = !DILocation(line: 93, column: 20, scope: !1246)
!1265 = !DILocation(line: 94, column: 25, scope: !1246)
!1266 = !DILocation(line: 94, column: 41, scope: !1246)
!1267 = !DILocation(line: 94, column: 39, scope: !1246)
!1268 = !DILocation(line: 94, column: 57, scope: !1246)
!1269 = !DILocation(line: 94, column: 55, scope: !1246)
!1270 = !DILocation(line: 94, column: 20, scope: !1246)
!1271 = !DILocation(line: 95, column: 11, scope: !1246)
!1272 = !DILocation(line: 95, column: 17, scope: !1246)
!1273 = !DILocation(line: 95, column: 20, scope: !1246)
!1274 = !DILocation(line: 95, column: 14, scope: !1246)
!1275 = !DILocation(line: 95, column: 6, scope: !1246)
!1276 = !DILocation(line: 95, column: 9, scope: !1246)
!1277 = !DILocation(line: 97, column: 11, scope: !1246)
!1278 = !DILocation(line: 97, column: 27, scope: !1246)
!1279 = !DILocation(line: 97, column: 25, scope: !1246)
!1280 = !DILocation(line: 97, column: 43, scope: !1246)
!1281 = !DILocation(line: 97, column: 41, scope: !1246)
!1282 = !DILocation(line: 97, column: 56, scope: !1246)
!1283 = !DILocation(line: 97, column: 54, scope: !1246)
!1284 = !DILocation(line: 97, column: 6, scope: !1246)
!1285 = !DILocation(line: 97, column: 9, scope: !1246)
!1286 = !DILocation(line: 98, column: 1, scope: !1246)
!1287 = distinct !DISubprogram(name: "rep_clz", scope: !411, file: !411, line: 69, type: !178, isLocal: true, isDefinition: true, scopeLine: 69, flags: DIFlagPrototyped, isOptimized: false, unit: !13, retainedNodes: !2)
!1288 = !DILocation(line: 73, column: 9, scope: !1287)
!1289 = !DILocation(line: 73, column: 11, scope: !1287)
!1290 = !DILocation(line: 74, column: 30, scope: !1287)
!1291 = !DILocation(line: 74, column: 32, scope: !1287)
!1292 = !DILocation(line: 74, column: 16, scope: !1287)
!1293 = !DILocation(line: 74, column: 9, scope: !1287)
!1294 = !DILocation(line: 76, column: 35, scope: !1287)
!1295 = !DILocation(line: 76, column: 37, scope: !1287)
!1296 = !DILocation(line: 76, column: 21, scope: !1287)
!1297 = !DILocation(line: 76, column: 19, scope: !1287)
!1298 = !DILocation(line: 76, column: 9, scope: !1287)
!1299 = !DILocation(line: 78, column: 1, scope: !1287)
!1300 = distinct !DISubprogram(name: "__divsf3", scope: !16, file: !16, line: 25, type: !178, isLocal: false, isDefinition: true, scopeLine: 25, flags: DIFlagPrototyped, isOptimized: false, unit: !15, retainedNodes: !2)
!1301 = !DILocation(line: 27, column: 42, scope: !1300)
!1302 = !DILocation(line: 27, column: 36, scope: !1300)
!1303 = !DILocation(line: 27, column: 45, scope: !1300)
!1304 = !DILocation(line: 27, column: 64, scope: !1300)
!1305 = !DILocation(line: 27, column: 24, scope: !1300)
!1306 = !DILocation(line: 28, column: 42, scope: !1300)
!1307 = !DILocation(line: 28, column: 36, scope: !1300)
!1308 = !DILocation(line: 28, column: 45, scope: !1300)
!1309 = !DILocation(line: 28, column: 64, scope: !1300)
!1310 = !DILocation(line: 28, column: 24, scope: !1300)
!1311 = !DILocation(line: 29, column: 39, scope: !1300)
!1312 = !DILocation(line: 29, column: 33, scope: !1300)
!1313 = !DILocation(line: 29, column: 50, scope: !1300)
!1314 = !DILocation(line: 29, column: 44, scope: !1300)
!1315 = !DILocation(line: 29, column: 42, scope: !1300)
!1316 = !DILocation(line: 29, column: 54, scope: !1300)
!1317 = !DILocation(line: 29, column: 17, scope: !1300)
!1318 = !DILocation(line: 31, column: 32, scope: !1300)
!1319 = !DILocation(line: 31, column: 26, scope: !1300)
!1320 = !DILocation(line: 31, column: 35, scope: !1300)
!1321 = !DILocation(line: 31, column: 11, scope: !1300)
!1322 = !DILocation(line: 32, column: 32, scope: !1300)
!1323 = !DILocation(line: 32, column: 26, scope: !1300)
!1324 = !DILocation(line: 32, column: 35, scope: !1300)
!1325 = !DILocation(line: 32, column: 11, scope: !1300)
!1326 = !DILocation(line: 33, column: 9, scope: !1300)
!1327 = !DILocation(line: 36, column: 9, scope: !1300)
!1328 = !DILocation(line: 36, column: 18, scope: !1300)
!1329 = !DILocation(line: 36, column: 22, scope: !1300)
!1330 = !DILocation(line: 36, column: 40, scope: !1300)
!1331 = !DILocation(line: 36, column: 43, scope: !1300)
!1332 = !DILocation(line: 36, column: 52, scope: !1300)
!1333 = !DILocation(line: 36, column: 56, scope: !1300)
!1334 = !DILocation(line: 38, column: 34, scope: !1300)
!1335 = !DILocation(line: 38, column: 28, scope: !1300)
!1336 = !DILocation(line: 38, column: 37, scope: !1300)
!1337 = !DILocation(line: 38, column: 21, scope: !1300)
!1338 = !DILocation(line: 39, column: 34, scope: !1300)
!1339 = !DILocation(line: 39, column: 28, scope: !1300)
!1340 = !DILocation(line: 39, column: 37, scope: !1300)
!1341 = !DILocation(line: 39, column: 21, scope: !1300)
!1342 = !DILocation(line: 42, column: 13, scope: !1300)
!1343 = !DILocation(line: 42, column: 18, scope: !1300)
!1344 = !DILocation(line: 42, column: 49, scope: !1300)
!1345 = !DILocation(line: 42, column: 43, scope: !1300)
!1346 = !DILocation(line: 42, column: 52, scope: !1300)
!1347 = !DILocation(line: 42, column: 35, scope: !1300)
!1348 = !DILocation(line: 42, column: 28, scope: !1300)
!1349 = !DILocation(line: 44, column: 13, scope: !1300)
!1350 = !DILocation(line: 44, column: 18, scope: !1300)
!1351 = !DILocation(line: 44, column: 49, scope: !1300)
!1352 = !DILocation(line: 44, column: 43, scope: !1300)
!1353 = !DILocation(line: 44, column: 52, scope: !1300)
!1354 = !DILocation(line: 44, column: 35, scope: !1300)
!1355 = !DILocation(line: 44, column: 28, scope: !1300)
!1356 = !DILocation(line: 46, column: 13, scope: !1300)
!1357 = !DILocation(line: 46, column: 18, scope: !1300)
!1358 = !DILocation(line: 48, column: 17, scope: !1300)
!1359 = !DILocation(line: 48, column: 22, scope: !1300)
!1360 = !DILocation(line: 48, column: 40, scope: !1300)
!1361 = !DILocation(line: 48, column: 33, scope: !1300)
!1362 = !DILocation(line: 50, column: 33, scope: !1300)
!1363 = !DILocation(line: 50, column: 40, scope: !1300)
!1364 = !DILocation(line: 50, column: 38, scope: !1300)
!1365 = !DILocation(line: 50, column: 25, scope: !1300)
!1366 = !DILocation(line: 50, column: 18, scope: !1300)
!1367 = !DILocation(line: 54, column: 13, scope: !1300)
!1368 = !DILocation(line: 54, column: 18, scope: !1300)
!1369 = !DILocation(line: 54, column: 44, scope: !1300)
!1370 = !DILocation(line: 54, column: 36, scope: !1300)
!1371 = !DILocation(line: 54, column: 29, scope: !1300)
!1372 = !DILocation(line: 56, column: 14, scope: !1300)
!1373 = !DILocation(line: 56, column: 13, scope: !1300)
!1374 = !DILocation(line: 58, column: 18, scope: !1300)
!1375 = !DILocation(line: 58, column: 17, scope: !1300)
!1376 = !DILocation(line: 58, column: 31, scope: !1300)
!1377 = !DILocation(line: 58, column: 24, scope: !1300)
!1378 = !DILocation(line: 60, column: 33, scope: !1300)
!1379 = !DILocation(line: 60, column: 25, scope: !1300)
!1380 = !DILocation(line: 60, column: 18, scope: !1300)
!1381 = !DILocation(line: 63, column: 14, scope: !1300)
!1382 = !DILocation(line: 63, column: 13, scope: !1300)
!1383 = !DILocation(line: 63, column: 44, scope: !1300)
!1384 = !DILocation(line: 63, column: 42, scope: !1300)
!1385 = !DILocation(line: 63, column: 27, scope: !1300)
!1386 = !DILocation(line: 63, column: 20, scope: !1300)
!1387 = !DILocation(line: 68, column: 13, scope: !1300)
!1388 = !DILocation(line: 68, column: 18, scope: !1300)
!1389 = !DILocation(line: 68, column: 42, scope: !1300)
!1390 = !DILocation(line: 68, column: 39, scope: !1300)
!1391 = !DILocation(line: 68, column: 33, scope: !1300)
!1392 = !DILocation(line: 69, column: 13, scope: !1300)
!1393 = !DILocation(line: 69, column: 18, scope: !1300)
!1394 = !DILocation(line: 69, column: 42, scope: !1300)
!1395 = !DILocation(line: 69, column: 39, scope: !1300)
!1396 = !DILocation(line: 69, column: 33, scope: !1300)
!1397 = !DILocation(line: 70, column: 5, scope: !1300)
!1398 = !DILocation(line: 75, column: 18, scope: !1300)
!1399 = !DILocation(line: 76, column: 18, scope: !1300)
!1400 = !DILocation(line: 77, column: 28, scope: !1300)
!1401 = !DILocation(line: 77, column: 40, scope: !1300)
!1402 = !DILocation(line: 77, column: 38, scope: !1300)
!1403 = !DILocation(line: 77, column: 52, scope: !1300)
!1404 = !DILocation(line: 77, column: 50, scope: !1300)
!1405 = !DILocation(line: 77, column: 9, scope: !1300)
!1406 = !DILocation(line: 83, column: 21, scope: !1300)
!1407 = !DILocation(line: 83, column: 34, scope: !1300)
!1408 = !DILocation(line: 83, column: 14, scope: !1300)
!1409 = !DILocation(line: 84, column: 50, scope: !1300)
!1410 = !DILocation(line: 84, column: 48, scope: !1300)
!1411 = !DILocation(line: 84, column: 14, scope: !1300)
!1412 = !DILocation(line: 94, column: 30, scope: !1300)
!1413 = !DILocation(line: 94, column: 20, scope: !1300)
!1414 = !DILocation(line: 94, column: 43, scope: !1300)
!1415 = !DILocation(line: 94, column: 41, scope: !1300)
!1416 = !DILocation(line: 94, column: 48, scope: !1300)
!1417 = !DILocation(line: 94, column: 18, scope: !1300)
!1418 = !DILocation(line: 94, column: 16, scope: !1300)
!1419 = !DILocation(line: 95, column: 28, scope: !1300)
!1420 = !DILocation(line: 95, column: 18, scope: !1300)
!1421 = !DILocation(line: 95, column: 41, scope: !1300)
!1422 = !DILocation(line: 95, column: 39, scope: !1300)
!1423 = !DILocation(line: 95, column: 52, scope: !1300)
!1424 = !DILocation(line: 95, column: 16, scope: !1300)
!1425 = !DILocation(line: 96, column: 30, scope: !1300)
!1426 = !DILocation(line: 96, column: 20, scope: !1300)
!1427 = !DILocation(line: 96, column: 43, scope: !1300)
!1428 = !DILocation(line: 96, column: 41, scope: !1300)
!1429 = !DILocation(line: 96, column: 48, scope: !1300)
!1430 = !DILocation(line: 96, column: 18, scope: !1300)
!1431 = !DILocation(line: 96, column: 16, scope: !1300)
!1432 = !DILocation(line: 97, column: 28, scope: !1300)
!1433 = !DILocation(line: 97, column: 18, scope: !1300)
!1434 = !DILocation(line: 97, column: 41, scope: !1300)
!1435 = !DILocation(line: 97, column: 39, scope: !1300)
!1436 = !DILocation(line: 97, column: 52, scope: !1300)
!1437 = !DILocation(line: 97, column: 16, scope: !1300)
!1438 = !DILocation(line: 98, column: 30, scope: !1300)
!1439 = !DILocation(line: 98, column: 20, scope: !1300)
!1440 = !DILocation(line: 98, column: 43, scope: !1300)
!1441 = !DILocation(line: 98, column: 41, scope: !1300)
!1442 = !DILocation(line: 98, column: 48, scope: !1300)
!1443 = !DILocation(line: 98, column: 18, scope: !1300)
!1444 = !DILocation(line: 98, column: 16, scope: !1300)
!1445 = !DILocation(line: 99, column: 28, scope: !1300)
!1446 = !DILocation(line: 99, column: 18, scope: !1300)
!1447 = !DILocation(line: 99, column: 41, scope: !1300)
!1448 = !DILocation(line: 99, column: 39, scope: !1300)
!1449 = !DILocation(line: 99, column: 52, scope: !1300)
!1450 = !DILocation(line: 99, column: 16, scope: !1300)
!1451 = !DILocation(line: 107, column: 16, scope: !1300)
!1452 = !DILocation(line: 121, column: 32, scope: !1300)
!1453 = !DILocation(line: 121, column: 22, scope: !1300)
!1454 = !DILocation(line: 121, column: 44, scope: !1300)
!1455 = !DILocation(line: 121, column: 57, scope: !1300)
!1456 = !DILocation(line: 121, column: 43, scope: !1300)
!1457 = !DILocation(line: 121, column: 42, scope: !1300)
!1458 = !DILocation(line: 121, column: 63, scope: !1300)
!1459 = !DILocation(line: 121, column: 11, scope: !1300)
!1460 = !DILocation(line: 137, column: 9, scope: !1300)
!1461 = !DILocation(line: 137, column: 18, scope: !1300)
!1462 = !DILocation(line: 138, column: 21, scope: !1300)
!1463 = !DILocation(line: 138, column: 34, scope: !1300)
!1464 = !DILocation(line: 138, column: 43, scope: !1300)
!1465 = !DILocation(line: 138, column: 54, scope: !1300)
!1466 = !DILocation(line: 138, column: 52, scope: !1300)
!1467 = !DILocation(line: 138, column: 41, scope: !1300)
!1468 = !DILocation(line: 138, column: 18, scope: !1300)
!1469 = !DILocation(line: 139, column: 25, scope: !1300)
!1470 = !DILocation(line: 140, column: 5, scope: !1300)
!1471 = !DILocation(line: 141, column: 18, scope: !1300)
!1472 = !DILocation(line: 142, column: 21, scope: !1300)
!1473 = !DILocation(line: 142, column: 34, scope: !1300)
!1474 = !DILocation(line: 142, column: 43, scope: !1300)
!1475 = !DILocation(line: 142, column: 54, scope: !1300)
!1476 = !DILocation(line: 142, column: 52, scope: !1300)
!1477 = !DILocation(line: 142, column: 41, scope: !1300)
!1478 = !DILocation(line: 142, column: 18, scope: !1300)
!1479 = !DILocation(line: 145, column: 33, scope: !1300)
!1480 = !DILocation(line: 145, column: 50, scope: !1300)
!1481 = !DILocation(line: 145, column: 15, scope: !1300)
!1482 = !DILocation(line: 147, column: 9, scope: !1300)
!1483 = !DILocation(line: 147, column: 25, scope: !1300)
!1484 = !DILocation(line: 149, column: 33, scope: !1300)
!1485 = !DILocation(line: 149, column: 31, scope: !1300)
!1486 = !DILocation(line: 149, column: 16, scope: !1300)
!1487 = !DILocation(line: 149, column: 9, scope: !1300)
!1488 = !DILocation(line: 152, column: 14, scope: !1300)
!1489 = !DILocation(line: 152, column: 30, scope: !1300)
!1490 = !DILocation(line: 155, column: 24, scope: !1300)
!1491 = !DILocation(line: 155, column: 16, scope: !1300)
!1492 = !DILocation(line: 155, column: 9, scope: !1300)
!1493 = !DILocation(line: 159, column: 29, scope: !1300)
!1494 = !DILocation(line: 159, column: 38, scope: !1300)
!1495 = !DILocation(line: 159, column: 46, scope: !1300)
!1496 = !DILocation(line: 159, column: 44, scope: !1300)
!1497 = !DILocation(line: 159, column: 20, scope: !1300)
!1498 = !DILocation(line: 161, column: 27, scope: !1300)
!1499 = !DILocation(line: 161, column: 36, scope: !1300)
!1500 = !DILocation(line: 161, column: 15, scope: !1300)
!1501 = !DILocation(line: 163, column: 29, scope: !1300)
!1502 = !DILocation(line: 163, column: 45, scope: !1300)
!1503 = !DILocation(line: 163, column: 19, scope: !1300)
!1504 = !DILocation(line: 165, column: 22, scope: !1300)
!1505 = !DILocation(line: 165, column: 19, scope: !1300)
!1506 = !DILocation(line: 167, column: 24, scope: !1300)
!1507 = !DILocation(line: 167, column: 36, scope: !1300)
!1508 = !DILocation(line: 167, column: 34, scope: !1300)
!1509 = !DILocation(line: 167, column: 16, scope: !1300)
!1510 = !DILocation(line: 167, column: 9, scope: !1300)
!1511 = !DILocation(line: 169, column: 1, scope: !1300)
!1512 = distinct !DISubprogram(name: "toRep", scope: !411, file: !411, line: 231, type: !178, isLocal: true, isDefinition: true, scopeLine: 231, flags: DIFlagPrototyped, isOptimized: false, unit: !15, retainedNodes: !2)
!1513 = !DILocation(line: 232, column: 44, scope: !1512)
!1514 = !DILocation(line: 232, column: 50, scope: !1512)
!1515 = !DILocation(line: 233, column: 16, scope: !1512)
!1516 = !DILocation(line: 233, column: 5, scope: !1512)
!1517 = distinct !DISubprogram(name: "fromRep", scope: !411, file: !411, line: 236, type: !178, isLocal: true, isDefinition: true, scopeLine: 236, flags: DIFlagPrototyped, isOptimized: false, unit: !15, retainedNodes: !2)
!1518 = !DILocation(line: 237, column: 44, scope: !1517)
!1519 = !DILocation(line: 237, column: 50, scope: !1517)
!1520 = !DILocation(line: 238, column: 16, scope: !1517)
!1521 = !DILocation(line: 238, column: 5, scope: !1517)
!1522 = distinct !DISubprogram(name: "normalize", scope: !411, file: !411, line: 241, type: !178, isLocal: true, isDefinition: true, scopeLine: 241, flags: DIFlagPrototyped, isOptimized: false, unit: !15, retainedNodes: !2)
!1523 = !DILocation(line: 242, column: 32, scope: !1522)
!1524 = !DILocation(line: 242, column: 31, scope: !1522)
!1525 = !DILocation(line: 242, column: 23, scope: !1522)
!1526 = !DILocation(line: 242, column: 47, scope: !1522)
!1527 = !DILocation(line: 242, column: 45, scope: !1522)
!1528 = !DILocation(line: 242, column: 15, scope: !1522)
!1529 = !DILocation(line: 243, column: 22, scope: !1522)
!1530 = !DILocation(line: 243, column: 6, scope: !1522)
!1531 = !DILocation(line: 243, column: 18, scope: !1522)
!1532 = !DILocation(line: 244, column: 16, scope: !1522)
!1533 = !DILocation(line: 244, column: 14, scope: !1522)
!1534 = !DILocation(line: 244, column: 5, scope: !1522)
!1535 = distinct !DISubprogram(name: "rep_clz", scope: !411, file: !411, line: 49, type: !178, isLocal: true, isDefinition: true, scopeLine: 49, flags: DIFlagPrototyped, isOptimized: false, unit: !15, retainedNodes: !2)
!1536 = !DILocation(line: 50, column: 26, scope: !1535)
!1537 = !DILocation(line: 50, column: 12, scope: !1535)
!1538 = !DILocation(line: 50, column: 5, scope: !1535)
!1539 = distinct !DISubprogram(name: "__extendhfsf2", scope: !22, file: !22, line: 19, type: !178, isLocal: false, isDefinition: true, scopeLine: 19, flags: DIFlagPrototyped, isOptimized: false, unit: !21, retainedNodes: !2)
!1540 = !DILocation(line: 20, column: 28, scope: !1539)
!1541 = !DILocation(line: 20, column: 12, scope: !1539)
!1542 = !DILocation(line: 20, column: 5, scope: !1539)
!1543 = distinct !DISubprogram(name: "__extendXfYf2__", scope: !1544, file: !1544, line: 41, type: !178, isLocal: true, isDefinition: true, scopeLine: 41, flags: DIFlagPrototyped, isOptimized: false, unit: !21, retainedNodes: !2)
!1544 = !DIFile(filename: "/home/hahns/Schreibtisch/llvmta_testcases/libraries/builtinsfloat/fp_extend_impl.inc", directory: "/home/hahns/Schreibtisch/llvmta_testcases/tmp.0b9rXPKPan")
!1545 = !DILocation(line: 44, column: 15, scope: !1543)
!1546 = !DILocation(line: 45, column: 15, scope: !1543)
!1547 = !DILocation(line: 46, column: 15, scope: !1543)
!1548 = !DILocation(line: 47, column: 15, scope: !1543)
!1549 = !DILocation(line: 49, column: 21, scope: !1543)
!1550 = !DILocation(line: 50, column: 21, scope: !1543)
!1551 = !DILocation(line: 51, column: 21, scope: !1543)
!1552 = !DILocation(line: 52, column: 21, scope: !1543)
!1553 = !DILocation(line: 53, column: 21, scope: !1543)
!1554 = !DILocation(line: 54, column: 21, scope: !1543)
!1555 = !DILocation(line: 56, column: 15, scope: !1543)
!1556 = !DILocation(line: 57, column: 15, scope: !1543)
!1557 = !DILocation(line: 58, column: 15, scope: !1543)
!1558 = !DILocation(line: 59, column: 15, scope: !1543)
!1559 = !DILocation(line: 61, column: 21, scope: !1543)
!1560 = !DILocation(line: 64, column: 37, scope: !1543)
!1561 = !DILocation(line: 64, column: 28, scope: !1543)
!1562 = !DILocation(line: 64, column: 21, scope: !1543)
!1563 = !DILocation(line: 65, column: 28, scope: !1543)
!1564 = !DILocation(line: 65, column: 33, scope: !1543)
!1565 = !DILocation(line: 65, column: 21, scope: !1543)
!1566 = !DILocation(line: 66, column: 28, scope: !1543)
!1567 = !DILocation(line: 66, column: 33, scope: !1543)
!1568 = !DILocation(line: 66, column: 21, scope: !1543)
!1569 = !DILocation(line: 71, column: 21, scope: !1543)
!1570 = !DILocation(line: 71, column: 26, scope: !1543)
!1571 = !DILocation(line: 71, column: 9, scope: !1543)
!1572 = !DILocation(line: 71, column: 42, scope: !1543)
!1573 = !DILocation(line: 75, column: 32, scope: !1543)
!1574 = !DILocation(line: 75, column: 21, scope: !1543)
!1575 = !DILocation(line: 75, column: 37, scope: !1543)
!1576 = !DILocation(line: 75, column: 19, scope: !1543)
!1577 = !DILocation(line: 76, column: 19, scope: !1543)
!1578 = !DILocation(line: 77, column: 5, scope: !1543)
!1579 = !DILocation(line: 79, column: 14, scope: !1543)
!1580 = !DILocation(line: 79, column: 19, scope: !1543)
!1581 = !DILocation(line: 84, column: 19, scope: !1543)
!1582 = !DILocation(line: 85, column: 34, scope: !1543)
!1583 = !DILocation(line: 85, column: 39, scope: !1543)
!1584 = !DILocation(line: 85, column: 50, scope: !1543)
!1585 = !DILocation(line: 85, column: 19, scope: !1543)
!1586 = !DILocation(line: 86, column: 34, scope: !1543)
!1587 = !DILocation(line: 86, column: 39, scope: !1543)
!1588 = !DILocation(line: 86, column: 53, scope: !1543)
!1589 = !DILocation(line: 86, column: 19, scope: !1543)
!1590 = !DILocation(line: 87, column: 5, scope: !1543)
!1591 = !DILocation(line: 89, column: 14, scope: !1543)
!1592 = !DILocation(line: 93, column: 41, scope: !1543)
!1593 = !DILocation(line: 93, column: 27, scope: !1543)
!1594 = !DILocation(line: 93, column: 47, scope: !1543)
!1595 = !DILocation(line: 93, column: 19, scope: !1543)
!1596 = !DILocation(line: 94, column: 32, scope: !1543)
!1597 = !DILocation(line: 94, column: 21, scope: !1543)
!1598 = !DILocation(line: 94, column: 67, scope: !1543)
!1599 = !DILocation(line: 94, column: 65, scope: !1543)
!1600 = !DILocation(line: 94, column: 37, scope: !1543)
!1601 = !DILocation(line: 94, column: 19, scope: !1543)
!1602 = !DILocation(line: 95, column: 19, scope: !1543)
!1603 = !DILocation(line: 96, column: 62, scope: !1543)
!1604 = !DILocation(line: 96, column: 60, scope: !1543)
!1605 = !DILocation(line: 96, column: 68, scope: !1543)
!1606 = !DILocation(line: 96, column: 19, scope: !1543)
!1607 = !DILocation(line: 97, column: 33, scope: !1543)
!1608 = !DILocation(line: 97, column: 48, scope: !1543)
!1609 = !DILocation(line: 97, column: 19, scope: !1543)
!1610 = !DILocation(line: 98, column: 5, scope: !1543)
!1611 = !DILocation(line: 102, column: 19, scope: !1543)
!1612 = !DILocation(line: 106, column: 30, scope: !1543)
!1613 = !DILocation(line: 106, column: 53, scope: !1543)
!1614 = !DILocation(line: 106, column: 42, scope: !1543)
!1615 = !DILocation(line: 106, column: 58, scope: !1543)
!1616 = !DILocation(line: 106, column: 40, scope: !1543)
!1617 = !DILocation(line: 106, column: 21, scope: !1543)
!1618 = !DILocation(line: 107, column: 23, scope: !1543)
!1619 = !DILocation(line: 107, column: 12, scope: !1543)
!1620 = !DILocation(line: 107, column: 5, scope: !1543)
!1621 = distinct !DISubprogram(name: "srcToRep", scope: !1622, file: !1622, line: 78, type: !178, isLocal: true, isDefinition: true, scopeLine: 78, flags: DIFlagPrototyped, isOptimized: false, unit: !21, retainedNodes: !2)
!1622 = !DIFile(filename: "/home/hahns/Schreibtisch/llvmta_testcases/libraries/builtinsfloat/fp_extend.h", directory: "/home/hahns/Schreibtisch/llvmta_testcases/tmp.0b9rXPKPan")
!1623 = !DILocation(line: 79, column: 49, scope: !1621)
!1624 = !DILocation(line: 79, column: 55, scope: !1621)
!1625 = !DILocation(line: 80, column: 16, scope: !1621)
!1626 = !DILocation(line: 80, column: 5, scope: !1621)
!1627 = distinct !DISubprogram(name: "dstFromRep", scope: !1622, file: !1622, line: 83, type: !178, isLocal: true, isDefinition: true, scopeLine: 83, flags: DIFlagPrototyped, isOptimized: false, unit: !21, retainedNodes: !2)
!1628 = !DILocation(line: 84, column: 49, scope: !1627)
!1629 = !DILocation(line: 84, column: 55, scope: !1627)
!1630 = !DILocation(line: 85, column: 16, scope: !1627)
!1631 = !DILocation(line: 85, column: 5, scope: !1627)
!1632 = distinct !DISubprogram(name: "__gnu_h2f_ieee", scope: !22, file: !22, line: 23, type: !178, isLocal: false, isDefinition: true, scopeLine: 23, flags: DIFlagPrototyped, isOptimized: false, unit: !21, retainedNodes: !2)
!1633 = !DILocation(line: 24, column: 26, scope: !1632)
!1634 = !DILocation(line: 24, column: 12, scope: !1632)
!1635 = !DILocation(line: 24, column: 5, scope: !1632)
!1636 = distinct !DISubprogram(name: "__extendsfdf2", scope: !24, file: !24, line: 17, type: !178, isLocal: false, isDefinition: true, scopeLine: 17, flags: DIFlagPrototyped, isOptimized: false, unit: !23, retainedNodes: !2)
!1637 = !DILocation(line: 18, column: 28, scope: !1636)
!1638 = !DILocation(line: 18, column: 12, scope: !1636)
!1639 = !DILocation(line: 18, column: 5, scope: !1636)
!1640 = distinct !DISubprogram(name: "__extendXfYf2__", scope: !1544, file: !1544, line: 41, type: !178, isLocal: true, isDefinition: true, scopeLine: 41, flags: DIFlagPrototyped, isOptimized: false, unit: !23, retainedNodes: !2)
!1641 = !DILocation(line: 44, column: 15, scope: !1640)
!1642 = !DILocation(line: 45, column: 15, scope: !1640)
!1643 = !DILocation(line: 46, column: 15, scope: !1640)
!1644 = !DILocation(line: 47, column: 15, scope: !1640)
!1645 = !DILocation(line: 49, column: 21, scope: !1640)
!1646 = !DILocation(line: 50, column: 21, scope: !1640)
!1647 = !DILocation(line: 51, column: 21, scope: !1640)
!1648 = !DILocation(line: 52, column: 21, scope: !1640)
!1649 = !DILocation(line: 53, column: 21, scope: !1640)
!1650 = !DILocation(line: 54, column: 21, scope: !1640)
!1651 = !DILocation(line: 56, column: 15, scope: !1640)
!1652 = !DILocation(line: 57, column: 15, scope: !1640)
!1653 = !DILocation(line: 58, column: 15, scope: !1640)
!1654 = !DILocation(line: 59, column: 15, scope: !1640)
!1655 = !DILocation(line: 61, column: 21, scope: !1640)
!1656 = !DILocation(line: 64, column: 37, scope: !1640)
!1657 = !DILocation(line: 64, column: 28, scope: !1640)
!1658 = !DILocation(line: 64, column: 21, scope: !1640)
!1659 = !DILocation(line: 65, column: 28, scope: !1640)
!1660 = !DILocation(line: 65, column: 33, scope: !1640)
!1661 = !DILocation(line: 65, column: 21, scope: !1640)
!1662 = !DILocation(line: 66, column: 28, scope: !1640)
!1663 = !DILocation(line: 66, column: 33, scope: !1640)
!1664 = !DILocation(line: 66, column: 21, scope: !1640)
!1665 = !DILocation(line: 71, column: 21, scope: !1640)
!1666 = !DILocation(line: 71, column: 26, scope: !1640)
!1667 = !DILocation(line: 71, column: 42, scope: !1640)
!1668 = !DILocation(line: 71, column: 9, scope: !1640)
!1669 = !DILocation(line: 75, column: 32, scope: !1640)
!1670 = !DILocation(line: 75, column: 21, scope: !1640)
!1671 = !DILocation(line: 75, column: 37, scope: !1640)
!1672 = !DILocation(line: 75, column: 19, scope: !1640)
!1673 = !DILocation(line: 76, column: 19, scope: !1640)
!1674 = !DILocation(line: 77, column: 5, scope: !1640)
!1675 = !DILocation(line: 79, column: 14, scope: !1640)
!1676 = !DILocation(line: 79, column: 19, scope: !1640)
!1677 = !DILocation(line: 84, column: 19, scope: !1640)
!1678 = !DILocation(line: 85, column: 34, scope: !1640)
!1679 = !DILocation(line: 85, column: 39, scope: !1640)
!1680 = !DILocation(line: 85, column: 22, scope: !1640)
!1681 = !DILocation(line: 85, column: 50, scope: !1640)
!1682 = !DILocation(line: 85, column: 19, scope: !1640)
!1683 = !DILocation(line: 86, column: 34, scope: !1640)
!1684 = !DILocation(line: 86, column: 39, scope: !1640)
!1685 = !DILocation(line: 86, column: 22, scope: !1640)
!1686 = !DILocation(line: 86, column: 53, scope: !1640)
!1687 = !DILocation(line: 86, column: 19, scope: !1640)
!1688 = !DILocation(line: 87, column: 5, scope: !1640)
!1689 = !DILocation(line: 89, column: 14, scope: !1640)
!1690 = !DILocation(line: 93, column: 41, scope: !1640)
!1691 = !DILocation(line: 93, column: 27, scope: !1640)
!1692 = !DILocation(line: 93, column: 47, scope: !1640)
!1693 = !DILocation(line: 93, column: 19, scope: !1640)
!1694 = !DILocation(line: 94, column: 32, scope: !1640)
!1695 = !DILocation(line: 94, column: 21, scope: !1640)
!1696 = !DILocation(line: 94, column: 67, scope: !1640)
!1697 = !DILocation(line: 94, column: 65, scope: !1640)
!1698 = !DILocation(line: 94, column: 37, scope: !1640)
!1699 = !DILocation(line: 94, column: 19, scope: !1640)
!1700 = !DILocation(line: 95, column: 19, scope: !1640)
!1701 = !DILocation(line: 96, column: 62, scope: !1640)
!1702 = !DILocation(line: 96, column: 60, scope: !1640)
!1703 = !DILocation(line: 96, column: 68, scope: !1640)
!1704 = !DILocation(line: 96, column: 19, scope: !1640)
!1705 = !DILocation(line: 97, column: 33, scope: !1640)
!1706 = !DILocation(line: 97, column: 22, scope: !1640)
!1707 = !DILocation(line: 97, column: 48, scope: !1640)
!1708 = !DILocation(line: 97, column: 19, scope: !1640)
!1709 = !DILocation(line: 98, column: 5, scope: !1640)
!1710 = !DILocation(line: 102, column: 19, scope: !1640)
!1711 = !DILocation(line: 106, column: 30, scope: !1640)
!1712 = !DILocation(line: 106, column: 53, scope: !1640)
!1713 = !DILocation(line: 106, column: 42, scope: !1640)
!1714 = !DILocation(line: 106, column: 58, scope: !1640)
!1715 = !DILocation(line: 106, column: 40, scope: !1640)
!1716 = !DILocation(line: 106, column: 21, scope: !1640)
!1717 = !DILocation(line: 107, column: 23, scope: !1640)
!1718 = !DILocation(line: 107, column: 12, scope: !1640)
!1719 = !DILocation(line: 107, column: 5, scope: !1640)
!1720 = distinct !DISubprogram(name: "srcToRep", scope: !1622, file: !1622, line: 78, type: !178, isLocal: true, isDefinition: true, scopeLine: 78, flags: DIFlagPrototyped, isOptimized: false, unit: !23, retainedNodes: !2)
!1721 = !DILocation(line: 79, column: 49, scope: !1720)
!1722 = !DILocation(line: 79, column: 55, scope: !1720)
!1723 = !DILocation(line: 80, column: 16, scope: !1720)
!1724 = !DILocation(line: 80, column: 5, scope: !1720)
!1725 = distinct !DISubprogram(name: "dstFromRep", scope: !1622, file: !1622, line: 83, type: !178, isLocal: true, isDefinition: true, scopeLine: 83, flags: DIFlagPrototyped, isOptimized: false, unit: !23, retainedNodes: !2)
!1726 = !DILocation(line: 84, column: 49, scope: !1725)
!1727 = !DILocation(line: 84, column: 55, scope: !1725)
!1728 = !DILocation(line: 85, column: 16, scope: !1725)
!1729 = !DILocation(line: 85, column: 5, scope: !1725)
!1730 = distinct !DISubprogram(name: "__fixdfdi", scope: !28, file: !28, line: 23, type: !178, isLocal: false, isDefinition: true, scopeLine: 24, flags: DIFlagPrototyped, isOptimized: false, unit: !27, retainedNodes: !2)
!1731 = !DILocation(line: 25, column: 9, scope: !1730)
!1732 = !DILocation(line: 25, column: 11, scope: !1730)
!1733 = !DILocation(line: 26, column: 31, scope: !1730)
!1734 = !DILocation(line: 26, column: 30, scope: !1730)
!1735 = !DILocation(line: 26, column: 17, scope: !1730)
!1736 = !DILocation(line: 26, column: 16, scope: !1730)
!1737 = !DILocation(line: 26, column: 9, scope: !1730)
!1738 = !DILocation(line: 28, column: 25, scope: !1730)
!1739 = !DILocation(line: 28, column: 12, scope: !1730)
!1740 = !DILocation(line: 28, column: 5, scope: !1730)
!1741 = !DILocation(line: 29, column: 1, scope: !1730)
!1742 = distinct !DISubprogram(name: "__fixdfsi", scope: !30, file: !30, line: 20, type: !178, isLocal: false, isDefinition: true, scopeLine: 20, flags: DIFlagPrototyped, isOptimized: false, unit: !29, retainedNodes: !2)
!1743 = !DILocation(line: 21, column: 21, scope: !1742)
!1744 = !DILocation(line: 21, column: 12, scope: !1742)
!1745 = !DILocation(line: 21, column: 5, scope: !1742)
!1746 = distinct !DISubprogram(name: "__fixint", scope: !1747, file: !1747, line: 17, type: !178, isLocal: true, isDefinition: true, scopeLine: 17, flags: DIFlagPrototyped, isOptimized: false, unit: !29, retainedNodes: !2)
!1747 = !DIFile(filename: "/home/hahns/Schreibtisch/llvmta_testcases/libraries/builtinsfloat/fp_fixint_impl.inc", directory: "/home/hahns/Schreibtisch/llvmta_testcases/tmp.0b9rXPKPan")
!1748 = !DILocation(line: 18, column: 20, scope: !1746)
!1749 = !DILocation(line: 19, column: 20, scope: !1746)
!1750 = !DILocation(line: 21, column: 30, scope: !1746)
!1751 = !DILocation(line: 21, column: 24, scope: !1746)
!1752 = !DILocation(line: 21, column: 17, scope: !1746)
!1753 = !DILocation(line: 22, column: 24, scope: !1746)
!1754 = !DILocation(line: 22, column: 29, scope: !1746)
!1755 = !DILocation(line: 22, column: 17, scope: !1746)
!1756 = !DILocation(line: 23, column: 27, scope: !1746)
!1757 = !DILocation(line: 23, column: 32, scope: !1746)
!1758 = !DILocation(line: 23, column: 20, scope: !1746)
!1759 = !DILocation(line: 24, column: 27, scope: !1746)
!1760 = !DILocation(line: 24, column: 32, scope: !1746)
!1761 = !DILocation(line: 24, column: 52, scope: !1746)
!1762 = !DILocation(line: 24, column: 26, scope: !1746)
!1763 = !DILocation(line: 24, column: 15, scope: !1746)
!1764 = !DILocation(line: 25, column: 32, scope: !1746)
!1765 = !DILocation(line: 25, column: 37, scope: !1746)
!1766 = !DILocation(line: 25, column: 56, scope: !1746)
!1767 = !DILocation(line: 25, column: 17, scope: !1746)
!1768 = !DILocation(line: 28, column: 9, scope: !1746)
!1769 = !DILocation(line: 28, column: 18, scope: !1746)
!1770 = !DILocation(line: 29, column: 9, scope: !1746)
!1771 = !DILocation(line: 32, column: 19, scope: !1746)
!1772 = !DILocation(line: 32, column: 28, scope: !1746)
!1773 = !DILocation(line: 32, column: 9, scope: !1746)
!1774 = !DILocation(line: 33, column: 16, scope: !1746)
!1775 = !DILocation(line: 33, column: 21, scope: !1746)
!1776 = !DILocation(line: 33, column: 9, scope: !1746)
!1777 = !DILocation(line: 37, column: 9, scope: !1746)
!1778 = !DILocation(line: 37, column: 18, scope: !1746)
!1779 = !DILocation(line: 38, column: 16, scope: !1746)
!1780 = !DILocation(line: 38, column: 24, scope: !1746)
!1781 = !DILocation(line: 38, column: 58, scope: !1746)
!1782 = !DILocation(line: 38, column: 56, scope: !1746)
!1783 = !DILocation(line: 38, column: 36, scope: !1746)
!1784 = !DILocation(line: 38, column: 21, scope: !1746)
!1785 = !DILocation(line: 38, column: 9, scope: !1746)
!1786 = !DILocation(line: 40, column: 16, scope: !1746)
!1787 = !DILocation(line: 40, column: 34, scope: !1746)
!1788 = !DILocation(line: 40, column: 24, scope: !1746)
!1789 = !DILocation(line: 40, column: 50, scope: !1746)
!1790 = !DILocation(line: 40, column: 59, scope: !1746)
!1791 = !DILocation(line: 40, column: 46, scope: !1746)
!1792 = !DILocation(line: 40, column: 21, scope: !1746)
!1793 = !DILocation(line: 40, column: 9, scope: !1746)
!1794 = !DILocation(line: 41, column: 1, scope: !1746)
!1795 = distinct !DISubprogram(name: "toRep", scope: !411, file: !411, line: 231, type: !178, isLocal: true, isDefinition: true, scopeLine: 231, flags: DIFlagPrototyped, isOptimized: false, unit: !29, retainedNodes: !2)
!1796 = !DILocation(line: 232, column: 44, scope: !1795)
!1797 = !DILocation(line: 232, column: 50, scope: !1795)
!1798 = !DILocation(line: 233, column: 16, scope: !1795)
!1799 = !DILocation(line: 233, column: 5, scope: !1795)
!1800 = distinct !DISubprogram(name: "__fixsfdi", scope: !34, file: !34, line: 24, type: !178, isLocal: false, isDefinition: true, scopeLine: 25, flags: DIFlagPrototyped, isOptimized: false, unit: !33, retainedNodes: !2)
!1801 = !DILocation(line: 26, column: 9, scope: !1800)
!1802 = !DILocation(line: 26, column: 11, scope: !1800)
!1803 = !DILocation(line: 27, column: 31, scope: !1800)
!1804 = !DILocation(line: 27, column: 30, scope: !1800)
!1805 = !DILocation(line: 27, column: 17, scope: !1800)
!1806 = !DILocation(line: 27, column: 16, scope: !1800)
!1807 = !DILocation(line: 27, column: 9, scope: !1800)
!1808 = !DILocation(line: 29, column: 25, scope: !1800)
!1809 = !DILocation(line: 29, column: 12, scope: !1800)
!1810 = !DILocation(line: 29, column: 5, scope: !1800)
!1811 = !DILocation(line: 30, column: 1, scope: !1800)
!1812 = distinct !DISubprogram(name: "__fixsfsi", scope: !36, file: !36, line: 20, type: !178, isLocal: false, isDefinition: true, scopeLine: 20, flags: DIFlagPrototyped, isOptimized: false, unit: !35, retainedNodes: !2)
!1813 = !DILocation(line: 21, column: 21, scope: !1812)
!1814 = !DILocation(line: 21, column: 12, scope: !1812)
!1815 = !DILocation(line: 21, column: 5, scope: !1812)
!1816 = distinct !DISubprogram(name: "__fixint", scope: !1747, file: !1747, line: 17, type: !178, isLocal: true, isDefinition: true, scopeLine: 17, flags: DIFlagPrototyped, isOptimized: false, unit: !35, retainedNodes: !2)
!1817 = !DILocation(line: 18, column: 20, scope: !1816)
!1818 = !DILocation(line: 19, column: 20, scope: !1816)
!1819 = !DILocation(line: 21, column: 30, scope: !1816)
!1820 = !DILocation(line: 21, column: 24, scope: !1816)
!1821 = !DILocation(line: 21, column: 17, scope: !1816)
!1822 = !DILocation(line: 22, column: 24, scope: !1816)
!1823 = !DILocation(line: 22, column: 29, scope: !1816)
!1824 = !DILocation(line: 22, column: 17, scope: !1816)
!1825 = !DILocation(line: 23, column: 27, scope: !1816)
!1826 = !DILocation(line: 23, column: 32, scope: !1816)
!1827 = !DILocation(line: 23, column: 20, scope: !1816)
!1828 = !DILocation(line: 24, column: 27, scope: !1816)
!1829 = !DILocation(line: 24, column: 32, scope: !1816)
!1830 = !DILocation(line: 24, column: 52, scope: !1816)
!1831 = !DILocation(line: 24, column: 15, scope: !1816)
!1832 = !DILocation(line: 25, column: 32, scope: !1816)
!1833 = !DILocation(line: 25, column: 37, scope: !1816)
!1834 = !DILocation(line: 25, column: 56, scope: !1816)
!1835 = !DILocation(line: 25, column: 17, scope: !1816)
!1836 = !DILocation(line: 28, column: 9, scope: !1816)
!1837 = !DILocation(line: 28, column: 18, scope: !1816)
!1838 = !DILocation(line: 29, column: 9, scope: !1816)
!1839 = !DILocation(line: 32, column: 19, scope: !1816)
!1840 = !DILocation(line: 32, column: 28, scope: !1816)
!1841 = !DILocation(line: 32, column: 9, scope: !1816)
!1842 = !DILocation(line: 33, column: 16, scope: !1816)
!1843 = !DILocation(line: 33, column: 21, scope: !1816)
!1844 = !DILocation(line: 33, column: 9, scope: !1816)
!1845 = !DILocation(line: 37, column: 9, scope: !1816)
!1846 = !DILocation(line: 37, column: 18, scope: !1816)
!1847 = !DILocation(line: 38, column: 16, scope: !1816)
!1848 = !DILocation(line: 38, column: 24, scope: !1816)
!1849 = !DILocation(line: 38, column: 58, scope: !1816)
!1850 = !DILocation(line: 38, column: 56, scope: !1816)
!1851 = !DILocation(line: 38, column: 36, scope: !1816)
!1852 = !DILocation(line: 38, column: 21, scope: !1816)
!1853 = !DILocation(line: 38, column: 9, scope: !1816)
!1854 = !DILocation(line: 40, column: 16, scope: !1816)
!1855 = !DILocation(line: 40, column: 34, scope: !1816)
!1856 = !DILocation(line: 40, column: 50, scope: !1816)
!1857 = !DILocation(line: 40, column: 59, scope: !1816)
!1858 = !DILocation(line: 40, column: 46, scope: !1816)
!1859 = !DILocation(line: 40, column: 21, scope: !1816)
!1860 = !DILocation(line: 40, column: 9, scope: !1816)
!1861 = !DILocation(line: 41, column: 1, scope: !1816)
!1862 = distinct !DISubprogram(name: "toRep", scope: !411, file: !411, line: 231, type: !178, isLocal: true, isDefinition: true, scopeLine: 231, flags: DIFlagPrototyped, isOptimized: false, unit: !35, retainedNodes: !2)
!1863 = !DILocation(line: 232, column: 44, scope: !1862)
!1864 = !DILocation(line: 232, column: 50, scope: !1862)
!1865 = !DILocation(line: 233, column: 16, scope: !1862)
!1866 = !DILocation(line: 233, column: 5, scope: !1862)
!1867 = distinct !DISubprogram(name: "__fixunsdfdi", scope: !46, file: !46, line: 22, type: !178, isLocal: false, isDefinition: true, scopeLine: 23, flags: DIFlagPrototyped, isOptimized: false, unit: !45, retainedNodes: !2)
!1868 = !DILocation(line: 24, column: 9, scope: !1867)
!1869 = !DILocation(line: 24, column: 11, scope: !1867)
!1870 = !DILocation(line: 24, column: 19, scope: !1867)
!1871 = !DILocation(line: 25, column: 19, scope: !1867)
!1872 = !DILocation(line: 25, column: 21, scope: !1867)
!1873 = !DILocation(line: 25, column: 12, scope: !1867)
!1874 = !DILocation(line: 26, column: 18, scope: !1867)
!1875 = !DILocation(line: 26, column: 30, scope: !1867)
!1876 = !DILocation(line: 26, column: 22, scope: !1867)
!1877 = !DILocation(line: 26, column: 35, scope: !1867)
!1878 = !DILocation(line: 26, column: 20, scope: !1867)
!1879 = !DILocation(line: 26, column: 12, scope: !1867)
!1880 = !DILocation(line: 27, column: 21, scope: !1867)
!1881 = !DILocation(line: 27, column: 13, scope: !1867)
!1882 = !DILocation(line: 27, column: 26, scope: !1867)
!1883 = !DILocation(line: 27, column: 35, scope: !1867)
!1884 = !DILocation(line: 27, column: 33, scope: !1867)
!1885 = !DILocation(line: 27, column: 5, scope: !1867)
!1886 = !DILocation(line: 28, column: 1, scope: !1867)
!1887 = distinct !DISubprogram(name: "__fixunsdfsi", scope: !48, file: !48, line: 19, type: !178, isLocal: false, isDefinition: true, scopeLine: 19, flags: DIFlagPrototyped, isOptimized: false, unit: !47, retainedNodes: !2)
!1888 = !DILocation(line: 20, column: 22, scope: !1887)
!1889 = !DILocation(line: 20, column: 12, scope: !1887)
!1890 = !DILocation(line: 20, column: 5, scope: !1887)
!1891 = distinct !DISubprogram(name: "__fixuint", scope: !1892, file: !1892, line: 17, type: !178, isLocal: true, isDefinition: true, scopeLine: 17, flags: DIFlagPrototyped, isOptimized: false, unit: !47, retainedNodes: !2)
!1892 = !DIFile(filename: "/home/hahns/Schreibtisch/llvmta_testcases/libraries/builtinsfloat/fp_fixuint_impl.inc", directory: "/home/hahns/Schreibtisch/llvmta_testcases/tmp.0b9rXPKPan")
!1893 = !DILocation(line: 19, column: 30, scope: !1891)
!1894 = !DILocation(line: 19, column: 24, scope: !1891)
!1895 = !DILocation(line: 19, column: 17, scope: !1891)
!1896 = !DILocation(line: 20, column: 24, scope: !1891)
!1897 = !DILocation(line: 20, column: 29, scope: !1891)
!1898 = !DILocation(line: 20, column: 17, scope: !1891)
!1899 = !DILocation(line: 21, column: 22, scope: !1891)
!1900 = !DILocation(line: 21, column: 27, scope: !1891)
!1901 = !DILocation(line: 21, column: 15, scope: !1891)
!1902 = !DILocation(line: 22, column: 27, scope: !1891)
!1903 = !DILocation(line: 22, column: 32, scope: !1891)
!1904 = !DILocation(line: 22, column: 52, scope: !1891)
!1905 = !DILocation(line: 22, column: 26, scope: !1891)
!1906 = !DILocation(line: 22, column: 15, scope: !1891)
!1907 = !DILocation(line: 23, column: 32, scope: !1891)
!1908 = !DILocation(line: 23, column: 37, scope: !1891)
!1909 = !DILocation(line: 23, column: 56, scope: !1891)
!1910 = !DILocation(line: 23, column: 17, scope: !1891)
!1911 = !DILocation(line: 26, column: 9, scope: !1891)
!1912 = !DILocation(line: 26, column: 14, scope: !1891)
!1913 = !DILocation(line: 26, column: 20, scope: !1891)
!1914 = !DILocation(line: 26, column: 23, scope: !1891)
!1915 = !DILocation(line: 26, column: 32, scope: !1891)
!1916 = !DILocation(line: 27, column: 9, scope: !1891)
!1917 = !DILocation(line: 30, column: 19, scope: !1891)
!1918 = !DILocation(line: 30, column: 28, scope: !1891)
!1919 = !DILocation(line: 30, column: 9, scope: !1891)
!1920 = !DILocation(line: 31, column: 9, scope: !1891)
!1921 = !DILocation(line: 35, column: 9, scope: !1891)
!1922 = !DILocation(line: 35, column: 18, scope: !1891)
!1923 = !DILocation(line: 36, column: 16, scope: !1891)
!1924 = !DILocation(line: 36, column: 50, scope: !1891)
!1925 = !DILocation(line: 36, column: 48, scope: !1891)
!1926 = !DILocation(line: 36, column: 28, scope: !1891)
!1927 = !DILocation(line: 36, column: 9, scope: !1891)
!1928 = !DILocation(line: 38, column: 27, scope: !1891)
!1929 = !DILocation(line: 38, column: 16, scope: !1891)
!1930 = !DILocation(line: 38, column: 43, scope: !1891)
!1931 = !DILocation(line: 38, column: 52, scope: !1891)
!1932 = !DILocation(line: 38, column: 39, scope: !1891)
!1933 = !DILocation(line: 38, column: 9, scope: !1891)
!1934 = !DILocation(line: 39, column: 1, scope: !1891)
!1935 = distinct !DISubprogram(name: "toRep", scope: !411, file: !411, line: 231, type: !178, isLocal: true, isDefinition: true, scopeLine: 231, flags: DIFlagPrototyped, isOptimized: false, unit: !47, retainedNodes: !2)
!1936 = !DILocation(line: 232, column: 44, scope: !1935)
!1937 = !DILocation(line: 232, column: 50, scope: !1935)
!1938 = !DILocation(line: 233, column: 16, scope: !1935)
!1939 = !DILocation(line: 233, column: 5, scope: !1935)
!1940 = distinct !DISubprogram(name: "__fixunssfdi", scope: !52, file: !52, line: 22, type: !178, isLocal: false, isDefinition: true, scopeLine: 23, flags: DIFlagPrototyped, isOptimized: false, unit: !51, retainedNodes: !2)
!1941 = !DILocation(line: 24, column: 9, scope: !1940)
!1942 = !DILocation(line: 24, column: 11, scope: !1940)
!1943 = !DILocation(line: 24, column: 20, scope: !1940)
!1944 = !DILocation(line: 25, column: 17, scope: !1940)
!1945 = !DILocation(line: 25, column: 12, scope: !1940)
!1946 = !DILocation(line: 26, column: 19, scope: !1940)
!1947 = !DILocation(line: 26, column: 22, scope: !1940)
!1948 = !DILocation(line: 26, column: 12, scope: !1940)
!1949 = !DILocation(line: 27, column: 18, scope: !1940)
!1950 = !DILocation(line: 27, column: 31, scope: !1940)
!1951 = !DILocation(line: 27, column: 23, scope: !1940)
!1952 = !DILocation(line: 27, column: 36, scope: !1940)
!1953 = !DILocation(line: 27, column: 21, scope: !1940)
!1954 = !DILocation(line: 27, column: 12, scope: !1940)
!1955 = !DILocation(line: 28, column: 21, scope: !1940)
!1956 = !DILocation(line: 28, column: 13, scope: !1940)
!1957 = !DILocation(line: 28, column: 26, scope: !1940)
!1958 = !DILocation(line: 28, column: 35, scope: !1940)
!1959 = !DILocation(line: 28, column: 33, scope: !1940)
!1960 = !DILocation(line: 28, column: 5, scope: !1940)
!1961 = !DILocation(line: 29, column: 1, scope: !1940)
!1962 = distinct !DISubprogram(name: "__fixunssfsi", scope: !54, file: !54, line: 23, type: !178, isLocal: false, isDefinition: true, scopeLine: 23, flags: DIFlagPrototyped, isOptimized: false, unit: !53, retainedNodes: !2)
!1963 = !DILocation(line: 24, column: 22, scope: !1962)
!1964 = !DILocation(line: 24, column: 12, scope: !1962)
!1965 = !DILocation(line: 24, column: 5, scope: !1962)
!1966 = distinct !DISubprogram(name: "__fixuint", scope: !1892, file: !1892, line: 17, type: !178, isLocal: true, isDefinition: true, scopeLine: 17, flags: DIFlagPrototyped, isOptimized: false, unit: !53, retainedNodes: !2)
!1967 = !DILocation(line: 19, column: 30, scope: !1966)
!1968 = !DILocation(line: 19, column: 24, scope: !1966)
!1969 = !DILocation(line: 19, column: 17, scope: !1966)
!1970 = !DILocation(line: 20, column: 24, scope: !1966)
!1971 = !DILocation(line: 20, column: 29, scope: !1966)
!1972 = !DILocation(line: 20, column: 17, scope: !1966)
!1973 = !DILocation(line: 21, column: 22, scope: !1966)
!1974 = !DILocation(line: 21, column: 27, scope: !1966)
!1975 = !DILocation(line: 21, column: 15, scope: !1966)
!1976 = !DILocation(line: 22, column: 27, scope: !1966)
!1977 = !DILocation(line: 22, column: 32, scope: !1966)
!1978 = !DILocation(line: 22, column: 52, scope: !1966)
!1979 = !DILocation(line: 22, column: 15, scope: !1966)
!1980 = !DILocation(line: 23, column: 32, scope: !1966)
!1981 = !DILocation(line: 23, column: 37, scope: !1966)
!1982 = !DILocation(line: 23, column: 56, scope: !1966)
!1983 = !DILocation(line: 23, column: 17, scope: !1966)
!1984 = !DILocation(line: 26, column: 9, scope: !1966)
!1985 = !DILocation(line: 26, column: 14, scope: !1966)
!1986 = !DILocation(line: 26, column: 20, scope: !1966)
!1987 = !DILocation(line: 26, column: 23, scope: !1966)
!1988 = !DILocation(line: 26, column: 32, scope: !1966)
!1989 = !DILocation(line: 27, column: 9, scope: !1966)
!1990 = !DILocation(line: 30, column: 19, scope: !1966)
!1991 = !DILocation(line: 30, column: 28, scope: !1966)
!1992 = !DILocation(line: 30, column: 9, scope: !1966)
!1993 = !DILocation(line: 31, column: 9, scope: !1966)
!1994 = !DILocation(line: 35, column: 9, scope: !1966)
!1995 = !DILocation(line: 35, column: 18, scope: !1966)
!1996 = !DILocation(line: 36, column: 16, scope: !1966)
!1997 = !DILocation(line: 36, column: 50, scope: !1966)
!1998 = !DILocation(line: 36, column: 48, scope: !1966)
!1999 = !DILocation(line: 36, column: 28, scope: !1966)
!2000 = !DILocation(line: 36, column: 9, scope: !1966)
!2001 = !DILocation(line: 38, column: 27, scope: !1966)
!2002 = !DILocation(line: 38, column: 43, scope: !1966)
!2003 = !DILocation(line: 38, column: 52, scope: !1966)
!2004 = !DILocation(line: 38, column: 39, scope: !1966)
!2005 = !DILocation(line: 38, column: 9, scope: !1966)
!2006 = !DILocation(line: 39, column: 1, scope: !1966)
!2007 = distinct !DISubprogram(name: "toRep", scope: !411, file: !411, line: 231, type: !178, isLocal: true, isDefinition: true, scopeLine: 231, flags: DIFlagPrototyped, isOptimized: false, unit: !53, retainedNodes: !2)
!2008 = !DILocation(line: 232, column: 44, scope: !2007)
!2009 = !DILocation(line: 232, column: 50, scope: !2007)
!2010 = !DILocation(line: 233, column: 16, scope: !2007)
!2011 = !DILocation(line: 233, column: 5, scope: !2007)
!2012 = distinct !DISubprogram(name: "__fixunsxfdi", scope: !64, file: !64, line: 34, type: !178, isLocal: false, isDefinition: true, scopeLine: 35, flags: DIFlagPrototyped, isOptimized: false, unit: !63, retainedNodes: !2)
!2013 = !DILocation(line: 37, column: 12, scope: !2012)
!2014 = !DILocation(line: 37, column: 8, scope: !2012)
!2015 = !DILocation(line: 37, column: 10, scope: !2012)
!2016 = !DILocation(line: 38, column: 17, scope: !2012)
!2017 = !DILocation(line: 38, column: 19, scope: !2012)
!2018 = !DILocation(line: 38, column: 24, scope: !2012)
!2019 = !DILocation(line: 38, column: 26, scope: !2012)
!2020 = !DILocation(line: 38, column: 30, scope: !2012)
!2021 = !DILocation(line: 38, column: 44, scope: !2012)
!2022 = !DILocation(line: 38, column: 9, scope: !2012)
!2023 = !DILocation(line: 39, column: 9, scope: !2012)
!2024 = !DILocation(line: 39, column: 11, scope: !2012)
!2025 = !DILocation(line: 39, column: 15, scope: !2012)
!2026 = !DILocation(line: 39, column: 22, scope: !2012)
!2027 = !DILocation(line: 39, column: 24, scope: !2012)
!2028 = !DILocation(line: 39, column: 29, scope: !2012)
!2029 = !DILocation(line: 39, column: 31, scope: !2012)
!2030 = !DILocation(line: 39, column: 35, scope: !2012)
!2031 = !DILocation(line: 40, column: 9, scope: !2012)
!2032 = !DILocation(line: 41, column: 19, scope: !2012)
!2033 = !DILocation(line: 41, column: 21, scope: !2012)
!2034 = !DILocation(line: 41, column: 9, scope: !2012)
!2035 = !DILocation(line: 42, column: 9, scope: !2012)
!2036 = !DILocation(line: 43, column: 15, scope: !2012)
!2037 = !DILocation(line: 43, column: 17, scope: !2012)
!2038 = !DILocation(line: 43, column: 21, scope: !2012)
!2039 = !DILocation(line: 43, column: 34, scope: !2012)
!2040 = !DILocation(line: 43, column: 32, scope: !2012)
!2041 = !DILocation(line: 43, column: 25, scope: !2012)
!2042 = !DILocation(line: 43, column: 5, scope: !2012)
!2043 = !DILocation(line: 44, column: 1, scope: !2012)
!2044 = distinct !DISubprogram(name: "__fixunsxfsi", scope: !66, file: !66, line: 33, type: !178, isLocal: false, isDefinition: true, scopeLine: 34, flags: DIFlagPrototyped, isOptimized: false, unit: !65, retainedNodes: !2)
!2045 = !DILocation(line: 36, column: 12, scope: !2044)
!2046 = !DILocation(line: 36, column: 8, scope: !2044)
!2047 = !DILocation(line: 36, column: 10, scope: !2044)
!2048 = !DILocation(line: 37, column: 17, scope: !2044)
!2049 = !DILocation(line: 37, column: 19, scope: !2044)
!2050 = !DILocation(line: 37, column: 24, scope: !2044)
!2051 = !DILocation(line: 37, column: 26, scope: !2044)
!2052 = !DILocation(line: 37, column: 30, scope: !2044)
!2053 = !DILocation(line: 37, column: 44, scope: !2044)
!2054 = !DILocation(line: 37, column: 9, scope: !2044)
!2055 = !DILocation(line: 38, column: 9, scope: !2044)
!2056 = !DILocation(line: 38, column: 11, scope: !2044)
!2057 = !DILocation(line: 38, column: 15, scope: !2044)
!2058 = !DILocation(line: 38, column: 22, scope: !2044)
!2059 = !DILocation(line: 38, column: 24, scope: !2044)
!2060 = !DILocation(line: 38, column: 29, scope: !2044)
!2061 = !DILocation(line: 38, column: 31, scope: !2044)
!2062 = !DILocation(line: 38, column: 35, scope: !2044)
!2063 = !DILocation(line: 39, column: 9, scope: !2044)
!2064 = !DILocation(line: 40, column: 19, scope: !2044)
!2065 = !DILocation(line: 40, column: 21, scope: !2044)
!2066 = !DILocation(line: 40, column: 9, scope: !2044)
!2067 = !DILocation(line: 41, column: 9, scope: !2044)
!2068 = !DILocation(line: 42, column: 15, scope: !2044)
!2069 = !DILocation(line: 42, column: 17, scope: !2044)
!2070 = !DILocation(line: 42, column: 21, scope: !2044)
!2071 = !DILocation(line: 42, column: 23, scope: !2044)
!2072 = !DILocation(line: 42, column: 37, scope: !2044)
!2073 = !DILocation(line: 42, column: 35, scope: !2044)
!2074 = !DILocation(line: 42, column: 28, scope: !2044)
!2075 = !DILocation(line: 42, column: 5, scope: !2044)
!2076 = !DILocation(line: 43, column: 1, scope: !2044)
!2077 = distinct !DISubprogram(name: "__fixxfdi", scope: !70, file: !70, line: 31, type: !178, isLocal: false, isDefinition: true, scopeLine: 32, flags: DIFlagPrototyped, isOptimized: false, unit: !69, retainedNodes: !2)
!2078 = !DILocation(line: 33, column: 18, scope: !2077)
!2079 = !DILocation(line: 34, column: 18, scope: !2077)
!2080 = !DILocation(line: 36, column: 12, scope: !2077)
!2081 = !DILocation(line: 36, column: 8, scope: !2077)
!2082 = !DILocation(line: 36, column: 10, scope: !2077)
!2083 = !DILocation(line: 37, column: 17, scope: !2077)
!2084 = !DILocation(line: 37, column: 19, scope: !2077)
!2085 = !DILocation(line: 37, column: 24, scope: !2077)
!2086 = !DILocation(line: 37, column: 26, scope: !2077)
!2087 = !DILocation(line: 37, column: 30, scope: !2077)
!2088 = !DILocation(line: 37, column: 44, scope: !2077)
!2089 = !DILocation(line: 37, column: 9, scope: !2077)
!2090 = !DILocation(line: 38, column: 9, scope: !2077)
!2091 = !DILocation(line: 38, column: 11, scope: !2077)
!2092 = !DILocation(line: 39, column: 9, scope: !2077)
!2093 = !DILocation(line: 40, column: 19, scope: !2077)
!2094 = !DILocation(line: 40, column: 21, scope: !2077)
!2095 = !DILocation(line: 40, column: 9, scope: !2077)
!2096 = !DILocation(line: 41, column: 16, scope: !2077)
!2097 = !DILocation(line: 41, column: 18, scope: !2077)
!2098 = !DILocation(line: 41, column: 9, scope: !2077)
!2099 = !DILocation(line: 42, column: 30, scope: !2077)
!2100 = !DILocation(line: 42, column: 32, scope: !2077)
!2101 = !DILocation(line: 42, column: 37, scope: !2077)
!2102 = !DILocation(line: 42, column: 39, scope: !2077)
!2103 = !DILocation(line: 42, column: 43, scope: !2077)
!2104 = !DILocation(line: 42, column: 57, scope: !2077)
!2105 = !DILocation(line: 42, column: 16, scope: !2077)
!2106 = !DILocation(line: 42, column: 12, scope: !2077)
!2107 = !DILocation(line: 43, column: 19, scope: !2077)
!2108 = !DILocation(line: 43, column: 21, scope: !2077)
!2109 = !DILocation(line: 43, column: 25, scope: !2077)
!2110 = !DILocation(line: 43, column: 12, scope: !2077)
!2111 = !DILocation(line: 44, column: 17, scope: !2077)
!2112 = !DILocation(line: 44, column: 28, scope: !2077)
!2113 = !DILocation(line: 44, column: 26, scope: !2077)
!2114 = !DILocation(line: 44, column: 19, scope: !2077)
!2115 = !DILocation(line: 44, column: 7, scope: !2077)
!2116 = !DILocation(line: 45, column: 13, scope: !2077)
!2117 = !DILocation(line: 45, column: 17, scope: !2077)
!2118 = !DILocation(line: 45, column: 15, scope: !2077)
!2119 = !DILocation(line: 45, column: 22, scope: !2077)
!2120 = !DILocation(line: 45, column: 20, scope: !2077)
!2121 = !DILocation(line: 45, column: 5, scope: !2077)
!2122 = !DILocation(line: 46, column: 1, scope: !2077)
!2123 = distinct !DISubprogram(name: "__floatdidf", scope: !74, file: !74, line: 33, type: !178, isLocal: false, isDefinition: true, scopeLine: 34, flags: DIFlagPrototyped, isOptimized: false, unit: !73, retainedNodes: !2)
!2124 = !DILocation(line: 38, column: 36, scope: !2123)
!2125 = !DILocation(line: 40, column: 35, scope: !2123)
!2126 = !DILocation(line: 40, column: 37, scope: !2123)
!2127 = !DILocation(line: 40, column: 25, scope: !2123)
!2128 = !DILocation(line: 40, column: 44, scope: !2123)
!2129 = !DILocation(line: 40, column: 18, scope: !2123)
!2130 = !DILocation(line: 41, column: 14, scope: !2123)
!2131 = !DILocation(line: 41, column: 16, scope: !2123)
!2132 = !DILocation(line: 41, column: 9, scope: !2123)
!2133 = !DILocation(line: 41, column: 11, scope: !2123)
!2134 = !DILocation(line: 43, column: 28, scope: !2123)
!2135 = !DILocation(line: 43, column: 33, scope: !2123)
!2136 = !DILocation(line: 43, column: 49, scope: !2123)
!2137 = !DILocation(line: 43, column: 43, scope: !2123)
!2138 = !DILocation(line: 43, column: 18, scope: !2123)
!2139 = !DILocation(line: 44, column: 12, scope: !2123)
!2140 = !DILocation(line: 44, column: 5, scope: !2123)
!2141 = distinct !DISubprogram(name: "__floatdisf", scope: !76, file: !76, line: 28, type: !178, isLocal: false, isDefinition: true, scopeLine: 29, flags: DIFlagPrototyped, isOptimized: false, unit: !75, retainedNodes: !2)
!2142 = !DILocation(line: 30, column: 9, scope: !2141)
!2143 = !DILocation(line: 30, column: 11, scope: !2141)
!2144 = !DILocation(line: 31, column: 9, scope: !2141)
!2145 = !DILocation(line: 32, column: 20, scope: !2141)
!2146 = !DILocation(line: 33, column: 22, scope: !2141)
!2147 = !DILocation(line: 33, column: 24, scope: !2141)
!2148 = !DILocation(line: 33, column: 18, scope: !2141)
!2149 = !DILocation(line: 34, column: 10, scope: !2141)
!2150 = !DILocation(line: 34, column: 14, scope: !2141)
!2151 = !DILocation(line: 34, column: 12, scope: !2141)
!2152 = !DILocation(line: 34, column: 19, scope: !2141)
!2153 = !DILocation(line: 34, column: 17, scope: !2141)
!2154 = !DILocation(line: 34, column: 7, scope: !2141)
!2155 = !DILocation(line: 35, column: 34, scope: !2141)
!2156 = !DILocation(line: 35, column: 18, scope: !2141)
!2157 = !DILocation(line: 35, column: 16, scope: !2141)
!2158 = !DILocation(line: 35, column: 9, scope: !2141)
!2159 = !DILocation(line: 36, column: 13, scope: !2141)
!2160 = !DILocation(line: 36, column: 16, scope: !2141)
!2161 = !DILocation(line: 36, column: 9, scope: !2141)
!2162 = !DILocation(line: 37, column: 9, scope: !2141)
!2163 = !DILocation(line: 37, column: 12, scope: !2141)
!2164 = !DILocation(line: 47, column: 17, scope: !2141)
!2165 = !DILocation(line: 47, column: 9, scope: !2141)
!2166 = !DILocation(line: 50, column: 15, scope: !2141)
!2167 = !DILocation(line: 51, column: 13, scope: !2141)
!2168 = !DILocation(line: 53, column: 13, scope: !2141)
!2169 = !DILocation(line: 55, column: 26, scope: !2141)
!2170 = !DILocation(line: 55, column: 32, scope: !2141)
!2171 = !DILocation(line: 55, column: 35, scope: !2141)
!2172 = !DILocation(line: 55, column: 28, scope: !2141)
!2173 = !DILocation(line: 56, column: 19, scope: !2141)
!2174 = !DILocation(line: 56, column: 64, scope: !2141)
!2175 = !DILocation(line: 56, column: 62, scope: !2141)
!2176 = !DILocation(line: 56, column: 37, scope: !2141)
!2177 = !DILocation(line: 56, column: 21, scope: !2141)
!2178 = !DILocation(line: 56, column: 70, scope: !2141)
!2179 = !DILocation(line: 56, column: 17, scope: !2141)
!2180 = !DILocation(line: 55, column: 56, scope: !2141)
!2181 = !DILocation(line: 55, column: 15, scope: !2141)
!2182 = !DILocation(line: 57, column: 9, scope: !2141)
!2183 = !DILocation(line: 59, column: 15, scope: !2141)
!2184 = !DILocation(line: 59, column: 17, scope: !2141)
!2185 = !DILocation(line: 59, column: 22, scope: !2141)
!2186 = !DILocation(line: 59, column: 14, scope: !2141)
!2187 = !DILocation(line: 59, column: 11, scope: !2141)
!2188 = !DILocation(line: 60, column: 9, scope: !2141)
!2189 = !DILocation(line: 61, column: 11, scope: !2141)
!2190 = !DILocation(line: 63, column: 13, scope: !2141)
!2191 = !DILocation(line: 63, column: 15, scope: !2141)
!2192 = !DILocation(line: 65, column: 15, scope: !2141)
!2193 = !DILocation(line: 66, column: 13, scope: !2141)
!2194 = !DILocation(line: 67, column: 9, scope: !2141)
!2195 = !DILocation(line: 69, column: 5, scope: !2141)
!2196 = !DILocation(line: 72, column: 31, scope: !2141)
!2197 = !DILocation(line: 72, column: 29, scope: !2141)
!2198 = !DILocation(line: 72, column: 11, scope: !2141)
!2199 = !DILocation(line: 76, column: 21, scope: !2141)
!2200 = !DILocation(line: 76, column: 13, scope: !2141)
!2201 = !DILocation(line: 76, column: 23, scope: !2141)
!2202 = !DILocation(line: 77, column: 14, scope: !2141)
!2203 = !DILocation(line: 77, column: 16, scope: !2141)
!2204 = !DILocation(line: 77, column: 23, scope: !2141)
!2205 = !DILocation(line: 76, column: 37, scope: !2141)
!2206 = !DILocation(line: 78, column: 21, scope: !2141)
!2207 = !DILocation(line: 78, column: 13, scope: !2141)
!2208 = !DILocation(line: 78, column: 23, scope: !2141)
!2209 = !DILocation(line: 77, column: 36, scope: !2141)
!2210 = !DILocation(line: 76, column: 8, scope: !2141)
!2211 = !DILocation(line: 76, column: 10, scope: !2141)
!2212 = !DILocation(line: 79, column: 15, scope: !2141)
!2213 = !DILocation(line: 79, column: 5, scope: !2141)
!2214 = !DILocation(line: 80, column: 1, scope: !2141)
!2215 = distinct !DISubprogram(name: "__floatdixf", scope: !80, file: !80, line: 30, type: !178, isLocal: false, isDefinition: true, scopeLine: 31, flags: DIFlagPrototyped, isOptimized: false, unit: !79, retainedNodes: !2)
!2216 = !DILocation(line: 32, column: 9, scope: !2215)
!2217 = !DILocation(line: 32, column: 11, scope: !2215)
!2218 = !DILocation(line: 33, column: 9, scope: !2215)
!2219 = !DILocation(line: 34, column: 20, scope: !2215)
!2220 = !DILocation(line: 35, column: 22, scope: !2215)
!2221 = !DILocation(line: 35, column: 24, scope: !2215)
!2222 = !DILocation(line: 35, column: 18, scope: !2215)
!2223 = !DILocation(line: 36, column: 10, scope: !2215)
!2224 = !DILocation(line: 36, column: 14, scope: !2215)
!2225 = !DILocation(line: 36, column: 12, scope: !2215)
!2226 = !DILocation(line: 36, column: 19, scope: !2215)
!2227 = !DILocation(line: 36, column: 17, scope: !2215)
!2228 = !DILocation(line: 36, column: 7, scope: !2215)
!2229 = !DILocation(line: 37, column: 31, scope: !2215)
!2230 = !DILocation(line: 37, column: 15, scope: !2215)
!2231 = !DILocation(line: 37, column: 9, scope: !2215)
!2232 = !DILocation(line: 38, column: 23, scope: !2215)
!2233 = !DILocation(line: 38, column: 21, scope: !2215)
!2234 = !DILocation(line: 38, column: 9, scope: !2215)
!2235 = !DILocation(line: 40, column: 32, scope: !2215)
!2236 = !DILocation(line: 40, column: 24, scope: !2215)
!2237 = !DILocation(line: 40, column: 34, scope: !2215)
!2238 = !DILocation(line: 41, column: 10, scope: !2215)
!2239 = !DILocation(line: 41, column: 12, scope: !2215)
!2240 = !DILocation(line: 40, column: 48, scope: !2215)
!2241 = !DILocation(line: 40, column: 8, scope: !2215)
!2242 = !DILocation(line: 40, column: 10, scope: !2215)
!2243 = !DILocation(line: 40, column: 15, scope: !2215)
!2244 = !DILocation(line: 40, column: 17, scope: !2215)
!2245 = !DILocation(line: 40, column: 21, scope: !2215)
!2246 = !DILocation(line: 42, column: 20, scope: !2215)
!2247 = !DILocation(line: 42, column: 25, scope: !2215)
!2248 = !DILocation(line: 42, column: 22, scope: !2215)
!2249 = !DILocation(line: 42, column: 8, scope: !2215)
!2250 = !DILocation(line: 42, column: 10, scope: !2215)
!2251 = !DILocation(line: 42, column: 14, scope: !2215)
!2252 = !DILocation(line: 42, column: 18, scope: !2215)
!2253 = !DILocation(line: 43, column: 15, scope: !2215)
!2254 = !DILocation(line: 43, column: 5, scope: !2215)
!2255 = !DILocation(line: 44, column: 1, scope: !2215)
!2256 = distinct !DISubprogram(name: "__floatsidf", scope: !82, file: !82, line: 24, type: !178, isLocal: false, isDefinition: true, scopeLine: 24, flags: DIFlagPrototyped, isOptimized: false, unit: !81, retainedNodes: !2)
!2257 = !DILocation(line: 26, column: 15, scope: !2256)
!2258 = !DILocation(line: 29, column: 9, scope: !2256)
!2259 = !DILocation(line: 29, column: 11, scope: !2256)
!2260 = !DILocation(line: 30, column: 16, scope: !2256)
!2261 = !DILocation(line: 30, column: 9, scope: !2256)
!2262 = !DILocation(line: 33, column: 11, scope: !2256)
!2263 = !DILocation(line: 34, column: 9, scope: !2256)
!2264 = !DILocation(line: 34, column: 11, scope: !2256)
!2265 = !DILocation(line: 35, column: 14, scope: !2256)
!2266 = !DILocation(line: 36, column: 14, scope: !2256)
!2267 = !DILocation(line: 36, column: 13, scope: !2256)
!2268 = !DILocation(line: 36, column: 11, scope: !2256)
!2269 = !DILocation(line: 37, column: 5, scope: !2256)
!2270 = !DILocation(line: 40, column: 55, scope: !2256)
!2271 = !DILocation(line: 40, column: 41, scope: !2256)
!2272 = !DILocation(line: 40, column: 39, scope: !2256)
!2273 = !DILocation(line: 40, column: 15, scope: !2256)
!2274 = !DILocation(line: 46, column: 41, scope: !2256)
!2275 = !DILocation(line: 46, column: 39, scope: !2256)
!2276 = !DILocation(line: 46, column: 15, scope: !2256)
!2277 = !DILocation(line: 47, column: 35, scope: !2256)
!2278 = !DILocation(line: 47, column: 14, scope: !2256)
!2279 = !DILocation(line: 47, column: 40, scope: !2256)
!2280 = !DILocation(line: 47, column: 37, scope: !2256)
!2281 = !DILocation(line: 47, column: 46, scope: !2256)
!2282 = !DILocation(line: 47, column: 12, scope: !2256)
!2283 = !DILocation(line: 50, column: 23, scope: !2256)
!2284 = !DILocation(line: 50, column: 32, scope: !2256)
!2285 = !DILocation(line: 50, column: 15, scope: !2256)
!2286 = !DILocation(line: 50, column: 48, scope: !2256)
!2287 = !DILocation(line: 50, column: 12, scope: !2256)
!2288 = !DILocation(line: 52, column: 20, scope: !2256)
!2289 = !DILocation(line: 52, column: 29, scope: !2256)
!2290 = !DILocation(line: 52, column: 27, scope: !2256)
!2291 = !DILocation(line: 52, column: 12, scope: !2256)
!2292 = !DILocation(line: 52, column: 5, scope: !2256)
!2293 = !DILocation(line: 53, column: 1, scope: !2256)
!2294 = distinct !DISubprogram(name: "fromRep", scope: !411, file: !411, line: 236, type: !178, isLocal: true, isDefinition: true, scopeLine: 236, flags: DIFlagPrototyped, isOptimized: false, unit: !81, retainedNodes: !2)
!2295 = !DILocation(line: 237, column: 44, scope: !2294)
!2296 = !DILocation(line: 237, column: 50, scope: !2294)
!2297 = !DILocation(line: 238, column: 16, scope: !2294)
!2298 = !DILocation(line: 238, column: 5, scope: !2294)
!2299 = distinct !DISubprogram(name: "__floatsisf", scope: !84, file: !84, line: 24, type: !178, isLocal: false, isDefinition: true, scopeLine: 24, flags: DIFlagPrototyped, isOptimized: false, unit: !83, retainedNodes: !2)
!2300 = !DILocation(line: 26, column: 15, scope: !2299)
!2301 = !DILocation(line: 29, column: 9, scope: !2299)
!2302 = !DILocation(line: 29, column: 11, scope: !2299)
!2303 = !DILocation(line: 30, column: 16, scope: !2299)
!2304 = !DILocation(line: 30, column: 9, scope: !2299)
!2305 = !DILocation(line: 33, column: 11, scope: !2299)
!2306 = !DILocation(line: 34, column: 9, scope: !2299)
!2307 = !DILocation(line: 34, column: 11, scope: !2299)
!2308 = !DILocation(line: 35, column: 14, scope: !2299)
!2309 = !DILocation(line: 36, column: 14, scope: !2299)
!2310 = !DILocation(line: 36, column: 13, scope: !2299)
!2311 = !DILocation(line: 36, column: 11, scope: !2299)
!2312 = !DILocation(line: 37, column: 5, scope: !2299)
!2313 = !DILocation(line: 40, column: 55, scope: !2299)
!2314 = !DILocation(line: 40, column: 41, scope: !2299)
!2315 = !DILocation(line: 40, column: 39, scope: !2299)
!2316 = !DILocation(line: 40, column: 15, scope: !2299)
!2317 = !DILocation(line: 44, column: 9, scope: !2299)
!2318 = !DILocation(line: 44, column: 18, scope: !2299)
!2319 = !DILocation(line: 45, column: 45, scope: !2299)
!2320 = !DILocation(line: 45, column: 43, scope: !2299)
!2321 = !DILocation(line: 45, column: 19, scope: !2299)
!2322 = !DILocation(line: 46, column: 25, scope: !2299)
!2323 = !DILocation(line: 46, column: 30, scope: !2299)
!2324 = !DILocation(line: 46, column: 27, scope: !2299)
!2325 = !DILocation(line: 46, column: 36, scope: !2299)
!2326 = !DILocation(line: 46, column: 16, scope: !2299)
!2327 = !DILocation(line: 47, column: 5, scope: !2299)
!2328 = !DILocation(line: 48, column: 27, scope: !2299)
!2329 = !DILocation(line: 48, column: 36, scope: !2299)
!2330 = !DILocation(line: 48, column: 19, scope: !2299)
!2331 = !DILocation(line: 49, column: 25, scope: !2299)
!2332 = !DILocation(line: 49, column: 30, scope: !2299)
!2333 = !DILocation(line: 49, column: 27, scope: !2299)
!2334 = !DILocation(line: 49, column: 36, scope: !2299)
!2335 = !DILocation(line: 49, column: 16, scope: !2299)
!2336 = !DILocation(line: 50, column: 30, scope: !2299)
!2337 = !DILocation(line: 50, column: 48, scope: !2299)
!2338 = !DILocation(line: 50, column: 46, scope: !2299)
!2339 = !DILocation(line: 50, column: 32, scope: !2299)
!2340 = !DILocation(line: 50, column: 15, scope: !2299)
!2341 = !DILocation(line: 51, column: 13, scope: !2299)
!2342 = !DILocation(line: 51, column: 19, scope: !2299)
!2343 = !DILocation(line: 51, column: 36, scope: !2299)
!2344 = !DILocation(line: 51, column: 30, scope: !2299)
!2345 = !DILocation(line: 52, column: 13, scope: !2299)
!2346 = !DILocation(line: 52, column: 19, scope: !2299)
!2347 = !DILocation(line: 52, column: 41, scope: !2299)
!2348 = !DILocation(line: 52, column: 48, scope: !2299)
!2349 = !DILocation(line: 52, column: 38, scope: !2299)
!2350 = !DILocation(line: 52, column: 31, scope: !2299)
!2351 = !DILocation(line: 56, column: 23, scope: !2299)
!2352 = !DILocation(line: 56, column: 32, scope: !2299)
!2353 = !DILocation(line: 56, column: 48, scope: !2299)
!2354 = !DILocation(line: 56, column: 12, scope: !2299)
!2355 = !DILocation(line: 58, column: 20, scope: !2299)
!2356 = !DILocation(line: 58, column: 29, scope: !2299)
!2357 = !DILocation(line: 58, column: 27, scope: !2299)
!2358 = !DILocation(line: 58, column: 12, scope: !2299)
!2359 = !DILocation(line: 58, column: 5, scope: !2299)
!2360 = !DILocation(line: 59, column: 1, scope: !2299)
!2361 = distinct !DISubprogram(name: "fromRep", scope: !411, file: !411, line: 236, type: !178, isLocal: true, isDefinition: true, scopeLine: 236, flags: DIFlagPrototyped, isOptimized: false, unit: !83, retainedNodes: !2)
!2362 = !DILocation(line: 237, column: 44, scope: !2361)
!2363 = !DILocation(line: 237, column: 50, scope: !2361)
!2364 = !DILocation(line: 238, column: 16, scope: !2361)
!2365 = !DILocation(line: 238, column: 5, scope: !2361)
!2366 = distinct !DISubprogram(name: "__floatundidf", scope: !96, file: !96, line: 33, type: !178, isLocal: false, isDefinition: true, scopeLine: 34, flags: DIFlagPrototyped, isOptimized: false, unit: !95, retainedNodes: !2)
!2367 = !DILocation(line: 39, column: 37, scope: !2366)
!2368 = !DILocation(line: 40, column: 37, scope: !2366)
!2369 = !DILocation(line: 42, column: 15, scope: !2366)
!2370 = !DILocation(line: 42, column: 17, scope: !2366)
!2371 = !DILocation(line: 42, column: 10, scope: !2366)
!2372 = !DILocation(line: 42, column: 12, scope: !2366)
!2373 = !DILocation(line: 43, column: 14, scope: !2366)
!2374 = !DILocation(line: 43, column: 16, scope: !2366)
!2375 = !DILocation(line: 43, column: 9, scope: !2366)
!2376 = !DILocation(line: 43, column: 11, scope: !2366)
!2377 = !DILocation(line: 45, column: 33, scope: !2366)
!2378 = !DILocation(line: 45, column: 35, scope: !2366)
!2379 = !DILocation(line: 45, column: 63, scope: !2366)
!2380 = !DILocation(line: 45, column: 57, scope: !2366)
!2381 = !DILocation(line: 45, column: 18, scope: !2366)
!2382 = !DILocation(line: 46, column: 12, scope: !2366)
!2383 = !DILocation(line: 46, column: 5, scope: !2366)
!2384 = distinct !DISubprogram(name: "__floatundisf", scope: !98, file: !98, line: 28, type: !178, isLocal: false, isDefinition: true, scopeLine: 29, flags: DIFlagPrototyped, isOptimized: false, unit: !97, retainedNodes: !2)
!2385 = !DILocation(line: 30, column: 9, scope: !2384)
!2386 = !DILocation(line: 30, column: 11, scope: !2384)
!2387 = !DILocation(line: 31, column: 9, scope: !2384)
!2388 = !DILocation(line: 32, column: 20, scope: !2384)
!2389 = !DILocation(line: 33, column: 34, scope: !2384)
!2390 = !DILocation(line: 33, column: 18, scope: !2384)
!2391 = !DILocation(line: 33, column: 16, scope: !2384)
!2392 = !DILocation(line: 33, column: 9, scope: !2384)
!2393 = !DILocation(line: 34, column: 13, scope: !2384)
!2394 = !DILocation(line: 34, column: 16, scope: !2384)
!2395 = !DILocation(line: 34, column: 9, scope: !2384)
!2396 = !DILocation(line: 35, column: 9, scope: !2384)
!2397 = !DILocation(line: 35, column: 12, scope: !2384)
!2398 = !DILocation(line: 45, column: 17, scope: !2384)
!2399 = !DILocation(line: 45, column: 9, scope: !2384)
!2400 = !DILocation(line: 48, column: 15, scope: !2384)
!2401 = !DILocation(line: 49, column: 13, scope: !2384)
!2402 = !DILocation(line: 51, column: 13, scope: !2384)
!2403 = !DILocation(line: 53, column: 18, scope: !2384)
!2404 = !DILocation(line: 53, column: 24, scope: !2384)
!2405 = !DILocation(line: 53, column: 27, scope: !2384)
!2406 = !DILocation(line: 53, column: 20, scope: !2384)
!2407 = !DILocation(line: 54, column: 19, scope: !2384)
!2408 = !DILocation(line: 54, column: 64, scope: !2384)
!2409 = !DILocation(line: 54, column: 62, scope: !2384)
!2410 = !DILocation(line: 54, column: 37, scope: !2384)
!2411 = !DILocation(line: 54, column: 21, scope: !2384)
!2412 = !DILocation(line: 54, column: 70, scope: !2384)
!2413 = !DILocation(line: 54, column: 17, scope: !2384)
!2414 = !DILocation(line: 53, column: 48, scope: !2384)
!2415 = !DILocation(line: 53, column: 15, scope: !2384)
!2416 = !DILocation(line: 55, column: 9, scope: !2384)
!2417 = !DILocation(line: 57, column: 15, scope: !2384)
!2418 = !DILocation(line: 57, column: 17, scope: !2384)
!2419 = !DILocation(line: 57, column: 22, scope: !2384)
!2420 = !DILocation(line: 57, column: 14, scope: !2384)
!2421 = !DILocation(line: 57, column: 11, scope: !2384)
!2422 = !DILocation(line: 58, column: 9, scope: !2384)
!2423 = !DILocation(line: 59, column: 11, scope: !2384)
!2424 = !DILocation(line: 61, column: 13, scope: !2384)
!2425 = !DILocation(line: 61, column: 15, scope: !2384)
!2426 = !DILocation(line: 63, column: 15, scope: !2384)
!2427 = !DILocation(line: 64, column: 13, scope: !2384)
!2428 = !DILocation(line: 65, column: 9, scope: !2384)
!2429 = !DILocation(line: 67, column: 5, scope: !2384)
!2430 = !DILocation(line: 70, column: 31, scope: !2384)
!2431 = !DILocation(line: 70, column: 29, scope: !2384)
!2432 = !DILocation(line: 70, column: 11, scope: !2384)
!2433 = !DILocation(line: 74, column: 14, scope: !2384)
!2434 = !DILocation(line: 74, column: 16, scope: !2384)
!2435 = !DILocation(line: 74, column: 23, scope: !2384)
!2436 = !DILocation(line: 75, column: 21, scope: !2384)
!2437 = !DILocation(line: 75, column: 13, scope: !2384)
!2438 = !DILocation(line: 75, column: 23, scope: !2384)
!2439 = !DILocation(line: 74, column: 36, scope: !2384)
!2440 = !DILocation(line: 74, column: 8, scope: !2384)
!2441 = !DILocation(line: 74, column: 10, scope: !2384)
!2442 = !DILocation(line: 76, column: 15, scope: !2384)
!2443 = !DILocation(line: 76, column: 5, scope: !2384)
!2444 = !DILocation(line: 77, column: 1, scope: !2384)
!2445 = distinct !DISubprogram(name: "__floatundixf", scope: !102, file: !102, line: 29, type: !178, isLocal: false, isDefinition: true, scopeLine: 30, flags: DIFlagPrototyped, isOptimized: false, unit: !101, retainedNodes: !2)
!2446 = !DILocation(line: 31, column: 9, scope: !2445)
!2447 = !DILocation(line: 31, column: 11, scope: !2445)
!2448 = !DILocation(line: 32, column: 9, scope: !2445)
!2449 = !DILocation(line: 33, column: 20, scope: !2445)
!2450 = !DILocation(line: 34, column: 31, scope: !2445)
!2451 = !DILocation(line: 34, column: 15, scope: !2445)
!2452 = !DILocation(line: 34, column: 9, scope: !2445)
!2453 = !DILocation(line: 35, column: 23, scope: !2445)
!2454 = !DILocation(line: 35, column: 21, scope: !2445)
!2455 = !DILocation(line: 35, column: 9, scope: !2445)
!2456 = !DILocation(line: 37, column: 24, scope: !2445)
!2457 = !DILocation(line: 37, column: 26, scope: !2445)
!2458 = !DILocation(line: 37, column: 8, scope: !2445)
!2459 = !DILocation(line: 37, column: 10, scope: !2445)
!2460 = !DILocation(line: 37, column: 15, scope: !2445)
!2461 = !DILocation(line: 37, column: 17, scope: !2445)
!2462 = !DILocation(line: 37, column: 21, scope: !2445)
!2463 = !DILocation(line: 38, column: 20, scope: !2445)
!2464 = !DILocation(line: 38, column: 25, scope: !2445)
!2465 = !DILocation(line: 38, column: 22, scope: !2445)
!2466 = !DILocation(line: 38, column: 8, scope: !2445)
!2467 = !DILocation(line: 38, column: 10, scope: !2445)
!2468 = !DILocation(line: 38, column: 14, scope: !2445)
!2469 = !DILocation(line: 38, column: 18, scope: !2445)
!2470 = !DILocation(line: 39, column: 15, scope: !2445)
!2471 = !DILocation(line: 39, column: 5, scope: !2445)
!2472 = !DILocation(line: 40, column: 1, scope: !2445)
!2473 = distinct !DISubprogram(name: "__floatunsidf", scope: !104, file: !104, line: 24, type: !178, isLocal: false, isDefinition: true, scopeLine: 24, flags: DIFlagPrototyped, isOptimized: false, unit: !103, retainedNodes: !2)
!2474 = !DILocation(line: 26, column: 15, scope: !2473)
!2475 = !DILocation(line: 29, column: 9, scope: !2473)
!2476 = !DILocation(line: 29, column: 11, scope: !2473)
!2477 = !DILocation(line: 29, column: 24, scope: !2473)
!2478 = !DILocation(line: 29, column: 17, scope: !2473)
!2479 = !DILocation(line: 32, column: 55, scope: !2473)
!2480 = !DILocation(line: 32, column: 41, scope: !2473)
!2481 = !DILocation(line: 32, column: 39, scope: !2473)
!2482 = !DILocation(line: 32, column: 15, scope: !2473)
!2483 = !DILocation(line: 36, column: 41, scope: !2473)
!2484 = !DILocation(line: 36, column: 39, scope: !2473)
!2485 = !DILocation(line: 36, column: 15, scope: !2473)
!2486 = !DILocation(line: 37, column: 21, scope: !2473)
!2487 = !DILocation(line: 37, column: 14, scope: !2473)
!2488 = !DILocation(line: 37, column: 26, scope: !2473)
!2489 = !DILocation(line: 37, column: 23, scope: !2473)
!2490 = !DILocation(line: 37, column: 32, scope: !2473)
!2491 = !DILocation(line: 37, column: 12, scope: !2473)
!2492 = !DILocation(line: 40, column: 23, scope: !2473)
!2493 = !DILocation(line: 40, column: 32, scope: !2473)
!2494 = !DILocation(line: 40, column: 15, scope: !2473)
!2495 = !DILocation(line: 40, column: 48, scope: !2473)
!2496 = !DILocation(line: 40, column: 12, scope: !2473)
!2497 = !DILocation(line: 41, column: 20, scope: !2473)
!2498 = !DILocation(line: 41, column: 12, scope: !2473)
!2499 = !DILocation(line: 41, column: 5, scope: !2473)
!2500 = !DILocation(line: 42, column: 1, scope: !2473)
!2501 = distinct !DISubprogram(name: "fromRep", scope: !411, file: !411, line: 236, type: !178, isLocal: true, isDefinition: true, scopeLine: 236, flags: DIFlagPrototyped, isOptimized: false, unit: !103, retainedNodes: !2)
!2502 = !DILocation(line: 237, column: 44, scope: !2501)
!2503 = !DILocation(line: 237, column: 50, scope: !2501)
!2504 = !DILocation(line: 238, column: 16, scope: !2501)
!2505 = !DILocation(line: 238, column: 5, scope: !2501)
!2506 = distinct !DISubprogram(name: "__floatunsisf", scope: !106, file: !106, line: 24, type: !178, isLocal: false, isDefinition: true, scopeLine: 24, flags: DIFlagPrototyped, isOptimized: false, unit: !105, retainedNodes: !2)
!2507 = !DILocation(line: 26, column: 15, scope: !2506)
!2508 = !DILocation(line: 29, column: 9, scope: !2506)
!2509 = !DILocation(line: 29, column: 11, scope: !2506)
!2510 = !DILocation(line: 29, column: 24, scope: !2506)
!2511 = !DILocation(line: 29, column: 17, scope: !2506)
!2512 = !DILocation(line: 32, column: 55, scope: !2506)
!2513 = !DILocation(line: 32, column: 41, scope: !2506)
!2514 = !DILocation(line: 32, column: 39, scope: !2506)
!2515 = !DILocation(line: 32, column: 15, scope: !2506)
!2516 = !DILocation(line: 36, column: 9, scope: !2506)
!2517 = !DILocation(line: 36, column: 18, scope: !2506)
!2518 = !DILocation(line: 37, column: 45, scope: !2506)
!2519 = !DILocation(line: 37, column: 43, scope: !2506)
!2520 = !DILocation(line: 37, column: 19, scope: !2506)
!2521 = !DILocation(line: 38, column: 25, scope: !2506)
!2522 = !DILocation(line: 38, column: 30, scope: !2506)
!2523 = !DILocation(line: 38, column: 27, scope: !2506)
!2524 = !DILocation(line: 38, column: 36, scope: !2506)
!2525 = !DILocation(line: 38, column: 16, scope: !2506)
!2526 = !DILocation(line: 39, column: 5, scope: !2506)
!2527 = !DILocation(line: 40, column: 27, scope: !2506)
!2528 = !DILocation(line: 40, column: 36, scope: !2506)
!2529 = !DILocation(line: 40, column: 19, scope: !2506)
!2530 = !DILocation(line: 41, column: 25, scope: !2506)
!2531 = !DILocation(line: 41, column: 30, scope: !2506)
!2532 = !DILocation(line: 41, column: 27, scope: !2506)
!2533 = !DILocation(line: 41, column: 36, scope: !2506)
!2534 = !DILocation(line: 41, column: 16, scope: !2506)
!2535 = !DILocation(line: 42, column: 30, scope: !2506)
!2536 = !DILocation(line: 42, column: 48, scope: !2506)
!2537 = !DILocation(line: 42, column: 46, scope: !2506)
!2538 = !DILocation(line: 42, column: 32, scope: !2506)
!2539 = !DILocation(line: 42, column: 15, scope: !2506)
!2540 = !DILocation(line: 43, column: 13, scope: !2506)
!2541 = !DILocation(line: 43, column: 19, scope: !2506)
!2542 = !DILocation(line: 43, column: 36, scope: !2506)
!2543 = !DILocation(line: 43, column: 30, scope: !2506)
!2544 = !DILocation(line: 44, column: 13, scope: !2506)
!2545 = !DILocation(line: 44, column: 19, scope: !2506)
!2546 = !DILocation(line: 44, column: 41, scope: !2506)
!2547 = !DILocation(line: 44, column: 48, scope: !2506)
!2548 = !DILocation(line: 44, column: 38, scope: !2506)
!2549 = !DILocation(line: 44, column: 31, scope: !2506)
!2550 = !DILocation(line: 48, column: 23, scope: !2506)
!2551 = !DILocation(line: 48, column: 32, scope: !2506)
!2552 = !DILocation(line: 48, column: 48, scope: !2506)
!2553 = !DILocation(line: 48, column: 12, scope: !2506)
!2554 = !DILocation(line: 49, column: 20, scope: !2506)
!2555 = !DILocation(line: 49, column: 12, scope: !2506)
!2556 = !DILocation(line: 49, column: 5, scope: !2506)
!2557 = !DILocation(line: 50, column: 1, scope: !2506)
!2558 = distinct !DISubprogram(name: "fromRep", scope: !411, file: !411, line: 236, type: !178, isLocal: true, isDefinition: true, scopeLine: 236, flags: DIFlagPrototyped, isOptimized: false, unit: !105, retainedNodes: !2)
!2559 = !DILocation(line: 237, column: 44, scope: !2558)
!2560 = !DILocation(line: 237, column: 50, scope: !2558)
!2561 = !DILocation(line: 238, column: 16, scope: !2558)
!2562 = !DILocation(line: 238, column: 5, scope: !2558)
!2563 = distinct !DISubprogram(name: "compilerrt_abort_impl", scope: !118, file: !118, line: 57, type: !178, isLocal: false, isDefinition: true, scopeLine: 57, flags: DIFlagPrototyped, isOptimized: false, unit: !117, retainedNodes: !2)
!2564 = !DILocation(line: 59, column: 1, scope: !2563)
!2565 = distinct !DISubprogram(name: "__muldf3", scope: !120, file: !120, line: 20, type: !178, isLocal: false, isDefinition: true, scopeLine: 20, flags: DIFlagPrototyped, isOptimized: false, unit: !119, retainedNodes: !2)
!2566 = !DILocation(line: 21, column: 23, scope: !2565)
!2567 = !DILocation(line: 21, column: 26, scope: !2565)
!2568 = !DILocation(line: 21, column: 12, scope: !2565)
!2569 = !DILocation(line: 21, column: 5, scope: !2565)
!2570 = distinct !DISubprogram(name: "__mulXf3__", scope: !2571, file: !2571, line: 17, type: !178, isLocal: true, isDefinition: true, scopeLine: 17, flags: DIFlagPrototyped, isOptimized: false, unit: !119, retainedNodes: !2)
!2571 = !DIFile(filename: "/home/hahns/Schreibtisch/llvmta_testcases/libraries/builtinsfloat/fp_mul_impl.inc", directory: "/home/hahns/Schreibtisch/llvmta_testcases/tmp.0b9rXPKPan")
!2572 = !DILocation(line: 18, column: 42, scope: !2570)
!2573 = !DILocation(line: 18, column: 36, scope: !2570)
!2574 = !DILocation(line: 18, column: 45, scope: !2570)
!2575 = !DILocation(line: 18, column: 64, scope: !2570)
!2576 = !DILocation(line: 18, column: 24, scope: !2570)
!2577 = !DILocation(line: 19, column: 42, scope: !2570)
!2578 = !DILocation(line: 19, column: 36, scope: !2570)
!2579 = !DILocation(line: 19, column: 45, scope: !2570)
!2580 = !DILocation(line: 19, column: 64, scope: !2570)
!2581 = !DILocation(line: 19, column: 24, scope: !2570)
!2582 = !DILocation(line: 20, column: 38, scope: !2570)
!2583 = !DILocation(line: 20, column: 32, scope: !2570)
!2584 = !DILocation(line: 20, column: 49, scope: !2570)
!2585 = !DILocation(line: 20, column: 43, scope: !2570)
!2586 = !DILocation(line: 20, column: 41, scope: !2570)
!2587 = !DILocation(line: 20, column: 53, scope: !2570)
!2588 = !DILocation(line: 20, column: 17, scope: !2570)
!2589 = !DILocation(line: 22, column: 32, scope: !2570)
!2590 = !DILocation(line: 22, column: 26, scope: !2570)
!2591 = !DILocation(line: 22, column: 35, scope: !2570)
!2592 = !DILocation(line: 22, column: 11, scope: !2570)
!2593 = !DILocation(line: 23, column: 32, scope: !2570)
!2594 = !DILocation(line: 23, column: 26, scope: !2570)
!2595 = !DILocation(line: 23, column: 35, scope: !2570)
!2596 = !DILocation(line: 23, column: 11, scope: !2570)
!2597 = !DILocation(line: 24, column: 9, scope: !2570)
!2598 = !DILocation(line: 27, column: 9, scope: !2570)
!2599 = !DILocation(line: 27, column: 18, scope: !2570)
!2600 = !DILocation(line: 27, column: 22, scope: !2570)
!2601 = !DILocation(line: 27, column: 40, scope: !2570)
!2602 = !DILocation(line: 27, column: 43, scope: !2570)
!2603 = !DILocation(line: 27, column: 52, scope: !2570)
!2604 = !DILocation(line: 27, column: 56, scope: !2570)
!2605 = !DILocation(line: 29, column: 34, scope: !2570)
!2606 = !DILocation(line: 29, column: 28, scope: !2570)
!2607 = !DILocation(line: 29, column: 37, scope: !2570)
!2608 = !DILocation(line: 29, column: 21, scope: !2570)
!2609 = !DILocation(line: 30, column: 34, scope: !2570)
!2610 = !DILocation(line: 30, column: 28, scope: !2570)
!2611 = !DILocation(line: 30, column: 37, scope: !2570)
!2612 = !DILocation(line: 30, column: 21, scope: !2570)
!2613 = !DILocation(line: 33, column: 13, scope: !2570)
!2614 = !DILocation(line: 33, column: 18, scope: !2570)
!2615 = !DILocation(line: 33, column: 49, scope: !2570)
!2616 = !DILocation(line: 33, column: 43, scope: !2570)
!2617 = !DILocation(line: 33, column: 52, scope: !2570)
!2618 = !DILocation(line: 33, column: 35, scope: !2570)
!2619 = !DILocation(line: 33, column: 28, scope: !2570)
!2620 = !DILocation(line: 35, column: 13, scope: !2570)
!2621 = !DILocation(line: 35, column: 18, scope: !2570)
!2622 = !DILocation(line: 35, column: 49, scope: !2570)
!2623 = !DILocation(line: 35, column: 43, scope: !2570)
!2624 = !DILocation(line: 35, column: 52, scope: !2570)
!2625 = !DILocation(line: 35, column: 35, scope: !2570)
!2626 = !DILocation(line: 35, column: 28, scope: !2570)
!2627 = !DILocation(line: 37, column: 13, scope: !2570)
!2628 = !DILocation(line: 37, column: 18, scope: !2570)
!2629 = !DILocation(line: 39, column: 17, scope: !2570)
!2630 = !DILocation(line: 39, column: 38, scope: !2570)
!2631 = !DILocation(line: 39, column: 45, scope: !2570)
!2632 = !DILocation(line: 39, column: 43, scope: !2570)
!2633 = !DILocation(line: 39, column: 30, scope: !2570)
!2634 = !DILocation(line: 39, column: 23, scope: !2570)
!2635 = !DILocation(line: 41, column: 25, scope: !2570)
!2636 = !DILocation(line: 41, column: 18, scope: !2570)
!2637 = !DILocation(line: 44, column: 13, scope: !2570)
!2638 = !DILocation(line: 44, column: 18, scope: !2570)
!2639 = !DILocation(line: 46, column: 17, scope: !2570)
!2640 = !DILocation(line: 46, column: 38, scope: !2570)
!2641 = !DILocation(line: 46, column: 45, scope: !2570)
!2642 = !DILocation(line: 46, column: 43, scope: !2570)
!2643 = !DILocation(line: 46, column: 30, scope: !2570)
!2644 = !DILocation(line: 46, column: 23, scope: !2570)
!2645 = !DILocation(line: 48, column: 25, scope: !2570)
!2646 = !DILocation(line: 48, column: 18, scope: !2570)
!2647 = !DILocation(line: 52, column: 14, scope: !2570)
!2648 = !DILocation(line: 52, column: 13, scope: !2570)
!2649 = !DILocation(line: 52, column: 35, scope: !2570)
!2650 = !DILocation(line: 52, column: 27, scope: !2570)
!2651 = !DILocation(line: 52, column: 20, scope: !2570)
!2652 = !DILocation(line: 54, column: 14, scope: !2570)
!2653 = !DILocation(line: 54, column: 13, scope: !2570)
!2654 = !DILocation(line: 54, column: 35, scope: !2570)
!2655 = !DILocation(line: 54, column: 27, scope: !2570)
!2656 = !DILocation(line: 54, column: 20, scope: !2570)
!2657 = !DILocation(line: 59, column: 13, scope: !2570)
!2658 = !DILocation(line: 59, column: 18, scope: !2570)
!2659 = !DILocation(line: 59, column: 42, scope: !2570)
!2660 = !DILocation(line: 59, column: 39, scope: !2570)
!2661 = !DILocation(line: 59, column: 33, scope: !2570)
!2662 = !DILocation(line: 60, column: 13, scope: !2570)
!2663 = !DILocation(line: 60, column: 18, scope: !2570)
!2664 = !DILocation(line: 60, column: 42, scope: !2570)
!2665 = !DILocation(line: 60, column: 39, scope: !2570)
!2666 = !DILocation(line: 60, column: 33, scope: !2570)
!2667 = !DILocation(line: 61, column: 5, scope: !2570)
!2668 = !DILocation(line: 66, column: 18, scope: !2570)
!2669 = !DILocation(line: 67, column: 18, scope: !2570)
!2670 = !DILocation(line: 75, column: 18, scope: !2570)
!2671 = !DILocation(line: 75, column: 32, scope: !2570)
!2672 = !DILocation(line: 75, column: 45, scope: !2570)
!2673 = !DILocation(line: 75, column: 5, scope: !2570)
!2674 = !DILocation(line: 78, column: 27, scope: !2570)
!2675 = !DILocation(line: 78, column: 39, scope: !2570)
!2676 = !DILocation(line: 78, column: 37, scope: !2570)
!2677 = !DILocation(line: 78, column: 49, scope: !2570)
!2678 = !DILocation(line: 78, column: 66, scope: !2570)
!2679 = !DILocation(line: 78, column: 64, scope: !2570)
!2680 = !DILocation(line: 78, column: 9, scope: !2570)
!2681 = !DILocation(line: 81, column: 9, scope: !2570)
!2682 = !DILocation(line: 81, column: 19, scope: !2570)
!2683 = !DILocation(line: 81, column: 49, scope: !2570)
!2684 = !DILocation(line: 81, column: 34, scope: !2570)
!2685 = !DILocation(line: 82, column: 10, scope: !2570)
!2686 = !DILocation(line: 85, column: 9, scope: !2570)
!2687 = !DILocation(line: 85, column: 25, scope: !2570)
!2688 = !DILocation(line: 85, column: 65, scope: !2570)
!2689 = !DILocation(line: 85, column: 63, scope: !2570)
!2690 = !DILocation(line: 85, column: 48, scope: !2570)
!2691 = !DILocation(line: 85, column: 41, scope: !2570)
!2692 = !DILocation(line: 87, column: 9, scope: !2570)
!2693 = !DILocation(line: 87, column: 25, scope: !2570)
!2694 = !DILocation(line: 94, column: 61, scope: !2570)
!2695 = !DILocation(line: 94, column: 47, scope: !2570)
!2696 = !DILocation(line: 94, column: 45, scope: !2570)
!2697 = !DILocation(line: 94, column: 36, scope: !2570)
!2698 = !DILocation(line: 94, column: 28, scope: !2570)
!2699 = !DILocation(line: 95, column: 13, scope: !2570)
!2700 = !DILocation(line: 95, column: 19, scope: !2570)
!2701 = !DILocation(line: 95, column: 48, scope: !2570)
!2702 = !DILocation(line: 95, column: 40, scope: !2570)
!2703 = !DILocation(line: 95, column: 33, scope: !2570)
!2704 = !DILocation(line: 99, column: 58, scope: !2570)
!2705 = !DILocation(line: 99, column: 9, scope: !2570)
!2706 = !DILocation(line: 100, column: 5, scope: !2570)
!2707 = !DILocation(line: 103, column: 19, scope: !2570)
!2708 = !DILocation(line: 104, column: 29, scope: !2570)
!2709 = !DILocation(line: 104, column: 22, scope: !2570)
!2710 = !DILocation(line: 104, column: 45, scope: !2570)
!2711 = !DILocation(line: 104, column: 19, scope: !2570)
!2712 = !DILocation(line: 108, column: 18, scope: !2570)
!2713 = !DILocation(line: 108, column: 15, scope: !2570)
!2714 = !DILocation(line: 113, column: 9, scope: !2570)
!2715 = !DILocation(line: 113, column: 19, scope: !2570)
!2716 = !DILocation(line: 113, column: 39, scope: !2570)
!2717 = !DILocation(line: 113, column: 30, scope: !2570)
!2718 = !DILocation(line: 114, column: 9, scope: !2570)
!2719 = !DILocation(line: 114, column: 19, scope: !2570)
!2720 = !DILocation(line: 114, column: 44, scope: !2570)
!2721 = !DILocation(line: 114, column: 54, scope: !2570)
!2722 = !DILocation(line: 114, column: 41, scope: !2570)
!2723 = !DILocation(line: 114, column: 31, scope: !2570)
!2724 = !DILocation(line: 115, column: 20, scope: !2570)
!2725 = !DILocation(line: 115, column: 12, scope: !2570)
!2726 = !DILocation(line: 115, column: 5, scope: !2570)
!2727 = !DILocation(line: 116, column: 1, scope: !2570)
!2728 = distinct !DISubprogram(name: "toRep", scope: !411, file: !411, line: 231, type: !178, isLocal: true, isDefinition: true, scopeLine: 231, flags: DIFlagPrototyped, isOptimized: false, unit: !119, retainedNodes: !2)
!2729 = !DILocation(line: 232, column: 44, scope: !2728)
!2730 = !DILocation(line: 232, column: 50, scope: !2728)
!2731 = !DILocation(line: 233, column: 16, scope: !2728)
!2732 = !DILocation(line: 233, column: 5, scope: !2728)
!2733 = distinct !DISubprogram(name: "fromRep", scope: !411, file: !411, line: 236, type: !178, isLocal: true, isDefinition: true, scopeLine: 236, flags: DIFlagPrototyped, isOptimized: false, unit: !119, retainedNodes: !2)
!2734 = !DILocation(line: 237, column: 44, scope: !2733)
!2735 = !DILocation(line: 237, column: 50, scope: !2733)
!2736 = !DILocation(line: 238, column: 16, scope: !2733)
!2737 = !DILocation(line: 238, column: 5, scope: !2733)
!2738 = distinct !DISubprogram(name: "normalize", scope: !411, file: !411, line: 241, type: !178, isLocal: true, isDefinition: true, scopeLine: 241, flags: DIFlagPrototyped, isOptimized: false, unit: !119, retainedNodes: !2)
!2739 = !DILocation(line: 242, column: 32, scope: !2738)
!2740 = !DILocation(line: 242, column: 31, scope: !2738)
!2741 = !DILocation(line: 242, column: 23, scope: !2738)
!2742 = !DILocation(line: 242, column: 47, scope: !2738)
!2743 = !DILocation(line: 242, column: 45, scope: !2738)
!2744 = !DILocation(line: 242, column: 15, scope: !2738)
!2745 = !DILocation(line: 243, column: 22, scope: !2738)
!2746 = !DILocation(line: 243, column: 6, scope: !2738)
!2747 = !DILocation(line: 243, column: 18, scope: !2738)
!2748 = !DILocation(line: 244, column: 16, scope: !2738)
!2749 = !DILocation(line: 244, column: 14, scope: !2738)
!2750 = !DILocation(line: 244, column: 5, scope: !2738)
!2751 = distinct !DISubprogram(name: "wideMultiply", scope: !411, file: !411, line: 86, type: !178, isLocal: true, isDefinition: true, scopeLine: 86, flags: DIFlagPrototyped, isOptimized: false, unit: !119, retainedNodes: !2)
!2752 = !DILocation(line: 88, column: 28, scope: !2751)
!2753 = !DILocation(line: 88, column: 40, scope: !2751)
!2754 = !DILocation(line: 88, column: 38, scope: !2751)
!2755 = !DILocation(line: 88, column: 20, scope: !2751)
!2756 = !DILocation(line: 89, column: 28, scope: !2751)
!2757 = !DILocation(line: 89, column: 40, scope: !2751)
!2758 = !DILocation(line: 89, column: 38, scope: !2751)
!2759 = !DILocation(line: 89, column: 20, scope: !2751)
!2760 = !DILocation(line: 90, column: 28, scope: !2751)
!2761 = !DILocation(line: 90, column: 40, scope: !2751)
!2762 = !DILocation(line: 90, column: 38, scope: !2751)
!2763 = !DILocation(line: 90, column: 20, scope: !2751)
!2764 = !DILocation(line: 91, column: 28, scope: !2751)
!2765 = !DILocation(line: 91, column: 40, scope: !2751)
!2766 = !DILocation(line: 91, column: 38, scope: !2751)
!2767 = !DILocation(line: 91, column: 20, scope: !2751)
!2768 = !DILocation(line: 93, column: 25, scope: !2751)
!2769 = !DILocation(line: 93, column: 20, scope: !2751)
!2770 = !DILocation(line: 94, column: 25, scope: !2751)
!2771 = !DILocation(line: 94, column: 41, scope: !2751)
!2772 = !DILocation(line: 94, column: 39, scope: !2751)
!2773 = !DILocation(line: 94, column: 57, scope: !2751)
!2774 = !DILocation(line: 94, column: 55, scope: !2751)
!2775 = !DILocation(line: 94, column: 20, scope: !2751)
!2776 = !DILocation(line: 95, column: 11, scope: !2751)
!2777 = !DILocation(line: 95, column: 17, scope: !2751)
!2778 = !DILocation(line: 95, column: 20, scope: !2751)
!2779 = !DILocation(line: 95, column: 14, scope: !2751)
!2780 = !DILocation(line: 95, column: 6, scope: !2751)
!2781 = !DILocation(line: 95, column: 9, scope: !2751)
!2782 = !DILocation(line: 97, column: 11, scope: !2751)
!2783 = !DILocation(line: 97, column: 27, scope: !2751)
!2784 = !DILocation(line: 97, column: 25, scope: !2751)
!2785 = !DILocation(line: 97, column: 43, scope: !2751)
!2786 = !DILocation(line: 97, column: 41, scope: !2751)
!2787 = !DILocation(line: 97, column: 56, scope: !2751)
!2788 = !DILocation(line: 97, column: 54, scope: !2751)
!2789 = !DILocation(line: 97, column: 6, scope: !2751)
!2790 = !DILocation(line: 97, column: 9, scope: !2751)
!2791 = !DILocation(line: 98, column: 1, scope: !2751)
!2792 = distinct !DISubprogram(name: "wideLeftShift", scope: !411, file: !411, line: 247, type: !178, isLocal: true, isDefinition: true, scopeLine: 247, flags: DIFlagPrototyped, isOptimized: false, unit: !119, retainedNodes: !2)
!2793 = !DILocation(line: 248, column: 12, scope: !2792)
!2794 = !DILocation(line: 248, column: 11, scope: !2792)
!2795 = !DILocation(line: 248, column: 18, scope: !2792)
!2796 = !DILocation(line: 248, column: 15, scope: !2792)
!2797 = !DILocation(line: 248, column: 27, scope: !2792)
!2798 = !DILocation(line: 248, column: 26, scope: !2792)
!2799 = !DILocation(line: 248, column: 46, scope: !2792)
!2800 = !DILocation(line: 248, column: 44, scope: !2792)
!2801 = !DILocation(line: 248, column: 30, scope: !2792)
!2802 = !DILocation(line: 248, column: 24, scope: !2792)
!2803 = !DILocation(line: 248, column: 6, scope: !2792)
!2804 = !DILocation(line: 248, column: 9, scope: !2792)
!2805 = !DILocation(line: 249, column: 12, scope: !2792)
!2806 = !DILocation(line: 249, column: 11, scope: !2792)
!2807 = !DILocation(line: 249, column: 18, scope: !2792)
!2808 = !DILocation(line: 249, column: 15, scope: !2792)
!2809 = !DILocation(line: 249, column: 6, scope: !2792)
!2810 = !DILocation(line: 249, column: 9, scope: !2792)
!2811 = !DILocation(line: 250, column: 1, scope: !2792)
!2812 = distinct !DISubprogram(name: "wideRightShiftWithSticky", scope: !411, file: !411, line: 252, type: !178, isLocal: true, isDefinition: true, scopeLine: 252, flags: DIFlagPrototyped, isOptimized: false, unit: !119, retainedNodes: !2)
!2813 = !DILocation(line: 253, column: 9, scope: !2812)
!2814 = !DILocation(line: 253, column: 15, scope: !2812)
!2815 = !DILocation(line: 254, column: 30, scope: !2812)
!2816 = !DILocation(line: 254, column: 29, scope: !2812)
!2817 = !DILocation(line: 254, column: 49, scope: !2812)
!2818 = !DILocation(line: 254, column: 47, scope: !2812)
!2819 = !DILocation(line: 254, column: 33, scope: !2812)
!2820 = !DILocation(line: 254, column: 20, scope: !2812)
!2821 = !DILocation(line: 255, column: 16, scope: !2812)
!2822 = !DILocation(line: 255, column: 15, scope: !2812)
!2823 = !DILocation(line: 255, column: 35, scope: !2812)
!2824 = !DILocation(line: 255, column: 33, scope: !2812)
!2825 = !DILocation(line: 255, column: 19, scope: !2812)
!2826 = !DILocation(line: 255, column: 45, scope: !2812)
!2827 = !DILocation(line: 255, column: 44, scope: !2812)
!2828 = !DILocation(line: 255, column: 51, scope: !2812)
!2829 = !DILocation(line: 255, column: 48, scope: !2812)
!2830 = !DILocation(line: 255, column: 42, scope: !2812)
!2831 = !DILocation(line: 255, column: 59, scope: !2812)
!2832 = !DILocation(line: 255, column: 57, scope: !2812)
!2833 = !DILocation(line: 255, column: 10, scope: !2812)
!2834 = !DILocation(line: 255, column: 13, scope: !2812)
!2835 = !DILocation(line: 256, column: 16, scope: !2812)
!2836 = !DILocation(line: 256, column: 15, scope: !2812)
!2837 = !DILocation(line: 256, column: 22, scope: !2812)
!2838 = !DILocation(line: 256, column: 19, scope: !2812)
!2839 = !DILocation(line: 256, column: 10, scope: !2812)
!2840 = !DILocation(line: 256, column: 13, scope: !2812)
!2841 = !DILocation(line: 257, column: 5, scope: !2812)
!2842 = !DILocation(line: 258, column: 14, scope: !2812)
!2843 = !DILocation(line: 258, column: 20, scope: !2812)
!2844 = !DILocation(line: 259, column: 30, scope: !2812)
!2845 = !DILocation(line: 259, column: 29, scope: !2812)
!2846 = !DILocation(line: 259, column: 51, scope: !2812)
!2847 = !DILocation(line: 259, column: 49, scope: !2812)
!2848 = !DILocation(line: 259, column: 33, scope: !2812)
!2849 = !DILocation(line: 259, column: 61, scope: !2812)
!2850 = !DILocation(line: 259, column: 60, scope: !2812)
!2851 = !DILocation(line: 259, column: 58, scope: !2812)
!2852 = !DILocation(line: 259, column: 20, scope: !2812)
!2853 = !DILocation(line: 260, column: 16, scope: !2812)
!2854 = !DILocation(line: 260, column: 15, scope: !2812)
!2855 = !DILocation(line: 260, column: 23, scope: !2812)
!2856 = !DILocation(line: 260, column: 29, scope: !2812)
!2857 = !DILocation(line: 260, column: 19, scope: !2812)
!2858 = !DILocation(line: 260, column: 44, scope: !2812)
!2859 = !DILocation(line: 260, column: 42, scope: !2812)
!2860 = !DILocation(line: 260, column: 10, scope: !2812)
!2861 = !DILocation(line: 260, column: 13, scope: !2812)
!2862 = !DILocation(line: 261, column: 10, scope: !2812)
!2863 = !DILocation(line: 261, column: 13, scope: !2812)
!2864 = !DILocation(line: 262, column: 5, scope: !2812)
!2865 = !DILocation(line: 263, column: 30, scope: !2812)
!2866 = !DILocation(line: 263, column: 29, scope: !2812)
!2867 = !DILocation(line: 263, column: 36, scope: !2812)
!2868 = !DILocation(line: 263, column: 35, scope: !2812)
!2869 = !DILocation(line: 263, column: 33, scope: !2812)
!2870 = !DILocation(line: 263, column: 20, scope: !2812)
!2871 = !DILocation(line: 264, column: 15, scope: !2812)
!2872 = !DILocation(line: 264, column: 10, scope: !2812)
!2873 = !DILocation(line: 264, column: 13, scope: !2812)
!2874 = !DILocation(line: 265, column: 10, scope: !2812)
!2875 = !DILocation(line: 265, column: 13, scope: !2812)
!2876 = !DILocation(line: 267, column: 1, scope: !2812)
!2877 = distinct !DISubprogram(name: "rep_clz", scope: !411, file: !411, line: 69, type: !178, isLocal: true, isDefinition: true, scopeLine: 69, flags: DIFlagPrototyped, isOptimized: false, unit: !119, retainedNodes: !2)
!2878 = !DILocation(line: 73, column: 9, scope: !2877)
!2879 = !DILocation(line: 73, column: 11, scope: !2877)
!2880 = !DILocation(line: 74, column: 30, scope: !2877)
!2881 = !DILocation(line: 74, column: 32, scope: !2877)
!2882 = !DILocation(line: 74, column: 16, scope: !2877)
!2883 = !DILocation(line: 74, column: 9, scope: !2877)
!2884 = !DILocation(line: 76, column: 35, scope: !2877)
!2885 = !DILocation(line: 76, column: 37, scope: !2877)
!2886 = !DILocation(line: 76, column: 21, scope: !2877)
!2887 = !DILocation(line: 76, column: 19, scope: !2877)
!2888 = !DILocation(line: 76, column: 9, scope: !2877)
!2889 = !DILocation(line: 78, column: 1, scope: !2877)
!2890 = distinct !DISubprogram(name: "__muldi3", scope: !122, file: !122, line: 46, type: !178, isLocal: false, isDefinition: true, scopeLine: 47, flags: DIFlagPrototyped, isOptimized: false, unit: !121, retainedNodes: !2)
!2891 = !DILocation(line: 49, column: 13, scope: !2890)
!2892 = !DILocation(line: 49, column: 7, scope: !2890)
!2893 = !DILocation(line: 49, column: 11, scope: !2890)
!2894 = !DILocation(line: 51, column: 13, scope: !2890)
!2895 = !DILocation(line: 51, column: 7, scope: !2890)
!2896 = !DILocation(line: 51, column: 11, scope: !2890)
!2897 = !DILocation(line: 53, column: 25, scope: !2890)
!2898 = !DILocation(line: 53, column: 27, scope: !2890)
!2899 = !DILocation(line: 53, column: 34, scope: !2890)
!2900 = !DILocation(line: 53, column: 36, scope: !2890)
!2901 = !DILocation(line: 53, column: 13, scope: !2890)
!2902 = !DILocation(line: 53, column: 7, scope: !2890)
!2903 = !DILocation(line: 53, column: 11, scope: !2890)
!2904 = !DILocation(line: 54, column: 19, scope: !2890)
!2905 = !DILocation(line: 54, column: 21, scope: !2890)
!2906 = !DILocation(line: 54, column: 30, scope: !2890)
!2907 = !DILocation(line: 54, column: 32, scope: !2890)
!2908 = !DILocation(line: 54, column: 26, scope: !2890)
!2909 = !DILocation(line: 54, column: 40, scope: !2890)
!2910 = !DILocation(line: 54, column: 42, scope: !2890)
!2911 = !DILocation(line: 54, column: 50, scope: !2890)
!2912 = !DILocation(line: 54, column: 52, scope: !2890)
!2913 = !DILocation(line: 54, column: 46, scope: !2890)
!2914 = !DILocation(line: 54, column: 36, scope: !2890)
!2915 = !DILocation(line: 54, column: 7, scope: !2890)
!2916 = !DILocation(line: 54, column: 9, scope: !2890)
!2917 = !DILocation(line: 54, column: 14, scope: !2890)
!2918 = !DILocation(line: 55, column: 14, scope: !2890)
!2919 = !DILocation(line: 55, column: 5, scope: !2890)
!2920 = distinct !DISubprogram(name: "__muldsi3", scope: !122, file: !122, line: 21, type: !178, isLocal: true, isDefinition: true, scopeLine: 22, flags: DIFlagPrototyped, isOptimized: false, unit: !121, retainedNodes: !2)
!2921 = !DILocation(line: 24, column: 15, scope: !2920)
!2922 = !DILocation(line: 25, column: 18, scope: !2920)
!2923 = !DILocation(line: 26, column: 16, scope: !2920)
!2924 = !DILocation(line: 26, column: 18, scope: !2920)
!2925 = !DILocation(line: 26, column: 35, scope: !2920)
!2926 = !DILocation(line: 26, column: 37, scope: !2920)
!2927 = !DILocation(line: 26, column: 32, scope: !2920)
!2928 = !DILocation(line: 26, column: 7, scope: !2920)
!2929 = !DILocation(line: 26, column: 9, scope: !2920)
!2930 = !DILocation(line: 26, column: 13, scope: !2920)
!2931 = !DILocation(line: 27, column: 18, scope: !2920)
!2932 = !DILocation(line: 27, column: 20, scope: !2920)
!2933 = !DILocation(line: 27, column: 24, scope: !2920)
!2934 = !DILocation(line: 27, column: 12, scope: !2920)
!2935 = !DILocation(line: 28, column: 7, scope: !2920)
!2936 = !DILocation(line: 28, column: 9, scope: !2920)
!2937 = !DILocation(line: 28, column: 13, scope: !2920)
!2938 = !DILocation(line: 29, column: 11, scope: !2920)
!2939 = !DILocation(line: 29, column: 13, scope: !2920)
!2940 = !DILocation(line: 29, column: 35, scope: !2920)
!2941 = !DILocation(line: 29, column: 37, scope: !2920)
!2942 = !DILocation(line: 29, column: 32, scope: !2920)
!2943 = !DILocation(line: 29, column: 7, scope: !2920)
!2944 = !DILocation(line: 30, column: 17, scope: !2920)
!2945 = !DILocation(line: 30, column: 19, scope: !2920)
!2946 = !DILocation(line: 30, column: 33, scope: !2920)
!2947 = !DILocation(line: 30, column: 7, scope: !2920)
!2948 = !DILocation(line: 30, column: 9, scope: !2920)
!2949 = !DILocation(line: 30, column: 13, scope: !2920)
!2950 = !DILocation(line: 31, column: 16, scope: !2920)
!2951 = !DILocation(line: 31, column: 18, scope: !2920)
!2952 = !DILocation(line: 31, column: 7, scope: !2920)
!2953 = !DILocation(line: 31, column: 9, scope: !2920)
!2954 = !DILocation(line: 31, column: 14, scope: !2920)
!2955 = !DILocation(line: 32, column: 11, scope: !2920)
!2956 = !DILocation(line: 32, column: 13, scope: !2920)
!2957 = !DILocation(line: 32, column: 17, scope: !2920)
!2958 = !DILocation(line: 32, column: 7, scope: !2920)
!2959 = !DILocation(line: 33, column: 7, scope: !2920)
!2960 = !DILocation(line: 33, column: 9, scope: !2920)
!2961 = !DILocation(line: 33, column: 13, scope: !2920)
!2962 = !DILocation(line: 34, column: 11, scope: !2920)
!2963 = !DILocation(line: 34, column: 13, scope: !2920)
!2964 = !DILocation(line: 34, column: 35, scope: !2920)
!2965 = !DILocation(line: 34, column: 37, scope: !2920)
!2966 = !DILocation(line: 34, column: 32, scope: !2920)
!2967 = !DILocation(line: 34, column: 7, scope: !2920)
!2968 = !DILocation(line: 35, column: 17, scope: !2920)
!2969 = !DILocation(line: 35, column: 19, scope: !2920)
!2970 = !DILocation(line: 35, column: 33, scope: !2920)
!2971 = !DILocation(line: 35, column: 7, scope: !2920)
!2972 = !DILocation(line: 35, column: 9, scope: !2920)
!2973 = !DILocation(line: 35, column: 13, scope: !2920)
!2974 = !DILocation(line: 36, column: 17, scope: !2920)
!2975 = !DILocation(line: 36, column: 19, scope: !2920)
!2976 = !DILocation(line: 36, column: 7, scope: !2920)
!2977 = !DILocation(line: 36, column: 9, scope: !2920)
!2978 = !DILocation(line: 36, column: 14, scope: !2920)
!2979 = !DILocation(line: 37, column: 18, scope: !2920)
!2980 = !DILocation(line: 37, column: 20, scope: !2920)
!2981 = !DILocation(line: 37, column: 42, scope: !2920)
!2982 = !DILocation(line: 37, column: 44, scope: !2920)
!2983 = !DILocation(line: 37, column: 39, scope: !2920)
!2984 = !DILocation(line: 37, column: 7, scope: !2920)
!2985 = !DILocation(line: 37, column: 9, scope: !2920)
!2986 = !DILocation(line: 37, column: 14, scope: !2920)
!2987 = !DILocation(line: 38, column: 14, scope: !2920)
!2988 = !DILocation(line: 38, column: 5, scope: !2920)
!2989 = distinct !DISubprogram(name: "__mulodi4", scope: !124, file: !124, line: 22, type: !178, isLocal: false, isDefinition: true, scopeLine: 23, flags: DIFlagPrototyped, isOptimized: false, unit: !123, retainedNodes: !2)
!2990 = !DILocation(line: 24, column: 15, scope: !2989)
!2991 = !DILocation(line: 25, column: 18, scope: !2989)
!2992 = !DILocation(line: 26, column: 18, scope: !2989)
!2993 = !DILocation(line: 27, column: 6, scope: !2989)
!2994 = !DILocation(line: 27, column: 15, scope: !2989)
!2995 = !DILocation(line: 28, column: 21, scope: !2989)
!2996 = !DILocation(line: 28, column: 25, scope: !2989)
!2997 = !DILocation(line: 28, column: 23, scope: !2989)
!2998 = !DILocation(line: 28, column: 12, scope: !2989)
!2999 = !DILocation(line: 29, column: 9, scope: !2989)
!3000 = !DILocation(line: 29, column: 11, scope: !2989)
!3001 = !DILocation(line: 31, column: 13, scope: !2989)
!3002 = !DILocation(line: 31, column: 15, scope: !2989)
!3003 = !DILocation(line: 31, column: 20, scope: !2989)
!3004 = !DILocation(line: 31, column: 23, scope: !2989)
!3005 = !DILocation(line: 31, column: 25, scope: !2989)
!3006 = !DILocation(line: 32, column: 7, scope: !2989)
!3007 = !DILocation(line: 32, column: 16, scope: !2989)
!3008 = !DILocation(line: 32, column: 6, scope: !2989)
!3009 = !DILocation(line: 33, column: 9, scope: !2989)
!3010 = !DILocation(line: 33, column: 2, scope: !2989)
!3011 = !DILocation(line: 35, column: 9, scope: !2989)
!3012 = !DILocation(line: 35, column: 11, scope: !2989)
!3013 = !DILocation(line: 37, column: 13, scope: !2989)
!3014 = !DILocation(line: 37, column: 15, scope: !2989)
!3015 = !DILocation(line: 37, column: 20, scope: !2989)
!3016 = !DILocation(line: 37, column: 23, scope: !2989)
!3017 = !DILocation(line: 37, column: 25, scope: !2989)
!3018 = !DILocation(line: 38, column: 7, scope: !2989)
!3019 = !DILocation(line: 38, column: 16, scope: !2989)
!3020 = !DILocation(line: 38, column: 6, scope: !2989)
!3021 = !DILocation(line: 39, column: 16, scope: !2989)
!3022 = !DILocation(line: 39, column: 9, scope: !2989)
!3023 = !DILocation(line: 41, column: 17, scope: !2989)
!3024 = !DILocation(line: 41, column: 19, scope: !2989)
!3025 = !DILocation(line: 41, column: 12, scope: !2989)
!3026 = !DILocation(line: 42, column: 21, scope: !2989)
!3027 = !DILocation(line: 42, column: 25, scope: !2989)
!3028 = !DILocation(line: 42, column: 23, scope: !2989)
!3029 = !DILocation(line: 42, column: 31, scope: !2989)
!3030 = !DILocation(line: 42, column: 29, scope: !2989)
!3031 = !DILocation(line: 42, column: 12, scope: !2989)
!3032 = !DILocation(line: 43, column: 17, scope: !2989)
!3033 = !DILocation(line: 43, column: 19, scope: !2989)
!3034 = !DILocation(line: 43, column: 12, scope: !2989)
!3035 = !DILocation(line: 44, column: 21, scope: !2989)
!3036 = !DILocation(line: 44, column: 25, scope: !2989)
!3037 = !DILocation(line: 44, column: 23, scope: !2989)
!3038 = !DILocation(line: 44, column: 31, scope: !2989)
!3039 = !DILocation(line: 44, column: 29, scope: !2989)
!3040 = !DILocation(line: 44, column: 12, scope: !2989)
!3041 = !DILocation(line: 45, column: 9, scope: !2989)
!3042 = !DILocation(line: 45, column: 15, scope: !2989)
!3043 = !DILocation(line: 45, column: 19, scope: !2989)
!3044 = !DILocation(line: 45, column: 22, scope: !2989)
!3045 = !DILocation(line: 45, column: 28, scope: !2989)
!3046 = !DILocation(line: 46, column: 16, scope: !2989)
!3047 = !DILocation(line: 46, column: 9, scope: !2989)
!3048 = !DILocation(line: 47, column: 9, scope: !2989)
!3049 = !DILocation(line: 47, column: 15, scope: !2989)
!3050 = !DILocation(line: 47, column: 12, scope: !2989)
!3051 = !DILocation(line: 49, column: 13, scope: !2989)
!3052 = !DILocation(line: 49, column: 27, scope: !2989)
!3053 = !DILocation(line: 49, column: 25, scope: !2989)
!3054 = !DILocation(line: 49, column: 19, scope: !2989)
!3055 = !DILocation(line: 50, column: 14, scope: !2989)
!3056 = !DILocation(line: 50, column: 23, scope: !2989)
!3057 = !DILocation(line: 50, column: 13, scope: !2989)
!3058 = !DILocation(line: 51, column: 5, scope: !2989)
!3059 = !DILocation(line: 54, column: 13, scope: !2989)
!3060 = !DILocation(line: 54, column: 28, scope: !2989)
!3061 = !DILocation(line: 54, column: 27, scope: !2989)
!3062 = !DILocation(line: 54, column: 25, scope: !2989)
!3063 = !DILocation(line: 54, column: 19, scope: !2989)
!3064 = !DILocation(line: 55, column: 14, scope: !2989)
!3065 = !DILocation(line: 55, column: 23, scope: !2989)
!3066 = !DILocation(line: 55, column: 13, scope: !2989)
!3067 = !DILocation(line: 57, column: 12, scope: !2989)
!3068 = !DILocation(line: 57, column: 5, scope: !2989)
!3069 = !DILocation(line: 58, column: 1, scope: !2989)
!3070 = distinct !DISubprogram(name: "__mulosi4", scope: !126, file: !126, line: 22, type: !178, isLocal: false, isDefinition: true, scopeLine: 23, flags: DIFlagPrototyped, isOptimized: false, unit: !125, retainedNodes: !2)
!3071 = !DILocation(line: 24, column: 15, scope: !3070)
!3072 = !DILocation(line: 25, column: 18, scope: !3070)
!3073 = !DILocation(line: 26, column: 18, scope: !3070)
!3074 = !DILocation(line: 27, column: 6, scope: !3070)
!3075 = !DILocation(line: 27, column: 15, scope: !3070)
!3076 = !DILocation(line: 28, column: 21, scope: !3070)
!3077 = !DILocation(line: 28, column: 25, scope: !3070)
!3078 = !DILocation(line: 28, column: 23, scope: !3070)
!3079 = !DILocation(line: 28, column: 12, scope: !3070)
!3080 = !DILocation(line: 29, column: 9, scope: !3070)
!3081 = !DILocation(line: 29, column: 11, scope: !3070)
!3082 = !DILocation(line: 31, column: 13, scope: !3070)
!3083 = !DILocation(line: 31, column: 15, scope: !3070)
!3084 = !DILocation(line: 31, column: 20, scope: !3070)
!3085 = !DILocation(line: 31, column: 23, scope: !3070)
!3086 = !DILocation(line: 31, column: 25, scope: !3070)
!3087 = !DILocation(line: 32, column: 7, scope: !3070)
!3088 = !DILocation(line: 32, column: 16, scope: !3070)
!3089 = !DILocation(line: 32, column: 6, scope: !3070)
!3090 = !DILocation(line: 33, column: 9, scope: !3070)
!3091 = !DILocation(line: 33, column: 2, scope: !3070)
!3092 = !DILocation(line: 35, column: 9, scope: !3070)
!3093 = !DILocation(line: 35, column: 11, scope: !3070)
!3094 = !DILocation(line: 37, column: 13, scope: !3070)
!3095 = !DILocation(line: 37, column: 15, scope: !3070)
!3096 = !DILocation(line: 37, column: 20, scope: !3070)
!3097 = !DILocation(line: 37, column: 23, scope: !3070)
!3098 = !DILocation(line: 37, column: 25, scope: !3070)
!3099 = !DILocation(line: 38, column: 7, scope: !3070)
!3100 = !DILocation(line: 38, column: 16, scope: !3070)
!3101 = !DILocation(line: 38, column: 6, scope: !3070)
!3102 = !DILocation(line: 39, column: 16, scope: !3070)
!3103 = !DILocation(line: 39, column: 9, scope: !3070)
!3104 = !DILocation(line: 41, column: 17, scope: !3070)
!3105 = !DILocation(line: 41, column: 19, scope: !3070)
!3106 = !DILocation(line: 41, column: 12, scope: !3070)
!3107 = !DILocation(line: 42, column: 21, scope: !3070)
!3108 = !DILocation(line: 42, column: 25, scope: !3070)
!3109 = !DILocation(line: 42, column: 23, scope: !3070)
!3110 = !DILocation(line: 42, column: 31, scope: !3070)
!3111 = !DILocation(line: 42, column: 29, scope: !3070)
!3112 = !DILocation(line: 42, column: 12, scope: !3070)
!3113 = !DILocation(line: 43, column: 17, scope: !3070)
!3114 = !DILocation(line: 43, column: 19, scope: !3070)
!3115 = !DILocation(line: 43, column: 12, scope: !3070)
!3116 = !DILocation(line: 44, column: 21, scope: !3070)
!3117 = !DILocation(line: 44, column: 25, scope: !3070)
!3118 = !DILocation(line: 44, column: 23, scope: !3070)
!3119 = !DILocation(line: 44, column: 31, scope: !3070)
!3120 = !DILocation(line: 44, column: 29, scope: !3070)
!3121 = !DILocation(line: 44, column: 12, scope: !3070)
!3122 = !DILocation(line: 45, column: 9, scope: !3070)
!3123 = !DILocation(line: 45, column: 15, scope: !3070)
!3124 = !DILocation(line: 45, column: 19, scope: !3070)
!3125 = !DILocation(line: 45, column: 22, scope: !3070)
!3126 = !DILocation(line: 45, column: 28, scope: !3070)
!3127 = !DILocation(line: 46, column: 16, scope: !3070)
!3128 = !DILocation(line: 46, column: 9, scope: !3070)
!3129 = !DILocation(line: 47, column: 9, scope: !3070)
!3130 = !DILocation(line: 47, column: 15, scope: !3070)
!3131 = !DILocation(line: 47, column: 12, scope: !3070)
!3132 = !DILocation(line: 49, column: 13, scope: !3070)
!3133 = !DILocation(line: 49, column: 27, scope: !3070)
!3134 = !DILocation(line: 49, column: 25, scope: !3070)
!3135 = !DILocation(line: 49, column: 19, scope: !3070)
!3136 = !DILocation(line: 50, column: 14, scope: !3070)
!3137 = !DILocation(line: 50, column: 23, scope: !3070)
!3138 = !DILocation(line: 50, column: 13, scope: !3070)
!3139 = !DILocation(line: 51, column: 5, scope: !3070)
!3140 = !DILocation(line: 54, column: 13, scope: !3070)
!3141 = !DILocation(line: 54, column: 28, scope: !3070)
!3142 = !DILocation(line: 54, column: 27, scope: !3070)
!3143 = !DILocation(line: 54, column: 25, scope: !3070)
!3144 = !DILocation(line: 54, column: 19, scope: !3070)
!3145 = !DILocation(line: 55, column: 14, scope: !3070)
!3146 = !DILocation(line: 55, column: 23, scope: !3070)
!3147 = !DILocation(line: 55, column: 13, scope: !3070)
!3148 = !DILocation(line: 57, column: 12, scope: !3070)
!3149 = !DILocation(line: 57, column: 5, scope: !3070)
!3150 = !DILocation(line: 58, column: 1, scope: !3070)
!3151 = distinct !DISubprogram(name: "__mulsf3", scope: !130, file: !130, line: 20, type: !178, isLocal: false, isDefinition: true, scopeLine: 20, flags: DIFlagPrototyped, isOptimized: false, unit: !129, retainedNodes: !2)
!3152 = !DILocation(line: 21, column: 23, scope: !3151)
!3153 = !DILocation(line: 21, column: 26, scope: !3151)
!3154 = !DILocation(line: 21, column: 12, scope: !3151)
!3155 = !DILocation(line: 21, column: 5, scope: !3151)
!3156 = distinct !DISubprogram(name: "__mulXf3__", scope: !2571, file: !2571, line: 17, type: !178, isLocal: true, isDefinition: true, scopeLine: 17, flags: DIFlagPrototyped, isOptimized: false, unit: !129, retainedNodes: !2)
!3157 = !DILocation(line: 18, column: 42, scope: !3156)
!3158 = !DILocation(line: 18, column: 36, scope: !3156)
!3159 = !DILocation(line: 18, column: 45, scope: !3156)
!3160 = !DILocation(line: 18, column: 64, scope: !3156)
!3161 = !DILocation(line: 18, column: 24, scope: !3156)
!3162 = !DILocation(line: 19, column: 42, scope: !3156)
!3163 = !DILocation(line: 19, column: 36, scope: !3156)
!3164 = !DILocation(line: 19, column: 45, scope: !3156)
!3165 = !DILocation(line: 19, column: 64, scope: !3156)
!3166 = !DILocation(line: 19, column: 24, scope: !3156)
!3167 = !DILocation(line: 20, column: 38, scope: !3156)
!3168 = !DILocation(line: 20, column: 32, scope: !3156)
!3169 = !DILocation(line: 20, column: 49, scope: !3156)
!3170 = !DILocation(line: 20, column: 43, scope: !3156)
!3171 = !DILocation(line: 20, column: 41, scope: !3156)
!3172 = !DILocation(line: 20, column: 53, scope: !3156)
!3173 = !DILocation(line: 20, column: 17, scope: !3156)
!3174 = !DILocation(line: 22, column: 32, scope: !3156)
!3175 = !DILocation(line: 22, column: 26, scope: !3156)
!3176 = !DILocation(line: 22, column: 35, scope: !3156)
!3177 = !DILocation(line: 22, column: 11, scope: !3156)
!3178 = !DILocation(line: 23, column: 32, scope: !3156)
!3179 = !DILocation(line: 23, column: 26, scope: !3156)
!3180 = !DILocation(line: 23, column: 35, scope: !3156)
!3181 = !DILocation(line: 23, column: 11, scope: !3156)
!3182 = !DILocation(line: 24, column: 9, scope: !3156)
!3183 = !DILocation(line: 27, column: 9, scope: !3156)
!3184 = !DILocation(line: 27, column: 18, scope: !3156)
!3185 = !DILocation(line: 27, column: 22, scope: !3156)
!3186 = !DILocation(line: 27, column: 40, scope: !3156)
!3187 = !DILocation(line: 27, column: 43, scope: !3156)
!3188 = !DILocation(line: 27, column: 52, scope: !3156)
!3189 = !DILocation(line: 27, column: 56, scope: !3156)
!3190 = !DILocation(line: 29, column: 34, scope: !3156)
!3191 = !DILocation(line: 29, column: 28, scope: !3156)
!3192 = !DILocation(line: 29, column: 37, scope: !3156)
!3193 = !DILocation(line: 29, column: 21, scope: !3156)
!3194 = !DILocation(line: 30, column: 34, scope: !3156)
!3195 = !DILocation(line: 30, column: 28, scope: !3156)
!3196 = !DILocation(line: 30, column: 37, scope: !3156)
!3197 = !DILocation(line: 30, column: 21, scope: !3156)
!3198 = !DILocation(line: 33, column: 13, scope: !3156)
!3199 = !DILocation(line: 33, column: 18, scope: !3156)
!3200 = !DILocation(line: 33, column: 49, scope: !3156)
!3201 = !DILocation(line: 33, column: 43, scope: !3156)
!3202 = !DILocation(line: 33, column: 52, scope: !3156)
!3203 = !DILocation(line: 33, column: 35, scope: !3156)
!3204 = !DILocation(line: 33, column: 28, scope: !3156)
!3205 = !DILocation(line: 35, column: 13, scope: !3156)
!3206 = !DILocation(line: 35, column: 18, scope: !3156)
!3207 = !DILocation(line: 35, column: 49, scope: !3156)
!3208 = !DILocation(line: 35, column: 43, scope: !3156)
!3209 = !DILocation(line: 35, column: 52, scope: !3156)
!3210 = !DILocation(line: 35, column: 35, scope: !3156)
!3211 = !DILocation(line: 35, column: 28, scope: !3156)
!3212 = !DILocation(line: 37, column: 13, scope: !3156)
!3213 = !DILocation(line: 37, column: 18, scope: !3156)
!3214 = !DILocation(line: 39, column: 17, scope: !3156)
!3215 = !DILocation(line: 39, column: 38, scope: !3156)
!3216 = !DILocation(line: 39, column: 45, scope: !3156)
!3217 = !DILocation(line: 39, column: 43, scope: !3156)
!3218 = !DILocation(line: 39, column: 30, scope: !3156)
!3219 = !DILocation(line: 39, column: 23, scope: !3156)
!3220 = !DILocation(line: 41, column: 25, scope: !3156)
!3221 = !DILocation(line: 41, column: 18, scope: !3156)
!3222 = !DILocation(line: 44, column: 13, scope: !3156)
!3223 = !DILocation(line: 44, column: 18, scope: !3156)
!3224 = !DILocation(line: 46, column: 17, scope: !3156)
!3225 = !DILocation(line: 46, column: 38, scope: !3156)
!3226 = !DILocation(line: 46, column: 45, scope: !3156)
!3227 = !DILocation(line: 46, column: 43, scope: !3156)
!3228 = !DILocation(line: 46, column: 30, scope: !3156)
!3229 = !DILocation(line: 46, column: 23, scope: !3156)
!3230 = !DILocation(line: 48, column: 25, scope: !3156)
!3231 = !DILocation(line: 48, column: 18, scope: !3156)
!3232 = !DILocation(line: 52, column: 14, scope: !3156)
!3233 = !DILocation(line: 52, column: 13, scope: !3156)
!3234 = !DILocation(line: 52, column: 35, scope: !3156)
!3235 = !DILocation(line: 52, column: 27, scope: !3156)
!3236 = !DILocation(line: 52, column: 20, scope: !3156)
!3237 = !DILocation(line: 54, column: 14, scope: !3156)
!3238 = !DILocation(line: 54, column: 13, scope: !3156)
!3239 = !DILocation(line: 54, column: 35, scope: !3156)
!3240 = !DILocation(line: 54, column: 27, scope: !3156)
!3241 = !DILocation(line: 54, column: 20, scope: !3156)
!3242 = !DILocation(line: 59, column: 13, scope: !3156)
!3243 = !DILocation(line: 59, column: 18, scope: !3156)
!3244 = !DILocation(line: 59, column: 42, scope: !3156)
!3245 = !DILocation(line: 59, column: 39, scope: !3156)
!3246 = !DILocation(line: 59, column: 33, scope: !3156)
!3247 = !DILocation(line: 60, column: 13, scope: !3156)
!3248 = !DILocation(line: 60, column: 18, scope: !3156)
!3249 = !DILocation(line: 60, column: 42, scope: !3156)
!3250 = !DILocation(line: 60, column: 39, scope: !3156)
!3251 = !DILocation(line: 60, column: 33, scope: !3156)
!3252 = !DILocation(line: 61, column: 5, scope: !3156)
!3253 = !DILocation(line: 66, column: 18, scope: !3156)
!3254 = !DILocation(line: 67, column: 18, scope: !3156)
!3255 = !DILocation(line: 75, column: 18, scope: !3156)
!3256 = !DILocation(line: 75, column: 32, scope: !3156)
!3257 = !DILocation(line: 75, column: 45, scope: !3156)
!3258 = !DILocation(line: 75, column: 5, scope: !3156)
!3259 = !DILocation(line: 78, column: 27, scope: !3156)
!3260 = !DILocation(line: 78, column: 39, scope: !3156)
!3261 = !DILocation(line: 78, column: 37, scope: !3156)
!3262 = !DILocation(line: 78, column: 49, scope: !3156)
!3263 = !DILocation(line: 78, column: 66, scope: !3156)
!3264 = !DILocation(line: 78, column: 64, scope: !3156)
!3265 = !DILocation(line: 78, column: 9, scope: !3156)
!3266 = !DILocation(line: 81, column: 9, scope: !3156)
!3267 = !DILocation(line: 81, column: 19, scope: !3156)
!3268 = !DILocation(line: 81, column: 49, scope: !3156)
!3269 = !DILocation(line: 81, column: 34, scope: !3156)
!3270 = !DILocation(line: 82, column: 10, scope: !3156)
!3271 = !DILocation(line: 85, column: 9, scope: !3156)
!3272 = !DILocation(line: 85, column: 25, scope: !3156)
!3273 = !DILocation(line: 85, column: 65, scope: !3156)
!3274 = !DILocation(line: 85, column: 63, scope: !3156)
!3275 = !DILocation(line: 85, column: 48, scope: !3156)
!3276 = !DILocation(line: 85, column: 41, scope: !3156)
!3277 = !DILocation(line: 87, column: 9, scope: !3156)
!3278 = !DILocation(line: 87, column: 25, scope: !3156)
!3279 = !DILocation(line: 94, column: 61, scope: !3156)
!3280 = !DILocation(line: 94, column: 45, scope: !3156)
!3281 = !DILocation(line: 94, column: 28, scope: !3156)
!3282 = !DILocation(line: 95, column: 13, scope: !3156)
!3283 = !DILocation(line: 95, column: 19, scope: !3156)
!3284 = !DILocation(line: 95, column: 48, scope: !3156)
!3285 = !DILocation(line: 95, column: 40, scope: !3156)
!3286 = !DILocation(line: 95, column: 33, scope: !3156)
!3287 = !DILocation(line: 99, column: 58, scope: !3156)
!3288 = !DILocation(line: 99, column: 9, scope: !3156)
!3289 = !DILocation(line: 100, column: 5, scope: !3156)
!3290 = !DILocation(line: 103, column: 19, scope: !3156)
!3291 = !DILocation(line: 104, column: 29, scope: !3156)
!3292 = !DILocation(line: 104, column: 45, scope: !3156)
!3293 = !DILocation(line: 104, column: 19, scope: !3156)
!3294 = !DILocation(line: 108, column: 18, scope: !3156)
!3295 = !DILocation(line: 108, column: 15, scope: !3156)
!3296 = !DILocation(line: 113, column: 9, scope: !3156)
!3297 = !DILocation(line: 113, column: 19, scope: !3156)
!3298 = !DILocation(line: 113, column: 39, scope: !3156)
!3299 = !DILocation(line: 113, column: 30, scope: !3156)
!3300 = !DILocation(line: 114, column: 9, scope: !3156)
!3301 = !DILocation(line: 114, column: 19, scope: !3156)
!3302 = !DILocation(line: 114, column: 44, scope: !3156)
!3303 = !DILocation(line: 114, column: 54, scope: !3156)
!3304 = !DILocation(line: 114, column: 41, scope: !3156)
!3305 = !DILocation(line: 114, column: 31, scope: !3156)
!3306 = !DILocation(line: 115, column: 20, scope: !3156)
!3307 = !DILocation(line: 115, column: 12, scope: !3156)
!3308 = !DILocation(line: 115, column: 5, scope: !3156)
!3309 = !DILocation(line: 116, column: 1, scope: !3156)
!3310 = distinct !DISubprogram(name: "toRep", scope: !411, file: !411, line: 231, type: !178, isLocal: true, isDefinition: true, scopeLine: 231, flags: DIFlagPrototyped, isOptimized: false, unit: !129, retainedNodes: !2)
!3311 = !DILocation(line: 232, column: 44, scope: !3310)
!3312 = !DILocation(line: 232, column: 50, scope: !3310)
!3313 = !DILocation(line: 233, column: 16, scope: !3310)
!3314 = !DILocation(line: 233, column: 5, scope: !3310)
!3315 = distinct !DISubprogram(name: "fromRep", scope: !411, file: !411, line: 236, type: !178, isLocal: true, isDefinition: true, scopeLine: 236, flags: DIFlagPrototyped, isOptimized: false, unit: !129, retainedNodes: !2)
!3316 = !DILocation(line: 237, column: 44, scope: !3315)
!3317 = !DILocation(line: 237, column: 50, scope: !3315)
!3318 = !DILocation(line: 238, column: 16, scope: !3315)
!3319 = !DILocation(line: 238, column: 5, scope: !3315)
!3320 = distinct !DISubprogram(name: "normalize", scope: !411, file: !411, line: 241, type: !178, isLocal: true, isDefinition: true, scopeLine: 241, flags: DIFlagPrototyped, isOptimized: false, unit: !129, retainedNodes: !2)
!3321 = !DILocation(line: 242, column: 32, scope: !3320)
!3322 = !DILocation(line: 242, column: 31, scope: !3320)
!3323 = !DILocation(line: 242, column: 23, scope: !3320)
!3324 = !DILocation(line: 242, column: 47, scope: !3320)
!3325 = !DILocation(line: 242, column: 45, scope: !3320)
!3326 = !DILocation(line: 242, column: 15, scope: !3320)
!3327 = !DILocation(line: 243, column: 22, scope: !3320)
!3328 = !DILocation(line: 243, column: 6, scope: !3320)
!3329 = !DILocation(line: 243, column: 18, scope: !3320)
!3330 = !DILocation(line: 244, column: 16, scope: !3320)
!3331 = !DILocation(line: 244, column: 14, scope: !3320)
!3332 = !DILocation(line: 244, column: 5, scope: !3320)
!3333 = distinct !DISubprogram(name: "wideMultiply", scope: !411, file: !411, line: 54, type: !178, isLocal: true, isDefinition: true, scopeLine: 54, flags: DIFlagPrototyped, isOptimized: false, unit: !129, retainedNodes: !2)
!3334 = !DILocation(line: 55, column: 40, scope: !3333)
!3335 = !DILocation(line: 55, column: 30, scope: !3333)
!3336 = !DILocation(line: 55, column: 42, scope: !3333)
!3337 = !DILocation(line: 55, column: 41, scope: !3333)
!3338 = !DILocation(line: 55, column: 20, scope: !3333)
!3339 = !DILocation(line: 56, column: 11, scope: !3333)
!3340 = !DILocation(line: 56, column: 19, scope: !3333)
!3341 = !DILocation(line: 56, column: 6, scope: !3333)
!3342 = !DILocation(line: 56, column: 9, scope: !3333)
!3343 = !DILocation(line: 57, column: 11, scope: !3333)
!3344 = !DILocation(line: 57, column: 6, scope: !3333)
!3345 = !DILocation(line: 57, column: 9, scope: !3333)
!3346 = !DILocation(line: 58, column: 1, scope: !3333)
!3347 = distinct !DISubprogram(name: "wideLeftShift", scope: !411, file: !411, line: 247, type: !178, isLocal: true, isDefinition: true, scopeLine: 247, flags: DIFlagPrototyped, isOptimized: false, unit: !129, retainedNodes: !2)
!3348 = !DILocation(line: 248, column: 12, scope: !3347)
!3349 = !DILocation(line: 248, column: 11, scope: !3347)
!3350 = !DILocation(line: 248, column: 18, scope: !3347)
!3351 = !DILocation(line: 248, column: 15, scope: !3347)
!3352 = !DILocation(line: 248, column: 27, scope: !3347)
!3353 = !DILocation(line: 248, column: 26, scope: !3347)
!3354 = !DILocation(line: 248, column: 46, scope: !3347)
!3355 = !DILocation(line: 248, column: 44, scope: !3347)
!3356 = !DILocation(line: 248, column: 30, scope: !3347)
!3357 = !DILocation(line: 248, column: 24, scope: !3347)
!3358 = !DILocation(line: 248, column: 6, scope: !3347)
!3359 = !DILocation(line: 248, column: 9, scope: !3347)
!3360 = !DILocation(line: 249, column: 12, scope: !3347)
!3361 = !DILocation(line: 249, column: 11, scope: !3347)
!3362 = !DILocation(line: 249, column: 18, scope: !3347)
!3363 = !DILocation(line: 249, column: 15, scope: !3347)
!3364 = !DILocation(line: 249, column: 6, scope: !3347)
!3365 = !DILocation(line: 249, column: 9, scope: !3347)
!3366 = !DILocation(line: 250, column: 1, scope: !3347)
!3367 = distinct !DISubprogram(name: "wideRightShiftWithSticky", scope: !411, file: !411, line: 252, type: !178, isLocal: true, isDefinition: true, scopeLine: 252, flags: DIFlagPrototyped, isOptimized: false, unit: !129, retainedNodes: !2)
!3368 = !DILocation(line: 253, column: 9, scope: !3367)
!3369 = !DILocation(line: 253, column: 15, scope: !3367)
!3370 = !DILocation(line: 254, column: 30, scope: !3367)
!3371 = !DILocation(line: 254, column: 29, scope: !3367)
!3372 = !DILocation(line: 254, column: 49, scope: !3367)
!3373 = !DILocation(line: 254, column: 47, scope: !3367)
!3374 = !DILocation(line: 254, column: 33, scope: !3367)
!3375 = !DILocation(line: 254, column: 20, scope: !3367)
!3376 = !DILocation(line: 255, column: 16, scope: !3367)
!3377 = !DILocation(line: 255, column: 15, scope: !3367)
!3378 = !DILocation(line: 255, column: 35, scope: !3367)
!3379 = !DILocation(line: 255, column: 33, scope: !3367)
!3380 = !DILocation(line: 255, column: 19, scope: !3367)
!3381 = !DILocation(line: 255, column: 45, scope: !3367)
!3382 = !DILocation(line: 255, column: 44, scope: !3367)
!3383 = !DILocation(line: 255, column: 51, scope: !3367)
!3384 = !DILocation(line: 255, column: 48, scope: !3367)
!3385 = !DILocation(line: 255, column: 42, scope: !3367)
!3386 = !DILocation(line: 255, column: 59, scope: !3367)
!3387 = !DILocation(line: 255, column: 57, scope: !3367)
!3388 = !DILocation(line: 255, column: 10, scope: !3367)
!3389 = !DILocation(line: 255, column: 13, scope: !3367)
!3390 = !DILocation(line: 256, column: 16, scope: !3367)
!3391 = !DILocation(line: 256, column: 15, scope: !3367)
!3392 = !DILocation(line: 256, column: 22, scope: !3367)
!3393 = !DILocation(line: 256, column: 19, scope: !3367)
!3394 = !DILocation(line: 256, column: 10, scope: !3367)
!3395 = !DILocation(line: 256, column: 13, scope: !3367)
!3396 = !DILocation(line: 257, column: 5, scope: !3367)
!3397 = !DILocation(line: 258, column: 14, scope: !3367)
!3398 = !DILocation(line: 258, column: 20, scope: !3367)
!3399 = !DILocation(line: 259, column: 30, scope: !3367)
!3400 = !DILocation(line: 259, column: 29, scope: !3367)
!3401 = !DILocation(line: 259, column: 51, scope: !3367)
!3402 = !DILocation(line: 259, column: 49, scope: !3367)
!3403 = !DILocation(line: 259, column: 33, scope: !3367)
!3404 = !DILocation(line: 259, column: 61, scope: !3367)
!3405 = !DILocation(line: 259, column: 60, scope: !3367)
!3406 = !DILocation(line: 259, column: 58, scope: !3367)
!3407 = !DILocation(line: 259, column: 20, scope: !3367)
!3408 = !DILocation(line: 260, column: 16, scope: !3367)
!3409 = !DILocation(line: 260, column: 15, scope: !3367)
!3410 = !DILocation(line: 260, column: 23, scope: !3367)
!3411 = !DILocation(line: 260, column: 29, scope: !3367)
!3412 = !DILocation(line: 260, column: 19, scope: !3367)
!3413 = !DILocation(line: 260, column: 44, scope: !3367)
!3414 = !DILocation(line: 260, column: 42, scope: !3367)
!3415 = !DILocation(line: 260, column: 10, scope: !3367)
!3416 = !DILocation(line: 260, column: 13, scope: !3367)
!3417 = !DILocation(line: 261, column: 10, scope: !3367)
!3418 = !DILocation(line: 261, column: 13, scope: !3367)
!3419 = !DILocation(line: 262, column: 5, scope: !3367)
!3420 = !DILocation(line: 263, column: 30, scope: !3367)
!3421 = !DILocation(line: 263, column: 29, scope: !3367)
!3422 = !DILocation(line: 263, column: 36, scope: !3367)
!3423 = !DILocation(line: 263, column: 35, scope: !3367)
!3424 = !DILocation(line: 263, column: 33, scope: !3367)
!3425 = !DILocation(line: 263, column: 20, scope: !3367)
!3426 = !DILocation(line: 264, column: 15, scope: !3367)
!3427 = !DILocation(line: 264, column: 10, scope: !3367)
!3428 = !DILocation(line: 264, column: 13, scope: !3367)
!3429 = !DILocation(line: 265, column: 10, scope: !3367)
!3430 = !DILocation(line: 265, column: 13, scope: !3367)
!3431 = !DILocation(line: 267, column: 1, scope: !3367)
!3432 = distinct !DISubprogram(name: "rep_clz", scope: !411, file: !411, line: 49, type: !178, isLocal: true, isDefinition: true, scopeLine: 49, flags: DIFlagPrototyped, isOptimized: false, unit: !129, retainedNodes: !2)
!3433 = !DILocation(line: 50, column: 26, scope: !3432)
!3434 = !DILocation(line: 50, column: 12, scope: !3432)
!3435 = !DILocation(line: 50, column: 5, scope: !3432)
!3436 = distinct !DISubprogram(name: "__negdf2", scope: !136, file: !136, line: 20, type: !178, isLocal: false, isDefinition: true, scopeLine: 20, flags: DIFlagPrototyped, isOptimized: false, unit: !135, retainedNodes: !2)
!3437 = !DILocation(line: 21, column: 26, scope: !3436)
!3438 = !DILocation(line: 21, column: 20, scope: !3436)
!3439 = !DILocation(line: 21, column: 29, scope: !3436)
!3440 = !DILocation(line: 21, column: 12, scope: !3436)
!3441 = !DILocation(line: 21, column: 5, scope: !3436)
!3442 = distinct !DISubprogram(name: "toRep", scope: !411, file: !411, line: 231, type: !178, isLocal: true, isDefinition: true, scopeLine: 231, flags: DIFlagPrototyped, isOptimized: false, unit: !135, retainedNodes: !2)
!3443 = !DILocation(line: 232, column: 44, scope: !3442)
!3444 = !DILocation(line: 232, column: 50, scope: !3442)
!3445 = !DILocation(line: 233, column: 16, scope: !3442)
!3446 = !DILocation(line: 233, column: 5, scope: !3442)
!3447 = distinct !DISubprogram(name: "fromRep", scope: !411, file: !411, line: 236, type: !178, isLocal: true, isDefinition: true, scopeLine: 236, flags: DIFlagPrototyped, isOptimized: false, unit: !135, retainedNodes: !2)
!3448 = !DILocation(line: 237, column: 44, scope: !3447)
!3449 = !DILocation(line: 237, column: 50, scope: !3447)
!3450 = !DILocation(line: 238, column: 16, scope: !3447)
!3451 = !DILocation(line: 238, column: 5, scope: !3447)
!3452 = distinct !DISubprogram(name: "__negdi2", scope: !138, file: !138, line: 20, type: !178, isLocal: false, isDefinition: true, scopeLine: 21, flags: DIFlagPrototyped, isOptimized: false, unit: !137, retainedNodes: !2)
!3453 = !DILocation(line: 25, column: 13, scope: !3452)
!3454 = !DILocation(line: 25, column: 12, scope: !3452)
!3455 = !DILocation(line: 25, column: 5, scope: !3452)
!3456 = distinct !DISubprogram(name: "__negsf2", scope: !140, file: !140, line: 20, type: !178, isLocal: false, isDefinition: true, scopeLine: 20, flags: DIFlagPrototyped, isOptimized: false, unit: !139, retainedNodes: !2)
!3457 = !DILocation(line: 21, column: 26, scope: !3456)
!3458 = !DILocation(line: 21, column: 20, scope: !3456)
!3459 = !DILocation(line: 21, column: 29, scope: !3456)
!3460 = !DILocation(line: 21, column: 12, scope: !3456)
!3461 = !DILocation(line: 21, column: 5, scope: !3456)
!3462 = distinct !DISubprogram(name: "toRep", scope: !411, file: !411, line: 231, type: !178, isLocal: true, isDefinition: true, scopeLine: 231, flags: DIFlagPrototyped, isOptimized: false, unit: !139, retainedNodes: !2)
!3463 = !DILocation(line: 232, column: 44, scope: !3462)
!3464 = !DILocation(line: 232, column: 50, scope: !3462)
!3465 = !DILocation(line: 233, column: 16, scope: !3462)
!3466 = !DILocation(line: 233, column: 5, scope: !3462)
!3467 = distinct !DISubprogram(name: "fromRep", scope: !411, file: !411, line: 236, type: !178, isLocal: true, isDefinition: true, scopeLine: 236, flags: DIFlagPrototyped, isOptimized: false, unit: !139, retainedNodes: !2)
!3468 = !DILocation(line: 237, column: 44, scope: !3467)
!3469 = !DILocation(line: 237, column: 50, scope: !3467)
!3470 = !DILocation(line: 238, column: 16, scope: !3467)
!3471 = !DILocation(line: 238, column: 5, scope: !3467)
!3472 = distinct !DISubprogram(name: "__negvdi2", scope: !144, file: !144, line: 22, type: !178, isLocal: false, isDefinition: true, scopeLine: 23, flags: DIFlagPrototyped, isOptimized: false, unit: !143, retainedNodes: !2)
!3473 = !DILocation(line: 24, column: 18, scope: !3472)
!3474 = !DILocation(line: 25, column: 9, scope: !3472)
!3475 = !DILocation(line: 25, column: 11, scope: !3472)
!3476 = !DILocation(line: 26, column: 9, scope: !3472)
!3477 = !DILocation(line: 27, column: 13, scope: !3472)
!3478 = !DILocation(line: 27, column: 12, scope: !3472)
!3479 = !DILocation(line: 27, column: 5, scope: !3472)
!3480 = distinct !DISubprogram(name: "__negvsi2", scope: !146, file: !146, line: 22, type: !178, isLocal: false, isDefinition: true, scopeLine: 23, flags: DIFlagPrototyped, isOptimized: false, unit: !145, retainedNodes: !2)
!3481 = !DILocation(line: 24, column: 18, scope: !3480)
!3482 = !DILocation(line: 25, column: 9, scope: !3480)
!3483 = !DILocation(line: 25, column: 11, scope: !3480)
!3484 = !DILocation(line: 26, column: 9, scope: !3480)
!3485 = !DILocation(line: 27, column: 13, scope: !3480)
!3486 = !DILocation(line: 27, column: 12, scope: !3480)
!3487 = !DILocation(line: 27, column: 5, scope: !3480)
!3488 = distinct !DISubprogram(name: "__powidf2", scope: !150, file: !150, line: 20, type: !178, isLocal: false, isDefinition: true, scopeLine: 21, flags: DIFlagPrototyped, isOptimized: false, unit: !149, retainedNodes: !2)
!3489 = !DILocation(line: 22, column: 23, scope: !3488)
!3490 = !DILocation(line: 22, column: 25, scope: !3488)
!3491 = !DILocation(line: 22, column: 15, scope: !3488)
!3492 = !DILocation(line: 23, column: 12, scope: !3488)
!3493 = !DILocation(line: 24, column: 5, scope: !3488)
!3494 = !DILocation(line: 26, column: 13, scope: !3488)
!3495 = !DILocation(line: 26, column: 15, scope: !3488)
!3496 = !DILocation(line: 27, column: 18, scope: !3488)
!3497 = !DILocation(line: 27, column: 15, scope: !3488)
!3498 = !DILocation(line: 27, column: 13, scope: !3488)
!3499 = !DILocation(line: 28, column: 11, scope: !3488)
!3500 = !DILocation(line: 29, column: 13, scope: !3488)
!3501 = !DILocation(line: 29, column: 15, scope: !3488)
!3502 = !DILocation(line: 30, column: 13, scope: !3488)
!3503 = !DILocation(line: 31, column: 14, scope: !3488)
!3504 = !DILocation(line: 31, column: 11, scope: !3488)
!3505 = distinct !{!3505, !3493, !3506}
!3506 = !DILocation(line: 32, column: 5, scope: !3488)
!3507 = !DILocation(line: 33, column: 12, scope: !3488)
!3508 = !DILocation(line: 33, column: 22, scope: !3488)
!3509 = !DILocation(line: 33, column: 21, scope: !3488)
!3510 = !DILocation(line: 33, column: 26, scope: !3488)
!3511 = !DILocation(line: 33, column: 5, scope: !3488)
!3512 = distinct !DISubprogram(name: "__powisf2", scope: !152, file: !152, line: 20, type: !178, isLocal: false, isDefinition: true, scopeLine: 21, flags: DIFlagPrototyped, isOptimized: false, unit: !151, retainedNodes: !2)
!3513 = !DILocation(line: 22, column: 23, scope: !3512)
!3514 = !DILocation(line: 22, column: 25, scope: !3512)
!3515 = !DILocation(line: 22, column: 15, scope: !3512)
!3516 = !DILocation(line: 23, column: 11, scope: !3512)
!3517 = !DILocation(line: 24, column: 5, scope: !3512)
!3518 = !DILocation(line: 26, column: 13, scope: !3512)
!3519 = !DILocation(line: 26, column: 15, scope: !3512)
!3520 = !DILocation(line: 27, column: 18, scope: !3512)
!3521 = !DILocation(line: 27, column: 15, scope: !3512)
!3522 = !DILocation(line: 27, column: 13, scope: !3512)
!3523 = !DILocation(line: 28, column: 11, scope: !3512)
!3524 = !DILocation(line: 29, column: 13, scope: !3512)
!3525 = !DILocation(line: 29, column: 15, scope: !3512)
!3526 = !DILocation(line: 30, column: 13, scope: !3512)
!3527 = !DILocation(line: 31, column: 14, scope: !3512)
!3528 = !DILocation(line: 31, column: 11, scope: !3512)
!3529 = distinct !{!3529, !3517, !3530}
!3530 = !DILocation(line: 32, column: 5, scope: !3512)
!3531 = !DILocation(line: 33, column: 12, scope: !3512)
!3532 = !DILocation(line: 33, column: 22, scope: !3512)
!3533 = !DILocation(line: 33, column: 21, scope: !3512)
!3534 = !DILocation(line: 33, column: 26, scope: !3512)
!3535 = !DILocation(line: 33, column: 5, scope: !3512)
!3536 = distinct !DISubprogram(name: "__powixf2", scope: !156, file: !156, line: 22, type: !178, isLocal: false, isDefinition: true, scopeLine: 23, flags: DIFlagPrototyped, isOptimized: false, unit: !155, retainedNodes: !2)
!3537 = !DILocation(line: 24, column: 23, scope: !3536)
!3538 = !DILocation(line: 24, column: 25, scope: !3536)
!3539 = !DILocation(line: 24, column: 15, scope: !3536)
!3540 = !DILocation(line: 25, column: 17, scope: !3536)
!3541 = !DILocation(line: 26, column: 5, scope: !3536)
!3542 = !DILocation(line: 28, column: 13, scope: !3536)
!3543 = !DILocation(line: 28, column: 15, scope: !3536)
!3544 = !DILocation(line: 29, column: 18, scope: !3536)
!3545 = !DILocation(line: 29, column: 15, scope: !3536)
!3546 = !DILocation(line: 29, column: 13, scope: !3536)
!3547 = !DILocation(line: 30, column: 11, scope: !3536)
!3548 = !DILocation(line: 31, column: 13, scope: !3536)
!3549 = !DILocation(line: 31, column: 15, scope: !3536)
!3550 = !DILocation(line: 32, column: 13, scope: !3536)
!3551 = !DILocation(line: 33, column: 14, scope: !3536)
!3552 = !DILocation(line: 33, column: 11, scope: !3536)
!3553 = distinct !{!3553, !3541, !3554}
!3554 = !DILocation(line: 34, column: 5, scope: !3536)
!3555 = !DILocation(line: 35, column: 12, scope: !3536)
!3556 = !DILocation(line: 35, column: 22, scope: !3536)
!3557 = !DILocation(line: 35, column: 21, scope: !3536)
!3558 = !DILocation(line: 35, column: 26, scope: !3536)
!3559 = !DILocation(line: 35, column: 5, scope: !3536)
!3560 = distinct !DISubprogram(name: "__subdf3", scope: !158, file: !158, line: 22, type: !178, isLocal: false, isDefinition: true, scopeLine: 22, flags: DIFlagPrototyped, isOptimized: false, unit: !157, retainedNodes: !2)
!3561 = !DILocation(line: 23, column: 21, scope: !3560)
!3562 = !DILocation(line: 23, column: 38, scope: !3560)
!3563 = !DILocation(line: 23, column: 32, scope: !3560)
!3564 = !DILocation(line: 23, column: 41, scope: !3560)
!3565 = !DILocation(line: 23, column: 24, scope: !3560)
!3566 = !DILocation(line: 23, column: 12, scope: !3560)
!3567 = !DILocation(line: 23, column: 5, scope: !3560)
!3568 = distinct !DISubprogram(name: "toRep", scope: !411, file: !411, line: 231, type: !178, isLocal: true, isDefinition: true, scopeLine: 231, flags: DIFlagPrototyped, isOptimized: false, unit: !157, retainedNodes: !2)
!3569 = !DILocation(line: 232, column: 44, scope: !3568)
!3570 = !DILocation(line: 232, column: 50, scope: !3568)
!3571 = !DILocation(line: 233, column: 16, scope: !3568)
!3572 = !DILocation(line: 233, column: 5, scope: !3568)
!3573 = distinct !DISubprogram(name: "fromRep", scope: !411, file: !411, line: 236, type: !178, isLocal: true, isDefinition: true, scopeLine: 236, flags: DIFlagPrototyped, isOptimized: false, unit: !157, retainedNodes: !2)
!3574 = !DILocation(line: 237, column: 44, scope: !3573)
!3575 = !DILocation(line: 237, column: 50, scope: !3573)
!3576 = !DILocation(line: 238, column: 16, scope: !3573)
!3577 = !DILocation(line: 238, column: 5, scope: !3573)
!3578 = distinct !DISubprogram(name: "__subsf3", scope: !160, file: !160, line: 22, type: !178, isLocal: false, isDefinition: true, scopeLine: 22, flags: DIFlagPrototyped, isOptimized: false, unit: !159, retainedNodes: !2)
!3579 = !DILocation(line: 23, column: 21, scope: !3578)
!3580 = !DILocation(line: 23, column: 38, scope: !3578)
!3581 = !DILocation(line: 23, column: 32, scope: !3578)
!3582 = !DILocation(line: 23, column: 41, scope: !3578)
!3583 = !DILocation(line: 23, column: 24, scope: !3578)
!3584 = !DILocation(line: 23, column: 12, scope: !3578)
!3585 = !DILocation(line: 23, column: 5, scope: !3578)
!3586 = distinct !DISubprogram(name: "toRep", scope: !411, file: !411, line: 231, type: !178, isLocal: true, isDefinition: true, scopeLine: 231, flags: DIFlagPrototyped, isOptimized: false, unit: !159, retainedNodes: !2)
!3587 = !DILocation(line: 232, column: 44, scope: !3586)
!3588 = !DILocation(line: 232, column: 50, scope: !3586)
!3589 = !DILocation(line: 233, column: 16, scope: !3586)
!3590 = !DILocation(line: 233, column: 5, scope: !3586)
!3591 = distinct !DISubprogram(name: "fromRep", scope: !411, file: !411, line: 236, type: !178, isLocal: true, isDefinition: true, scopeLine: 236, flags: DIFlagPrototyped, isOptimized: false, unit: !159, retainedNodes: !2)
!3592 = !DILocation(line: 237, column: 44, scope: !3591)
!3593 = !DILocation(line: 237, column: 50, scope: !3591)
!3594 = !DILocation(line: 238, column: 16, scope: !3591)
!3595 = !DILocation(line: 238, column: 5, scope: !3591)
!3596 = distinct !DISubprogram(name: "__truncdfhf2", scope: !164, file: !164, line: 16, type: !178, isLocal: false, isDefinition: true, scopeLine: 16, flags: DIFlagPrototyped, isOptimized: false, unit: !163, retainedNodes: !2)
!3597 = !DILocation(line: 17, column: 27, scope: !3596)
!3598 = !DILocation(line: 17, column: 12, scope: !3596)
!3599 = !DILocation(line: 17, column: 5, scope: !3596)
!3600 = distinct !DISubprogram(name: "__truncXfYf2__", scope: !3601, file: !3601, line: 42, type: !178, isLocal: true, isDefinition: true, scopeLine: 42, flags: DIFlagPrototyped, isOptimized: false, unit: !163, retainedNodes: !2)
!3601 = !DIFile(filename: "/home/hahns/Schreibtisch/llvmta_testcases/libraries/builtinsfloat/fp_trunc_impl.inc", directory: "/home/hahns/Schreibtisch/llvmta_testcases/tmp.0b9rXPKPan")
!3602 = !DILocation(line: 45, column: 15, scope: !3600)
!3603 = !DILocation(line: 46, column: 15, scope: !3600)
!3604 = !DILocation(line: 47, column: 15, scope: !3600)
!3605 = !DILocation(line: 48, column: 15, scope: !3600)
!3606 = !DILocation(line: 50, column: 21, scope: !3600)
!3607 = !DILocation(line: 51, column: 21, scope: !3600)
!3608 = !DILocation(line: 52, column: 21, scope: !3600)
!3609 = !DILocation(line: 53, column: 21, scope: !3600)
!3610 = !DILocation(line: 54, column: 21, scope: !3600)
!3611 = !DILocation(line: 55, column: 21, scope: !3600)
!3612 = !DILocation(line: 56, column: 21, scope: !3600)
!3613 = !DILocation(line: 57, column: 21, scope: !3600)
!3614 = !DILocation(line: 58, column: 21, scope: !3600)
!3615 = !DILocation(line: 60, column: 15, scope: !3600)
!3616 = !DILocation(line: 61, column: 15, scope: !3600)
!3617 = !DILocation(line: 62, column: 15, scope: !3600)
!3618 = !DILocation(line: 63, column: 15, scope: !3600)
!3619 = !DILocation(line: 65, column: 15, scope: !3600)
!3620 = !DILocation(line: 66, column: 15, scope: !3600)
!3621 = !DILocation(line: 67, column: 21, scope: !3600)
!3622 = !DILocation(line: 68, column: 21, scope: !3600)
!3623 = !DILocation(line: 70, column: 21, scope: !3600)
!3624 = !DILocation(line: 71, column: 21, scope: !3600)
!3625 = !DILocation(line: 74, column: 37, scope: !3600)
!3626 = !DILocation(line: 74, column: 28, scope: !3600)
!3627 = !DILocation(line: 74, column: 21, scope: !3600)
!3628 = !DILocation(line: 75, column: 28, scope: !3600)
!3629 = !DILocation(line: 75, column: 33, scope: !3600)
!3630 = !DILocation(line: 75, column: 21, scope: !3600)
!3631 = !DILocation(line: 76, column: 28, scope: !3600)
!3632 = !DILocation(line: 76, column: 33, scope: !3600)
!3633 = !DILocation(line: 76, column: 21, scope: !3600)
!3634 = !DILocation(line: 79, column: 9, scope: !3600)
!3635 = !DILocation(line: 79, column: 14, scope: !3600)
!3636 = !DILocation(line: 79, column: 28, scope: !3600)
!3637 = !DILocation(line: 79, column: 33, scope: !3600)
!3638 = !DILocation(line: 79, column: 26, scope: !3600)
!3639 = !DILocation(line: 83, column: 21, scope: !3600)
!3640 = !DILocation(line: 83, column: 26, scope: !3600)
!3641 = !DILocation(line: 83, column: 19, scope: !3600)
!3642 = !DILocation(line: 84, column: 19, scope: !3600)
!3643 = !DILocation(line: 86, column: 37, scope: !3600)
!3644 = !DILocation(line: 86, column: 42, scope: !3600)
!3645 = !DILocation(line: 86, column: 25, scope: !3600)
!3646 = !DILocation(line: 88, column: 13, scope: !3600)
!3647 = !DILocation(line: 88, column: 23, scope: !3600)
!3648 = !DILocation(line: 89, column: 22, scope: !3600)
!3649 = !DILocation(line: 89, column: 13, scope: !3600)
!3650 = !DILocation(line: 91, column: 18, scope: !3600)
!3651 = !DILocation(line: 91, column: 28, scope: !3600)
!3652 = !DILocation(line: 92, column: 26, scope: !3600)
!3653 = !DILocation(line: 92, column: 36, scope: !3600)
!3654 = !DILocation(line: 92, column: 23, scope: !3600)
!3655 = !DILocation(line: 92, column: 13, scope: !3600)
!3656 = !DILocation(line: 93, column: 5, scope: !3600)
!3657 = !DILocation(line: 94, column: 14, scope: !3600)
!3658 = !DILocation(line: 94, column: 19, scope: !3600)
!3659 = !DILocation(line: 98, column: 19, scope: !3600)
!3660 = !DILocation(line: 99, column: 19, scope: !3600)
!3661 = !DILocation(line: 100, column: 24, scope: !3600)
!3662 = !DILocation(line: 100, column: 29, scope: !3600)
!3663 = !DILocation(line: 100, column: 43, scope: !3600)
!3664 = !DILocation(line: 100, column: 73, scope: !3600)
!3665 = !DILocation(line: 100, column: 19, scope: !3600)
!3666 = !DILocation(line: 101, column: 5, scope: !3600)
!3667 = !DILocation(line: 102, column: 14, scope: !3600)
!3668 = !DILocation(line: 102, column: 19, scope: !3600)
!3669 = !DILocation(line: 104, column: 19, scope: !3600)
!3670 = !DILocation(line: 105, column: 5, scope: !3600)
!3671 = !DILocation(line: 110, column: 26, scope: !3600)
!3672 = !DILocation(line: 110, column: 31, scope: !3600)
!3673 = !DILocation(line: 110, column: 19, scope: !3600)
!3674 = !DILocation(line: 111, column: 53, scope: !3600)
!3675 = !DILocation(line: 111, column: 51, scope: !3600)
!3676 = !DILocation(line: 111, column: 58, scope: !3600)
!3677 = !DILocation(line: 111, column: 19, scope: !3600)
!3678 = !DILocation(line: 113, column: 40, scope: !3600)
!3679 = !DILocation(line: 113, column: 45, scope: !3600)
!3680 = !DILocation(line: 113, column: 67, scope: !3600)
!3681 = !DILocation(line: 113, column: 25, scope: !3600)
!3682 = !DILocation(line: 116, column: 13, scope: !3600)
!3683 = !DILocation(line: 116, column: 19, scope: !3600)
!3684 = !DILocation(line: 117, column: 23, scope: !3600)
!3685 = !DILocation(line: 118, column: 9, scope: !3600)
!3686 = !DILocation(line: 119, column: 33, scope: !3600)
!3687 = !DILocation(line: 119, column: 59, scope: !3600)
!3688 = !DILocation(line: 119, column: 57, scope: !3600)
!3689 = !DILocation(line: 119, column: 45, scope: !3600)
!3690 = !DILocation(line: 119, column: 24, scope: !3600)
!3691 = !DILocation(line: 120, column: 49, scope: !3600)
!3692 = !DILocation(line: 120, column: 64, scope: !3600)
!3693 = !DILocation(line: 120, column: 61, scope: !3600)
!3694 = !DILocation(line: 120, column: 72, scope: !3600)
!3695 = !DILocation(line: 120, column: 70, scope: !3600)
!3696 = !DILocation(line: 120, column: 23, scope: !3600)
!3697 = !DILocation(line: 121, column: 25, scope: !3600)
!3698 = !DILocation(line: 121, column: 49, scope: !3600)
!3699 = !DILocation(line: 121, column: 23, scope: !3600)
!3700 = !DILocation(line: 122, column: 41, scope: !3600)
!3701 = !DILocation(line: 122, column: 65, scope: !3600)
!3702 = !DILocation(line: 122, column: 29, scope: !3600)
!3703 = !DILocation(line: 124, column: 17, scope: !3600)
!3704 = !DILocation(line: 124, column: 27, scope: !3600)
!3705 = !DILocation(line: 125, column: 26, scope: !3600)
!3706 = !DILocation(line: 125, column: 17, scope: !3600)
!3707 = !DILocation(line: 127, column: 22, scope: !3600)
!3708 = !DILocation(line: 127, column: 32, scope: !3600)
!3709 = !DILocation(line: 128, column: 30, scope: !3600)
!3710 = !DILocation(line: 128, column: 40, scope: !3600)
!3711 = !DILocation(line: 128, column: 27, scope: !3600)
!3712 = !DILocation(line: 128, column: 17, scope: !3600)
!3713 = !DILocation(line: 133, column: 30, scope: !3600)
!3714 = !DILocation(line: 133, column: 42, scope: !3600)
!3715 = !DILocation(line: 133, column: 47, scope: !3600)
!3716 = !DILocation(line: 133, column: 40, scope: !3600)
!3717 = !DILocation(line: 133, column: 21, scope: !3600)
!3718 = !DILocation(line: 134, column: 23, scope: !3600)
!3719 = !DILocation(line: 134, column: 12, scope: !3600)
!3720 = !DILocation(line: 134, column: 5, scope: !3600)
!3721 = distinct !DISubprogram(name: "srcToRep", scope: !3722, file: !3722, line: 66, type: !178, isLocal: true, isDefinition: true, scopeLine: 66, flags: DIFlagPrototyped, isOptimized: false, unit: !163, retainedNodes: !2)
!3722 = !DIFile(filename: "/home/hahns/Schreibtisch/llvmta_testcases/libraries/builtinsfloat/fp_trunc.h", directory: "/home/hahns/Schreibtisch/llvmta_testcases/tmp.0b9rXPKPan")
!3723 = !DILocation(line: 67, column: 49, scope: !3721)
!3724 = !DILocation(line: 67, column: 55, scope: !3721)
!3725 = !DILocation(line: 68, column: 16, scope: !3721)
!3726 = !DILocation(line: 68, column: 5, scope: !3721)
!3727 = distinct !DISubprogram(name: "dstFromRep", scope: !3722, file: !3722, line: 71, type: !178, isLocal: true, isDefinition: true, scopeLine: 71, flags: DIFlagPrototyped, isOptimized: false, unit: !163, retainedNodes: !2)
!3728 = !DILocation(line: 72, column: 49, scope: !3727)
!3729 = !DILocation(line: 72, column: 55, scope: !3727)
!3730 = !DILocation(line: 73, column: 16, scope: !3727)
!3731 = !DILocation(line: 73, column: 5, scope: !3727)
!3732 = distinct !DISubprogram(name: "__truncdfsf2", scope: !166, file: !166, line: 16, type: !178, isLocal: false, isDefinition: true, scopeLine: 16, flags: DIFlagPrototyped, isOptimized: false, unit: !165, retainedNodes: !2)
!3733 = !DILocation(line: 17, column: 27, scope: !3732)
!3734 = !DILocation(line: 17, column: 12, scope: !3732)
!3735 = !DILocation(line: 17, column: 5, scope: !3732)
!3736 = distinct !DISubprogram(name: "__truncXfYf2__", scope: !3601, file: !3601, line: 42, type: !178, isLocal: true, isDefinition: true, scopeLine: 42, flags: DIFlagPrototyped, isOptimized: false, unit: !165, retainedNodes: !2)
!3737 = !DILocation(line: 45, column: 15, scope: !3736)
!3738 = !DILocation(line: 46, column: 15, scope: !3736)
!3739 = !DILocation(line: 47, column: 15, scope: !3736)
!3740 = !DILocation(line: 48, column: 15, scope: !3736)
!3741 = !DILocation(line: 50, column: 21, scope: !3736)
!3742 = !DILocation(line: 51, column: 21, scope: !3736)
!3743 = !DILocation(line: 52, column: 21, scope: !3736)
!3744 = !DILocation(line: 53, column: 21, scope: !3736)
!3745 = !DILocation(line: 54, column: 21, scope: !3736)
!3746 = !DILocation(line: 55, column: 21, scope: !3736)
!3747 = !DILocation(line: 56, column: 21, scope: !3736)
!3748 = !DILocation(line: 57, column: 21, scope: !3736)
!3749 = !DILocation(line: 58, column: 21, scope: !3736)
!3750 = !DILocation(line: 60, column: 15, scope: !3736)
!3751 = !DILocation(line: 61, column: 15, scope: !3736)
!3752 = !DILocation(line: 62, column: 15, scope: !3736)
!3753 = !DILocation(line: 63, column: 15, scope: !3736)
!3754 = !DILocation(line: 65, column: 15, scope: !3736)
!3755 = !DILocation(line: 66, column: 15, scope: !3736)
!3756 = !DILocation(line: 67, column: 21, scope: !3736)
!3757 = !DILocation(line: 68, column: 21, scope: !3736)
!3758 = !DILocation(line: 70, column: 21, scope: !3736)
!3759 = !DILocation(line: 71, column: 21, scope: !3736)
!3760 = !DILocation(line: 74, column: 37, scope: !3736)
!3761 = !DILocation(line: 74, column: 28, scope: !3736)
!3762 = !DILocation(line: 74, column: 21, scope: !3736)
!3763 = !DILocation(line: 75, column: 28, scope: !3736)
!3764 = !DILocation(line: 75, column: 33, scope: !3736)
!3765 = !DILocation(line: 75, column: 21, scope: !3736)
!3766 = !DILocation(line: 76, column: 28, scope: !3736)
!3767 = !DILocation(line: 76, column: 33, scope: !3736)
!3768 = !DILocation(line: 76, column: 21, scope: !3736)
!3769 = !DILocation(line: 79, column: 9, scope: !3736)
!3770 = !DILocation(line: 79, column: 14, scope: !3736)
!3771 = !DILocation(line: 79, column: 28, scope: !3736)
!3772 = !DILocation(line: 79, column: 33, scope: !3736)
!3773 = !DILocation(line: 79, column: 26, scope: !3736)
!3774 = !DILocation(line: 83, column: 21, scope: !3736)
!3775 = !DILocation(line: 83, column: 26, scope: !3736)
!3776 = !DILocation(line: 83, column: 19, scope: !3736)
!3777 = !DILocation(line: 84, column: 19, scope: !3736)
!3778 = !DILocation(line: 86, column: 37, scope: !3736)
!3779 = !DILocation(line: 86, column: 42, scope: !3736)
!3780 = !DILocation(line: 86, column: 25, scope: !3736)
!3781 = !DILocation(line: 88, column: 13, scope: !3736)
!3782 = !DILocation(line: 88, column: 23, scope: !3736)
!3783 = !DILocation(line: 89, column: 22, scope: !3736)
!3784 = !DILocation(line: 89, column: 13, scope: !3736)
!3785 = !DILocation(line: 91, column: 18, scope: !3736)
!3786 = !DILocation(line: 91, column: 28, scope: !3736)
!3787 = !DILocation(line: 92, column: 26, scope: !3736)
!3788 = !DILocation(line: 92, column: 36, scope: !3736)
!3789 = !DILocation(line: 92, column: 23, scope: !3736)
!3790 = !DILocation(line: 92, column: 13, scope: !3736)
!3791 = !DILocation(line: 93, column: 5, scope: !3736)
!3792 = !DILocation(line: 94, column: 14, scope: !3736)
!3793 = !DILocation(line: 94, column: 19, scope: !3736)
!3794 = !DILocation(line: 98, column: 19, scope: !3736)
!3795 = !DILocation(line: 99, column: 19, scope: !3736)
!3796 = !DILocation(line: 100, column: 24, scope: !3736)
!3797 = !DILocation(line: 100, column: 29, scope: !3736)
!3798 = !DILocation(line: 100, column: 43, scope: !3736)
!3799 = !DILocation(line: 100, column: 73, scope: !3736)
!3800 = !DILocation(line: 100, column: 19, scope: !3736)
!3801 = !DILocation(line: 101, column: 5, scope: !3736)
!3802 = !DILocation(line: 102, column: 14, scope: !3736)
!3803 = !DILocation(line: 102, column: 19, scope: !3736)
!3804 = !DILocation(line: 104, column: 19, scope: !3736)
!3805 = !DILocation(line: 105, column: 5, scope: !3736)
!3806 = !DILocation(line: 110, column: 26, scope: !3736)
!3807 = !DILocation(line: 110, column: 31, scope: !3736)
!3808 = !DILocation(line: 110, column: 19, scope: !3736)
!3809 = !DILocation(line: 111, column: 53, scope: !3736)
!3810 = !DILocation(line: 111, column: 51, scope: !3736)
!3811 = !DILocation(line: 111, column: 58, scope: !3736)
!3812 = !DILocation(line: 111, column: 19, scope: !3736)
!3813 = !DILocation(line: 113, column: 40, scope: !3736)
!3814 = !DILocation(line: 113, column: 45, scope: !3736)
!3815 = !DILocation(line: 113, column: 67, scope: !3736)
!3816 = !DILocation(line: 113, column: 25, scope: !3736)
!3817 = !DILocation(line: 116, column: 13, scope: !3736)
!3818 = !DILocation(line: 116, column: 19, scope: !3736)
!3819 = !DILocation(line: 117, column: 23, scope: !3736)
!3820 = !DILocation(line: 118, column: 9, scope: !3736)
!3821 = !DILocation(line: 119, column: 33, scope: !3736)
!3822 = !DILocation(line: 119, column: 59, scope: !3736)
!3823 = !DILocation(line: 119, column: 57, scope: !3736)
!3824 = !DILocation(line: 119, column: 45, scope: !3736)
!3825 = !DILocation(line: 119, column: 24, scope: !3736)
!3826 = !DILocation(line: 120, column: 49, scope: !3736)
!3827 = !DILocation(line: 120, column: 64, scope: !3736)
!3828 = !DILocation(line: 120, column: 61, scope: !3736)
!3829 = !DILocation(line: 120, column: 72, scope: !3736)
!3830 = !DILocation(line: 120, column: 70, scope: !3736)
!3831 = !DILocation(line: 120, column: 23, scope: !3736)
!3832 = !DILocation(line: 121, column: 25, scope: !3736)
!3833 = !DILocation(line: 121, column: 49, scope: !3736)
!3834 = !DILocation(line: 121, column: 23, scope: !3736)
!3835 = !DILocation(line: 122, column: 41, scope: !3736)
!3836 = !DILocation(line: 122, column: 65, scope: !3736)
!3837 = !DILocation(line: 122, column: 29, scope: !3736)
!3838 = !DILocation(line: 124, column: 17, scope: !3736)
!3839 = !DILocation(line: 124, column: 27, scope: !3736)
!3840 = !DILocation(line: 125, column: 26, scope: !3736)
!3841 = !DILocation(line: 125, column: 17, scope: !3736)
!3842 = !DILocation(line: 127, column: 22, scope: !3736)
!3843 = !DILocation(line: 127, column: 32, scope: !3736)
!3844 = !DILocation(line: 128, column: 30, scope: !3736)
!3845 = !DILocation(line: 128, column: 40, scope: !3736)
!3846 = !DILocation(line: 128, column: 27, scope: !3736)
!3847 = !DILocation(line: 128, column: 17, scope: !3736)
!3848 = !DILocation(line: 133, column: 30, scope: !3736)
!3849 = !DILocation(line: 133, column: 42, scope: !3736)
!3850 = !DILocation(line: 133, column: 47, scope: !3736)
!3851 = !DILocation(line: 133, column: 40, scope: !3736)
!3852 = !DILocation(line: 133, column: 21, scope: !3736)
!3853 = !DILocation(line: 134, column: 23, scope: !3736)
!3854 = !DILocation(line: 134, column: 12, scope: !3736)
!3855 = !DILocation(line: 134, column: 5, scope: !3736)
!3856 = distinct !DISubprogram(name: "srcToRep", scope: !3722, file: !3722, line: 66, type: !178, isLocal: true, isDefinition: true, scopeLine: 66, flags: DIFlagPrototyped, isOptimized: false, unit: !165, retainedNodes: !2)
!3857 = !DILocation(line: 67, column: 49, scope: !3856)
!3858 = !DILocation(line: 67, column: 55, scope: !3856)
!3859 = !DILocation(line: 68, column: 16, scope: !3856)
!3860 = !DILocation(line: 68, column: 5, scope: !3856)
!3861 = distinct !DISubprogram(name: "dstFromRep", scope: !3722, file: !3722, line: 71, type: !178, isLocal: true, isDefinition: true, scopeLine: 71, flags: DIFlagPrototyped, isOptimized: false, unit: !165, retainedNodes: !2)
!3862 = !DILocation(line: 72, column: 49, scope: !3861)
!3863 = !DILocation(line: 72, column: 55, scope: !3861)
!3864 = !DILocation(line: 73, column: 16, scope: !3861)
!3865 = !DILocation(line: 73, column: 5, scope: !3861)
!3866 = distinct !DISubprogram(name: "__truncsfhf2", scope: !168, file: !168, line: 18, type: !178, isLocal: false, isDefinition: true, scopeLine: 18, flags: DIFlagPrototyped, isOptimized: false, unit: !167, retainedNodes: !2)
!3867 = !DILocation(line: 19, column: 27, scope: !3866)
!3868 = !DILocation(line: 19, column: 12, scope: !3866)
!3869 = !DILocation(line: 19, column: 5, scope: !3866)
!3870 = distinct !DISubprogram(name: "__truncXfYf2__", scope: !3601, file: !3601, line: 42, type: !178, isLocal: true, isDefinition: true, scopeLine: 42, flags: DIFlagPrototyped, isOptimized: false, unit: !167, retainedNodes: !2)
!3871 = !DILocation(line: 45, column: 15, scope: !3870)
!3872 = !DILocation(line: 46, column: 15, scope: !3870)
!3873 = !DILocation(line: 47, column: 15, scope: !3870)
!3874 = !DILocation(line: 48, column: 15, scope: !3870)
!3875 = !DILocation(line: 50, column: 21, scope: !3870)
!3876 = !DILocation(line: 51, column: 21, scope: !3870)
!3877 = !DILocation(line: 52, column: 21, scope: !3870)
!3878 = !DILocation(line: 53, column: 21, scope: !3870)
!3879 = !DILocation(line: 54, column: 21, scope: !3870)
!3880 = !DILocation(line: 55, column: 21, scope: !3870)
!3881 = !DILocation(line: 56, column: 21, scope: !3870)
!3882 = !DILocation(line: 57, column: 21, scope: !3870)
!3883 = !DILocation(line: 58, column: 21, scope: !3870)
!3884 = !DILocation(line: 60, column: 15, scope: !3870)
!3885 = !DILocation(line: 61, column: 15, scope: !3870)
!3886 = !DILocation(line: 62, column: 15, scope: !3870)
!3887 = !DILocation(line: 63, column: 15, scope: !3870)
!3888 = !DILocation(line: 65, column: 15, scope: !3870)
!3889 = !DILocation(line: 66, column: 15, scope: !3870)
!3890 = !DILocation(line: 67, column: 21, scope: !3870)
!3891 = !DILocation(line: 68, column: 21, scope: !3870)
!3892 = !DILocation(line: 70, column: 21, scope: !3870)
!3893 = !DILocation(line: 71, column: 21, scope: !3870)
!3894 = !DILocation(line: 74, column: 37, scope: !3870)
!3895 = !DILocation(line: 74, column: 28, scope: !3870)
!3896 = !DILocation(line: 74, column: 21, scope: !3870)
!3897 = !DILocation(line: 75, column: 28, scope: !3870)
!3898 = !DILocation(line: 75, column: 33, scope: !3870)
!3899 = !DILocation(line: 75, column: 21, scope: !3870)
!3900 = !DILocation(line: 76, column: 28, scope: !3870)
!3901 = !DILocation(line: 76, column: 33, scope: !3870)
!3902 = !DILocation(line: 76, column: 21, scope: !3870)
!3903 = !DILocation(line: 79, column: 9, scope: !3870)
!3904 = !DILocation(line: 79, column: 14, scope: !3870)
!3905 = !DILocation(line: 79, column: 28, scope: !3870)
!3906 = !DILocation(line: 79, column: 33, scope: !3870)
!3907 = !DILocation(line: 79, column: 26, scope: !3870)
!3908 = !DILocation(line: 83, column: 21, scope: !3870)
!3909 = !DILocation(line: 83, column: 26, scope: !3870)
!3910 = !DILocation(line: 83, column: 19, scope: !3870)
!3911 = !DILocation(line: 84, column: 19, scope: !3870)
!3912 = !DILocation(line: 86, column: 37, scope: !3870)
!3913 = !DILocation(line: 86, column: 42, scope: !3870)
!3914 = !DILocation(line: 86, column: 25, scope: !3870)
!3915 = !DILocation(line: 88, column: 13, scope: !3870)
!3916 = !DILocation(line: 88, column: 23, scope: !3870)
!3917 = !DILocation(line: 89, column: 22, scope: !3870)
!3918 = !DILocation(line: 89, column: 13, scope: !3870)
!3919 = !DILocation(line: 91, column: 18, scope: !3870)
!3920 = !DILocation(line: 91, column: 28, scope: !3870)
!3921 = !DILocation(line: 92, column: 26, scope: !3870)
!3922 = !DILocation(line: 92, column: 36, scope: !3870)
!3923 = !DILocation(line: 92, column: 23, scope: !3870)
!3924 = !DILocation(line: 92, column: 13, scope: !3870)
!3925 = !DILocation(line: 93, column: 5, scope: !3870)
!3926 = !DILocation(line: 94, column: 14, scope: !3870)
!3927 = !DILocation(line: 94, column: 19, scope: !3870)
!3928 = !DILocation(line: 98, column: 19, scope: !3870)
!3929 = !DILocation(line: 99, column: 19, scope: !3870)
!3930 = !DILocation(line: 100, column: 24, scope: !3870)
!3931 = !DILocation(line: 100, column: 29, scope: !3870)
!3932 = !DILocation(line: 100, column: 43, scope: !3870)
!3933 = !DILocation(line: 100, column: 73, scope: !3870)
!3934 = !DILocation(line: 100, column: 19, scope: !3870)
!3935 = !DILocation(line: 101, column: 5, scope: !3870)
!3936 = !DILocation(line: 102, column: 14, scope: !3870)
!3937 = !DILocation(line: 102, column: 19, scope: !3870)
!3938 = !DILocation(line: 104, column: 19, scope: !3870)
!3939 = !DILocation(line: 105, column: 5, scope: !3870)
!3940 = !DILocation(line: 110, column: 26, scope: !3870)
!3941 = !DILocation(line: 110, column: 31, scope: !3870)
!3942 = !DILocation(line: 110, column: 19, scope: !3870)
!3943 = !DILocation(line: 111, column: 53, scope: !3870)
!3944 = !DILocation(line: 111, column: 51, scope: !3870)
!3945 = !DILocation(line: 111, column: 58, scope: !3870)
!3946 = !DILocation(line: 111, column: 19, scope: !3870)
!3947 = !DILocation(line: 113, column: 40, scope: !3870)
!3948 = !DILocation(line: 113, column: 45, scope: !3870)
!3949 = !DILocation(line: 113, column: 67, scope: !3870)
!3950 = !DILocation(line: 113, column: 25, scope: !3870)
!3951 = !DILocation(line: 116, column: 13, scope: !3870)
!3952 = !DILocation(line: 116, column: 19, scope: !3870)
!3953 = !DILocation(line: 117, column: 23, scope: !3870)
!3954 = !DILocation(line: 118, column: 9, scope: !3870)
!3955 = !DILocation(line: 119, column: 33, scope: !3870)
!3956 = !DILocation(line: 119, column: 59, scope: !3870)
!3957 = !DILocation(line: 119, column: 57, scope: !3870)
!3958 = !DILocation(line: 119, column: 45, scope: !3870)
!3959 = !DILocation(line: 119, column: 24, scope: !3870)
!3960 = !DILocation(line: 120, column: 49, scope: !3870)
!3961 = !DILocation(line: 120, column: 64, scope: !3870)
!3962 = !DILocation(line: 120, column: 61, scope: !3870)
!3963 = !DILocation(line: 120, column: 72, scope: !3870)
!3964 = !DILocation(line: 120, column: 70, scope: !3870)
!3965 = !DILocation(line: 120, column: 23, scope: !3870)
!3966 = !DILocation(line: 121, column: 25, scope: !3870)
!3967 = !DILocation(line: 121, column: 49, scope: !3870)
!3968 = !DILocation(line: 121, column: 23, scope: !3870)
!3969 = !DILocation(line: 122, column: 41, scope: !3870)
!3970 = !DILocation(line: 122, column: 65, scope: !3870)
!3971 = !DILocation(line: 122, column: 29, scope: !3870)
!3972 = !DILocation(line: 124, column: 17, scope: !3870)
!3973 = !DILocation(line: 124, column: 27, scope: !3870)
!3974 = !DILocation(line: 125, column: 26, scope: !3870)
!3975 = !DILocation(line: 125, column: 17, scope: !3870)
!3976 = !DILocation(line: 127, column: 22, scope: !3870)
!3977 = !DILocation(line: 127, column: 32, scope: !3870)
!3978 = !DILocation(line: 128, column: 30, scope: !3870)
!3979 = !DILocation(line: 128, column: 40, scope: !3870)
!3980 = !DILocation(line: 128, column: 27, scope: !3870)
!3981 = !DILocation(line: 128, column: 17, scope: !3870)
!3982 = !DILocation(line: 133, column: 30, scope: !3870)
!3983 = !DILocation(line: 133, column: 42, scope: !3870)
!3984 = !DILocation(line: 133, column: 47, scope: !3870)
!3985 = !DILocation(line: 133, column: 40, scope: !3870)
!3986 = !DILocation(line: 133, column: 21, scope: !3870)
!3987 = !DILocation(line: 134, column: 23, scope: !3870)
!3988 = !DILocation(line: 134, column: 12, scope: !3870)
!3989 = !DILocation(line: 134, column: 5, scope: !3870)
!3990 = distinct !DISubprogram(name: "srcToRep", scope: !3722, file: !3722, line: 66, type: !178, isLocal: true, isDefinition: true, scopeLine: 66, flags: DIFlagPrototyped, isOptimized: false, unit: !167, retainedNodes: !2)
!3991 = !DILocation(line: 67, column: 49, scope: !3990)
!3992 = !DILocation(line: 67, column: 55, scope: !3990)
!3993 = !DILocation(line: 68, column: 16, scope: !3990)
!3994 = !DILocation(line: 68, column: 5, scope: !3990)
!3995 = distinct !DISubprogram(name: "dstFromRep", scope: !3722, file: !3722, line: 71, type: !178, isLocal: true, isDefinition: true, scopeLine: 71, flags: DIFlagPrototyped, isOptimized: false, unit: !167, retainedNodes: !2)
!3996 = !DILocation(line: 72, column: 49, scope: !3995)
!3997 = !DILocation(line: 72, column: 55, scope: !3995)
!3998 = !DILocation(line: 73, column: 16, scope: !3995)
!3999 = !DILocation(line: 73, column: 5, scope: !3995)
!4000 = distinct !DISubprogram(name: "__gnu_f2h_ieee", scope: !168, file: !168, line: 22, type: !178, isLocal: false, isDefinition: true, scopeLine: 22, flags: DIFlagPrototyped, isOptimized: false, unit: !167, retainedNodes: !2)
!4001 = !DILocation(line: 23, column: 25, scope: !4000)
!4002 = !DILocation(line: 23, column: 12, scope: !4000)
!4003 = !DILocation(line: 23, column: 5, scope: !4000)
