; ModuleID = 'llvm-link'
source_filename = "llvm-link"
target datalayout = "e-m:e-p:32:32-Fi8-i64:64-v128:64:128-a:0:32-n32-S64"
target triple = "armv4t-unknown-unknown"

%union.anon.0 = type { double }
%union.anon.0.0 = type { float }
%union.anon = type { i16 }
%union.long_double_bits = type { %struct.uqwords }
%struct.uqwords = type { %union.udwords, %union.udwords }
%union.udwords = type { i64 }
%struct.anon = type { i32, i32 }
%union.float_bits = type { i32 }

@__const.__floatdidf.low = private unnamed_addr constant { double } { double 0x4330000000000000 }, align 8
@__const.__floatundidf.high = private unnamed_addr constant { double } { double 0x4530000000000000 }, align 8
@__const.__floatundidf.low = private unnamed_addr constant { double } { double 0x4330000000000000 }, align 8
@.str = private unnamed_addr constant [13 x i8] c"../negvdi2.c\00", align 1
@__func__.__negvdi2 = private unnamed_addr constant [10 x i8] c"__negvdi2\00", align 1
@.str.50 = private unnamed_addr constant [13 x i8] c"../negvsi2.c\00", align 1
@__func__.__negvsi2 = private unnamed_addr constant [10 x i8] c"__negvsi2\00", align 1

@__aeabi_dadd = dso_local alias void (...), bitcast (double (double, double)* @__adddf3 to void (...)*)
@__aeabi_fadd = dso_local alias void (...), bitcast (float (float, float)* @__addsf3 to void (...)*)
@__aeabi_dcmpun = dso_local alias void (...), bitcast (i32 (double, double)* @__unorddf2 to void (...)*)
@__aeabi_fcmpun = dso_local alias void (...), bitcast (i32 (float, float)* @__unordsf2 to void (...)*)
@__aeabi_ddiv = dso_local alias void (...), bitcast (double (double, double)* @__divdf3 to void (...)*)
@__aeabi_fdiv = dso_local alias void (...), bitcast (float (float, float)* @__divsf3 to void (...)*)
@__aeabi_h2f = dso_local alias void (...), bitcast (float (i16)* @__extendhfsf2 to void (...)*)
@__aeabi_f2d = dso_local alias void (...), bitcast (double (float)* @__extendsfdf2 to void (...)*)
@__aeabi_d2lz = dso_local alias void (...), bitcast (i64 (double)* @__fixdfdi to void (...)*)
@__aeabi_d2iz = dso_local alias void (...), bitcast (i32 (double)* @__fixdfsi to void (...)*)
@__aeabi_f2lz = dso_local alias void (...), bitcast (i64 (float)* @__fixsfdi to void (...)*)
@__aeabi_f2iz = dso_local alias void (...), bitcast (i32 (float)* @__fixsfsi to void (...)*)
@__aeabi_d2ulz = dso_local alias void (...), bitcast (i64 (double)* @__fixunsdfdi to void (...)*)
@__aeabi_d2uiz = dso_local alias void (...), bitcast (i32 (double)* @__fixunsdfsi to void (...)*)
@__aeabi_f2ulz = dso_local alias void (...), bitcast (i64 (float)* @__fixunssfdi to void (...)*)
@__aeabi_f2uiz = dso_local alias void (...), bitcast (i32 (float)* @__fixunssfsi to void (...)*)
@__aeabi_l2d = dso_local alias void (...), bitcast (double (i64)* @__floatdidf to void (...)*)
@__aeabi_l2f = dso_local alias void (...), bitcast (float (i64)* @__floatdisf to void (...)*)
@__aeabi_i2d = dso_local alias void (...), bitcast (double (i32)* @__floatsidf to void (...)*)
@__aeabi_i2f = dso_local alias void (...), bitcast (float (i32)* @__floatsisf to void (...)*)
@__aeabi_ul2d = dso_local alias void (...), bitcast (double (i64)* @__floatundidf to void (...)*)
@__aeabi_ul2f = dso_local alias void (...), bitcast (float (i64)* @__floatundisf to void (...)*)
@__aeabi_ui2d = dso_local alias void (...), bitcast (double (i32)* @__floatunsidf to void (...)*)
@__aeabi_ui2f = dso_local alias void (...), bitcast (float (i32)* @__floatunsisf to void (...)*)
@__aeabi_dmul = dso_local alias void (...), bitcast (double (double, double)* @__muldf3 to void (...)*)
@__aeabi_lmul = dso_local alias void (...), bitcast (i64 (i64, i64)* @__muldi3 to void (...)*)
@__aeabi_fmul = dso_local alias void (...), bitcast (float (float, float)* @__mulsf3 to void (...)*)
@__aeabi_dneg = dso_local alias void (...), bitcast (double (double)* @__negdf2 to void (...)*)
@__aeabi_fneg = dso_local alias void (...), bitcast (float (float)* @__negsf2 to void (...)*)
@__aeabi_dsub = dso_local alias void (...), bitcast (double (double, double)* @__subdf3 to void (...)*)
@__aeabi_fsub = dso_local alias void (...), bitcast (float (float, float)* @__subsf3 to void (...)*)
@__aeabi_d2h = dso_local alias void (...), bitcast (i16 (double)* @__truncdfhf2 to void (...)*)
@__aeabi_d2f = dso_local alias void (...), bitcast (float (double)* @__truncdfsf2 to void (...)*)
@__aeabi_f2h = dso_local alias void (...), bitcast (i16 (float)* @__truncsfhf2 to void (...)*)

; Function Attrs: noinline nounwind
define dso_local arm_aapcscc double @__adddf3(double noundef %a, double noundef %b) #0 !dbg !182 {
entry:
  %a.addr = alloca double, align 8
  %b.addr = alloca double, align 8
  store double %a, double* %a.addr, align 8
  store double %b, double* %b.addr, align 8
  %0 = load double, double* %a.addr, align 8, !dbg !185
  %1 = load double, double* %b.addr, align 8, !dbg !186
  %call = call arm_aapcscc double @__addXf3__(double noundef %0, double noundef %1) #4, !dbg !187
  ret double %call, !dbg !188
}

; Function Attrs: noinline nounwind
define internal arm_aapcscc double @__addXf3__(double noundef %a, double noundef %b) #0 !dbg !189 {
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
  %0 = load double, double* %a.addr, align 8, !dbg !191
  %call = call arm_aapcscc i64 @toRep(double noundef %0) #4, !dbg !192
  store i64 %call, i64* %aRep, align 8, !dbg !193
  %1 = load double, double* %b.addr, align 8, !dbg !194
  %call1 = call arm_aapcscc i64 @toRep(double noundef %1) #4, !dbg !195
  store i64 %call1, i64* %bRep, align 8, !dbg !196
  %2 = load i64, i64* %aRep, align 8, !dbg !197
  %and = and i64 %2, 9223372036854775807, !dbg !198
  store i64 %and, i64* %aAbs, align 8, !dbg !199
  %3 = load i64, i64* %bRep, align 8, !dbg !200
  %and2 = and i64 %3, 9223372036854775807, !dbg !201
  store i64 %and2, i64* %bAbs, align 8, !dbg !202
  %4 = load i64, i64* %aAbs, align 8, !dbg !203
  %sub = sub i64 %4, 1, !dbg !204
  %cmp = icmp uge i64 %sub, 9218868437227405311, !dbg !205
  br i1 %cmp, label %if.then, label %lor.lhs.false, !dbg !206

lor.lhs.false:                                    ; preds = %entry
  %5 = load i64, i64* %bAbs, align 8, !dbg !207
  %sub3 = sub i64 %5, 1, !dbg !208
  %cmp4 = icmp uge i64 %sub3, 9218868437227405311, !dbg !209
  br i1 %cmp4, label %if.then, label %if.end38, !dbg !203

if.then:                                          ; preds = %lor.lhs.false, %entry
  %6 = load i64, i64* %aAbs, align 8, !dbg !210
  %cmp5 = icmp ugt i64 %6, 9218868437227405312, !dbg !211
  br i1 %cmp5, label %if.then6, label %if.end, !dbg !210

if.then6:                                         ; preds = %if.then
  %7 = load double, double* %a.addr, align 8, !dbg !212
  %call7 = call arm_aapcscc i64 @toRep(double noundef %7) #4, !dbg !213
  %or = or i64 %call7, 2251799813685248, !dbg !214
  %call8 = call arm_aapcscc double @fromRep(i64 noundef %or) #4, !dbg !215
  store double %call8, double* %retval, align 8, !dbg !216
  br label %return, !dbg !216

if.end:                                           ; preds = %if.then
  %8 = load i64, i64* %bAbs, align 8, !dbg !217
  %cmp9 = icmp ugt i64 %8, 9218868437227405312, !dbg !218
  br i1 %cmp9, label %if.then10, label %if.end14, !dbg !217

if.then10:                                        ; preds = %if.end
  %9 = load double, double* %b.addr, align 8, !dbg !219
  %call11 = call arm_aapcscc i64 @toRep(double noundef %9) #4, !dbg !220
  %or12 = or i64 %call11, 2251799813685248, !dbg !221
  %call13 = call arm_aapcscc double @fromRep(i64 noundef %or12) #4, !dbg !222
  store double %call13, double* %retval, align 8, !dbg !223
  br label %return, !dbg !223

if.end14:                                         ; preds = %if.end
  %10 = load i64, i64* %aAbs, align 8, !dbg !224
  %cmp15 = icmp eq i64 %10, 9218868437227405312, !dbg !225
  br i1 %cmp15, label %if.then16, label %if.end22, !dbg !224

if.then16:                                        ; preds = %if.end14
  %11 = load double, double* %a.addr, align 8, !dbg !226
  %call17 = call arm_aapcscc i64 @toRep(double noundef %11) #4, !dbg !227
  %12 = load double, double* %b.addr, align 8, !dbg !228
  %call18 = call arm_aapcscc i64 @toRep(double noundef %12) #4, !dbg !229
  %xor = xor i64 %call17, %call18, !dbg !230
  %cmp19 = icmp eq i64 %xor, -9223372036854775808, !dbg !231
  br i1 %cmp19, label %if.then20, label %if.else, !dbg !232

if.then20:                                        ; preds = %if.then16
  %call21 = call arm_aapcscc double @fromRep(i64 noundef 9221120237041090560) #4, !dbg !233
  store double %call21, double* %retval, align 8, !dbg !234
  br label %return, !dbg !234

if.else:                                          ; preds = %if.then16
  %13 = load double, double* %a.addr, align 8, !dbg !235
  store double %13, double* %retval, align 8, !dbg !236
  br label %return, !dbg !236

if.end22:                                         ; preds = %if.end14
  %14 = load i64, i64* %bAbs, align 8, !dbg !237
  %cmp23 = icmp eq i64 %14, 9218868437227405312, !dbg !238
  br i1 %cmp23, label %if.then24, label %if.end25, !dbg !237

if.then24:                                        ; preds = %if.end22
  %15 = load double, double* %b.addr, align 8, !dbg !239
  store double %15, double* %retval, align 8, !dbg !240
  br label %return, !dbg !240

if.end25:                                         ; preds = %if.end22
  %16 = load i64, i64* %aAbs, align 8, !dbg !241
  %tobool = icmp ne i64 %16, 0, !dbg !241
  br i1 %tobool, label %if.end34, label %if.then26, !dbg !242

if.then26:                                        ; preds = %if.end25
  %17 = load i64, i64* %bAbs, align 8, !dbg !243
  %tobool27 = icmp ne i64 %17, 0, !dbg !243
  br i1 %tobool27, label %if.else33, label %if.then28, !dbg !244

if.then28:                                        ; preds = %if.then26
  %18 = load double, double* %a.addr, align 8, !dbg !245
  %call29 = call arm_aapcscc i64 @toRep(double noundef %18) #4, !dbg !246
  %19 = load double, double* %b.addr, align 8, !dbg !247
  %call30 = call arm_aapcscc i64 @toRep(double noundef %19) #4, !dbg !248
  %and31 = and i64 %call29, %call30, !dbg !249
  %call32 = call arm_aapcscc double @fromRep(i64 noundef %and31) #4, !dbg !250
  store double %call32, double* %retval, align 8, !dbg !251
  br label %return, !dbg !251

if.else33:                                        ; preds = %if.then26
  %20 = load double, double* %b.addr, align 8, !dbg !252
  store double %20, double* %retval, align 8, !dbg !253
  br label %return, !dbg !253

if.end34:                                         ; preds = %if.end25
  %21 = load i64, i64* %bAbs, align 8, !dbg !254
  %tobool35 = icmp ne i64 %21, 0, !dbg !254
  br i1 %tobool35, label %if.end37, label %if.then36, !dbg !255

if.then36:                                        ; preds = %if.end34
  %22 = load double, double* %a.addr, align 8, !dbg !256
  store double %22, double* %retval, align 8, !dbg !257
  br label %return, !dbg !257

if.end37:                                         ; preds = %if.end34
  br label %if.end38, !dbg !258

if.end38:                                         ; preds = %if.end37, %lor.lhs.false
  %23 = load i64, i64* %bAbs, align 8, !dbg !259
  %24 = load i64, i64* %aAbs, align 8, !dbg !260
  %cmp39 = icmp ugt i64 %23, %24, !dbg !261
  br i1 %cmp39, label %if.then40, label %if.end41, !dbg !259

if.then40:                                        ; preds = %if.end38
  %25 = load i64, i64* %aRep, align 8, !dbg !262
  store i64 %25, i64* %temp, align 8, !dbg !263
  %26 = load i64, i64* %bRep, align 8, !dbg !264
  store i64 %26, i64* %aRep, align 8, !dbg !265
  %27 = load i64, i64* %temp, align 8, !dbg !266
  store i64 %27, i64* %bRep, align 8, !dbg !267
  br label %if.end41, !dbg !268

if.end41:                                         ; preds = %if.then40, %if.end38
  %28 = load i64, i64* %aRep, align 8, !dbg !269
  %shr = lshr i64 %28, 52, !dbg !270
  %and42 = and i64 %shr, 2047, !dbg !271
  %conv = trunc i64 %and42 to i32, !dbg !269
  store i32 %conv, i32* %aExponent, align 4, !dbg !272
  %29 = load i64, i64* %bRep, align 8, !dbg !273
  %shr43 = lshr i64 %29, 52, !dbg !274
  %and44 = and i64 %shr43, 2047, !dbg !275
  %conv45 = trunc i64 %and44 to i32, !dbg !273
  store i32 %conv45, i32* %bExponent, align 4, !dbg !276
  %30 = load i64, i64* %aRep, align 8, !dbg !277
  %and46 = and i64 %30, 4503599627370495, !dbg !278
  store i64 %and46, i64* %aSignificand, align 8, !dbg !279
  %31 = load i64, i64* %bRep, align 8, !dbg !280
  %and47 = and i64 %31, 4503599627370495, !dbg !281
  store i64 %and47, i64* %bSignificand, align 8, !dbg !282
  %32 = load i32, i32* %aExponent, align 4, !dbg !283
  %cmp48 = icmp eq i32 %32, 0, !dbg !284
  br i1 %cmp48, label %if.then50, label %if.end52, !dbg !283

if.then50:                                        ; preds = %if.end41
  %call51 = call arm_aapcscc i32 @normalize(i64* noundef %aSignificand) #4, !dbg !285
  store i32 %call51, i32* %aExponent, align 4, !dbg !286
  br label %if.end52, !dbg !287

if.end52:                                         ; preds = %if.then50, %if.end41
  %33 = load i32, i32* %bExponent, align 4, !dbg !288
  %cmp53 = icmp eq i32 %33, 0, !dbg !289
  br i1 %cmp53, label %if.then55, label %if.end57, !dbg !288

if.then55:                                        ; preds = %if.end52
  %call56 = call arm_aapcscc i32 @normalize(i64* noundef %bSignificand) #4, !dbg !290
  store i32 %call56, i32* %bExponent, align 4, !dbg !291
  br label %if.end57, !dbg !292

if.end57:                                         ; preds = %if.then55, %if.end52
  %34 = load i64, i64* %aRep, align 8, !dbg !293
  %and58 = and i64 %34, -9223372036854775808, !dbg !294
  store i64 %and58, i64* %resultSign, align 8, !dbg !295
  %35 = load i64, i64* %aRep, align 8, !dbg !296
  %36 = load i64, i64* %bRep, align 8, !dbg !297
  %xor59 = xor i64 %35, %36, !dbg !298
  %and60 = and i64 %xor59, -9223372036854775808, !dbg !299
  %tobool61 = icmp ne i64 %and60, 0, !dbg !300
  %frombool = zext i1 %tobool61 to i8, !dbg !301
  store i8 %frombool, i8* %subtraction, align 1, !dbg !301
  %37 = load i64, i64* %aSignificand, align 8, !dbg !302
  %or62 = or i64 %37, 4503599627370496, !dbg !303
  %shl = shl i64 %or62, 3, !dbg !304
  store i64 %shl, i64* %aSignificand, align 8, !dbg !305
  %38 = load i64, i64* %bSignificand, align 8, !dbg !306
  %or63 = or i64 %38, 4503599627370496, !dbg !307
  %shl64 = shl i64 %or63, 3, !dbg !308
  store i64 %shl64, i64* %bSignificand, align 8, !dbg !309
  %39 = load i32, i32* %aExponent, align 4, !dbg !310
  %40 = load i32, i32* %bExponent, align 4, !dbg !311
  %sub65 = sub nsw i32 %39, %40, !dbg !312
  store i32 %sub65, i32* %align, align 4, !dbg !313
  %41 = load i32, i32* %align, align 4, !dbg !314
  %tobool66 = icmp ne i32 %41, 0, !dbg !314
  br i1 %tobool66, label %if.then67, label %if.end82, !dbg !314

if.then67:                                        ; preds = %if.end57
  %42 = load i32, i32* %align, align 4, !dbg !315
  %cmp68 = icmp ult i32 %42, 64, !dbg !316
  br i1 %cmp68, label %if.then70, label %if.else80, !dbg !315

if.then70:                                        ; preds = %if.then67
  %43 = load i64, i64* %bSignificand, align 8, !dbg !317
  %44 = load i32, i32* %align, align 4, !dbg !318
  %sub71 = sub i32 64, %44, !dbg !319
  %sh_prom = zext i32 %sub71 to i64, !dbg !320
  %shl72 = shl i64 %43, %sh_prom, !dbg !320
  %tobool73 = icmp ne i64 %shl72, 0, !dbg !317
  %frombool74 = zext i1 %tobool73 to i8, !dbg !321
  store i8 %frombool74, i8* %sticky, align 1, !dbg !321
  %45 = load i64, i64* %bSignificand, align 8, !dbg !322
  %46 = load i32, i32* %align, align 4, !dbg !323
  %sh_prom75 = zext i32 %46 to i64, !dbg !324
  %shr76 = lshr i64 %45, %sh_prom75, !dbg !324
  %47 = load i8, i8* %sticky, align 1, !dbg !325
  %tobool77 = trunc i8 %47 to i1, !dbg !325
  %conv78 = zext i1 %tobool77 to i64, !dbg !325
  %or79 = or i64 %shr76, %conv78, !dbg !326
  store i64 %or79, i64* %bSignificand, align 8, !dbg !327
  br label %if.end81, !dbg !328

if.else80:                                        ; preds = %if.then67
  store i64 1, i64* %bSignificand, align 8, !dbg !329
  br label %if.end81

if.end81:                                         ; preds = %if.else80, %if.then70
  br label %if.end82, !dbg !330

if.end82:                                         ; preds = %if.end81, %if.end57
  %48 = load i8, i8* %subtraction, align 1, !dbg !331
  %tobool83 = trunc i8 %48 to i1, !dbg !331
  br i1 %tobool83, label %if.then84, label %if.else101, !dbg !331

if.then84:                                        ; preds = %if.end82
  %49 = load i64, i64* %bSignificand, align 8, !dbg !332
  %50 = load i64, i64* %aSignificand, align 8, !dbg !333
  %sub85 = sub i64 %50, %49, !dbg !333
  store i64 %sub85, i64* %aSignificand, align 8, !dbg !333
  %51 = load i64, i64* %aSignificand, align 8, !dbg !334
  %cmp86 = icmp eq i64 %51, 0, !dbg !335
  br i1 %cmp86, label %if.then88, label %if.end90, !dbg !334

if.then88:                                        ; preds = %if.then84
  %call89 = call arm_aapcscc double @fromRep(i64 noundef 0) #4, !dbg !336
  store double %call89, double* %retval, align 8, !dbg !337
  br label %return, !dbg !337

if.end90:                                         ; preds = %if.then84
  %52 = load i64, i64* %aSignificand, align 8, !dbg !338
  %cmp91 = icmp ult i64 %52, 36028797018963968, !dbg !339
  br i1 %cmp91, label %if.then93, label %if.end100, !dbg !338

if.then93:                                        ; preds = %if.end90
  %53 = load i64, i64* %aSignificand, align 8, !dbg !340
  %call94 = call arm_aapcscc i32 @rep_clz(i64 noundef %53) #4, !dbg !341
  %call95 = call arm_aapcscc i32 @rep_clz(i64 noundef 36028797018963968) #4, !dbg !342
  %sub96 = sub nsw i32 %call94, %call95, !dbg !343
  store i32 %sub96, i32* %shift, align 4, !dbg !344
  %54 = load i32, i32* %shift, align 4, !dbg !345
  %55 = load i64, i64* %aSignificand, align 8, !dbg !346
  %sh_prom97 = zext i32 %54 to i64, !dbg !346
  %shl98 = shl i64 %55, %sh_prom97, !dbg !346
  store i64 %shl98, i64* %aSignificand, align 8, !dbg !346
  %56 = load i32, i32* %shift, align 4, !dbg !347
  %57 = load i32, i32* %aExponent, align 4, !dbg !348
  %sub99 = sub nsw i32 %57, %56, !dbg !348
  store i32 %sub99, i32* %aExponent, align 4, !dbg !348
  br label %if.end100, !dbg !349

if.end100:                                        ; preds = %if.then93, %if.end90
  br label %if.end115, !dbg !350

if.else101:                                       ; preds = %if.end82
  %58 = load i64, i64* %bSignificand, align 8, !dbg !351
  %59 = load i64, i64* %aSignificand, align 8, !dbg !352
  %add = add i64 %59, %58, !dbg !352
  store i64 %add, i64* %aSignificand, align 8, !dbg !352
  %60 = load i64, i64* %aSignificand, align 8, !dbg !353
  %and102 = and i64 %60, 72057594037927936, !dbg !354
  %tobool103 = icmp ne i64 %and102, 0, !dbg !354
  br i1 %tobool103, label %if.then104, label %if.end114, !dbg !353

if.then104:                                       ; preds = %if.else101
  %61 = load i64, i64* %aSignificand, align 8, !dbg !355
  %and106 = and i64 %61, 1, !dbg !356
  %tobool107 = icmp ne i64 %and106, 0, !dbg !355
  %frombool108 = zext i1 %tobool107 to i8, !dbg !357
  store i8 %frombool108, i8* %sticky105, align 1, !dbg !357
  %62 = load i64, i64* %aSignificand, align 8, !dbg !358
  %shr109 = lshr i64 %62, 1, !dbg !359
  %63 = load i8, i8* %sticky105, align 1, !dbg !360
  %tobool110 = trunc i8 %63 to i1, !dbg !360
  %conv111 = zext i1 %tobool110 to i64, !dbg !360
  %or112 = or i64 %shr109, %conv111, !dbg !361
  store i64 %or112, i64* %aSignificand, align 8, !dbg !362
  %64 = load i32, i32* %aExponent, align 4, !dbg !363
  %add113 = add nsw i32 %64, 1, !dbg !363
  store i32 %add113, i32* %aExponent, align 4, !dbg !363
  br label %if.end114, !dbg !364

if.end114:                                        ; preds = %if.then104, %if.else101
  br label %if.end115

if.end115:                                        ; preds = %if.end114, %if.end100
  %65 = load i32, i32* %aExponent, align 4, !dbg !365
  %cmp116 = icmp sge i32 %65, 2047, !dbg !366
  br i1 %cmp116, label %if.then118, label %if.end121, !dbg !365

if.then118:                                       ; preds = %if.end115
  %66 = load i64, i64* %resultSign, align 8, !dbg !367
  %or119 = or i64 9218868437227405312, %66, !dbg !368
  %call120 = call arm_aapcscc double @fromRep(i64 noundef %or119) #4, !dbg !369
  store double %call120, double* %retval, align 8, !dbg !370
  br label %return, !dbg !370

if.end121:                                        ; preds = %if.end115
  %67 = load i32, i32* %aExponent, align 4, !dbg !371
  %cmp122 = icmp sle i32 %67, 0, !dbg !372
  br i1 %cmp122, label %if.then124, label %if.end138, !dbg !371

if.then124:                                       ; preds = %if.end121
  %68 = load i32, i32* %aExponent, align 4, !dbg !373
  %sub126 = sub nsw i32 1, %68, !dbg !374
  store i32 %sub126, i32* %shift125, align 4, !dbg !375
  %69 = load i64, i64* %aSignificand, align 8, !dbg !376
  %70 = load i32, i32* %shift125, align 4, !dbg !377
  %sub128 = sub i32 64, %70, !dbg !378
  %sh_prom129 = zext i32 %sub128 to i64, !dbg !379
  %shl130 = shl i64 %69, %sh_prom129, !dbg !379
  %tobool131 = icmp ne i64 %shl130, 0, !dbg !376
  %frombool132 = zext i1 %tobool131 to i8, !dbg !380
  store i8 %frombool132, i8* %sticky127, align 1, !dbg !380
  %71 = load i64, i64* %aSignificand, align 8, !dbg !381
  %72 = load i32, i32* %shift125, align 4, !dbg !382
  %sh_prom133 = zext i32 %72 to i64, !dbg !383
  %shr134 = lshr i64 %71, %sh_prom133, !dbg !383
  %73 = load i8, i8* %sticky127, align 1, !dbg !384
  %tobool135 = trunc i8 %73 to i1, !dbg !384
  %conv136 = zext i1 %tobool135 to i64, !dbg !384
  %or137 = or i64 %shr134, %conv136, !dbg !385
  store i64 %or137, i64* %aSignificand, align 8, !dbg !386
  store i32 0, i32* %aExponent, align 4, !dbg !387
  br label %if.end138, !dbg !388

if.end138:                                        ; preds = %if.then124, %if.end121
  %74 = load i64, i64* %aSignificand, align 8, !dbg !389
  %and139 = and i64 %74, 7, !dbg !390
  %conv140 = trunc i64 %and139 to i32, !dbg !389
  store i32 %conv140, i32* %roundGuardSticky, align 4, !dbg !391
  %75 = load i64, i64* %aSignificand, align 8, !dbg !392
  %shr141 = lshr i64 %75, 3, !dbg !393
  %and142 = and i64 %shr141, 4503599627370495, !dbg !394
  store i64 %and142, i64* %result, align 8, !dbg !395
  %76 = load i32, i32* %aExponent, align 4, !dbg !396
  %conv143 = sext i32 %76 to i64, !dbg !397
  %shl144 = shl i64 %conv143, 52, !dbg !398
  %77 = load i64, i64* %result, align 8, !dbg !399
  %or145 = or i64 %77, %shl144, !dbg !399
  store i64 %or145, i64* %result, align 8, !dbg !399
  %78 = load i64, i64* %resultSign, align 8, !dbg !400
  %79 = load i64, i64* %result, align 8, !dbg !401
  %or146 = or i64 %79, %78, !dbg !401
  store i64 %or146, i64* %result, align 8, !dbg !401
  %80 = load i32, i32* %roundGuardSticky, align 4, !dbg !402
  %cmp147 = icmp sgt i32 %80, 4, !dbg !403
  br i1 %cmp147, label %if.then149, label %if.end150, !dbg !402

if.then149:                                       ; preds = %if.end138
  %81 = load i64, i64* %result, align 8, !dbg !404
  %inc = add i64 %81, 1, !dbg !404
  store i64 %inc, i64* %result, align 8, !dbg !404
  br label %if.end150, !dbg !405

if.end150:                                        ; preds = %if.then149, %if.end138
  %82 = load i32, i32* %roundGuardSticky, align 4, !dbg !406
  %cmp151 = icmp eq i32 %82, 4, !dbg !407
  br i1 %cmp151, label %if.then153, label %if.end156, !dbg !406

if.then153:                                       ; preds = %if.end150
  %83 = load i64, i64* %result, align 8, !dbg !408
  %and154 = and i64 %83, 1, !dbg !409
  %84 = load i64, i64* %result, align 8, !dbg !410
  %add155 = add i64 %84, %and154, !dbg !410
  store i64 %add155, i64* %result, align 8, !dbg !410
  br label %if.end156, !dbg !411

if.end156:                                        ; preds = %if.then153, %if.end150
  %85 = load i64, i64* %result, align 8, !dbg !412
  %call157 = call arm_aapcscc double @fromRep(i64 noundef %85) #4, !dbg !413
  store double %call157, double* %retval, align 8, !dbg !414
  br label %return, !dbg !414

return:                                           ; preds = %if.end156, %if.then118, %if.then88, %if.then36, %if.else33, %if.then28, %if.then24, %if.else, %if.then20, %if.then10, %if.then6
  %86 = load double, double* %retval, align 8, !dbg !415
  ret double %86, !dbg !415
}

; Function Attrs: noinline nounwind
define internal arm_aapcscc i64 @toRep(double noundef %x) #0 !dbg !416 {
entry:
  %x.addr = alloca double, align 8
  %rep = alloca %union.anon.0, align 8
  store double %x, double* %x.addr, align 8
  %f = bitcast %union.anon.0* %rep to double*, !dbg !418
  %0 = load double, double* %x.addr, align 8, !dbg !419
  store double %0, double* %f, align 8, !dbg !418
  %i = bitcast %union.anon.0* %rep to i64*, !dbg !420
  %1 = load i64, i64* %i, align 8, !dbg !420
  ret i64 %1, !dbg !421
}

; Function Attrs: noinline nounwind
define internal arm_aapcscc double @fromRep(i64 noundef %x) #0 !dbg !422 {
entry:
  %x.addr = alloca i64, align 8
  %rep = alloca %union.anon.0, align 8
  store i64 %x, i64* %x.addr, align 8
  %i = bitcast %union.anon.0* %rep to i64*, !dbg !423
  %0 = load i64, i64* %x.addr, align 8, !dbg !424
  store i64 %0, i64* %i, align 8, !dbg !423
  %f = bitcast %union.anon.0* %rep to double*, !dbg !425
  %1 = load double, double* %f, align 8, !dbg !425
  ret double %1, !dbg !426
}

; Function Attrs: noinline nounwind
define internal arm_aapcscc i32 @normalize(i64* noundef %significand) #0 !dbg !427 {
entry:
  %significand.addr = alloca i64*, align 4
  %shift = alloca i32, align 4
  store i64* %significand, i64** %significand.addr, align 4
  %0 = load i64*, i64** %significand.addr, align 4, !dbg !428
  %1 = load i64, i64* %0, align 8, !dbg !429
  %call = call arm_aapcscc i32 @rep_clz(i64 noundef %1) #4, !dbg !430
  %call1 = call arm_aapcscc i32 @rep_clz(i64 noundef 4503599627370496) #4, !dbg !431
  %sub = sub nsw i32 %call, %call1, !dbg !432
  store i32 %sub, i32* %shift, align 4, !dbg !433
  %2 = load i32, i32* %shift, align 4, !dbg !434
  %3 = load i64*, i64** %significand.addr, align 4, !dbg !435
  %4 = load i64, i64* %3, align 8, !dbg !436
  %sh_prom = zext i32 %2 to i64, !dbg !436
  %shl = shl i64 %4, %sh_prom, !dbg !436
  store i64 %shl, i64* %3, align 8, !dbg !436
  %5 = load i32, i32* %shift, align 4, !dbg !437
  %sub2 = sub nsw i32 1, %5, !dbg !438
  ret i32 %sub2, !dbg !439
}

; Function Attrs: noinline nounwind
define internal arm_aapcscc i32 @rep_clz(i64 noundef %a) #0 !dbg !440 {
entry:
  %retval = alloca i32, align 4
  %a.addr = alloca i64, align 8
  store i64 %a, i64* %a.addr, align 8
  %0 = load i64, i64* %a.addr, align 8, !dbg !441
  %and = and i64 %0, -4294967296, !dbg !442
  %tobool = icmp ne i64 %and, 0, !dbg !442
  br i1 %tobool, label %if.then, label %if.else, !dbg !441

if.then:                                          ; preds = %entry
  %1 = load i64, i64* %a.addr, align 8, !dbg !443
  %shr = lshr i64 %1, 32, !dbg !444
  %conv = trunc i64 %shr to i32, !dbg !443
  %2 = call i32 @llvm.ctlz.i32(i32 %conv, i1 false), !dbg !445
  store i32 %2, i32* %retval, align 4, !dbg !446
  br label %return, !dbg !446

if.else:                                          ; preds = %entry
  %3 = load i64, i64* %a.addr, align 8, !dbg !447
  %and1 = and i64 %3, 4294967295, !dbg !448
  %conv2 = trunc i64 %and1 to i32, !dbg !447
  %4 = call i32 @llvm.ctlz.i32(i32 %conv2, i1 false), !dbg !449
  %add = add nsw i32 32, %4, !dbg !450
  store i32 %add, i32* %retval, align 4, !dbg !451
  br label %return, !dbg !451

return:                                           ; preds = %if.else, %if.then
  %5 = load i32, i32* %retval, align 4, !dbg !452
  ret i32 %5, !dbg !452
}

; Function Attrs: nofree nosync nounwind readnone speculatable willreturn
declare i32 @llvm.ctlz.i32(i32, i1 immarg) #1

; Function Attrs: noinline nounwind
define dso_local arm_aapcscc float @__addsf3(float noundef %a, float noundef %b) #0 !dbg !453 {
entry:
  %a.addr = alloca float, align 4
  %b.addr = alloca float, align 4
  store float %a, float* %a.addr, align 4
  store float %b, float* %b.addr, align 4
  %0 = load float, float* %a.addr, align 4, !dbg !454
  %1 = load float, float* %b.addr, align 4, !dbg !455
  %call = call arm_aapcscc float @__addXf3__.1(float noundef %0, float noundef %1) #4, !dbg !456
  ret float %call, !dbg !457
}

; Function Attrs: noinline nounwind
define internal arm_aapcscc float @__addXf3__.1(float noundef %a, float noundef %b) #0 !dbg !458 {
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
  %0 = load float, float* %a.addr, align 4, !dbg !459
  %call = call arm_aapcscc i32 @toRep.2(float noundef %0) #4, !dbg !460
  store i32 %call, i32* %aRep, align 4, !dbg !461
  %1 = load float, float* %b.addr, align 4, !dbg !462
  %call1 = call arm_aapcscc i32 @toRep.2(float noundef %1) #4, !dbg !463
  store i32 %call1, i32* %bRep, align 4, !dbg !464
  %2 = load i32, i32* %aRep, align 4, !dbg !465
  %and = and i32 %2, 2147483647, !dbg !466
  store i32 %and, i32* %aAbs, align 4, !dbg !467
  %3 = load i32, i32* %bRep, align 4, !dbg !468
  %and2 = and i32 %3, 2147483647, !dbg !469
  store i32 %and2, i32* %bAbs, align 4, !dbg !470
  %4 = load i32, i32* %aAbs, align 4, !dbg !471
  %sub = sub i32 %4, 1, !dbg !472
  %cmp = icmp uge i32 %sub, 2139095039, !dbg !473
  br i1 %cmp, label %if.then, label %lor.lhs.false, !dbg !474

lor.lhs.false:                                    ; preds = %entry
  %5 = load i32, i32* %bAbs, align 4, !dbg !475
  %sub3 = sub i32 %5, 1, !dbg !476
  %cmp4 = icmp uge i32 %sub3, 2139095039, !dbg !477
  br i1 %cmp4, label %if.then, label %if.end38, !dbg !471

if.then:                                          ; preds = %lor.lhs.false, %entry
  %6 = load i32, i32* %aAbs, align 4, !dbg !478
  %cmp5 = icmp ugt i32 %6, 2139095040, !dbg !479
  br i1 %cmp5, label %if.then6, label %if.end, !dbg !478

if.then6:                                         ; preds = %if.then
  %7 = load float, float* %a.addr, align 4, !dbg !480
  %call7 = call arm_aapcscc i32 @toRep.2(float noundef %7) #4, !dbg !481
  %or = or i32 %call7, 4194304, !dbg !482
  %call8 = call arm_aapcscc float @fromRep.3(i32 noundef %or) #4, !dbg !483
  store float %call8, float* %retval, align 4, !dbg !484
  br label %return, !dbg !484

if.end:                                           ; preds = %if.then
  %8 = load i32, i32* %bAbs, align 4, !dbg !485
  %cmp9 = icmp ugt i32 %8, 2139095040, !dbg !486
  br i1 %cmp9, label %if.then10, label %if.end14, !dbg !485

if.then10:                                        ; preds = %if.end
  %9 = load float, float* %b.addr, align 4, !dbg !487
  %call11 = call arm_aapcscc i32 @toRep.2(float noundef %9) #4, !dbg !488
  %or12 = or i32 %call11, 4194304, !dbg !489
  %call13 = call arm_aapcscc float @fromRep.3(i32 noundef %or12) #4, !dbg !490
  store float %call13, float* %retval, align 4, !dbg !491
  br label %return, !dbg !491

if.end14:                                         ; preds = %if.end
  %10 = load i32, i32* %aAbs, align 4, !dbg !492
  %cmp15 = icmp eq i32 %10, 2139095040, !dbg !493
  br i1 %cmp15, label %if.then16, label %if.end22, !dbg !492

if.then16:                                        ; preds = %if.end14
  %11 = load float, float* %a.addr, align 4, !dbg !494
  %call17 = call arm_aapcscc i32 @toRep.2(float noundef %11) #4, !dbg !495
  %12 = load float, float* %b.addr, align 4, !dbg !496
  %call18 = call arm_aapcscc i32 @toRep.2(float noundef %12) #4, !dbg !497
  %xor = xor i32 %call17, %call18, !dbg !498
  %cmp19 = icmp eq i32 %xor, -2147483648, !dbg !499
  br i1 %cmp19, label %if.then20, label %if.else, !dbg !500

if.then20:                                        ; preds = %if.then16
  %call21 = call arm_aapcscc float @fromRep.3(i32 noundef 2143289344) #4, !dbg !501
  store float %call21, float* %retval, align 4, !dbg !502
  br label %return, !dbg !502

if.else:                                          ; preds = %if.then16
  %13 = load float, float* %a.addr, align 4, !dbg !503
  store float %13, float* %retval, align 4, !dbg !504
  br label %return, !dbg !504

if.end22:                                         ; preds = %if.end14
  %14 = load i32, i32* %bAbs, align 4, !dbg !505
  %cmp23 = icmp eq i32 %14, 2139095040, !dbg !506
  br i1 %cmp23, label %if.then24, label %if.end25, !dbg !505

if.then24:                                        ; preds = %if.end22
  %15 = load float, float* %b.addr, align 4, !dbg !507
  store float %15, float* %retval, align 4, !dbg !508
  br label %return, !dbg !508

if.end25:                                         ; preds = %if.end22
  %16 = load i32, i32* %aAbs, align 4, !dbg !509
  %tobool = icmp ne i32 %16, 0, !dbg !509
  br i1 %tobool, label %if.end34, label %if.then26, !dbg !510

if.then26:                                        ; preds = %if.end25
  %17 = load i32, i32* %bAbs, align 4, !dbg !511
  %tobool27 = icmp ne i32 %17, 0, !dbg !511
  br i1 %tobool27, label %if.else33, label %if.then28, !dbg !512

if.then28:                                        ; preds = %if.then26
  %18 = load float, float* %a.addr, align 4, !dbg !513
  %call29 = call arm_aapcscc i32 @toRep.2(float noundef %18) #4, !dbg !514
  %19 = load float, float* %b.addr, align 4, !dbg !515
  %call30 = call arm_aapcscc i32 @toRep.2(float noundef %19) #4, !dbg !516
  %and31 = and i32 %call29, %call30, !dbg !517
  %call32 = call arm_aapcscc float @fromRep.3(i32 noundef %and31) #4, !dbg !518
  store float %call32, float* %retval, align 4, !dbg !519
  br label %return, !dbg !519

if.else33:                                        ; preds = %if.then26
  %20 = load float, float* %b.addr, align 4, !dbg !520
  store float %20, float* %retval, align 4, !dbg !521
  br label %return, !dbg !521

if.end34:                                         ; preds = %if.end25
  %21 = load i32, i32* %bAbs, align 4, !dbg !522
  %tobool35 = icmp ne i32 %21, 0, !dbg !522
  br i1 %tobool35, label %if.end37, label %if.then36, !dbg !523

if.then36:                                        ; preds = %if.end34
  %22 = load float, float* %a.addr, align 4, !dbg !524
  store float %22, float* %retval, align 4, !dbg !525
  br label %return, !dbg !525

if.end37:                                         ; preds = %if.end34
  br label %if.end38, !dbg !526

if.end38:                                         ; preds = %if.end37, %lor.lhs.false
  %23 = load i32, i32* %bAbs, align 4, !dbg !527
  %24 = load i32, i32* %aAbs, align 4, !dbg !528
  %cmp39 = icmp ugt i32 %23, %24, !dbg !529
  br i1 %cmp39, label %if.then40, label %if.end41, !dbg !527

if.then40:                                        ; preds = %if.end38
  %25 = load i32, i32* %aRep, align 4, !dbg !530
  store i32 %25, i32* %temp, align 4, !dbg !531
  %26 = load i32, i32* %bRep, align 4, !dbg !532
  store i32 %26, i32* %aRep, align 4, !dbg !533
  %27 = load i32, i32* %temp, align 4, !dbg !534
  store i32 %27, i32* %bRep, align 4, !dbg !535
  br label %if.end41, !dbg !536

if.end41:                                         ; preds = %if.then40, %if.end38
  %28 = load i32, i32* %aRep, align 4, !dbg !537
  %shr = lshr i32 %28, 23, !dbg !538
  %and42 = and i32 %shr, 255, !dbg !539
  store i32 %and42, i32* %aExponent, align 4, !dbg !540
  %29 = load i32, i32* %bRep, align 4, !dbg !541
  %shr43 = lshr i32 %29, 23, !dbg !542
  %and44 = and i32 %shr43, 255, !dbg !543
  store i32 %and44, i32* %bExponent, align 4, !dbg !544
  %30 = load i32, i32* %aRep, align 4, !dbg !545
  %and45 = and i32 %30, 8388607, !dbg !546
  store i32 %and45, i32* %aSignificand, align 4, !dbg !547
  %31 = load i32, i32* %bRep, align 4, !dbg !548
  %and46 = and i32 %31, 8388607, !dbg !549
  store i32 %and46, i32* %bSignificand, align 4, !dbg !550
  %32 = load i32, i32* %aExponent, align 4, !dbg !551
  %cmp47 = icmp eq i32 %32, 0, !dbg !552
  br i1 %cmp47, label %if.then48, label %if.end50, !dbg !551

if.then48:                                        ; preds = %if.end41
  %call49 = call arm_aapcscc i32 @normalize.4(i32* noundef %aSignificand) #4, !dbg !553
  store i32 %call49, i32* %aExponent, align 4, !dbg !554
  br label %if.end50, !dbg !555

if.end50:                                         ; preds = %if.then48, %if.end41
  %33 = load i32, i32* %bExponent, align 4, !dbg !556
  %cmp51 = icmp eq i32 %33, 0, !dbg !557
  br i1 %cmp51, label %if.then52, label %if.end54, !dbg !556

if.then52:                                        ; preds = %if.end50
  %call53 = call arm_aapcscc i32 @normalize.4(i32* noundef %bSignificand) #4, !dbg !558
  store i32 %call53, i32* %bExponent, align 4, !dbg !559
  br label %if.end54, !dbg !560

if.end54:                                         ; preds = %if.then52, %if.end50
  %34 = load i32, i32* %aRep, align 4, !dbg !561
  %and55 = and i32 %34, -2147483648, !dbg !562
  store i32 %and55, i32* %resultSign, align 4, !dbg !563
  %35 = load i32, i32* %aRep, align 4, !dbg !564
  %36 = load i32, i32* %bRep, align 4, !dbg !565
  %xor56 = xor i32 %35, %36, !dbg !566
  %and57 = and i32 %xor56, -2147483648, !dbg !567
  %tobool58 = icmp ne i32 %and57, 0, !dbg !568
  %frombool = zext i1 %tobool58 to i8, !dbg !569
  store i8 %frombool, i8* %subtraction, align 1, !dbg !569
  %37 = load i32, i32* %aSignificand, align 4, !dbg !570
  %or59 = or i32 %37, 8388608, !dbg !571
  %shl = shl i32 %or59, 3, !dbg !572
  store i32 %shl, i32* %aSignificand, align 4, !dbg !573
  %38 = load i32, i32* %bSignificand, align 4, !dbg !574
  %or60 = or i32 %38, 8388608, !dbg !575
  %shl61 = shl i32 %or60, 3, !dbg !576
  store i32 %shl61, i32* %bSignificand, align 4, !dbg !577
  %39 = load i32, i32* %aExponent, align 4, !dbg !578
  %40 = load i32, i32* %bExponent, align 4, !dbg !579
  %sub62 = sub nsw i32 %39, %40, !dbg !580
  store i32 %sub62, i32* %align, align 4, !dbg !581
  %41 = load i32, i32* %align, align 4, !dbg !582
  %tobool63 = icmp ne i32 %41, 0, !dbg !582
  br i1 %tobool63, label %if.then64, label %if.end76, !dbg !582

if.then64:                                        ; preds = %if.end54
  %42 = load i32, i32* %align, align 4, !dbg !583
  %cmp65 = icmp ult i32 %42, 32, !dbg !584
  br i1 %cmp65, label %if.then66, label %if.else74, !dbg !583

if.then66:                                        ; preds = %if.then64
  %43 = load i32, i32* %bSignificand, align 4, !dbg !585
  %44 = load i32, i32* %align, align 4, !dbg !586
  %sub67 = sub i32 32, %44, !dbg !587
  %shl68 = shl i32 %43, %sub67, !dbg !588
  %tobool69 = icmp ne i32 %shl68, 0, !dbg !585
  %frombool70 = zext i1 %tobool69 to i8, !dbg !589
  store i8 %frombool70, i8* %sticky, align 1, !dbg !589
  %45 = load i32, i32* %bSignificand, align 4, !dbg !590
  %46 = load i32, i32* %align, align 4, !dbg !591
  %shr71 = lshr i32 %45, %46, !dbg !592
  %47 = load i8, i8* %sticky, align 1, !dbg !593
  %tobool72 = trunc i8 %47 to i1, !dbg !593
  %conv = zext i1 %tobool72 to i32, !dbg !593
  %or73 = or i32 %shr71, %conv, !dbg !594
  store i32 %or73, i32* %bSignificand, align 4, !dbg !595
  br label %if.end75, !dbg !596

if.else74:                                        ; preds = %if.then64
  store i32 1, i32* %bSignificand, align 4, !dbg !597
  br label %if.end75

if.end75:                                         ; preds = %if.else74, %if.then66
  br label %if.end76, !dbg !598

if.end76:                                         ; preds = %if.end75, %if.end54
  %48 = load i8, i8* %subtraction, align 1, !dbg !599
  %tobool77 = trunc i8 %48 to i1, !dbg !599
  br i1 %tobool77, label %if.then78, label %if.else94, !dbg !599

if.then78:                                        ; preds = %if.end76
  %49 = load i32, i32* %bSignificand, align 4, !dbg !600
  %50 = load i32, i32* %aSignificand, align 4, !dbg !601
  %sub79 = sub i32 %50, %49, !dbg !601
  store i32 %sub79, i32* %aSignificand, align 4, !dbg !601
  %51 = load i32, i32* %aSignificand, align 4, !dbg !602
  %cmp80 = icmp eq i32 %51, 0, !dbg !603
  br i1 %cmp80, label %if.then82, label %if.end84, !dbg !602

if.then82:                                        ; preds = %if.then78
  %call83 = call arm_aapcscc float @fromRep.3(i32 noundef 0) #4, !dbg !604
  store float %call83, float* %retval, align 4, !dbg !605
  br label %return, !dbg !605

if.end84:                                         ; preds = %if.then78
  %52 = load i32, i32* %aSignificand, align 4, !dbg !606
  %cmp85 = icmp ult i32 %52, 67108864, !dbg !607
  br i1 %cmp85, label %if.then87, label %if.end93, !dbg !606

if.then87:                                        ; preds = %if.end84
  %53 = load i32, i32* %aSignificand, align 4, !dbg !608
  %call88 = call arm_aapcscc i32 @rep_clz.5(i32 noundef %53) #4, !dbg !609
  %call89 = call arm_aapcscc i32 @rep_clz.5(i32 noundef 67108864) #4, !dbg !610
  %sub90 = sub nsw i32 %call88, %call89, !dbg !611
  store i32 %sub90, i32* %shift, align 4, !dbg !612
  %54 = load i32, i32* %shift, align 4, !dbg !613
  %55 = load i32, i32* %aSignificand, align 4, !dbg !614
  %shl91 = shl i32 %55, %54, !dbg !614
  store i32 %shl91, i32* %aSignificand, align 4, !dbg !614
  %56 = load i32, i32* %shift, align 4, !dbg !615
  %57 = load i32, i32* %aExponent, align 4, !dbg !616
  %sub92 = sub nsw i32 %57, %56, !dbg !616
  store i32 %sub92, i32* %aExponent, align 4, !dbg !616
  br label %if.end93, !dbg !617

if.end93:                                         ; preds = %if.then87, %if.end84
  br label %if.end108, !dbg !618

if.else94:                                        ; preds = %if.end76
  %58 = load i32, i32* %bSignificand, align 4, !dbg !619
  %59 = load i32, i32* %aSignificand, align 4, !dbg !620
  %add = add i32 %59, %58, !dbg !620
  store i32 %add, i32* %aSignificand, align 4, !dbg !620
  %60 = load i32, i32* %aSignificand, align 4, !dbg !621
  %and95 = and i32 %60, 134217728, !dbg !622
  %tobool96 = icmp ne i32 %and95, 0, !dbg !622
  br i1 %tobool96, label %if.then97, label %if.end107, !dbg !621

if.then97:                                        ; preds = %if.else94
  %61 = load i32, i32* %aSignificand, align 4, !dbg !623
  %and99 = and i32 %61, 1, !dbg !624
  %tobool100 = icmp ne i32 %and99, 0, !dbg !623
  %frombool101 = zext i1 %tobool100 to i8, !dbg !625
  store i8 %frombool101, i8* %sticky98, align 1, !dbg !625
  %62 = load i32, i32* %aSignificand, align 4, !dbg !626
  %shr102 = lshr i32 %62, 1, !dbg !627
  %63 = load i8, i8* %sticky98, align 1, !dbg !628
  %tobool103 = trunc i8 %63 to i1, !dbg !628
  %conv104 = zext i1 %tobool103 to i32, !dbg !628
  %or105 = or i32 %shr102, %conv104, !dbg !629
  store i32 %or105, i32* %aSignificand, align 4, !dbg !630
  %64 = load i32, i32* %aExponent, align 4, !dbg !631
  %add106 = add nsw i32 %64, 1, !dbg !631
  store i32 %add106, i32* %aExponent, align 4, !dbg !631
  br label %if.end107, !dbg !632

if.end107:                                        ; preds = %if.then97, %if.else94
  br label %if.end108

if.end108:                                        ; preds = %if.end107, %if.end93
  %65 = load i32, i32* %aExponent, align 4, !dbg !633
  %cmp109 = icmp sge i32 %65, 255, !dbg !634
  br i1 %cmp109, label %if.then111, label %if.end114, !dbg !633

if.then111:                                       ; preds = %if.end108
  %66 = load i32, i32* %resultSign, align 4, !dbg !635
  %or112 = or i32 2139095040, %66, !dbg !636
  %call113 = call arm_aapcscc float @fromRep.3(i32 noundef %or112) #4, !dbg !637
  store float %call113, float* %retval, align 4, !dbg !638
  br label %return, !dbg !638

if.end114:                                        ; preds = %if.end108
  %67 = load i32, i32* %aExponent, align 4, !dbg !639
  %cmp115 = icmp sle i32 %67, 0, !dbg !640
  br i1 %cmp115, label %if.then117, label %if.end129, !dbg !639

if.then117:                                       ; preds = %if.end114
  %68 = load i32, i32* %aExponent, align 4, !dbg !641
  %sub119 = sub nsw i32 1, %68, !dbg !642
  store i32 %sub119, i32* %shift118, align 4, !dbg !643
  %69 = load i32, i32* %aSignificand, align 4, !dbg !644
  %70 = load i32, i32* %shift118, align 4, !dbg !645
  %sub121 = sub i32 32, %70, !dbg !646
  %shl122 = shl i32 %69, %sub121, !dbg !647
  %tobool123 = icmp ne i32 %shl122, 0, !dbg !644
  %frombool124 = zext i1 %tobool123 to i8, !dbg !648
  store i8 %frombool124, i8* %sticky120, align 1, !dbg !648
  %71 = load i32, i32* %aSignificand, align 4, !dbg !649
  %72 = load i32, i32* %shift118, align 4, !dbg !650
  %shr125 = lshr i32 %71, %72, !dbg !651
  %73 = load i8, i8* %sticky120, align 1, !dbg !652
  %tobool126 = trunc i8 %73 to i1, !dbg !652
  %conv127 = zext i1 %tobool126 to i32, !dbg !652
  %or128 = or i32 %shr125, %conv127, !dbg !653
  store i32 %or128, i32* %aSignificand, align 4, !dbg !654
  store i32 0, i32* %aExponent, align 4, !dbg !655
  br label %if.end129, !dbg !656

if.end129:                                        ; preds = %if.then117, %if.end114
  %74 = load i32, i32* %aSignificand, align 4, !dbg !657
  %and130 = and i32 %74, 7, !dbg !658
  store i32 %and130, i32* %roundGuardSticky, align 4, !dbg !659
  %75 = load i32, i32* %aSignificand, align 4, !dbg !660
  %shr131 = lshr i32 %75, 3, !dbg !661
  %and132 = and i32 %shr131, 8388607, !dbg !662
  store i32 %and132, i32* %result, align 4, !dbg !663
  %76 = load i32, i32* %aExponent, align 4, !dbg !664
  %shl133 = shl i32 %76, 23, !dbg !665
  %77 = load i32, i32* %result, align 4, !dbg !666
  %or134 = or i32 %77, %shl133, !dbg !666
  store i32 %or134, i32* %result, align 4, !dbg !666
  %78 = load i32, i32* %resultSign, align 4, !dbg !667
  %79 = load i32, i32* %result, align 4, !dbg !668
  %or135 = or i32 %79, %78, !dbg !668
  store i32 %or135, i32* %result, align 4, !dbg !668
  %80 = load i32, i32* %roundGuardSticky, align 4, !dbg !669
  %cmp136 = icmp sgt i32 %80, 4, !dbg !670
  br i1 %cmp136, label %if.then138, label %if.end139, !dbg !669

if.then138:                                       ; preds = %if.end129
  %81 = load i32, i32* %result, align 4, !dbg !671
  %inc = add i32 %81, 1, !dbg !671
  store i32 %inc, i32* %result, align 4, !dbg !671
  br label %if.end139, !dbg !672

if.end139:                                        ; preds = %if.then138, %if.end129
  %82 = load i32, i32* %roundGuardSticky, align 4, !dbg !673
  %cmp140 = icmp eq i32 %82, 4, !dbg !674
  br i1 %cmp140, label %if.then142, label %if.end145, !dbg !673

if.then142:                                       ; preds = %if.end139
  %83 = load i32, i32* %result, align 4, !dbg !675
  %and143 = and i32 %83, 1, !dbg !676
  %84 = load i32, i32* %result, align 4, !dbg !677
  %add144 = add i32 %84, %and143, !dbg !677
  store i32 %add144, i32* %result, align 4, !dbg !677
  br label %if.end145, !dbg !678

if.end145:                                        ; preds = %if.then142, %if.end139
  %85 = load i32, i32* %result, align 4, !dbg !679
  %call146 = call arm_aapcscc float @fromRep.3(i32 noundef %85) #4, !dbg !680
  store float %call146, float* %retval, align 4, !dbg !681
  br label %return, !dbg !681

return:                                           ; preds = %if.end145, %if.then111, %if.then82, %if.then36, %if.else33, %if.then28, %if.then24, %if.else, %if.then20, %if.then10, %if.then6
  %86 = load float, float* %retval, align 4, !dbg !682
  ret float %86, !dbg !682
}

; Function Attrs: noinline nounwind
define internal arm_aapcscc i32 @toRep.2(float noundef %x) #0 !dbg !683 {
entry:
  %x.addr = alloca float, align 4
  %rep = alloca %union.anon.0.0, align 4
  store float %x, float* %x.addr, align 4
  %f = bitcast %union.anon.0.0* %rep to float*, !dbg !684
  %0 = load float, float* %x.addr, align 4, !dbg !685
  store float %0, float* %f, align 4, !dbg !684
  %i = bitcast %union.anon.0.0* %rep to i32*, !dbg !686
  %1 = load i32, i32* %i, align 4, !dbg !686
  ret i32 %1, !dbg !687
}

; Function Attrs: noinline nounwind
define internal arm_aapcscc float @fromRep.3(i32 noundef %x) #0 !dbg !688 {
entry:
  %x.addr = alloca i32, align 4
  %rep = alloca %union.anon.0.0, align 4
  store i32 %x, i32* %x.addr, align 4
  %i = bitcast %union.anon.0.0* %rep to i32*, !dbg !689
  %0 = load i32, i32* %x.addr, align 4, !dbg !690
  store i32 %0, i32* %i, align 4, !dbg !689
  %f = bitcast %union.anon.0.0* %rep to float*, !dbg !691
  %1 = load float, float* %f, align 4, !dbg !691
  ret float %1, !dbg !692
}

; Function Attrs: noinline nounwind
define internal arm_aapcscc i32 @normalize.4(i32* noundef %significand) #0 !dbg !693 {
entry:
  %significand.addr = alloca i32*, align 4
  %shift = alloca i32, align 4
  store i32* %significand, i32** %significand.addr, align 4
  %0 = load i32*, i32** %significand.addr, align 4, !dbg !694
  %1 = load i32, i32* %0, align 4, !dbg !695
  %call = call arm_aapcscc i32 @rep_clz.5(i32 noundef %1) #4, !dbg !696
  %call1 = call arm_aapcscc i32 @rep_clz.5(i32 noundef 8388608) #4, !dbg !697
  %sub = sub nsw i32 %call, %call1, !dbg !698
  store i32 %sub, i32* %shift, align 4, !dbg !699
  %2 = load i32, i32* %shift, align 4, !dbg !700
  %3 = load i32*, i32** %significand.addr, align 4, !dbg !701
  %4 = load i32, i32* %3, align 4, !dbg !702
  %shl = shl i32 %4, %2, !dbg !702
  store i32 %shl, i32* %3, align 4, !dbg !702
  %5 = load i32, i32* %shift, align 4, !dbg !703
  %sub2 = sub nsw i32 1, %5, !dbg !704
  ret i32 %sub2, !dbg !705
}

; Function Attrs: noinline nounwind
define internal arm_aapcscc i32 @rep_clz.5(i32 noundef %a) #0 !dbg !706 {
entry:
  %a.addr = alloca i32, align 4
  store i32 %a, i32* %a.addr, align 4
  %0 = load i32, i32* %a.addr, align 4, !dbg !707
  %1 = call i32 @llvm.ctlz.i32(i32 %0, i1 false), !dbg !708
  ret i32 %1, !dbg !709
}

; Function Attrs: noinline nounwind
define dso_local arm_aapcscc i32 @__ledf2(double noundef %a, double noundef %b) #0 !dbg !710 {
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
  %0 = load double, double* %a.addr, align 8, !dbg !711
  %call = call arm_aapcscc i64 @toRep.6(double noundef %0) #4, !dbg !712
  store i64 %call, i64* %aInt, align 8, !dbg !713
  %1 = load double, double* %b.addr, align 8, !dbg !714
  %call1 = call arm_aapcscc i64 @toRep.6(double noundef %1) #4, !dbg !715
  store i64 %call1, i64* %bInt, align 8, !dbg !716
  %2 = load i64, i64* %aInt, align 8, !dbg !717
  %and = and i64 %2, 9223372036854775807, !dbg !718
  store i64 %and, i64* %aAbs, align 8, !dbg !719
  %3 = load i64, i64* %bInt, align 8, !dbg !720
  %and2 = and i64 %3, 9223372036854775807, !dbg !721
  store i64 %and2, i64* %bAbs, align 8, !dbg !722
  %4 = load i64, i64* %aAbs, align 8, !dbg !723
  %cmp = icmp ugt i64 %4, 9218868437227405312, !dbg !724
  br i1 %cmp, label %if.then, label %lor.lhs.false, !dbg !725

lor.lhs.false:                                    ; preds = %entry
  %5 = load i64, i64* %bAbs, align 8, !dbg !726
  %cmp3 = icmp ugt i64 %5, 9218868437227405312, !dbg !727
  br i1 %cmp3, label %if.then, label %if.end, !dbg !723

if.then:                                          ; preds = %lor.lhs.false, %entry
  store i32 1, i32* %retval, align 4, !dbg !728
  br label %return, !dbg !728

if.end:                                           ; preds = %lor.lhs.false
  %6 = load i64, i64* %aAbs, align 8, !dbg !729
  %7 = load i64, i64* %bAbs, align 8, !dbg !730
  %or = or i64 %6, %7, !dbg !731
  %cmp4 = icmp eq i64 %or, 0, !dbg !732
  br i1 %cmp4, label %if.then5, label %if.end6, !dbg !733

if.then5:                                         ; preds = %if.end
  store i32 0, i32* %retval, align 4, !dbg !734
  br label %return, !dbg !734

if.end6:                                          ; preds = %if.end
  %8 = load i64, i64* %aInt, align 8, !dbg !735
  %9 = load i64, i64* %bInt, align 8, !dbg !736
  %and7 = and i64 %8, %9, !dbg !737
  %cmp8 = icmp sge i64 %and7, 0, !dbg !738
  br i1 %cmp8, label %if.then9, label %if.else15, !dbg !739

if.then9:                                         ; preds = %if.end6
  %10 = load i64, i64* %aInt, align 8, !dbg !740
  %11 = load i64, i64* %bInt, align 8, !dbg !741
  %cmp10 = icmp slt i64 %10, %11, !dbg !742
  br i1 %cmp10, label %if.then11, label %if.else, !dbg !740

if.then11:                                        ; preds = %if.then9
  store i32 -1, i32* %retval, align 4, !dbg !743
  br label %return, !dbg !743

if.else:                                          ; preds = %if.then9
  %12 = load i64, i64* %aInt, align 8, !dbg !744
  %13 = load i64, i64* %bInt, align 8, !dbg !745
  %cmp12 = icmp eq i64 %12, %13, !dbg !746
  br i1 %cmp12, label %if.then13, label %if.else14, !dbg !744

if.then13:                                        ; preds = %if.else
  store i32 0, i32* %retval, align 4, !dbg !747
  br label %return, !dbg !747

if.else14:                                        ; preds = %if.else
  store i32 1, i32* %retval, align 4, !dbg !748
  br label %return, !dbg !748

if.else15:                                        ; preds = %if.end6
  %14 = load i64, i64* %aInt, align 8, !dbg !749
  %15 = load i64, i64* %bInt, align 8, !dbg !750
  %cmp16 = icmp sgt i64 %14, %15, !dbg !751
  br i1 %cmp16, label %if.then17, label %if.else18, !dbg !749

if.then17:                                        ; preds = %if.else15
  store i32 -1, i32* %retval, align 4, !dbg !752
  br label %return, !dbg !752

if.else18:                                        ; preds = %if.else15
  %16 = load i64, i64* %aInt, align 8, !dbg !753
  %17 = load i64, i64* %bInt, align 8, !dbg !754
  %cmp19 = icmp eq i64 %16, %17, !dbg !755
  br i1 %cmp19, label %if.then20, label %if.else21, !dbg !753

if.then20:                                        ; preds = %if.else18
  store i32 0, i32* %retval, align 4, !dbg !756
  br label %return, !dbg !756

if.else21:                                        ; preds = %if.else18
  store i32 1, i32* %retval, align 4, !dbg !757
  br label %return, !dbg !757

return:                                           ; preds = %if.else21, %if.then20, %if.then17, %if.else14, %if.then13, %if.then11, %if.then5, %if.then
  %18 = load i32, i32* %retval, align 4, !dbg !758
  ret i32 %18, !dbg !758
}

; Function Attrs: noinline nounwind
define internal arm_aapcscc i64 @toRep.6(double noundef %x) #0 !dbg !759 {
entry:
  %x.addr = alloca double, align 8
  %rep = alloca %union.anon.0, align 8
  store double %x, double* %x.addr, align 8
  %f = bitcast %union.anon.0* %rep to double*, !dbg !760
  %0 = load double, double* %x.addr, align 8, !dbg !761
  store double %0, double* %f, align 8, !dbg !760
  %i = bitcast %union.anon.0* %rep to i64*, !dbg !762
  %1 = load i64, i64* %i, align 8, !dbg !762
  ret i64 %1, !dbg !763
}

; Function Attrs: noinline nounwind
define dso_local arm_aapcscc i32 @__gedf2(double noundef %a, double noundef %b) #0 !dbg !764 {
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
  %0 = load double, double* %a.addr, align 8, !dbg !765
  %call = call arm_aapcscc i64 @toRep.6(double noundef %0) #4, !dbg !766
  store i64 %call, i64* %aInt, align 8, !dbg !767
  %1 = load double, double* %b.addr, align 8, !dbg !768
  %call1 = call arm_aapcscc i64 @toRep.6(double noundef %1) #4, !dbg !769
  store i64 %call1, i64* %bInt, align 8, !dbg !770
  %2 = load i64, i64* %aInt, align 8, !dbg !771
  %and = and i64 %2, 9223372036854775807, !dbg !772
  store i64 %and, i64* %aAbs, align 8, !dbg !773
  %3 = load i64, i64* %bInt, align 8, !dbg !774
  %and2 = and i64 %3, 9223372036854775807, !dbg !775
  store i64 %and2, i64* %bAbs, align 8, !dbg !776
  %4 = load i64, i64* %aAbs, align 8, !dbg !777
  %cmp = icmp ugt i64 %4, 9218868437227405312, !dbg !778
  br i1 %cmp, label %if.then, label %lor.lhs.false, !dbg !779

lor.lhs.false:                                    ; preds = %entry
  %5 = load i64, i64* %bAbs, align 8, !dbg !780
  %cmp3 = icmp ugt i64 %5, 9218868437227405312, !dbg !781
  br i1 %cmp3, label %if.then, label %if.end, !dbg !777

if.then:                                          ; preds = %lor.lhs.false, %entry
  store i32 -1, i32* %retval, align 4, !dbg !782
  br label %return, !dbg !782

if.end:                                           ; preds = %lor.lhs.false
  %6 = load i64, i64* %aAbs, align 8, !dbg !783
  %7 = load i64, i64* %bAbs, align 8, !dbg !784
  %or = or i64 %6, %7, !dbg !785
  %cmp4 = icmp eq i64 %or, 0, !dbg !786
  br i1 %cmp4, label %if.then5, label %if.end6, !dbg !787

if.then5:                                         ; preds = %if.end
  store i32 0, i32* %retval, align 4, !dbg !788
  br label %return, !dbg !788

if.end6:                                          ; preds = %if.end
  %8 = load i64, i64* %aInt, align 8, !dbg !789
  %9 = load i64, i64* %bInt, align 8, !dbg !790
  %and7 = and i64 %8, %9, !dbg !791
  %cmp8 = icmp sge i64 %and7, 0, !dbg !792
  br i1 %cmp8, label %if.then9, label %if.else15, !dbg !793

if.then9:                                         ; preds = %if.end6
  %10 = load i64, i64* %aInt, align 8, !dbg !794
  %11 = load i64, i64* %bInt, align 8, !dbg !795
  %cmp10 = icmp slt i64 %10, %11, !dbg !796
  br i1 %cmp10, label %if.then11, label %if.else, !dbg !794

if.then11:                                        ; preds = %if.then9
  store i32 -1, i32* %retval, align 4, !dbg !797
  br label %return, !dbg !797

if.else:                                          ; preds = %if.then9
  %12 = load i64, i64* %aInt, align 8, !dbg !798
  %13 = load i64, i64* %bInt, align 8, !dbg !799
  %cmp12 = icmp eq i64 %12, %13, !dbg !800
  br i1 %cmp12, label %if.then13, label %if.else14, !dbg !798

if.then13:                                        ; preds = %if.else
  store i32 0, i32* %retval, align 4, !dbg !801
  br label %return, !dbg !801

if.else14:                                        ; preds = %if.else
  store i32 1, i32* %retval, align 4, !dbg !802
  br label %return, !dbg !802

if.else15:                                        ; preds = %if.end6
  %14 = load i64, i64* %aInt, align 8, !dbg !803
  %15 = load i64, i64* %bInt, align 8, !dbg !804
  %cmp16 = icmp sgt i64 %14, %15, !dbg !805
  br i1 %cmp16, label %if.then17, label %if.else18, !dbg !803

if.then17:                                        ; preds = %if.else15
  store i32 -1, i32* %retval, align 4, !dbg !806
  br label %return, !dbg !806

if.else18:                                        ; preds = %if.else15
  %16 = load i64, i64* %aInt, align 8, !dbg !807
  %17 = load i64, i64* %bInt, align 8, !dbg !808
  %cmp19 = icmp eq i64 %16, %17, !dbg !809
  br i1 %cmp19, label %if.then20, label %if.else21, !dbg !807

if.then20:                                        ; preds = %if.else18
  store i32 0, i32* %retval, align 4, !dbg !810
  br label %return, !dbg !810

if.else21:                                        ; preds = %if.else18
  store i32 1, i32* %retval, align 4, !dbg !811
  br label %return, !dbg !811

return:                                           ; preds = %if.else21, %if.then20, %if.then17, %if.else14, %if.then13, %if.then11, %if.then5, %if.then
  %18 = load i32, i32* %retval, align 4, !dbg !812
  ret i32 %18, !dbg !812
}

; Function Attrs: noinline nounwind
define dso_local arm_aapcscc i32 @__unorddf2(double noundef %a, double noundef %b) #0 !dbg !813 {
entry:
  %a.addr = alloca double, align 8
  %b.addr = alloca double, align 8
  %aAbs = alloca i64, align 8
  %bAbs = alloca i64, align 8
  store double %a, double* %a.addr, align 8
  store double %b, double* %b.addr, align 8
  %0 = load double, double* %a.addr, align 8, !dbg !814
  %call = call arm_aapcscc i64 @toRep.6(double noundef %0) #4, !dbg !815
  %and = and i64 %call, 9223372036854775807, !dbg !816
  store i64 %and, i64* %aAbs, align 8, !dbg !817
  %1 = load double, double* %b.addr, align 8, !dbg !818
  %call1 = call arm_aapcscc i64 @toRep.6(double noundef %1) #4, !dbg !819
  %and2 = and i64 %call1, 9223372036854775807, !dbg !820
  store i64 %and2, i64* %bAbs, align 8, !dbg !821
  %2 = load i64, i64* %aAbs, align 8, !dbg !822
  %cmp = icmp ugt i64 %2, 9218868437227405312, !dbg !823
  br i1 %cmp, label %lor.end, label %lor.rhs, !dbg !824

lor.rhs:                                          ; preds = %entry
  %3 = load i64, i64* %bAbs, align 8, !dbg !825
  %cmp3 = icmp ugt i64 %3, 9218868437227405312, !dbg !826
  br label %lor.end, !dbg !824

lor.end:                                          ; preds = %lor.rhs, %entry
  %4 = phi i1 [ true, %entry ], [ %cmp3, %lor.rhs ]
  %lor.ext = zext i1 %4 to i32, !dbg !824
  ret i32 %lor.ext, !dbg !827
}

; Function Attrs: noinline nounwind
define dso_local arm_aapcscc i32 @__eqdf2(double noundef %a, double noundef %b) #0 !dbg !828 {
entry:
  %a.addr = alloca double, align 8
  %b.addr = alloca double, align 8
  store double %a, double* %a.addr, align 8
  store double %b, double* %b.addr, align 8
  %0 = load double, double* %a.addr, align 8, !dbg !829
  %1 = load double, double* %b.addr, align 8, !dbg !830
  %call = call arm_aapcscc i32 @__ledf2(double noundef %0, double noundef %1) #4, !dbg !831
  ret i32 %call, !dbg !832
}

; Function Attrs: noinline nounwind
define dso_local arm_aapcscc i32 @__ltdf2(double noundef %a, double noundef %b) #0 !dbg !833 {
entry:
  %a.addr = alloca double, align 8
  %b.addr = alloca double, align 8
  store double %a, double* %a.addr, align 8
  store double %b, double* %b.addr, align 8
  %0 = load double, double* %a.addr, align 8, !dbg !834
  %1 = load double, double* %b.addr, align 8, !dbg !835
  %call = call arm_aapcscc i32 @__ledf2(double noundef %0, double noundef %1) #4, !dbg !836
  ret i32 %call, !dbg !837
}

; Function Attrs: noinline nounwind
define dso_local arm_aapcscc i32 @__nedf2(double noundef %a, double noundef %b) #0 !dbg !838 {
entry:
  %a.addr = alloca double, align 8
  %b.addr = alloca double, align 8
  store double %a, double* %a.addr, align 8
  store double %b, double* %b.addr, align 8
  %0 = load double, double* %a.addr, align 8, !dbg !839
  %1 = load double, double* %b.addr, align 8, !dbg !840
  %call = call arm_aapcscc i32 @__ledf2(double noundef %0, double noundef %1) #4, !dbg !841
  ret i32 %call, !dbg !842
}

; Function Attrs: noinline nounwind
define dso_local arm_aapcscc i32 @__gtdf2(double noundef %a, double noundef %b) #0 !dbg !843 {
entry:
  %a.addr = alloca double, align 8
  %b.addr = alloca double, align 8
  store double %a, double* %a.addr, align 8
  store double %b, double* %b.addr, align 8
  %0 = load double, double* %a.addr, align 8, !dbg !844
  %1 = load double, double* %b.addr, align 8, !dbg !845
  %call = call arm_aapcscc i32 @__gedf2(double noundef %0, double noundef %1) #4, !dbg !846
  ret i32 %call, !dbg !847
}

; Function Attrs: noinline nounwind
define dso_local arm_aapcscc i32 @__lesf2(float noundef %a, float noundef %b) #0 !dbg !848 {
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
  %0 = load float, float* %a.addr, align 4, !dbg !849
  %call = call arm_aapcscc i32 @toRep.7(float noundef %0) #4, !dbg !850
  store i32 %call, i32* %aInt, align 4, !dbg !851
  %1 = load float, float* %b.addr, align 4, !dbg !852
  %call1 = call arm_aapcscc i32 @toRep.7(float noundef %1) #4, !dbg !853
  store i32 %call1, i32* %bInt, align 4, !dbg !854
  %2 = load i32, i32* %aInt, align 4, !dbg !855
  %and = and i32 %2, 2147483647, !dbg !856
  store i32 %and, i32* %aAbs, align 4, !dbg !857
  %3 = load i32, i32* %bInt, align 4, !dbg !858
  %and2 = and i32 %3, 2147483647, !dbg !859
  store i32 %and2, i32* %bAbs, align 4, !dbg !860
  %4 = load i32, i32* %aAbs, align 4, !dbg !861
  %cmp = icmp ugt i32 %4, 2139095040, !dbg !862
  br i1 %cmp, label %if.then, label %lor.lhs.false, !dbg !863

lor.lhs.false:                                    ; preds = %entry
  %5 = load i32, i32* %bAbs, align 4, !dbg !864
  %cmp3 = icmp ugt i32 %5, 2139095040, !dbg !865
  br i1 %cmp3, label %if.then, label %if.end, !dbg !861

if.then:                                          ; preds = %lor.lhs.false, %entry
  store i32 1, i32* %retval, align 4, !dbg !866
  br label %return, !dbg !866

if.end:                                           ; preds = %lor.lhs.false
  %6 = load i32, i32* %aAbs, align 4, !dbg !867
  %7 = load i32, i32* %bAbs, align 4, !dbg !868
  %or = or i32 %6, %7, !dbg !869
  %cmp4 = icmp eq i32 %or, 0, !dbg !870
  br i1 %cmp4, label %if.then5, label %if.end6, !dbg !871

if.then5:                                         ; preds = %if.end
  store i32 0, i32* %retval, align 4, !dbg !872
  br label %return, !dbg !872

if.end6:                                          ; preds = %if.end
  %8 = load i32, i32* %aInt, align 4, !dbg !873
  %9 = load i32, i32* %bInt, align 4, !dbg !874
  %and7 = and i32 %8, %9, !dbg !875
  %cmp8 = icmp sge i32 %and7, 0, !dbg !876
  br i1 %cmp8, label %if.then9, label %if.else15, !dbg !877

if.then9:                                         ; preds = %if.end6
  %10 = load i32, i32* %aInt, align 4, !dbg !878
  %11 = load i32, i32* %bInt, align 4, !dbg !879
  %cmp10 = icmp slt i32 %10, %11, !dbg !880
  br i1 %cmp10, label %if.then11, label %if.else, !dbg !878

if.then11:                                        ; preds = %if.then9
  store i32 -1, i32* %retval, align 4, !dbg !881
  br label %return, !dbg !881

if.else:                                          ; preds = %if.then9
  %12 = load i32, i32* %aInt, align 4, !dbg !882
  %13 = load i32, i32* %bInt, align 4, !dbg !883
  %cmp12 = icmp eq i32 %12, %13, !dbg !884
  br i1 %cmp12, label %if.then13, label %if.else14, !dbg !882

if.then13:                                        ; preds = %if.else
  store i32 0, i32* %retval, align 4, !dbg !885
  br label %return, !dbg !885

if.else14:                                        ; preds = %if.else
  store i32 1, i32* %retval, align 4, !dbg !886
  br label %return, !dbg !886

if.else15:                                        ; preds = %if.end6
  %14 = load i32, i32* %aInt, align 4, !dbg !887
  %15 = load i32, i32* %bInt, align 4, !dbg !888
  %cmp16 = icmp sgt i32 %14, %15, !dbg !889
  br i1 %cmp16, label %if.then17, label %if.else18, !dbg !887

if.then17:                                        ; preds = %if.else15
  store i32 -1, i32* %retval, align 4, !dbg !890
  br label %return, !dbg !890

if.else18:                                        ; preds = %if.else15
  %16 = load i32, i32* %aInt, align 4, !dbg !891
  %17 = load i32, i32* %bInt, align 4, !dbg !892
  %cmp19 = icmp eq i32 %16, %17, !dbg !893
  br i1 %cmp19, label %if.then20, label %if.else21, !dbg !891

if.then20:                                        ; preds = %if.else18
  store i32 0, i32* %retval, align 4, !dbg !894
  br label %return, !dbg !894

if.else21:                                        ; preds = %if.else18
  store i32 1, i32* %retval, align 4, !dbg !895
  br label %return, !dbg !895

return:                                           ; preds = %if.else21, %if.then20, %if.then17, %if.else14, %if.then13, %if.then11, %if.then5, %if.then
  %18 = load i32, i32* %retval, align 4, !dbg !896
  ret i32 %18, !dbg !896
}

; Function Attrs: noinline nounwind
define internal arm_aapcscc i32 @toRep.7(float noundef %x) #0 !dbg !897 {
entry:
  %x.addr = alloca float, align 4
  %rep = alloca %union.anon.0.0, align 4
  store float %x, float* %x.addr, align 4
  %f = bitcast %union.anon.0.0* %rep to float*, !dbg !898
  %0 = load float, float* %x.addr, align 4, !dbg !899
  store float %0, float* %f, align 4, !dbg !898
  %i = bitcast %union.anon.0.0* %rep to i32*, !dbg !900
  %1 = load i32, i32* %i, align 4, !dbg !900
  ret i32 %1, !dbg !901
}

; Function Attrs: noinline nounwind
define dso_local arm_aapcscc i32 @__gesf2(float noundef %a, float noundef %b) #0 !dbg !902 {
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
  %0 = load float, float* %a.addr, align 4, !dbg !903
  %call = call arm_aapcscc i32 @toRep.7(float noundef %0) #4, !dbg !904
  store i32 %call, i32* %aInt, align 4, !dbg !905
  %1 = load float, float* %b.addr, align 4, !dbg !906
  %call1 = call arm_aapcscc i32 @toRep.7(float noundef %1) #4, !dbg !907
  store i32 %call1, i32* %bInt, align 4, !dbg !908
  %2 = load i32, i32* %aInt, align 4, !dbg !909
  %and = and i32 %2, 2147483647, !dbg !910
  store i32 %and, i32* %aAbs, align 4, !dbg !911
  %3 = load i32, i32* %bInt, align 4, !dbg !912
  %and2 = and i32 %3, 2147483647, !dbg !913
  store i32 %and2, i32* %bAbs, align 4, !dbg !914
  %4 = load i32, i32* %aAbs, align 4, !dbg !915
  %cmp = icmp ugt i32 %4, 2139095040, !dbg !916
  br i1 %cmp, label %if.then, label %lor.lhs.false, !dbg !917

lor.lhs.false:                                    ; preds = %entry
  %5 = load i32, i32* %bAbs, align 4, !dbg !918
  %cmp3 = icmp ugt i32 %5, 2139095040, !dbg !919
  br i1 %cmp3, label %if.then, label %if.end, !dbg !915

if.then:                                          ; preds = %lor.lhs.false, %entry
  store i32 -1, i32* %retval, align 4, !dbg !920
  br label %return, !dbg !920

if.end:                                           ; preds = %lor.lhs.false
  %6 = load i32, i32* %aAbs, align 4, !dbg !921
  %7 = load i32, i32* %bAbs, align 4, !dbg !922
  %or = or i32 %6, %7, !dbg !923
  %cmp4 = icmp eq i32 %or, 0, !dbg !924
  br i1 %cmp4, label %if.then5, label %if.end6, !dbg !925

if.then5:                                         ; preds = %if.end
  store i32 0, i32* %retval, align 4, !dbg !926
  br label %return, !dbg !926

if.end6:                                          ; preds = %if.end
  %8 = load i32, i32* %aInt, align 4, !dbg !927
  %9 = load i32, i32* %bInt, align 4, !dbg !928
  %and7 = and i32 %8, %9, !dbg !929
  %cmp8 = icmp sge i32 %and7, 0, !dbg !930
  br i1 %cmp8, label %if.then9, label %if.else15, !dbg !931

if.then9:                                         ; preds = %if.end6
  %10 = load i32, i32* %aInt, align 4, !dbg !932
  %11 = load i32, i32* %bInt, align 4, !dbg !933
  %cmp10 = icmp slt i32 %10, %11, !dbg !934
  br i1 %cmp10, label %if.then11, label %if.else, !dbg !932

if.then11:                                        ; preds = %if.then9
  store i32 -1, i32* %retval, align 4, !dbg !935
  br label %return, !dbg !935

if.else:                                          ; preds = %if.then9
  %12 = load i32, i32* %aInt, align 4, !dbg !936
  %13 = load i32, i32* %bInt, align 4, !dbg !937
  %cmp12 = icmp eq i32 %12, %13, !dbg !938
  br i1 %cmp12, label %if.then13, label %if.else14, !dbg !936

if.then13:                                        ; preds = %if.else
  store i32 0, i32* %retval, align 4, !dbg !939
  br label %return, !dbg !939

if.else14:                                        ; preds = %if.else
  store i32 1, i32* %retval, align 4, !dbg !940
  br label %return, !dbg !940

if.else15:                                        ; preds = %if.end6
  %14 = load i32, i32* %aInt, align 4, !dbg !941
  %15 = load i32, i32* %bInt, align 4, !dbg !942
  %cmp16 = icmp sgt i32 %14, %15, !dbg !943
  br i1 %cmp16, label %if.then17, label %if.else18, !dbg !941

if.then17:                                        ; preds = %if.else15
  store i32 -1, i32* %retval, align 4, !dbg !944
  br label %return, !dbg !944

if.else18:                                        ; preds = %if.else15
  %16 = load i32, i32* %aInt, align 4, !dbg !945
  %17 = load i32, i32* %bInt, align 4, !dbg !946
  %cmp19 = icmp eq i32 %16, %17, !dbg !947
  br i1 %cmp19, label %if.then20, label %if.else21, !dbg !945

if.then20:                                        ; preds = %if.else18
  store i32 0, i32* %retval, align 4, !dbg !948
  br label %return, !dbg !948

if.else21:                                        ; preds = %if.else18
  store i32 1, i32* %retval, align 4, !dbg !949
  br label %return, !dbg !949

return:                                           ; preds = %if.else21, %if.then20, %if.then17, %if.else14, %if.then13, %if.then11, %if.then5, %if.then
  %18 = load i32, i32* %retval, align 4, !dbg !950
  ret i32 %18, !dbg !950
}

; Function Attrs: noinline nounwind
define dso_local arm_aapcscc i32 @__unordsf2(float noundef %a, float noundef %b) #0 !dbg !951 {
entry:
  %a.addr = alloca float, align 4
  %b.addr = alloca float, align 4
  %aAbs = alloca i32, align 4
  %bAbs = alloca i32, align 4
  store float %a, float* %a.addr, align 4
  store float %b, float* %b.addr, align 4
  %0 = load float, float* %a.addr, align 4, !dbg !952
  %call = call arm_aapcscc i32 @toRep.7(float noundef %0) #4, !dbg !953
  %and = and i32 %call, 2147483647, !dbg !954
  store i32 %and, i32* %aAbs, align 4, !dbg !955
  %1 = load float, float* %b.addr, align 4, !dbg !956
  %call1 = call arm_aapcscc i32 @toRep.7(float noundef %1) #4, !dbg !957
  %and2 = and i32 %call1, 2147483647, !dbg !958
  store i32 %and2, i32* %bAbs, align 4, !dbg !959
  %2 = load i32, i32* %aAbs, align 4, !dbg !960
  %cmp = icmp ugt i32 %2, 2139095040, !dbg !961
  br i1 %cmp, label %lor.end, label %lor.rhs, !dbg !962

lor.rhs:                                          ; preds = %entry
  %3 = load i32, i32* %bAbs, align 4, !dbg !963
  %cmp3 = icmp ugt i32 %3, 2139095040, !dbg !964
  br label %lor.end, !dbg !962

lor.end:                                          ; preds = %lor.rhs, %entry
  %4 = phi i1 [ true, %entry ], [ %cmp3, %lor.rhs ]
  %lor.ext = zext i1 %4 to i32, !dbg !962
  ret i32 %lor.ext, !dbg !965
}

; Function Attrs: noinline nounwind
define dso_local arm_aapcscc i32 @__eqsf2(float noundef %a, float noundef %b) #0 !dbg !966 {
entry:
  %a.addr = alloca float, align 4
  %b.addr = alloca float, align 4
  store float %a, float* %a.addr, align 4
  store float %b, float* %b.addr, align 4
  %0 = load float, float* %a.addr, align 4, !dbg !967
  %1 = load float, float* %b.addr, align 4, !dbg !968
  %call = call arm_aapcscc i32 @__lesf2(float noundef %0, float noundef %1) #4, !dbg !969
  ret i32 %call, !dbg !970
}

; Function Attrs: noinline nounwind
define dso_local arm_aapcscc i32 @__ltsf2(float noundef %a, float noundef %b) #0 !dbg !971 {
entry:
  %a.addr = alloca float, align 4
  %b.addr = alloca float, align 4
  store float %a, float* %a.addr, align 4
  store float %b, float* %b.addr, align 4
  %0 = load float, float* %a.addr, align 4, !dbg !972
  %1 = load float, float* %b.addr, align 4, !dbg !973
  %call = call arm_aapcscc i32 @__lesf2(float noundef %0, float noundef %1) #4, !dbg !974
  ret i32 %call, !dbg !975
}

; Function Attrs: noinline nounwind
define dso_local arm_aapcscc i32 @__nesf2(float noundef %a, float noundef %b) #0 !dbg !976 {
entry:
  %a.addr = alloca float, align 4
  %b.addr = alloca float, align 4
  store float %a, float* %a.addr, align 4
  store float %b, float* %b.addr, align 4
  %0 = load float, float* %a.addr, align 4, !dbg !977
  %1 = load float, float* %b.addr, align 4, !dbg !978
  %call = call arm_aapcscc i32 @__lesf2(float noundef %0, float noundef %1) #4, !dbg !979
  ret i32 %call, !dbg !980
}

; Function Attrs: noinline nounwind
define dso_local arm_aapcscc i32 @__gtsf2(float noundef %a, float noundef %b) #0 !dbg !981 {
entry:
  %a.addr = alloca float, align 4
  %b.addr = alloca float, align 4
  store float %a, float* %a.addr, align 4
  store float %b, float* %b.addr, align 4
  %0 = load float, float* %a.addr, align 4, !dbg !982
  %1 = load float, float* %b.addr, align 4, !dbg !983
  %call = call arm_aapcscc i32 @__gesf2(float noundef %0, float noundef %1) #4, !dbg !984
  ret i32 %call, !dbg !985
}

; Function Attrs: noinline nounwind
define dso_local arm_aapcscc double @__divdf3(double noundef %a, double noundef %b) #0 !dbg !986 {
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
  %0 = load double, double* %a.addr, align 8, !dbg !987
  %call = call arm_aapcscc i64 @toRep.8(double noundef %0) #4, !dbg !988
  %shr = lshr i64 %call, 52, !dbg !989
  %and = and i64 %shr, 2047, !dbg !990
  %conv = trunc i64 %and to i32, !dbg !988
  store i32 %conv, i32* %aExponent, align 4, !dbg !991
  %1 = load double, double* %b.addr, align 8, !dbg !992
  %call1 = call arm_aapcscc i64 @toRep.8(double noundef %1) #4, !dbg !993
  %shr2 = lshr i64 %call1, 52, !dbg !994
  %and3 = and i64 %shr2, 2047, !dbg !995
  %conv4 = trunc i64 %and3 to i32, !dbg !993
  store i32 %conv4, i32* %bExponent, align 4, !dbg !996
  %2 = load double, double* %a.addr, align 8, !dbg !997
  %call5 = call arm_aapcscc i64 @toRep.8(double noundef %2) #4, !dbg !998
  %3 = load double, double* %b.addr, align 8, !dbg !999
  %call6 = call arm_aapcscc i64 @toRep.8(double noundef %3) #4, !dbg !1000
  %xor = xor i64 %call5, %call6, !dbg !1001
  %and7 = and i64 %xor, -9223372036854775808, !dbg !1002
  store i64 %and7, i64* %quotientSign, align 8, !dbg !1003
  %4 = load double, double* %a.addr, align 8, !dbg !1004
  %call8 = call arm_aapcscc i64 @toRep.8(double noundef %4) #4, !dbg !1005
  %and9 = and i64 %call8, 4503599627370495, !dbg !1006
  store i64 %and9, i64* %aSignificand, align 8, !dbg !1007
  %5 = load double, double* %b.addr, align 8, !dbg !1008
  %call10 = call arm_aapcscc i64 @toRep.8(double noundef %5) #4, !dbg !1009
  %and11 = and i64 %call10, 4503599627370495, !dbg !1010
  store i64 %and11, i64* %bSignificand, align 8, !dbg !1011
  store i32 0, i32* %scale, align 4, !dbg !1012
  %6 = load i32, i32* %aExponent, align 4, !dbg !1013
  %sub = sub i32 %6, 1, !dbg !1014
  %cmp = icmp uge i32 %sub, 2046, !dbg !1015
  br i1 %cmp, label %if.then, label %lor.lhs.false, !dbg !1016

lor.lhs.false:                                    ; preds = %entry
  %7 = load i32, i32* %bExponent, align 4, !dbg !1017
  %sub13 = sub i32 %7, 1, !dbg !1018
  %cmp14 = icmp uge i32 %sub13, 2046, !dbg !1019
  br i1 %cmp14, label %if.then, label %if.end70, !dbg !1013

if.then:                                          ; preds = %lor.lhs.false, %entry
  %8 = load double, double* %a.addr, align 8, !dbg !1020
  %call16 = call arm_aapcscc i64 @toRep.8(double noundef %8) #4, !dbg !1021
  %and17 = and i64 %call16, 9223372036854775807, !dbg !1022
  store i64 %and17, i64* %aAbs, align 8, !dbg !1023
  %9 = load double, double* %b.addr, align 8, !dbg !1024
  %call18 = call arm_aapcscc i64 @toRep.8(double noundef %9) #4, !dbg !1025
  %and19 = and i64 %call18, 9223372036854775807, !dbg !1026
  store i64 %and19, i64* %bAbs, align 8, !dbg !1027
  %10 = load i64, i64* %aAbs, align 8, !dbg !1028
  %cmp20 = icmp ugt i64 %10, 9218868437227405312, !dbg !1029
  br i1 %cmp20, label %if.then22, label %if.end, !dbg !1028

if.then22:                                        ; preds = %if.then
  %11 = load double, double* %a.addr, align 8, !dbg !1030
  %call23 = call arm_aapcscc i64 @toRep.8(double noundef %11) #4, !dbg !1031
  %or = or i64 %call23, 2251799813685248, !dbg !1032
  %call24 = call arm_aapcscc double @fromRep.9(i64 noundef %or) #4, !dbg !1033
  store double %call24, double* %retval, align 8, !dbg !1034
  br label %return, !dbg !1034

if.end:                                           ; preds = %if.then
  %12 = load i64, i64* %bAbs, align 8, !dbg !1035
  %cmp25 = icmp ugt i64 %12, 9218868437227405312, !dbg !1036
  br i1 %cmp25, label %if.then27, label %if.end31, !dbg !1035

if.then27:                                        ; preds = %if.end
  %13 = load double, double* %b.addr, align 8, !dbg !1037
  %call28 = call arm_aapcscc i64 @toRep.8(double noundef %13) #4, !dbg !1038
  %or29 = or i64 %call28, 2251799813685248, !dbg !1039
  %call30 = call arm_aapcscc double @fromRep.9(i64 noundef %or29) #4, !dbg !1040
  store double %call30, double* %retval, align 8, !dbg !1041
  br label %return, !dbg !1041

if.end31:                                         ; preds = %if.end
  %14 = load i64, i64* %aAbs, align 8, !dbg !1042
  %cmp32 = icmp eq i64 %14, 9218868437227405312, !dbg !1043
  br i1 %cmp32, label %if.then34, label %if.end41, !dbg !1042

if.then34:                                        ; preds = %if.end31
  %15 = load i64, i64* %bAbs, align 8, !dbg !1044
  %cmp35 = icmp eq i64 %15, 9218868437227405312, !dbg !1045
  br i1 %cmp35, label %if.then37, label %if.else, !dbg !1044

if.then37:                                        ; preds = %if.then34
  %call38 = call arm_aapcscc double @fromRep.9(i64 noundef 9221120237041090560) #4, !dbg !1046
  store double %call38, double* %retval, align 8, !dbg !1047
  br label %return, !dbg !1047

if.else:                                          ; preds = %if.then34
  %16 = load i64, i64* %aAbs, align 8, !dbg !1048
  %17 = load i64, i64* %quotientSign, align 8, !dbg !1049
  %or39 = or i64 %16, %17, !dbg !1050
  %call40 = call arm_aapcscc double @fromRep.9(i64 noundef %or39) #4, !dbg !1051
  store double %call40, double* %retval, align 8, !dbg !1052
  br label %return, !dbg !1052

if.end41:                                         ; preds = %if.end31
  %18 = load i64, i64* %bAbs, align 8, !dbg !1053
  %cmp42 = icmp eq i64 %18, 9218868437227405312, !dbg !1054
  br i1 %cmp42, label %if.then44, label %if.end46, !dbg !1053

if.then44:                                        ; preds = %if.end41
  %19 = load i64, i64* %quotientSign, align 8, !dbg !1055
  %call45 = call arm_aapcscc double @fromRep.9(i64 noundef %19) #4, !dbg !1056
  store double %call45, double* %retval, align 8, !dbg !1057
  br label %return, !dbg !1057

if.end46:                                         ; preds = %if.end41
  %20 = load i64, i64* %aAbs, align 8, !dbg !1058
  %tobool = icmp ne i64 %20, 0, !dbg !1058
  br i1 %tobool, label %if.end53, label %if.then47, !dbg !1059

if.then47:                                        ; preds = %if.end46
  %21 = load i64, i64* %bAbs, align 8, !dbg !1060
  %tobool48 = icmp ne i64 %21, 0, !dbg !1060
  br i1 %tobool48, label %if.else51, label %if.then49, !dbg !1061

if.then49:                                        ; preds = %if.then47
  %call50 = call arm_aapcscc double @fromRep.9(i64 noundef 9221120237041090560) #4, !dbg !1062
  store double %call50, double* %retval, align 8, !dbg !1063
  br label %return, !dbg !1063

if.else51:                                        ; preds = %if.then47
  %22 = load i64, i64* %quotientSign, align 8, !dbg !1064
  %call52 = call arm_aapcscc double @fromRep.9(i64 noundef %22) #4, !dbg !1065
  store double %call52, double* %retval, align 8, !dbg !1066
  br label %return, !dbg !1066

if.end53:                                         ; preds = %if.end46
  %23 = load i64, i64* %bAbs, align 8, !dbg !1067
  %tobool54 = icmp ne i64 %23, 0, !dbg !1067
  br i1 %tobool54, label %if.end58, label %if.then55, !dbg !1068

if.then55:                                        ; preds = %if.end53
  %24 = load i64, i64* %quotientSign, align 8, !dbg !1069
  %or56 = or i64 9218868437227405312, %24, !dbg !1070
  %call57 = call arm_aapcscc double @fromRep.9(i64 noundef %or56) #4, !dbg !1071
  store double %call57, double* %retval, align 8, !dbg !1072
  br label %return, !dbg !1072

if.end58:                                         ; preds = %if.end53
  %25 = load i64, i64* %aAbs, align 8, !dbg !1073
  %cmp59 = icmp ult i64 %25, 4503599627370496, !dbg !1074
  br i1 %cmp59, label %if.then61, label %if.end63, !dbg !1073

if.then61:                                        ; preds = %if.end58
  %call62 = call arm_aapcscc i32 @normalize.10(i64* noundef %aSignificand) #4, !dbg !1075
  %26 = load i32, i32* %scale, align 4, !dbg !1076
  %add = add nsw i32 %26, %call62, !dbg !1076
  store i32 %add, i32* %scale, align 4, !dbg !1076
  br label %if.end63, !dbg !1077

if.end63:                                         ; preds = %if.then61, %if.end58
  %27 = load i64, i64* %bAbs, align 8, !dbg !1078
  %cmp64 = icmp ult i64 %27, 4503599627370496, !dbg !1079
  br i1 %cmp64, label %if.then66, label %if.end69, !dbg !1078

if.then66:                                        ; preds = %if.end63
  %call67 = call arm_aapcscc i32 @normalize.10(i64* noundef %bSignificand) #4, !dbg !1080
  %28 = load i32, i32* %scale, align 4, !dbg !1081
  %sub68 = sub nsw i32 %28, %call67, !dbg !1081
  store i32 %sub68, i32* %scale, align 4, !dbg !1081
  br label %if.end69, !dbg !1082

if.end69:                                         ; preds = %if.then66, %if.end63
  br label %if.end70, !dbg !1083

if.end70:                                         ; preds = %if.end69, %lor.lhs.false
  %29 = load i64, i64* %aSignificand, align 8, !dbg !1084
  %or71 = or i64 %29, 4503599627370496, !dbg !1084
  store i64 %or71, i64* %aSignificand, align 8, !dbg !1084
  %30 = load i64, i64* %bSignificand, align 8, !dbg !1085
  %or72 = or i64 %30, 4503599627370496, !dbg !1085
  store i64 %or72, i64* %bSignificand, align 8, !dbg !1085
  %31 = load i32, i32* %aExponent, align 4, !dbg !1086
  %32 = load i32, i32* %bExponent, align 4, !dbg !1087
  %sub73 = sub i32 %31, %32, !dbg !1088
  %33 = load i32, i32* %scale, align 4, !dbg !1089
  %add74 = add i32 %sub73, %33, !dbg !1090
  store i32 %add74, i32* %quotientExponent, align 4, !dbg !1091
  %34 = load i64, i64* %bSignificand, align 8, !dbg !1092
  %shr75 = lshr i64 %34, 21, !dbg !1093
  %conv76 = trunc i64 %shr75 to i32, !dbg !1092
  store i32 %conv76, i32* %q31b, align 4, !dbg !1094
  %35 = load i32, i32* %q31b, align 4, !dbg !1095
  %sub77 = sub i32 1963258675, %35, !dbg !1096
  store i32 %sub77, i32* %recip32, align 4, !dbg !1097
  %36 = load i32, i32* %recip32, align 4, !dbg !1098
  %conv78 = zext i32 %36 to i64, !dbg !1099
  %37 = load i32, i32* %q31b, align 4, !dbg !1100
  %conv79 = zext i32 %37 to i64, !dbg !1100
  %mul = mul i64 %conv78, %conv79, !dbg !1101
  %shr80 = lshr i64 %mul, 32, !dbg !1102
  %sub81 = sub i64 0, %shr80, !dbg !1103
  %conv82 = trunc i64 %sub81 to i32, !dbg !1103
  store i32 %conv82, i32* %correction32, align 4, !dbg !1104
  %38 = load i32, i32* %recip32, align 4, !dbg !1105
  %conv83 = zext i32 %38 to i64, !dbg !1106
  %39 = load i32, i32* %correction32, align 4, !dbg !1107
  %conv84 = zext i32 %39 to i64, !dbg !1107
  %mul85 = mul i64 %conv83, %conv84, !dbg !1108
  %shr86 = lshr i64 %mul85, 31, !dbg !1109
  %conv87 = trunc i64 %shr86 to i32, !dbg !1106
  store i32 %conv87, i32* %recip32, align 4, !dbg !1110
  %40 = load i32, i32* %recip32, align 4, !dbg !1111
  %conv88 = zext i32 %40 to i64, !dbg !1112
  %41 = load i32, i32* %q31b, align 4, !dbg !1113
  %conv89 = zext i32 %41 to i64, !dbg !1113
  %mul90 = mul i64 %conv88, %conv89, !dbg !1114
  %shr91 = lshr i64 %mul90, 32, !dbg !1115
  %sub92 = sub i64 0, %shr91, !dbg !1116
  %conv93 = trunc i64 %sub92 to i32, !dbg !1116
  store i32 %conv93, i32* %correction32, align 4, !dbg !1117
  %42 = load i32, i32* %recip32, align 4, !dbg !1118
  %conv94 = zext i32 %42 to i64, !dbg !1119
  %43 = load i32, i32* %correction32, align 4, !dbg !1120
  %conv95 = zext i32 %43 to i64, !dbg !1120
  %mul96 = mul i64 %conv94, %conv95, !dbg !1121
  %shr97 = lshr i64 %mul96, 31, !dbg !1122
  %conv98 = trunc i64 %shr97 to i32, !dbg !1119
  store i32 %conv98, i32* %recip32, align 4, !dbg !1123
  %44 = load i32, i32* %recip32, align 4, !dbg !1124
  %conv99 = zext i32 %44 to i64, !dbg !1125
  %45 = load i32, i32* %q31b, align 4, !dbg !1126
  %conv100 = zext i32 %45 to i64, !dbg !1126
  %mul101 = mul i64 %conv99, %conv100, !dbg !1127
  %shr102 = lshr i64 %mul101, 32, !dbg !1128
  %sub103 = sub i64 0, %shr102, !dbg !1129
  %conv104 = trunc i64 %sub103 to i32, !dbg !1129
  store i32 %conv104, i32* %correction32, align 4, !dbg !1130
  %46 = load i32, i32* %recip32, align 4, !dbg !1131
  %conv105 = zext i32 %46 to i64, !dbg !1132
  %47 = load i32, i32* %correction32, align 4, !dbg !1133
  %conv106 = zext i32 %47 to i64, !dbg !1133
  %mul107 = mul i64 %conv105, %conv106, !dbg !1134
  %shr108 = lshr i64 %mul107, 31, !dbg !1135
  %conv109 = trunc i64 %shr108 to i32, !dbg !1132
  store i32 %conv109, i32* %recip32, align 4, !dbg !1136
  %48 = load i32, i32* %recip32, align 4, !dbg !1137
  %dec = add i32 %48, -1, !dbg !1137
  store i32 %dec, i32* %recip32, align 4, !dbg !1137
  %49 = load i64, i64* %bSignificand, align 8, !dbg !1138
  %shl = shl i64 %49, 11, !dbg !1139
  %conv110 = trunc i64 %shl to i32, !dbg !1138
  store i32 %conv110, i32* %q63blo, align 4, !dbg !1140
  %50 = load i32, i32* %recip32, align 4, !dbg !1141
  %conv111 = zext i32 %50 to i64, !dbg !1142
  %51 = load i32, i32* %q31b, align 4, !dbg !1143
  %conv112 = zext i32 %51 to i64, !dbg !1143
  %mul113 = mul i64 %conv111, %conv112, !dbg !1144
  %52 = load i32, i32* %recip32, align 4, !dbg !1145
  %conv114 = zext i32 %52 to i64, !dbg !1146
  %53 = load i32, i32* %q63blo, align 4, !dbg !1147
  %conv115 = zext i32 %53 to i64, !dbg !1147
  %mul116 = mul i64 %conv114, %conv115, !dbg !1148
  %shr117 = lshr i64 %mul116, 32, !dbg !1149
  %add118 = add i64 %mul113, %shr117, !dbg !1150
  %sub119 = sub i64 0, %add118, !dbg !1151
  store i64 %sub119, i64* %correction, align 8, !dbg !1152
  %54 = load i64, i64* %correction, align 8, !dbg !1153
  %shr120 = lshr i64 %54, 32, !dbg !1154
  %conv121 = trunc i64 %shr120 to i32, !dbg !1153
  store i32 %conv121, i32* %cHi, align 4, !dbg !1155
  %55 = load i64, i64* %correction, align 8, !dbg !1156
  %conv122 = trunc i64 %55 to i32, !dbg !1156
  store i32 %conv122, i32* %cLo, align 4, !dbg !1157
  %56 = load i32, i32* %recip32, align 4, !dbg !1158
  %conv123 = zext i32 %56 to i64, !dbg !1159
  %57 = load i32, i32* %cHi, align 4, !dbg !1160
  %conv124 = zext i32 %57 to i64, !dbg !1160
  %mul125 = mul i64 %conv123, %conv124, !dbg !1161
  %58 = load i32, i32* %recip32, align 4, !dbg !1162
  %conv126 = zext i32 %58 to i64, !dbg !1163
  %59 = load i32, i32* %cLo, align 4, !dbg !1164
  %conv127 = zext i32 %59 to i64, !dbg !1164
  %mul128 = mul i64 %conv126, %conv127, !dbg !1165
  %shr129 = lshr i64 %mul128, 32, !dbg !1166
  %add130 = add i64 %mul125, %shr129, !dbg !1167
  store i64 %add130, i64* %reciprocal, align 8, !dbg !1168
  %60 = load i64, i64* %reciprocal, align 8, !dbg !1169
  %sub131 = sub i64 %60, 2, !dbg !1169
  store i64 %sub131, i64* %reciprocal, align 8, !dbg !1169
  %61 = load i64, i64* %aSignificand, align 8, !dbg !1170
  %shl132 = shl i64 %61, 2, !dbg !1171
  %62 = load i64, i64* %reciprocal, align 8, !dbg !1172
  call arm_aapcscc void @wideMultiply(i64 noundef %shl132, i64 noundef %62, i64* noundef %quotient, i64* noundef %quotientLo) #4, !dbg !1173
  %63 = load i64, i64* %quotient, align 8, !dbg !1174
  %cmp133 = icmp ult i64 %63, 9007199254740992, !dbg !1175
  br i1 %cmp133, label %if.then135, label %if.else140, !dbg !1174

if.then135:                                       ; preds = %if.end70
  %64 = load i64, i64* %aSignificand, align 8, !dbg !1176
  %shl136 = shl i64 %64, 53, !dbg !1177
  %65 = load i64, i64* %quotient, align 8, !dbg !1178
  %66 = load i64, i64* %bSignificand, align 8, !dbg !1179
  %mul137 = mul i64 %65, %66, !dbg !1180
  %sub138 = sub i64 %shl136, %mul137, !dbg !1181
  store i64 %sub138, i64* %residual, align 8, !dbg !1182
  %67 = load i32, i32* %quotientExponent, align 4, !dbg !1183
  %dec139 = add nsw i32 %67, -1, !dbg !1183
  store i32 %dec139, i32* %quotientExponent, align 4, !dbg !1183
  br label %if.end145, !dbg !1184

if.else140:                                       ; preds = %if.end70
  %68 = load i64, i64* %quotient, align 8, !dbg !1185
  %shr141 = lshr i64 %68, 1, !dbg !1185
  store i64 %shr141, i64* %quotient, align 8, !dbg !1185
  %69 = load i64, i64* %aSignificand, align 8, !dbg !1186
  %shl142 = shl i64 %69, 52, !dbg !1187
  %70 = load i64, i64* %quotient, align 8, !dbg !1188
  %71 = load i64, i64* %bSignificand, align 8, !dbg !1189
  %mul143 = mul i64 %70, %71, !dbg !1190
  %sub144 = sub i64 %shl142, %mul143, !dbg !1191
  store i64 %sub144, i64* %residual, align 8, !dbg !1192
  br label %if.end145

if.end145:                                        ; preds = %if.else140, %if.then135
  %72 = load i32, i32* %quotientExponent, align 4, !dbg !1193
  %add146 = add nsw i32 %72, 1023, !dbg !1194
  store i32 %add146, i32* %writtenExponent, align 4, !dbg !1195
  %73 = load i32, i32* %writtenExponent, align 4, !dbg !1196
  %cmp147 = icmp sge i32 %73, 2047, !dbg !1197
  br i1 %cmp147, label %if.then149, label %if.else152, !dbg !1196

if.then149:                                       ; preds = %if.end145
  %74 = load i64, i64* %quotientSign, align 8, !dbg !1198
  %or150 = or i64 9218868437227405312, %74, !dbg !1199
  %call151 = call arm_aapcscc double @fromRep.9(i64 noundef %or150) #4, !dbg !1200
  store double %call151, double* %retval, align 8, !dbg !1201
  br label %return, !dbg !1201

if.else152:                                       ; preds = %if.end145
  %75 = load i32, i32* %writtenExponent, align 4, !dbg !1202
  %cmp153 = icmp slt i32 %75, 1, !dbg !1203
  br i1 %cmp153, label %if.then155, label %if.else157, !dbg !1202

if.then155:                                       ; preds = %if.else152
  %76 = load i64, i64* %quotientSign, align 8, !dbg !1204
  %call156 = call arm_aapcscc double @fromRep.9(i64 noundef %76) #4, !dbg !1205
  store double %call156, double* %retval, align 8, !dbg !1206
  br label %return, !dbg !1206

if.else157:                                       ; preds = %if.else152
  %77 = load i64, i64* %residual, align 8, !dbg !1207
  %shl158 = shl i64 %77, 1, !dbg !1208
  %78 = load i64, i64* %bSignificand, align 8, !dbg !1209
  %cmp159 = icmp ugt i64 %shl158, %78, !dbg !1210
  %frombool = zext i1 %cmp159 to i8, !dbg !1211
  store i8 %frombool, i8* %round, align 1, !dbg !1211
  %79 = load i64, i64* %quotient, align 8, !dbg !1212
  %and161 = and i64 %79, 4503599627370495, !dbg !1213
  store i64 %and161, i64* %absResult, align 8, !dbg !1214
  %80 = load i32, i32* %writtenExponent, align 4, !dbg !1215
  %conv162 = sext i32 %80 to i64, !dbg !1216
  %shl163 = shl i64 %conv162, 52, !dbg !1217
  %81 = load i64, i64* %absResult, align 8, !dbg !1218
  %or164 = or i64 %81, %shl163, !dbg !1218
  store i64 %or164, i64* %absResult, align 8, !dbg !1218
  %82 = load i8, i8* %round, align 1, !dbg !1219
  %tobool165 = trunc i8 %82 to i1, !dbg !1219
  %conv166 = zext i1 %tobool165 to i64, !dbg !1219
  %83 = load i64, i64* %absResult, align 8, !dbg !1220
  %add167 = add i64 %83, %conv166, !dbg !1220
  store i64 %add167, i64* %absResult, align 8, !dbg !1220
  %84 = load i64, i64* %absResult, align 8, !dbg !1221
  %85 = load i64, i64* %quotientSign, align 8, !dbg !1222
  %or168 = or i64 %84, %85, !dbg !1223
  %call169 = call arm_aapcscc double @fromRep.9(i64 noundef %or168) #4, !dbg !1224
  store double %call169, double* %result, align 8, !dbg !1225
  %86 = load double, double* %result, align 8, !dbg !1226
  store double %86, double* %retval, align 8, !dbg !1227
  br label %return, !dbg !1227

return:                                           ; preds = %if.else157, %if.then155, %if.then149, %if.then55, %if.else51, %if.then49, %if.then44, %if.else, %if.then37, %if.then27, %if.then22
  %87 = load double, double* %retval, align 8, !dbg !1228
  ret double %87, !dbg !1228
}

; Function Attrs: noinline nounwind
define internal arm_aapcscc i64 @toRep.8(double noundef %x) #0 !dbg !1229 {
entry:
  %x.addr = alloca double, align 8
  %rep = alloca %union.anon.0, align 8
  store double %x, double* %x.addr, align 8
  %f = bitcast %union.anon.0* %rep to double*, !dbg !1230
  %0 = load double, double* %x.addr, align 8, !dbg !1231
  store double %0, double* %f, align 8, !dbg !1230
  %i = bitcast %union.anon.0* %rep to i64*, !dbg !1232
  %1 = load i64, i64* %i, align 8, !dbg !1232
  ret i64 %1, !dbg !1233
}

; Function Attrs: noinline nounwind
define internal arm_aapcscc double @fromRep.9(i64 noundef %x) #0 !dbg !1234 {
entry:
  %x.addr = alloca i64, align 8
  %rep = alloca %union.anon.0, align 8
  store i64 %x, i64* %x.addr, align 8
  %i = bitcast %union.anon.0* %rep to i64*, !dbg !1235
  %0 = load i64, i64* %x.addr, align 8, !dbg !1236
  store i64 %0, i64* %i, align 8, !dbg !1235
  %f = bitcast %union.anon.0* %rep to double*, !dbg !1237
  %1 = load double, double* %f, align 8, !dbg !1237
  ret double %1, !dbg !1238
}

; Function Attrs: noinline nounwind
define internal arm_aapcscc i32 @normalize.10(i64* noundef %significand) #0 !dbg !1239 {
entry:
  %significand.addr = alloca i64*, align 4
  %shift = alloca i32, align 4
  store i64* %significand, i64** %significand.addr, align 4
  %0 = load i64*, i64** %significand.addr, align 4, !dbg !1240
  %1 = load i64, i64* %0, align 8, !dbg !1241
  %call = call arm_aapcscc i32 @rep_clz.11(i64 noundef %1) #4, !dbg !1242
  %call1 = call arm_aapcscc i32 @rep_clz.11(i64 noundef 4503599627370496) #4, !dbg !1243
  %sub = sub nsw i32 %call, %call1, !dbg !1244
  store i32 %sub, i32* %shift, align 4, !dbg !1245
  %2 = load i32, i32* %shift, align 4, !dbg !1246
  %3 = load i64*, i64** %significand.addr, align 4, !dbg !1247
  %4 = load i64, i64* %3, align 8, !dbg !1248
  %sh_prom = zext i32 %2 to i64, !dbg !1248
  %shl = shl i64 %4, %sh_prom, !dbg !1248
  store i64 %shl, i64* %3, align 8, !dbg !1248
  %5 = load i32, i32* %shift, align 4, !dbg !1249
  %sub2 = sub nsw i32 1, %5, !dbg !1250
  ret i32 %sub2, !dbg !1251
}

; Function Attrs: noinline nounwind
define internal arm_aapcscc void @wideMultiply(i64 noundef %a, i64 noundef %b, i64* noundef %hi, i64* noundef %lo) #0 !dbg !1252 {
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
  %0 = load i64, i64* %a.addr, align 8, !dbg !1253
  %and = and i64 %0, 4294967295, !dbg !1253
  %1 = load i64, i64* %b.addr, align 8, !dbg !1254
  %and1 = and i64 %1, 4294967295, !dbg !1254
  %mul = mul i64 %and, %and1, !dbg !1255
  store i64 %mul, i64* %plolo, align 8, !dbg !1256
  %2 = load i64, i64* %a.addr, align 8, !dbg !1257
  %and2 = and i64 %2, 4294967295, !dbg !1257
  %3 = load i64, i64* %b.addr, align 8, !dbg !1258
  %shr = lshr i64 %3, 32, !dbg !1258
  %mul3 = mul i64 %and2, %shr, !dbg !1259
  store i64 %mul3, i64* %plohi, align 8, !dbg !1260
  %4 = load i64, i64* %a.addr, align 8, !dbg !1261
  %shr4 = lshr i64 %4, 32, !dbg !1261
  %5 = load i64, i64* %b.addr, align 8, !dbg !1262
  %and5 = and i64 %5, 4294967295, !dbg !1262
  %mul6 = mul i64 %shr4, %and5, !dbg !1263
  store i64 %mul6, i64* %philo, align 8, !dbg !1264
  %6 = load i64, i64* %a.addr, align 8, !dbg !1265
  %shr7 = lshr i64 %6, 32, !dbg !1265
  %7 = load i64, i64* %b.addr, align 8, !dbg !1266
  %shr8 = lshr i64 %7, 32, !dbg !1266
  %mul9 = mul i64 %shr7, %shr8, !dbg !1267
  store i64 %mul9, i64* %phihi, align 8, !dbg !1268
  %8 = load i64, i64* %plolo, align 8, !dbg !1269
  %and10 = and i64 %8, 4294967295, !dbg !1269
  store i64 %and10, i64* %r0, align 8, !dbg !1270
  %9 = load i64, i64* %plolo, align 8, !dbg !1271
  %shr11 = lshr i64 %9, 32, !dbg !1271
  %10 = load i64, i64* %plohi, align 8, !dbg !1272
  %and12 = and i64 %10, 4294967295, !dbg !1272
  %add = add i64 %shr11, %and12, !dbg !1273
  %11 = load i64, i64* %philo, align 8, !dbg !1274
  %and13 = and i64 %11, 4294967295, !dbg !1274
  %add14 = add i64 %add, %and13, !dbg !1275
  store i64 %add14, i64* %r1, align 8, !dbg !1276
  %12 = load i64, i64* %r0, align 8, !dbg !1277
  %13 = load i64, i64* %r1, align 8, !dbg !1278
  %shl = shl i64 %13, 32, !dbg !1279
  %add15 = add i64 %12, %shl, !dbg !1280
  %14 = load i64*, i64** %lo.addr, align 4, !dbg !1281
  store i64 %add15, i64* %14, align 8, !dbg !1282
  %15 = load i64, i64* %plohi, align 8, !dbg !1283
  %shr16 = lshr i64 %15, 32, !dbg !1283
  %16 = load i64, i64* %philo, align 8, !dbg !1284
  %shr17 = lshr i64 %16, 32, !dbg !1284
  %add18 = add i64 %shr16, %shr17, !dbg !1285
  %17 = load i64, i64* %r1, align 8, !dbg !1286
  %shr19 = lshr i64 %17, 32, !dbg !1286
  %add20 = add i64 %add18, %shr19, !dbg !1287
  %18 = load i64, i64* %phihi, align 8, !dbg !1288
  %add21 = add i64 %add20, %18, !dbg !1289
  %19 = load i64*, i64** %hi.addr, align 4, !dbg !1290
  store i64 %add21, i64* %19, align 8, !dbg !1291
  ret void, !dbg !1292
}

; Function Attrs: noinline nounwind
define internal arm_aapcscc i32 @rep_clz.11(i64 noundef %a) #0 !dbg !1293 {
entry:
  %retval = alloca i32, align 4
  %a.addr = alloca i64, align 8
  store i64 %a, i64* %a.addr, align 8
  %0 = load i64, i64* %a.addr, align 8, !dbg !1294
  %and = and i64 %0, -4294967296, !dbg !1295
  %tobool = icmp ne i64 %and, 0, !dbg !1295
  br i1 %tobool, label %if.then, label %if.else, !dbg !1294

if.then:                                          ; preds = %entry
  %1 = load i64, i64* %a.addr, align 8, !dbg !1296
  %shr = lshr i64 %1, 32, !dbg !1297
  %conv = trunc i64 %shr to i32, !dbg !1296
  %2 = call i32 @llvm.ctlz.i32(i32 %conv, i1 false), !dbg !1298
  store i32 %2, i32* %retval, align 4, !dbg !1299
  br label %return, !dbg !1299

if.else:                                          ; preds = %entry
  %3 = load i64, i64* %a.addr, align 8, !dbg !1300
  %and1 = and i64 %3, 4294967295, !dbg !1301
  %conv2 = trunc i64 %and1 to i32, !dbg !1300
  %4 = call i32 @llvm.ctlz.i32(i32 %conv2, i1 false), !dbg !1302
  %add = add nsw i32 32, %4, !dbg !1303
  store i32 %add, i32* %retval, align 4, !dbg !1304
  br label %return, !dbg !1304

return:                                           ; preds = %if.else, %if.then
  %5 = load i32, i32* %retval, align 4, !dbg !1305
  ret i32 %5, !dbg !1305
}

; Function Attrs: noinline nounwind
define dso_local arm_aapcscc float @__divsf3(float noundef %a, float noundef %b) #0 !dbg !1306 {
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
  %0 = load float, float* %a.addr, align 4, !dbg !1307
  %call = call arm_aapcscc i32 @toRep.12(float noundef %0) #4, !dbg !1308
  %shr = lshr i32 %call, 23, !dbg !1309
  %and = and i32 %shr, 255, !dbg !1310
  store i32 %and, i32* %aExponent, align 4, !dbg !1311
  %1 = load float, float* %b.addr, align 4, !dbg !1312
  %call1 = call arm_aapcscc i32 @toRep.12(float noundef %1) #4, !dbg !1313
  %shr2 = lshr i32 %call1, 23, !dbg !1314
  %and3 = and i32 %shr2, 255, !dbg !1315
  store i32 %and3, i32* %bExponent, align 4, !dbg !1316
  %2 = load float, float* %a.addr, align 4, !dbg !1317
  %call4 = call arm_aapcscc i32 @toRep.12(float noundef %2) #4, !dbg !1318
  %3 = load float, float* %b.addr, align 4, !dbg !1319
  %call5 = call arm_aapcscc i32 @toRep.12(float noundef %3) #4, !dbg !1320
  %xor = xor i32 %call4, %call5, !dbg !1321
  %and6 = and i32 %xor, -2147483648, !dbg !1322
  store i32 %and6, i32* %quotientSign, align 4, !dbg !1323
  %4 = load float, float* %a.addr, align 4, !dbg !1324
  %call7 = call arm_aapcscc i32 @toRep.12(float noundef %4) #4, !dbg !1325
  %and8 = and i32 %call7, 8388607, !dbg !1326
  store i32 %and8, i32* %aSignificand, align 4, !dbg !1327
  %5 = load float, float* %b.addr, align 4, !dbg !1328
  %call9 = call arm_aapcscc i32 @toRep.12(float noundef %5) #4, !dbg !1329
  %and10 = and i32 %call9, 8388607, !dbg !1330
  store i32 %and10, i32* %bSignificand, align 4, !dbg !1331
  store i32 0, i32* %scale, align 4, !dbg !1332
  %6 = load i32, i32* %aExponent, align 4, !dbg !1333
  %sub = sub i32 %6, 1, !dbg !1334
  %cmp = icmp uge i32 %sub, 254, !dbg !1335
  br i1 %cmp, label %if.then, label %lor.lhs.false, !dbg !1336

lor.lhs.false:                                    ; preds = %entry
  %7 = load i32, i32* %bExponent, align 4, !dbg !1337
  %sub11 = sub i32 %7, 1, !dbg !1338
  %cmp12 = icmp uge i32 %sub11, 254, !dbg !1339
  br i1 %cmp12, label %if.then, label %if.end60, !dbg !1333

if.then:                                          ; preds = %lor.lhs.false, %entry
  %8 = load float, float* %a.addr, align 4, !dbg !1340
  %call13 = call arm_aapcscc i32 @toRep.12(float noundef %8) #4, !dbg !1341
  %and14 = and i32 %call13, 2147483647, !dbg !1342
  store i32 %and14, i32* %aAbs, align 4, !dbg !1343
  %9 = load float, float* %b.addr, align 4, !dbg !1344
  %call15 = call arm_aapcscc i32 @toRep.12(float noundef %9) #4, !dbg !1345
  %and16 = and i32 %call15, 2147483647, !dbg !1346
  store i32 %and16, i32* %bAbs, align 4, !dbg !1347
  %10 = load i32, i32* %aAbs, align 4, !dbg !1348
  %cmp17 = icmp ugt i32 %10, 2139095040, !dbg !1349
  br i1 %cmp17, label %if.then18, label %if.end, !dbg !1348

if.then18:                                        ; preds = %if.then
  %11 = load float, float* %a.addr, align 4, !dbg !1350
  %call19 = call arm_aapcscc i32 @toRep.12(float noundef %11) #4, !dbg !1351
  %or = or i32 %call19, 4194304, !dbg !1352
  %call20 = call arm_aapcscc float @fromRep.13(i32 noundef %or) #4, !dbg !1353
  store float %call20, float* %retval, align 4, !dbg !1354
  br label %return, !dbg !1354

if.end:                                           ; preds = %if.then
  %12 = load i32, i32* %bAbs, align 4, !dbg !1355
  %cmp21 = icmp ugt i32 %12, 2139095040, !dbg !1356
  br i1 %cmp21, label %if.then22, label %if.end26, !dbg !1355

if.then22:                                        ; preds = %if.end
  %13 = load float, float* %b.addr, align 4, !dbg !1357
  %call23 = call arm_aapcscc i32 @toRep.12(float noundef %13) #4, !dbg !1358
  %or24 = or i32 %call23, 4194304, !dbg !1359
  %call25 = call arm_aapcscc float @fromRep.13(i32 noundef %or24) #4, !dbg !1360
  store float %call25, float* %retval, align 4, !dbg !1361
  br label %return, !dbg !1361

if.end26:                                         ; preds = %if.end
  %14 = load i32, i32* %aAbs, align 4, !dbg !1362
  %cmp27 = icmp eq i32 %14, 2139095040, !dbg !1363
  br i1 %cmp27, label %if.then28, label %if.end34, !dbg !1362

if.then28:                                        ; preds = %if.end26
  %15 = load i32, i32* %bAbs, align 4, !dbg !1364
  %cmp29 = icmp eq i32 %15, 2139095040, !dbg !1365
  br i1 %cmp29, label %if.then30, label %if.else, !dbg !1364

if.then30:                                        ; preds = %if.then28
  %call31 = call arm_aapcscc float @fromRep.13(i32 noundef 2143289344) #4, !dbg !1366
  store float %call31, float* %retval, align 4, !dbg !1367
  br label %return, !dbg !1367

if.else:                                          ; preds = %if.then28
  %16 = load i32, i32* %aAbs, align 4, !dbg !1368
  %17 = load i32, i32* %quotientSign, align 4, !dbg !1369
  %or32 = or i32 %16, %17, !dbg !1370
  %call33 = call arm_aapcscc float @fromRep.13(i32 noundef %or32) #4, !dbg !1371
  store float %call33, float* %retval, align 4, !dbg !1372
  br label %return, !dbg !1372

if.end34:                                         ; preds = %if.end26
  %18 = load i32, i32* %bAbs, align 4, !dbg !1373
  %cmp35 = icmp eq i32 %18, 2139095040, !dbg !1374
  br i1 %cmp35, label %if.then36, label %if.end38, !dbg !1373

if.then36:                                        ; preds = %if.end34
  %19 = load i32, i32* %quotientSign, align 4, !dbg !1375
  %call37 = call arm_aapcscc float @fromRep.13(i32 noundef %19) #4, !dbg !1376
  store float %call37, float* %retval, align 4, !dbg !1377
  br label %return, !dbg !1377

if.end38:                                         ; preds = %if.end34
  %20 = load i32, i32* %aAbs, align 4, !dbg !1378
  %tobool = icmp ne i32 %20, 0, !dbg !1378
  br i1 %tobool, label %if.end45, label %if.then39, !dbg !1379

if.then39:                                        ; preds = %if.end38
  %21 = load i32, i32* %bAbs, align 4, !dbg !1380
  %tobool40 = icmp ne i32 %21, 0, !dbg !1380
  br i1 %tobool40, label %if.else43, label %if.then41, !dbg !1381

if.then41:                                        ; preds = %if.then39
  %call42 = call arm_aapcscc float @fromRep.13(i32 noundef 2143289344) #4, !dbg !1382
  store float %call42, float* %retval, align 4, !dbg !1383
  br label %return, !dbg !1383

if.else43:                                        ; preds = %if.then39
  %22 = load i32, i32* %quotientSign, align 4, !dbg !1384
  %call44 = call arm_aapcscc float @fromRep.13(i32 noundef %22) #4, !dbg !1385
  store float %call44, float* %retval, align 4, !dbg !1386
  br label %return, !dbg !1386

if.end45:                                         ; preds = %if.end38
  %23 = load i32, i32* %bAbs, align 4, !dbg !1387
  %tobool46 = icmp ne i32 %23, 0, !dbg !1387
  br i1 %tobool46, label %if.end50, label %if.then47, !dbg !1388

if.then47:                                        ; preds = %if.end45
  %24 = load i32, i32* %quotientSign, align 4, !dbg !1389
  %or48 = or i32 2139095040, %24, !dbg !1390
  %call49 = call arm_aapcscc float @fromRep.13(i32 noundef %or48) #4, !dbg !1391
  store float %call49, float* %retval, align 4, !dbg !1392
  br label %return, !dbg !1392

if.end50:                                         ; preds = %if.end45
  %25 = load i32, i32* %aAbs, align 4, !dbg !1393
  %cmp51 = icmp ult i32 %25, 8388608, !dbg !1394
  br i1 %cmp51, label %if.then52, label %if.end54, !dbg !1393

if.then52:                                        ; preds = %if.end50
  %call53 = call arm_aapcscc i32 @normalize.14(i32* noundef %aSignificand) #4, !dbg !1395
  %26 = load i32, i32* %scale, align 4, !dbg !1396
  %add = add nsw i32 %26, %call53, !dbg !1396
  store i32 %add, i32* %scale, align 4, !dbg !1396
  br label %if.end54, !dbg !1397

if.end54:                                         ; preds = %if.then52, %if.end50
  %27 = load i32, i32* %bAbs, align 4, !dbg !1398
  %cmp55 = icmp ult i32 %27, 8388608, !dbg !1399
  br i1 %cmp55, label %if.then56, label %if.end59, !dbg !1398

if.then56:                                        ; preds = %if.end54
  %call57 = call arm_aapcscc i32 @normalize.14(i32* noundef %bSignificand) #4, !dbg !1400
  %28 = load i32, i32* %scale, align 4, !dbg !1401
  %sub58 = sub nsw i32 %28, %call57, !dbg !1401
  store i32 %sub58, i32* %scale, align 4, !dbg !1401
  br label %if.end59, !dbg !1402

if.end59:                                         ; preds = %if.then56, %if.end54
  br label %if.end60, !dbg !1403

if.end60:                                         ; preds = %if.end59, %lor.lhs.false
  %29 = load i32, i32* %aSignificand, align 4, !dbg !1404
  %or61 = or i32 %29, 8388608, !dbg !1404
  store i32 %or61, i32* %aSignificand, align 4, !dbg !1404
  %30 = load i32, i32* %bSignificand, align 4, !dbg !1405
  %or62 = or i32 %30, 8388608, !dbg !1405
  store i32 %or62, i32* %bSignificand, align 4, !dbg !1405
  %31 = load i32, i32* %aExponent, align 4, !dbg !1406
  %32 = load i32, i32* %bExponent, align 4, !dbg !1407
  %sub63 = sub i32 %31, %32, !dbg !1408
  %33 = load i32, i32* %scale, align 4, !dbg !1409
  %add64 = add i32 %sub63, %33, !dbg !1410
  store i32 %add64, i32* %quotientExponent, align 4, !dbg !1411
  %34 = load i32, i32* %bSignificand, align 4, !dbg !1412
  %shl = shl i32 %34, 8, !dbg !1413
  store i32 %shl, i32* %q31b, align 4, !dbg !1414
  %35 = load i32, i32* %q31b, align 4, !dbg !1415
  %sub65 = sub i32 1963258675, %35, !dbg !1416
  store i32 %sub65, i32* %reciprocal, align 4, !dbg !1417
  %36 = load i32, i32* %reciprocal, align 4, !dbg !1418
  %conv = zext i32 %36 to i64, !dbg !1419
  %37 = load i32, i32* %q31b, align 4, !dbg !1420
  %conv66 = zext i32 %37 to i64, !dbg !1420
  %mul = mul i64 %conv, %conv66, !dbg !1421
  %shr67 = lshr i64 %mul, 32, !dbg !1422
  %sub68 = sub i64 0, %shr67, !dbg !1423
  %conv69 = trunc i64 %sub68 to i32, !dbg !1423
  store i32 %conv69, i32* %correction, align 4, !dbg !1424
  %38 = load i32, i32* %reciprocal, align 4, !dbg !1425
  %conv70 = zext i32 %38 to i64, !dbg !1426
  %39 = load i32, i32* %correction, align 4, !dbg !1427
  %conv71 = zext i32 %39 to i64, !dbg !1427
  %mul72 = mul i64 %conv70, %conv71, !dbg !1428
  %shr73 = lshr i64 %mul72, 31, !dbg !1429
  %conv74 = trunc i64 %shr73 to i32, !dbg !1426
  store i32 %conv74, i32* %reciprocal, align 4, !dbg !1430
  %40 = load i32, i32* %reciprocal, align 4, !dbg !1431
  %conv75 = zext i32 %40 to i64, !dbg !1432
  %41 = load i32, i32* %q31b, align 4, !dbg !1433
  %conv76 = zext i32 %41 to i64, !dbg !1433
  %mul77 = mul i64 %conv75, %conv76, !dbg !1434
  %shr78 = lshr i64 %mul77, 32, !dbg !1435
  %sub79 = sub i64 0, %shr78, !dbg !1436
  %conv80 = trunc i64 %sub79 to i32, !dbg !1436
  store i32 %conv80, i32* %correction, align 4, !dbg !1437
  %42 = load i32, i32* %reciprocal, align 4, !dbg !1438
  %conv81 = zext i32 %42 to i64, !dbg !1439
  %43 = load i32, i32* %correction, align 4, !dbg !1440
  %conv82 = zext i32 %43 to i64, !dbg !1440
  %mul83 = mul i64 %conv81, %conv82, !dbg !1441
  %shr84 = lshr i64 %mul83, 31, !dbg !1442
  %conv85 = trunc i64 %shr84 to i32, !dbg !1439
  store i32 %conv85, i32* %reciprocal, align 4, !dbg !1443
  %44 = load i32, i32* %reciprocal, align 4, !dbg !1444
  %conv86 = zext i32 %44 to i64, !dbg !1445
  %45 = load i32, i32* %q31b, align 4, !dbg !1446
  %conv87 = zext i32 %45 to i64, !dbg !1446
  %mul88 = mul i64 %conv86, %conv87, !dbg !1447
  %shr89 = lshr i64 %mul88, 32, !dbg !1448
  %sub90 = sub i64 0, %shr89, !dbg !1449
  %conv91 = trunc i64 %sub90 to i32, !dbg !1449
  store i32 %conv91, i32* %correction, align 4, !dbg !1450
  %46 = load i32, i32* %reciprocal, align 4, !dbg !1451
  %conv92 = zext i32 %46 to i64, !dbg !1452
  %47 = load i32, i32* %correction, align 4, !dbg !1453
  %conv93 = zext i32 %47 to i64, !dbg !1453
  %mul94 = mul i64 %conv92, %conv93, !dbg !1454
  %shr95 = lshr i64 %mul94, 31, !dbg !1455
  %conv96 = trunc i64 %shr95 to i32, !dbg !1452
  store i32 %conv96, i32* %reciprocal, align 4, !dbg !1456
  %48 = load i32, i32* %reciprocal, align 4, !dbg !1457
  %sub97 = sub i32 %48, 2, !dbg !1457
  store i32 %sub97, i32* %reciprocal, align 4, !dbg !1457
  %49 = load i32, i32* %reciprocal, align 4, !dbg !1458
  %conv98 = zext i32 %49 to i64, !dbg !1459
  %50 = load i32, i32* %aSignificand, align 4, !dbg !1460
  %shl99 = shl i32 %50, 1, !dbg !1461
  %conv100 = zext i32 %shl99 to i64, !dbg !1462
  %mul101 = mul i64 %conv98, %conv100, !dbg !1463
  %shr102 = lshr i64 %mul101, 32, !dbg !1464
  %conv103 = trunc i64 %shr102 to i32, !dbg !1459
  store i32 %conv103, i32* %quotient, align 4, !dbg !1465
  %51 = load i32, i32* %quotient, align 4, !dbg !1466
  %cmp104 = icmp ult i32 %51, 16777216, !dbg !1467
  br i1 %cmp104, label %if.then106, label %if.else110, !dbg !1466

if.then106:                                       ; preds = %if.end60
  %52 = load i32, i32* %aSignificand, align 4, !dbg !1468
  %shl107 = shl i32 %52, 24, !dbg !1469
  %53 = load i32, i32* %quotient, align 4, !dbg !1470
  %54 = load i32, i32* %bSignificand, align 4, !dbg !1471
  %mul108 = mul i32 %53, %54, !dbg !1472
  %sub109 = sub i32 %shl107, %mul108, !dbg !1473
  store i32 %sub109, i32* %residual, align 4, !dbg !1474
  %55 = load i32, i32* %quotientExponent, align 4, !dbg !1475
  %dec = add nsw i32 %55, -1, !dbg !1475
  store i32 %dec, i32* %quotientExponent, align 4, !dbg !1475
  br label %if.end115, !dbg !1476

if.else110:                                       ; preds = %if.end60
  %56 = load i32, i32* %quotient, align 4, !dbg !1477
  %shr111 = lshr i32 %56, 1, !dbg !1477
  store i32 %shr111, i32* %quotient, align 4, !dbg !1477
  %57 = load i32, i32* %aSignificand, align 4, !dbg !1478
  %shl112 = shl i32 %57, 23, !dbg !1479
  %58 = load i32, i32* %quotient, align 4, !dbg !1480
  %59 = load i32, i32* %bSignificand, align 4, !dbg !1481
  %mul113 = mul i32 %58, %59, !dbg !1482
  %sub114 = sub i32 %shl112, %mul113, !dbg !1483
  store i32 %sub114, i32* %residual, align 4, !dbg !1484
  br label %if.end115

if.end115:                                        ; preds = %if.else110, %if.then106
  %60 = load i32, i32* %quotientExponent, align 4, !dbg !1485
  %add116 = add nsw i32 %60, 127, !dbg !1486
  store i32 %add116, i32* %writtenExponent, align 4, !dbg !1487
  %61 = load i32, i32* %writtenExponent, align 4, !dbg !1488
  %cmp117 = icmp sge i32 %61, 255, !dbg !1489
  br i1 %cmp117, label %if.then119, label %if.else122, !dbg !1488

if.then119:                                       ; preds = %if.end115
  %62 = load i32, i32* %quotientSign, align 4, !dbg !1490
  %or120 = or i32 2139095040, %62, !dbg !1491
  %call121 = call arm_aapcscc float @fromRep.13(i32 noundef %or120) #4, !dbg !1492
  store float %call121, float* %retval, align 4, !dbg !1493
  br label %return, !dbg !1493

if.else122:                                       ; preds = %if.end115
  %63 = load i32, i32* %writtenExponent, align 4, !dbg !1494
  %cmp123 = icmp slt i32 %63, 1, !dbg !1495
  br i1 %cmp123, label %if.then125, label %if.else127, !dbg !1494

if.then125:                                       ; preds = %if.else122
  %64 = load i32, i32* %quotientSign, align 4, !dbg !1496
  %call126 = call arm_aapcscc float @fromRep.13(i32 noundef %64) #4, !dbg !1497
  store float %call126, float* %retval, align 4, !dbg !1498
  br label %return, !dbg !1498

if.else127:                                       ; preds = %if.else122
  %65 = load i32, i32* %residual, align 4, !dbg !1499
  %shl128 = shl i32 %65, 1, !dbg !1500
  %66 = load i32, i32* %bSignificand, align 4, !dbg !1501
  %cmp129 = icmp ugt i32 %shl128, %66, !dbg !1502
  %frombool = zext i1 %cmp129 to i8, !dbg !1503
  store i8 %frombool, i8* %round, align 1, !dbg !1503
  %67 = load i32, i32* %quotient, align 4, !dbg !1504
  %and131 = and i32 %67, 8388607, !dbg !1505
  store i32 %and131, i32* %absResult, align 4, !dbg !1506
  %68 = load i32, i32* %writtenExponent, align 4, !dbg !1507
  %shl132 = shl i32 %68, 23, !dbg !1508
  %69 = load i32, i32* %absResult, align 4, !dbg !1509
  %or133 = or i32 %69, %shl132, !dbg !1509
  store i32 %or133, i32* %absResult, align 4, !dbg !1509
  %70 = load i8, i8* %round, align 1, !dbg !1510
  %tobool134 = trunc i8 %70 to i1, !dbg !1510
  %conv135 = zext i1 %tobool134 to i32, !dbg !1510
  %71 = load i32, i32* %absResult, align 4, !dbg !1511
  %add136 = add i32 %71, %conv135, !dbg !1511
  store i32 %add136, i32* %absResult, align 4, !dbg !1511
  %72 = load i32, i32* %absResult, align 4, !dbg !1512
  %73 = load i32, i32* %quotientSign, align 4, !dbg !1513
  %or137 = or i32 %72, %73, !dbg !1514
  %call138 = call arm_aapcscc float @fromRep.13(i32 noundef %or137) #4, !dbg !1515
  store float %call138, float* %retval, align 4, !dbg !1516
  br label %return, !dbg !1516

return:                                           ; preds = %if.else127, %if.then125, %if.then119, %if.then47, %if.else43, %if.then41, %if.then36, %if.else, %if.then30, %if.then22, %if.then18
  %74 = load float, float* %retval, align 4, !dbg !1517
  ret float %74, !dbg !1517
}

; Function Attrs: noinline nounwind
define internal arm_aapcscc i32 @toRep.12(float noundef %x) #0 !dbg !1518 {
entry:
  %x.addr = alloca float, align 4
  %rep = alloca %union.anon.0.0, align 4
  store float %x, float* %x.addr, align 4
  %f = bitcast %union.anon.0.0* %rep to float*, !dbg !1519
  %0 = load float, float* %x.addr, align 4, !dbg !1520
  store float %0, float* %f, align 4, !dbg !1519
  %i = bitcast %union.anon.0.0* %rep to i32*, !dbg !1521
  %1 = load i32, i32* %i, align 4, !dbg !1521
  ret i32 %1, !dbg !1522
}

; Function Attrs: noinline nounwind
define internal arm_aapcscc float @fromRep.13(i32 noundef %x) #0 !dbg !1523 {
entry:
  %x.addr = alloca i32, align 4
  %rep = alloca %union.anon.0.0, align 4
  store i32 %x, i32* %x.addr, align 4
  %i = bitcast %union.anon.0.0* %rep to i32*, !dbg !1524
  %0 = load i32, i32* %x.addr, align 4, !dbg !1525
  store i32 %0, i32* %i, align 4, !dbg !1524
  %f = bitcast %union.anon.0.0* %rep to float*, !dbg !1526
  %1 = load float, float* %f, align 4, !dbg !1526
  ret float %1, !dbg !1527
}

; Function Attrs: noinline nounwind
define internal arm_aapcscc i32 @normalize.14(i32* noundef %significand) #0 !dbg !1528 {
entry:
  %significand.addr = alloca i32*, align 4
  %shift = alloca i32, align 4
  store i32* %significand, i32** %significand.addr, align 4
  %0 = load i32*, i32** %significand.addr, align 4, !dbg !1529
  %1 = load i32, i32* %0, align 4, !dbg !1530
  %call = call arm_aapcscc i32 @rep_clz.15(i32 noundef %1) #4, !dbg !1531
  %call1 = call arm_aapcscc i32 @rep_clz.15(i32 noundef 8388608) #4, !dbg !1532
  %sub = sub nsw i32 %call, %call1, !dbg !1533
  store i32 %sub, i32* %shift, align 4, !dbg !1534
  %2 = load i32, i32* %shift, align 4, !dbg !1535
  %3 = load i32*, i32** %significand.addr, align 4, !dbg !1536
  %4 = load i32, i32* %3, align 4, !dbg !1537
  %shl = shl i32 %4, %2, !dbg !1537
  store i32 %shl, i32* %3, align 4, !dbg !1537
  %5 = load i32, i32* %shift, align 4, !dbg !1538
  %sub2 = sub nsw i32 1, %5, !dbg !1539
  ret i32 %sub2, !dbg !1540
}

; Function Attrs: noinline nounwind
define internal arm_aapcscc i32 @rep_clz.15(i32 noundef %a) #0 !dbg !1541 {
entry:
  %a.addr = alloca i32, align 4
  store i32 %a, i32* %a.addr, align 4
  %0 = load i32, i32* %a.addr, align 4, !dbg !1542
  %1 = call i32 @llvm.ctlz.i32(i32 %0, i1 false), !dbg !1543
  ret i32 %1, !dbg !1544
}

; Function Attrs: noinline nounwind
define dso_local arm_aapcscc float @__extendhfsf2(i16 noundef zeroext %a) #0 !dbg !1545 {
entry:
  %a.addr = alloca i16, align 2
  store i16 %a, i16* %a.addr, align 2
  %0 = load i16, i16* %a.addr, align 2, !dbg !1546
  %call = call arm_aapcscc float @__extendXfYf2__(i16 noundef zeroext %0) #4, !dbg !1547
  ret float %call, !dbg !1548
}

; Function Attrs: noinline nounwind
define internal arm_aapcscc float @__extendXfYf2__(i16 noundef zeroext %a) #0 !dbg !1549 {
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
  store i32 16, i32* %srcBits, align 4, !dbg !1551
  store i32 5, i32* %srcExpBits, align 4, !dbg !1552
  store i32 31, i32* %srcInfExp, align 4, !dbg !1553
  store i32 15, i32* %srcExpBias, align 4, !dbg !1554
  store i16 1024, i16* %srcMinNormal, align 2, !dbg !1555
  store i16 31744, i16* %srcInfinity, align 2, !dbg !1556
  store i16 -32768, i16* %srcSignMask, align 2, !dbg !1557
  store i16 32767, i16* %srcAbsMask, align 2, !dbg !1558
  store i16 512, i16* %srcQNaN, align 2, !dbg !1559
  store i16 511, i16* %srcNaNCode, align 2, !dbg !1560
  store i32 32, i32* %dstBits, align 4, !dbg !1561
  store i32 8, i32* %dstExpBits, align 4, !dbg !1562
  store i32 255, i32* %dstInfExp, align 4, !dbg !1563
  store i32 127, i32* %dstExpBias, align 4, !dbg !1564
  store i32 8388608, i32* %dstMinNormal, align 4, !dbg !1565
  %0 = load i16, i16* %a.addr, align 2, !dbg !1566
  %call = call arm_aapcscc zeroext i16 @srcToRep(i16 noundef zeroext %0) #4, !dbg !1567
  store i16 %call, i16* %aRep, align 2, !dbg !1568
  %1 = load i16, i16* %aRep, align 2, !dbg !1569
  %conv = zext i16 %1 to i32, !dbg !1569
  %and = and i32 %conv, 32767, !dbg !1570
  %conv1 = trunc i32 %and to i16, !dbg !1569
  store i16 %conv1, i16* %aAbs, align 2, !dbg !1571
  %2 = load i16, i16* %aRep, align 2, !dbg !1572
  %conv2 = zext i16 %2 to i32, !dbg !1572
  %and3 = and i32 %conv2, 32768, !dbg !1573
  %conv4 = trunc i32 %and3 to i16, !dbg !1572
  store i16 %conv4, i16* %sign, align 2, !dbg !1574
  %3 = load i16, i16* %aAbs, align 2, !dbg !1575
  %conv5 = zext i16 %3 to i32, !dbg !1575
  %sub = sub nsw i32 %conv5, 1024, !dbg !1576
  %conv6 = trunc i32 %sub to i16, !dbg !1577
  %conv7 = zext i16 %conv6 to i32, !dbg !1577
  %cmp = icmp slt i32 %conv7, 30720, !dbg !1578
  br i1 %cmp, label %if.then, label %if.else, !dbg !1577

if.then:                                          ; preds = %entry
  %4 = load i16, i16* %aAbs, align 2, !dbg !1579
  %conv9 = zext i16 %4 to i32, !dbg !1580
  %shl = shl i32 %conv9, 13, !dbg !1581
  store i32 %shl, i32* %absResult, align 4, !dbg !1582
  %5 = load i32, i32* %absResult, align 4, !dbg !1583
  %add = add i32 %5, 939524096, !dbg !1583
  store i32 %add, i32* %absResult, align 4, !dbg !1583
  br label %if.end34, !dbg !1584

if.else:                                          ; preds = %entry
  %6 = load i16, i16* %aAbs, align 2, !dbg !1585
  %conv10 = zext i16 %6 to i32, !dbg !1585
  %cmp11 = icmp sge i32 %conv10, 31744, !dbg !1586
  br i1 %cmp11, label %if.then13, label %if.else21, !dbg !1585

if.then13:                                        ; preds = %if.else
  store i32 2139095040, i32* %absResult, align 4, !dbg !1587
  %7 = load i16, i16* %aAbs, align 2, !dbg !1588
  %conv14 = zext i16 %7 to i32, !dbg !1588
  %and15 = and i32 %conv14, 512, !dbg !1589
  %shl16 = shl i32 %and15, 13, !dbg !1590
  %8 = load i32, i32* %absResult, align 4, !dbg !1591
  %or = or i32 %8, %shl16, !dbg !1591
  store i32 %or, i32* %absResult, align 4, !dbg !1591
  %9 = load i16, i16* %aAbs, align 2, !dbg !1592
  %conv17 = zext i16 %9 to i32, !dbg !1592
  %and18 = and i32 %conv17, 511, !dbg !1593
  %shl19 = shl i32 %and18, 13, !dbg !1594
  %10 = load i32, i32* %absResult, align 4, !dbg !1595
  %or20 = or i32 %10, %shl19, !dbg !1595
  store i32 %or20, i32* %absResult, align 4, !dbg !1595
  br label %if.end33, !dbg !1596

if.else21:                                        ; preds = %if.else
  %11 = load i16, i16* %aAbs, align 2, !dbg !1597
  %tobool = icmp ne i16 %11, 0, !dbg !1597
  br i1 %tobool, label %if.then22, label %if.else32, !dbg !1597

if.then22:                                        ; preds = %if.else21
  %12 = load i16, i16* %aAbs, align 2, !dbg !1598
  %conv23 = zext i16 %12 to i32, !dbg !1598
  %13 = call i32 @llvm.ctlz.i32(i32 %conv23, i1 false), !dbg !1599
  %sub24 = sub nsw i32 %13, 21, !dbg !1600
  store i32 %sub24, i32* %scale, align 4, !dbg !1601
  %14 = load i16, i16* %aAbs, align 2, !dbg !1602
  %conv25 = zext i16 %14 to i32, !dbg !1603
  %15 = load i32, i32* %scale, align 4, !dbg !1604
  %add26 = add nsw i32 13, %15, !dbg !1605
  %shl27 = shl i32 %conv25, %add26, !dbg !1606
  store i32 %shl27, i32* %absResult, align 4, !dbg !1607
  %16 = load i32, i32* %absResult, align 4, !dbg !1608
  %xor = xor i32 %16, 8388608, !dbg !1608
  store i32 %xor, i32* %absResult, align 4, !dbg !1608
  %17 = load i32, i32* %scale, align 4, !dbg !1609
  %sub28 = sub nsw i32 112, %17, !dbg !1610
  %add29 = add nsw i32 %sub28, 1, !dbg !1611
  store i32 %add29, i32* %resultExponent, align 4, !dbg !1612
  %18 = load i32, i32* %resultExponent, align 4, !dbg !1613
  %shl30 = shl i32 %18, 23, !dbg !1614
  %19 = load i32, i32* %absResult, align 4, !dbg !1615
  %or31 = or i32 %19, %shl30, !dbg !1615
  store i32 %or31, i32* %absResult, align 4, !dbg !1615
  br label %if.end, !dbg !1616

if.else32:                                        ; preds = %if.else21
  store i32 0, i32* %absResult, align 4, !dbg !1617
  br label %if.end

if.end:                                           ; preds = %if.else32, %if.then22
  br label %if.end33

if.end33:                                         ; preds = %if.end, %if.then13
  br label %if.end34

if.end34:                                         ; preds = %if.end33, %if.then
  %20 = load i32, i32* %absResult, align 4, !dbg !1618
  %21 = load i16, i16* %sign, align 2, !dbg !1619
  %conv35 = zext i16 %21 to i32, !dbg !1620
  %shl36 = shl i32 %conv35, 16, !dbg !1621
  %or37 = or i32 %20, %shl36, !dbg !1622
  store i32 %or37, i32* %result, align 4, !dbg !1623
  %22 = load i32, i32* %result, align 4, !dbg !1624
  %call38 = call arm_aapcscc float @dstFromRep(i32 noundef %22) #4, !dbg !1625
  ret float %call38, !dbg !1626
}

; Function Attrs: noinline nounwind
define internal arm_aapcscc zeroext i16 @srcToRep(i16 noundef zeroext %x) #0 !dbg !1627 {
entry:
  %x.addr = alloca i16, align 2
  %rep = alloca %union.anon, align 2
  store i16 %x, i16* %x.addr, align 2
  %f = bitcast %union.anon* %rep to i16*, !dbg !1629
  %0 = load i16, i16* %x.addr, align 2, !dbg !1630
  store i16 %0, i16* %f, align 2, !dbg !1629
  %i = bitcast %union.anon* %rep to i16*, !dbg !1631
  %1 = load i16, i16* %i, align 2, !dbg !1631
  ret i16 %1, !dbg !1632
}

; Function Attrs: noinline nounwind
define internal arm_aapcscc float @dstFromRep(i32 noundef %x) #0 !dbg !1633 {
entry:
  %x.addr = alloca i32, align 4
  %rep = alloca %union.anon.0.0, align 4
  store i32 %x, i32* %x.addr, align 4
  %i = bitcast %union.anon.0.0* %rep to i32*, !dbg !1634
  %0 = load i32, i32* %x.addr, align 4, !dbg !1635
  store i32 %0, i32* %i, align 4, !dbg !1634
  %f = bitcast %union.anon.0.0* %rep to float*, !dbg !1636
  %1 = load float, float* %f, align 4, !dbg !1636
  ret float %1, !dbg !1637
}

; Function Attrs: noinline nounwind
define dso_local arm_aapcscc float @__gnu_h2f_ieee(i16 noundef zeroext %a) #0 !dbg !1638 {
entry:
  %a.addr = alloca i16, align 2
  store i16 %a, i16* %a.addr, align 2
  %0 = load i16, i16* %a.addr, align 2, !dbg !1639
  %call = call arm_aapcscc float @__extendhfsf2(i16 noundef zeroext %0) #4, !dbg !1640
  ret float %call, !dbg !1641
}

; Function Attrs: noinline nounwind
define dso_local arm_aapcscc double @__extendsfdf2(float noundef %a) #0 !dbg !1642 {
entry:
  %a.addr = alloca float, align 4
  store float %a, float* %a.addr, align 4
  %0 = load float, float* %a.addr, align 4, !dbg !1643
  %call = call arm_aapcscc double @__extendXfYf2__.16(float noundef %0) #4, !dbg !1644
  ret double %call, !dbg !1645
}

; Function Attrs: noinline nounwind
define internal arm_aapcscc double @__extendXfYf2__.16(float noundef %a) #0 !dbg !1646 {
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
  store i32 32, i32* %srcBits, align 4, !dbg !1647
  store i32 8, i32* %srcExpBits, align 4, !dbg !1648
  store i32 255, i32* %srcInfExp, align 4, !dbg !1649
  store i32 127, i32* %srcExpBias, align 4, !dbg !1650
  store i32 8388608, i32* %srcMinNormal, align 4, !dbg !1651
  store i32 2139095040, i32* %srcInfinity, align 4, !dbg !1652
  store i32 -2147483648, i32* %srcSignMask, align 4, !dbg !1653
  store i32 2147483647, i32* %srcAbsMask, align 4, !dbg !1654
  store i32 4194304, i32* %srcQNaN, align 4, !dbg !1655
  store i32 4194303, i32* %srcNaNCode, align 4, !dbg !1656
  store i32 64, i32* %dstBits, align 4, !dbg !1657
  store i32 11, i32* %dstExpBits, align 4, !dbg !1658
  store i32 2047, i32* %dstInfExp, align 4, !dbg !1659
  store i32 1023, i32* %dstExpBias, align 4, !dbg !1660
  store i64 4503599627370496, i64* %dstMinNormal, align 8, !dbg !1661
  %0 = load float, float* %a.addr, align 4, !dbg !1662
  %call = call arm_aapcscc i32 @srcToRep.17(float noundef %0) #4, !dbg !1663
  store i32 %call, i32* %aRep, align 4, !dbg !1664
  %1 = load i32, i32* %aRep, align 4, !dbg !1665
  %and = and i32 %1, 2147483647, !dbg !1666
  store i32 %and, i32* %aAbs, align 4, !dbg !1667
  %2 = load i32, i32* %aRep, align 4, !dbg !1668
  %and1 = and i32 %2, -2147483648, !dbg !1669
  store i32 %and1, i32* %sign, align 4, !dbg !1670
  %3 = load i32, i32* %aAbs, align 4, !dbg !1671
  %sub = sub i32 %3, 8388608, !dbg !1672
  %cmp = icmp ult i32 %sub, 2130706432, !dbg !1673
  br i1 %cmp, label %if.then, label %if.else, !dbg !1674

if.then:                                          ; preds = %entry
  %4 = load i32, i32* %aAbs, align 4, !dbg !1675
  %conv = zext i32 %4 to i64, !dbg !1676
  %shl = shl i64 %conv, 29, !dbg !1677
  store i64 %shl, i64* %absResult, align 8, !dbg !1678
  %5 = load i64, i64* %absResult, align 8, !dbg !1679
  %add = add i64 %5, 4035225266123964416, !dbg !1679
  store i64 %add, i64* %absResult, align 8, !dbg !1679
  br label %if.end25, !dbg !1680

if.else:                                          ; preds = %entry
  %6 = load i32, i32* %aAbs, align 4, !dbg !1681
  %cmp2 = icmp uge i32 %6, 2139095040, !dbg !1682
  br i1 %cmp2, label %if.then4, label %if.else12, !dbg !1681

if.then4:                                         ; preds = %if.else
  store i64 9218868437227405312, i64* %absResult, align 8, !dbg !1683
  %7 = load i32, i32* %aAbs, align 4, !dbg !1684
  %and5 = and i32 %7, 4194304, !dbg !1685
  %conv6 = zext i32 %and5 to i64, !dbg !1686
  %shl7 = shl i64 %conv6, 29, !dbg !1687
  %8 = load i64, i64* %absResult, align 8, !dbg !1688
  %or = or i64 %8, %shl7, !dbg !1688
  store i64 %or, i64* %absResult, align 8, !dbg !1688
  %9 = load i32, i32* %aAbs, align 4, !dbg !1689
  %and8 = and i32 %9, 4194303, !dbg !1690
  %conv9 = zext i32 %and8 to i64, !dbg !1691
  %shl10 = shl i64 %conv9, 29, !dbg !1692
  %10 = load i64, i64* %absResult, align 8, !dbg !1693
  %or11 = or i64 %10, %shl10, !dbg !1693
  store i64 %or11, i64* %absResult, align 8, !dbg !1693
  br label %if.end24, !dbg !1694

if.else12:                                        ; preds = %if.else
  %11 = load i32, i32* %aAbs, align 4, !dbg !1695
  %tobool = icmp ne i32 %11, 0, !dbg !1695
  br i1 %tobool, label %if.then13, label %if.else23, !dbg !1695

if.then13:                                        ; preds = %if.else12
  %12 = load i32, i32* %aAbs, align 4, !dbg !1696
  %13 = call i32 @llvm.ctlz.i32(i32 %12, i1 false), !dbg !1697
  %sub14 = sub nsw i32 %13, 8, !dbg !1698
  store i32 %sub14, i32* %scale, align 4, !dbg !1699
  %14 = load i32, i32* %aAbs, align 4, !dbg !1700
  %conv15 = zext i32 %14 to i64, !dbg !1701
  %15 = load i32, i32* %scale, align 4, !dbg !1702
  %add16 = add nsw i32 29, %15, !dbg !1703
  %sh_prom = zext i32 %add16 to i64, !dbg !1704
  %shl17 = shl i64 %conv15, %sh_prom, !dbg !1704
  store i64 %shl17, i64* %absResult, align 8, !dbg !1705
  %16 = load i64, i64* %absResult, align 8, !dbg !1706
  %xor = xor i64 %16, 4503599627370496, !dbg !1706
  store i64 %xor, i64* %absResult, align 8, !dbg !1706
  %17 = load i32, i32* %scale, align 4, !dbg !1707
  %sub18 = sub nsw i32 896, %17, !dbg !1708
  %add19 = add nsw i32 %sub18, 1, !dbg !1709
  store i32 %add19, i32* %resultExponent, align 4, !dbg !1710
  %18 = load i32, i32* %resultExponent, align 4, !dbg !1711
  %conv20 = sext i32 %18 to i64, !dbg !1712
  %shl21 = shl i64 %conv20, 52, !dbg !1713
  %19 = load i64, i64* %absResult, align 8, !dbg !1714
  %or22 = or i64 %19, %shl21, !dbg !1714
  store i64 %or22, i64* %absResult, align 8, !dbg !1714
  br label %if.end, !dbg !1715

if.else23:                                        ; preds = %if.else12
  store i64 0, i64* %absResult, align 8, !dbg !1716
  br label %if.end

if.end:                                           ; preds = %if.else23, %if.then13
  br label %if.end24

if.end24:                                         ; preds = %if.end, %if.then4
  br label %if.end25

if.end25:                                         ; preds = %if.end24, %if.then
  %20 = load i64, i64* %absResult, align 8, !dbg !1717
  %21 = load i32, i32* %sign, align 4, !dbg !1718
  %conv26 = zext i32 %21 to i64, !dbg !1719
  %shl27 = shl i64 %conv26, 32, !dbg !1720
  %or28 = or i64 %20, %shl27, !dbg !1721
  store i64 %or28, i64* %result, align 8, !dbg !1722
  %22 = load i64, i64* %result, align 8, !dbg !1723
  %call29 = call arm_aapcscc double @dstFromRep.18(i64 noundef %22) #4, !dbg !1724
  ret double %call29, !dbg !1725
}

; Function Attrs: noinline nounwind
define internal arm_aapcscc i32 @srcToRep.17(float noundef %x) #0 !dbg !1726 {
entry:
  %x.addr = alloca float, align 4
  %rep = alloca %union.anon.0.0, align 4
  store float %x, float* %x.addr, align 4
  %f = bitcast %union.anon.0.0* %rep to float*, !dbg !1727
  %0 = load float, float* %x.addr, align 4, !dbg !1728
  store float %0, float* %f, align 4, !dbg !1727
  %i = bitcast %union.anon.0.0* %rep to i32*, !dbg !1729
  %1 = load i32, i32* %i, align 4, !dbg !1729
  ret i32 %1, !dbg !1730
}

; Function Attrs: noinline nounwind
define internal arm_aapcscc double @dstFromRep.18(i64 noundef %x) #0 !dbg !1731 {
entry:
  %x.addr = alloca i64, align 8
  %rep = alloca %union.anon.0, align 8
  store i64 %x, i64* %x.addr, align 8
  %i = bitcast %union.anon.0* %rep to i64*, !dbg !1732
  %0 = load i64, i64* %x.addr, align 8, !dbg !1733
  store i64 %0, i64* %i, align 8, !dbg !1732
  %f = bitcast %union.anon.0* %rep to double*, !dbg !1734
  %1 = load double, double* %f, align 8, !dbg !1734
  ret double %1, !dbg !1735
}

; Function Attrs: noinline nounwind
define dso_local arm_aapcscc i64 @__fixdfdi(double noundef %a) #0 !dbg !1736 {
entry:
  %retval = alloca i64, align 8
  %a.addr = alloca double, align 8
  store double %a, double* %a.addr, align 8
  %0 = load double, double* %a.addr, align 8, !dbg !1737
  %cmp = fcmp olt double %0, 0.000000e+00, !dbg !1738
  br i1 %cmp, label %if.then, label %if.end, !dbg !1737

if.then:                                          ; preds = %entry
  %1 = load double, double* %a.addr, align 8, !dbg !1739
  %fneg = fneg double %1, !dbg !1740
  %call = call arm_aapcscc i64 @__fixunsdfdi(double noundef %fneg) #4, !dbg !1741
  %sub = sub i64 0, %call, !dbg !1742
  store i64 %sub, i64* %retval, align 8, !dbg !1743
  br label %return, !dbg !1743

if.end:                                           ; preds = %entry
  %2 = load double, double* %a.addr, align 8, !dbg !1744
  %call1 = call arm_aapcscc i64 @__fixunsdfdi(double noundef %2) #4, !dbg !1745
  store i64 %call1, i64* %retval, align 8, !dbg !1746
  br label %return, !dbg !1746

return:                                           ; preds = %if.end, %if.then
  %3 = load i64, i64* %retval, align 8, !dbg !1747
  ret i64 %3, !dbg !1747
}

; Function Attrs: noinline nounwind
define dso_local arm_aapcscc i32 @__fixdfsi(double noundef %a) #0 !dbg !1748 {
entry:
  %a.addr = alloca double, align 8
  store double %a, double* %a.addr, align 8
  %0 = load double, double* %a.addr, align 8, !dbg !1749
  %call = call arm_aapcscc i32 @__fixint(double noundef %0) #4, !dbg !1750
  ret i32 %call, !dbg !1751
}

; Function Attrs: noinline nounwind
define internal arm_aapcscc i32 @__fixint(double noundef %a) #0 !dbg !1752 {
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
  store i32 2147483647, i32* %fixint_max, align 4, !dbg !1754
  store i32 -2147483648, i32* %fixint_min, align 4, !dbg !1755
  %0 = load double, double* %a.addr, align 8, !dbg !1756
  %call = call arm_aapcscc i64 @toRep.19(double noundef %0) #4, !dbg !1757
  store i64 %call, i64* %aRep, align 8, !dbg !1758
  %1 = load i64, i64* %aRep, align 8, !dbg !1759
  %and = and i64 %1, 9223372036854775807, !dbg !1760
  store i64 %and, i64* %aAbs, align 8, !dbg !1761
  %2 = load i64, i64* %aRep, align 8, !dbg !1762
  %and1 = and i64 %2, -9223372036854775808, !dbg !1763
  %tobool = icmp ne i64 %and1, 0, !dbg !1762
  %3 = zext i1 %tobool to i64, !dbg !1762
  %cond = select i1 %tobool, i32 -1, i32 1, !dbg !1762
  store i32 %cond, i32* %sign, align 4, !dbg !1764
  %4 = load i64, i64* %aAbs, align 8, !dbg !1765
  %shr = lshr i64 %4, 52, !dbg !1766
  %sub = sub i64 %shr, 1023, !dbg !1767
  %conv = trunc i64 %sub to i32, !dbg !1768
  store i32 %conv, i32* %exponent, align 4, !dbg !1769
  %5 = load i64, i64* %aAbs, align 8, !dbg !1770
  %and2 = and i64 %5, 4503599627370495, !dbg !1771
  %or = or i64 %and2, 4503599627370496, !dbg !1772
  store i64 %or, i64* %significand, align 8, !dbg !1773
  %6 = load i32, i32* %exponent, align 4, !dbg !1774
  %cmp = icmp slt i32 %6, 0, !dbg !1775
  br i1 %cmp, label %if.then, label %if.end, !dbg !1774

if.then:                                          ; preds = %entry
  store i32 0, i32* %retval, align 4, !dbg !1776
  br label %return, !dbg !1776

if.end:                                           ; preds = %entry
  %7 = load i32, i32* %exponent, align 4, !dbg !1777
  %cmp4 = icmp uge i32 %7, 32, !dbg !1778
  br i1 %cmp4, label %if.then6, label %if.end10, !dbg !1779

if.then6:                                         ; preds = %if.end
  %8 = load i32, i32* %sign, align 4, !dbg !1780
  %cmp7 = icmp eq i32 %8, 1, !dbg !1781
  %9 = zext i1 %cmp7 to i64, !dbg !1780
  %cond9 = select i1 %cmp7, i32 2147483647, i32 -2147483648, !dbg !1780
  store i32 %cond9, i32* %retval, align 4, !dbg !1782
  br label %return, !dbg !1782

if.end10:                                         ; preds = %if.end
  %10 = load i32, i32* %exponent, align 4, !dbg !1783
  %cmp11 = icmp slt i32 %10, 52, !dbg !1784
  br i1 %cmp11, label %if.then13, label %if.else, !dbg !1783

if.then13:                                        ; preds = %if.end10
  %11 = load i32, i32* %sign, align 4, !dbg !1785
  %conv14 = sext i32 %11 to i64, !dbg !1785
  %12 = load i64, i64* %significand, align 8, !dbg !1786
  %13 = load i32, i32* %exponent, align 4, !dbg !1787
  %sub15 = sub nsw i32 52, %13, !dbg !1788
  %sh_prom = zext i32 %sub15 to i64, !dbg !1789
  %shr16 = lshr i64 %12, %sh_prom, !dbg !1789
  %mul = mul i64 %conv14, %shr16, !dbg !1790
  %conv17 = trunc i64 %mul to i32, !dbg !1785
  store i32 %conv17, i32* %retval, align 4, !dbg !1791
  br label %return, !dbg !1791

if.else:                                          ; preds = %if.end10
  %14 = load i32, i32* %sign, align 4, !dbg !1792
  %15 = load i64, i64* %significand, align 8, !dbg !1793
  %conv18 = trunc i64 %15 to i32, !dbg !1794
  %16 = load i32, i32* %exponent, align 4, !dbg !1795
  %sub19 = sub nsw i32 %16, 52, !dbg !1796
  %shl = shl i32 %conv18, %sub19, !dbg !1797
  %mul20 = mul nsw i32 %14, %shl, !dbg !1798
  store i32 %mul20, i32* %retval, align 4, !dbg !1799
  br label %return, !dbg !1799

return:                                           ; preds = %if.else, %if.then13, %if.then6, %if.then
  %17 = load i32, i32* %retval, align 4, !dbg !1800
  ret i32 %17, !dbg !1800
}

; Function Attrs: noinline nounwind
define internal arm_aapcscc i64 @toRep.19(double noundef %x) #0 !dbg !1801 {
entry:
  %x.addr = alloca double, align 8
  %rep = alloca %union.anon.0, align 8
  store double %x, double* %x.addr, align 8
  %f = bitcast %union.anon.0* %rep to double*, !dbg !1802
  %0 = load double, double* %x.addr, align 8, !dbg !1803
  store double %0, double* %f, align 8, !dbg !1802
  %i = bitcast %union.anon.0* %rep to i64*, !dbg !1804
  %1 = load i64, i64* %i, align 8, !dbg !1804
  ret i64 %1, !dbg !1805
}

; Function Attrs: noinline nounwind
define dso_local arm_aapcscc i64 @__fixsfdi(float noundef %a) #0 !dbg !1806 {
entry:
  %retval = alloca i64, align 8
  %a.addr = alloca float, align 4
  store float %a, float* %a.addr, align 4
  %0 = load float, float* %a.addr, align 4, !dbg !1807
  %cmp = fcmp olt float %0, 0.000000e+00, !dbg !1808
  br i1 %cmp, label %if.then, label %if.end, !dbg !1807

if.then:                                          ; preds = %entry
  %1 = load float, float* %a.addr, align 4, !dbg !1809
  %fneg = fneg float %1, !dbg !1810
  %call = call arm_aapcscc i64 @__fixunssfdi(float noundef %fneg) #4, !dbg !1811
  %sub = sub i64 0, %call, !dbg !1812
  store i64 %sub, i64* %retval, align 8, !dbg !1813
  br label %return, !dbg !1813

if.end:                                           ; preds = %entry
  %2 = load float, float* %a.addr, align 4, !dbg !1814
  %call1 = call arm_aapcscc i64 @__fixunssfdi(float noundef %2) #4, !dbg !1815
  store i64 %call1, i64* %retval, align 8, !dbg !1816
  br label %return, !dbg !1816

return:                                           ; preds = %if.end, %if.then
  %3 = load i64, i64* %retval, align 8, !dbg !1817
  ret i64 %3, !dbg !1817
}

; Function Attrs: noinline nounwind
define dso_local arm_aapcscc i32 @__fixsfsi(float noundef %a) #0 !dbg !1818 {
entry:
  %a.addr = alloca float, align 4
  store float %a, float* %a.addr, align 4
  %0 = load float, float* %a.addr, align 4, !dbg !1819
  %call = call arm_aapcscc i32 @__fixint.20(float noundef %0) #4, !dbg !1820
  ret i32 %call, !dbg !1821
}

; Function Attrs: noinline nounwind
define internal arm_aapcscc i32 @__fixint.20(float noundef %a) #0 !dbg !1822 {
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
  store i32 2147483647, i32* %fixint_max, align 4, !dbg !1823
  store i32 -2147483648, i32* %fixint_min, align 4, !dbg !1824
  %0 = load float, float* %a.addr, align 4, !dbg !1825
  %call = call arm_aapcscc i32 @toRep.21(float noundef %0) #4, !dbg !1826
  store i32 %call, i32* %aRep, align 4, !dbg !1827
  %1 = load i32, i32* %aRep, align 4, !dbg !1828
  %and = and i32 %1, 2147483647, !dbg !1829
  store i32 %and, i32* %aAbs, align 4, !dbg !1830
  %2 = load i32, i32* %aRep, align 4, !dbg !1831
  %and1 = and i32 %2, -2147483648, !dbg !1832
  %tobool = icmp ne i32 %and1, 0, !dbg !1831
  %3 = zext i1 %tobool to i64, !dbg !1831
  %cond = select i1 %tobool, i32 -1, i32 1, !dbg !1831
  store i32 %cond, i32* %sign, align 4, !dbg !1833
  %4 = load i32, i32* %aAbs, align 4, !dbg !1834
  %shr = lshr i32 %4, 23, !dbg !1835
  %sub = sub i32 %shr, 127, !dbg !1836
  store i32 %sub, i32* %exponent, align 4, !dbg !1837
  %5 = load i32, i32* %aAbs, align 4, !dbg !1838
  %and2 = and i32 %5, 8388607, !dbg !1839
  %or = or i32 %and2, 8388608, !dbg !1840
  store i32 %or, i32* %significand, align 4, !dbg !1841
  %6 = load i32, i32* %exponent, align 4, !dbg !1842
  %cmp = icmp slt i32 %6, 0, !dbg !1843
  br i1 %cmp, label %if.then, label %if.end, !dbg !1842

if.then:                                          ; preds = %entry
  store i32 0, i32* %retval, align 4, !dbg !1844
  br label %return, !dbg !1844

if.end:                                           ; preds = %entry
  %7 = load i32, i32* %exponent, align 4, !dbg !1845
  %cmp3 = icmp uge i32 %7, 32, !dbg !1846
  br i1 %cmp3, label %if.then4, label %if.end7, !dbg !1847

if.then4:                                         ; preds = %if.end
  %8 = load i32, i32* %sign, align 4, !dbg !1848
  %cmp5 = icmp eq i32 %8, 1, !dbg !1849
  %9 = zext i1 %cmp5 to i64, !dbg !1848
  %cond6 = select i1 %cmp5, i32 2147483647, i32 -2147483648, !dbg !1848
  store i32 %cond6, i32* %retval, align 4, !dbg !1850
  br label %return, !dbg !1850

if.end7:                                          ; preds = %if.end
  %10 = load i32, i32* %exponent, align 4, !dbg !1851
  %cmp8 = icmp slt i32 %10, 23, !dbg !1852
  br i1 %cmp8, label %if.then9, label %if.else, !dbg !1851

if.then9:                                         ; preds = %if.end7
  %11 = load i32, i32* %sign, align 4, !dbg !1853
  %12 = load i32, i32* %significand, align 4, !dbg !1854
  %13 = load i32, i32* %exponent, align 4, !dbg !1855
  %sub10 = sub nsw i32 23, %13, !dbg !1856
  %shr11 = lshr i32 %12, %sub10, !dbg !1857
  %mul = mul i32 %11, %shr11, !dbg !1858
  store i32 %mul, i32* %retval, align 4, !dbg !1859
  br label %return, !dbg !1859

if.else:                                          ; preds = %if.end7
  %14 = load i32, i32* %sign, align 4, !dbg !1860
  %15 = load i32, i32* %significand, align 4, !dbg !1861
  %16 = load i32, i32* %exponent, align 4, !dbg !1862
  %sub12 = sub nsw i32 %16, 23, !dbg !1863
  %shl = shl i32 %15, %sub12, !dbg !1864
  %mul13 = mul nsw i32 %14, %shl, !dbg !1865
  store i32 %mul13, i32* %retval, align 4, !dbg !1866
  br label %return, !dbg !1866

return:                                           ; preds = %if.else, %if.then9, %if.then4, %if.then
  %17 = load i32, i32* %retval, align 4, !dbg !1867
  ret i32 %17, !dbg !1867
}

; Function Attrs: noinline nounwind
define internal arm_aapcscc i32 @toRep.21(float noundef %x) #0 !dbg !1868 {
entry:
  %x.addr = alloca float, align 4
  %rep = alloca %union.anon.0.0, align 4
  store float %x, float* %x.addr, align 4
  %f = bitcast %union.anon.0.0* %rep to float*, !dbg !1869
  %0 = load float, float* %x.addr, align 4, !dbg !1870
  store float %0, float* %f, align 4, !dbg !1869
  %i = bitcast %union.anon.0.0* %rep to i32*, !dbg !1871
  %1 = load i32, i32* %i, align 4, !dbg !1871
  ret i32 %1, !dbg !1872
}

; Function Attrs: noinline nounwind
define dso_local arm_aapcscc i64 @__fixunsdfdi(double noundef %a) #0 !dbg !1873 {
entry:
  %retval = alloca i64, align 8
  %a.addr = alloca double, align 8
  %high = alloca i32, align 4
  %low = alloca i32, align 4
  store double %a, double* %a.addr, align 8
  %0 = load double, double* %a.addr, align 8, !dbg !1874
  %cmp = fcmp ole double %0, 0.000000e+00, !dbg !1875
  br i1 %cmp, label %if.then, label %if.end, !dbg !1874

if.then:                                          ; preds = %entry
  store i64 0, i64* %retval, align 8, !dbg !1876
  br label %return, !dbg !1876

if.end:                                           ; preds = %entry
  %1 = load double, double* %a.addr, align 8, !dbg !1877
  %div = fdiv double %1, 0x41F0000000000000, !dbg !1878
  %conv = fptoui double %div to i32, !dbg !1877
  store i32 %conv, i32* %high, align 4, !dbg !1879
  %2 = load double, double* %a.addr, align 8, !dbg !1880
  %3 = load i32, i32* %high, align 4, !dbg !1881
  %conv1 = uitofp i32 %3 to double, !dbg !1882
  %neg = fneg double %conv1, !dbg !1883
  %4 = call double @llvm.fmuladd.f64(double %neg, double 0x41F0000000000000, double %2), !dbg !1883
  %conv2 = fptoui double %4 to i32, !dbg !1880
  store i32 %conv2, i32* %low, align 4, !dbg !1884
  %5 = load i32, i32* %high, align 4, !dbg !1885
  %conv3 = zext i32 %5 to i64, !dbg !1886
  %shl = shl i64 %conv3, 32, !dbg !1887
  %6 = load i32, i32* %low, align 4, !dbg !1888
  %conv4 = zext i32 %6 to i64, !dbg !1888
  %or = or i64 %shl, %conv4, !dbg !1889
  store i64 %or, i64* %retval, align 8, !dbg !1890
  br label %return, !dbg !1890

return:                                           ; preds = %if.end, %if.then
  %7 = load i64, i64* %retval, align 8, !dbg !1891
  ret i64 %7, !dbg !1891
}

; Function Attrs: nofree nosync nounwind readnone speculatable willreturn
declare double @llvm.fmuladd.f64(double, double, double) #1

; Function Attrs: noinline nounwind
define dso_local arm_aapcscc i32 @__fixunsdfsi(double noundef %a) #0 !dbg !1892 {
entry:
  %a.addr = alloca double, align 8
  store double %a, double* %a.addr, align 8
  %0 = load double, double* %a.addr, align 8, !dbg !1893
  %call = call arm_aapcscc i32 @__fixuint(double noundef %0) #4, !dbg !1894
  ret i32 %call, !dbg !1895
}

; Function Attrs: noinline nounwind
define internal arm_aapcscc i32 @__fixuint(double noundef %a) #0 !dbg !1896 {
entry:
  %retval = alloca i32, align 4
  %a.addr = alloca double, align 8
  %aRep = alloca i64, align 8
  %aAbs = alloca i64, align 8
  %sign = alloca i32, align 4
  %exponent = alloca i32, align 4
  %significand = alloca i64, align 8
  store double %a, double* %a.addr, align 8
  %0 = load double, double* %a.addr, align 8, !dbg !1898
  %call = call arm_aapcscc i64 @toRep.24(double noundef %0) #4, !dbg !1899
  store i64 %call, i64* %aRep, align 8, !dbg !1900
  %1 = load i64, i64* %aRep, align 8, !dbg !1901
  %and = and i64 %1, 9223372036854775807, !dbg !1902
  store i64 %and, i64* %aAbs, align 8, !dbg !1903
  %2 = load i64, i64* %aRep, align 8, !dbg !1904
  %and1 = and i64 %2, -9223372036854775808, !dbg !1905
  %tobool = icmp ne i64 %and1, 0, !dbg !1904
  %3 = zext i1 %tobool to i64, !dbg !1904
  %cond = select i1 %tobool, i32 -1, i32 1, !dbg !1904
  store i32 %cond, i32* %sign, align 4, !dbg !1906
  %4 = load i64, i64* %aAbs, align 8, !dbg !1907
  %shr = lshr i64 %4, 52, !dbg !1908
  %sub = sub i64 %shr, 1023, !dbg !1909
  %conv = trunc i64 %sub to i32, !dbg !1910
  store i32 %conv, i32* %exponent, align 4, !dbg !1911
  %5 = load i64, i64* %aAbs, align 8, !dbg !1912
  %and2 = and i64 %5, 4503599627370495, !dbg !1913
  %or = or i64 %and2, 4503599627370496, !dbg !1914
  store i64 %or, i64* %significand, align 8, !dbg !1915
  %6 = load i32, i32* %sign, align 4, !dbg !1916
  %cmp = icmp eq i32 %6, -1, !dbg !1917
  br i1 %cmp, label %if.then, label %lor.lhs.false, !dbg !1918

lor.lhs.false:                                    ; preds = %entry
  %7 = load i32, i32* %exponent, align 4, !dbg !1919
  %cmp4 = icmp slt i32 %7, 0, !dbg !1920
  br i1 %cmp4, label %if.then, label %if.end, !dbg !1916

if.then:                                          ; preds = %lor.lhs.false, %entry
  store i32 0, i32* %retval, align 4, !dbg !1921
  br label %return, !dbg !1921

if.end:                                           ; preds = %lor.lhs.false
  %8 = load i32, i32* %exponent, align 4, !dbg !1922
  %cmp6 = icmp uge i32 %8, 32, !dbg !1923
  br i1 %cmp6, label %if.then8, label %if.end9, !dbg !1924

if.then8:                                         ; preds = %if.end
  store i32 -1, i32* %retval, align 4, !dbg !1925
  br label %return, !dbg !1925

if.end9:                                          ; preds = %if.end
  %9 = load i32, i32* %exponent, align 4, !dbg !1926
  %cmp10 = icmp slt i32 %9, 52, !dbg !1927
  br i1 %cmp10, label %if.then12, label %if.else, !dbg !1926

if.then12:                                        ; preds = %if.end9
  %10 = load i64, i64* %significand, align 8, !dbg !1928
  %11 = load i32, i32* %exponent, align 4, !dbg !1929
  %sub13 = sub nsw i32 52, %11, !dbg !1930
  %sh_prom = zext i32 %sub13 to i64, !dbg !1931
  %shr14 = lshr i64 %10, %sh_prom, !dbg !1931
  %conv15 = trunc i64 %shr14 to i32, !dbg !1928
  store i32 %conv15, i32* %retval, align 4, !dbg !1932
  br label %return, !dbg !1932

if.else:                                          ; preds = %if.end9
  %12 = load i64, i64* %significand, align 8, !dbg !1933
  %conv16 = trunc i64 %12 to i32, !dbg !1934
  %13 = load i32, i32* %exponent, align 4, !dbg !1935
  %sub17 = sub nsw i32 %13, 52, !dbg !1936
  %shl = shl i32 %conv16, %sub17, !dbg !1937
  store i32 %shl, i32* %retval, align 4, !dbg !1938
  br label %return, !dbg !1938

return:                                           ; preds = %if.else, %if.then12, %if.then8, %if.then
  %14 = load i32, i32* %retval, align 4, !dbg !1939
  ret i32 %14, !dbg !1939
}

; Function Attrs: noinline nounwind
define internal arm_aapcscc i64 @toRep.24(double noundef %x) #0 !dbg !1940 {
entry:
  %x.addr = alloca double, align 8
  %rep = alloca %union.anon.0, align 8
  store double %x, double* %x.addr, align 8
  %f = bitcast %union.anon.0* %rep to double*, !dbg !1941
  %0 = load double, double* %x.addr, align 8, !dbg !1942
  store double %0, double* %f, align 8, !dbg !1941
  %i = bitcast %union.anon.0* %rep to i64*, !dbg !1943
  %1 = load i64, i64* %i, align 8, !dbg !1943
  ret i64 %1, !dbg !1944
}

; Function Attrs: noinline nounwind
define dso_local arm_aapcscc i64 @__fixunssfdi(float noundef %a) #0 !dbg !1945 {
entry:
  %retval = alloca i64, align 8
  %a.addr = alloca float, align 4
  %da = alloca double, align 8
  %high = alloca i32, align 4
  %low = alloca i32, align 4
  store float %a, float* %a.addr, align 4
  %0 = load float, float* %a.addr, align 4, !dbg !1946
  %cmp = fcmp ole float %0, 0.000000e+00, !dbg !1947
  br i1 %cmp, label %if.then, label %if.end, !dbg !1946

if.then:                                          ; preds = %entry
  store i64 0, i64* %retval, align 8, !dbg !1948
  br label %return, !dbg !1948

if.end:                                           ; preds = %entry
  %1 = load float, float* %a.addr, align 4, !dbg !1949
  %conv = fpext float %1 to double, !dbg !1949
  store double %conv, double* %da, align 8, !dbg !1950
  %2 = load double, double* %da, align 8, !dbg !1951
  %div = fdiv double %2, 0x41F0000000000000, !dbg !1952
  %conv1 = fptoui double %div to i32, !dbg !1951
  store i32 %conv1, i32* %high, align 4, !dbg !1953
  %3 = load double, double* %da, align 8, !dbg !1954
  %4 = load i32, i32* %high, align 4, !dbg !1955
  %conv2 = uitofp i32 %4 to double, !dbg !1956
  %neg = fneg double %conv2, !dbg !1957
  %5 = call double @llvm.fmuladd.f64(double %neg, double 0x41F0000000000000, double %3), !dbg !1957
  %conv3 = fptoui double %5 to i32, !dbg !1954
  store i32 %conv3, i32* %low, align 4, !dbg !1958
  %6 = load i32, i32* %high, align 4, !dbg !1959
  %conv4 = zext i32 %6 to i64, !dbg !1960
  %shl = shl i64 %conv4, 32, !dbg !1961
  %7 = load i32, i32* %low, align 4, !dbg !1962
  %conv5 = zext i32 %7 to i64, !dbg !1962
  %or = or i64 %shl, %conv5, !dbg !1963
  store i64 %or, i64* %retval, align 8, !dbg !1964
  br label %return, !dbg !1964

return:                                           ; preds = %if.end, %if.then
  %8 = load i64, i64* %retval, align 8, !dbg !1965
  ret i64 %8, !dbg !1965
}

; Function Attrs: noinline nounwind
define dso_local arm_aapcscc i32 @__fixunssfsi(float noundef %a) #0 !dbg !1966 {
entry:
  %a.addr = alloca float, align 4
  store float %a, float* %a.addr, align 4
  %0 = load float, float* %a.addr, align 4, !dbg !1967
  %call = call arm_aapcscc i32 @__fixuint.27(float noundef %0) #4, !dbg !1968
  ret i32 %call, !dbg !1969
}

; Function Attrs: noinline nounwind
define internal arm_aapcscc i32 @__fixuint.27(float noundef %a) #0 !dbg !1970 {
entry:
  %retval = alloca i32, align 4
  %a.addr = alloca float, align 4
  %aRep = alloca i32, align 4
  %aAbs = alloca i32, align 4
  %sign = alloca i32, align 4
  %exponent = alloca i32, align 4
  %significand = alloca i32, align 4
  store float %a, float* %a.addr, align 4
  %0 = load float, float* %a.addr, align 4, !dbg !1971
  %call = call arm_aapcscc i32 @toRep.28(float noundef %0) #4, !dbg !1972
  store i32 %call, i32* %aRep, align 4, !dbg !1973
  %1 = load i32, i32* %aRep, align 4, !dbg !1974
  %and = and i32 %1, 2147483647, !dbg !1975
  store i32 %and, i32* %aAbs, align 4, !dbg !1976
  %2 = load i32, i32* %aRep, align 4, !dbg !1977
  %and1 = and i32 %2, -2147483648, !dbg !1978
  %tobool = icmp ne i32 %and1, 0, !dbg !1977
  %3 = zext i1 %tobool to i64, !dbg !1977
  %cond = select i1 %tobool, i32 -1, i32 1, !dbg !1977
  store i32 %cond, i32* %sign, align 4, !dbg !1979
  %4 = load i32, i32* %aAbs, align 4, !dbg !1980
  %shr = lshr i32 %4, 23, !dbg !1981
  %sub = sub i32 %shr, 127, !dbg !1982
  store i32 %sub, i32* %exponent, align 4, !dbg !1983
  %5 = load i32, i32* %aAbs, align 4, !dbg !1984
  %and2 = and i32 %5, 8388607, !dbg !1985
  %or = or i32 %and2, 8388608, !dbg !1986
  store i32 %or, i32* %significand, align 4, !dbg !1987
  %6 = load i32, i32* %sign, align 4, !dbg !1988
  %cmp = icmp eq i32 %6, -1, !dbg !1989
  br i1 %cmp, label %if.then, label %lor.lhs.false, !dbg !1990

lor.lhs.false:                                    ; preds = %entry
  %7 = load i32, i32* %exponent, align 4, !dbg !1991
  %cmp3 = icmp slt i32 %7, 0, !dbg !1992
  br i1 %cmp3, label %if.then, label %if.end, !dbg !1988

if.then:                                          ; preds = %lor.lhs.false, %entry
  store i32 0, i32* %retval, align 4, !dbg !1993
  br label %return, !dbg !1993

if.end:                                           ; preds = %lor.lhs.false
  %8 = load i32, i32* %exponent, align 4, !dbg !1994
  %cmp4 = icmp uge i32 %8, 32, !dbg !1995
  br i1 %cmp4, label %if.then5, label %if.end6, !dbg !1996

if.then5:                                         ; preds = %if.end
  store i32 -1, i32* %retval, align 4, !dbg !1997
  br label %return, !dbg !1997

if.end6:                                          ; preds = %if.end
  %9 = load i32, i32* %exponent, align 4, !dbg !1998
  %cmp7 = icmp slt i32 %9, 23, !dbg !1999
  br i1 %cmp7, label %if.then8, label %if.else, !dbg !1998

if.then8:                                         ; preds = %if.end6
  %10 = load i32, i32* %significand, align 4, !dbg !2000
  %11 = load i32, i32* %exponent, align 4, !dbg !2001
  %sub9 = sub nsw i32 23, %11, !dbg !2002
  %shr10 = lshr i32 %10, %sub9, !dbg !2003
  store i32 %shr10, i32* %retval, align 4, !dbg !2004
  br label %return, !dbg !2004

if.else:                                          ; preds = %if.end6
  %12 = load i32, i32* %significand, align 4, !dbg !2005
  %13 = load i32, i32* %exponent, align 4, !dbg !2006
  %sub11 = sub nsw i32 %13, 23, !dbg !2007
  %shl = shl i32 %12, %sub11, !dbg !2008
  store i32 %shl, i32* %retval, align 4, !dbg !2009
  br label %return, !dbg !2009

return:                                           ; preds = %if.else, %if.then8, %if.then5, %if.then
  %14 = load i32, i32* %retval, align 4, !dbg !2010
  ret i32 %14, !dbg !2010
}

; Function Attrs: noinline nounwind
define internal arm_aapcscc i32 @toRep.28(float noundef %x) #0 !dbg !2011 {
entry:
  %x.addr = alloca float, align 4
  %rep = alloca %union.anon.0.0, align 4
  store float %x, float* %x.addr, align 4
  %f = bitcast %union.anon.0.0* %rep to float*, !dbg !2012
  %0 = load float, float* %x.addr, align 4, !dbg !2013
  store float %0, float* %f, align 4, !dbg !2012
  %i = bitcast %union.anon.0.0* %rep to i32*, !dbg !2014
  %1 = load i32, i32* %i, align 4, !dbg !2014
  ret i32 %1, !dbg !2015
}

; Function Attrs: noinline nounwind
define dso_local arm_aapcscc i64 @__fixunsxfdi(double noundef %a) #0 !dbg !2016 {
entry:
  %retval = alloca i64, align 8
  %a.addr = alloca double, align 8
  %fb = alloca %union.long_double_bits, align 8
  %e = alloca i32, align 4
  store double %a, double* %a.addr, align 8
  %0 = load double, double* %a.addr, align 8, !dbg !2017
  %f = bitcast %union.long_double_bits* %fb to double*, !dbg !2018
  store double %0, double* %f, align 8, !dbg !2019
  %u = bitcast %union.long_double_bits* %fb to %struct.uqwords*, !dbg !2020
  %high = getelementptr inbounds %struct.uqwords, %struct.uqwords* %u, i32 0, i32 1, !dbg !2021
  %s = bitcast %union.udwords* %high to %struct.anon*, !dbg !2022
  %low = getelementptr inbounds %struct.anon, %struct.anon* %s, i32 0, i32 0, !dbg !2023
  %1 = load i32, i32* %low, align 8, !dbg !2023
  %and = and i32 %1, 32767, !dbg !2024
  %sub = sub i32 %and, 16383, !dbg !2025
  store i32 %sub, i32* %e, align 4, !dbg !2026
  %2 = load i32, i32* %e, align 4, !dbg !2027
  %cmp = icmp slt i32 %2, 0, !dbg !2028
  br i1 %cmp, label %if.then, label %lor.lhs.false, !dbg !2029

lor.lhs.false:                                    ; preds = %entry
  %u1 = bitcast %union.long_double_bits* %fb to %struct.uqwords*, !dbg !2030
  %high2 = getelementptr inbounds %struct.uqwords, %struct.uqwords* %u1, i32 0, i32 1, !dbg !2031
  %s3 = bitcast %union.udwords* %high2 to %struct.anon*, !dbg !2032
  %low4 = getelementptr inbounds %struct.anon, %struct.anon* %s3, i32 0, i32 0, !dbg !2033
  %3 = load i32, i32* %low4, align 8, !dbg !2033
  %and5 = and i32 %3, 32768, !dbg !2034
  %tobool = icmp ne i32 %and5, 0, !dbg !2034
  br i1 %tobool, label %if.then, label %if.end, !dbg !2027

if.then:                                          ; preds = %lor.lhs.false, %entry
  store i64 0, i64* %retval, align 8, !dbg !2035
  br label %return, !dbg !2035

if.end:                                           ; preds = %lor.lhs.false
  %4 = load i32, i32* %e, align 4, !dbg !2036
  %cmp6 = icmp ugt i32 %4, 64, !dbg !2037
  br i1 %cmp6, label %if.then7, label %if.end8, !dbg !2038

if.then7:                                         ; preds = %if.end
  store i64 -1, i64* %retval, align 8, !dbg !2039
  br label %return, !dbg !2039

if.end8:                                          ; preds = %if.end
  %u9 = bitcast %union.long_double_bits* %fb to %struct.uqwords*, !dbg !2040
  %low10 = getelementptr inbounds %struct.uqwords, %struct.uqwords* %u9, i32 0, i32 0, !dbg !2041
  %all = bitcast %union.udwords* %low10 to i64*, !dbg !2042
  %5 = load i64, i64* %all, align 8, !dbg !2042
  %6 = load i32, i32* %e, align 4, !dbg !2043
  %sub11 = sub nsw i32 63, %6, !dbg !2044
  %sh_prom = zext i32 %sub11 to i64, !dbg !2045
  %shr = lshr i64 %5, %sh_prom, !dbg !2045
  store i64 %shr, i64* %retval, align 8, !dbg !2046
  br label %return, !dbg !2046

return:                                           ; preds = %if.end8, %if.then7, %if.then
  %7 = load i64, i64* %retval, align 8, !dbg !2047
  ret i64 %7, !dbg !2047
}

; Function Attrs: noinline nounwind
define dso_local arm_aapcscc i32 @__fixunsxfsi(double noundef %a) #0 !dbg !2048 {
entry:
  %retval = alloca i32, align 4
  %a.addr = alloca double, align 8
  %fb = alloca %union.long_double_bits, align 8
  %e = alloca i32, align 4
  store double %a, double* %a.addr, align 8
  %0 = load double, double* %a.addr, align 8, !dbg !2049
  %f = bitcast %union.long_double_bits* %fb to double*, !dbg !2050
  store double %0, double* %f, align 8, !dbg !2051
  %u = bitcast %union.long_double_bits* %fb to %struct.uqwords*, !dbg !2052
  %high = getelementptr inbounds %struct.uqwords, %struct.uqwords* %u, i32 0, i32 1, !dbg !2053
  %s = bitcast %union.udwords* %high to %struct.anon*, !dbg !2054
  %low = getelementptr inbounds %struct.anon, %struct.anon* %s, i32 0, i32 0, !dbg !2055
  %1 = load i32, i32* %low, align 8, !dbg !2055
  %and = and i32 %1, 32767, !dbg !2056
  %sub = sub i32 %and, 16383, !dbg !2057
  store i32 %sub, i32* %e, align 4, !dbg !2058
  %2 = load i32, i32* %e, align 4, !dbg !2059
  %cmp = icmp slt i32 %2, 0, !dbg !2060
  br i1 %cmp, label %if.then, label %lor.lhs.false, !dbg !2061

lor.lhs.false:                                    ; preds = %entry
  %u1 = bitcast %union.long_double_bits* %fb to %struct.uqwords*, !dbg !2062
  %high2 = getelementptr inbounds %struct.uqwords, %struct.uqwords* %u1, i32 0, i32 1, !dbg !2063
  %s3 = bitcast %union.udwords* %high2 to %struct.anon*, !dbg !2064
  %low4 = getelementptr inbounds %struct.anon, %struct.anon* %s3, i32 0, i32 0, !dbg !2065
  %3 = load i32, i32* %low4, align 8, !dbg !2065
  %and5 = and i32 %3, 32768, !dbg !2066
  %tobool = icmp ne i32 %and5, 0, !dbg !2066
  br i1 %tobool, label %if.then, label %if.end, !dbg !2059

if.then:                                          ; preds = %lor.lhs.false, %entry
  store i32 0, i32* %retval, align 4, !dbg !2067
  br label %return, !dbg !2067

if.end:                                           ; preds = %lor.lhs.false
  %4 = load i32, i32* %e, align 4, !dbg !2068
  %cmp6 = icmp ugt i32 %4, 32, !dbg !2069
  br i1 %cmp6, label %if.then7, label %if.end8, !dbg !2070

if.then7:                                         ; preds = %if.end
  store i32 -1, i32* %retval, align 4, !dbg !2071
  br label %return, !dbg !2071

if.end8:                                          ; preds = %if.end
  %u9 = bitcast %union.long_double_bits* %fb to %struct.uqwords*, !dbg !2072
  %low10 = getelementptr inbounds %struct.uqwords, %struct.uqwords* %u9, i32 0, i32 0, !dbg !2073
  %s11 = bitcast %union.udwords* %low10 to %struct.anon*, !dbg !2074
  %high12 = getelementptr inbounds %struct.anon, %struct.anon* %s11, i32 0, i32 1, !dbg !2075
  %5 = load i32, i32* %high12, align 4, !dbg !2075
  %6 = load i32, i32* %e, align 4, !dbg !2076
  %sub13 = sub nsw i32 31, %6, !dbg !2077
  %shr = lshr i32 %5, %sub13, !dbg !2078
  store i32 %shr, i32* %retval, align 4, !dbg !2079
  br label %return, !dbg !2079

return:                                           ; preds = %if.end8, %if.then7, %if.then
  %7 = load i32, i32* %retval, align 4, !dbg !2080
  ret i32 %7, !dbg !2080
}

; Function Attrs: noinline nounwind
define dso_local arm_aapcscc i64 @__fixxfdi(double noundef %a) #0 !dbg !2081 {
entry:
  %retval = alloca i64, align 8
  %a.addr = alloca double, align 8
  %di_max = alloca i64, align 8
  %di_min = alloca i64, align 8
  %fb = alloca %union.long_double_bits, align 8
  %e = alloca i32, align 4
  %s5 = alloca i64, align 8
  %r = alloca i64, align 8
  store double %a, double* %a.addr, align 8
  store i64 9223372036854775807, i64* %di_max, align 8, !dbg !2082
  store i64 -9223372036854775808, i64* %di_min, align 8, !dbg !2083
  %0 = load double, double* %a.addr, align 8, !dbg !2084
  %f = bitcast %union.long_double_bits* %fb to double*, !dbg !2085
  store double %0, double* %f, align 8, !dbg !2086
  %u = bitcast %union.long_double_bits* %fb to %struct.uqwords*, !dbg !2087
  %high = getelementptr inbounds %struct.uqwords, %struct.uqwords* %u, i32 0, i32 1, !dbg !2088
  %s = bitcast %union.udwords* %high to %struct.anon*, !dbg !2089
  %low = getelementptr inbounds %struct.anon, %struct.anon* %s, i32 0, i32 0, !dbg !2090
  %1 = load i32, i32* %low, align 8, !dbg !2090
  %and = and i32 %1, 32767, !dbg !2091
  %sub = sub i32 %and, 16383, !dbg !2092
  store i32 %sub, i32* %e, align 4, !dbg !2093
  %2 = load i32, i32* %e, align 4, !dbg !2094
  %cmp = icmp slt i32 %2, 0, !dbg !2095
  br i1 %cmp, label %if.then, label %if.end, !dbg !2094

if.then:                                          ; preds = %entry
  store i64 0, i64* %retval, align 8, !dbg !2096
  br label %return, !dbg !2096

if.end:                                           ; preds = %entry
  %3 = load i32, i32* %e, align 4, !dbg !2097
  %cmp1 = icmp uge i32 %3, 64, !dbg !2098
  br i1 %cmp1, label %if.then2, label %if.end4, !dbg !2099

if.then2:                                         ; preds = %if.end
  %4 = load double, double* %a.addr, align 8, !dbg !2100
  %cmp3 = fcmp ogt double %4, 0.000000e+00, !dbg !2101
  %5 = zext i1 %cmp3 to i64, !dbg !2100
  %cond = select i1 %cmp3, i64 9223372036854775807, i64 -9223372036854775808, !dbg !2100
  store i64 %cond, i64* %retval, align 8, !dbg !2102
  br label %return, !dbg !2102

if.end4:                                          ; preds = %if.end
  %u6 = bitcast %union.long_double_bits* %fb to %struct.uqwords*, !dbg !2103
  %high7 = getelementptr inbounds %struct.uqwords, %struct.uqwords* %u6, i32 0, i32 1, !dbg !2104
  %s8 = bitcast %union.udwords* %high7 to %struct.anon*, !dbg !2105
  %low9 = getelementptr inbounds %struct.anon, %struct.anon* %s8, i32 0, i32 0, !dbg !2106
  %6 = load i32, i32* %low9, align 8, !dbg !2106
  %and10 = and i32 %6, 32768, !dbg !2107
  %shr = lshr i32 %and10, 15, !dbg !2108
  %sub11 = sub nsw i32 0, %shr, !dbg !2109
  %conv = sext i32 %sub11 to i64, !dbg !2109
  store i64 %conv, i64* %s5, align 8, !dbg !2110
  %u12 = bitcast %union.long_double_bits* %fb to %struct.uqwords*, !dbg !2111
  %low13 = getelementptr inbounds %struct.uqwords, %struct.uqwords* %u12, i32 0, i32 0, !dbg !2112
  %all = bitcast %union.udwords* %low13 to i64*, !dbg !2113
  %7 = load i64, i64* %all, align 8, !dbg !2113
  store i64 %7, i64* %r, align 8, !dbg !2114
  %8 = load i64, i64* %r, align 8, !dbg !2115
  %9 = load i32, i32* %e, align 4, !dbg !2116
  %sub14 = sub nsw i32 63, %9, !dbg !2117
  %sh_prom = zext i32 %sub14 to i64, !dbg !2118
  %shr15 = lshr i64 %8, %sh_prom, !dbg !2118
  store i64 %shr15, i64* %r, align 8, !dbg !2119
  %10 = load i64, i64* %r, align 8, !dbg !2120
  %11 = load i64, i64* %s5, align 8, !dbg !2121
  %xor = xor i64 %10, %11, !dbg !2122
  %12 = load i64, i64* %s5, align 8, !dbg !2123
  %sub16 = sub nsw i64 %xor, %12, !dbg !2124
  store i64 %sub16, i64* %retval, align 8, !dbg !2125
  br label %return, !dbg !2125

return:                                           ; preds = %if.end4, %if.then2, %if.then
  %13 = load i64, i64* %retval, align 8, !dbg !2126
  ret i64 %13, !dbg !2126
}

; Function Attrs: noinline nounwind
define dso_local arm_aapcscc double @__floatdidf(i64 noundef %a) #0 !dbg !2127 {
entry:
  %a.addr = alloca i64, align 8
  %low = alloca %union.udwords, align 8
  %high = alloca double, align 8
  %result = alloca double, align 8
  store i64 %a, i64* %a.addr, align 8
  %0 = bitcast %union.udwords* %low to i8*, !dbg !2128
  call void @llvm.memcpy.p0i8.p0i8.i32(i8* align 8 %0, i8* align 8 bitcast ({ double }* @__const.__floatdidf.low to i8*), i32 8, i1 false), !dbg !2128
  %1 = load i64, i64* %a.addr, align 8, !dbg !2129
  %shr = ashr i64 %1, 32, !dbg !2130
  %conv = trunc i64 %shr to i32, !dbg !2131
  %conv1 = sitofp i32 %conv to double, !dbg !2131
  %mul = fmul double %conv1, 0x41F0000000000000, !dbg !2132
  store double %mul, double* %high, align 8, !dbg !2133
  %2 = load i64, i64* %a.addr, align 8, !dbg !2134
  %and = and i64 %2, 4294967295, !dbg !2135
  %x = bitcast %union.udwords* %low to i64*, !dbg !2136
  %3 = load i64, i64* %x, align 8, !dbg !2137
  %or = or i64 %3, %and, !dbg !2137
  store i64 %or, i64* %x, align 8, !dbg !2137
  %4 = load double, double* %high, align 8, !dbg !2138
  %sub = fsub double %4, 0x4330000000000000, !dbg !2139
  %d = bitcast %union.udwords* %low to double*, !dbg !2140
  %5 = load double, double* %d, align 8, !dbg !2140
  %add = fadd double %sub, %5, !dbg !2141
  store double %add, double* %result, align 8, !dbg !2142
  %6 = load double, double* %result, align 8, !dbg !2143
  ret double %6, !dbg !2144
}

; Function Attrs: argmemonly nofree nounwind willreturn
declare void @llvm.memcpy.p0i8.p0i8.i32(i8* noalias nocapture writeonly, i8* noalias nocapture readonly, i32, i1 immarg) #2

; Function Attrs: noinline nounwind
define dso_local arm_aapcscc float @__floatdisf(i64 noundef %a) #0 !dbg !2145 {
entry:
  %retval = alloca float, align 4
  %a.addr = alloca i64, align 8
  %N = alloca i32, align 4
  %s = alloca i64, align 8
  %sd = alloca i32, align 4
  %e = alloca i32, align 4
  %fb = alloca %union.float_bits, align 4
  store i64 %a, i64* %a.addr, align 8
  %0 = load i64, i64* %a.addr, align 8, !dbg !2146
  %cmp = icmp eq i64 %0, 0, !dbg !2147
  br i1 %cmp, label %if.then, label %if.end, !dbg !2146

if.then:                                          ; preds = %entry
  store float 0.000000e+00, float* %retval, align 4, !dbg !2148
  br label %return, !dbg !2148

if.end:                                           ; preds = %entry
  store i32 64, i32* %N, align 4, !dbg !2149
  %1 = load i64, i64* %a.addr, align 8, !dbg !2150
  %shr = ashr i64 %1, 63, !dbg !2151
  store i64 %shr, i64* %s, align 8, !dbg !2152
  %2 = load i64, i64* %a.addr, align 8, !dbg !2153
  %3 = load i64, i64* %s, align 8, !dbg !2154
  %xor = xor i64 %2, %3, !dbg !2155
  %4 = load i64, i64* %s, align 8, !dbg !2156
  %sub = sub nsw i64 %xor, %4, !dbg !2157
  store i64 %sub, i64* %a.addr, align 8, !dbg !2158
  %5 = load i64, i64* %a.addr, align 8, !dbg !2159
  %6 = call i64 @llvm.ctlz.i64(i64 %5, i1 false), !dbg !2160
  %cast = trunc i64 %6 to i32, !dbg !2160
  %sub1 = sub i32 64, %cast, !dbg !2161
  store i32 %sub1, i32* %sd, align 4, !dbg !2162
  %7 = load i32, i32* %sd, align 4, !dbg !2163
  %sub2 = sub nsw i32 %7, 1, !dbg !2164
  store i32 %sub2, i32* %e, align 4, !dbg !2165
  %8 = load i32, i32* %sd, align 4, !dbg !2166
  %cmp3 = icmp sgt i32 %8, 24, !dbg !2167
  br i1 %cmp3, label %if.then4, label %if.else, !dbg !2166

if.then4:                                         ; preds = %if.end
  %9 = load i32, i32* %sd, align 4, !dbg !2168
  switch i32 %9, label %sw.default [
    i32 25, label %sw.bb
    i32 26, label %sw.bb5
  ], !dbg !2169

sw.bb:                                            ; preds = %if.then4
  %10 = load i64, i64* %a.addr, align 8, !dbg !2170
  %shl = shl i64 %10, 1, !dbg !2170
  store i64 %shl, i64* %a.addr, align 8, !dbg !2170
  br label %sw.epilog, !dbg !2171

sw.bb5:                                           ; preds = %if.then4
  br label %sw.epilog, !dbg !2172

sw.default:                                       ; preds = %if.then4
  %11 = load i64, i64* %a.addr, align 8, !dbg !2173
  %12 = load i32, i32* %sd, align 4, !dbg !2174
  %sub6 = sub nsw i32 %12, 26, !dbg !2175
  %sh_prom = zext i32 %sub6 to i64, !dbg !2176
  %shr7 = lshr i64 %11, %sh_prom, !dbg !2176
  %13 = load i64, i64* %a.addr, align 8, !dbg !2177
  %14 = load i32, i32* %sd, align 4, !dbg !2178
  %sub8 = sub i32 90, %14, !dbg !2179
  %sh_prom9 = zext i32 %sub8 to i64, !dbg !2180
  %shr10 = lshr i64 -1, %sh_prom9, !dbg !2180
  %and = and i64 %13, %shr10, !dbg !2181
  %cmp11 = icmp ne i64 %and, 0, !dbg !2182
  %conv = zext i1 %cmp11 to i32, !dbg !2182
  %conv12 = sext i32 %conv to i64, !dbg !2183
  %or = or i64 %shr7, %conv12, !dbg !2184
  store i64 %or, i64* %a.addr, align 8, !dbg !2185
  br label %sw.epilog, !dbg !2186

sw.epilog:                                        ; preds = %sw.default, %sw.bb5, %sw.bb
  %15 = load i64, i64* %a.addr, align 8, !dbg !2187
  %and13 = and i64 %15, 4, !dbg !2188
  %cmp14 = icmp ne i64 %and13, 0, !dbg !2189
  %conv15 = zext i1 %cmp14 to i32, !dbg !2189
  %conv16 = sext i32 %conv15 to i64, !dbg !2190
  %16 = load i64, i64* %a.addr, align 8, !dbg !2191
  %or17 = or i64 %16, %conv16, !dbg !2191
  store i64 %or17, i64* %a.addr, align 8, !dbg !2191
  %17 = load i64, i64* %a.addr, align 8, !dbg !2192
  %inc = add nsw i64 %17, 1, !dbg !2192
  store i64 %inc, i64* %a.addr, align 8, !dbg !2192
  %18 = load i64, i64* %a.addr, align 8, !dbg !2193
  %shr18 = ashr i64 %18, 2, !dbg !2193
  store i64 %shr18, i64* %a.addr, align 8, !dbg !2193
  %19 = load i64, i64* %a.addr, align 8, !dbg !2194
  %and19 = and i64 %19, 16777216, !dbg !2195
  %tobool = icmp ne i64 %and19, 0, !dbg !2195
  br i1 %tobool, label %if.then20, label %if.end23, !dbg !2194

if.then20:                                        ; preds = %sw.epilog
  %20 = load i64, i64* %a.addr, align 8, !dbg !2196
  %shr21 = ashr i64 %20, 1, !dbg !2196
  store i64 %shr21, i64* %a.addr, align 8, !dbg !2196
  %21 = load i32, i32* %e, align 4, !dbg !2197
  %inc22 = add nsw i32 %21, 1, !dbg !2197
  store i32 %inc22, i32* %e, align 4, !dbg !2197
  br label %if.end23, !dbg !2198

if.end23:                                         ; preds = %if.then20, %sw.epilog
  br label %if.end27, !dbg !2199

if.else:                                          ; preds = %if.end
  %22 = load i32, i32* %sd, align 4, !dbg !2200
  %sub24 = sub nsw i32 24, %22, !dbg !2201
  %23 = load i64, i64* %a.addr, align 8, !dbg !2202
  %sh_prom25 = zext i32 %sub24 to i64, !dbg !2202
  %shl26 = shl i64 %23, %sh_prom25, !dbg !2202
  store i64 %shl26, i64* %a.addr, align 8, !dbg !2202
  br label %if.end27

if.end27:                                         ; preds = %if.else, %if.end23
  %24 = load i64, i64* %s, align 8, !dbg !2203
  %conv28 = trunc i64 %24 to i32, !dbg !2204
  %and29 = and i32 %conv28, -2147483648, !dbg !2205
  %25 = load i32, i32* %e, align 4, !dbg !2206
  %add = add nsw i32 %25, 127, !dbg !2207
  %shl30 = shl i32 %add, 23, !dbg !2208
  %or31 = or i32 %and29, %shl30, !dbg !2209
  %26 = load i64, i64* %a.addr, align 8, !dbg !2210
  %conv32 = trunc i64 %26 to i32, !dbg !2211
  %and33 = and i32 %conv32, 8388607, !dbg !2212
  %or34 = or i32 %or31, %and33, !dbg !2213
  %u = bitcast %union.float_bits* %fb to i32*, !dbg !2214
  store i32 %or34, i32* %u, align 4, !dbg !2215
  %f = bitcast %union.float_bits* %fb to float*, !dbg !2216
  %27 = load float, float* %f, align 4, !dbg !2216
  store float %27, float* %retval, align 4, !dbg !2217
  br label %return, !dbg !2217

return:                                           ; preds = %if.end27, %if.then
  %28 = load float, float* %retval, align 4, !dbg !2218
  ret float %28, !dbg !2218
}

; Function Attrs: nofree nosync nounwind readnone speculatable willreturn
declare i64 @llvm.ctlz.i64(i64, i1 immarg) #1

; Function Attrs: noinline nounwind
define dso_local arm_aapcscc double @__floatdixf(i64 noundef %a) #0 !dbg !2219 {
entry:
  %retval = alloca double, align 8
  %a.addr = alloca i64, align 8
  %N = alloca i32, align 4
  %s = alloca i64, align 8
  %clz = alloca i32, align 4
  %e = alloca i32, align 4
  %fb = alloca %union.long_double_bits, align 8
  store i64 %a, i64* %a.addr, align 8
  %0 = load i64, i64* %a.addr, align 8, !dbg !2220
  %cmp = icmp eq i64 %0, 0, !dbg !2221
  br i1 %cmp, label %if.then, label %if.end, !dbg !2220

if.then:                                          ; preds = %entry
  store double 0.000000e+00, double* %retval, align 8, !dbg !2222
  br label %return, !dbg !2222

if.end:                                           ; preds = %entry
  store i32 64, i32* %N, align 4, !dbg !2223
  %1 = load i64, i64* %a.addr, align 8, !dbg !2224
  %shr = ashr i64 %1, 63, !dbg !2225
  store i64 %shr, i64* %s, align 8, !dbg !2226
  %2 = load i64, i64* %a.addr, align 8, !dbg !2227
  %3 = load i64, i64* %s, align 8, !dbg !2228
  %xor = xor i64 %2, %3, !dbg !2229
  %4 = load i64, i64* %s, align 8, !dbg !2230
  %sub = sub nsw i64 %xor, %4, !dbg !2231
  store i64 %sub, i64* %a.addr, align 8, !dbg !2232
  %5 = load i64, i64* %a.addr, align 8, !dbg !2233
  %6 = call i64 @llvm.ctlz.i64(i64 %5, i1 false), !dbg !2234
  %cast = trunc i64 %6 to i32, !dbg !2234
  store i32 %cast, i32* %clz, align 4, !dbg !2235
  %7 = load i32, i32* %clz, align 4, !dbg !2236
  %sub1 = sub i32 63, %7, !dbg !2237
  store i32 %sub1, i32* %e, align 4, !dbg !2238
  %8 = load i64, i64* %s, align 8, !dbg !2239
  %conv = trunc i64 %8 to i32, !dbg !2240
  %and = and i32 %conv, 32768, !dbg !2241
  %9 = load i32, i32* %e, align 4, !dbg !2242
  %add = add nsw i32 %9, 16383, !dbg !2243
  %or = or i32 %and, %add, !dbg !2244
  %u = bitcast %union.long_double_bits* %fb to %struct.uqwords*, !dbg !2245
  %high = getelementptr inbounds %struct.uqwords, %struct.uqwords* %u, i32 0, i32 1, !dbg !2246
  %s2 = bitcast %union.udwords* %high to %struct.anon*, !dbg !2247
  %low = getelementptr inbounds %struct.anon, %struct.anon* %s2, i32 0, i32 0, !dbg !2248
  store i32 %or, i32* %low, align 8, !dbg !2249
  %10 = load i64, i64* %a.addr, align 8, !dbg !2250
  %11 = load i32, i32* %clz, align 4, !dbg !2251
  %sh_prom = zext i32 %11 to i64, !dbg !2252
  %shl = shl i64 %10, %sh_prom, !dbg !2252
  %u3 = bitcast %union.long_double_bits* %fb to %struct.uqwords*, !dbg !2253
  %low4 = getelementptr inbounds %struct.uqwords, %struct.uqwords* %u3, i32 0, i32 0, !dbg !2254
  %all = bitcast %union.udwords* %low4 to i64*, !dbg !2255
  store i64 %shl, i64* %all, align 8, !dbg !2256
  %f = bitcast %union.long_double_bits* %fb to double*, !dbg !2257
  %12 = load double, double* %f, align 8, !dbg !2257
  store double %12, double* %retval, align 8, !dbg !2258
  br label %return, !dbg !2258

return:                                           ; preds = %if.end, %if.then
  %13 = load double, double* %retval, align 8, !dbg !2259
  ret double %13, !dbg !2259
}

; Function Attrs: noinline nounwind
define dso_local arm_aapcscc double @__floatsidf(i32 noundef %a) #0 !dbg !2260 {
entry:
  %retval = alloca double, align 8
  %a.addr = alloca i32, align 4
  %aWidth = alloca i32, align 4
  %sign = alloca i64, align 8
  %exponent = alloca i32, align 4
  %result = alloca i64, align 8
  %shift = alloca i32, align 4
  store i32 %a, i32* %a.addr, align 4
  store i32 32, i32* %aWidth, align 4, !dbg !2261
  %0 = load i32, i32* %a.addr, align 4, !dbg !2262
  %cmp = icmp eq i32 %0, 0, !dbg !2263
  br i1 %cmp, label %if.then, label %if.end, !dbg !2262

if.then:                                          ; preds = %entry
  %call = call arm_aapcscc double @fromRep.29(i64 noundef 0) #4, !dbg !2264
  store double %call, double* %retval, align 8, !dbg !2265
  br label %return, !dbg !2265

if.end:                                           ; preds = %entry
  store i64 0, i64* %sign, align 8, !dbg !2266
  %1 = load i32, i32* %a.addr, align 4, !dbg !2267
  %cmp1 = icmp slt i32 %1, 0, !dbg !2268
  br i1 %cmp1, label %if.then2, label %if.end3, !dbg !2267

if.then2:                                         ; preds = %if.end
  store i64 -9223372036854775808, i64* %sign, align 8, !dbg !2269
  %2 = load i32, i32* %a.addr, align 4, !dbg !2270
  %sub = sub nsw i32 0, %2, !dbg !2271
  store i32 %sub, i32* %a.addr, align 4, !dbg !2272
  br label %if.end3, !dbg !2273

if.end3:                                          ; preds = %if.then2, %if.end
  %3 = load i32, i32* %a.addr, align 4, !dbg !2274
  %4 = call i32 @llvm.ctlz.i32(i32 %3, i1 false), !dbg !2275
  %sub4 = sub nsw i32 31, %4, !dbg !2276
  store i32 %sub4, i32* %exponent, align 4, !dbg !2277
  %5 = load i32, i32* %exponent, align 4, !dbg !2278
  %sub5 = sub nsw i32 52, %5, !dbg !2279
  store i32 %sub5, i32* %shift, align 4, !dbg !2280
  %6 = load i32, i32* %a.addr, align 4, !dbg !2281
  %conv = zext i32 %6 to i64, !dbg !2282
  %7 = load i32, i32* %shift, align 4, !dbg !2283
  %sh_prom = zext i32 %7 to i64, !dbg !2284
  %shl = shl i64 %conv, %sh_prom, !dbg !2284
  %xor = xor i64 %shl, 4503599627370496, !dbg !2285
  store i64 %xor, i64* %result, align 8, !dbg !2286
  %8 = load i32, i32* %exponent, align 4, !dbg !2287
  %add = add nsw i32 %8, 1023, !dbg !2288
  %conv6 = sext i32 %add to i64, !dbg !2289
  %shl7 = shl i64 %conv6, 52, !dbg !2290
  %9 = load i64, i64* %result, align 8, !dbg !2291
  %add8 = add i64 %9, %shl7, !dbg !2291
  store i64 %add8, i64* %result, align 8, !dbg !2291
  %10 = load i64, i64* %result, align 8, !dbg !2292
  %11 = load i64, i64* %sign, align 8, !dbg !2293
  %or = or i64 %10, %11, !dbg !2294
  %call9 = call arm_aapcscc double @fromRep.29(i64 noundef %or) #4, !dbg !2295
  store double %call9, double* %retval, align 8, !dbg !2296
  br label %return, !dbg !2296

return:                                           ; preds = %if.end3, %if.then
  %12 = load double, double* %retval, align 8, !dbg !2297
  ret double %12, !dbg !2297
}

; Function Attrs: noinline nounwind
define internal arm_aapcscc double @fromRep.29(i64 noundef %x) #0 !dbg !2298 {
entry:
  %x.addr = alloca i64, align 8
  %rep = alloca %union.anon.0, align 8
  store i64 %x, i64* %x.addr, align 8
  %i = bitcast %union.anon.0* %rep to i64*, !dbg !2299
  %0 = load i64, i64* %x.addr, align 8, !dbg !2300
  store i64 %0, i64* %i, align 8, !dbg !2299
  %f = bitcast %union.anon.0* %rep to double*, !dbg !2301
  %1 = load double, double* %f, align 8, !dbg !2301
  ret double %1, !dbg !2302
}

; Function Attrs: noinline nounwind
define dso_local arm_aapcscc float @__floatsisf(i32 noundef %a) #0 !dbg !2303 {
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
  store i32 32, i32* %aWidth, align 4, !dbg !2304
  %0 = load i32, i32* %a.addr, align 4, !dbg !2305
  %cmp = icmp eq i32 %0, 0, !dbg !2306
  br i1 %cmp, label %if.then, label %if.end, !dbg !2305

if.then:                                          ; preds = %entry
  %call = call arm_aapcscc float @fromRep.30(i32 noundef 0) #4, !dbg !2307
  store float %call, float* %retval, align 4, !dbg !2308
  br label %return, !dbg !2308

if.end:                                           ; preds = %entry
  store i32 0, i32* %sign, align 4, !dbg !2309
  %1 = load i32, i32* %a.addr, align 4, !dbg !2310
  %cmp1 = icmp slt i32 %1, 0, !dbg !2311
  br i1 %cmp1, label %if.then2, label %if.end3, !dbg !2310

if.then2:                                         ; preds = %if.end
  store i32 -2147483648, i32* %sign, align 4, !dbg !2312
  %2 = load i32, i32* %a.addr, align 4, !dbg !2313
  %sub = sub nsw i32 0, %2, !dbg !2314
  store i32 %sub, i32* %a.addr, align 4, !dbg !2315
  br label %if.end3, !dbg !2316

if.end3:                                          ; preds = %if.then2, %if.end
  %3 = load i32, i32* %a.addr, align 4, !dbg !2317
  %4 = call i32 @llvm.ctlz.i32(i32 %3, i1 false), !dbg !2318
  %sub4 = sub nsw i32 31, %4, !dbg !2319
  store i32 %sub4, i32* %exponent, align 4, !dbg !2320
  %5 = load i32, i32* %exponent, align 4, !dbg !2321
  %cmp5 = icmp sle i32 %5, 23, !dbg !2322
  br i1 %cmp5, label %if.then6, label %if.else, !dbg !2321

if.then6:                                         ; preds = %if.end3
  %6 = load i32, i32* %exponent, align 4, !dbg !2323
  %sub7 = sub nsw i32 23, %6, !dbg !2324
  store i32 %sub7, i32* %shift, align 4, !dbg !2325
  %7 = load i32, i32* %a.addr, align 4, !dbg !2326
  %8 = load i32, i32* %shift, align 4, !dbg !2327
  %shl = shl i32 %7, %8, !dbg !2328
  %xor = xor i32 %shl, 8388608, !dbg !2329
  store i32 %xor, i32* %result, align 4, !dbg !2330
  br label %if.end19, !dbg !2331

if.else:                                          ; preds = %if.end3
  %9 = load i32, i32* %exponent, align 4, !dbg !2332
  %sub9 = sub nsw i32 %9, 23, !dbg !2333
  store i32 %sub9, i32* %shift8, align 4, !dbg !2334
  %10 = load i32, i32* %a.addr, align 4, !dbg !2335
  %11 = load i32, i32* %shift8, align 4, !dbg !2336
  %shr = lshr i32 %10, %11, !dbg !2337
  %xor10 = xor i32 %shr, 8388608, !dbg !2338
  store i32 %xor10, i32* %result, align 4, !dbg !2339
  %12 = load i32, i32* %a.addr, align 4, !dbg !2340
  %13 = load i32, i32* %shift8, align 4, !dbg !2341
  %sub11 = sub i32 32, %13, !dbg !2342
  %shl12 = shl i32 %12, %sub11, !dbg !2343
  store i32 %shl12, i32* %round, align 4, !dbg !2344
  %14 = load i32, i32* %round, align 4, !dbg !2345
  %cmp13 = icmp ugt i32 %14, -2147483648, !dbg !2346
  br i1 %cmp13, label %if.then14, label %if.end15, !dbg !2345

if.then14:                                        ; preds = %if.else
  %15 = load i32, i32* %result, align 4, !dbg !2347
  %inc = add i32 %15, 1, !dbg !2347
  store i32 %inc, i32* %result, align 4, !dbg !2347
  br label %if.end15, !dbg !2348

if.end15:                                         ; preds = %if.then14, %if.else
  %16 = load i32, i32* %round, align 4, !dbg !2349
  %cmp16 = icmp eq i32 %16, -2147483648, !dbg !2350
  br i1 %cmp16, label %if.then17, label %if.end18, !dbg !2349

if.then17:                                        ; preds = %if.end15
  %17 = load i32, i32* %result, align 4, !dbg !2351
  %and = and i32 %17, 1, !dbg !2352
  %18 = load i32, i32* %result, align 4, !dbg !2353
  %add = add i32 %18, %and, !dbg !2353
  store i32 %add, i32* %result, align 4, !dbg !2353
  br label %if.end18, !dbg !2354

if.end18:                                         ; preds = %if.then17, %if.end15
  br label %if.end19

if.end19:                                         ; preds = %if.end18, %if.then6
  %19 = load i32, i32* %exponent, align 4, !dbg !2355
  %add20 = add nsw i32 %19, 127, !dbg !2356
  %shl21 = shl i32 %add20, 23, !dbg !2357
  %20 = load i32, i32* %result, align 4, !dbg !2358
  %add22 = add i32 %20, %shl21, !dbg !2358
  store i32 %add22, i32* %result, align 4, !dbg !2358
  %21 = load i32, i32* %result, align 4, !dbg !2359
  %22 = load i32, i32* %sign, align 4, !dbg !2360
  %or = or i32 %21, %22, !dbg !2361
  %call23 = call arm_aapcscc float @fromRep.30(i32 noundef %or) #4, !dbg !2362
  store float %call23, float* %retval, align 4, !dbg !2363
  br label %return, !dbg !2363

return:                                           ; preds = %if.end19, %if.then
  %23 = load float, float* %retval, align 4, !dbg !2364
  ret float %23, !dbg !2364
}

; Function Attrs: noinline nounwind
define internal arm_aapcscc float @fromRep.30(i32 noundef %x) #0 !dbg !2365 {
entry:
  %x.addr = alloca i32, align 4
  %rep = alloca %union.anon.0.0, align 4
  store i32 %x, i32* %x.addr, align 4
  %i = bitcast %union.anon.0.0* %rep to i32*, !dbg !2366
  %0 = load i32, i32* %x.addr, align 4, !dbg !2367
  store i32 %0, i32* %i, align 4, !dbg !2366
  %f = bitcast %union.anon.0.0* %rep to float*, !dbg !2368
  %1 = load float, float* %f, align 4, !dbg !2368
  ret float %1, !dbg !2369
}

; Function Attrs: noinline nounwind
define dso_local arm_aapcscc double @__floatundidf(i64 noundef %a) #0 !dbg !2370 {
entry:
  %a.addr = alloca i64, align 8
  %high = alloca %union.udwords, align 8
  %low = alloca %union.udwords, align 8
  %result = alloca double, align 8
  store i64 %a, i64* %a.addr, align 8
  %0 = bitcast %union.udwords* %high to i8*, !dbg !2371
  call void @llvm.memcpy.p0i8.p0i8.i32(i8* align 8 %0, i8* align 8 bitcast ({ double }* @__const.__floatundidf.high to i8*), i32 8, i1 false), !dbg !2371
  %1 = bitcast %union.udwords* %low to i8*, !dbg !2372
  call void @llvm.memcpy.p0i8.p0i8.i32(i8* align 8 %1, i8* align 8 bitcast ({ double }* @__const.__floatundidf.low to i8*), i32 8, i1 false), !dbg !2372
  %2 = load i64, i64* %a.addr, align 8, !dbg !2373
  %shr = lshr i64 %2, 32, !dbg !2374
  %x = bitcast %union.udwords* %high to i64*, !dbg !2375
  %3 = load i64, i64* %x, align 8, !dbg !2376
  %or = or i64 %3, %shr, !dbg !2376
  store i64 %or, i64* %x, align 8, !dbg !2376
  %4 = load i64, i64* %a.addr, align 8, !dbg !2377
  %and = and i64 %4, 4294967295, !dbg !2378
  %x1 = bitcast %union.udwords* %low to i64*, !dbg !2379
  %5 = load i64, i64* %x1, align 8, !dbg !2380
  %or2 = or i64 %5, %and, !dbg !2380
  store i64 %or2, i64* %x1, align 8, !dbg !2380
  %d = bitcast %union.udwords* %high to double*, !dbg !2381
  %6 = load double, double* %d, align 8, !dbg !2381
  %sub = fsub double %6, 0x4530000000100000, !dbg !2382
  %d3 = bitcast %union.udwords* %low to double*, !dbg !2383
  %7 = load double, double* %d3, align 8, !dbg !2383
  %add = fadd double %sub, %7, !dbg !2384
  store double %add, double* %result, align 8, !dbg !2385
  %8 = load double, double* %result, align 8, !dbg !2386
  ret double %8, !dbg !2387
}

; Function Attrs: noinline nounwind
define dso_local arm_aapcscc float @__floatundisf(i64 noundef %a) #0 !dbg !2388 {
entry:
  %retval = alloca float, align 4
  %a.addr = alloca i64, align 8
  %N = alloca i32, align 4
  %sd = alloca i32, align 4
  %e = alloca i32, align 4
  %fb = alloca %union.float_bits, align 4
  store i64 %a, i64* %a.addr, align 8
  %0 = load i64, i64* %a.addr, align 8, !dbg !2389
  %cmp = icmp eq i64 %0, 0, !dbg !2390
  br i1 %cmp, label %if.then, label %if.end, !dbg !2389

if.then:                                          ; preds = %entry
  store float 0.000000e+00, float* %retval, align 4, !dbg !2391
  br label %return, !dbg !2391

if.end:                                           ; preds = %entry
  store i32 64, i32* %N, align 4, !dbg !2392
  %1 = load i64, i64* %a.addr, align 8, !dbg !2393
  %2 = call i64 @llvm.ctlz.i64(i64 %1, i1 false), !dbg !2394
  %cast = trunc i64 %2 to i32, !dbg !2394
  %sub = sub i32 64, %cast, !dbg !2395
  store i32 %sub, i32* %sd, align 4, !dbg !2396
  %3 = load i32, i32* %sd, align 4, !dbg !2397
  %sub1 = sub nsw i32 %3, 1, !dbg !2398
  store i32 %sub1, i32* %e, align 4, !dbg !2399
  %4 = load i32, i32* %sd, align 4, !dbg !2400
  %cmp2 = icmp sgt i32 %4, 24, !dbg !2401
  br i1 %cmp2, label %if.then3, label %if.else, !dbg !2400

if.then3:                                         ; preds = %if.end
  %5 = load i32, i32* %sd, align 4, !dbg !2402
  switch i32 %5, label %sw.default [
    i32 25, label %sw.bb
    i32 26, label %sw.bb4
  ], !dbg !2403

sw.bb:                                            ; preds = %if.then3
  %6 = load i64, i64* %a.addr, align 8, !dbg !2404
  %shl = shl i64 %6, 1, !dbg !2404
  store i64 %shl, i64* %a.addr, align 8, !dbg !2404
  br label %sw.epilog, !dbg !2405

sw.bb4:                                           ; preds = %if.then3
  br label %sw.epilog, !dbg !2406

sw.default:                                       ; preds = %if.then3
  %7 = load i64, i64* %a.addr, align 8, !dbg !2407
  %8 = load i32, i32* %sd, align 4, !dbg !2408
  %sub5 = sub nsw i32 %8, 26, !dbg !2409
  %sh_prom = zext i32 %sub5 to i64, !dbg !2410
  %shr = lshr i64 %7, %sh_prom, !dbg !2410
  %9 = load i64, i64* %a.addr, align 8, !dbg !2411
  %10 = load i32, i32* %sd, align 4, !dbg !2412
  %sub6 = sub i32 90, %10, !dbg !2413
  %sh_prom7 = zext i32 %sub6 to i64, !dbg !2414
  %shr8 = lshr i64 -1, %sh_prom7, !dbg !2414
  %and = and i64 %9, %shr8, !dbg !2415
  %cmp9 = icmp ne i64 %and, 0, !dbg !2416
  %conv = zext i1 %cmp9 to i32, !dbg !2416
  %conv10 = sext i32 %conv to i64, !dbg !2417
  %or = or i64 %shr, %conv10, !dbg !2418
  store i64 %or, i64* %a.addr, align 8, !dbg !2419
  br label %sw.epilog, !dbg !2420

sw.epilog:                                        ; preds = %sw.default, %sw.bb4, %sw.bb
  %11 = load i64, i64* %a.addr, align 8, !dbg !2421
  %and11 = and i64 %11, 4, !dbg !2422
  %cmp12 = icmp ne i64 %and11, 0, !dbg !2423
  %conv13 = zext i1 %cmp12 to i32, !dbg !2423
  %conv14 = sext i32 %conv13 to i64, !dbg !2424
  %12 = load i64, i64* %a.addr, align 8, !dbg !2425
  %or15 = or i64 %12, %conv14, !dbg !2425
  store i64 %or15, i64* %a.addr, align 8, !dbg !2425
  %13 = load i64, i64* %a.addr, align 8, !dbg !2426
  %inc = add i64 %13, 1, !dbg !2426
  store i64 %inc, i64* %a.addr, align 8, !dbg !2426
  %14 = load i64, i64* %a.addr, align 8, !dbg !2427
  %shr16 = lshr i64 %14, 2, !dbg !2427
  store i64 %shr16, i64* %a.addr, align 8, !dbg !2427
  %15 = load i64, i64* %a.addr, align 8, !dbg !2428
  %and17 = and i64 %15, 16777216, !dbg !2429
  %tobool = icmp ne i64 %and17, 0, !dbg !2429
  br i1 %tobool, label %if.then18, label %if.end21, !dbg !2428

if.then18:                                        ; preds = %sw.epilog
  %16 = load i64, i64* %a.addr, align 8, !dbg !2430
  %shr19 = lshr i64 %16, 1, !dbg !2430
  store i64 %shr19, i64* %a.addr, align 8, !dbg !2430
  %17 = load i32, i32* %e, align 4, !dbg !2431
  %inc20 = add nsw i32 %17, 1, !dbg !2431
  store i32 %inc20, i32* %e, align 4, !dbg !2431
  br label %if.end21, !dbg !2432

if.end21:                                         ; preds = %if.then18, %sw.epilog
  br label %if.end25, !dbg !2433

if.else:                                          ; preds = %if.end
  %18 = load i32, i32* %sd, align 4, !dbg !2434
  %sub22 = sub nsw i32 24, %18, !dbg !2435
  %19 = load i64, i64* %a.addr, align 8, !dbg !2436
  %sh_prom23 = zext i32 %sub22 to i64, !dbg !2436
  %shl24 = shl i64 %19, %sh_prom23, !dbg !2436
  store i64 %shl24, i64* %a.addr, align 8, !dbg !2436
  br label %if.end25

if.end25:                                         ; preds = %if.else, %if.end21
  %20 = load i32, i32* %e, align 4, !dbg !2437
  %add = add nsw i32 %20, 127, !dbg !2438
  %shl26 = shl i32 %add, 23, !dbg !2439
  %21 = load i64, i64* %a.addr, align 8, !dbg !2440
  %conv27 = trunc i64 %21 to i32, !dbg !2441
  %and28 = and i32 %conv27, 8388607, !dbg !2442
  %or29 = or i32 %shl26, %and28, !dbg !2443
  %u = bitcast %union.float_bits* %fb to i32*, !dbg !2444
  store i32 %or29, i32* %u, align 4, !dbg !2445
  %f = bitcast %union.float_bits* %fb to float*, !dbg !2446
  %22 = load float, float* %f, align 4, !dbg !2446
  store float %22, float* %retval, align 4, !dbg !2447
  br label %return, !dbg !2447

return:                                           ; preds = %if.end25, %if.then
  %23 = load float, float* %retval, align 4, !dbg !2448
  ret float %23, !dbg !2448
}

; Function Attrs: noinline nounwind
define dso_local arm_aapcscc double @__floatundixf(i64 noundef %a) #0 !dbg !2449 {
entry:
  %retval = alloca double, align 8
  %a.addr = alloca i64, align 8
  %N = alloca i32, align 4
  %clz = alloca i32, align 4
  %e = alloca i32, align 4
  %fb = alloca %union.long_double_bits, align 8
  store i64 %a, i64* %a.addr, align 8
  %0 = load i64, i64* %a.addr, align 8, !dbg !2450
  %cmp = icmp eq i64 %0, 0, !dbg !2451
  br i1 %cmp, label %if.then, label %if.end, !dbg !2450

if.then:                                          ; preds = %entry
  store double 0.000000e+00, double* %retval, align 8, !dbg !2452
  br label %return, !dbg !2452

if.end:                                           ; preds = %entry
  store i32 64, i32* %N, align 4, !dbg !2453
  %1 = load i64, i64* %a.addr, align 8, !dbg !2454
  %2 = call i64 @llvm.ctlz.i64(i64 %1, i1 false), !dbg !2455
  %cast = trunc i64 %2 to i32, !dbg !2455
  store i32 %cast, i32* %clz, align 4, !dbg !2456
  %3 = load i32, i32* %clz, align 4, !dbg !2457
  %sub = sub i32 63, %3, !dbg !2458
  store i32 %sub, i32* %e, align 4, !dbg !2459
  %4 = load i32, i32* %e, align 4, !dbg !2460
  %add = add nsw i32 %4, 16383, !dbg !2461
  %u = bitcast %union.long_double_bits* %fb to %struct.uqwords*, !dbg !2462
  %high = getelementptr inbounds %struct.uqwords, %struct.uqwords* %u, i32 0, i32 1, !dbg !2463
  %s = bitcast %union.udwords* %high to %struct.anon*, !dbg !2464
  %low = getelementptr inbounds %struct.anon, %struct.anon* %s, i32 0, i32 0, !dbg !2465
  store i32 %add, i32* %low, align 8, !dbg !2466
  %5 = load i64, i64* %a.addr, align 8, !dbg !2467
  %6 = load i32, i32* %clz, align 4, !dbg !2468
  %sh_prom = zext i32 %6 to i64, !dbg !2469
  %shl = shl i64 %5, %sh_prom, !dbg !2469
  %u1 = bitcast %union.long_double_bits* %fb to %struct.uqwords*, !dbg !2470
  %low2 = getelementptr inbounds %struct.uqwords, %struct.uqwords* %u1, i32 0, i32 0, !dbg !2471
  %all = bitcast %union.udwords* %low2 to i64*, !dbg !2472
  store i64 %shl, i64* %all, align 8, !dbg !2473
  %f = bitcast %union.long_double_bits* %fb to double*, !dbg !2474
  %7 = load double, double* %f, align 8, !dbg !2474
  store double %7, double* %retval, align 8, !dbg !2475
  br label %return, !dbg !2475

return:                                           ; preds = %if.end, %if.then
  %8 = load double, double* %retval, align 8, !dbg !2476
  ret double %8, !dbg !2476
}

; Function Attrs: noinline nounwind
define dso_local arm_aapcscc double @__floatunsidf(i32 noundef %a) #0 !dbg !2477 {
entry:
  %retval = alloca double, align 8
  %a.addr = alloca i32, align 4
  %aWidth = alloca i32, align 4
  %exponent = alloca i32, align 4
  %result = alloca i64, align 8
  %shift = alloca i32, align 4
  store i32 %a, i32* %a.addr, align 4
  store i32 32, i32* %aWidth, align 4, !dbg !2478
  %0 = load i32, i32* %a.addr, align 4, !dbg !2479
  %cmp = icmp eq i32 %0, 0, !dbg !2480
  br i1 %cmp, label %if.then, label %if.end, !dbg !2479

if.then:                                          ; preds = %entry
  %call = call arm_aapcscc double @fromRep.31(i64 noundef 0) #4, !dbg !2481
  store double %call, double* %retval, align 8, !dbg !2482
  br label %return, !dbg !2482

if.end:                                           ; preds = %entry
  %1 = load i32, i32* %a.addr, align 4, !dbg !2483
  %2 = call i32 @llvm.ctlz.i32(i32 %1, i1 false), !dbg !2484
  %sub = sub nsw i32 31, %2, !dbg !2485
  store i32 %sub, i32* %exponent, align 4, !dbg !2486
  %3 = load i32, i32* %exponent, align 4, !dbg !2487
  %sub1 = sub nsw i32 52, %3, !dbg !2488
  store i32 %sub1, i32* %shift, align 4, !dbg !2489
  %4 = load i32, i32* %a.addr, align 4, !dbg !2490
  %conv = zext i32 %4 to i64, !dbg !2491
  %5 = load i32, i32* %shift, align 4, !dbg !2492
  %sh_prom = zext i32 %5 to i64, !dbg !2493
  %shl = shl i64 %conv, %sh_prom, !dbg !2493
  %xor = xor i64 %shl, 4503599627370496, !dbg !2494
  store i64 %xor, i64* %result, align 8, !dbg !2495
  %6 = load i32, i32* %exponent, align 4, !dbg !2496
  %add = add nsw i32 %6, 1023, !dbg !2497
  %conv2 = sext i32 %add to i64, !dbg !2498
  %shl3 = shl i64 %conv2, 52, !dbg !2499
  %7 = load i64, i64* %result, align 8, !dbg !2500
  %add4 = add i64 %7, %shl3, !dbg !2500
  store i64 %add4, i64* %result, align 8, !dbg !2500
  %8 = load i64, i64* %result, align 8, !dbg !2501
  %call5 = call arm_aapcscc double @fromRep.31(i64 noundef %8) #4, !dbg !2502
  store double %call5, double* %retval, align 8, !dbg !2503
  br label %return, !dbg !2503

return:                                           ; preds = %if.end, %if.then
  %9 = load double, double* %retval, align 8, !dbg !2504
  ret double %9, !dbg !2504
}

; Function Attrs: noinline nounwind
define internal arm_aapcscc double @fromRep.31(i64 noundef %x) #0 !dbg !2505 {
entry:
  %x.addr = alloca i64, align 8
  %rep = alloca %union.anon.0, align 8
  store i64 %x, i64* %x.addr, align 8
  %i = bitcast %union.anon.0* %rep to i64*, !dbg !2506
  %0 = load i64, i64* %x.addr, align 8, !dbg !2507
  store i64 %0, i64* %i, align 8, !dbg !2506
  %f = bitcast %union.anon.0* %rep to double*, !dbg !2508
  %1 = load double, double* %f, align 8, !dbg !2508
  ret double %1, !dbg !2509
}

; Function Attrs: noinline nounwind
define dso_local arm_aapcscc float @__floatunsisf(i32 noundef %a) #0 !dbg !2510 {
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
  store i32 32, i32* %aWidth, align 4, !dbg !2511
  %0 = load i32, i32* %a.addr, align 4, !dbg !2512
  %cmp = icmp eq i32 %0, 0, !dbg !2513
  br i1 %cmp, label %if.then, label %if.end, !dbg !2512

if.then:                                          ; preds = %entry
  %call = call arm_aapcscc float @fromRep.32(i32 noundef 0) #4, !dbg !2514
  store float %call, float* %retval, align 4, !dbg !2515
  br label %return, !dbg !2515

if.end:                                           ; preds = %entry
  %1 = load i32, i32* %a.addr, align 4, !dbg !2516
  %2 = call i32 @llvm.ctlz.i32(i32 %1, i1 false), !dbg !2517
  %sub = sub nsw i32 31, %2, !dbg !2518
  store i32 %sub, i32* %exponent, align 4, !dbg !2519
  %3 = load i32, i32* %exponent, align 4, !dbg !2520
  %cmp1 = icmp sle i32 %3, 23, !dbg !2521
  br i1 %cmp1, label %if.then2, label %if.else, !dbg !2520

if.then2:                                         ; preds = %if.end
  %4 = load i32, i32* %exponent, align 4, !dbg !2522
  %sub3 = sub nsw i32 23, %4, !dbg !2523
  store i32 %sub3, i32* %shift, align 4, !dbg !2524
  %5 = load i32, i32* %a.addr, align 4, !dbg !2525
  %6 = load i32, i32* %shift, align 4, !dbg !2526
  %shl = shl i32 %5, %6, !dbg !2527
  %xor = xor i32 %shl, 8388608, !dbg !2528
  store i32 %xor, i32* %result, align 4, !dbg !2529
  br label %if.end15, !dbg !2530

if.else:                                          ; preds = %if.end
  %7 = load i32, i32* %exponent, align 4, !dbg !2531
  %sub5 = sub nsw i32 %7, 23, !dbg !2532
  store i32 %sub5, i32* %shift4, align 4, !dbg !2533
  %8 = load i32, i32* %a.addr, align 4, !dbg !2534
  %9 = load i32, i32* %shift4, align 4, !dbg !2535
  %shr = lshr i32 %8, %9, !dbg !2536
  %xor6 = xor i32 %shr, 8388608, !dbg !2537
  store i32 %xor6, i32* %result, align 4, !dbg !2538
  %10 = load i32, i32* %a.addr, align 4, !dbg !2539
  %11 = load i32, i32* %shift4, align 4, !dbg !2540
  %sub7 = sub i32 32, %11, !dbg !2541
  %shl8 = shl i32 %10, %sub7, !dbg !2542
  store i32 %shl8, i32* %round, align 4, !dbg !2543
  %12 = load i32, i32* %round, align 4, !dbg !2544
  %cmp9 = icmp ugt i32 %12, -2147483648, !dbg !2545
  br i1 %cmp9, label %if.then10, label %if.end11, !dbg !2544

if.then10:                                        ; preds = %if.else
  %13 = load i32, i32* %result, align 4, !dbg !2546
  %inc = add i32 %13, 1, !dbg !2546
  store i32 %inc, i32* %result, align 4, !dbg !2546
  br label %if.end11, !dbg !2547

if.end11:                                         ; preds = %if.then10, %if.else
  %14 = load i32, i32* %round, align 4, !dbg !2548
  %cmp12 = icmp eq i32 %14, -2147483648, !dbg !2549
  br i1 %cmp12, label %if.then13, label %if.end14, !dbg !2548

if.then13:                                        ; preds = %if.end11
  %15 = load i32, i32* %result, align 4, !dbg !2550
  %and = and i32 %15, 1, !dbg !2551
  %16 = load i32, i32* %result, align 4, !dbg !2552
  %add = add i32 %16, %and, !dbg !2552
  store i32 %add, i32* %result, align 4, !dbg !2552
  br label %if.end14, !dbg !2553

if.end14:                                         ; preds = %if.then13, %if.end11
  br label %if.end15

if.end15:                                         ; preds = %if.end14, %if.then2
  %17 = load i32, i32* %exponent, align 4, !dbg !2554
  %add16 = add nsw i32 %17, 127, !dbg !2555
  %shl17 = shl i32 %add16, 23, !dbg !2556
  %18 = load i32, i32* %result, align 4, !dbg !2557
  %add18 = add i32 %18, %shl17, !dbg !2557
  store i32 %add18, i32* %result, align 4, !dbg !2557
  %19 = load i32, i32* %result, align 4, !dbg !2558
  %call19 = call arm_aapcscc float @fromRep.32(i32 noundef %19) #4, !dbg !2559
  store float %call19, float* %retval, align 4, !dbg !2560
  br label %return, !dbg !2560

return:                                           ; preds = %if.end15, %if.then
  %20 = load float, float* %retval, align 4, !dbg !2561
  ret float %20, !dbg !2561
}

; Function Attrs: noinline nounwind
define internal arm_aapcscc float @fromRep.32(i32 noundef %x) #0 !dbg !2562 {
entry:
  %x.addr = alloca i32, align 4
  %rep = alloca %union.anon.0.0, align 4
  store i32 %x, i32* %x.addr, align 4
  %i = bitcast %union.anon.0.0* %rep to i32*, !dbg !2563
  %0 = load i32, i32* %x.addr, align 4, !dbg !2564
  store i32 %0, i32* %i, align 4, !dbg !2563
  %f = bitcast %union.anon.0.0* %rep to float*, !dbg !2565
  %1 = load float, float* %f, align 4, !dbg !2565
  ret float %1, !dbg !2566
}

; Function Attrs: noinline noreturn nounwind
define weak hidden arm_aapcscc void @compilerrt_abort_impl(i8* noundef %file, i32 noundef %line, i8* noundef %function) #3 !dbg !2567 {
entry:
  %file.addr = alloca i8*, align 4
  %line.addr = alloca i32, align 4
  %function.addr = alloca i8*, align 4
  store i8* %file, i8** %file.addr, align 4
  store i32 %line, i32* %line.addr, align 4
  store i8* %function, i8** %function.addr, align 4
  unreachable, !dbg !2568
}

; Function Attrs: noinline nounwind
define dso_local arm_aapcscc double @__muldf3(double noundef %a, double noundef %b) #0 !dbg !2569 {
entry:
  %a.addr = alloca double, align 8
  %b.addr = alloca double, align 8
  store double %a, double* %a.addr, align 8
  store double %b, double* %b.addr, align 8
  %0 = load double, double* %a.addr, align 8, !dbg !2570
  %1 = load double, double* %b.addr, align 8, !dbg !2571
  %call = call arm_aapcscc double @__mulXf3__(double noundef %0, double noundef %1) #4, !dbg !2572
  ret double %call, !dbg !2573
}

; Function Attrs: noinline nounwind
define internal arm_aapcscc double @__mulXf3__(double noundef %a, double noundef %b) #0 !dbg !2574 {
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
  %0 = load double, double* %a.addr, align 8, !dbg !2576
  %call = call arm_aapcscc i64 @toRep.33(double noundef %0) #4, !dbg !2577
  %shr = lshr i64 %call, 52, !dbg !2578
  %and = and i64 %shr, 2047, !dbg !2579
  %conv = trunc i64 %and to i32, !dbg !2577
  store i32 %conv, i32* %aExponent, align 4, !dbg !2580
  %1 = load double, double* %b.addr, align 8, !dbg !2581
  %call1 = call arm_aapcscc i64 @toRep.33(double noundef %1) #4, !dbg !2582
  %shr2 = lshr i64 %call1, 52, !dbg !2583
  %and3 = and i64 %shr2, 2047, !dbg !2584
  %conv4 = trunc i64 %and3 to i32, !dbg !2582
  store i32 %conv4, i32* %bExponent, align 4, !dbg !2585
  %2 = load double, double* %a.addr, align 8, !dbg !2586
  %call5 = call arm_aapcscc i64 @toRep.33(double noundef %2) #4, !dbg !2587
  %3 = load double, double* %b.addr, align 8, !dbg !2588
  %call6 = call arm_aapcscc i64 @toRep.33(double noundef %3) #4, !dbg !2589
  %xor = xor i64 %call5, %call6, !dbg !2590
  %and7 = and i64 %xor, -9223372036854775808, !dbg !2591
  store i64 %and7, i64* %productSign, align 8, !dbg !2592
  %4 = load double, double* %a.addr, align 8, !dbg !2593
  %call8 = call arm_aapcscc i64 @toRep.33(double noundef %4) #4, !dbg !2594
  %and9 = and i64 %call8, 4503599627370495, !dbg !2595
  store i64 %and9, i64* %aSignificand, align 8, !dbg !2596
  %5 = load double, double* %b.addr, align 8, !dbg !2597
  %call10 = call arm_aapcscc i64 @toRep.33(double noundef %5) #4, !dbg !2598
  %and11 = and i64 %call10, 4503599627370495, !dbg !2599
  store i64 %and11, i64* %bSignificand, align 8, !dbg !2600
  store i32 0, i32* %scale, align 4, !dbg !2601
  %6 = load i32, i32* %aExponent, align 4, !dbg !2602
  %sub = sub i32 %6, 1, !dbg !2603
  %cmp = icmp uge i32 %sub, 2046, !dbg !2604
  br i1 %cmp, label %if.then, label %lor.lhs.false, !dbg !2605

lor.lhs.false:                                    ; preds = %entry
  %7 = load i32, i32* %bExponent, align 4, !dbg !2606
  %sub13 = sub i32 %7, 1, !dbg !2607
  %cmp14 = icmp uge i32 %sub13, 2046, !dbg !2608
  br i1 %cmp14, label %if.then, label %if.end69, !dbg !2602

if.then:                                          ; preds = %lor.lhs.false, %entry
  %8 = load double, double* %a.addr, align 8, !dbg !2609
  %call16 = call arm_aapcscc i64 @toRep.33(double noundef %8) #4, !dbg !2610
  %and17 = and i64 %call16, 9223372036854775807, !dbg !2611
  store i64 %and17, i64* %aAbs, align 8, !dbg !2612
  %9 = load double, double* %b.addr, align 8, !dbg !2613
  %call18 = call arm_aapcscc i64 @toRep.33(double noundef %9) #4, !dbg !2614
  %and19 = and i64 %call18, 9223372036854775807, !dbg !2615
  store i64 %and19, i64* %bAbs, align 8, !dbg !2616
  %10 = load i64, i64* %aAbs, align 8, !dbg !2617
  %cmp20 = icmp ugt i64 %10, 9218868437227405312, !dbg !2618
  br i1 %cmp20, label %if.then22, label %if.end, !dbg !2617

if.then22:                                        ; preds = %if.then
  %11 = load double, double* %a.addr, align 8, !dbg !2619
  %call23 = call arm_aapcscc i64 @toRep.33(double noundef %11) #4, !dbg !2620
  %or = or i64 %call23, 2251799813685248, !dbg !2621
  %call24 = call arm_aapcscc double @fromRep.34(i64 noundef %or) #4, !dbg !2622
  store double %call24, double* %retval, align 8, !dbg !2623
  br label %return, !dbg !2623

if.end:                                           ; preds = %if.then
  %12 = load i64, i64* %bAbs, align 8, !dbg !2624
  %cmp25 = icmp ugt i64 %12, 9218868437227405312, !dbg !2625
  br i1 %cmp25, label %if.then27, label %if.end31, !dbg !2624

if.then27:                                        ; preds = %if.end
  %13 = load double, double* %b.addr, align 8, !dbg !2626
  %call28 = call arm_aapcscc i64 @toRep.33(double noundef %13) #4, !dbg !2627
  %or29 = or i64 %call28, 2251799813685248, !dbg !2628
  %call30 = call arm_aapcscc double @fromRep.34(i64 noundef %or29) #4, !dbg !2629
  store double %call30, double* %retval, align 8, !dbg !2630
  br label %return, !dbg !2630

if.end31:                                         ; preds = %if.end
  %14 = load i64, i64* %aAbs, align 8, !dbg !2631
  %cmp32 = icmp eq i64 %14, 9218868437227405312, !dbg !2632
  br i1 %cmp32, label %if.then34, label %if.end39, !dbg !2631

if.then34:                                        ; preds = %if.end31
  %15 = load i64, i64* %bAbs, align 8, !dbg !2633
  %tobool = icmp ne i64 %15, 0, !dbg !2633
  br i1 %tobool, label %if.then35, label %if.else, !dbg !2633

if.then35:                                        ; preds = %if.then34
  %16 = load i64, i64* %aAbs, align 8, !dbg !2634
  %17 = load i64, i64* %productSign, align 8, !dbg !2635
  %or36 = or i64 %16, %17, !dbg !2636
  %call37 = call arm_aapcscc double @fromRep.34(i64 noundef %or36) #4, !dbg !2637
  store double %call37, double* %retval, align 8, !dbg !2638
  br label %return, !dbg !2638

if.else:                                          ; preds = %if.then34
  %call38 = call arm_aapcscc double @fromRep.34(i64 noundef 9221120237041090560) #4, !dbg !2639
  store double %call38, double* %retval, align 8, !dbg !2640
  br label %return, !dbg !2640

if.end39:                                         ; preds = %if.end31
  %18 = load i64, i64* %bAbs, align 8, !dbg !2641
  %cmp40 = icmp eq i64 %18, 9218868437227405312, !dbg !2642
  br i1 %cmp40, label %if.then42, label %if.end49, !dbg !2641

if.then42:                                        ; preds = %if.end39
  %19 = load i64, i64* %aAbs, align 8, !dbg !2643
  %tobool43 = icmp ne i64 %19, 0, !dbg !2643
  br i1 %tobool43, label %if.then44, label %if.else47, !dbg !2643

if.then44:                                        ; preds = %if.then42
  %20 = load i64, i64* %bAbs, align 8, !dbg !2644
  %21 = load i64, i64* %productSign, align 8, !dbg !2645
  %or45 = or i64 %20, %21, !dbg !2646
  %call46 = call arm_aapcscc double @fromRep.34(i64 noundef %or45) #4, !dbg !2647
  store double %call46, double* %retval, align 8, !dbg !2648
  br label %return, !dbg !2648

if.else47:                                        ; preds = %if.then42
  %call48 = call arm_aapcscc double @fromRep.34(i64 noundef 9221120237041090560) #4, !dbg !2649
  store double %call48, double* %retval, align 8, !dbg !2650
  br label %return, !dbg !2650

if.end49:                                         ; preds = %if.end39
  %22 = load i64, i64* %aAbs, align 8, !dbg !2651
  %tobool50 = icmp ne i64 %22, 0, !dbg !2651
  br i1 %tobool50, label %if.end53, label %if.then51, !dbg !2652

if.then51:                                        ; preds = %if.end49
  %23 = load i64, i64* %productSign, align 8, !dbg !2653
  %call52 = call arm_aapcscc double @fromRep.34(i64 noundef %23) #4, !dbg !2654
  store double %call52, double* %retval, align 8, !dbg !2655
  br label %return, !dbg !2655

if.end53:                                         ; preds = %if.end49
  %24 = load i64, i64* %bAbs, align 8, !dbg !2656
  %tobool54 = icmp ne i64 %24, 0, !dbg !2656
  br i1 %tobool54, label %if.end57, label %if.then55, !dbg !2657

if.then55:                                        ; preds = %if.end53
  %25 = load i64, i64* %productSign, align 8, !dbg !2658
  %call56 = call arm_aapcscc double @fromRep.34(i64 noundef %25) #4, !dbg !2659
  store double %call56, double* %retval, align 8, !dbg !2660
  br label %return, !dbg !2660

if.end57:                                         ; preds = %if.end53
  %26 = load i64, i64* %aAbs, align 8, !dbg !2661
  %cmp58 = icmp ult i64 %26, 4503599627370496, !dbg !2662
  br i1 %cmp58, label %if.then60, label %if.end62, !dbg !2661

if.then60:                                        ; preds = %if.end57
  %call61 = call arm_aapcscc i32 @normalize.35(i64* noundef %aSignificand) #4, !dbg !2663
  %27 = load i32, i32* %scale, align 4, !dbg !2664
  %add = add nsw i32 %27, %call61, !dbg !2664
  store i32 %add, i32* %scale, align 4, !dbg !2664
  br label %if.end62, !dbg !2665

if.end62:                                         ; preds = %if.then60, %if.end57
  %28 = load i64, i64* %bAbs, align 8, !dbg !2666
  %cmp63 = icmp ult i64 %28, 4503599627370496, !dbg !2667
  br i1 %cmp63, label %if.then65, label %if.end68, !dbg !2666

if.then65:                                        ; preds = %if.end62
  %call66 = call arm_aapcscc i32 @normalize.35(i64* noundef %bSignificand) #4, !dbg !2668
  %29 = load i32, i32* %scale, align 4, !dbg !2669
  %add67 = add nsw i32 %29, %call66, !dbg !2669
  store i32 %add67, i32* %scale, align 4, !dbg !2669
  br label %if.end68, !dbg !2670

if.end68:                                         ; preds = %if.then65, %if.end62
  br label %if.end69, !dbg !2671

if.end69:                                         ; preds = %if.end68, %lor.lhs.false
  %30 = load i64, i64* %aSignificand, align 8, !dbg !2672
  %or70 = or i64 %30, 4503599627370496, !dbg !2672
  store i64 %or70, i64* %aSignificand, align 8, !dbg !2672
  %31 = load i64, i64* %bSignificand, align 8, !dbg !2673
  %or71 = or i64 %31, 4503599627370496, !dbg !2673
  store i64 %or71, i64* %bSignificand, align 8, !dbg !2673
  %32 = load i64, i64* %aSignificand, align 8, !dbg !2674
  %33 = load i64, i64* %bSignificand, align 8, !dbg !2675
  %shl = shl i64 %33, 11, !dbg !2676
  call arm_aapcscc void @wideMultiply.36(i64 noundef %32, i64 noundef %shl, i64* noundef %productHi, i64* noundef %productLo) #4, !dbg !2677
  %34 = load i32, i32* %aExponent, align 4, !dbg !2678
  %35 = load i32, i32* %bExponent, align 4, !dbg !2679
  %add72 = add i32 %34, %35, !dbg !2680
  %sub73 = sub i32 %add72, 1023, !dbg !2681
  %36 = load i32, i32* %scale, align 4, !dbg !2682
  %add74 = add i32 %sub73, %36, !dbg !2683
  store i32 %add74, i32* %productExponent, align 4, !dbg !2684
  %37 = load i64, i64* %productHi, align 8, !dbg !2685
  %and75 = and i64 %37, 4503599627370496, !dbg !2686
  %tobool76 = icmp ne i64 %and75, 0, !dbg !2686
  br i1 %tobool76, label %if.then77, label %if.else78, !dbg !2685

if.then77:                                        ; preds = %if.end69
  %38 = load i32, i32* %productExponent, align 4, !dbg !2687
  %inc = add nsw i32 %38, 1, !dbg !2687
  store i32 %inc, i32* %productExponent, align 4, !dbg !2687
  br label %if.end79, !dbg !2688

if.else78:                                        ; preds = %if.end69
  call arm_aapcscc void @wideLeftShift(i64* noundef %productHi, i64* noundef %productLo, i32 noundef 1) #4, !dbg !2689
  br label %if.end79

if.end79:                                         ; preds = %if.else78, %if.then77
  %39 = load i32, i32* %productExponent, align 4, !dbg !2690
  %cmp80 = icmp sge i32 %39, 2047, !dbg !2691
  br i1 %cmp80, label %if.then82, label %if.end85, !dbg !2690

if.then82:                                        ; preds = %if.end79
  %40 = load i64, i64* %productSign, align 8, !dbg !2692
  %or83 = or i64 9218868437227405312, %40, !dbg !2693
  %call84 = call arm_aapcscc double @fromRep.34(i64 noundef %or83) #4, !dbg !2694
  store double %call84, double* %retval, align 8, !dbg !2695
  br label %return, !dbg !2695

if.end85:                                         ; preds = %if.end79
  %41 = load i32, i32* %productExponent, align 4, !dbg !2696
  %cmp86 = icmp sle i32 %41, 0, !dbg !2697
  br i1 %cmp86, label %if.then88, label %if.else97, !dbg !2696

if.then88:                                        ; preds = %if.end85
  %42 = load i32, i32* %productExponent, align 4, !dbg !2698
  %conv89 = zext i32 %42 to i64, !dbg !2699
  %sub90 = sub i64 1, %conv89, !dbg !2700
  %conv91 = trunc i64 %sub90 to i32, !dbg !2701
  store i32 %conv91, i32* %shift, align 4, !dbg !2702
  %43 = load i32, i32* %shift, align 4, !dbg !2703
  %cmp92 = icmp uge i32 %43, 64, !dbg !2704
  br i1 %cmp92, label %if.then94, label %if.end96, !dbg !2703

if.then94:                                        ; preds = %if.then88
  %44 = load i64, i64* %productSign, align 8, !dbg !2705
  %call95 = call arm_aapcscc double @fromRep.34(i64 noundef %44) #4, !dbg !2706
  store double %call95, double* %retval, align 8, !dbg !2707
  br label %return, !dbg !2707

if.end96:                                         ; preds = %if.then88
  %45 = load i32, i32* %shift, align 4, !dbg !2708
  call arm_aapcscc void @wideRightShiftWithSticky(i64* noundef %productHi, i64* noundef %productLo, i32 noundef %45) #4, !dbg !2709
  br label %if.end102, !dbg !2710

if.else97:                                        ; preds = %if.end85
  %46 = load i64, i64* %productHi, align 8, !dbg !2711
  %and98 = and i64 %46, 4503599627370495, !dbg !2711
  store i64 %and98, i64* %productHi, align 8, !dbg !2711
  %47 = load i32, i32* %productExponent, align 4, !dbg !2712
  %conv99 = sext i32 %47 to i64, !dbg !2713
  %shl100 = shl i64 %conv99, 52, !dbg !2714
  %48 = load i64, i64* %productHi, align 8, !dbg !2715
  %or101 = or i64 %48, %shl100, !dbg !2715
  store i64 %or101, i64* %productHi, align 8, !dbg !2715
  br label %if.end102

if.end102:                                        ; preds = %if.else97, %if.end96
  %49 = load i64, i64* %productSign, align 8, !dbg !2716
  %50 = load i64, i64* %productHi, align 8, !dbg !2717
  %or103 = or i64 %50, %49, !dbg !2717
  store i64 %or103, i64* %productHi, align 8, !dbg !2717
  %51 = load i64, i64* %productLo, align 8, !dbg !2718
  %cmp104 = icmp ugt i64 %51, -9223372036854775808, !dbg !2719
  br i1 %cmp104, label %if.then106, label %if.end108, !dbg !2718

if.then106:                                       ; preds = %if.end102
  %52 = load i64, i64* %productHi, align 8, !dbg !2720
  %inc107 = add i64 %52, 1, !dbg !2720
  store i64 %inc107, i64* %productHi, align 8, !dbg !2720
  br label %if.end108, !dbg !2721

if.end108:                                        ; preds = %if.then106, %if.end102
  %53 = load i64, i64* %productLo, align 8, !dbg !2722
  %cmp109 = icmp eq i64 %53, -9223372036854775808, !dbg !2723
  br i1 %cmp109, label %if.then111, label %if.end114, !dbg !2722

if.then111:                                       ; preds = %if.end108
  %54 = load i64, i64* %productHi, align 8, !dbg !2724
  %and112 = and i64 %54, 1, !dbg !2725
  %55 = load i64, i64* %productHi, align 8, !dbg !2726
  %add113 = add i64 %55, %and112, !dbg !2726
  store i64 %add113, i64* %productHi, align 8, !dbg !2726
  br label %if.end114, !dbg !2727

if.end114:                                        ; preds = %if.then111, %if.end108
  %56 = load i64, i64* %productHi, align 8, !dbg !2728
  %call115 = call arm_aapcscc double @fromRep.34(i64 noundef %56) #4, !dbg !2729
  store double %call115, double* %retval, align 8, !dbg !2730
  br label %return, !dbg !2730

return:                                           ; preds = %if.end114, %if.then94, %if.then82, %if.then55, %if.then51, %if.else47, %if.then44, %if.else, %if.then35, %if.then27, %if.then22
  %57 = load double, double* %retval, align 8, !dbg !2731
  ret double %57, !dbg !2731
}

; Function Attrs: noinline nounwind
define internal arm_aapcscc i64 @toRep.33(double noundef %x) #0 !dbg !2732 {
entry:
  %x.addr = alloca double, align 8
  %rep = alloca %union.anon.0, align 8
  store double %x, double* %x.addr, align 8
  %f = bitcast %union.anon.0* %rep to double*, !dbg !2733
  %0 = load double, double* %x.addr, align 8, !dbg !2734
  store double %0, double* %f, align 8, !dbg !2733
  %i = bitcast %union.anon.0* %rep to i64*, !dbg !2735
  %1 = load i64, i64* %i, align 8, !dbg !2735
  ret i64 %1, !dbg !2736
}

; Function Attrs: noinline nounwind
define internal arm_aapcscc double @fromRep.34(i64 noundef %x) #0 !dbg !2737 {
entry:
  %x.addr = alloca i64, align 8
  %rep = alloca %union.anon.0, align 8
  store i64 %x, i64* %x.addr, align 8
  %i = bitcast %union.anon.0* %rep to i64*, !dbg !2738
  %0 = load i64, i64* %x.addr, align 8, !dbg !2739
  store i64 %0, i64* %i, align 8, !dbg !2738
  %f = bitcast %union.anon.0* %rep to double*, !dbg !2740
  %1 = load double, double* %f, align 8, !dbg !2740
  ret double %1, !dbg !2741
}

; Function Attrs: noinline nounwind
define internal arm_aapcscc i32 @normalize.35(i64* noundef %significand) #0 !dbg !2742 {
entry:
  %significand.addr = alloca i64*, align 4
  %shift = alloca i32, align 4
  store i64* %significand, i64** %significand.addr, align 4
  %0 = load i64*, i64** %significand.addr, align 4, !dbg !2743
  %1 = load i64, i64* %0, align 8, !dbg !2744
  %call = call arm_aapcscc i32 @rep_clz.37(i64 noundef %1) #4, !dbg !2745
  %call1 = call arm_aapcscc i32 @rep_clz.37(i64 noundef 4503599627370496) #4, !dbg !2746
  %sub = sub nsw i32 %call, %call1, !dbg !2747
  store i32 %sub, i32* %shift, align 4, !dbg !2748
  %2 = load i32, i32* %shift, align 4, !dbg !2749
  %3 = load i64*, i64** %significand.addr, align 4, !dbg !2750
  %4 = load i64, i64* %3, align 8, !dbg !2751
  %sh_prom = zext i32 %2 to i64, !dbg !2751
  %shl = shl i64 %4, %sh_prom, !dbg !2751
  store i64 %shl, i64* %3, align 8, !dbg !2751
  %5 = load i32, i32* %shift, align 4, !dbg !2752
  %sub2 = sub nsw i32 1, %5, !dbg !2753
  ret i32 %sub2, !dbg !2754
}

; Function Attrs: noinline nounwind
define internal arm_aapcscc void @wideMultiply.36(i64 noundef %a, i64 noundef %b, i64* noundef %hi, i64* noundef %lo) #0 !dbg !2755 {
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
  %0 = load i64, i64* %a.addr, align 8, !dbg !2756
  %and = and i64 %0, 4294967295, !dbg !2756
  %1 = load i64, i64* %b.addr, align 8, !dbg !2757
  %and1 = and i64 %1, 4294967295, !dbg !2757
  %mul = mul i64 %and, %and1, !dbg !2758
  store i64 %mul, i64* %plolo, align 8, !dbg !2759
  %2 = load i64, i64* %a.addr, align 8, !dbg !2760
  %and2 = and i64 %2, 4294967295, !dbg !2760
  %3 = load i64, i64* %b.addr, align 8, !dbg !2761
  %shr = lshr i64 %3, 32, !dbg !2761
  %mul3 = mul i64 %and2, %shr, !dbg !2762
  store i64 %mul3, i64* %plohi, align 8, !dbg !2763
  %4 = load i64, i64* %a.addr, align 8, !dbg !2764
  %shr4 = lshr i64 %4, 32, !dbg !2764
  %5 = load i64, i64* %b.addr, align 8, !dbg !2765
  %and5 = and i64 %5, 4294967295, !dbg !2765
  %mul6 = mul i64 %shr4, %and5, !dbg !2766
  store i64 %mul6, i64* %philo, align 8, !dbg !2767
  %6 = load i64, i64* %a.addr, align 8, !dbg !2768
  %shr7 = lshr i64 %6, 32, !dbg !2768
  %7 = load i64, i64* %b.addr, align 8, !dbg !2769
  %shr8 = lshr i64 %7, 32, !dbg !2769
  %mul9 = mul i64 %shr7, %shr8, !dbg !2770
  store i64 %mul9, i64* %phihi, align 8, !dbg !2771
  %8 = load i64, i64* %plolo, align 8, !dbg !2772
  %and10 = and i64 %8, 4294967295, !dbg !2772
  store i64 %and10, i64* %r0, align 8, !dbg !2773
  %9 = load i64, i64* %plolo, align 8, !dbg !2774
  %shr11 = lshr i64 %9, 32, !dbg !2774
  %10 = load i64, i64* %plohi, align 8, !dbg !2775
  %and12 = and i64 %10, 4294967295, !dbg !2775
  %add = add i64 %shr11, %and12, !dbg !2776
  %11 = load i64, i64* %philo, align 8, !dbg !2777
  %and13 = and i64 %11, 4294967295, !dbg !2777
  %add14 = add i64 %add, %and13, !dbg !2778
  store i64 %add14, i64* %r1, align 8, !dbg !2779
  %12 = load i64, i64* %r0, align 8, !dbg !2780
  %13 = load i64, i64* %r1, align 8, !dbg !2781
  %shl = shl i64 %13, 32, !dbg !2782
  %add15 = add i64 %12, %shl, !dbg !2783
  %14 = load i64*, i64** %lo.addr, align 4, !dbg !2784
  store i64 %add15, i64* %14, align 8, !dbg !2785
  %15 = load i64, i64* %plohi, align 8, !dbg !2786
  %shr16 = lshr i64 %15, 32, !dbg !2786
  %16 = load i64, i64* %philo, align 8, !dbg !2787
  %shr17 = lshr i64 %16, 32, !dbg !2787
  %add18 = add i64 %shr16, %shr17, !dbg !2788
  %17 = load i64, i64* %r1, align 8, !dbg !2789
  %shr19 = lshr i64 %17, 32, !dbg !2789
  %add20 = add i64 %add18, %shr19, !dbg !2790
  %18 = load i64, i64* %phihi, align 8, !dbg !2791
  %add21 = add i64 %add20, %18, !dbg !2792
  %19 = load i64*, i64** %hi.addr, align 4, !dbg !2793
  store i64 %add21, i64* %19, align 8, !dbg !2794
  ret void, !dbg !2795
}

; Function Attrs: noinline nounwind
define internal arm_aapcscc void @wideLeftShift(i64* noundef %hi, i64* noundef %lo, i32 noundef %count) #0 !dbg !2796 {
entry:
  %hi.addr = alloca i64*, align 4
  %lo.addr = alloca i64*, align 4
  %count.addr = alloca i32, align 4
  store i64* %hi, i64** %hi.addr, align 4
  store i64* %lo, i64** %lo.addr, align 4
  store i32 %count, i32* %count.addr, align 4
  %0 = load i64*, i64** %hi.addr, align 4, !dbg !2797
  %1 = load i64, i64* %0, align 8, !dbg !2798
  %2 = load i32, i32* %count.addr, align 4, !dbg !2799
  %sh_prom = zext i32 %2 to i64, !dbg !2800
  %shl = shl i64 %1, %sh_prom, !dbg !2800
  %3 = load i64*, i64** %lo.addr, align 4, !dbg !2801
  %4 = load i64, i64* %3, align 8, !dbg !2802
  %5 = load i32, i32* %count.addr, align 4, !dbg !2803
  %sub = sub i32 64, %5, !dbg !2804
  %sh_prom1 = zext i32 %sub to i64, !dbg !2805
  %shr = lshr i64 %4, %sh_prom1, !dbg !2805
  %or = or i64 %shl, %shr, !dbg !2806
  %6 = load i64*, i64** %hi.addr, align 4, !dbg !2807
  store i64 %or, i64* %6, align 8, !dbg !2808
  %7 = load i64*, i64** %lo.addr, align 4, !dbg !2809
  %8 = load i64, i64* %7, align 8, !dbg !2810
  %9 = load i32, i32* %count.addr, align 4, !dbg !2811
  %sh_prom2 = zext i32 %9 to i64, !dbg !2812
  %shl3 = shl i64 %8, %sh_prom2, !dbg !2812
  %10 = load i64*, i64** %lo.addr, align 4, !dbg !2813
  store i64 %shl3, i64* %10, align 8, !dbg !2814
  ret void, !dbg !2815
}

; Function Attrs: noinline nounwind
define internal arm_aapcscc void @wideRightShiftWithSticky(i64* noundef %hi, i64* noundef %lo, i32 noundef %count) #0 !dbg !2816 {
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
  %0 = load i32, i32* %count.addr, align 4, !dbg !2817
  %cmp = icmp ult i32 %0, 64, !dbg !2818
  br i1 %cmp, label %if.then, label %if.else, !dbg !2817

if.then:                                          ; preds = %entry
  %1 = load i64*, i64** %lo.addr, align 4, !dbg !2819
  %2 = load i64, i64* %1, align 8, !dbg !2820
  %3 = load i32, i32* %count.addr, align 4, !dbg !2821
  %sub = sub i32 64, %3, !dbg !2822
  %sh_prom = zext i32 %sub to i64, !dbg !2823
  %shl = shl i64 %2, %sh_prom, !dbg !2823
  %tobool = icmp ne i64 %shl, 0, !dbg !2820
  %frombool = zext i1 %tobool to i8, !dbg !2824
  store i8 %frombool, i8* %sticky, align 1, !dbg !2824
  %4 = load i64*, i64** %hi.addr, align 4, !dbg !2825
  %5 = load i64, i64* %4, align 8, !dbg !2826
  %6 = load i32, i32* %count.addr, align 4, !dbg !2827
  %sub1 = sub i32 64, %6, !dbg !2828
  %sh_prom2 = zext i32 %sub1 to i64, !dbg !2829
  %shl3 = shl i64 %5, %sh_prom2, !dbg !2829
  %7 = load i64*, i64** %lo.addr, align 4, !dbg !2830
  %8 = load i64, i64* %7, align 8, !dbg !2831
  %9 = load i32, i32* %count.addr, align 4, !dbg !2832
  %sh_prom4 = zext i32 %9 to i64, !dbg !2833
  %shr = lshr i64 %8, %sh_prom4, !dbg !2833
  %or = or i64 %shl3, %shr, !dbg !2834
  %10 = load i8, i8* %sticky, align 1, !dbg !2835
  %tobool5 = trunc i8 %10 to i1, !dbg !2835
  %conv = zext i1 %tobool5 to i64, !dbg !2835
  %or6 = or i64 %or, %conv, !dbg !2836
  %11 = load i64*, i64** %lo.addr, align 4, !dbg !2837
  store i64 %or6, i64* %11, align 8, !dbg !2838
  %12 = load i64*, i64** %hi.addr, align 4, !dbg !2839
  %13 = load i64, i64* %12, align 8, !dbg !2840
  %14 = load i32, i32* %count.addr, align 4, !dbg !2841
  %sh_prom7 = zext i32 %14 to i64, !dbg !2842
  %shr8 = lshr i64 %13, %sh_prom7, !dbg !2842
  %15 = load i64*, i64** %hi.addr, align 4, !dbg !2843
  store i64 %shr8, i64* %15, align 8, !dbg !2844
  br label %if.end32, !dbg !2845

if.else:                                          ; preds = %entry
  %16 = load i32, i32* %count.addr, align 4, !dbg !2846
  %cmp9 = icmp ult i32 %16, 128, !dbg !2847
  br i1 %cmp9, label %if.then11, label %if.else25, !dbg !2846

if.then11:                                        ; preds = %if.else
  %17 = load i64*, i64** %hi.addr, align 4, !dbg !2848
  %18 = load i64, i64* %17, align 8, !dbg !2849
  %19 = load i32, i32* %count.addr, align 4, !dbg !2850
  %sub13 = sub i32 128, %19, !dbg !2851
  %sh_prom14 = zext i32 %sub13 to i64, !dbg !2852
  %shl15 = shl i64 %18, %sh_prom14, !dbg !2852
  %20 = load i64*, i64** %lo.addr, align 4, !dbg !2853
  %21 = load i64, i64* %20, align 8, !dbg !2854
  %or16 = or i64 %shl15, %21, !dbg !2855
  %tobool17 = icmp ne i64 %or16, 0, !dbg !2849
  %frombool18 = zext i1 %tobool17 to i8, !dbg !2856
  store i8 %frombool18, i8* %sticky12, align 1, !dbg !2856
  %22 = load i64*, i64** %hi.addr, align 4, !dbg !2857
  %23 = load i64, i64* %22, align 8, !dbg !2858
  %24 = load i32, i32* %count.addr, align 4, !dbg !2859
  %sub19 = sub i32 %24, 64, !dbg !2860
  %sh_prom20 = zext i32 %sub19 to i64, !dbg !2861
  %shr21 = lshr i64 %23, %sh_prom20, !dbg !2861
  %25 = load i8, i8* %sticky12, align 1, !dbg !2862
  %tobool22 = trunc i8 %25 to i1, !dbg !2862
  %conv23 = zext i1 %tobool22 to i64, !dbg !2862
  %or24 = or i64 %shr21, %conv23, !dbg !2863
  %26 = load i64*, i64** %lo.addr, align 4, !dbg !2864
  store i64 %or24, i64* %26, align 8, !dbg !2865
  %27 = load i64*, i64** %hi.addr, align 4, !dbg !2866
  store i64 0, i64* %27, align 8, !dbg !2867
  br label %if.end, !dbg !2868

if.else25:                                        ; preds = %if.else
  %28 = load i64*, i64** %hi.addr, align 4, !dbg !2869
  %29 = load i64, i64* %28, align 8, !dbg !2870
  %30 = load i64*, i64** %lo.addr, align 4, !dbg !2871
  %31 = load i64, i64* %30, align 8, !dbg !2872
  %or27 = or i64 %29, %31, !dbg !2873
  %tobool28 = icmp ne i64 %or27, 0, !dbg !2870
  %frombool29 = zext i1 %tobool28 to i8, !dbg !2874
  store i8 %frombool29, i8* %sticky26, align 1, !dbg !2874
  %32 = load i8, i8* %sticky26, align 1, !dbg !2875
  %tobool30 = trunc i8 %32 to i1, !dbg !2875
  %conv31 = zext i1 %tobool30 to i64, !dbg !2875
  %33 = load i64*, i64** %lo.addr, align 4, !dbg !2876
  store i64 %conv31, i64* %33, align 8, !dbg !2877
  %34 = load i64*, i64** %hi.addr, align 4, !dbg !2878
  store i64 0, i64* %34, align 8, !dbg !2879
  br label %if.end

if.end:                                           ; preds = %if.else25, %if.then11
  br label %if.end32

if.end32:                                         ; preds = %if.end, %if.then
  ret void, !dbg !2880
}

; Function Attrs: noinline nounwind
define internal arm_aapcscc i32 @rep_clz.37(i64 noundef %a) #0 !dbg !2881 {
entry:
  %retval = alloca i32, align 4
  %a.addr = alloca i64, align 8
  store i64 %a, i64* %a.addr, align 8
  %0 = load i64, i64* %a.addr, align 8, !dbg !2882
  %and = and i64 %0, -4294967296, !dbg !2883
  %tobool = icmp ne i64 %and, 0, !dbg !2883
  br i1 %tobool, label %if.then, label %if.else, !dbg !2882

if.then:                                          ; preds = %entry
  %1 = load i64, i64* %a.addr, align 8, !dbg !2884
  %shr = lshr i64 %1, 32, !dbg !2885
  %conv = trunc i64 %shr to i32, !dbg !2884
  %2 = call i32 @llvm.ctlz.i32(i32 %conv, i1 false), !dbg !2886
  store i32 %2, i32* %retval, align 4, !dbg !2887
  br label %return, !dbg !2887

if.else:                                          ; preds = %entry
  %3 = load i64, i64* %a.addr, align 8, !dbg !2888
  %and1 = and i64 %3, 4294967295, !dbg !2889
  %conv2 = trunc i64 %and1 to i32, !dbg !2888
  %4 = call i32 @llvm.ctlz.i32(i32 %conv2, i1 false), !dbg !2890
  %add = add nsw i32 32, %4, !dbg !2891
  store i32 %add, i32* %retval, align 4, !dbg !2892
  br label %return, !dbg !2892

return:                                           ; preds = %if.else, %if.then
  %5 = load i32, i32* %retval, align 4, !dbg !2893
  ret i32 %5, !dbg !2893
}

; Function Attrs: noinline nounwind
define dso_local arm_aapcscc i64 @__muldi3(i64 noundef %a, i64 noundef %b) #0 !dbg !2894 {
entry:
  %a.addr = alloca i64, align 8
  %b.addr = alloca i64, align 8
  %x = alloca %union.udwords, align 8
  %y = alloca %union.udwords, align 8
  %r = alloca %union.udwords, align 8
  store i64 %a, i64* %a.addr, align 8
  store i64 %b, i64* %b.addr, align 8
  %0 = load i64, i64* %a.addr, align 8, !dbg !2895
  %all = bitcast %union.udwords* %x to i64*, !dbg !2896
  store i64 %0, i64* %all, align 8, !dbg !2897
  %1 = load i64, i64* %b.addr, align 8, !dbg !2898
  %all1 = bitcast %union.udwords* %y to i64*, !dbg !2899
  store i64 %1, i64* %all1, align 8, !dbg !2900
  %s = bitcast %union.udwords* %x to %struct.anon*, !dbg !2901
  %low = getelementptr inbounds %struct.anon, %struct.anon* %s, i32 0, i32 0, !dbg !2902
  %2 = load i32, i32* %low, align 8, !dbg !2902
  %s2 = bitcast %union.udwords* %y to %struct.anon*, !dbg !2903
  %low3 = getelementptr inbounds %struct.anon, %struct.anon* %s2, i32 0, i32 0, !dbg !2904
  %3 = load i32, i32* %low3, align 8, !dbg !2904
  %call = call arm_aapcscc i64 @__muldsi3(i32 noundef %2, i32 noundef %3) #4, !dbg !2905
  %all4 = bitcast %union.udwords* %r to i64*, !dbg !2906
  store i64 %call, i64* %all4, align 8, !dbg !2907
  %s5 = bitcast %union.udwords* %x to %struct.anon*, !dbg !2908
  %high = getelementptr inbounds %struct.anon, %struct.anon* %s5, i32 0, i32 1, !dbg !2909
  %4 = load i32, i32* %high, align 4, !dbg !2909
  %s6 = bitcast %union.udwords* %y to %struct.anon*, !dbg !2910
  %low7 = getelementptr inbounds %struct.anon, %struct.anon* %s6, i32 0, i32 0, !dbg !2911
  %5 = load i32, i32* %low7, align 8, !dbg !2911
  %mul = mul i32 %4, %5, !dbg !2912
  %s8 = bitcast %union.udwords* %x to %struct.anon*, !dbg !2913
  %low9 = getelementptr inbounds %struct.anon, %struct.anon* %s8, i32 0, i32 0, !dbg !2914
  %6 = load i32, i32* %low9, align 8, !dbg !2914
  %s10 = bitcast %union.udwords* %y to %struct.anon*, !dbg !2915
  %high11 = getelementptr inbounds %struct.anon, %struct.anon* %s10, i32 0, i32 1, !dbg !2916
  %7 = load i32, i32* %high11, align 4, !dbg !2916
  %mul12 = mul i32 %6, %7, !dbg !2917
  %add = add i32 %mul, %mul12, !dbg !2918
  %s13 = bitcast %union.udwords* %r to %struct.anon*, !dbg !2919
  %high14 = getelementptr inbounds %struct.anon, %struct.anon* %s13, i32 0, i32 1, !dbg !2920
  %8 = load i32, i32* %high14, align 4, !dbg !2921
  %add15 = add i32 %8, %add, !dbg !2921
  store i32 %add15, i32* %high14, align 4, !dbg !2921
  %all16 = bitcast %union.udwords* %r to i64*, !dbg !2922
  %9 = load i64, i64* %all16, align 8, !dbg !2922
  ret i64 %9, !dbg !2923
}

; Function Attrs: noinline nounwind
define internal arm_aapcscc i64 @__muldsi3(i32 noundef %a, i32 noundef %b) #0 !dbg !2924 {
entry:
  %a.addr = alloca i32, align 4
  %b.addr = alloca i32, align 4
  %r = alloca %union.udwords, align 8
  %bits_in_word_2 = alloca i32, align 4
  %lower_mask = alloca i32, align 4
  %t = alloca i32, align 4
  store i32 %a, i32* %a.addr, align 4
  store i32 %b, i32* %b.addr, align 4
  store i32 16, i32* %bits_in_word_2, align 4, !dbg !2925
  store i32 65535, i32* %lower_mask, align 4, !dbg !2926
  %0 = load i32, i32* %a.addr, align 4, !dbg !2927
  %and = and i32 %0, 65535, !dbg !2928
  %1 = load i32, i32* %b.addr, align 4, !dbg !2929
  %and1 = and i32 %1, 65535, !dbg !2930
  %mul = mul i32 %and, %and1, !dbg !2931
  %s = bitcast %union.udwords* %r to %struct.anon*, !dbg !2932
  %low = getelementptr inbounds %struct.anon, %struct.anon* %s, i32 0, i32 0, !dbg !2933
  store i32 %mul, i32* %low, align 8, !dbg !2934
  %s2 = bitcast %union.udwords* %r to %struct.anon*, !dbg !2935
  %low3 = getelementptr inbounds %struct.anon, %struct.anon* %s2, i32 0, i32 0, !dbg !2936
  %2 = load i32, i32* %low3, align 8, !dbg !2936
  %shr = lshr i32 %2, 16, !dbg !2937
  store i32 %shr, i32* %t, align 4, !dbg !2938
  %s4 = bitcast %union.udwords* %r to %struct.anon*, !dbg !2939
  %low5 = getelementptr inbounds %struct.anon, %struct.anon* %s4, i32 0, i32 0, !dbg !2940
  %3 = load i32, i32* %low5, align 8, !dbg !2941
  %and6 = and i32 %3, 65535, !dbg !2941
  store i32 %and6, i32* %low5, align 8, !dbg !2941
  %4 = load i32, i32* %a.addr, align 4, !dbg !2942
  %shr7 = lshr i32 %4, 16, !dbg !2943
  %5 = load i32, i32* %b.addr, align 4, !dbg !2944
  %and8 = and i32 %5, 65535, !dbg !2945
  %mul9 = mul i32 %shr7, %and8, !dbg !2946
  %6 = load i32, i32* %t, align 4, !dbg !2947
  %add = add i32 %6, %mul9, !dbg !2947
  store i32 %add, i32* %t, align 4, !dbg !2947
  %7 = load i32, i32* %t, align 4, !dbg !2948
  %and10 = and i32 %7, 65535, !dbg !2949
  %shl = shl i32 %and10, 16, !dbg !2950
  %s11 = bitcast %union.udwords* %r to %struct.anon*, !dbg !2951
  %low12 = getelementptr inbounds %struct.anon, %struct.anon* %s11, i32 0, i32 0, !dbg !2952
  %8 = load i32, i32* %low12, align 8, !dbg !2953
  %add13 = add i32 %8, %shl, !dbg !2953
  store i32 %add13, i32* %low12, align 8, !dbg !2953
  %9 = load i32, i32* %t, align 4, !dbg !2954
  %shr14 = lshr i32 %9, 16, !dbg !2955
  %s15 = bitcast %union.udwords* %r to %struct.anon*, !dbg !2956
  %high = getelementptr inbounds %struct.anon, %struct.anon* %s15, i32 0, i32 1, !dbg !2957
  store i32 %shr14, i32* %high, align 4, !dbg !2958
  %s16 = bitcast %union.udwords* %r to %struct.anon*, !dbg !2959
  %low17 = getelementptr inbounds %struct.anon, %struct.anon* %s16, i32 0, i32 0, !dbg !2960
  %10 = load i32, i32* %low17, align 8, !dbg !2960
  %shr18 = lshr i32 %10, 16, !dbg !2961
  store i32 %shr18, i32* %t, align 4, !dbg !2962
  %s19 = bitcast %union.udwords* %r to %struct.anon*, !dbg !2963
  %low20 = getelementptr inbounds %struct.anon, %struct.anon* %s19, i32 0, i32 0, !dbg !2964
  %11 = load i32, i32* %low20, align 8, !dbg !2965
  %and21 = and i32 %11, 65535, !dbg !2965
  store i32 %and21, i32* %low20, align 8, !dbg !2965
  %12 = load i32, i32* %b.addr, align 4, !dbg !2966
  %shr22 = lshr i32 %12, 16, !dbg !2967
  %13 = load i32, i32* %a.addr, align 4, !dbg !2968
  %and23 = and i32 %13, 65535, !dbg !2969
  %mul24 = mul i32 %shr22, %and23, !dbg !2970
  %14 = load i32, i32* %t, align 4, !dbg !2971
  %add25 = add i32 %14, %mul24, !dbg !2971
  store i32 %add25, i32* %t, align 4, !dbg !2971
  %15 = load i32, i32* %t, align 4, !dbg !2972
  %and26 = and i32 %15, 65535, !dbg !2973
  %shl27 = shl i32 %and26, 16, !dbg !2974
  %s28 = bitcast %union.udwords* %r to %struct.anon*, !dbg !2975
  %low29 = getelementptr inbounds %struct.anon, %struct.anon* %s28, i32 0, i32 0, !dbg !2976
  %16 = load i32, i32* %low29, align 8, !dbg !2977
  %add30 = add i32 %16, %shl27, !dbg !2977
  store i32 %add30, i32* %low29, align 8, !dbg !2977
  %17 = load i32, i32* %t, align 4, !dbg !2978
  %shr31 = lshr i32 %17, 16, !dbg !2979
  %s32 = bitcast %union.udwords* %r to %struct.anon*, !dbg !2980
  %high33 = getelementptr inbounds %struct.anon, %struct.anon* %s32, i32 0, i32 1, !dbg !2981
  %18 = load i32, i32* %high33, align 4, !dbg !2982
  %add34 = add i32 %18, %shr31, !dbg !2982
  store i32 %add34, i32* %high33, align 4, !dbg !2982
  %19 = load i32, i32* %a.addr, align 4, !dbg !2983
  %shr35 = lshr i32 %19, 16, !dbg !2984
  %20 = load i32, i32* %b.addr, align 4, !dbg !2985
  %shr36 = lshr i32 %20, 16, !dbg !2986
  %mul37 = mul i32 %shr35, %shr36, !dbg !2987
  %s38 = bitcast %union.udwords* %r to %struct.anon*, !dbg !2988
  %high39 = getelementptr inbounds %struct.anon, %struct.anon* %s38, i32 0, i32 1, !dbg !2989
  %21 = load i32, i32* %high39, align 4, !dbg !2990
  %add40 = add i32 %21, %mul37, !dbg !2990
  store i32 %add40, i32* %high39, align 4, !dbg !2990
  %all = bitcast %union.udwords* %r to i64*, !dbg !2991
  %22 = load i64, i64* %all, align 8, !dbg !2991
  ret i64 %22, !dbg !2992
}

; Function Attrs: noinline nounwind
define dso_local arm_aapcscc i64 @__mulodi4(i64 noundef %a, i64 noundef %b, i32* noundef %overflow) #0 !dbg !2993 {
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
  store i32 64, i32* %N, align 4, !dbg !2994
  store i64 -9223372036854775808, i64* %MIN, align 8, !dbg !2995
  store i64 9223372036854775807, i64* %MAX, align 8, !dbg !2996
  %0 = load i32*, i32** %overflow.addr, align 4, !dbg !2997
  store i32 0, i32* %0, align 4, !dbg !2998
  %1 = load i64, i64* %a.addr, align 8, !dbg !2999
  %2 = load i64, i64* %b.addr, align 8, !dbg !3000
  %mul = mul nsw i64 %1, %2, !dbg !3001
  store i64 %mul, i64* %result, align 8, !dbg !3002
  %3 = load i64, i64* %a.addr, align 8, !dbg !3003
  %cmp = icmp eq i64 %3, -9223372036854775808, !dbg !3004
  br i1 %cmp, label %if.then, label %if.end4, !dbg !3003

if.then:                                          ; preds = %entry
  %4 = load i64, i64* %b.addr, align 8, !dbg !3005
  %cmp1 = icmp ne i64 %4, 0, !dbg !3006
  br i1 %cmp1, label %land.lhs.true, label %if.end, !dbg !3007

land.lhs.true:                                    ; preds = %if.then
  %5 = load i64, i64* %b.addr, align 8, !dbg !3008
  %cmp2 = icmp ne i64 %5, 1, !dbg !3009
  br i1 %cmp2, label %if.then3, label %if.end, !dbg !3005

if.then3:                                         ; preds = %land.lhs.true
  %6 = load i32*, i32** %overflow.addr, align 4, !dbg !3010
  store i32 1, i32* %6, align 4, !dbg !3011
  br label %if.end, !dbg !3012

if.end:                                           ; preds = %if.then3, %land.lhs.true, %if.then
  %7 = load i64, i64* %result, align 8, !dbg !3013
  store i64 %7, i64* %retval, align 8, !dbg !3014
  br label %return, !dbg !3014

if.end4:                                          ; preds = %entry
  %8 = load i64, i64* %b.addr, align 8, !dbg !3015
  %cmp5 = icmp eq i64 %8, -9223372036854775808, !dbg !3016
  br i1 %cmp5, label %if.then6, label %if.end12, !dbg !3015

if.then6:                                         ; preds = %if.end4
  %9 = load i64, i64* %a.addr, align 8, !dbg !3017
  %cmp7 = icmp ne i64 %9, 0, !dbg !3018
  br i1 %cmp7, label %land.lhs.true8, label %if.end11, !dbg !3019

land.lhs.true8:                                   ; preds = %if.then6
  %10 = load i64, i64* %a.addr, align 8, !dbg !3020
  %cmp9 = icmp ne i64 %10, 1, !dbg !3021
  br i1 %cmp9, label %if.then10, label %if.end11, !dbg !3017

if.then10:                                        ; preds = %land.lhs.true8
  %11 = load i32*, i32** %overflow.addr, align 4, !dbg !3022
  store i32 1, i32* %11, align 4, !dbg !3023
  br label %if.end11, !dbg !3024

if.end11:                                         ; preds = %if.then10, %land.lhs.true8, %if.then6
  %12 = load i64, i64* %result, align 8, !dbg !3025
  store i64 %12, i64* %retval, align 8, !dbg !3026
  br label %return, !dbg !3026

if.end12:                                         ; preds = %if.end4
  %13 = load i64, i64* %a.addr, align 8, !dbg !3027
  %shr = ashr i64 %13, 63, !dbg !3028
  store i64 %shr, i64* %sa, align 8, !dbg !3029
  %14 = load i64, i64* %a.addr, align 8, !dbg !3030
  %15 = load i64, i64* %sa, align 8, !dbg !3031
  %xor = xor i64 %14, %15, !dbg !3032
  %16 = load i64, i64* %sa, align 8, !dbg !3033
  %sub = sub nsw i64 %xor, %16, !dbg !3034
  store i64 %sub, i64* %abs_a, align 8, !dbg !3035
  %17 = load i64, i64* %b.addr, align 8, !dbg !3036
  %shr13 = ashr i64 %17, 63, !dbg !3037
  store i64 %shr13, i64* %sb, align 8, !dbg !3038
  %18 = load i64, i64* %b.addr, align 8, !dbg !3039
  %19 = load i64, i64* %sb, align 8, !dbg !3040
  %xor14 = xor i64 %18, %19, !dbg !3041
  %20 = load i64, i64* %sb, align 8, !dbg !3042
  %sub15 = sub nsw i64 %xor14, %20, !dbg !3043
  store i64 %sub15, i64* %abs_b, align 8, !dbg !3044
  %21 = load i64, i64* %abs_a, align 8, !dbg !3045
  %cmp16 = icmp slt i64 %21, 2, !dbg !3046
  br i1 %cmp16, label %if.then18, label %lor.lhs.false, !dbg !3047

lor.lhs.false:                                    ; preds = %if.end12
  %22 = load i64, i64* %abs_b, align 8, !dbg !3048
  %cmp17 = icmp slt i64 %22, 2, !dbg !3049
  br i1 %cmp17, label %if.then18, label %if.end19, !dbg !3045

if.then18:                                        ; preds = %lor.lhs.false, %if.end12
  %23 = load i64, i64* %result, align 8, !dbg !3050
  store i64 %23, i64* %retval, align 8, !dbg !3051
  br label %return, !dbg !3051

if.end19:                                         ; preds = %lor.lhs.false
  %24 = load i64, i64* %sa, align 8, !dbg !3052
  %25 = load i64, i64* %sb, align 8, !dbg !3053
  %cmp20 = icmp eq i64 %24, %25, !dbg !3054
  br i1 %cmp20, label %if.then21, label %if.else, !dbg !3052

if.then21:                                        ; preds = %if.end19
  %26 = load i64, i64* %abs_a, align 8, !dbg !3055
  %27 = load i64, i64* %abs_b, align 8, !dbg !3056
  %div = sdiv i64 9223372036854775807, %27, !dbg !3057
  %cmp22 = icmp sgt i64 %26, %div, !dbg !3058
  br i1 %cmp22, label %if.then23, label %if.end24, !dbg !3055

if.then23:                                        ; preds = %if.then21
  %28 = load i32*, i32** %overflow.addr, align 4, !dbg !3059
  store i32 1, i32* %28, align 4, !dbg !3060
  br label %if.end24, !dbg !3061

if.end24:                                         ; preds = %if.then23, %if.then21
  br label %if.end30, !dbg !3062

if.else:                                          ; preds = %if.end19
  %29 = load i64, i64* %abs_a, align 8, !dbg !3063
  %30 = load i64, i64* %abs_b, align 8, !dbg !3064
  %sub25 = sub nsw i64 0, %30, !dbg !3065
  %div26 = sdiv i64 -9223372036854775808, %sub25, !dbg !3066
  %cmp27 = icmp sgt i64 %29, %div26, !dbg !3067
  br i1 %cmp27, label %if.then28, label %if.end29, !dbg !3063

if.then28:                                        ; preds = %if.else
  %31 = load i32*, i32** %overflow.addr, align 4, !dbg !3068
  store i32 1, i32* %31, align 4, !dbg !3069
  br label %if.end29, !dbg !3070

if.end29:                                         ; preds = %if.then28, %if.else
  br label %if.end30

if.end30:                                         ; preds = %if.end29, %if.end24
  %32 = load i64, i64* %result, align 8, !dbg !3071
  store i64 %32, i64* %retval, align 8, !dbg !3072
  br label %return, !dbg !3072

return:                                           ; preds = %if.end30, %if.then18, %if.end11, %if.end
  %33 = load i64, i64* %retval, align 8, !dbg !3073
  ret i64 %33, !dbg !3073
}

; Function Attrs: noinline nounwind
define dso_local arm_aapcscc i32 @__mulosi4(i32 noundef %a, i32 noundef %b, i32* noundef %overflow) #0 !dbg !3074 {
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
  store i32 32, i32* %N, align 4, !dbg !3075
  store i32 -2147483648, i32* %MIN, align 4, !dbg !3076
  store i32 2147483647, i32* %MAX, align 4, !dbg !3077
  %0 = load i32*, i32** %overflow.addr, align 4, !dbg !3078
  store i32 0, i32* %0, align 4, !dbg !3079
  %1 = load i32, i32* %a.addr, align 4, !dbg !3080
  %2 = load i32, i32* %b.addr, align 4, !dbg !3081
  %mul = mul nsw i32 %1, %2, !dbg !3082
  store i32 %mul, i32* %result, align 4, !dbg !3083
  %3 = load i32, i32* %a.addr, align 4, !dbg !3084
  %cmp = icmp eq i32 %3, -2147483648, !dbg !3085
  br i1 %cmp, label %if.then, label %if.end4, !dbg !3084

if.then:                                          ; preds = %entry
  %4 = load i32, i32* %b.addr, align 4, !dbg !3086
  %cmp1 = icmp ne i32 %4, 0, !dbg !3087
  br i1 %cmp1, label %land.lhs.true, label %if.end, !dbg !3088

land.lhs.true:                                    ; preds = %if.then
  %5 = load i32, i32* %b.addr, align 4, !dbg !3089
  %cmp2 = icmp ne i32 %5, 1, !dbg !3090
  br i1 %cmp2, label %if.then3, label %if.end, !dbg !3086

if.then3:                                         ; preds = %land.lhs.true
  %6 = load i32*, i32** %overflow.addr, align 4, !dbg !3091
  store i32 1, i32* %6, align 4, !dbg !3092
  br label %if.end, !dbg !3093

if.end:                                           ; preds = %if.then3, %land.lhs.true, %if.then
  %7 = load i32, i32* %result, align 4, !dbg !3094
  store i32 %7, i32* %retval, align 4, !dbg !3095
  br label %return, !dbg !3095

if.end4:                                          ; preds = %entry
  %8 = load i32, i32* %b.addr, align 4, !dbg !3096
  %cmp5 = icmp eq i32 %8, -2147483648, !dbg !3097
  br i1 %cmp5, label %if.then6, label %if.end12, !dbg !3096

if.then6:                                         ; preds = %if.end4
  %9 = load i32, i32* %a.addr, align 4, !dbg !3098
  %cmp7 = icmp ne i32 %9, 0, !dbg !3099
  br i1 %cmp7, label %land.lhs.true8, label %if.end11, !dbg !3100

land.lhs.true8:                                   ; preds = %if.then6
  %10 = load i32, i32* %a.addr, align 4, !dbg !3101
  %cmp9 = icmp ne i32 %10, 1, !dbg !3102
  br i1 %cmp9, label %if.then10, label %if.end11, !dbg !3098

if.then10:                                        ; preds = %land.lhs.true8
  %11 = load i32*, i32** %overflow.addr, align 4, !dbg !3103
  store i32 1, i32* %11, align 4, !dbg !3104
  br label %if.end11, !dbg !3105

if.end11:                                         ; preds = %if.then10, %land.lhs.true8, %if.then6
  %12 = load i32, i32* %result, align 4, !dbg !3106
  store i32 %12, i32* %retval, align 4, !dbg !3107
  br label %return, !dbg !3107

if.end12:                                         ; preds = %if.end4
  %13 = load i32, i32* %a.addr, align 4, !dbg !3108
  %shr = ashr i32 %13, 31, !dbg !3109
  store i32 %shr, i32* %sa, align 4, !dbg !3110
  %14 = load i32, i32* %a.addr, align 4, !dbg !3111
  %15 = load i32, i32* %sa, align 4, !dbg !3112
  %xor = xor i32 %14, %15, !dbg !3113
  %16 = load i32, i32* %sa, align 4, !dbg !3114
  %sub = sub nsw i32 %xor, %16, !dbg !3115
  store i32 %sub, i32* %abs_a, align 4, !dbg !3116
  %17 = load i32, i32* %b.addr, align 4, !dbg !3117
  %shr13 = ashr i32 %17, 31, !dbg !3118
  store i32 %shr13, i32* %sb, align 4, !dbg !3119
  %18 = load i32, i32* %b.addr, align 4, !dbg !3120
  %19 = load i32, i32* %sb, align 4, !dbg !3121
  %xor14 = xor i32 %18, %19, !dbg !3122
  %20 = load i32, i32* %sb, align 4, !dbg !3123
  %sub15 = sub nsw i32 %xor14, %20, !dbg !3124
  store i32 %sub15, i32* %abs_b, align 4, !dbg !3125
  %21 = load i32, i32* %abs_a, align 4, !dbg !3126
  %cmp16 = icmp slt i32 %21, 2, !dbg !3127
  br i1 %cmp16, label %if.then18, label %lor.lhs.false, !dbg !3128

lor.lhs.false:                                    ; preds = %if.end12
  %22 = load i32, i32* %abs_b, align 4, !dbg !3129
  %cmp17 = icmp slt i32 %22, 2, !dbg !3130
  br i1 %cmp17, label %if.then18, label %if.end19, !dbg !3126

if.then18:                                        ; preds = %lor.lhs.false, %if.end12
  %23 = load i32, i32* %result, align 4, !dbg !3131
  store i32 %23, i32* %retval, align 4, !dbg !3132
  br label %return, !dbg !3132

if.end19:                                         ; preds = %lor.lhs.false
  %24 = load i32, i32* %sa, align 4, !dbg !3133
  %25 = load i32, i32* %sb, align 4, !dbg !3134
  %cmp20 = icmp eq i32 %24, %25, !dbg !3135
  br i1 %cmp20, label %if.then21, label %if.else, !dbg !3133

if.then21:                                        ; preds = %if.end19
  %26 = load i32, i32* %abs_a, align 4, !dbg !3136
  %27 = load i32, i32* %abs_b, align 4, !dbg !3137
  %div = sdiv i32 2147483647, %27, !dbg !3138
  %cmp22 = icmp sgt i32 %26, %div, !dbg !3139
  br i1 %cmp22, label %if.then23, label %if.end24, !dbg !3136

if.then23:                                        ; preds = %if.then21
  %28 = load i32*, i32** %overflow.addr, align 4, !dbg !3140
  store i32 1, i32* %28, align 4, !dbg !3141
  br label %if.end24, !dbg !3142

if.end24:                                         ; preds = %if.then23, %if.then21
  br label %if.end30, !dbg !3143

if.else:                                          ; preds = %if.end19
  %29 = load i32, i32* %abs_a, align 4, !dbg !3144
  %30 = load i32, i32* %abs_b, align 4, !dbg !3145
  %sub25 = sub nsw i32 0, %30, !dbg !3146
  %div26 = sdiv i32 -2147483648, %sub25, !dbg !3147
  %cmp27 = icmp sgt i32 %29, %div26, !dbg !3148
  br i1 %cmp27, label %if.then28, label %if.end29, !dbg !3144

if.then28:                                        ; preds = %if.else
  %31 = load i32*, i32** %overflow.addr, align 4, !dbg !3149
  store i32 1, i32* %31, align 4, !dbg !3150
  br label %if.end29, !dbg !3151

if.end29:                                         ; preds = %if.then28, %if.else
  br label %if.end30

if.end30:                                         ; preds = %if.end29, %if.end24
  %32 = load i32, i32* %result, align 4, !dbg !3152
  store i32 %32, i32* %retval, align 4, !dbg !3153
  br label %return, !dbg !3153

return:                                           ; preds = %if.end30, %if.then18, %if.end11, %if.end
  %33 = load i32, i32* %retval, align 4, !dbg !3154
  ret i32 %33, !dbg !3154
}

; Function Attrs: noinline nounwind
define dso_local arm_aapcscc float @__mulsf3(float noundef %a, float noundef %b) #0 !dbg !3155 {
entry:
  %a.addr = alloca float, align 4
  %b.addr = alloca float, align 4
  store float %a, float* %a.addr, align 4
  store float %b, float* %b.addr, align 4
  %0 = load float, float* %a.addr, align 4, !dbg !3156
  %1 = load float, float* %b.addr, align 4, !dbg !3157
  %call = call arm_aapcscc float @__mulXf3__.38(float noundef %0, float noundef %1) #4, !dbg !3158
  ret float %call, !dbg !3159
}

; Function Attrs: noinline nounwind
define internal arm_aapcscc float @__mulXf3__.38(float noundef %a, float noundef %b) #0 !dbg !3160 {
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
  %0 = load float, float* %a.addr, align 4, !dbg !3161
  %call = call arm_aapcscc i32 @toRep.39(float noundef %0) #4, !dbg !3162
  %shr = lshr i32 %call, 23, !dbg !3163
  %and = and i32 %shr, 255, !dbg !3164
  store i32 %and, i32* %aExponent, align 4, !dbg !3165
  %1 = load float, float* %b.addr, align 4, !dbg !3166
  %call1 = call arm_aapcscc i32 @toRep.39(float noundef %1) #4, !dbg !3167
  %shr2 = lshr i32 %call1, 23, !dbg !3168
  %and3 = and i32 %shr2, 255, !dbg !3169
  store i32 %and3, i32* %bExponent, align 4, !dbg !3170
  %2 = load float, float* %a.addr, align 4, !dbg !3171
  %call4 = call arm_aapcscc i32 @toRep.39(float noundef %2) #4, !dbg !3172
  %3 = load float, float* %b.addr, align 4, !dbg !3173
  %call5 = call arm_aapcscc i32 @toRep.39(float noundef %3) #4, !dbg !3174
  %xor = xor i32 %call4, %call5, !dbg !3175
  %and6 = and i32 %xor, -2147483648, !dbg !3176
  store i32 %and6, i32* %productSign, align 4, !dbg !3177
  %4 = load float, float* %a.addr, align 4, !dbg !3178
  %call7 = call arm_aapcscc i32 @toRep.39(float noundef %4) #4, !dbg !3179
  %and8 = and i32 %call7, 8388607, !dbg !3180
  store i32 %and8, i32* %aSignificand, align 4, !dbg !3181
  %5 = load float, float* %b.addr, align 4, !dbg !3182
  %call9 = call arm_aapcscc i32 @toRep.39(float noundef %5) #4, !dbg !3183
  %and10 = and i32 %call9, 8388607, !dbg !3184
  store i32 %and10, i32* %bSignificand, align 4, !dbg !3185
  store i32 0, i32* %scale, align 4, !dbg !3186
  %6 = load i32, i32* %aExponent, align 4, !dbg !3187
  %sub = sub i32 %6, 1, !dbg !3188
  %cmp = icmp uge i32 %sub, 254, !dbg !3189
  br i1 %cmp, label %if.then, label %lor.lhs.false, !dbg !3190

lor.lhs.false:                                    ; preds = %entry
  %7 = load i32, i32* %bExponent, align 4, !dbg !3191
  %sub11 = sub i32 %7, 1, !dbg !3192
  %cmp12 = icmp uge i32 %sub11, 254, !dbg !3193
  br i1 %cmp12, label %if.then, label %if.end60, !dbg !3187

if.then:                                          ; preds = %lor.lhs.false, %entry
  %8 = load float, float* %a.addr, align 4, !dbg !3194
  %call13 = call arm_aapcscc i32 @toRep.39(float noundef %8) #4, !dbg !3195
  %and14 = and i32 %call13, 2147483647, !dbg !3196
  store i32 %and14, i32* %aAbs, align 4, !dbg !3197
  %9 = load float, float* %b.addr, align 4, !dbg !3198
  %call15 = call arm_aapcscc i32 @toRep.39(float noundef %9) #4, !dbg !3199
  %and16 = and i32 %call15, 2147483647, !dbg !3200
  store i32 %and16, i32* %bAbs, align 4, !dbg !3201
  %10 = load i32, i32* %aAbs, align 4, !dbg !3202
  %cmp17 = icmp ugt i32 %10, 2139095040, !dbg !3203
  br i1 %cmp17, label %if.then18, label %if.end, !dbg !3202

if.then18:                                        ; preds = %if.then
  %11 = load float, float* %a.addr, align 4, !dbg !3204
  %call19 = call arm_aapcscc i32 @toRep.39(float noundef %11) #4, !dbg !3205
  %or = or i32 %call19, 4194304, !dbg !3206
  %call20 = call arm_aapcscc float @fromRep.40(i32 noundef %or) #4, !dbg !3207
  store float %call20, float* %retval, align 4, !dbg !3208
  br label %return, !dbg !3208

if.end:                                           ; preds = %if.then
  %12 = load i32, i32* %bAbs, align 4, !dbg !3209
  %cmp21 = icmp ugt i32 %12, 2139095040, !dbg !3210
  br i1 %cmp21, label %if.then22, label %if.end26, !dbg !3209

if.then22:                                        ; preds = %if.end
  %13 = load float, float* %b.addr, align 4, !dbg !3211
  %call23 = call arm_aapcscc i32 @toRep.39(float noundef %13) #4, !dbg !3212
  %or24 = or i32 %call23, 4194304, !dbg !3213
  %call25 = call arm_aapcscc float @fromRep.40(i32 noundef %or24) #4, !dbg !3214
  store float %call25, float* %retval, align 4, !dbg !3215
  br label %return, !dbg !3215

if.end26:                                         ; preds = %if.end
  %14 = load i32, i32* %aAbs, align 4, !dbg !3216
  %cmp27 = icmp eq i32 %14, 2139095040, !dbg !3217
  br i1 %cmp27, label %if.then28, label %if.end33, !dbg !3216

if.then28:                                        ; preds = %if.end26
  %15 = load i32, i32* %bAbs, align 4, !dbg !3218
  %tobool = icmp ne i32 %15, 0, !dbg !3218
  br i1 %tobool, label %if.then29, label %if.else, !dbg !3218

if.then29:                                        ; preds = %if.then28
  %16 = load i32, i32* %aAbs, align 4, !dbg !3219
  %17 = load i32, i32* %productSign, align 4, !dbg !3220
  %or30 = or i32 %16, %17, !dbg !3221
  %call31 = call arm_aapcscc float @fromRep.40(i32 noundef %or30) #4, !dbg !3222
  store float %call31, float* %retval, align 4, !dbg !3223
  br label %return, !dbg !3223

if.else:                                          ; preds = %if.then28
  %call32 = call arm_aapcscc float @fromRep.40(i32 noundef 2143289344) #4, !dbg !3224
  store float %call32, float* %retval, align 4, !dbg !3225
  br label %return, !dbg !3225

if.end33:                                         ; preds = %if.end26
  %18 = load i32, i32* %bAbs, align 4, !dbg !3226
  %cmp34 = icmp eq i32 %18, 2139095040, !dbg !3227
  br i1 %cmp34, label %if.then35, label %if.end42, !dbg !3226

if.then35:                                        ; preds = %if.end33
  %19 = load i32, i32* %aAbs, align 4, !dbg !3228
  %tobool36 = icmp ne i32 %19, 0, !dbg !3228
  br i1 %tobool36, label %if.then37, label %if.else40, !dbg !3228

if.then37:                                        ; preds = %if.then35
  %20 = load i32, i32* %bAbs, align 4, !dbg !3229
  %21 = load i32, i32* %productSign, align 4, !dbg !3230
  %or38 = or i32 %20, %21, !dbg !3231
  %call39 = call arm_aapcscc float @fromRep.40(i32 noundef %or38) #4, !dbg !3232
  store float %call39, float* %retval, align 4, !dbg !3233
  br label %return, !dbg !3233

if.else40:                                        ; preds = %if.then35
  %call41 = call arm_aapcscc float @fromRep.40(i32 noundef 2143289344) #4, !dbg !3234
  store float %call41, float* %retval, align 4, !dbg !3235
  br label %return, !dbg !3235

if.end42:                                         ; preds = %if.end33
  %22 = load i32, i32* %aAbs, align 4, !dbg !3236
  %tobool43 = icmp ne i32 %22, 0, !dbg !3236
  br i1 %tobool43, label %if.end46, label %if.then44, !dbg !3237

if.then44:                                        ; preds = %if.end42
  %23 = load i32, i32* %productSign, align 4, !dbg !3238
  %call45 = call arm_aapcscc float @fromRep.40(i32 noundef %23) #4, !dbg !3239
  store float %call45, float* %retval, align 4, !dbg !3240
  br label %return, !dbg !3240

if.end46:                                         ; preds = %if.end42
  %24 = load i32, i32* %bAbs, align 4, !dbg !3241
  %tobool47 = icmp ne i32 %24, 0, !dbg !3241
  br i1 %tobool47, label %if.end50, label %if.then48, !dbg !3242

if.then48:                                        ; preds = %if.end46
  %25 = load i32, i32* %productSign, align 4, !dbg !3243
  %call49 = call arm_aapcscc float @fromRep.40(i32 noundef %25) #4, !dbg !3244
  store float %call49, float* %retval, align 4, !dbg !3245
  br label %return, !dbg !3245

if.end50:                                         ; preds = %if.end46
  %26 = load i32, i32* %aAbs, align 4, !dbg !3246
  %cmp51 = icmp ult i32 %26, 8388608, !dbg !3247
  br i1 %cmp51, label %if.then52, label %if.end54, !dbg !3246

if.then52:                                        ; preds = %if.end50
  %call53 = call arm_aapcscc i32 @normalize.41(i32* noundef %aSignificand) #4, !dbg !3248
  %27 = load i32, i32* %scale, align 4, !dbg !3249
  %add = add nsw i32 %27, %call53, !dbg !3249
  store i32 %add, i32* %scale, align 4, !dbg !3249
  br label %if.end54, !dbg !3250

if.end54:                                         ; preds = %if.then52, %if.end50
  %28 = load i32, i32* %bAbs, align 4, !dbg !3251
  %cmp55 = icmp ult i32 %28, 8388608, !dbg !3252
  br i1 %cmp55, label %if.then56, label %if.end59, !dbg !3251

if.then56:                                        ; preds = %if.end54
  %call57 = call arm_aapcscc i32 @normalize.41(i32* noundef %bSignificand) #4, !dbg !3253
  %29 = load i32, i32* %scale, align 4, !dbg !3254
  %add58 = add nsw i32 %29, %call57, !dbg !3254
  store i32 %add58, i32* %scale, align 4, !dbg !3254
  br label %if.end59, !dbg !3255

if.end59:                                         ; preds = %if.then56, %if.end54
  br label %if.end60, !dbg !3256

if.end60:                                         ; preds = %if.end59, %lor.lhs.false
  %30 = load i32, i32* %aSignificand, align 4, !dbg !3257
  %or61 = or i32 %30, 8388608, !dbg !3257
  store i32 %or61, i32* %aSignificand, align 4, !dbg !3257
  %31 = load i32, i32* %bSignificand, align 4, !dbg !3258
  %or62 = or i32 %31, 8388608, !dbg !3258
  store i32 %or62, i32* %bSignificand, align 4, !dbg !3258
  %32 = load i32, i32* %aSignificand, align 4, !dbg !3259
  %33 = load i32, i32* %bSignificand, align 4, !dbg !3260
  %shl = shl i32 %33, 8, !dbg !3261
  call arm_aapcscc void @wideMultiply.42(i32 noundef %32, i32 noundef %shl, i32* noundef %productHi, i32* noundef %productLo) #4, !dbg !3262
  %34 = load i32, i32* %aExponent, align 4, !dbg !3263
  %35 = load i32, i32* %bExponent, align 4, !dbg !3264
  %add63 = add i32 %34, %35, !dbg !3265
  %sub64 = sub i32 %add63, 127, !dbg !3266
  %36 = load i32, i32* %scale, align 4, !dbg !3267
  %add65 = add i32 %sub64, %36, !dbg !3268
  store i32 %add65, i32* %productExponent, align 4, !dbg !3269
  %37 = load i32, i32* %productHi, align 4, !dbg !3270
  %and66 = and i32 %37, 8388608, !dbg !3271
  %tobool67 = icmp ne i32 %and66, 0, !dbg !3271
  br i1 %tobool67, label %if.then68, label %if.else69, !dbg !3270

if.then68:                                        ; preds = %if.end60
  %38 = load i32, i32* %productExponent, align 4, !dbg !3272
  %inc = add nsw i32 %38, 1, !dbg !3272
  store i32 %inc, i32* %productExponent, align 4, !dbg !3272
  br label %if.end70, !dbg !3273

if.else69:                                        ; preds = %if.end60
  call arm_aapcscc void @wideLeftShift.43(i32* noundef %productHi, i32* noundef %productLo, i32 noundef 1) #4, !dbg !3274
  br label %if.end70

if.end70:                                         ; preds = %if.else69, %if.then68
  %39 = load i32, i32* %productExponent, align 4, !dbg !3275
  %cmp71 = icmp sge i32 %39, 255, !dbg !3276
  br i1 %cmp71, label %if.then72, label %if.end75, !dbg !3275

if.then72:                                        ; preds = %if.end70
  %40 = load i32, i32* %productSign, align 4, !dbg !3277
  %or73 = or i32 2139095040, %40, !dbg !3278
  %call74 = call arm_aapcscc float @fromRep.40(i32 noundef %or73) #4, !dbg !3279
  store float %call74, float* %retval, align 4, !dbg !3280
  br label %return, !dbg !3280

if.end75:                                         ; preds = %if.end70
  %41 = load i32, i32* %productExponent, align 4, !dbg !3281
  %cmp76 = icmp sle i32 %41, 0, !dbg !3282
  br i1 %cmp76, label %if.then77, label %if.else83, !dbg !3281

if.then77:                                        ; preds = %if.end75
  %42 = load i32, i32* %productExponent, align 4, !dbg !3283
  %sub78 = sub i32 1, %42, !dbg !3284
  store i32 %sub78, i32* %shift, align 4, !dbg !3285
  %43 = load i32, i32* %shift, align 4, !dbg !3286
  %cmp79 = icmp uge i32 %43, 32, !dbg !3287
  br i1 %cmp79, label %if.then80, label %if.end82, !dbg !3286

if.then80:                                        ; preds = %if.then77
  %44 = load i32, i32* %productSign, align 4, !dbg !3288
  %call81 = call arm_aapcscc float @fromRep.40(i32 noundef %44) #4, !dbg !3289
  store float %call81, float* %retval, align 4, !dbg !3290
  br label %return, !dbg !3290

if.end82:                                         ; preds = %if.then77
  %45 = load i32, i32* %shift, align 4, !dbg !3291
  call arm_aapcscc void @wideRightShiftWithSticky.44(i32* noundef %productHi, i32* noundef %productLo, i32 noundef %45) #4, !dbg !3292
  br label %if.end87, !dbg !3293

if.else83:                                        ; preds = %if.end75
  %46 = load i32, i32* %productHi, align 4, !dbg !3294
  %and84 = and i32 %46, 8388607, !dbg !3294
  store i32 %and84, i32* %productHi, align 4, !dbg !3294
  %47 = load i32, i32* %productExponent, align 4, !dbg !3295
  %shl85 = shl i32 %47, 23, !dbg !3296
  %48 = load i32, i32* %productHi, align 4, !dbg !3297
  %or86 = or i32 %48, %shl85, !dbg !3297
  store i32 %or86, i32* %productHi, align 4, !dbg !3297
  br label %if.end87

if.end87:                                         ; preds = %if.else83, %if.end82
  %49 = load i32, i32* %productSign, align 4, !dbg !3298
  %50 = load i32, i32* %productHi, align 4, !dbg !3299
  %or88 = or i32 %50, %49, !dbg !3299
  store i32 %or88, i32* %productHi, align 4, !dbg !3299
  %51 = load i32, i32* %productLo, align 4, !dbg !3300
  %cmp89 = icmp ugt i32 %51, -2147483648, !dbg !3301
  br i1 %cmp89, label %if.then90, label %if.end92, !dbg !3300

if.then90:                                        ; preds = %if.end87
  %52 = load i32, i32* %productHi, align 4, !dbg !3302
  %inc91 = add i32 %52, 1, !dbg !3302
  store i32 %inc91, i32* %productHi, align 4, !dbg !3302
  br label %if.end92, !dbg !3303

if.end92:                                         ; preds = %if.then90, %if.end87
  %53 = load i32, i32* %productLo, align 4, !dbg !3304
  %cmp93 = icmp eq i32 %53, -2147483648, !dbg !3305
  br i1 %cmp93, label %if.then94, label %if.end97, !dbg !3304

if.then94:                                        ; preds = %if.end92
  %54 = load i32, i32* %productHi, align 4, !dbg !3306
  %and95 = and i32 %54, 1, !dbg !3307
  %55 = load i32, i32* %productHi, align 4, !dbg !3308
  %add96 = add i32 %55, %and95, !dbg !3308
  store i32 %add96, i32* %productHi, align 4, !dbg !3308
  br label %if.end97, !dbg !3309

if.end97:                                         ; preds = %if.then94, %if.end92
  %56 = load i32, i32* %productHi, align 4, !dbg !3310
  %call98 = call arm_aapcscc float @fromRep.40(i32 noundef %56) #4, !dbg !3311
  store float %call98, float* %retval, align 4, !dbg !3312
  br label %return, !dbg !3312

return:                                           ; preds = %if.end97, %if.then80, %if.then72, %if.then48, %if.then44, %if.else40, %if.then37, %if.else, %if.then29, %if.then22, %if.then18
  %57 = load float, float* %retval, align 4, !dbg !3313
  ret float %57, !dbg !3313
}

; Function Attrs: noinline nounwind
define internal arm_aapcscc i32 @toRep.39(float noundef %x) #0 !dbg !3314 {
entry:
  %x.addr = alloca float, align 4
  %rep = alloca %union.anon.0.0, align 4
  store float %x, float* %x.addr, align 4
  %f = bitcast %union.anon.0.0* %rep to float*, !dbg !3315
  %0 = load float, float* %x.addr, align 4, !dbg !3316
  store float %0, float* %f, align 4, !dbg !3315
  %i = bitcast %union.anon.0.0* %rep to i32*, !dbg !3317
  %1 = load i32, i32* %i, align 4, !dbg !3317
  ret i32 %1, !dbg !3318
}

; Function Attrs: noinline nounwind
define internal arm_aapcscc float @fromRep.40(i32 noundef %x) #0 !dbg !3319 {
entry:
  %x.addr = alloca i32, align 4
  %rep = alloca %union.anon.0.0, align 4
  store i32 %x, i32* %x.addr, align 4
  %i = bitcast %union.anon.0.0* %rep to i32*, !dbg !3320
  %0 = load i32, i32* %x.addr, align 4, !dbg !3321
  store i32 %0, i32* %i, align 4, !dbg !3320
  %f = bitcast %union.anon.0.0* %rep to float*, !dbg !3322
  %1 = load float, float* %f, align 4, !dbg !3322
  ret float %1, !dbg !3323
}

; Function Attrs: noinline nounwind
define internal arm_aapcscc i32 @normalize.41(i32* noundef %significand) #0 !dbg !3324 {
entry:
  %significand.addr = alloca i32*, align 4
  %shift = alloca i32, align 4
  store i32* %significand, i32** %significand.addr, align 4
  %0 = load i32*, i32** %significand.addr, align 4, !dbg !3325
  %1 = load i32, i32* %0, align 4, !dbg !3326
  %call = call arm_aapcscc i32 @rep_clz.45(i32 noundef %1) #4, !dbg !3327
  %call1 = call arm_aapcscc i32 @rep_clz.45(i32 noundef 8388608) #4, !dbg !3328
  %sub = sub nsw i32 %call, %call1, !dbg !3329
  store i32 %sub, i32* %shift, align 4, !dbg !3330
  %2 = load i32, i32* %shift, align 4, !dbg !3331
  %3 = load i32*, i32** %significand.addr, align 4, !dbg !3332
  %4 = load i32, i32* %3, align 4, !dbg !3333
  %shl = shl i32 %4, %2, !dbg !3333
  store i32 %shl, i32* %3, align 4, !dbg !3333
  %5 = load i32, i32* %shift, align 4, !dbg !3334
  %sub2 = sub nsw i32 1, %5, !dbg !3335
  ret i32 %sub2, !dbg !3336
}

; Function Attrs: noinline nounwind
define internal arm_aapcscc void @wideMultiply.42(i32 noundef %a, i32 noundef %b, i32* noundef %hi, i32* noundef %lo) #0 !dbg !3337 {
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
  %0 = load i32, i32* %a.addr, align 4, !dbg !3338
  %conv = zext i32 %0 to i64, !dbg !3339
  %1 = load i32, i32* %b.addr, align 4, !dbg !3340
  %conv1 = zext i32 %1 to i64, !dbg !3340
  %mul = mul i64 %conv, %conv1, !dbg !3341
  store i64 %mul, i64* %product, align 8, !dbg !3342
  %2 = load i64, i64* %product, align 8, !dbg !3343
  %shr = lshr i64 %2, 32, !dbg !3344
  %conv2 = trunc i64 %shr to i32, !dbg !3343
  %3 = load i32*, i32** %hi.addr, align 4, !dbg !3345
  store i32 %conv2, i32* %3, align 4, !dbg !3346
  %4 = load i64, i64* %product, align 8, !dbg !3347
  %conv3 = trunc i64 %4 to i32, !dbg !3347
  %5 = load i32*, i32** %lo.addr, align 4, !dbg !3348
  store i32 %conv3, i32* %5, align 4, !dbg !3349
  ret void, !dbg !3350
}

; Function Attrs: noinline nounwind
define internal arm_aapcscc void @wideLeftShift.43(i32* noundef %hi, i32* noundef %lo, i32 noundef %count) #0 !dbg !3351 {
entry:
  %hi.addr = alloca i32*, align 4
  %lo.addr = alloca i32*, align 4
  %count.addr = alloca i32, align 4
  store i32* %hi, i32** %hi.addr, align 4
  store i32* %lo, i32** %lo.addr, align 4
  store i32 %count, i32* %count.addr, align 4
  %0 = load i32*, i32** %hi.addr, align 4, !dbg !3352
  %1 = load i32, i32* %0, align 4, !dbg !3353
  %2 = load i32, i32* %count.addr, align 4, !dbg !3354
  %shl = shl i32 %1, %2, !dbg !3355
  %3 = load i32*, i32** %lo.addr, align 4, !dbg !3356
  %4 = load i32, i32* %3, align 4, !dbg !3357
  %5 = load i32, i32* %count.addr, align 4, !dbg !3358
  %sub = sub i32 32, %5, !dbg !3359
  %shr = lshr i32 %4, %sub, !dbg !3360
  %or = or i32 %shl, %shr, !dbg !3361
  %6 = load i32*, i32** %hi.addr, align 4, !dbg !3362
  store i32 %or, i32* %6, align 4, !dbg !3363
  %7 = load i32*, i32** %lo.addr, align 4, !dbg !3364
  %8 = load i32, i32* %7, align 4, !dbg !3365
  %9 = load i32, i32* %count.addr, align 4, !dbg !3366
  %shl1 = shl i32 %8, %9, !dbg !3367
  %10 = load i32*, i32** %lo.addr, align 4, !dbg !3368
  store i32 %shl1, i32* %10, align 4, !dbg !3369
  ret void, !dbg !3370
}

; Function Attrs: noinline nounwind
define internal arm_aapcscc void @wideRightShiftWithSticky.44(i32* noundef %hi, i32* noundef %lo, i32 noundef %count) #0 !dbg !3371 {
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
  %0 = load i32, i32* %count.addr, align 4, !dbg !3372
  %cmp = icmp ult i32 %0, 32, !dbg !3373
  br i1 %cmp, label %if.then, label %if.else, !dbg !3372

if.then:                                          ; preds = %entry
  %1 = load i32*, i32** %lo.addr, align 4, !dbg !3374
  %2 = load i32, i32* %1, align 4, !dbg !3375
  %3 = load i32, i32* %count.addr, align 4, !dbg !3376
  %sub = sub i32 32, %3, !dbg !3377
  %shl = shl i32 %2, %sub, !dbg !3378
  %tobool = icmp ne i32 %shl, 0, !dbg !3375
  %frombool = zext i1 %tobool to i8, !dbg !3379
  store i8 %frombool, i8* %sticky, align 1, !dbg !3379
  %4 = load i32*, i32** %hi.addr, align 4, !dbg !3380
  %5 = load i32, i32* %4, align 4, !dbg !3381
  %6 = load i32, i32* %count.addr, align 4, !dbg !3382
  %sub1 = sub i32 32, %6, !dbg !3383
  %shl2 = shl i32 %5, %sub1, !dbg !3384
  %7 = load i32*, i32** %lo.addr, align 4, !dbg !3385
  %8 = load i32, i32* %7, align 4, !dbg !3386
  %9 = load i32, i32* %count.addr, align 4, !dbg !3387
  %shr = lshr i32 %8, %9, !dbg !3388
  %or = or i32 %shl2, %shr, !dbg !3389
  %10 = load i8, i8* %sticky, align 1, !dbg !3390
  %tobool3 = trunc i8 %10 to i1, !dbg !3390
  %conv = zext i1 %tobool3 to i32, !dbg !3390
  %or4 = or i32 %or, %conv, !dbg !3391
  %11 = load i32*, i32** %lo.addr, align 4, !dbg !3392
  store i32 %or4, i32* %11, align 4, !dbg !3393
  %12 = load i32*, i32** %hi.addr, align 4, !dbg !3394
  %13 = load i32, i32* %12, align 4, !dbg !3395
  %14 = load i32, i32* %count.addr, align 4, !dbg !3396
  %shr5 = lshr i32 %13, %14, !dbg !3397
  %15 = load i32*, i32** %hi.addr, align 4, !dbg !3398
  store i32 %shr5, i32* %15, align 4, !dbg !3399
  br label %if.end27, !dbg !3400

if.else:                                          ; preds = %entry
  %16 = load i32, i32* %count.addr, align 4, !dbg !3401
  %cmp6 = icmp ult i32 %16, 64, !dbg !3402
  br i1 %cmp6, label %if.then8, label %if.else20, !dbg !3401

if.then8:                                         ; preds = %if.else
  %17 = load i32*, i32** %hi.addr, align 4, !dbg !3403
  %18 = load i32, i32* %17, align 4, !dbg !3404
  %19 = load i32, i32* %count.addr, align 4, !dbg !3405
  %sub10 = sub i32 64, %19, !dbg !3406
  %shl11 = shl i32 %18, %sub10, !dbg !3407
  %20 = load i32*, i32** %lo.addr, align 4, !dbg !3408
  %21 = load i32, i32* %20, align 4, !dbg !3409
  %or12 = or i32 %shl11, %21, !dbg !3410
  %tobool13 = icmp ne i32 %or12, 0, !dbg !3404
  %frombool14 = zext i1 %tobool13 to i8, !dbg !3411
  store i8 %frombool14, i8* %sticky9, align 1, !dbg !3411
  %22 = load i32*, i32** %hi.addr, align 4, !dbg !3412
  %23 = load i32, i32* %22, align 4, !dbg !3413
  %24 = load i32, i32* %count.addr, align 4, !dbg !3414
  %sub15 = sub i32 %24, 32, !dbg !3415
  %shr16 = lshr i32 %23, %sub15, !dbg !3416
  %25 = load i8, i8* %sticky9, align 1, !dbg !3417
  %tobool17 = trunc i8 %25 to i1, !dbg !3417
  %conv18 = zext i1 %tobool17 to i32, !dbg !3417
  %or19 = or i32 %shr16, %conv18, !dbg !3418
  %26 = load i32*, i32** %lo.addr, align 4, !dbg !3419
  store i32 %or19, i32* %26, align 4, !dbg !3420
  %27 = load i32*, i32** %hi.addr, align 4, !dbg !3421
  store i32 0, i32* %27, align 4, !dbg !3422
  br label %if.end, !dbg !3423

if.else20:                                        ; preds = %if.else
  %28 = load i32*, i32** %hi.addr, align 4, !dbg !3424
  %29 = load i32, i32* %28, align 4, !dbg !3425
  %30 = load i32*, i32** %lo.addr, align 4, !dbg !3426
  %31 = load i32, i32* %30, align 4, !dbg !3427
  %or22 = or i32 %29, %31, !dbg !3428
  %tobool23 = icmp ne i32 %or22, 0, !dbg !3425
  %frombool24 = zext i1 %tobool23 to i8, !dbg !3429
  store i8 %frombool24, i8* %sticky21, align 1, !dbg !3429
  %32 = load i8, i8* %sticky21, align 1, !dbg !3430
  %tobool25 = trunc i8 %32 to i1, !dbg !3430
  %conv26 = zext i1 %tobool25 to i32, !dbg !3430
  %33 = load i32*, i32** %lo.addr, align 4, !dbg !3431
  store i32 %conv26, i32* %33, align 4, !dbg !3432
  %34 = load i32*, i32** %hi.addr, align 4, !dbg !3433
  store i32 0, i32* %34, align 4, !dbg !3434
  br label %if.end

if.end:                                           ; preds = %if.else20, %if.then8
  br label %if.end27

if.end27:                                         ; preds = %if.end, %if.then
  ret void, !dbg !3435
}

; Function Attrs: noinline nounwind
define internal arm_aapcscc i32 @rep_clz.45(i32 noundef %a) #0 !dbg !3436 {
entry:
  %a.addr = alloca i32, align 4
  store i32 %a, i32* %a.addr, align 4
  %0 = load i32, i32* %a.addr, align 4, !dbg !3437
  %1 = call i32 @llvm.ctlz.i32(i32 %0, i1 false), !dbg !3438
  ret i32 %1, !dbg !3439
}

; Function Attrs: noinline nounwind
define dso_local arm_aapcscc double @__negdf2(double noundef %a) #0 !dbg !3440 {
entry:
  %a.addr = alloca double, align 8
  store double %a, double* %a.addr, align 8
  %0 = load double, double* %a.addr, align 8, !dbg !3441
  %call = call arm_aapcscc i64 @toRep.46(double noundef %0) #4, !dbg !3442
  %xor = xor i64 %call, -9223372036854775808, !dbg !3443
  %call1 = call arm_aapcscc double @fromRep.47(i64 noundef %xor) #4, !dbg !3444
  ret double %call1, !dbg !3445
}

; Function Attrs: noinline nounwind
define internal arm_aapcscc i64 @toRep.46(double noundef %x) #0 !dbg !3446 {
entry:
  %x.addr = alloca double, align 8
  %rep = alloca %union.anon.0, align 8
  store double %x, double* %x.addr, align 8
  %f = bitcast %union.anon.0* %rep to double*, !dbg !3447
  %0 = load double, double* %x.addr, align 8, !dbg !3448
  store double %0, double* %f, align 8, !dbg !3447
  %i = bitcast %union.anon.0* %rep to i64*, !dbg !3449
  %1 = load i64, i64* %i, align 8, !dbg !3449
  ret i64 %1, !dbg !3450
}

; Function Attrs: noinline nounwind
define internal arm_aapcscc double @fromRep.47(i64 noundef %x) #0 !dbg !3451 {
entry:
  %x.addr = alloca i64, align 8
  %rep = alloca %union.anon.0, align 8
  store i64 %x, i64* %x.addr, align 8
  %i = bitcast %union.anon.0* %rep to i64*, !dbg !3452
  %0 = load i64, i64* %x.addr, align 8, !dbg !3453
  store i64 %0, i64* %i, align 8, !dbg !3452
  %f = bitcast %union.anon.0* %rep to double*, !dbg !3454
  %1 = load double, double* %f, align 8, !dbg !3454
  ret double %1, !dbg !3455
}

; Function Attrs: noinline nounwind
define dso_local arm_aapcscc i64 @__negdi2(i64 noundef %a) #0 !dbg !3456 {
entry:
  %a.addr = alloca i64, align 8
  store i64 %a, i64* %a.addr, align 8
  %0 = load i64, i64* %a.addr, align 8, !dbg !3457
  %sub = sub nsw i64 0, %0, !dbg !3458
  ret i64 %sub, !dbg !3459
}

; Function Attrs: noinline nounwind
define dso_local arm_aapcscc float @__negsf2(float noundef %a) #0 !dbg !3460 {
entry:
  %a.addr = alloca float, align 4
  store float %a, float* %a.addr, align 4
  %0 = load float, float* %a.addr, align 4, !dbg !3461
  %call = call arm_aapcscc i32 @toRep.48(float noundef %0) #4, !dbg !3462
  %xor = xor i32 %call, -2147483648, !dbg !3463
  %call1 = call arm_aapcscc float @fromRep.49(i32 noundef %xor) #4, !dbg !3464
  ret float %call1, !dbg !3465
}

; Function Attrs: noinline nounwind
define internal arm_aapcscc i32 @toRep.48(float noundef %x) #0 !dbg !3466 {
entry:
  %x.addr = alloca float, align 4
  %rep = alloca %union.anon.0.0, align 4
  store float %x, float* %x.addr, align 4
  %f = bitcast %union.anon.0.0* %rep to float*, !dbg !3467
  %0 = load float, float* %x.addr, align 4, !dbg !3468
  store float %0, float* %f, align 4, !dbg !3467
  %i = bitcast %union.anon.0.0* %rep to i32*, !dbg !3469
  %1 = load i32, i32* %i, align 4, !dbg !3469
  ret i32 %1, !dbg !3470
}

; Function Attrs: noinline nounwind
define internal arm_aapcscc float @fromRep.49(i32 noundef %x) #0 !dbg !3471 {
entry:
  %x.addr = alloca i32, align 4
  %rep = alloca %union.anon.0.0, align 4
  store i32 %x, i32* %x.addr, align 4
  %i = bitcast %union.anon.0.0* %rep to i32*, !dbg !3472
  %0 = load i32, i32* %x.addr, align 4, !dbg !3473
  store i32 %0, i32* %i, align 4, !dbg !3472
  %f = bitcast %union.anon.0.0* %rep to float*, !dbg !3474
  %1 = load float, float* %f, align 4, !dbg !3474
  ret float %1, !dbg !3475
}

; Function Attrs: noinline nounwind
define dso_local arm_aapcscc i64 @__negvdi2(i64 noundef %a) #0 !dbg !3476 {
entry:
  %a.addr = alloca i64, align 8
  %MIN = alloca i64, align 8
  store i64 %a, i64* %a.addr, align 8
  store i64 -9223372036854775808, i64* %MIN, align 8, !dbg !3477
  %0 = load i64, i64* %a.addr, align 8, !dbg !3478
  %cmp = icmp eq i64 %0, -9223372036854775808, !dbg !3479
  br i1 %cmp, label %if.then, label %if.end, !dbg !3478

if.then:                                          ; preds = %entry
  call arm_aapcscc void @compilerrt_abort_impl(i8* noundef getelementptr inbounds ([13 x i8], [13 x i8]* @.str, i32 0, i32 0), i32 noundef 26, i8* noundef getelementptr inbounds ([10 x i8], [10 x i8]* @__func__.__negvdi2, i32 0, i32 0)) #5, !dbg !3480
  unreachable, !dbg !3480

if.end:                                           ; preds = %entry
  %1 = load i64, i64* %a.addr, align 8, !dbg !3481
  %sub = sub nsw i64 0, %1, !dbg !3482
  ret i64 %sub, !dbg !3483
}

; Function Attrs: noinline nounwind
define dso_local arm_aapcscc i32 @__negvsi2(i32 noundef %a) #0 !dbg !3484 {
entry:
  %a.addr = alloca i32, align 4
  %MIN = alloca i32, align 4
  store i32 %a, i32* %a.addr, align 4
  store i32 -2147483648, i32* %MIN, align 4, !dbg !3485
  %0 = load i32, i32* %a.addr, align 4, !dbg !3486
  %cmp = icmp eq i32 %0, -2147483648, !dbg !3487
  br i1 %cmp, label %if.then, label %if.end, !dbg !3486

if.then:                                          ; preds = %entry
  call arm_aapcscc void @compilerrt_abort_impl(i8* noundef getelementptr inbounds ([13 x i8], [13 x i8]* @.str.50, i32 0, i32 0), i32 noundef 26, i8* noundef getelementptr inbounds ([10 x i8], [10 x i8]* @__func__.__negvsi2, i32 0, i32 0)) #5, !dbg !3488
  unreachable, !dbg !3488

if.end:                                           ; preds = %entry
  %1 = load i32, i32* %a.addr, align 4, !dbg !3489
  %sub = sub nsw i32 0, %1, !dbg !3490
  ret i32 %sub, !dbg !3491
}

; Function Attrs: noinline nounwind
define dso_local arm_aapcscc double @__powidf2(double noundef %a, i32 noundef %b) #0 !dbg !3492 {
entry:
  %a.addr = alloca double, align 8
  %b.addr = alloca i32, align 4
  %recip = alloca i32, align 4
  %r = alloca double, align 8
  store double %a, double* %a.addr, align 8
  store i32 %b, i32* %b.addr, align 4
  %0 = load i32, i32* %b.addr, align 4, !dbg !3493
  %cmp = icmp slt i32 %0, 0, !dbg !3494
  %conv = zext i1 %cmp to i32, !dbg !3494
  store i32 %conv, i32* %recip, align 4, !dbg !3495
  store double 1.000000e+00, double* %r, align 8, !dbg !3496
  br label %while.body, !dbg !3497

while.body:                                       ; preds = %if.end4, %entry
  %1 = load i32, i32* %b.addr, align 4, !dbg !3498
  %and = and i32 %1, 1, !dbg !3499
  %tobool = icmp ne i32 %and, 0, !dbg !3499
  br i1 %tobool, label %if.then, label %if.end, !dbg !3498

if.then:                                          ; preds = %while.body
  %2 = load double, double* %a.addr, align 8, !dbg !3500
  %3 = load double, double* %r, align 8, !dbg !3501
  %mul = fmul double %3, %2, !dbg !3501
  store double %mul, double* %r, align 8, !dbg !3501
  br label %if.end, !dbg !3502

if.end:                                           ; preds = %if.then, %while.body
  %4 = load i32, i32* %b.addr, align 4, !dbg !3503
  %div = sdiv i32 %4, 2, !dbg !3503
  store i32 %div, i32* %b.addr, align 4, !dbg !3503
  %5 = load i32, i32* %b.addr, align 4, !dbg !3504
  %cmp1 = icmp eq i32 %5, 0, !dbg !3505
  br i1 %cmp1, label %if.then3, label %if.end4, !dbg !3504

if.then3:                                         ; preds = %if.end
  br label %while.end, !dbg !3506

if.end4:                                          ; preds = %if.end
  %6 = load double, double* %a.addr, align 8, !dbg !3507
  %7 = load double, double* %a.addr, align 8, !dbg !3508
  %mul5 = fmul double %7, %6, !dbg !3508
  store double %mul5, double* %a.addr, align 8, !dbg !3508
  br label %while.body, !dbg !3497, !llvm.loop !3509

while.end:                                        ; preds = %if.then3
  %8 = load i32, i32* %recip, align 4, !dbg !3511
  %tobool6 = icmp ne i32 %8, 0, !dbg !3511
  br i1 %tobool6, label %cond.true, label %cond.false, !dbg !3511

cond.true:                                        ; preds = %while.end
  %9 = load double, double* %r, align 8, !dbg !3512
  %div7 = fdiv double 1.000000e+00, %9, !dbg !3513
  br label %cond.end, !dbg !3511

cond.false:                                       ; preds = %while.end
  %10 = load double, double* %r, align 8, !dbg !3514
  br label %cond.end, !dbg !3511

cond.end:                                         ; preds = %cond.false, %cond.true
  %cond = phi double [ %div7, %cond.true ], [ %10, %cond.false ], !dbg !3511
  ret double %cond, !dbg !3515
}

; Function Attrs: noinline nounwind
define dso_local arm_aapcscc float @__powisf2(float noundef %a, i32 noundef %b) #0 !dbg !3516 {
entry:
  %a.addr = alloca float, align 4
  %b.addr = alloca i32, align 4
  %recip = alloca i32, align 4
  %r = alloca float, align 4
  store float %a, float* %a.addr, align 4
  store i32 %b, i32* %b.addr, align 4
  %0 = load i32, i32* %b.addr, align 4, !dbg !3517
  %cmp = icmp slt i32 %0, 0, !dbg !3518
  %conv = zext i1 %cmp to i32, !dbg !3518
  store i32 %conv, i32* %recip, align 4, !dbg !3519
  store float 1.000000e+00, float* %r, align 4, !dbg !3520
  br label %while.body, !dbg !3521

while.body:                                       ; preds = %if.end4, %entry
  %1 = load i32, i32* %b.addr, align 4, !dbg !3522
  %and = and i32 %1, 1, !dbg !3523
  %tobool = icmp ne i32 %and, 0, !dbg !3523
  br i1 %tobool, label %if.then, label %if.end, !dbg !3522

if.then:                                          ; preds = %while.body
  %2 = load float, float* %a.addr, align 4, !dbg !3524
  %3 = load float, float* %r, align 4, !dbg !3525
  %mul = fmul float %3, %2, !dbg !3525
  store float %mul, float* %r, align 4, !dbg !3525
  br label %if.end, !dbg !3526

if.end:                                           ; preds = %if.then, %while.body
  %4 = load i32, i32* %b.addr, align 4, !dbg !3527
  %div = sdiv i32 %4, 2, !dbg !3527
  store i32 %div, i32* %b.addr, align 4, !dbg !3527
  %5 = load i32, i32* %b.addr, align 4, !dbg !3528
  %cmp1 = icmp eq i32 %5, 0, !dbg !3529
  br i1 %cmp1, label %if.then3, label %if.end4, !dbg !3528

if.then3:                                         ; preds = %if.end
  br label %while.end, !dbg !3530

if.end4:                                          ; preds = %if.end
  %6 = load float, float* %a.addr, align 4, !dbg !3531
  %7 = load float, float* %a.addr, align 4, !dbg !3532
  %mul5 = fmul float %7, %6, !dbg !3532
  store float %mul5, float* %a.addr, align 4, !dbg !3532
  br label %while.body, !dbg !3521, !llvm.loop !3533

while.end:                                        ; preds = %if.then3
  %8 = load i32, i32* %recip, align 4, !dbg !3535
  %tobool6 = icmp ne i32 %8, 0, !dbg !3535
  br i1 %tobool6, label %cond.true, label %cond.false, !dbg !3535

cond.true:                                        ; preds = %while.end
  %9 = load float, float* %r, align 4, !dbg !3536
  %div7 = fdiv float 1.000000e+00, %9, !dbg !3537
  br label %cond.end, !dbg !3535

cond.false:                                       ; preds = %while.end
  %10 = load float, float* %r, align 4, !dbg !3538
  br label %cond.end, !dbg !3535

cond.end:                                         ; preds = %cond.false, %cond.true
  %cond = phi float [ %div7, %cond.true ], [ %10, %cond.false ], !dbg !3535
  ret float %cond, !dbg !3539
}

; Function Attrs: noinline nounwind
define dso_local arm_aapcscc double @__powixf2(double noundef %a, i32 noundef %b) #0 !dbg !3540 {
entry:
  %a.addr = alloca double, align 8
  %b.addr = alloca i32, align 4
  %recip = alloca i32, align 4
  %r = alloca double, align 8
  store double %a, double* %a.addr, align 8
  store i32 %b, i32* %b.addr, align 4
  %0 = load i32, i32* %b.addr, align 4, !dbg !3541
  %cmp = icmp slt i32 %0, 0, !dbg !3542
  %conv = zext i1 %cmp to i32, !dbg !3542
  store i32 %conv, i32* %recip, align 4, !dbg !3543
  store double 1.000000e+00, double* %r, align 8, !dbg !3544
  br label %while.body, !dbg !3545

while.body:                                       ; preds = %if.end4, %entry
  %1 = load i32, i32* %b.addr, align 4, !dbg !3546
  %and = and i32 %1, 1, !dbg !3547
  %tobool = icmp ne i32 %and, 0, !dbg !3547
  br i1 %tobool, label %if.then, label %if.end, !dbg !3546

if.then:                                          ; preds = %while.body
  %2 = load double, double* %a.addr, align 8, !dbg !3548
  %3 = load double, double* %r, align 8, !dbg !3549
  %mul = fmul double %3, %2, !dbg !3549
  store double %mul, double* %r, align 8, !dbg !3549
  br label %if.end, !dbg !3550

if.end:                                           ; preds = %if.then, %while.body
  %4 = load i32, i32* %b.addr, align 4, !dbg !3551
  %div = sdiv i32 %4, 2, !dbg !3551
  store i32 %div, i32* %b.addr, align 4, !dbg !3551
  %5 = load i32, i32* %b.addr, align 4, !dbg !3552
  %cmp1 = icmp eq i32 %5, 0, !dbg !3553
  br i1 %cmp1, label %if.then3, label %if.end4, !dbg !3552

if.then3:                                         ; preds = %if.end
  br label %while.end, !dbg !3554

if.end4:                                          ; preds = %if.end
  %6 = load double, double* %a.addr, align 8, !dbg !3555
  %7 = load double, double* %a.addr, align 8, !dbg !3556
  %mul5 = fmul double %7, %6, !dbg !3556
  store double %mul5, double* %a.addr, align 8, !dbg !3556
  br label %while.body, !dbg !3545, !llvm.loop !3557

while.end:                                        ; preds = %if.then3
  %8 = load i32, i32* %recip, align 4, !dbg !3559
  %tobool6 = icmp ne i32 %8, 0, !dbg !3559
  br i1 %tobool6, label %cond.true, label %cond.false, !dbg !3559

cond.true:                                        ; preds = %while.end
  %9 = load double, double* %r, align 8, !dbg !3560
  %div7 = fdiv double 1.000000e+00, %9, !dbg !3561
  br label %cond.end, !dbg !3559

cond.false:                                       ; preds = %while.end
  %10 = load double, double* %r, align 8, !dbg !3562
  br label %cond.end, !dbg !3559

cond.end:                                         ; preds = %cond.false, %cond.true
  %cond = phi double [ %div7, %cond.true ], [ %10, %cond.false ], !dbg !3559
  ret double %cond, !dbg !3563
}

; Function Attrs: noinline nounwind
define dso_local arm_aapcscc double @__subdf3(double noundef %a, double noundef %b) #0 !dbg !3564 {
entry:
  %a.addr = alloca double, align 8
  %b.addr = alloca double, align 8
  store double %a, double* %a.addr, align 8
  store double %b, double* %b.addr, align 8
  %0 = load double, double* %a.addr, align 8, !dbg !3565
  %1 = load double, double* %b.addr, align 8, !dbg !3566
  %call = call arm_aapcscc i64 @toRep.51(double noundef %1) #4, !dbg !3567
  %xor = xor i64 %call, -9223372036854775808, !dbg !3568
  %call1 = call arm_aapcscc double @fromRep.52(i64 noundef %xor) #4, !dbg !3569
  %call2 = call arm_aapcscc double @__adddf3(double noundef %0, double noundef %call1) #4, !dbg !3570
  ret double %call2, !dbg !3571
}

; Function Attrs: noinline nounwind
define internal arm_aapcscc i64 @toRep.51(double noundef %x) #0 !dbg !3572 {
entry:
  %x.addr = alloca double, align 8
  %rep = alloca %union.anon.0, align 8
  store double %x, double* %x.addr, align 8
  %f = bitcast %union.anon.0* %rep to double*, !dbg !3573
  %0 = load double, double* %x.addr, align 8, !dbg !3574
  store double %0, double* %f, align 8, !dbg !3573
  %i = bitcast %union.anon.0* %rep to i64*, !dbg !3575
  %1 = load i64, i64* %i, align 8, !dbg !3575
  ret i64 %1, !dbg !3576
}

; Function Attrs: noinline nounwind
define internal arm_aapcscc double @fromRep.52(i64 noundef %x) #0 !dbg !3577 {
entry:
  %x.addr = alloca i64, align 8
  %rep = alloca %union.anon.0, align 8
  store i64 %x, i64* %x.addr, align 8
  %i = bitcast %union.anon.0* %rep to i64*, !dbg !3578
  %0 = load i64, i64* %x.addr, align 8, !dbg !3579
  store i64 %0, i64* %i, align 8, !dbg !3578
  %f = bitcast %union.anon.0* %rep to double*, !dbg !3580
  %1 = load double, double* %f, align 8, !dbg !3580
  ret double %1, !dbg !3581
}

; Function Attrs: noinline nounwind
define dso_local arm_aapcscc float @__subsf3(float noundef %a, float noundef %b) #0 !dbg !3582 {
entry:
  %a.addr = alloca float, align 4
  %b.addr = alloca float, align 4
  store float %a, float* %a.addr, align 4
  store float %b, float* %b.addr, align 4
  %0 = load float, float* %a.addr, align 4, !dbg !3583
  %1 = load float, float* %b.addr, align 4, !dbg !3584
  %call = call arm_aapcscc i32 @toRep.53(float noundef %1) #4, !dbg !3585
  %xor = xor i32 %call, -2147483648, !dbg !3586
  %call1 = call arm_aapcscc float @fromRep.54(i32 noundef %xor) #4, !dbg !3587
  %call2 = call arm_aapcscc float @__addsf3(float noundef %0, float noundef %call1) #4, !dbg !3588
  ret float %call2, !dbg !3589
}

; Function Attrs: noinline nounwind
define internal arm_aapcscc i32 @toRep.53(float noundef %x) #0 !dbg !3590 {
entry:
  %x.addr = alloca float, align 4
  %rep = alloca %union.anon.0.0, align 4
  store float %x, float* %x.addr, align 4
  %f = bitcast %union.anon.0.0* %rep to float*, !dbg !3591
  %0 = load float, float* %x.addr, align 4, !dbg !3592
  store float %0, float* %f, align 4, !dbg !3591
  %i = bitcast %union.anon.0.0* %rep to i32*, !dbg !3593
  %1 = load i32, i32* %i, align 4, !dbg !3593
  ret i32 %1, !dbg !3594
}

; Function Attrs: noinline nounwind
define internal arm_aapcscc float @fromRep.54(i32 noundef %x) #0 !dbg !3595 {
entry:
  %x.addr = alloca i32, align 4
  %rep = alloca %union.anon.0.0, align 4
  store i32 %x, i32* %x.addr, align 4
  %i = bitcast %union.anon.0.0* %rep to i32*, !dbg !3596
  %0 = load i32, i32* %x.addr, align 4, !dbg !3597
  store i32 %0, i32* %i, align 4, !dbg !3596
  %f = bitcast %union.anon.0.0* %rep to float*, !dbg !3598
  %1 = load float, float* %f, align 4, !dbg !3598
  ret float %1, !dbg !3599
}

; Function Attrs: noinline nounwind
define dso_local arm_aapcscc zeroext i16 @__truncdfhf2(double noundef %a) #0 !dbg !3600 {
entry:
  %a.addr = alloca double, align 8
  store double %a, double* %a.addr, align 8
  %0 = load double, double* %a.addr, align 8, !dbg !3601
  %call = call arm_aapcscc zeroext i16 @__truncXfYf2__(double noundef %0) #4, !dbg !3602
  ret i16 %call, !dbg !3603
}

; Function Attrs: noinline nounwind
define internal arm_aapcscc zeroext i16 @__truncXfYf2__(double noundef %a) #0 !dbg !3604 {
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
  store i32 64, i32* %srcBits, align 4, !dbg !3606
  store i32 11, i32* %srcExpBits, align 4, !dbg !3607
  store i32 2047, i32* %srcInfExp, align 4, !dbg !3608
  store i32 1023, i32* %srcExpBias, align 4, !dbg !3609
  store i64 4503599627370496, i64* %srcMinNormal, align 8, !dbg !3610
  store i64 4503599627370495, i64* %srcSignificandMask, align 8, !dbg !3611
  store i64 9218868437227405312, i64* %srcInfinity, align 8, !dbg !3612
  store i64 -9223372036854775808, i64* %srcSignMask, align 8, !dbg !3613
  store i64 9223372036854775807, i64* %srcAbsMask, align 8, !dbg !3614
  store i64 4398046511103, i64* %roundMask, align 8, !dbg !3615
  store i64 2199023255552, i64* %halfway, align 8, !dbg !3616
  store i64 2251799813685248, i64* %srcQNaN, align 8, !dbg !3617
  store i64 2251799813685247, i64* %srcNaNCode, align 8, !dbg !3618
  store i32 16, i32* %dstBits, align 4, !dbg !3619
  store i32 5, i32* %dstExpBits, align 4, !dbg !3620
  store i32 31, i32* %dstInfExp, align 4, !dbg !3621
  store i32 15, i32* %dstExpBias, align 4, !dbg !3622
  store i32 1009, i32* %underflowExponent, align 4, !dbg !3623
  store i32 1039, i32* %overflowExponent, align 4, !dbg !3624
  store i64 4544132024016830464, i64* %underflow, align 8, !dbg !3625
  store i64 4679240012837945344, i64* %overflow, align 8, !dbg !3626
  store i16 512, i16* %dstQNaN, align 2, !dbg !3627
  store i16 511, i16* %dstNaNCode, align 2, !dbg !3628
  %0 = load double, double* %a.addr, align 8, !dbg !3629
  %call = call arm_aapcscc i64 @srcToRep.55(double noundef %0) #4, !dbg !3630
  store i64 %call, i64* %aRep, align 8, !dbg !3631
  %1 = load i64, i64* %aRep, align 8, !dbg !3632
  %and = and i64 %1, 9223372036854775807, !dbg !3633
  store i64 %and, i64* %aAbs, align 8, !dbg !3634
  %2 = load i64, i64* %aRep, align 8, !dbg !3635
  %and1 = and i64 %2, -9223372036854775808, !dbg !3636
  store i64 %and1, i64* %sign, align 8, !dbg !3637
  %3 = load i64, i64* %aAbs, align 8, !dbg !3638
  %sub = sub i64 %3, 4544132024016830464, !dbg !3639
  %4 = load i64, i64* %aAbs, align 8, !dbg !3640
  %sub2 = sub i64 %4, 4679240012837945344, !dbg !3641
  %cmp = icmp ult i64 %sub, %sub2, !dbg !3642
  br i1 %cmp, label %if.then, label %if.else18, !dbg !3638

if.then:                                          ; preds = %entry
  %5 = load i64, i64* %aAbs, align 8, !dbg !3643
  %shr = lshr i64 %5, 42, !dbg !3644
  %conv = trunc i64 %shr to i16, !dbg !3643
  store i16 %conv, i16* %absResult, align 2, !dbg !3645
  %6 = load i16, i16* %absResult, align 2, !dbg !3646
  %conv3 = zext i16 %6 to i32, !dbg !3646
  %sub4 = sub nsw i32 %conv3, 1032192, !dbg !3646
  %conv5 = trunc i32 %sub4 to i16, !dbg !3646
  store i16 %conv5, i16* %absResult, align 2, !dbg !3646
  %7 = load i64, i64* %aAbs, align 8, !dbg !3647
  %and6 = and i64 %7, 4398046511103, !dbg !3648
  store i64 %and6, i64* %roundBits, align 8, !dbg !3649
  %8 = load i64, i64* %roundBits, align 8, !dbg !3650
  %cmp7 = icmp ugt i64 %8, 2199023255552, !dbg !3651
  br i1 %cmp7, label %if.then9, label %if.else, !dbg !3650

if.then9:                                         ; preds = %if.then
  %9 = load i16, i16* %absResult, align 2, !dbg !3652
  %inc = add i16 %9, 1, !dbg !3652
  store i16 %inc, i16* %absResult, align 2, !dbg !3652
  br label %if.end17, !dbg !3653

if.else:                                          ; preds = %if.then
  %10 = load i64, i64* %roundBits, align 8, !dbg !3654
  %cmp10 = icmp eq i64 %10, 2199023255552, !dbg !3655
  br i1 %cmp10, label %if.then12, label %if.end, !dbg !3654

if.then12:                                        ; preds = %if.else
  %11 = load i16, i16* %absResult, align 2, !dbg !3656
  %conv13 = zext i16 %11 to i32, !dbg !3656
  %and14 = and i32 %conv13, 1, !dbg !3657
  %12 = load i16, i16* %absResult, align 2, !dbg !3658
  %conv15 = zext i16 %12 to i32, !dbg !3658
  %add = add nsw i32 %conv15, %and14, !dbg !3658
  %conv16 = trunc i32 %add to i16, !dbg !3658
  store i16 %conv16, i16* %absResult, align 2, !dbg !3658
  br label %if.end, !dbg !3659

if.end:                                           ; preds = %if.then12, %if.else
  br label %if.end17

if.end17:                                         ; preds = %if.end, %if.then9
  br label %if.end73, !dbg !3660

if.else18:                                        ; preds = %entry
  %13 = load i64, i64* %aAbs, align 8, !dbg !3661
  %cmp19 = icmp ugt i64 %13, 9218868437227405312, !dbg !3662
  br i1 %cmp19, label %if.then21, label %if.else30, !dbg !3661

if.then21:                                        ; preds = %if.else18
  store i16 31744, i16* %absResult, align 2, !dbg !3663
  %14 = load i16, i16* %absResult, align 2, !dbg !3664
  %conv22 = zext i16 %14 to i32, !dbg !3664
  %or = or i32 %conv22, 512, !dbg !3664
  %conv23 = trunc i32 %or to i16, !dbg !3664
  store i16 %conv23, i16* %absResult, align 2, !dbg !3664
  %15 = load i64, i64* %aAbs, align 8, !dbg !3665
  %and24 = and i64 %15, 2251799813685247, !dbg !3666
  %shr25 = lshr i64 %and24, 42, !dbg !3667
  %and26 = and i64 %shr25, 511, !dbg !3668
  %16 = load i16, i16* %absResult, align 2, !dbg !3669
  %conv27 = zext i16 %16 to i64, !dbg !3669
  %or28 = or i64 %conv27, %and26, !dbg !3669
  %conv29 = trunc i64 %or28 to i16, !dbg !3669
  store i16 %conv29, i16* %absResult, align 2, !dbg !3669
  br label %if.end72, !dbg !3670

if.else30:                                        ; preds = %if.else18
  %17 = load i64, i64* %aAbs, align 8, !dbg !3671
  %cmp31 = icmp uge i64 %17, 4679240012837945344, !dbg !3672
  br i1 %cmp31, label %if.then33, label %if.else34, !dbg !3671

if.then33:                                        ; preds = %if.else30
  store i16 31744, i16* %absResult, align 2, !dbg !3673
  br label %if.end71, !dbg !3674

if.else34:                                        ; preds = %if.else30
  %18 = load i64, i64* %aAbs, align 8, !dbg !3675
  %shr35 = lshr i64 %18, 52, !dbg !3676
  %conv36 = trunc i64 %shr35 to i32, !dbg !3675
  store i32 %conv36, i32* %aExp, align 4, !dbg !3677
  %19 = load i32, i32* %aExp, align 4, !dbg !3678
  %sub37 = sub nsw i32 1008, %19, !dbg !3679
  %add38 = add nsw i32 %sub37, 1, !dbg !3680
  store i32 %add38, i32* %shift, align 4, !dbg !3681
  %20 = load i64, i64* %aRep, align 8, !dbg !3682
  %and39 = and i64 %20, 4503599627370495, !dbg !3683
  %or40 = or i64 %and39, 4503599627370496, !dbg !3684
  store i64 %or40, i64* %significand, align 8, !dbg !3685
  %21 = load i32, i32* %shift, align 4, !dbg !3686
  %cmp41 = icmp sgt i32 %21, 52, !dbg !3687
  br i1 %cmp41, label %if.then43, label %if.else44, !dbg !3686

if.then43:                                        ; preds = %if.else34
  store i16 0, i16* %absResult, align 2, !dbg !3688
  br label %if.end70, !dbg !3689

if.else44:                                        ; preds = %if.else34
  %22 = load i64, i64* %significand, align 8, !dbg !3690
  %23 = load i32, i32* %shift, align 4, !dbg !3691
  %sub45 = sub nsw i32 64, %23, !dbg !3692
  %sh_prom = zext i32 %sub45 to i64, !dbg !3693
  %shl = shl i64 %22, %sh_prom, !dbg !3693
  %tobool = icmp ne i64 %shl, 0, !dbg !3690
  %frombool = zext i1 %tobool to i8, !dbg !3694
  store i8 %frombool, i8* %sticky, align 1, !dbg !3694
  %24 = load i64, i64* %significand, align 8, !dbg !3695
  %25 = load i32, i32* %shift, align 4, !dbg !3696
  %sh_prom46 = zext i32 %25 to i64, !dbg !3697
  %shr47 = lshr i64 %24, %sh_prom46, !dbg !3697
  %26 = load i8, i8* %sticky, align 1, !dbg !3698
  %tobool48 = trunc i8 %26 to i1, !dbg !3698
  %conv49 = zext i1 %tobool48 to i64, !dbg !3698
  %or50 = or i64 %shr47, %conv49, !dbg !3699
  store i64 %or50, i64* %denormalizedSignificand, align 8, !dbg !3700
  %27 = load i64, i64* %denormalizedSignificand, align 8, !dbg !3701
  %shr51 = lshr i64 %27, 42, !dbg !3702
  %conv52 = trunc i64 %shr51 to i16, !dbg !3701
  store i16 %conv52, i16* %absResult, align 2, !dbg !3703
  %28 = load i64, i64* %denormalizedSignificand, align 8, !dbg !3704
  %and54 = and i64 %28, 4398046511103, !dbg !3705
  store i64 %and54, i64* %roundBits53, align 8, !dbg !3706
  %29 = load i64, i64* %roundBits53, align 8, !dbg !3707
  %cmp55 = icmp ugt i64 %29, 2199023255552, !dbg !3708
  br i1 %cmp55, label %if.then57, label %if.else59, !dbg !3707

if.then57:                                        ; preds = %if.else44
  %30 = load i16, i16* %absResult, align 2, !dbg !3709
  %inc58 = add i16 %30, 1, !dbg !3709
  store i16 %inc58, i16* %absResult, align 2, !dbg !3709
  br label %if.end69, !dbg !3710

if.else59:                                        ; preds = %if.else44
  %31 = load i64, i64* %roundBits53, align 8, !dbg !3711
  %cmp60 = icmp eq i64 %31, 2199023255552, !dbg !3712
  br i1 %cmp60, label %if.then62, label %if.end68, !dbg !3711

if.then62:                                        ; preds = %if.else59
  %32 = load i16, i16* %absResult, align 2, !dbg !3713
  %conv63 = zext i16 %32 to i32, !dbg !3713
  %and64 = and i32 %conv63, 1, !dbg !3714
  %33 = load i16, i16* %absResult, align 2, !dbg !3715
  %conv65 = zext i16 %33 to i32, !dbg !3715
  %add66 = add nsw i32 %conv65, %and64, !dbg !3715
  %conv67 = trunc i32 %add66 to i16, !dbg !3715
  store i16 %conv67, i16* %absResult, align 2, !dbg !3715
  br label %if.end68, !dbg !3716

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
  %34 = load i16, i16* %absResult, align 2, !dbg !3717
  %conv74 = zext i16 %34 to i64, !dbg !3717
  %35 = load i64, i64* %sign, align 8, !dbg !3718
  %shr75 = lshr i64 %35, 48, !dbg !3719
  %or76 = or i64 %conv74, %shr75, !dbg !3720
  %conv77 = trunc i64 %or76 to i16, !dbg !3717
  store i16 %conv77, i16* %result, align 2, !dbg !3721
  %36 = load i16, i16* %result, align 2, !dbg !3722
  %call78 = call arm_aapcscc zeroext i16 @dstFromRep.56(i16 noundef zeroext %36) #4, !dbg !3723
  ret i16 %call78, !dbg !3724
}

; Function Attrs: noinline nounwind
define internal arm_aapcscc i64 @srcToRep.55(double noundef %x) #0 !dbg !3725 {
entry:
  %x.addr = alloca double, align 8
  %rep = alloca %union.anon.0, align 8
  store double %x, double* %x.addr, align 8
  %f = bitcast %union.anon.0* %rep to double*, !dbg !3727
  %0 = load double, double* %x.addr, align 8, !dbg !3728
  store double %0, double* %f, align 8, !dbg !3727
  %i = bitcast %union.anon.0* %rep to i64*, !dbg !3729
  %1 = load i64, i64* %i, align 8, !dbg !3729
  ret i64 %1, !dbg !3730
}

; Function Attrs: noinline nounwind
define internal arm_aapcscc zeroext i16 @dstFromRep.56(i16 noundef zeroext %x) #0 !dbg !3731 {
entry:
  %x.addr = alloca i16, align 2
  %rep = alloca %union.anon, align 2
  store i16 %x, i16* %x.addr, align 2
  %i = bitcast %union.anon* %rep to i16*, !dbg !3732
  %0 = load i16, i16* %x.addr, align 2, !dbg !3733
  store i16 %0, i16* %i, align 2, !dbg !3732
  %f = bitcast %union.anon* %rep to i16*, !dbg !3734
  %1 = load i16, i16* %f, align 2, !dbg !3734
  ret i16 %1, !dbg !3735
}

; Function Attrs: noinline nounwind
define dso_local arm_aapcscc float @__truncdfsf2(double noundef %a) #0 !dbg !3736 {
entry:
  %a.addr = alloca double, align 8
  store double %a, double* %a.addr, align 8
  %0 = load double, double* %a.addr, align 8, !dbg !3737
  %call = call arm_aapcscc float @__truncXfYf2__.57(double noundef %0) #4, !dbg !3738
  ret float %call, !dbg !3739
}

; Function Attrs: noinline nounwind
define internal arm_aapcscc float @__truncXfYf2__.57(double noundef %a) #0 !dbg !3740 {
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
  store i32 64, i32* %srcBits, align 4, !dbg !3741
  store i32 11, i32* %srcExpBits, align 4, !dbg !3742
  store i32 2047, i32* %srcInfExp, align 4, !dbg !3743
  store i32 1023, i32* %srcExpBias, align 4, !dbg !3744
  store i64 4503599627370496, i64* %srcMinNormal, align 8, !dbg !3745
  store i64 4503599627370495, i64* %srcSignificandMask, align 8, !dbg !3746
  store i64 9218868437227405312, i64* %srcInfinity, align 8, !dbg !3747
  store i64 -9223372036854775808, i64* %srcSignMask, align 8, !dbg !3748
  store i64 9223372036854775807, i64* %srcAbsMask, align 8, !dbg !3749
  store i64 536870911, i64* %roundMask, align 8, !dbg !3750
  store i64 268435456, i64* %halfway, align 8, !dbg !3751
  store i64 2251799813685248, i64* %srcQNaN, align 8, !dbg !3752
  store i64 2251799813685247, i64* %srcNaNCode, align 8, !dbg !3753
  store i32 32, i32* %dstBits, align 4, !dbg !3754
  store i32 8, i32* %dstExpBits, align 4, !dbg !3755
  store i32 255, i32* %dstInfExp, align 4, !dbg !3756
  store i32 127, i32* %dstExpBias, align 4, !dbg !3757
  store i32 897, i32* %underflowExponent, align 4, !dbg !3758
  store i32 1151, i32* %overflowExponent, align 4, !dbg !3759
  store i64 4039728865751334912, i64* %underflow, align 8, !dbg !3760
  store i64 5183643171103440896, i64* %overflow, align 8, !dbg !3761
  store i32 4194304, i32* %dstQNaN, align 4, !dbg !3762
  store i32 4194303, i32* %dstNaNCode, align 4, !dbg !3763
  %0 = load double, double* %a.addr, align 8, !dbg !3764
  %call = call arm_aapcscc i64 @srcToRep.58(double noundef %0) #4, !dbg !3765
  store i64 %call, i64* %aRep, align 8, !dbg !3766
  %1 = load i64, i64* %aRep, align 8, !dbg !3767
  %and = and i64 %1, 9223372036854775807, !dbg !3768
  store i64 %and, i64* %aAbs, align 8, !dbg !3769
  %2 = load i64, i64* %aRep, align 8, !dbg !3770
  %and1 = and i64 %2, -9223372036854775808, !dbg !3771
  store i64 %and1, i64* %sign, align 8, !dbg !3772
  %3 = load i64, i64* %aAbs, align 8, !dbg !3773
  %sub = sub i64 %3, 4039728865751334912, !dbg !3774
  %4 = load i64, i64* %aAbs, align 8, !dbg !3775
  %sub2 = sub i64 %4, 5183643171103440896, !dbg !3776
  %cmp = icmp ult i64 %sub, %sub2, !dbg !3777
  br i1 %cmp, label %if.then, label %if.else13, !dbg !3773

if.then:                                          ; preds = %entry
  %5 = load i64, i64* %aAbs, align 8, !dbg !3778
  %shr = lshr i64 %5, 29, !dbg !3779
  %conv = trunc i64 %shr to i32, !dbg !3778
  store i32 %conv, i32* %absResult, align 4, !dbg !3780
  %6 = load i32, i32* %absResult, align 4, !dbg !3781
  %sub3 = sub i32 %6, -1073741824, !dbg !3781
  store i32 %sub3, i32* %absResult, align 4, !dbg !3781
  %7 = load i64, i64* %aAbs, align 8, !dbg !3782
  %and4 = and i64 %7, 536870911, !dbg !3783
  store i64 %and4, i64* %roundBits, align 8, !dbg !3784
  %8 = load i64, i64* %roundBits, align 8, !dbg !3785
  %cmp5 = icmp ugt i64 %8, 268435456, !dbg !3786
  br i1 %cmp5, label %if.then7, label %if.else, !dbg !3785

if.then7:                                         ; preds = %if.then
  %9 = load i32, i32* %absResult, align 4, !dbg !3787
  %inc = add i32 %9, 1, !dbg !3787
  store i32 %inc, i32* %absResult, align 4, !dbg !3787
  br label %if.end12, !dbg !3788

if.else:                                          ; preds = %if.then
  %10 = load i64, i64* %roundBits, align 8, !dbg !3789
  %cmp8 = icmp eq i64 %10, 268435456, !dbg !3790
  br i1 %cmp8, label %if.then10, label %if.end, !dbg !3789

if.then10:                                        ; preds = %if.else
  %11 = load i32, i32* %absResult, align 4, !dbg !3791
  %and11 = and i32 %11, 1, !dbg !3792
  %12 = load i32, i32* %absResult, align 4, !dbg !3793
  %add = add i32 %12, %and11, !dbg !3793
  store i32 %add, i32* %absResult, align 4, !dbg !3793
  br label %if.end, !dbg !3794

if.end:                                           ; preds = %if.then10, %if.else
  br label %if.end12

if.end12:                                         ; preds = %if.end, %if.then7
  br label %if.end63, !dbg !3795

if.else13:                                        ; preds = %entry
  %13 = load i64, i64* %aAbs, align 8, !dbg !3796
  %cmp14 = icmp ugt i64 %13, 9218868437227405312, !dbg !3797
  br i1 %cmp14, label %if.then16, label %if.else23, !dbg !3796

if.then16:                                        ; preds = %if.else13
  store i32 2139095040, i32* %absResult, align 4, !dbg !3798
  %14 = load i32, i32* %absResult, align 4, !dbg !3799
  %or = or i32 %14, 4194304, !dbg !3799
  store i32 %or, i32* %absResult, align 4, !dbg !3799
  %15 = load i64, i64* %aAbs, align 8, !dbg !3800
  %and17 = and i64 %15, 2251799813685247, !dbg !3801
  %shr18 = lshr i64 %and17, 29, !dbg !3802
  %and19 = and i64 %shr18, 4194303, !dbg !3803
  %16 = load i32, i32* %absResult, align 4, !dbg !3804
  %conv20 = zext i32 %16 to i64, !dbg !3804
  %or21 = or i64 %conv20, %and19, !dbg !3804
  %conv22 = trunc i64 %or21 to i32, !dbg !3804
  store i32 %conv22, i32* %absResult, align 4, !dbg !3804
  br label %if.end62, !dbg !3805

if.else23:                                        ; preds = %if.else13
  %17 = load i64, i64* %aAbs, align 8, !dbg !3806
  %cmp24 = icmp uge i64 %17, 5183643171103440896, !dbg !3807
  br i1 %cmp24, label %if.then26, label %if.else27, !dbg !3806

if.then26:                                        ; preds = %if.else23
  store i32 2139095040, i32* %absResult, align 4, !dbg !3808
  br label %if.end61, !dbg !3809

if.else27:                                        ; preds = %if.else23
  %18 = load i64, i64* %aAbs, align 8, !dbg !3810
  %shr28 = lshr i64 %18, 52, !dbg !3811
  %conv29 = trunc i64 %shr28 to i32, !dbg !3810
  store i32 %conv29, i32* %aExp, align 4, !dbg !3812
  %19 = load i32, i32* %aExp, align 4, !dbg !3813
  %sub30 = sub nsw i32 896, %19, !dbg !3814
  %add31 = add nsw i32 %sub30, 1, !dbg !3815
  store i32 %add31, i32* %shift, align 4, !dbg !3816
  %20 = load i64, i64* %aRep, align 8, !dbg !3817
  %and32 = and i64 %20, 4503599627370495, !dbg !3818
  %or33 = or i64 %and32, 4503599627370496, !dbg !3819
  store i64 %or33, i64* %significand, align 8, !dbg !3820
  %21 = load i32, i32* %shift, align 4, !dbg !3821
  %cmp34 = icmp sgt i32 %21, 52, !dbg !3822
  br i1 %cmp34, label %if.then36, label %if.else37, !dbg !3821

if.then36:                                        ; preds = %if.else27
  store i32 0, i32* %absResult, align 4, !dbg !3823
  br label %if.end60, !dbg !3824

if.else37:                                        ; preds = %if.else27
  %22 = load i64, i64* %significand, align 8, !dbg !3825
  %23 = load i32, i32* %shift, align 4, !dbg !3826
  %sub38 = sub nsw i32 64, %23, !dbg !3827
  %sh_prom = zext i32 %sub38 to i64, !dbg !3828
  %shl = shl i64 %22, %sh_prom, !dbg !3828
  %tobool = icmp ne i64 %shl, 0, !dbg !3825
  %frombool = zext i1 %tobool to i8, !dbg !3829
  store i8 %frombool, i8* %sticky, align 1, !dbg !3829
  %24 = load i64, i64* %significand, align 8, !dbg !3830
  %25 = load i32, i32* %shift, align 4, !dbg !3831
  %sh_prom39 = zext i32 %25 to i64, !dbg !3832
  %shr40 = lshr i64 %24, %sh_prom39, !dbg !3832
  %26 = load i8, i8* %sticky, align 1, !dbg !3833
  %tobool41 = trunc i8 %26 to i1, !dbg !3833
  %conv42 = zext i1 %tobool41 to i64, !dbg !3833
  %or43 = or i64 %shr40, %conv42, !dbg !3834
  store i64 %or43, i64* %denormalizedSignificand, align 8, !dbg !3835
  %27 = load i64, i64* %denormalizedSignificand, align 8, !dbg !3836
  %shr44 = lshr i64 %27, 29, !dbg !3837
  %conv45 = trunc i64 %shr44 to i32, !dbg !3836
  store i32 %conv45, i32* %absResult, align 4, !dbg !3838
  %28 = load i64, i64* %denormalizedSignificand, align 8, !dbg !3839
  %and47 = and i64 %28, 536870911, !dbg !3840
  store i64 %and47, i64* %roundBits46, align 8, !dbg !3841
  %29 = load i64, i64* %roundBits46, align 8, !dbg !3842
  %cmp48 = icmp ugt i64 %29, 268435456, !dbg !3843
  br i1 %cmp48, label %if.then50, label %if.else52, !dbg !3842

if.then50:                                        ; preds = %if.else37
  %30 = load i32, i32* %absResult, align 4, !dbg !3844
  %inc51 = add i32 %30, 1, !dbg !3844
  store i32 %inc51, i32* %absResult, align 4, !dbg !3844
  br label %if.end59, !dbg !3845

if.else52:                                        ; preds = %if.else37
  %31 = load i64, i64* %roundBits46, align 8, !dbg !3846
  %cmp53 = icmp eq i64 %31, 268435456, !dbg !3847
  br i1 %cmp53, label %if.then55, label %if.end58, !dbg !3846

if.then55:                                        ; preds = %if.else52
  %32 = load i32, i32* %absResult, align 4, !dbg !3848
  %and56 = and i32 %32, 1, !dbg !3849
  %33 = load i32, i32* %absResult, align 4, !dbg !3850
  %add57 = add i32 %33, %and56, !dbg !3850
  store i32 %add57, i32* %absResult, align 4, !dbg !3850
  br label %if.end58, !dbg !3851

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
  %34 = load i32, i32* %absResult, align 4, !dbg !3852
  %conv64 = zext i32 %34 to i64, !dbg !3852
  %35 = load i64, i64* %sign, align 8, !dbg !3853
  %shr65 = lshr i64 %35, 32, !dbg !3854
  %or66 = or i64 %conv64, %shr65, !dbg !3855
  %conv67 = trunc i64 %or66 to i32, !dbg !3852
  store i32 %conv67, i32* %result, align 4, !dbg !3856
  %36 = load i32, i32* %result, align 4, !dbg !3857
  %call68 = call arm_aapcscc float @dstFromRep.59(i32 noundef %36) #4, !dbg !3858
  ret float %call68, !dbg !3859
}

; Function Attrs: noinline nounwind
define internal arm_aapcscc i64 @srcToRep.58(double noundef %x) #0 !dbg !3860 {
entry:
  %x.addr = alloca double, align 8
  %rep = alloca %union.anon.0, align 8
  store double %x, double* %x.addr, align 8
  %f = bitcast %union.anon.0* %rep to double*, !dbg !3861
  %0 = load double, double* %x.addr, align 8, !dbg !3862
  store double %0, double* %f, align 8, !dbg !3861
  %i = bitcast %union.anon.0* %rep to i64*, !dbg !3863
  %1 = load i64, i64* %i, align 8, !dbg !3863
  ret i64 %1, !dbg !3864
}

; Function Attrs: noinline nounwind
define internal arm_aapcscc float @dstFromRep.59(i32 noundef %x) #0 !dbg !3865 {
entry:
  %x.addr = alloca i32, align 4
  %rep = alloca %union.anon.0.0, align 4
  store i32 %x, i32* %x.addr, align 4
  %i = bitcast %union.anon.0.0* %rep to i32*, !dbg !3866
  %0 = load i32, i32* %x.addr, align 4, !dbg !3867
  store i32 %0, i32* %i, align 4, !dbg !3866
  %f = bitcast %union.anon.0.0* %rep to float*, !dbg !3868
  %1 = load float, float* %f, align 4, !dbg !3868
  ret float %1, !dbg !3869
}

; Function Attrs: noinline nounwind
define dso_local arm_aapcscc zeroext i16 @__truncsfhf2(float noundef %a) #0 !dbg !3870 {
entry:
  %a.addr = alloca float, align 4
  store float %a, float* %a.addr, align 4
  %0 = load float, float* %a.addr, align 4, !dbg !3871
  %call = call arm_aapcscc zeroext i16 @__truncXfYf2__.60(float noundef %0) #4, !dbg !3872
  ret i16 %call, !dbg !3873
}

; Function Attrs: noinline nounwind
define internal arm_aapcscc zeroext i16 @__truncXfYf2__.60(float noundef %a) #0 !dbg !3874 {
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
  store i32 32, i32* %srcBits, align 4, !dbg !3875
  store i32 8, i32* %srcExpBits, align 4, !dbg !3876
  store i32 255, i32* %srcInfExp, align 4, !dbg !3877
  store i32 127, i32* %srcExpBias, align 4, !dbg !3878
  store i32 8388608, i32* %srcMinNormal, align 4, !dbg !3879
  store i32 8388607, i32* %srcSignificandMask, align 4, !dbg !3880
  store i32 2139095040, i32* %srcInfinity, align 4, !dbg !3881
  store i32 -2147483648, i32* %srcSignMask, align 4, !dbg !3882
  store i32 2147483647, i32* %srcAbsMask, align 4, !dbg !3883
  store i32 8191, i32* %roundMask, align 4, !dbg !3884
  store i32 4096, i32* %halfway, align 4, !dbg !3885
  store i32 4194304, i32* %srcQNaN, align 4, !dbg !3886
  store i32 4194303, i32* %srcNaNCode, align 4, !dbg !3887
  store i32 16, i32* %dstBits, align 4, !dbg !3888
  store i32 5, i32* %dstExpBits, align 4, !dbg !3889
  store i32 31, i32* %dstInfExp, align 4, !dbg !3890
  store i32 15, i32* %dstExpBias, align 4, !dbg !3891
  store i32 113, i32* %underflowExponent, align 4, !dbg !3892
  store i32 143, i32* %overflowExponent, align 4, !dbg !3893
  store i32 947912704, i32* %underflow, align 4, !dbg !3894
  store i32 1199570944, i32* %overflow, align 4, !dbg !3895
  store i16 512, i16* %dstQNaN, align 2, !dbg !3896
  store i16 511, i16* %dstNaNCode, align 2, !dbg !3897
  %0 = load float, float* %a.addr, align 4, !dbg !3898
  %call = call arm_aapcscc i32 @srcToRep.61(float noundef %0) #4, !dbg !3899
  store i32 %call, i32* %aRep, align 4, !dbg !3900
  %1 = load i32, i32* %aRep, align 4, !dbg !3901
  %and = and i32 %1, 2147483647, !dbg !3902
  store i32 %and, i32* %aAbs, align 4, !dbg !3903
  %2 = load i32, i32* %aRep, align 4, !dbg !3904
  %and1 = and i32 %2, -2147483648, !dbg !3905
  store i32 %and1, i32* %sign, align 4, !dbg !3906
  %3 = load i32, i32* %aAbs, align 4, !dbg !3907
  %sub = sub i32 %3, 947912704, !dbg !3908
  %4 = load i32, i32* %aAbs, align 4, !dbg !3909
  %sub2 = sub i32 %4, 1199570944, !dbg !3910
  %cmp = icmp ult i32 %sub, %sub2, !dbg !3911
  br i1 %cmp, label %if.then, label %if.else18, !dbg !3907

if.then:                                          ; preds = %entry
  %5 = load i32, i32* %aAbs, align 4, !dbg !3912
  %shr = lshr i32 %5, 13, !dbg !3913
  %conv = trunc i32 %shr to i16, !dbg !3912
  store i16 %conv, i16* %absResult, align 2, !dbg !3914
  %6 = load i16, i16* %absResult, align 2, !dbg !3915
  %conv3 = zext i16 %6 to i32, !dbg !3915
  %sub4 = sub nsw i32 %conv3, 114688, !dbg !3915
  %conv5 = trunc i32 %sub4 to i16, !dbg !3915
  store i16 %conv5, i16* %absResult, align 2, !dbg !3915
  %7 = load i32, i32* %aAbs, align 4, !dbg !3916
  %and6 = and i32 %7, 8191, !dbg !3917
  store i32 %and6, i32* %roundBits, align 4, !dbg !3918
  %8 = load i32, i32* %roundBits, align 4, !dbg !3919
  %cmp7 = icmp ugt i32 %8, 4096, !dbg !3920
  br i1 %cmp7, label %if.then9, label %if.else, !dbg !3919

if.then9:                                         ; preds = %if.then
  %9 = load i16, i16* %absResult, align 2, !dbg !3921
  %inc = add i16 %9, 1, !dbg !3921
  store i16 %inc, i16* %absResult, align 2, !dbg !3921
  br label %if.end17, !dbg !3922

if.else:                                          ; preds = %if.then
  %10 = load i32, i32* %roundBits, align 4, !dbg !3923
  %cmp10 = icmp eq i32 %10, 4096, !dbg !3924
  br i1 %cmp10, label %if.then12, label %if.end, !dbg !3923

if.then12:                                        ; preds = %if.else
  %11 = load i16, i16* %absResult, align 2, !dbg !3925
  %conv13 = zext i16 %11 to i32, !dbg !3925
  %and14 = and i32 %conv13, 1, !dbg !3926
  %12 = load i16, i16* %absResult, align 2, !dbg !3927
  %conv15 = zext i16 %12 to i32, !dbg !3927
  %add = add nsw i32 %conv15, %and14, !dbg !3927
  %conv16 = trunc i32 %add to i16, !dbg !3927
  store i16 %conv16, i16* %absResult, align 2, !dbg !3927
  br label %if.end, !dbg !3928

if.end:                                           ; preds = %if.then12, %if.else
  br label %if.end17

if.end17:                                         ; preds = %if.end, %if.then9
  br label %if.end71, !dbg !3929

if.else18:                                        ; preds = %entry
  %13 = load i32, i32* %aAbs, align 4, !dbg !3930
  %cmp19 = icmp ugt i32 %13, 2139095040, !dbg !3931
  br i1 %cmp19, label %if.then21, label %if.else30, !dbg !3930

if.then21:                                        ; preds = %if.else18
  store i16 31744, i16* %absResult, align 2, !dbg !3932
  %14 = load i16, i16* %absResult, align 2, !dbg !3933
  %conv22 = zext i16 %14 to i32, !dbg !3933
  %or = or i32 %conv22, 512, !dbg !3933
  %conv23 = trunc i32 %or to i16, !dbg !3933
  store i16 %conv23, i16* %absResult, align 2, !dbg !3933
  %15 = load i32, i32* %aAbs, align 4, !dbg !3934
  %and24 = and i32 %15, 4194303, !dbg !3935
  %shr25 = lshr i32 %and24, 13, !dbg !3936
  %and26 = and i32 %shr25, 511, !dbg !3937
  %16 = load i16, i16* %absResult, align 2, !dbg !3938
  %conv27 = zext i16 %16 to i32, !dbg !3938
  %or28 = or i32 %conv27, %and26, !dbg !3938
  %conv29 = trunc i32 %or28 to i16, !dbg !3938
  store i16 %conv29, i16* %absResult, align 2, !dbg !3938
  br label %if.end70, !dbg !3939

if.else30:                                        ; preds = %if.else18
  %17 = load i32, i32* %aAbs, align 4, !dbg !3940
  %cmp31 = icmp uge i32 %17, 1199570944, !dbg !3941
  br i1 %cmp31, label %if.then33, label %if.else34, !dbg !3940

if.then33:                                        ; preds = %if.else30
  store i16 31744, i16* %absResult, align 2, !dbg !3942
  br label %if.end69, !dbg !3943

if.else34:                                        ; preds = %if.else30
  %18 = load i32, i32* %aAbs, align 4, !dbg !3944
  %shr35 = lshr i32 %18, 23, !dbg !3945
  store i32 %shr35, i32* %aExp, align 4, !dbg !3946
  %19 = load i32, i32* %aExp, align 4, !dbg !3947
  %sub36 = sub nsw i32 112, %19, !dbg !3948
  %add37 = add nsw i32 %sub36, 1, !dbg !3949
  store i32 %add37, i32* %shift, align 4, !dbg !3950
  %20 = load i32, i32* %aRep, align 4, !dbg !3951
  %and38 = and i32 %20, 8388607, !dbg !3952
  %or39 = or i32 %and38, 8388608, !dbg !3953
  store i32 %or39, i32* %significand, align 4, !dbg !3954
  %21 = load i32, i32* %shift, align 4, !dbg !3955
  %cmp40 = icmp sgt i32 %21, 23, !dbg !3956
  br i1 %cmp40, label %if.then42, label %if.else43, !dbg !3955

if.then42:                                        ; preds = %if.else34
  store i16 0, i16* %absResult, align 2, !dbg !3957
  br label %if.end68, !dbg !3958

if.else43:                                        ; preds = %if.else34
  %22 = load i32, i32* %significand, align 4, !dbg !3959
  %23 = load i32, i32* %shift, align 4, !dbg !3960
  %sub44 = sub nsw i32 32, %23, !dbg !3961
  %shl = shl i32 %22, %sub44, !dbg !3962
  %tobool = icmp ne i32 %shl, 0, !dbg !3959
  %frombool = zext i1 %tobool to i8, !dbg !3963
  store i8 %frombool, i8* %sticky, align 1, !dbg !3963
  %24 = load i32, i32* %significand, align 4, !dbg !3964
  %25 = load i32, i32* %shift, align 4, !dbg !3965
  %shr45 = lshr i32 %24, %25, !dbg !3966
  %26 = load i8, i8* %sticky, align 1, !dbg !3967
  %tobool46 = trunc i8 %26 to i1, !dbg !3967
  %conv47 = zext i1 %tobool46 to i32, !dbg !3967
  %or48 = or i32 %shr45, %conv47, !dbg !3968
  store i32 %or48, i32* %denormalizedSignificand, align 4, !dbg !3969
  %27 = load i32, i32* %denormalizedSignificand, align 4, !dbg !3970
  %shr49 = lshr i32 %27, 13, !dbg !3971
  %conv50 = trunc i32 %shr49 to i16, !dbg !3970
  store i16 %conv50, i16* %absResult, align 2, !dbg !3972
  %28 = load i32, i32* %denormalizedSignificand, align 4, !dbg !3973
  %and52 = and i32 %28, 8191, !dbg !3974
  store i32 %and52, i32* %roundBits51, align 4, !dbg !3975
  %29 = load i32, i32* %roundBits51, align 4, !dbg !3976
  %cmp53 = icmp ugt i32 %29, 4096, !dbg !3977
  br i1 %cmp53, label %if.then55, label %if.else57, !dbg !3976

if.then55:                                        ; preds = %if.else43
  %30 = load i16, i16* %absResult, align 2, !dbg !3978
  %inc56 = add i16 %30, 1, !dbg !3978
  store i16 %inc56, i16* %absResult, align 2, !dbg !3978
  br label %if.end67, !dbg !3979

if.else57:                                        ; preds = %if.else43
  %31 = load i32, i32* %roundBits51, align 4, !dbg !3980
  %cmp58 = icmp eq i32 %31, 4096, !dbg !3981
  br i1 %cmp58, label %if.then60, label %if.end66, !dbg !3980

if.then60:                                        ; preds = %if.else57
  %32 = load i16, i16* %absResult, align 2, !dbg !3982
  %conv61 = zext i16 %32 to i32, !dbg !3982
  %and62 = and i32 %conv61, 1, !dbg !3983
  %33 = load i16, i16* %absResult, align 2, !dbg !3984
  %conv63 = zext i16 %33 to i32, !dbg !3984
  %add64 = add nsw i32 %conv63, %and62, !dbg !3984
  %conv65 = trunc i32 %add64 to i16, !dbg !3984
  store i16 %conv65, i16* %absResult, align 2, !dbg !3984
  br label %if.end66, !dbg !3985

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
  %34 = load i16, i16* %absResult, align 2, !dbg !3986
  %conv72 = zext i16 %34 to i32, !dbg !3986
  %35 = load i32, i32* %sign, align 4, !dbg !3987
  %shr73 = lshr i32 %35, 16, !dbg !3988
  %or74 = or i32 %conv72, %shr73, !dbg !3989
  %conv75 = trunc i32 %or74 to i16, !dbg !3986
  store i16 %conv75, i16* %result, align 2, !dbg !3990
  %36 = load i16, i16* %result, align 2, !dbg !3991
  %call76 = call arm_aapcscc zeroext i16 @dstFromRep.62(i16 noundef zeroext %36) #4, !dbg !3992
  ret i16 %call76, !dbg !3993
}

; Function Attrs: noinline nounwind
define internal arm_aapcscc i32 @srcToRep.61(float noundef %x) #0 !dbg !3994 {
entry:
  %x.addr = alloca float, align 4
  %rep = alloca %union.anon.0.0, align 4
  store float %x, float* %x.addr, align 4
  %f = bitcast %union.anon.0.0* %rep to float*, !dbg !3995
  %0 = load float, float* %x.addr, align 4, !dbg !3996
  store float %0, float* %f, align 4, !dbg !3995
  %i = bitcast %union.anon.0.0* %rep to i32*, !dbg !3997
  %1 = load i32, i32* %i, align 4, !dbg !3997
  ret i32 %1, !dbg !3998
}

; Function Attrs: noinline nounwind
define internal arm_aapcscc zeroext i16 @dstFromRep.62(i16 noundef zeroext %x) #0 !dbg !3999 {
entry:
  %x.addr = alloca i16, align 2
  %rep = alloca %union.anon, align 2
  store i16 %x, i16* %x.addr, align 2
  %i = bitcast %union.anon* %rep to i16*, !dbg !4000
  %0 = load i16, i16* %x.addr, align 2, !dbg !4001
  store i16 %0, i16* %i, align 2, !dbg !4000
  %f = bitcast %union.anon* %rep to i16*, !dbg !4002
  %1 = load i16, i16* %f, align 2, !dbg !4002
  ret i16 %1, !dbg !4003
}

; Function Attrs: noinline nounwind
define dso_local arm_aapcscc zeroext i16 @__gnu_f2h_ieee(float noundef %a) #0 !dbg !4004 {
entry:
  %a.addr = alloca float, align 4
  store float %a, float* %a.addr, align 4
  %0 = load float, float* %a.addr, align 4, !dbg !4005
  %call = call arm_aapcscc zeroext i16 @__truncsfhf2(float noundef %0) #4, !dbg !4006
  ret i16 %call, !dbg !4007
}

attributes #0 = { noinline nounwind "frame-pointer"="all" "min-legal-vector-width"="0" "no-builtins" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="arm7tdmi" "target-features"="+armv4t,+soft-float,+strict-align,-aes,-bf16,-d32,-dotprod,-fp-armv8,-fp-armv8d16,-fp-armv8d16sp,-fp-armv8sp,-fp16,-fp16fml,-fp64,-fpregs,-fullfp16,-mve,-mve.fp,-neon,-sha2,-thumb-mode,-vfp2,-vfp2sp,-vfp3,-vfp3d16,-vfp3d16sp,-vfp3sp,-vfp4,-vfp4d16,-vfp4d16sp,-vfp4sp" "use-soft-float"="true" }
attributes #1 = { nofree nosync nounwind readnone speculatable willreturn }
attributes #2 = { argmemonly nofree nounwind willreturn }
attributes #3 = { noinline noreturn nounwind "frame-pointer"="all" "min-legal-vector-width"="0" "no-builtins" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="arm7tdmi" "target-features"="+armv4t,+soft-float,+strict-align,-aes,-bf16,-d32,-dotprod,-fp-armv8,-fp-armv8d16,-fp-armv8d16sp,-fp-armv8sp,-fp16,-fp16fml,-fp64,-fpregs,-fullfp16,-mve,-mve.fp,-neon,-sha2,-thumb-mode,-vfp2,-vfp2sp,-vfp3,-vfp3d16,-vfp3d16sp,-vfp3sp,-vfp4,-vfp4d16,-vfp4d16sp,-vfp4sp" "use-soft-float"="true" }
attributes #4 = { nobuiltin "no-builtins" }
attributes #5 = { nobuiltin noreturn "no-builtins" }

!llvm.dbg.cu = !{!0, !2, !4, !6, !8, !10, !12, !14, !16, !18, !20, !22, !24, !26, !28, !30, !32, !34, !36, !38, !40, !42, !44, !46, !48, !50, !52, !54, !56, !58, !60, !62, !64, !66, !68, !70, !72, !74, !76, !78, !80, !82, !84, !86, !88, !90, !92, !94, !96, !98, !100, !102, !104, !106, !108, !110, !112, !114, !116, !118, !120, !122, !124, !126, !128, !130, !132, !134, !136, !138, !140, !142, !144, !146, !148, !150, !152, !154, !156, !158, !160, !162, !164, !166, !168, !170}
!llvm.ident = !{!172, !172, !172, !172, !172, !172, !172, !172, !172, !172, !172, !172, !172, !172, !172, !172, !172, !172, !172, !172, !172, !172, !172, !172, !172, !172, !172, !172, !172, !172, !172, !172, !172, !172, !172, !172, !172, !172, !172, !172, !172, !172, !172, !172, !172, !172, !172, !172, !172, !172, !172, !172, !172, !172, !172, !172, !172, !172, !172, !172, !172, !172, !172, !172, !172, !172, !172, !172, !172, !172, !172, !172, !172, !172, !172, !172, !172, !172, !172, !172, !172, !172, !172, !172, !172, !172}
!llvm.module.flags = !{!173, !174, !175, !176, !177, !178, !179, !180, !181}

!0 = distinct !DICompileUnit(language: DW_LANG_C99, file: !1, producer: "clang version 14.0.6 (git@gitlab.tu-dortmund.de:f4-ls12-daes/llvmta/llvmta.git 64262528b05c9d91a76d9ec1ec1045982f385529)", isOptimized: false, runtimeVersion: 0, emissionKind: LineTablesOnly, splitDebugInlining: false, nameTableKind: None)
!1 = !DIFile(filename: "../adddf3.c", directory: "/workspaces/llvmta/testcases/libraries/builtinsfloat/buildarmv4", checksumkind: CSK_MD5, checksum: "e0251d85d8b9298f4b7d7bde89c2da14")
!2 = distinct !DICompileUnit(language: DW_LANG_C99, file: !3, producer: "clang version 14.0.6 (git@gitlab.tu-dortmund.de:f4-ls12-daes/llvmta/llvmta.git 64262528b05c9d91a76d9ec1ec1045982f385529)", isOptimized: false, runtimeVersion: 0, emissionKind: LineTablesOnly, splitDebugInlining: false, nameTableKind: None)
!3 = !DIFile(filename: "../addsf3.c", directory: "/workspaces/llvmta/testcases/libraries/builtinsfloat/buildarmv4", checksumkind: CSK_MD5, checksum: "374fec2ce14c515fea2743927d345a52")
!4 = distinct !DICompileUnit(language: DW_LANG_C99, file: !5, producer: "clang version 14.0.6 (git@gitlab.tu-dortmund.de:f4-ls12-daes/llvmta/llvmta.git 64262528b05c9d91a76d9ec1ec1045982f385529)", isOptimized: false, runtimeVersion: 0, emissionKind: LineTablesOnly, splitDebugInlining: false, nameTableKind: None)
!5 = !DIFile(filename: "../addtf3.c", directory: "/workspaces/llvmta/testcases/libraries/builtinsfloat/buildarmv4", checksumkind: CSK_MD5, checksum: "b8a80da606472788c7fd49791b6a3e7b")
!6 = distinct !DICompileUnit(language: DW_LANG_C99, file: !7, producer: "clang version 14.0.6 (git@gitlab.tu-dortmund.de:f4-ls12-daes/llvmta/llvmta.git 64262528b05c9d91a76d9ec1ec1045982f385529)", isOptimized: false, runtimeVersion: 0, emissionKind: LineTablesOnly, splitDebugInlining: false, nameTableKind: None)
!7 = !DIFile(filename: "../comparedf2.c", directory: "/workspaces/llvmta/testcases/libraries/builtinsfloat/buildarmv4", checksumkind: CSK_MD5, checksum: "fbd12646cae0afa4f38a456b06356d8d")
!8 = distinct !DICompileUnit(language: DW_LANG_C99, file: !9, producer: "clang version 14.0.6 (git@gitlab.tu-dortmund.de:f4-ls12-daes/llvmta/llvmta.git 64262528b05c9d91a76d9ec1ec1045982f385529)", isOptimized: false, runtimeVersion: 0, emissionKind: LineTablesOnly, splitDebugInlining: false, nameTableKind: None)
!9 = !DIFile(filename: "../comparesf2.c", directory: "/workspaces/llvmta/testcases/libraries/builtinsfloat/buildarmv4", checksumkind: CSK_MD5, checksum: "0ebe6266ac9f076b05c337420b1e2170")
!10 = distinct !DICompileUnit(language: DW_LANG_C99, file: !11, producer: "clang version 14.0.6 (git@gitlab.tu-dortmund.de:f4-ls12-daes/llvmta/llvmta.git 64262528b05c9d91a76d9ec1ec1045982f385529)", isOptimized: false, runtimeVersion: 0, emissionKind: LineTablesOnly, splitDebugInlining: false, nameTableKind: None)
!11 = !DIFile(filename: "../comparetf2.c", directory: "/workspaces/llvmta/testcases/libraries/builtinsfloat/buildarmv4", checksumkind: CSK_MD5, checksum: "01fe0d18b2af3485e946e6fff44a14bb")
!12 = distinct !DICompileUnit(language: DW_LANG_C99, file: !13, producer: "clang version 14.0.6 (git@gitlab.tu-dortmund.de:f4-ls12-daes/llvmta/llvmta.git 64262528b05c9d91a76d9ec1ec1045982f385529)", isOptimized: false, runtimeVersion: 0, emissionKind: LineTablesOnly, splitDebugInlining: false, nameTableKind: None)
!13 = !DIFile(filename: "../divdf3.c", directory: "/workspaces/llvmta/testcases/libraries/builtinsfloat/buildarmv4", checksumkind: CSK_MD5, checksum: "261cc11321bc9c6e7119a2df54ff0ff8")
!14 = distinct !DICompileUnit(language: DW_LANG_C99, file: !15, producer: "clang version 14.0.6 (git@gitlab.tu-dortmund.de:f4-ls12-daes/llvmta/llvmta.git 64262528b05c9d91a76d9ec1ec1045982f385529)", isOptimized: false, runtimeVersion: 0, emissionKind: LineTablesOnly, splitDebugInlining: false, nameTableKind: None)
!15 = !DIFile(filename: "../divsf3.c", directory: "/workspaces/llvmta/testcases/libraries/builtinsfloat/buildarmv4", checksumkind: CSK_MD5, checksum: "7d3063a03b9dc025d09812aef44ed398")
!16 = distinct !DICompileUnit(language: DW_LANG_C99, file: !17, producer: "clang version 14.0.6 (git@gitlab.tu-dortmund.de:f4-ls12-daes/llvmta/llvmta.git 64262528b05c9d91a76d9ec1ec1045982f385529)", isOptimized: false, runtimeVersion: 0, emissionKind: LineTablesOnly, splitDebugInlining: false, nameTableKind: None)
!17 = !DIFile(filename: "../divtf3.c", directory: "/workspaces/llvmta/testcases/libraries/builtinsfloat/buildarmv4", checksumkind: CSK_MD5, checksum: "b9fe8a84ce6efc4a805ce88d1dc03156")
!18 = distinct !DICompileUnit(language: DW_LANG_C99, file: !19, producer: "clang version 14.0.6 (git@gitlab.tu-dortmund.de:f4-ls12-daes/llvmta/llvmta.git 64262528b05c9d91a76d9ec1ec1045982f385529)", isOptimized: false, runtimeVersion: 0, emissionKind: LineTablesOnly, splitDebugInlining: false, nameTableKind: None)
!19 = !DIFile(filename: "../extenddftf2.c", directory: "/workspaces/llvmta/testcases/libraries/builtinsfloat/buildarmv4", checksumkind: CSK_MD5, checksum: "6c7831c8b2efd5ca29d59f7733bea2ef")
!20 = distinct !DICompileUnit(language: DW_LANG_C99, file: !21, producer: "clang version 14.0.6 (git@gitlab.tu-dortmund.de:f4-ls12-daes/llvmta/llvmta.git 64262528b05c9d91a76d9ec1ec1045982f385529)", isOptimized: false, runtimeVersion: 0, emissionKind: LineTablesOnly, splitDebugInlining: false, nameTableKind: None)
!21 = !DIFile(filename: "../extendhfsf2.c", directory: "/workspaces/llvmta/testcases/libraries/builtinsfloat/buildarmv4", checksumkind: CSK_MD5, checksum: "a5a10e040b7849d52a32e736bcb3c397")
!22 = distinct !DICompileUnit(language: DW_LANG_C99, file: !23, producer: "clang version 14.0.6 (git@gitlab.tu-dortmund.de:f4-ls12-daes/llvmta/llvmta.git 64262528b05c9d91a76d9ec1ec1045982f385529)", isOptimized: false, runtimeVersion: 0, emissionKind: LineTablesOnly, splitDebugInlining: false, nameTableKind: None)
!23 = !DIFile(filename: "../extendsfdf2.c", directory: "/workspaces/llvmta/testcases/libraries/builtinsfloat/buildarmv4", checksumkind: CSK_MD5, checksum: "4e1f23973b36a8543e6f218ddda73a81")
!24 = distinct !DICompileUnit(language: DW_LANG_C99, file: !25, producer: "clang version 14.0.6 (git@gitlab.tu-dortmund.de:f4-ls12-daes/llvmta/llvmta.git 64262528b05c9d91a76d9ec1ec1045982f385529)", isOptimized: false, runtimeVersion: 0, emissionKind: LineTablesOnly, splitDebugInlining: false, nameTableKind: None)
!25 = !DIFile(filename: "../extendsftf2.c", directory: "/workspaces/llvmta/testcases/libraries/builtinsfloat/buildarmv4", checksumkind: CSK_MD5, checksum: "6e48b2bd18165df6b0d7cd96562bc90e")
!26 = distinct !DICompileUnit(language: DW_LANG_C99, file: !27, producer: "clang version 14.0.6 (git@gitlab.tu-dortmund.de:f4-ls12-daes/llvmta/llvmta.git 64262528b05c9d91a76d9ec1ec1045982f385529)", isOptimized: false, runtimeVersion: 0, emissionKind: LineTablesOnly, splitDebugInlining: false, nameTableKind: None)
!27 = !DIFile(filename: "../fixdfdi.c", directory: "/workspaces/llvmta/testcases/libraries/builtinsfloat/buildarmv4", checksumkind: CSK_MD5, checksum: "47e708860fdf5a8df241e5320d28d108")
!28 = distinct !DICompileUnit(language: DW_LANG_C99, file: !29, producer: "clang version 14.0.6 (git@gitlab.tu-dortmund.de:f4-ls12-daes/llvmta/llvmta.git 64262528b05c9d91a76d9ec1ec1045982f385529)", isOptimized: false, runtimeVersion: 0, emissionKind: LineTablesOnly, splitDebugInlining: false, nameTableKind: None)
!29 = !DIFile(filename: "../fixdfsi.c", directory: "/workspaces/llvmta/testcases/libraries/builtinsfloat/buildarmv4", checksumkind: CSK_MD5, checksum: "ab025b47eaba5eab57a20c4f7d364472")
!30 = distinct !DICompileUnit(language: DW_LANG_C99, file: !31, producer: "clang version 14.0.6 (git@gitlab.tu-dortmund.de:f4-ls12-daes/llvmta/llvmta.git 64262528b05c9d91a76d9ec1ec1045982f385529)", isOptimized: false, runtimeVersion: 0, emissionKind: LineTablesOnly, splitDebugInlining: false, nameTableKind: None)
!31 = !DIFile(filename: "../fixdfti.c", directory: "/workspaces/llvmta/testcases/libraries/builtinsfloat/buildarmv4", checksumkind: CSK_MD5, checksum: "e8cfbed86a48d8d385e0ba3358daa4fe")
!32 = distinct !DICompileUnit(language: DW_LANG_C99, file: !33, producer: "clang version 14.0.6 (git@gitlab.tu-dortmund.de:f4-ls12-daes/llvmta/llvmta.git 64262528b05c9d91a76d9ec1ec1045982f385529)", isOptimized: false, runtimeVersion: 0, emissionKind: LineTablesOnly, splitDebugInlining: false, nameTableKind: None)
!33 = !DIFile(filename: "../fixsfdi.c", directory: "/workspaces/llvmta/testcases/libraries/builtinsfloat/buildarmv4", checksumkind: CSK_MD5, checksum: "cc8fccc6df63f71c2ce1c1c99dec5510")
!34 = distinct !DICompileUnit(language: DW_LANG_C99, file: !35, producer: "clang version 14.0.6 (git@gitlab.tu-dortmund.de:f4-ls12-daes/llvmta/llvmta.git 64262528b05c9d91a76d9ec1ec1045982f385529)", isOptimized: false, runtimeVersion: 0, emissionKind: LineTablesOnly, splitDebugInlining: false, nameTableKind: None)
!35 = !DIFile(filename: "../fixsfsi.c", directory: "/workspaces/llvmta/testcases/libraries/builtinsfloat/buildarmv4", checksumkind: CSK_MD5, checksum: "42c849690580d6639a7796e4fd09df10")
!36 = distinct !DICompileUnit(language: DW_LANG_C99, file: !37, producer: "clang version 14.0.6 (git@gitlab.tu-dortmund.de:f4-ls12-daes/llvmta/llvmta.git 64262528b05c9d91a76d9ec1ec1045982f385529)", isOptimized: false, runtimeVersion: 0, emissionKind: LineTablesOnly, splitDebugInlining: false, nameTableKind: None)
!37 = !DIFile(filename: "../fixsfti.c", directory: "/workspaces/llvmta/testcases/libraries/builtinsfloat/buildarmv4", checksumkind: CSK_MD5, checksum: "f9344e0ca2da9525f9b706daff202bea")
!38 = distinct !DICompileUnit(language: DW_LANG_C99, file: !39, producer: "clang version 14.0.6 (git@gitlab.tu-dortmund.de:f4-ls12-daes/llvmta/llvmta.git 64262528b05c9d91a76d9ec1ec1045982f385529)", isOptimized: false, runtimeVersion: 0, emissionKind: LineTablesOnly, splitDebugInlining: false, nameTableKind: None)
!39 = !DIFile(filename: "../fixtfdi.c", directory: "/workspaces/llvmta/testcases/libraries/builtinsfloat/buildarmv4", checksumkind: CSK_MD5, checksum: "a998f69f33b8dfd839a0e1ef86f6124e")
!40 = distinct !DICompileUnit(language: DW_LANG_C99, file: !41, producer: "clang version 14.0.6 (git@gitlab.tu-dortmund.de:f4-ls12-daes/llvmta/llvmta.git 64262528b05c9d91a76d9ec1ec1045982f385529)", isOptimized: false, runtimeVersion: 0, emissionKind: LineTablesOnly, splitDebugInlining: false, nameTableKind: None)
!41 = !DIFile(filename: "../fixtfsi.c", directory: "/workspaces/llvmta/testcases/libraries/builtinsfloat/buildarmv4", checksumkind: CSK_MD5, checksum: "639a80b713b65281ee5006844fbf7290")
!42 = distinct !DICompileUnit(language: DW_LANG_C99, file: !43, producer: "clang version 14.0.6 (git@gitlab.tu-dortmund.de:f4-ls12-daes/llvmta/llvmta.git 64262528b05c9d91a76d9ec1ec1045982f385529)", isOptimized: false, runtimeVersion: 0, emissionKind: LineTablesOnly, splitDebugInlining: false, nameTableKind: None)
!43 = !DIFile(filename: "../fixtfti.c", directory: "/workspaces/llvmta/testcases/libraries/builtinsfloat/buildarmv4", checksumkind: CSK_MD5, checksum: "758113d292e1857a1954e9d50a314036")
!44 = distinct !DICompileUnit(language: DW_LANG_C99, file: !45, producer: "clang version 14.0.6 (git@gitlab.tu-dortmund.de:f4-ls12-daes/llvmta/llvmta.git 64262528b05c9d91a76d9ec1ec1045982f385529)", isOptimized: false, runtimeVersion: 0, emissionKind: LineTablesOnly, splitDebugInlining: false, nameTableKind: None)
!45 = !DIFile(filename: "../fixunsdfdi.c", directory: "/workspaces/llvmta/testcases/libraries/builtinsfloat/buildarmv4", checksumkind: CSK_MD5, checksum: "bb698dc308993ca2bb4ab90619c828c7")
!46 = distinct !DICompileUnit(language: DW_LANG_C99, file: !47, producer: "clang version 14.0.6 (git@gitlab.tu-dortmund.de:f4-ls12-daes/llvmta/llvmta.git 64262528b05c9d91a76d9ec1ec1045982f385529)", isOptimized: false, runtimeVersion: 0, emissionKind: LineTablesOnly, splitDebugInlining: false, nameTableKind: None)
!47 = !DIFile(filename: "../fixunsdfsi.c", directory: "/workspaces/llvmta/testcases/libraries/builtinsfloat/buildarmv4", checksumkind: CSK_MD5, checksum: "029e294e42ede4179ebf70d7b8cdcbce")
!48 = distinct !DICompileUnit(language: DW_LANG_C99, file: !49, producer: "clang version 14.0.6 (git@gitlab.tu-dortmund.de:f4-ls12-daes/llvmta/llvmta.git 64262528b05c9d91a76d9ec1ec1045982f385529)", isOptimized: false, runtimeVersion: 0, emissionKind: LineTablesOnly, splitDebugInlining: false, nameTableKind: None)
!49 = !DIFile(filename: "../fixunsdfti.c", directory: "/workspaces/llvmta/testcases/libraries/builtinsfloat/buildarmv4", checksumkind: CSK_MD5, checksum: "caef2e593a4fabc6c1231bd68a82d55c")
!50 = distinct !DICompileUnit(language: DW_LANG_C99, file: !51, producer: "clang version 14.0.6 (git@gitlab.tu-dortmund.de:f4-ls12-daes/llvmta/llvmta.git 64262528b05c9d91a76d9ec1ec1045982f385529)", isOptimized: false, runtimeVersion: 0, emissionKind: LineTablesOnly, splitDebugInlining: false, nameTableKind: None)
!51 = !DIFile(filename: "../fixunssfdi.c", directory: "/workspaces/llvmta/testcases/libraries/builtinsfloat/buildarmv4", checksumkind: CSK_MD5, checksum: "6b0da526a1e4fbc8a0b0f9991405e5aa")
!52 = distinct !DICompileUnit(language: DW_LANG_C99, file: !53, producer: "clang version 14.0.6 (git@gitlab.tu-dortmund.de:f4-ls12-daes/llvmta/llvmta.git 64262528b05c9d91a76d9ec1ec1045982f385529)", isOptimized: false, runtimeVersion: 0, emissionKind: LineTablesOnly, splitDebugInlining: false, nameTableKind: None)
!53 = !DIFile(filename: "../fixunssfsi.c", directory: "/workspaces/llvmta/testcases/libraries/builtinsfloat/buildarmv4", checksumkind: CSK_MD5, checksum: "48b21aad953f9cc2c9112be544031b21")
!54 = distinct !DICompileUnit(language: DW_LANG_C99, file: !55, producer: "clang version 14.0.6 (git@gitlab.tu-dortmund.de:f4-ls12-daes/llvmta/llvmta.git 64262528b05c9d91a76d9ec1ec1045982f385529)", isOptimized: false, runtimeVersion: 0, emissionKind: LineTablesOnly, splitDebugInlining: false, nameTableKind: None)
!55 = !DIFile(filename: "../fixunssfti.c", directory: "/workspaces/llvmta/testcases/libraries/builtinsfloat/buildarmv4", checksumkind: CSK_MD5, checksum: "2059b01af49f2fb00e9ef512708a78bb")
!56 = distinct !DICompileUnit(language: DW_LANG_C99, file: !57, producer: "clang version 14.0.6 (git@gitlab.tu-dortmund.de:f4-ls12-daes/llvmta/llvmta.git 64262528b05c9d91a76d9ec1ec1045982f385529)", isOptimized: false, runtimeVersion: 0, emissionKind: LineTablesOnly, splitDebugInlining: false, nameTableKind: None)
!57 = !DIFile(filename: "../fixunstfdi.c", directory: "/workspaces/llvmta/testcases/libraries/builtinsfloat/buildarmv4", checksumkind: CSK_MD5, checksum: "b2618a18d8418c39552b2988bc006f85")
!58 = distinct !DICompileUnit(language: DW_LANG_C99, file: !59, producer: "clang version 14.0.6 (git@gitlab.tu-dortmund.de:f4-ls12-daes/llvmta/llvmta.git 64262528b05c9d91a76d9ec1ec1045982f385529)", isOptimized: false, runtimeVersion: 0, emissionKind: LineTablesOnly, splitDebugInlining: false, nameTableKind: None)
!59 = !DIFile(filename: "../fixunstfsi.c", directory: "/workspaces/llvmta/testcases/libraries/builtinsfloat/buildarmv4", checksumkind: CSK_MD5, checksum: "4b5e33b191b26b08989150fa9a214059")
!60 = distinct !DICompileUnit(language: DW_LANG_C99, file: !61, producer: "clang version 14.0.6 (git@gitlab.tu-dortmund.de:f4-ls12-daes/llvmta/llvmta.git 64262528b05c9d91a76d9ec1ec1045982f385529)", isOptimized: false, runtimeVersion: 0, emissionKind: LineTablesOnly, splitDebugInlining: false, nameTableKind: None)
!61 = !DIFile(filename: "../fixunstfti.c", directory: "/workspaces/llvmta/testcases/libraries/builtinsfloat/buildarmv4", checksumkind: CSK_MD5, checksum: "5c5ea7bfc6ae7808ec8a881ee53ba3f3")
!62 = distinct !DICompileUnit(language: DW_LANG_C99, file: !63, producer: "clang version 14.0.6 (git@gitlab.tu-dortmund.de:f4-ls12-daes/llvmta/llvmta.git 64262528b05c9d91a76d9ec1ec1045982f385529)", isOptimized: false, runtimeVersion: 0, emissionKind: LineTablesOnly, splitDebugInlining: false, nameTableKind: None)
!63 = !DIFile(filename: "../fixunsxfdi.c", directory: "/workspaces/llvmta/testcases/libraries/builtinsfloat/buildarmv4", checksumkind: CSK_MD5, checksum: "c5b8c82f82ec230f86bab25cdd51241f")
!64 = distinct !DICompileUnit(language: DW_LANG_C99, file: !65, producer: "clang version 14.0.6 (git@gitlab.tu-dortmund.de:f4-ls12-daes/llvmta/llvmta.git 64262528b05c9d91a76d9ec1ec1045982f385529)", isOptimized: false, runtimeVersion: 0, emissionKind: LineTablesOnly, splitDebugInlining: false, nameTableKind: None)
!65 = !DIFile(filename: "../fixunsxfsi.c", directory: "/workspaces/llvmta/testcases/libraries/builtinsfloat/buildarmv4", checksumkind: CSK_MD5, checksum: "3a4bc679da33f33545955f1d5f9295a3")
!66 = distinct !DICompileUnit(language: DW_LANG_C99, file: !67, producer: "clang version 14.0.6 (git@gitlab.tu-dortmund.de:f4-ls12-daes/llvmta/llvmta.git 64262528b05c9d91a76d9ec1ec1045982f385529)", isOptimized: false, runtimeVersion: 0, emissionKind: LineTablesOnly, splitDebugInlining: false, nameTableKind: None)
!67 = !DIFile(filename: "../fixunsxfti.c", directory: "/workspaces/llvmta/testcases/libraries/builtinsfloat/buildarmv4", checksumkind: CSK_MD5, checksum: "c81feece3aea6f34d7045357bee719f0")
!68 = distinct !DICompileUnit(language: DW_LANG_C99, file: !69, producer: "clang version 14.0.6 (git@gitlab.tu-dortmund.de:f4-ls12-daes/llvmta/llvmta.git 64262528b05c9d91a76d9ec1ec1045982f385529)", isOptimized: false, runtimeVersion: 0, emissionKind: LineTablesOnly, splitDebugInlining: false, nameTableKind: None)
!69 = !DIFile(filename: "../fixxfdi.c", directory: "/workspaces/llvmta/testcases/libraries/builtinsfloat/buildarmv4", checksumkind: CSK_MD5, checksum: "1d3e33c056b8d764ec90c9c4bccde967")
!70 = distinct !DICompileUnit(language: DW_LANG_C99, file: !71, producer: "clang version 14.0.6 (git@gitlab.tu-dortmund.de:f4-ls12-daes/llvmta/llvmta.git 64262528b05c9d91a76d9ec1ec1045982f385529)", isOptimized: false, runtimeVersion: 0, emissionKind: LineTablesOnly, splitDebugInlining: false, nameTableKind: None)
!71 = !DIFile(filename: "../fixxfti.c", directory: "/workspaces/llvmta/testcases/libraries/builtinsfloat/buildarmv4", checksumkind: CSK_MD5, checksum: "538dbc97aba965b3c18c60b96c1718fd")
!72 = distinct !DICompileUnit(language: DW_LANG_C99, file: !73, producer: "clang version 14.0.6 (git@gitlab.tu-dortmund.de:f4-ls12-daes/llvmta/llvmta.git 64262528b05c9d91a76d9ec1ec1045982f385529)", isOptimized: false, runtimeVersion: 0, emissionKind: LineTablesOnly, splitDebugInlining: false, nameTableKind: None)
!73 = !DIFile(filename: "../floatdidf.c", directory: "/workspaces/llvmta/testcases/libraries/builtinsfloat/buildarmv4", checksumkind: CSK_MD5, checksum: "589757f5bf5948f8d680d68ea09b8b28")
!74 = distinct !DICompileUnit(language: DW_LANG_C99, file: !75, producer: "clang version 14.0.6 (git@gitlab.tu-dortmund.de:f4-ls12-daes/llvmta/llvmta.git 64262528b05c9d91a76d9ec1ec1045982f385529)", isOptimized: false, runtimeVersion: 0, emissionKind: LineTablesOnly, splitDebugInlining: false, nameTableKind: None)
!75 = !DIFile(filename: "../floatdisf.c", directory: "/workspaces/llvmta/testcases/libraries/builtinsfloat/buildarmv4", checksumkind: CSK_MD5, checksum: "d490cd79b8654d77c2b677080ad7dccc")
!76 = distinct !DICompileUnit(language: DW_LANG_C99, file: !77, producer: "clang version 14.0.6 (git@gitlab.tu-dortmund.de:f4-ls12-daes/llvmta/llvmta.git 64262528b05c9d91a76d9ec1ec1045982f385529)", isOptimized: false, runtimeVersion: 0, emissionKind: LineTablesOnly, splitDebugInlining: false, nameTableKind: None)
!77 = !DIFile(filename: "../floatditf.c", directory: "/workspaces/llvmta/testcases/libraries/builtinsfloat/buildarmv4", checksumkind: CSK_MD5, checksum: "20f09e3e356d85c457c64d3aebefdeda")
!78 = distinct !DICompileUnit(language: DW_LANG_C99, file: !79, producer: "clang version 14.0.6 (git@gitlab.tu-dortmund.de:f4-ls12-daes/llvmta/llvmta.git 64262528b05c9d91a76d9ec1ec1045982f385529)", isOptimized: false, runtimeVersion: 0, emissionKind: LineTablesOnly, splitDebugInlining: false, nameTableKind: None)
!79 = !DIFile(filename: "../floatdixf.c", directory: "/workspaces/llvmta/testcases/libraries/builtinsfloat/buildarmv4", checksumkind: CSK_MD5, checksum: "8b1a0058f785628324b5f9e560c1f2f7")
!80 = distinct !DICompileUnit(language: DW_LANG_C99, file: !81, producer: "clang version 14.0.6 (git@gitlab.tu-dortmund.de:f4-ls12-daes/llvmta/llvmta.git 64262528b05c9d91a76d9ec1ec1045982f385529)", isOptimized: false, runtimeVersion: 0, emissionKind: LineTablesOnly, splitDebugInlining: false, nameTableKind: None)
!81 = !DIFile(filename: "../floatsidf.c", directory: "/workspaces/llvmta/testcases/libraries/builtinsfloat/buildarmv4", checksumkind: CSK_MD5, checksum: "74d68f8d7666958b02fc991a96f5d18b")
!82 = distinct !DICompileUnit(language: DW_LANG_C99, file: !83, producer: "clang version 14.0.6 (git@gitlab.tu-dortmund.de:f4-ls12-daes/llvmta/llvmta.git 64262528b05c9d91a76d9ec1ec1045982f385529)", isOptimized: false, runtimeVersion: 0, emissionKind: LineTablesOnly, splitDebugInlining: false, nameTableKind: None)
!83 = !DIFile(filename: "../floatsisf.c", directory: "/workspaces/llvmta/testcases/libraries/builtinsfloat/buildarmv4", checksumkind: CSK_MD5, checksum: "e8269d7393de437d1985e43b852d1b4c")
!84 = distinct !DICompileUnit(language: DW_LANG_C99, file: !85, producer: "clang version 14.0.6 (git@gitlab.tu-dortmund.de:f4-ls12-daes/llvmta/llvmta.git 64262528b05c9d91a76d9ec1ec1045982f385529)", isOptimized: false, runtimeVersion: 0, emissionKind: LineTablesOnly, splitDebugInlining: false, nameTableKind: None)
!85 = !DIFile(filename: "../floatsitf.c", directory: "/workspaces/llvmta/testcases/libraries/builtinsfloat/buildarmv4", checksumkind: CSK_MD5, checksum: "e9c164d2174bbcc29395c3aa63d0cfb9")
!86 = distinct !DICompileUnit(language: DW_LANG_C99, file: !87, producer: "clang version 14.0.6 (git@gitlab.tu-dortmund.de:f4-ls12-daes/llvmta/llvmta.git 64262528b05c9d91a76d9ec1ec1045982f385529)", isOptimized: false, runtimeVersion: 0, emissionKind: LineTablesOnly, splitDebugInlining: false, nameTableKind: None)
!87 = !DIFile(filename: "../floattidf.c", directory: "/workspaces/llvmta/testcases/libraries/builtinsfloat/buildarmv4", checksumkind: CSK_MD5, checksum: "02001cec56eeadee7fe6f3cc8807cedb")
!88 = distinct !DICompileUnit(language: DW_LANG_C99, file: !89, producer: "clang version 14.0.6 (git@gitlab.tu-dortmund.de:f4-ls12-daes/llvmta/llvmta.git 64262528b05c9d91a76d9ec1ec1045982f385529)", isOptimized: false, runtimeVersion: 0, emissionKind: LineTablesOnly, splitDebugInlining: false, nameTableKind: None)
!89 = !DIFile(filename: "../floattisf.c", directory: "/workspaces/llvmta/testcases/libraries/builtinsfloat/buildarmv4", checksumkind: CSK_MD5, checksum: "f78b4a675b5ede3cf4565e9926770440")
!90 = distinct !DICompileUnit(language: DW_LANG_C99, file: !91, producer: "clang version 14.0.6 (git@gitlab.tu-dortmund.de:f4-ls12-daes/llvmta/llvmta.git 64262528b05c9d91a76d9ec1ec1045982f385529)", isOptimized: false, runtimeVersion: 0, emissionKind: LineTablesOnly, splitDebugInlining: false, nameTableKind: None)
!91 = !DIFile(filename: "../floattitf.c", directory: "/workspaces/llvmta/testcases/libraries/builtinsfloat/buildarmv4", checksumkind: CSK_MD5, checksum: "69ef5e45f9490345c66c587133808825")
!92 = distinct !DICompileUnit(language: DW_LANG_C99, file: !93, producer: "clang version 14.0.6 (git@gitlab.tu-dortmund.de:f4-ls12-daes/llvmta/llvmta.git 64262528b05c9d91a76d9ec1ec1045982f385529)", isOptimized: false, runtimeVersion: 0, emissionKind: LineTablesOnly, splitDebugInlining: false, nameTableKind: None)
!93 = !DIFile(filename: "../floattixf.c", directory: "/workspaces/llvmta/testcases/libraries/builtinsfloat/buildarmv4", checksumkind: CSK_MD5, checksum: "363950fc75fc38684746712d53c0b081")
!94 = distinct !DICompileUnit(language: DW_LANG_C99, file: !95, producer: "clang version 14.0.6 (git@gitlab.tu-dortmund.de:f4-ls12-daes/llvmta/llvmta.git 64262528b05c9d91a76d9ec1ec1045982f385529)", isOptimized: false, runtimeVersion: 0, emissionKind: LineTablesOnly, splitDebugInlining: false, nameTableKind: None)
!95 = !DIFile(filename: "../floatundidf.c", directory: "/workspaces/llvmta/testcases/libraries/builtinsfloat/buildarmv4", checksumkind: CSK_MD5, checksum: "332ecea9fc06121bb9792813051cd121")
!96 = distinct !DICompileUnit(language: DW_LANG_C99, file: !97, producer: "clang version 14.0.6 (git@gitlab.tu-dortmund.de:f4-ls12-daes/llvmta/llvmta.git 64262528b05c9d91a76d9ec1ec1045982f385529)", isOptimized: false, runtimeVersion: 0, emissionKind: LineTablesOnly, splitDebugInlining: false, nameTableKind: None)
!97 = !DIFile(filename: "../floatundisf.c", directory: "/workspaces/llvmta/testcases/libraries/builtinsfloat/buildarmv4", checksumkind: CSK_MD5, checksum: "7ab0c7414b7105a5334add4b33b95292")
!98 = distinct !DICompileUnit(language: DW_LANG_C99, file: !99, producer: "clang version 14.0.6 (git@gitlab.tu-dortmund.de:f4-ls12-daes/llvmta/llvmta.git 64262528b05c9d91a76d9ec1ec1045982f385529)", isOptimized: false, runtimeVersion: 0, emissionKind: LineTablesOnly, splitDebugInlining: false, nameTableKind: None)
!99 = !DIFile(filename: "../floatunditf.c", directory: "/workspaces/llvmta/testcases/libraries/builtinsfloat/buildarmv4", checksumkind: CSK_MD5, checksum: "3bec54b1a510cfda27db4cb1020b10dc")
!100 = distinct !DICompileUnit(language: DW_LANG_C99, file: !101, producer: "clang version 14.0.6 (git@gitlab.tu-dortmund.de:f4-ls12-daes/llvmta/llvmta.git 64262528b05c9d91a76d9ec1ec1045982f385529)", isOptimized: false, runtimeVersion: 0, emissionKind: LineTablesOnly, splitDebugInlining: false, nameTableKind: None)
!101 = !DIFile(filename: "../floatundixf.c", directory: "/workspaces/llvmta/testcases/libraries/builtinsfloat/buildarmv4", checksumkind: CSK_MD5, checksum: "55601cdc8ffb7b6458d917ea4861681f")
!102 = distinct !DICompileUnit(language: DW_LANG_C99, file: !103, producer: "clang version 14.0.6 (git@gitlab.tu-dortmund.de:f4-ls12-daes/llvmta/llvmta.git 64262528b05c9d91a76d9ec1ec1045982f385529)", isOptimized: false, runtimeVersion: 0, emissionKind: LineTablesOnly, splitDebugInlining: false, nameTableKind: None)
!103 = !DIFile(filename: "../floatunsidf.c", directory: "/workspaces/llvmta/testcases/libraries/builtinsfloat/buildarmv4", checksumkind: CSK_MD5, checksum: "7abcd27bee360e384bfcbe8b4e29e4b5")
!104 = distinct !DICompileUnit(language: DW_LANG_C99, file: !105, producer: "clang version 14.0.6 (git@gitlab.tu-dortmund.de:f4-ls12-daes/llvmta/llvmta.git 64262528b05c9d91a76d9ec1ec1045982f385529)", isOptimized: false, runtimeVersion: 0, emissionKind: LineTablesOnly, splitDebugInlining: false, nameTableKind: None)
!105 = !DIFile(filename: "../floatunsisf.c", directory: "/workspaces/llvmta/testcases/libraries/builtinsfloat/buildarmv4", checksumkind: CSK_MD5, checksum: "25377c9e1088361533bcc87d26a579aa")
!106 = distinct !DICompileUnit(language: DW_LANG_C99, file: !107, producer: "clang version 14.0.6 (git@gitlab.tu-dortmund.de:f4-ls12-daes/llvmta/llvmta.git 64262528b05c9d91a76d9ec1ec1045982f385529)", isOptimized: false, runtimeVersion: 0, emissionKind: LineTablesOnly, splitDebugInlining: false, nameTableKind: None)
!107 = !DIFile(filename: "../floatunsitf.c", directory: "/workspaces/llvmta/testcases/libraries/builtinsfloat/buildarmv4", checksumkind: CSK_MD5, checksum: "f61e31b6b83ad7980e4c2cd151d127d7")
!108 = distinct !DICompileUnit(language: DW_LANG_C99, file: !109, producer: "clang version 14.0.6 (git@gitlab.tu-dortmund.de:f4-ls12-daes/llvmta/llvmta.git 64262528b05c9d91a76d9ec1ec1045982f385529)", isOptimized: false, runtimeVersion: 0, emissionKind: LineTablesOnly, splitDebugInlining: false, nameTableKind: None)
!109 = !DIFile(filename: "../floatuntidf.c", directory: "/workspaces/llvmta/testcases/libraries/builtinsfloat/buildarmv4", checksumkind: CSK_MD5, checksum: "daaa5863596bd264231583dd4e935351")
!110 = distinct !DICompileUnit(language: DW_LANG_C99, file: !111, producer: "clang version 14.0.6 (git@gitlab.tu-dortmund.de:f4-ls12-daes/llvmta/llvmta.git 64262528b05c9d91a76d9ec1ec1045982f385529)", isOptimized: false, runtimeVersion: 0, emissionKind: LineTablesOnly, splitDebugInlining: false, nameTableKind: None)
!111 = !DIFile(filename: "../floatuntisf.c", directory: "/workspaces/llvmta/testcases/libraries/builtinsfloat/buildarmv4", checksumkind: CSK_MD5, checksum: "3c8eb24382036e5bf69269c87c968665")
!112 = distinct !DICompileUnit(language: DW_LANG_C99, file: !113, producer: "clang version 14.0.6 (git@gitlab.tu-dortmund.de:f4-ls12-daes/llvmta/llvmta.git 64262528b05c9d91a76d9ec1ec1045982f385529)", isOptimized: false, runtimeVersion: 0, emissionKind: LineTablesOnly, splitDebugInlining: false, nameTableKind: None)
!113 = !DIFile(filename: "../floatuntitf.c", directory: "/workspaces/llvmta/testcases/libraries/builtinsfloat/buildarmv4", checksumkind: CSK_MD5, checksum: "a2a81feab5093db32a94221c09059952")
!114 = distinct !DICompileUnit(language: DW_LANG_C99, file: !115, producer: "clang version 14.0.6 (git@gitlab.tu-dortmund.de:f4-ls12-daes/llvmta/llvmta.git 64262528b05c9d91a76d9ec1ec1045982f385529)", isOptimized: false, runtimeVersion: 0, emissionKind: LineTablesOnly, splitDebugInlining: false, nameTableKind: None)
!115 = !DIFile(filename: "../floatuntixf.c", directory: "/workspaces/llvmta/testcases/libraries/builtinsfloat/buildarmv4", checksumkind: CSK_MD5, checksum: "af14ea06c35eff6221145fef129eb14b")
!116 = distinct !DICompileUnit(language: DW_LANG_C99, file: !117, producer: "clang version 14.0.6 (git@gitlab.tu-dortmund.de:f4-ls12-daes/llvmta/llvmta.git 64262528b05c9d91a76d9ec1ec1045982f385529)", isOptimized: false, runtimeVersion: 0, emissionKind: LineTablesOnly, splitDebugInlining: false, nameTableKind: None)
!117 = !DIFile(filename: "../int_util.c", directory: "/workspaces/llvmta/testcases/libraries/builtinsfloat/buildarmv4", checksumkind: CSK_MD5, checksum: "51792efca379487643647da23a7fcecc")
!118 = distinct !DICompileUnit(language: DW_LANG_C99, file: !119, producer: "clang version 14.0.6 (git@gitlab.tu-dortmund.de:f4-ls12-daes/llvmta/llvmta.git 64262528b05c9d91a76d9ec1ec1045982f385529)", isOptimized: false, runtimeVersion: 0, emissionKind: LineTablesOnly, splitDebugInlining: false, nameTableKind: None)
!119 = !DIFile(filename: "../muldf3.c", directory: "/workspaces/llvmta/testcases/libraries/builtinsfloat/buildarmv4", checksumkind: CSK_MD5, checksum: "e1094ad6f1ac68776663659720a263c1")
!120 = distinct !DICompileUnit(language: DW_LANG_C99, file: !121, producer: "clang version 14.0.6 (git@gitlab.tu-dortmund.de:f4-ls12-daes/llvmta/llvmta.git 64262528b05c9d91a76d9ec1ec1045982f385529)", isOptimized: false, runtimeVersion: 0, emissionKind: LineTablesOnly, splitDebugInlining: false, nameTableKind: None)
!121 = !DIFile(filename: "../muldi3.c", directory: "/workspaces/llvmta/testcases/libraries/builtinsfloat/buildarmv4", checksumkind: CSK_MD5, checksum: "df26ca90afd732d72d44a32b26ef9ff6")
!122 = distinct !DICompileUnit(language: DW_LANG_C99, file: !123, producer: "clang version 14.0.6 (git@gitlab.tu-dortmund.de:f4-ls12-daes/llvmta/llvmta.git 64262528b05c9d91a76d9ec1ec1045982f385529)", isOptimized: false, runtimeVersion: 0, emissionKind: LineTablesOnly, splitDebugInlining: false, nameTableKind: None)
!123 = !DIFile(filename: "../mulodi4.c", directory: "/workspaces/llvmta/testcases/libraries/builtinsfloat/buildarmv4", checksumkind: CSK_MD5, checksum: "548e26a16754ea0a5e8b99fd257e0228")
!124 = distinct !DICompileUnit(language: DW_LANG_C99, file: !125, producer: "clang version 14.0.6 (git@gitlab.tu-dortmund.de:f4-ls12-daes/llvmta/llvmta.git 64262528b05c9d91a76d9ec1ec1045982f385529)", isOptimized: false, runtimeVersion: 0, emissionKind: LineTablesOnly, splitDebugInlining: false, nameTableKind: None)
!125 = !DIFile(filename: "../mulosi4.c", directory: "/workspaces/llvmta/testcases/libraries/builtinsfloat/buildarmv4", checksumkind: CSK_MD5, checksum: "5df5fe6423348eb23592c3af73d99ba1")
!126 = distinct !DICompileUnit(language: DW_LANG_C99, file: !127, producer: "clang version 14.0.6 (git@gitlab.tu-dortmund.de:f4-ls12-daes/llvmta/llvmta.git 64262528b05c9d91a76d9ec1ec1045982f385529)", isOptimized: false, runtimeVersion: 0, emissionKind: LineTablesOnly, splitDebugInlining: false, nameTableKind: None)
!127 = !DIFile(filename: "../muloti4.c", directory: "/workspaces/llvmta/testcases/libraries/builtinsfloat/buildarmv4", checksumkind: CSK_MD5, checksum: "705b62b6400093f8c368f9a43e940021")
!128 = distinct !DICompileUnit(language: DW_LANG_C99, file: !129, producer: "clang version 14.0.6 (git@gitlab.tu-dortmund.de:f4-ls12-daes/llvmta/llvmta.git 64262528b05c9d91a76d9ec1ec1045982f385529)", isOptimized: false, runtimeVersion: 0, emissionKind: LineTablesOnly, splitDebugInlining: false, nameTableKind: None)
!129 = !DIFile(filename: "../mulsf3.c", directory: "/workspaces/llvmta/testcases/libraries/builtinsfloat/buildarmv4", checksumkind: CSK_MD5, checksum: "2f401fa14324cdf3806a6e0a75176873")
!130 = distinct !DICompileUnit(language: DW_LANG_C99, file: !131, producer: "clang version 14.0.6 (git@gitlab.tu-dortmund.de:f4-ls12-daes/llvmta/llvmta.git 64262528b05c9d91a76d9ec1ec1045982f385529)", isOptimized: false, runtimeVersion: 0, emissionKind: LineTablesOnly, splitDebugInlining: false, nameTableKind: None)
!131 = !DIFile(filename: "../multf3.c", directory: "/workspaces/llvmta/testcases/libraries/builtinsfloat/buildarmv4", checksumkind: CSK_MD5, checksum: "5f563d9d79e87f3dfcf6e2a97aa9961d")
!132 = distinct !DICompileUnit(language: DW_LANG_C99, file: !133, producer: "clang version 14.0.6 (git@gitlab.tu-dortmund.de:f4-ls12-daes/llvmta/llvmta.git 64262528b05c9d91a76d9ec1ec1045982f385529)", isOptimized: false, runtimeVersion: 0, emissionKind: LineTablesOnly, splitDebugInlining: false, nameTableKind: None)
!133 = !DIFile(filename: "../multi3.c", directory: "/workspaces/llvmta/testcases/libraries/builtinsfloat/buildarmv4", checksumkind: CSK_MD5, checksum: "e3a762d0cee613ddcbe257a7e3f59bd6")
!134 = distinct !DICompileUnit(language: DW_LANG_C99, file: !135, producer: "clang version 14.0.6 (git@gitlab.tu-dortmund.de:f4-ls12-daes/llvmta/llvmta.git 64262528b05c9d91a76d9ec1ec1045982f385529)", isOptimized: false, runtimeVersion: 0, emissionKind: LineTablesOnly, splitDebugInlining: false, nameTableKind: None)
!135 = !DIFile(filename: "../negdf2.c", directory: "/workspaces/llvmta/testcases/libraries/builtinsfloat/buildarmv4", checksumkind: CSK_MD5, checksum: "856367fb8d9ed2d14100b66d78c0cb6a")
!136 = distinct !DICompileUnit(language: DW_LANG_C99, file: !137, producer: "clang version 14.0.6 (git@gitlab.tu-dortmund.de:f4-ls12-daes/llvmta/llvmta.git 64262528b05c9d91a76d9ec1ec1045982f385529)", isOptimized: false, runtimeVersion: 0, emissionKind: LineTablesOnly, splitDebugInlining: false, nameTableKind: None)
!137 = !DIFile(filename: "../negdi2.c", directory: "/workspaces/llvmta/testcases/libraries/builtinsfloat/buildarmv4", checksumkind: CSK_MD5, checksum: "338e7f5aee6d443286451453d2d8b2ee")
!138 = distinct !DICompileUnit(language: DW_LANG_C99, file: !139, producer: "clang version 14.0.6 (git@gitlab.tu-dortmund.de:f4-ls12-daes/llvmta/llvmta.git 64262528b05c9d91a76d9ec1ec1045982f385529)", isOptimized: false, runtimeVersion: 0, emissionKind: LineTablesOnly, splitDebugInlining: false, nameTableKind: None)
!139 = !DIFile(filename: "../negsf2.c", directory: "/workspaces/llvmta/testcases/libraries/builtinsfloat/buildarmv4", checksumkind: CSK_MD5, checksum: "9ce93f6a4d6a5fd6bd4a2c8b1cec4f7d")
!140 = distinct !DICompileUnit(language: DW_LANG_C99, file: !141, producer: "clang version 14.0.6 (git@gitlab.tu-dortmund.de:f4-ls12-daes/llvmta/llvmta.git 64262528b05c9d91a76d9ec1ec1045982f385529)", isOptimized: false, runtimeVersion: 0, emissionKind: LineTablesOnly, splitDebugInlining: false, nameTableKind: None)
!141 = !DIFile(filename: "../negti2.c", directory: "/workspaces/llvmta/testcases/libraries/builtinsfloat/buildarmv4", checksumkind: CSK_MD5, checksum: "28b6572c640233aee02ab6cc80df25ad")
!142 = distinct !DICompileUnit(language: DW_LANG_C99, file: !143, producer: "clang version 14.0.6 (git@gitlab.tu-dortmund.de:f4-ls12-daes/llvmta/llvmta.git 64262528b05c9d91a76d9ec1ec1045982f385529)", isOptimized: false, runtimeVersion: 0, emissionKind: LineTablesOnly, splitDebugInlining: false, nameTableKind: None)
!143 = !DIFile(filename: "../negvdi2.c", directory: "/workspaces/llvmta/testcases/libraries/builtinsfloat/buildarmv4", checksumkind: CSK_MD5, checksum: "814179687c8ab9c02d6c16d74f3c8cc7")
!144 = distinct !DICompileUnit(language: DW_LANG_C99, file: !145, producer: "clang version 14.0.6 (git@gitlab.tu-dortmund.de:f4-ls12-daes/llvmta/llvmta.git 64262528b05c9d91a76d9ec1ec1045982f385529)", isOptimized: false, runtimeVersion: 0, emissionKind: LineTablesOnly, splitDebugInlining: false, nameTableKind: None)
!145 = !DIFile(filename: "../negvsi2.c", directory: "/workspaces/llvmta/testcases/libraries/builtinsfloat/buildarmv4", checksumkind: CSK_MD5, checksum: "25551377cb1882de433decba0bed328a")
!146 = distinct !DICompileUnit(language: DW_LANG_C99, file: !147, producer: "clang version 14.0.6 (git@gitlab.tu-dortmund.de:f4-ls12-daes/llvmta/llvmta.git 64262528b05c9d91a76d9ec1ec1045982f385529)", isOptimized: false, runtimeVersion: 0, emissionKind: LineTablesOnly, splitDebugInlining: false, nameTableKind: None)
!147 = !DIFile(filename: "../negvti2.c", directory: "/workspaces/llvmta/testcases/libraries/builtinsfloat/buildarmv4", checksumkind: CSK_MD5, checksum: "a07c33be4dee71901c4ea0f33edfbfe4")
!148 = distinct !DICompileUnit(language: DW_LANG_C99, file: !149, producer: "clang version 14.0.6 (git@gitlab.tu-dortmund.de:f4-ls12-daes/llvmta/llvmta.git 64262528b05c9d91a76d9ec1ec1045982f385529)", isOptimized: false, runtimeVersion: 0, emissionKind: LineTablesOnly, splitDebugInlining: false, nameTableKind: None)
!149 = !DIFile(filename: "../powidf2.c", directory: "/workspaces/llvmta/testcases/libraries/builtinsfloat/buildarmv4", checksumkind: CSK_MD5, checksum: "b63b11bd01652aa60af60c7ccb3ffe0d")
!150 = distinct !DICompileUnit(language: DW_LANG_C99, file: !151, producer: "clang version 14.0.6 (git@gitlab.tu-dortmund.de:f4-ls12-daes/llvmta/llvmta.git 64262528b05c9d91a76d9ec1ec1045982f385529)", isOptimized: false, runtimeVersion: 0, emissionKind: LineTablesOnly, splitDebugInlining: false, nameTableKind: None)
!151 = !DIFile(filename: "../powisf2.c", directory: "/workspaces/llvmta/testcases/libraries/builtinsfloat/buildarmv4", checksumkind: CSK_MD5, checksum: "9b2ba22fb17e1bd7a8c91a47073af5eb")
!152 = distinct !DICompileUnit(language: DW_LANG_C99, file: !153, producer: "clang version 14.0.6 (git@gitlab.tu-dortmund.de:f4-ls12-daes/llvmta/llvmta.git 64262528b05c9d91a76d9ec1ec1045982f385529)", isOptimized: false, runtimeVersion: 0, emissionKind: LineTablesOnly, splitDebugInlining: false, nameTableKind: None)
!153 = !DIFile(filename: "../powitf2.c", directory: "/workspaces/llvmta/testcases/libraries/builtinsfloat/buildarmv4", checksumkind: CSK_MD5, checksum: "a5822c6b584193a485d39742a1bd03ad")
!154 = distinct !DICompileUnit(language: DW_LANG_C99, file: !155, producer: "clang version 14.0.6 (git@gitlab.tu-dortmund.de:f4-ls12-daes/llvmta/llvmta.git 64262528b05c9d91a76d9ec1ec1045982f385529)", isOptimized: false, runtimeVersion: 0, emissionKind: LineTablesOnly, splitDebugInlining: false, nameTableKind: None)
!155 = !DIFile(filename: "../powixf2.c", directory: "/workspaces/llvmta/testcases/libraries/builtinsfloat/buildarmv4", checksumkind: CSK_MD5, checksum: "053c772639acd49f8c4cdf3eb9bb7bee")
!156 = distinct !DICompileUnit(language: DW_LANG_C99, file: !157, producer: "clang version 14.0.6 (git@gitlab.tu-dortmund.de:f4-ls12-daes/llvmta/llvmta.git 64262528b05c9d91a76d9ec1ec1045982f385529)", isOptimized: false, runtimeVersion: 0, emissionKind: LineTablesOnly, splitDebugInlining: false, nameTableKind: None)
!157 = !DIFile(filename: "../subdf3.c", directory: "/workspaces/llvmta/testcases/libraries/builtinsfloat/buildarmv4", checksumkind: CSK_MD5, checksum: "b385478a5e4c00397ac82ee5b0b51f57")
!158 = distinct !DICompileUnit(language: DW_LANG_C99, file: !159, producer: "clang version 14.0.6 (git@gitlab.tu-dortmund.de:f4-ls12-daes/llvmta/llvmta.git 64262528b05c9d91a76d9ec1ec1045982f385529)", isOptimized: false, runtimeVersion: 0, emissionKind: LineTablesOnly, splitDebugInlining: false, nameTableKind: None)
!159 = !DIFile(filename: "../subsf3.c", directory: "/workspaces/llvmta/testcases/libraries/builtinsfloat/buildarmv4", checksumkind: CSK_MD5, checksum: "c3a6b2693ea97bea2331c4555d4efe2d")
!160 = distinct !DICompileUnit(language: DW_LANG_C99, file: !161, producer: "clang version 14.0.6 (git@gitlab.tu-dortmund.de:f4-ls12-daes/llvmta/llvmta.git 64262528b05c9d91a76d9ec1ec1045982f385529)", isOptimized: false, runtimeVersion: 0, emissionKind: LineTablesOnly, splitDebugInlining: false, nameTableKind: None)
!161 = !DIFile(filename: "../subtf3.c", directory: "/workspaces/llvmta/testcases/libraries/builtinsfloat/buildarmv4", checksumkind: CSK_MD5, checksum: "4cafb3006eb27594eec63027fa347c6f")
!162 = distinct !DICompileUnit(language: DW_LANG_C99, file: !163, producer: "clang version 14.0.6 (git@gitlab.tu-dortmund.de:f4-ls12-daes/llvmta/llvmta.git 64262528b05c9d91a76d9ec1ec1045982f385529)", isOptimized: false, runtimeVersion: 0, emissionKind: LineTablesOnly, splitDebugInlining: false, nameTableKind: None)
!163 = !DIFile(filename: "../truncdfhf2.c", directory: "/workspaces/llvmta/testcases/libraries/builtinsfloat/buildarmv4", checksumkind: CSK_MD5, checksum: "d933e46dfe952b3d2808f5620f0aeefa")
!164 = distinct !DICompileUnit(language: DW_LANG_C99, file: !165, producer: "clang version 14.0.6 (git@gitlab.tu-dortmund.de:f4-ls12-daes/llvmta/llvmta.git 64262528b05c9d91a76d9ec1ec1045982f385529)", isOptimized: false, runtimeVersion: 0, emissionKind: LineTablesOnly, splitDebugInlining: false, nameTableKind: None)
!165 = !DIFile(filename: "../truncdfsf2.c", directory: "/workspaces/llvmta/testcases/libraries/builtinsfloat/buildarmv4", checksumkind: CSK_MD5, checksum: "70a3f09e6c98a39d709dbf03acedc251")
!166 = distinct !DICompileUnit(language: DW_LANG_C99, file: !167, producer: "clang version 14.0.6 (git@gitlab.tu-dortmund.de:f4-ls12-daes/llvmta/llvmta.git 64262528b05c9d91a76d9ec1ec1045982f385529)", isOptimized: false, runtimeVersion: 0, emissionKind: LineTablesOnly, splitDebugInlining: false, nameTableKind: None)
!167 = !DIFile(filename: "../truncsfhf2.c", directory: "/workspaces/llvmta/testcases/libraries/builtinsfloat/buildarmv4", checksumkind: CSK_MD5, checksum: "770788bf3f7b6a834415d81367cf4d39")
!168 = distinct !DICompileUnit(language: DW_LANG_C99, file: !169, producer: "clang version 14.0.6 (git@gitlab.tu-dortmund.de:f4-ls12-daes/llvmta/llvmta.git 64262528b05c9d91a76d9ec1ec1045982f385529)", isOptimized: false, runtimeVersion: 0, emissionKind: LineTablesOnly, splitDebugInlining: false, nameTableKind: None)
!169 = !DIFile(filename: "../trunctfdf2.c", directory: "/workspaces/llvmta/testcases/libraries/builtinsfloat/buildarmv4", checksumkind: CSK_MD5, checksum: "7415653ef7295b1a4135bb5bfd3195a2")
!170 = distinct !DICompileUnit(language: DW_LANG_C99, file: !171, producer: "clang version 14.0.6 (git@gitlab.tu-dortmund.de:f4-ls12-daes/llvmta/llvmta.git 64262528b05c9d91a76d9ec1ec1045982f385529)", isOptimized: false, runtimeVersion: 0, emissionKind: LineTablesOnly, splitDebugInlining: false, nameTableKind: None)
!171 = !DIFile(filename: "../trunctfsf2.c", directory: "/workspaces/llvmta/testcases/libraries/builtinsfloat/buildarmv4", checksumkind: CSK_MD5, checksum: "067ae423a50088959c3088695755f9f4")
!172 = !{!"clang version 14.0.6 (git@gitlab.tu-dortmund.de:f4-ls12-daes/llvmta/llvmta.git 64262528b05c9d91a76d9ec1ec1045982f385529)"}
!173 = !{i32 7, !"Dwarf Version", i32 5}
!174 = !{i32 2, !"Debug Info Version", i32 3}
!175 = !{i32 1, !"wchar_size", i32 4}
!176 = !{i32 1, !"min_enum_size", i32 4}
!177 = !{i32 1, !"branch-target-enforcement", i32 0}
!178 = !{i32 1, !"sign-return-address", i32 0}
!179 = !{i32 1, !"sign-return-address-all", i32 0}
!180 = !{i32 1, !"sign-return-address-with-bkey", i32 0}
!181 = !{i32 7, !"frame-pointer", i32 2}
!182 = distinct !DISubprogram(name: "__adddf3", scope: !1, file: !1, line: 20, type: !183, scopeLine: 20, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !0, retainedNodes: !184)
!183 = !DISubroutineType(types: !184)
!184 = !{}
!185 = !DILocation(line: 21, column: 23, scope: !182)
!186 = !DILocation(line: 21, column: 26, scope: !182)
!187 = !DILocation(line: 21, column: 12, scope: !182)
!188 = !DILocation(line: 21, column: 5, scope: !182)
!189 = distinct !DISubprogram(name: "__addXf3__", scope: !190, file: !190, line: 17, type: !183, scopeLine: 17, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !0, retainedNodes: !184)
!190 = !DIFile(filename: "../fp_add_impl.inc", directory: "/workspaces/llvmta/testcases/libraries/builtinsfloat/buildarmv4", checksumkind: CSK_MD5, checksum: "5bd22e4da10823e89bdeb8c5b297f4f4")
!191 = !DILocation(line: 18, column: 24, scope: !189)
!192 = !DILocation(line: 18, column: 18, scope: !189)
!193 = !DILocation(line: 18, column: 11, scope: !189)
!194 = !DILocation(line: 19, column: 24, scope: !189)
!195 = !DILocation(line: 19, column: 18, scope: !189)
!196 = !DILocation(line: 19, column: 11, scope: !189)
!197 = !DILocation(line: 20, column: 24, scope: !189)
!198 = !DILocation(line: 20, column: 29, scope: !189)
!199 = !DILocation(line: 20, column: 17, scope: !189)
!200 = !DILocation(line: 21, column: 24, scope: !189)
!201 = !DILocation(line: 21, column: 29, scope: !189)
!202 = !DILocation(line: 21, column: 17, scope: !189)
!203 = !DILocation(line: 24, column: 9, scope: !189)
!204 = !DILocation(line: 24, column: 14, scope: !189)
!205 = !DILocation(line: 24, column: 25, scope: !189)
!206 = !DILocation(line: 24, column: 46, scope: !189)
!207 = !DILocation(line: 25, column: 9, scope: !189)
!208 = !DILocation(line: 25, column: 14, scope: !189)
!209 = !DILocation(line: 25, column: 25, scope: !189)
!210 = !DILocation(line: 27, column: 13, scope: !189)
!211 = !DILocation(line: 27, column: 18, scope: !189)
!212 = !DILocation(line: 27, column: 49, scope: !189)
!213 = !DILocation(line: 27, column: 43, scope: !189)
!214 = !DILocation(line: 27, column: 52, scope: !189)
!215 = !DILocation(line: 27, column: 35, scope: !189)
!216 = !DILocation(line: 27, column: 28, scope: !189)
!217 = !DILocation(line: 29, column: 13, scope: !189)
!218 = !DILocation(line: 29, column: 18, scope: !189)
!219 = !DILocation(line: 29, column: 49, scope: !189)
!220 = !DILocation(line: 29, column: 43, scope: !189)
!221 = !DILocation(line: 29, column: 52, scope: !189)
!222 = !DILocation(line: 29, column: 35, scope: !189)
!223 = !DILocation(line: 29, column: 28, scope: !189)
!224 = !DILocation(line: 31, column: 13, scope: !189)
!225 = !DILocation(line: 31, column: 18, scope: !189)
!226 = !DILocation(line: 33, column: 24, scope: !189)
!227 = !DILocation(line: 33, column: 18, scope: !189)
!228 = !DILocation(line: 33, column: 35, scope: !189)
!229 = !DILocation(line: 33, column: 29, scope: !189)
!230 = !DILocation(line: 33, column: 27, scope: !189)
!231 = !DILocation(line: 33, column: 39, scope: !189)
!232 = !DILocation(line: 33, column: 17, scope: !189)
!233 = !DILocation(line: 33, column: 58, scope: !189)
!234 = !DILocation(line: 33, column: 51, scope: !189)
!235 = !DILocation(line: 35, column: 25, scope: !189)
!236 = !DILocation(line: 35, column: 18, scope: !189)
!237 = !DILocation(line: 39, column: 13, scope: !189)
!238 = !DILocation(line: 39, column: 18, scope: !189)
!239 = !DILocation(line: 39, column: 36, scope: !189)
!240 = !DILocation(line: 39, column: 29, scope: !189)
!241 = !DILocation(line: 42, column: 14, scope: !189)
!242 = !DILocation(line: 42, column: 13, scope: !189)
!243 = !DILocation(line: 44, column: 18, scope: !189)
!244 = !DILocation(line: 44, column: 17, scope: !189)
!245 = !DILocation(line: 44, column: 45, scope: !189)
!246 = !DILocation(line: 44, column: 39, scope: !189)
!247 = !DILocation(line: 44, column: 56, scope: !189)
!248 = !DILocation(line: 44, column: 50, scope: !189)
!249 = !DILocation(line: 44, column: 48, scope: !189)
!250 = !DILocation(line: 44, column: 31, scope: !189)
!251 = !DILocation(line: 44, column: 24, scope: !189)
!252 = !DILocation(line: 45, column: 25, scope: !189)
!253 = !DILocation(line: 45, column: 18, scope: !189)
!254 = !DILocation(line: 49, column: 14, scope: !189)
!255 = !DILocation(line: 49, column: 13, scope: !189)
!256 = !DILocation(line: 49, column: 27, scope: !189)
!257 = !DILocation(line: 49, column: 20, scope: !189)
!258 = !DILocation(line: 50, column: 5, scope: !189)
!259 = !DILocation(line: 53, column: 9, scope: !189)
!260 = !DILocation(line: 53, column: 16, scope: !189)
!261 = !DILocation(line: 53, column: 14, scope: !189)
!262 = !DILocation(line: 54, column: 28, scope: !189)
!263 = !DILocation(line: 54, column: 21, scope: !189)
!264 = !DILocation(line: 55, column: 16, scope: !189)
!265 = !DILocation(line: 55, column: 14, scope: !189)
!266 = !DILocation(line: 56, column: 16, scope: !189)
!267 = !DILocation(line: 56, column: 14, scope: !189)
!268 = !DILocation(line: 57, column: 5, scope: !189)
!269 = !DILocation(line: 60, column: 21, scope: !189)
!270 = !DILocation(line: 60, column: 26, scope: !189)
!271 = !DILocation(line: 60, column: 45, scope: !189)
!272 = !DILocation(line: 60, column: 9, scope: !189)
!273 = !DILocation(line: 61, column: 21, scope: !189)
!274 = !DILocation(line: 61, column: 26, scope: !189)
!275 = !DILocation(line: 61, column: 45, scope: !189)
!276 = !DILocation(line: 61, column: 9, scope: !189)
!277 = !DILocation(line: 62, column: 26, scope: !189)
!278 = !DILocation(line: 62, column: 31, scope: !189)
!279 = !DILocation(line: 62, column: 11, scope: !189)
!280 = !DILocation(line: 63, column: 26, scope: !189)
!281 = !DILocation(line: 63, column: 31, scope: !189)
!282 = !DILocation(line: 63, column: 11, scope: !189)
!283 = !DILocation(line: 66, column: 9, scope: !189)
!284 = !DILocation(line: 66, column: 19, scope: !189)
!285 = !DILocation(line: 66, column: 37, scope: !189)
!286 = !DILocation(line: 66, column: 35, scope: !189)
!287 = !DILocation(line: 66, column: 25, scope: !189)
!288 = !DILocation(line: 67, column: 9, scope: !189)
!289 = !DILocation(line: 67, column: 19, scope: !189)
!290 = !DILocation(line: 67, column: 37, scope: !189)
!291 = !DILocation(line: 67, column: 35, scope: !189)
!292 = !DILocation(line: 67, column: 25, scope: !189)
!293 = !DILocation(line: 71, column: 30, scope: !189)
!294 = !DILocation(line: 71, column: 35, scope: !189)
!295 = !DILocation(line: 71, column: 17, scope: !189)
!296 = !DILocation(line: 72, column: 31, scope: !189)
!297 = !DILocation(line: 72, column: 38, scope: !189)
!298 = !DILocation(line: 72, column: 36, scope: !189)
!299 = !DILocation(line: 72, column: 44, scope: !189)
!300 = !DILocation(line: 72, column: 30, scope: !189)
!301 = !DILocation(line: 72, column: 16, scope: !189)
!302 = !DILocation(line: 78, column: 21, scope: !189)
!303 = !DILocation(line: 78, column: 34, scope: !189)
!304 = !DILocation(line: 78, column: 49, scope: !189)
!305 = !DILocation(line: 78, column: 18, scope: !189)
!306 = !DILocation(line: 79, column: 21, scope: !189)
!307 = !DILocation(line: 79, column: 34, scope: !189)
!308 = !DILocation(line: 79, column: 49, scope: !189)
!309 = !DILocation(line: 79, column: 18, scope: !189)
!310 = !DILocation(line: 83, column: 32, scope: !189)
!311 = !DILocation(line: 83, column: 44, scope: !189)
!312 = !DILocation(line: 83, column: 42, scope: !189)
!313 = !DILocation(line: 83, column: 24, scope: !189)
!314 = !DILocation(line: 84, column: 9, scope: !189)
!315 = !DILocation(line: 85, column: 13, scope: !189)
!316 = !DILocation(line: 85, column: 19, scope: !189)
!317 = !DILocation(line: 86, column: 33, scope: !189)
!318 = !DILocation(line: 86, column: 62, scope: !189)
!319 = !DILocation(line: 86, column: 60, scope: !189)
!320 = !DILocation(line: 86, column: 46, scope: !189)
!321 = !DILocation(line: 86, column: 24, scope: !189)
!322 = !DILocation(line: 87, column: 28, scope: !189)
!323 = !DILocation(line: 87, column: 44, scope: !189)
!324 = !DILocation(line: 87, column: 41, scope: !189)
!325 = !DILocation(line: 87, column: 52, scope: !189)
!326 = !DILocation(line: 87, column: 50, scope: !189)
!327 = !DILocation(line: 87, column: 26, scope: !189)
!328 = !DILocation(line: 88, column: 9, scope: !189)
!329 = !DILocation(line: 89, column: 26, scope: !189)
!330 = !DILocation(line: 91, column: 5, scope: !189)
!331 = !DILocation(line: 92, column: 9, scope: !189)
!332 = !DILocation(line: 93, column: 25, scope: !189)
!333 = !DILocation(line: 93, column: 22, scope: !189)
!334 = !DILocation(line: 95, column: 13, scope: !189)
!335 = !DILocation(line: 95, column: 26, scope: !189)
!336 = !DILocation(line: 95, column: 39, scope: !189)
!337 = !DILocation(line: 95, column: 32, scope: !189)
!338 = !DILocation(line: 99, column: 13, scope: !189)
!339 = !DILocation(line: 99, column: 26, scope: !189)
!340 = !DILocation(line: 100, column: 39, scope: !189)
!341 = !DILocation(line: 100, column: 31, scope: !189)
!342 = !DILocation(line: 100, column: 55, scope: !189)
!343 = !DILocation(line: 100, column: 53, scope: !189)
!344 = !DILocation(line: 100, column: 23, scope: !189)
!345 = !DILocation(line: 101, column: 30, scope: !189)
!346 = !DILocation(line: 101, column: 26, scope: !189)
!347 = !DILocation(line: 102, column: 26, scope: !189)
!348 = !DILocation(line: 102, column: 23, scope: !189)
!349 = !DILocation(line: 103, column: 9, scope: !189)
!350 = !DILocation(line: 104, column: 5, scope: !189)
!351 = !DILocation(line: 106, column: 25, scope: !189)
!352 = !DILocation(line: 106, column: 22, scope: !189)
!353 = !DILocation(line: 110, column: 13, scope: !189)
!354 = !DILocation(line: 110, column: 26, scope: !189)
!355 = !DILocation(line: 111, column: 33, scope: !189)
!356 = !DILocation(line: 111, column: 46, scope: !189)
!357 = !DILocation(line: 111, column: 24, scope: !189)
!358 = !DILocation(line: 112, column: 28, scope: !189)
!359 = !DILocation(line: 112, column: 41, scope: !189)
!360 = !DILocation(line: 112, column: 48, scope: !189)
!361 = !DILocation(line: 112, column: 46, scope: !189)
!362 = !DILocation(line: 112, column: 26, scope: !189)
!363 = !DILocation(line: 113, column: 23, scope: !189)
!364 = !DILocation(line: 114, column: 9, scope: !189)
!365 = !DILocation(line: 118, column: 9, scope: !189)
!366 = !DILocation(line: 118, column: 19, scope: !189)
!367 = !DILocation(line: 118, column: 59, scope: !189)
!368 = !DILocation(line: 118, column: 57, scope: !189)
!369 = !DILocation(line: 118, column: 42, scope: !189)
!370 = !DILocation(line: 118, column: 35, scope: !189)
!371 = !DILocation(line: 120, column: 9, scope: !189)
!372 = !DILocation(line: 120, column: 19, scope: !189)
!373 = !DILocation(line: 123, column: 31, scope: !189)
!374 = !DILocation(line: 123, column: 29, scope: !189)
!375 = !DILocation(line: 123, column: 19, scope: !189)
!376 = !DILocation(line: 124, column: 29, scope: !189)
!377 = !DILocation(line: 124, column: 58, scope: !189)
!378 = !DILocation(line: 124, column: 56, scope: !189)
!379 = !DILocation(line: 124, column: 42, scope: !189)
!380 = !DILocation(line: 124, column: 20, scope: !189)
!381 = !DILocation(line: 125, column: 24, scope: !189)
!382 = !DILocation(line: 125, column: 40, scope: !189)
!383 = !DILocation(line: 125, column: 37, scope: !189)
!384 = !DILocation(line: 125, column: 48, scope: !189)
!385 = !DILocation(line: 125, column: 46, scope: !189)
!386 = !DILocation(line: 125, column: 22, scope: !189)
!387 = !DILocation(line: 126, column: 19, scope: !189)
!388 = !DILocation(line: 127, column: 5, scope: !189)
!389 = !DILocation(line: 130, column: 34, scope: !189)
!390 = !DILocation(line: 130, column: 47, scope: !189)
!391 = !DILocation(line: 130, column: 15, scope: !189)
!392 = !DILocation(line: 133, column: 20, scope: !189)
!393 = !DILocation(line: 133, column: 33, scope: !189)
!394 = !DILocation(line: 133, column: 38, scope: !189)
!395 = !DILocation(line: 133, column: 11, scope: !189)
!396 = !DILocation(line: 136, column: 22, scope: !189)
!397 = !DILocation(line: 136, column: 15, scope: !189)
!398 = !DILocation(line: 136, column: 32, scope: !189)
!399 = !DILocation(line: 136, column: 12, scope: !189)
!400 = !DILocation(line: 137, column: 15, scope: !189)
!401 = !DILocation(line: 137, column: 12, scope: !189)
!402 = !DILocation(line: 141, column: 9, scope: !189)
!403 = !DILocation(line: 141, column: 26, scope: !189)
!404 = !DILocation(line: 141, column: 39, scope: !189)
!405 = !DILocation(line: 141, column: 33, scope: !189)
!406 = !DILocation(line: 142, column: 9, scope: !189)
!407 = !DILocation(line: 142, column: 26, scope: !189)
!408 = !DILocation(line: 142, column: 44, scope: !189)
!409 = !DILocation(line: 142, column: 51, scope: !189)
!410 = !DILocation(line: 142, column: 41, scope: !189)
!411 = !DILocation(line: 142, column: 34, scope: !189)
!412 = !DILocation(line: 143, column: 20, scope: !189)
!413 = !DILocation(line: 143, column: 12, scope: !189)
!414 = !DILocation(line: 143, column: 5, scope: !189)
!415 = !DILocation(line: 144, column: 1, scope: !189)
!416 = distinct !DISubprogram(name: "toRep", scope: !417, file: !417, line: 231, type: !183, scopeLine: 231, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !0, retainedNodes: !184)
!417 = !DIFile(filename: "../fp_lib.h", directory: "/workspaces/llvmta/testcases/libraries/builtinsfloat/buildarmv4", checksumkind: CSK_MD5, checksum: "7dc3444b56426ce9030559b28a9f87ee")
!418 = !DILocation(line: 232, column: 44, scope: !416)
!419 = !DILocation(line: 232, column: 50, scope: !416)
!420 = !DILocation(line: 233, column: 16, scope: !416)
!421 = !DILocation(line: 233, column: 5, scope: !416)
!422 = distinct !DISubprogram(name: "fromRep", scope: !417, file: !417, line: 236, type: !183, scopeLine: 236, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !0, retainedNodes: !184)
!423 = !DILocation(line: 237, column: 44, scope: !422)
!424 = !DILocation(line: 237, column: 50, scope: !422)
!425 = !DILocation(line: 238, column: 16, scope: !422)
!426 = !DILocation(line: 238, column: 5, scope: !422)
!427 = distinct !DISubprogram(name: "normalize", scope: !417, file: !417, line: 241, type: !183, scopeLine: 241, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !0, retainedNodes: !184)
!428 = !DILocation(line: 242, column: 32, scope: !427)
!429 = !DILocation(line: 242, column: 31, scope: !427)
!430 = !DILocation(line: 242, column: 23, scope: !427)
!431 = !DILocation(line: 242, column: 47, scope: !427)
!432 = !DILocation(line: 242, column: 45, scope: !427)
!433 = !DILocation(line: 242, column: 15, scope: !427)
!434 = !DILocation(line: 243, column: 22, scope: !427)
!435 = !DILocation(line: 243, column: 6, scope: !427)
!436 = !DILocation(line: 243, column: 18, scope: !427)
!437 = !DILocation(line: 244, column: 16, scope: !427)
!438 = !DILocation(line: 244, column: 14, scope: !427)
!439 = !DILocation(line: 244, column: 5, scope: !427)
!440 = distinct !DISubprogram(name: "rep_clz", scope: !417, file: !417, line: 69, type: !183, scopeLine: 69, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !0, retainedNodes: !184)
!441 = !DILocation(line: 73, column: 9, scope: !440)
!442 = !DILocation(line: 73, column: 11, scope: !440)
!443 = !DILocation(line: 74, column: 30, scope: !440)
!444 = !DILocation(line: 74, column: 32, scope: !440)
!445 = !DILocation(line: 74, column: 16, scope: !440)
!446 = !DILocation(line: 74, column: 9, scope: !440)
!447 = !DILocation(line: 76, column: 35, scope: !440)
!448 = !DILocation(line: 76, column: 37, scope: !440)
!449 = !DILocation(line: 76, column: 21, scope: !440)
!450 = !DILocation(line: 76, column: 19, scope: !440)
!451 = !DILocation(line: 76, column: 9, scope: !440)
!452 = !DILocation(line: 78, column: 1, scope: !440)
!453 = distinct !DISubprogram(name: "__addsf3", scope: !3, file: !3, line: 20, type: !183, scopeLine: 20, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !184)
!454 = !DILocation(line: 21, column: 23, scope: !453)
!455 = !DILocation(line: 21, column: 26, scope: !453)
!456 = !DILocation(line: 21, column: 12, scope: !453)
!457 = !DILocation(line: 21, column: 5, scope: !453)
!458 = distinct !DISubprogram(name: "__addXf3__", scope: !190, file: !190, line: 17, type: !183, scopeLine: 17, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !184)
!459 = !DILocation(line: 18, column: 24, scope: !458)
!460 = !DILocation(line: 18, column: 18, scope: !458)
!461 = !DILocation(line: 18, column: 11, scope: !458)
!462 = !DILocation(line: 19, column: 24, scope: !458)
!463 = !DILocation(line: 19, column: 18, scope: !458)
!464 = !DILocation(line: 19, column: 11, scope: !458)
!465 = !DILocation(line: 20, column: 24, scope: !458)
!466 = !DILocation(line: 20, column: 29, scope: !458)
!467 = !DILocation(line: 20, column: 17, scope: !458)
!468 = !DILocation(line: 21, column: 24, scope: !458)
!469 = !DILocation(line: 21, column: 29, scope: !458)
!470 = !DILocation(line: 21, column: 17, scope: !458)
!471 = !DILocation(line: 24, column: 9, scope: !458)
!472 = !DILocation(line: 24, column: 14, scope: !458)
!473 = !DILocation(line: 24, column: 25, scope: !458)
!474 = !DILocation(line: 24, column: 46, scope: !458)
!475 = !DILocation(line: 25, column: 9, scope: !458)
!476 = !DILocation(line: 25, column: 14, scope: !458)
!477 = !DILocation(line: 25, column: 25, scope: !458)
!478 = !DILocation(line: 27, column: 13, scope: !458)
!479 = !DILocation(line: 27, column: 18, scope: !458)
!480 = !DILocation(line: 27, column: 49, scope: !458)
!481 = !DILocation(line: 27, column: 43, scope: !458)
!482 = !DILocation(line: 27, column: 52, scope: !458)
!483 = !DILocation(line: 27, column: 35, scope: !458)
!484 = !DILocation(line: 27, column: 28, scope: !458)
!485 = !DILocation(line: 29, column: 13, scope: !458)
!486 = !DILocation(line: 29, column: 18, scope: !458)
!487 = !DILocation(line: 29, column: 49, scope: !458)
!488 = !DILocation(line: 29, column: 43, scope: !458)
!489 = !DILocation(line: 29, column: 52, scope: !458)
!490 = !DILocation(line: 29, column: 35, scope: !458)
!491 = !DILocation(line: 29, column: 28, scope: !458)
!492 = !DILocation(line: 31, column: 13, scope: !458)
!493 = !DILocation(line: 31, column: 18, scope: !458)
!494 = !DILocation(line: 33, column: 24, scope: !458)
!495 = !DILocation(line: 33, column: 18, scope: !458)
!496 = !DILocation(line: 33, column: 35, scope: !458)
!497 = !DILocation(line: 33, column: 29, scope: !458)
!498 = !DILocation(line: 33, column: 27, scope: !458)
!499 = !DILocation(line: 33, column: 39, scope: !458)
!500 = !DILocation(line: 33, column: 17, scope: !458)
!501 = !DILocation(line: 33, column: 58, scope: !458)
!502 = !DILocation(line: 33, column: 51, scope: !458)
!503 = !DILocation(line: 35, column: 25, scope: !458)
!504 = !DILocation(line: 35, column: 18, scope: !458)
!505 = !DILocation(line: 39, column: 13, scope: !458)
!506 = !DILocation(line: 39, column: 18, scope: !458)
!507 = !DILocation(line: 39, column: 36, scope: !458)
!508 = !DILocation(line: 39, column: 29, scope: !458)
!509 = !DILocation(line: 42, column: 14, scope: !458)
!510 = !DILocation(line: 42, column: 13, scope: !458)
!511 = !DILocation(line: 44, column: 18, scope: !458)
!512 = !DILocation(line: 44, column: 17, scope: !458)
!513 = !DILocation(line: 44, column: 45, scope: !458)
!514 = !DILocation(line: 44, column: 39, scope: !458)
!515 = !DILocation(line: 44, column: 56, scope: !458)
!516 = !DILocation(line: 44, column: 50, scope: !458)
!517 = !DILocation(line: 44, column: 48, scope: !458)
!518 = !DILocation(line: 44, column: 31, scope: !458)
!519 = !DILocation(line: 44, column: 24, scope: !458)
!520 = !DILocation(line: 45, column: 25, scope: !458)
!521 = !DILocation(line: 45, column: 18, scope: !458)
!522 = !DILocation(line: 49, column: 14, scope: !458)
!523 = !DILocation(line: 49, column: 13, scope: !458)
!524 = !DILocation(line: 49, column: 27, scope: !458)
!525 = !DILocation(line: 49, column: 20, scope: !458)
!526 = !DILocation(line: 50, column: 5, scope: !458)
!527 = !DILocation(line: 53, column: 9, scope: !458)
!528 = !DILocation(line: 53, column: 16, scope: !458)
!529 = !DILocation(line: 53, column: 14, scope: !458)
!530 = !DILocation(line: 54, column: 28, scope: !458)
!531 = !DILocation(line: 54, column: 21, scope: !458)
!532 = !DILocation(line: 55, column: 16, scope: !458)
!533 = !DILocation(line: 55, column: 14, scope: !458)
!534 = !DILocation(line: 56, column: 16, scope: !458)
!535 = !DILocation(line: 56, column: 14, scope: !458)
!536 = !DILocation(line: 57, column: 5, scope: !458)
!537 = !DILocation(line: 60, column: 21, scope: !458)
!538 = !DILocation(line: 60, column: 26, scope: !458)
!539 = !DILocation(line: 60, column: 45, scope: !458)
!540 = !DILocation(line: 60, column: 9, scope: !458)
!541 = !DILocation(line: 61, column: 21, scope: !458)
!542 = !DILocation(line: 61, column: 26, scope: !458)
!543 = !DILocation(line: 61, column: 45, scope: !458)
!544 = !DILocation(line: 61, column: 9, scope: !458)
!545 = !DILocation(line: 62, column: 26, scope: !458)
!546 = !DILocation(line: 62, column: 31, scope: !458)
!547 = !DILocation(line: 62, column: 11, scope: !458)
!548 = !DILocation(line: 63, column: 26, scope: !458)
!549 = !DILocation(line: 63, column: 31, scope: !458)
!550 = !DILocation(line: 63, column: 11, scope: !458)
!551 = !DILocation(line: 66, column: 9, scope: !458)
!552 = !DILocation(line: 66, column: 19, scope: !458)
!553 = !DILocation(line: 66, column: 37, scope: !458)
!554 = !DILocation(line: 66, column: 35, scope: !458)
!555 = !DILocation(line: 66, column: 25, scope: !458)
!556 = !DILocation(line: 67, column: 9, scope: !458)
!557 = !DILocation(line: 67, column: 19, scope: !458)
!558 = !DILocation(line: 67, column: 37, scope: !458)
!559 = !DILocation(line: 67, column: 35, scope: !458)
!560 = !DILocation(line: 67, column: 25, scope: !458)
!561 = !DILocation(line: 71, column: 30, scope: !458)
!562 = !DILocation(line: 71, column: 35, scope: !458)
!563 = !DILocation(line: 71, column: 17, scope: !458)
!564 = !DILocation(line: 72, column: 31, scope: !458)
!565 = !DILocation(line: 72, column: 38, scope: !458)
!566 = !DILocation(line: 72, column: 36, scope: !458)
!567 = !DILocation(line: 72, column: 44, scope: !458)
!568 = !DILocation(line: 72, column: 30, scope: !458)
!569 = !DILocation(line: 72, column: 16, scope: !458)
!570 = !DILocation(line: 78, column: 21, scope: !458)
!571 = !DILocation(line: 78, column: 34, scope: !458)
!572 = !DILocation(line: 78, column: 49, scope: !458)
!573 = !DILocation(line: 78, column: 18, scope: !458)
!574 = !DILocation(line: 79, column: 21, scope: !458)
!575 = !DILocation(line: 79, column: 34, scope: !458)
!576 = !DILocation(line: 79, column: 49, scope: !458)
!577 = !DILocation(line: 79, column: 18, scope: !458)
!578 = !DILocation(line: 83, column: 32, scope: !458)
!579 = !DILocation(line: 83, column: 44, scope: !458)
!580 = !DILocation(line: 83, column: 42, scope: !458)
!581 = !DILocation(line: 83, column: 24, scope: !458)
!582 = !DILocation(line: 84, column: 9, scope: !458)
!583 = !DILocation(line: 85, column: 13, scope: !458)
!584 = !DILocation(line: 85, column: 19, scope: !458)
!585 = !DILocation(line: 86, column: 33, scope: !458)
!586 = !DILocation(line: 86, column: 62, scope: !458)
!587 = !DILocation(line: 86, column: 60, scope: !458)
!588 = !DILocation(line: 86, column: 46, scope: !458)
!589 = !DILocation(line: 86, column: 24, scope: !458)
!590 = !DILocation(line: 87, column: 28, scope: !458)
!591 = !DILocation(line: 87, column: 44, scope: !458)
!592 = !DILocation(line: 87, column: 41, scope: !458)
!593 = !DILocation(line: 87, column: 52, scope: !458)
!594 = !DILocation(line: 87, column: 50, scope: !458)
!595 = !DILocation(line: 87, column: 26, scope: !458)
!596 = !DILocation(line: 88, column: 9, scope: !458)
!597 = !DILocation(line: 89, column: 26, scope: !458)
!598 = !DILocation(line: 91, column: 5, scope: !458)
!599 = !DILocation(line: 92, column: 9, scope: !458)
!600 = !DILocation(line: 93, column: 25, scope: !458)
!601 = !DILocation(line: 93, column: 22, scope: !458)
!602 = !DILocation(line: 95, column: 13, scope: !458)
!603 = !DILocation(line: 95, column: 26, scope: !458)
!604 = !DILocation(line: 95, column: 39, scope: !458)
!605 = !DILocation(line: 95, column: 32, scope: !458)
!606 = !DILocation(line: 99, column: 13, scope: !458)
!607 = !DILocation(line: 99, column: 26, scope: !458)
!608 = !DILocation(line: 100, column: 39, scope: !458)
!609 = !DILocation(line: 100, column: 31, scope: !458)
!610 = !DILocation(line: 100, column: 55, scope: !458)
!611 = !DILocation(line: 100, column: 53, scope: !458)
!612 = !DILocation(line: 100, column: 23, scope: !458)
!613 = !DILocation(line: 101, column: 30, scope: !458)
!614 = !DILocation(line: 101, column: 26, scope: !458)
!615 = !DILocation(line: 102, column: 26, scope: !458)
!616 = !DILocation(line: 102, column: 23, scope: !458)
!617 = !DILocation(line: 103, column: 9, scope: !458)
!618 = !DILocation(line: 104, column: 5, scope: !458)
!619 = !DILocation(line: 106, column: 25, scope: !458)
!620 = !DILocation(line: 106, column: 22, scope: !458)
!621 = !DILocation(line: 110, column: 13, scope: !458)
!622 = !DILocation(line: 110, column: 26, scope: !458)
!623 = !DILocation(line: 111, column: 33, scope: !458)
!624 = !DILocation(line: 111, column: 46, scope: !458)
!625 = !DILocation(line: 111, column: 24, scope: !458)
!626 = !DILocation(line: 112, column: 28, scope: !458)
!627 = !DILocation(line: 112, column: 41, scope: !458)
!628 = !DILocation(line: 112, column: 48, scope: !458)
!629 = !DILocation(line: 112, column: 46, scope: !458)
!630 = !DILocation(line: 112, column: 26, scope: !458)
!631 = !DILocation(line: 113, column: 23, scope: !458)
!632 = !DILocation(line: 114, column: 9, scope: !458)
!633 = !DILocation(line: 118, column: 9, scope: !458)
!634 = !DILocation(line: 118, column: 19, scope: !458)
!635 = !DILocation(line: 118, column: 59, scope: !458)
!636 = !DILocation(line: 118, column: 57, scope: !458)
!637 = !DILocation(line: 118, column: 42, scope: !458)
!638 = !DILocation(line: 118, column: 35, scope: !458)
!639 = !DILocation(line: 120, column: 9, scope: !458)
!640 = !DILocation(line: 120, column: 19, scope: !458)
!641 = !DILocation(line: 123, column: 31, scope: !458)
!642 = !DILocation(line: 123, column: 29, scope: !458)
!643 = !DILocation(line: 123, column: 19, scope: !458)
!644 = !DILocation(line: 124, column: 29, scope: !458)
!645 = !DILocation(line: 124, column: 58, scope: !458)
!646 = !DILocation(line: 124, column: 56, scope: !458)
!647 = !DILocation(line: 124, column: 42, scope: !458)
!648 = !DILocation(line: 124, column: 20, scope: !458)
!649 = !DILocation(line: 125, column: 24, scope: !458)
!650 = !DILocation(line: 125, column: 40, scope: !458)
!651 = !DILocation(line: 125, column: 37, scope: !458)
!652 = !DILocation(line: 125, column: 48, scope: !458)
!653 = !DILocation(line: 125, column: 46, scope: !458)
!654 = !DILocation(line: 125, column: 22, scope: !458)
!655 = !DILocation(line: 126, column: 19, scope: !458)
!656 = !DILocation(line: 127, column: 5, scope: !458)
!657 = !DILocation(line: 130, column: 34, scope: !458)
!658 = !DILocation(line: 130, column: 47, scope: !458)
!659 = !DILocation(line: 130, column: 15, scope: !458)
!660 = !DILocation(line: 133, column: 20, scope: !458)
!661 = !DILocation(line: 133, column: 33, scope: !458)
!662 = !DILocation(line: 133, column: 38, scope: !458)
!663 = !DILocation(line: 133, column: 11, scope: !458)
!664 = !DILocation(line: 136, column: 22, scope: !458)
!665 = !DILocation(line: 136, column: 32, scope: !458)
!666 = !DILocation(line: 136, column: 12, scope: !458)
!667 = !DILocation(line: 137, column: 15, scope: !458)
!668 = !DILocation(line: 137, column: 12, scope: !458)
!669 = !DILocation(line: 141, column: 9, scope: !458)
!670 = !DILocation(line: 141, column: 26, scope: !458)
!671 = !DILocation(line: 141, column: 39, scope: !458)
!672 = !DILocation(line: 141, column: 33, scope: !458)
!673 = !DILocation(line: 142, column: 9, scope: !458)
!674 = !DILocation(line: 142, column: 26, scope: !458)
!675 = !DILocation(line: 142, column: 44, scope: !458)
!676 = !DILocation(line: 142, column: 51, scope: !458)
!677 = !DILocation(line: 142, column: 41, scope: !458)
!678 = !DILocation(line: 142, column: 34, scope: !458)
!679 = !DILocation(line: 143, column: 20, scope: !458)
!680 = !DILocation(line: 143, column: 12, scope: !458)
!681 = !DILocation(line: 143, column: 5, scope: !458)
!682 = !DILocation(line: 144, column: 1, scope: !458)
!683 = distinct !DISubprogram(name: "toRep", scope: !417, file: !417, line: 231, type: !183, scopeLine: 231, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !184)
!684 = !DILocation(line: 232, column: 44, scope: !683)
!685 = !DILocation(line: 232, column: 50, scope: !683)
!686 = !DILocation(line: 233, column: 16, scope: !683)
!687 = !DILocation(line: 233, column: 5, scope: !683)
!688 = distinct !DISubprogram(name: "fromRep", scope: !417, file: !417, line: 236, type: !183, scopeLine: 236, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !184)
!689 = !DILocation(line: 237, column: 44, scope: !688)
!690 = !DILocation(line: 237, column: 50, scope: !688)
!691 = !DILocation(line: 238, column: 16, scope: !688)
!692 = !DILocation(line: 238, column: 5, scope: !688)
!693 = distinct !DISubprogram(name: "normalize", scope: !417, file: !417, line: 241, type: !183, scopeLine: 241, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !184)
!694 = !DILocation(line: 242, column: 32, scope: !693)
!695 = !DILocation(line: 242, column: 31, scope: !693)
!696 = !DILocation(line: 242, column: 23, scope: !693)
!697 = !DILocation(line: 242, column: 47, scope: !693)
!698 = !DILocation(line: 242, column: 45, scope: !693)
!699 = !DILocation(line: 242, column: 15, scope: !693)
!700 = !DILocation(line: 243, column: 22, scope: !693)
!701 = !DILocation(line: 243, column: 6, scope: !693)
!702 = !DILocation(line: 243, column: 18, scope: !693)
!703 = !DILocation(line: 244, column: 16, scope: !693)
!704 = !DILocation(line: 244, column: 14, scope: !693)
!705 = !DILocation(line: 244, column: 5, scope: !693)
!706 = distinct !DISubprogram(name: "rep_clz", scope: !417, file: !417, line: 49, type: !183, scopeLine: 49, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !184)
!707 = !DILocation(line: 50, column: 26, scope: !706)
!708 = !DILocation(line: 50, column: 12, scope: !706)
!709 = !DILocation(line: 50, column: 5, scope: !706)
!710 = distinct !DISubprogram(name: "__ledf2", scope: !7, file: !7, line: 51, type: !183, scopeLine: 51, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !6, retainedNodes: !184)
!711 = !DILocation(line: 53, column: 31, scope: !710)
!712 = !DILocation(line: 53, column: 25, scope: !710)
!713 = !DILocation(line: 53, column: 18, scope: !710)
!714 = !DILocation(line: 54, column: 31, scope: !710)
!715 = !DILocation(line: 54, column: 25, scope: !710)
!716 = !DILocation(line: 54, column: 18, scope: !710)
!717 = !DILocation(line: 55, column: 24, scope: !710)
!718 = !DILocation(line: 55, column: 29, scope: !710)
!719 = !DILocation(line: 55, column: 17, scope: !710)
!720 = !DILocation(line: 56, column: 24, scope: !710)
!721 = !DILocation(line: 56, column: 29, scope: !710)
!722 = !DILocation(line: 56, column: 17, scope: !710)
!723 = !DILocation(line: 59, column: 9, scope: !710)
!724 = !DILocation(line: 59, column: 14, scope: !710)
!725 = !DILocation(line: 59, column: 23, scope: !710)
!726 = !DILocation(line: 59, column: 26, scope: !710)
!727 = !DILocation(line: 59, column: 31, scope: !710)
!728 = !DILocation(line: 59, column: 41, scope: !710)
!729 = !DILocation(line: 62, column: 10, scope: !710)
!730 = !DILocation(line: 62, column: 17, scope: !710)
!731 = !DILocation(line: 62, column: 15, scope: !710)
!732 = !DILocation(line: 62, column: 23, scope: !710)
!733 = !DILocation(line: 62, column: 9, scope: !710)
!734 = !DILocation(line: 62, column: 29, scope: !710)
!735 = !DILocation(line: 66, column: 10, scope: !710)
!736 = !DILocation(line: 66, column: 17, scope: !710)
!737 = !DILocation(line: 66, column: 15, scope: !710)
!738 = !DILocation(line: 66, column: 23, scope: !710)
!739 = !DILocation(line: 66, column: 9, scope: !710)
!740 = !DILocation(line: 67, column: 13, scope: !710)
!741 = !DILocation(line: 67, column: 20, scope: !710)
!742 = !DILocation(line: 67, column: 18, scope: !710)
!743 = !DILocation(line: 67, column: 26, scope: !710)
!744 = !DILocation(line: 68, column: 18, scope: !710)
!745 = !DILocation(line: 68, column: 26, scope: !710)
!746 = !DILocation(line: 68, column: 23, scope: !710)
!747 = !DILocation(line: 68, column: 32, scope: !710)
!748 = !DILocation(line: 69, column: 14, scope: !710)
!749 = !DILocation(line: 77, column: 13, scope: !710)
!750 = !DILocation(line: 77, column: 20, scope: !710)
!751 = !DILocation(line: 77, column: 18, scope: !710)
!752 = !DILocation(line: 77, column: 26, scope: !710)
!753 = !DILocation(line: 78, column: 18, scope: !710)
!754 = !DILocation(line: 78, column: 26, scope: !710)
!755 = !DILocation(line: 78, column: 23, scope: !710)
!756 = !DILocation(line: 78, column: 32, scope: !710)
!757 = !DILocation(line: 79, column: 14, scope: !710)
!758 = !DILocation(line: 81, column: 1, scope: !710)
!759 = distinct !DISubprogram(name: "toRep", scope: !417, file: !417, line: 231, type: !183, scopeLine: 231, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !6, retainedNodes: !184)
!760 = !DILocation(line: 232, column: 44, scope: !759)
!761 = !DILocation(line: 232, column: 50, scope: !759)
!762 = !DILocation(line: 233, column: 16, scope: !759)
!763 = !DILocation(line: 233, column: 5, scope: !759)
!764 = distinct !DISubprogram(name: "__gedf2", scope: !7, file: !7, line: 96, type: !183, scopeLine: 96, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !6, retainedNodes: !184)
!765 = !DILocation(line: 98, column: 31, scope: !764)
!766 = !DILocation(line: 98, column: 25, scope: !764)
!767 = !DILocation(line: 98, column: 18, scope: !764)
!768 = !DILocation(line: 99, column: 31, scope: !764)
!769 = !DILocation(line: 99, column: 25, scope: !764)
!770 = !DILocation(line: 99, column: 18, scope: !764)
!771 = !DILocation(line: 100, column: 24, scope: !764)
!772 = !DILocation(line: 100, column: 29, scope: !764)
!773 = !DILocation(line: 100, column: 17, scope: !764)
!774 = !DILocation(line: 101, column: 24, scope: !764)
!775 = !DILocation(line: 101, column: 29, scope: !764)
!776 = !DILocation(line: 101, column: 17, scope: !764)
!777 = !DILocation(line: 103, column: 9, scope: !764)
!778 = !DILocation(line: 103, column: 14, scope: !764)
!779 = !DILocation(line: 103, column: 23, scope: !764)
!780 = !DILocation(line: 103, column: 26, scope: !764)
!781 = !DILocation(line: 103, column: 31, scope: !764)
!782 = !DILocation(line: 103, column: 41, scope: !764)
!783 = !DILocation(line: 104, column: 10, scope: !764)
!784 = !DILocation(line: 104, column: 17, scope: !764)
!785 = !DILocation(line: 104, column: 15, scope: !764)
!786 = !DILocation(line: 104, column: 23, scope: !764)
!787 = !DILocation(line: 104, column: 9, scope: !764)
!788 = !DILocation(line: 104, column: 29, scope: !764)
!789 = !DILocation(line: 105, column: 10, scope: !764)
!790 = !DILocation(line: 105, column: 17, scope: !764)
!791 = !DILocation(line: 105, column: 15, scope: !764)
!792 = !DILocation(line: 105, column: 23, scope: !764)
!793 = !DILocation(line: 105, column: 9, scope: !764)
!794 = !DILocation(line: 106, column: 13, scope: !764)
!795 = !DILocation(line: 106, column: 20, scope: !764)
!796 = !DILocation(line: 106, column: 18, scope: !764)
!797 = !DILocation(line: 106, column: 26, scope: !764)
!798 = !DILocation(line: 107, column: 18, scope: !764)
!799 = !DILocation(line: 107, column: 26, scope: !764)
!800 = !DILocation(line: 107, column: 23, scope: !764)
!801 = !DILocation(line: 107, column: 32, scope: !764)
!802 = !DILocation(line: 108, column: 14, scope: !764)
!803 = !DILocation(line: 110, column: 13, scope: !764)
!804 = !DILocation(line: 110, column: 20, scope: !764)
!805 = !DILocation(line: 110, column: 18, scope: !764)
!806 = !DILocation(line: 110, column: 26, scope: !764)
!807 = !DILocation(line: 111, column: 18, scope: !764)
!808 = !DILocation(line: 111, column: 26, scope: !764)
!809 = !DILocation(line: 111, column: 23, scope: !764)
!810 = !DILocation(line: 111, column: 32, scope: !764)
!811 = !DILocation(line: 112, column: 14, scope: !764)
!812 = !DILocation(line: 114, column: 1, scope: !764)
!813 = distinct !DISubprogram(name: "__unorddf2", scope: !7, file: !7, line: 119, type: !183, scopeLine: 119, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !6, retainedNodes: !184)
!814 = !DILocation(line: 120, column: 30, scope: !813)
!815 = !DILocation(line: 120, column: 24, scope: !813)
!816 = !DILocation(line: 120, column: 33, scope: !813)
!817 = !DILocation(line: 120, column: 17, scope: !813)
!818 = !DILocation(line: 121, column: 30, scope: !813)
!819 = !DILocation(line: 121, column: 24, scope: !813)
!820 = !DILocation(line: 121, column: 33, scope: !813)
!821 = !DILocation(line: 121, column: 17, scope: !813)
!822 = !DILocation(line: 122, column: 12, scope: !813)
!823 = !DILocation(line: 122, column: 17, scope: !813)
!824 = !DILocation(line: 122, column: 26, scope: !813)
!825 = !DILocation(line: 122, column: 29, scope: !813)
!826 = !DILocation(line: 122, column: 34, scope: !813)
!827 = !DILocation(line: 122, column: 5, scope: !813)
!828 = distinct !DISubprogram(name: "__eqdf2", scope: !7, file: !7, line: 128, type: !183, scopeLine: 128, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !6, retainedNodes: !184)
!829 = !DILocation(line: 129, column: 20, scope: !828)
!830 = !DILocation(line: 129, column: 23, scope: !828)
!831 = !DILocation(line: 129, column: 12, scope: !828)
!832 = !DILocation(line: 129, column: 5, scope: !828)
!833 = distinct !DISubprogram(name: "__ltdf2", scope: !7, file: !7, line: 133, type: !183, scopeLine: 133, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !6, retainedNodes: !184)
!834 = !DILocation(line: 134, column: 20, scope: !833)
!835 = !DILocation(line: 134, column: 23, scope: !833)
!836 = !DILocation(line: 134, column: 12, scope: !833)
!837 = !DILocation(line: 134, column: 5, scope: !833)
!838 = distinct !DISubprogram(name: "__nedf2", scope: !7, file: !7, line: 138, type: !183, scopeLine: 138, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !6, retainedNodes: !184)
!839 = !DILocation(line: 139, column: 20, scope: !838)
!840 = !DILocation(line: 139, column: 23, scope: !838)
!841 = !DILocation(line: 139, column: 12, scope: !838)
!842 = !DILocation(line: 139, column: 5, scope: !838)
!843 = distinct !DISubprogram(name: "__gtdf2", scope: !7, file: !7, line: 143, type: !183, scopeLine: 143, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !6, retainedNodes: !184)
!844 = !DILocation(line: 144, column: 20, scope: !843)
!845 = !DILocation(line: 144, column: 23, scope: !843)
!846 = !DILocation(line: 144, column: 12, scope: !843)
!847 = !DILocation(line: 144, column: 5, scope: !843)
!848 = distinct !DISubprogram(name: "__lesf2", scope: !9, file: !9, line: 51, type: !183, scopeLine: 51, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !8, retainedNodes: !184)
!849 = !DILocation(line: 53, column: 31, scope: !848)
!850 = !DILocation(line: 53, column: 25, scope: !848)
!851 = !DILocation(line: 53, column: 18, scope: !848)
!852 = !DILocation(line: 54, column: 31, scope: !848)
!853 = !DILocation(line: 54, column: 25, scope: !848)
!854 = !DILocation(line: 54, column: 18, scope: !848)
!855 = !DILocation(line: 55, column: 24, scope: !848)
!856 = !DILocation(line: 55, column: 29, scope: !848)
!857 = !DILocation(line: 55, column: 17, scope: !848)
!858 = !DILocation(line: 56, column: 24, scope: !848)
!859 = !DILocation(line: 56, column: 29, scope: !848)
!860 = !DILocation(line: 56, column: 17, scope: !848)
!861 = !DILocation(line: 59, column: 9, scope: !848)
!862 = !DILocation(line: 59, column: 14, scope: !848)
!863 = !DILocation(line: 59, column: 23, scope: !848)
!864 = !DILocation(line: 59, column: 26, scope: !848)
!865 = !DILocation(line: 59, column: 31, scope: !848)
!866 = !DILocation(line: 59, column: 41, scope: !848)
!867 = !DILocation(line: 62, column: 10, scope: !848)
!868 = !DILocation(line: 62, column: 17, scope: !848)
!869 = !DILocation(line: 62, column: 15, scope: !848)
!870 = !DILocation(line: 62, column: 23, scope: !848)
!871 = !DILocation(line: 62, column: 9, scope: !848)
!872 = !DILocation(line: 62, column: 29, scope: !848)
!873 = !DILocation(line: 66, column: 10, scope: !848)
!874 = !DILocation(line: 66, column: 17, scope: !848)
!875 = !DILocation(line: 66, column: 15, scope: !848)
!876 = !DILocation(line: 66, column: 23, scope: !848)
!877 = !DILocation(line: 66, column: 9, scope: !848)
!878 = !DILocation(line: 67, column: 13, scope: !848)
!879 = !DILocation(line: 67, column: 20, scope: !848)
!880 = !DILocation(line: 67, column: 18, scope: !848)
!881 = !DILocation(line: 67, column: 26, scope: !848)
!882 = !DILocation(line: 68, column: 18, scope: !848)
!883 = !DILocation(line: 68, column: 26, scope: !848)
!884 = !DILocation(line: 68, column: 23, scope: !848)
!885 = !DILocation(line: 68, column: 32, scope: !848)
!886 = !DILocation(line: 69, column: 14, scope: !848)
!887 = !DILocation(line: 77, column: 13, scope: !848)
!888 = !DILocation(line: 77, column: 20, scope: !848)
!889 = !DILocation(line: 77, column: 18, scope: !848)
!890 = !DILocation(line: 77, column: 26, scope: !848)
!891 = !DILocation(line: 78, column: 18, scope: !848)
!892 = !DILocation(line: 78, column: 26, scope: !848)
!893 = !DILocation(line: 78, column: 23, scope: !848)
!894 = !DILocation(line: 78, column: 32, scope: !848)
!895 = !DILocation(line: 79, column: 14, scope: !848)
!896 = !DILocation(line: 81, column: 1, scope: !848)
!897 = distinct !DISubprogram(name: "toRep", scope: !417, file: !417, line: 231, type: !183, scopeLine: 231, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !8, retainedNodes: !184)
!898 = !DILocation(line: 232, column: 44, scope: !897)
!899 = !DILocation(line: 232, column: 50, scope: !897)
!900 = !DILocation(line: 233, column: 16, scope: !897)
!901 = !DILocation(line: 233, column: 5, scope: !897)
!902 = distinct !DISubprogram(name: "__gesf2", scope: !9, file: !9, line: 96, type: !183, scopeLine: 96, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !8, retainedNodes: !184)
!903 = !DILocation(line: 98, column: 31, scope: !902)
!904 = !DILocation(line: 98, column: 25, scope: !902)
!905 = !DILocation(line: 98, column: 18, scope: !902)
!906 = !DILocation(line: 99, column: 31, scope: !902)
!907 = !DILocation(line: 99, column: 25, scope: !902)
!908 = !DILocation(line: 99, column: 18, scope: !902)
!909 = !DILocation(line: 100, column: 24, scope: !902)
!910 = !DILocation(line: 100, column: 29, scope: !902)
!911 = !DILocation(line: 100, column: 17, scope: !902)
!912 = !DILocation(line: 101, column: 24, scope: !902)
!913 = !DILocation(line: 101, column: 29, scope: !902)
!914 = !DILocation(line: 101, column: 17, scope: !902)
!915 = !DILocation(line: 103, column: 9, scope: !902)
!916 = !DILocation(line: 103, column: 14, scope: !902)
!917 = !DILocation(line: 103, column: 23, scope: !902)
!918 = !DILocation(line: 103, column: 26, scope: !902)
!919 = !DILocation(line: 103, column: 31, scope: !902)
!920 = !DILocation(line: 103, column: 41, scope: !902)
!921 = !DILocation(line: 104, column: 10, scope: !902)
!922 = !DILocation(line: 104, column: 17, scope: !902)
!923 = !DILocation(line: 104, column: 15, scope: !902)
!924 = !DILocation(line: 104, column: 23, scope: !902)
!925 = !DILocation(line: 104, column: 9, scope: !902)
!926 = !DILocation(line: 104, column: 29, scope: !902)
!927 = !DILocation(line: 105, column: 10, scope: !902)
!928 = !DILocation(line: 105, column: 17, scope: !902)
!929 = !DILocation(line: 105, column: 15, scope: !902)
!930 = !DILocation(line: 105, column: 23, scope: !902)
!931 = !DILocation(line: 105, column: 9, scope: !902)
!932 = !DILocation(line: 106, column: 13, scope: !902)
!933 = !DILocation(line: 106, column: 20, scope: !902)
!934 = !DILocation(line: 106, column: 18, scope: !902)
!935 = !DILocation(line: 106, column: 26, scope: !902)
!936 = !DILocation(line: 107, column: 18, scope: !902)
!937 = !DILocation(line: 107, column: 26, scope: !902)
!938 = !DILocation(line: 107, column: 23, scope: !902)
!939 = !DILocation(line: 107, column: 32, scope: !902)
!940 = !DILocation(line: 108, column: 14, scope: !902)
!941 = !DILocation(line: 110, column: 13, scope: !902)
!942 = !DILocation(line: 110, column: 20, scope: !902)
!943 = !DILocation(line: 110, column: 18, scope: !902)
!944 = !DILocation(line: 110, column: 26, scope: !902)
!945 = !DILocation(line: 111, column: 18, scope: !902)
!946 = !DILocation(line: 111, column: 26, scope: !902)
!947 = !DILocation(line: 111, column: 23, scope: !902)
!948 = !DILocation(line: 111, column: 32, scope: !902)
!949 = !DILocation(line: 112, column: 14, scope: !902)
!950 = !DILocation(line: 114, column: 1, scope: !902)
!951 = distinct !DISubprogram(name: "__unordsf2", scope: !9, file: !9, line: 119, type: !183, scopeLine: 119, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !8, retainedNodes: !184)
!952 = !DILocation(line: 120, column: 30, scope: !951)
!953 = !DILocation(line: 120, column: 24, scope: !951)
!954 = !DILocation(line: 120, column: 33, scope: !951)
!955 = !DILocation(line: 120, column: 17, scope: !951)
!956 = !DILocation(line: 121, column: 30, scope: !951)
!957 = !DILocation(line: 121, column: 24, scope: !951)
!958 = !DILocation(line: 121, column: 33, scope: !951)
!959 = !DILocation(line: 121, column: 17, scope: !951)
!960 = !DILocation(line: 122, column: 12, scope: !951)
!961 = !DILocation(line: 122, column: 17, scope: !951)
!962 = !DILocation(line: 122, column: 26, scope: !951)
!963 = !DILocation(line: 122, column: 29, scope: !951)
!964 = !DILocation(line: 122, column: 34, scope: !951)
!965 = !DILocation(line: 122, column: 5, scope: !951)
!966 = distinct !DISubprogram(name: "__eqsf2", scope: !9, file: !9, line: 128, type: !183, scopeLine: 128, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !8, retainedNodes: !184)
!967 = !DILocation(line: 129, column: 20, scope: !966)
!968 = !DILocation(line: 129, column: 23, scope: !966)
!969 = !DILocation(line: 129, column: 12, scope: !966)
!970 = !DILocation(line: 129, column: 5, scope: !966)
!971 = distinct !DISubprogram(name: "__ltsf2", scope: !9, file: !9, line: 133, type: !183, scopeLine: 133, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !8, retainedNodes: !184)
!972 = !DILocation(line: 134, column: 20, scope: !971)
!973 = !DILocation(line: 134, column: 23, scope: !971)
!974 = !DILocation(line: 134, column: 12, scope: !971)
!975 = !DILocation(line: 134, column: 5, scope: !971)
!976 = distinct !DISubprogram(name: "__nesf2", scope: !9, file: !9, line: 138, type: !183, scopeLine: 138, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !8, retainedNodes: !184)
!977 = !DILocation(line: 139, column: 20, scope: !976)
!978 = !DILocation(line: 139, column: 23, scope: !976)
!979 = !DILocation(line: 139, column: 12, scope: !976)
!980 = !DILocation(line: 139, column: 5, scope: !976)
!981 = distinct !DISubprogram(name: "__gtsf2", scope: !9, file: !9, line: 143, type: !183, scopeLine: 143, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !8, retainedNodes: !184)
!982 = !DILocation(line: 144, column: 20, scope: !981)
!983 = !DILocation(line: 144, column: 23, scope: !981)
!984 = !DILocation(line: 144, column: 12, scope: !981)
!985 = !DILocation(line: 144, column: 5, scope: !981)
!986 = distinct !DISubprogram(name: "__divdf3", scope: !13, file: !13, line: 25, type: !183, scopeLine: 25, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !12, retainedNodes: !184)
!987 = !DILocation(line: 27, column: 42, scope: !986)
!988 = !DILocation(line: 27, column: 36, scope: !986)
!989 = !DILocation(line: 27, column: 45, scope: !986)
!990 = !DILocation(line: 27, column: 64, scope: !986)
!991 = !DILocation(line: 27, column: 24, scope: !986)
!992 = !DILocation(line: 28, column: 42, scope: !986)
!993 = !DILocation(line: 28, column: 36, scope: !986)
!994 = !DILocation(line: 28, column: 45, scope: !986)
!995 = !DILocation(line: 28, column: 64, scope: !986)
!996 = !DILocation(line: 28, column: 24, scope: !986)
!997 = !DILocation(line: 29, column: 39, scope: !986)
!998 = !DILocation(line: 29, column: 33, scope: !986)
!999 = !DILocation(line: 29, column: 50, scope: !986)
!1000 = !DILocation(line: 29, column: 44, scope: !986)
!1001 = !DILocation(line: 29, column: 42, scope: !986)
!1002 = !DILocation(line: 29, column: 54, scope: !986)
!1003 = !DILocation(line: 29, column: 17, scope: !986)
!1004 = !DILocation(line: 31, column: 32, scope: !986)
!1005 = !DILocation(line: 31, column: 26, scope: !986)
!1006 = !DILocation(line: 31, column: 35, scope: !986)
!1007 = !DILocation(line: 31, column: 11, scope: !986)
!1008 = !DILocation(line: 32, column: 32, scope: !986)
!1009 = !DILocation(line: 32, column: 26, scope: !986)
!1010 = !DILocation(line: 32, column: 35, scope: !986)
!1011 = !DILocation(line: 32, column: 11, scope: !986)
!1012 = !DILocation(line: 33, column: 9, scope: !986)
!1013 = !DILocation(line: 36, column: 9, scope: !986)
!1014 = !DILocation(line: 36, column: 18, scope: !986)
!1015 = !DILocation(line: 36, column: 22, scope: !986)
!1016 = !DILocation(line: 36, column: 40, scope: !986)
!1017 = !DILocation(line: 36, column: 43, scope: !986)
!1018 = !DILocation(line: 36, column: 52, scope: !986)
!1019 = !DILocation(line: 36, column: 56, scope: !986)
!1020 = !DILocation(line: 38, column: 34, scope: !986)
!1021 = !DILocation(line: 38, column: 28, scope: !986)
!1022 = !DILocation(line: 38, column: 37, scope: !986)
!1023 = !DILocation(line: 38, column: 21, scope: !986)
!1024 = !DILocation(line: 39, column: 34, scope: !986)
!1025 = !DILocation(line: 39, column: 28, scope: !986)
!1026 = !DILocation(line: 39, column: 37, scope: !986)
!1027 = !DILocation(line: 39, column: 21, scope: !986)
!1028 = !DILocation(line: 42, column: 13, scope: !986)
!1029 = !DILocation(line: 42, column: 18, scope: !986)
!1030 = !DILocation(line: 42, column: 49, scope: !986)
!1031 = !DILocation(line: 42, column: 43, scope: !986)
!1032 = !DILocation(line: 42, column: 52, scope: !986)
!1033 = !DILocation(line: 42, column: 35, scope: !986)
!1034 = !DILocation(line: 42, column: 28, scope: !986)
!1035 = !DILocation(line: 44, column: 13, scope: !986)
!1036 = !DILocation(line: 44, column: 18, scope: !986)
!1037 = !DILocation(line: 44, column: 49, scope: !986)
!1038 = !DILocation(line: 44, column: 43, scope: !986)
!1039 = !DILocation(line: 44, column: 52, scope: !986)
!1040 = !DILocation(line: 44, column: 35, scope: !986)
!1041 = !DILocation(line: 44, column: 28, scope: !986)
!1042 = !DILocation(line: 46, column: 13, scope: !986)
!1043 = !DILocation(line: 46, column: 18, scope: !986)
!1044 = !DILocation(line: 48, column: 17, scope: !986)
!1045 = !DILocation(line: 48, column: 22, scope: !986)
!1046 = !DILocation(line: 48, column: 40, scope: !986)
!1047 = !DILocation(line: 48, column: 33, scope: !986)
!1048 = !DILocation(line: 50, column: 33, scope: !986)
!1049 = !DILocation(line: 50, column: 40, scope: !986)
!1050 = !DILocation(line: 50, column: 38, scope: !986)
!1051 = !DILocation(line: 50, column: 25, scope: !986)
!1052 = !DILocation(line: 50, column: 18, scope: !986)
!1053 = !DILocation(line: 54, column: 13, scope: !986)
!1054 = !DILocation(line: 54, column: 18, scope: !986)
!1055 = !DILocation(line: 54, column: 44, scope: !986)
!1056 = !DILocation(line: 54, column: 36, scope: !986)
!1057 = !DILocation(line: 54, column: 29, scope: !986)
!1058 = !DILocation(line: 56, column: 14, scope: !986)
!1059 = !DILocation(line: 56, column: 13, scope: !986)
!1060 = !DILocation(line: 58, column: 18, scope: !986)
!1061 = !DILocation(line: 58, column: 17, scope: !986)
!1062 = !DILocation(line: 58, column: 31, scope: !986)
!1063 = !DILocation(line: 58, column: 24, scope: !986)
!1064 = !DILocation(line: 60, column: 33, scope: !986)
!1065 = !DILocation(line: 60, column: 25, scope: !986)
!1066 = !DILocation(line: 60, column: 18, scope: !986)
!1067 = !DILocation(line: 63, column: 14, scope: !986)
!1068 = !DILocation(line: 63, column: 13, scope: !986)
!1069 = !DILocation(line: 63, column: 44, scope: !986)
!1070 = !DILocation(line: 63, column: 42, scope: !986)
!1071 = !DILocation(line: 63, column: 27, scope: !986)
!1072 = !DILocation(line: 63, column: 20, scope: !986)
!1073 = !DILocation(line: 68, column: 13, scope: !986)
!1074 = !DILocation(line: 68, column: 18, scope: !986)
!1075 = !DILocation(line: 68, column: 42, scope: !986)
!1076 = !DILocation(line: 68, column: 39, scope: !986)
!1077 = !DILocation(line: 68, column: 33, scope: !986)
!1078 = !DILocation(line: 69, column: 13, scope: !986)
!1079 = !DILocation(line: 69, column: 18, scope: !986)
!1080 = !DILocation(line: 69, column: 42, scope: !986)
!1081 = !DILocation(line: 69, column: 39, scope: !986)
!1082 = !DILocation(line: 69, column: 33, scope: !986)
!1083 = !DILocation(line: 70, column: 5, scope: !986)
!1084 = !DILocation(line: 75, column: 18, scope: !986)
!1085 = !DILocation(line: 76, column: 18, scope: !986)
!1086 = !DILocation(line: 77, column: 28, scope: !986)
!1087 = !DILocation(line: 77, column: 40, scope: !986)
!1088 = !DILocation(line: 77, column: 38, scope: !986)
!1089 = !DILocation(line: 77, column: 52, scope: !986)
!1090 = !DILocation(line: 77, column: 50, scope: !986)
!1091 = !DILocation(line: 77, column: 9, scope: !986)
!1092 = !DILocation(line: 83, column: 27, scope: !986)
!1093 = !DILocation(line: 83, column: 40, scope: !986)
!1094 = !DILocation(line: 83, column: 20, scope: !986)
!1095 = !DILocation(line: 84, column: 47, scope: !986)
!1096 = !DILocation(line: 84, column: 45, scope: !986)
!1097 = !DILocation(line: 84, column: 14, scope: !986)
!1098 = !DILocation(line: 94, column: 32, scope: !986)
!1099 = !DILocation(line: 94, column: 22, scope: !986)
!1100 = !DILocation(line: 94, column: 42, scope: !986)
!1101 = !DILocation(line: 94, column: 40, scope: !986)
!1102 = !DILocation(line: 94, column: 47, scope: !986)
!1103 = !DILocation(line: 94, column: 20, scope: !986)
!1104 = !DILocation(line: 94, column: 18, scope: !986)
!1105 = !DILocation(line: 95, column: 25, scope: !986)
!1106 = !DILocation(line: 95, column: 15, scope: !986)
!1107 = !DILocation(line: 95, column: 35, scope: !986)
!1108 = !DILocation(line: 95, column: 33, scope: !986)
!1109 = !DILocation(line: 95, column: 48, scope: !986)
!1110 = !DILocation(line: 95, column: 13, scope: !986)
!1111 = !DILocation(line: 96, column: 32, scope: !986)
!1112 = !DILocation(line: 96, column: 22, scope: !986)
!1113 = !DILocation(line: 96, column: 42, scope: !986)
!1114 = !DILocation(line: 96, column: 40, scope: !986)
!1115 = !DILocation(line: 96, column: 47, scope: !986)
!1116 = !DILocation(line: 96, column: 20, scope: !986)
!1117 = !DILocation(line: 96, column: 18, scope: !986)
!1118 = !DILocation(line: 97, column: 25, scope: !986)
!1119 = !DILocation(line: 97, column: 15, scope: !986)
!1120 = !DILocation(line: 97, column: 35, scope: !986)
!1121 = !DILocation(line: 97, column: 33, scope: !986)
!1122 = !DILocation(line: 97, column: 48, scope: !986)
!1123 = !DILocation(line: 97, column: 13, scope: !986)
!1124 = !DILocation(line: 98, column: 32, scope: !986)
!1125 = !DILocation(line: 98, column: 22, scope: !986)
!1126 = !DILocation(line: 98, column: 42, scope: !986)
!1127 = !DILocation(line: 98, column: 40, scope: !986)
!1128 = !DILocation(line: 98, column: 47, scope: !986)
!1129 = !DILocation(line: 98, column: 20, scope: !986)
!1130 = !DILocation(line: 98, column: 18, scope: !986)
!1131 = !DILocation(line: 99, column: 25, scope: !986)
!1132 = !DILocation(line: 99, column: 15, scope: !986)
!1133 = !DILocation(line: 99, column: 35, scope: !986)
!1134 = !DILocation(line: 99, column: 33, scope: !986)
!1135 = !DILocation(line: 99, column: 48, scope: !986)
!1136 = !DILocation(line: 99, column: 13, scope: !986)
!1137 = !DILocation(line: 105, column: 12, scope: !986)
!1138 = !DILocation(line: 109, column: 29, scope: !986)
!1139 = !DILocation(line: 109, column: 42, scope: !986)
!1140 = !DILocation(line: 109, column: 20, scope: !986)
!1141 = !DILocation(line: 111, column: 30, scope: !986)
!1142 = !DILocation(line: 111, column: 20, scope: !986)
!1143 = !DILocation(line: 111, column: 38, scope: !986)
!1144 = !DILocation(line: 111, column: 37, scope: !986)
!1145 = !DILocation(line: 111, column: 56, scope: !986)
!1146 = !DILocation(line: 111, column: 46, scope: !986)
!1147 = !DILocation(line: 111, column: 64, scope: !986)
!1148 = !DILocation(line: 111, column: 63, scope: !986)
!1149 = !DILocation(line: 111, column: 71, scope: !986)
!1150 = !DILocation(line: 111, column: 43, scope: !986)
!1151 = !DILocation(line: 111, column: 18, scope: !986)
!1152 = !DILocation(line: 111, column: 16, scope: !986)
!1153 = !DILocation(line: 112, column: 20, scope: !986)
!1154 = !DILocation(line: 112, column: 31, scope: !986)
!1155 = !DILocation(line: 112, column: 14, scope: !986)
!1156 = !DILocation(line: 113, column: 20, scope: !986)
!1157 = !DILocation(line: 113, column: 14, scope: !986)
!1158 = !DILocation(line: 114, column: 28, scope: !986)
!1159 = !DILocation(line: 114, column: 18, scope: !986)
!1160 = !DILocation(line: 114, column: 36, scope: !986)
!1161 = !DILocation(line: 114, column: 35, scope: !986)
!1162 = !DILocation(line: 114, column: 53, scope: !986)
!1163 = !DILocation(line: 114, column: 43, scope: !986)
!1164 = !DILocation(line: 114, column: 61, scope: !986)
!1165 = !DILocation(line: 114, column: 60, scope: !986)
!1166 = !DILocation(line: 114, column: 65, scope: !986)
!1167 = !DILocation(line: 114, column: 40, scope: !986)
!1168 = !DILocation(line: 114, column: 16, scope: !986)
!1169 = !DILocation(line: 121, column: 16, scope: !986)
!1170 = !DILocation(line: 136, column: 18, scope: !986)
!1171 = !DILocation(line: 136, column: 31, scope: !986)
!1172 = !DILocation(line: 136, column: 37, scope: !986)
!1173 = !DILocation(line: 136, column: 5, scope: !986)
!1174 = !DILocation(line: 152, column: 9, scope: !986)
!1175 = !DILocation(line: 152, column: 18, scope: !986)
!1176 = !DILocation(line: 153, column: 21, scope: !986)
!1177 = !DILocation(line: 153, column: 34, scope: !986)
!1178 = !DILocation(line: 153, column: 43, scope: !986)
!1179 = !DILocation(line: 153, column: 54, scope: !986)
!1180 = !DILocation(line: 153, column: 52, scope: !986)
!1181 = !DILocation(line: 153, column: 41, scope: !986)
!1182 = !DILocation(line: 153, column: 18, scope: !986)
!1183 = !DILocation(line: 154, column: 25, scope: !986)
!1184 = !DILocation(line: 155, column: 5, scope: !986)
!1185 = !DILocation(line: 156, column: 18, scope: !986)
!1186 = !DILocation(line: 157, column: 21, scope: !986)
!1187 = !DILocation(line: 157, column: 34, scope: !986)
!1188 = !DILocation(line: 157, column: 43, scope: !986)
!1189 = !DILocation(line: 157, column: 54, scope: !986)
!1190 = !DILocation(line: 157, column: 52, scope: !986)
!1191 = !DILocation(line: 157, column: 41, scope: !986)
!1192 = !DILocation(line: 157, column: 18, scope: !986)
!1193 = !DILocation(line: 160, column: 33, scope: !986)
!1194 = !DILocation(line: 160, column: 50, scope: !986)
!1195 = !DILocation(line: 160, column: 15, scope: !986)
!1196 = !DILocation(line: 162, column: 9, scope: !986)
!1197 = !DILocation(line: 162, column: 25, scope: !986)
!1198 = !DILocation(line: 164, column: 33, scope: !986)
!1199 = !DILocation(line: 164, column: 31, scope: !986)
!1200 = !DILocation(line: 164, column: 16, scope: !986)
!1201 = !DILocation(line: 164, column: 9, scope: !986)
!1202 = !DILocation(line: 167, column: 14, scope: !986)
!1203 = !DILocation(line: 167, column: 30, scope: !986)
!1204 = !DILocation(line: 170, column: 24, scope: !986)
!1205 = !DILocation(line: 170, column: 16, scope: !986)
!1206 = !DILocation(line: 170, column: 9, scope: !986)
!1207 = !DILocation(line: 174, column: 29, scope: !986)
!1208 = !DILocation(line: 174, column: 38, scope: !986)
!1209 = !DILocation(line: 174, column: 46, scope: !986)
!1210 = !DILocation(line: 174, column: 44, scope: !986)
!1211 = !DILocation(line: 174, column: 20, scope: !986)
!1212 = !DILocation(line: 176, column: 27, scope: !986)
!1213 = !DILocation(line: 176, column: 36, scope: !986)
!1214 = !DILocation(line: 176, column: 15, scope: !986)
!1215 = !DILocation(line: 178, column: 29, scope: !986)
!1216 = !DILocation(line: 178, column: 22, scope: !986)
!1217 = !DILocation(line: 178, column: 45, scope: !986)
!1218 = !DILocation(line: 178, column: 19, scope: !986)
!1219 = !DILocation(line: 180, column: 22, scope: !986)
!1220 = !DILocation(line: 180, column: 19, scope: !986)
!1221 = !DILocation(line: 182, column: 39, scope: !986)
!1222 = !DILocation(line: 182, column: 51, scope: !986)
!1223 = !DILocation(line: 182, column: 49, scope: !986)
!1224 = !DILocation(line: 182, column: 31, scope: !986)
!1225 = !DILocation(line: 182, column: 22, scope: !986)
!1226 = !DILocation(line: 183, column: 16, scope: !986)
!1227 = !DILocation(line: 183, column: 9, scope: !986)
!1228 = !DILocation(line: 185, column: 1, scope: !986)
!1229 = distinct !DISubprogram(name: "toRep", scope: !417, file: !417, line: 231, type: !183, scopeLine: 231, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !12, retainedNodes: !184)
!1230 = !DILocation(line: 232, column: 44, scope: !1229)
!1231 = !DILocation(line: 232, column: 50, scope: !1229)
!1232 = !DILocation(line: 233, column: 16, scope: !1229)
!1233 = !DILocation(line: 233, column: 5, scope: !1229)
!1234 = distinct !DISubprogram(name: "fromRep", scope: !417, file: !417, line: 236, type: !183, scopeLine: 236, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !12, retainedNodes: !184)
!1235 = !DILocation(line: 237, column: 44, scope: !1234)
!1236 = !DILocation(line: 237, column: 50, scope: !1234)
!1237 = !DILocation(line: 238, column: 16, scope: !1234)
!1238 = !DILocation(line: 238, column: 5, scope: !1234)
!1239 = distinct !DISubprogram(name: "normalize", scope: !417, file: !417, line: 241, type: !183, scopeLine: 241, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !12, retainedNodes: !184)
!1240 = !DILocation(line: 242, column: 32, scope: !1239)
!1241 = !DILocation(line: 242, column: 31, scope: !1239)
!1242 = !DILocation(line: 242, column: 23, scope: !1239)
!1243 = !DILocation(line: 242, column: 47, scope: !1239)
!1244 = !DILocation(line: 242, column: 45, scope: !1239)
!1245 = !DILocation(line: 242, column: 15, scope: !1239)
!1246 = !DILocation(line: 243, column: 22, scope: !1239)
!1247 = !DILocation(line: 243, column: 6, scope: !1239)
!1248 = !DILocation(line: 243, column: 18, scope: !1239)
!1249 = !DILocation(line: 244, column: 16, scope: !1239)
!1250 = !DILocation(line: 244, column: 14, scope: !1239)
!1251 = !DILocation(line: 244, column: 5, scope: !1239)
!1252 = distinct !DISubprogram(name: "wideMultiply", scope: !417, file: !417, line: 86, type: !183, scopeLine: 86, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !12, retainedNodes: !184)
!1253 = !DILocation(line: 88, column: 28, scope: !1252)
!1254 = !DILocation(line: 88, column: 40, scope: !1252)
!1255 = !DILocation(line: 88, column: 38, scope: !1252)
!1256 = !DILocation(line: 88, column: 20, scope: !1252)
!1257 = !DILocation(line: 89, column: 28, scope: !1252)
!1258 = !DILocation(line: 89, column: 40, scope: !1252)
!1259 = !DILocation(line: 89, column: 38, scope: !1252)
!1260 = !DILocation(line: 89, column: 20, scope: !1252)
!1261 = !DILocation(line: 90, column: 28, scope: !1252)
!1262 = !DILocation(line: 90, column: 40, scope: !1252)
!1263 = !DILocation(line: 90, column: 38, scope: !1252)
!1264 = !DILocation(line: 90, column: 20, scope: !1252)
!1265 = !DILocation(line: 91, column: 28, scope: !1252)
!1266 = !DILocation(line: 91, column: 40, scope: !1252)
!1267 = !DILocation(line: 91, column: 38, scope: !1252)
!1268 = !DILocation(line: 91, column: 20, scope: !1252)
!1269 = !DILocation(line: 93, column: 25, scope: !1252)
!1270 = !DILocation(line: 93, column: 20, scope: !1252)
!1271 = !DILocation(line: 94, column: 25, scope: !1252)
!1272 = !DILocation(line: 94, column: 41, scope: !1252)
!1273 = !DILocation(line: 94, column: 39, scope: !1252)
!1274 = !DILocation(line: 94, column: 57, scope: !1252)
!1275 = !DILocation(line: 94, column: 55, scope: !1252)
!1276 = !DILocation(line: 94, column: 20, scope: !1252)
!1277 = !DILocation(line: 95, column: 11, scope: !1252)
!1278 = !DILocation(line: 95, column: 17, scope: !1252)
!1279 = !DILocation(line: 95, column: 20, scope: !1252)
!1280 = !DILocation(line: 95, column: 14, scope: !1252)
!1281 = !DILocation(line: 95, column: 6, scope: !1252)
!1282 = !DILocation(line: 95, column: 9, scope: !1252)
!1283 = !DILocation(line: 97, column: 11, scope: !1252)
!1284 = !DILocation(line: 97, column: 27, scope: !1252)
!1285 = !DILocation(line: 97, column: 25, scope: !1252)
!1286 = !DILocation(line: 97, column: 43, scope: !1252)
!1287 = !DILocation(line: 97, column: 41, scope: !1252)
!1288 = !DILocation(line: 97, column: 56, scope: !1252)
!1289 = !DILocation(line: 97, column: 54, scope: !1252)
!1290 = !DILocation(line: 97, column: 6, scope: !1252)
!1291 = !DILocation(line: 97, column: 9, scope: !1252)
!1292 = !DILocation(line: 98, column: 1, scope: !1252)
!1293 = distinct !DISubprogram(name: "rep_clz", scope: !417, file: !417, line: 69, type: !183, scopeLine: 69, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !12, retainedNodes: !184)
!1294 = !DILocation(line: 73, column: 9, scope: !1293)
!1295 = !DILocation(line: 73, column: 11, scope: !1293)
!1296 = !DILocation(line: 74, column: 30, scope: !1293)
!1297 = !DILocation(line: 74, column: 32, scope: !1293)
!1298 = !DILocation(line: 74, column: 16, scope: !1293)
!1299 = !DILocation(line: 74, column: 9, scope: !1293)
!1300 = !DILocation(line: 76, column: 35, scope: !1293)
!1301 = !DILocation(line: 76, column: 37, scope: !1293)
!1302 = !DILocation(line: 76, column: 21, scope: !1293)
!1303 = !DILocation(line: 76, column: 19, scope: !1293)
!1304 = !DILocation(line: 76, column: 9, scope: !1293)
!1305 = !DILocation(line: 78, column: 1, scope: !1293)
!1306 = distinct !DISubprogram(name: "__divsf3", scope: !15, file: !15, line: 25, type: !183, scopeLine: 25, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !14, retainedNodes: !184)
!1307 = !DILocation(line: 27, column: 42, scope: !1306)
!1308 = !DILocation(line: 27, column: 36, scope: !1306)
!1309 = !DILocation(line: 27, column: 45, scope: !1306)
!1310 = !DILocation(line: 27, column: 64, scope: !1306)
!1311 = !DILocation(line: 27, column: 24, scope: !1306)
!1312 = !DILocation(line: 28, column: 42, scope: !1306)
!1313 = !DILocation(line: 28, column: 36, scope: !1306)
!1314 = !DILocation(line: 28, column: 45, scope: !1306)
!1315 = !DILocation(line: 28, column: 64, scope: !1306)
!1316 = !DILocation(line: 28, column: 24, scope: !1306)
!1317 = !DILocation(line: 29, column: 39, scope: !1306)
!1318 = !DILocation(line: 29, column: 33, scope: !1306)
!1319 = !DILocation(line: 29, column: 50, scope: !1306)
!1320 = !DILocation(line: 29, column: 44, scope: !1306)
!1321 = !DILocation(line: 29, column: 42, scope: !1306)
!1322 = !DILocation(line: 29, column: 54, scope: !1306)
!1323 = !DILocation(line: 29, column: 17, scope: !1306)
!1324 = !DILocation(line: 31, column: 32, scope: !1306)
!1325 = !DILocation(line: 31, column: 26, scope: !1306)
!1326 = !DILocation(line: 31, column: 35, scope: !1306)
!1327 = !DILocation(line: 31, column: 11, scope: !1306)
!1328 = !DILocation(line: 32, column: 32, scope: !1306)
!1329 = !DILocation(line: 32, column: 26, scope: !1306)
!1330 = !DILocation(line: 32, column: 35, scope: !1306)
!1331 = !DILocation(line: 32, column: 11, scope: !1306)
!1332 = !DILocation(line: 33, column: 9, scope: !1306)
!1333 = !DILocation(line: 36, column: 9, scope: !1306)
!1334 = !DILocation(line: 36, column: 18, scope: !1306)
!1335 = !DILocation(line: 36, column: 22, scope: !1306)
!1336 = !DILocation(line: 36, column: 40, scope: !1306)
!1337 = !DILocation(line: 36, column: 43, scope: !1306)
!1338 = !DILocation(line: 36, column: 52, scope: !1306)
!1339 = !DILocation(line: 36, column: 56, scope: !1306)
!1340 = !DILocation(line: 38, column: 34, scope: !1306)
!1341 = !DILocation(line: 38, column: 28, scope: !1306)
!1342 = !DILocation(line: 38, column: 37, scope: !1306)
!1343 = !DILocation(line: 38, column: 21, scope: !1306)
!1344 = !DILocation(line: 39, column: 34, scope: !1306)
!1345 = !DILocation(line: 39, column: 28, scope: !1306)
!1346 = !DILocation(line: 39, column: 37, scope: !1306)
!1347 = !DILocation(line: 39, column: 21, scope: !1306)
!1348 = !DILocation(line: 42, column: 13, scope: !1306)
!1349 = !DILocation(line: 42, column: 18, scope: !1306)
!1350 = !DILocation(line: 42, column: 49, scope: !1306)
!1351 = !DILocation(line: 42, column: 43, scope: !1306)
!1352 = !DILocation(line: 42, column: 52, scope: !1306)
!1353 = !DILocation(line: 42, column: 35, scope: !1306)
!1354 = !DILocation(line: 42, column: 28, scope: !1306)
!1355 = !DILocation(line: 44, column: 13, scope: !1306)
!1356 = !DILocation(line: 44, column: 18, scope: !1306)
!1357 = !DILocation(line: 44, column: 49, scope: !1306)
!1358 = !DILocation(line: 44, column: 43, scope: !1306)
!1359 = !DILocation(line: 44, column: 52, scope: !1306)
!1360 = !DILocation(line: 44, column: 35, scope: !1306)
!1361 = !DILocation(line: 44, column: 28, scope: !1306)
!1362 = !DILocation(line: 46, column: 13, scope: !1306)
!1363 = !DILocation(line: 46, column: 18, scope: !1306)
!1364 = !DILocation(line: 48, column: 17, scope: !1306)
!1365 = !DILocation(line: 48, column: 22, scope: !1306)
!1366 = !DILocation(line: 48, column: 40, scope: !1306)
!1367 = !DILocation(line: 48, column: 33, scope: !1306)
!1368 = !DILocation(line: 50, column: 33, scope: !1306)
!1369 = !DILocation(line: 50, column: 40, scope: !1306)
!1370 = !DILocation(line: 50, column: 38, scope: !1306)
!1371 = !DILocation(line: 50, column: 25, scope: !1306)
!1372 = !DILocation(line: 50, column: 18, scope: !1306)
!1373 = !DILocation(line: 54, column: 13, scope: !1306)
!1374 = !DILocation(line: 54, column: 18, scope: !1306)
!1375 = !DILocation(line: 54, column: 44, scope: !1306)
!1376 = !DILocation(line: 54, column: 36, scope: !1306)
!1377 = !DILocation(line: 54, column: 29, scope: !1306)
!1378 = !DILocation(line: 56, column: 14, scope: !1306)
!1379 = !DILocation(line: 56, column: 13, scope: !1306)
!1380 = !DILocation(line: 58, column: 18, scope: !1306)
!1381 = !DILocation(line: 58, column: 17, scope: !1306)
!1382 = !DILocation(line: 58, column: 31, scope: !1306)
!1383 = !DILocation(line: 58, column: 24, scope: !1306)
!1384 = !DILocation(line: 60, column: 33, scope: !1306)
!1385 = !DILocation(line: 60, column: 25, scope: !1306)
!1386 = !DILocation(line: 60, column: 18, scope: !1306)
!1387 = !DILocation(line: 63, column: 14, scope: !1306)
!1388 = !DILocation(line: 63, column: 13, scope: !1306)
!1389 = !DILocation(line: 63, column: 44, scope: !1306)
!1390 = !DILocation(line: 63, column: 42, scope: !1306)
!1391 = !DILocation(line: 63, column: 27, scope: !1306)
!1392 = !DILocation(line: 63, column: 20, scope: !1306)
!1393 = !DILocation(line: 68, column: 13, scope: !1306)
!1394 = !DILocation(line: 68, column: 18, scope: !1306)
!1395 = !DILocation(line: 68, column: 42, scope: !1306)
!1396 = !DILocation(line: 68, column: 39, scope: !1306)
!1397 = !DILocation(line: 68, column: 33, scope: !1306)
!1398 = !DILocation(line: 69, column: 13, scope: !1306)
!1399 = !DILocation(line: 69, column: 18, scope: !1306)
!1400 = !DILocation(line: 69, column: 42, scope: !1306)
!1401 = !DILocation(line: 69, column: 39, scope: !1306)
!1402 = !DILocation(line: 69, column: 33, scope: !1306)
!1403 = !DILocation(line: 70, column: 5, scope: !1306)
!1404 = !DILocation(line: 75, column: 18, scope: !1306)
!1405 = !DILocation(line: 76, column: 18, scope: !1306)
!1406 = !DILocation(line: 77, column: 28, scope: !1306)
!1407 = !DILocation(line: 77, column: 40, scope: !1306)
!1408 = !DILocation(line: 77, column: 38, scope: !1306)
!1409 = !DILocation(line: 77, column: 52, scope: !1306)
!1410 = !DILocation(line: 77, column: 50, scope: !1306)
!1411 = !DILocation(line: 77, column: 9, scope: !1306)
!1412 = !DILocation(line: 83, column: 21, scope: !1306)
!1413 = !DILocation(line: 83, column: 34, scope: !1306)
!1414 = !DILocation(line: 83, column: 14, scope: !1306)
!1415 = !DILocation(line: 84, column: 50, scope: !1306)
!1416 = !DILocation(line: 84, column: 48, scope: !1306)
!1417 = !DILocation(line: 84, column: 14, scope: !1306)
!1418 = !DILocation(line: 94, column: 30, scope: !1306)
!1419 = !DILocation(line: 94, column: 20, scope: !1306)
!1420 = !DILocation(line: 94, column: 43, scope: !1306)
!1421 = !DILocation(line: 94, column: 41, scope: !1306)
!1422 = !DILocation(line: 94, column: 48, scope: !1306)
!1423 = !DILocation(line: 94, column: 18, scope: !1306)
!1424 = !DILocation(line: 94, column: 16, scope: !1306)
!1425 = !DILocation(line: 95, column: 28, scope: !1306)
!1426 = !DILocation(line: 95, column: 18, scope: !1306)
!1427 = !DILocation(line: 95, column: 41, scope: !1306)
!1428 = !DILocation(line: 95, column: 39, scope: !1306)
!1429 = !DILocation(line: 95, column: 52, scope: !1306)
!1430 = !DILocation(line: 95, column: 16, scope: !1306)
!1431 = !DILocation(line: 96, column: 30, scope: !1306)
!1432 = !DILocation(line: 96, column: 20, scope: !1306)
!1433 = !DILocation(line: 96, column: 43, scope: !1306)
!1434 = !DILocation(line: 96, column: 41, scope: !1306)
!1435 = !DILocation(line: 96, column: 48, scope: !1306)
!1436 = !DILocation(line: 96, column: 18, scope: !1306)
!1437 = !DILocation(line: 96, column: 16, scope: !1306)
!1438 = !DILocation(line: 97, column: 28, scope: !1306)
!1439 = !DILocation(line: 97, column: 18, scope: !1306)
!1440 = !DILocation(line: 97, column: 41, scope: !1306)
!1441 = !DILocation(line: 97, column: 39, scope: !1306)
!1442 = !DILocation(line: 97, column: 52, scope: !1306)
!1443 = !DILocation(line: 97, column: 16, scope: !1306)
!1444 = !DILocation(line: 98, column: 30, scope: !1306)
!1445 = !DILocation(line: 98, column: 20, scope: !1306)
!1446 = !DILocation(line: 98, column: 43, scope: !1306)
!1447 = !DILocation(line: 98, column: 41, scope: !1306)
!1448 = !DILocation(line: 98, column: 48, scope: !1306)
!1449 = !DILocation(line: 98, column: 18, scope: !1306)
!1450 = !DILocation(line: 98, column: 16, scope: !1306)
!1451 = !DILocation(line: 99, column: 28, scope: !1306)
!1452 = !DILocation(line: 99, column: 18, scope: !1306)
!1453 = !DILocation(line: 99, column: 41, scope: !1306)
!1454 = !DILocation(line: 99, column: 39, scope: !1306)
!1455 = !DILocation(line: 99, column: 52, scope: !1306)
!1456 = !DILocation(line: 99, column: 16, scope: !1306)
!1457 = !DILocation(line: 107, column: 16, scope: !1306)
!1458 = !DILocation(line: 121, column: 32, scope: !1306)
!1459 = !DILocation(line: 121, column: 22, scope: !1306)
!1460 = !DILocation(line: 121, column: 44, scope: !1306)
!1461 = !DILocation(line: 121, column: 57, scope: !1306)
!1462 = !DILocation(line: 121, column: 43, scope: !1306)
!1463 = !DILocation(line: 121, column: 42, scope: !1306)
!1464 = !DILocation(line: 121, column: 63, scope: !1306)
!1465 = !DILocation(line: 121, column: 11, scope: !1306)
!1466 = !DILocation(line: 137, column: 9, scope: !1306)
!1467 = !DILocation(line: 137, column: 18, scope: !1306)
!1468 = !DILocation(line: 138, column: 21, scope: !1306)
!1469 = !DILocation(line: 138, column: 34, scope: !1306)
!1470 = !DILocation(line: 138, column: 43, scope: !1306)
!1471 = !DILocation(line: 138, column: 54, scope: !1306)
!1472 = !DILocation(line: 138, column: 52, scope: !1306)
!1473 = !DILocation(line: 138, column: 41, scope: !1306)
!1474 = !DILocation(line: 138, column: 18, scope: !1306)
!1475 = !DILocation(line: 139, column: 25, scope: !1306)
!1476 = !DILocation(line: 140, column: 5, scope: !1306)
!1477 = !DILocation(line: 141, column: 18, scope: !1306)
!1478 = !DILocation(line: 142, column: 21, scope: !1306)
!1479 = !DILocation(line: 142, column: 34, scope: !1306)
!1480 = !DILocation(line: 142, column: 43, scope: !1306)
!1481 = !DILocation(line: 142, column: 54, scope: !1306)
!1482 = !DILocation(line: 142, column: 52, scope: !1306)
!1483 = !DILocation(line: 142, column: 41, scope: !1306)
!1484 = !DILocation(line: 142, column: 18, scope: !1306)
!1485 = !DILocation(line: 145, column: 33, scope: !1306)
!1486 = !DILocation(line: 145, column: 50, scope: !1306)
!1487 = !DILocation(line: 145, column: 15, scope: !1306)
!1488 = !DILocation(line: 147, column: 9, scope: !1306)
!1489 = !DILocation(line: 147, column: 25, scope: !1306)
!1490 = !DILocation(line: 149, column: 33, scope: !1306)
!1491 = !DILocation(line: 149, column: 31, scope: !1306)
!1492 = !DILocation(line: 149, column: 16, scope: !1306)
!1493 = !DILocation(line: 149, column: 9, scope: !1306)
!1494 = !DILocation(line: 152, column: 14, scope: !1306)
!1495 = !DILocation(line: 152, column: 30, scope: !1306)
!1496 = !DILocation(line: 155, column: 24, scope: !1306)
!1497 = !DILocation(line: 155, column: 16, scope: !1306)
!1498 = !DILocation(line: 155, column: 9, scope: !1306)
!1499 = !DILocation(line: 159, column: 29, scope: !1306)
!1500 = !DILocation(line: 159, column: 38, scope: !1306)
!1501 = !DILocation(line: 159, column: 46, scope: !1306)
!1502 = !DILocation(line: 159, column: 44, scope: !1306)
!1503 = !DILocation(line: 159, column: 20, scope: !1306)
!1504 = !DILocation(line: 161, column: 27, scope: !1306)
!1505 = !DILocation(line: 161, column: 36, scope: !1306)
!1506 = !DILocation(line: 161, column: 15, scope: !1306)
!1507 = !DILocation(line: 163, column: 29, scope: !1306)
!1508 = !DILocation(line: 163, column: 45, scope: !1306)
!1509 = !DILocation(line: 163, column: 19, scope: !1306)
!1510 = !DILocation(line: 165, column: 22, scope: !1306)
!1511 = !DILocation(line: 165, column: 19, scope: !1306)
!1512 = !DILocation(line: 167, column: 24, scope: !1306)
!1513 = !DILocation(line: 167, column: 36, scope: !1306)
!1514 = !DILocation(line: 167, column: 34, scope: !1306)
!1515 = !DILocation(line: 167, column: 16, scope: !1306)
!1516 = !DILocation(line: 167, column: 9, scope: !1306)
!1517 = !DILocation(line: 169, column: 1, scope: !1306)
!1518 = distinct !DISubprogram(name: "toRep", scope: !417, file: !417, line: 231, type: !183, scopeLine: 231, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !14, retainedNodes: !184)
!1519 = !DILocation(line: 232, column: 44, scope: !1518)
!1520 = !DILocation(line: 232, column: 50, scope: !1518)
!1521 = !DILocation(line: 233, column: 16, scope: !1518)
!1522 = !DILocation(line: 233, column: 5, scope: !1518)
!1523 = distinct !DISubprogram(name: "fromRep", scope: !417, file: !417, line: 236, type: !183, scopeLine: 236, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !14, retainedNodes: !184)
!1524 = !DILocation(line: 237, column: 44, scope: !1523)
!1525 = !DILocation(line: 237, column: 50, scope: !1523)
!1526 = !DILocation(line: 238, column: 16, scope: !1523)
!1527 = !DILocation(line: 238, column: 5, scope: !1523)
!1528 = distinct !DISubprogram(name: "normalize", scope: !417, file: !417, line: 241, type: !183, scopeLine: 241, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !14, retainedNodes: !184)
!1529 = !DILocation(line: 242, column: 32, scope: !1528)
!1530 = !DILocation(line: 242, column: 31, scope: !1528)
!1531 = !DILocation(line: 242, column: 23, scope: !1528)
!1532 = !DILocation(line: 242, column: 47, scope: !1528)
!1533 = !DILocation(line: 242, column: 45, scope: !1528)
!1534 = !DILocation(line: 242, column: 15, scope: !1528)
!1535 = !DILocation(line: 243, column: 22, scope: !1528)
!1536 = !DILocation(line: 243, column: 6, scope: !1528)
!1537 = !DILocation(line: 243, column: 18, scope: !1528)
!1538 = !DILocation(line: 244, column: 16, scope: !1528)
!1539 = !DILocation(line: 244, column: 14, scope: !1528)
!1540 = !DILocation(line: 244, column: 5, scope: !1528)
!1541 = distinct !DISubprogram(name: "rep_clz", scope: !417, file: !417, line: 49, type: !183, scopeLine: 49, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !14, retainedNodes: !184)
!1542 = !DILocation(line: 50, column: 26, scope: !1541)
!1543 = !DILocation(line: 50, column: 12, scope: !1541)
!1544 = !DILocation(line: 50, column: 5, scope: !1541)
!1545 = distinct !DISubprogram(name: "__extendhfsf2", scope: !21, file: !21, line: 19, type: !183, scopeLine: 19, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !20, retainedNodes: !184)
!1546 = !DILocation(line: 20, column: 28, scope: !1545)
!1547 = !DILocation(line: 20, column: 12, scope: !1545)
!1548 = !DILocation(line: 20, column: 5, scope: !1545)
!1549 = distinct !DISubprogram(name: "__extendXfYf2__", scope: !1550, file: !1550, line: 41, type: !183, scopeLine: 41, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !20, retainedNodes: !184)
!1550 = !DIFile(filename: "../fp_extend_impl.inc", directory: "/workspaces/llvmta/testcases/libraries/builtinsfloat/buildarmv4", checksumkind: CSK_MD5, checksum: "782f110678e58d1f3d0cad0e8fd5cc59")
!1551 = !DILocation(line: 44, column: 15, scope: !1549)
!1552 = !DILocation(line: 45, column: 15, scope: !1549)
!1553 = !DILocation(line: 46, column: 15, scope: !1549)
!1554 = !DILocation(line: 47, column: 15, scope: !1549)
!1555 = !DILocation(line: 49, column: 21, scope: !1549)
!1556 = !DILocation(line: 50, column: 21, scope: !1549)
!1557 = !DILocation(line: 51, column: 21, scope: !1549)
!1558 = !DILocation(line: 52, column: 21, scope: !1549)
!1559 = !DILocation(line: 53, column: 21, scope: !1549)
!1560 = !DILocation(line: 54, column: 21, scope: !1549)
!1561 = !DILocation(line: 56, column: 15, scope: !1549)
!1562 = !DILocation(line: 57, column: 15, scope: !1549)
!1563 = !DILocation(line: 58, column: 15, scope: !1549)
!1564 = !DILocation(line: 59, column: 15, scope: !1549)
!1565 = !DILocation(line: 61, column: 21, scope: !1549)
!1566 = !DILocation(line: 64, column: 37, scope: !1549)
!1567 = !DILocation(line: 64, column: 28, scope: !1549)
!1568 = !DILocation(line: 64, column: 21, scope: !1549)
!1569 = !DILocation(line: 65, column: 28, scope: !1549)
!1570 = !DILocation(line: 65, column: 33, scope: !1549)
!1571 = !DILocation(line: 65, column: 21, scope: !1549)
!1572 = !DILocation(line: 66, column: 28, scope: !1549)
!1573 = !DILocation(line: 66, column: 33, scope: !1549)
!1574 = !DILocation(line: 66, column: 21, scope: !1549)
!1575 = !DILocation(line: 71, column: 21, scope: !1549)
!1576 = !DILocation(line: 71, column: 26, scope: !1549)
!1577 = !DILocation(line: 71, column: 9, scope: !1549)
!1578 = !DILocation(line: 71, column: 42, scope: !1549)
!1579 = !DILocation(line: 75, column: 32, scope: !1549)
!1580 = !DILocation(line: 75, column: 21, scope: !1549)
!1581 = !DILocation(line: 75, column: 37, scope: !1549)
!1582 = !DILocation(line: 75, column: 19, scope: !1549)
!1583 = !DILocation(line: 76, column: 19, scope: !1549)
!1584 = !DILocation(line: 77, column: 5, scope: !1549)
!1585 = !DILocation(line: 79, column: 14, scope: !1549)
!1586 = !DILocation(line: 79, column: 19, scope: !1549)
!1587 = !DILocation(line: 84, column: 19, scope: !1549)
!1588 = !DILocation(line: 85, column: 34, scope: !1549)
!1589 = !DILocation(line: 85, column: 39, scope: !1549)
!1590 = !DILocation(line: 85, column: 50, scope: !1549)
!1591 = !DILocation(line: 85, column: 19, scope: !1549)
!1592 = !DILocation(line: 86, column: 34, scope: !1549)
!1593 = !DILocation(line: 86, column: 39, scope: !1549)
!1594 = !DILocation(line: 86, column: 53, scope: !1549)
!1595 = !DILocation(line: 86, column: 19, scope: !1549)
!1596 = !DILocation(line: 87, column: 5, scope: !1549)
!1597 = !DILocation(line: 89, column: 14, scope: !1549)
!1598 = !DILocation(line: 93, column: 41, scope: !1549)
!1599 = !DILocation(line: 93, column: 27, scope: !1549)
!1600 = !DILocation(line: 93, column: 47, scope: !1549)
!1601 = !DILocation(line: 93, column: 19, scope: !1549)
!1602 = !DILocation(line: 94, column: 32, scope: !1549)
!1603 = !DILocation(line: 94, column: 21, scope: !1549)
!1604 = !DILocation(line: 94, column: 67, scope: !1549)
!1605 = !DILocation(line: 94, column: 65, scope: !1549)
!1606 = !DILocation(line: 94, column: 37, scope: !1549)
!1607 = !DILocation(line: 94, column: 19, scope: !1549)
!1608 = !DILocation(line: 95, column: 19, scope: !1549)
!1609 = !DILocation(line: 96, column: 62, scope: !1549)
!1610 = !DILocation(line: 96, column: 60, scope: !1549)
!1611 = !DILocation(line: 96, column: 68, scope: !1549)
!1612 = !DILocation(line: 96, column: 19, scope: !1549)
!1613 = !DILocation(line: 97, column: 33, scope: !1549)
!1614 = !DILocation(line: 97, column: 48, scope: !1549)
!1615 = !DILocation(line: 97, column: 19, scope: !1549)
!1616 = !DILocation(line: 98, column: 5, scope: !1549)
!1617 = !DILocation(line: 102, column: 19, scope: !1549)
!1618 = !DILocation(line: 106, column: 30, scope: !1549)
!1619 = !DILocation(line: 106, column: 53, scope: !1549)
!1620 = !DILocation(line: 106, column: 42, scope: !1549)
!1621 = !DILocation(line: 106, column: 58, scope: !1549)
!1622 = !DILocation(line: 106, column: 40, scope: !1549)
!1623 = !DILocation(line: 106, column: 21, scope: !1549)
!1624 = !DILocation(line: 107, column: 23, scope: !1549)
!1625 = !DILocation(line: 107, column: 12, scope: !1549)
!1626 = !DILocation(line: 107, column: 5, scope: !1549)
!1627 = distinct !DISubprogram(name: "srcToRep", scope: !1628, file: !1628, line: 78, type: !183, scopeLine: 78, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !20, retainedNodes: !184)
!1628 = !DIFile(filename: "../fp_extend.h", directory: "/workspaces/llvmta/testcases/libraries/builtinsfloat/buildarmv4", checksumkind: CSK_MD5, checksum: "d4932a0fd0790103e1f317fdc8091d48")
!1629 = !DILocation(line: 79, column: 49, scope: !1627)
!1630 = !DILocation(line: 79, column: 55, scope: !1627)
!1631 = !DILocation(line: 80, column: 16, scope: !1627)
!1632 = !DILocation(line: 80, column: 5, scope: !1627)
!1633 = distinct !DISubprogram(name: "dstFromRep", scope: !1628, file: !1628, line: 83, type: !183, scopeLine: 83, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !20, retainedNodes: !184)
!1634 = !DILocation(line: 84, column: 49, scope: !1633)
!1635 = !DILocation(line: 84, column: 55, scope: !1633)
!1636 = !DILocation(line: 85, column: 16, scope: !1633)
!1637 = !DILocation(line: 85, column: 5, scope: !1633)
!1638 = distinct !DISubprogram(name: "__gnu_h2f_ieee", scope: !21, file: !21, line: 23, type: !183, scopeLine: 23, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !20, retainedNodes: !184)
!1639 = !DILocation(line: 24, column: 26, scope: !1638)
!1640 = !DILocation(line: 24, column: 12, scope: !1638)
!1641 = !DILocation(line: 24, column: 5, scope: !1638)
!1642 = distinct !DISubprogram(name: "__extendsfdf2", scope: !23, file: !23, line: 17, type: !183, scopeLine: 17, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !22, retainedNodes: !184)
!1643 = !DILocation(line: 18, column: 28, scope: !1642)
!1644 = !DILocation(line: 18, column: 12, scope: !1642)
!1645 = !DILocation(line: 18, column: 5, scope: !1642)
!1646 = distinct !DISubprogram(name: "__extendXfYf2__", scope: !1550, file: !1550, line: 41, type: !183, scopeLine: 41, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !22, retainedNodes: !184)
!1647 = !DILocation(line: 44, column: 15, scope: !1646)
!1648 = !DILocation(line: 45, column: 15, scope: !1646)
!1649 = !DILocation(line: 46, column: 15, scope: !1646)
!1650 = !DILocation(line: 47, column: 15, scope: !1646)
!1651 = !DILocation(line: 49, column: 21, scope: !1646)
!1652 = !DILocation(line: 50, column: 21, scope: !1646)
!1653 = !DILocation(line: 51, column: 21, scope: !1646)
!1654 = !DILocation(line: 52, column: 21, scope: !1646)
!1655 = !DILocation(line: 53, column: 21, scope: !1646)
!1656 = !DILocation(line: 54, column: 21, scope: !1646)
!1657 = !DILocation(line: 56, column: 15, scope: !1646)
!1658 = !DILocation(line: 57, column: 15, scope: !1646)
!1659 = !DILocation(line: 58, column: 15, scope: !1646)
!1660 = !DILocation(line: 59, column: 15, scope: !1646)
!1661 = !DILocation(line: 61, column: 21, scope: !1646)
!1662 = !DILocation(line: 64, column: 37, scope: !1646)
!1663 = !DILocation(line: 64, column: 28, scope: !1646)
!1664 = !DILocation(line: 64, column: 21, scope: !1646)
!1665 = !DILocation(line: 65, column: 28, scope: !1646)
!1666 = !DILocation(line: 65, column: 33, scope: !1646)
!1667 = !DILocation(line: 65, column: 21, scope: !1646)
!1668 = !DILocation(line: 66, column: 28, scope: !1646)
!1669 = !DILocation(line: 66, column: 33, scope: !1646)
!1670 = !DILocation(line: 66, column: 21, scope: !1646)
!1671 = !DILocation(line: 71, column: 21, scope: !1646)
!1672 = !DILocation(line: 71, column: 26, scope: !1646)
!1673 = !DILocation(line: 71, column: 42, scope: !1646)
!1674 = !DILocation(line: 71, column: 9, scope: !1646)
!1675 = !DILocation(line: 75, column: 32, scope: !1646)
!1676 = !DILocation(line: 75, column: 21, scope: !1646)
!1677 = !DILocation(line: 75, column: 37, scope: !1646)
!1678 = !DILocation(line: 75, column: 19, scope: !1646)
!1679 = !DILocation(line: 76, column: 19, scope: !1646)
!1680 = !DILocation(line: 77, column: 5, scope: !1646)
!1681 = !DILocation(line: 79, column: 14, scope: !1646)
!1682 = !DILocation(line: 79, column: 19, scope: !1646)
!1683 = !DILocation(line: 84, column: 19, scope: !1646)
!1684 = !DILocation(line: 85, column: 34, scope: !1646)
!1685 = !DILocation(line: 85, column: 39, scope: !1646)
!1686 = !DILocation(line: 85, column: 22, scope: !1646)
!1687 = !DILocation(line: 85, column: 50, scope: !1646)
!1688 = !DILocation(line: 85, column: 19, scope: !1646)
!1689 = !DILocation(line: 86, column: 34, scope: !1646)
!1690 = !DILocation(line: 86, column: 39, scope: !1646)
!1691 = !DILocation(line: 86, column: 22, scope: !1646)
!1692 = !DILocation(line: 86, column: 53, scope: !1646)
!1693 = !DILocation(line: 86, column: 19, scope: !1646)
!1694 = !DILocation(line: 87, column: 5, scope: !1646)
!1695 = !DILocation(line: 89, column: 14, scope: !1646)
!1696 = !DILocation(line: 93, column: 41, scope: !1646)
!1697 = !DILocation(line: 93, column: 27, scope: !1646)
!1698 = !DILocation(line: 93, column: 47, scope: !1646)
!1699 = !DILocation(line: 93, column: 19, scope: !1646)
!1700 = !DILocation(line: 94, column: 32, scope: !1646)
!1701 = !DILocation(line: 94, column: 21, scope: !1646)
!1702 = !DILocation(line: 94, column: 67, scope: !1646)
!1703 = !DILocation(line: 94, column: 65, scope: !1646)
!1704 = !DILocation(line: 94, column: 37, scope: !1646)
!1705 = !DILocation(line: 94, column: 19, scope: !1646)
!1706 = !DILocation(line: 95, column: 19, scope: !1646)
!1707 = !DILocation(line: 96, column: 62, scope: !1646)
!1708 = !DILocation(line: 96, column: 60, scope: !1646)
!1709 = !DILocation(line: 96, column: 68, scope: !1646)
!1710 = !DILocation(line: 96, column: 19, scope: !1646)
!1711 = !DILocation(line: 97, column: 33, scope: !1646)
!1712 = !DILocation(line: 97, column: 22, scope: !1646)
!1713 = !DILocation(line: 97, column: 48, scope: !1646)
!1714 = !DILocation(line: 97, column: 19, scope: !1646)
!1715 = !DILocation(line: 98, column: 5, scope: !1646)
!1716 = !DILocation(line: 102, column: 19, scope: !1646)
!1717 = !DILocation(line: 106, column: 30, scope: !1646)
!1718 = !DILocation(line: 106, column: 53, scope: !1646)
!1719 = !DILocation(line: 106, column: 42, scope: !1646)
!1720 = !DILocation(line: 106, column: 58, scope: !1646)
!1721 = !DILocation(line: 106, column: 40, scope: !1646)
!1722 = !DILocation(line: 106, column: 21, scope: !1646)
!1723 = !DILocation(line: 107, column: 23, scope: !1646)
!1724 = !DILocation(line: 107, column: 12, scope: !1646)
!1725 = !DILocation(line: 107, column: 5, scope: !1646)
!1726 = distinct !DISubprogram(name: "srcToRep", scope: !1628, file: !1628, line: 78, type: !183, scopeLine: 78, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !22, retainedNodes: !184)
!1727 = !DILocation(line: 79, column: 49, scope: !1726)
!1728 = !DILocation(line: 79, column: 55, scope: !1726)
!1729 = !DILocation(line: 80, column: 16, scope: !1726)
!1730 = !DILocation(line: 80, column: 5, scope: !1726)
!1731 = distinct !DISubprogram(name: "dstFromRep", scope: !1628, file: !1628, line: 83, type: !183, scopeLine: 83, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !22, retainedNodes: !184)
!1732 = !DILocation(line: 84, column: 49, scope: !1731)
!1733 = !DILocation(line: 84, column: 55, scope: !1731)
!1734 = !DILocation(line: 85, column: 16, scope: !1731)
!1735 = !DILocation(line: 85, column: 5, scope: !1731)
!1736 = distinct !DISubprogram(name: "__fixdfdi", scope: !27, file: !27, line: 23, type: !183, scopeLine: 24, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !26, retainedNodes: !184)
!1737 = !DILocation(line: 25, column: 9, scope: !1736)
!1738 = !DILocation(line: 25, column: 11, scope: !1736)
!1739 = !DILocation(line: 26, column: 31, scope: !1736)
!1740 = !DILocation(line: 26, column: 30, scope: !1736)
!1741 = !DILocation(line: 26, column: 17, scope: !1736)
!1742 = !DILocation(line: 26, column: 16, scope: !1736)
!1743 = !DILocation(line: 26, column: 9, scope: !1736)
!1744 = !DILocation(line: 28, column: 25, scope: !1736)
!1745 = !DILocation(line: 28, column: 12, scope: !1736)
!1746 = !DILocation(line: 28, column: 5, scope: !1736)
!1747 = !DILocation(line: 29, column: 1, scope: !1736)
!1748 = distinct !DISubprogram(name: "__fixdfsi", scope: !29, file: !29, line: 20, type: !183, scopeLine: 20, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !28, retainedNodes: !184)
!1749 = !DILocation(line: 21, column: 21, scope: !1748)
!1750 = !DILocation(line: 21, column: 12, scope: !1748)
!1751 = !DILocation(line: 21, column: 5, scope: !1748)
!1752 = distinct !DISubprogram(name: "__fixint", scope: !1753, file: !1753, line: 17, type: !183, scopeLine: 17, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !28, retainedNodes: !184)
!1753 = !DIFile(filename: "../fp_fixint_impl.inc", directory: "/workspaces/llvmta/testcases/libraries/builtinsfloat/buildarmv4", checksumkind: CSK_MD5, checksum: "89ea1a0185caa3a064d6051520736960")
!1754 = !DILocation(line: 18, column: 20, scope: !1752)
!1755 = !DILocation(line: 19, column: 20, scope: !1752)
!1756 = !DILocation(line: 21, column: 30, scope: !1752)
!1757 = !DILocation(line: 21, column: 24, scope: !1752)
!1758 = !DILocation(line: 21, column: 17, scope: !1752)
!1759 = !DILocation(line: 22, column: 24, scope: !1752)
!1760 = !DILocation(line: 22, column: 29, scope: !1752)
!1761 = !DILocation(line: 22, column: 17, scope: !1752)
!1762 = !DILocation(line: 23, column: 27, scope: !1752)
!1763 = !DILocation(line: 23, column: 32, scope: !1752)
!1764 = !DILocation(line: 23, column: 20, scope: !1752)
!1765 = !DILocation(line: 24, column: 27, scope: !1752)
!1766 = !DILocation(line: 24, column: 32, scope: !1752)
!1767 = !DILocation(line: 24, column: 52, scope: !1752)
!1768 = !DILocation(line: 24, column: 26, scope: !1752)
!1769 = !DILocation(line: 24, column: 15, scope: !1752)
!1770 = !DILocation(line: 25, column: 32, scope: !1752)
!1771 = !DILocation(line: 25, column: 37, scope: !1752)
!1772 = !DILocation(line: 25, column: 56, scope: !1752)
!1773 = !DILocation(line: 25, column: 17, scope: !1752)
!1774 = !DILocation(line: 28, column: 9, scope: !1752)
!1775 = !DILocation(line: 28, column: 18, scope: !1752)
!1776 = !DILocation(line: 29, column: 9, scope: !1752)
!1777 = !DILocation(line: 32, column: 19, scope: !1752)
!1778 = !DILocation(line: 32, column: 28, scope: !1752)
!1779 = !DILocation(line: 32, column: 9, scope: !1752)
!1780 = !DILocation(line: 33, column: 16, scope: !1752)
!1781 = !DILocation(line: 33, column: 21, scope: !1752)
!1782 = !DILocation(line: 33, column: 9, scope: !1752)
!1783 = !DILocation(line: 37, column: 9, scope: !1752)
!1784 = !DILocation(line: 37, column: 18, scope: !1752)
!1785 = !DILocation(line: 38, column: 16, scope: !1752)
!1786 = !DILocation(line: 38, column: 24, scope: !1752)
!1787 = !DILocation(line: 38, column: 58, scope: !1752)
!1788 = !DILocation(line: 38, column: 56, scope: !1752)
!1789 = !DILocation(line: 38, column: 36, scope: !1752)
!1790 = !DILocation(line: 38, column: 21, scope: !1752)
!1791 = !DILocation(line: 38, column: 9, scope: !1752)
!1792 = !DILocation(line: 40, column: 16, scope: !1752)
!1793 = !DILocation(line: 40, column: 34, scope: !1752)
!1794 = !DILocation(line: 40, column: 24, scope: !1752)
!1795 = !DILocation(line: 40, column: 50, scope: !1752)
!1796 = !DILocation(line: 40, column: 59, scope: !1752)
!1797 = !DILocation(line: 40, column: 46, scope: !1752)
!1798 = !DILocation(line: 40, column: 21, scope: !1752)
!1799 = !DILocation(line: 40, column: 9, scope: !1752)
!1800 = !DILocation(line: 41, column: 1, scope: !1752)
!1801 = distinct !DISubprogram(name: "toRep", scope: !417, file: !417, line: 231, type: !183, scopeLine: 231, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !28, retainedNodes: !184)
!1802 = !DILocation(line: 232, column: 44, scope: !1801)
!1803 = !DILocation(line: 232, column: 50, scope: !1801)
!1804 = !DILocation(line: 233, column: 16, scope: !1801)
!1805 = !DILocation(line: 233, column: 5, scope: !1801)
!1806 = distinct !DISubprogram(name: "__fixsfdi", scope: !33, file: !33, line: 24, type: !183, scopeLine: 25, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !32, retainedNodes: !184)
!1807 = !DILocation(line: 26, column: 9, scope: !1806)
!1808 = !DILocation(line: 26, column: 11, scope: !1806)
!1809 = !DILocation(line: 27, column: 31, scope: !1806)
!1810 = !DILocation(line: 27, column: 30, scope: !1806)
!1811 = !DILocation(line: 27, column: 17, scope: !1806)
!1812 = !DILocation(line: 27, column: 16, scope: !1806)
!1813 = !DILocation(line: 27, column: 9, scope: !1806)
!1814 = !DILocation(line: 29, column: 25, scope: !1806)
!1815 = !DILocation(line: 29, column: 12, scope: !1806)
!1816 = !DILocation(line: 29, column: 5, scope: !1806)
!1817 = !DILocation(line: 30, column: 1, scope: !1806)
!1818 = distinct !DISubprogram(name: "__fixsfsi", scope: !35, file: !35, line: 20, type: !183, scopeLine: 20, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !34, retainedNodes: !184)
!1819 = !DILocation(line: 21, column: 21, scope: !1818)
!1820 = !DILocation(line: 21, column: 12, scope: !1818)
!1821 = !DILocation(line: 21, column: 5, scope: !1818)
!1822 = distinct !DISubprogram(name: "__fixint", scope: !1753, file: !1753, line: 17, type: !183, scopeLine: 17, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !34, retainedNodes: !184)
!1823 = !DILocation(line: 18, column: 20, scope: !1822)
!1824 = !DILocation(line: 19, column: 20, scope: !1822)
!1825 = !DILocation(line: 21, column: 30, scope: !1822)
!1826 = !DILocation(line: 21, column: 24, scope: !1822)
!1827 = !DILocation(line: 21, column: 17, scope: !1822)
!1828 = !DILocation(line: 22, column: 24, scope: !1822)
!1829 = !DILocation(line: 22, column: 29, scope: !1822)
!1830 = !DILocation(line: 22, column: 17, scope: !1822)
!1831 = !DILocation(line: 23, column: 27, scope: !1822)
!1832 = !DILocation(line: 23, column: 32, scope: !1822)
!1833 = !DILocation(line: 23, column: 20, scope: !1822)
!1834 = !DILocation(line: 24, column: 27, scope: !1822)
!1835 = !DILocation(line: 24, column: 32, scope: !1822)
!1836 = !DILocation(line: 24, column: 52, scope: !1822)
!1837 = !DILocation(line: 24, column: 15, scope: !1822)
!1838 = !DILocation(line: 25, column: 32, scope: !1822)
!1839 = !DILocation(line: 25, column: 37, scope: !1822)
!1840 = !DILocation(line: 25, column: 56, scope: !1822)
!1841 = !DILocation(line: 25, column: 17, scope: !1822)
!1842 = !DILocation(line: 28, column: 9, scope: !1822)
!1843 = !DILocation(line: 28, column: 18, scope: !1822)
!1844 = !DILocation(line: 29, column: 9, scope: !1822)
!1845 = !DILocation(line: 32, column: 19, scope: !1822)
!1846 = !DILocation(line: 32, column: 28, scope: !1822)
!1847 = !DILocation(line: 32, column: 9, scope: !1822)
!1848 = !DILocation(line: 33, column: 16, scope: !1822)
!1849 = !DILocation(line: 33, column: 21, scope: !1822)
!1850 = !DILocation(line: 33, column: 9, scope: !1822)
!1851 = !DILocation(line: 37, column: 9, scope: !1822)
!1852 = !DILocation(line: 37, column: 18, scope: !1822)
!1853 = !DILocation(line: 38, column: 16, scope: !1822)
!1854 = !DILocation(line: 38, column: 24, scope: !1822)
!1855 = !DILocation(line: 38, column: 58, scope: !1822)
!1856 = !DILocation(line: 38, column: 56, scope: !1822)
!1857 = !DILocation(line: 38, column: 36, scope: !1822)
!1858 = !DILocation(line: 38, column: 21, scope: !1822)
!1859 = !DILocation(line: 38, column: 9, scope: !1822)
!1860 = !DILocation(line: 40, column: 16, scope: !1822)
!1861 = !DILocation(line: 40, column: 34, scope: !1822)
!1862 = !DILocation(line: 40, column: 50, scope: !1822)
!1863 = !DILocation(line: 40, column: 59, scope: !1822)
!1864 = !DILocation(line: 40, column: 46, scope: !1822)
!1865 = !DILocation(line: 40, column: 21, scope: !1822)
!1866 = !DILocation(line: 40, column: 9, scope: !1822)
!1867 = !DILocation(line: 41, column: 1, scope: !1822)
!1868 = distinct !DISubprogram(name: "toRep", scope: !417, file: !417, line: 231, type: !183, scopeLine: 231, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !34, retainedNodes: !184)
!1869 = !DILocation(line: 232, column: 44, scope: !1868)
!1870 = !DILocation(line: 232, column: 50, scope: !1868)
!1871 = !DILocation(line: 233, column: 16, scope: !1868)
!1872 = !DILocation(line: 233, column: 5, scope: !1868)
!1873 = distinct !DISubprogram(name: "__fixunsdfdi", scope: !45, file: !45, line: 22, type: !183, scopeLine: 23, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !44, retainedNodes: !184)
!1874 = !DILocation(line: 24, column: 9, scope: !1873)
!1875 = !DILocation(line: 24, column: 11, scope: !1873)
!1876 = !DILocation(line: 24, column: 19, scope: !1873)
!1877 = !DILocation(line: 25, column: 19, scope: !1873)
!1878 = !DILocation(line: 25, column: 21, scope: !1873)
!1879 = !DILocation(line: 25, column: 12, scope: !1873)
!1880 = !DILocation(line: 26, column: 18, scope: !1873)
!1881 = !DILocation(line: 26, column: 30, scope: !1873)
!1882 = !DILocation(line: 26, column: 22, scope: !1873)
!1883 = !DILocation(line: 26, column: 20, scope: !1873)
!1884 = !DILocation(line: 26, column: 12, scope: !1873)
!1885 = !DILocation(line: 27, column: 21, scope: !1873)
!1886 = !DILocation(line: 27, column: 13, scope: !1873)
!1887 = !DILocation(line: 27, column: 26, scope: !1873)
!1888 = !DILocation(line: 27, column: 35, scope: !1873)
!1889 = !DILocation(line: 27, column: 33, scope: !1873)
!1890 = !DILocation(line: 27, column: 5, scope: !1873)
!1891 = !DILocation(line: 28, column: 1, scope: !1873)
!1892 = distinct !DISubprogram(name: "__fixunsdfsi", scope: !47, file: !47, line: 19, type: !183, scopeLine: 19, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !46, retainedNodes: !184)
!1893 = !DILocation(line: 20, column: 22, scope: !1892)
!1894 = !DILocation(line: 20, column: 12, scope: !1892)
!1895 = !DILocation(line: 20, column: 5, scope: !1892)
!1896 = distinct !DISubprogram(name: "__fixuint", scope: !1897, file: !1897, line: 17, type: !183, scopeLine: 17, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !46, retainedNodes: !184)
!1897 = !DIFile(filename: "../fp_fixuint_impl.inc", directory: "/workspaces/llvmta/testcases/libraries/builtinsfloat/buildarmv4", checksumkind: CSK_MD5, checksum: "6bc5369d617a52303e78f0c14245c5a2")
!1898 = !DILocation(line: 19, column: 30, scope: !1896)
!1899 = !DILocation(line: 19, column: 24, scope: !1896)
!1900 = !DILocation(line: 19, column: 17, scope: !1896)
!1901 = !DILocation(line: 20, column: 24, scope: !1896)
!1902 = !DILocation(line: 20, column: 29, scope: !1896)
!1903 = !DILocation(line: 20, column: 17, scope: !1896)
!1904 = !DILocation(line: 21, column: 22, scope: !1896)
!1905 = !DILocation(line: 21, column: 27, scope: !1896)
!1906 = !DILocation(line: 21, column: 15, scope: !1896)
!1907 = !DILocation(line: 22, column: 27, scope: !1896)
!1908 = !DILocation(line: 22, column: 32, scope: !1896)
!1909 = !DILocation(line: 22, column: 52, scope: !1896)
!1910 = !DILocation(line: 22, column: 26, scope: !1896)
!1911 = !DILocation(line: 22, column: 15, scope: !1896)
!1912 = !DILocation(line: 23, column: 32, scope: !1896)
!1913 = !DILocation(line: 23, column: 37, scope: !1896)
!1914 = !DILocation(line: 23, column: 56, scope: !1896)
!1915 = !DILocation(line: 23, column: 17, scope: !1896)
!1916 = !DILocation(line: 26, column: 9, scope: !1896)
!1917 = !DILocation(line: 26, column: 14, scope: !1896)
!1918 = !DILocation(line: 26, column: 20, scope: !1896)
!1919 = !DILocation(line: 26, column: 23, scope: !1896)
!1920 = !DILocation(line: 26, column: 32, scope: !1896)
!1921 = !DILocation(line: 27, column: 9, scope: !1896)
!1922 = !DILocation(line: 30, column: 19, scope: !1896)
!1923 = !DILocation(line: 30, column: 28, scope: !1896)
!1924 = !DILocation(line: 30, column: 9, scope: !1896)
!1925 = !DILocation(line: 31, column: 9, scope: !1896)
!1926 = !DILocation(line: 35, column: 9, scope: !1896)
!1927 = !DILocation(line: 35, column: 18, scope: !1896)
!1928 = !DILocation(line: 36, column: 16, scope: !1896)
!1929 = !DILocation(line: 36, column: 50, scope: !1896)
!1930 = !DILocation(line: 36, column: 48, scope: !1896)
!1931 = !DILocation(line: 36, column: 28, scope: !1896)
!1932 = !DILocation(line: 36, column: 9, scope: !1896)
!1933 = !DILocation(line: 38, column: 27, scope: !1896)
!1934 = !DILocation(line: 38, column: 16, scope: !1896)
!1935 = !DILocation(line: 38, column: 43, scope: !1896)
!1936 = !DILocation(line: 38, column: 52, scope: !1896)
!1937 = !DILocation(line: 38, column: 39, scope: !1896)
!1938 = !DILocation(line: 38, column: 9, scope: !1896)
!1939 = !DILocation(line: 39, column: 1, scope: !1896)
!1940 = distinct !DISubprogram(name: "toRep", scope: !417, file: !417, line: 231, type: !183, scopeLine: 231, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !46, retainedNodes: !184)
!1941 = !DILocation(line: 232, column: 44, scope: !1940)
!1942 = !DILocation(line: 232, column: 50, scope: !1940)
!1943 = !DILocation(line: 233, column: 16, scope: !1940)
!1944 = !DILocation(line: 233, column: 5, scope: !1940)
!1945 = distinct !DISubprogram(name: "__fixunssfdi", scope: !51, file: !51, line: 22, type: !183, scopeLine: 23, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !50, retainedNodes: !184)
!1946 = !DILocation(line: 24, column: 9, scope: !1945)
!1947 = !DILocation(line: 24, column: 11, scope: !1945)
!1948 = !DILocation(line: 24, column: 20, scope: !1945)
!1949 = !DILocation(line: 25, column: 17, scope: !1945)
!1950 = !DILocation(line: 25, column: 12, scope: !1945)
!1951 = !DILocation(line: 26, column: 19, scope: !1945)
!1952 = !DILocation(line: 26, column: 22, scope: !1945)
!1953 = !DILocation(line: 26, column: 12, scope: !1945)
!1954 = !DILocation(line: 27, column: 18, scope: !1945)
!1955 = !DILocation(line: 27, column: 31, scope: !1945)
!1956 = !DILocation(line: 27, column: 23, scope: !1945)
!1957 = !DILocation(line: 27, column: 21, scope: !1945)
!1958 = !DILocation(line: 27, column: 12, scope: !1945)
!1959 = !DILocation(line: 28, column: 21, scope: !1945)
!1960 = !DILocation(line: 28, column: 13, scope: !1945)
!1961 = !DILocation(line: 28, column: 26, scope: !1945)
!1962 = !DILocation(line: 28, column: 35, scope: !1945)
!1963 = !DILocation(line: 28, column: 33, scope: !1945)
!1964 = !DILocation(line: 28, column: 5, scope: !1945)
!1965 = !DILocation(line: 29, column: 1, scope: !1945)
!1966 = distinct !DISubprogram(name: "__fixunssfsi", scope: !53, file: !53, line: 23, type: !183, scopeLine: 23, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !52, retainedNodes: !184)
!1967 = !DILocation(line: 24, column: 22, scope: !1966)
!1968 = !DILocation(line: 24, column: 12, scope: !1966)
!1969 = !DILocation(line: 24, column: 5, scope: !1966)
!1970 = distinct !DISubprogram(name: "__fixuint", scope: !1897, file: !1897, line: 17, type: !183, scopeLine: 17, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !52, retainedNodes: !184)
!1971 = !DILocation(line: 19, column: 30, scope: !1970)
!1972 = !DILocation(line: 19, column: 24, scope: !1970)
!1973 = !DILocation(line: 19, column: 17, scope: !1970)
!1974 = !DILocation(line: 20, column: 24, scope: !1970)
!1975 = !DILocation(line: 20, column: 29, scope: !1970)
!1976 = !DILocation(line: 20, column: 17, scope: !1970)
!1977 = !DILocation(line: 21, column: 22, scope: !1970)
!1978 = !DILocation(line: 21, column: 27, scope: !1970)
!1979 = !DILocation(line: 21, column: 15, scope: !1970)
!1980 = !DILocation(line: 22, column: 27, scope: !1970)
!1981 = !DILocation(line: 22, column: 32, scope: !1970)
!1982 = !DILocation(line: 22, column: 52, scope: !1970)
!1983 = !DILocation(line: 22, column: 15, scope: !1970)
!1984 = !DILocation(line: 23, column: 32, scope: !1970)
!1985 = !DILocation(line: 23, column: 37, scope: !1970)
!1986 = !DILocation(line: 23, column: 56, scope: !1970)
!1987 = !DILocation(line: 23, column: 17, scope: !1970)
!1988 = !DILocation(line: 26, column: 9, scope: !1970)
!1989 = !DILocation(line: 26, column: 14, scope: !1970)
!1990 = !DILocation(line: 26, column: 20, scope: !1970)
!1991 = !DILocation(line: 26, column: 23, scope: !1970)
!1992 = !DILocation(line: 26, column: 32, scope: !1970)
!1993 = !DILocation(line: 27, column: 9, scope: !1970)
!1994 = !DILocation(line: 30, column: 19, scope: !1970)
!1995 = !DILocation(line: 30, column: 28, scope: !1970)
!1996 = !DILocation(line: 30, column: 9, scope: !1970)
!1997 = !DILocation(line: 31, column: 9, scope: !1970)
!1998 = !DILocation(line: 35, column: 9, scope: !1970)
!1999 = !DILocation(line: 35, column: 18, scope: !1970)
!2000 = !DILocation(line: 36, column: 16, scope: !1970)
!2001 = !DILocation(line: 36, column: 50, scope: !1970)
!2002 = !DILocation(line: 36, column: 48, scope: !1970)
!2003 = !DILocation(line: 36, column: 28, scope: !1970)
!2004 = !DILocation(line: 36, column: 9, scope: !1970)
!2005 = !DILocation(line: 38, column: 27, scope: !1970)
!2006 = !DILocation(line: 38, column: 43, scope: !1970)
!2007 = !DILocation(line: 38, column: 52, scope: !1970)
!2008 = !DILocation(line: 38, column: 39, scope: !1970)
!2009 = !DILocation(line: 38, column: 9, scope: !1970)
!2010 = !DILocation(line: 39, column: 1, scope: !1970)
!2011 = distinct !DISubprogram(name: "toRep", scope: !417, file: !417, line: 231, type: !183, scopeLine: 231, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !52, retainedNodes: !184)
!2012 = !DILocation(line: 232, column: 44, scope: !2011)
!2013 = !DILocation(line: 232, column: 50, scope: !2011)
!2014 = !DILocation(line: 233, column: 16, scope: !2011)
!2015 = !DILocation(line: 233, column: 5, scope: !2011)
!2016 = distinct !DISubprogram(name: "__fixunsxfdi", scope: !63, file: !63, line: 34, type: !183, scopeLine: 35, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !62, retainedNodes: !184)
!2017 = !DILocation(line: 37, column: 12, scope: !2016)
!2018 = !DILocation(line: 37, column: 8, scope: !2016)
!2019 = !DILocation(line: 37, column: 10, scope: !2016)
!2020 = !DILocation(line: 38, column: 17, scope: !2016)
!2021 = !DILocation(line: 38, column: 19, scope: !2016)
!2022 = !DILocation(line: 38, column: 24, scope: !2016)
!2023 = !DILocation(line: 38, column: 26, scope: !2016)
!2024 = !DILocation(line: 38, column: 30, scope: !2016)
!2025 = !DILocation(line: 38, column: 44, scope: !2016)
!2026 = !DILocation(line: 38, column: 9, scope: !2016)
!2027 = !DILocation(line: 39, column: 9, scope: !2016)
!2028 = !DILocation(line: 39, column: 11, scope: !2016)
!2029 = !DILocation(line: 39, column: 15, scope: !2016)
!2030 = !DILocation(line: 39, column: 22, scope: !2016)
!2031 = !DILocation(line: 39, column: 24, scope: !2016)
!2032 = !DILocation(line: 39, column: 29, scope: !2016)
!2033 = !DILocation(line: 39, column: 31, scope: !2016)
!2034 = !DILocation(line: 39, column: 35, scope: !2016)
!2035 = !DILocation(line: 40, column: 9, scope: !2016)
!2036 = !DILocation(line: 41, column: 19, scope: !2016)
!2037 = !DILocation(line: 41, column: 21, scope: !2016)
!2038 = !DILocation(line: 41, column: 9, scope: !2016)
!2039 = !DILocation(line: 42, column: 9, scope: !2016)
!2040 = !DILocation(line: 43, column: 15, scope: !2016)
!2041 = !DILocation(line: 43, column: 17, scope: !2016)
!2042 = !DILocation(line: 43, column: 21, scope: !2016)
!2043 = !DILocation(line: 43, column: 34, scope: !2016)
!2044 = !DILocation(line: 43, column: 32, scope: !2016)
!2045 = !DILocation(line: 43, column: 25, scope: !2016)
!2046 = !DILocation(line: 43, column: 5, scope: !2016)
!2047 = !DILocation(line: 44, column: 1, scope: !2016)
!2048 = distinct !DISubprogram(name: "__fixunsxfsi", scope: !65, file: !65, line: 33, type: !183, scopeLine: 34, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !64, retainedNodes: !184)
!2049 = !DILocation(line: 36, column: 12, scope: !2048)
!2050 = !DILocation(line: 36, column: 8, scope: !2048)
!2051 = !DILocation(line: 36, column: 10, scope: !2048)
!2052 = !DILocation(line: 37, column: 17, scope: !2048)
!2053 = !DILocation(line: 37, column: 19, scope: !2048)
!2054 = !DILocation(line: 37, column: 24, scope: !2048)
!2055 = !DILocation(line: 37, column: 26, scope: !2048)
!2056 = !DILocation(line: 37, column: 30, scope: !2048)
!2057 = !DILocation(line: 37, column: 44, scope: !2048)
!2058 = !DILocation(line: 37, column: 9, scope: !2048)
!2059 = !DILocation(line: 38, column: 9, scope: !2048)
!2060 = !DILocation(line: 38, column: 11, scope: !2048)
!2061 = !DILocation(line: 38, column: 15, scope: !2048)
!2062 = !DILocation(line: 38, column: 22, scope: !2048)
!2063 = !DILocation(line: 38, column: 24, scope: !2048)
!2064 = !DILocation(line: 38, column: 29, scope: !2048)
!2065 = !DILocation(line: 38, column: 31, scope: !2048)
!2066 = !DILocation(line: 38, column: 35, scope: !2048)
!2067 = !DILocation(line: 39, column: 9, scope: !2048)
!2068 = !DILocation(line: 40, column: 19, scope: !2048)
!2069 = !DILocation(line: 40, column: 21, scope: !2048)
!2070 = !DILocation(line: 40, column: 9, scope: !2048)
!2071 = !DILocation(line: 41, column: 9, scope: !2048)
!2072 = !DILocation(line: 42, column: 15, scope: !2048)
!2073 = !DILocation(line: 42, column: 17, scope: !2048)
!2074 = !DILocation(line: 42, column: 21, scope: !2048)
!2075 = !DILocation(line: 42, column: 23, scope: !2048)
!2076 = !DILocation(line: 42, column: 37, scope: !2048)
!2077 = !DILocation(line: 42, column: 35, scope: !2048)
!2078 = !DILocation(line: 42, column: 28, scope: !2048)
!2079 = !DILocation(line: 42, column: 5, scope: !2048)
!2080 = !DILocation(line: 43, column: 1, scope: !2048)
!2081 = distinct !DISubprogram(name: "__fixxfdi", scope: !69, file: !69, line: 31, type: !183, scopeLine: 32, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !68, retainedNodes: !184)
!2082 = !DILocation(line: 33, column: 18, scope: !2081)
!2083 = !DILocation(line: 34, column: 18, scope: !2081)
!2084 = !DILocation(line: 36, column: 12, scope: !2081)
!2085 = !DILocation(line: 36, column: 8, scope: !2081)
!2086 = !DILocation(line: 36, column: 10, scope: !2081)
!2087 = !DILocation(line: 37, column: 17, scope: !2081)
!2088 = !DILocation(line: 37, column: 19, scope: !2081)
!2089 = !DILocation(line: 37, column: 24, scope: !2081)
!2090 = !DILocation(line: 37, column: 26, scope: !2081)
!2091 = !DILocation(line: 37, column: 30, scope: !2081)
!2092 = !DILocation(line: 37, column: 44, scope: !2081)
!2093 = !DILocation(line: 37, column: 9, scope: !2081)
!2094 = !DILocation(line: 38, column: 9, scope: !2081)
!2095 = !DILocation(line: 38, column: 11, scope: !2081)
!2096 = !DILocation(line: 39, column: 9, scope: !2081)
!2097 = !DILocation(line: 40, column: 19, scope: !2081)
!2098 = !DILocation(line: 40, column: 21, scope: !2081)
!2099 = !DILocation(line: 40, column: 9, scope: !2081)
!2100 = !DILocation(line: 41, column: 16, scope: !2081)
!2101 = !DILocation(line: 41, column: 18, scope: !2081)
!2102 = !DILocation(line: 41, column: 9, scope: !2081)
!2103 = !DILocation(line: 42, column: 30, scope: !2081)
!2104 = !DILocation(line: 42, column: 32, scope: !2081)
!2105 = !DILocation(line: 42, column: 37, scope: !2081)
!2106 = !DILocation(line: 42, column: 39, scope: !2081)
!2107 = !DILocation(line: 42, column: 43, scope: !2081)
!2108 = !DILocation(line: 42, column: 57, scope: !2081)
!2109 = !DILocation(line: 42, column: 16, scope: !2081)
!2110 = !DILocation(line: 42, column: 12, scope: !2081)
!2111 = !DILocation(line: 43, column: 19, scope: !2081)
!2112 = !DILocation(line: 43, column: 21, scope: !2081)
!2113 = !DILocation(line: 43, column: 25, scope: !2081)
!2114 = !DILocation(line: 43, column: 12, scope: !2081)
!2115 = !DILocation(line: 44, column: 17, scope: !2081)
!2116 = !DILocation(line: 44, column: 28, scope: !2081)
!2117 = !DILocation(line: 44, column: 26, scope: !2081)
!2118 = !DILocation(line: 44, column: 19, scope: !2081)
!2119 = !DILocation(line: 44, column: 7, scope: !2081)
!2120 = !DILocation(line: 45, column: 13, scope: !2081)
!2121 = !DILocation(line: 45, column: 17, scope: !2081)
!2122 = !DILocation(line: 45, column: 15, scope: !2081)
!2123 = !DILocation(line: 45, column: 22, scope: !2081)
!2124 = !DILocation(line: 45, column: 20, scope: !2081)
!2125 = !DILocation(line: 45, column: 5, scope: !2081)
!2126 = !DILocation(line: 46, column: 1, scope: !2081)
!2127 = distinct !DISubprogram(name: "__floatdidf", scope: !73, file: !73, line: 33, type: !183, scopeLine: 34, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !72, retainedNodes: !184)
!2128 = !DILocation(line: 38, column: 36, scope: !2127)
!2129 = !DILocation(line: 40, column: 35, scope: !2127)
!2130 = !DILocation(line: 40, column: 37, scope: !2127)
!2131 = !DILocation(line: 40, column: 25, scope: !2127)
!2132 = !DILocation(line: 40, column: 44, scope: !2127)
!2133 = !DILocation(line: 40, column: 18, scope: !2127)
!2134 = !DILocation(line: 41, column: 14, scope: !2127)
!2135 = !DILocation(line: 41, column: 16, scope: !2127)
!2136 = !DILocation(line: 41, column: 9, scope: !2127)
!2137 = !DILocation(line: 41, column: 11, scope: !2127)
!2138 = !DILocation(line: 43, column: 28, scope: !2127)
!2139 = !DILocation(line: 43, column: 33, scope: !2127)
!2140 = !DILocation(line: 43, column: 49, scope: !2127)
!2141 = !DILocation(line: 43, column: 43, scope: !2127)
!2142 = !DILocation(line: 43, column: 18, scope: !2127)
!2143 = !DILocation(line: 44, column: 12, scope: !2127)
!2144 = !DILocation(line: 44, column: 5, scope: !2127)
!2145 = distinct !DISubprogram(name: "__floatdisf", scope: !75, file: !75, line: 28, type: !183, scopeLine: 29, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !74, retainedNodes: !184)
!2146 = !DILocation(line: 30, column: 9, scope: !2145)
!2147 = !DILocation(line: 30, column: 11, scope: !2145)
!2148 = !DILocation(line: 31, column: 9, scope: !2145)
!2149 = !DILocation(line: 32, column: 20, scope: !2145)
!2150 = !DILocation(line: 33, column: 22, scope: !2145)
!2151 = !DILocation(line: 33, column: 24, scope: !2145)
!2152 = !DILocation(line: 33, column: 18, scope: !2145)
!2153 = !DILocation(line: 34, column: 10, scope: !2145)
!2154 = !DILocation(line: 34, column: 14, scope: !2145)
!2155 = !DILocation(line: 34, column: 12, scope: !2145)
!2156 = !DILocation(line: 34, column: 19, scope: !2145)
!2157 = !DILocation(line: 34, column: 17, scope: !2145)
!2158 = !DILocation(line: 34, column: 7, scope: !2145)
!2159 = !DILocation(line: 35, column: 34, scope: !2145)
!2160 = !DILocation(line: 35, column: 18, scope: !2145)
!2161 = !DILocation(line: 35, column: 16, scope: !2145)
!2162 = !DILocation(line: 35, column: 9, scope: !2145)
!2163 = !DILocation(line: 36, column: 13, scope: !2145)
!2164 = !DILocation(line: 36, column: 16, scope: !2145)
!2165 = !DILocation(line: 36, column: 9, scope: !2145)
!2166 = !DILocation(line: 37, column: 9, scope: !2145)
!2167 = !DILocation(line: 37, column: 12, scope: !2145)
!2168 = !DILocation(line: 47, column: 17, scope: !2145)
!2169 = !DILocation(line: 47, column: 9, scope: !2145)
!2170 = !DILocation(line: 50, column: 15, scope: !2145)
!2171 = !DILocation(line: 51, column: 13, scope: !2145)
!2172 = !DILocation(line: 53, column: 13, scope: !2145)
!2173 = !DILocation(line: 55, column: 26, scope: !2145)
!2174 = !DILocation(line: 55, column: 32, scope: !2145)
!2175 = !DILocation(line: 55, column: 35, scope: !2145)
!2176 = !DILocation(line: 55, column: 28, scope: !2145)
!2177 = !DILocation(line: 56, column: 19, scope: !2145)
!2178 = !DILocation(line: 56, column: 64, scope: !2145)
!2179 = !DILocation(line: 56, column: 62, scope: !2145)
!2180 = !DILocation(line: 56, column: 37, scope: !2145)
!2181 = !DILocation(line: 56, column: 21, scope: !2145)
!2182 = !DILocation(line: 56, column: 70, scope: !2145)
!2183 = !DILocation(line: 56, column: 17, scope: !2145)
!2184 = !DILocation(line: 55, column: 56, scope: !2145)
!2185 = !DILocation(line: 55, column: 15, scope: !2145)
!2186 = !DILocation(line: 57, column: 9, scope: !2145)
!2187 = !DILocation(line: 59, column: 15, scope: !2145)
!2188 = !DILocation(line: 59, column: 17, scope: !2145)
!2189 = !DILocation(line: 59, column: 22, scope: !2145)
!2190 = !DILocation(line: 59, column: 14, scope: !2145)
!2191 = !DILocation(line: 59, column: 11, scope: !2145)
!2192 = !DILocation(line: 60, column: 9, scope: !2145)
!2193 = !DILocation(line: 61, column: 11, scope: !2145)
!2194 = !DILocation(line: 63, column: 13, scope: !2145)
!2195 = !DILocation(line: 63, column: 15, scope: !2145)
!2196 = !DILocation(line: 65, column: 15, scope: !2145)
!2197 = !DILocation(line: 66, column: 13, scope: !2145)
!2198 = !DILocation(line: 67, column: 9, scope: !2145)
!2199 = !DILocation(line: 69, column: 5, scope: !2145)
!2200 = !DILocation(line: 72, column: 31, scope: !2145)
!2201 = !DILocation(line: 72, column: 29, scope: !2145)
!2202 = !DILocation(line: 72, column: 11, scope: !2145)
!2203 = !DILocation(line: 76, column: 21, scope: !2145)
!2204 = !DILocation(line: 76, column: 13, scope: !2145)
!2205 = !DILocation(line: 76, column: 23, scope: !2145)
!2206 = !DILocation(line: 77, column: 14, scope: !2145)
!2207 = !DILocation(line: 77, column: 16, scope: !2145)
!2208 = !DILocation(line: 77, column: 23, scope: !2145)
!2209 = !DILocation(line: 76, column: 37, scope: !2145)
!2210 = !DILocation(line: 78, column: 21, scope: !2145)
!2211 = !DILocation(line: 78, column: 13, scope: !2145)
!2212 = !DILocation(line: 78, column: 23, scope: !2145)
!2213 = !DILocation(line: 77, column: 36, scope: !2145)
!2214 = !DILocation(line: 76, column: 8, scope: !2145)
!2215 = !DILocation(line: 76, column: 10, scope: !2145)
!2216 = !DILocation(line: 79, column: 15, scope: !2145)
!2217 = !DILocation(line: 79, column: 5, scope: !2145)
!2218 = !DILocation(line: 80, column: 1, scope: !2145)
!2219 = distinct !DISubprogram(name: "__floatdixf", scope: !79, file: !79, line: 30, type: !183, scopeLine: 31, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !78, retainedNodes: !184)
!2220 = !DILocation(line: 32, column: 9, scope: !2219)
!2221 = !DILocation(line: 32, column: 11, scope: !2219)
!2222 = !DILocation(line: 33, column: 9, scope: !2219)
!2223 = !DILocation(line: 34, column: 20, scope: !2219)
!2224 = !DILocation(line: 35, column: 22, scope: !2219)
!2225 = !DILocation(line: 35, column: 24, scope: !2219)
!2226 = !DILocation(line: 35, column: 18, scope: !2219)
!2227 = !DILocation(line: 36, column: 10, scope: !2219)
!2228 = !DILocation(line: 36, column: 14, scope: !2219)
!2229 = !DILocation(line: 36, column: 12, scope: !2219)
!2230 = !DILocation(line: 36, column: 19, scope: !2219)
!2231 = !DILocation(line: 36, column: 17, scope: !2219)
!2232 = !DILocation(line: 36, column: 7, scope: !2219)
!2233 = !DILocation(line: 37, column: 31, scope: !2219)
!2234 = !DILocation(line: 37, column: 15, scope: !2219)
!2235 = !DILocation(line: 37, column: 9, scope: !2219)
!2236 = !DILocation(line: 38, column: 23, scope: !2219)
!2237 = !DILocation(line: 38, column: 21, scope: !2219)
!2238 = !DILocation(line: 38, column: 9, scope: !2219)
!2239 = !DILocation(line: 40, column: 32, scope: !2219)
!2240 = !DILocation(line: 40, column: 24, scope: !2219)
!2241 = !DILocation(line: 40, column: 34, scope: !2219)
!2242 = !DILocation(line: 41, column: 10, scope: !2219)
!2243 = !DILocation(line: 41, column: 12, scope: !2219)
!2244 = !DILocation(line: 40, column: 48, scope: !2219)
!2245 = !DILocation(line: 40, column: 8, scope: !2219)
!2246 = !DILocation(line: 40, column: 10, scope: !2219)
!2247 = !DILocation(line: 40, column: 15, scope: !2219)
!2248 = !DILocation(line: 40, column: 17, scope: !2219)
!2249 = !DILocation(line: 40, column: 21, scope: !2219)
!2250 = !DILocation(line: 42, column: 20, scope: !2219)
!2251 = !DILocation(line: 42, column: 25, scope: !2219)
!2252 = !DILocation(line: 42, column: 22, scope: !2219)
!2253 = !DILocation(line: 42, column: 8, scope: !2219)
!2254 = !DILocation(line: 42, column: 10, scope: !2219)
!2255 = !DILocation(line: 42, column: 14, scope: !2219)
!2256 = !DILocation(line: 42, column: 18, scope: !2219)
!2257 = !DILocation(line: 43, column: 15, scope: !2219)
!2258 = !DILocation(line: 43, column: 5, scope: !2219)
!2259 = !DILocation(line: 44, column: 1, scope: !2219)
!2260 = distinct !DISubprogram(name: "__floatsidf", scope: !81, file: !81, line: 24, type: !183, scopeLine: 24, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !80, retainedNodes: !184)
!2261 = !DILocation(line: 26, column: 15, scope: !2260)
!2262 = !DILocation(line: 29, column: 9, scope: !2260)
!2263 = !DILocation(line: 29, column: 11, scope: !2260)
!2264 = !DILocation(line: 30, column: 16, scope: !2260)
!2265 = !DILocation(line: 30, column: 9, scope: !2260)
!2266 = !DILocation(line: 33, column: 11, scope: !2260)
!2267 = !DILocation(line: 34, column: 9, scope: !2260)
!2268 = !DILocation(line: 34, column: 11, scope: !2260)
!2269 = !DILocation(line: 35, column: 14, scope: !2260)
!2270 = !DILocation(line: 36, column: 14, scope: !2260)
!2271 = !DILocation(line: 36, column: 13, scope: !2260)
!2272 = !DILocation(line: 36, column: 11, scope: !2260)
!2273 = !DILocation(line: 37, column: 5, scope: !2260)
!2274 = !DILocation(line: 40, column: 55, scope: !2260)
!2275 = !DILocation(line: 40, column: 41, scope: !2260)
!2276 = !DILocation(line: 40, column: 39, scope: !2260)
!2277 = !DILocation(line: 40, column: 15, scope: !2260)
!2278 = !DILocation(line: 46, column: 41, scope: !2260)
!2279 = !DILocation(line: 46, column: 39, scope: !2260)
!2280 = !DILocation(line: 46, column: 15, scope: !2260)
!2281 = !DILocation(line: 47, column: 35, scope: !2260)
!2282 = !DILocation(line: 47, column: 14, scope: !2260)
!2283 = !DILocation(line: 47, column: 40, scope: !2260)
!2284 = !DILocation(line: 47, column: 37, scope: !2260)
!2285 = !DILocation(line: 47, column: 46, scope: !2260)
!2286 = !DILocation(line: 47, column: 12, scope: !2260)
!2287 = !DILocation(line: 50, column: 23, scope: !2260)
!2288 = !DILocation(line: 50, column: 32, scope: !2260)
!2289 = !DILocation(line: 50, column: 15, scope: !2260)
!2290 = !DILocation(line: 50, column: 48, scope: !2260)
!2291 = !DILocation(line: 50, column: 12, scope: !2260)
!2292 = !DILocation(line: 52, column: 20, scope: !2260)
!2293 = !DILocation(line: 52, column: 29, scope: !2260)
!2294 = !DILocation(line: 52, column: 27, scope: !2260)
!2295 = !DILocation(line: 52, column: 12, scope: !2260)
!2296 = !DILocation(line: 52, column: 5, scope: !2260)
!2297 = !DILocation(line: 53, column: 1, scope: !2260)
!2298 = distinct !DISubprogram(name: "fromRep", scope: !417, file: !417, line: 236, type: !183, scopeLine: 236, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !80, retainedNodes: !184)
!2299 = !DILocation(line: 237, column: 44, scope: !2298)
!2300 = !DILocation(line: 237, column: 50, scope: !2298)
!2301 = !DILocation(line: 238, column: 16, scope: !2298)
!2302 = !DILocation(line: 238, column: 5, scope: !2298)
!2303 = distinct !DISubprogram(name: "__floatsisf", scope: !83, file: !83, line: 24, type: !183, scopeLine: 24, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !82, retainedNodes: !184)
!2304 = !DILocation(line: 26, column: 15, scope: !2303)
!2305 = !DILocation(line: 29, column: 9, scope: !2303)
!2306 = !DILocation(line: 29, column: 11, scope: !2303)
!2307 = !DILocation(line: 30, column: 16, scope: !2303)
!2308 = !DILocation(line: 30, column: 9, scope: !2303)
!2309 = !DILocation(line: 33, column: 11, scope: !2303)
!2310 = !DILocation(line: 34, column: 9, scope: !2303)
!2311 = !DILocation(line: 34, column: 11, scope: !2303)
!2312 = !DILocation(line: 35, column: 14, scope: !2303)
!2313 = !DILocation(line: 36, column: 14, scope: !2303)
!2314 = !DILocation(line: 36, column: 13, scope: !2303)
!2315 = !DILocation(line: 36, column: 11, scope: !2303)
!2316 = !DILocation(line: 37, column: 5, scope: !2303)
!2317 = !DILocation(line: 40, column: 55, scope: !2303)
!2318 = !DILocation(line: 40, column: 41, scope: !2303)
!2319 = !DILocation(line: 40, column: 39, scope: !2303)
!2320 = !DILocation(line: 40, column: 15, scope: !2303)
!2321 = !DILocation(line: 44, column: 9, scope: !2303)
!2322 = !DILocation(line: 44, column: 18, scope: !2303)
!2323 = !DILocation(line: 45, column: 45, scope: !2303)
!2324 = !DILocation(line: 45, column: 43, scope: !2303)
!2325 = !DILocation(line: 45, column: 19, scope: !2303)
!2326 = !DILocation(line: 46, column: 25, scope: !2303)
!2327 = !DILocation(line: 46, column: 30, scope: !2303)
!2328 = !DILocation(line: 46, column: 27, scope: !2303)
!2329 = !DILocation(line: 46, column: 36, scope: !2303)
!2330 = !DILocation(line: 46, column: 16, scope: !2303)
!2331 = !DILocation(line: 47, column: 5, scope: !2303)
!2332 = !DILocation(line: 48, column: 27, scope: !2303)
!2333 = !DILocation(line: 48, column: 36, scope: !2303)
!2334 = !DILocation(line: 48, column: 19, scope: !2303)
!2335 = !DILocation(line: 49, column: 25, scope: !2303)
!2336 = !DILocation(line: 49, column: 30, scope: !2303)
!2337 = !DILocation(line: 49, column: 27, scope: !2303)
!2338 = !DILocation(line: 49, column: 36, scope: !2303)
!2339 = !DILocation(line: 49, column: 16, scope: !2303)
!2340 = !DILocation(line: 50, column: 30, scope: !2303)
!2341 = !DILocation(line: 50, column: 48, scope: !2303)
!2342 = !DILocation(line: 50, column: 46, scope: !2303)
!2343 = !DILocation(line: 50, column: 32, scope: !2303)
!2344 = !DILocation(line: 50, column: 15, scope: !2303)
!2345 = !DILocation(line: 51, column: 13, scope: !2303)
!2346 = !DILocation(line: 51, column: 19, scope: !2303)
!2347 = !DILocation(line: 51, column: 36, scope: !2303)
!2348 = !DILocation(line: 51, column: 30, scope: !2303)
!2349 = !DILocation(line: 52, column: 13, scope: !2303)
!2350 = !DILocation(line: 52, column: 19, scope: !2303)
!2351 = !DILocation(line: 52, column: 41, scope: !2303)
!2352 = !DILocation(line: 52, column: 48, scope: !2303)
!2353 = !DILocation(line: 52, column: 38, scope: !2303)
!2354 = !DILocation(line: 52, column: 31, scope: !2303)
!2355 = !DILocation(line: 56, column: 23, scope: !2303)
!2356 = !DILocation(line: 56, column: 32, scope: !2303)
!2357 = !DILocation(line: 56, column: 48, scope: !2303)
!2358 = !DILocation(line: 56, column: 12, scope: !2303)
!2359 = !DILocation(line: 58, column: 20, scope: !2303)
!2360 = !DILocation(line: 58, column: 29, scope: !2303)
!2361 = !DILocation(line: 58, column: 27, scope: !2303)
!2362 = !DILocation(line: 58, column: 12, scope: !2303)
!2363 = !DILocation(line: 58, column: 5, scope: !2303)
!2364 = !DILocation(line: 59, column: 1, scope: !2303)
!2365 = distinct !DISubprogram(name: "fromRep", scope: !417, file: !417, line: 236, type: !183, scopeLine: 236, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !82, retainedNodes: !184)
!2366 = !DILocation(line: 237, column: 44, scope: !2365)
!2367 = !DILocation(line: 237, column: 50, scope: !2365)
!2368 = !DILocation(line: 238, column: 16, scope: !2365)
!2369 = !DILocation(line: 238, column: 5, scope: !2365)
!2370 = distinct !DISubprogram(name: "__floatundidf", scope: !95, file: !95, line: 33, type: !183, scopeLine: 34, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !94, retainedNodes: !184)
!2371 = !DILocation(line: 39, column: 37, scope: !2370)
!2372 = !DILocation(line: 40, column: 37, scope: !2370)
!2373 = !DILocation(line: 42, column: 15, scope: !2370)
!2374 = !DILocation(line: 42, column: 17, scope: !2370)
!2375 = !DILocation(line: 42, column: 10, scope: !2370)
!2376 = !DILocation(line: 42, column: 12, scope: !2370)
!2377 = !DILocation(line: 43, column: 14, scope: !2370)
!2378 = !DILocation(line: 43, column: 16, scope: !2370)
!2379 = !DILocation(line: 43, column: 9, scope: !2370)
!2380 = !DILocation(line: 43, column: 11, scope: !2370)
!2381 = !DILocation(line: 45, column: 33, scope: !2370)
!2382 = !DILocation(line: 45, column: 35, scope: !2370)
!2383 = !DILocation(line: 45, column: 63, scope: !2370)
!2384 = !DILocation(line: 45, column: 57, scope: !2370)
!2385 = !DILocation(line: 45, column: 18, scope: !2370)
!2386 = !DILocation(line: 46, column: 12, scope: !2370)
!2387 = !DILocation(line: 46, column: 5, scope: !2370)
!2388 = distinct !DISubprogram(name: "__floatundisf", scope: !97, file: !97, line: 28, type: !183, scopeLine: 29, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !96, retainedNodes: !184)
!2389 = !DILocation(line: 30, column: 9, scope: !2388)
!2390 = !DILocation(line: 30, column: 11, scope: !2388)
!2391 = !DILocation(line: 31, column: 9, scope: !2388)
!2392 = !DILocation(line: 32, column: 20, scope: !2388)
!2393 = !DILocation(line: 33, column: 34, scope: !2388)
!2394 = !DILocation(line: 33, column: 18, scope: !2388)
!2395 = !DILocation(line: 33, column: 16, scope: !2388)
!2396 = !DILocation(line: 33, column: 9, scope: !2388)
!2397 = !DILocation(line: 34, column: 13, scope: !2388)
!2398 = !DILocation(line: 34, column: 16, scope: !2388)
!2399 = !DILocation(line: 34, column: 9, scope: !2388)
!2400 = !DILocation(line: 35, column: 9, scope: !2388)
!2401 = !DILocation(line: 35, column: 12, scope: !2388)
!2402 = !DILocation(line: 45, column: 17, scope: !2388)
!2403 = !DILocation(line: 45, column: 9, scope: !2388)
!2404 = !DILocation(line: 48, column: 15, scope: !2388)
!2405 = !DILocation(line: 49, column: 13, scope: !2388)
!2406 = !DILocation(line: 51, column: 13, scope: !2388)
!2407 = !DILocation(line: 53, column: 18, scope: !2388)
!2408 = !DILocation(line: 53, column: 24, scope: !2388)
!2409 = !DILocation(line: 53, column: 27, scope: !2388)
!2410 = !DILocation(line: 53, column: 20, scope: !2388)
!2411 = !DILocation(line: 54, column: 19, scope: !2388)
!2412 = !DILocation(line: 54, column: 64, scope: !2388)
!2413 = !DILocation(line: 54, column: 62, scope: !2388)
!2414 = !DILocation(line: 54, column: 37, scope: !2388)
!2415 = !DILocation(line: 54, column: 21, scope: !2388)
!2416 = !DILocation(line: 54, column: 70, scope: !2388)
!2417 = !DILocation(line: 54, column: 17, scope: !2388)
!2418 = !DILocation(line: 53, column: 48, scope: !2388)
!2419 = !DILocation(line: 53, column: 15, scope: !2388)
!2420 = !DILocation(line: 55, column: 9, scope: !2388)
!2421 = !DILocation(line: 57, column: 15, scope: !2388)
!2422 = !DILocation(line: 57, column: 17, scope: !2388)
!2423 = !DILocation(line: 57, column: 22, scope: !2388)
!2424 = !DILocation(line: 57, column: 14, scope: !2388)
!2425 = !DILocation(line: 57, column: 11, scope: !2388)
!2426 = !DILocation(line: 58, column: 9, scope: !2388)
!2427 = !DILocation(line: 59, column: 11, scope: !2388)
!2428 = !DILocation(line: 61, column: 13, scope: !2388)
!2429 = !DILocation(line: 61, column: 15, scope: !2388)
!2430 = !DILocation(line: 63, column: 15, scope: !2388)
!2431 = !DILocation(line: 64, column: 13, scope: !2388)
!2432 = !DILocation(line: 65, column: 9, scope: !2388)
!2433 = !DILocation(line: 67, column: 5, scope: !2388)
!2434 = !DILocation(line: 70, column: 31, scope: !2388)
!2435 = !DILocation(line: 70, column: 29, scope: !2388)
!2436 = !DILocation(line: 70, column: 11, scope: !2388)
!2437 = !DILocation(line: 74, column: 14, scope: !2388)
!2438 = !DILocation(line: 74, column: 16, scope: !2388)
!2439 = !DILocation(line: 74, column: 23, scope: !2388)
!2440 = !DILocation(line: 75, column: 21, scope: !2388)
!2441 = !DILocation(line: 75, column: 13, scope: !2388)
!2442 = !DILocation(line: 75, column: 23, scope: !2388)
!2443 = !DILocation(line: 74, column: 36, scope: !2388)
!2444 = !DILocation(line: 74, column: 8, scope: !2388)
!2445 = !DILocation(line: 74, column: 10, scope: !2388)
!2446 = !DILocation(line: 76, column: 15, scope: !2388)
!2447 = !DILocation(line: 76, column: 5, scope: !2388)
!2448 = !DILocation(line: 77, column: 1, scope: !2388)
!2449 = distinct !DISubprogram(name: "__floatundixf", scope: !101, file: !101, line: 29, type: !183, scopeLine: 30, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !100, retainedNodes: !184)
!2450 = !DILocation(line: 31, column: 9, scope: !2449)
!2451 = !DILocation(line: 31, column: 11, scope: !2449)
!2452 = !DILocation(line: 32, column: 9, scope: !2449)
!2453 = !DILocation(line: 33, column: 20, scope: !2449)
!2454 = !DILocation(line: 34, column: 31, scope: !2449)
!2455 = !DILocation(line: 34, column: 15, scope: !2449)
!2456 = !DILocation(line: 34, column: 9, scope: !2449)
!2457 = !DILocation(line: 35, column: 23, scope: !2449)
!2458 = !DILocation(line: 35, column: 21, scope: !2449)
!2459 = !DILocation(line: 35, column: 9, scope: !2449)
!2460 = !DILocation(line: 37, column: 24, scope: !2449)
!2461 = !DILocation(line: 37, column: 26, scope: !2449)
!2462 = !DILocation(line: 37, column: 8, scope: !2449)
!2463 = !DILocation(line: 37, column: 10, scope: !2449)
!2464 = !DILocation(line: 37, column: 15, scope: !2449)
!2465 = !DILocation(line: 37, column: 17, scope: !2449)
!2466 = !DILocation(line: 37, column: 21, scope: !2449)
!2467 = !DILocation(line: 38, column: 20, scope: !2449)
!2468 = !DILocation(line: 38, column: 25, scope: !2449)
!2469 = !DILocation(line: 38, column: 22, scope: !2449)
!2470 = !DILocation(line: 38, column: 8, scope: !2449)
!2471 = !DILocation(line: 38, column: 10, scope: !2449)
!2472 = !DILocation(line: 38, column: 14, scope: !2449)
!2473 = !DILocation(line: 38, column: 18, scope: !2449)
!2474 = !DILocation(line: 39, column: 15, scope: !2449)
!2475 = !DILocation(line: 39, column: 5, scope: !2449)
!2476 = !DILocation(line: 40, column: 1, scope: !2449)
!2477 = distinct !DISubprogram(name: "__floatunsidf", scope: !103, file: !103, line: 24, type: !183, scopeLine: 24, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !102, retainedNodes: !184)
!2478 = !DILocation(line: 26, column: 15, scope: !2477)
!2479 = !DILocation(line: 29, column: 9, scope: !2477)
!2480 = !DILocation(line: 29, column: 11, scope: !2477)
!2481 = !DILocation(line: 29, column: 24, scope: !2477)
!2482 = !DILocation(line: 29, column: 17, scope: !2477)
!2483 = !DILocation(line: 32, column: 55, scope: !2477)
!2484 = !DILocation(line: 32, column: 41, scope: !2477)
!2485 = !DILocation(line: 32, column: 39, scope: !2477)
!2486 = !DILocation(line: 32, column: 15, scope: !2477)
!2487 = !DILocation(line: 36, column: 41, scope: !2477)
!2488 = !DILocation(line: 36, column: 39, scope: !2477)
!2489 = !DILocation(line: 36, column: 15, scope: !2477)
!2490 = !DILocation(line: 37, column: 21, scope: !2477)
!2491 = !DILocation(line: 37, column: 14, scope: !2477)
!2492 = !DILocation(line: 37, column: 26, scope: !2477)
!2493 = !DILocation(line: 37, column: 23, scope: !2477)
!2494 = !DILocation(line: 37, column: 32, scope: !2477)
!2495 = !DILocation(line: 37, column: 12, scope: !2477)
!2496 = !DILocation(line: 40, column: 23, scope: !2477)
!2497 = !DILocation(line: 40, column: 32, scope: !2477)
!2498 = !DILocation(line: 40, column: 15, scope: !2477)
!2499 = !DILocation(line: 40, column: 48, scope: !2477)
!2500 = !DILocation(line: 40, column: 12, scope: !2477)
!2501 = !DILocation(line: 41, column: 20, scope: !2477)
!2502 = !DILocation(line: 41, column: 12, scope: !2477)
!2503 = !DILocation(line: 41, column: 5, scope: !2477)
!2504 = !DILocation(line: 42, column: 1, scope: !2477)
!2505 = distinct !DISubprogram(name: "fromRep", scope: !417, file: !417, line: 236, type: !183, scopeLine: 236, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !102, retainedNodes: !184)
!2506 = !DILocation(line: 237, column: 44, scope: !2505)
!2507 = !DILocation(line: 237, column: 50, scope: !2505)
!2508 = !DILocation(line: 238, column: 16, scope: !2505)
!2509 = !DILocation(line: 238, column: 5, scope: !2505)
!2510 = distinct !DISubprogram(name: "__floatunsisf", scope: !105, file: !105, line: 24, type: !183, scopeLine: 24, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !104, retainedNodes: !184)
!2511 = !DILocation(line: 26, column: 15, scope: !2510)
!2512 = !DILocation(line: 29, column: 9, scope: !2510)
!2513 = !DILocation(line: 29, column: 11, scope: !2510)
!2514 = !DILocation(line: 29, column: 24, scope: !2510)
!2515 = !DILocation(line: 29, column: 17, scope: !2510)
!2516 = !DILocation(line: 32, column: 55, scope: !2510)
!2517 = !DILocation(line: 32, column: 41, scope: !2510)
!2518 = !DILocation(line: 32, column: 39, scope: !2510)
!2519 = !DILocation(line: 32, column: 15, scope: !2510)
!2520 = !DILocation(line: 36, column: 9, scope: !2510)
!2521 = !DILocation(line: 36, column: 18, scope: !2510)
!2522 = !DILocation(line: 37, column: 45, scope: !2510)
!2523 = !DILocation(line: 37, column: 43, scope: !2510)
!2524 = !DILocation(line: 37, column: 19, scope: !2510)
!2525 = !DILocation(line: 38, column: 25, scope: !2510)
!2526 = !DILocation(line: 38, column: 30, scope: !2510)
!2527 = !DILocation(line: 38, column: 27, scope: !2510)
!2528 = !DILocation(line: 38, column: 36, scope: !2510)
!2529 = !DILocation(line: 38, column: 16, scope: !2510)
!2530 = !DILocation(line: 39, column: 5, scope: !2510)
!2531 = !DILocation(line: 40, column: 27, scope: !2510)
!2532 = !DILocation(line: 40, column: 36, scope: !2510)
!2533 = !DILocation(line: 40, column: 19, scope: !2510)
!2534 = !DILocation(line: 41, column: 25, scope: !2510)
!2535 = !DILocation(line: 41, column: 30, scope: !2510)
!2536 = !DILocation(line: 41, column: 27, scope: !2510)
!2537 = !DILocation(line: 41, column: 36, scope: !2510)
!2538 = !DILocation(line: 41, column: 16, scope: !2510)
!2539 = !DILocation(line: 42, column: 30, scope: !2510)
!2540 = !DILocation(line: 42, column: 48, scope: !2510)
!2541 = !DILocation(line: 42, column: 46, scope: !2510)
!2542 = !DILocation(line: 42, column: 32, scope: !2510)
!2543 = !DILocation(line: 42, column: 15, scope: !2510)
!2544 = !DILocation(line: 43, column: 13, scope: !2510)
!2545 = !DILocation(line: 43, column: 19, scope: !2510)
!2546 = !DILocation(line: 43, column: 36, scope: !2510)
!2547 = !DILocation(line: 43, column: 30, scope: !2510)
!2548 = !DILocation(line: 44, column: 13, scope: !2510)
!2549 = !DILocation(line: 44, column: 19, scope: !2510)
!2550 = !DILocation(line: 44, column: 41, scope: !2510)
!2551 = !DILocation(line: 44, column: 48, scope: !2510)
!2552 = !DILocation(line: 44, column: 38, scope: !2510)
!2553 = !DILocation(line: 44, column: 31, scope: !2510)
!2554 = !DILocation(line: 48, column: 23, scope: !2510)
!2555 = !DILocation(line: 48, column: 32, scope: !2510)
!2556 = !DILocation(line: 48, column: 48, scope: !2510)
!2557 = !DILocation(line: 48, column: 12, scope: !2510)
!2558 = !DILocation(line: 49, column: 20, scope: !2510)
!2559 = !DILocation(line: 49, column: 12, scope: !2510)
!2560 = !DILocation(line: 49, column: 5, scope: !2510)
!2561 = !DILocation(line: 50, column: 1, scope: !2510)
!2562 = distinct !DISubprogram(name: "fromRep", scope: !417, file: !417, line: 236, type: !183, scopeLine: 236, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !104, retainedNodes: !184)
!2563 = !DILocation(line: 237, column: 44, scope: !2562)
!2564 = !DILocation(line: 237, column: 50, scope: !2562)
!2565 = !DILocation(line: 238, column: 16, scope: !2562)
!2566 = !DILocation(line: 238, column: 5, scope: !2562)
!2567 = distinct !DISubprogram(name: "compilerrt_abort_impl", scope: !117, file: !117, line: 57, type: !183, scopeLine: 57, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !116, retainedNodes: !184)
!2568 = !DILocation(line: 59, column: 1, scope: !2567)
!2569 = distinct !DISubprogram(name: "__muldf3", scope: !119, file: !119, line: 20, type: !183, scopeLine: 20, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !118, retainedNodes: !184)
!2570 = !DILocation(line: 21, column: 23, scope: !2569)
!2571 = !DILocation(line: 21, column: 26, scope: !2569)
!2572 = !DILocation(line: 21, column: 12, scope: !2569)
!2573 = !DILocation(line: 21, column: 5, scope: !2569)
!2574 = distinct !DISubprogram(name: "__mulXf3__", scope: !2575, file: !2575, line: 17, type: !183, scopeLine: 17, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !118, retainedNodes: !184)
!2575 = !DIFile(filename: "../fp_mul_impl.inc", directory: "/workspaces/llvmta/testcases/libraries/builtinsfloat/buildarmv4", checksumkind: CSK_MD5, checksum: "cb8b87aca5fd73e925ac34f9720dae07")
!2576 = !DILocation(line: 18, column: 42, scope: !2574)
!2577 = !DILocation(line: 18, column: 36, scope: !2574)
!2578 = !DILocation(line: 18, column: 45, scope: !2574)
!2579 = !DILocation(line: 18, column: 64, scope: !2574)
!2580 = !DILocation(line: 18, column: 24, scope: !2574)
!2581 = !DILocation(line: 19, column: 42, scope: !2574)
!2582 = !DILocation(line: 19, column: 36, scope: !2574)
!2583 = !DILocation(line: 19, column: 45, scope: !2574)
!2584 = !DILocation(line: 19, column: 64, scope: !2574)
!2585 = !DILocation(line: 19, column: 24, scope: !2574)
!2586 = !DILocation(line: 20, column: 38, scope: !2574)
!2587 = !DILocation(line: 20, column: 32, scope: !2574)
!2588 = !DILocation(line: 20, column: 49, scope: !2574)
!2589 = !DILocation(line: 20, column: 43, scope: !2574)
!2590 = !DILocation(line: 20, column: 41, scope: !2574)
!2591 = !DILocation(line: 20, column: 53, scope: !2574)
!2592 = !DILocation(line: 20, column: 17, scope: !2574)
!2593 = !DILocation(line: 22, column: 32, scope: !2574)
!2594 = !DILocation(line: 22, column: 26, scope: !2574)
!2595 = !DILocation(line: 22, column: 35, scope: !2574)
!2596 = !DILocation(line: 22, column: 11, scope: !2574)
!2597 = !DILocation(line: 23, column: 32, scope: !2574)
!2598 = !DILocation(line: 23, column: 26, scope: !2574)
!2599 = !DILocation(line: 23, column: 35, scope: !2574)
!2600 = !DILocation(line: 23, column: 11, scope: !2574)
!2601 = !DILocation(line: 24, column: 9, scope: !2574)
!2602 = !DILocation(line: 27, column: 9, scope: !2574)
!2603 = !DILocation(line: 27, column: 18, scope: !2574)
!2604 = !DILocation(line: 27, column: 22, scope: !2574)
!2605 = !DILocation(line: 27, column: 40, scope: !2574)
!2606 = !DILocation(line: 27, column: 43, scope: !2574)
!2607 = !DILocation(line: 27, column: 52, scope: !2574)
!2608 = !DILocation(line: 27, column: 56, scope: !2574)
!2609 = !DILocation(line: 29, column: 34, scope: !2574)
!2610 = !DILocation(line: 29, column: 28, scope: !2574)
!2611 = !DILocation(line: 29, column: 37, scope: !2574)
!2612 = !DILocation(line: 29, column: 21, scope: !2574)
!2613 = !DILocation(line: 30, column: 34, scope: !2574)
!2614 = !DILocation(line: 30, column: 28, scope: !2574)
!2615 = !DILocation(line: 30, column: 37, scope: !2574)
!2616 = !DILocation(line: 30, column: 21, scope: !2574)
!2617 = !DILocation(line: 33, column: 13, scope: !2574)
!2618 = !DILocation(line: 33, column: 18, scope: !2574)
!2619 = !DILocation(line: 33, column: 49, scope: !2574)
!2620 = !DILocation(line: 33, column: 43, scope: !2574)
!2621 = !DILocation(line: 33, column: 52, scope: !2574)
!2622 = !DILocation(line: 33, column: 35, scope: !2574)
!2623 = !DILocation(line: 33, column: 28, scope: !2574)
!2624 = !DILocation(line: 35, column: 13, scope: !2574)
!2625 = !DILocation(line: 35, column: 18, scope: !2574)
!2626 = !DILocation(line: 35, column: 49, scope: !2574)
!2627 = !DILocation(line: 35, column: 43, scope: !2574)
!2628 = !DILocation(line: 35, column: 52, scope: !2574)
!2629 = !DILocation(line: 35, column: 35, scope: !2574)
!2630 = !DILocation(line: 35, column: 28, scope: !2574)
!2631 = !DILocation(line: 37, column: 13, scope: !2574)
!2632 = !DILocation(line: 37, column: 18, scope: !2574)
!2633 = !DILocation(line: 39, column: 17, scope: !2574)
!2634 = !DILocation(line: 39, column: 38, scope: !2574)
!2635 = !DILocation(line: 39, column: 45, scope: !2574)
!2636 = !DILocation(line: 39, column: 43, scope: !2574)
!2637 = !DILocation(line: 39, column: 30, scope: !2574)
!2638 = !DILocation(line: 39, column: 23, scope: !2574)
!2639 = !DILocation(line: 41, column: 25, scope: !2574)
!2640 = !DILocation(line: 41, column: 18, scope: !2574)
!2641 = !DILocation(line: 44, column: 13, scope: !2574)
!2642 = !DILocation(line: 44, column: 18, scope: !2574)
!2643 = !DILocation(line: 46, column: 17, scope: !2574)
!2644 = !DILocation(line: 46, column: 38, scope: !2574)
!2645 = !DILocation(line: 46, column: 45, scope: !2574)
!2646 = !DILocation(line: 46, column: 43, scope: !2574)
!2647 = !DILocation(line: 46, column: 30, scope: !2574)
!2648 = !DILocation(line: 46, column: 23, scope: !2574)
!2649 = !DILocation(line: 48, column: 25, scope: !2574)
!2650 = !DILocation(line: 48, column: 18, scope: !2574)
!2651 = !DILocation(line: 52, column: 14, scope: !2574)
!2652 = !DILocation(line: 52, column: 13, scope: !2574)
!2653 = !DILocation(line: 52, column: 35, scope: !2574)
!2654 = !DILocation(line: 52, column: 27, scope: !2574)
!2655 = !DILocation(line: 52, column: 20, scope: !2574)
!2656 = !DILocation(line: 54, column: 14, scope: !2574)
!2657 = !DILocation(line: 54, column: 13, scope: !2574)
!2658 = !DILocation(line: 54, column: 35, scope: !2574)
!2659 = !DILocation(line: 54, column: 27, scope: !2574)
!2660 = !DILocation(line: 54, column: 20, scope: !2574)
!2661 = !DILocation(line: 59, column: 13, scope: !2574)
!2662 = !DILocation(line: 59, column: 18, scope: !2574)
!2663 = !DILocation(line: 59, column: 42, scope: !2574)
!2664 = !DILocation(line: 59, column: 39, scope: !2574)
!2665 = !DILocation(line: 59, column: 33, scope: !2574)
!2666 = !DILocation(line: 60, column: 13, scope: !2574)
!2667 = !DILocation(line: 60, column: 18, scope: !2574)
!2668 = !DILocation(line: 60, column: 42, scope: !2574)
!2669 = !DILocation(line: 60, column: 39, scope: !2574)
!2670 = !DILocation(line: 60, column: 33, scope: !2574)
!2671 = !DILocation(line: 61, column: 5, scope: !2574)
!2672 = !DILocation(line: 66, column: 18, scope: !2574)
!2673 = !DILocation(line: 67, column: 18, scope: !2574)
!2674 = !DILocation(line: 75, column: 18, scope: !2574)
!2675 = !DILocation(line: 75, column: 32, scope: !2574)
!2676 = !DILocation(line: 75, column: 45, scope: !2574)
!2677 = !DILocation(line: 75, column: 5, scope: !2574)
!2678 = !DILocation(line: 78, column: 27, scope: !2574)
!2679 = !DILocation(line: 78, column: 39, scope: !2574)
!2680 = !DILocation(line: 78, column: 37, scope: !2574)
!2681 = !DILocation(line: 78, column: 49, scope: !2574)
!2682 = !DILocation(line: 78, column: 66, scope: !2574)
!2683 = !DILocation(line: 78, column: 64, scope: !2574)
!2684 = !DILocation(line: 78, column: 9, scope: !2574)
!2685 = !DILocation(line: 81, column: 9, scope: !2574)
!2686 = !DILocation(line: 81, column: 19, scope: !2574)
!2687 = !DILocation(line: 81, column: 49, scope: !2574)
!2688 = !DILocation(line: 81, column: 34, scope: !2574)
!2689 = !DILocation(line: 82, column: 10, scope: !2574)
!2690 = !DILocation(line: 85, column: 9, scope: !2574)
!2691 = !DILocation(line: 85, column: 25, scope: !2574)
!2692 = !DILocation(line: 85, column: 65, scope: !2574)
!2693 = !DILocation(line: 85, column: 63, scope: !2574)
!2694 = !DILocation(line: 85, column: 48, scope: !2574)
!2695 = !DILocation(line: 85, column: 41, scope: !2574)
!2696 = !DILocation(line: 87, column: 9, scope: !2574)
!2697 = !DILocation(line: 87, column: 25, scope: !2574)
!2698 = !DILocation(line: 94, column: 61, scope: !2574)
!2699 = !DILocation(line: 94, column: 47, scope: !2574)
!2700 = !DILocation(line: 94, column: 45, scope: !2574)
!2701 = !DILocation(line: 94, column: 36, scope: !2574)
!2702 = !DILocation(line: 94, column: 28, scope: !2574)
!2703 = !DILocation(line: 95, column: 13, scope: !2574)
!2704 = !DILocation(line: 95, column: 19, scope: !2574)
!2705 = !DILocation(line: 95, column: 48, scope: !2574)
!2706 = !DILocation(line: 95, column: 40, scope: !2574)
!2707 = !DILocation(line: 95, column: 33, scope: !2574)
!2708 = !DILocation(line: 99, column: 58, scope: !2574)
!2709 = !DILocation(line: 99, column: 9, scope: !2574)
!2710 = !DILocation(line: 100, column: 5, scope: !2574)
!2711 = !DILocation(line: 103, column: 19, scope: !2574)
!2712 = !DILocation(line: 104, column: 29, scope: !2574)
!2713 = !DILocation(line: 104, column: 22, scope: !2574)
!2714 = !DILocation(line: 104, column: 45, scope: !2574)
!2715 = !DILocation(line: 104, column: 19, scope: !2574)
!2716 = !DILocation(line: 108, column: 18, scope: !2574)
!2717 = !DILocation(line: 108, column: 15, scope: !2574)
!2718 = !DILocation(line: 113, column: 9, scope: !2574)
!2719 = !DILocation(line: 113, column: 19, scope: !2574)
!2720 = !DILocation(line: 113, column: 39, scope: !2574)
!2721 = !DILocation(line: 113, column: 30, scope: !2574)
!2722 = !DILocation(line: 114, column: 9, scope: !2574)
!2723 = !DILocation(line: 114, column: 19, scope: !2574)
!2724 = !DILocation(line: 114, column: 44, scope: !2574)
!2725 = !DILocation(line: 114, column: 54, scope: !2574)
!2726 = !DILocation(line: 114, column: 41, scope: !2574)
!2727 = !DILocation(line: 114, column: 31, scope: !2574)
!2728 = !DILocation(line: 115, column: 20, scope: !2574)
!2729 = !DILocation(line: 115, column: 12, scope: !2574)
!2730 = !DILocation(line: 115, column: 5, scope: !2574)
!2731 = !DILocation(line: 116, column: 1, scope: !2574)
!2732 = distinct !DISubprogram(name: "toRep", scope: !417, file: !417, line: 231, type: !183, scopeLine: 231, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !118, retainedNodes: !184)
!2733 = !DILocation(line: 232, column: 44, scope: !2732)
!2734 = !DILocation(line: 232, column: 50, scope: !2732)
!2735 = !DILocation(line: 233, column: 16, scope: !2732)
!2736 = !DILocation(line: 233, column: 5, scope: !2732)
!2737 = distinct !DISubprogram(name: "fromRep", scope: !417, file: !417, line: 236, type: !183, scopeLine: 236, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !118, retainedNodes: !184)
!2738 = !DILocation(line: 237, column: 44, scope: !2737)
!2739 = !DILocation(line: 237, column: 50, scope: !2737)
!2740 = !DILocation(line: 238, column: 16, scope: !2737)
!2741 = !DILocation(line: 238, column: 5, scope: !2737)
!2742 = distinct !DISubprogram(name: "normalize", scope: !417, file: !417, line: 241, type: !183, scopeLine: 241, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !118, retainedNodes: !184)
!2743 = !DILocation(line: 242, column: 32, scope: !2742)
!2744 = !DILocation(line: 242, column: 31, scope: !2742)
!2745 = !DILocation(line: 242, column: 23, scope: !2742)
!2746 = !DILocation(line: 242, column: 47, scope: !2742)
!2747 = !DILocation(line: 242, column: 45, scope: !2742)
!2748 = !DILocation(line: 242, column: 15, scope: !2742)
!2749 = !DILocation(line: 243, column: 22, scope: !2742)
!2750 = !DILocation(line: 243, column: 6, scope: !2742)
!2751 = !DILocation(line: 243, column: 18, scope: !2742)
!2752 = !DILocation(line: 244, column: 16, scope: !2742)
!2753 = !DILocation(line: 244, column: 14, scope: !2742)
!2754 = !DILocation(line: 244, column: 5, scope: !2742)
!2755 = distinct !DISubprogram(name: "wideMultiply", scope: !417, file: !417, line: 86, type: !183, scopeLine: 86, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !118, retainedNodes: !184)
!2756 = !DILocation(line: 88, column: 28, scope: !2755)
!2757 = !DILocation(line: 88, column: 40, scope: !2755)
!2758 = !DILocation(line: 88, column: 38, scope: !2755)
!2759 = !DILocation(line: 88, column: 20, scope: !2755)
!2760 = !DILocation(line: 89, column: 28, scope: !2755)
!2761 = !DILocation(line: 89, column: 40, scope: !2755)
!2762 = !DILocation(line: 89, column: 38, scope: !2755)
!2763 = !DILocation(line: 89, column: 20, scope: !2755)
!2764 = !DILocation(line: 90, column: 28, scope: !2755)
!2765 = !DILocation(line: 90, column: 40, scope: !2755)
!2766 = !DILocation(line: 90, column: 38, scope: !2755)
!2767 = !DILocation(line: 90, column: 20, scope: !2755)
!2768 = !DILocation(line: 91, column: 28, scope: !2755)
!2769 = !DILocation(line: 91, column: 40, scope: !2755)
!2770 = !DILocation(line: 91, column: 38, scope: !2755)
!2771 = !DILocation(line: 91, column: 20, scope: !2755)
!2772 = !DILocation(line: 93, column: 25, scope: !2755)
!2773 = !DILocation(line: 93, column: 20, scope: !2755)
!2774 = !DILocation(line: 94, column: 25, scope: !2755)
!2775 = !DILocation(line: 94, column: 41, scope: !2755)
!2776 = !DILocation(line: 94, column: 39, scope: !2755)
!2777 = !DILocation(line: 94, column: 57, scope: !2755)
!2778 = !DILocation(line: 94, column: 55, scope: !2755)
!2779 = !DILocation(line: 94, column: 20, scope: !2755)
!2780 = !DILocation(line: 95, column: 11, scope: !2755)
!2781 = !DILocation(line: 95, column: 17, scope: !2755)
!2782 = !DILocation(line: 95, column: 20, scope: !2755)
!2783 = !DILocation(line: 95, column: 14, scope: !2755)
!2784 = !DILocation(line: 95, column: 6, scope: !2755)
!2785 = !DILocation(line: 95, column: 9, scope: !2755)
!2786 = !DILocation(line: 97, column: 11, scope: !2755)
!2787 = !DILocation(line: 97, column: 27, scope: !2755)
!2788 = !DILocation(line: 97, column: 25, scope: !2755)
!2789 = !DILocation(line: 97, column: 43, scope: !2755)
!2790 = !DILocation(line: 97, column: 41, scope: !2755)
!2791 = !DILocation(line: 97, column: 56, scope: !2755)
!2792 = !DILocation(line: 97, column: 54, scope: !2755)
!2793 = !DILocation(line: 97, column: 6, scope: !2755)
!2794 = !DILocation(line: 97, column: 9, scope: !2755)
!2795 = !DILocation(line: 98, column: 1, scope: !2755)
!2796 = distinct !DISubprogram(name: "wideLeftShift", scope: !417, file: !417, line: 247, type: !183, scopeLine: 247, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !118, retainedNodes: !184)
!2797 = !DILocation(line: 248, column: 12, scope: !2796)
!2798 = !DILocation(line: 248, column: 11, scope: !2796)
!2799 = !DILocation(line: 248, column: 18, scope: !2796)
!2800 = !DILocation(line: 248, column: 15, scope: !2796)
!2801 = !DILocation(line: 248, column: 27, scope: !2796)
!2802 = !DILocation(line: 248, column: 26, scope: !2796)
!2803 = !DILocation(line: 248, column: 46, scope: !2796)
!2804 = !DILocation(line: 248, column: 44, scope: !2796)
!2805 = !DILocation(line: 248, column: 30, scope: !2796)
!2806 = !DILocation(line: 248, column: 24, scope: !2796)
!2807 = !DILocation(line: 248, column: 6, scope: !2796)
!2808 = !DILocation(line: 248, column: 9, scope: !2796)
!2809 = !DILocation(line: 249, column: 12, scope: !2796)
!2810 = !DILocation(line: 249, column: 11, scope: !2796)
!2811 = !DILocation(line: 249, column: 18, scope: !2796)
!2812 = !DILocation(line: 249, column: 15, scope: !2796)
!2813 = !DILocation(line: 249, column: 6, scope: !2796)
!2814 = !DILocation(line: 249, column: 9, scope: !2796)
!2815 = !DILocation(line: 250, column: 1, scope: !2796)
!2816 = distinct !DISubprogram(name: "wideRightShiftWithSticky", scope: !417, file: !417, line: 252, type: !183, scopeLine: 252, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !118, retainedNodes: !184)
!2817 = !DILocation(line: 253, column: 9, scope: !2816)
!2818 = !DILocation(line: 253, column: 15, scope: !2816)
!2819 = !DILocation(line: 254, column: 30, scope: !2816)
!2820 = !DILocation(line: 254, column: 29, scope: !2816)
!2821 = !DILocation(line: 254, column: 49, scope: !2816)
!2822 = !DILocation(line: 254, column: 47, scope: !2816)
!2823 = !DILocation(line: 254, column: 33, scope: !2816)
!2824 = !DILocation(line: 254, column: 20, scope: !2816)
!2825 = !DILocation(line: 255, column: 16, scope: !2816)
!2826 = !DILocation(line: 255, column: 15, scope: !2816)
!2827 = !DILocation(line: 255, column: 35, scope: !2816)
!2828 = !DILocation(line: 255, column: 33, scope: !2816)
!2829 = !DILocation(line: 255, column: 19, scope: !2816)
!2830 = !DILocation(line: 255, column: 45, scope: !2816)
!2831 = !DILocation(line: 255, column: 44, scope: !2816)
!2832 = !DILocation(line: 255, column: 51, scope: !2816)
!2833 = !DILocation(line: 255, column: 48, scope: !2816)
!2834 = !DILocation(line: 255, column: 42, scope: !2816)
!2835 = !DILocation(line: 255, column: 59, scope: !2816)
!2836 = !DILocation(line: 255, column: 57, scope: !2816)
!2837 = !DILocation(line: 255, column: 10, scope: !2816)
!2838 = !DILocation(line: 255, column: 13, scope: !2816)
!2839 = !DILocation(line: 256, column: 16, scope: !2816)
!2840 = !DILocation(line: 256, column: 15, scope: !2816)
!2841 = !DILocation(line: 256, column: 22, scope: !2816)
!2842 = !DILocation(line: 256, column: 19, scope: !2816)
!2843 = !DILocation(line: 256, column: 10, scope: !2816)
!2844 = !DILocation(line: 256, column: 13, scope: !2816)
!2845 = !DILocation(line: 257, column: 5, scope: !2816)
!2846 = !DILocation(line: 258, column: 14, scope: !2816)
!2847 = !DILocation(line: 258, column: 20, scope: !2816)
!2848 = !DILocation(line: 259, column: 30, scope: !2816)
!2849 = !DILocation(line: 259, column: 29, scope: !2816)
!2850 = !DILocation(line: 259, column: 51, scope: !2816)
!2851 = !DILocation(line: 259, column: 49, scope: !2816)
!2852 = !DILocation(line: 259, column: 33, scope: !2816)
!2853 = !DILocation(line: 259, column: 61, scope: !2816)
!2854 = !DILocation(line: 259, column: 60, scope: !2816)
!2855 = !DILocation(line: 259, column: 58, scope: !2816)
!2856 = !DILocation(line: 259, column: 20, scope: !2816)
!2857 = !DILocation(line: 260, column: 16, scope: !2816)
!2858 = !DILocation(line: 260, column: 15, scope: !2816)
!2859 = !DILocation(line: 260, column: 23, scope: !2816)
!2860 = !DILocation(line: 260, column: 29, scope: !2816)
!2861 = !DILocation(line: 260, column: 19, scope: !2816)
!2862 = !DILocation(line: 260, column: 44, scope: !2816)
!2863 = !DILocation(line: 260, column: 42, scope: !2816)
!2864 = !DILocation(line: 260, column: 10, scope: !2816)
!2865 = !DILocation(line: 260, column: 13, scope: !2816)
!2866 = !DILocation(line: 261, column: 10, scope: !2816)
!2867 = !DILocation(line: 261, column: 13, scope: !2816)
!2868 = !DILocation(line: 262, column: 5, scope: !2816)
!2869 = !DILocation(line: 263, column: 30, scope: !2816)
!2870 = !DILocation(line: 263, column: 29, scope: !2816)
!2871 = !DILocation(line: 263, column: 36, scope: !2816)
!2872 = !DILocation(line: 263, column: 35, scope: !2816)
!2873 = !DILocation(line: 263, column: 33, scope: !2816)
!2874 = !DILocation(line: 263, column: 20, scope: !2816)
!2875 = !DILocation(line: 264, column: 15, scope: !2816)
!2876 = !DILocation(line: 264, column: 10, scope: !2816)
!2877 = !DILocation(line: 264, column: 13, scope: !2816)
!2878 = !DILocation(line: 265, column: 10, scope: !2816)
!2879 = !DILocation(line: 265, column: 13, scope: !2816)
!2880 = !DILocation(line: 267, column: 1, scope: !2816)
!2881 = distinct !DISubprogram(name: "rep_clz", scope: !417, file: !417, line: 69, type: !183, scopeLine: 69, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !118, retainedNodes: !184)
!2882 = !DILocation(line: 73, column: 9, scope: !2881)
!2883 = !DILocation(line: 73, column: 11, scope: !2881)
!2884 = !DILocation(line: 74, column: 30, scope: !2881)
!2885 = !DILocation(line: 74, column: 32, scope: !2881)
!2886 = !DILocation(line: 74, column: 16, scope: !2881)
!2887 = !DILocation(line: 74, column: 9, scope: !2881)
!2888 = !DILocation(line: 76, column: 35, scope: !2881)
!2889 = !DILocation(line: 76, column: 37, scope: !2881)
!2890 = !DILocation(line: 76, column: 21, scope: !2881)
!2891 = !DILocation(line: 76, column: 19, scope: !2881)
!2892 = !DILocation(line: 76, column: 9, scope: !2881)
!2893 = !DILocation(line: 78, column: 1, scope: !2881)
!2894 = distinct !DISubprogram(name: "__muldi3", scope: !121, file: !121, line: 46, type: !183, scopeLine: 47, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !120, retainedNodes: !184)
!2895 = !DILocation(line: 49, column: 13, scope: !2894)
!2896 = !DILocation(line: 49, column: 7, scope: !2894)
!2897 = !DILocation(line: 49, column: 11, scope: !2894)
!2898 = !DILocation(line: 51, column: 13, scope: !2894)
!2899 = !DILocation(line: 51, column: 7, scope: !2894)
!2900 = !DILocation(line: 51, column: 11, scope: !2894)
!2901 = !DILocation(line: 53, column: 25, scope: !2894)
!2902 = !DILocation(line: 53, column: 27, scope: !2894)
!2903 = !DILocation(line: 53, column: 34, scope: !2894)
!2904 = !DILocation(line: 53, column: 36, scope: !2894)
!2905 = !DILocation(line: 53, column: 13, scope: !2894)
!2906 = !DILocation(line: 53, column: 7, scope: !2894)
!2907 = !DILocation(line: 53, column: 11, scope: !2894)
!2908 = !DILocation(line: 54, column: 19, scope: !2894)
!2909 = !DILocation(line: 54, column: 21, scope: !2894)
!2910 = !DILocation(line: 54, column: 30, scope: !2894)
!2911 = !DILocation(line: 54, column: 32, scope: !2894)
!2912 = !DILocation(line: 54, column: 26, scope: !2894)
!2913 = !DILocation(line: 54, column: 40, scope: !2894)
!2914 = !DILocation(line: 54, column: 42, scope: !2894)
!2915 = !DILocation(line: 54, column: 50, scope: !2894)
!2916 = !DILocation(line: 54, column: 52, scope: !2894)
!2917 = !DILocation(line: 54, column: 46, scope: !2894)
!2918 = !DILocation(line: 54, column: 36, scope: !2894)
!2919 = !DILocation(line: 54, column: 7, scope: !2894)
!2920 = !DILocation(line: 54, column: 9, scope: !2894)
!2921 = !DILocation(line: 54, column: 14, scope: !2894)
!2922 = !DILocation(line: 55, column: 14, scope: !2894)
!2923 = !DILocation(line: 55, column: 5, scope: !2894)
!2924 = distinct !DISubprogram(name: "__muldsi3", scope: !121, file: !121, line: 21, type: !183, scopeLine: 22, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !120, retainedNodes: !184)
!2925 = !DILocation(line: 24, column: 15, scope: !2924)
!2926 = !DILocation(line: 25, column: 18, scope: !2924)
!2927 = !DILocation(line: 26, column: 16, scope: !2924)
!2928 = !DILocation(line: 26, column: 18, scope: !2924)
!2929 = !DILocation(line: 26, column: 35, scope: !2924)
!2930 = !DILocation(line: 26, column: 37, scope: !2924)
!2931 = !DILocation(line: 26, column: 32, scope: !2924)
!2932 = !DILocation(line: 26, column: 7, scope: !2924)
!2933 = !DILocation(line: 26, column: 9, scope: !2924)
!2934 = !DILocation(line: 26, column: 13, scope: !2924)
!2935 = !DILocation(line: 27, column: 18, scope: !2924)
!2936 = !DILocation(line: 27, column: 20, scope: !2924)
!2937 = !DILocation(line: 27, column: 24, scope: !2924)
!2938 = !DILocation(line: 27, column: 12, scope: !2924)
!2939 = !DILocation(line: 28, column: 7, scope: !2924)
!2940 = !DILocation(line: 28, column: 9, scope: !2924)
!2941 = !DILocation(line: 28, column: 13, scope: !2924)
!2942 = !DILocation(line: 29, column: 11, scope: !2924)
!2943 = !DILocation(line: 29, column: 13, scope: !2924)
!2944 = !DILocation(line: 29, column: 35, scope: !2924)
!2945 = !DILocation(line: 29, column: 37, scope: !2924)
!2946 = !DILocation(line: 29, column: 32, scope: !2924)
!2947 = !DILocation(line: 29, column: 7, scope: !2924)
!2948 = !DILocation(line: 30, column: 17, scope: !2924)
!2949 = !DILocation(line: 30, column: 19, scope: !2924)
!2950 = !DILocation(line: 30, column: 33, scope: !2924)
!2951 = !DILocation(line: 30, column: 7, scope: !2924)
!2952 = !DILocation(line: 30, column: 9, scope: !2924)
!2953 = !DILocation(line: 30, column: 13, scope: !2924)
!2954 = !DILocation(line: 31, column: 16, scope: !2924)
!2955 = !DILocation(line: 31, column: 18, scope: !2924)
!2956 = !DILocation(line: 31, column: 7, scope: !2924)
!2957 = !DILocation(line: 31, column: 9, scope: !2924)
!2958 = !DILocation(line: 31, column: 14, scope: !2924)
!2959 = !DILocation(line: 32, column: 11, scope: !2924)
!2960 = !DILocation(line: 32, column: 13, scope: !2924)
!2961 = !DILocation(line: 32, column: 17, scope: !2924)
!2962 = !DILocation(line: 32, column: 7, scope: !2924)
!2963 = !DILocation(line: 33, column: 7, scope: !2924)
!2964 = !DILocation(line: 33, column: 9, scope: !2924)
!2965 = !DILocation(line: 33, column: 13, scope: !2924)
!2966 = !DILocation(line: 34, column: 11, scope: !2924)
!2967 = !DILocation(line: 34, column: 13, scope: !2924)
!2968 = !DILocation(line: 34, column: 35, scope: !2924)
!2969 = !DILocation(line: 34, column: 37, scope: !2924)
!2970 = !DILocation(line: 34, column: 32, scope: !2924)
!2971 = !DILocation(line: 34, column: 7, scope: !2924)
!2972 = !DILocation(line: 35, column: 17, scope: !2924)
!2973 = !DILocation(line: 35, column: 19, scope: !2924)
!2974 = !DILocation(line: 35, column: 33, scope: !2924)
!2975 = !DILocation(line: 35, column: 7, scope: !2924)
!2976 = !DILocation(line: 35, column: 9, scope: !2924)
!2977 = !DILocation(line: 35, column: 13, scope: !2924)
!2978 = !DILocation(line: 36, column: 17, scope: !2924)
!2979 = !DILocation(line: 36, column: 19, scope: !2924)
!2980 = !DILocation(line: 36, column: 7, scope: !2924)
!2981 = !DILocation(line: 36, column: 9, scope: !2924)
!2982 = !DILocation(line: 36, column: 14, scope: !2924)
!2983 = !DILocation(line: 37, column: 18, scope: !2924)
!2984 = !DILocation(line: 37, column: 20, scope: !2924)
!2985 = !DILocation(line: 37, column: 42, scope: !2924)
!2986 = !DILocation(line: 37, column: 44, scope: !2924)
!2987 = !DILocation(line: 37, column: 39, scope: !2924)
!2988 = !DILocation(line: 37, column: 7, scope: !2924)
!2989 = !DILocation(line: 37, column: 9, scope: !2924)
!2990 = !DILocation(line: 37, column: 14, scope: !2924)
!2991 = !DILocation(line: 38, column: 14, scope: !2924)
!2992 = !DILocation(line: 38, column: 5, scope: !2924)
!2993 = distinct !DISubprogram(name: "__mulodi4", scope: !123, file: !123, line: 22, type: !183, scopeLine: 23, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !122, retainedNodes: !184)
!2994 = !DILocation(line: 24, column: 15, scope: !2993)
!2995 = !DILocation(line: 25, column: 18, scope: !2993)
!2996 = !DILocation(line: 26, column: 18, scope: !2993)
!2997 = !DILocation(line: 27, column: 6, scope: !2993)
!2998 = !DILocation(line: 27, column: 15, scope: !2993)
!2999 = !DILocation(line: 28, column: 21, scope: !2993)
!3000 = !DILocation(line: 28, column: 25, scope: !2993)
!3001 = !DILocation(line: 28, column: 23, scope: !2993)
!3002 = !DILocation(line: 28, column: 12, scope: !2993)
!3003 = !DILocation(line: 29, column: 9, scope: !2993)
!3004 = !DILocation(line: 29, column: 11, scope: !2993)
!3005 = !DILocation(line: 31, column: 13, scope: !2993)
!3006 = !DILocation(line: 31, column: 15, scope: !2993)
!3007 = !DILocation(line: 31, column: 20, scope: !2993)
!3008 = !DILocation(line: 31, column: 23, scope: !2993)
!3009 = !DILocation(line: 31, column: 25, scope: !2993)
!3010 = !DILocation(line: 32, column: 7, scope: !2993)
!3011 = !DILocation(line: 32, column: 16, scope: !2993)
!3012 = !DILocation(line: 32, column: 6, scope: !2993)
!3013 = !DILocation(line: 33, column: 9, scope: !2993)
!3014 = !DILocation(line: 33, column: 2, scope: !2993)
!3015 = !DILocation(line: 35, column: 9, scope: !2993)
!3016 = !DILocation(line: 35, column: 11, scope: !2993)
!3017 = !DILocation(line: 37, column: 13, scope: !2993)
!3018 = !DILocation(line: 37, column: 15, scope: !2993)
!3019 = !DILocation(line: 37, column: 20, scope: !2993)
!3020 = !DILocation(line: 37, column: 23, scope: !2993)
!3021 = !DILocation(line: 37, column: 25, scope: !2993)
!3022 = !DILocation(line: 38, column: 7, scope: !2993)
!3023 = !DILocation(line: 38, column: 16, scope: !2993)
!3024 = !DILocation(line: 38, column: 6, scope: !2993)
!3025 = !DILocation(line: 39, column: 16, scope: !2993)
!3026 = !DILocation(line: 39, column: 9, scope: !2993)
!3027 = !DILocation(line: 41, column: 17, scope: !2993)
!3028 = !DILocation(line: 41, column: 19, scope: !2993)
!3029 = !DILocation(line: 41, column: 12, scope: !2993)
!3030 = !DILocation(line: 42, column: 21, scope: !2993)
!3031 = !DILocation(line: 42, column: 25, scope: !2993)
!3032 = !DILocation(line: 42, column: 23, scope: !2993)
!3033 = !DILocation(line: 42, column: 31, scope: !2993)
!3034 = !DILocation(line: 42, column: 29, scope: !2993)
!3035 = !DILocation(line: 42, column: 12, scope: !2993)
!3036 = !DILocation(line: 43, column: 17, scope: !2993)
!3037 = !DILocation(line: 43, column: 19, scope: !2993)
!3038 = !DILocation(line: 43, column: 12, scope: !2993)
!3039 = !DILocation(line: 44, column: 21, scope: !2993)
!3040 = !DILocation(line: 44, column: 25, scope: !2993)
!3041 = !DILocation(line: 44, column: 23, scope: !2993)
!3042 = !DILocation(line: 44, column: 31, scope: !2993)
!3043 = !DILocation(line: 44, column: 29, scope: !2993)
!3044 = !DILocation(line: 44, column: 12, scope: !2993)
!3045 = !DILocation(line: 45, column: 9, scope: !2993)
!3046 = !DILocation(line: 45, column: 15, scope: !2993)
!3047 = !DILocation(line: 45, column: 19, scope: !2993)
!3048 = !DILocation(line: 45, column: 22, scope: !2993)
!3049 = !DILocation(line: 45, column: 28, scope: !2993)
!3050 = !DILocation(line: 46, column: 16, scope: !2993)
!3051 = !DILocation(line: 46, column: 9, scope: !2993)
!3052 = !DILocation(line: 47, column: 9, scope: !2993)
!3053 = !DILocation(line: 47, column: 15, scope: !2993)
!3054 = !DILocation(line: 47, column: 12, scope: !2993)
!3055 = !DILocation(line: 49, column: 13, scope: !2993)
!3056 = !DILocation(line: 49, column: 27, scope: !2993)
!3057 = !DILocation(line: 49, column: 25, scope: !2993)
!3058 = !DILocation(line: 49, column: 19, scope: !2993)
!3059 = !DILocation(line: 50, column: 14, scope: !2993)
!3060 = !DILocation(line: 50, column: 23, scope: !2993)
!3061 = !DILocation(line: 50, column: 13, scope: !2993)
!3062 = !DILocation(line: 51, column: 5, scope: !2993)
!3063 = !DILocation(line: 54, column: 13, scope: !2993)
!3064 = !DILocation(line: 54, column: 28, scope: !2993)
!3065 = !DILocation(line: 54, column: 27, scope: !2993)
!3066 = !DILocation(line: 54, column: 25, scope: !2993)
!3067 = !DILocation(line: 54, column: 19, scope: !2993)
!3068 = !DILocation(line: 55, column: 14, scope: !2993)
!3069 = !DILocation(line: 55, column: 23, scope: !2993)
!3070 = !DILocation(line: 55, column: 13, scope: !2993)
!3071 = !DILocation(line: 57, column: 12, scope: !2993)
!3072 = !DILocation(line: 57, column: 5, scope: !2993)
!3073 = !DILocation(line: 58, column: 1, scope: !2993)
!3074 = distinct !DISubprogram(name: "__mulosi4", scope: !125, file: !125, line: 22, type: !183, scopeLine: 23, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !124, retainedNodes: !184)
!3075 = !DILocation(line: 24, column: 15, scope: !3074)
!3076 = !DILocation(line: 25, column: 18, scope: !3074)
!3077 = !DILocation(line: 26, column: 18, scope: !3074)
!3078 = !DILocation(line: 27, column: 6, scope: !3074)
!3079 = !DILocation(line: 27, column: 15, scope: !3074)
!3080 = !DILocation(line: 28, column: 21, scope: !3074)
!3081 = !DILocation(line: 28, column: 25, scope: !3074)
!3082 = !DILocation(line: 28, column: 23, scope: !3074)
!3083 = !DILocation(line: 28, column: 12, scope: !3074)
!3084 = !DILocation(line: 29, column: 9, scope: !3074)
!3085 = !DILocation(line: 29, column: 11, scope: !3074)
!3086 = !DILocation(line: 31, column: 13, scope: !3074)
!3087 = !DILocation(line: 31, column: 15, scope: !3074)
!3088 = !DILocation(line: 31, column: 20, scope: !3074)
!3089 = !DILocation(line: 31, column: 23, scope: !3074)
!3090 = !DILocation(line: 31, column: 25, scope: !3074)
!3091 = !DILocation(line: 32, column: 7, scope: !3074)
!3092 = !DILocation(line: 32, column: 16, scope: !3074)
!3093 = !DILocation(line: 32, column: 6, scope: !3074)
!3094 = !DILocation(line: 33, column: 9, scope: !3074)
!3095 = !DILocation(line: 33, column: 2, scope: !3074)
!3096 = !DILocation(line: 35, column: 9, scope: !3074)
!3097 = !DILocation(line: 35, column: 11, scope: !3074)
!3098 = !DILocation(line: 37, column: 13, scope: !3074)
!3099 = !DILocation(line: 37, column: 15, scope: !3074)
!3100 = !DILocation(line: 37, column: 20, scope: !3074)
!3101 = !DILocation(line: 37, column: 23, scope: !3074)
!3102 = !DILocation(line: 37, column: 25, scope: !3074)
!3103 = !DILocation(line: 38, column: 7, scope: !3074)
!3104 = !DILocation(line: 38, column: 16, scope: !3074)
!3105 = !DILocation(line: 38, column: 6, scope: !3074)
!3106 = !DILocation(line: 39, column: 16, scope: !3074)
!3107 = !DILocation(line: 39, column: 9, scope: !3074)
!3108 = !DILocation(line: 41, column: 17, scope: !3074)
!3109 = !DILocation(line: 41, column: 19, scope: !3074)
!3110 = !DILocation(line: 41, column: 12, scope: !3074)
!3111 = !DILocation(line: 42, column: 21, scope: !3074)
!3112 = !DILocation(line: 42, column: 25, scope: !3074)
!3113 = !DILocation(line: 42, column: 23, scope: !3074)
!3114 = !DILocation(line: 42, column: 31, scope: !3074)
!3115 = !DILocation(line: 42, column: 29, scope: !3074)
!3116 = !DILocation(line: 42, column: 12, scope: !3074)
!3117 = !DILocation(line: 43, column: 17, scope: !3074)
!3118 = !DILocation(line: 43, column: 19, scope: !3074)
!3119 = !DILocation(line: 43, column: 12, scope: !3074)
!3120 = !DILocation(line: 44, column: 21, scope: !3074)
!3121 = !DILocation(line: 44, column: 25, scope: !3074)
!3122 = !DILocation(line: 44, column: 23, scope: !3074)
!3123 = !DILocation(line: 44, column: 31, scope: !3074)
!3124 = !DILocation(line: 44, column: 29, scope: !3074)
!3125 = !DILocation(line: 44, column: 12, scope: !3074)
!3126 = !DILocation(line: 45, column: 9, scope: !3074)
!3127 = !DILocation(line: 45, column: 15, scope: !3074)
!3128 = !DILocation(line: 45, column: 19, scope: !3074)
!3129 = !DILocation(line: 45, column: 22, scope: !3074)
!3130 = !DILocation(line: 45, column: 28, scope: !3074)
!3131 = !DILocation(line: 46, column: 16, scope: !3074)
!3132 = !DILocation(line: 46, column: 9, scope: !3074)
!3133 = !DILocation(line: 47, column: 9, scope: !3074)
!3134 = !DILocation(line: 47, column: 15, scope: !3074)
!3135 = !DILocation(line: 47, column: 12, scope: !3074)
!3136 = !DILocation(line: 49, column: 13, scope: !3074)
!3137 = !DILocation(line: 49, column: 27, scope: !3074)
!3138 = !DILocation(line: 49, column: 25, scope: !3074)
!3139 = !DILocation(line: 49, column: 19, scope: !3074)
!3140 = !DILocation(line: 50, column: 14, scope: !3074)
!3141 = !DILocation(line: 50, column: 23, scope: !3074)
!3142 = !DILocation(line: 50, column: 13, scope: !3074)
!3143 = !DILocation(line: 51, column: 5, scope: !3074)
!3144 = !DILocation(line: 54, column: 13, scope: !3074)
!3145 = !DILocation(line: 54, column: 28, scope: !3074)
!3146 = !DILocation(line: 54, column: 27, scope: !3074)
!3147 = !DILocation(line: 54, column: 25, scope: !3074)
!3148 = !DILocation(line: 54, column: 19, scope: !3074)
!3149 = !DILocation(line: 55, column: 14, scope: !3074)
!3150 = !DILocation(line: 55, column: 23, scope: !3074)
!3151 = !DILocation(line: 55, column: 13, scope: !3074)
!3152 = !DILocation(line: 57, column: 12, scope: !3074)
!3153 = !DILocation(line: 57, column: 5, scope: !3074)
!3154 = !DILocation(line: 58, column: 1, scope: !3074)
!3155 = distinct !DISubprogram(name: "__mulsf3", scope: !129, file: !129, line: 20, type: !183, scopeLine: 20, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !128, retainedNodes: !184)
!3156 = !DILocation(line: 21, column: 23, scope: !3155)
!3157 = !DILocation(line: 21, column: 26, scope: !3155)
!3158 = !DILocation(line: 21, column: 12, scope: !3155)
!3159 = !DILocation(line: 21, column: 5, scope: !3155)
!3160 = distinct !DISubprogram(name: "__mulXf3__", scope: !2575, file: !2575, line: 17, type: !183, scopeLine: 17, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !128, retainedNodes: !184)
!3161 = !DILocation(line: 18, column: 42, scope: !3160)
!3162 = !DILocation(line: 18, column: 36, scope: !3160)
!3163 = !DILocation(line: 18, column: 45, scope: !3160)
!3164 = !DILocation(line: 18, column: 64, scope: !3160)
!3165 = !DILocation(line: 18, column: 24, scope: !3160)
!3166 = !DILocation(line: 19, column: 42, scope: !3160)
!3167 = !DILocation(line: 19, column: 36, scope: !3160)
!3168 = !DILocation(line: 19, column: 45, scope: !3160)
!3169 = !DILocation(line: 19, column: 64, scope: !3160)
!3170 = !DILocation(line: 19, column: 24, scope: !3160)
!3171 = !DILocation(line: 20, column: 38, scope: !3160)
!3172 = !DILocation(line: 20, column: 32, scope: !3160)
!3173 = !DILocation(line: 20, column: 49, scope: !3160)
!3174 = !DILocation(line: 20, column: 43, scope: !3160)
!3175 = !DILocation(line: 20, column: 41, scope: !3160)
!3176 = !DILocation(line: 20, column: 53, scope: !3160)
!3177 = !DILocation(line: 20, column: 17, scope: !3160)
!3178 = !DILocation(line: 22, column: 32, scope: !3160)
!3179 = !DILocation(line: 22, column: 26, scope: !3160)
!3180 = !DILocation(line: 22, column: 35, scope: !3160)
!3181 = !DILocation(line: 22, column: 11, scope: !3160)
!3182 = !DILocation(line: 23, column: 32, scope: !3160)
!3183 = !DILocation(line: 23, column: 26, scope: !3160)
!3184 = !DILocation(line: 23, column: 35, scope: !3160)
!3185 = !DILocation(line: 23, column: 11, scope: !3160)
!3186 = !DILocation(line: 24, column: 9, scope: !3160)
!3187 = !DILocation(line: 27, column: 9, scope: !3160)
!3188 = !DILocation(line: 27, column: 18, scope: !3160)
!3189 = !DILocation(line: 27, column: 22, scope: !3160)
!3190 = !DILocation(line: 27, column: 40, scope: !3160)
!3191 = !DILocation(line: 27, column: 43, scope: !3160)
!3192 = !DILocation(line: 27, column: 52, scope: !3160)
!3193 = !DILocation(line: 27, column: 56, scope: !3160)
!3194 = !DILocation(line: 29, column: 34, scope: !3160)
!3195 = !DILocation(line: 29, column: 28, scope: !3160)
!3196 = !DILocation(line: 29, column: 37, scope: !3160)
!3197 = !DILocation(line: 29, column: 21, scope: !3160)
!3198 = !DILocation(line: 30, column: 34, scope: !3160)
!3199 = !DILocation(line: 30, column: 28, scope: !3160)
!3200 = !DILocation(line: 30, column: 37, scope: !3160)
!3201 = !DILocation(line: 30, column: 21, scope: !3160)
!3202 = !DILocation(line: 33, column: 13, scope: !3160)
!3203 = !DILocation(line: 33, column: 18, scope: !3160)
!3204 = !DILocation(line: 33, column: 49, scope: !3160)
!3205 = !DILocation(line: 33, column: 43, scope: !3160)
!3206 = !DILocation(line: 33, column: 52, scope: !3160)
!3207 = !DILocation(line: 33, column: 35, scope: !3160)
!3208 = !DILocation(line: 33, column: 28, scope: !3160)
!3209 = !DILocation(line: 35, column: 13, scope: !3160)
!3210 = !DILocation(line: 35, column: 18, scope: !3160)
!3211 = !DILocation(line: 35, column: 49, scope: !3160)
!3212 = !DILocation(line: 35, column: 43, scope: !3160)
!3213 = !DILocation(line: 35, column: 52, scope: !3160)
!3214 = !DILocation(line: 35, column: 35, scope: !3160)
!3215 = !DILocation(line: 35, column: 28, scope: !3160)
!3216 = !DILocation(line: 37, column: 13, scope: !3160)
!3217 = !DILocation(line: 37, column: 18, scope: !3160)
!3218 = !DILocation(line: 39, column: 17, scope: !3160)
!3219 = !DILocation(line: 39, column: 38, scope: !3160)
!3220 = !DILocation(line: 39, column: 45, scope: !3160)
!3221 = !DILocation(line: 39, column: 43, scope: !3160)
!3222 = !DILocation(line: 39, column: 30, scope: !3160)
!3223 = !DILocation(line: 39, column: 23, scope: !3160)
!3224 = !DILocation(line: 41, column: 25, scope: !3160)
!3225 = !DILocation(line: 41, column: 18, scope: !3160)
!3226 = !DILocation(line: 44, column: 13, scope: !3160)
!3227 = !DILocation(line: 44, column: 18, scope: !3160)
!3228 = !DILocation(line: 46, column: 17, scope: !3160)
!3229 = !DILocation(line: 46, column: 38, scope: !3160)
!3230 = !DILocation(line: 46, column: 45, scope: !3160)
!3231 = !DILocation(line: 46, column: 43, scope: !3160)
!3232 = !DILocation(line: 46, column: 30, scope: !3160)
!3233 = !DILocation(line: 46, column: 23, scope: !3160)
!3234 = !DILocation(line: 48, column: 25, scope: !3160)
!3235 = !DILocation(line: 48, column: 18, scope: !3160)
!3236 = !DILocation(line: 52, column: 14, scope: !3160)
!3237 = !DILocation(line: 52, column: 13, scope: !3160)
!3238 = !DILocation(line: 52, column: 35, scope: !3160)
!3239 = !DILocation(line: 52, column: 27, scope: !3160)
!3240 = !DILocation(line: 52, column: 20, scope: !3160)
!3241 = !DILocation(line: 54, column: 14, scope: !3160)
!3242 = !DILocation(line: 54, column: 13, scope: !3160)
!3243 = !DILocation(line: 54, column: 35, scope: !3160)
!3244 = !DILocation(line: 54, column: 27, scope: !3160)
!3245 = !DILocation(line: 54, column: 20, scope: !3160)
!3246 = !DILocation(line: 59, column: 13, scope: !3160)
!3247 = !DILocation(line: 59, column: 18, scope: !3160)
!3248 = !DILocation(line: 59, column: 42, scope: !3160)
!3249 = !DILocation(line: 59, column: 39, scope: !3160)
!3250 = !DILocation(line: 59, column: 33, scope: !3160)
!3251 = !DILocation(line: 60, column: 13, scope: !3160)
!3252 = !DILocation(line: 60, column: 18, scope: !3160)
!3253 = !DILocation(line: 60, column: 42, scope: !3160)
!3254 = !DILocation(line: 60, column: 39, scope: !3160)
!3255 = !DILocation(line: 60, column: 33, scope: !3160)
!3256 = !DILocation(line: 61, column: 5, scope: !3160)
!3257 = !DILocation(line: 66, column: 18, scope: !3160)
!3258 = !DILocation(line: 67, column: 18, scope: !3160)
!3259 = !DILocation(line: 75, column: 18, scope: !3160)
!3260 = !DILocation(line: 75, column: 32, scope: !3160)
!3261 = !DILocation(line: 75, column: 45, scope: !3160)
!3262 = !DILocation(line: 75, column: 5, scope: !3160)
!3263 = !DILocation(line: 78, column: 27, scope: !3160)
!3264 = !DILocation(line: 78, column: 39, scope: !3160)
!3265 = !DILocation(line: 78, column: 37, scope: !3160)
!3266 = !DILocation(line: 78, column: 49, scope: !3160)
!3267 = !DILocation(line: 78, column: 66, scope: !3160)
!3268 = !DILocation(line: 78, column: 64, scope: !3160)
!3269 = !DILocation(line: 78, column: 9, scope: !3160)
!3270 = !DILocation(line: 81, column: 9, scope: !3160)
!3271 = !DILocation(line: 81, column: 19, scope: !3160)
!3272 = !DILocation(line: 81, column: 49, scope: !3160)
!3273 = !DILocation(line: 81, column: 34, scope: !3160)
!3274 = !DILocation(line: 82, column: 10, scope: !3160)
!3275 = !DILocation(line: 85, column: 9, scope: !3160)
!3276 = !DILocation(line: 85, column: 25, scope: !3160)
!3277 = !DILocation(line: 85, column: 65, scope: !3160)
!3278 = !DILocation(line: 85, column: 63, scope: !3160)
!3279 = !DILocation(line: 85, column: 48, scope: !3160)
!3280 = !DILocation(line: 85, column: 41, scope: !3160)
!3281 = !DILocation(line: 87, column: 9, scope: !3160)
!3282 = !DILocation(line: 87, column: 25, scope: !3160)
!3283 = !DILocation(line: 94, column: 61, scope: !3160)
!3284 = !DILocation(line: 94, column: 45, scope: !3160)
!3285 = !DILocation(line: 94, column: 28, scope: !3160)
!3286 = !DILocation(line: 95, column: 13, scope: !3160)
!3287 = !DILocation(line: 95, column: 19, scope: !3160)
!3288 = !DILocation(line: 95, column: 48, scope: !3160)
!3289 = !DILocation(line: 95, column: 40, scope: !3160)
!3290 = !DILocation(line: 95, column: 33, scope: !3160)
!3291 = !DILocation(line: 99, column: 58, scope: !3160)
!3292 = !DILocation(line: 99, column: 9, scope: !3160)
!3293 = !DILocation(line: 100, column: 5, scope: !3160)
!3294 = !DILocation(line: 103, column: 19, scope: !3160)
!3295 = !DILocation(line: 104, column: 29, scope: !3160)
!3296 = !DILocation(line: 104, column: 45, scope: !3160)
!3297 = !DILocation(line: 104, column: 19, scope: !3160)
!3298 = !DILocation(line: 108, column: 18, scope: !3160)
!3299 = !DILocation(line: 108, column: 15, scope: !3160)
!3300 = !DILocation(line: 113, column: 9, scope: !3160)
!3301 = !DILocation(line: 113, column: 19, scope: !3160)
!3302 = !DILocation(line: 113, column: 39, scope: !3160)
!3303 = !DILocation(line: 113, column: 30, scope: !3160)
!3304 = !DILocation(line: 114, column: 9, scope: !3160)
!3305 = !DILocation(line: 114, column: 19, scope: !3160)
!3306 = !DILocation(line: 114, column: 44, scope: !3160)
!3307 = !DILocation(line: 114, column: 54, scope: !3160)
!3308 = !DILocation(line: 114, column: 41, scope: !3160)
!3309 = !DILocation(line: 114, column: 31, scope: !3160)
!3310 = !DILocation(line: 115, column: 20, scope: !3160)
!3311 = !DILocation(line: 115, column: 12, scope: !3160)
!3312 = !DILocation(line: 115, column: 5, scope: !3160)
!3313 = !DILocation(line: 116, column: 1, scope: !3160)
!3314 = distinct !DISubprogram(name: "toRep", scope: !417, file: !417, line: 231, type: !183, scopeLine: 231, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !128, retainedNodes: !184)
!3315 = !DILocation(line: 232, column: 44, scope: !3314)
!3316 = !DILocation(line: 232, column: 50, scope: !3314)
!3317 = !DILocation(line: 233, column: 16, scope: !3314)
!3318 = !DILocation(line: 233, column: 5, scope: !3314)
!3319 = distinct !DISubprogram(name: "fromRep", scope: !417, file: !417, line: 236, type: !183, scopeLine: 236, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !128, retainedNodes: !184)
!3320 = !DILocation(line: 237, column: 44, scope: !3319)
!3321 = !DILocation(line: 237, column: 50, scope: !3319)
!3322 = !DILocation(line: 238, column: 16, scope: !3319)
!3323 = !DILocation(line: 238, column: 5, scope: !3319)
!3324 = distinct !DISubprogram(name: "normalize", scope: !417, file: !417, line: 241, type: !183, scopeLine: 241, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !128, retainedNodes: !184)
!3325 = !DILocation(line: 242, column: 32, scope: !3324)
!3326 = !DILocation(line: 242, column: 31, scope: !3324)
!3327 = !DILocation(line: 242, column: 23, scope: !3324)
!3328 = !DILocation(line: 242, column: 47, scope: !3324)
!3329 = !DILocation(line: 242, column: 45, scope: !3324)
!3330 = !DILocation(line: 242, column: 15, scope: !3324)
!3331 = !DILocation(line: 243, column: 22, scope: !3324)
!3332 = !DILocation(line: 243, column: 6, scope: !3324)
!3333 = !DILocation(line: 243, column: 18, scope: !3324)
!3334 = !DILocation(line: 244, column: 16, scope: !3324)
!3335 = !DILocation(line: 244, column: 14, scope: !3324)
!3336 = !DILocation(line: 244, column: 5, scope: !3324)
!3337 = distinct !DISubprogram(name: "wideMultiply", scope: !417, file: !417, line: 54, type: !183, scopeLine: 54, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !128, retainedNodes: !184)
!3338 = !DILocation(line: 55, column: 40, scope: !3337)
!3339 = !DILocation(line: 55, column: 30, scope: !3337)
!3340 = !DILocation(line: 55, column: 42, scope: !3337)
!3341 = !DILocation(line: 55, column: 41, scope: !3337)
!3342 = !DILocation(line: 55, column: 20, scope: !3337)
!3343 = !DILocation(line: 56, column: 11, scope: !3337)
!3344 = !DILocation(line: 56, column: 19, scope: !3337)
!3345 = !DILocation(line: 56, column: 6, scope: !3337)
!3346 = !DILocation(line: 56, column: 9, scope: !3337)
!3347 = !DILocation(line: 57, column: 11, scope: !3337)
!3348 = !DILocation(line: 57, column: 6, scope: !3337)
!3349 = !DILocation(line: 57, column: 9, scope: !3337)
!3350 = !DILocation(line: 58, column: 1, scope: !3337)
!3351 = distinct !DISubprogram(name: "wideLeftShift", scope: !417, file: !417, line: 247, type: !183, scopeLine: 247, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !128, retainedNodes: !184)
!3352 = !DILocation(line: 248, column: 12, scope: !3351)
!3353 = !DILocation(line: 248, column: 11, scope: !3351)
!3354 = !DILocation(line: 248, column: 18, scope: !3351)
!3355 = !DILocation(line: 248, column: 15, scope: !3351)
!3356 = !DILocation(line: 248, column: 27, scope: !3351)
!3357 = !DILocation(line: 248, column: 26, scope: !3351)
!3358 = !DILocation(line: 248, column: 46, scope: !3351)
!3359 = !DILocation(line: 248, column: 44, scope: !3351)
!3360 = !DILocation(line: 248, column: 30, scope: !3351)
!3361 = !DILocation(line: 248, column: 24, scope: !3351)
!3362 = !DILocation(line: 248, column: 6, scope: !3351)
!3363 = !DILocation(line: 248, column: 9, scope: !3351)
!3364 = !DILocation(line: 249, column: 12, scope: !3351)
!3365 = !DILocation(line: 249, column: 11, scope: !3351)
!3366 = !DILocation(line: 249, column: 18, scope: !3351)
!3367 = !DILocation(line: 249, column: 15, scope: !3351)
!3368 = !DILocation(line: 249, column: 6, scope: !3351)
!3369 = !DILocation(line: 249, column: 9, scope: !3351)
!3370 = !DILocation(line: 250, column: 1, scope: !3351)
!3371 = distinct !DISubprogram(name: "wideRightShiftWithSticky", scope: !417, file: !417, line: 252, type: !183, scopeLine: 252, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !128, retainedNodes: !184)
!3372 = !DILocation(line: 253, column: 9, scope: !3371)
!3373 = !DILocation(line: 253, column: 15, scope: !3371)
!3374 = !DILocation(line: 254, column: 30, scope: !3371)
!3375 = !DILocation(line: 254, column: 29, scope: !3371)
!3376 = !DILocation(line: 254, column: 49, scope: !3371)
!3377 = !DILocation(line: 254, column: 47, scope: !3371)
!3378 = !DILocation(line: 254, column: 33, scope: !3371)
!3379 = !DILocation(line: 254, column: 20, scope: !3371)
!3380 = !DILocation(line: 255, column: 16, scope: !3371)
!3381 = !DILocation(line: 255, column: 15, scope: !3371)
!3382 = !DILocation(line: 255, column: 35, scope: !3371)
!3383 = !DILocation(line: 255, column: 33, scope: !3371)
!3384 = !DILocation(line: 255, column: 19, scope: !3371)
!3385 = !DILocation(line: 255, column: 45, scope: !3371)
!3386 = !DILocation(line: 255, column: 44, scope: !3371)
!3387 = !DILocation(line: 255, column: 51, scope: !3371)
!3388 = !DILocation(line: 255, column: 48, scope: !3371)
!3389 = !DILocation(line: 255, column: 42, scope: !3371)
!3390 = !DILocation(line: 255, column: 59, scope: !3371)
!3391 = !DILocation(line: 255, column: 57, scope: !3371)
!3392 = !DILocation(line: 255, column: 10, scope: !3371)
!3393 = !DILocation(line: 255, column: 13, scope: !3371)
!3394 = !DILocation(line: 256, column: 16, scope: !3371)
!3395 = !DILocation(line: 256, column: 15, scope: !3371)
!3396 = !DILocation(line: 256, column: 22, scope: !3371)
!3397 = !DILocation(line: 256, column: 19, scope: !3371)
!3398 = !DILocation(line: 256, column: 10, scope: !3371)
!3399 = !DILocation(line: 256, column: 13, scope: !3371)
!3400 = !DILocation(line: 257, column: 5, scope: !3371)
!3401 = !DILocation(line: 258, column: 14, scope: !3371)
!3402 = !DILocation(line: 258, column: 20, scope: !3371)
!3403 = !DILocation(line: 259, column: 30, scope: !3371)
!3404 = !DILocation(line: 259, column: 29, scope: !3371)
!3405 = !DILocation(line: 259, column: 51, scope: !3371)
!3406 = !DILocation(line: 259, column: 49, scope: !3371)
!3407 = !DILocation(line: 259, column: 33, scope: !3371)
!3408 = !DILocation(line: 259, column: 61, scope: !3371)
!3409 = !DILocation(line: 259, column: 60, scope: !3371)
!3410 = !DILocation(line: 259, column: 58, scope: !3371)
!3411 = !DILocation(line: 259, column: 20, scope: !3371)
!3412 = !DILocation(line: 260, column: 16, scope: !3371)
!3413 = !DILocation(line: 260, column: 15, scope: !3371)
!3414 = !DILocation(line: 260, column: 23, scope: !3371)
!3415 = !DILocation(line: 260, column: 29, scope: !3371)
!3416 = !DILocation(line: 260, column: 19, scope: !3371)
!3417 = !DILocation(line: 260, column: 44, scope: !3371)
!3418 = !DILocation(line: 260, column: 42, scope: !3371)
!3419 = !DILocation(line: 260, column: 10, scope: !3371)
!3420 = !DILocation(line: 260, column: 13, scope: !3371)
!3421 = !DILocation(line: 261, column: 10, scope: !3371)
!3422 = !DILocation(line: 261, column: 13, scope: !3371)
!3423 = !DILocation(line: 262, column: 5, scope: !3371)
!3424 = !DILocation(line: 263, column: 30, scope: !3371)
!3425 = !DILocation(line: 263, column: 29, scope: !3371)
!3426 = !DILocation(line: 263, column: 36, scope: !3371)
!3427 = !DILocation(line: 263, column: 35, scope: !3371)
!3428 = !DILocation(line: 263, column: 33, scope: !3371)
!3429 = !DILocation(line: 263, column: 20, scope: !3371)
!3430 = !DILocation(line: 264, column: 15, scope: !3371)
!3431 = !DILocation(line: 264, column: 10, scope: !3371)
!3432 = !DILocation(line: 264, column: 13, scope: !3371)
!3433 = !DILocation(line: 265, column: 10, scope: !3371)
!3434 = !DILocation(line: 265, column: 13, scope: !3371)
!3435 = !DILocation(line: 267, column: 1, scope: !3371)
!3436 = distinct !DISubprogram(name: "rep_clz", scope: !417, file: !417, line: 49, type: !183, scopeLine: 49, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !128, retainedNodes: !184)
!3437 = !DILocation(line: 50, column: 26, scope: !3436)
!3438 = !DILocation(line: 50, column: 12, scope: !3436)
!3439 = !DILocation(line: 50, column: 5, scope: !3436)
!3440 = distinct !DISubprogram(name: "__negdf2", scope: !135, file: !135, line: 20, type: !183, scopeLine: 20, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !134, retainedNodes: !184)
!3441 = !DILocation(line: 21, column: 26, scope: !3440)
!3442 = !DILocation(line: 21, column: 20, scope: !3440)
!3443 = !DILocation(line: 21, column: 29, scope: !3440)
!3444 = !DILocation(line: 21, column: 12, scope: !3440)
!3445 = !DILocation(line: 21, column: 5, scope: !3440)
!3446 = distinct !DISubprogram(name: "toRep", scope: !417, file: !417, line: 231, type: !183, scopeLine: 231, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !134, retainedNodes: !184)
!3447 = !DILocation(line: 232, column: 44, scope: !3446)
!3448 = !DILocation(line: 232, column: 50, scope: !3446)
!3449 = !DILocation(line: 233, column: 16, scope: !3446)
!3450 = !DILocation(line: 233, column: 5, scope: !3446)
!3451 = distinct !DISubprogram(name: "fromRep", scope: !417, file: !417, line: 236, type: !183, scopeLine: 236, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !134, retainedNodes: !184)
!3452 = !DILocation(line: 237, column: 44, scope: !3451)
!3453 = !DILocation(line: 237, column: 50, scope: !3451)
!3454 = !DILocation(line: 238, column: 16, scope: !3451)
!3455 = !DILocation(line: 238, column: 5, scope: !3451)
!3456 = distinct !DISubprogram(name: "__negdi2", scope: !137, file: !137, line: 20, type: !183, scopeLine: 21, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !136, retainedNodes: !184)
!3457 = !DILocation(line: 25, column: 13, scope: !3456)
!3458 = !DILocation(line: 25, column: 12, scope: !3456)
!3459 = !DILocation(line: 25, column: 5, scope: !3456)
!3460 = distinct !DISubprogram(name: "__negsf2", scope: !139, file: !139, line: 20, type: !183, scopeLine: 20, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !138, retainedNodes: !184)
!3461 = !DILocation(line: 21, column: 26, scope: !3460)
!3462 = !DILocation(line: 21, column: 20, scope: !3460)
!3463 = !DILocation(line: 21, column: 29, scope: !3460)
!3464 = !DILocation(line: 21, column: 12, scope: !3460)
!3465 = !DILocation(line: 21, column: 5, scope: !3460)
!3466 = distinct !DISubprogram(name: "toRep", scope: !417, file: !417, line: 231, type: !183, scopeLine: 231, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !138, retainedNodes: !184)
!3467 = !DILocation(line: 232, column: 44, scope: !3466)
!3468 = !DILocation(line: 232, column: 50, scope: !3466)
!3469 = !DILocation(line: 233, column: 16, scope: !3466)
!3470 = !DILocation(line: 233, column: 5, scope: !3466)
!3471 = distinct !DISubprogram(name: "fromRep", scope: !417, file: !417, line: 236, type: !183, scopeLine: 236, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !138, retainedNodes: !184)
!3472 = !DILocation(line: 237, column: 44, scope: !3471)
!3473 = !DILocation(line: 237, column: 50, scope: !3471)
!3474 = !DILocation(line: 238, column: 16, scope: !3471)
!3475 = !DILocation(line: 238, column: 5, scope: !3471)
!3476 = distinct !DISubprogram(name: "__negvdi2", scope: !143, file: !143, line: 22, type: !183, scopeLine: 23, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !142, retainedNodes: !184)
!3477 = !DILocation(line: 24, column: 18, scope: !3476)
!3478 = !DILocation(line: 25, column: 9, scope: !3476)
!3479 = !DILocation(line: 25, column: 11, scope: !3476)
!3480 = !DILocation(line: 26, column: 9, scope: !3476)
!3481 = !DILocation(line: 27, column: 13, scope: !3476)
!3482 = !DILocation(line: 27, column: 12, scope: !3476)
!3483 = !DILocation(line: 27, column: 5, scope: !3476)
!3484 = distinct !DISubprogram(name: "__negvsi2", scope: !145, file: !145, line: 22, type: !183, scopeLine: 23, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !144, retainedNodes: !184)
!3485 = !DILocation(line: 24, column: 18, scope: !3484)
!3486 = !DILocation(line: 25, column: 9, scope: !3484)
!3487 = !DILocation(line: 25, column: 11, scope: !3484)
!3488 = !DILocation(line: 26, column: 9, scope: !3484)
!3489 = !DILocation(line: 27, column: 13, scope: !3484)
!3490 = !DILocation(line: 27, column: 12, scope: !3484)
!3491 = !DILocation(line: 27, column: 5, scope: !3484)
!3492 = distinct !DISubprogram(name: "__powidf2", scope: !149, file: !149, line: 20, type: !183, scopeLine: 21, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !148, retainedNodes: !184)
!3493 = !DILocation(line: 22, column: 23, scope: !3492)
!3494 = !DILocation(line: 22, column: 25, scope: !3492)
!3495 = !DILocation(line: 22, column: 15, scope: !3492)
!3496 = !DILocation(line: 23, column: 12, scope: !3492)
!3497 = !DILocation(line: 24, column: 5, scope: !3492)
!3498 = !DILocation(line: 26, column: 13, scope: !3492)
!3499 = !DILocation(line: 26, column: 15, scope: !3492)
!3500 = !DILocation(line: 27, column: 18, scope: !3492)
!3501 = !DILocation(line: 27, column: 15, scope: !3492)
!3502 = !DILocation(line: 27, column: 13, scope: !3492)
!3503 = !DILocation(line: 28, column: 11, scope: !3492)
!3504 = !DILocation(line: 29, column: 13, scope: !3492)
!3505 = !DILocation(line: 29, column: 15, scope: !3492)
!3506 = !DILocation(line: 30, column: 13, scope: !3492)
!3507 = !DILocation(line: 31, column: 14, scope: !3492)
!3508 = !DILocation(line: 31, column: 11, scope: !3492)
!3509 = distinct !{!3509, !3497, !3510}
!3510 = !DILocation(line: 32, column: 5, scope: !3492)
!3511 = !DILocation(line: 33, column: 12, scope: !3492)
!3512 = !DILocation(line: 33, column: 22, scope: !3492)
!3513 = !DILocation(line: 33, column: 21, scope: !3492)
!3514 = !DILocation(line: 33, column: 26, scope: !3492)
!3515 = !DILocation(line: 33, column: 5, scope: !3492)
!3516 = distinct !DISubprogram(name: "__powisf2", scope: !151, file: !151, line: 20, type: !183, scopeLine: 21, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !150, retainedNodes: !184)
!3517 = !DILocation(line: 22, column: 23, scope: !3516)
!3518 = !DILocation(line: 22, column: 25, scope: !3516)
!3519 = !DILocation(line: 22, column: 15, scope: !3516)
!3520 = !DILocation(line: 23, column: 11, scope: !3516)
!3521 = !DILocation(line: 24, column: 5, scope: !3516)
!3522 = !DILocation(line: 26, column: 13, scope: !3516)
!3523 = !DILocation(line: 26, column: 15, scope: !3516)
!3524 = !DILocation(line: 27, column: 18, scope: !3516)
!3525 = !DILocation(line: 27, column: 15, scope: !3516)
!3526 = !DILocation(line: 27, column: 13, scope: !3516)
!3527 = !DILocation(line: 28, column: 11, scope: !3516)
!3528 = !DILocation(line: 29, column: 13, scope: !3516)
!3529 = !DILocation(line: 29, column: 15, scope: !3516)
!3530 = !DILocation(line: 30, column: 13, scope: !3516)
!3531 = !DILocation(line: 31, column: 14, scope: !3516)
!3532 = !DILocation(line: 31, column: 11, scope: !3516)
!3533 = distinct !{!3533, !3521, !3534}
!3534 = !DILocation(line: 32, column: 5, scope: !3516)
!3535 = !DILocation(line: 33, column: 12, scope: !3516)
!3536 = !DILocation(line: 33, column: 22, scope: !3516)
!3537 = !DILocation(line: 33, column: 21, scope: !3516)
!3538 = !DILocation(line: 33, column: 26, scope: !3516)
!3539 = !DILocation(line: 33, column: 5, scope: !3516)
!3540 = distinct !DISubprogram(name: "__powixf2", scope: !155, file: !155, line: 22, type: !183, scopeLine: 23, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !154, retainedNodes: !184)
!3541 = !DILocation(line: 24, column: 23, scope: !3540)
!3542 = !DILocation(line: 24, column: 25, scope: !3540)
!3543 = !DILocation(line: 24, column: 15, scope: !3540)
!3544 = !DILocation(line: 25, column: 17, scope: !3540)
!3545 = !DILocation(line: 26, column: 5, scope: !3540)
!3546 = !DILocation(line: 28, column: 13, scope: !3540)
!3547 = !DILocation(line: 28, column: 15, scope: !3540)
!3548 = !DILocation(line: 29, column: 18, scope: !3540)
!3549 = !DILocation(line: 29, column: 15, scope: !3540)
!3550 = !DILocation(line: 29, column: 13, scope: !3540)
!3551 = !DILocation(line: 30, column: 11, scope: !3540)
!3552 = !DILocation(line: 31, column: 13, scope: !3540)
!3553 = !DILocation(line: 31, column: 15, scope: !3540)
!3554 = !DILocation(line: 32, column: 13, scope: !3540)
!3555 = !DILocation(line: 33, column: 14, scope: !3540)
!3556 = !DILocation(line: 33, column: 11, scope: !3540)
!3557 = distinct !{!3557, !3545, !3558}
!3558 = !DILocation(line: 34, column: 5, scope: !3540)
!3559 = !DILocation(line: 35, column: 12, scope: !3540)
!3560 = !DILocation(line: 35, column: 22, scope: !3540)
!3561 = !DILocation(line: 35, column: 21, scope: !3540)
!3562 = !DILocation(line: 35, column: 26, scope: !3540)
!3563 = !DILocation(line: 35, column: 5, scope: !3540)
!3564 = distinct !DISubprogram(name: "__subdf3", scope: !157, file: !157, line: 22, type: !183, scopeLine: 22, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !156, retainedNodes: !184)
!3565 = !DILocation(line: 23, column: 21, scope: !3564)
!3566 = !DILocation(line: 23, column: 38, scope: !3564)
!3567 = !DILocation(line: 23, column: 32, scope: !3564)
!3568 = !DILocation(line: 23, column: 41, scope: !3564)
!3569 = !DILocation(line: 23, column: 24, scope: !3564)
!3570 = !DILocation(line: 23, column: 12, scope: !3564)
!3571 = !DILocation(line: 23, column: 5, scope: !3564)
!3572 = distinct !DISubprogram(name: "toRep", scope: !417, file: !417, line: 231, type: !183, scopeLine: 231, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !156, retainedNodes: !184)
!3573 = !DILocation(line: 232, column: 44, scope: !3572)
!3574 = !DILocation(line: 232, column: 50, scope: !3572)
!3575 = !DILocation(line: 233, column: 16, scope: !3572)
!3576 = !DILocation(line: 233, column: 5, scope: !3572)
!3577 = distinct !DISubprogram(name: "fromRep", scope: !417, file: !417, line: 236, type: !183, scopeLine: 236, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !156, retainedNodes: !184)
!3578 = !DILocation(line: 237, column: 44, scope: !3577)
!3579 = !DILocation(line: 237, column: 50, scope: !3577)
!3580 = !DILocation(line: 238, column: 16, scope: !3577)
!3581 = !DILocation(line: 238, column: 5, scope: !3577)
!3582 = distinct !DISubprogram(name: "__subsf3", scope: !159, file: !159, line: 22, type: !183, scopeLine: 22, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !158, retainedNodes: !184)
!3583 = !DILocation(line: 23, column: 21, scope: !3582)
!3584 = !DILocation(line: 23, column: 38, scope: !3582)
!3585 = !DILocation(line: 23, column: 32, scope: !3582)
!3586 = !DILocation(line: 23, column: 41, scope: !3582)
!3587 = !DILocation(line: 23, column: 24, scope: !3582)
!3588 = !DILocation(line: 23, column: 12, scope: !3582)
!3589 = !DILocation(line: 23, column: 5, scope: !3582)
!3590 = distinct !DISubprogram(name: "toRep", scope: !417, file: !417, line: 231, type: !183, scopeLine: 231, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !158, retainedNodes: !184)
!3591 = !DILocation(line: 232, column: 44, scope: !3590)
!3592 = !DILocation(line: 232, column: 50, scope: !3590)
!3593 = !DILocation(line: 233, column: 16, scope: !3590)
!3594 = !DILocation(line: 233, column: 5, scope: !3590)
!3595 = distinct !DISubprogram(name: "fromRep", scope: !417, file: !417, line: 236, type: !183, scopeLine: 236, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !158, retainedNodes: !184)
!3596 = !DILocation(line: 237, column: 44, scope: !3595)
!3597 = !DILocation(line: 237, column: 50, scope: !3595)
!3598 = !DILocation(line: 238, column: 16, scope: !3595)
!3599 = !DILocation(line: 238, column: 5, scope: !3595)
!3600 = distinct !DISubprogram(name: "__truncdfhf2", scope: !163, file: !163, line: 16, type: !183, scopeLine: 16, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !162, retainedNodes: !184)
!3601 = !DILocation(line: 17, column: 27, scope: !3600)
!3602 = !DILocation(line: 17, column: 12, scope: !3600)
!3603 = !DILocation(line: 17, column: 5, scope: !3600)
!3604 = distinct !DISubprogram(name: "__truncXfYf2__", scope: !3605, file: !3605, line: 42, type: !183, scopeLine: 42, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !162, retainedNodes: !184)
!3605 = !DIFile(filename: "../fp_trunc_impl.inc", directory: "/workspaces/llvmta/testcases/libraries/builtinsfloat/buildarmv4", checksumkind: CSK_MD5, checksum: "6b2b11da044f1e9b292453d3c4a11a99")
!3606 = !DILocation(line: 45, column: 15, scope: !3604)
!3607 = !DILocation(line: 46, column: 15, scope: !3604)
!3608 = !DILocation(line: 47, column: 15, scope: !3604)
!3609 = !DILocation(line: 48, column: 15, scope: !3604)
!3610 = !DILocation(line: 50, column: 21, scope: !3604)
!3611 = !DILocation(line: 51, column: 21, scope: !3604)
!3612 = !DILocation(line: 52, column: 21, scope: !3604)
!3613 = !DILocation(line: 53, column: 21, scope: !3604)
!3614 = !DILocation(line: 54, column: 21, scope: !3604)
!3615 = !DILocation(line: 55, column: 21, scope: !3604)
!3616 = !DILocation(line: 56, column: 21, scope: !3604)
!3617 = !DILocation(line: 57, column: 21, scope: !3604)
!3618 = !DILocation(line: 58, column: 21, scope: !3604)
!3619 = !DILocation(line: 60, column: 15, scope: !3604)
!3620 = !DILocation(line: 61, column: 15, scope: !3604)
!3621 = !DILocation(line: 62, column: 15, scope: !3604)
!3622 = !DILocation(line: 63, column: 15, scope: !3604)
!3623 = !DILocation(line: 65, column: 15, scope: !3604)
!3624 = !DILocation(line: 66, column: 15, scope: !3604)
!3625 = !DILocation(line: 67, column: 21, scope: !3604)
!3626 = !DILocation(line: 68, column: 21, scope: !3604)
!3627 = !DILocation(line: 70, column: 21, scope: !3604)
!3628 = !DILocation(line: 71, column: 21, scope: !3604)
!3629 = !DILocation(line: 74, column: 37, scope: !3604)
!3630 = !DILocation(line: 74, column: 28, scope: !3604)
!3631 = !DILocation(line: 74, column: 21, scope: !3604)
!3632 = !DILocation(line: 75, column: 28, scope: !3604)
!3633 = !DILocation(line: 75, column: 33, scope: !3604)
!3634 = !DILocation(line: 75, column: 21, scope: !3604)
!3635 = !DILocation(line: 76, column: 28, scope: !3604)
!3636 = !DILocation(line: 76, column: 33, scope: !3604)
!3637 = !DILocation(line: 76, column: 21, scope: !3604)
!3638 = !DILocation(line: 79, column: 9, scope: !3604)
!3639 = !DILocation(line: 79, column: 14, scope: !3604)
!3640 = !DILocation(line: 79, column: 28, scope: !3604)
!3641 = !DILocation(line: 79, column: 33, scope: !3604)
!3642 = !DILocation(line: 79, column: 26, scope: !3604)
!3643 = !DILocation(line: 83, column: 21, scope: !3604)
!3644 = !DILocation(line: 83, column: 26, scope: !3604)
!3645 = !DILocation(line: 83, column: 19, scope: !3604)
!3646 = !DILocation(line: 84, column: 19, scope: !3604)
!3647 = !DILocation(line: 86, column: 37, scope: !3604)
!3648 = !DILocation(line: 86, column: 42, scope: !3604)
!3649 = !DILocation(line: 86, column: 25, scope: !3604)
!3650 = !DILocation(line: 88, column: 13, scope: !3604)
!3651 = !DILocation(line: 88, column: 23, scope: !3604)
!3652 = !DILocation(line: 89, column: 22, scope: !3604)
!3653 = !DILocation(line: 89, column: 13, scope: !3604)
!3654 = !DILocation(line: 91, column: 18, scope: !3604)
!3655 = !DILocation(line: 91, column: 28, scope: !3604)
!3656 = !DILocation(line: 92, column: 26, scope: !3604)
!3657 = !DILocation(line: 92, column: 36, scope: !3604)
!3658 = !DILocation(line: 92, column: 23, scope: !3604)
!3659 = !DILocation(line: 92, column: 13, scope: !3604)
!3660 = !DILocation(line: 93, column: 5, scope: !3604)
!3661 = !DILocation(line: 94, column: 14, scope: !3604)
!3662 = !DILocation(line: 94, column: 19, scope: !3604)
!3663 = !DILocation(line: 98, column: 19, scope: !3604)
!3664 = !DILocation(line: 99, column: 19, scope: !3604)
!3665 = !DILocation(line: 100, column: 24, scope: !3604)
!3666 = !DILocation(line: 100, column: 29, scope: !3604)
!3667 = !DILocation(line: 100, column: 43, scope: !3604)
!3668 = !DILocation(line: 100, column: 73, scope: !3604)
!3669 = !DILocation(line: 100, column: 19, scope: !3604)
!3670 = !DILocation(line: 101, column: 5, scope: !3604)
!3671 = !DILocation(line: 102, column: 14, scope: !3604)
!3672 = !DILocation(line: 102, column: 19, scope: !3604)
!3673 = !DILocation(line: 104, column: 19, scope: !3604)
!3674 = !DILocation(line: 105, column: 5, scope: !3604)
!3675 = !DILocation(line: 110, column: 26, scope: !3604)
!3676 = !DILocation(line: 110, column: 31, scope: !3604)
!3677 = !DILocation(line: 110, column: 19, scope: !3604)
!3678 = !DILocation(line: 111, column: 53, scope: !3604)
!3679 = !DILocation(line: 111, column: 51, scope: !3604)
!3680 = !DILocation(line: 111, column: 58, scope: !3604)
!3681 = !DILocation(line: 111, column: 19, scope: !3604)
!3682 = !DILocation(line: 113, column: 40, scope: !3604)
!3683 = !DILocation(line: 113, column: 45, scope: !3604)
!3684 = !DILocation(line: 113, column: 67, scope: !3604)
!3685 = !DILocation(line: 113, column: 25, scope: !3604)
!3686 = !DILocation(line: 116, column: 13, scope: !3604)
!3687 = !DILocation(line: 116, column: 19, scope: !3604)
!3688 = !DILocation(line: 117, column: 23, scope: !3604)
!3689 = !DILocation(line: 118, column: 9, scope: !3604)
!3690 = !DILocation(line: 119, column: 33, scope: !3604)
!3691 = !DILocation(line: 119, column: 59, scope: !3604)
!3692 = !DILocation(line: 119, column: 57, scope: !3604)
!3693 = !DILocation(line: 119, column: 45, scope: !3604)
!3694 = !DILocation(line: 119, column: 24, scope: !3604)
!3695 = !DILocation(line: 120, column: 49, scope: !3604)
!3696 = !DILocation(line: 120, column: 64, scope: !3604)
!3697 = !DILocation(line: 120, column: 61, scope: !3604)
!3698 = !DILocation(line: 120, column: 72, scope: !3604)
!3699 = !DILocation(line: 120, column: 70, scope: !3604)
!3700 = !DILocation(line: 120, column: 23, scope: !3604)
!3701 = !DILocation(line: 121, column: 25, scope: !3604)
!3702 = !DILocation(line: 121, column: 49, scope: !3604)
!3703 = !DILocation(line: 121, column: 23, scope: !3604)
!3704 = !DILocation(line: 122, column: 41, scope: !3604)
!3705 = !DILocation(line: 122, column: 65, scope: !3604)
!3706 = !DILocation(line: 122, column: 29, scope: !3604)
!3707 = !DILocation(line: 124, column: 17, scope: !3604)
!3708 = !DILocation(line: 124, column: 27, scope: !3604)
!3709 = !DILocation(line: 125, column: 26, scope: !3604)
!3710 = !DILocation(line: 125, column: 17, scope: !3604)
!3711 = !DILocation(line: 127, column: 22, scope: !3604)
!3712 = !DILocation(line: 127, column: 32, scope: !3604)
!3713 = !DILocation(line: 128, column: 30, scope: !3604)
!3714 = !DILocation(line: 128, column: 40, scope: !3604)
!3715 = !DILocation(line: 128, column: 27, scope: !3604)
!3716 = !DILocation(line: 128, column: 17, scope: !3604)
!3717 = !DILocation(line: 133, column: 30, scope: !3604)
!3718 = !DILocation(line: 133, column: 42, scope: !3604)
!3719 = !DILocation(line: 133, column: 47, scope: !3604)
!3720 = !DILocation(line: 133, column: 40, scope: !3604)
!3721 = !DILocation(line: 133, column: 21, scope: !3604)
!3722 = !DILocation(line: 134, column: 23, scope: !3604)
!3723 = !DILocation(line: 134, column: 12, scope: !3604)
!3724 = !DILocation(line: 134, column: 5, scope: !3604)
!3725 = distinct !DISubprogram(name: "srcToRep", scope: !3726, file: !3726, line: 66, type: !183, scopeLine: 66, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !162, retainedNodes: !184)
!3726 = !DIFile(filename: "../fp_trunc.h", directory: "/workspaces/llvmta/testcases/libraries/builtinsfloat/buildarmv4", checksumkind: CSK_MD5, checksum: "48d5e43ae7f0339c7e20f71580034d98")
!3727 = !DILocation(line: 67, column: 49, scope: !3725)
!3728 = !DILocation(line: 67, column: 55, scope: !3725)
!3729 = !DILocation(line: 68, column: 16, scope: !3725)
!3730 = !DILocation(line: 68, column: 5, scope: !3725)
!3731 = distinct !DISubprogram(name: "dstFromRep", scope: !3726, file: !3726, line: 71, type: !183, scopeLine: 71, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !162, retainedNodes: !184)
!3732 = !DILocation(line: 72, column: 49, scope: !3731)
!3733 = !DILocation(line: 72, column: 55, scope: !3731)
!3734 = !DILocation(line: 73, column: 16, scope: !3731)
!3735 = !DILocation(line: 73, column: 5, scope: !3731)
!3736 = distinct !DISubprogram(name: "__truncdfsf2", scope: !165, file: !165, line: 16, type: !183, scopeLine: 16, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !164, retainedNodes: !184)
!3737 = !DILocation(line: 17, column: 27, scope: !3736)
!3738 = !DILocation(line: 17, column: 12, scope: !3736)
!3739 = !DILocation(line: 17, column: 5, scope: !3736)
!3740 = distinct !DISubprogram(name: "__truncXfYf2__", scope: !3605, file: !3605, line: 42, type: !183, scopeLine: 42, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !164, retainedNodes: !184)
!3741 = !DILocation(line: 45, column: 15, scope: !3740)
!3742 = !DILocation(line: 46, column: 15, scope: !3740)
!3743 = !DILocation(line: 47, column: 15, scope: !3740)
!3744 = !DILocation(line: 48, column: 15, scope: !3740)
!3745 = !DILocation(line: 50, column: 21, scope: !3740)
!3746 = !DILocation(line: 51, column: 21, scope: !3740)
!3747 = !DILocation(line: 52, column: 21, scope: !3740)
!3748 = !DILocation(line: 53, column: 21, scope: !3740)
!3749 = !DILocation(line: 54, column: 21, scope: !3740)
!3750 = !DILocation(line: 55, column: 21, scope: !3740)
!3751 = !DILocation(line: 56, column: 21, scope: !3740)
!3752 = !DILocation(line: 57, column: 21, scope: !3740)
!3753 = !DILocation(line: 58, column: 21, scope: !3740)
!3754 = !DILocation(line: 60, column: 15, scope: !3740)
!3755 = !DILocation(line: 61, column: 15, scope: !3740)
!3756 = !DILocation(line: 62, column: 15, scope: !3740)
!3757 = !DILocation(line: 63, column: 15, scope: !3740)
!3758 = !DILocation(line: 65, column: 15, scope: !3740)
!3759 = !DILocation(line: 66, column: 15, scope: !3740)
!3760 = !DILocation(line: 67, column: 21, scope: !3740)
!3761 = !DILocation(line: 68, column: 21, scope: !3740)
!3762 = !DILocation(line: 70, column: 21, scope: !3740)
!3763 = !DILocation(line: 71, column: 21, scope: !3740)
!3764 = !DILocation(line: 74, column: 37, scope: !3740)
!3765 = !DILocation(line: 74, column: 28, scope: !3740)
!3766 = !DILocation(line: 74, column: 21, scope: !3740)
!3767 = !DILocation(line: 75, column: 28, scope: !3740)
!3768 = !DILocation(line: 75, column: 33, scope: !3740)
!3769 = !DILocation(line: 75, column: 21, scope: !3740)
!3770 = !DILocation(line: 76, column: 28, scope: !3740)
!3771 = !DILocation(line: 76, column: 33, scope: !3740)
!3772 = !DILocation(line: 76, column: 21, scope: !3740)
!3773 = !DILocation(line: 79, column: 9, scope: !3740)
!3774 = !DILocation(line: 79, column: 14, scope: !3740)
!3775 = !DILocation(line: 79, column: 28, scope: !3740)
!3776 = !DILocation(line: 79, column: 33, scope: !3740)
!3777 = !DILocation(line: 79, column: 26, scope: !3740)
!3778 = !DILocation(line: 83, column: 21, scope: !3740)
!3779 = !DILocation(line: 83, column: 26, scope: !3740)
!3780 = !DILocation(line: 83, column: 19, scope: !3740)
!3781 = !DILocation(line: 84, column: 19, scope: !3740)
!3782 = !DILocation(line: 86, column: 37, scope: !3740)
!3783 = !DILocation(line: 86, column: 42, scope: !3740)
!3784 = !DILocation(line: 86, column: 25, scope: !3740)
!3785 = !DILocation(line: 88, column: 13, scope: !3740)
!3786 = !DILocation(line: 88, column: 23, scope: !3740)
!3787 = !DILocation(line: 89, column: 22, scope: !3740)
!3788 = !DILocation(line: 89, column: 13, scope: !3740)
!3789 = !DILocation(line: 91, column: 18, scope: !3740)
!3790 = !DILocation(line: 91, column: 28, scope: !3740)
!3791 = !DILocation(line: 92, column: 26, scope: !3740)
!3792 = !DILocation(line: 92, column: 36, scope: !3740)
!3793 = !DILocation(line: 92, column: 23, scope: !3740)
!3794 = !DILocation(line: 92, column: 13, scope: !3740)
!3795 = !DILocation(line: 93, column: 5, scope: !3740)
!3796 = !DILocation(line: 94, column: 14, scope: !3740)
!3797 = !DILocation(line: 94, column: 19, scope: !3740)
!3798 = !DILocation(line: 98, column: 19, scope: !3740)
!3799 = !DILocation(line: 99, column: 19, scope: !3740)
!3800 = !DILocation(line: 100, column: 24, scope: !3740)
!3801 = !DILocation(line: 100, column: 29, scope: !3740)
!3802 = !DILocation(line: 100, column: 43, scope: !3740)
!3803 = !DILocation(line: 100, column: 73, scope: !3740)
!3804 = !DILocation(line: 100, column: 19, scope: !3740)
!3805 = !DILocation(line: 101, column: 5, scope: !3740)
!3806 = !DILocation(line: 102, column: 14, scope: !3740)
!3807 = !DILocation(line: 102, column: 19, scope: !3740)
!3808 = !DILocation(line: 104, column: 19, scope: !3740)
!3809 = !DILocation(line: 105, column: 5, scope: !3740)
!3810 = !DILocation(line: 110, column: 26, scope: !3740)
!3811 = !DILocation(line: 110, column: 31, scope: !3740)
!3812 = !DILocation(line: 110, column: 19, scope: !3740)
!3813 = !DILocation(line: 111, column: 53, scope: !3740)
!3814 = !DILocation(line: 111, column: 51, scope: !3740)
!3815 = !DILocation(line: 111, column: 58, scope: !3740)
!3816 = !DILocation(line: 111, column: 19, scope: !3740)
!3817 = !DILocation(line: 113, column: 40, scope: !3740)
!3818 = !DILocation(line: 113, column: 45, scope: !3740)
!3819 = !DILocation(line: 113, column: 67, scope: !3740)
!3820 = !DILocation(line: 113, column: 25, scope: !3740)
!3821 = !DILocation(line: 116, column: 13, scope: !3740)
!3822 = !DILocation(line: 116, column: 19, scope: !3740)
!3823 = !DILocation(line: 117, column: 23, scope: !3740)
!3824 = !DILocation(line: 118, column: 9, scope: !3740)
!3825 = !DILocation(line: 119, column: 33, scope: !3740)
!3826 = !DILocation(line: 119, column: 59, scope: !3740)
!3827 = !DILocation(line: 119, column: 57, scope: !3740)
!3828 = !DILocation(line: 119, column: 45, scope: !3740)
!3829 = !DILocation(line: 119, column: 24, scope: !3740)
!3830 = !DILocation(line: 120, column: 49, scope: !3740)
!3831 = !DILocation(line: 120, column: 64, scope: !3740)
!3832 = !DILocation(line: 120, column: 61, scope: !3740)
!3833 = !DILocation(line: 120, column: 72, scope: !3740)
!3834 = !DILocation(line: 120, column: 70, scope: !3740)
!3835 = !DILocation(line: 120, column: 23, scope: !3740)
!3836 = !DILocation(line: 121, column: 25, scope: !3740)
!3837 = !DILocation(line: 121, column: 49, scope: !3740)
!3838 = !DILocation(line: 121, column: 23, scope: !3740)
!3839 = !DILocation(line: 122, column: 41, scope: !3740)
!3840 = !DILocation(line: 122, column: 65, scope: !3740)
!3841 = !DILocation(line: 122, column: 29, scope: !3740)
!3842 = !DILocation(line: 124, column: 17, scope: !3740)
!3843 = !DILocation(line: 124, column: 27, scope: !3740)
!3844 = !DILocation(line: 125, column: 26, scope: !3740)
!3845 = !DILocation(line: 125, column: 17, scope: !3740)
!3846 = !DILocation(line: 127, column: 22, scope: !3740)
!3847 = !DILocation(line: 127, column: 32, scope: !3740)
!3848 = !DILocation(line: 128, column: 30, scope: !3740)
!3849 = !DILocation(line: 128, column: 40, scope: !3740)
!3850 = !DILocation(line: 128, column: 27, scope: !3740)
!3851 = !DILocation(line: 128, column: 17, scope: !3740)
!3852 = !DILocation(line: 133, column: 30, scope: !3740)
!3853 = !DILocation(line: 133, column: 42, scope: !3740)
!3854 = !DILocation(line: 133, column: 47, scope: !3740)
!3855 = !DILocation(line: 133, column: 40, scope: !3740)
!3856 = !DILocation(line: 133, column: 21, scope: !3740)
!3857 = !DILocation(line: 134, column: 23, scope: !3740)
!3858 = !DILocation(line: 134, column: 12, scope: !3740)
!3859 = !DILocation(line: 134, column: 5, scope: !3740)
!3860 = distinct !DISubprogram(name: "srcToRep", scope: !3726, file: !3726, line: 66, type: !183, scopeLine: 66, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !164, retainedNodes: !184)
!3861 = !DILocation(line: 67, column: 49, scope: !3860)
!3862 = !DILocation(line: 67, column: 55, scope: !3860)
!3863 = !DILocation(line: 68, column: 16, scope: !3860)
!3864 = !DILocation(line: 68, column: 5, scope: !3860)
!3865 = distinct !DISubprogram(name: "dstFromRep", scope: !3726, file: !3726, line: 71, type: !183, scopeLine: 71, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !164, retainedNodes: !184)
!3866 = !DILocation(line: 72, column: 49, scope: !3865)
!3867 = !DILocation(line: 72, column: 55, scope: !3865)
!3868 = !DILocation(line: 73, column: 16, scope: !3865)
!3869 = !DILocation(line: 73, column: 5, scope: !3865)
!3870 = distinct !DISubprogram(name: "__truncsfhf2", scope: !167, file: !167, line: 18, type: !183, scopeLine: 18, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !166, retainedNodes: !184)
!3871 = !DILocation(line: 19, column: 27, scope: !3870)
!3872 = !DILocation(line: 19, column: 12, scope: !3870)
!3873 = !DILocation(line: 19, column: 5, scope: !3870)
!3874 = distinct !DISubprogram(name: "__truncXfYf2__", scope: !3605, file: !3605, line: 42, type: !183, scopeLine: 42, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !166, retainedNodes: !184)
!3875 = !DILocation(line: 45, column: 15, scope: !3874)
!3876 = !DILocation(line: 46, column: 15, scope: !3874)
!3877 = !DILocation(line: 47, column: 15, scope: !3874)
!3878 = !DILocation(line: 48, column: 15, scope: !3874)
!3879 = !DILocation(line: 50, column: 21, scope: !3874)
!3880 = !DILocation(line: 51, column: 21, scope: !3874)
!3881 = !DILocation(line: 52, column: 21, scope: !3874)
!3882 = !DILocation(line: 53, column: 21, scope: !3874)
!3883 = !DILocation(line: 54, column: 21, scope: !3874)
!3884 = !DILocation(line: 55, column: 21, scope: !3874)
!3885 = !DILocation(line: 56, column: 21, scope: !3874)
!3886 = !DILocation(line: 57, column: 21, scope: !3874)
!3887 = !DILocation(line: 58, column: 21, scope: !3874)
!3888 = !DILocation(line: 60, column: 15, scope: !3874)
!3889 = !DILocation(line: 61, column: 15, scope: !3874)
!3890 = !DILocation(line: 62, column: 15, scope: !3874)
!3891 = !DILocation(line: 63, column: 15, scope: !3874)
!3892 = !DILocation(line: 65, column: 15, scope: !3874)
!3893 = !DILocation(line: 66, column: 15, scope: !3874)
!3894 = !DILocation(line: 67, column: 21, scope: !3874)
!3895 = !DILocation(line: 68, column: 21, scope: !3874)
!3896 = !DILocation(line: 70, column: 21, scope: !3874)
!3897 = !DILocation(line: 71, column: 21, scope: !3874)
!3898 = !DILocation(line: 74, column: 37, scope: !3874)
!3899 = !DILocation(line: 74, column: 28, scope: !3874)
!3900 = !DILocation(line: 74, column: 21, scope: !3874)
!3901 = !DILocation(line: 75, column: 28, scope: !3874)
!3902 = !DILocation(line: 75, column: 33, scope: !3874)
!3903 = !DILocation(line: 75, column: 21, scope: !3874)
!3904 = !DILocation(line: 76, column: 28, scope: !3874)
!3905 = !DILocation(line: 76, column: 33, scope: !3874)
!3906 = !DILocation(line: 76, column: 21, scope: !3874)
!3907 = !DILocation(line: 79, column: 9, scope: !3874)
!3908 = !DILocation(line: 79, column: 14, scope: !3874)
!3909 = !DILocation(line: 79, column: 28, scope: !3874)
!3910 = !DILocation(line: 79, column: 33, scope: !3874)
!3911 = !DILocation(line: 79, column: 26, scope: !3874)
!3912 = !DILocation(line: 83, column: 21, scope: !3874)
!3913 = !DILocation(line: 83, column: 26, scope: !3874)
!3914 = !DILocation(line: 83, column: 19, scope: !3874)
!3915 = !DILocation(line: 84, column: 19, scope: !3874)
!3916 = !DILocation(line: 86, column: 37, scope: !3874)
!3917 = !DILocation(line: 86, column: 42, scope: !3874)
!3918 = !DILocation(line: 86, column: 25, scope: !3874)
!3919 = !DILocation(line: 88, column: 13, scope: !3874)
!3920 = !DILocation(line: 88, column: 23, scope: !3874)
!3921 = !DILocation(line: 89, column: 22, scope: !3874)
!3922 = !DILocation(line: 89, column: 13, scope: !3874)
!3923 = !DILocation(line: 91, column: 18, scope: !3874)
!3924 = !DILocation(line: 91, column: 28, scope: !3874)
!3925 = !DILocation(line: 92, column: 26, scope: !3874)
!3926 = !DILocation(line: 92, column: 36, scope: !3874)
!3927 = !DILocation(line: 92, column: 23, scope: !3874)
!3928 = !DILocation(line: 92, column: 13, scope: !3874)
!3929 = !DILocation(line: 93, column: 5, scope: !3874)
!3930 = !DILocation(line: 94, column: 14, scope: !3874)
!3931 = !DILocation(line: 94, column: 19, scope: !3874)
!3932 = !DILocation(line: 98, column: 19, scope: !3874)
!3933 = !DILocation(line: 99, column: 19, scope: !3874)
!3934 = !DILocation(line: 100, column: 24, scope: !3874)
!3935 = !DILocation(line: 100, column: 29, scope: !3874)
!3936 = !DILocation(line: 100, column: 43, scope: !3874)
!3937 = !DILocation(line: 100, column: 73, scope: !3874)
!3938 = !DILocation(line: 100, column: 19, scope: !3874)
!3939 = !DILocation(line: 101, column: 5, scope: !3874)
!3940 = !DILocation(line: 102, column: 14, scope: !3874)
!3941 = !DILocation(line: 102, column: 19, scope: !3874)
!3942 = !DILocation(line: 104, column: 19, scope: !3874)
!3943 = !DILocation(line: 105, column: 5, scope: !3874)
!3944 = !DILocation(line: 110, column: 26, scope: !3874)
!3945 = !DILocation(line: 110, column: 31, scope: !3874)
!3946 = !DILocation(line: 110, column: 19, scope: !3874)
!3947 = !DILocation(line: 111, column: 53, scope: !3874)
!3948 = !DILocation(line: 111, column: 51, scope: !3874)
!3949 = !DILocation(line: 111, column: 58, scope: !3874)
!3950 = !DILocation(line: 111, column: 19, scope: !3874)
!3951 = !DILocation(line: 113, column: 40, scope: !3874)
!3952 = !DILocation(line: 113, column: 45, scope: !3874)
!3953 = !DILocation(line: 113, column: 67, scope: !3874)
!3954 = !DILocation(line: 113, column: 25, scope: !3874)
!3955 = !DILocation(line: 116, column: 13, scope: !3874)
!3956 = !DILocation(line: 116, column: 19, scope: !3874)
!3957 = !DILocation(line: 117, column: 23, scope: !3874)
!3958 = !DILocation(line: 118, column: 9, scope: !3874)
!3959 = !DILocation(line: 119, column: 33, scope: !3874)
!3960 = !DILocation(line: 119, column: 59, scope: !3874)
!3961 = !DILocation(line: 119, column: 57, scope: !3874)
!3962 = !DILocation(line: 119, column: 45, scope: !3874)
!3963 = !DILocation(line: 119, column: 24, scope: !3874)
!3964 = !DILocation(line: 120, column: 49, scope: !3874)
!3965 = !DILocation(line: 120, column: 64, scope: !3874)
!3966 = !DILocation(line: 120, column: 61, scope: !3874)
!3967 = !DILocation(line: 120, column: 72, scope: !3874)
!3968 = !DILocation(line: 120, column: 70, scope: !3874)
!3969 = !DILocation(line: 120, column: 23, scope: !3874)
!3970 = !DILocation(line: 121, column: 25, scope: !3874)
!3971 = !DILocation(line: 121, column: 49, scope: !3874)
!3972 = !DILocation(line: 121, column: 23, scope: !3874)
!3973 = !DILocation(line: 122, column: 41, scope: !3874)
!3974 = !DILocation(line: 122, column: 65, scope: !3874)
!3975 = !DILocation(line: 122, column: 29, scope: !3874)
!3976 = !DILocation(line: 124, column: 17, scope: !3874)
!3977 = !DILocation(line: 124, column: 27, scope: !3874)
!3978 = !DILocation(line: 125, column: 26, scope: !3874)
!3979 = !DILocation(line: 125, column: 17, scope: !3874)
!3980 = !DILocation(line: 127, column: 22, scope: !3874)
!3981 = !DILocation(line: 127, column: 32, scope: !3874)
!3982 = !DILocation(line: 128, column: 30, scope: !3874)
!3983 = !DILocation(line: 128, column: 40, scope: !3874)
!3984 = !DILocation(line: 128, column: 27, scope: !3874)
!3985 = !DILocation(line: 128, column: 17, scope: !3874)
!3986 = !DILocation(line: 133, column: 30, scope: !3874)
!3987 = !DILocation(line: 133, column: 42, scope: !3874)
!3988 = !DILocation(line: 133, column: 47, scope: !3874)
!3989 = !DILocation(line: 133, column: 40, scope: !3874)
!3990 = !DILocation(line: 133, column: 21, scope: !3874)
!3991 = !DILocation(line: 134, column: 23, scope: !3874)
!3992 = !DILocation(line: 134, column: 12, scope: !3874)
!3993 = !DILocation(line: 134, column: 5, scope: !3874)
!3994 = distinct !DISubprogram(name: "srcToRep", scope: !3726, file: !3726, line: 66, type: !183, scopeLine: 66, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !166, retainedNodes: !184)
!3995 = !DILocation(line: 67, column: 49, scope: !3994)
!3996 = !DILocation(line: 67, column: 55, scope: !3994)
!3997 = !DILocation(line: 68, column: 16, scope: !3994)
!3998 = !DILocation(line: 68, column: 5, scope: !3994)
!3999 = distinct !DISubprogram(name: "dstFromRep", scope: !3726, file: !3726, line: 71, type: !183, scopeLine: 71, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !166, retainedNodes: !184)
!4000 = !DILocation(line: 72, column: 49, scope: !3999)
!4001 = !DILocation(line: 72, column: 55, scope: !3999)
!4002 = !DILocation(line: 73, column: 16, scope: !3999)
!4003 = !DILocation(line: 73, column: 5, scope: !3999)
!4004 = distinct !DISubprogram(name: "__gnu_f2h_ieee", scope: !167, file: !167, line: 22, type: !183, scopeLine: 22, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !166, retainedNodes: !184)
!4005 = !DILocation(line: 23, column: 25, scope: !4004)
!4006 = !DILocation(line: 23, column: 12, scope: !4004)
!4007 = !DILocation(line: 23, column: 5, scope: !4004)
