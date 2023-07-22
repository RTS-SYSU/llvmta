; ModuleID = 'llvm-link'
source_filename = "llvm-link"
target datalayout = "e-m:e-p:32:32-Fi8-i64:64-v128:64:128-a:0:32-n32-S64"
target triple = "armv7-unknown-unknown"

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
@.str = private unnamed_addr constant [10 x i8] c"negvdi2.c\00", align 1
@__func__.__negvdi2 = private unnamed_addr constant [10 x i8] c"__negvdi2\00", align 1
@.str.50 = private unnamed_addr constant [10 x i8] c"negvsi2.c\00", align 1
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
define dso_local arm_aapcscc double @__adddf3(double %a, double %b) #0 !dbg !178 {
entry:
  %a.addr = alloca double, align 8
  %b.addr = alloca double, align 8
  store double %a, double* %a.addr, align 8
  store double %b, double* %b.addr, align 8
  %0 = load double, double* %a.addr, align 8, !dbg !180
  %1 = load double, double* %b.addr, align 8, !dbg !181
  %call = call arm_aapcs_vfpcc double @__addXf3__(double %0, double %1) #4, !dbg !182
  ret double %call, !dbg !183
}

; Function Attrs: noinline nounwind
define internal arm_aapcs_vfpcc double @__addXf3__(double %a, double %b) #0 !dbg !184 {
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
  %0 = load double, double* %a.addr, align 8, !dbg !186
  %call = call arm_aapcs_vfpcc i64 @toRep(double %0) #4, !dbg !187
  store i64 %call, i64* %aRep, align 8, !dbg !188
  %1 = load double, double* %b.addr, align 8, !dbg !189
  %call1 = call arm_aapcs_vfpcc i64 @toRep(double %1) #4, !dbg !190
  store i64 %call1, i64* %bRep, align 8, !dbg !191
  %2 = load i64, i64* %aRep, align 8, !dbg !192
  %and = and i64 %2, 9223372036854775807, !dbg !193
  store i64 %and, i64* %aAbs, align 8, !dbg !194
  %3 = load i64, i64* %bRep, align 8, !dbg !195
  %and2 = and i64 %3, 9223372036854775807, !dbg !196
  store i64 %and2, i64* %bAbs, align 8, !dbg !197
  %4 = load i64, i64* %aAbs, align 8, !dbg !198
  %sub = sub i64 %4, 1, !dbg !199
  %cmp = icmp uge i64 %sub, 9218868437227405311, !dbg !200
  br i1 %cmp, label %if.then, label %lor.lhs.false, !dbg !201

lor.lhs.false:                                    ; preds = %entry
  %5 = load i64, i64* %bAbs, align 8, !dbg !202
  %sub3 = sub i64 %5, 1, !dbg !203
  %cmp4 = icmp uge i64 %sub3, 9218868437227405311, !dbg !204
  br i1 %cmp4, label %if.then, label %if.end38, !dbg !198

if.then:                                          ; preds = %lor.lhs.false, %entry
  %6 = load i64, i64* %aAbs, align 8, !dbg !205
  %cmp5 = icmp ugt i64 %6, 9218868437227405312, !dbg !206
  br i1 %cmp5, label %if.then6, label %if.end, !dbg !205

if.then6:                                         ; preds = %if.then
  %7 = load double, double* %a.addr, align 8, !dbg !207
  %call7 = call arm_aapcs_vfpcc i64 @toRep(double %7) #4, !dbg !208
  %or = or i64 %call7, 2251799813685248, !dbg !209
  %call8 = call arm_aapcs_vfpcc double @fromRep(i64 %or) #4, !dbg !210
  store double %call8, double* %retval, align 8, !dbg !211
  br label %return, !dbg !211

if.end:                                           ; preds = %if.then
  %8 = load i64, i64* %bAbs, align 8, !dbg !212
  %cmp9 = icmp ugt i64 %8, 9218868437227405312, !dbg !213
  br i1 %cmp9, label %if.then10, label %if.end14, !dbg !212

if.then10:                                        ; preds = %if.end
  %9 = load double, double* %b.addr, align 8, !dbg !214
  %call11 = call arm_aapcs_vfpcc i64 @toRep(double %9) #4, !dbg !215
  %or12 = or i64 %call11, 2251799813685248, !dbg !216
  %call13 = call arm_aapcs_vfpcc double @fromRep(i64 %or12) #4, !dbg !217
  store double %call13, double* %retval, align 8, !dbg !218
  br label %return, !dbg !218

if.end14:                                         ; preds = %if.end
  %10 = load i64, i64* %aAbs, align 8, !dbg !219
  %cmp15 = icmp eq i64 %10, 9218868437227405312, !dbg !220
  br i1 %cmp15, label %if.then16, label %if.end22, !dbg !219

if.then16:                                        ; preds = %if.end14
  %11 = load double, double* %a.addr, align 8, !dbg !221
  %call17 = call arm_aapcs_vfpcc i64 @toRep(double %11) #4, !dbg !222
  %12 = load double, double* %b.addr, align 8, !dbg !223
  %call18 = call arm_aapcs_vfpcc i64 @toRep(double %12) #4, !dbg !224
  %xor = xor i64 %call17, %call18, !dbg !225
  %cmp19 = icmp eq i64 %xor, -9223372036854775808, !dbg !226
  br i1 %cmp19, label %if.then20, label %if.else, !dbg !227

if.then20:                                        ; preds = %if.then16
  %call21 = call arm_aapcs_vfpcc double @fromRep(i64 9221120237041090560) #4, !dbg !228
  store double %call21, double* %retval, align 8, !dbg !229
  br label %return, !dbg !229

if.else:                                          ; preds = %if.then16
  %13 = load double, double* %a.addr, align 8, !dbg !230
  store double %13, double* %retval, align 8, !dbg !231
  br label %return, !dbg !231

if.end22:                                         ; preds = %if.end14
  %14 = load i64, i64* %bAbs, align 8, !dbg !232
  %cmp23 = icmp eq i64 %14, 9218868437227405312, !dbg !233
  br i1 %cmp23, label %if.then24, label %if.end25, !dbg !232

if.then24:                                        ; preds = %if.end22
  %15 = load double, double* %b.addr, align 8, !dbg !234
  store double %15, double* %retval, align 8, !dbg !235
  br label %return, !dbg !235

if.end25:                                         ; preds = %if.end22
  %16 = load i64, i64* %aAbs, align 8, !dbg !236
  %tobool = icmp ne i64 %16, 0, !dbg !236
  br i1 %tobool, label %if.end34, label %if.then26, !dbg !237

if.then26:                                        ; preds = %if.end25
  %17 = load i64, i64* %bAbs, align 8, !dbg !238
  %tobool27 = icmp ne i64 %17, 0, !dbg !238
  br i1 %tobool27, label %if.else33, label %if.then28, !dbg !239

if.then28:                                        ; preds = %if.then26
  %18 = load double, double* %a.addr, align 8, !dbg !240
  %call29 = call arm_aapcs_vfpcc i64 @toRep(double %18) #4, !dbg !241
  %19 = load double, double* %b.addr, align 8, !dbg !242
  %call30 = call arm_aapcs_vfpcc i64 @toRep(double %19) #4, !dbg !243
  %and31 = and i64 %call29, %call30, !dbg !244
  %call32 = call arm_aapcs_vfpcc double @fromRep(i64 %and31) #4, !dbg !245
  store double %call32, double* %retval, align 8, !dbg !246
  br label %return, !dbg !246

if.else33:                                        ; preds = %if.then26
  %20 = load double, double* %b.addr, align 8, !dbg !247
  store double %20, double* %retval, align 8, !dbg !248
  br label %return, !dbg !248

if.end34:                                         ; preds = %if.end25
  %21 = load i64, i64* %bAbs, align 8, !dbg !249
  %tobool35 = icmp ne i64 %21, 0, !dbg !249
  br i1 %tobool35, label %if.end37, label %if.then36, !dbg !250

if.then36:                                        ; preds = %if.end34
  %22 = load double, double* %a.addr, align 8, !dbg !251
  store double %22, double* %retval, align 8, !dbg !252
  br label %return, !dbg !252

if.end37:                                         ; preds = %if.end34
  br label %if.end38, !dbg !253

if.end38:                                         ; preds = %if.end37, %lor.lhs.false
  %23 = load i64, i64* %bAbs, align 8, !dbg !254
  %24 = load i64, i64* %aAbs, align 8, !dbg !255
  %cmp39 = icmp ugt i64 %23, %24, !dbg !256
  br i1 %cmp39, label %if.then40, label %if.end41, !dbg !254

if.then40:                                        ; preds = %if.end38
  %25 = load i64, i64* %aRep, align 8, !dbg !257
  store i64 %25, i64* %temp, align 8, !dbg !258
  %26 = load i64, i64* %bRep, align 8, !dbg !259
  store i64 %26, i64* %aRep, align 8, !dbg !260
  %27 = load i64, i64* %temp, align 8, !dbg !261
  store i64 %27, i64* %bRep, align 8, !dbg !262
  br label %if.end41, !dbg !263

if.end41:                                         ; preds = %if.then40, %if.end38
  %28 = load i64, i64* %aRep, align 8, !dbg !264
  %shr = lshr i64 %28, 52, !dbg !265
  %and42 = and i64 %shr, 2047, !dbg !266
  %conv = trunc i64 %and42 to i32, !dbg !264
  store i32 %conv, i32* %aExponent, align 4, !dbg !267
  %29 = load i64, i64* %bRep, align 8, !dbg !268
  %shr43 = lshr i64 %29, 52, !dbg !269
  %and44 = and i64 %shr43, 2047, !dbg !270
  %conv45 = trunc i64 %and44 to i32, !dbg !268
  store i32 %conv45, i32* %bExponent, align 4, !dbg !271
  %30 = load i64, i64* %aRep, align 8, !dbg !272
  %and46 = and i64 %30, 4503599627370495, !dbg !273
  store i64 %and46, i64* %aSignificand, align 8, !dbg !274
  %31 = load i64, i64* %bRep, align 8, !dbg !275
  %and47 = and i64 %31, 4503599627370495, !dbg !276
  store i64 %and47, i64* %bSignificand, align 8, !dbg !277
  %32 = load i32, i32* %aExponent, align 4, !dbg !278
  %cmp48 = icmp eq i32 %32, 0, !dbg !279
  br i1 %cmp48, label %if.then50, label %if.end52, !dbg !278

if.then50:                                        ; preds = %if.end41
  %call51 = call arm_aapcs_vfpcc i32 @normalize(i64* %aSignificand) #4, !dbg !280
  store i32 %call51, i32* %aExponent, align 4, !dbg !281
  br label %if.end52, !dbg !282

if.end52:                                         ; preds = %if.then50, %if.end41
  %33 = load i32, i32* %bExponent, align 4, !dbg !283
  %cmp53 = icmp eq i32 %33, 0, !dbg !284
  br i1 %cmp53, label %if.then55, label %if.end57, !dbg !283

if.then55:                                        ; preds = %if.end52
  %call56 = call arm_aapcs_vfpcc i32 @normalize(i64* %bSignificand) #4, !dbg !285
  store i32 %call56, i32* %bExponent, align 4, !dbg !286
  br label %if.end57, !dbg !287

if.end57:                                         ; preds = %if.then55, %if.end52
  %34 = load i64, i64* %aRep, align 8, !dbg !288
  %and58 = and i64 %34, -9223372036854775808, !dbg !289
  store i64 %and58, i64* %resultSign, align 8, !dbg !290
  %35 = load i64, i64* %aRep, align 8, !dbg !291
  %36 = load i64, i64* %bRep, align 8, !dbg !292
  %xor59 = xor i64 %35, %36, !dbg !293
  %and60 = and i64 %xor59, -9223372036854775808, !dbg !294
  %tobool61 = icmp ne i64 %and60, 0, !dbg !295
  %frombool = zext i1 %tobool61 to i8, !dbg !296
  store i8 %frombool, i8* %subtraction, align 1, !dbg !296
  %37 = load i64, i64* %aSignificand, align 8, !dbg !297
  %or62 = or i64 %37, 4503599627370496, !dbg !298
  %shl = shl i64 %or62, 3, !dbg !299
  store i64 %shl, i64* %aSignificand, align 8, !dbg !300
  %38 = load i64, i64* %bSignificand, align 8, !dbg !301
  %or63 = or i64 %38, 4503599627370496, !dbg !302
  %shl64 = shl i64 %or63, 3, !dbg !303
  store i64 %shl64, i64* %bSignificand, align 8, !dbg !304
  %39 = load i32, i32* %aExponent, align 4, !dbg !305
  %40 = load i32, i32* %bExponent, align 4, !dbg !306
  %sub65 = sub nsw i32 %39, %40, !dbg !307
  store i32 %sub65, i32* %align, align 4, !dbg !308
  %41 = load i32, i32* %align, align 4, !dbg !309
  %tobool66 = icmp ne i32 %41, 0, !dbg !309
  br i1 %tobool66, label %if.then67, label %if.end82, !dbg !309

if.then67:                                        ; preds = %if.end57
  %42 = load i32, i32* %align, align 4, !dbg !310
  %cmp68 = icmp ult i32 %42, 64, !dbg !311
  br i1 %cmp68, label %if.then70, label %if.else80, !dbg !310

if.then70:                                        ; preds = %if.then67
  %43 = load i64, i64* %bSignificand, align 8, !dbg !312
  %44 = load i32, i32* %align, align 4, !dbg !313
  %sub71 = sub i32 64, %44, !dbg !314
  %sh_prom = zext i32 %sub71 to i64, !dbg !315
  %shl72 = shl i64 %43, %sh_prom, !dbg !315
  %tobool73 = icmp ne i64 %shl72, 0, !dbg !312
  %frombool74 = zext i1 %tobool73 to i8, !dbg !316
  store i8 %frombool74, i8* %sticky, align 1, !dbg !316
  %45 = load i64, i64* %bSignificand, align 8, !dbg !317
  %46 = load i32, i32* %align, align 4, !dbg !318
  %sh_prom75 = zext i32 %46 to i64, !dbg !319
  %shr76 = lshr i64 %45, %sh_prom75, !dbg !319
  %47 = load i8, i8* %sticky, align 1, !dbg !320
  %tobool77 = trunc i8 %47 to i1, !dbg !320
  %conv78 = zext i1 %tobool77 to i64, !dbg !320
  %or79 = or i64 %shr76, %conv78, !dbg !321
  store i64 %or79, i64* %bSignificand, align 8, !dbg !322
  br label %if.end81, !dbg !323

if.else80:                                        ; preds = %if.then67
  store i64 1, i64* %bSignificand, align 8, !dbg !324
  br label %if.end81

if.end81:                                         ; preds = %if.else80, %if.then70
  br label %if.end82, !dbg !325

if.end82:                                         ; preds = %if.end81, %if.end57
  %48 = load i8, i8* %subtraction, align 1, !dbg !326
  %tobool83 = trunc i8 %48 to i1, !dbg !326
  br i1 %tobool83, label %if.then84, label %if.else101, !dbg !326

if.then84:                                        ; preds = %if.end82
  %49 = load i64, i64* %bSignificand, align 8, !dbg !327
  %50 = load i64, i64* %aSignificand, align 8, !dbg !328
  %sub85 = sub i64 %50, %49, !dbg !328
  store i64 %sub85, i64* %aSignificand, align 8, !dbg !328
  %51 = load i64, i64* %aSignificand, align 8, !dbg !329
  %cmp86 = icmp eq i64 %51, 0, !dbg !330
  br i1 %cmp86, label %if.then88, label %if.end90, !dbg !329

if.then88:                                        ; preds = %if.then84
  %call89 = call arm_aapcs_vfpcc double @fromRep(i64 0) #4, !dbg !331
  store double %call89, double* %retval, align 8, !dbg !332
  br label %return, !dbg !332

if.end90:                                         ; preds = %if.then84
  %52 = load i64, i64* %aSignificand, align 8, !dbg !333
  %cmp91 = icmp ult i64 %52, 36028797018963968, !dbg !334
  br i1 %cmp91, label %if.then93, label %if.end100, !dbg !333

if.then93:                                        ; preds = %if.end90
  %53 = load i64, i64* %aSignificand, align 8, !dbg !335
  %call94 = call arm_aapcs_vfpcc i32 @rep_clz(i64 %53) #4, !dbg !336
  %call95 = call arm_aapcs_vfpcc i32 @rep_clz(i64 36028797018963968) #4, !dbg !337
  %sub96 = sub nsw i32 %call94, %call95, !dbg !338
  store i32 %sub96, i32* %shift, align 4, !dbg !339
  %54 = load i32, i32* %shift, align 4, !dbg !340
  %55 = load i64, i64* %aSignificand, align 8, !dbg !341
  %sh_prom97 = zext i32 %54 to i64, !dbg !341
  %shl98 = shl i64 %55, %sh_prom97, !dbg !341
  store i64 %shl98, i64* %aSignificand, align 8, !dbg !341
  %56 = load i32, i32* %shift, align 4, !dbg !342
  %57 = load i32, i32* %aExponent, align 4, !dbg !343
  %sub99 = sub nsw i32 %57, %56, !dbg !343
  store i32 %sub99, i32* %aExponent, align 4, !dbg !343
  br label %if.end100, !dbg !344

if.end100:                                        ; preds = %if.then93, %if.end90
  br label %if.end115, !dbg !345

if.else101:                                       ; preds = %if.end82
  %58 = load i64, i64* %bSignificand, align 8, !dbg !346
  %59 = load i64, i64* %aSignificand, align 8, !dbg !347
  %add = add i64 %59, %58, !dbg !347
  store i64 %add, i64* %aSignificand, align 8, !dbg !347
  %60 = load i64, i64* %aSignificand, align 8, !dbg !348
  %and102 = and i64 %60, 72057594037927936, !dbg !349
  %tobool103 = icmp ne i64 %and102, 0, !dbg !349
  br i1 %tobool103, label %if.then104, label %if.end114, !dbg !348

if.then104:                                       ; preds = %if.else101
  %61 = load i64, i64* %aSignificand, align 8, !dbg !350
  %and106 = and i64 %61, 1, !dbg !351
  %tobool107 = icmp ne i64 %and106, 0, !dbg !350
  %frombool108 = zext i1 %tobool107 to i8, !dbg !352
  store i8 %frombool108, i8* %sticky105, align 1, !dbg !352
  %62 = load i64, i64* %aSignificand, align 8, !dbg !353
  %shr109 = lshr i64 %62, 1, !dbg !354
  %63 = load i8, i8* %sticky105, align 1, !dbg !355
  %tobool110 = trunc i8 %63 to i1, !dbg !355
  %conv111 = zext i1 %tobool110 to i64, !dbg !355
  %or112 = or i64 %shr109, %conv111, !dbg !356
  store i64 %or112, i64* %aSignificand, align 8, !dbg !357
  %64 = load i32, i32* %aExponent, align 4, !dbg !358
  %add113 = add nsw i32 %64, 1, !dbg !358
  store i32 %add113, i32* %aExponent, align 4, !dbg !358
  br label %if.end114, !dbg !359

if.end114:                                        ; preds = %if.then104, %if.else101
  br label %if.end115

if.end115:                                        ; preds = %if.end114, %if.end100
  %65 = load i32, i32* %aExponent, align 4, !dbg !360
  %cmp116 = icmp sge i32 %65, 2047, !dbg !361
  br i1 %cmp116, label %if.then118, label %if.end121, !dbg !360

if.then118:                                       ; preds = %if.end115
  %66 = load i64, i64* %resultSign, align 8, !dbg !362
  %or119 = or i64 9218868437227405312, %66, !dbg !363
  %call120 = call arm_aapcs_vfpcc double @fromRep(i64 %or119) #4, !dbg !364
  store double %call120, double* %retval, align 8, !dbg !365
  br label %return, !dbg !365

if.end121:                                        ; preds = %if.end115
  %67 = load i32, i32* %aExponent, align 4, !dbg !366
  %cmp122 = icmp sle i32 %67, 0, !dbg !367
  br i1 %cmp122, label %if.then124, label %if.end138, !dbg !366

if.then124:                                       ; preds = %if.end121
  %68 = load i32, i32* %aExponent, align 4, !dbg !368
  %sub126 = sub nsw i32 1, %68, !dbg !369
  store i32 %sub126, i32* %shift125, align 4, !dbg !370
  %69 = load i64, i64* %aSignificand, align 8, !dbg !371
  %70 = load i32, i32* %shift125, align 4, !dbg !372
  %sub128 = sub i32 64, %70, !dbg !373
  %sh_prom129 = zext i32 %sub128 to i64, !dbg !374
  %shl130 = shl i64 %69, %sh_prom129, !dbg !374
  %tobool131 = icmp ne i64 %shl130, 0, !dbg !371
  %frombool132 = zext i1 %tobool131 to i8, !dbg !375
  store i8 %frombool132, i8* %sticky127, align 1, !dbg !375
  %71 = load i64, i64* %aSignificand, align 8, !dbg !376
  %72 = load i32, i32* %shift125, align 4, !dbg !377
  %sh_prom133 = zext i32 %72 to i64, !dbg !378
  %shr134 = lshr i64 %71, %sh_prom133, !dbg !378
  %73 = load i8, i8* %sticky127, align 1, !dbg !379
  %tobool135 = trunc i8 %73 to i1, !dbg !379
  %conv136 = zext i1 %tobool135 to i64, !dbg !379
  %or137 = or i64 %shr134, %conv136, !dbg !380
  store i64 %or137, i64* %aSignificand, align 8, !dbg !381
  store i32 0, i32* %aExponent, align 4, !dbg !382
  br label %if.end138, !dbg !383

if.end138:                                        ; preds = %if.then124, %if.end121
  %74 = load i64, i64* %aSignificand, align 8, !dbg !384
  %and139 = and i64 %74, 7, !dbg !385
  %conv140 = trunc i64 %and139 to i32, !dbg !384
  store i32 %conv140, i32* %roundGuardSticky, align 4, !dbg !386
  %75 = load i64, i64* %aSignificand, align 8, !dbg !387
  %shr141 = lshr i64 %75, 3, !dbg !388
  %and142 = and i64 %shr141, 4503599627370495, !dbg !389
  store i64 %and142, i64* %result, align 8, !dbg !390
  %76 = load i32, i32* %aExponent, align 4, !dbg !391
  %conv143 = sext i32 %76 to i64, !dbg !392
  %shl144 = shl i64 %conv143, 52, !dbg !393
  %77 = load i64, i64* %result, align 8, !dbg !394
  %or145 = or i64 %77, %shl144, !dbg !394
  store i64 %or145, i64* %result, align 8, !dbg !394
  %78 = load i64, i64* %resultSign, align 8, !dbg !395
  %79 = load i64, i64* %result, align 8, !dbg !396
  %or146 = or i64 %79, %78, !dbg !396
  store i64 %or146, i64* %result, align 8, !dbg !396
  %80 = load i32, i32* %roundGuardSticky, align 4, !dbg !397
  %cmp147 = icmp sgt i32 %80, 4, !dbg !398
  br i1 %cmp147, label %if.then149, label %if.end150, !dbg !397

if.then149:                                       ; preds = %if.end138
  %81 = load i64, i64* %result, align 8, !dbg !399
  %inc = add i64 %81, 1, !dbg !399
  store i64 %inc, i64* %result, align 8, !dbg !399
  br label %if.end150, !dbg !400

if.end150:                                        ; preds = %if.then149, %if.end138
  %82 = load i32, i32* %roundGuardSticky, align 4, !dbg !401
  %cmp151 = icmp eq i32 %82, 4, !dbg !402
  br i1 %cmp151, label %if.then153, label %if.end156, !dbg !401

if.then153:                                       ; preds = %if.end150
  %83 = load i64, i64* %result, align 8, !dbg !403
  %and154 = and i64 %83, 1, !dbg !404
  %84 = load i64, i64* %result, align 8, !dbg !405
  %add155 = add i64 %84, %and154, !dbg !405
  store i64 %add155, i64* %result, align 8, !dbg !405
  br label %if.end156, !dbg !406

if.end156:                                        ; preds = %if.then153, %if.end150
  %85 = load i64, i64* %result, align 8, !dbg !407
  %call157 = call arm_aapcs_vfpcc double @fromRep(i64 %85) #4, !dbg !408
  store double %call157, double* %retval, align 8, !dbg !409
  br label %return, !dbg !409

return:                                           ; preds = %if.end156, %if.then118, %if.then88, %if.then36, %if.else33, %if.then28, %if.then24, %if.else, %if.then20, %if.then10, %if.then6
  %86 = load double, double* %retval, align 8, !dbg !410
  ret double %86, !dbg !410
}

; Function Attrs: noinline nounwind
define internal arm_aapcs_vfpcc i64 @toRep(double %x) #0 !dbg !411 {
entry:
  %x.addr = alloca double, align 8
  %rep = alloca %union.anon.0, align 8
  store double %x, double* %x.addr, align 8
  %f = bitcast %union.anon.0* %rep to double*, !dbg !413
  %0 = load double, double* %x.addr, align 8, !dbg !414
  store double %0, double* %f, align 8, !dbg !413
  %i = bitcast %union.anon.0* %rep to i64*, !dbg !415
  %1 = load i64, i64* %i, align 8, !dbg !415
  ret i64 %1, !dbg !416
}

; Function Attrs: noinline nounwind
define internal arm_aapcs_vfpcc double @fromRep(i64 %x) #0 !dbg !417 {
entry:
  %x.addr = alloca i64, align 8
  %rep = alloca %union.anon.0, align 8
  store i64 %x, i64* %x.addr, align 8
  %i = bitcast %union.anon.0* %rep to i64*, !dbg !418
  %0 = load i64, i64* %x.addr, align 8, !dbg !419
  store i64 %0, i64* %i, align 8, !dbg !418
  %f = bitcast %union.anon.0* %rep to double*, !dbg !420
  %1 = load double, double* %f, align 8, !dbg !420
  ret double %1, !dbg !421
}

; Function Attrs: noinline nounwind
define internal arm_aapcs_vfpcc i32 @normalize(i64* %significand) #0 !dbg !422 {
entry:
  %significand.addr = alloca i64*, align 4
  %shift = alloca i32, align 4
  store i64* %significand, i64** %significand.addr, align 4
  %0 = load i64*, i64** %significand.addr, align 4, !dbg !423
  %1 = load i64, i64* %0, align 8, !dbg !424
  %call = call arm_aapcs_vfpcc i32 @rep_clz(i64 %1) #4, !dbg !425
  %call1 = call arm_aapcs_vfpcc i32 @rep_clz(i64 4503599627370496) #4, !dbg !426
  %sub = sub nsw i32 %call, %call1, !dbg !427
  store i32 %sub, i32* %shift, align 4, !dbg !428
  %2 = load i32, i32* %shift, align 4, !dbg !429
  %3 = load i64*, i64** %significand.addr, align 4, !dbg !430
  %4 = load i64, i64* %3, align 8, !dbg !431
  %sh_prom = zext i32 %2 to i64, !dbg !431
  %shl = shl i64 %4, %sh_prom, !dbg !431
  store i64 %shl, i64* %3, align 8, !dbg !431
  %5 = load i32, i32* %shift, align 4, !dbg !432
  %sub2 = sub nsw i32 1, %5, !dbg !433
  ret i32 %sub2, !dbg !434
}

; Function Attrs: noinline nounwind
define internal arm_aapcs_vfpcc i32 @rep_clz(i64 %a) #0 !dbg !435 {
entry:
  %retval = alloca i32, align 4
  %a.addr = alloca i64, align 8
  store i64 %a, i64* %a.addr, align 8
  %0 = load i64, i64* %a.addr, align 8, !dbg !436
  %and = and i64 %0, -4294967296, !dbg !437
  %tobool = icmp ne i64 %and, 0, !dbg !437
  br i1 %tobool, label %if.then, label %if.else, !dbg !436

if.then:                                          ; preds = %entry
  %1 = load i64, i64* %a.addr, align 8, !dbg !438
  %shr = lshr i64 %1, 32, !dbg !439
  %conv = trunc i64 %shr to i32, !dbg !438
  %2 = call i32 @llvm.ctlz.i32(i32 %conv, i1 false), !dbg !440
  store i32 %2, i32* %retval, align 4, !dbg !441
  br label %return, !dbg !441

if.else:                                          ; preds = %entry
  %3 = load i64, i64* %a.addr, align 8, !dbg !442
  %and1 = and i64 %3, 4294967295, !dbg !443
  %conv2 = trunc i64 %and1 to i32, !dbg !442
  %4 = call i32 @llvm.ctlz.i32(i32 %conv2, i1 false), !dbg !444
  %add = add nsw i32 32, %4, !dbg !445
  store i32 %add, i32* %retval, align 4, !dbg !446
  br label %return, !dbg !446

return:                                           ; preds = %if.else, %if.then
  %5 = load i32, i32* %retval, align 4, !dbg !447
  ret i32 %5, !dbg !447
}

; Function Attrs: nounwind readnone speculatable
declare i32 @llvm.ctlz.i32(i32, i1 immarg) #1

; Function Attrs: noinline nounwind
define dso_local arm_aapcscc float @__addsf3(float %a, float %b) #0 !dbg !448 {
entry:
  %a.addr = alloca float, align 4
  %b.addr = alloca float, align 4
  store float %a, float* %a.addr, align 4
  store float %b, float* %b.addr, align 4
  %0 = load float, float* %a.addr, align 4, !dbg !449
  %1 = load float, float* %b.addr, align 4, !dbg !450
  %call = call arm_aapcs_vfpcc float @__addXf3__.1(float %0, float %1) #4, !dbg !451
  ret float %call, !dbg !452
}

; Function Attrs: noinline nounwind
define internal arm_aapcs_vfpcc float @__addXf3__.1(float %a, float %b) #0 !dbg !453 {
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
  %0 = load float, float* %a.addr, align 4, !dbg !454
  %call = call arm_aapcs_vfpcc i32 @toRep.2(float %0) #4, !dbg !455
  store i32 %call, i32* %aRep, align 4, !dbg !456
  %1 = load float, float* %b.addr, align 4, !dbg !457
  %call1 = call arm_aapcs_vfpcc i32 @toRep.2(float %1) #4, !dbg !458
  store i32 %call1, i32* %bRep, align 4, !dbg !459
  %2 = load i32, i32* %aRep, align 4, !dbg !460
  %and = and i32 %2, 2147483647, !dbg !461
  store i32 %and, i32* %aAbs, align 4, !dbg !462
  %3 = load i32, i32* %bRep, align 4, !dbg !463
  %and2 = and i32 %3, 2147483647, !dbg !464
  store i32 %and2, i32* %bAbs, align 4, !dbg !465
  %4 = load i32, i32* %aAbs, align 4, !dbg !466
  %sub = sub i32 %4, 1, !dbg !467
  %cmp = icmp uge i32 %sub, 2139095039, !dbg !468
  br i1 %cmp, label %if.then, label %lor.lhs.false, !dbg !469

lor.lhs.false:                                    ; preds = %entry
  %5 = load i32, i32* %bAbs, align 4, !dbg !470
  %sub3 = sub i32 %5, 1, !dbg !471
  %cmp4 = icmp uge i32 %sub3, 2139095039, !dbg !472
  br i1 %cmp4, label %if.then, label %if.end38, !dbg !466

if.then:                                          ; preds = %lor.lhs.false, %entry
  %6 = load i32, i32* %aAbs, align 4, !dbg !473
  %cmp5 = icmp ugt i32 %6, 2139095040, !dbg !474
  br i1 %cmp5, label %if.then6, label %if.end, !dbg !473

if.then6:                                         ; preds = %if.then
  %7 = load float, float* %a.addr, align 4, !dbg !475
  %call7 = call arm_aapcs_vfpcc i32 @toRep.2(float %7) #4, !dbg !476
  %or = or i32 %call7, 4194304, !dbg !477
  %call8 = call arm_aapcs_vfpcc float @fromRep.3(i32 %or) #4, !dbg !478
  store float %call8, float* %retval, align 4, !dbg !479
  br label %return, !dbg !479

if.end:                                           ; preds = %if.then
  %8 = load i32, i32* %bAbs, align 4, !dbg !480
  %cmp9 = icmp ugt i32 %8, 2139095040, !dbg !481
  br i1 %cmp9, label %if.then10, label %if.end14, !dbg !480

if.then10:                                        ; preds = %if.end
  %9 = load float, float* %b.addr, align 4, !dbg !482
  %call11 = call arm_aapcs_vfpcc i32 @toRep.2(float %9) #4, !dbg !483
  %or12 = or i32 %call11, 4194304, !dbg !484
  %call13 = call arm_aapcs_vfpcc float @fromRep.3(i32 %or12) #4, !dbg !485
  store float %call13, float* %retval, align 4, !dbg !486
  br label %return, !dbg !486

if.end14:                                         ; preds = %if.end
  %10 = load i32, i32* %aAbs, align 4, !dbg !487
  %cmp15 = icmp eq i32 %10, 2139095040, !dbg !488
  br i1 %cmp15, label %if.then16, label %if.end22, !dbg !487

if.then16:                                        ; preds = %if.end14
  %11 = load float, float* %a.addr, align 4, !dbg !489
  %call17 = call arm_aapcs_vfpcc i32 @toRep.2(float %11) #4, !dbg !490
  %12 = load float, float* %b.addr, align 4, !dbg !491
  %call18 = call arm_aapcs_vfpcc i32 @toRep.2(float %12) #4, !dbg !492
  %xor = xor i32 %call17, %call18, !dbg !493
  %cmp19 = icmp eq i32 %xor, -2147483648, !dbg !494
  br i1 %cmp19, label %if.then20, label %if.else, !dbg !495

if.then20:                                        ; preds = %if.then16
  %call21 = call arm_aapcs_vfpcc float @fromRep.3(i32 2143289344) #4, !dbg !496
  store float %call21, float* %retval, align 4, !dbg !497
  br label %return, !dbg !497

if.else:                                          ; preds = %if.then16
  %13 = load float, float* %a.addr, align 4, !dbg !498
  store float %13, float* %retval, align 4, !dbg !499
  br label %return, !dbg !499

if.end22:                                         ; preds = %if.end14
  %14 = load i32, i32* %bAbs, align 4, !dbg !500
  %cmp23 = icmp eq i32 %14, 2139095040, !dbg !501
  br i1 %cmp23, label %if.then24, label %if.end25, !dbg !500

if.then24:                                        ; preds = %if.end22
  %15 = load float, float* %b.addr, align 4, !dbg !502
  store float %15, float* %retval, align 4, !dbg !503
  br label %return, !dbg !503

if.end25:                                         ; preds = %if.end22
  %16 = load i32, i32* %aAbs, align 4, !dbg !504
  %tobool = icmp ne i32 %16, 0, !dbg !504
  br i1 %tobool, label %if.end34, label %if.then26, !dbg !505

if.then26:                                        ; preds = %if.end25
  %17 = load i32, i32* %bAbs, align 4, !dbg !506
  %tobool27 = icmp ne i32 %17, 0, !dbg !506
  br i1 %tobool27, label %if.else33, label %if.then28, !dbg !507

if.then28:                                        ; preds = %if.then26
  %18 = load float, float* %a.addr, align 4, !dbg !508
  %call29 = call arm_aapcs_vfpcc i32 @toRep.2(float %18) #4, !dbg !509
  %19 = load float, float* %b.addr, align 4, !dbg !510
  %call30 = call arm_aapcs_vfpcc i32 @toRep.2(float %19) #4, !dbg !511
  %and31 = and i32 %call29, %call30, !dbg !512
  %call32 = call arm_aapcs_vfpcc float @fromRep.3(i32 %and31) #4, !dbg !513
  store float %call32, float* %retval, align 4, !dbg !514
  br label %return, !dbg !514

if.else33:                                        ; preds = %if.then26
  %20 = load float, float* %b.addr, align 4, !dbg !515
  store float %20, float* %retval, align 4, !dbg !516
  br label %return, !dbg !516

if.end34:                                         ; preds = %if.end25
  %21 = load i32, i32* %bAbs, align 4, !dbg !517
  %tobool35 = icmp ne i32 %21, 0, !dbg !517
  br i1 %tobool35, label %if.end37, label %if.then36, !dbg !518

if.then36:                                        ; preds = %if.end34
  %22 = load float, float* %a.addr, align 4, !dbg !519
  store float %22, float* %retval, align 4, !dbg !520
  br label %return, !dbg !520

if.end37:                                         ; preds = %if.end34
  br label %if.end38, !dbg !521

if.end38:                                         ; preds = %if.end37, %lor.lhs.false
  %23 = load i32, i32* %bAbs, align 4, !dbg !522
  %24 = load i32, i32* %aAbs, align 4, !dbg !523
  %cmp39 = icmp ugt i32 %23, %24, !dbg !524
  br i1 %cmp39, label %if.then40, label %if.end41, !dbg !522

if.then40:                                        ; preds = %if.end38
  %25 = load i32, i32* %aRep, align 4, !dbg !525
  store i32 %25, i32* %temp, align 4, !dbg !526
  %26 = load i32, i32* %bRep, align 4, !dbg !527
  store i32 %26, i32* %aRep, align 4, !dbg !528
  %27 = load i32, i32* %temp, align 4, !dbg !529
  store i32 %27, i32* %bRep, align 4, !dbg !530
  br label %if.end41, !dbg !531

if.end41:                                         ; preds = %if.then40, %if.end38
  %28 = load i32, i32* %aRep, align 4, !dbg !532
  %shr = lshr i32 %28, 23, !dbg !533
  %and42 = and i32 %shr, 255, !dbg !534
  store i32 %and42, i32* %aExponent, align 4, !dbg !535
  %29 = load i32, i32* %bRep, align 4, !dbg !536
  %shr43 = lshr i32 %29, 23, !dbg !537
  %and44 = and i32 %shr43, 255, !dbg !538
  store i32 %and44, i32* %bExponent, align 4, !dbg !539
  %30 = load i32, i32* %aRep, align 4, !dbg !540
  %and45 = and i32 %30, 8388607, !dbg !541
  store i32 %and45, i32* %aSignificand, align 4, !dbg !542
  %31 = load i32, i32* %bRep, align 4, !dbg !543
  %and46 = and i32 %31, 8388607, !dbg !544
  store i32 %and46, i32* %bSignificand, align 4, !dbg !545
  %32 = load i32, i32* %aExponent, align 4, !dbg !546
  %cmp47 = icmp eq i32 %32, 0, !dbg !547
  br i1 %cmp47, label %if.then48, label %if.end50, !dbg !546

if.then48:                                        ; preds = %if.end41
  %call49 = call arm_aapcs_vfpcc i32 @normalize.4(i32* %aSignificand) #4, !dbg !548
  store i32 %call49, i32* %aExponent, align 4, !dbg !549
  br label %if.end50, !dbg !550

if.end50:                                         ; preds = %if.then48, %if.end41
  %33 = load i32, i32* %bExponent, align 4, !dbg !551
  %cmp51 = icmp eq i32 %33, 0, !dbg !552
  br i1 %cmp51, label %if.then52, label %if.end54, !dbg !551

if.then52:                                        ; preds = %if.end50
  %call53 = call arm_aapcs_vfpcc i32 @normalize.4(i32* %bSignificand) #4, !dbg !553
  store i32 %call53, i32* %bExponent, align 4, !dbg !554
  br label %if.end54, !dbg !555

if.end54:                                         ; preds = %if.then52, %if.end50
  %34 = load i32, i32* %aRep, align 4, !dbg !556
  %and55 = and i32 %34, -2147483648, !dbg !557
  store i32 %and55, i32* %resultSign, align 4, !dbg !558
  %35 = load i32, i32* %aRep, align 4, !dbg !559
  %36 = load i32, i32* %bRep, align 4, !dbg !560
  %xor56 = xor i32 %35, %36, !dbg !561
  %and57 = and i32 %xor56, -2147483648, !dbg !562
  %tobool58 = icmp ne i32 %and57, 0, !dbg !563
  %frombool = zext i1 %tobool58 to i8, !dbg !564
  store i8 %frombool, i8* %subtraction, align 1, !dbg !564
  %37 = load i32, i32* %aSignificand, align 4, !dbg !565
  %or59 = or i32 %37, 8388608, !dbg !566
  %shl = shl i32 %or59, 3, !dbg !567
  store i32 %shl, i32* %aSignificand, align 4, !dbg !568
  %38 = load i32, i32* %bSignificand, align 4, !dbg !569
  %or60 = or i32 %38, 8388608, !dbg !570
  %shl61 = shl i32 %or60, 3, !dbg !571
  store i32 %shl61, i32* %bSignificand, align 4, !dbg !572
  %39 = load i32, i32* %aExponent, align 4, !dbg !573
  %40 = load i32, i32* %bExponent, align 4, !dbg !574
  %sub62 = sub nsw i32 %39, %40, !dbg !575
  store i32 %sub62, i32* %align, align 4, !dbg !576
  %41 = load i32, i32* %align, align 4, !dbg !577
  %tobool63 = icmp ne i32 %41, 0, !dbg !577
  br i1 %tobool63, label %if.then64, label %if.end76, !dbg !577

if.then64:                                        ; preds = %if.end54
  %42 = load i32, i32* %align, align 4, !dbg !578
  %cmp65 = icmp ult i32 %42, 32, !dbg !579
  br i1 %cmp65, label %if.then66, label %if.else74, !dbg !578

if.then66:                                        ; preds = %if.then64
  %43 = load i32, i32* %bSignificand, align 4, !dbg !580
  %44 = load i32, i32* %align, align 4, !dbg !581
  %sub67 = sub i32 32, %44, !dbg !582
  %shl68 = shl i32 %43, %sub67, !dbg !583
  %tobool69 = icmp ne i32 %shl68, 0, !dbg !580
  %frombool70 = zext i1 %tobool69 to i8, !dbg !584
  store i8 %frombool70, i8* %sticky, align 1, !dbg !584
  %45 = load i32, i32* %bSignificand, align 4, !dbg !585
  %46 = load i32, i32* %align, align 4, !dbg !586
  %shr71 = lshr i32 %45, %46, !dbg !587
  %47 = load i8, i8* %sticky, align 1, !dbg !588
  %tobool72 = trunc i8 %47 to i1, !dbg !588
  %conv = zext i1 %tobool72 to i32, !dbg !588
  %or73 = or i32 %shr71, %conv, !dbg !589
  store i32 %or73, i32* %bSignificand, align 4, !dbg !590
  br label %if.end75, !dbg !591

if.else74:                                        ; preds = %if.then64
  store i32 1, i32* %bSignificand, align 4, !dbg !592
  br label %if.end75

if.end75:                                         ; preds = %if.else74, %if.then66
  br label %if.end76, !dbg !593

if.end76:                                         ; preds = %if.end75, %if.end54
  %48 = load i8, i8* %subtraction, align 1, !dbg !594
  %tobool77 = trunc i8 %48 to i1, !dbg !594
  br i1 %tobool77, label %if.then78, label %if.else94, !dbg !594

if.then78:                                        ; preds = %if.end76
  %49 = load i32, i32* %bSignificand, align 4, !dbg !595
  %50 = load i32, i32* %aSignificand, align 4, !dbg !596
  %sub79 = sub i32 %50, %49, !dbg !596
  store i32 %sub79, i32* %aSignificand, align 4, !dbg !596
  %51 = load i32, i32* %aSignificand, align 4, !dbg !597
  %cmp80 = icmp eq i32 %51, 0, !dbg !598
  br i1 %cmp80, label %if.then82, label %if.end84, !dbg !597

if.then82:                                        ; preds = %if.then78
  %call83 = call arm_aapcs_vfpcc float @fromRep.3(i32 0) #4, !dbg !599
  store float %call83, float* %retval, align 4, !dbg !600
  br label %return, !dbg !600

if.end84:                                         ; preds = %if.then78
  %52 = load i32, i32* %aSignificand, align 4, !dbg !601
  %cmp85 = icmp ult i32 %52, 67108864, !dbg !602
  br i1 %cmp85, label %if.then87, label %if.end93, !dbg !601

if.then87:                                        ; preds = %if.end84
  %53 = load i32, i32* %aSignificand, align 4, !dbg !603
  %call88 = call arm_aapcs_vfpcc i32 @rep_clz.5(i32 %53) #4, !dbg !604
  %call89 = call arm_aapcs_vfpcc i32 @rep_clz.5(i32 67108864) #4, !dbg !605
  %sub90 = sub nsw i32 %call88, %call89, !dbg !606
  store i32 %sub90, i32* %shift, align 4, !dbg !607
  %54 = load i32, i32* %shift, align 4, !dbg !608
  %55 = load i32, i32* %aSignificand, align 4, !dbg !609
  %shl91 = shl i32 %55, %54, !dbg !609
  store i32 %shl91, i32* %aSignificand, align 4, !dbg !609
  %56 = load i32, i32* %shift, align 4, !dbg !610
  %57 = load i32, i32* %aExponent, align 4, !dbg !611
  %sub92 = sub nsw i32 %57, %56, !dbg !611
  store i32 %sub92, i32* %aExponent, align 4, !dbg !611
  br label %if.end93, !dbg !612

if.end93:                                         ; preds = %if.then87, %if.end84
  br label %if.end108, !dbg !613

if.else94:                                        ; preds = %if.end76
  %58 = load i32, i32* %bSignificand, align 4, !dbg !614
  %59 = load i32, i32* %aSignificand, align 4, !dbg !615
  %add = add i32 %59, %58, !dbg !615
  store i32 %add, i32* %aSignificand, align 4, !dbg !615
  %60 = load i32, i32* %aSignificand, align 4, !dbg !616
  %and95 = and i32 %60, 134217728, !dbg !617
  %tobool96 = icmp ne i32 %and95, 0, !dbg !617
  br i1 %tobool96, label %if.then97, label %if.end107, !dbg !616

if.then97:                                        ; preds = %if.else94
  %61 = load i32, i32* %aSignificand, align 4, !dbg !618
  %and99 = and i32 %61, 1, !dbg !619
  %tobool100 = icmp ne i32 %and99, 0, !dbg !618
  %frombool101 = zext i1 %tobool100 to i8, !dbg !620
  store i8 %frombool101, i8* %sticky98, align 1, !dbg !620
  %62 = load i32, i32* %aSignificand, align 4, !dbg !621
  %shr102 = lshr i32 %62, 1, !dbg !622
  %63 = load i8, i8* %sticky98, align 1, !dbg !623
  %tobool103 = trunc i8 %63 to i1, !dbg !623
  %conv104 = zext i1 %tobool103 to i32, !dbg !623
  %or105 = or i32 %shr102, %conv104, !dbg !624
  store i32 %or105, i32* %aSignificand, align 4, !dbg !625
  %64 = load i32, i32* %aExponent, align 4, !dbg !626
  %add106 = add nsw i32 %64, 1, !dbg !626
  store i32 %add106, i32* %aExponent, align 4, !dbg !626
  br label %if.end107, !dbg !627

if.end107:                                        ; preds = %if.then97, %if.else94
  br label %if.end108

if.end108:                                        ; preds = %if.end107, %if.end93
  %65 = load i32, i32* %aExponent, align 4, !dbg !628
  %cmp109 = icmp sge i32 %65, 255, !dbg !629
  br i1 %cmp109, label %if.then111, label %if.end114, !dbg !628

if.then111:                                       ; preds = %if.end108
  %66 = load i32, i32* %resultSign, align 4, !dbg !630
  %or112 = or i32 2139095040, %66, !dbg !631
  %call113 = call arm_aapcs_vfpcc float @fromRep.3(i32 %or112) #4, !dbg !632
  store float %call113, float* %retval, align 4, !dbg !633
  br label %return, !dbg !633

if.end114:                                        ; preds = %if.end108
  %67 = load i32, i32* %aExponent, align 4, !dbg !634
  %cmp115 = icmp sle i32 %67, 0, !dbg !635
  br i1 %cmp115, label %if.then117, label %if.end129, !dbg !634

if.then117:                                       ; preds = %if.end114
  %68 = load i32, i32* %aExponent, align 4, !dbg !636
  %sub119 = sub nsw i32 1, %68, !dbg !637
  store i32 %sub119, i32* %shift118, align 4, !dbg !638
  %69 = load i32, i32* %aSignificand, align 4, !dbg !639
  %70 = load i32, i32* %shift118, align 4, !dbg !640
  %sub121 = sub i32 32, %70, !dbg !641
  %shl122 = shl i32 %69, %sub121, !dbg !642
  %tobool123 = icmp ne i32 %shl122, 0, !dbg !639
  %frombool124 = zext i1 %tobool123 to i8, !dbg !643
  store i8 %frombool124, i8* %sticky120, align 1, !dbg !643
  %71 = load i32, i32* %aSignificand, align 4, !dbg !644
  %72 = load i32, i32* %shift118, align 4, !dbg !645
  %shr125 = lshr i32 %71, %72, !dbg !646
  %73 = load i8, i8* %sticky120, align 1, !dbg !647
  %tobool126 = trunc i8 %73 to i1, !dbg !647
  %conv127 = zext i1 %tobool126 to i32, !dbg !647
  %or128 = or i32 %shr125, %conv127, !dbg !648
  store i32 %or128, i32* %aSignificand, align 4, !dbg !649
  store i32 0, i32* %aExponent, align 4, !dbg !650
  br label %if.end129, !dbg !651

if.end129:                                        ; preds = %if.then117, %if.end114
  %74 = load i32, i32* %aSignificand, align 4, !dbg !652
  %and130 = and i32 %74, 7, !dbg !653
  store i32 %and130, i32* %roundGuardSticky, align 4, !dbg !654
  %75 = load i32, i32* %aSignificand, align 4, !dbg !655
  %shr131 = lshr i32 %75, 3, !dbg !656
  %and132 = and i32 %shr131, 8388607, !dbg !657
  store i32 %and132, i32* %result, align 4, !dbg !658
  %76 = load i32, i32* %aExponent, align 4, !dbg !659
  %shl133 = shl i32 %76, 23, !dbg !660
  %77 = load i32, i32* %result, align 4, !dbg !661
  %or134 = or i32 %77, %shl133, !dbg !661
  store i32 %or134, i32* %result, align 4, !dbg !661
  %78 = load i32, i32* %resultSign, align 4, !dbg !662
  %79 = load i32, i32* %result, align 4, !dbg !663
  %or135 = or i32 %79, %78, !dbg !663
  store i32 %or135, i32* %result, align 4, !dbg !663
  %80 = load i32, i32* %roundGuardSticky, align 4, !dbg !664
  %cmp136 = icmp sgt i32 %80, 4, !dbg !665
  br i1 %cmp136, label %if.then138, label %if.end139, !dbg !664

if.then138:                                       ; preds = %if.end129
  %81 = load i32, i32* %result, align 4, !dbg !666
  %inc = add i32 %81, 1, !dbg !666
  store i32 %inc, i32* %result, align 4, !dbg !666
  br label %if.end139, !dbg !667

if.end139:                                        ; preds = %if.then138, %if.end129
  %82 = load i32, i32* %roundGuardSticky, align 4, !dbg !668
  %cmp140 = icmp eq i32 %82, 4, !dbg !669
  br i1 %cmp140, label %if.then142, label %if.end145, !dbg !668

if.then142:                                       ; preds = %if.end139
  %83 = load i32, i32* %result, align 4, !dbg !670
  %and143 = and i32 %83, 1, !dbg !671
  %84 = load i32, i32* %result, align 4, !dbg !672
  %add144 = add i32 %84, %and143, !dbg !672
  store i32 %add144, i32* %result, align 4, !dbg !672
  br label %if.end145, !dbg !673

if.end145:                                        ; preds = %if.then142, %if.end139
  %85 = load i32, i32* %result, align 4, !dbg !674
  %call146 = call arm_aapcs_vfpcc float @fromRep.3(i32 %85) #4, !dbg !675
  store float %call146, float* %retval, align 4, !dbg !676
  br label %return, !dbg !676

return:                                           ; preds = %if.end145, %if.then111, %if.then82, %if.then36, %if.else33, %if.then28, %if.then24, %if.else, %if.then20, %if.then10, %if.then6
  %86 = load float, float* %retval, align 4, !dbg !677
  ret float %86, !dbg !677
}

; Function Attrs: noinline nounwind
define internal arm_aapcs_vfpcc i32 @toRep.2(float %x) #0 !dbg !678 {
entry:
  %x.addr = alloca float, align 4
  %rep = alloca %union.anon.0.0, align 4
  store float %x, float* %x.addr, align 4
  %f = bitcast %union.anon.0.0* %rep to float*, !dbg !679
  %0 = load float, float* %x.addr, align 4, !dbg !680
  store float %0, float* %f, align 4, !dbg !679
  %i = bitcast %union.anon.0.0* %rep to i32*, !dbg !681
  %1 = load i32, i32* %i, align 4, !dbg !681
  ret i32 %1, !dbg !682
}

; Function Attrs: noinline nounwind
define internal arm_aapcs_vfpcc float @fromRep.3(i32 %x) #0 !dbg !683 {
entry:
  %x.addr = alloca i32, align 4
  %rep = alloca %union.anon.0.0, align 4
  store i32 %x, i32* %x.addr, align 4
  %i = bitcast %union.anon.0.0* %rep to i32*, !dbg !684
  %0 = load i32, i32* %x.addr, align 4, !dbg !685
  store i32 %0, i32* %i, align 4, !dbg !684
  %f = bitcast %union.anon.0.0* %rep to float*, !dbg !686
  %1 = load float, float* %f, align 4, !dbg !686
  ret float %1, !dbg !687
}

; Function Attrs: noinline nounwind
define internal arm_aapcs_vfpcc i32 @normalize.4(i32* %significand) #0 !dbg !688 {
entry:
  %significand.addr = alloca i32*, align 4
  %shift = alloca i32, align 4
  store i32* %significand, i32** %significand.addr, align 4
  %0 = load i32*, i32** %significand.addr, align 4, !dbg !689
  %1 = load i32, i32* %0, align 4, !dbg !690
  %call = call arm_aapcs_vfpcc i32 @rep_clz.5(i32 %1) #4, !dbg !691
  %call1 = call arm_aapcs_vfpcc i32 @rep_clz.5(i32 8388608) #4, !dbg !692
  %sub = sub nsw i32 %call, %call1, !dbg !693
  store i32 %sub, i32* %shift, align 4, !dbg !694
  %2 = load i32, i32* %shift, align 4, !dbg !695
  %3 = load i32*, i32** %significand.addr, align 4, !dbg !696
  %4 = load i32, i32* %3, align 4, !dbg !697
  %shl = shl i32 %4, %2, !dbg !697
  store i32 %shl, i32* %3, align 4, !dbg !697
  %5 = load i32, i32* %shift, align 4, !dbg !698
  %sub2 = sub nsw i32 1, %5, !dbg !699
  ret i32 %sub2, !dbg !700
}

; Function Attrs: noinline nounwind
define internal arm_aapcs_vfpcc i32 @rep_clz.5(i32 %a) #0 !dbg !701 {
entry:
  %a.addr = alloca i32, align 4
  store i32 %a, i32* %a.addr, align 4
  %0 = load i32, i32* %a.addr, align 4, !dbg !702
  %1 = call i32 @llvm.ctlz.i32(i32 %0, i1 false), !dbg !703
  ret i32 %1, !dbg !704
}

; Function Attrs: noinline nounwind
define dso_local arm_aapcscc i32 @__ledf2(double %a, double %b) #0 !dbg !705 {
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
  %0 = load double, double* %a.addr, align 8, !dbg !706
  %call = call arm_aapcs_vfpcc i64 @toRep.6(double %0) #4, !dbg !707
  store i64 %call, i64* %aInt, align 8, !dbg !708
  %1 = load double, double* %b.addr, align 8, !dbg !709
  %call1 = call arm_aapcs_vfpcc i64 @toRep.6(double %1) #4, !dbg !710
  store i64 %call1, i64* %bInt, align 8, !dbg !711
  %2 = load i64, i64* %aInt, align 8, !dbg !712
  %and = and i64 %2, 9223372036854775807, !dbg !713
  store i64 %and, i64* %aAbs, align 8, !dbg !714
  %3 = load i64, i64* %bInt, align 8, !dbg !715
  %and2 = and i64 %3, 9223372036854775807, !dbg !716
  store i64 %and2, i64* %bAbs, align 8, !dbg !717
  %4 = load i64, i64* %aAbs, align 8, !dbg !718
  %cmp = icmp ugt i64 %4, 9218868437227405312, !dbg !719
  br i1 %cmp, label %if.then, label %lor.lhs.false, !dbg !720

lor.lhs.false:                                    ; preds = %entry
  %5 = load i64, i64* %bAbs, align 8, !dbg !721
  %cmp3 = icmp ugt i64 %5, 9218868437227405312, !dbg !722
  br i1 %cmp3, label %if.then, label %if.end, !dbg !718

if.then:                                          ; preds = %lor.lhs.false, %entry
  store i32 1, i32* %retval, align 4, !dbg !723
  br label %return, !dbg !723

if.end:                                           ; preds = %lor.lhs.false
  %6 = load i64, i64* %aAbs, align 8, !dbg !724
  %7 = load i64, i64* %bAbs, align 8, !dbg !725
  %or = or i64 %6, %7, !dbg !726
  %cmp4 = icmp eq i64 %or, 0, !dbg !727
  br i1 %cmp4, label %if.then5, label %if.end6, !dbg !728

if.then5:                                         ; preds = %if.end
  store i32 0, i32* %retval, align 4, !dbg !729
  br label %return, !dbg !729

if.end6:                                          ; preds = %if.end
  %8 = load i64, i64* %aInt, align 8, !dbg !730
  %9 = load i64, i64* %bInt, align 8, !dbg !731
  %and7 = and i64 %8, %9, !dbg !732
  %cmp8 = icmp sge i64 %and7, 0, !dbg !733
  br i1 %cmp8, label %if.then9, label %if.else15, !dbg !734

if.then9:                                         ; preds = %if.end6
  %10 = load i64, i64* %aInt, align 8, !dbg !735
  %11 = load i64, i64* %bInt, align 8, !dbg !736
  %cmp10 = icmp slt i64 %10, %11, !dbg !737
  br i1 %cmp10, label %if.then11, label %if.else, !dbg !735

if.then11:                                        ; preds = %if.then9
  store i32 -1, i32* %retval, align 4, !dbg !738
  br label %return, !dbg !738

if.else:                                          ; preds = %if.then9
  %12 = load i64, i64* %aInt, align 8, !dbg !739
  %13 = load i64, i64* %bInt, align 8, !dbg !740
  %cmp12 = icmp eq i64 %12, %13, !dbg !741
  br i1 %cmp12, label %if.then13, label %if.else14, !dbg !739

if.then13:                                        ; preds = %if.else
  store i32 0, i32* %retval, align 4, !dbg !742
  br label %return, !dbg !742

if.else14:                                        ; preds = %if.else
  store i32 1, i32* %retval, align 4, !dbg !743
  br label %return, !dbg !743

if.else15:                                        ; preds = %if.end6
  %14 = load i64, i64* %aInt, align 8, !dbg !744
  %15 = load i64, i64* %bInt, align 8, !dbg !745
  %cmp16 = icmp sgt i64 %14, %15, !dbg !746
  br i1 %cmp16, label %if.then17, label %if.else18, !dbg !744

if.then17:                                        ; preds = %if.else15
  store i32 -1, i32* %retval, align 4, !dbg !747
  br label %return, !dbg !747

if.else18:                                        ; preds = %if.else15
  %16 = load i64, i64* %aInt, align 8, !dbg !748
  %17 = load i64, i64* %bInt, align 8, !dbg !749
  %cmp19 = icmp eq i64 %16, %17, !dbg !750
  br i1 %cmp19, label %if.then20, label %if.else21, !dbg !748

if.then20:                                        ; preds = %if.else18
  store i32 0, i32* %retval, align 4, !dbg !751
  br label %return, !dbg !751

if.else21:                                        ; preds = %if.else18
  store i32 1, i32* %retval, align 4, !dbg !752
  br label %return, !dbg !752

return:                                           ; preds = %if.else21, %if.then20, %if.then17, %if.else14, %if.then13, %if.then11, %if.then5, %if.then
  %18 = load i32, i32* %retval, align 4, !dbg !753
  ret i32 %18, !dbg !753
}

; Function Attrs: noinline nounwind
define internal arm_aapcs_vfpcc i64 @toRep.6(double %x) #0 !dbg !754 {
entry:
  %x.addr = alloca double, align 8
  %rep = alloca %union.anon.0, align 8
  store double %x, double* %x.addr, align 8
  %f = bitcast %union.anon.0* %rep to double*, !dbg !755
  %0 = load double, double* %x.addr, align 8, !dbg !756
  store double %0, double* %f, align 8, !dbg !755
  %i = bitcast %union.anon.0* %rep to i64*, !dbg !757
  %1 = load i64, i64* %i, align 8, !dbg !757
  ret i64 %1, !dbg !758
}

; Function Attrs: noinline nounwind
define dso_local arm_aapcscc i32 @__gedf2(double %a, double %b) #0 !dbg !759 {
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
  %0 = load double, double* %a.addr, align 8, !dbg !760
  %call = call arm_aapcs_vfpcc i64 @toRep.6(double %0) #4, !dbg !761
  store i64 %call, i64* %aInt, align 8, !dbg !762
  %1 = load double, double* %b.addr, align 8, !dbg !763
  %call1 = call arm_aapcs_vfpcc i64 @toRep.6(double %1) #4, !dbg !764
  store i64 %call1, i64* %bInt, align 8, !dbg !765
  %2 = load i64, i64* %aInt, align 8, !dbg !766
  %and = and i64 %2, 9223372036854775807, !dbg !767
  store i64 %and, i64* %aAbs, align 8, !dbg !768
  %3 = load i64, i64* %bInt, align 8, !dbg !769
  %and2 = and i64 %3, 9223372036854775807, !dbg !770
  store i64 %and2, i64* %bAbs, align 8, !dbg !771
  %4 = load i64, i64* %aAbs, align 8, !dbg !772
  %cmp = icmp ugt i64 %4, 9218868437227405312, !dbg !773
  br i1 %cmp, label %if.then, label %lor.lhs.false, !dbg !774

lor.lhs.false:                                    ; preds = %entry
  %5 = load i64, i64* %bAbs, align 8, !dbg !775
  %cmp3 = icmp ugt i64 %5, 9218868437227405312, !dbg !776
  br i1 %cmp3, label %if.then, label %if.end, !dbg !772

if.then:                                          ; preds = %lor.lhs.false, %entry
  store i32 -1, i32* %retval, align 4, !dbg !777
  br label %return, !dbg !777

if.end:                                           ; preds = %lor.lhs.false
  %6 = load i64, i64* %aAbs, align 8, !dbg !778
  %7 = load i64, i64* %bAbs, align 8, !dbg !779
  %or = or i64 %6, %7, !dbg !780
  %cmp4 = icmp eq i64 %or, 0, !dbg !781
  br i1 %cmp4, label %if.then5, label %if.end6, !dbg !782

if.then5:                                         ; preds = %if.end
  store i32 0, i32* %retval, align 4, !dbg !783
  br label %return, !dbg !783

if.end6:                                          ; preds = %if.end
  %8 = load i64, i64* %aInt, align 8, !dbg !784
  %9 = load i64, i64* %bInt, align 8, !dbg !785
  %and7 = and i64 %8, %9, !dbg !786
  %cmp8 = icmp sge i64 %and7, 0, !dbg !787
  br i1 %cmp8, label %if.then9, label %if.else15, !dbg !788

if.then9:                                         ; preds = %if.end6
  %10 = load i64, i64* %aInt, align 8, !dbg !789
  %11 = load i64, i64* %bInt, align 8, !dbg !790
  %cmp10 = icmp slt i64 %10, %11, !dbg !791
  br i1 %cmp10, label %if.then11, label %if.else, !dbg !789

if.then11:                                        ; preds = %if.then9
  store i32 -1, i32* %retval, align 4, !dbg !792
  br label %return, !dbg !792

if.else:                                          ; preds = %if.then9
  %12 = load i64, i64* %aInt, align 8, !dbg !793
  %13 = load i64, i64* %bInt, align 8, !dbg !794
  %cmp12 = icmp eq i64 %12, %13, !dbg !795
  br i1 %cmp12, label %if.then13, label %if.else14, !dbg !793

if.then13:                                        ; preds = %if.else
  store i32 0, i32* %retval, align 4, !dbg !796
  br label %return, !dbg !796

if.else14:                                        ; preds = %if.else
  store i32 1, i32* %retval, align 4, !dbg !797
  br label %return, !dbg !797

if.else15:                                        ; preds = %if.end6
  %14 = load i64, i64* %aInt, align 8, !dbg !798
  %15 = load i64, i64* %bInt, align 8, !dbg !799
  %cmp16 = icmp sgt i64 %14, %15, !dbg !800
  br i1 %cmp16, label %if.then17, label %if.else18, !dbg !798

if.then17:                                        ; preds = %if.else15
  store i32 -1, i32* %retval, align 4, !dbg !801
  br label %return, !dbg !801

if.else18:                                        ; preds = %if.else15
  %16 = load i64, i64* %aInt, align 8, !dbg !802
  %17 = load i64, i64* %bInt, align 8, !dbg !803
  %cmp19 = icmp eq i64 %16, %17, !dbg !804
  br i1 %cmp19, label %if.then20, label %if.else21, !dbg !802

if.then20:                                        ; preds = %if.else18
  store i32 0, i32* %retval, align 4, !dbg !805
  br label %return, !dbg !805

if.else21:                                        ; preds = %if.else18
  store i32 1, i32* %retval, align 4, !dbg !806
  br label %return, !dbg !806

return:                                           ; preds = %if.else21, %if.then20, %if.then17, %if.else14, %if.then13, %if.then11, %if.then5, %if.then
  %18 = load i32, i32* %retval, align 4, !dbg !807
  ret i32 %18, !dbg !807
}

; Function Attrs: noinline nounwind
define dso_local arm_aapcscc i32 @__unorddf2(double %a, double %b) #0 !dbg !808 {
entry:
  %a.addr = alloca double, align 8
  %b.addr = alloca double, align 8
  %aAbs = alloca i64, align 8
  %bAbs = alloca i64, align 8
  store double %a, double* %a.addr, align 8
  store double %b, double* %b.addr, align 8
  %0 = load double, double* %a.addr, align 8, !dbg !809
  %call = call arm_aapcs_vfpcc i64 @toRep.6(double %0) #4, !dbg !810
  %and = and i64 %call, 9223372036854775807, !dbg !811
  store i64 %and, i64* %aAbs, align 8, !dbg !812
  %1 = load double, double* %b.addr, align 8, !dbg !813
  %call1 = call arm_aapcs_vfpcc i64 @toRep.6(double %1) #4, !dbg !814
  %and2 = and i64 %call1, 9223372036854775807, !dbg !815
  store i64 %and2, i64* %bAbs, align 8, !dbg !816
  %2 = load i64, i64* %aAbs, align 8, !dbg !817
  %cmp = icmp ugt i64 %2, 9218868437227405312, !dbg !818
  br i1 %cmp, label %lor.end, label %lor.rhs, !dbg !819

lor.rhs:                                          ; preds = %entry
  %3 = load i64, i64* %bAbs, align 8, !dbg !820
  %cmp3 = icmp ugt i64 %3, 9218868437227405312, !dbg !821
  br label %lor.end, !dbg !819

lor.end:                                          ; preds = %lor.rhs, %entry
  %4 = phi i1 [ true, %entry ], [ %cmp3, %lor.rhs ]
  %lor.ext = zext i1 %4 to i32, !dbg !819
  ret i32 %lor.ext, !dbg !822
}

; Function Attrs: noinline nounwind
define dso_local arm_aapcscc i32 @__eqdf2(double %a, double %b) #0 !dbg !823 {
entry:
  %a.addr = alloca double, align 8
  %b.addr = alloca double, align 8
  store double %a, double* %a.addr, align 8
  store double %b, double* %b.addr, align 8
  %0 = load double, double* %a.addr, align 8, !dbg !824
  %1 = load double, double* %b.addr, align 8, !dbg !825
  %call = call arm_aapcscc i32 @__ledf2(double %0, double %1) #4, !dbg !826
  ret i32 %call, !dbg !827
}

; Function Attrs: noinline nounwind
define dso_local arm_aapcscc i32 @__ltdf2(double %a, double %b) #0 !dbg !828 {
entry:
  %a.addr = alloca double, align 8
  %b.addr = alloca double, align 8
  store double %a, double* %a.addr, align 8
  store double %b, double* %b.addr, align 8
  %0 = load double, double* %a.addr, align 8, !dbg !829
  %1 = load double, double* %b.addr, align 8, !dbg !830
  %call = call arm_aapcscc i32 @__ledf2(double %0, double %1) #4, !dbg !831
  ret i32 %call, !dbg !832
}

; Function Attrs: noinline nounwind
define dso_local arm_aapcscc i32 @__nedf2(double %a, double %b) #0 !dbg !833 {
entry:
  %a.addr = alloca double, align 8
  %b.addr = alloca double, align 8
  store double %a, double* %a.addr, align 8
  store double %b, double* %b.addr, align 8
  %0 = load double, double* %a.addr, align 8, !dbg !834
  %1 = load double, double* %b.addr, align 8, !dbg !835
  %call = call arm_aapcscc i32 @__ledf2(double %0, double %1) #4, !dbg !836
  ret i32 %call, !dbg !837
}

; Function Attrs: noinline nounwind
define dso_local arm_aapcscc i32 @__gtdf2(double %a, double %b) #0 !dbg !838 {
entry:
  %a.addr = alloca double, align 8
  %b.addr = alloca double, align 8
  store double %a, double* %a.addr, align 8
  store double %b, double* %b.addr, align 8
  %0 = load double, double* %a.addr, align 8, !dbg !839
  %1 = load double, double* %b.addr, align 8, !dbg !840
  %call = call arm_aapcscc i32 @__gedf2(double %0, double %1) #4, !dbg !841
  ret i32 %call, !dbg !842
}

; Function Attrs: noinline nounwind
define dso_local arm_aapcscc i32 @__lesf2(float %a, float %b) #0 !dbg !843 {
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
  %0 = load float, float* %a.addr, align 4, !dbg !844
  %call = call arm_aapcs_vfpcc i32 @toRep.7(float %0) #4, !dbg !845
  store i32 %call, i32* %aInt, align 4, !dbg !846
  %1 = load float, float* %b.addr, align 4, !dbg !847
  %call1 = call arm_aapcs_vfpcc i32 @toRep.7(float %1) #4, !dbg !848
  store i32 %call1, i32* %bInt, align 4, !dbg !849
  %2 = load i32, i32* %aInt, align 4, !dbg !850
  %and = and i32 %2, 2147483647, !dbg !851
  store i32 %and, i32* %aAbs, align 4, !dbg !852
  %3 = load i32, i32* %bInt, align 4, !dbg !853
  %and2 = and i32 %3, 2147483647, !dbg !854
  store i32 %and2, i32* %bAbs, align 4, !dbg !855
  %4 = load i32, i32* %aAbs, align 4, !dbg !856
  %cmp = icmp ugt i32 %4, 2139095040, !dbg !857
  br i1 %cmp, label %if.then, label %lor.lhs.false, !dbg !858

lor.lhs.false:                                    ; preds = %entry
  %5 = load i32, i32* %bAbs, align 4, !dbg !859
  %cmp3 = icmp ugt i32 %5, 2139095040, !dbg !860
  br i1 %cmp3, label %if.then, label %if.end, !dbg !856

if.then:                                          ; preds = %lor.lhs.false, %entry
  store i32 1, i32* %retval, align 4, !dbg !861
  br label %return, !dbg !861

if.end:                                           ; preds = %lor.lhs.false
  %6 = load i32, i32* %aAbs, align 4, !dbg !862
  %7 = load i32, i32* %bAbs, align 4, !dbg !863
  %or = or i32 %6, %7, !dbg !864
  %cmp4 = icmp eq i32 %or, 0, !dbg !865
  br i1 %cmp4, label %if.then5, label %if.end6, !dbg !866

if.then5:                                         ; preds = %if.end
  store i32 0, i32* %retval, align 4, !dbg !867
  br label %return, !dbg !867

if.end6:                                          ; preds = %if.end
  %8 = load i32, i32* %aInt, align 4, !dbg !868
  %9 = load i32, i32* %bInt, align 4, !dbg !869
  %and7 = and i32 %8, %9, !dbg !870
  %cmp8 = icmp sge i32 %and7, 0, !dbg !871
  br i1 %cmp8, label %if.then9, label %if.else15, !dbg !872

if.then9:                                         ; preds = %if.end6
  %10 = load i32, i32* %aInt, align 4, !dbg !873
  %11 = load i32, i32* %bInt, align 4, !dbg !874
  %cmp10 = icmp slt i32 %10, %11, !dbg !875
  br i1 %cmp10, label %if.then11, label %if.else, !dbg !873

if.then11:                                        ; preds = %if.then9
  store i32 -1, i32* %retval, align 4, !dbg !876
  br label %return, !dbg !876

if.else:                                          ; preds = %if.then9
  %12 = load i32, i32* %aInt, align 4, !dbg !877
  %13 = load i32, i32* %bInt, align 4, !dbg !878
  %cmp12 = icmp eq i32 %12, %13, !dbg !879
  br i1 %cmp12, label %if.then13, label %if.else14, !dbg !877

if.then13:                                        ; preds = %if.else
  store i32 0, i32* %retval, align 4, !dbg !880
  br label %return, !dbg !880

if.else14:                                        ; preds = %if.else
  store i32 1, i32* %retval, align 4, !dbg !881
  br label %return, !dbg !881

if.else15:                                        ; preds = %if.end6
  %14 = load i32, i32* %aInt, align 4, !dbg !882
  %15 = load i32, i32* %bInt, align 4, !dbg !883
  %cmp16 = icmp sgt i32 %14, %15, !dbg !884
  br i1 %cmp16, label %if.then17, label %if.else18, !dbg !882

if.then17:                                        ; preds = %if.else15
  store i32 -1, i32* %retval, align 4, !dbg !885
  br label %return, !dbg !885

if.else18:                                        ; preds = %if.else15
  %16 = load i32, i32* %aInt, align 4, !dbg !886
  %17 = load i32, i32* %bInt, align 4, !dbg !887
  %cmp19 = icmp eq i32 %16, %17, !dbg !888
  br i1 %cmp19, label %if.then20, label %if.else21, !dbg !886

if.then20:                                        ; preds = %if.else18
  store i32 0, i32* %retval, align 4, !dbg !889
  br label %return, !dbg !889

if.else21:                                        ; preds = %if.else18
  store i32 1, i32* %retval, align 4, !dbg !890
  br label %return, !dbg !890

return:                                           ; preds = %if.else21, %if.then20, %if.then17, %if.else14, %if.then13, %if.then11, %if.then5, %if.then
  %18 = load i32, i32* %retval, align 4, !dbg !891
  ret i32 %18, !dbg !891
}

; Function Attrs: noinline nounwind
define internal arm_aapcs_vfpcc i32 @toRep.7(float %x) #0 !dbg !892 {
entry:
  %x.addr = alloca float, align 4
  %rep = alloca %union.anon.0.0, align 4
  store float %x, float* %x.addr, align 4
  %f = bitcast %union.anon.0.0* %rep to float*, !dbg !893
  %0 = load float, float* %x.addr, align 4, !dbg !894
  store float %0, float* %f, align 4, !dbg !893
  %i = bitcast %union.anon.0.0* %rep to i32*, !dbg !895
  %1 = load i32, i32* %i, align 4, !dbg !895
  ret i32 %1, !dbg !896
}

; Function Attrs: noinline nounwind
define dso_local arm_aapcscc i32 @__gesf2(float %a, float %b) #0 !dbg !897 {
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
  %0 = load float, float* %a.addr, align 4, !dbg !898
  %call = call arm_aapcs_vfpcc i32 @toRep.7(float %0) #4, !dbg !899
  store i32 %call, i32* %aInt, align 4, !dbg !900
  %1 = load float, float* %b.addr, align 4, !dbg !901
  %call1 = call arm_aapcs_vfpcc i32 @toRep.7(float %1) #4, !dbg !902
  store i32 %call1, i32* %bInt, align 4, !dbg !903
  %2 = load i32, i32* %aInt, align 4, !dbg !904
  %and = and i32 %2, 2147483647, !dbg !905
  store i32 %and, i32* %aAbs, align 4, !dbg !906
  %3 = load i32, i32* %bInt, align 4, !dbg !907
  %and2 = and i32 %3, 2147483647, !dbg !908
  store i32 %and2, i32* %bAbs, align 4, !dbg !909
  %4 = load i32, i32* %aAbs, align 4, !dbg !910
  %cmp = icmp ugt i32 %4, 2139095040, !dbg !911
  br i1 %cmp, label %if.then, label %lor.lhs.false, !dbg !912

lor.lhs.false:                                    ; preds = %entry
  %5 = load i32, i32* %bAbs, align 4, !dbg !913
  %cmp3 = icmp ugt i32 %5, 2139095040, !dbg !914
  br i1 %cmp3, label %if.then, label %if.end, !dbg !910

if.then:                                          ; preds = %lor.lhs.false, %entry
  store i32 -1, i32* %retval, align 4, !dbg !915
  br label %return, !dbg !915

if.end:                                           ; preds = %lor.lhs.false
  %6 = load i32, i32* %aAbs, align 4, !dbg !916
  %7 = load i32, i32* %bAbs, align 4, !dbg !917
  %or = or i32 %6, %7, !dbg !918
  %cmp4 = icmp eq i32 %or, 0, !dbg !919
  br i1 %cmp4, label %if.then5, label %if.end6, !dbg !920

if.then5:                                         ; preds = %if.end
  store i32 0, i32* %retval, align 4, !dbg !921
  br label %return, !dbg !921

if.end6:                                          ; preds = %if.end
  %8 = load i32, i32* %aInt, align 4, !dbg !922
  %9 = load i32, i32* %bInt, align 4, !dbg !923
  %and7 = and i32 %8, %9, !dbg !924
  %cmp8 = icmp sge i32 %and7, 0, !dbg !925
  br i1 %cmp8, label %if.then9, label %if.else15, !dbg !926

if.then9:                                         ; preds = %if.end6
  %10 = load i32, i32* %aInt, align 4, !dbg !927
  %11 = load i32, i32* %bInt, align 4, !dbg !928
  %cmp10 = icmp slt i32 %10, %11, !dbg !929
  br i1 %cmp10, label %if.then11, label %if.else, !dbg !927

if.then11:                                        ; preds = %if.then9
  store i32 -1, i32* %retval, align 4, !dbg !930
  br label %return, !dbg !930

if.else:                                          ; preds = %if.then9
  %12 = load i32, i32* %aInt, align 4, !dbg !931
  %13 = load i32, i32* %bInt, align 4, !dbg !932
  %cmp12 = icmp eq i32 %12, %13, !dbg !933
  br i1 %cmp12, label %if.then13, label %if.else14, !dbg !931

if.then13:                                        ; preds = %if.else
  store i32 0, i32* %retval, align 4, !dbg !934
  br label %return, !dbg !934

if.else14:                                        ; preds = %if.else
  store i32 1, i32* %retval, align 4, !dbg !935
  br label %return, !dbg !935

if.else15:                                        ; preds = %if.end6
  %14 = load i32, i32* %aInt, align 4, !dbg !936
  %15 = load i32, i32* %bInt, align 4, !dbg !937
  %cmp16 = icmp sgt i32 %14, %15, !dbg !938
  br i1 %cmp16, label %if.then17, label %if.else18, !dbg !936

if.then17:                                        ; preds = %if.else15
  store i32 -1, i32* %retval, align 4, !dbg !939
  br label %return, !dbg !939

if.else18:                                        ; preds = %if.else15
  %16 = load i32, i32* %aInt, align 4, !dbg !940
  %17 = load i32, i32* %bInt, align 4, !dbg !941
  %cmp19 = icmp eq i32 %16, %17, !dbg !942
  br i1 %cmp19, label %if.then20, label %if.else21, !dbg !940

if.then20:                                        ; preds = %if.else18
  store i32 0, i32* %retval, align 4, !dbg !943
  br label %return, !dbg !943

if.else21:                                        ; preds = %if.else18
  store i32 1, i32* %retval, align 4, !dbg !944
  br label %return, !dbg !944

return:                                           ; preds = %if.else21, %if.then20, %if.then17, %if.else14, %if.then13, %if.then11, %if.then5, %if.then
  %18 = load i32, i32* %retval, align 4, !dbg !945
  ret i32 %18, !dbg !945
}

; Function Attrs: noinline nounwind
define dso_local arm_aapcscc i32 @__unordsf2(float %a, float %b) #0 !dbg !946 {
entry:
  %a.addr = alloca float, align 4
  %b.addr = alloca float, align 4
  %aAbs = alloca i32, align 4
  %bAbs = alloca i32, align 4
  store float %a, float* %a.addr, align 4
  store float %b, float* %b.addr, align 4
  %0 = load float, float* %a.addr, align 4, !dbg !947
  %call = call arm_aapcs_vfpcc i32 @toRep.7(float %0) #4, !dbg !948
  %and = and i32 %call, 2147483647, !dbg !949
  store i32 %and, i32* %aAbs, align 4, !dbg !950
  %1 = load float, float* %b.addr, align 4, !dbg !951
  %call1 = call arm_aapcs_vfpcc i32 @toRep.7(float %1) #4, !dbg !952
  %and2 = and i32 %call1, 2147483647, !dbg !953
  store i32 %and2, i32* %bAbs, align 4, !dbg !954
  %2 = load i32, i32* %aAbs, align 4, !dbg !955
  %cmp = icmp ugt i32 %2, 2139095040, !dbg !956
  br i1 %cmp, label %lor.end, label %lor.rhs, !dbg !957

lor.rhs:                                          ; preds = %entry
  %3 = load i32, i32* %bAbs, align 4, !dbg !958
  %cmp3 = icmp ugt i32 %3, 2139095040, !dbg !959
  br label %lor.end, !dbg !957

lor.end:                                          ; preds = %lor.rhs, %entry
  %4 = phi i1 [ true, %entry ], [ %cmp3, %lor.rhs ]
  %lor.ext = zext i1 %4 to i32, !dbg !957
  ret i32 %lor.ext, !dbg !960
}

; Function Attrs: noinline nounwind
define dso_local arm_aapcscc i32 @__eqsf2(float %a, float %b) #0 !dbg !961 {
entry:
  %a.addr = alloca float, align 4
  %b.addr = alloca float, align 4
  store float %a, float* %a.addr, align 4
  store float %b, float* %b.addr, align 4
  %0 = load float, float* %a.addr, align 4, !dbg !962
  %1 = load float, float* %b.addr, align 4, !dbg !963
  %call = call arm_aapcscc i32 @__lesf2(float %0, float %1) #4, !dbg !964
  ret i32 %call, !dbg !965
}

; Function Attrs: noinline nounwind
define dso_local arm_aapcscc i32 @__ltsf2(float %a, float %b) #0 !dbg !966 {
entry:
  %a.addr = alloca float, align 4
  %b.addr = alloca float, align 4
  store float %a, float* %a.addr, align 4
  store float %b, float* %b.addr, align 4
  %0 = load float, float* %a.addr, align 4, !dbg !967
  %1 = load float, float* %b.addr, align 4, !dbg !968
  %call = call arm_aapcscc i32 @__lesf2(float %0, float %1) #4, !dbg !969
  ret i32 %call, !dbg !970
}

; Function Attrs: noinline nounwind
define dso_local arm_aapcscc i32 @__nesf2(float %a, float %b) #0 !dbg !971 {
entry:
  %a.addr = alloca float, align 4
  %b.addr = alloca float, align 4
  store float %a, float* %a.addr, align 4
  store float %b, float* %b.addr, align 4
  %0 = load float, float* %a.addr, align 4, !dbg !972
  %1 = load float, float* %b.addr, align 4, !dbg !973
  %call = call arm_aapcscc i32 @__lesf2(float %0, float %1) #4, !dbg !974
  ret i32 %call, !dbg !975
}

; Function Attrs: noinline nounwind
define dso_local arm_aapcscc i32 @__gtsf2(float %a, float %b) #0 !dbg !976 {
entry:
  %a.addr = alloca float, align 4
  %b.addr = alloca float, align 4
  store float %a, float* %a.addr, align 4
  store float %b, float* %b.addr, align 4
  %0 = load float, float* %a.addr, align 4, !dbg !977
  %1 = load float, float* %b.addr, align 4, !dbg !978
  %call = call arm_aapcscc i32 @__gesf2(float %0, float %1) #4, !dbg !979
  ret i32 %call, !dbg !980
}

; Function Attrs: noinline nounwind
define dso_local arm_aapcscc double @__divdf3(double %a, double %b) #0 !dbg !981 {
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
  %0 = load double, double* %a.addr, align 8, !dbg !982
  %call = call arm_aapcs_vfpcc i64 @toRep.8(double %0) #4, !dbg !983
  %shr = lshr i64 %call, 52, !dbg !984
  %and = and i64 %shr, 2047, !dbg !985
  %conv = trunc i64 %and to i32, !dbg !983
  store i32 %conv, i32* %aExponent, align 4, !dbg !986
  %1 = load double, double* %b.addr, align 8, !dbg !987
  %call1 = call arm_aapcs_vfpcc i64 @toRep.8(double %1) #4, !dbg !988
  %shr2 = lshr i64 %call1, 52, !dbg !989
  %and3 = and i64 %shr2, 2047, !dbg !990
  %conv4 = trunc i64 %and3 to i32, !dbg !988
  store i32 %conv4, i32* %bExponent, align 4, !dbg !991
  %2 = load double, double* %a.addr, align 8, !dbg !992
  %call5 = call arm_aapcs_vfpcc i64 @toRep.8(double %2) #4, !dbg !993
  %3 = load double, double* %b.addr, align 8, !dbg !994
  %call6 = call arm_aapcs_vfpcc i64 @toRep.8(double %3) #4, !dbg !995
  %xor = xor i64 %call5, %call6, !dbg !996
  %and7 = and i64 %xor, -9223372036854775808, !dbg !997
  store i64 %and7, i64* %quotientSign, align 8, !dbg !998
  %4 = load double, double* %a.addr, align 8, !dbg !999
  %call8 = call arm_aapcs_vfpcc i64 @toRep.8(double %4) #4, !dbg !1000
  %and9 = and i64 %call8, 4503599627370495, !dbg !1001
  store i64 %and9, i64* %aSignificand, align 8, !dbg !1002
  %5 = load double, double* %b.addr, align 8, !dbg !1003
  %call10 = call arm_aapcs_vfpcc i64 @toRep.8(double %5) #4, !dbg !1004
  %and11 = and i64 %call10, 4503599627370495, !dbg !1005
  store i64 %and11, i64* %bSignificand, align 8, !dbg !1006
  store i32 0, i32* %scale, align 4, !dbg !1007
  %6 = load i32, i32* %aExponent, align 4, !dbg !1008
  %sub = sub i32 %6, 1, !dbg !1009
  %cmp = icmp uge i32 %sub, 2046, !dbg !1010
  br i1 %cmp, label %if.then, label %lor.lhs.false, !dbg !1011

lor.lhs.false:                                    ; preds = %entry
  %7 = load i32, i32* %bExponent, align 4, !dbg !1012
  %sub13 = sub i32 %7, 1, !dbg !1013
  %cmp14 = icmp uge i32 %sub13, 2046, !dbg !1014
  br i1 %cmp14, label %if.then, label %if.end70, !dbg !1008

if.then:                                          ; preds = %lor.lhs.false, %entry
  %8 = load double, double* %a.addr, align 8, !dbg !1015
  %call16 = call arm_aapcs_vfpcc i64 @toRep.8(double %8) #4, !dbg !1016
  %and17 = and i64 %call16, 9223372036854775807, !dbg !1017
  store i64 %and17, i64* %aAbs, align 8, !dbg !1018
  %9 = load double, double* %b.addr, align 8, !dbg !1019
  %call18 = call arm_aapcs_vfpcc i64 @toRep.8(double %9) #4, !dbg !1020
  %and19 = and i64 %call18, 9223372036854775807, !dbg !1021
  store i64 %and19, i64* %bAbs, align 8, !dbg !1022
  %10 = load i64, i64* %aAbs, align 8, !dbg !1023
  %cmp20 = icmp ugt i64 %10, 9218868437227405312, !dbg !1024
  br i1 %cmp20, label %if.then22, label %if.end, !dbg !1023

if.then22:                                        ; preds = %if.then
  %11 = load double, double* %a.addr, align 8, !dbg !1025
  %call23 = call arm_aapcs_vfpcc i64 @toRep.8(double %11) #4, !dbg !1026
  %or = or i64 %call23, 2251799813685248, !dbg !1027
  %call24 = call arm_aapcs_vfpcc double @fromRep.9(i64 %or) #4, !dbg !1028
  store double %call24, double* %retval, align 8, !dbg !1029
  br label %return, !dbg !1029

if.end:                                           ; preds = %if.then
  %12 = load i64, i64* %bAbs, align 8, !dbg !1030
  %cmp25 = icmp ugt i64 %12, 9218868437227405312, !dbg !1031
  br i1 %cmp25, label %if.then27, label %if.end31, !dbg !1030

if.then27:                                        ; preds = %if.end
  %13 = load double, double* %b.addr, align 8, !dbg !1032
  %call28 = call arm_aapcs_vfpcc i64 @toRep.8(double %13) #4, !dbg !1033
  %or29 = or i64 %call28, 2251799813685248, !dbg !1034
  %call30 = call arm_aapcs_vfpcc double @fromRep.9(i64 %or29) #4, !dbg !1035
  store double %call30, double* %retval, align 8, !dbg !1036
  br label %return, !dbg !1036

if.end31:                                         ; preds = %if.end
  %14 = load i64, i64* %aAbs, align 8, !dbg !1037
  %cmp32 = icmp eq i64 %14, 9218868437227405312, !dbg !1038
  br i1 %cmp32, label %if.then34, label %if.end41, !dbg !1037

if.then34:                                        ; preds = %if.end31
  %15 = load i64, i64* %bAbs, align 8, !dbg !1039
  %cmp35 = icmp eq i64 %15, 9218868437227405312, !dbg !1040
  br i1 %cmp35, label %if.then37, label %if.else, !dbg !1039

if.then37:                                        ; preds = %if.then34
  %call38 = call arm_aapcs_vfpcc double @fromRep.9(i64 9221120237041090560) #4, !dbg !1041
  store double %call38, double* %retval, align 8, !dbg !1042
  br label %return, !dbg !1042

if.else:                                          ; preds = %if.then34
  %16 = load i64, i64* %aAbs, align 8, !dbg !1043
  %17 = load i64, i64* %quotientSign, align 8, !dbg !1044
  %or39 = or i64 %16, %17, !dbg !1045
  %call40 = call arm_aapcs_vfpcc double @fromRep.9(i64 %or39) #4, !dbg !1046
  store double %call40, double* %retval, align 8, !dbg !1047
  br label %return, !dbg !1047

if.end41:                                         ; preds = %if.end31
  %18 = load i64, i64* %bAbs, align 8, !dbg !1048
  %cmp42 = icmp eq i64 %18, 9218868437227405312, !dbg !1049
  br i1 %cmp42, label %if.then44, label %if.end46, !dbg !1048

if.then44:                                        ; preds = %if.end41
  %19 = load i64, i64* %quotientSign, align 8, !dbg !1050
  %call45 = call arm_aapcs_vfpcc double @fromRep.9(i64 %19) #4, !dbg !1051
  store double %call45, double* %retval, align 8, !dbg !1052
  br label %return, !dbg !1052

if.end46:                                         ; preds = %if.end41
  %20 = load i64, i64* %aAbs, align 8, !dbg !1053
  %tobool = icmp ne i64 %20, 0, !dbg !1053
  br i1 %tobool, label %if.end53, label %if.then47, !dbg !1054

if.then47:                                        ; preds = %if.end46
  %21 = load i64, i64* %bAbs, align 8, !dbg !1055
  %tobool48 = icmp ne i64 %21, 0, !dbg !1055
  br i1 %tobool48, label %if.else51, label %if.then49, !dbg !1056

if.then49:                                        ; preds = %if.then47
  %call50 = call arm_aapcs_vfpcc double @fromRep.9(i64 9221120237041090560) #4, !dbg !1057
  store double %call50, double* %retval, align 8, !dbg !1058
  br label %return, !dbg !1058

if.else51:                                        ; preds = %if.then47
  %22 = load i64, i64* %quotientSign, align 8, !dbg !1059
  %call52 = call arm_aapcs_vfpcc double @fromRep.9(i64 %22) #4, !dbg !1060
  store double %call52, double* %retval, align 8, !dbg !1061
  br label %return, !dbg !1061

if.end53:                                         ; preds = %if.end46
  %23 = load i64, i64* %bAbs, align 8, !dbg !1062
  %tobool54 = icmp ne i64 %23, 0, !dbg !1062
  br i1 %tobool54, label %if.end58, label %if.then55, !dbg !1063

if.then55:                                        ; preds = %if.end53
  %24 = load i64, i64* %quotientSign, align 8, !dbg !1064
  %or56 = or i64 9218868437227405312, %24, !dbg !1065
  %call57 = call arm_aapcs_vfpcc double @fromRep.9(i64 %or56) #4, !dbg !1066
  store double %call57, double* %retval, align 8, !dbg !1067
  br label %return, !dbg !1067

if.end58:                                         ; preds = %if.end53
  %25 = load i64, i64* %aAbs, align 8, !dbg !1068
  %cmp59 = icmp ult i64 %25, 4503599627370496, !dbg !1069
  br i1 %cmp59, label %if.then61, label %if.end63, !dbg !1068

if.then61:                                        ; preds = %if.end58
  %call62 = call arm_aapcs_vfpcc i32 @normalize.10(i64* %aSignificand) #4, !dbg !1070
  %26 = load i32, i32* %scale, align 4, !dbg !1071
  %add = add nsw i32 %26, %call62, !dbg !1071
  store i32 %add, i32* %scale, align 4, !dbg !1071
  br label %if.end63, !dbg !1072

if.end63:                                         ; preds = %if.then61, %if.end58
  %27 = load i64, i64* %bAbs, align 8, !dbg !1073
  %cmp64 = icmp ult i64 %27, 4503599627370496, !dbg !1074
  br i1 %cmp64, label %if.then66, label %if.end69, !dbg !1073

if.then66:                                        ; preds = %if.end63
  %call67 = call arm_aapcs_vfpcc i32 @normalize.10(i64* %bSignificand) #4, !dbg !1075
  %28 = load i32, i32* %scale, align 4, !dbg !1076
  %sub68 = sub nsw i32 %28, %call67, !dbg !1076
  store i32 %sub68, i32* %scale, align 4, !dbg !1076
  br label %if.end69, !dbg !1077

if.end69:                                         ; preds = %if.then66, %if.end63
  br label %if.end70, !dbg !1078

if.end70:                                         ; preds = %if.end69, %lor.lhs.false
  %29 = load i64, i64* %aSignificand, align 8, !dbg !1079
  %or71 = or i64 %29, 4503599627370496, !dbg !1079
  store i64 %or71, i64* %aSignificand, align 8, !dbg !1079
  %30 = load i64, i64* %bSignificand, align 8, !dbg !1080
  %or72 = or i64 %30, 4503599627370496, !dbg !1080
  store i64 %or72, i64* %bSignificand, align 8, !dbg !1080
  %31 = load i32, i32* %aExponent, align 4, !dbg !1081
  %32 = load i32, i32* %bExponent, align 4, !dbg !1082
  %sub73 = sub i32 %31, %32, !dbg !1083
  %33 = load i32, i32* %scale, align 4, !dbg !1084
  %add74 = add i32 %sub73, %33, !dbg !1085
  store i32 %add74, i32* %quotientExponent, align 4, !dbg !1086
  %34 = load i64, i64* %bSignificand, align 8, !dbg !1087
  %shr75 = lshr i64 %34, 21, !dbg !1088
  %conv76 = trunc i64 %shr75 to i32, !dbg !1087
  store i32 %conv76, i32* %q31b, align 4, !dbg !1089
  %35 = load i32, i32* %q31b, align 4, !dbg !1090
  %sub77 = sub i32 1963258675, %35, !dbg !1091
  store i32 %sub77, i32* %recip32, align 4, !dbg !1092
  %36 = load i32, i32* %recip32, align 4, !dbg !1093
  %conv78 = zext i32 %36 to i64, !dbg !1094
  %37 = load i32, i32* %q31b, align 4, !dbg !1095
  %conv79 = zext i32 %37 to i64, !dbg !1095
  %mul = mul i64 %conv78, %conv79, !dbg !1096
  %shr80 = lshr i64 %mul, 32, !dbg !1097
  %sub81 = sub i64 0, %shr80, !dbg !1098
  %conv82 = trunc i64 %sub81 to i32, !dbg !1098
  store i32 %conv82, i32* %correction32, align 4, !dbg !1099
  %38 = load i32, i32* %recip32, align 4, !dbg !1100
  %conv83 = zext i32 %38 to i64, !dbg !1101
  %39 = load i32, i32* %correction32, align 4, !dbg !1102
  %conv84 = zext i32 %39 to i64, !dbg !1102
  %mul85 = mul i64 %conv83, %conv84, !dbg !1103
  %shr86 = lshr i64 %mul85, 31, !dbg !1104
  %conv87 = trunc i64 %shr86 to i32, !dbg !1101
  store i32 %conv87, i32* %recip32, align 4, !dbg !1105
  %40 = load i32, i32* %recip32, align 4, !dbg !1106
  %conv88 = zext i32 %40 to i64, !dbg !1107
  %41 = load i32, i32* %q31b, align 4, !dbg !1108
  %conv89 = zext i32 %41 to i64, !dbg !1108
  %mul90 = mul i64 %conv88, %conv89, !dbg !1109
  %shr91 = lshr i64 %mul90, 32, !dbg !1110
  %sub92 = sub i64 0, %shr91, !dbg !1111
  %conv93 = trunc i64 %sub92 to i32, !dbg !1111
  store i32 %conv93, i32* %correction32, align 4, !dbg !1112
  %42 = load i32, i32* %recip32, align 4, !dbg !1113
  %conv94 = zext i32 %42 to i64, !dbg !1114
  %43 = load i32, i32* %correction32, align 4, !dbg !1115
  %conv95 = zext i32 %43 to i64, !dbg !1115
  %mul96 = mul i64 %conv94, %conv95, !dbg !1116
  %shr97 = lshr i64 %mul96, 31, !dbg !1117
  %conv98 = trunc i64 %shr97 to i32, !dbg !1114
  store i32 %conv98, i32* %recip32, align 4, !dbg !1118
  %44 = load i32, i32* %recip32, align 4, !dbg !1119
  %conv99 = zext i32 %44 to i64, !dbg !1120
  %45 = load i32, i32* %q31b, align 4, !dbg !1121
  %conv100 = zext i32 %45 to i64, !dbg !1121
  %mul101 = mul i64 %conv99, %conv100, !dbg !1122
  %shr102 = lshr i64 %mul101, 32, !dbg !1123
  %sub103 = sub i64 0, %shr102, !dbg !1124
  %conv104 = trunc i64 %sub103 to i32, !dbg !1124
  store i32 %conv104, i32* %correction32, align 4, !dbg !1125
  %46 = load i32, i32* %recip32, align 4, !dbg !1126
  %conv105 = zext i32 %46 to i64, !dbg !1127
  %47 = load i32, i32* %correction32, align 4, !dbg !1128
  %conv106 = zext i32 %47 to i64, !dbg !1128
  %mul107 = mul i64 %conv105, %conv106, !dbg !1129
  %shr108 = lshr i64 %mul107, 31, !dbg !1130
  %conv109 = trunc i64 %shr108 to i32, !dbg !1127
  store i32 %conv109, i32* %recip32, align 4, !dbg !1131
  %48 = load i32, i32* %recip32, align 4, !dbg !1132
  %dec = add i32 %48, -1, !dbg !1132
  store i32 %dec, i32* %recip32, align 4, !dbg !1132
  %49 = load i64, i64* %bSignificand, align 8, !dbg !1133
  %shl = shl i64 %49, 11, !dbg !1134
  %conv110 = trunc i64 %shl to i32, !dbg !1133
  store i32 %conv110, i32* %q63blo, align 4, !dbg !1135
  %50 = load i32, i32* %recip32, align 4, !dbg !1136
  %conv111 = zext i32 %50 to i64, !dbg !1137
  %51 = load i32, i32* %q31b, align 4, !dbg !1138
  %conv112 = zext i32 %51 to i64, !dbg !1138
  %mul113 = mul i64 %conv111, %conv112, !dbg !1139
  %52 = load i32, i32* %recip32, align 4, !dbg !1140
  %conv114 = zext i32 %52 to i64, !dbg !1141
  %53 = load i32, i32* %q63blo, align 4, !dbg !1142
  %conv115 = zext i32 %53 to i64, !dbg !1142
  %mul116 = mul i64 %conv114, %conv115, !dbg !1143
  %shr117 = lshr i64 %mul116, 32, !dbg !1144
  %add118 = add i64 %mul113, %shr117, !dbg !1145
  %sub119 = sub i64 0, %add118, !dbg !1146
  store i64 %sub119, i64* %correction, align 8, !dbg !1147
  %54 = load i64, i64* %correction, align 8, !dbg !1148
  %shr120 = lshr i64 %54, 32, !dbg !1149
  %conv121 = trunc i64 %shr120 to i32, !dbg !1148
  store i32 %conv121, i32* %cHi, align 4, !dbg !1150
  %55 = load i64, i64* %correction, align 8, !dbg !1151
  %conv122 = trunc i64 %55 to i32, !dbg !1151
  store i32 %conv122, i32* %cLo, align 4, !dbg !1152
  %56 = load i32, i32* %recip32, align 4, !dbg !1153
  %conv123 = zext i32 %56 to i64, !dbg !1154
  %57 = load i32, i32* %cHi, align 4, !dbg !1155
  %conv124 = zext i32 %57 to i64, !dbg !1155
  %mul125 = mul i64 %conv123, %conv124, !dbg !1156
  %58 = load i32, i32* %recip32, align 4, !dbg !1157
  %conv126 = zext i32 %58 to i64, !dbg !1158
  %59 = load i32, i32* %cLo, align 4, !dbg !1159
  %conv127 = zext i32 %59 to i64, !dbg !1159
  %mul128 = mul i64 %conv126, %conv127, !dbg !1160
  %shr129 = lshr i64 %mul128, 32, !dbg !1161
  %add130 = add i64 %mul125, %shr129, !dbg !1162
  store i64 %add130, i64* %reciprocal, align 8, !dbg !1163
  %60 = load i64, i64* %reciprocal, align 8, !dbg !1164
  %sub131 = sub i64 %60, 2, !dbg !1164
  store i64 %sub131, i64* %reciprocal, align 8, !dbg !1164
  %61 = load i64, i64* %aSignificand, align 8, !dbg !1165
  %shl132 = shl i64 %61, 2, !dbg !1166
  %62 = load i64, i64* %reciprocal, align 8, !dbg !1167
  call arm_aapcs_vfpcc void @wideMultiply(i64 %shl132, i64 %62, i64* %quotient, i64* %quotientLo) #4, !dbg !1168
  %63 = load i64, i64* %quotient, align 8, !dbg !1169
  %cmp133 = icmp ult i64 %63, 9007199254740992, !dbg !1170
  br i1 %cmp133, label %if.then135, label %if.else140, !dbg !1169

if.then135:                                       ; preds = %if.end70
  %64 = load i64, i64* %aSignificand, align 8, !dbg !1171
  %shl136 = shl i64 %64, 53, !dbg !1172
  %65 = load i64, i64* %quotient, align 8, !dbg !1173
  %66 = load i64, i64* %bSignificand, align 8, !dbg !1174
  %mul137 = mul i64 %65, %66, !dbg !1175
  %sub138 = sub i64 %shl136, %mul137, !dbg !1176
  store i64 %sub138, i64* %residual, align 8, !dbg !1177
  %67 = load i32, i32* %quotientExponent, align 4, !dbg !1178
  %dec139 = add nsw i32 %67, -1, !dbg !1178
  store i32 %dec139, i32* %quotientExponent, align 4, !dbg !1178
  br label %if.end145, !dbg !1179

if.else140:                                       ; preds = %if.end70
  %68 = load i64, i64* %quotient, align 8, !dbg !1180
  %shr141 = lshr i64 %68, 1, !dbg !1180
  store i64 %shr141, i64* %quotient, align 8, !dbg !1180
  %69 = load i64, i64* %aSignificand, align 8, !dbg !1181
  %shl142 = shl i64 %69, 52, !dbg !1182
  %70 = load i64, i64* %quotient, align 8, !dbg !1183
  %71 = load i64, i64* %bSignificand, align 8, !dbg !1184
  %mul143 = mul i64 %70, %71, !dbg !1185
  %sub144 = sub i64 %shl142, %mul143, !dbg !1186
  store i64 %sub144, i64* %residual, align 8, !dbg !1187
  br label %if.end145

if.end145:                                        ; preds = %if.else140, %if.then135
  %72 = load i32, i32* %quotientExponent, align 4, !dbg !1188
  %add146 = add nsw i32 %72, 1023, !dbg !1189
  store i32 %add146, i32* %writtenExponent, align 4, !dbg !1190
  %73 = load i32, i32* %writtenExponent, align 4, !dbg !1191
  %cmp147 = icmp sge i32 %73, 2047, !dbg !1192
  br i1 %cmp147, label %if.then149, label %if.else152, !dbg !1191

if.then149:                                       ; preds = %if.end145
  %74 = load i64, i64* %quotientSign, align 8, !dbg !1193
  %or150 = or i64 9218868437227405312, %74, !dbg !1194
  %call151 = call arm_aapcs_vfpcc double @fromRep.9(i64 %or150) #4, !dbg !1195
  store double %call151, double* %retval, align 8, !dbg !1196
  br label %return, !dbg !1196

if.else152:                                       ; preds = %if.end145
  %75 = load i32, i32* %writtenExponent, align 4, !dbg !1197
  %cmp153 = icmp slt i32 %75, 1, !dbg !1198
  br i1 %cmp153, label %if.then155, label %if.else157, !dbg !1197

if.then155:                                       ; preds = %if.else152
  %76 = load i64, i64* %quotientSign, align 8, !dbg !1199
  %call156 = call arm_aapcs_vfpcc double @fromRep.9(i64 %76) #4, !dbg !1200
  store double %call156, double* %retval, align 8, !dbg !1201
  br label %return, !dbg !1201

if.else157:                                       ; preds = %if.else152
  %77 = load i64, i64* %residual, align 8, !dbg !1202
  %shl158 = shl i64 %77, 1, !dbg !1203
  %78 = load i64, i64* %bSignificand, align 8, !dbg !1204
  %cmp159 = icmp ugt i64 %shl158, %78, !dbg !1205
  %frombool = zext i1 %cmp159 to i8, !dbg !1206
  store i8 %frombool, i8* %round, align 1, !dbg !1206
  %79 = load i64, i64* %quotient, align 8, !dbg !1207
  %and161 = and i64 %79, 4503599627370495, !dbg !1208
  store i64 %and161, i64* %absResult, align 8, !dbg !1209
  %80 = load i32, i32* %writtenExponent, align 4, !dbg !1210
  %conv162 = sext i32 %80 to i64, !dbg !1211
  %shl163 = shl i64 %conv162, 52, !dbg !1212
  %81 = load i64, i64* %absResult, align 8, !dbg !1213
  %or164 = or i64 %81, %shl163, !dbg !1213
  store i64 %or164, i64* %absResult, align 8, !dbg !1213
  %82 = load i8, i8* %round, align 1, !dbg !1214
  %tobool165 = trunc i8 %82 to i1, !dbg !1214
  %conv166 = zext i1 %tobool165 to i64, !dbg !1214
  %83 = load i64, i64* %absResult, align 8, !dbg !1215
  %add167 = add i64 %83, %conv166, !dbg !1215
  store i64 %add167, i64* %absResult, align 8, !dbg !1215
  %84 = load i64, i64* %absResult, align 8, !dbg !1216
  %85 = load i64, i64* %quotientSign, align 8, !dbg !1217
  %or168 = or i64 %84, %85, !dbg !1218
  %call169 = call arm_aapcs_vfpcc double @fromRep.9(i64 %or168) #4, !dbg !1219
  store double %call169, double* %result, align 8, !dbg !1220
  %86 = load double, double* %result, align 8, !dbg !1221
  store double %86, double* %retval, align 8, !dbg !1222
  br label %return, !dbg !1222

return:                                           ; preds = %if.else157, %if.then155, %if.then149, %if.then55, %if.else51, %if.then49, %if.then44, %if.else, %if.then37, %if.then27, %if.then22
  %87 = load double, double* %retval, align 8, !dbg !1223
  ret double %87, !dbg !1223
}

; Function Attrs: noinline nounwind
define internal arm_aapcs_vfpcc i64 @toRep.8(double %x) #0 !dbg !1224 {
entry:
  %x.addr = alloca double, align 8
  %rep = alloca %union.anon.0, align 8
  store double %x, double* %x.addr, align 8
  %f = bitcast %union.anon.0* %rep to double*, !dbg !1225
  %0 = load double, double* %x.addr, align 8, !dbg !1226
  store double %0, double* %f, align 8, !dbg !1225
  %i = bitcast %union.anon.0* %rep to i64*, !dbg !1227
  %1 = load i64, i64* %i, align 8, !dbg !1227
  ret i64 %1, !dbg !1228
}

; Function Attrs: noinline nounwind
define internal arm_aapcs_vfpcc double @fromRep.9(i64 %x) #0 !dbg !1229 {
entry:
  %x.addr = alloca i64, align 8
  %rep = alloca %union.anon.0, align 8
  store i64 %x, i64* %x.addr, align 8
  %i = bitcast %union.anon.0* %rep to i64*, !dbg !1230
  %0 = load i64, i64* %x.addr, align 8, !dbg !1231
  store i64 %0, i64* %i, align 8, !dbg !1230
  %f = bitcast %union.anon.0* %rep to double*, !dbg !1232
  %1 = load double, double* %f, align 8, !dbg !1232
  ret double %1, !dbg !1233
}

; Function Attrs: noinline nounwind
define internal arm_aapcs_vfpcc i32 @normalize.10(i64* %significand) #0 !dbg !1234 {
entry:
  %significand.addr = alloca i64*, align 4
  %shift = alloca i32, align 4
  store i64* %significand, i64** %significand.addr, align 4
  %0 = load i64*, i64** %significand.addr, align 4, !dbg !1235
  %1 = load i64, i64* %0, align 8, !dbg !1236
  %call = call arm_aapcs_vfpcc i32 @rep_clz.11(i64 %1) #4, !dbg !1237
  %call1 = call arm_aapcs_vfpcc i32 @rep_clz.11(i64 4503599627370496) #4, !dbg !1238
  %sub = sub nsw i32 %call, %call1, !dbg !1239
  store i32 %sub, i32* %shift, align 4, !dbg !1240
  %2 = load i32, i32* %shift, align 4, !dbg !1241
  %3 = load i64*, i64** %significand.addr, align 4, !dbg !1242
  %4 = load i64, i64* %3, align 8, !dbg !1243
  %sh_prom = zext i32 %2 to i64, !dbg !1243
  %shl = shl i64 %4, %sh_prom, !dbg !1243
  store i64 %shl, i64* %3, align 8, !dbg !1243
  %5 = load i32, i32* %shift, align 4, !dbg !1244
  %sub2 = sub nsw i32 1, %5, !dbg !1245
  ret i32 %sub2, !dbg !1246
}

; Function Attrs: noinline nounwind
define internal arm_aapcs_vfpcc void @wideMultiply(i64 %a, i64 %b, i64* %hi, i64* %lo) #0 !dbg !1247 {
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
  %0 = load i64, i64* %a.addr, align 8, !dbg !1248
  %and = and i64 %0, 4294967295, !dbg !1248
  %1 = load i64, i64* %b.addr, align 8, !dbg !1249
  %and1 = and i64 %1, 4294967295, !dbg !1249
  %mul = mul i64 %and, %and1, !dbg !1250
  store i64 %mul, i64* %plolo, align 8, !dbg !1251
  %2 = load i64, i64* %a.addr, align 8, !dbg !1252
  %and2 = and i64 %2, 4294967295, !dbg !1252
  %3 = load i64, i64* %b.addr, align 8, !dbg !1253
  %shr = lshr i64 %3, 32, !dbg !1253
  %mul3 = mul i64 %and2, %shr, !dbg !1254
  store i64 %mul3, i64* %plohi, align 8, !dbg !1255
  %4 = load i64, i64* %a.addr, align 8, !dbg !1256
  %shr4 = lshr i64 %4, 32, !dbg !1256
  %5 = load i64, i64* %b.addr, align 8, !dbg !1257
  %and5 = and i64 %5, 4294967295, !dbg !1257
  %mul6 = mul i64 %shr4, %and5, !dbg !1258
  store i64 %mul6, i64* %philo, align 8, !dbg !1259
  %6 = load i64, i64* %a.addr, align 8, !dbg !1260
  %shr7 = lshr i64 %6, 32, !dbg !1260
  %7 = load i64, i64* %b.addr, align 8, !dbg !1261
  %shr8 = lshr i64 %7, 32, !dbg !1261
  %mul9 = mul i64 %shr7, %shr8, !dbg !1262
  store i64 %mul9, i64* %phihi, align 8, !dbg !1263
  %8 = load i64, i64* %plolo, align 8, !dbg !1264
  %and10 = and i64 %8, 4294967295, !dbg !1264
  store i64 %and10, i64* %r0, align 8, !dbg !1265
  %9 = load i64, i64* %plolo, align 8, !dbg !1266
  %shr11 = lshr i64 %9, 32, !dbg !1266
  %10 = load i64, i64* %plohi, align 8, !dbg !1267
  %and12 = and i64 %10, 4294967295, !dbg !1267
  %add = add i64 %shr11, %and12, !dbg !1268
  %11 = load i64, i64* %philo, align 8, !dbg !1269
  %and13 = and i64 %11, 4294967295, !dbg !1269
  %add14 = add i64 %add, %and13, !dbg !1270
  store i64 %add14, i64* %r1, align 8, !dbg !1271
  %12 = load i64, i64* %r0, align 8, !dbg !1272
  %13 = load i64, i64* %r1, align 8, !dbg !1273
  %shl = shl i64 %13, 32, !dbg !1274
  %add15 = add i64 %12, %shl, !dbg !1275
  %14 = load i64*, i64** %lo.addr, align 4, !dbg !1276
  store i64 %add15, i64* %14, align 8, !dbg !1277
  %15 = load i64, i64* %plohi, align 8, !dbg !1278
  %shr16 = lshr i64 %15, 32, !dbg !1278
  %16 = load i64, i64* %philo, align 8, !dbg !1279
  %shr17 = lshr i64 %16, 32, !dbg !1279
  %add18 = add i64 %shr16, %shr17, !dbg !1280
  %17 = load i64, i64* %r1, align 8, !dbg !1281
  %shr19 = lshr i64 %17, 32, !dbg !1281
  %add20 = add i64 %add18, %shr19, !dbg !1282
  %18 = load i64, i64* %phihi, align 8, !dbg !1283
  %add21 = add i64 %add20, %18, !dbg !1284
  %19 = load i64*, i64** %hi.addr, align 4, !dbg !1285
  store i64 %add21, i64* %19, align 8, !dbg !1286
  ret void, !dbg !1287
}

; Function Attrs: noinline nounwind
define internal arm_aapcs_vfpcc i32 @rep_clz.11(i64 %a) #0 !dbg !1288 {
entry:
  %retval = alloca i32, align 4
  %a.addr = alloca i64, align 8
  store i64 %a, i64* %a.addr, align 8
  %0 = load i64, i64* %a.addr, align 8, !dbg !1289
  %and = and i64 %0, -4294967296, !dbg !1290
  %tobool = icmp ne i64 %and, 0, !dbg !1290
  br i1 %tobool, label %if.then, label %if.else, !dbg !1289

if.then:                                          ; preds = %entry
  %1 = load i64, i64* %a.addr, align 8, !dbg !1291
  %shr = lshr i64 %1, 32, !dbg !1292
  %conv = trunc i64 %shr to i32, !dbg !1291
  %2 = call i32 @llvm.ctlz.i32(i32 %conv, i1 false), !dbg !1293
  store i32 %2, i32* %retval, align 4, !dbg !1294
  br label %return, !dbg !1294

if.else:                                          ; preds = %entry
  %3 = load i64, i64* %a.addr, align 8, !dbg !1295
  %and1 = and i64 %3, 4294967295, !dbg !1296
  %conv2 = trunc i64 %and1 to i32, !dbg !1295
  %4 = call i32 @llvm.ctlz.i32(i32 %conv2, i1 false), !dbg !1297
  %add = add nsw i32 32, %4, !dbg !1298
  store i32 %add, i32* %retval, align 4, !dbg !1299
  br label %return, !dbg !1299

return:                                           ; preds = %if.else, %if.then
  %5 = load i32, i32* %retval, align 4, !dbg !1300
  ret i32 %5, !dbg !1300
}

; Function Attrs: noinline nounwind
define dso_local arm_aapcscc float @__divsf3(float %a, float %b) #0 !dbg !1301 {
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
  %0 = load float, float* %a.addr, align 4, !dbg !1302
  %call = call arm_aapcs_vfpcc i32 @toRep.12(float %0) #4, !dbg !1303
  %shr = lshr i32 %call, 23, !dbg !1304
  %and = and i32 %shr, 255, !dbg !1305
  store i32 %and, i32* %aExponent, align 4, !dbg !1306
  %1 = load float, float* %b.addr, align 4, !dbg !1307
  %call1 = call arm_aapcs_vfpcc i32 @toRep.12(float %1) #4, !dbg !1308
  %shr2 = lshr i32 %call1, 23, !dbg !1309
  %and3 = and i32 %shr2, 255, !dbg !1310
  store i32 %and3, i32* %bExponent, align 4, !dbg !1311
  %2 = load float, float* %a.addr, align 4, !dbg !1312
  %call4 = call arm_aapcs_vfpcc i32 @toRep.12(float %2) #4, !dbg !1313
  %3 = load float, float* %b.addr, align 4, !dbg !1314
  %call5 = call arm_aapcs_vfpcc i32 @toRep.12(float %3) #4, !dbg !1315
  %xor = xor i32 %call4, %call5, !dbg !1316
  %and6 = and i32 %xor, -2147483648, !dbg !1317
  store i32 %and6, i32* %quotientSign, align 4, !dbg !1318
  %4 = load float, float* %a.addr, align 4, !dbg !1319
  %call7 = call arm_aapcs_vfpcc i32 @toRep.12(float %4) #4, !dbg !1320
  %and8 = and i32 %call7, 8388607, !dbg !1321
  store i32 %and8, i32* %aSignificand, align 4, !dbg !1322
  %5 = load float, float* %b.addr, align 4, !dbg !1323
  %call9 = call arm_aapcs_vfpcc i32 @toRep.12(float %5) #4, !dbg !1324
  %and10 = and i32 %call9, 8388607, !dbg !1325
  store i32 %and10, i32* %bSignificand, align 4, !dbg !1326
  store i32 0, i32* %scale, align 4, !dbg !1327
  %6 = load i32, i32* %aExponent, align 4, !dbg !1328
  %sub = sub i32 %6, 1, !dbg !1329
  %cmp = icmp uge i32 %sub, 254, !dbg !1330
  br i1 %cmp, label %if.then, label %lor.lhs.false, !dbg !1331

lor.lhs.false:                                    ; preds = %entry
  %7 = load i32, i32* %bExponent, align 4, !dbg !1332
  %sub11 = sub i32 %7, 1, !dbg !1333
  %cmp12 = icmp uge i32 %sub11, 254, !dbg !1334
  br i1 %cmp12, label %if.then, label %if.end60, !dbg !1328

if.then:                                          ; preds = %lor.lhs.false, %entry
  %8 = load float, float* %a.addr, align 4, !dbg !1335
  %call13 = call arm_aapcs_vfpcc i32 @toRep.12(float %8) #4, !dbg !1336
  %and14 = and i32 %call13, 2147483647, !dbg !1337
  store i32 %and14, i32* %aAbs, align 4, !dbg !1338
  %9 = load float, float* %b.addr, align 4, !dbg !1339
  %call15 = call arm_aapcs_vfpcc i32 @toRep.12(float %9) #4, !dbg !1340
  %and16 = and i32 %call15, 2147483647, !dbg !1341
  store i32 %and16, i32* %bAbs, align 4, !dbg !1342
  %10 = load i32, i32* %aAbs, align 4, !dbg !1343
  %cmp17 = icmp ugt i32 %10, 2139095040, !dbg !1344
  br i1 %cmp17, label %if.then18, label %if.end, !dbg !1343

if.then18:                                        ; preds = %if.then
  %11 = load float, float* %a.addr, align 4, !dbg !1345
  %call19 = call arm_aapcs_vfpcc i32 @toRep.12(float %11) #4, !dbg !1346
  %or = or i32 %call19, 4194304, !dbg !1347
  %call20 = call arm_aapcs_vfpcc float @fromRep.13(i32 %or) #4, !dbg !1348
  store float %call20, float* %retval, align 4, !dbg !1349
  br label %return, !dbg !1349

if.end:                                           ; preds = %if.then
  %12 = load i32, i32* %bAbs, align 4, !dbg !1350
  %cmp21 = icmp ugt i32 %12, 2139095040, !dbg !1351
  br i1 %cmp21, label %if.then22, label %if.end26, !dbg !1350

if.then22:                                        ; preds = %if.end
  %13 = load float, float* %b.addr, align 4, !dbg !1352
  %call23 = call arm_aapcs_vfpcc i32 @toRep.12(float %13) #4, !dbg !1353
  %or24 = or i32 %call23, 4194304, !dbg !1354
  %call25 = call arm_aapcs_vfpcc float @fromRep.13(i32 %or24) #4, !dbg !1355
  store float %call25, float* %retval, align 4, !dbg !1356
  br label %return, !dbg !1356

if.end26:                                         ; preds = %if.end
  %14 = load i32, i32* %aAbs, align 4, !dbg !1357
  %cmp27 = icmp eq i32 %14, 2139095040, !dbg !1358
  br i1 %cmp27, label %if.then28, label %if.end34, !dbg !1357

if.then28:                                        ; preds = %if.end26
  %15 = load i32, i32* %bAbs, align 4, !dbg !1359
  %cmp29 = icmp eq i32 %15, 2139095040, !dbg !1360
  br i1 %cmp29, label %if.then30, label %if.else, !dbg !1359

if.then30:                                        ; preds = %if.then28
  %call31 = call arm_aapcs_vfpcc float @fromRep.13(i32 2143289344) #4, !dbg !1361
  store float %call31, float* %retval, align 4, !dbg !1362
  br label %return, !dbg !1362

if.else:                                          ; preds = %if.then28
  %16 = load i32, i32* %aAbs, align 4, !dbg !1363
  %17 = load i32, i32* %quotientSign, align 4, !dbg !1364
  %or32 = or i32 %16, %17, !dbg !1365
  %call33 = call arm_aapcs_vfpcc float @fromRep.13(i32 %or32) #4, !dbg !1366
  store float %call33, float* %retval, align 4, !dbg !1367
  br label %return, !dbg !1367

if.end34:                                         ; preds = %if.end26
  %18 = load i32, i32* %bAbs, align 4, !dbg !1368
  %cmp35 = icmp eq i32 %18, 2139095040, !dbg !1369
  br i1 %cmp35, label %if.then36, label %if.end38, !dbg !1368

if.then36:                                        ; preds = %if.end34
  %19 = load i32, i32* %quotientSign, align 4, !dbg !1370
  %call37 = call arm_aapcs_vfpcc float @fromRep.13(i32 %19) #4, !dbg !1371
  store float %call37, float* %retval, align 4, !dbg !1372
  br label %return, !dbg !1372

if.end38:                                         ; preds = %if.end34
  %20 = load i32, i32* %aAbs, align 4, !dbg !1373
  %tobool = icmp ne i32 %20, 0, !dbg !1373
  br i1 %tobool, label %if.end45, label %if.then39, !dbg !1374

if.then39:                                        ; preds = %if.end38
  %21 = load i32, i32* %bAbs, align 4, !dbg !1375
  %tobool40 = icmp ne i32 %21, 0, !dbg !1375
  br i1 %tobool40, label %if.else43, label %if.then41, !dbg !1376

if.then41:                                        ; preds = %if.then39
  %call42 = call arm_aapcs_vfpcc float @fromRep.13(i32 2143289344) #4, !dbg !1377
  store float %call42, float* %retval, align 4, !dbg !1378
  br label %return, !dbg !1378

if.else43:                                        ; preds = %if.then39
  %22 = load i32, i32* %quotientSign, align 4, !dbg !1379
  %call44 = call arm_aapcs_vfpcc float @fromRep.13(i32 %22) #4, !dbg !1380
  store float %call44, float* %retval, align 4, !dbg !1381
  br label %return, !dbg !1381

if.end45:                                         ; preds = %if.end38
  %23 = load i32, i32* %bAbs, align 4, !dbg !1382
  %tobool46 = icmp ne i32 %23, 0, !dbg !1382
  br i1 %tobool46, label %if.end50, label %if.then47, !dbg !1383

if.then47:                                        ; preds = %if.end45
  %24 = load i32, i32* %quotientSign, align 4, !dbg !1384
  %or48 = or i32 2139095040, %24, !dbg !1385
  %call49 = call arm_aapcs_vfpcc float @fromRep.13(i32 %or48) #4, !dbg !1386
  store float %call49, float* %retval, align 4, !dbg !1387
  br label %return, !dbg !1387

if.end50:                                         ; preds = %if.end45
  %25 = load i32, i32* %aAbs, align 4, !dbg !1388
  %cmp51 = icmp ult i32 %25, 8388608, !dbg !1389
  br i1 %cmp51, label %if.then52, label %if.end54, !dbg !1388

if.then52:                                        ; preds = %if.end50
  %call53 = call arm_aapcs_vfpcc i32 @normalize.14(i32* %aSignificand) #4, !dbg !1390
  %26 = load i32, i32* %scale, align 4, !dbg !1391
  %add = add nsw i32 %26, %call53, !dbg !1391
  store i32 %add, i32* %scale, align 4, !dbg !1391
  br label %if.end54, !dbg !1392

if.end54:                                         ; preds = %if.then52, %if.end50
  %27 = load i32, i32* %bAbs, align 4, !dbg !1393
  %cmp55 = icmp ult i32 %27, 8388608, !dbg !1394
  br i1 %cmp55, label %if.then56, label %if.end59, !dbg !1393

if.then56:                                        ; preds = %if.end54
  %call57 = call arm_aapcs_vfpcc i32 @normalize.14(i32* %bSignificand) #4, !dbg !1395
  %28 = load i32, i32* %scale, align 4, !dbg !1396
  %sub58 = sub nsw i32 %28, %call57, !dbg !1396
  store i32 %sub58, i32* %scale, align 4, !dbg !1396
  br label %if.end59, !dbg !1397

if.end59:                                         ; preds = %if.then56, %if.end54
  br label %if.end60, !dbg !1398

if.end60:                                         ; preds = %if.end59, %lor.lhs.false
  %29 = load i32, i32* %aSignificand, align 4, !dbg !1399
  %or61 = or i32 %29, 8388608, !dbg !1399
  store i32 %or61, i32* %aSignificand, align 4, !dbg !1399
  %30 = load i32, i32* %bSignificand, align 4, !dbg !1400
  %or62 = or i32 %30, 8388608, !dbg !1400
  store i32 %or62, i32* %bSignificand, align 4, !dbg !1400
  %31 = load i32, i32* %aExponent, align 4, !dbg !1401
  %32 = load i32, i32* %bExponent, align 4, !dbg !1402
  %sub63 = sub i32 %31, %32, !dbg !1403
  %33 = load i32, i32* %scale, align 4, !dbg !1404
  %add64 = add i32 %sub63, %33, !dbg !1405
  store i32 %add64, i32* %quotientExponent, align 4, !dbg !1406
  %34 = load i32, i32* %bSignificand, align 4, !dbg !1407
  %shl = shl i32 %34, 8, !dbg !1408
  store i32 %shl, i32* %q31b, align 4, !dbg !1409
  %35 = load i32, i32* %q31b, align 4, !dbg !1410
  %sub65 = sub i32 1963258675, %35, !dbg !1411
  store i32 %sub65, i32* %reciprocal, align 4, !dbg !1412
  %36 = load i32, i32* %reciprocal, align 4, !dbg !1413
  %conv = zext i32 %36 to i64, !dbg !1414
  %37 = load i32, i32* %q31b, align 4, !dbg !1415
  %conv66 = zext i32 %37 to i64, !dbg !1415
  %mul = mul i64 %conv, %conv66, !dbg !1416
  %shr67 = lshr i64 %mul, 32, !dbg !1417
  %sub68 = sub i64 0, %shr67, !dbg !1418
  %conv69 = trunc i64 %sub68 to i32, !dbg !1418
  store i32 %conv69, i32* %correction, align 4, !dbg !1419
  %38 = load i32, i32* %reciprocal, align 4, !dbg !1420
  %conv70 = zext i32 %38 to i64, !dbg !1421
  %39 = load i32, i32* %correction, align 4, !dbg !1422
  %conv71 = zext i32 %39 to i64, !dbg !1422
  %mul72 = mul i64 %conv70, %conv71, !dbg !1423
  %shr73 = lshr i64 %mul72, 31, !dbg !1424
  %conv74 = trunc i64 %shr73 to i32, !dbg !1421
  store i32 %conv74, i32* %reciprocal, align 4, !dbg !1425
  %40 = load i32, i32* %reciprocal, align 4, !dbg !1426
  %conv75 = zext i32 %40 to i64, !dbg !1427
  %41 = load i32, i32* %q31b, align 4, !dbg !1428
  %conv76 = zext i32 %41 to i64, !dbg !1428
  %mul77 = mul i64 %conv75, %conv76, !dbg !1429
  %shr78 = lshr i64 %mul77, 32, !dbg !1430
  %sub79 = sub i64 0, %shr78, !dbg !1431
  %conv80 = trunc i64 %sub79 to i32, !dbg !1431
  store i32 %conv80, i32* %correction, align 4, !dbg !1432
  %42 = load i32, i32* %reciprocal, align 4, !dbg !1433
  %conv81 = zext i32 %42 to i64, !dbg !1434
  %43 = load i32, i32* %correction, align 4, !dbg !1435
  %conv82 = zext i32 %43 to i64, !dbg !1435
  %mul83 = mul i64 %conv81, %conv82, !dbg !1436
  %shr84 = lshr i64 %mul83, 31, !dbg !1437
  %conv85 = trunc i64 %shr84 to i32, !dbg !1434
  store i32 %conv85, i32* %reciprocal, align 4, !dbg !1438
  %44 = load i32, i32* %reciprocal, align 4, !dbg !1439
  %conv86 = zext i32 %44 to i64, !dbg !1440
  %45 = load i32, i32* %q31b, align 4, !dbg !1441
  %conv87 = zext i32 %45 to i64, !dbg !1441
  %mul88 = mul i64 %conv86, %conv87, !dbg !1442
  %shr89 = lshr i64 %mul88, 32, !dbg !1443
  %sub90 = sub i64 0, %shr89, !dbg !1444
  %conv91 = trunc i64 %sub90 to i32, !dbg !1444
  store i32 %conv91, i32* %correction, align 4, !dbg !1445
  %46 = load i32, i32* %reciprocal, align 4, !dbg !1446
  %conv92 = zext i32 %46 to i64, !dbg !1447
  %47 = load i32, i32* %correction, align 4, !dbg !1448
  %conv93 = zext i32 %47 to i64, !dbg !1448
  %mul94 = mul i64 %conv92, %conv93, !dbg !1449
  %shr95 = lshr i64 %mul94, 31, !dbg !1450
  %conv96 = trunc i64 %shr95 to i32, !dbg !1447
  store i32 %conv96, i32* %reciprocal, align 4, !dbg !1451
  %48 = load i32, i32* %reciprocal, align 4, !dbg !1452
  %sub97 = sub i32 %48, 2, !dbg !1452
  store i32 %sub97, i32* %reciprocal, align 4, !dbg !1452
  %49 = load i32, i32* %reciprocal, align 4, !dbg !1453
  %conv98 = zext i32 %49 to i64, !dbg !1454
  %50 = load i32, i32* %aSignificand, align 4, !dbg !1455
  %shl99 = shl i32 %50, 1, !dbg !1456
  %conv100 = zext i32 %shl99 to i64, !dbg !1457
  %mul101 = mul i64 %conv98, %conv100, !dbg !1458
  %shr102 = lshr i64 %mul101, 32, !dbg !1459
  %conv103 = trunc i64 %shr102 to i32, !dbg !1454
  store i32 %conv103, i32* %quotient, align 4, !dbg !1460
  %51 = load i32, i32* %quotient, align 4, !dbg !1461
  %cmp104 = icmp ult i32 %51, 16777216, !dbg !1462
  br i1 %cmp104, label %if.then106, label %if.else110, !dbg !1461

if.then106:                                       ; preds = %if.end60
  %52 = load i32, i32* %aSignificand, align 4, !dbg !1463
  %shl107 = shl i32 %52, 24, !dbg !1464
  %53 = load i32, i32* %quotient, align 4, !dbg !1465
  %54 = load i32, i32* %bSignificand, align 4, !dbg !1466
  %mul108 = mul i32 %53, %54, !dbg !1467
  %sub109 = sub i32 %shl107, %mul108, !dbg !1468
  store i32 %sub109, i32* %residual, align 4, !dbg !1469
  %55 = load i32, i32* %quotientExponent, align 4, !dbg !1470
  %dec = add nsw i32 %55, -1, !dbg !1470
  store i32 %dec, i32* %quotientExponent, align 4, !dbg !1470
  br label %if.end115, !dbg !1471

if.else110:                                       ; preds = %if.end60
  %56 = load i32, i32* %quotient, align 4, !dbg !1472
  %shr111 = lshr i32 %56, 1, !dbg !1472
  store i32 %shr111, i32* %quotient, align 4, !dbg !1472
  %57 = load i32, i32* %aSignificand, align 4, !dbg !1473
  %shl112 = shl i32 %57, 23, !dbg !1474
  %58 = load i32, i32* %quotient, align 4, !dbg !1475
  %59 = load i32, i32* %bSignificand, align 4, !dbg !1476
  %mul113 = mul i32 %58, %59, !dbg !1477
  %sub114 = sub i32 %shl112, %mul113, !dbg !1478
  store i32 %sub114, i32* %residual, align 4, !dbg !1479
  br label %if.end115

if.end115:                                        ; preds = %if.else110, %if.then106
  %60 = load i32, i32* %quotientExponent, align 4, !dbg !1480
  %add116 = add nsw i32 %60, 127, !dbg !1481
  store i32 %add116, i32* %writtenExponent, align 4, !dbg !1482
  %61 = load i32, i32* %writtenExponent, align 4, !dbg !1483
  %cmp117 = icmp sge i32 %61, 255, !dbg !1484
  br i1 %cmp117, label %if.then119, label %if.else122, !dbg !1483

if.then119:                                       ; preds = %if.end115
  %62 = load i32, i32* %quotientSign, align 4, !dbg !1485
  %or120 = or i32 2139095040, %62, !dbg !1486
  %call121 = call arm_aapcs_vfpcc float @fromRep.13(i32 %or120) #4, !dbg !1487
  store float %call121, float* %retval, align 4, !dbg !1488
  br label %return, !dbg !1488

if.else122:                                       ; preds = %if.end115
  %63 = load i32, i32* %writtenExponent, align 4, !dbg !1489
  %cmp123 = icmp slt i32 %63, 1, !dbg !1490
  br i1 %cmp123, label %if.then125, label %if.else127, !dbg !1489

if.then125:                                       ; preds = %if.else122
  %64 = load i32, i32* %quotientSign, align 4, !dbg !1491
  %call126 = call arm_aapcs_vfpcc float @fromRep.13(i32 %64) #4, !dbg !1492
  store float %call126, float* %retval, align 4, !dbg !1493
  br label %return, !dbg !1493

if.else127:                                       ; preds = %if.else122
  %65 = load i32, i32* %residual, align 4, !dbg !1494
  %shl128 = shl i32 %65, 1, !dbg !1495
  %66 = load i32, i32* %bSignificand, align 4, !dbg !1496
  %cmp129 = icmp ugt i32 %shl128, %66, !dbg !1497
  %frombool = zext i1 %cmp129 to i8, !dbg !1498
  store i8 %frombool, i8* %round, align 1, !dbg !1498
  %67 = load i32, i32* %quotient, align 4, !dbg !1499
  %and131 = and i32 %67, 8388607, !dbg !1500
  store i32 %and131, i32* %absResult, align 4, !dbg !1501
  %68 = load i32, i32* %writtenExponent, align 4, !dbg !1502
  %shl132 = shl i32 %68, 23, !dbg !1503
  %69 = load i32, i32* %absResult, align 4, !dbg !1504
  %or133 = or i32 %69, %shl132, !dbg !1504
  store i32 %or133, i32* %absResult, align 4, !dbg !1504
  %70 = load i8, i8* %round, align 1, !dbg !1505
  %tobool134 = trunc i8 %70 to i1, !dbg !1505
  %conv135 = zext i1 %tobool134 to i32, !dbg !1505
  %71 = load i32, i32* %absResult, align 4, !dbg !1506
  %add136 = add i32 %71, %conv135, !dbg !1506
  store i32 %add136, i32* %absResult, align 4, !dbg !1506
  %72 = load i32, i32* %absResult, align 4, !dbg !1507
  %73 = load i32, i32* %quotientSign, align 4, !dbg !1508
  %or137 = or i32 %72, %73, !dbg !1509
  %call138 = call arm_aapcs_vfpcc float @fromRep.13(i32 %or137) #4, !dbg !1510
  store float %call138, float* %retval, align 4, !dbg !1511
  br label %return, !dbg !1511

return:                                           ; preds = %if.else127, %if.then125, %if.then119, %if.then47, %if.else43, %if.then41, %if.then36, %if.else, %if.then30, %if.then22, %if.then18
  %74 = load float, float* %retval, align 4, !dbg !1512
  ret float %74, !dbg !1512
}

; Function Attrs: noinline nounwind
define internal arm_aapcs_vfpcc i32 @toRep.12(float %x) #0 !dbg !1513 {
entry:
  %x.addr = alloca float, align 4
  %rep = alloca %union.anon.0.0, align 4
  store float %x, float* %x.addr, align 4
  %f = bitcast %union.anon.0.0* %rep to float*, !dbg !1514
  %0 = load float, float* %x.addr, align 4, !dbg !1515
  store float %0, float* %f, align 4, !dbg !1514
  %i = bitcast %union.anon.0.0* %rep to i32*, !dbg !1516
  %1 = load i32, i32* %i, align 4, !dbg !1516
  ret i32 %1, !dbg !1517
}

; Function Attrs: noinline nounwind
define internal arm_aapcs_vfpcc float @fromRep.13(i32 %x) #0 !dbg !1518 {
entry:
  %x.addr = alloca i32, align 4
  %rep = alloca %union.anon.0.0, align 4
  store i32 %x, i32* %x.addr, align 4
  %i = bitcast %union.anon.0.0* %rep to i32*, !dbg !1519
  %0 = load i32, i32* %x.addr, align 4, !dbg !1520
  store i32 %0, i32* %i, align 4, !dbg !1519
  %f = bitcast %union.anon.0.0* %rep to float*, !dbg !1521
  %1 = load float, float* %f, align 4, !dbg !1521
  ret float %1, !dbg !1522
}

; Function Attrs: noinline nounwind
define internal arm_aapcs_vfpcc i32 @normalize.14(i32* %significand) #0 !dbg !1523 {
entry:
  %significand.addr = alloca i32*, align 4
  %shift = alloca i32, align 4
  store i32* %significand, i32** %significand.addr, align 4
  %0 = load i32*, i32** %significand.addr, align 4, !dbg !1524
  %1 = load i32, i32* %0, align 4, !dbg !1525
  %call = call arm_aapcs_vfpcc i32 @rep_clz.15(i32 %1) #4, !dbg !1526
  %call1 = call arm_aapcs_vfpcc i32 @rep_clz.15(i32 8388608) #4, !dbg !1527
  %sub = sub nsw i32 %call, %call1, !dbg !1528
  store i32 %sub, i32* %shift, align 4, !dbg !1529
  %2 = load i32, i32* %shift, align 4, !dbg !1530
  %3 = load i32*, i32** %significand.addr, align 4, !dbg !1531
  %4 = load i32, i32* %3, align 4, !dbg !1532
  %shl = shl i32 %4, %2, !dbg !1532
  store i32 %shl, i32* %3, align 4, !dbg !1532
  %5 = load i32, i32* %shift, align 4, !dbg !1533
  %sub2 = sub nsw i32 1, %5, !dbg !1534
  ret i32 %sub2, !dbg !1535
}

; Function Attrs: noinline nounwind
define internal arm_aapcs_vfpcc i32 @rep_clz.15(i32 %a) #0 !dbg !1536 {
entry:
  %a.addr = alloca i32, align 4
  store i32 %a, i32* %a.addr, align 4
  %0 = load i32, i32* %a.addr, align 4, !dbg !1537
  %1 = call i32 @llvm.ctlz.i32(i32 %0, i1 false), !dbg !1538
  ret i32 %1, !dbg !1539
}

; Function Attrs: noinline nounwind
define dso_local arm_aapcscc float @__extendhfsf2(i16 zeroext %a) #0 !dbg !1540 {
entry:
  %a.addr = alloca i16, align 2
  store i16 %a, i16* %a.addr, align 2
  %0 = load i16, i16* %a.addr, align 2, !dbg !1541
  %call = call arm_aapcs_vfpcc float @__extendXfYf2__(i16 zeroext %0) #4, !dbg !1542
  ret float %call, !dbg !1543
}

; Function Attrs: noinline nounwind
define internal arm_aapcs_vfpcc float @__extendXfYf2__(i16 zeroext %a) #0 !dbg !1544 {
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
  store i32 16, i32* %srcBits, align 4, !dbg !1546
  store i32 5, i32* %srcExpBits, align 4, !dbg !1547
  store i32 31, i32* %srcInfExp, align 4, !dbg !1548
  store i32 15, i32* %srcExpBias, align 4, !dbg !1549
  store i16 1024, i16* %srcMinNormal, align 2, !dbg !1550
  store i16 31744, i16* %srcInfinity, align 2, !dbg !1551
  store i16 -32768, i16* %srcSignMask, align 2, !dbg !1552
  store i16 32767, i16* %srcAbsMask, align 2, !dbg !1553
  store i16 512, i16* %srcQNaN, align 2, !dbg !1554
  store i16 511, i16* %srcNaNCode, align 2, !dbg !1555
  store i32 32, i32* %dstBits, align 4, !dbg !1556
  store i32 8, i32* %dstExpBits, align 4, !dbg !1557
  store i32 255, i32* %dstInfExp, align 4, !dbg !1558
  store i32 127, i32* %dstExpBias, align 4, !dbg !1559
  store i32 8388608, i32* %dstMinNormal, align 4, !dbg !1560
  %0 = load i16, i16* %a.addr, align 2, !dbg !1561
  %call = call arm_aapcs_vfpcc zeroext i16 @srcToRep(i16 zeroext %0) #4, !dbg !1562
  store i16 %call, i16* %aRep, align 2, !dbg !1563
  %1 = load i16, i16* %aRep, align 2, !dbg !1564
  %conv = zext i16 %1 to i32, !dbg !1564
  %and = and i32 %conv, 32767, !dbg !1565
  %conv1 = trunc i32 %and to i16, !dbg !1564
  store i16 %conv1, i16* %aAbs, align 2, !dbg !1566
  %2 = load i16, i16* %aRep, align 2, !dbg !1567
  %conv2 = zext i16 %2 to i32, !dbg !1567
  %and3 = and i32 %conv2, 32768, !dbg !1568
  %conv4 = trunc i32 %and3 to i16, !dbg !1567
  store i16 %conv4, i16* %sign, align 2, !dbg !1569
  %3 = load i16, i16* %aAbs, align 2, !dbg !1570
  %conv5 = zext i16 %3 to i32, !dbg !1570
  %sub = sub nsw i32 %conv5, 1024, !dbg !1571
  %conv6 = trunc i32 %sub to i16, !dbg !1572
  %conv7 = zext i16 %conv6 to i32, !dbg !1572
  %cmp = icmp slt i32 %conv7, 30720, !dbg !1573
  br i1 %cmp, label %if.then, label %if.else, !dbg !1572

if.then:                                          ; preds = %entry
  %4 = load i16, i16* %aAbs, align 2, !dbg !1574
  %conv9 = zext i16 %4 to i32, !dbg !1575
  %shl = shl i32 %conv9, 13, !dbg !1576
  store i32 %shl, i32* %absResult, align 4, !dbg !1577
  %5 = load i32, i32* %absResult, align 4, !dbg !1578
  %add = add i32 %5, 939524096, !dbg !1578
  store i32 %add, i32* %absResult, align 4, !dbg !1578
  br label %if.end34, !dbg !1579

if.else:                                          ; preds = %entry
  %6 = load i16, i16* %aAbs, align 2, !dbg !1580
  %conv10 = zext i16 %6 to i32, !dbg !1580
  %cmp11 = icmp sge i32 %conv10, 31744, !dbg !1581
  br i1 %cmp11, label %if.then13, label %if.else21, !dbg !1580

if.then13:                                        ; preds = %if.else
  store i32 2139095040, i32* %absResult, align 4, !dbg !1582
  %7 = load i16, i16* %aAbs, align 2, !dbg !1583
  %conv14 = zext i16 %7 to i32, !dbg !1583
  %and15 = and i32 %conv14, 512, !dbg !1584
  %shl16 = shl i32 %and15, 13, !dbg !1585
  %8 = load i32, i32* %absResult, align 4, !dbg !1586
  %or = or i32 %8, %shl16, !dbg !1586
  store i32 %or, i32* %absResult, align 4, !dbg !1586
  %9 = load i16, i16* %aAbs, align 2, !dbg !1587
  %conv17 = zext i16 %9 to i32, !dbg !1587
  %and18 = and i32 %conv17, 511, !dbg !1588
  %shl19 = shl i32 %and18, 13, !dbg !1589
  %10 = load i32, i32* %absResult, align 4, !dbg !1590
  %or20 = or i32 %10, %shl19, !dbg !1590
  store i32 %or20, i32* %absResult, align 4, !dbg !1590
  br label %if.end33, !dbg !1591

if.else21:                                        ; preds = %if.else
  %11 = load i16, i16* %aAbs, align 2, !dbg !1592
  %tobool = icmp ne i16 %11, 0, !dbg !1592
  br i1 %tobool, label %if.then22, label %if.else32, !dbg !1592

if.then22:                                        ; preds = %if.else21
  %12 = load i16, i16* %aAbs, align 2, !dbg !1593
  %conv23 = zext i16 %12 to i32, !dbg !1593
  %13 = call i32 @llvm.ctlz.i32(i32 %conv23, i1 false), !dbg !1594
  %sub24 = sub nsw i32 %13, 21, !dbg !1595
  store i32 %sub24, i32* %scale, align 4, !dbg !1596
  %14 = load i16, i16* %aAbs, align 2, !dbg !1597
  %conv25 = zext i16 %14 to i32, !dbg !1598
  %15 = load i32, i32* %scale, align 4, !dbg !1599
  %add26 = add nsw i32 13, %15, !dbg !1600
  %shl27 = shl i32 %conv25, %add26, !dbg !1601
  store i32 %shl27, i32* %absResult, align 4, !dbg !1602
  %16 = load i32, i32* %absResult, align 4, !dbg !1603
  %xor = xor i32 %16, 8388608, !dbg !1603
  store i32 %xor, i32* %absResult, align 4, !dbg !1603
  %17 = load i32, i32* %scale, align 4, !dbg !1604
  %sub28 = sub nsw i32 112, %17, !dbg !1605
  %add29 = add nsw i32 %sub28, 1, !dbg !1606
  store i32 %add29, i32* %resultExponent, align 4, !dbg !1607
  %18 = load i32, i32* %resultExponent, align 4, !dbg !1608
  %shl30 = shl i32 %18, 23, !dbg !1609
  %19 = load i32, i32* %absResult, align 4, !dbg !1610
  %or31 = or i32 %19, %shl30, !dbg !1610
  store i32 %or31, i32* %absResult, align 4, !dbg !1610
  br label %if.end, !dbg !1611

if.else32:                                        ; preds = %if.else21
  store i32 0, i32* %absResult, align 4, !dbg !1612
  br label %if.end

if.end:                                           ; preds = %if.else32, %if.then22
  br label %if.end33

if.end33:                                         ; preds = %if.end, %if.then13
  br label %if.end34

if.end34:                                         ; preds = %if.end33, %if.then
  %20 = load i32, i32* %absResult, align 4, !dbg !1613
  %21 = load i16, i16* %sign, align 2, !dbg !1614
  %conv35 = zext i16 %21 to i32, !dbg !1615
  %shl36 = shl i32 %conv35, 16, !dbg !1616
  %or37 = or i32 %20, %shl36, !dbg !1617
  store i32 %or37, i32* %result, align 4, !dbg !1618
  %22 = load i32, i32* %result, align 4, !dbg !1619
  %call38 = call arm_aapcs_vfpcc float @dstFromRep(i32 %22) #4, !dbg !1620
  ret float %call38, !dbg !1621
}

; Function Attrs: noinline nounwind
define internal arm_aapcs_vfpcc zeroext i16 @srcToRep(i16 zeroext %x) #0 !dbg !1622 {
entry:
  %x.addr = alloca i16, align 2
  %rep = alloca %union.anon, align 2
  store i16 %x, i16* %x.addr, align 2
  %f = bitcast %union.anon* %rep to i16*, !dbg !1624
  %0 = load i16, i16* %x.addr, align 2, !dbg !1625
  store i16 %0, i16* %f, align 2, !dbg !1624
  %i = bitcast %union.anon* %rep to i16*, !dbg !1626
  %1 = load i16, i16* %i, align 2, !dbg !1626
  ret i16 %1, !dbg !1627
}

; Function Attrs: noinline nounwind
define internal arm_aapcs_vfpcc float @dstFromRep(i32 %x) #0 !dbg !1628 {
entry:
  %x.addr = alloca i32, align 4
  %rep = alloca %union.anon.0.0, align 4
  store i32 %x, i32* %x.addr, align 4
  %i = bitcast %union.anon.0.0* %rep to i32*, !dbg !1629
  %0 = load i32, i32* %x.addr, align 4, !dbg !1630
  store i32 %0, i32* %i, align 4, !dbg !1629
  %f = bitcast %union.anon.0.0* %rep to float*, !dbg !1631
  %1 = load float, float* %f, align 4, !dbg !1631
  ret float %1, !dbg !1632
}

; Function Attrs: noinline nounwind
define dso_local arm_aapcscc float @__gnu_h2f_ieee(i16 zeroext %a) #0 !dbg !1633 {
entry:
  %a.addr = alloca i16, align 2
  store i16 %a, i16* %a.addr, align 2
  %0 = load i16, i16* %a.addr, align 2, !dbg !1634
  %call = call arm_aapcscc float @__extendhfsf2(i16 zeroext %0) #4, !dbg !1635
  ret float %call, !dbg !1636
}

; Function Attrs: noinline nounwind
define dso_local arm_aapcscc double @__extendsfdf2(float %a) #0 !dbg !1637 {
entry:
  %a.addr = alloca float, align 4
  store float %a, float* %a.addr, align 4
  %0 = load float, float* %a.addr, align 4, !dbg !1638
  %call = call arm_aapcs_vfpcc double @__extendXfYf2__.16(float %0) #4, !dbg !1639
  ret double %call, !dbg !1640
}

; Function Attrs: noinline nounwind
define internal arm_aapcs_vfpcc double @__extendXfYf2__.16(float %a) #0 !dbg !1641 {
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
  store i32 32, i32* %srcBits, align 4, !dbg !1642
  store i32 8, i32* %srcExpBits, align 4, !dbg !1643
  store i32 255, i32* %srcInfExp, align 4, !dbg !1644
  store i32 127, i32* %srcExpBias, align 4, !dbg !1645
  store i32 8388608, i32* %srcMinNormal, align 4, !dbg !1646
  store i32 2139095040, i32* %srcInfinity, align 4, !dbg !1647
  store i32 -2147483648, i32* %srcSignMask, align 4, !dbg !1648
  store i32 2147483647, i32* %srcAbsMask, align 4, !dbg !1649
  store i32 4194304, i32* %srcQNaN, align 4, !dbg !1650
  store i32 4194303, i32* %srcNaNCode, align 4, !dbg !1651
  store i32 64, i32* %dstBits, align 4, !dbg !1652
  store i32 11, i32* %dstExpBits, align 4, !dbg !1653
  store i32 2047, i32* %dstInfExp, align 4, !dbg !1654
  store i32 1023, i32* %dstExpBias, align 4, !dbg !1655
  store i64 4503599627370496, i64* %dstMinNormal, align 8, !dbg !1656
  %0 = load float, float* %a.addr, align 4, !dbg !1657
  %call = call arm_aapcs_vfpcc i32 @srcToRep.17(float %0) #4, !dbg !1658
  store i32 %call, i32* %aRep, align 4, !dbg !1659
  %1 = load i32, i32* %aRep, align 4, !dbg !1660
  %and = and i32 %1, 2147483647, !dbg !1661
  store i32 %and, i32* %aAbs, align 4, !dbg !1662
  %2 = load i32, i32* %aRep, align 4, !dbg !1663
  %and1 = and i32 %2, -2147483648, !dbg !1664
  store i32 %and1, i32* %sign, align 4, !dbg !1665
  %3 = load i32, i32* %aAbs, align 4, !dbg !1666
  %sub = sub i32 %3, 8388608, !dbg !1667
  %cmp = icmp ult i32 %sub, 2130706432, !dbg !1668
  br i1 %cmp, label %if.then, label %if.else, !dbg !1669

if.then:                                          ; preds = %entry
  %4 = load i32, i32* %aAbs, align 4, !dbg !1670
  %conv = zext i32 %4 to i64, !dbg !1671
  %shl = shl i64 %conv, 29, !dbg !1672
  store i64 %shl, i64* %absResult, align 8, !dbg !1673
  %5 = load i64, i64* %absResult, align 8, !dbg !1674
  %add = add i64 %5, 4035225266123964416, !dbg !1674
  store i64 %add, i64* %absResult, align 8, !dbg !1674
  br label %if.end25, !dbg !1675

if.else:                                          ; preds = %entry
  %6 = load i32, i32* %aAbs, align 4, !dbg !1676
  %cmp2 = icmp uge i32 %6, 2139095040, !dbg !1677
  br i1 %cmp2, label %if.then4, label %if.else12, !dbg !1676

if.then4:                                         ; preds = %if.else
  store i64 9218868437227405312, i64* %absResult, align 8, !dbg !1678
  %7 = load i32, i32* %aAbs, align 4, !dbg !1679
  %and5 = and i32 %7, 4194304, !dbg !1680
  %conv6 = zext i32 %and5 to i64, !dbg !1681
  %shl7 = shl i64 %conv6, 29, !dbg !1682
  %8 = load i64, i64* %absResult, align 8, !dbg !1683
  %or = or i64 %8, %shl7, !dbg !1683
  store i64 %or, i64* %absResult, align 8, !dbg !1683
  %9 = load i32, i32* %aAbs, align 4, !dbg !1684
  %and8 = and i32 %9, 4194303, !dbg !1685
  %conv9 = zext i32 %and8 to i64, !dbg !1686
  %shl10 = shl i64 %conv9, 29, !dbg !1687
  %10 = load i64, i64* %absResult, align 8, !dbg !1688
  %or11 = or i64 %10, %shl10, !dbg !1688
  store i64 %or11, i64* %absResult, align 8, !dbg !1688
  br label %if.end24, !dbg !1689

if.else12:                                        ; preds = %if.else
  %11 = load i32, i32* %aAbs, align 4, !dbg !1690
  %tobool = icmp ne i32 %11, 0, !dbg !1690
  br i1 %tobool, label %if.then13, label %if.else23, !dbg !1690

if.then13:                                        ; preds = %if.else12
  %12 = load i32, i32* %aAbs, align 4, !dbg !1691
  %13 = call i32 @llvm.ctlz.i32(i32 %12, i1 false), !dbg !1692
  %sub14 = sub nsw i32 %13, 8, !dbg !1693
  store i32 %sub14, i32* %scale, align 4, !dbg !1694
  %14 = load i32, i32* %aAbs, align 4, !dbg !1695
  %conv15 = zext i32 %14 to i64, !dbg !1696
  %15 = load i32, i32* %scale, align 4, !dbg !1697
  %add16 = add nsw i32 29, %15, !dbg !1698
  %sh_prom = zext i32 %add16 to i64, !dbg !1699
  %shl17 = shl i64 %conv15, %sh_prom, !dbg !1699
  store i64 %shl17, i64* %absResult, align 8, !dbg !1700
  %16 = load i64, i64* %absResult, align 8, !dbg !1701
  %xor = xor i64 %16, 4503599627370496, !dbg !1701
  store i64 %xor, i64* %absResult, align 8, !dbg !1701
  %17 = load i32, i32* %scale, align 4, !dbg !1702
  %sub18 = sub nsw i32 896, %17, !dbg !1703
  %add19 = add nsw i32 %sub18, 1, !dbg !1704
  store i32 %add19, i32* %resultExponent, align 4, !dbg !1705
  %18 = load i32, i32* %resultExponent, align 4, !dbg !1706
  %conv20 = sext i32 %18 to i64, !dbg !1707
  %shl21 = shl i64 %conv20, 52, !dbg !1708
  %19 = load i64, i64* %absResult, align 8, !dbg !1709
  %or22 = or i64 %19, %shl21, !dbg !1709
  store i64 %or22, i64* %absResult, align 8, !dbg !1709
  br label %if.end, !dbg !1710

if.else23:                                        ; preds = %if.else12
  store i64 0, i64* %absResult, align 8, !dbg !1711
  br label %if.end

if.end:                                           ; preds = %if.else23, %if.then13
  br label %if.end24

if.end24:                                         ; preds = %if.end, %if.then4
  br label %if.end25

if.end25:                                         ; preds = %if.end24, %if.then
  %20 = load i64, i64* %absResult, align 8, !dbg !1712
  %21 = load i32, i32* %sign, align 4, !dbg !1713
  %conv26 = zext i32 %21 to i64, !dbg !1714
  %shl27 = shl i64 %conv26, 32, !dbg !1715
  %or28 = or i64 %20, %shl27, !dbg !1716
  store i64 %or28, i64* %result, align 8, !dbg !1717
  %22 = load i64, i64* %result, align 8, !dbg !1718
  %call29 = call arm_aapcs_vfpcc double @dstFromRep.18(i64 %22) #4, !dbg !1719
  ret double %call29, !dbg !1720
}

; Function Attrs: noinline nounwind
define internal arm_aapcs_vfpcc i32 @srcToRep.17(float %x) #0 !dbg !1721 {
entry:
  %x.addr = alloca float, align 4
  %rep = alloca %union.anon.0.0, align 4
  store float %x, float* %x.addr, align 4
  %f = bitcast %union.anon.0.0* %rep to float*, !dbg !1722
  %0 = load float, float* %x.addr, align 4, !dbg !1723
  store float %0, float* %f, align 4, !dbg !1722
  %i = bitcast %union.anon.0.0* %rep to i32*, !dbg !1724
  %1 = load i32, i32* %i, align 4, !dbg !1724
  ret i32 %1, !dbg !1725
}

; Function Attrs: noinline nounwind
define internal arm_aapcs_vfpcc double @dstFromRep.18(i64 %x) #0 !dbg !1726 {
entry:
  %x.addr = alloca i64, align 8
  %rep = alloca %union.anon.0, align 8
  store i64 %x, i64* %x.addr, align 8
  %i = bitcast %union.anon.0* %rep to i64*, !dbg !1727
  %0 = load i64, i64* %x.addr, align 8, !dbg !1728
  store i64 %0, i64* %i, align 8, !dbg !1727
  %f = bitcast %union.anon.0* %rep to double*, !dbg !1729
  %1 = load double, double* %f, align 8, !dbg !1729
  ret double %1, !dbg !1730
}

; Function Attrs: noinline nounwind
define dso_local arm_aapcscc i64 @__fixdfdi(double %a) #0 !dbg !1731 {
entry:
  %retval = alloca i64, align 8
  %a.addr = alloca double, align 8
  store double %a, double* %a.addr, align 8
  %0 = load double, double* %a.addr, align 8, !dbg !1732
  %cmp = fcmp olt double %0, 0.000000e+00, !dbg !1733
  br i1 %cmp, label %if.then, label %if.end, !dbg !1732

if.then:                                          ; preds = %entry
  %1 = load double, double* %a.addr, align 8, !dbg !1734
  %sub = fsub double -0.000000e+00, %1, !dbg !1735
  %call = call arm_aapcscc i64 @__fixunsdfdi(double %sub) #4, !dbg !1736
  %sub1 = sub i64 0, %call, !dbg !1737
  store i64 %sub1, i64* %retval, align 8, !dbg !1738
  br label %return, !dbg !1738

if.end:                                           ; preds = %entry
  %2 = load double, double* %a.addr, align 8, !dbg !1739
  %call2 = call arm_aapcscc i64 @__fixunsdfdi(double %2) #4, !dbg !1740
  store i64 %call2, i64* %retval, align 8, !dbg !1741
  br label %return, !dbg !1741

return:                                           ; preds = %if.end, %if.then
  %3 = load i64, i64* %retval, align 8, !dbg !1742
  ret i64 %3, !dbg !1742
}

; Function Attrs: noinline nounwind
define dso_local arm_aapcscc i32 @__fixdfsi(double %a) #0 !dbg !1743 {
entry:
  %a.addr = alloca double, align 8
  store double %a, double* %a.addr, align 8
  %0 = load double, double* %a.addr, align 8, !dbg !1744
  %call = call arm_aapcs_vfpcc i32 @__fixint(double %0) #4, !dbg !1745
  ret i32 %call, !dbg !1746
}

; Function Attrs: noinline nounwind
define internal arm_aapcs_vfpcc i32 @__fixint(double %a) #0 !dbg !1747 {
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
  store i32 2147483647, i32* %fixint_max, align 4, !dbg !1749
  store i32 -2147483648, i32* %fixint_min, align 4, !dbg !1750
  %0 = load double, double* %a.addr, align 8, !dbg !1751
  %call = call arm_aapcs_vfpcc i64 @toRep.19(double %0) #4, !dbg !1752
  store i64 %call, i64* %aRep, align 8, !dbg !1753
  %1 = load i64, i64* %aRep, align 8, !dbg !1754
  %and = and i64 %1, 9223372036854775807, !dbg !1755
  store i64 %and, i64* %aAbs, align 8, !dbg !1756
  %2 = load i64, i64* %aRep, align 8, !dbg !1757
  %and1 = and i64 %2, -9223372036854775808, !dbg !1758
  %tobool = icmp ne i64 %and1, 0, !dbg !1757
  %3 = zext i1 %tobool to i64, !dbg !1757
  %cond = select i1 %tobool, i32 -1, i32 1, !dbg !1757
  store i32 %cond, i32* %sign, align 4, !dbg !1759
  %4 = load i64, i64* %aAbs, align 8, !dbg !1760
  %shr = lshr i64 %4, 52, !dbg !1761
  %sub = sub i64 %shr, 1023, !dbg !1762
  %conv = trunc i64 %sub to i32, !dbg !1763
  store i32 %conv, i32* %exponent, align 4, !dbg !1764
  %5 = load i64, i64* %aAbs, align 8, !dbg !1765
  %and2 = and i64 %5, 4503599627370495, !dbg !1766
  %or = or i64 %and2, 4503599627370496, !dbg !1767
  store i64 %or, i64* %significand, align 8, !dbg !1768
  %6 = load i32, i32* %exponent, align 4, !dbg !1769
  %cmp = icmp slt i32 %6, 0, !dbg !1770
  br i1 %cmp, label %if.then, label %if.end, !dbg !1769

if.then:                                          ; preds = %entry
  store i32 0, i32* %retval, align 4, !dbg !1771
  br label %return, !dbg !1771

if.end:                                           ; preds = %entry
  %7 = load i32, i32* %exponent, align 4, !dbg !1772
  %cmp4 = icmp uge i32 %7, 32, !dbg !1773
  br i1 %cmp4, label %if.then6, label %if.end10, !dbg !1774

if.then6:                                         ; preds = %if.end
  %8 = load i32, i32* %sign, align 4, !dbg !1775
  %cmp7 = icmp eq i32 %8, 1, !dbg !1776
  %9 = zext i1 %cmp7 to i64, !dbg !1775
  %cond9 = select i1 %cmp7, i32 2147483647, i32 -2147483648, !dbg !1775
  store i32 %cond9, i32* %retval, align 4, !dbg !1777
  br label %return, !dbg !1777

if.end10:                                         ; preds = %if.end
  %10 = load i32, i32* %exponent, align 4, !dbg !1778
  %cmp11 = icmp slt i32 %10, 52, !dbg !1779
  br i1 %cmp11, label %if.then13, label %if.else, !dbg !1778

if.then13:                                        ; preds = %if.end10
  %11 = load i32, i32* %sign, align 4, !dbg !1780
  %conv14 = sext i32 %11 to i64, !dbg !1780
  %12 = load i64, i64* %significand, align 8, !dbg !1781
  %13 = load i32, i32* %exponent, align 4, !dbg !1782
  %sub15 = sub nsw i32 52, %13, !dbg !1783
  %sh_prom = zext i32 %sub15 to i64, !dbg !1784
  %shr16 = lshr i64 %12, %sh_prom, !dbg !1784
  %mul = mul i64 %conv14, %shr16, !dbg !1785
  %conv17 = trunc i64 %mul to i32, !dbg !1780
  store i32 %conv17, i32* %retval, align 4, !dbg !1786
  br label %return, !dbg !1786

if.else:                                          ; preds = %if.end10
  %14 = load i32, i32* %sign, align 4, !dbg !1787
  %15 = load i64, i64* %significand, align 8, !dbg !1788
  %conv18 = trunc i64 %15 to i32, !dbg !1789
  %16 = load i32, i32* %exponent, align 4, !dbg !1790
  %sub19 = sub nsw i32 %16, 52, !dbg !1791
  %shl = shl i32 %conv18, %sub19, !dbg !1792
  %mul20 = mul nsw i32 %14, %shl, !dbg !1793
  store i32 %mul20, i32* %retval, align 4, !dbg !1794
  br label %return, !dbg !1794

return:                                           ; preds = %if.else, %if.then13, %if.then6, %if.then
  %17 = load i32, i32* %retval, align 4, !dbg !1795
  ret i32 %17, !dbg !1795
}

; Function Attrs: noinline nounwind
define internal arm_aapcs_vfpcc i64 @toRep.19(double %x) #0 !dbg !1796 {
entry:
  %x.addr = alloca double, align 8
  %rep = alloca %union.anon.0, align 8
  store double %x, double* %x.addr, align 8
  %f = bitcast %union.anon.0* %rep to double*, !dbg !1797
  %0 = load double, double* %x.addr, align 8, !dbg !1798
  store double %0, double* %f, align 8, !dbg !1797
  %i = bitcast %union.anon.0* %rep to i64*, !dbg !1799
  %1 = load i64, i64* %i, align 8, !dbg !1799
  ret i64 %1, !dbg !1800
}

; Function Attrs: noinline nounwind
define dso_local arm_aapcscc i64 @__fixsfdi(float %a) #0 !dbg !1801 {
entry:
  %retval = alloca i64, align 8
  %a.addr = alloca float, align 4
  store float %a, float* %a.addr, align 4
  %0 = load float, float* %a.addr, align 4, !dbg !1802
  %cmp = fcmp olt float %0, 0.000000e+00, !dbg !1803
  br i1 %cmp, label %if.then, label %if.end, !dbg !1802

if.then:                                          ; preds = %entry
  %1 = load float, float* %a.addr, align 4, !dbg !1804
  %sub = fsub float -0.000000e+00, %1, !dbg !1805
  %call = call arm_aapcscc i64 @__fixunssfdi(float %sub) #4, !dbg !1806
  %sub1 = sub i64 0, %call, !dbg !1807
  store i64 %sub1, i64* %retval, align 8, !dbg !1808
  br label %return, !dbg !1808

if.end:                                           ; preds = %entry
  %2 = load float, float* %a.addr, align 4, !dbg !1809
  %call2 = call arm_aapcscc i64 @__fixunssfdi(float %2) #4, !dbg !1810
  store i64 %call2, i64* %retval, align 8, !dbg !1811
  br label %return, !dbg !1811

return:                                           ; preds = %if.end, %if.then
  %3 = load i64, i64* %retval, align 8, !dbg !1812
  ret i64 %3, !dbg !1812
}

; Function Attrs: noinline nounwind
define dso_local arm_aapcscc i32 @__fixsfsi(float %a) #0 !dbg !1813 {
entry:
  %a.addr = alloca float, align 4
  store float %a, float* %a.addr, align 4
  %0 = load float, float* %a.addr, align 4, !dbg !1814
  %call = call arm_aapcs_vfpcc i32 @__fixint.20(float %0) #4, !dbg !1815
  ret i32 %call, !dbg !1816
}

; Function Attrs: noinline nounwind
define internal arm_aapcs_vfpcc i32 @__fixint.20(float %a) #0 !dbg !1817 {
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
  store i32 2147483647, i32* %fixint_max, align 4, !dbg !1818
  store i32 -2147483648, i32* %fixint_min, align 4, !dbg !1819
  %0 = load float, float* %a.addr, align 4, !dbg !1820
  %call = call arm_aapcs_vfpcc i32 @toRep.21(float %0) #4, !dbg !1821
  store i32 %call, i32* %aRep, align 4, !dbg !1822
  %1 = load i32, i32* %aRep, align 4, !dbg !1823
  %and = and i32 %1, 2147483647, !dbg !1824
  store i32 %and, i32* %aAbs, align 4, !dbg !1825
  %2 = load i32, i32* %aRep, align 4, !dbg !1826
  %and1 = and i32 %2, -2147483648, !dbg !1827
  %tobool = icmp ne i32 %and1, 0, !dbg !1826
  %3 = zext i1 %tobool to i64, !dbg !1826
  %cond = select i1 %tobool, i32 -1, i32 1, !dbg !1826
  store i32 %cond, i32* %sign, align 4, !dbg !1828
  %4 = load i32, i32* %aAbs, align 4, !dbg !1829
  %shr = lshr i32 %4, 23, !dbg !1830
  %sub = sub i32 %shr, 127, !dbg !1831
  store i32 %sub, i32* %exponent, align 4, !dbg !1832
  %5 = load i32, i32* %aAbs, align 4, !dbg !1833
  %and2 = and i32 %5, 8388607, !dbg !1834
  %or = or i32 %and2, 8388608, !dbg !1835
  store i32 %or, i32* %significand, align 4, !dbg !1836
  %6 = load i32, i32* %exponent, align 4, !dbg !1837
  %cmp = icmp slt i32 %6, 0, !dbg !1838
  br i1 %cmp, label %if.then, label %if.end, !dbg !1837

if.then:                                          ; preds = %entry
  store i32 0, i32* %retval, align 4, !dbg !1839
  br label %return, !dbg !1839

if.end:                                           ; preds = %entry
  %7 = load i32, i32* %exponent, align 4, !dbg !1840
  %cmp3 = icmp uge i32 %7, 32, !dbg !1841
  br i1 %cmp3, label %if.then4, label %if.end7, !dbg !1842

if.then4:                                         ; preds = %if.end
  %8 = load i32, i32* %sign, align 4, !dbg !1843
  %cmp5 = icmp eq i32 %8, 1, !dbg !1844
  %9 = zext i1 %cmp5 to i64, !dbg !1843
  %cond6 = select i1 %cmp5, i32 2147483647, i32 -2147483648, !dbg !1843
  store i32 %cond6, i32* %retval, align 4, !dbg !1845
  br label %return, !dbg !1845

if.end7:                                          ; preds = %if.end
  %10 = load i32, i32* %exponent, align 4, !dbg !1846
  %cmp8 = icmp slt i32 %10, 23, !dbg !1847
  br i1 %cmp8, label %if.then9, label %if.else, !dbg !1846

if.then9:                                         ; preds = %if.end7
  %11 = load i32, i32* %sign, align 4, !dbg !1848
  %12 = load i32, i32* %significand, align 4, !dbg !1849
  %13 = load i32, i32* %exponent, align 4, !dbg !1850
  %sub10 = sub nsw i32 23, %13, !dbg !1851
  %shr11 = lshr i32 %12, %sub10, !dbg !1852
  %mul = mul i32 %11, %shr11, !dbg !1853
  store i32 %mul, i32* %retval, align 4, !dbg !1854
  br label %return, !dbg !1854

if.else:                                          ; preds = %if.end7
  %14 = load i32, i32* %sign, align 4, !dbg !1855
  %15 = load i32, i32* %significand, align 4, !dbg !1856
  %16 = load i32, i32* %exponent, align 4, !dbg !1857
  %sub12 = sub nsw i32 %16, 23, !dbg !1858
  %shl = shl i32 %15, %sub12, !dbg !1859
  %mul13 = mul nsw i32 %14, %shl, !dbg !1860
  store i32 %mul13, i32* %retval, align 4, !dbg !1861
  br label %return, !dbg !1861

return:                                           ; preds = %if.else, %if.then9, %if.then4, %if.then
  %17 = load i32, i32* %retval, align 4, !dbg !1862
  ret i32 %17, !dbg !1862
}

; Function Attrs: noinline nounwind
define internal arm_aapcs_vfpcc i32 @toRep.21(float %x) #0 !dbg !1863 {
entry:
  %x.addr = alloca float, align 4
  %rep = alloca %union.anon.0.0, align 4
  store float %x, float* %x.addr, align 4
  %f = bitcast %union.anon.0.0* %rep to float*, !dbg !1864
  %0 = load float, float* %x.addr, align 4, !dbg !1865
  store float %0, float* %f, align 4, !dbg !1864
  %i = bitcast %union.anon.0.0* %rep to i32*, !dbg !1866
  %1 = load i32, i32* %i, align 4, !dbg !1866
  ret i32 %1, !dbg !1867
}

; Function Attrs: noinline nounwind
define dso_local arm_aapcscc i64 @__fixunsdfdi(double %a) #0 !dbg !1868 {
entry:
  %retval = alloca i64, align 8
  %a.addr = alloca double, align 8
  %high = alloca i32, align 4
  %low = alloca i32, align 4
  store double %a, double* %a.addr, align 8
  %0 = load double, double* %a.addr, align 8, !dbg !1869
  %cmp = fcmp ole double %0, 0.000000e+00, !dbg !1870
  br i1 %cmp, label %if.then, label %if.end, !dbg !1869

if.then:                                          ; preds = %entry
  store i64 0, i64* %retval, align 8, !dbg !1871
  br label %return, !dbg !1871

if.end:                                           ; preds = %entry
  %1 = load double, double* %a.addr, align 8, !dbg !1872
  %div = fdiv double %1, 0x41F0000000000000, !dbg !1873
  %conv = fptoui double %div to i32, !dbg !1872
  store i32 %conv, i32* %high, align 4, !dbg !1874
  %2 = load double, double* %a.addr, align 8, !dbg !1875
  %3 = load i32, i32* %high, align 4, !dbg !1876
  %conv1 = uitofp i32 %3 to double, !dbg !1877
  %mul = fmul double %conv1, 0x41F0000000000000, !dbg !1878
  %sub = fsub double %2, %mul, !dbg !1879
  %conv2 = fptoui double %sub to i32, !dbg !1875
  store i32 %conv2, i32* %low, align 4, !dbg !1880
  %4 = load i32, i32* %high, align 4, !dbg !1881
  %conv3 = zext i32 %4 to i64, !dbg !1882
  %shl = shl i64 %conv3, 32, !dbg !1883
  %5 = load i32, i32* %low, align 4, !dbg !1884
  %conv4 = zext i32 %5 to i64, !dbg !1884
  %or = or i64 %shl, %conv4, !dbg !1885
  store i64 %or, i64* %retval, align 8, !dbg !1886
  br label %return, !dbg !1886

return:                                           ; preds = %if.end, %if.then
  %6 = load i64, i64* %retval, align 8, !dbg !1887
  ret i64 %6, !dbg !1887
}

; Function Attrs: noinline nounwind
define dso_local arm_aapcscc i32 @__fixunsdfsi(double %a) #0 !dbg !1888 {
entry:
  %a.addr = alloca double, align 8
  store double %a, double* %a.addr, align 8
  %0 = load double, double* %a.addr, align 8, !dbg !1889
  %call = call arm_aapcs_vfpcc i32 @__fixuint(double %0) #4, !dbg !1890
  ret i32 %call, !dbg !1891
}

; Function Attrs: noinline nounwind
define internal arm_aapcs_vfpcc i32 @__fixuint(double %a) #0 !dbg !1892 {
entry:
  %retval = alloca i32, align 4
  %a.addr = alloca double, align 8
  %aRep = alloca i64, align 8
  %aAbs = alloca i64, align 8
  %sign = alloca i32, align 4
  %exponent = alloca i32, align 4
  %significand = alloca i64, align 8
  store double %a, double* %a.addr, align 8
  %0 = load double, double* %a.addr, align 8, !dbg !1894
  %call = call arm_aapcs_vfpcc i64 @toRep.24(double %0) #4, !dbg !1895
  store i64 %call, i64* %aRep, align 8, !dbg !1896
  %1 = load i64, i64* %aRep, align 8, !dbg !1897
  %and = and i64 %1, 9223372036854775807, !dbg !1898
  store i64 %and, i64* %aAbs, align 8, !dbg !1899
  %2 = load i64, i64* %aRep, align 8, !dbg !1900
  %and1 = and i64 %2, -9223372036854775808, !dbg !1901
  %tobool = icmp ne i64 %and1, 0, !dbg !1900
  %3 = zext i1 %tobool to i64, !dbg !1900
  %cond = select i1 %tobool, i32 -1, i32 1, !dbg !1900
  store i32 %cond, i32* %sign, align 4, !dbg !1902
  %4 = load i64, i64* %aAbs, align 8, !dbg !1903
  %shr = lshr i64 %4, 52, !dbg !1904
  %sub = sub i64 %shr, 1023, !dbg !1905
  %conv = trunc i64 %sub to i32, !dbg !1906
  store i32 %conv, i32* %exponent, align 4, !dbg !1907
  %5 = load i64, i64* %aAbs, align 8, !dbg !1908
  %and2 = and i64 %5, 4503599627370495, !dbg !1909
  %or = or i64 %and2, 4503599627370496, !dbg !1910
  store i64 %or, i64* %significand, align 8, !dbg !1911
  %6 = load i32, i32* %sign, align 4, !dbg !1912
  %cmp = icmp eq i32 %6, -1, !dbg !1913
  br i1 %cmp, label %if.then, label %lor.lhs.false, !dbg !1914

lor.lhs.false:                                    ; preds = %entry
  %7 = load i32, i32* %exponent, align 4, !dbg !1915
  %cmp4 = icmp slt i32 %7, 0, !dbg !1916
  br i1 %cmp4, label %if.then, label %if.end, !dbg !1912

if.then:                                          ; preds = %lor.lhs.false, %entry
  store i32 0, i32* %retval, align 4, !dbg !1917
  br label %return, !dbg !1917

if.end:                                           ; preds = %lor.lhs.false
  %8 = load i32, i32* %exponent, align 4, !dbg !1918
  %cmp6 = icmp uge i32 %8, 32, !dbg !1919
  br i1 %cmp6, label %if.then8, label %if.end9, !dbg !1920

if.then8:                                         ; preds = %if.end
  store i32 -1, i32* %retval, align 4, !dbg !1921
  br label %return, !dbg !1921

if.end9:                                          ; preds = %if.end
  %9 = load i32, i32* %exponent, align 4, !dbg !1922
  %cmp10 = icmp slt i32 %9, 52, !dbg !1923
  br i1 %cmp10, label %if.then12, label %if.else, !dbg !1922

if.then12:                                        ; preds = %if.end9
  %10 = load i64, i64* %significand, align 8, !dbg !1924
  %11 = load i32, i32* %exponent, align 4, !dbg !1925
  %sub13 = sub nsw i32 52, %11, !dbg !1926
  %sh_prom = zext i32 %sub13 to i64, !dbg !1927
  %shr14 = lshr i64 %10, %sh_prom, !dbg !1927
  %conv15 = trunc i64 %shr14 to i32, !dbg !1924
  store i32 %conv15, i32* %retval, align 4, !dbg !1928
  br label %return, !dbg !1928

if.else:                                          ; preds = %if.end9
  %12 = load i64, i64* %significand, align 8, !dbg !1929
  %conv16 = trunc i64 %12 to i32, !dbg !1930
  %13 = load i32, i32* %exponent, align 4, !dbg !1931
  %sub17 = sub nsw i32 %13, 52, !dbg !1932
  %shl = shl i32 %conv16, %sub17, !dbg !1933
  store i32 %shl, i32* %retval, align 4, !dbg !1934
  br label %return, !dbg !1934

return:                                           ; preds = %if.else, %if.then12, %if.then8, %if.then
  %14 = load i32, i32* %retval, align 4, !dbg !1935
  ret i32 %14, !dbg !1935
}

; Function Attrs: noinline nounwind
define internal arm_aapcs_vfpcc i64 @toRep.24(double %x) #0 !dbg !1936 {
entry:
  %x.addr = alloca double, align 8
  %rep = alloca %union.anon.0, align 8
  store double %x, double* %x.addr, align 8
  %f = bitcast %union.anon.0* %rep to double*, !dbg !1937
  %0 = load double, double* %x.addr, align 8, !dbg !1938
  store double %0, double* %f, align 8, !dbg !1937
  %i = bitcast %union.anon.0* %rep to i64*, !dbg !1939
  %1 = load i64, i64* %i, align 8, !dbg !1939
  ret i64 %1, !dbg !1940
}

; Function Attrs: noinline nounwind
define dso_local arm_aapcscc i64 @__fixunssfdi(float %a) #0 !dbg !1941 {
entry:
  %retval = alloca i64, align 8
  %a.addr = alloca float, align 4
  %da = alloca double, align 8
  %high = alloca i32, align 4
  %low = alloca i32, align 4
  store float %a, float* %a.addr, align 4
  %0 = load float, float* %a.addr, align 4, !dbg !1942
  %cmp = fcmp ole float %0, 0.000000e+00, !dbg !1943
  br i1 %cmp, label %if.then, label %if.end, !dbg !1942

if.then:                                          ; preds = %entry
  store i64 0, i64* %retval, align 8, !dbg !1944
  br label %return, !dbg !1944

if.end:                                           ; preds = %entry
  %1 = load float, float* %a.addr, align 4, !dbg !1945
  %conv = fpext float %1 to double, !dbg !1945
  store double %conv, double* %da, align 8, !dbg !1946
  %2 = load double, double* %da, align 8, !dbg !1947
  %div = fdiv double %2, 0x41F0000000000000, !dbg !1948
  %conv1 = fptoui double %div to i32, !dbg !1947
  store i32 %conv1, i32* %high, align 4, !dbg !1949
  %3 = load double, double* %da, align 8, !dbg !1950
  %4 = load i32, i32* %high, align 4, !dbg !1951
  %conv2 = uitofp i32 %4 to double, !dbg !1952
  %mul = fmul double %conv2, 0x41F0000000000000, !dbg !1953
  %sub = fsub double %3, %mul, !dbg !1954
  %conv3 = fptoui double %sub to i32, !dbg !1950
  store i32 %conv3, i32* %low, align 4, !dbg !1955
  %5 = load i32, i32* %high, align 4, !dbg !1956
  %conv4 = zext i32 %5 to i64, !dbg !1957
  %shl = shl i64 %conv4, 32, !dbg !1958
  %6 = load i32, i32* %low, align 4, !dbg !1959
  %conv5 = zext i32 %6 to i64, !dbg !1959
  %or = or i64 %shl, %conv5, !dbg !1960
  store i64 %or, i64* %retval, align 8, !dbg !1961
  br label %return, !dbg !1961

return:                                           ; preds = %if.end, %if.then
  %7 = load i64, i64* %retval, align 8, !dbg !1962
  ret i64 %7, !dbg !1962
}

; Function Attrs: noinline nounwind
define dso_local arm_aapcscc i32 @__fixunssfsi(float %a) #0 !dbg !1963 {
entry:
  %a.addr = alloca float, align 4
  store float %a, float* %a.addr, align 4
  %0 = load float, float* %a.addr, align 4, !dbg !1964
  %call = call arm_aapcs_vfpcc i32 @__fixuint.27(float %0) #4, !dbg !1965
  ret i32 %call, !dbg !1966
}

; Function Attrs: noinline nounwind
define internal arm_aapcs_vfpcc i32 @__fixuint.27(float %a) #0 !dbg !1967 {
entry:
  %retval = alloca i32, align 4
  %a.addr = alloca float, align 4
  %aRep = alloca i32, align 4
  %aAbs = alloca i32, align 4
  %sign = alloca i32, align 4
  %exponent = alloca i32, align 4
  %significand = alloca i32, align 4
  store float %a, float* %a.addr, align 4
  %0 = load float, float* %a.addr, align 4, !dbg !1968
  %call = call arm_aapcs_vfpcc i32 @toRep.28(float %0) #4, !dbg !1969
  store i32 %call, i32* %aRep, align 4, !dbg !1970
  %1 = load i32, i32* %aRep, align 4, !dbg !1971
  %and = and i32 %1, 2147483647, !dbg !1972
  store i32 %and, i32* %aAbs, align 4, !dbg !1973
  %2 = load i32, i32* %aRep, align 4, !dbg !1974
  %and1 = and i32 %2, -2147483648, !dbg !1975
  %tobool = icmp ne i32 %and1, 0, !dbg !1974
  %3 = zext i1 %tobool to i64, !dbg !1974
  %cond = select i1 %tobool, i32 -1, i32 1, !dbg !1974
  store i32 %cond, i32* %sign, align 4, !dbg !1976
  %4 = load i32, i32* %aAbs, align 4, !dbg !1977
  %shr = lshr i32 %4, 23, !dbg !1978
  %sub = sub i32 %shr, 127, !dbg !1979
  store i32 %sub, i32* %exponent, align 4, !dbg !1980
  %5 = load i32, i32* %aAbs, align 4, !dbg !1981
  %and2 = and i32 %5, 8388607, !dbg !1982
  %or = or i32 %and2, 8388608, !dbg !1983
  store i32 %or, i32* %significand, align 4, !dbg !1984
  %6 = load i32, i32* %sign, align 4, !dbg !1985
  %cmp = icmp eq i32 %6, -1, !dbg !1986
  br i1 %cmp, label %if.then, label %lor.lhs.false, !dbg !1987

lor.lhs.false:                                    ; preds = %entry
  %7 = load i32, i32* %exponent, align 4, !dbg !1988
  %cmp3 = icmp slt i32 %7, 0, !dbg !1989
  br i1 %cmp3, label %if.then, label %if.end, !dbg !1985

if.then:                                          ; preds = %lor.lhs.false, %entry
  store i32 0, i32* %retval, align 4, !dbg !1990
  br label %return, !dbg !1990

if.end:                                           ; preds = %lor.lhs.false
  %8 = load i32, i32* %exponent, align 4, !dbg !1991
  %cmp4 = icmp uge i32 %8, 32, !dbg !1992
  br i1 %cmp4, label %if.then5, label %if.end6, !dbg !1993

if.then5:                                         ; preds = %if.end
  store i32 -1, i32* %retval, align 4, !dbg !1994
  br label %return, !dbg !1994

if.end6:                                          ; preds = %if.end
  %9 = load i32, i32* %exponent, align 4, !dbg !1995
  %cmp7 = icmp slt i32 %9, 23, !dbg !1996
  br i1 %cmp7, label %if.then8, label %if.else, !dbg !1995

if.then8:                                         ; preds = %if.end6
  %10 = load i32, i32* %significand, align 4, !dbg !1997
  %11 = load i32, i32* %exponent, align 4, !dbg !1998
  %sub9 = sub nsw i32 23, %11, !dbg !1999
  %shr10 = lshr i32 %10, %sub9, !dbg !2000
  store i32 %shr10, i32* %retval, align 4, !dbg !2001
  br label %return, !dbg !2001

if.else:                                          ; preds = %if.end6
  %12 = load i32, i32* %significand, align 4, !dbg !2002
  %13 = load i32, i32* %exponent, align 4, !dbg !2003
  %sub11 = sub nsw i32 %13, 23, !dbg !2004
  %shl = shl i32 %12, %sub11, !dbg !2005
  store i32 %shl, i32* %retval, align 4, !dbg !2006
  br label %return, !dbg !2006

return:                                           ; preds = %if.else, %if.then8, %if.then5, %if.then
  %14 = load i32, i32* %retval, align 4, !dbg !2007
  ret i32 %14, !dbg !2007
}

; Function Attrs: noinline nounwind
define internal arm_aapcs_vfpcc i32 @toRep.28(float %x) #0 !dbg !2008 {
entry:
  %x.addr = alloca float, align 4
  %rep = alloca %union.anon.0.0, align 4
  store float %x, float* %x.addr, align 4
  %f = bitcast %union.anon.0.0* %rep to float*, !dbg !2009
  %0 = load float, float* %x.addr, align 4, !dbg !2010
  store float %0, float* %f, align 4, !dbg !2009
  %i = bitcast %union.anon.0.0* %rep to i32*, !dbg !2011
  %1 = load i32, i32* %i, align 4, !dbg !2011
  ret i32 %1, !dbg !2012
}

; Function Attrs: noinline nounwind
define dso_local arm_aapcscc i64 @__fixunsxfdi(double %a) #0 !dbg !2013 {
entry:
  %retval = alloca i64, align 8
  %a.addr = alloca double, align 8
  %fb = alloca %union.long_double_bits, align 8
  %e = alloca i32, align 4
  store double %a, double* %a.addr, align 8
  %0 = load double, double* %a.addr, align 8, !dbg !2014
  %f = bitcast %union.long_double_bits* %fb to double*, !dbg !2015
  store double %0, double* %f, align 8, !dbg !2016
  %u = bitcast %union.long_double_bits* %fb to %struct.uqwords*, !dbg !2017
  %high = getelementptr inbounds %struct.uqwords, %struct.uqwords* %u, i32 0, i32 1, !dbg !2018
  %s = bitcast %union.udwords* %high to %struct.anon*, !dbg !2019
  %low = getelementptr inbounds %struct.anon, %struct.anon* %s, i32 0, i32 0, !dbg !2020
  %1 = load i32, i32* %low, align 8, !dbg !2020
  %and = and i32 %1, 32767, !dbg !2021
  %sub = sub i32 %and, 16383, !dbg !2022
  store i32 %sub, i32* %e, align 4, !dbg !2023
  %2 = load i32, i32* %e, align 4, !dbg !2024
  %cmp = icmp slt i32 %2, 0, !dbg !2025
  br i1 %cmp, label %if.then, label %lor.lhs.false, !dbg !2026

lor.lhs.false:                                    ; preds = %entry
  %u1 = bitcast %union.long_double_bits* %fb to %struct.uqwords*, !dbg !2027
  %high2 = getelementptr inbounds %struct.uqwords, %struct.uqwords* %u1, i32 0, i32 1, !dbg !2028
  %s3 = bitcast %union.udwords* %high2 to %struct.anon*, !dbg !2029
  %low4 = getelementptr inbounds %struct.anon, %struct.anon* %s3, i32 0, i32 0, !dbg !2030
  %3 = load i32, i32* %low4, align 8, !dbg !2030
  %and5 = and i32 %3, 32768, !dbg !2031
  %tobool = icmp ne i32 %and5, 0, !dbg !2031
  br i1 %tobool, label %if.then, label %if.end, !dbg !2024

if.then:                                          ; preds = %lor.lhs.false, %entry
  store i64 0, i64* %retval, align 8, !dbg !2032
  br label %return, !dbg !2032

if.end:                                           ; preds = %lor.lhs.false
  %4 = load i32, i32* %e, align 4, !dbg !2033
  %cmp6 = icmp ugt i32 %4, 64, !dbg !2034
  br i1 %cmp6, label %if.then7, label %if.end8, !dbg !2035

if.then7:                                         ; preds = %if.end
  store i64 -1, i64* %retval, align 8, !dbg !2036
  br label %return, !dbg !2036

if.end8:                                          ; preds = %if.end
  %u9 = bitcast %union.long_double_bits* %fb to %struct.uqwords*, !dbg !2037
  %low10 = getelementptr inbounds %struct.uqwords, %struct.uqwords* %u9, i32 0, i32 0, !dbg !2038
  %all = bitcast %union.udwords* %low10 to i64*, !dbg !2039
  %5 = load i64, i64* %all, align 8, !dbg !2039
  %6 = load i32, i32* %e, align 4, !dbg !2040
  %sub11 = sub nsw i32 63, %6, !dbg !2041
  %sh_prom = zext i32 %sub11 to i64, !dbg !2042
  %shr = lshr i64 %5, %sh_prom, !dbg !2042
  store i64 %shr, i64* %retval, align 8, !dbg !2043
  br label %return, !dbg !2043

return:                                           ; preds = %if.end8, %if.then7, %if.then
  %7 = load i64, i64* %retval, align 8, !dbg !2044
  ret i64 %7, !dbg !2044
}

; Function Attrs: noinline nounwind
define dso_local arm_aapcscc i32 @__fixunsxfsi(double %a) #0 !dbg !2045 {
entry:
  %retval = alloca i32, align 4
  %a.addr = alloca double, align 8
  %fb = alloca %union.long_double_bits, align 8
  %e = alloca i32, align 4
  store double %a, double* %a.addr, align 8
  %0 = load double, double* %a.addr, align 8, !dbg !2046
  %f = bitcast %union.long_double_bits* %fb to double*, !dbg !2047
  store double %0, double* %f, align 8, !dbg !2048
  %u = bitcast %union.long_double_bits* %fb to %struct.uqwords*, !dbg !2049
  %high = getelementptr inbounds %struct.uqwords, %struct.uqwords* %u, i32 0, i32 1, !dbg !2050
  %s = bitcast %union.udwords* %high to %struct.anon*, !dbg !2051
  %low = getelementptr inbounds %struct.anon, %struct.anon* %s, i32 0, i32 0, !dbg !2052
  %1 = load i32, i32* %low, align 8, !dbg !2052
  %and = and i32 %1, 32767, !dbg !2053
  %sub = sub i32 %and, 16383, !dbg !2054
  store i32 %sub, i32* %e, align 4, !dbg !2055
  %2 = load i32, i32* %e, align 4, !dbg !2056
  %cmp = icmp slt i32 %2, 0, !dbg !2057
  br i1 %cmp, label %if.then, label %lor.lhs.false, !dbg !2058

lor.lhs.false:                                    ; preds = %entry
  %u1 = bitcast %union.long_double_bits* %fb to %struct.uqwords*, !dbg !2059
  %high2 = getelementptr inbounds %struct.uqwords, %struct.uqwords* %u1, i32 0, i32 1, !dbg !2060
  %s3 = bitcast %union.udwords* %high2 to %struct.anon*, !dbg !2061
  %low4 = getelementptr inbounds %struct.anon, %struct.anon* %s3, i32 0, i32 0, !dbg !2062
  %3 = load i32, i32* %low4, align 8, !dbg !2062
  %and5 = and i32 %3, 32768, !dbg !2063
  %tobool = icmp ne i32 %and5, 0, !dbg !2063
  br i1 %tobool, label %if.then, label %if.end, !dbg !2056

if.then:                                          ; preds = %lor.lhs.false, %entry
  store i32 0, i32* %retval, align 4, !dbg !2064
  br label %return, !dbg !2064

if.end:                                           ; preds = %lor.lhs.false
  %4 = load i32, i32* %e, align 4, !dbg !2065
  %cmp6 = icmp ugt i32 %4, 32, !dbg !2066
  br i1 %cmp6, label %if.then7, label %if.end8, !dbg !2067

if.then7:                                         ; preds = %if.end
  store i32 -1, i32* %retval, align 4, !dbg !2068
  br label %return, !dbg !2068

if.end8:                                          ; preds = %if.end
  %u9 = bitcast %union.long_double_bits* %fb to %struct.uqwords*, !dbg !2069
  %low10 = getelementptr inbounds %struct.uqwords, %struct.uqwords* %u9, i32 0, i32 0, !dbg !2070
  %s11 = bitcast %union.udwords* %low10 to %struct.anon*, !dbg !2071
  %high12 = getelementptr inbounds %struct.anon, %struct.anon* %s11, i32 0, i32 1, !dbg !2072
  %5 = load i32, i32* %high12, align 4, !dbg !2072
  %6 = load i32, i32* %e, align 4, !dbg !2073
  %sub13 = sub nsw i32 31, %6, !dbg !2074
  %shr = lshr i32 %5, %sub13, !dbg !2075
  store i32 %shr, i32* %retval, align 4, !dbg !2076
  br label %return, !dbg !2076

return:                                           ; preds = %if.end8, %if.then7, %if.then
  %7 = load i32, i32* %retval, align 4, !dbg !2077
  ret i32 %7, !dbg !2077
}

; Function Attrs: noinline nounwind
define dso_local arm_aapcscc i64 @__fixxfdi(double %a) #0 !dbg !2078 {
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
  store i64 9223372036854775807, i64* %di_max, align 8, !dbg !2079
  store i64 -9223372036854775808, i64* %di_min, align 8, !dbg !2080
  %0 = load double, double* %a.addr, align 8, !dbg !2081
  %f = bitcast %union.long_double_bits* %fb to double*, !dbg !2082
  store double %0, double* %f, align 8, !dbg !2083
  %u = bitcast %union.long_double_bits* %fb to %struct.uqwords*, !dbg !2084
  %high = getelementptr inbounds %struct.uqwords, %struct.uqwords* %u, i32 0, i32 1, !dbg !2085
  %s = bitcast %union.udwords* %high to %struct.anon*, !dbg !2086
  %low = getelementptr inbounds %struct.anon, %struct.anon* %s, i32 0, i32 0, !dbg !2087
  %1 = load i32, i32* %low, align 8, !dbg !2087
  %and = and i32 %1, 32767, !dbg !2088
  %sub = sub i32 %and, 16383, !dbg !2089
  store i32 %sub, i32* %e, align 4, !dbg !2090
  %2 = load i32, i32* %e, align 4, !dbg !2091
  %cmp = icmp slt i32 %2, 0, !dbg !2092
  br i1 %cmp, label %if.then, label %if.end, !dbg !2091

if.then:                                          ; preds = %entry
  store i64 0, i64* %retval, align 8, !dbg !2093
  br label %return, !dbg !2093

if.end:                                           ; preds = %entry
  %3 = load i32, i32* %e, align 4, !dbg !2094
  %cmp1 = icmp uge i32 %3, 64, !dbg !2095
  br i1 %cmp1, label %if.then2, label %if.end4, !dbg !2096

if.then2:                                         ; preds = %if.end
  %4 = load double, double* %a.addr, align 8, !dbg !2097
  %cmp3 = fcmp ogt double %4, 0.000000e+00, !dbg !2098
  %5 = zext i1 %cmp3 to i64, !dbg !2097
  %cond = select i1 %cmp3, i64 9223372036854775807, i64 -9223372036854775808, !dbg !2097
  store i64 %cond, i64* %retval, align 8, !dbg !2099
  br label %return, !dbg !2099

if.end4:                                          ; preds = %if.end
  %u6 = bitcast %union.long_double_bits* %fb to %struct.uqwords*, !dbg !2100
  %high7 = getelementptr inbounds %struct.uqwords, %struct.uqwords* %u6, i32 0, i32 1, !dbg !2101
  %s8 = bitcast %union.udwords* %high7 to %struct.anon*, !dbg !2102
  %low9 = getelementptr inbounds %struct.anon, %struct.anon* %s8, i32 0, i32 0, !dbg !2103
  %6 = load i32, i32* %low9, align 8, !dbg !2103
  %and10 = and i32 %6, 32768, !dbg !2104
  %shr = lshr i32 %and10, 15, !dbg !2105
  %sub11 = sub nsw i32 0, %shr, !dbg !2106
  %conv = sext i32 %sub11 to i64, !dbg !2106
  store i64 %conv, i64* %s5, align 8, !dbg !2107
  %u12 = bitcast %union.long_double_bits* %fb to %struct.uqwords*, !dbg !2108
  %low13 = getelementptr inbounds %struct.uqwords, %struct.uqwords* %u12, i32 0, i32 0, !dbg !2109
  %all = bitcast %union.udwords* %low13 to i64*, !dbg !2110
  %7 = load i64, i64* %all, align 8, !dbg !2110
  store i64 %7, i64* %r, align 8, !dbg !2111
  %8 = load i64, i64* %r, align 8, !dbg !2112
  %9 = load i32, i32* %e, align 4, !dbg !2113
  %sub14 = sub nsw i32 63, %9, !dbg !2114
  %sh_prom = zext i32 %sub14 to i64, !dbg !2115
  %shr15 = lshr i64 %8, %sh_prom, !dbg !2115
  store i64 %shr15, i64* %r, align 8, !dbg !2116
  %10 = load i64, i64* %r, align 8, !dbg !2117
  %11 = load i64, i64* %s5, align 8, !dbg !2118
  %xor = xor i64 %10, %11, !dbg !2119
  %12 = load i64, i64* %s5, align 8, !dbg !2120
  %sub16 = sub nsw i64 %xor, %12, !dbg !2121
  store i64 %sub16, i64* %retval, align 8, !dbg !2122
  br label %return, !dbg !2122

return:                                           ; preds = %if.end4, %if.then2, %if.then
  %13 = load i64, i64* %retval, align 8, !dbg !2123
  ret i64 %13, !dbg !2123
}

; Function Attrs: noinline nounwind
define dso_local arm_aapcscc double @__floatdidf(i64 %a) #0 !dbg !2124 {
entry:
  %a.addr = alloca i64, align 8
  %low = alloca %union.udwords, align 8
  %high = alloca double, align 8
  %result = alloca double, align 8
  store i64 %a, i64* %a.addr, align 8
  %0 = bitcast %union.udwords* %low to i8*, !dbg !2125
  call void @llvm.memcpy.p0i8.p0i8.i32(i8* align 8 %0, i8* align 8 bitcast ({ double }* @__const.__floatdidf.low to i8*), i32 8, i1 false), !dbg !2125
  %1 = load i64, i64* %a.addr, align 8, !dbg !2126
  %shr = ashr i64 %1, 32, !dbg !2127
  %conv = trunc i64 %shr to i32, !dbg !2128
  %conv1 = sitofp i32 %conv to double, !dbg !2128
  %mul = fmul double %conv1, 0x41F0000000000000, !dbg !2129
  store double %mul, double* %high, align 8, !dbg !2130
  %2 = load i64, i64* %a.addr, align 8, !dbg !2131
  %and = and i64 %2, 4294967295, !dbg !2132
  %x = bitcast %union.udwords* %low to i64*, !dbg !2133
  %3 = load i64, i64* %x, align 8, !dbg !2134
  %or = or i64 %3, %and, !dbg !2134
  store i64 %or, i64* %x, align 8, !dbg !2134
  %4 = load double, double* %high, align 8, !dbg !2135
  %sub = fsub double %4, 0x4330000000000000, !dbg !2136
  %d = bitcast %union.udwords* %low to double*, !dbg !2137
  %5 = load double, double* %d, align 8, !dbg !2137
  %add = fadd double %sub, %5, !dbg !2138
  store double %add, double* %result, align 8, !dbg !2139
  %6 = load double, double* %result, align 8, !dbg !2140
  ret double %6, !dbg !2141
}

; Function Attrs: argmemonly nounwind
declare void @llvm.memcpy.p0i8.p0i8.i32(i8* nocapture writeonly, i8* nocapture readonly, i32, i1 immarg) #2

; Function Attrs: noinline nounwind
define dso_local arm_aapcscc float @__floatdisf(i64 %a) #0 !dbg !2142 {
entry:
  %retval = alloca float, align 4
  %a.addr = alloca i64, align 8
  %N = alloca i32, align 4
  %s = alloca i64, align 8
  %sd = alloca i32, align 4
  %e = alloca i32, align 4
  %fb = alloca %union.float_bits, align 4
  store i64 %a, i64* %a.addr, align 8
  %0 = load i64, i64* %a.addr, align 8, !dbg !2143
  %cmp = icmp eq i64 %0, 0, !dbg !2144
  br i1 %cmp, label %if.then, label %if.end, !dbg !2143

if.then:                                          ; preds = %entry
  store float 0.000000e+00, float* %retval, align 4, !dbg !2145
  br label %return, !dbg !2145

if.end:                                           ; preds = %entry
  store i32 64, i32* %N, align 4, !dbg !2146
  %1 = load i64, i64* %a.addr, align 8, !dbg !2147
  %shr = ashr i64 %1, 63, !dbg !2148
  store i64 %shr, i64* %s, align 8, !dbg !2149
  %2 = load i64, i64* %a.addr, align 8, !dbg !2150
  %3 = load i64, i64* %s, align 8, !dbg !2151
  %xor = xor i64 %2, %3, !dbg !2152
  %4 = load i64, i64* %s, align 8, !dbg !2153
  %sub = sub nsw i64 %xor, %4, !dbg !2154
  store i64 %sub, i64* %a.addr, align 8, !dbg !2155
  %5 = load i64, i64* %a.addr, align 8, !dbg !2156
  %6 = call i64 @llvm.ctlz.i64(i64 %5, i1 false), !dbg !2157
  %cast = trunc i64 %6 to i32, !dbg !2157
  %sub1 = sub i32 64, %cast, !dbg !2158
  store i32 %sub1, i32* %sd, align 4, !dbg !2159
  %7 = load i32, i32* %sd, align 4, !dbg !2160
  %sub2 = sub nsw i32 %7, 1, !dbg !2161
  store i32 %sub2, i32* %e, align 4, !dbg !2162
  %8 = load i32, i32* %sd, align 4, !dbg !2163
  %cmp3 = icmp sgt i32 %8, 24, !dbg !2164
  br i1 %cmp3, label %if.then4, label %if.else, !dbg !2163

if.then4:                                         ; preds = %if.end
  %9 = load i32, i32* %sd, align 4, !dbg !2165
  switch i32 %9, label %sw.default [
    i32 25, label %sw.bb
    i32 26, label %sw.bb5
  ], !dbg !2166

sw.bb:                                            ; preds = %if.then4
  %10 = load i64, i64* %a.addr, align 8, !dbg !2167
  %shl = shl i64 %10, 1, !dbg !2167
  store i64 %shl, i64* %a.addr, align 8, !dbg !2167
  br label %sw.epilog, !dbg !2168

sw.bb5:                                           ; preds = %if.then4
  br label %sw.epilog, !dbg !2169

sw.default:                                       ; preds = %if.then4
  %11 = load i64, i64* %a.addr, align 8, !dbg !2170
  %12 = load i32, i32* %sd, align 4, !dbg !2171
  %sub6 = sub nsw i32 %12, 26, !dbg !2172
  %sh_prom = zext i32 %sub6 to i64, !dbg !2173
  %shr7 = lshr i64 %11, %sh_prom, !dbg !2173
  %13 = load i64, i64* %a.addr, align 8, !dbg !2174
  %14 = load i32, i32* %sd, align 4, !dbg !2175
  %sub8 = sub i32 90, %14, !dbg !2176
  %sh_prom9 = zext i32 %sub8 to i64, !dbg !2177
  %shr10 = lshr i64 -1, %sh_prom9, !dbg !2177
  %and = and i64 %13, %shr10, !dbg !2178
  %cmp11 = icmp ne i64 %and, 0, !dbg !2179
  %conv = zext i1 %cmp11 to i32, !dbg !2179
  %conv12 = sext i32 %conv to i64, !dbg !2180
  %or = or i64 %shr7, %conv12, !dbg !2181
  store i64 %or, i64* %a.addr, align 8, !dbg !2182
  br label %sw.epilog, !dbg !2183

sw.epilog:                                        ; preds = %sw.default, %sw.bb5, %sw.bb
  %15 = load i64, i64* %a.addr, align 8, !dbg !2184
  %and13 = and i64 %15, 4, !dbg !2185
  %cmp14 = icmp ne i64 %and13, 0, !dbg !2186
  %conv15 = zext i1 %cmp14 to i32, !dbg !2186
  %conv16 = sext i32 %conv15 to i64, !dbg !2187
  %16 = load i64, i64* %a.addr, align 8, !dbg !2188
  %or17 = or i64 %16, %conv16, !dbg !2188
  store i64 %or17, i64* %a.addr, align 8, !dbg !2188
  %17 = load i64, i64* %a.addr, align 8, !dbg !2189
  %inc = add nsw i64 %17, 1, !dbg !2189
  store i64 %inc, i64* %a.addr, align 8, !dbg !2189
  %18 = load i64, i64* %a.addr, align 8, !dbg !2190
  %shr18 = ashr i64 %18, 2, !dbg !2190
  store i64 %shr18, i64* %a.addr, align 8, !dbg !2190
  %19 = load i64, i64* %a.addr, align 8, !dbg !2191
  %and19 = and i64 %19, 16777216, !dbg !2192
  %tobool = icmp ne i64 %and19, 0, !dbg !2192
  br i1 %tobool, label %if.then20, label %if.end23, !dbg !2191

if.then20:                                        ; preds = %sw.epilog
  %20 = load i64, i64* %a.addr, align 8, !dbg !2193
  %shr21 = ashr i64 %20, 1, !dbg !2193
  store i64 %shr21, i64* %a.addr, align 8, !dbg !2193
  %21 = load i32, i32* %e, align 4, !dbg !2194
  %inc22 = add nsw i32 %21, 1, !dbg !2194
  store i32 %inc22, i32* %e, align 4, !dbg !2194
  br label %if.end23, !dbg !2195

if.end23:                                         ; preds = %if.then20, %sw.epilog
  br label %if.end27, !dbg !2196

if.else:                                          ; preds = %if.end
  %22 = load i32, i32* %sd, align 4, !dbg !2197
  %sub24 = sub nsw i32 24, %22, !dbg !2198
  %23 = load i64, i64* %a.addr, align 8, !dbg !2199
  %sh_prom25 = zext i32 %sub24 to i64, !dbg !2199
  %shl26 = shl i64 %23, %sh_prom25, !dbg !2199
  store i64 %shl26, i64* %a.addr, align 8, !dbg !2199
  br label %if.end27

if.end27:                                         ; preds = %if.else, %if.end23
  %24 = load i64, i64* %s, align 8, !dbg !2200
  %conv28 = trunc i64 %24 to i32, !dbg !2201
  %and29 = and i32 %conv28, -2147483648, !dbg !2202
  %25 = load i32, i32* %e, align 4, !dbg !2203
  %add = add nsw i32 %25, 127, !dbg !2204
  %shl30 = shl i32 %add, 23, !dbg !2205
  %or31 = or i32 %and29, %shl30, !dbg !2206
  %26 = load i64, i64* %a.addr, align 8, !dbg !2207
  %conv32 = trunc i64 %26 to i32, !dbg !2208
  %and33 = and i32 %conv32, 8388607, !dbg !2209
  %or34 = or i32 %or31, %and33, !dbg !2210
  %u = bitcast %union.float_bits* %fb to i32*, !dbg !2211
  store i32 %or34, i32* %u, align 4, !dbg !2212
  %f = bitcast %union.float_bits* %fb to float*, !dbg !2213
  %27 = load float, float* %f, align 4, !dbg !2213
  store float %27, float* %retval, align 4, !dbg !2214
  br label %return, !dbg !2214

return:                                           ; preds = %if.end27, %if.then
  %28 = load float, float* %retval, align 4, !dbg !2215
  ret float %28, !dbg !2215
}

; Function Attrs: nounwind readnone speculatable
declare i64 @llvm.ctlz.i64(i64, i1 immarg) #1

; Function Attrs: noinline nounwind
define dso_local arm_aapcscc double @__floatdixf(i64 %a) #0 !dbg !2216 {
entry:
  %retval = alloca double, align 8
  %a.addr = alloca i64, align 8
  %N = alloca i32, align 4
  %s = alloca i64, align 8
  %clz = alloca i32, align 4
  %e = alloca i32, align 4
  %fb = alloca %union.long_double_bits, align 8
  store i64 %a, i64* %a.addr, align 8
  %0 = load i64, i64* %a.addr, align 8, !dbg !2217
  %cmp = icmp eq i64 %0, 0, !dbg !2218
  br i1 %cmp, label %if.then, label %if.end, !dbg !2217

if.then:                                          ; preds = %entry
  store double 0.000000e+00, double* %retval, align 8, !dbg !2219
  br label %return, !dbg !2219

if.end:                                           ; preds = %entry
  store i32 64, i32* %N, align 4, !dbg !2220
  %1 = load i64, i64* %a.addr, align 8, !dbg !2221
  %shr = ashr i64 %1, 63, !dbg !2222
  store i64 %shr, i64* %s, align 8, !dbg !2223
  %2 = load i64, i64* %a.addr, align 8, !dbg !2224
  %3 = load i64, i64* %s, align 8, !dbg !2225
  %xor = xor i64 %2, %3, !dbg !2226
  %4 = load i64, i64* %s, align 8, !dbg !2227
  %sub = sub nsw i64 %xor, %4, !dbg !2228
  store i64 %sub, i64* %a.addr, align 8, !dbg !2229
  %5 = load i64, i64* %a.addr, align 8, !dbg !2230
  %6 = call i64 @llvm.ctlz.i64(i64 %5, i1 false), !dbg !2231
  %cast = trunc i64 %6 to i32, !dbg !2231
  store i32 %cast, i32* %clz, align 4, !dbg !2232
  %7 = load i32, i32* %clz, align 4, !dbg !2233
  %sub1 = sub i32 63, %7, !dbg !2234
  store i32 %sub1, i32* %e, align 4, !dbg !2235
  %8 = load i64, i64* %s, align 8, !dbg !2236
  %conv = trunc i64 %8 to i32, !dbg !2237
  %and = and i32 %conv, 32768, !dbg !2238
  %9 = load i32, i32* %e, align 4, !dbg !2239
  %add = add nsw i32 %9, 16383, !dbg !2240
  %or = or i32 %and, %add, !dbg !2241
  %u = bitcast %union.long_double_bits* %fb to %struct.uqwords*, !dbg !2242
  %high = getelementptr inbounds %struct.uqwords, %struct.uqwords* %u, i32 0, i32 1, !dbg !2243
  %s2 = bitcast %union.udwords* %high to %struct.anon*, !dbg !2244
  %low = getelementptr inbounds %struct.anon, %struct.anon* %s2, i32 0, i32 0, !dbg !2245
  store i32 %or, i32* %low, align 8, !dbg !2246
  %10 = load i64, i64* %a.addr, align 8, !dbg !2247
  %11 = load i32, i32* %clz, align 4, !dbg !2248
  %sh_prom = zext i32 %11 to i64, !dbg !2249
  %shl = shl i64 %10, %sh_prom, !dbg !2249
  %u3 = bitcast %union.long_double_bits* %fb to %struct.uqwords*, !dbg !2250
  %low4 = getelementptr inbounds %struct.uqwords, %struct.uqwords* %u3, i32 0, i32 0, !dbg !2251
  %all = bitcast %union.udwords* %low4 to i64*, !dbg !2252
  store i64 %shl, i64* %all, align 8, !dbg !2253
  %f = bitcast %union.long_double_bits* %fb to double*, !dbg !2254
  %12 = load double, double* %f, align 8, !dbg !2254
  store double %12, double* %retval, align 8, !dbg !2255
  br label %return, !dbg !2255

return:                                           ; preds = %if.end, %if.then
  %13 = load double, double* %retval, align 8, !dbg !2256
  ret double %13, !dbg !2256
}

; Function Attrs: noinline nounwind
define dso_local arm_aapcscc double @__floatsidf(i32 %a) #0 !dbg !2257 {
entry:
  %retval = alloca double, align 8
  %a.addr = alloca i32, align 4
  %aWidth = alloca i32, align 4
  %sign = alloca i64, align 8
  %exponent = alloca i32, align 4
  %result = alloca i64, align 8
  %shift = alloca i32, align 4
  store i32 %a, i32* %a.addr, align 4
  store i32 32, i32* %aWidth, align 4, !dbg !2258
  %0 = load i32, i32* %a.addr, align 4, !dbg !2259
  %cmp = icmp eq i32 %0, 0, !dbg !2260
  br i1 %cmp, label %if.then, label %if.end, !dbg !2259

if.then:                                          ; preds = %entry
  %call = call arm_aapcs_vfpcc double @fromRep.29(i64 0) #4, !dbg !2261
  store double %call, double* %retval, align 8, !dbg !2262
  br label %return, !dbg !2262

if.end:                                           ; preds = %entry
  store i64 0, i64* %sign, align 8, !dbg !2263
  %1 = load i32, i32* %a.addr, align 4, !dbg !2264
  %cmp1 = icmp slt i32 %1, 0, !dbg !2265
  br i1 %cmp1, label %if.then2, label %if.end3, !dbg !2264

if.then2:                                         ; preds = %if.end
  store i64 -9223372036854775808, i64* %sign, align 8, !dbg !2266
  %2 = load i32, i32* %a.addr, align 4, !dbg !2267
  %sub = sub nsw i32 0, %2, !dbg !2268
  store i32 %sub, i32* %a.addr, align 4, !dbg !2269
  br label %if.end3, !dbg !2270

if.end3:                                          ; preds = %if.then2, %if.end
  %3 = load i32, i32* %a.addr, align 4, !dbg !2271
  %4 = call i32 @llvm.ctlz.i32(i32 %3, i1 false), !dbg !2272
  %sub4 = sub nsw i32 31, %4, !dbg !2273
  store i32 %sub4, i32* %exponent, align 4, !dbg !2274
  %5 = load i32, i32* %exponent, align 4, !dbg !2275
  %sub5 = sub nsw i32 52, %5, !dbg !2276
  store i32 %sub5, i32* %shift, align 4, !dbg !2277
  %6 = load i32, i32* %a.addr, align 4, !dbg !2278
  %conv = zext i32 %6 to i64, !dbg !2279
  %7 = load i32, i32* %shift, align 4, !dbg !2280
  %sh_prom = zext i32 %7 to i64, !dbg !2281
  %shl = shl i64 %conv, %sh_prom, !dbg !2281
  %xor = xor i64 %shl, 4503599627370496, !dbg !2282
  store i64 %xor, i64* %result, align 8, !dbg !2283
  %8 = load i32, i32* %exponent, align 4, !dbg !2284
  %add = add nsw i32 %8, 1023, !dbg !2285
  %conv6 = sext i32 %add to i64, !dbg !2286
  %shl7 = shl i64 %conv6, 52, !dbg !2287
  %9 = load i64, i64* %result, align 8, !dbg !2288
  %add8 = add i64 %9, %shl7, !dbg !2288
  store i64 %add8, i64* %result, align 8, !dbg !2288
  %10 = load i64, i64* %result, align 8, !dbg !2289
  %11 = load i64, i64* %sign, align 8, !dbg !2290
  %or = or i64 %10, %11, !dbg !2291
  %call9 = call arm_aapcs_vfpcc double @fromRep.29(i64 %or) #4, !dbg !2292
  store double %call9, double* %retval, align 8, !dbg !2293
  br label %return, !dbg !2293

return:                                           ; preds = %if.end3, %if.then
  %12 = load double, double* %retval, align 8, !dbg !2294
  ret double %12, !dbg !2294
}

; Function Attrs: noinline nounwind
define internal arm_aapcs_vfpcc double @fromRep.29(i64 %x) #0 !dbg !2295 {
entry:
  %x.addr = alloca i64, align 8
  %rep = alloca %union.anon.0, align 8
  store i64 %x, i64* %x.addr, align 8
  %i = bitcast %union.anon.0* %rep to i64*, !dbg !2296
  %0 = load i64, i64* %x.addr, align 8, !dbg !2297
  store i64 %0, i64* %i, align 8, !dbg !2296
  %f = bitcast %union.anon.0* %rep to double*, !dbg !2298
  %1 = load double, double* %f, align 8, !dbg !2298
  ret double %1, !dbg !2299
}

; Function Attrs: noinline nounwind
define dso_local arm_aapcscc float @__floatsisf(i32 %a) #0 !dbg !2300 {
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
  store i32 32, i32* %aWidth, align 4, !dbg !2301
  %0 = load i32, i32* %a.addr, align 4, !dbg !2302
  %cmp = icmp eq i32 %0, 0, !dbg !2303
  br i1 %cmp, label %if.then, label %if.end, !dbg !2302

if.then:                                          ; preds = %entry
  %call = call arm_aapcs_vfpcc float @fromRep.30(i32 0) #4, !dbg !2304
  store float %call, float* %retval, align 4, !dbg !2305
  br label %return, !dbg !2305

if.end:                                           ; preds = %entry
  store i32 0, i32* %sign, align 4, !dbg !2306
  %1 = load i32, i32* %a.addr, align 4, !dbg !2307
  %cmp1 = icmp slt i32 %1, 0, !dbg !2308
  br i1 %cmp1, label %if.then2, label %if.end3, !dbg !2307

if.then2:                                         ; preds = %if.end
  store i32 -2147483648, i32* %sign, align 4, !dbg !2309
  %2 = load i32, i32* %a.addr, align 4, !dbg !2310
  %sub = sub nsw i32 0, %2, !dbg !2311
  store i32 %sub, i32* %a.addr, align 4, !dbg !2312
  br label %if.end3, !dbg !2313

if.end3:                                          ; preds = %if.then2, %if.end
  %3 = load i32, i32* %a.addr, align 4, !dbg !2314
  %4 = call i32 @llvm.ctlz.i32(i32 %3, i1 false), !dbg !2315
  %sub4 = sub nsw i32 31, %4, !dbg !2316
  store i32 %sub4, i32* %exponent, align 4, !dbg !2317
  %5 = load i32, i32* %exponent, align 4, !dbg !2318
  %cmp5 = icmp sle i32 %5, 23, !dbg !2319
  br i1 %cmp5, label %if.then6, label %if.else, !dbg !2318

if.then6:                                         ; preds = %if.end3
  %6 = load i32, i32* %exponent, align 4, !dbg !2320
  %sub7 = sub nsw i32 23, %6, !dbg !2321
  store i32 %sub7, i32* %shift, align 4, !dbg !2322
  %7 = load i32, i32* %a.addr, align 4, !dbg !2323
  %8 = load i32, i32* %shift, align 4, !dbg !2324
  %shl = shl i32 %7, %8, !dbg !2325
  %xor = xor i32 %shl, 8388608, !dbg !2326
  store i32 %xor, i32* %result, align 4, !dbg !2327
  br label %if.end19, !dbg !2328

if.else:                                          ; preds = %if.end3
  %9 = load i32, i32* %exponent, align 4, !dbg !2329
  %sub9 = sub nsw i32 %9, 23, !dbg !2330
  store i32 %sub9, i32* %shift8, align 4, !dbg !2331
  %10 = load i32, i32* %a.addr, align 4, !dbg !2332
  %11 = load i32, i32* %shift8, align 4, !dbg !2333
  %shr = lshr i32 %10, %11, !dbg !2334
  %xor10 = xor i32 %shr, 8388608, !dbg !2335
  store i32 %xor10, i32* %result, align 4, !dbg !2336
  %12 = load i32, i32* %a.addr, align 4, !dbg !2337
  %13 = load i32, i32* %shift8, align 4, !dbg !2338
  %sub11 = sub i32 32, %13, !dbg !2339
  %shl12 = shl i32 %12, %sub11, !dbg !2340
  store i32 %shl12, i32* %round, align 4, !dbg !2341
  %14 = load i32, i32* %round, align 4, !dbg !2342
  %cmp13 = icmp ugt i32 %14, -2147483648, !dbg !2343
  br i1 %cmp13, label %if.then14, label %if.end15, !dbg !2342

if.then14:                                        ; preds = %if.else
  %15 = load i32, i32* %result, align 4, !dbg !2344
  %inc = add i32 %15, 1, !dbg !2344
  store i32 %inc, i32* %result, align 4, !dbg !2344
  br label %if.end15, !dbg !2345

if.end15:                                         ; preds = %if.then14, %if.else
  %16 = load i32, i32* %round, align 4, !dbg !2346
  %cmp16 = icmp eq i32 %16, -2147483648, !dbg !2347
  br i1 %cmp16, label %if.then17, label %if.end18, !dbg !2346

if.then17:                                        ; preds = %if.end15
  %17 = load i32, i32* %result, align 4, !dbg !2348
  %and = and i32 %17, 1, !dbg !2349
  %18 = load i32, i32* %result, align 4, !dbg !2350
  %add = add i32 %18, %and, !dbg !2350
  store i32 %add, i32* %result, align 4, !dbg !2350
  br label %if.end18, !dbg !2351

if.end18:                                         ; preds = %if.then17, %if.end15
  br label %if.end19

if.end19:                                         ; preds = %if.end18, %if.then6
  %19 = load i32, i32* %exponent, align 4, !dbg !2352
  %add20 = add nsw i32 %19, 127, !dbg !2353
  %shl21 = shl i32 %add20, 23, !dbg !2354
  %20 = load i32, i32* %result, align 4, !dbg !2355
  %add22 = add i32 %20, %shl21, !dbg !2355
  store i32 %add22, i32* %result, align 4, !dbg !2355
  %21 = load i32, i32* %result, align 4, !dbg !2356
  %22 = load i32, i32* %sign, align 4, !dbg !2357
  %or = or i32 %21, %22, !dbg !2358
  %call23 = call arm_aapcs_vfpcc float @fromRep.30(i32 %or) #4, !dbg !2359
  store float %call23, float* %retval, align 4, !dbg !2360
  br label %return, !dbg !2360

return:                                           ; preds = %if.end19, %if.then
  %23 = load float, float* %retval, align 4, !dbg !2361
  ret float %23, !dbg !2361
}

; Function Attrs: noinline nounwind
define internal arm_aapcs_vfpcc float @fromRep.30(i32 %x) #0 !dbg !2362 {
entry:
  %x.addr = alloca i32, align 4
  %rep = alloca %union.anon.0.0, align 4
  store i32 %x, i32* %x.addr, align 4
  %i = bitcast %union.anon.0.0* %rep to i32*, !dbg !2363
  %0 = load i32, i32* %x.addr, align 4, !dbg !2364
  store i32 %0, i32* %i, align 4, !dbg !2363
  %f = bitcast %union.anon.0.0* %rep to float*, !dbg !2365
  %1 = load float, float* %f, align 4, !dbg !2365
  ret float %1, !dbg !2366
}

; Function Attrs: noinline nounwind
define dso_local arm_aapcscc double @__floatundidf(i64 %a) #0 !dbg !2367 {
entry:
  %a.addr = alloca i64, align 8
  %high = alloca %union.udwords, align 8
  %low = alloca %union.udwords, align 8
  %result = alloca double, align 8
  store i64 %a, i64* %a.addr, align 8
  %0 = bitcast %union.udwords* %high to i8*, !dbg !2368
  call void @llvm.memcpy.p0i8.p0i8.i32(i8* align 8 %0, i8* align 8 bitcast ({ double }* @__const.__floatundidf.high to i8*), i32 8, i1 false), !dbg !2368
  %1 = bitcast %union.udwords* %low to i8*, !dbg !2369
  call void @llvm.memcpy.p0i8.p0i8.i32(i8* align 8 %1, i8* align 8 bitcast ({ double }* @__const.__floatundidf.low to i8*), i32 8, i1 false), !dbg !2369
  %2 = load i64, i64* %a.addr, align 8, !dbg !2370
  %shr = lshr i64 %2, 32, !dbg !2371
  %x = bitcast %union.udwords* %high to i64*, !dbg !2372
  %3 = load i64, i64* %x, align 8, !dbg !2373
  %or = or i64 %3, %shr, !dbg !2373
  store i64 %or, i64* %x, align 8, !dbg !2373
  %4 = load i64, i64* %a.addr, align 8, !dbg !2374
  %and = and i64 %4, 4294967295, !dbg !2375
  %x1 = bitcast %union.udwords* %low to i64*, !dbg !2376
  %5 = load i64, i64* %x1, align 8, !dbg !2377
  %or2 = or i64 %5, %and, !dbg !2377
  store i64 %or2, i64* %x1, align 8, !dbg !2377
  %d = bitcast %union.udwords* %high to double*, !dbg !2378
  %6 = load double, double* %d, align 8, !dbg !2378
  %sub = fsub double %6, 0x4530000000100000, !dbg !2379
  %d3 = bitcast %union.udwords* %low to double*, !dbg !2380
  %7 = load double, double* %d3, align 8, !dbg !2380
  %add = fadd double %sub, %7, !dbg !2381
  store double %add, double* %result, align 8, !dbg !2382
  %8 = load double, double* %result, align 8, !dbg !2383
  ret double %8, !dbg !2384
}

; Function Attrs: noinline nounwind
define dso_local arm_aapcscc float @__floatundisf(i64 %a) #0 !dbg !2385 {
entry:
  %retval = alloca float, align 4
  %a.addr = alloca i64, align 8
  %N = alloca i32, align 4
  %sd = alloca i32, align 4
  %e = alloca i32, align 4
  %fb = alloca %union.float_bits, align 4
  store i64 %a, i64* %a.addr, align 8
  %0 = load i64, i64* %a.addr, align 8, !dbg !2386
  %cmp = icmp eq i64 %0, 0, !dbg !2387
  br i1 %cmp, label %if.then, label %if.end, !dbg !2386

if.then:                                          ; preds = %entry
  store float 0.000000e+00, float* %retval, align 4, !dbg !2388
  br label %return, !dbg !2388

if.end:                                           ; preds = %entry
  store i32 64, i32* %N, align 4, !dbg !2389
  %1 = load i64, i64* %a.addr, align 8, !dbg !2390
  %2 = call i64 @llvm.ctlz.i64(i64 %1, i1 false), !dbg !2391
  %cast = trunc i64 %2 to i32, !dbg !2391
  %sub = sub i32 64, %cast, !dbg !2392
  store i32 %sub, i32* %sd, align 4, !dbg !2393
  %3 = load i32, i32* %sd, align 4, !dbg !2394
  %sub1 = sub nsw i32 %3, 1, !dbg !2395
  store i32 %sub1, i32* %e, align 4, !dbg !2396
  %4 = load i32, i32* %sd, align 4, !dbg !2397
  %cmp2 = icmp sgt i32 %4, 24, !dbg !2398
  br i1 %cmp2, label %if.then3, label %if.else, !dbg !2397

if.then3:                                         ; preds = %if.end
  %5 = load i32, i32* %sd, align 4, !dbg !2399
  switch i32 %5, label %sw.default [
    i32 25, label %sw.bb
    i32 26, label %sw.bb4
  ], !dbg !2400

sw.bb:                                            ; preds = %if.then3
  %6 = load i64, i64* %a.addr, align 8, !dbg !2401
  %shl = shl i64 %6, 1, !dbg !2401
  store i64 %shl, i64* %a.addr, align 8, !dbg !2401
  br label %sw.epilog, !dbg !2402

sw.bb4:                                           ; preds = %if.then3
  br label %sw.epilog, !dbg !2403

sw.default:                                       ; preds = %if.then3
  %7 = load i64, i64* %a.addr, align 8, !dbg !2404
  %8 = load i32, i32* %sd, align 4, !dbg !2405
  %sub5 = sub nsw i32 %8, 26, !dbg !2406
  %sh_prom = zext i32 %sub5 to i64, !dbg !2407
  %shr = lshr i64 %7, %sh_prom, !dbg !2407
  %9 = load i64, i64* %a.addr, align 8, !dbg !2408
  %10 = load i32, i32* %sd, align 4, !dbg !2409
  %sub6 = sub i32 90, %10, !dbg !2410
  %sh_prom7 = zext i32 %sub6 to i64, !dbg !2411
  %shr8 = lshr i64 -1, %sh_prom7, !dbg !2411
  %and = and i64 %9, %shr8, !dbg !2412
  %cmp9 = icmp ne i64 %and, 0, !dbg !2413
  %conv = zext i1 %cmp9 to i32, !dbg !2413
  %conv10 = sext i32 %conv to i64, !dbg !2414
  %or = or i64 %shr, %conv10, !dbg !2415
  store i64 %or, i64* %a.addr, align 8, !dbg !2416
  br label %sw.epilog, !dbg !2417

sw.epilog:                                        ; preds = %sw.default, %sw.bb4, %sw.bb
  %11 = load i64, i64* %a.addr, align 8, !dbg !2418
  %and11 = and i64 %11, 4, !dbg !2419
  %cmp12 = icmp ne i64 %and11, 0, !dbg !2420
  %conv13 = zext i1 %cmp12 to i32, !dbg !2420
  %conv14 = sext i32 %conv13 to i64, !dbg !2421
  %12 = load i64, i64* %a.addr, align 8, !dbg !2422
  %or15 = or i64 %12, %conv14, !dbg !2422
  store i64 %or15, i64* %a.addr, align 8, !dbg !2422
  %13 = load i64, i64* %a.addr, align 8, !dbg !2423
  %inc = add i64 %13, 1, !dbg !2423
  store i64 %inc, i64* %a.addr, align 8, !dbg !2423
  %14 = load i64, i64* %a.addr, align 8, !dbg !2424
  %shr16 = lshr i64 %14, 2, !dbg !2424
  store i64 %shr16, i64* %a.addr, align 8, !dbg !2424
  %15 = load i64, i64* %a.addr, align 8, !dbg !2425
  %and17 = and i64 %15, 16777216, !dbg !2426
  %tobool = icmp ne i64 %and17, 0, !dbg !2426
  br i1 %tobool, label %if.then18, label %if.end21, !dbg !2425

if.then18:                                        ; preds = %sw.epilog
  %16 = load i64, i64* %a.addr, align 8, !dbg !2427
  %shr19 = lshr i64 %16, 1, !dbg !2427
  store i64 %shr19, i64* %a.addr, align 8, !dbg !2427
  %17 = load i32, i32* %e, align 4, !dbg !2428
  %inc20 = add nsw i32 %17, 1, !dbg !2428
  store i32 %inc20, i32* %e, align 4, !dbg !2428
  br label %if.end21, !dbg !2429

if.end21:                                         ; preds = %if.then18, %sw.epilog
  br label %if.end25, !dbg !2430

if.else:                                          ; preds = %if.end
  %18 = load i32, i32* %sd, align 4, !dbg !2431
  %sub22 = sub nsw i32 24, %18, !dbg !2432
  %19 = load i64, i64* %a.addr, align 8, !dbg !2433
  %sh_prom23 = zext i32 %sub22 to i64, !dbg !2433
  %shl24 = shl i64 %19, %sh_prom23, !dbg !2433
  store i64 %shl24, i64* %a.addr, align 8, !dbg !2433
  br label %if.end25

if.end25:                                         ; preds = %if.else, %if.end21
  %20 = load i32, i32* %e, align 4, !dbg !2434
  %add = add nsw i32 %20, 127, !dbg !2435
  %shl26 = shl i32 %add, 23, !dbg !2436
  %21 = load i64, i64* %a.addr, align 8, !dbg !2437
  %conv27 = trunc i64 %21 to i32, !dbg !2438
  %and28 = and i32 %conv27, 8388607, !dbg !2439
  %or29 = or i32 %shl26, %and28, !dbg !2440
  %u = bitcast %union.float_bits* %fb to i32*, !dbg !2441
  store i32 %or29, i32* %u, align 4, !dbg !2442
  %f = bitcast %union.float_bits* %fb to float*, !dbg !2443
  %22 = load float, float* %f, align 4, !dbg !2443
  store float %22, float* %retval, align 4, !dbg !2444
  br label %return, !dbg !2444

return:                                           ; preds = %if.end25, %if.then
  %23 = load float, float* %retval, align 4, !dbg !2445
  ret float %23, !dbg !2445
}

; Function Attrs: noinline nounwind
define dso_local arm_aapcscc double @__floatundixf(i64 %a) #0 !dbg !2446 {
entry:
  %retval = alloca double, align 8
  %a.addr = alloca i64, align 8
  %N = alloca i32, align 4
  %clz = alloca i32, align 4
  %e = alloca i32, align 4
  %fb = alloca %union.long_double_bits, align 8
  store i64 %a, i64* %a.addr, align 8
  %0 = load i64, i64* %a.addr, align 8, !dbg !2447
  %cmp = icmp eq i64 %0, 0, !dbg !2448
  br i1 %cmp, label %if.then, label %if.end, !dbg !2447

if.then:                                          ; preds = %entry
  store double 0.000000e+00, double* %retval, align 8, !dbg !2449
  br label %return, !dbg !2449

if.end:                                           ; preds = %entry
  store i32 64, i32* %N, align 4, !dbg !2450
  %1 = load i64, i64* %a.addr, align 8, !dbg !2451
  %2 = call i64 @llvm.ctlz.i64(i64 %1, i1 false), !dbg !2452
  %cast = trunc i64 %2 to i32, !dbg !2452
  store i32 %cast, i32* %clz, align 4, !dbg !2453
  %3 = load i32, i32* %clz, align 4, !dbg !2454
  %sub = sub i32 63, %3, !dbg !2455
  store i32 %sub, i32* %e, align 4, !dbg !2456
  %4 = load i32, i32* %e, align 4, !dbg !2457
  %add = add nsw i32 %4, 16383, !dbg !2458
  %u = bitcast %union.long_double_bits* %fb to %struct.uqwords*, !dbg !2459
  %high = getelementptr inbounds %struct.uqwords, %struct.uqwords* %u, i32 0, i32 1, !dbg !2460
  %s = bitcast %union.udwords* %high to %struct.anon*, !dbg !2461
  %low = getelementptr inbounds %struct.anon, %struct.anon* %s, i32 0, i32 0, !dbg !2462
  store i32 %add, i32* %low, align 8, !dbg !2463
  %5 = load i64, i64* %a.addr, align 8, !dbg !2464
  %6 = load i32, i32* %clz, align 4, !dbg !2465
  %sh_prom = zext i32 %6 to i64, !dbg !2466
  %shl = shl i64 %5, %sh_prom, !dbg !2466
  %u1 = bitcast %union.long_double_bits* %fb to %struct.uqwords*, !dbg !2467
  %low2 = getelementptr inbounds %struct.uqwords, %struct.uqwords* %u1, i32 0, i32 0, !dbg !2468
  %all = bitcast %union.udwords* %low2 to i64*, !dbg !2469
  store i64 %shl, i64* %all, align 8, !dbg !2470
  %f = bitcast %union.long_double_bits* %fb to double*, !dbg !2471
  %7 = load double, double* %f, align 8, !dbg !2471
  store double %7, double* %retval, align 8, !dbg !2472
  br label %return, !dbg !2472

return:                                           ; preds = %if.end, %if.then
  %8 = load double, double* %retval, align 8, !dbg !2473
  ret double %8, !dbg !2473
}

; Function Attrs: noinline nounwind
define dso_local arm_aapcscc double @__floatunsidf(i32 %a) #0 !dbg !2474 {
entry:
  %retval = alloca double, align 8
  %a.addr = alloca i32, align 4
  %aWidth = alloca i32, align 4
  %exponent = alloca i32, align 4
  %result = alloca i64, align 8
  %shift = alloca i32, align 4
  store i32 %a, i32* %a.addr, align 4
  store i32 32, i32* %aWidth, align 4, !dbg !2475
  %0 = load i32, i32* %a.addr, align 4, !dbg !2476
  %cmp = icmp eq i32 %0, 0, !dbg !2477
  br i1 %cmp, label %if.then, label %if.end, !dbg !2476

if.then:                                          ; preds = %entry
  %call = call arm_aapcs_vfpcc double @fromRep.31(i64 0) #4, !dbg !2478
  store double %call, double* %retval, align 8, !dbg !2479
  br label %return, !dbg !2479

if.end:                                           ; preds = %entry
  %1 = load i32, i32* %a.addr, align 4, !dbg !2480
  %2 = call i32 @llvm.ctlz.i32(i32 %1, i1 false), !dbg !2481
  %sub = sub nsw i32 31, %2, !dbg !2482
  store i32 %sub, i32* %exponent, align 4, !dbg !2483
  %3 = load i32, i32* %exponent, align 4, !dbg !2484
  %sub1 = sub nsw i32 52, %3, !dbg !2485
  store i32 %sub1, i32* %shift, align 4, !dbg !2486
  %4 = load i32, i32* %a.addr, align 4, !dbg !2487
  %conv = zext i32 %4 to i64, !dbg !2488
  %5 = load i32, i32* %shift, align 4, !dbg !2489
  %sh_prom = zext i32 %5 to i64, !dbg !2490
  %shl = shl i64 %conv, %sh_prom, !dbg !2490
  %xor = xor i64 %shl, 4503599627370496, !dbg !2491
  store i64 %xor, i64* %result, align 8, !dbg !2492
  %6 = load i32, i32* %exponent, align 4, !dbg !2493
  %add = add nsw i32 %6, 1023, !dbg !2494
  %conv2 = sext i32 %add to i64, !dbg !2495
  %shl3 = shl i64 %conv2, 52, !dbg !2496
  %7 = load i64, i64* %result, align 8, !dbg !2497
  %add4 = add i64 %7, %shl3, !dbg !2497
  store i64 %add4, i64* %result, align 8, !dbg !2497
  %8 = load i64, i64* %result, align 8, !dbg !2498
  %call5 = call arm_aapcs_vfpcc double @fromRep.31(i64 %8) #4, !dbg !2499
  store double %call5, double* %retval, align 8, !dbg !2500
  br label %return, !dbg !2500

return:                                           ; preds = %if.end, %if.then
  %9 = load double, double* %retval, align 8, !dbg !2501
  ret double %9, !dbg !2501
}

; Function Attrs: noinline nounwind
define internal arm_aapcs_vfpcc double @fromRep.31(i64 %x) #0 !dbg !2502 {
entry:
  %x.addr = alloca i64, align 8
  %rep = alloca %union.anon.0, align 8
  store i64 %x, i64* %x.addr, align 8
  %i = bitcast %union.anon.0* %rep to i64*, !dbg !2503
  %0 = load i64, i64* %x.addr, align 8, !dbg !2504
  store i64 %0, i64* %i, align 8, !dbg !2503
  %f = bitcast %union.anon.0* %rep to double*, !dbg !2505
  %1 = load double, double* %f, align 8, !dbg !2505
  ret double %1, !dbg !2506
}

; Function Attrs: noinline nounwind
define dso_local arm_aapcscc float @__floatunsisf(i32 %a) #0 !dbg !2507 {
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
  store i32 32, i32* %aWidth, align 4, !dbg !2508
  %0 = load i32, i32* %a.addr, align 4, !dbg !2509
  %cmp = icmp eq i32 %0, 0, !dbg !2510
  br i1 %cmp, label %if.then, label %if.end, !dbg !2509

if.then:                                          ; preds = %entry
  %call = call arm_aapcs_vfpcc float @fromRep.32(i32 0) #4, !dbg !2511
  store float %call, float* %retval, align 4, !dbg !2512
  br label %return, !dbg !2512

if.end:                                           ; preds = %entry
  %1 = load i32, i32* %a.addr, align 4, !dbg !2513
  %2 = call i32 @llvm.ctlz.i32(i32 %1, i1 false), !dbg !2514
  %sub = sub nsw i32 31, %2, !dbg !2515
  store i32 %sub, i32* %exponent, align 4, !dbg !2516
  %3 = load i32, i32* %exponent, align 4, !dbg !2517
  %cmp1 = icmp sle i32 %3, 23, !dbg !2518
  br i1 %cmp1, label %if.then2, label %if.else, !dbg !2517

if.then2:                                         ; preds = %if.end
  %4 = load i32, i32* %exponent, align 4, !dbg !2519
  %sub3 = sub nsw i32 23, %4, !dbg !2520
  store i32 %sub3, i32* %shift, align 4, !dbg !2521
  %5 = load i32, i32* %a.addr, align 4, !dbg !2522
  %6 = load i32, i32* %shift, align 4, !dbg !2523
  %shl = shl i32 %5, %6, !dbg !2524
  %xor = xor i32 %shl, 8388608, !dbg !2525
  store i32 %xor, i32* %result, align 4, !dbg !2526
  br label %if.end15, !dbg !2527

if.else:                                          ; preds = %if.end
  %7 = load i32, i32* %exponent, align 4, !dbg !2528
  %sub5 = sub nsw i32 %7, 23, !dbg !2529
  store i32 %sub5, i32* %shift4, align 4, !dbg !2530
  %8 = load i32, i32* %a.addr, align 4, !dbg !2531
  %9 = load i32, i32* %shift4, align 4, !dbg !2532
  %shr = lshr i32 %8, %9, !dbg !2533
  %xor6 = xor i32 %shr, 8388608, !dbg !2534
  store i32 %xor6, i32* %result, align 4, !dbg !2535
  %10 = load i32, i32* %a.addr, align 4, !dbg !2536
  %11 = load i32, i32* %shift4, align 4, !dbg !2537
  %sub7 = sub i32 32, %11, !dbg !2538
  %shl8 = shl i32 %10, %sub7, !dbg !2539
  store i32 %shl8, i32* %round, align 4, !dbg !2540
  %12 = load i32, i32* %round, align 4, !dbg !2541
  %cmp9 = icmp ugt i32 %12, -2147483648, !dbg !2542
  br i1 %cmp9, label %if.then10, label %if.end11, !dbg !2541

if.then10:                                        ; preds = %if.else
  %13 = load i32, i32* %result, align 4, !dbg !2543
  %inc = add i32 %13, 1, !dbg !2543
  store i32 %inc, i32* %result, align 4, !dbg !2543
  br label %if.end11, !dbg !2544

if.end11:                                         ; preds = %if.then10, %if.else
  %14 = load i32, i32* %round, align 4, !dbg !2545
  %cmp12 = icmp eq i32 %14, -2147483648, !dbg !2546
  br i1 %cmp12, label %if.then13, label %if.end14, !dbg !2545

if.then13:                                        ; preds = %if.end11
  %15 = load i32, i32* %result, align 4, !dbg !2547
  %and = and i32 %15, 1, !dbg !2548
  %16 = load i32, i32* %result, align 4, !dbg !2549
  %add = add i32 %16, %and, !dbg !2549
  store i32 %add, i32* %result, align 4, !dbg !2549
  br label %if.end14, !dbg !2550

if.end14:                                         ; preds = %if.then13, %if.end11
  br label %if.end15

if.end15:                                         ; preds = %if.end14, %if.then2
  %17 = load i32, i32* %exponent, align 4, !dbg !2551
  %add16 = add nsw i32 %17, 127, !dbg !2552
  %shl17 = shl i32 %add16, 23, !dbg !2553
  %18 = load i32, i32* %result, align 4, !dbg !2554
  %add18 = add i32 %18, %shl17, !dbg !2554
  store i32 %add18, i32* %result, align 4, !dbg !2554
  %19 = load i32, i32* %result, align 4, !dbg !2555
  %call19 = call arm_aapcs_vfpcc float @fromRep.32(i32 %19) #4, !dbg !2556
  store float %call19, float* %retval, align 4, !dbg !2557
  br label %return, !dbg !2557

return:                                           ; preds = %if.end15, %if.then
  %20 = load float, float* %retval, align 4, !dbg !2558
  ret float %20, !dbg !2558
}

; Function Attrs: noinline nounwind
define internal arm_aapcs_vfpcc float @fromRep.32(i32 %x) #0 !dbg !2559 {
entry:
  %x.addr = alloca i32, align 4
  %rep = alloca %union.anon.0.0, align 4
  store i32 %x, i32* %x.addr, align 4
  %i = bitcast %union.anon.0.0* %rep to i32*, !dbg !2560
  %0 = load i32, i32* %x.addr, align 4, !dbg !2561
  store i32 %0, i32* %i, align 4, !dbg !2560
  %f = bitcast %union.anon.0.0* %rep to float*, !dbg !2562
  %1 = load float, float* %f, align 4, !dbg !2562
  ret float %1, !dbg !2563
}

; Function Attrs: noinline noreturn nounwind
define weak hidden arm_aapcs_vfpcc void @compilerrt_abort_impl(i8* %file, i32 %line, i8* %function) #3 !dbg !2564 {
entry:
  %file.addr = alloca i8*, align 4
  %line.addr = alloca i32, align 4
  %function.addr = alloca i8*, align 4
  store i8* %file, i8** %file.addr, align 4
  store i32 %line, i32* %line.addr, align 4
  store i8* %function, i8** %function.addr, align 4
  unreachable, !dbg !2565
}

; Function Attrs: noinline nounwind
define dso_local arm_aapcscc double @__muldf3(double %a, double %b) #0 !dbg !2566 {
entry:
  %a.addr = alloca double, align 8
  %b.addr = alloca double, align 8
  store double %a, double* %a.addr, align 8
  store double %b, double* %b.addr, align 8
  %0 = load double, double* %a.addr, align 8, !dbg !2567
  %1 = load double, double* %b.addr, align 8, !dbg !2568
  %call = call arm_aapcs_vfpcc double @__mulXf3__(double %0, double %1) #4, !dbg !2569
  ret double %call, !dbg !2570
}

; Function Attrs: noinline nounwind
define internal arm_aapcs_vfpcc double @__mulXf3__(double %a, double %b) #0 !dbg !2571 {
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
  %0 = load double, double* %a.addr, align 8, !dbg !2573
  %call = call arm_aapcs_vfpcc i64 @toRep.33(double %0) #4, !dbg !2574
  %shr = lshr i64 %call, 52, !dbg !2575
  %and = and i64 %shr, 2047, !dbg !2576
  %conv = trunc i64 %and to i32, !dbg !2574
  store i32 %conv, i32* %aExponent, align 4, !dbg !2577
  %1 = load double, double* %b.addr, align 8, !dbg !2578
  %call1 = call arm_aapcs_vfpcc i64 @toRep.33(double %1) #4, !dbg !2579
  %shr2 = lshr i64 %call1, 52, !dbg !2580
  %and3 = and i64 %shr2, 2047, !dbg !2581
  %conv4 = trunc i64 %and3 to i32, !dbg !2579
  store i32 %conv4, i32* %bExponent, align 4, !dbg !2582
  %2 = load double, double* %a.addr, align 8, !dbg !2583
  %call5 = call arm_aapcs_vfpcc i64 @toRep.33(double %2) #4, !dbg !2584
  %3 = load double, double* %b.addr, align 8, !dbg !2585
  %call6 = call arm_aapcs_vfpcc i64 @toRep.33(double %3) #4, !dbg !2586
  %xor = xor i64 %call5, %call6, !dbg !2587
  %and7 = and i64 %xor, -9223372036854775808, !dbg !2588
  store i64 %and7, i64* %productSign, align 8, !dbg !2589
  %4 = load double, double* %a.addr, align 8, !dbg !2590
  %call8 = call arm_aapcs_vfpcc i64 @toRep.33(double %4) #4, !dbg !2591
  %and9 = and i64 %call8, 4503599627370495, !dbg !2592
  store i64 %and9, i64* %aSignificand, align 8, !dbg !2593
  %5 = load double, double* %b.addr, align 8, !dbg !2594
  %call10 = call arm_aapcs_vfpcc i64 @toRep.33(double %5) #4, !dbg !2595
  %and11 = and i64 %call10, 4503599627370495, !dbg !2596
  store i64 %and11, i64* %bSignificand, align 8, !dbg !2597
  store i32 0, i32* %scale, align 4, !dbg !2598
  %6 = load i32, i32* %aExponent, align 4, !dbg !2599
  %sub = sub i32 %6, 1, !dbg !2600
  %cmp = icmp uge i32 %sub, 2046, !dbg !2601
  br i1 %cmp, label %if.then, label %lor.lhs.false, !dbg !2602

lor.lhs.false:                                    ; preds = %entry
  %7 = load i32, i32* %bExponent, align 4, !dbg !2603
  %sub13 = sub i32 %7, 1, !dbg !2604
  %cmp14 = icmp uge i32 %sub13, 2046, !dbg !2605
  br i1 %cmp14, label %if.then, label %if.end69, !dbg !2599

if.then:                                          ; preds = %lor.lhs.false, %entry
  %8 = load double, double* %a.addr, align 8, !dbg !2606
  %call16 = call arm_aapcs_vfpcc i64 @toRep.33(double %8) #4, !dbg !2607
  %and17 = and i64 %call16, 9223372036854775807, !dbg !2608
  store i64 %and17, i64* %aAbs, align 8, !dbg !2609
  %9 = load double, double* %b.addr, align 8, !dbg !2610
  %call18 = call arm_aapcs_vfpcc i64 @toRep.33(double %9) #4, !dbg !2611
  %and19 = and i64 %call18, 9223372036854775807, !dbg !2612
  store i64 %and19, i64* %bAbs, align 8, !dbg !2613
  %10 = load i64, i64* %aAbs, align 8, !dbg !2614
  %cmp20 = icmp ugt i64 %10, 9218868437227405312, !dbg !2615
  br i1 %cmp20, label %if.then22, label %if.end, !dbg !2614

if.then22:                                        ; preds = %if.then
  %11 = load double, double* %a.addr, align 8, !dbg !2616
  %call23 = call arm_aapcs_vfpcc i64 @toRep.33(double %11) #4, !dbg !2617
  %or = or i64 %call23, 2251799813685248, !dbg !2618
  %call24 = call arm_aapcs_vfpcc double @fromRep.34(i64 %or) #4, !dbg !2619
  store double %call24, double* %retval, align 8, !dbg !2620
  br label %return, !dbg !2620

if.end:                                           ; preds = %if.then
  %12 = load i64, i64* %bAbs, align 8, !dbg !2621
  %cmp25 = icmp ugt i64 %12, 9218868437227405312, !dbg !2622
  br i1 %cmp25, label %if.then27, label %if.end31, !dbg !2621

if.then27:                                        ; preds = %if.end
  %13 = load double, double* %b.addr, align 8, !dbg !2623
  %call28 = call arm_aapcs_vfpcc i64 @toRep.33(double %13) #4, !dbg !2624
  %or29 = or i64 %call28, 2251799813685248, !dbg !2625
  %call30 = call arm_aapcs_vfpcc double @fromRep.34(i64 %or29) #4, !dbg !2626
  store double %call30, double* %retval, align 8, !dbg !2627
  br label %return, !dbg !2627

if.end31:                                         ; preds = %if.end
  %14 = load i64, i64* %aAbs, align 8, !dbg !2628
  %cmp32 = icmp eq i64 %14, 9218868437227405312, !dbg !2629
  br i1 %cmp32, label %if.then34, label %if.end39, !dbg !2628

if.then34:                                        ; preds = %if.end31
  %15 = load i64, i64* %bAbs, align 8, !dbg !2630
  %tobool = icmp ne i64 %15, 0, !dbg !2630
  br i1 %tobool, label %if.then35, label %if.else, !dbg !2630

if.then35:                                        ; preds = %if.then34
  %16 = load i64, i64* %aAbs, align 8, !dbg !2631
  %17 = load i64, i64* %productSign, align 8, !dbg !2632
  %or36 = or i64 %16, %17, !dbg !2633
  %call37 = call arm_aapcs_vfpcc double @fromRep.34(i64 %or36) #4, !dbg !2634
  store double %call37, double* %retval, align 8, !dbg !2635
  br label %return, !dbg !2635

if.else:                                          ; preds = %if.then34
  %call38 = call arm_aapcs_vfpcc double @fromRep.34(i64 9221120237041090560) #4, !dbg !2636
  store double %call38, double* %retval, align 8, !dbg !2637
  br label %return, !dbg !2637

if.end39:                                         ; preds = %if.end31
  %18 = load i64, i64* %bAbs, align 8, !dbg !2638
  %cmp40 = icmp eq i64 %18, 9218868437227405312, !dbg !2639
  br i1 %cmp40, label %if.then42, label %if.end49, !dbg !2638

if.then42:                                        ; preds = %if.end39
  %19 = load i64, i64* %aAbs, align 8, !dbg !2640
  %tobool43 = icmp ne i64 %19, 0, !dbg !2640
  br i1 %tobool43, label %if.then44, label %if.else47, !dbg !2640

if.then44:                                        ; preds = %if.then42
  %20 = load i64, i64* %bAbs, align 8, !dbg !2641
  %21 = load i64, i64* %productSign, align 8, !dbg !2642
  %or45 = or i64 %20, %21, !dbg !2643
  %call46 = call arm_aapcs_vfpcc double @fromRep.34(i64 %or45) #4, !dbg !2644
  store double %call46, double* %retval, align 8, !dbg !2645
  br label %return, !dbg !2645

if.else47:                                        ; preds = %if.then42
  %call48 = call arm_aapcs_vfpcc double @fromRep.34(i64 9221120237041090560) #4, !dbg !2646
  store double %call48, double* %retval, align 8, !dbg !2647
  br label %return, !dbg !2647

if.end49:                                         ; preds = %if.end39
  %22 = load i64, i64* %aAbs, align 8, !dbg !2648
  %tobool50 = icmp ne i64 %22, 0, !dbg !2648
  br i1 %tobool50, label %if.end53, label %if.then51, !dbg !2649

if.then51:                                        ; preds = %if.end49
  %23 = load i64, i64* %productSign, align 8, !dbg !2650
  %call52 = call arm_aapcs_vfpcc double @fromRep.34(i64 %23) #4, !dbg !2651
  store double %call52, double* %retval, align 8, !dbg !2652
  br label %return, !dbg !2652

if.end53:                                         ; preds = %if.end49
  %24 = load i64, i64* %bAbs, align 8, !dbg !2653
  %tobool54 = icmp ne i64 %24, 0, !dbg !2653
  br i1 %tobool54, label %if.end57, label %if.then55, !dbg !2654

if.then55:                                        ; preds = %if.end53
  %25 = load i64, i64* %productSign, align 8, !dbg !2655
  %call56 = call arm_aapcs_vfpcc double @fromRep.34(i64 %25) #4, !dbg !2656
  store double %call56, double* %retval, align 8, !dbg !2657
  br label %return, !dbg !2657

if.end57:                                         ; preds = %if.end53
  %26 = load i64, i64* %aAbs, align 8, !dbg !2658
  %cmp58 = icmp ult i64 %26, 4503599627370496, !dbg !2659
  br i1 %cmp58, label %if.then60, label %if.end62, !dbg !2658

if.then60:                                        ; preds = %if.end57
  %call61 = call arm_aapcs_vfpcc i32 @normalize.35(i64* %aSignificand) #4, !dbg !2660
  %27 = load i32, i32* %scale, align 4, !dbg !2661
  %add = add nsw i32 %27, %call61, !dbg !2661
  store i32 %add, i32* %scale, align 4, !dbg !2661
  br label %if.end62, !dbg !2662

if.end62:                                         ; preds = %if.then60, %if.end57
  %28 = load i64, i64* %bAbs, align 8, !dbg !2663
  %cmp63 = icmp ult i64 %28, 4503599627370496, !dbg !2664
  br i1 %cmp63, label %if.then65, label %if.end68, !dbg !2663

if.then65:                                        ; preds = %if.end62
  %call66 = call arm_aapcs_vfpcc i32 @normalize.35(i64* %bSignificand) #4, !dbg !2665
  %29 = load i32, i32* %scale, align 4, !dbg !2666
  %add67 = add nsw i32 %29, %call66, !dbg !2666
  store i32 %add67, i32* %scale, align 4, !dbg !2666
  br label %if.end68, !dbg !2667

if.end68:                                         ; preds = %if.then65, %if.end62
  br label %if.end69, !dbg !2668

if.end69:                                         ; preds = %if.end68, %lor.lhs.false
  %30 = load i64, i64* %aSignificand, align 8, !dbg !2669
  %or70 = or i64 %30, 4503599627370496, !dbg !2669
  store i64 %or70, i64* %aSignificand, align 8, !dbg !2669
  %31 = load i64, i64* %bSignificand, align 8, !dbg !2670
  %or71 = or i64 %31, 4503599627370496, !dbg !2670
  store i64 %or71, i64* %bSignificand, align 8, !dbg !2670
  %32 = load i64, i64* %aSignificand, align 8, !dbg !2671
  %33 = load i64, i64* %bSignificand, align 8, !dbg !2672
  %shl = shl i64 %33, 11, !dbg !2673
  call arm_aapcs_vfpcc void @wideMultiply.36(i64 %32, i64 %shl, i64* %productHi, i64* %productLo) #4, !dbg !2674
  %34 = load i32, i32* %aExponent, align 4, !dbg !2675
  %35 = load i32, i32* %bExponent, align 4, !dbg !2676
  %add72 = add i32 %34, %35, !dbg !2677
  %sub73 = sub i32 %add72, 1023, !dbg !2678
  %36 = load i32, i32* %scale, align 4, !dbg !2679
  %add74 = add i32 %sub73, %36, !dbg !2680
  store i32 %add74, i32* %productExponent, align 4, !dbg !2681
  %37 = load i64, i64* %productHi, align 8, !dbg !2682
  %and75 = and i64 %37, 4503599627370496, !dbg !2683
  %tobool76 = icmp ne i64 %and75, 0, !dbg !2683
  br i1 %tobool76, label %if.then77, label %if.else78, !dbg !2682

if.then77:                                        ; preds = %if.end69
  %38 = load i32, i32* %productExponent, align 4, !dbg !2684
  %inc = add nsw i32 %38, 1, !dbg !2684
  store i32 %inc, i32* %productExponent, align 4, !dbg !2684
  br label %if.end79, !dbg !2685

if.else78:                                        ; preds = %if.end69
  call arm_aapcs_vfpcc void @wideLeftShift(i64* %productHi, i64* %productLo, i32 1) #4, !dbg !2686
  br label %if.end79

if.end79:                                         ; preds = %if.else78, %if.then77
  %39 = load i32, i32* %productExponent, align 4, !dbg !2687
  %cmp80 = icmp sge i32 %39, 2047, !dbg !2688
  br i1 %cmp80, label %if.then82, label %if.end85, !dbg !2687

if.then82:                                        ; preds = %if.end79
  %40 = load i64, i64* %productSign, align 8, !dbg !2689
  %or83 = or i64 9218868437227405312, %40, !dbg !2690
  %call84 = call arm_aapcs_vfpcc double @fromRep.34(i64 %or83) #4, !dbg !2691
  store double %call84, double* %retval, align 8, !dbg !2692
  br label %return, !dbg !2692

if.end85:                                         ; preds = %if.end79
  %41 = load i32, i32* %productExponent, align 4, !dbg !2693
  %cmp86 = icmp sle i32 %41, 0, !dbg !2694
  br i1 %cmp86, label %if.then88, label %if.else97, !dbg !2693

if.then88:                                        ; preds = %if.end85
  %42 = load i32, i32* %productExponent, align 4, !dbg !2695
  %conv89 = zext i32 %42 to i64, !dbg !2696
  %sub90 = sub i64 1, %conv89, !dbg !2697
  %conv91 = trunc i64 %sub90 to i32, !dbg !2698
  store i32 %conv91, i32* %shift, align 4, !dbg !2699
  %43 = load i32, i32* %shift, align 4, !dbg !2700
  %cmp92 = icmp uge i32 %43, 64, !dbg !2701
  br i1 %cmp92, label %if.then94, label %if.end96, !dbg !2700

if.then94:                                        ; preds = %if.then88
  %44 = load i64, i64* %productSign, align 8, !dbg !2702
  %call95 = call arm_aapcs_vfpcc double @fromRep.34(i64 %44) #4, !dbg !2703
  store double %call95, double* %retval, align 8, !dbg !2704
  br label %return, !dbg !2704

if.end96:                                         ; preds = %if.then88
  %45 = load i32, i32* %shift, align 4, !dbg !2705
  call arm_aapcs_vfpcc void @wideRightShiftWithSticky(i64* %productHi, i64* %productLo, i32 %45) #4, !dbg !2706
  br label %if.end102, !dbg !2707

if.else97:                                        ; preds = %if.end85
  %46 = load i64, i64* %productHi, align 8, !dbg !2708
  %and98 = and i64 %46, 4503599627370495, !dbg !2708
  store i64 %and98, i64* %productHi, align 8, !dbg !2708
  %47 = load i32, i32* %productExponent, align 4, !dbg !2709
  %conv99 = sext i32 %47 to i64, !dbg !2710
  %shl100 = shl i64 %conv99, 52, !dbg !2711
  %48 = load i64, i64* %productHi, align 8, !dbg !2712
  %or101 = or i64 %48, %shl100, !dbg !2712
  store i64 %or101, i64* %productHi, align 8, !dbg !2712
  br label %if.end102

if.end102:                                        ; preds = %if.else97, %if.end96
  %49 = load i64, i64* %productSign, align 8, !dbg !2713
  %50 = load i64, i64* %productHi, align 8, !dbg !2714
  %or103 = or i64 %50, %49, !dbg !2714
  store i64 %or103, i64* %productHi, align 8, !dbg !2714
  %51 = load i64, i64* %productLo, align 8, !dbg !2715
  %cmp104 = icmp ugt i64 %51, -9223372036854775808, !dbg !2716
  br i1 %cmp104, label %if.then106, label %if.end108, !dbg !2715

if.then106:                                       ; preds = %if.end102
  %52 = load i64, i64* %productHi, align 8, !dbg !2717
  %inc107 = add i64 %52, 1, !dbg !2717
  store i64 %inc107, i64* %productHi, align 8, !dbg !2717
  br label %if.end108, !dbg !2718

if.end108:                                        ; preds = %if.then106, %if.end102
  %53 = load i64, i64* %productLo, align 8, !dbg !2719
  %cmp109 = icmp eq i64 %53, -9223372036854775808, !dbg !2720
  br i1 %cmp109, label %if.then111, label %if.end114, !dbg !2719

if.then111:                                       ; preds = %if.end108
  %54 = load i64, i64* %productHi, align 8, !dbg !2721
  %and112 = and i64 %54, 1, !dbg !2722
  %55 = load i64, i64* %productHi, align 8, !dbg !2723
  %add113 = add i64 %55, %and112, !dbg !2723
  store i64 %add113, i64* %productHi, align 8, !dbg !2723
  br label %if.end114, !dbg !2724

if.end114:                                        ; preds = %if.then111, %if.end108
  %56 = load i64, i64* %productHi, align 8, !dbg !2725
  %call115 = call arm_aapcs_vfpcc double @fromRep.34(i64 %56) #4, !dbg !2726
  store double %call115, double* %retval, align 8, !dbg !2727
  br label %return, !dbg !2727

return:                                           ; preds = %if.end114, %if.then94, %if.then82, %if.then55, %if.then51, %if.else47, %if.then44, %if.else, %if.then35, %if.then27, %if.then22
  %57 = load double, double* %retval, align 8, !dbg !2728
  ret double %57, !dbg !2728
}

; Function Attrs: noinline nounwind
define internal arm_aapcs_vfpcc i64 @toRep.33(double %x) #0 !dbg !2729 {
entry:
  %x.addr = alloca double, align 8
  %rep = alloca %union.anon.0, align 8
  store double %x, double* %x.addr, align 8
  %f = bitcast %union.anon.0* %rep to double*, !dbg !2730
  %0 = load double, double* %x.addr, align 8, !dbg !2731
  store double %0, double* %f, align 8, !dbg !2730
  %i = bitcast %union.anon.0* %rep to i64*, !dbg !2732
  %1 = load i64, i64* %i, align 8, !dbg !2732
  ret i64 %1, !dbg !2733
}

; Function Attrs: noinline nounwind
define internal arm_aapcs_vfpcc double @fromRep.34(i64 %x) #0 !dbg !2734 {
entry:
  %x.addr = alloca i64, align 8
  %rep = alloca %union.anon.0, align 8
  store i64 %x, i64* %x.addr, align 8
  %i = bitcast %union.anon.0* %rep to i64*, !dbg !2735
  %0 = load i64, i64* %x.addr, align 8, !dbg !2736
  store i64 %0, i64* %i, align 8, !dbg !2735
  %f = bitcast %union.anon.0* %rep to double*, !dbg !2737
  %1 = load double, double* %f, align 8, !dbg !2737
  ret double %1, !dbg !2738
}

; Function Attrs: noinline nounwind
define internal arm_aapcs_vfpcc i32 @normalize.35(i64* %significand) #0 !dbg !2739 {
entry:
  %significand.addr = alloca i64*, align 4
  %shift = alloca i32, align 4
  store i64* %significand, i64** %significand.addr, align 4
  %0 = load i64*, i64** %significand.addr, align 4, !dbg !2740
  %1 = load i64, i64* %0, align 8, !dbg !2741
  %call = call arm_aapcs_vfpcc i32 @rep_clz.37(i64 %1) #4, !dbg !2742
  %call1 = call arm_aapcs_vfpcc i32 @rep_clz.37(i64 4503599627370496) #4, !dbg !2743
  %sub = sub nsw i32 %call, %call1, !dbg !2744
  store i32 %sub, i32* %shift, align 4, !dbg !2745
  %2 = load i32, i32* %shift, align 4, !dbg !2746
  %3 = load i64*, i64** %significand.addr, align 4, !dbg !2747
  %4 = load i64, i64* %3, align 8, !dbg !2748
  %sh_prom = zext i32 %2 to i64, !dbg !2748
  %shl = shl i64 %4, %sh_prom, !dbg !2748
  store i64 %shl, i64* %3, align 8, !dbg !2748
  %5 = load i32, i32* %shift, align 4, !dbg !2749
  %sub2 = sub nsw i32 1, %5, !dbg !2750
  ret i32 %sub2, !dbg !2751
}

; Function Attrs: noinline nounwind
define internal arm_aapcs_vfpcc void @wideMultiply.36(i64 %a, i64 %b, i64* %hi, i64* %lo) #0 !dbg !2752 {
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
  %0 = load i64, i64* %a.addr, align 8, !dbg !2753
  %and = and i64 %0, 4294967295, !dbg !2753
  %1 = load i64, i64* %b.addr, align 8, !dbg !2754
  %and1 = and i64 %1, 4294967295, !dbg !2754
  %mul = mul i64 %and, %and1, !dbg !2755
  store i64 %mul, i64* %plolo, align 8, !dbg !2756
  %2 = load i64, i64* %a.addr, align 8, !dbg !2757
  %and2 = and i64 %2, 4294967295, !dbg !2757
  %3 = load i64, i64* %b.addr, align 8, !dbg !2758
  %shr = lshr i64 %3, 32, !dbg !2758
  %mul3 = mul i64 %and2, %shr, !dbg !2759
  store i64 %mul3, i64* %plohi, align 8, !dbg !2760
  %4 = load i64, i64* %a.addr, align 8, !dbg !2761
  %shr4 = lshr i64 %4, 32, !dbg !2761
  %5 = load i64, i64* %b.addr, align 8, !dbg !2762
  %and5 = and i64 %5, 4294967295, !dbg !2762
  %mul6 = mul i64 %shr4, %and5, !dbg !2763
  store i64 %mul6, i64* %philo, align 8, !dbg !2764
  %6 = load i64, i64* %a.addr, align 8, !dbg !2765
  %shr7 = lshr i64 %6, 32, !dbg !2765
  %7 = load i64, i64* %b.addr, align 8, !dbg !2766
  %shr8 = lshr i64 %7, 32, !dbg !2766
  %mul9 = mul i64 %shr7, %shr8, !dbg !2767
  store i64 %mul9, i64* %phihi, align 8, !dbg !2768
  %8 = load i64, i64* %plolo, align 8, !dbg !2769
  %and10 = and i64 %8, 4294967295, !dbg !2769
  store i64 %and10, i64* %r0, align 8, !dbg !2770
  %9 = load i64, i64* %plolo, align 8, !dbg !2771
  %shr11 = lshr i64 %9, 32, !dbg !2771
  %10 = load i64, i64* %plohi, align 8, !dbg !2772
  %and12 = and i64 %10, 4294967295, !dbg !2772
  %add = add i64 %shr11, %and12, !dbg !2773
  %11 = load i64, i64* %philo, align 8, !dbg !2774
  %and13 = and i64 %11, 4294967295, !dbg !2774
  %add14 = add i64 %add, %and13, !dbg !2775
  store i64 %add14, i64* %r1, align 8, !dbg !2776
  %12 = load i64, i64* %r0, align 8, !dbg !2777
  %13 = load i64, i64* %r1, align 8, !dbg !2778
  %shl = shl i64 %13, 32, !dbg !2779
  %add15 = add i64 %12, %shl, !dbg !2780
  %14 = load i64*, i64** %lo.addr, align 4, !dbg !2781
  store i64 %add15, i64* %14, align 8, !dbg !2782
  %15 = load i64, i64* %plohi, align 8, !dbg !2783
  %shr16 = lshr i64 %15, 32, !dbg !2783
  %16 = load i64, i64* %philo, align 8, !dbg !2784
  %shr17 = lshr i64 %16, 32, !dbg !2784
  %add18 = add i64 %shr16, %shr17, !dbg !2785
  %17 = load i64, i64* %r1, align 8, !dbg !2786
  %shr19 = lshr i64 %17, 32, !dbg !2786
  %add20 = add i64 %add18, %shr19, !dbg !2787
  %18 = load i64, i64* %phihi, align 8, !dbg !2788
  %add21 = add i64 %add20, %18, !dbg !2789
  %19 = load i64*, i64** %hi.addr, align 4, !dbg !2790
  store i64 %add21, i64* %19, align 8, !dbg !2791
  ret void, !dbg !2792
}

; Function Attrs: noinline nounwind
define internal arm_aapcs_vfpcc void @wideLeftShift(i64* %hi, i64* %lo, i32 %count) #0 !dbg !2793 {
entry:
  %hi.addr = alloca i64*, align 4
  %lo.addr = alloca i64*, align 4
  %count.addr = alloca i32, align 4
  store i64* %hi, i64** %hi.addr, align 4
  store i64* %lo, i64** %lo.addr, align 4
  store i32 %count, i32* %count.addr, align 4
  %0 = load i64*, i64** %hi.addr, align 4, !dbg !2794
  %1 = load i64, i64* %0, align 8, !dbg !2795
  %2 = load i32, i32* %count.addr, align 4, !dbg !2796
  %sh_prom = zext i32 %2 to i64, !dbg !2797
  %shl = shl i64 %1, %sh_prom, !dbg !2797
  %3 = load i64*, i64** %lo.addr, align 4, !dbg !2798
  %4 = load i64, i64* %3, align 8, !dbg !2799
  %5 = load i32, i32* %count.addr, align 4, !dbg !2800
  %sub = sub i32 64, %5, !dbg !2801
  %sh_prom1 = zext i32 %sub to i64, !dbg !2802
  %shr = lshr i64 %4, %sh_prom1, !dbg !2802
  %or = or i64 %shl, %shr, !dbg !2803
  %6 = load i64*, i64** %hi.addr, align 4, !dbg !2804
  store i64 %or, i64* %6, align 8, !dbg !2805
  %7 = load i64*, i64** %lo.addr, align 4, !dbg !2806
  %8 = load i64, i64* %7, align 8, !dbg !2807
  %9 = load i32, i32* %count.addr, align 4, !dbg !2808
  %sh_prom2 = zext i32 %9 to i64, !dbg !2809
  %shl3 = shl i64 %8, %sh_prom2, !dbg !2809
  %10 = load i64*, i64** %lo.addr, align 4, !dbg !2810
  store i64 %shl3, i64* %10, align 8, !dbg !2811
  ret void, !dbg !2812
}

; Function Attrs: noinline nounwind
define internal arm_aapcs_vfpcc void @wideRightShiftWithSticky(i64* %hi, i64* %lo, i32 %count) #0 !dbg !2813 {
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
  %0 = load i32, i32* %count.addr, align 4, !dbg !2814
  %cmp = icmp ult i32 %0, 64, !dbg !2815
  br i1 %cmp, label %if.then, label %if.else, !dbg !2814

if.then:                                          ; preds = %entry
  %1 = load i64*, i64** %lo.addr, align 4, !dbg !2816
  %2 = load i64, i64* %1, align 8, !dbg !2817
  %3 = load i32, i32* %count.addr, align 4, !dbg !2818
  %sub = sub i32 64, %3, !dbg !2819
  %sh_prom = zext i32 %sub to i64, !dbg !2820
  %shl = shl i64 %2, %sh_prom, !dbg !2820
  %tobool = icmp ne i64 %shl, 0, !dbg !2817
  %frombool = zext i1 %tobool to i8, !dbg !2821
  store i8 %frombool, i8* %sticky, align 1, !dbg !2821
  %4 = load i64*, i64** %hi.addr, align 4, !dbg !2822
  %5 = load i64, i64* %4, align 8, !dbg !2823
  %6 = load i32, i32* %count.addr, align 4, !dbg !2824
  %sub1 = sub i32 64, %6, !dbg !2825
  %sh_prom2 = zext i32 %sub1 to i64, !dbg !2826
  %shl3 = shl i64 %5, %sh_prom2, !dbg !2826
  %7 = load i64*, i64** %lo.addr, align 4, !dbg !2827
  %8 = load i64, i64* %7, align 8, !dbg !2828
  %9 = load i32, i32* %count.addr, align 4, !dbg !2829
  %sh_prom4 = zext i32 %9 to i64, !dbg !2830
  %shr = lshr i64 %8, %sh_prom4, !dbg !2830
  %or = or i64 %shl3, %shr, !dbg !2831
  %10 = load i8, i8* %sticky, align 1, !dbg !2832
  %tobool5 = trunc i8 %10 to i1, !dbg !2832
  %conv = zext i1 %tobool5 to i64, !dbg !2832
  %or6 = or i64 %or, %conv, !dbg !2833
  %11 = load i64*, i64** %lo.addr, align 4, !dbg !2834
  store i64 %or6, i64* %11, align 8, !dbg !2835
  %12 = load i64*, i64** %hi.addr, align 4, !dbg !2836
  %13 = load i64, i64* %12, align 8, !dbg !2837
  %14 = load i32, i32* %count.addr, align 4, !dbg !2838
  %sh_prom7 = zext i32 %14 to i64, !dbg !2839
  %shr8 = lshr i64 %13, %sh_prom7, !dbg !2839
  %15 = load i64*, i64** %hi.addr, align 4, !dbg !2840
  store i64 %shr8, i64* %15, align 8, !dbg !2841
  br label %if.end32, !dbg !2842

if.else:                                          ; preds = %entry
  %16 = load i32, i32* %count.addr, align 4, !dbg !2843
  %cmp9 = icmp ult i32 %16, 128, !dbg !2844
  br i1 %cmp9, label %if.then11, label %if.else25, !dbg !2843

if.then11:                                        ; preds = %if.else
  %17 = load i64*, i64** %hi.addr, align 4, !dbg !2845
  %18 = load i64, i64* %17, align 8, !dbg !2846
  %19 = load i32, i32* %count.addr, align 4, !dbg !2847
  %sub13 = sub i32 128, %19, !dbg !2848
  %sh_prom14 = zext i32 %sub13 to i64, !dbg !2849
  %shl15 = shl i64 %18, %sh_prom14, !dbg !2849
  %20 = load i64*, i64** %lo.addr, align 4, !dbg !2850
  %21 = load i64, i64* %20, align 8, !dbg !2851
  %or16 = or i64 %shl15, %21, !dbg !2852
  %tobool17 = icmp ne i64 %or16, 0, !dbg !2846
  %frombool18 = zext i1 %tobool17 to i8, !dbg !2853
  store i8 %frombool18, i8* %sticky12, align 1, !dbg !2853
  %22 = load i64*, i64** %hi.addr, align 4, !dbg !2854
  %23 = load i64, i64* %22, align 8, !dbg !2855
  %24 = load i32, i32* %count.addr, align 4, !dbg !2856
  %sub19 = sub i32 %24, 64, !dbg !2857
  %sh_prom20 = zext i32 %sub19 to i64, !dbg !2858
  %shr21 = lshr i64 %23, %sh_prom20, !dbg !2858
  %25 = load i8, i8* %sticky12, align 1, !dbg !2859
  %tobool22 = trunc i8 %25 to i1, !dbg !2859
  %conv23 = zext i1 %tobool22 to i64, !dbg !2859
  %or24 = or i64 %shr21, %conv23, !dbg !2860
  %26 = load i64*, i64** %lo.addr, align 4, !dbg !2861
  store i64 %or24, i64* %26, align 8, !dbg !2862
  %27 = load i64*, i64** %hi.addr, align 4, !dbg !2863
  store i64 0, i64* %27, align 8, !dbg !2864
  br label %if.end, !dbg !2865

if.else25:                                        ; preds = %if.else
  %28 = load i64*, i64** %hi.addr, align 4, !dbg !2866
  %29 = load i64, i64* %28, align 8, !dbg !2867
  %30 = load i64*, i64** %lo.addr, align 4, !dbg !2868
  %31 = load i64, i64* %30, align 8, !dbg !2869
  %or27 = or i64 %29, %31, !dbg !2870
  %tobool28 = icmp ne i64 %or27, 0, !dbg !2867
  %frombool29 = zext i1 %tobool28 to i8, !dbg !2871
  store i8 %frombool29, i8* %sticky26, align 1, !dbg !2871
  %32 = load i8, i8* %sticky26, align 1, !dbg !2872
  %tobool30 = trunc i8 %32 to i1, !dbg !2872
  %conv31 = zext i1 %tobool30 to i64, !dbg !2872
  %33 = load i64*, i64** %lo.addr, align 4, !dbg !2873
  store i64 %conv31, i64* %33, align 8, !dbg !2874
  %34 = load i64*, i64** %hi.addr, align 4, !dbg !2875
  store i64 0, i64* %34, align 8, !dbg !2876
  br label %if.end

if.end:                                           ; preds = %if.else25, %if.then11
  br label %if.end32

if.end32:                                         ; preds = %if.end, %if.then
  ret void, !dbg !2877
}

; Function Attrs: noinline nounwind
define internal arm_aapcs_vfpcc i32 @rep_clz.37(i64 %a) #0 !dbg !2878 {
entry:
  %retval = alloca i32, align 4
  %a.addr = alloca i64, align 8
  store i64 %a, i64* %a.addr, align 8
  %0 = load i64, i64* %a.addr, align 8, !dbg !2879
  %and = and i64 %0, -4294967296, !dbg !2880
  %tobool = icmp ne i64 %and, 0, !dbg !2880
  br i1 %tobool, label %if.then, label %if.else, !dbg !2879

if.then:                                          ; preds = %entry
  %1 = load i64, i64* %a.addr, align 8, !dbg !2881
  %shr = lshr i64 %1, 32, !dbg !2882
  %conv = trunc i64 %shr to i32, !dbg !2881
  %2 = call i32 @llvm.ctlz.i32(i32 %conv, i1 false), !dbg !2883
  store i32 %2, i32* %retval, align 4, !dbg !2884
  br label %return, !dbg !2884

if.else:                                          ; preds = %entry
  %3 = load i64, i64* %a.addr, align 8, !dbg !2885
  %and1 = and i64 %3, 4294967295, !dbg !2886
  %conv2 = trunc i64 %and1 to i32, !dbg !2885
  %4 = call i32 @llvm.ctlz.i32(i32 %conv2, i1 false), !dbg !2887
  %add = add nsw i32 32, %4, !dbg !2888
  store i32 %add, i32* %retval, align 4, !dbg !2889
  br label %return, !dbg !2889

return:                                           ; preds = %if.else, %if.then
  %5 = load i32, i32* %retval, align 4, !dbg !2890
  ret i32 %5, !dbg !2890
}

; Function Attrs: noinline nounwind
define dso_local arm_aapcscc i64 @__muldi3(i64 %a, i64 %b) #0 !dbg !2891 {
entry:
  %a.addr = alloca i64, align 8
  %b.addr = alloca i64, align 8
  %x = alloca %union.udwords, align 8
  %y = alloca %union.udwords, align 8
  %r = alloca %union.udwords, align 8
  store i64 %a, i64* %a.addr, align 8
  store i64 %b, i64* %b.addr, align 8
  %0 = load i64, i64* %a.addr, align 8, !dbg !2892
  %all = bitcast %union.udwords* %x to i64*, !dbg !2893
  store i64 %0, i64* %all, align 8, !dbg !2894
  %1 = load i64, i64* %b.addr, align 8, !dbg !2895
  %all1 = bitcast %union.udwords* %y to i64*, !dbg !2896
  store i64 %1, i64* %all1, align 8, !dbg !2897
  %s = bitcast %union.udwords* %x to %struct.anon*, !dbg !2898
  %low = getelementptr inbounds %struct.anon, %struct.anon* %s, i32 0, i32 0, !dbg !2899
  %2 = load i32, i32* %low, align 8, !dbg !2899
  %s2 = bitcast %union.udwords* %y to %struct.anon*, !dbg !2900
  %low3 = getelementptr inbounds %struct.anon, %struct.anon* %s2, i32 0, i32 0, !dbg !2901
  %3 = load i32, i32* %low3, align 8, !dbg !2901
  %call = call arm_aapcs_vfpcc i64 @__muldsi3(i32 %2, i32 %3) #4, !dbg !2902
  %all4 = bitcast %union.udwords* %r to i64*, !dbg !2903
  store i64 %call, i64* %all4, align 8, !dbg !2904
  %s5 = bitcast %union.udwords* %x to %struct.anon*, !dbg !2905
  %high = getelementptr inbounds %struct.anon, %struct.anon* %s5, i32 0, i32 1, !dbg !2906
  %4 = load i32, i32* %high, align 4, !dbg !2906
  %s6 = bitcast %union.udwords* %y to %struct.anon*, !dbg !2907
  %low7 = getelementptr inbounds %struct.anon, %struct.anon* %s6, i32 0, i32 0, !dbg !2908
  %5 = load i32, i32* %low7, align 8, !dbg !2908
  %mul = mul i32 %4, %5, !dbg !2909
  %s8 = bitcast %union.udwords* %x to %struct.anon*, !dbg !2910
  %low9 = getelementptr inbounds %struct.anon, %struct.anon* %s8, i32 0, i32 0, !dbg !2911
  %6 = load i32, i32* %low9, align 8, !dbg !2911
  %s10 = bitcast %union.udwords* %y to %struct.anon*, !dbg !2912
  %high11 = getelementptr inbounds %struct.anon, %struct.anon* %s10, i32 0, i32 1, !dbg !2913
  %7 = load i32, i32* %high11, align 4, !dbg !2913
  %mul12 = mul i32 %6, %7, !dbg !2914
  %add = add i32 %mul, %mul12, !dbg !2915
  %s13 = bitcast %union.udwords* %r to %struct.anon*, !dbg !2916
  %high14 = getelementptr inbounds %struct.anon, %struct.anon* %s13, i32 0, i32 1, !dbg !2917
  %8 = load i32, i32* %high14, align 4, !dbg !2918
  %add15 = add i32 %8, %add, !dbg !2918
  store i32 %add15, i32* %high14, align 4, !dbg !2918
  %all16 = bitcast %union.udwords* %r to i64*, !dbg !2919
  %9 = load i64, i64* %all16, align 8, !dbg !2919
  ret i64 %9, !dbg !2920
}

; Function Attrs: noinline nounwind
define internal arm_aapcs_vfpcc i64 @__muldsi3(i32 %a, i32 %b) #0 !dbg !2921 {
entry:
  %a.addr = alloca i32, align 4
  %b.addr = alloca i32, align 4
  %r = alloca %union.udwords, align 8
  %bits_in_word_2 = alloca i32, align 4
  %lower_mask = alloca i32, align 4
  %t = alloca i32, align 4
  store i32 %a, i32* %a.addr, align 4
  store i32 %b, i32* %b.addr, align 4
  store i32 16, i32* %bits_in_word_2, align 4, !dbg !2922
  store i32 65535, i32* %lower_mask, align 4, !dbg !2923
  %0 = load i32, i32* %a.addr, align 4, !dbg !2924
  %and = and i32 %0, 65535, !dbg !2925
  %1 = load i32, i32* %b.addr, align 4, !dbg !2926
  %and1 = and i32 %1, 65535, !dbg !2927
  %mul = mul i32 %and, %and1, !dbg !2928
  %s = bitcast %union.udwords* %r to %struct.anon*, !dbg !2929
  %low = getelementptr inbounds %struct.anon, %struct.anon* %s, i32 0, i32 0, !dbg !2930
  store i32 %mul, i32* %low, align 8, !dbg !2931
  %s2 = bitcast %union.udwords* %r to %struct.anon*, !dbg !2932
  %low3 = getelementptr inbounds %struct.anon, %struct.anon* %s2, i32 0, i32 0, !dbg !2933
  %2 = load i32, i32* %low3, align 8, !dbg !2933
  %shr = lshr i32 %2, 16, !dbg !2934
  store i32 %shr, i32* %t, align 4, !dbg !2935
  %s4 = bitcast %union.udwords* %r to %struct.anon*, !dbg !2936
  %low5 = getelementptr inbounds %struct.anon, %struct.anon* %s4, i32 0, i32 0, !dbg !2937
  %3 = load i32, i32* %low5, align 8, !dbg !2938
  %and6 = and i32 %3, 65535, !dbg !2938
  store i32 %and6, i32* %low5, align 8, !dbg !2938
  %4 = load i32, i32* %a.addr, align 4, !dbg !2939
  %shr7 = lshr i32 %4, 16, !dbg !2940
  %5 = load i32, i32* %b.addr, align 4, !dbg !2941
  %and8 = and i32 %5, 65535, !dbg !2942
  %mul9 = mul i32 %shr7, %and8, !dbg !2943
  %6 = load i32, i32* %t, align 4, !dbg !2944
  %add = add i32 %6, %mul9, !dbg !2944
  store i32 %add, i32* %t, align 4, !dbg !2944
  %7 = load i32, i32* %t, align 4, !dbg !2945
  %and10 = and i32 %7, 65535, !dbg !2946
  %shl = shl i32 %and10, 16, !dbg !2947
  %s11 = bitcast %union.udwords* %r to %struct.anon*, !dbg !2948
  %low12 = getelementptr inbounds %struct.anon, %struct.anon* %s11, i32 0, i32 0, !dbg !2949
  %8 = load i32, i32* %low12, align 8, !dbg !2950
  %add13 = add i32 %8, %shl, !dbg !2950
  store i32 %add13, i32* %low12, align 8, !dbg !2950
  %9 = load i32, i32* %t, align 4, !dbg !2951
  %shr14 = lshr i32 %9, 16, !dbg !2952
  %s15 = bitcast %union.udwords* %r to %struct.anon*, !dbg !2953
  %high = getelementptr inbounds %struct.anon, %struct.anon* %s15, i32 0, i32 1, !dbg !2954
  store i32 %shr14, i32* %high, align 4, !dbg !2955
  %s16 = bitcast %union.udwords* %r to %struct.anon*, !dbg !2956
  %low17 = getelementptr inbounds %struct.anon, %struct.anon* %s16, i32 0, i32 0, !dbg !2957
  %10 = load i32, i32* %low17, align 8, !dbg !2957
  %shr18 = lshr i32 %10, 16, !dbg !2958
  store i32 %shr18, i32* %t, align 4, !dbg !2959
  %s19 = bitcast %union.udwords* %r to %struct.anon*, !dbg !2960
  %low20 = getelementptr inbounds %struct.anon, %struct.anon* %s19, i32 0, i32 0, !dbg !2961
  %11 = load i32, i32* %low20, align 8, !dbg !2962
  %and21 = and i32 %11, 65535, !dbg !2962
  store i32 %and21, i32* %low20, align 8, !dbg !2962
  %12 = load i32, i32* %b.addr, align 4, !dbg !2963
  %shr22 = lshr i32 %12, 16, !dbg !2964
  %13 = load i32, i32* %a.addr, align 4, !dbg !2965
  %and23 = and i32 %13, 65535, !dbg !2966
  %mul24 = mul i32 %shr22, %and23, !dbg !2967
  %14 = load i32, i32* %t, align 4, !dbg !2968
  %add25 = add i32 %14, %mul24, !dbg !2968
  store i32 %add25, i32* %t, align 4, !dbg !2968
  %15 = load i32, i32* %t, align 4, !dbg !2969
  %and26 = and i32 %15, 65535, !dbg !2970
  %shl27 = shl i32 %and26, 16, !dbg !2971
  %s28 = bitcast %union.udwords* %r to %struct.anon*, !dbg !2972
  %low29 = getelementptr inbounds %struct.anon, %struct.anon* %s28, i32 0, i32 0, !dbg !2973
  %16 = load i32, i32* %low29, align 8, !dbg !2974
  %add30 = add i32 %16, %shl27, !dbg !2974
  store i32 %add30, i32* %low29, align 8, !dbg !2974
  %17 = load i32, i32* %t, align 4, !dbg !2975
  %shr31 = lshr i32 %17, 16, !dbg !2976
  %s32 = bitcast %union.udwords* %r to %struct.anon*, !dbg !2977
  %high33 = getelementptr inbounds %struct.anon, %struct.anon* %s32, i32 0, i32 1, !dbg !2978
  %18 = load i32, i32* %high33, align 4, !dbg !2979
  %add34 = add i32 %18, %shr31, !dbg !2979
  store i32 %add34, i32* %high33, align 4, !dbg !2979
  %19 = load i32, i32* %a.addr, align 4, !dbg !2980
  %shr35 = lshr i32 %19, 16, !dbg !2981
  %20 = load i32, i32* %b.addr, align 4, !dbg !2982
  %shr36 = lshr i32 %20, 16, !dbg !2983
  %mul37 = mul i32 %shr35, %shr36, !dbg !2984
  %s38 = bitcast %union.udwords* %r to %struct.anon*, !dbg !2985
  %high39 = getelementptr inbounds %struct.anon, %struct.anon* %s38, i32 0, i32 1, !dbg !2986
  %21 = load i32, i32* %high39, align 4, !dbg !2987
  %add40 = add i32 %21, %mul37, !dbg !2987
  store i32 %add40, i32* %high39, align 4, !dbg !2987
  %all = bitcast %union.udwords* %r to i64*, !dbg !2988
  %22 = load i64, i64* %all, align 8, !dbg !2988
  ret i64 %22, !dbg !2989
}

; Function Attrs: noinline nounwind
define dso_local arm_aapcscc i64 @__mulodi4(i64 %a, i64 %b, i32* %overflow) #0 !dbg !2990 {
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
  store i32 64, i32* %N, align 4, !dbg !2991
  store i64 -9223372036854775808, i64* %MIN, align 8, !dbg !2992
  store i64 9223372036854775807, i64* %MAX, align 8, !dbg !2993
  %0 = load i32*, i32** %overflow.addr, align 4, !dbg !2994
  store i32 0, i32* %0, align 4, !dbg !2995
  %1 = load i64, i64* %a.addr, align 8, !dbg !2996
  %2 = load i64, i64* %b.addr, align 8, !dbg !2997
  %mul = mul nsw i64 %1, %2, !dbg !2998
  store i64 %mul, i64* %result, align 8, !dbg !2999
  %3 = load i64, i64* %a.addr, align 8, !dbg !3000
  %cmp = icmp eq i64 %3, -9223372036854775808, !dbg !3001
  br i1 %cmp, label %if.then, label %if.end4, !dbg !3000

if.then:                                          ; preds = %entry
  %4 = load i64, i64* %b.addr, align 8, !dbg !3002
  %cmp1 = icmp ne i64 %4, 0, !dbg !3003
  br i1 %cmp1, label %land.lhs.true, label %if.end, !dbg !3004

land.lhs.true:                                    ; preds = %if.then
  %5 = load i64, i64* %b.addr, align 8, !dbg !3005
  %cmp2 = icmp ne i64 %5, 1, !dbg !3006
  br i1 %cmp2, label %if.then3, label %if.end, !dbg !3002

if.then3:                                         ; preds = %land.lhs.true
  %6 = load i32*, i32** %overflow.addr, align 4, !dbg !3007
  store i32 1, i32* %6, align 4, !dbg !3008
  br label %if.end, !dbg !3009

if.end:                                           ; preds = %if.then3, %land.lhs.true, %if.then
  %7 = load i64, i64* %result, align 8, !dbg !3010
  store i64 %7, i64* %retval, align 8, !dbg !3011
  br label %return, !dbg !3011

if.end4:                                          ; preds = %entry
  %8 = load i64, i64* %b.addr, align 8, !dbg !3012
  %cmp5 = icmp eq i64 %8, -9223372036854775808, !dbg !3013
  br i1 %cmp5, label %if.then6, label %if.end12, !dbg !3012

if.then6:                                         ; preds = %if.end4
  %9 = load i64, i64* %a.addr, align 8, !dbg !3014
  %cmp7 = icmp ne i64 %9, 0, !dbg !3015
  br i1 %cmp7, label %land.lhs.true8, label %if.end11, !dbg !3016

land.lhs.true8:                                   ; preds = %if.then6
  %10 = load i64, i64* %a.addr, align 8, !dbg !3017
  %cmp9 = icmp ne i64 %10, 1, !dbg !3018
  br i1 %cmp9, label %if.then10, label %if.end11, !dbg !3014

if.then10:                                        ; preds = %land.lhs.true8
  %11 = load i32*, i32** %overflow.addr, align 4, !dbg !3019
  store i32 1, i32* %11, align 4, !dbg !3020
  br label %if.end11, !dbg !3021

if.end11:                                         ; preds = %if.then10, %land.lhs.true8, %if.then6
  %12 = load i64, i64* %result, align 8, !dbg !3022
  store i64 %12, i64* %retval, align 8, !dbg !3023
  br label %return, !dbg !3023

if.end12:                                         ; preds = %if.end4
  %13 = load i64, i64* %a.addr, align 8, !dbg !3024
  %shr = ashr i64 %13, 63, !dbg !3025
  store i64 %shr, i64* %sa, align 8, !dbg !3026
  %14 = load i64, i64* %a.addr, align 8, !dbg !3027
  %15 = load i64, i64* %sa, align 8, !dbg !3028
  %xor = xor i64 %14, %15, !dbg !3029
  %16 = load i64, i64* %sa, align 8, !dbg !3030
  %sub = sub nsw i64 %xor, %16, !dbg !3031
  store i64 %sub, i64* %abs_a, align 8, !dbg !3032
  %17 = load i64, i64* %b.addr, align 8, !dbg !3033
  %shr13 = ashr i64 %17, 63, !dbg !3034
  store i64 %shr13, i64* %sb, align 8, !dbg !3035
  %18 = load i64, i64* %b.addr, align 8, !dbg !3036
  %19 = load i64, i64* %sb, align 8, !dbg !3037
  %xor14 = xor i64 %18, %19, !dbg !3038
  %20 = load i64, i64* %sb, align 8, !dbg !3039
  %sub15 = sub nsw i64 %xor14, %20, !dbg !3040
  store i64 %sub15, i64* %abs_b, align 8, !dbg !3041
  %21 = load i64, i64* %abs_a, align 8, !dbg !3042
  %cmp16 = icmp slt i64 %21, 2, !dbg !3043
  br i1 %cmp16, label %if.then18, label %lor.lhs.false, !dbg !3044

lor.lhs.false:                                    ; preds = %if.end12
  %22 = load i64, i64* %abs_b, align 8, !dbg !3045
  %cmp17 = icmp slt i64 %22, 2, !dbg !3046
  br i1 %cmp17, label %if.then18, label %if.end19, !dbg !3042

if.then18:                                        ; preds = %lor.lhs.false, %if.end12
  %23 = load i64, i64* %result, align 8, !dbg !3047
  store i64 %23, i64* %retval, align 8, !dbg !3048
  br label %return, !dbg !3048

if.end19:                                         ; preds = %lor.lhs.false
  %24 = load i64, i64* %sa, align 8, !dbg !3049
  %25 = load i64, i64* %sb, align 8, !dbg !3050
  %cmp20 = icmp eq i64 %24, %25, !dbg !3051
  br i1 %cmp20, label %if.then21, label %if.else, !dbg !3049

if.then21:                                        ; preds = %if.end19
  %26 = load i64, i64* %abs_a, align 8, !dbg !3052
  %27 = load i64, i64* %abs_b, align 8, !dbg !3053
  %div = sdiv i64 9223372036854775807, %27, !dbg !3054
  %cmp22 = icmp sgt i64 %26, %div, !dbg !3055
  br i1 %cmp22, label %if.then23, label %if.end24, !dbg !3052

if.then23:                                        ; preds = %if.then21
  %28 = load i32*, i32** %overflow.addr, align 4, !dbg !3056
  store i32 1, i32* %28, align 4, !dbg !3057
  br label %if.end24, !dbg !3058

if.end24:                                         ; preds = %if.then23, %if.then21
  br label %if.end30, !dbg !3059

if.else:                                          ; preds = %if.end19
  %29 = load i64, i64* %abs_a, align 8, !dbg !3060
  %30 = load i64, i64* %abs_b, align 8, !dbg !3061
  %sub25 = sub nsw i64 0, %30, !dbg !3062
  %div26 = sdiv i64 -9223372036854775808, %sub25, !dbg !3063
  %cmp27 = icmp sgt i64 %29, %div26, !dbg !3064
  br i1 %cmp27, label %if.then28, label %if.end29, !dbg !3060

if.then28:                                        ; preds = %if.else
  %31 = load i32*, i32** %overflow.addr, align 4, !dbg !3065
  store i32 1, i32* %31, align 4, !dbg !3066
  br label %if.end29, !dbg !3067

if.end29:                                         ; preds = %if.then28, %if.else
  br label %if.end30

if.end30:                                         ; preds = %if.end29, %if.end24
  %32 = load i64, i64* %result, align 8, !dbg !3068
  store i64 %32, i64* %retval, align 8, !dbg !3069
  br label %return, !dbg !3069

return:                                           ; preds = %if.end30, %if.then18, %if.end11, %if.end
  %33 = load i64, i64* %retval, align 8, !dbg !3070
  ret i64 %33, !dbg !3070
}

; Function Attrs: noinline nounwind
define dso_local arm_aapcscc i32 @__mulosi4(i32 %a, i32 %b, i32* %overflow) #0 !dbg !3071 {
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
  store i32 32, i32* %N, align 4, !dbg !3072
  store i32 -2147483648, i32* %MIN, align 4, !dbg !3073
  store i32 2147483647, i32* %MAX, align 4, !dbg !3074
  %0 = load i32*, i32** %overflow.addr, align 4, !dbg !3075
  store i32 0, i32* %0, align 4, !dbg !3076
  %1 = load i32, i32* %a.addr, align 4, !dbg !3077
  %2 = load i32, i32* %b.addr, align 4, !dbg !3078
  %mul = mul nsw i32 %1, %2, !dbg !3079
  store i32 %mul, i32* %result, align 4, !dbg !3080
  %3 = load i32, i32* %a.addr, align 4, !dbg !3081
  %cmp = icmp eq i32 %3, -2147483648, !dbg !3082
  br i1 %cmp, label %if.then, label %if.end4, !dbg !3081

if.then:                                          ; preds = %entry
  %4 = load i32, i32* %b.addr, align 4, !dbg !3083
  %cmp1 = icmp ne i32 %4, 0, !dbg !3084
  br i1 %cmp1, label %land.lhs.true, label %if.end, !dbg !3085

land.lhs.true:                                    ; preds = %if.then
  %5 = load i32, i32* %b.addr, align 4, !dbg !3086
  %cmp2 = icmp ne i32 %5, 1, !dbg !3087
  br i1 %cmp2, label %if.then3, label %if.end, !dbg !3083

if.then3:                                         ; preds = %land.lhs.true
  %6 = load i32*, i32** %overflow.addr, align 4, !dbg !3088
  store i32 1, i32* %6, align 4, !dbg !3089
  br label %if.end, !dbg !3090

if.end:                                           ; preds = %if.then3, %land.lhs.true, %if.then
  %7 = load i32, i32* %result, align 4, !dbg !3091
  store i32 %7, i32* %retval, align 4, !dbg !3092
  br label %return, !dbg !3092

if.end4:                                          ; preds = %entry
  %8 = load i32, i32* %b.addr, align 4, !dbg !3093
  %cmp5 = icmp eq i32 %8, -2147483648, !dbg !3094
  br i1 %cmp5, label %if.then6, label %if.end12, !dbg !3093

if.then6:                                         ; preds = %if.end4
  %9 = load i32, i32* %a.addr, align 4, !dbg !3095
  %cmp7 = icmp ne i32 %9, 0, !dbg !3096
  br i1 %cmp7, label %land.lhs.true8, label %if.end11, !dbg !3097

land.lhs.true8:                                   ; preds = %if.then6
  %10 = load i32, i32* %a.addr, align 4, !dbg !3098
  %cmp9 = icmp ne i32 %10, 1, !dbg !3099
  br i1 %cmp9, label %if.then10, label %if.end11, !dbg !3095

if.then10:                                        ; preds = %land.lhs.true8
  %11 = load i32*, i32** %overflow.addr, align 4, !dbg !3100
  store i32 1, i32* %11, align 4, !dbg !3101
  br label %if.end11, !dbg !3102

if.end11:                                         ; preds = %if.then10, %land.lhs.true8, %if.then6
  %12 = load i32, i32* %result, align 4, !dbg !3103
  store i32 %12, i32* %retval, align 4, !dbg !3104
  br label %return, !dbg !3104

if.end12:                                         ; preds = %if.end4
  %13 = load i32, i32* %a.addr, align 4, !dbg !3105
  %shr = ashr i32 %13, 31, !dbg !3106
  store i32 %shr, i32* %sa, align 4, !dbg !3107
  %14 = load i32, i32* %a.addr, align 4, !dbg !3108
  %15 = load i32, i32* %sa, align 4, !dbg !3109
  %xor = xor i32 %14, %15, !dbg !3110
  %16 = load i32, i32* %sa, align 4, !dbg !3111
  %sub = sub nsw i32 %xor, %16, !dbg !3112
  store i32 %sub, i32* %abs_a, align 4, !dbg !3113
  %17 = load i32, i32* %b.addr, align 4, !dbg !3114
  %shr13 = ashr i32 %17, 31, !dbg !3115
  store i32 %shr13, i32* %sb, align 4, !dbg !3116
  %18 = load i32, i32* %b.addr, align 4, !dbg !3117
  %19 = load i32, i32* %sb, align 4, !dbg !3118
  %xor14 = xor i32 %18, %19, !dbg !3119
  %20 = load i32, i32* %sb, align 4, !dbg !3120
  %sub15 = sub nsw i32 %xor14, %20, !dbg !3121
  store i32 %sub15, i32* %abs_b, align 4, !dbg !3122
  %21 = load i32, i32* %abs_a, align 4, !dbg !3123
  %cmp16 = icmp slt i32 %21, 2, !dbg !3124
  br i1 %cmp16, label %if.then18, label %lor.lhs.false, !dbg !3125

lor.lhs.false:                                    ; preds = %if.end12
  %22 = load i32, i32* %abs_b, align 4, !dbg !3126
  %cmp17 = icmp slt i32 %22, 2, !dbg !3127
  br i1 %cmp17, label %if.then18, label %if.end19, !dbg !3123

if.then18:                                        ; preds = %lor.lhs.false, %if.end12
  %23 = load i32, i32* %result, align 4, !dbg !3128
  store i32 %23, i32* %retval, align 4, !dbg !3129
  br label %return, !dbg !3129

if.end19:                                         ; preds = %lor.lhs.false
  %24 = load i32, i32* %sa, align 4, !dbg !3130
  %25 = load i32, i32* %sb, align 4, !dbg !3131
  %cmp20 = icmp eq i32 %24, %25, !dbg !3132
  br i1 %cmp20, label %if.then21, label %if.else, !dbg !3130

if.then21:                                        ; preds = %if.end19
  %26 = load i32, i32* %abs_a, align 4, !dbg !3133
  %27 = load i32, i32* %abs_b, align 4, !dbg !3134
  %div = sdiv i32 2147483647, %27, !dbg !3135
  %cmp22 = icmp sgt i32 %26, %div, !dbg !3136
  br i1 %cmp22, label %if.then23, label %if.end24, !dbg !3133

if.then23:                                        ; preds = %if.then21
  %28 = load i32*, i32** %overflow.addr, align 4, !dbg !3137
  store i32 1, i32* %28, align 4, !dbg !3138
  br label %if.end24, !dbg !3139

if.end24:                                         ; preds = %if.then23, %if.then21
  br label %if.end30, !dbg !3140

if.else:                                          ; preds = %if.end19
  %29 = load i32, i32* %abs_a, align 4, !dbg !3141
  %30 = load i32, i32* %abs_b, align 4, !dbg !3142
  %sub25 = sub nsw i32 0, %30, !dbg !3143
  %div26 = sdiv i32 -2147483648, %sub25, !dbg !3144
  %cmp27 = icmp sgt i32 %29, %div26, !dbg !3145
  br i1 %cmp27, label %if.then28, label %if.end29, !dbg !3141

if.then28:                                        ; preds = %if.else
  %31 = load i32*, i32** %overflow.addr, align 4, !dbg !3146
  store i32 1, i32* %31, align 4, !dbg !3147
  br label %if.end29, !dbg !3148

if.end29:                                         ; preds = %if.then28, %if.else
  br label %if.end30

if.end30:                                         ; preds = %if.end29, %if.end24
  %32 = load i32, i32* %result, align 4, !dbg !3149
  store i32 %32, i32* %retval, align 4, !dbg !3150
  br label %return, !dbg !3150

return:                                           ; preds = %if.end30, %if.then18, %if.end11, %if.end
  %33 = load i32, i32* %retval, align 4, !dbg !3151
  ret i32 %33, !dbg !3151
}

; Function Attrs: noinline nounwind
define dso_local arm_aapcscc float @__mulsf3(float %a, float %b) #0 !dbg !3152 {
entry:
  %a.addr = alloca float, align 4
  %b.addr = alloca float, align 4
  store float %a, float* %a.addr, align 4
  store float %b, float* %b.addr, align 4
  %0 = load float, float* %a.addr, align 4, !dbg !3153
  %1 = load float, float* %b.addr, align 4, !dbg !3154
  %call = call arm_aapcs_vfpcc float @__mulXf3__.38(float %0, float %1) #4, !dbg !3155
  ret float %call, !dbg !3156
}

; Function Attrs: noinline nounwind
define internal arm_aapcs_vfpcc float @__mulXf3__.38(float %a, float %b) #0 !dbg !3157 {
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
  %0 = load float, float* %a.addr, align 4, !dbg !3158
  %call = call arm_aapcs_vfpcc i32 @toRep.39(float %0) #4, !dbg !3159
  %shr = lshr i32 %call, 23, !dbg !3160
  %and = and i32 %shr, 255, !dbg !3161
  store i32 %and, i32* %aExponent, align 4, !dbg !3162
  %1 = load float, float* %b.addr, align 4, !dbg !3163
  %call1 = call arm_aapcs_vfpcc i32 @toRep.39(float %1) #4, !dbg !3164
  %shr2 = lshr i32 %call1, 23, !dbg !3165
  %and3 = and i32 %shr2, 255, !dbg !3166
  store i32 %and3, i32* %bExponent, align 4, !dbg !3167
  %2 = load float, float* %a.addr, align 4, !dbg !3168
  %call4 = call arm_aapcs_vfpcc i32 @toRep.39(float %2) #4, !dbg !3169
  %3 = load float, float* %b.addr, align 4, !dbg !3170
  %call5 = call arm_aapcs_vfpcc i32 @toRep.39(float %3) #4, !dbg !3171
  %xor = xor i32 %call4, %call5, !dbg !3172
  %and6 = and i32 %xor, -2147483648, !dbg !3173
  store i32 %and6, i32* %productSign, align 4, !dbg !3174
  %4 = load float, float* %a.addr, align 4, !dbg !3175
  %call7 = call arm_aapcs_vfpcc i32 @toRep.39(float %4) #4, !dbg !3176
  %and8 = and i32 %call7, 8388607, !dbg !3177
  store i32 %and8, i32* %aSignificand, align 4, !dbg !3178
  %5 = load float, float* %b.addr, align 4, !dbg !3179
  %call9 = call arm_aapcs_vfpcc i32 @toRep.39(float %5) #4, !dbg !3180
  %and10 = and i32 %call9, 8388607, !dbg !3181
  store i32 %and10, i32* %bSignificand, align 4, !dbg !3182
  store i32 0, i32* %scale, align 4, !dbg !3183
  %6 = load i32, i32* %aExponent, align 4, !dbg !3184
  %sub = sub i32 %6, 1, !dbg !3185
  %cmp = icmp uge i32 %sub, 254, !dbg !3186
  br i1 %cmp, label %if.then, label %lor.lhs.false, !dbg !3187

lor.lhs.false:                                    ; preds = %entry
  %7 = load i32, i32* %bExponent, align 4, !dbg !3188
  %sub11 = sub i32 %7, 1, !dbg !3189
  %cmp12 = icmp uge i32 %sub11, 254, !dbg !3190
  br i1 %cmp12, label %if.then, label %if.end60, !dbg !3184

if.then:                                          ; preds = %lor.lhs.false, %entry
  %8 = load float, float* %a.addr, align 4, !dbg !3191
  %call13 = call arm_aapcs_vfpcc i32 @toRep.39(float %8) #4, !dbg !3192
  %and14 = and i32 %call13, 2147483647, !dbg !3193
  store i32 %and14, i32* %aAbs, align 4, !dbg !3194
  %9 = load float, float* %b.addr, align 4, !dbg !3195
  %call15 = call arm_aapcs_vfpcc i32 @toRep.39(float %9) #4, !dbg !3196
  %and16 = and i32 %call15, 2147483647, !dbg !3197
  store i32 %and16, i32* %bAbs, align 4, !dbg !3198
  %10 = load i32, i32* %aAbs, align 4, !dbg !3199
  %cmp17 = icmp ugt i32 %10, 2139095040, !dbg !3200
  br i1 %cmp17, label %if.then18, label %if.end, !dbg !3199

if.then18:                                        ; preds = %if.then
  %11 = load float, float* %a.addr, align 4, !dbg !3201
  %call19 = call arm_aapcs_vfpcc i32 @toRep.39(float %11) #4, !dbg !3202
  %or = or i32 %call19, 4194304, !dbg !3203
  %call20 = call arm_aapcs_vfpcc float @fromRep.40(i32 %or) #4, !dbg !3204
  store float %call20, float* %retval, align 4, !dbg !3205
  br label %return, !dbg !3205

if.end:                                           ; preds = %if.then
  %12 = load i32, i32* %bAbs, align 4, !dbg !3206
  %cmp21 = icmp ugt i32 %12, 2139095040, !dbg !3207
  br i1 %cmp21, label %if.then22, label %if.end26, !dbg !3206

if.then22:                                        ; preds = %if.end
  %13 = load float, float* %b.addr, align 4, !dbg !3208
  %call23 = call arm_aapcs_vfpcc i32 @toRep.39(float %13) #4, !dbg !3209
  %or24 = or i32 %call23, 4194304, !dbg !3210
  %call25 = call arm_aapcs_vfpcc float @fromRep.40(i32 %or24) #4, !dbg !3211
  store float %call25, float* %retval, align 4, !dbg !3212
  br label %return, !dbg !3212

if.end26:                                         ; preds = %if.end
  %14 = load i32, i32* %aAbs, align 4, !dbg !3213
  %cmp27 = icmp eq i32 %14, 2139095040, !dbg !3214
  br i1 %cmp27, label %if.then28, label %if.end33, !dbg !3213

if.then28:                                        ; preds = %if.end26
  %15 = load i32, i32* %bAbs, align 4, !dbg !3215
  %tobool = icmp ne i32 %15, 0, !dbg !3215
  br i1 %tobool, label %if.then29, label %if.else, !dbg !3215

if.then29:                                        ; preds = %if.then28
  %16 = load i32, i32* %aAbs, align 4, !dbg !3216
  %17 = load i32, i32* %productSign, align 4, !dbg !3217
  %or30 = or i32 %16, %17, !dbg !3218
  %call31 = call arm_aapcs_vfpcc float @fromRep.40(i32 %or30) #4, !dbg !3219
  store float %call31, float* %retval, align 4, !dbg !3220
  br label %return, !dbg !3220

if.else:                                          ; preds = %if.then28
  %call32 = call arm_aapcs_vfpcc float @fromRep.40(i32 2143289344) #4, !dbg !3221
  store float %call32, float* %retval, align 4, !dbg !3222
  br label %return, !dbg !3222

if.end33:                                         ; preds = %if.end26
  %18 = load i32, i32* %bAbs, align 4, !dbg !3223
  %cmp34 = icmp eq i32 %18, 2139095040, !dbg !3224
  br i1 %cmp34, label %if.then35, label %if.end42, !dbg !3223

if.then35:                                        ; preds = %if.end33
  %19 = load i32, i32* %aAbs, align 4, !dbg !3225
  %tobool36 = icmp ne i32 %19, 0, !dbg !3225
  br i1 %tobool36, label %if.then37, label %if.else40, !dbg !3225

if.then37:                                        ; preds = %if.then35
  %20 = load i32, i32* %bAbs, align 4, !dbg !3226
  %21 = load i32, i32* %productSign, align 4, !dbg !3227
  %or38 = or i32 %20, %21, !dbg !3228
  %call39 = call arm_aapcs_vfpcc float @fromRep.40(i32 %or38) #4, !dbg !3229
  store float %call39, float* %retval, align 4, !dbg !3230
  br label %return, !dbg !3230

if.else40:                                        ; preds = %if.then35
  %call41 = call arm_aapcs_vfpcc float @fromRep.40(i32 2143289344) #4, !dbg !3231
  store float %call41, float* %retval, align 4, !dbg !3232
  br label %return, !dbg !3232

if.end42:                                         ; preds = %if.end33
  %22 = load i32, i32* %aAbs, align 4, !dbg !3233
  %tobool43 = icmp ne i32 %22, 0, !dbg !3233
  br i1 %tobool43, label %if.end46, label %if.then44, !dbg !3234

if.then44:                                        ; preds = %if.end42
  %23 = load i32, i32* %productSign, align 4, !dbg !3235
  %call45 = call arm_aapcs_vfpcc float @fromRep.40(i32 %23) #4, !dbg !3236
  store float %call45, float* %retval, align 4, !dbg !3237
  br label %return, !dbg !3237

if.end46:                                         ; preds = %if.end42
  %24 = load i32, i32* %bAbs, align 4, !dbg !3238
  %tobool47 = icmp ne i32 %24, 0, !dbg !3238
  br i1 %tobool47, label %if.end50, label %if.then48, !dbg !3239

if.then48:                                        ; preds = %if.end46
  %25 = load i32, i32* %productSign, align 4, !dbg !3240
  %call49 = call arm_aapcs_vfpcc float @fromRep.40(i32 %25) #4, !dbg !3241
  store float %call49, float* %retval, align 4, !dbg !3242
  br label %return, !dbg !3242

if.end50:                                         ; preds = %if.end46
  %26 = load i32, i32* %aAbs, align 4, !dbg !3243
  %cmp51 = icmp ult i32 %26, 8388608, !dbg !3244
  br i1 %cmp51, label %if.then52, label %if.end54, !dbg !3243

if.then52:                                        ; preds = %if.end50
  %call53 = call arm_aapcs_vfpcc i32 @normalize.41(i32* %aSignificand) #4, !dbg !3245
  %27 = load i32, i32* %scale, align 4, !dbg !3246
  %add = add nsw i32 %27, %call53, !dbg !3246
  store i32 %add, i32* %scale, align 4, !dbg !3246
  br label %if.end54, !dbg !3247

if.end54:                                         ; preds = %if.then52, %if.end50
  %28 = load i32, i32* %bAbs, align 4, !dbg !3248
  %cmp55 = icmp ult i32 %28, 8388608, !dbg !3249
  br i1 %cmp55, label %if.then56, label %if.end59, !dbg !3248

if.then56:                                        ; preds = %if.end54
  %call57 = call arm_aapcs_vfpcc i32 @normalize.41(i32* %bSignificand) #4, !dbg !3250
  %29 = load i32, i32* %scale, align 4, !dbg !3251
  %add58 = add nsw i32 %29, %call57, !dbg !3251
  store i32 %add58, i32* %scale, align 4, !dbg !3251
  br label %if.end59, !dbg !3252

if.end59:                                         ; preds = %if.then56, %if.end54
  br label %if.end60, !dbg !3253

if.end60:                                         ; preds = %if.end59, %lor.lhs.false
  %30 = load i32, i32* %aSignificand, align 4, !dbg !3254
  %or61 = or i32 %30, 8388608, !dbg !3254
  store i32 %or61, i32* %aSignificand, align 4, !dbg !3254
  %31 = load i32, i32* %bSignificand, align 4, !dbg !3255
  %or62 = or i32 %31, 8388608, !dbg !3255
  store i32 %or62, i32* %bSignificand, align 4, !dbg !3255
  %32 = load i32, i32* %aSignificand, align 4, !dbg !3256
  %33 = load i32, i32* %bSignificand, align 4, !dbg !3257
  %shl = shl i32 %33, 8, !dbg !3258
  call arm_aapcs_vfpcc void @wideMultiply.42(i32 %32, i32 %shl, i32* %productHi, i32* %productLo) #4, !dbg !3259
  %34 = load i32, i32* %aExponent, align 4, !dbg !3260
  %35 = load i32, i32* %bExponent, align 4, !dbg !3261
  %add63 = add i32 %34, %35, !dbg !3262
  %sub64 = sub i32 %add63, 127, !dbg !3263
  %36 = load i32, i32* %scale, align 4, !dbg !3264
  %add65 = add i32 %sub64, %36, !dbg !3265
  store i32 %add65, i32* %productExponent, align 4, !dbg !3266
  %37 = load i32, i32* %productHi, align 4, !dbg !3267
  %and66 = and i32 %37, 8388608, !dbg !3268
  %tobool67 = icmp ne i32 %and66, 0, !dbg !3268
  br i1 %tobool67, label %if.then68, label %if.else69, !dbg !3267

if.then68:                                        ; preds = %if.end60
  %38 = load i32, i32* %productExponent, align 4, !dbg !3269
  %inc = add nsw i32 %38, 1, !dbg !3269
  store i32 %inc, i32* %productExponent, align 4, !dbg !3269
  br label %if.end70, !dbg !3270

if.else69:                                        ; preds = %if.end60
  call arm_aapcs_vfpcc void @wideLeftShift.43(i32* %productHi, i32* %productLo, i32 1) #4, !dbg !3271
  br label %if.end70

if.end70:                                         ; preds = %if.else69, %if.then68
  %39 = load i32, i32* %productExponent, align 4, !dbg !3272
  %cmp71 = icmp sge i32 %39, 255, !dbg !3273
  br i1 %cmp71, label %if.then72, label %if.end75, !dbg !3272

if.then72:                                        ; preds = %if.end70
  %40 = load i32, i32* %productSign, align 4, !dbg !3274
  %or73 = or i32 2139095040, %40, !dbg !3275
  %call74 = call arm_aapcs_vfpcc float @fromRep.40(i32 %or73) #4, !dbg !3276
  store float %call74, float* %retval, align 4, !dbg !3277
  br label %return, !dbg !3277

if.end75:                                         ; preds = %if.end70
  %41 = load i32, i32* %productExponent, align 4, !dbg !3278
  %cmp76 = icmp sle i32 %41, 0, !dbg !3279
  br i1 %cmp76, label %if.then77, label %if.else83, !dbg !3278

if.then77:                                        ; preds = %if.end75
  %42 = load i32, i32* %productExponent, align 4, !dbg !3280
  %sub78 = sub i32 1, %42, !dbg !3281
  store i32 %sub78, i32* %shift, align 4, !dbg !3282
  %43 = load i32, i32* %shift, align 4, !dbg !3283
  %cmp79 = icmp uge i32 %43, 32, !dbg !3284
  br i1 %cmp79, label %if.then80, label %if.end82, !dbg !3283

if.then80:                                        ; preds = %if.then77
  %44 = load i32, i32* %productSign, align 4, !dbg !3285
  %call81 = call arm_aapcs_vfpcc float @fromRep.40(i32 %44) #4, !dbg !3286
  store float %call81, float* %retval, align 4, !dbg !3287
  br label %return, !dbg !3287

if.end82:                                         ; preds = %if.then77
  %45 = load i32, i32* %shift, align 4, !dbg !3288
  call arm_aapcs_vfpcc void @wideRightShiftWithSticky.44(i32* %productHi, i32* %productLo, i32 %45) #4, !dbg !3289
  br label %if.end87, !dbg !3290

if.else83:                                        ; preds = %if.end75
  %46 = load i32, i32* %productHi, align 4, !dbg !3291
  %and84 = and i32 %46, 8388607, !dbg !3291
  store i32 %and84, i32* %productHi, align 4, !dbg !3291
  %47 = load i32, i32* %productExponent, align 4, !dbg !3292
  %shl85 = shl i32 %47, 23, !dbg !3293
  %48 = load i32, i32* %productHi, align 4, !dbg !3294
  %or86 = or i32 %48, %shl85, !dbg !3294
  store i32 %or86, i32* %productHi, align 4, !dbg !3294
  br label %if.end87

if.end87:                                         ; preds = %if.else83, %if.end82
  %49 = load i32, i32* %productSign, align 4, !dbg !3295
  %50 = load i32, i32* %productHi, align 4, !dbg !3296
  %or88 = or i32 %50, %49, !dbg !3296
  store i32 %or88, i32* %productHi, align 4, !dbg !3296
  %51 = load i32, i32* %productLo, align 4, !dbg !3297
  %cmp89 = icmp ugt i32 %51, -2147483648, !dbg !3298
  br i1 %cmp89, label %if.then90, label %if.end92, !dbg !3297

if.then90:                                        ; preds = %if.end87
  %52 = load i32, i32* %productHi, align 4, !dbg !3299
  %inc91 = add i32 %52, 1, !dbg !3299
  store i32 %inc91, i32* %productHi, align 4, !dbg !3299
  br label %if.end92, !dbg !3300

if.end92:                                         ; preds = %if.then90, %if.end87
  %53 = load i32, i32* %productLo, align 4, !dbg !3301
  %cmp93 = icmp eq i32 %53, -2147483648, !dbg !3302
  br i1 %cmp93, label %if.then94, label %if.end97, !dbg !3301

if.then94:                                        ; preds = %if.end92
  %54 = load i32, i32* %productHi, align 4, !dbg !3303
  %and95 = and i32 %54, 1, !dbg !3304
  %55 = load i32, i32* %productHi, align 4, !dbg !3305
  %add96 = add i32 %55, %and95, !dbg !3305
  store i32 %add96, i32* %productHi, align 4, !dbg !3305
  br label %if.end97, !dbg !3306

if.end97:                                         ; preds = %if.then94, %if.end92
  %56 = load i32, i32* %productHi, align 4, !dbg !3307
  %call98 = call arm_aapcs_vfpcc float @fromRep.40(i32 %56) #4, !dbg !3308
  store float %call98, float* %retval, align 4, !dbg !3309
  br label %return, !dbg !3309

return:                                           ; preds = %if.end97, %if.then80, %if.then72, %if.then48, %if.then44, %if.else40, %if.then37, %if.else, %if.then29, %if.then22, %if.then18
  %57 = load float, float* %retval, align 4, !dbg !3310
  ret float %57, !dbg !3310
}

; Function Attrs: noinline nounwind
define internal arm_aapcs_vfpcc i32 @toRep.39(float %x) #0 !dbg !3311 {
entry:
  %x.addr = alloca float, align 4
  %rep = alloca %union.anon.0.0, align 4
  store float %x, float* %x.addr, align 4
  %f = bitcast %union.anon.0.0* %rep to float*, !dbg !3312
  %0 = load float, float* %x.addr, align 4, !dbg !3313
  store float %0, float* %f, align 4, !dbg !3312
  %i = bitcast %union.anon.0.0* %rep to i32*, !dbg !3314
  %1 = load i32, i32* %i, align 4, !dbg !3314
  ret i32 %1, !dbg !3315
}

; Function Attrs: noinline nounwind
define internal arm_aapcs_vfpcc float @fromRep.40(i32 %x) #0 !dbg !3316 {
entry:
  %x.addr = alloca i32, align 4
  %rep = alloca %union.anon.0.0, align 4
  store i32 %x, i32* %x.addr, align 4
  %i = bitcast %union.anon.0.0* %rep to i32*, !dbg !3317
  %0 = load i32, i32* %x.addr, align 4, !dbg !3318
  store i32 %0, i32* %i, align 4, !dbg !3317
  %f = bitcast %union.anon.0.0* %rep to float*, !dbg !3319
  %1 = load float, float* %f, align 4, !dbg !3319
  ret float %1, !dbg !3320
}

; Function Attrs: noinline nounwind
define internal arm_aapcs_vfpcc i32 @normalize.41(i32* %significand) #0 !dbg !3321 {
entry:
  %significand.addr = alloca i32*, align 4
  %shift = alloca i32, align 4
  store i32* %significand, i32** %significand.addr, align 4
  %0 = load i32*, i32** %significand.addr, align 4, !dbg !3322
  %1 = load i32, i32* %0, align 4, !dbg !3323
  %call = call arm_aapcs_vfpcc i32 @rep_clz.45(i32 %1) #4, !dbg !3324
  %call1 = call arm_aapcs_vfpcc i32 @rep_clz.45(i32 8388608) #4, !dbg !3325
  %sub = sub nsw i32 %call, %call1, !dbg !3326
  store i32 %sub, i32* %shift, align 4, !dbg !3327
  %2 = load i32, i32* %shift, align 4, !dbg !3328
  %3 = load i32*, i32** %significand.addr, align 4, !dbg !3329
  %4 = load i32, i32* %3, align 4, !dbg !3330
  %shl = shl i32 %4, %2, !dbg !3330
  store i32 %shl, i32* %3, align 4, !dbg !3330
  %5 = load i32, i32* %shift, align 4, !dbg !3331
  %sub2 = sub nsw i32 1, %5, !dbg !3332
  ret i32 %sub2, !dbg !3333
}

; Function Attrs: noinline nounwind
define internal arm_aapcs_vfpcc void @wideMultiply.42(i32 %a, i32 %b, i32* %hi, i32* %lo) #0 !dbg !3334 {
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
  %0 = load i32, i32* %a.addr, align 4, !dbg !3335
  %conv = zext i32 %0 to i64, !dbg !3336
  %1 = load i32, i32* %b.addr, align 4, !dbg !3337
  %conv1 = zext i32 %1 to i64, !dbg !3337
  %mul = mul i64 %conv, %conv1, !dbg !3338
  store i64 %mul, i64* %product, align 8, !dbg !3339
  %2 = load i64, i64* %product, align 8, !dbg !3340
  %shr = lshr i64 %2, 32, !dbg !3341
  %conv2 = trunc i64 %shr to i32, !dbg !3340
  %3 = load i32*, i32** %hi.addr, align 4, !dbg !3342
  store i32 %conv2, i32* %3, align 4, !dbg !3343
  %4 = load i64, i64* %product, align 8, !dbg !3344
  %conv3 = trunc i64 %4 to i32, !dbg !3344
  %5 = load i32*, i32** %lo.addr, align 4, !dbg !3345
  store i32 %conv3, i32* %5, align 4, !dbg !3346
  ret void, !dbg !3347
}

; Function Attrs: noinline nounwind
define internal arm_aapcs_vfpcc void @wideLeftShift.43(i32* %hi, i32* %lo, i32 %count) #0 !dbg !3348 {
entry:
  %hi.addr = alloca i32*, align 4
  %lo.addr = alloca i32*, align 4
  %count.addr = alloca i32, align 4
  store i32* %hi, i32** %hi.addr, align 4
  store i32* %lo, i32** %lo.addr, align 4
  store i32 %count, i32* %count.addr, align 4
  %0 = load i32*, i32** %hi.addr, align 4, !dbg !3349
  %1 = load i32, i32* %0, align 4, !dbg !3350
  %2 = load i32, i32* %count.addr, align 4, !dbg !3351
  %shl = shl i32 %1, %2, !dbg !3352
  %3 = load i32*, i32** %lo.addr, align 4, !dbg !3353
  %4 = load i32, i32* %3, align 4, !dbg !3354
  %5 = load i32, i32* %count.addr, align 4, !dbg !3355
  %sub = sub i32 32, %5, !dbg !3356
  %shr = lshr i32 %4, %sub, !dbg !3357
  %or = or i32 %shl, %shr, !dbg !3358
  %6 = load i32*, i32** %hi.addr, align 4, !dbg !3359
  store i32 %or, i32* %6, align 4, !dbg !3360
  %7 = load i32*, i32** %lo.addr, align 4, !dbg !3361
  %8 = load i32, i32* %7, align 4, !dbg !3362
  %9 = load i32, i32* %count.addr, align 4, !dbg !3363
  %shl1 = shl i32 %8, %9, !dbg !3364
  %10 = load i32*, i32** %lo.addr, align 4, !dbg !3365
  store i32 %shl1, i32* %10, align 4, !dbg !3366
  ret void, !dbg !3367
}

; Function Attrs: noinline nounwind
define internal arm_aapcs_vfpcc void @wideRightShiftWithSticky.44(i32* %hi, i32* %lo, i32 %count) #0 !dbg !3368 {
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
  %0 = load i32, i32* %count.addr, align 4, !dbg !3369
  %cmp = icmp ult i32 %0, 32, !dbg !3370
  br i1 %cmp, label %if.then, label %if.else, !dbg !3369

if.then:                                          ; preds = %entry
  %1 = load i32*, i32** %lo.addr, align 4, !dbg !3371
  %2 = load i32, i32* %1, align 4, !dbg !3372
  %3 = load i32, i32* %count.addr, align 4, !dbg !3373
  %sub = sub i32 32, %3, !dbg !3374
  %shl = shl i32 %2, %sub, !dbg !3375
  %tobool = icmp ne i32 %shl, 0, !dbg !3372
  %frombool = zext i1 %tobool to i8, !dbg !3376
  store i8 %frombool, i8* %sticky, align 1, !dbg !3376
  %4 = load i32*, i32** %hi.addr, align 4, !dbg !3377
  %5 = load i32, i32* %4, align 4, !dbg !3378
  %6 = load i32, i32* %count.addr, align 4, !dbg !3379
  %sub1 = sub i32 32, %6, !dbg !3380
  %shl2 = shl i32 %5, %sub1, !dbg !3381
  %7 = load i32*, i32** %lo.addr, align 4, !dbg !3382
  %8 = load i32, i32* %7, align 4, !dbg !3383
  %9 = load i32, i32* %count.addr, align 4, !dbg !3384
  %shr = lshr i32 %8, %9, !dbg !3385
  %or = or i32 %shl2, %shr, !dbg !3386
  %10 = load i8, i8* %sticky, align 1, !dbg !3387
  %tobool3 = trunc i8 %10 to i1, !dbg !3387
  %conv = zext i1 %tobool3 to i32, !dbg !3387
  %or4 = or i32 %or, %conv, !dbg !3388
  %11 = load i32*, i32** %lo.addr, align 4, !dbg !3389
  store i32 %or4, i32* %11, align 4, !dbg !3390
  %12 = load i32*, i32** %hi.addr, align 4, !dbg !3391
  %13 = load i32, i32* %12, align 4, !dbg !3392
  %14 = load i32, i32* %count.addr, align 4, !dbg !3393
  %shr5 = lshr i32 %13, %14, !dbg !3394
  %15 = load i32*, i32** %hi.addr, align 4, !dbg !3395
  store i32 %shr5, i32* %15, align 4, !dbg !3396
  br label %if.end27, !dbg !3397

if.else:                                          ; preds = %entry
  %16 = load i32, i32* %count.addr, align 4, !dbg !3398
  %cmp6 = icmp ult i32 %16, 64, !dbg !3399
  br i1 %cmp6, label %if.then8, label %if.else20, !dbg !3398

if.then8:                                         ; preds = %if.else
  %17 = load i32*, i32** %hi.addr, align 4, !dbg !3400
  %18 = load i32, i32* %17, align 4, !dbg !3401
  %19 = load i32, i32* %count.addr, align 4, !dbg !3402
  %sub10 = sub i32 64, %19, !dbg !3403
  %shl11 = shl i32 %18, %sub10, !dbg !3404
  %20 = load i32*, i32** %lo.addr, align 4, !dbg !3405
  %21 = load i32, i32* %20, align 4, !dbg !3406
  %or12 = or i32 %shl11, %21, !dbg !3407
  %tobool13 = icmp ne i32 %or12, 0, !dbg !3401
  %frombool14 = zext i1 %tobool13 to i8, !dbg !3408
  store i8 %frombool14, i8* %sticky9, align 1, !dbg !3408
  %22 = load i32*, i32** %hi.addr, align 4, !dbg !3409
  %23 = load i32, i32* %22, align 4, !dbg !3410
  %24 = load i32, i32* %count.addr, align 4, !dbg !3411
  %sub15 = sub i32 %24, 32, !dbg !3412
  %shr16 = lshr i32 %23, %sub15, !dbg !3413
  %25 = load i8, i8* %sticky9, align 1, !dbg !3414
  %tobool17 = trunc i8 %25 to i1, !dbg !3414
  %conv18 = zext i1 %tobool17 to i32, !dbg !3414
  %or19 = or i32 %shr16, %conv18, !dbg !3415
  %26 = load i32*, i32** %lo.addr, align 4, !dbg !3416
  store i32 %or19, i32* %26, align 4, !dbg !3417
  %27 = load i32*, i32** %hi.addr, align 4, !dbg !3418
  store i32 0, i32* %27, align 4, !dbg !3419
  br label %if.end, !dbg !3420

if.else20:                                        ; preds = %if.else
  %28 = load i32*, i32** %hi.addr, align 4, !dbg !3421
  %29 = load i32, i32* %28, align 4, !dbg !3422
  %30 = load i32*, i32** %lo.addr, align 4, !dbg !3423
  %31 = load i32, i32* %30, align 4, !dbg !3424
  %or22 = or i32 %29, %31, !dbg !3425
  %tobool23 = icmp ne i32 %or22, 0, !dbg !3422
  %frombool24 = zext i1 %tobool23 to i8, !dbg !3426
  store i8 %frombool24, i8* %sticky21, align 1, !dbg !3426
  %32 = load i8, i8* %sticky21, align 1, !dbg !3427
  %tobool25 = trunc i8 %32 to i1, !dbg !3427
  %conv26 = zext i1 %tobool25 to i32, !dbg !3427
  %33 = load i32*, i32** %lo.addr, align 4, !dbg !3428
  store i32 %conv26, i32* %33, align 4, !dbg !3429
  %34 = load i32*, i32** %hi.addr, align 4, !dbg !3430
  store i32 0, i32* %34, align 4, !dbg !3431
  br label %if.end

if.end:                                           ; preds = %if.else20, %if.then8
  br label %if.end27

if.end27:                                         ; preds = %if.end, %if.then
  ret void, !dbg !3432
}

; Function Attrs: noinline nounwind
define internal arm_aapcs_vfpcc i32 @rep_clz.45(i32 %a) #0 !dbg !3433 {
entry:
  %a.addr = alloca i32, align 4
  store i32 %a, i32* %a.addr, align 4
  %0 = load i32, i32* %a.addr, align 4, !dbg !3434
  %1 = call i32 @llvm.ctlz.i32(i32 %0, i1 false), !dbg !3435
  ret i32 %1, !dbg !3436
}

; Function Attrs: noinline nounwind
define dso_local arm_aapcscc double @__negdf2(double %a) #0 !dbg !3437 {
entry:
  %a.addr = alloca double, align 8
  store double %a, double* %a.addr, align 8
  %0 = load double, double* %a.addr, align 8, !dbg !3438
  %call = call arm_aapcs_vfpcc i64 @toRep.46(double %0) #4, !dbg !3439
  %xor = xor i64 %call, -9223372036854775808, !dbg !3440
  %call1 = call arm_aapcs_vfpcc double @fromRep.47(i64 %xor) #4, !dbg !3441
  ret double %call1, !dbg !3442
}

; Function Attrs: noinline nounwind
define internal arm_aapcs_vfpcc i64 @toRep.46(double %x) #0 !dbg !3443 {
entry:
  %x.addr = alloca double, align 8
  %rep = alloca %union.anon.0, align 8
  store double %x, double* %x.addr, align 8
  %f = bitcast %union.anon.0* %rep to double*, !dbg !3444
  %0 = load double, double* %x.addr, align 8, !dbg !3445
  store double %0, double* %f, align 8, !dbg !3444
  %i = bitcast %union.anon.0* %rep to i64*, !dbg !3446
  %1 = load i64, i64* %i, align 8, !dbg !3446
  ret i64 %1, !dbg !3447
}

; Function Attrs: noinline nounwind
define internal arm_aapcs_vfpcc double @fromRep.47(i64 %x) #0 !dbg !3448 {
entry:
  %x.addr = alloca i64, align 8
  %rep = alloca %union.anon.0, align 8
  store i64 %x, i64* %x.addr, align 8
  %i = bitcast %union.anon.0* %rep to i64*, !dbg !3449
  %0 = load i64, i64* %x.addr, align 8, !dbg !3450
  store i64 %0, i64* %i, align 8, !dbg !3449
  %f = bitcast %union.anon.0* %rep to double*, !dbg !3451
  %1 = load double, double* %f, align 8, !dbg !3451
  ret double %1, !dbg !3452
}

; Function Attrs: noinline nounwind
define dso_local arm_aapcscc i64 @__negdi2(i64 %a) #0 !dbg !3453 {
entry:
  %a.addr = alloca i64, align 8
  store i64 %a, i64* %a.addr, align 8
  %0 = load i64, i64* %a.addr, align 8, !dbg !3454
  %sub = sub nsw i64 0, %0, !dbg !3455
  ret i64 %sub, !dbg !3456
}

; Function Attrs: noinline nounwind
define dso_local arm_aapcscc float @__negsf2(float %a) #0 !dbg !3457 {
entry:
  %a.addr = alloca float, align 4
  store float %a, float* %a.addr, align 4
  %0 = load float, float* %a.addr, align 4, !dbg !3458
  %call = call arm_aapcs_vfpcc i32 @toRep.48(float %0) #4, !dbg !3459
  %xor = xor i32 %call, -2147483648, !dbg !3460
  %call1 = call arm_aapcs_vfpcc float @fromRep.49(i32 %xor) #4, !dbg !3461
  ret float %call1, !dbg !3462
}

; Function Attrs: noinline nounwind
define internal arm_aapcs_vfpcc i32 @toRep.48(float %x) #0 !dbg !3463 {
entry:
  %x.addr = alloca float, align 4
  %rep = alloca %union.anon.0.0, align 4
  store float %x, float* %x.addr, align 4
  %f = bitcast %union.anon.0.0* %rep to float*, !dbg !3464
  %0 = load float, float* %x.addr, align 4, !dbg !3465
  store float %0, float* %f, align 4, !dbg !3464
  %i = bitcast %union.anon.0.0* %rep to i32*, !dbg !3466
  %1 = load i32, i32* %i, align 4, !dbg !3466
  ret i32 %1, !dbg !3467
}

; Function Attrs: noinline nounwind
define internal arm_aapcs_vfpcc float @fromRep.49(i32 %x) #0 !dbg !3468 {
entry:
  %x.addr = alloca i32, align 4
  %rep = alloca %union.anon.0.0, align 4
  store i32 %x, i32* %x.addr, align 4
  %i = bitcast %union.anon.0.0* %rep to i32*, !dbg !3469
  %0 = load i32, i32* %x.addr, align 4, !dbg !3470
  store i32 %0, i32* %i, align 4, !dbg !3469
  %f = bitcast %union.anon.0.0* %rep to float*, !dbg !3471
  %1 = load float, float* %f, align 4, !dbg !3471
  ret float %1, !dbg !3472
}

; Function Attrs: noinline nounwind
define dso_local arm_aapcscc i64 @__negvdi2(i64 %a) #0 !dbg !3473 {
entry:
  %a.addr = alloca i64, align 8
  %MIN = alloca i64, align 8
  store i64 %a, i64* %a.addr, align 8
  store i64 -9223372036854775808, i64* %MIN, align 8, !dbg !3474
  %0 = load i64, i64* %a.addr, align 8, !dbg !3475
  %cmp = icmp eq i64 %0, -9223372036854775808, !dbg !3476
  br i1 %cmp, label %if.then, label %if.end, !dbg !3475

if.then:                                          ; preds = %entry
  call arm_aapcs_vfpcc void @compilerrt_abort_impl(i8* getelementptr inbounds ([10 x i8], [10 x i8]* @.str, i32 0, i32 0), i32 26, i8* getelementptr inbounds ([10 x i8], [10 x i8]* @__func__.__negvdi2, i32 0, i32 0)) #5, !dbg !3477
  unreachable, !dbg !3477

if.end:                                           ; preds = %entry
  %1 = load i64, i64* %a.addr, align 8, !dbg !3478
  %sub = sub nsw i64 0, %1, !dbg !3479
  ret i64 %sub, !dbg !3480
}

; Function Attrs: noinline nounwind
define dso_local arm_aapcscc i32 @__negvsi2(i32 %a) #0 !dbg !3481 {
entry:
  %a.addr = alloca i32, align 4
  %MIN = alloca i32, align 4
  store i32 %a, i32* %a.addr, align 4
  store i32 -2147483648, i32* %MIN, align 4, !dbg !3482
  %0 = load i32, i32* %a.addr, align 4, !dbg !3483
  %cmp = icmp eq i32 %0, -2147483648, !dbg !3484
  br i1 %cmp, label %if.then, label %if.end, !dbg !3483

if.then:                                          ; preds = %entry
  call arm_aapcs_vfpcc void @compilerrt_abort_impl(i8* getelementptr inbounds ([10 x i8], [10 x i8]* @.str.50, i32 0, i32 0), i32 26, i8* getelementptr inbounds ([10 x i8], [10 x i8]* @__func__.__negvsi2, i32 0, i32 0)) #5, !dbg !3485
  unreachable, !dbg !3485

if.end:                                           ; preds = %entry
  %1 = load i32, i32* %a.addr, align 4, !dbg !3486
  %sub = sub nsw i32 0, %1, !dbg !3487
  ret i32 %sub, !dbg !3488
}

; Function Attrs: noinline nounwind
define dso_local arm_aapcscc double @__powidf2(double %a, i32 %b) #0 !dbg !3489 {
entry:
  %a.addr = alloca double, align 8
  %b.addr = alloca i32, align 4
  %recip = alloca i32, align 4
  %r = alloca double, align 8
  store double %a, double* %a.addr, align 8
  store i32 %b, i32* %b.addr, align 4
  %0 = load i32, i32* %b.addr, align 4, !dbg !3490
  %cmp = icmp slt i32 %0, 0, !dbg !3491
  %conv = zext i1 %cmp to i32, !dbg !3491
  store i32 %conv, i32* %recip, align 4, !dbg !3492
  store double 1.000000e+00, double* %r, align 8, !dbg !3493
  br label %while.body, !dbg !3494

while.body:                                       ; preds = %if.end4, %entry
  %1 = load i32, i32* %b.addr, align 4, !dbg !3495
  %and = and i32 %1, 1, !dbg !3496
  %tobool = icmp ne i32 %and, 0, !dbg !3496
  br i1 %tobool, label %if.then, label %if.end, !dbg !3495

if.then:                                          ; preds = %while.body
  %2 = load double, double* %a.addr, align 8, !dbg !3497
  %3 = load double, double* %r, align 8, !dbg !3498
  %mul = fmul double %3, %2, !dbg !3498
  store double %mul, double* %r, align 8, !dbg !3498
  br label %if.end, !dbg !3499

if.end:                                           ; preds = %if.then, %while.body
  %4 = load i32, i32* %b.addr, align 4, !dbg !3500
  %div = sdiv i32 %4, 2, !dbg !3500
  store i32 %div, i32* %b.addr, align 4, !dbg !3500
  %5 = load i32, i32* %b.addr, align 4, !dbg !3501
  %cmp1 = icmp eq i32 %5, 0, !dbg !3502
  br i1 %cmp1, label %if.then3, label %if.end4, !dbg !3501

if.then3:                                         ; preds = %if.end
  br label %while.end, !dbg !3503

if.end4:                                          ; preds = %if.end
  %6 = load double, double* %a.addr, align 8, !dbg !3504
  %7 = load double, double* %a.addr, align 8, !dbg !3505
  %mul5 = fmul double %7, %6, !dbg !3505
  store double %mul5, double* %a.addr, align 8, !dbg !3505
  br label %while.body, !dbg !3494, !llvm.loop !3506

while.end:                                        ; preds = %if.then3
  %8 = load i32, i32* %recip, align 4, !dbg !3508
  %tobool6 = icmp ne i32 %8, 0, !dbg !3508
  br i1 %tobool6, label %cond.true, label %cond.false, !dbg !3508

cond.true:                                        ; preds = %while.end
  %9 = load double, double* %r, align 8, !dbg !3509
  %div7 = fdiv double 1.000000e+00, %9, !dbg !3510
  br label %cond.end, !dbg !3508

cond.false:                                       ; preds = %while.end
  %10 = load double, double* %r, align 8, !dbg !3511
  br label %cond.end, !dbg !3508

cond.end:                                         ; preds = %cond.false, %cond.true
  %cond = phi double [ %div7, %cond.true ], [ %10, %cond.false ], !dbg !3508
  ret double %cond, !dbg !3512
}

; Function Attrs: noinline nounwind
define dso_local arm_aapcscc float @__powisf2(float %a, i32 %b) #0 !dbg !3513 {
entry:
  %a.addr = alloca float, align 4
  %b.addr = alloca i32, align 4
  %recip = alloca i32, align 4
  %r = alloca float, align 4
  store float %a, float* %a.addr, align 4
  store i32 %b, i32* %b.addr, align 4
  %0 = load i32, i32* %b.addr, align 4, !dbg !3514
  %cmp = icmp slt i32 %0, 0, !dbg !3515
  %conv = zext i1 %cmp to i32, !dbg !3515
  store i32 %conv, i32* %recip, align 4, !dbg !3516
  store float 1.000000e+00, float* %r, align 4, !dbg !3517
  br label %while.body, !dbg !3518

while.body:                                       ; preds = %if.end4, %entry
  %1 = load i32, i32* %b.addr, align 4, !dbg !3519
  %and = and i32 %1, 1, !dbg !3520
  %tobool = icmp ne i32 %and, 0, !dbg !3520
  br i1 %tobool, label %if.then, label %if.end, !dbg !3519

if.then:                                          ; preds = %while.body
  %2 = load float, float* %a.addr, align 4, !dbg !3521
  %3 = load float, float* %r, align 4, !dbg !3522
  %mul = fmul float %3, %2, !dbg !3522
  store float %mul, float* %r, align 4, !dbg !3522
  br label %if.end, !dbg !3523

if.end:                                           ; preds = %if.then, %while.body
  %4 = load i32, i32* %b.addr, align 4, !dbg !3524
  %div = sdiv i32 %4, 2, !dbg !3524
  store i32 %div, i32* %b.addr, align 4, !dbg !3524
  %5 = load i32, i32* %b.addr, align 4, !dbg !3525
  %cmp1 = icmp eq i32 %5, 0, !dbg !3526
  br i1 %cmp1, label %if.then3, label %if.end4, !dbg !3525

if.then3:                                         ; preds = %if.end
  br label %while.end, !dbg !3527

if.end4:                                          ; preds = %if.end
  %6 = load float, float* %a.addr, align 4, !dbg !3528
  %7 = load float, float* %a.addr, align 4, !dbg !3529
  %mul5 = fmul float %7, %6, !dbg !3529
  store float %mul5, float* %a.addr, align 4, !dbg !3529
  br label %while.body, !dbg !3518, !llvm.loop !3530

while.end:                                        ; preds = %if.then3
  %8 = load i32, i32* %recip, align 4, !dbg !3532
  %tobool6 = icmp ne i32 %8, 0, !dbg !3532
  br i1 %tobool6, label %cond.true, label %cond.false, !dbg !3532

cond.true:                                        ; preds = %while.end
  %9 = load float, float* %r, align 4, !dbg !3533
  %div7 = fdiv float 1.000000e+00, %9, !dbg !3534
  br label %cond.end, !dbg !3532

cond.false:                                       ; preds = %while.end
  %10 = load float, float* %r, align 4, !dbg !3535
  br label %cond.end, !dbg !3532

cond.end:                                         ; preds = %cond.false, %cond.true
  %cond = phi float [ %div7, %cond.true ], [ %10, %cond.false ], !dbg !3532
  ret float %cond, !dbg !3536
}

; Function Attrs: noinline nounwind
define dso_local arm_aapcscc double @__powixf2(double %a, i32 %b) #0 !dbg !3537 {
entry:
  %a.addr = alloca double, align 8
  %b.addr = alloca i32, align 4
  %recip = alloca i32, align 4
  %r = alloca double, align 8
  store double %a, double* %a.addr, align 8
  store i32 %b, i32* %b.addr, align 4
  %0 = load i32, i32* %b.addr, align 4, !dbg !3538
  %cmp = icmp slt i32 %0, 0, !dbg !3539
  %conv = zext i1 %cmp to i32, !dbg !3539
  store i32 %conv, i32* %recip, align 4, !dbg !3540
  store double 1.000000e+00, double* %r, align 8, !dbg !3541
  br label %while.body, !dbg !3542

while.body:                                       ; preds = %if.end4, %entry
  %1 = load i32, i32* %b.addr, align 4, !dbg !3543
  %and = and i32 %1, 1, !dbg !3544
  %tobool = icmp ne i32 %and, 0, !dbg !3544
  br i1 %tobool, label %if.then, label %if.end, !dbg !3543

if.then:                                          ; preds = %while.body
  %2 = load double, double* %a.addr, align 8, !dbg !3545
  %3 = load double, double* %r, align 8, !dbg !3546
  %mul = fmul double %3, %2, !dbg !3546
  store double %mul, double* %r, align 8, !dbg !3546
  br label %if.end, !dbg !3547

if.end:                                           ; preds = %if.then, %while.body
  %4 = load i32, i32* %b.addr, align 4, !dbg !3548
  %div = sdiv i32 %4, 2, !dbg !3548
  store i32 %div, i32* %b.addr, align 4, !dbg !3548
  %5 = load i32, i32* %b.addr, align 4, !dbg !3549
  %cmp1 = icmp eq i32 %5, 0, !dbg !3550
  br i1 %cmp1, label %if.then3, label %if.end4, !dbg !3549

if.then3:                                         ; preds = %if.end
  br label %while.end, !dbg !3551

if.end4:                                          ; preds = %if.end
  %6 = load double, double* %a.addr, align 8, !dbg !3552
  %7 = load double, double* %a.addr, align 8, !dbg !3553
  %mul5 = fmul double %7, %6, !dbg !3553
  store double %mul5, double* %a.addr, align 8, !dbg !3553
  br label %while.body, !dbg !3542, !llvm.loop !3554

while.end:                                        ; preds = %if.then3
  %8 = load i32, i32* %recip, align 4, !dbg !3556
  %tobool6 = icmp ne i32 %8, 0, !dbg !3556
  br i1 %tobool6, label %cond.true, label %cond.false, !dbg !3556

cond.true:                                        ; preds = %while.end
  %9 = load double, double* %r, align 8, !dbg !3557
  %div7 = fdiv double 1.000000e+00, %9, !dbg !3558
  br label %cond.end, !dbg !3556

cond.false:                                       ; preds = %while.end
  %10 = load double, double* %r, align 8, !dbg !3559
  br label %cond.end, !dbg !3556

cond.end:                                         ; preds = %cond.false, %cond.true
  %cond = phi double [ %div7, %cond.true ], [ %10, %cond.false ], !dbg !3556
  ret double %cond, !dbg !3560
}

; Function Attrs: noinline nounwind
define dso_local arm_aapcscc double @__subdf3(double %a, double %b) #0 !dbg !3561 {
entry:
  %a.addr = alloca double, align 8
  %b.addr = alloca double, align 8
  store double %a, double* %a.addr, align 8
  store double %b, double* %b.addr, align 8
  %0 = load double, double* %a.addr, align 8, !dbg !3562
  %1 = load double, double* %b.addr, align 8, !dbg !3563
  %call = call arm_aapcs_vfpcc i64 @toRep.51(double %1) #4, !dbg !3564
  %xor = xor i64 %call, -9223372036854775808, !dbg !3565
  %call1 = call arm_aapcs_vfpcc double @fromRep.52(i64 %xor) #4, !dbg !3566
  %call2 = call arm_aapcscc double @__adddf3(double %0, double %call1) #4, !dbg !3567
  ret double %call2, !dbg !3568
}

; Function Attrs: noinline nounwind
define internal arm_aapcs_vfpcc i64 @toRep.51(double %x) #0 !dbg !3569 {
entry:
  %x.addr = alloca double, align 8
  %rep = alloca %union.anon.0, align 8
  store double %x, double* %x.addr, align 8
  %f = bitcast %union.anon.0* %rep to double*, !dbg !3570
  %0 = load double, double* %x.addr, align 8, !dbg !3571
  store double %0, double* %f, align 8, !dbg !3570
  %i = bitcast %union.anon.0* %rep to i64*, !dbg !3572
  %1 = load i64, i64* %i, align 8, !dbg !3572
  ret i64 %1, !dbg !3573
}

; Function Attrs: noinline nounwind
define internal arm_aapcs_vfpcc double @fromRep.52(i64 %x) #0 !dbg !3574 {
entry:
  %x.addr = alloca i64, align 8
  %rep = alloca %union.anon.0, align 8
  store i64 %x, i64* %x.addr, align 8
  %i = bitcast %union.anon.0* %rep to i64*, !dbg !3575
  %0 = load i64, i64* %x.addr, align 8, !dbg !3576
  store i64 %0, i64* %i, align 8, !dbg !3575
  %f = bitcast %union.anon.0* %rep to double*, !dbg !3577
  %1 = load double, double* %f, align 8, !dbg !3577
  ret double %1, !dbg !3578
}

; Function Attrs: noinline nounwind
define dso_local arm_aapcscc float @__subsf3(float %a, float %b) #0 !dbg !3579 {
entry:
  %a.addr = alloca float, align 4
  %b.addr = alloca float, align 4
  store float %a, float* %a.addr, align 4
  store float %b, float* %b.addr, align 4
  %0 = load float, float* %a.addr, align 4, !dbg !3580
  %1 = load float, float* %b.addr, align 4, !dbg !3581
  %call = call arm_aapcs_vfpcc i32 @toRep.53(float %1) #4, !dbg !3582
  %xor = xor i32 %call, -2147483648, !dbg !3583
  %call1 = call arm_aapcs_vfpcc float @fromRep.54(i32 %xor) #4, !dbg !3584
  %call2 = call arm_aapcscc float @__addsf3(float %0, float %call1) #4, !dbg !3585
  ret float %call2, !dbg !3586
}

; Function Attrs: noinline nounwind
define internal arm_aapcs_vfpcc i32 @toRep.53(float %x) #0 !dbg !3587 {
entry:
  %x.addr = alloca float, align 4
  %rep = alloca %union.anon.0.0, align 4
  store float %x, float* %x.addr, align 4
  %f = bitcast %union.anon.0.0* %rep to float*, !dbg !3588
  %0 = load float, float* %x.addr, align 4, !dbg !3589
  store float %0, float* %f, align 4, !dbg !3588
  %i = bitcast %union.anon.0.0* %rep to i32*, !dbg !3590
  %1 = load i32, i32* %i, align 4, !dbg !3590
  ret i32 %1, !dbg !3591
}

; Function Attrs: noinline nounwind
define internal arm_aapcs_vfpcc float @fromRep.54(i32 %x) #0 !dbg !3592 {
entry:
  %x.addr = alloca i32, align 4
  %rep = alloca %union.anon.0.0, align 4
  store i32 %x, i32* %x.addr, align 4
  %i = bitcast %union.anon.0.0* %rep to i32*, !dbg !3593
  %0 = load i32, i32* %x.addr, align 4, !dbg !3594
  store i32 %0, i32* %i, align 4, !dbg !3593
  %f = bitcast %union.anon.0.0* %rep to float*, !dbg !3595
  %1 = load float, float* %f, align 4, !dbg !3595
  ret float %1, !dbg !3596
}

; Function Attrs: noinline nounwind
define dso_local arm_aapcscc zeroext i16 @__truncdfhf2(double %a) #0 !dbg !3597 {
entry:
  %a.addr = alloca double, align 8
  store double %a, double* %a.addr, align 8
  %0 = load double, double* %a.addr, align 8, !dbg !3598
  %call = call arm_aapcs_vfpcc zeroext i16 @__truncXfYf2__(double %0) #4, !dbg !3599
  ret i16 %call, !dbg !3600
}

; Function Attrs: noinline nounwind
define internal arm_aapcs_vfpcc zeroext i16 @__truncXfYf2__(double %a) #0 !dbg !3601 {
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
  store i32 64, i32* %srcBits, align 4, !dbg !3603
  store i32 11, i32* %srcExpBits, align 4, !dbg !3604
  store i32 2047, i32* %srcInfExp, align 4, !dbg !3605
  store i32 1023, i32* %srcExpBias, align 4, !dbg !3606
  store i64 4503599627370496, i64* %srcMinNormal, align 8, !dbg !3607
  store i64 4503599627370495, i64* %srcSignificandMask, align 8, !dbg !3608
  store i64 9218868437227405312, i64* %srcInfinity, align 8, !dbg !3609
  store i64 -9223372036854775808, i64* %srcSignMask, align 8, !dbg !3610
  store i64 9223372036854775807, i64* %srcAbsMask, align 8, !dbg !3611
  store i64 4398046511103, i64* %roundMask, align 8, !dbg !3612
  store i64 2199023255552, i64* %halfway, align 8, !dbg !3613
  store i64 2251799813685248, i64* %srcQNaN, align 8, !dbg !3614
  store i64 2251799813685247, i64* %srcNaNCode, align 8, !dbg !3615
  store i32 16, i32* %dstBits, align 4, !dbg !3616
  store i32 5, i32* %dstExpBits, align 4, !dbg !3617
  store i32 31, i32* %dstInfExp, align 4, !dbg !3618
  store i32 15, i32* %dstExpBias, align 4, !dbg !3619
  store i32 1009, i32* %underflowExponent, align 4, !dbg !3620
  store i32 1039, i32* %overflowExponent, align 4, !dbg !3621
  store i64 4544132024016830464, i64* %underflow, align 8, !dbg !3622
  store i64 4679240012837945344, i64* %overflow, align 8, !dbg !3623
  store i16 512, i16* %dstQNaN, align 2, !dbg !3624
  store i16 511, i16* %dstNaNCode, align 2, !dbg !3625
  %0 = load double, double* %a.addr, align 8, !dbg !3626
  %call = call arm_aapcs_vfpcc i64 @srcToRep.55(double %0) #4, !dbg !3627
  store i64 %call, i64* %aRep, align 8, !dbg !3628
  %1 = load i64, i64* %aRep, align 8, !dbg !3629
  %and = and i64 %1, 9223372036854775807, !dbg !3630
  store i64 %and, i64* %aAbs, align 8, !dbg !3631
  %2 = load i64, i64* %aRep, align 8, !dbg !3632
  %and1 = and i64 %2, -9223372036854775808, !dbg !3633
  store i64 %and1, i64* %sign, align 8, !dbg !3634
  %3 = load i64, i64* %aAbs, align 8, !dbg !3635
  %sub = sub i64 %3, 4544132024016830464, !dbg !3636
  %4 = load i64, i64* %aAbs, align 8, !dbg !3637
  %sub2 = sub i64 %4, 4679240012837945344, !dbg !3638
  %cmp = icmp ult i64 %sub, %sub2, !dbg !3639
  br i1 %cmp, label %if.then, label %if.else18, !dbg !3635

if.then:                                          ; preds = %entry
  %5 = load i64, i64* %aAbs, align 8, !dbg !3640
  %shr = lshr i64 %5, 42, !dbg !3641
  %conv = trunc i64 %shr to i16, !dbg !3640
  store i16 %conv, i16* %absResult, align 2, !dbg !3642
  %6 = load i16, i16* %absResult, align 2, !dbg !3643
  %conv3 = zext i16 %6 to i32, !dbg !3643
  %sub4 = sub nsw i32 %conv3, 1032192, !dbg !3643
  %conv5 = trunc i32 %sub4 to i16, !dbg !3643
  store i16 %conv5, i16* %absResult, align 2, !dbg !3643
  %7 = load i64, i64* %aAbs, align 8, !dbg !3644
  %and6 = and i64 %7, 4398046511103, !dbg !3645
  store i64 %and6, i64* %roundBits, align 8, !dbg !3646
  %8 = load i64, i64* %roundBits, align 8, !dbg !3647
  %cmp7 = icmp ugt i64 %8, 2199023255552, !dbg !3648
  br i1 %cmp7, label %if.then9, label %if.else, !dbg !3647

if.then9:                                         ; preds = %if.then
  %9 = load i16, i16* %absResult, align 2, !dbg !3649
  %inc = add i16 %9, 1, !dbg !3649
  store i16 %inc, i16* %absResult, align 2, !dbg !3649
  br label %if.end17, !dbg !3650

if.else:                                          ; preds = %if.then
  %10 = load i64, i64* %roundBits, align 8, !dbg !3651
  %cmp10 = icmp eq i64 %10, 2199023255552, !dbg !3652
  br i1 %cmp10, label %if.then12, label %if.end, !dbg !3651

if.then12:                                        ; preds = %if.else
  %11 = load i16, i16* %absResult, align 2, !dbg !3653
  %conv13 = zext i16 %11 to i32, !dbg !3653
  %and14 = and i32 %conv13, 1, !dbg !3654
  %12 = load i16, i16* %absResult, align 2, !dbg !3655
  %conv15 = zext i16 %12 to i32, !dbg !3655
  %add = add nsw i32 %conv15, %and14, !dbg !3655
  %conv16 = trunc i32 %add to i16, !dbg !3655
  store i16 %conv16, i16* %absResult, align 2, !dbg !3655
  br label %if.end, !dbg !3656

if.end:                                           ; preds = %if.then12, %if.else
  br label %if.end17

if.end17:                                         ; preds = %if.end, %if.then9
  br label %if.end73, !dbg !3657

if.else18:                                        ; preds = %entry
  %13 = load i64, i64* %aAbs, align 8, !dbg !3658
  %cmp19 = icmp ugt i64 %13, 9218868437227405312, !dbg !3659
  br i1 %cmp19, label %if.then21, label %if.else30, !dbg !3658

if.then21:                                        ; preds = %if.else18
  store i16 31744, i16* %absResult, align 2, !dbg !3660
  %14 = load i16, i16* %absResult, align 2, !dbg !3661
  %conv22 = zext i16 %14 to i32, !dbg !3661
  %or = or i32 %conv22, 512, !dbg !3661
  %conv23 = trunc i32 %or to i16, !dbg !3661
  store i16 %conv23, i16* %absResult, align 2, !dbg !3661
  %15 = load i64, i64* %aAbs, align 8, !dbg !3662
  %and24 = and i64 %15, 2251799813685247, !dbg !3663
  %shr25 = lshr i64 %and24, 42, !dbg !3664
  %and26 = and i64 %shr25, 511, !dbg !3665
  %16 = load i16, i16* %absResult, align 2, !dbg !3666
  %conv27 = zext i16 %16 to i64, !dbg !3666
  %or28 = or i64 %conv27, %and26, !dbg !3666
  %conv29 = trunc i64 %or28 to i16, !dbg !3666
  store i16 %conv29, i16* %absResult, align 2, !dbg !3666
  br label %if.end72, !dbg !3667

if.else30:                                        ; preds = %if.else18
  %17 = load i64, i64* %aAbs, align 8, !dbg !3668
  %cmp31 = icmp uge i64 %17, 4679240012837945344, !dbg !3669
  br i1 %cmp31, label %if.then33, label %if.else34, !dbg !3668

if.then33:                                        ; preds = %if.else30
  store i16 31744, i16* %absResult, align 2, !dbg !3670
  br label %if.end71, !dbg !3671

if.else34:                                        ; preds = %if.else30
  %18 = load i64, i64* %aAbs, align 8, !dbg !3672
  %shr35 = lshr i64 %18, 52, !dbg !3673
  %conv36 = trunc i64 %shr35 to i32, !dbg !3672
  store i32 %conv36, i32* %aExp, align 4, !dbg !3674
  %19 = load i32, i32* %aExp, align 4, !dbg !3675
  %sub37 = sub nsw i32 1008, %19, !dbg !3676
  %add38 = add nsw i32 %sub37, 1, !dbg !3677
  store i32 %add38, i32* %shift, align 4, !dbg !3678
  %20 = load i64, i64* %aRep, align 8, !dbg !3679
  %and39 = and i64 %20, 4503599627370495, !dbg !3680
  %or40 = or i64 %and39, 4503599627370496, !dbg !3681
  store i64 %or40, i64* %significand, align 8, !dbg !3682
  %21 = load i32, i32* %shift, align 4, !dbg !3683
  %cmp41 = icmp sgt i32 %21, 52, !dbg !3684
  br i1 %cmp41, label %if.then43, label %if.else44, !dbg !3683

if.then43:                                        ; preds = %if.else34
  store i16 0, i16* %absResult, align 2, !dbg !3685
  br label %if.end70, !dbg !3686

if.else44:                                        ; preds = %if.else34
  %22 = load i64, i64* %significand, align 8, !dbg !3687
  %23 = load i32, i32* %shift, align 4, !dbg !3688
  %sub45 = sub nsw i32 64, %23, !dbg !3689
  %sh_prom = zext i32 %sub45 to i64, !dbg !3690
  %shl = shl i64 %22, %sh_prom, !dbg !3690
  %tobool = icmp ne i64 %shl, 0, !dbg !3687
  %frombool = zext i1 %tobool to i8, !dbg !3691
  store i8 %frombool, i8* %sticky, align 1, !dbg !3691
  %24 = load i64, i64* %significand, align 8, !dbg !3692
  %25 = load i32, i32* %shift, align 4, !dbg !3693
  %sh_prom46 = zext i32 %25 to i64, !dbg !3694
  %shr47 = lshr i64 %24, %sh_prom46, !dbg !3694
  %26 = load i8, i8* %sticky, align 1, !dbg !3695
  %tobool48 = trunc i8 %26 to i1, !dbg !3695
  %conv49 = zext i1 %tobool48 to i64, !dbg !3695
  %or50 = or i64 %shr47, %conv49, !dbg !3696
  store i64 %or50, i64* %denormalizedSignificand, align 8, !dbg !3697
  %27 = load i64, i64* %denormalizedSignificand, align 8, !dbg !3698
  %shr51 = lshr i64 %27, 42, !dbg !3699
  %conv52 = trunc i64 %shr51 to i16, !dbg !3698
  store i16 %conv52, i16* %absResult, align 2, !dbg !3700
  %28 = load i64, i64* %denormalizedSignificand, align 8, !dbg !3701
  %and54 = and i64 %28, 4398046511103, !dbg !3702
  store i64 %and54, i64* %roundBits53, align 8, !dbg !3703
  %29 = load i64, i64* %roundBits53, align 8, !dbg !3704
  %cmp55 = icmp ugt i64 %29, 2199023255552, !dbg !3705
  br i1 %cmp55, label %if.then57, label %if.else59, !dbg !3704

if.then57:                                        ; preds = %if.else44
  %30 = load i16, i16* %absResult, align 2, !dbg !3706
  %inc58 = add i16 %30, 1, !dbg !3706
  store i16 %inc58, i16* %absResult, align 2, !dbg !3706
  br label %if.end69, !dbg !3707

if.else59:                                        ; preds = %if.else44
  %31 = load i64, i64* %roundBits53, align 8, !dbg !3708
  %cmp60 = icmp eq i64 %31, 2199023255552, !dbg !3709
  br i1 %cmp60, label %if.then62, label %if.end68, !dbg !3708

if.then62:                                        ; preds = %if.else59
  %32 = load i16, i16* %absResult, align 2, !dbg !3710
  %conv63 = zext i16 %32 to i32, !dbg !3710
  %and64 = and i32 %conv63, 1, !dbg !3711
  %33 = load i16, i16* %absResult, align 2, !dbg !3712
  %conv65 = zext i16 %33 to i32, !dbg !3712
  %add66 = add nsw i32 %conv65, %and64, !dbg !3712
  %conv67 = trunc i32 %add66 to i16, !dbg !3712
  store i16 %conv67, i16* %absResult, align 2, !dbg !3712
  br label %if.end68, !dbg !3713

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
  %34 = load i16, i16* %absResult, align 2, !dbg !3714
  %conv74 = zext i16 %34 to i64, !dbg !3714
  %35 = load i64, i64* %sign, align 8, !dbg !3715
  %shr75 = lshr i64 %35, 48, !dbg !3716
  %or76 = or i64 %conv74, %shr75, !dbg !3717
  %conv77 = trunc i64 %or76 to i16, !dbg !3714
  store i16 %conv77, i16* %result, align 2, !dbg !3718
  %36 = load i16, i16* %result, align 2, !dbg !3719
  %call78 = call arm_aapcs_vfpcc zeroext i16 @dstFromRep.56(i16 zeroext %36) #4, !dbg !3720
  ret i16 %call78, !dbg !3721
}

; Function Attrs: noinline nounwind
define internal arm_aapcs_vfpcc i64 @srcToRep.55(double %x) #0 !dbg !3722 {
entry:
  %x.addr = alloca double, align 8
  %rep = alloca %union.anon.0, align 8
  store double %x, double* %x.addr, align 8
  %f = bitcast %union.anon.0* %rep to double*, !dbg !3724
  %0 = load double, double* %x.addr, align 8, !dbg !3725
  store double %0, double* %f, align 8, !dbg !3724
  %i = bitcast %union.anon.0* %rep to i64*, !dbg !3726
  %1 = load i64, i64* %i, align 8, !dbg !3726
  ret i64 %1, !dbg !3727
}

; Function Attrs: noinline nounwind
define internal arm_aapcs_vfpcc zeroext i16 @dstFromRep.56(i16 zeroext %x) #0 !dbg !3728 {
entry:
  %x.addr = alloca i16, align 2
  %rep = alloca %union.anon, align 2
  store i16 %x, i16* %x.addr, align 2
  %i = bitcast %union.anon* %rep to i16*, !dbg !3729
  %0 = load i16, i16* %x.addr, align 2, !dbg !3730
  store i16 %0, i16* %i, align 2, !dbg !3729
  %f = bitcast %union.anon* %rep to i16*, !dbg !3731
  %1 = load i16, i16* %f, align 2, !dbg !3731
  ret i16 %1, !dbg !3732
}

; Function Attrs: noinline nounwind
define dso_local arm_aapcscc float @__truncdfsf2(double %a) #0 !dbg !3733 {
entry:
  %a.addr = alloca double, align 8
  store double %a, double* %a.addr, align 8
  %0 = load double, double* %a.addr, align 8, !dbg !3734
  %call = call arm_aapcs_vfpcc float @__truncXfYf2__.57(double %0) #4, !dbg !3735
  ret float %call, !dbg !3736
}

; Function Attrs: noinline nounwind
define internal arm_aapcs_vfpcc float @__truncXfYf2__.57(double %a) #0 !dbg !3737 {
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
  store i32 64, i32* %srcBits, align 4, !dbg !3738
  store i32 11, i32* %srcExpBits, align 4, !dbg !3739
  store i32 2047, i32* %srcInfExp, align 4, !dbg !3740
  store i32 1023, i32* %srcExpBias, align 4, !dbg !3741
  store i64 4503599627370496, i64* %srcMinNormal, align 8, !dbg !3742
  store i64 4503599627370495, i64* %srcSignificandMask, align 8, !dbg !3743
  store i64 9218868437227405312, i64* %srcInfinity, align 8, !dbg !3744
  store i64 -9223372036854775808, i64* %srcSignMask, align 8, !dbg !3745
  store i64 9223372036854775807, i64* %srcAbsMask, align 8, !dbg !3746
  store i64 536870911, i64* %roundMask, align 8, !dbg !3747
  store i64 268435456, i64* %halfway, align 8, !dbg !3748
  store i64 2251799813685248, i64* %srcQNaN, align 8, !dbg !3749
  store i64 2251799813685247, i64* %srcNaNCode, align 8, !dbg !3750
  store i32 32, i32* %dstBits, align 4, !dbg !3751
  store i32 8, i32* %dstExpBits, align 4, !dbg !3752
  store i32 255, i32* %dstInfExp, align 4, !dbg !3753
  store i32 127, i32* %dstExpBias, align 4, !dbg !3754
  store i32 897, i32* %underflowExponent, align 4, !dbg !3755
  store i32 1151, i32* %overflowExponent, align 4, !dbg !3756
  store i64 4039728865751334912, i64* %underflow, align 8, !dbg !3757
  store i64 5183643171103440896, i64* %overflow, align 8, !dbg !3758
  store i32 4194304, i32* %dstQNaN, align 4, !dbg !3759
  store i32 4194303, i32* %dstNaNCode, align 4, !dbg !3760
  %0 = load double, double* %a.addr, align 8, !dbg !3761
  %call = call arm_aapcs_vfpcc i64 @srcToRep.58(double %0) #4, !dbg !3762
  store i64 %call, i64* %aRep, align 8, !dbg !3763
  %1 = load i64, i64* %aRep, align 8, !dbg !3764
  %and = and i64 %1, 9223372036854775807, !dbg !3765
  store i64 %and, i64* %aAbs, align 8, !dbg !3766
  %2 = load i64, i64* %aRep, align 8, !dbg !3767
  %and1 = and i64 %2, -9223372036854775808, !dbg !3768
  store i64 %and1, i64* %sign, align 8, !dbg !3769
  %3 = load i64, i64* %aAbs, align 8, !dbg !3770
  %sub = sub i64 %3, 4039728865751334912, !dbg !3771
  %4 = load i64, i64* %aAbs, align 8, !dbg !3772
  %sub2 = sub i64 %4, 5183643171103440896, !dbg !3773
  %cmp = icmp ult i64 %sub, %sub2, !dbg !3774
  br i1 %cmp, label %if.then, label %if.else13, !dbg !3770

if.then:                                          ; preds = %entry
  %5 = load i64, i64* %aAbs, align 8, !dbg !3775
  %shr = lshr i64 %5, 29, !dbg !3776
  %conv = trunc i64 %shr to i32, !dbg !3775
  store i32 %conv, i32* %absResult, align 4, !dbg !3777
  %6 = load i32, i32* %absResult, align 4, !dbg !3778
  %sub3 = sub i32 %6, -1073741824, !dbg !3778
  store i32 %sub3, i32* %absResult, align 4, !dbg !3778
  %7 = load i64, i64* %aAbs, align 8, !dbg !3779
  %and4 = and i64 %7, 536870911, !dbg !3780
  store i64 %and4, i64* %roundBits, align 8, !dbg !3781
  %8 = load i64, i64* %roundBits, align 8, !dbg !3782
  %cmp5 = icmp ugt i64 %8, 268435456, !dbg !3783
  br i1 %cmp5, label %if.then7, label %if.else, !dbg !3782

if.then7:                                         ; preds = %if.then
  %9 = load i32, i32* %absResult, align 4, !dbg !3784
  %inc = add i32 %9, 1, !dbg !3784
  store i32 %inc, i32* %absResult, align 4, !dbg !3784
  br label %if.end12, !dbg !3785

if.else:                                          ; preds = %if.then
  %10 = load i64, i64* %roundBits, align 8, !dbg !3786
  %cmp8 = icmp eq i64 %10, 268435456, !dbg !3787
  br i1 %cmp8, label %if.then10, label %if.end, !dbg !3786

if.then10:                                        ; preds = %if.else
  %11 = load i32, i32* %absResult, align 4, !dbg !3788
  %and11 = and i32 %11, 1, !dbg !3789
  %12 = load i32, i32* %absResult, align 4, !dbg !3790
  %add = add i32 %12, %and11, !dbg !3790
  store i32 %add, i32* %absResult, align 4, !dbg !3790
  br label %if.end, !dbg !3791

if.end:                                           ; preds = %if.then10, %if.else
  br label %if.end12

if.end12:                                         ; preds = %if.end, %if.then7
  br label %if.end63, !dbg !3792

if.else13:                                        ; preds = %entry
  %13 = load i64, i64* %aAbs, align 8, !dbg !3793
  %cmp14 = icmp ugt i64 %13, 9218868437227405312, !dbg !3794
  br i1 %cmp14, label %if.then16, label %if.else23, !dbg !3793

if.then16:                                        ; preds = %if.else13
  store i32 2139095040, i32* %absResult, align 4, !dbg !3795
  %14 = load i32, i32* %absResult, align 4, !dbg !3796
  %or = or i32 %14, 4194304, !dbg !3796
  store i32 %or, i32* %absResult, align 4, !dbg !3796
  %15 = load i64, i64* %aAbs, align 8, !dbg !3797
  %and17 = and i64 %15, 2251799813685247, !dbg !3798
  %shr18 = lshr i64 %and17, 29, !dbg !3799
  %and19 = and i64 %shr18, 4194303, !dbg !3800
  %16 = load i32, i32* %absResult, align 4, !dbg !3801
  %conv20 = zext i32 %16 to i64, !dbg !3801
  %or21 = or i64 %conv20, %and19, !dbg !3801
  %conv22 = trunc i64 %or21 to i32, !dbg !3801
  store i32 %conv22, i32* %absResult, align 4, !dbg !3801
  br label %if.end62, !dbg !3802

if.else23:                                        ; preds = %if.else13
  %17 = load i64, i64* %aAbs, align 8, !dbg !3803
  %cmp24 = icmp uge i64 %17, 5183643171103440896, !dbg !3804
  br i1 %cmp24, label %if.then26, label %if.else27, !dbg !3803

if.then26:                                        ; preds = %if.else23
  store i32 2139095040, i32* %absResult, align 4, !dbg !3805
  br label %if.end61, !dbg !3806

if.else27:                                        ; preds = %if.else23
  %18 = load i64, i64* %aAbs, align 8, !dbg !3807
  %shr28 = lshr i64 %18, 52, !dbg !3808
  %conv29 = trunc i64 %shr28 to i32, !dbg !3807
  store i32 %conv29, i32* %aExp, align 4, !dbg !3809
  %19 = load i32, i32* %aExp, align 4, !dbg !3810
  %sub30 = sub nsw i32 896, %19, !dbg !3811
  %add31 = add nsw i32 %sub30, 1, !dbg !3812
  store i32 %add31, i32* %shift, align 4, !dbg !3813
  %20 = load i64, i64* %aRep, align 8, !dbg !3814
  %and32 = and i64 %20, 4503599627370495, !dbg !3815
  %or33 = or i64 %and32, 4503599627370496, !dbg !3816
  store i64 %or33, i64* %significand, align 8, !dbg !3817
  %21 = load i32, i32* %shift, align 4, !dbg !3818
  %cmp34 = icmp sgt i32 %21, 52, !dbg !3819
  br i1 %cmp34, label %if.then36, label %if.else37, !dbg !3818

if.then36:                                        ; preds = %if.else27
  store i32 0, i32* %absResult, align 4, !dbg !3820
  br label %if.end60, !dbg !3821

if.else37:                                        ; preds = %if.else27
  %22 = load i64, i64* %significand, align 8, !dbg !3822
  %23 = load i32, i32* %shift, align 4, !dbg !3823
  %sub38 = sub nsw i32 64, %23, !dbg !3824
  %sh_prom = zext i32 %sub38 to i64, !dbg !3825
  %shl = shl i64 %22, %sh_prom, !dbg !3825
  %tobool = icmp ne i64 %shl, 0, !dbg !3822
  %frombool = zext i1 %tobool to i8, !dbg !3826
  store i8 %frombool, i8* %sticky, align 1, !dbg !3826
  %24 = load i64, i64* %significand, align 8, !dbg !3827
  %25 = load i32, i32* %shift, align 4, !dbg !3828
  %sh_prom39 = zext i32 %25 to i64, !dbg !3829
  %shr40 = lshr i64 %24, %sh_prom39, !dbg !3829
  %26 = load i8, i8* %sticky, align 1, !dbg !3830
  %tobool41 = trunc i8 %26 to i1, !dbg !3830
  %conv42 = zext i1 %tobool41 to i64, !dbg !3830
  %or43 = or i64 %shr40, %conv42, !dbg !3831
  store i64 %or43, i64* %denormalizedSignificand, align 8, !dbg !3832
  %27 = load i64, i64* %denormalizedSignificand, align 8, !dbg !3833
  %shr44 = lshr i64 %27, 29, !dbg !3834
  %conv45 = trunc i64 %shr44 to i32, !dbg !3833
  store i32 %conv45, i32* %absResult, align 4, !dbg !3835
  %28 = load i64, i64* %denormalizedSignificand, align 8, !dbg !3836
  %and47 = and i64 %28, 536870911, !dbg !3837
  store i64 %and47, i64* %roundBits46, align 8, !dbg !3838
  %29 = load i64, i64* %roundBits46, align 8, !dbg !3839
  %cmp48 = icmp ugt i64 %29, 268435456, !dbg !3840
  br i1 %cmp48, label %if.then50, label %if.else52, !dbg !3839

if.then50:                                        ; preds = %if.else37
  %30 = load i32, i32* %absResult, align 4, !dbg !3841
  %inc51 = add i32 %30, 1, !dbg !3841
  store i32 %inc51, i32* %absResult, align 4, !dbg !3841
  br label %if.end59, !dbg !3842

if.else52:                                        ; preds = %if.else37
  %31 = load i64, i64* %roundBits46, align 8, !dbg !3843
  %cmp53 = icmp eq i64 %31, 268435456, !dbg !3844
  br i1 %cmp53, label %if.then55, label %if.end58, !dbg !3843

if.then55:                                        ; preds = %if.else52
  %32 = load i32, i32* %absResult, align 4, !dbg !3845
  %and56 = and i32 %32, 1, !dbg !3846
  %33 = load i32, i32* %absResult, align 4, !dbg !3847
  %add57 = add i32 %33, %and56, !dbg !3847
  store i32 %add57, i32* %absResult, align 4, !dbg !3847
  br label %if.end58, !dbg !3848

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
  %34 = load i32, i32* %absResult, align 4, !dbg !3849
  %conv64 = zext i32 %34 to i64, !dbg !3849
  %35 = load i64, i64* %sign, align 8, !dbg !3850
  %shr65 = lshr i64 %35, 32, !dbg !3851
  %or66 = or i64 %conv64, %shr65, !dbg !3852
  %conv67 = trunc i64 %or66 to i32, !dbg !3849
  store i32 %conv67, i32* %result, align 4, !dbg !3853
  %36 = load i32, i32* %result, align 4, !dbg !3854
  %call68 = call arm_aapcs_vfpcc float @dstFromRep.59(i32 %36) #4, !dbg !3855
  ret float %call68, !dbg !3856
}

; Function Attrs: noinline nounwind
define internal arm_aapcs_vfpcc i64 @srcToRep.58(double %x) #0 !dbg !3857 {
entry:
  %x.addr = alloca double, align 8
  %rep = alloca %union.anon.0, align 8
  store double %x, double* %x.addr, align 8
  %f = bitcast %union.anon.0* %rep to double*, !dbg !3858
  %0 = load double, double* %x.addr, align 8, !dbg !3859
  store double %0, double* %f, align 8, !dbg !3858
  %i = bitcast %union.anon.0* %rep to i64*, !dbg !3860
  %1 = load i64, i64* %i, align 8, !dbg !3860
  ret i64 %1, !dbg !3861
}

; Function Attrs: noinline nounwind
define internal arm_aapcs_vfpcc float @dstFromRep.59(i32 %x) #0 !dbg !3862 {
entry:
  %x.addr = alloca i32, align 4
  %rep = alloca %union.anon.0.0, align 4
  store i32 %x, i32* %x.addr, align 4
  %i = bitcast %union.anon.0.0* %rep to i32*, !dbg !3863
  %0 = load i32, i32* %x.addr, align 4, !dbg !3864
  store i32 %0, i32* %i, align 4, !dbg !3863
  %f = bitcast %union.anon.0.0* %rep to float*, !dbg !3865
  %1 = load float, float* %f, align 4, !dbg !3865
  ret float %1, !dbg !3866
}

; Function Attrs: noinline nounwind
define dso_local arm_aapcscc zeroext i16 @__truncsfhf2(float %a) #0 !dbg !3867 {
entry:
  %a.addr = alloca float, align 4
  store float %a, float* %a.addr, align 4
  %0 = load float, float* %a.addr, align 4, !dbg !3868
  %call = call arm_aapcs_vfpcc zeroext i16 @__truncXfYf2__.60(float %0) #4, !dbg !3869
  ret i16 %call, !dbg !3870
}

; Function Attrs: noinline nounwind
define internal arm_aapcs_vfpcc zeroext i16 @__truncXfYf2__.60(float %a) #0 !dbg !3871 {
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
  store i32 32, i32* %srcBits, align 4, !dbg !3872
  store i32 8, i32* %srcExpBits, align 4, !dbg !3873
  store i32 255, i32* %srcInfExp, align 4, !dbg !3874
  store i32 127, i32* %srcExpBias, align 4, !dbg !3875
  store i32 8388608, i32* %srcMinNormal, align 4, !dbg !3876
  store i32 8388607, i32* %srcSignificandMask, align 4, !dbg !3877
  store i32 2139095040, i32* %srcInfinity, align 4, !dbg !3878
  store i32 -2147483648, i32* %srcSignMask, align 4, !dbg !3879
  store i32 2147483647, i32* %srcAbsMask, align 4, !dbg !3880
  store i32 8191, i32* %roundMask, align 4, !dbg !3881
  store i32 4096, i32* %halfway, align 4, !dbg !3882
  store i32 4194304, i32* %srcQNaN, align 4, !dbg !3883
  store i32 4194303, i32* %srcNaNCode, align 4, !dbg !3884
  store i32 16, i32* %dstBits, align 4, !dbg !3885
  store i32 5, i32* %dstExpBits, align 4, !dbg !3886
  store i32 31, i32* %dstInfExp, align 4, !dbg !3887
  store i32 15, i32* %dstExpBias, align 4, !dbg !3888
  store i32 113, i32* %underflowExponent, align 4, !dbg !3889
  store i32 143, i32* %overflowExponent, align 4, !dbg !3890
  store i32 947912704, i32* %underflow, align 4, !dbg !3891
  store i32 1199570944, i32* %overflow, align 4, !dbg !3892
  store i16 512, i16* %dstQNaN, align 2, !dbg !3893
  store i16 511, i16* %dstNaNCode, align 2, !dbg !3894
  %0 = load float, float* %a.addr, align 4, !dbg !3895
  %call = call arm_aapcs_vfpcc i32 @srcToRep.61(float %0) #4, !dbg !3896
  store i32 %call, i32* %aRep, align 4, !dbg !3897
  %1 = load i32, i32* %aRep, align 4, !dbg !3898
  %and = and i32 %1, 2147483647, !dbg !3899
  store i32 %and, i32* %aAbs, align 4, !dbg !3900
  %2 = load i32, i32* %aRep, align 4, !dbg !3901
  %and1 = and i32 %2, -2147483648, !dbg !3902
  store i32 %and1, i32* %sign, align 4, !dbg !3903
  %3 = load i32, i32* %aAbs, align 4, !dbg !3904
  %sub = sub i32 %3, 947912704, !dbg !3905
  %4 = load i32, i32* %aAbs, align 4, !dbg !3906
  %sub2 = sub i32 %4, 1199570944, !dbg !3907
  %cmp = icmp ult i32 %sub, %sub2, !dbg !3908
  br i1 %cmp, label %if.then, label %if.else18, !dbg !3904

if.then:                                          ; preds = %entry
  %5 = load i32, i32* %aAbs, align 4, !dbg !3909
  %shr = lshr i32 %5, 13, !dbg !3910
  %conv = trunc i32 %shr to i16, !dbg !3909
  store i16 %conv, i16* %absResult, align 2, !dbg !3911
  %6 = load i16, i16* %absResult, align 2, !dbg !3912
  %conv3 = zext i16 %6 to i32, !dbg !3912
  %sub4 = sub nsw i32 %conv3, 114688, !dbg !3912
  %conv5 = trunc i32 %sub4 to i16, !dbg !3912
  store i16 %conv5, i16* %absResult, align 2, !dbg !3912
  %7 = load i32, i32* %aAbs, align 4, !dbg !3913
  %and6 = and i32 %7, 8191, !dbg !3914
  store i32 %and6, i32* %roundBits, align 4, !dbg !3915
  %8 = load i32, i32* %roundBits, align 4, !dbg !3916
  %cmp7 = icmp ugt i32 %8, 4096, !dbg !3917
  br i1 %cmp7, label %if.then9, label %if.else, !dbg !3916

if.then9:                                         ; preds = %if.then
  %9 = load i16, i16* %absResult, align 2, !dbg !3918
  %inc = add i16 %9, 1, !dbg !3918
  store i16 %inc, i16* %absResult, align 2, !dbg !3918
  br label %if.end17, !dbg !3919

if.else:                                          ; preds = %if.then
  %10 = load i32, i32* %roundBits, align 4, !dbg !3920
  %cmp10 = icmp eq i32 %10, 4096, !dbg !3921
  br i1 %cmp10, label %if.then12, label %if.end, !dbg !3920

if.then12:                                        ; preds = %if.else
  %11 = load i16, i16* %absResult, align 2, !dbg !3922
  %conv13 = zext i16 %11 to i32, !dbg !3922
  %and14 = and i32 %conv13, 1, !dbg !3923
  %12 = load i16, i16* %absResult, align 2, !dbg !3924
  %conv15 = zext i16 %12 to i32, !dbg !3924
  %add = add nsw i32 %conv15, %and14, !dbg !3924
  %conv16 = trunc i32 %add to i16, !dbg !3924
  store i16 %conv16, i16* %absResult, align 2, !dbg !3924
  br label %if.end, !dbg !3925

if.end:                                           ; preds = %if.then12, %if.else
  br label %if.end17

if.end17:                                         ; preds = %if.end, %if.then9
  br label %if.end71, !dbg !3926

if.else18:                                        ; preds = %entry
  %13 = load i32, i32* %aAbs, align 4, !dbg !3927
  %cmp19 = icmp ugt i32 %13, 2139095040, !dbg !3928
  br i1 %cmp19, label %if.then21, label %if.else30, !dbg !3927

if.then21:                                        ; preds = %if.else18
  store i16 31744, i16* %absResult, align 2, !dbg !3929
  %14 = load i16, i16* %absResult, align 2, !dbg !3930
  %conv22 = zext i16 %14 to i32, !dbg !3930
  %or = or i32 %conv22, 512, !dbg !3930
  %conv23 = trunc i32 %or to i16, !dbg !3930
  store i16 %conv23, i16* %absResult, align 2, !dbg !3930
  %15 = load i32, i32* %aAbs, align 4, !dbg !3931
  %and24 = and i32 %15, 4194303, !dbg !3932
  %shr25 = lshr i32 %and24, 13, !dbg !3933
  %and26 = and i32 %shr25, 511, !dbg !3934
  %16 = load i16, i16* %absResult, align 2, !dbg !3935
  %conv27 = zext i16 %16 to i32, !dbg !3935
  %or28 = or i32 %conv27, %and26, !dbg !3935
  %conv29 = trunc i32 %or28 to i16, !dbg !3935
  store i16 %conv29, i16* %absResult, align 2, !dbg !3935
  br label %if.end70, !dbg !3936

if.else30:                                        ; preds = %if.else18
  %17 = load i32, i32* %aAbs, align 4, !dbg !3937
  %cmp31 = icmp uge i32 %17, 1199570944, !dbg !3938
  br i1 %cmp31, label %if.then33, label %if.else34, !dbg !3937

if.then33:                                        ; preds = %if.else30
  store i16 31744, i16* %absResult, align 2, !dbg !3939
  br label %if.end69, !dbg !3940

if.else34:                                        ; preds = %if.else30
  %18 = load i32, i32* %aAbs, align 4, !dbg !3941
  %shr35 = lshr i32 %18, 23, !dbg !3942
  store i32 %shr35, i32* %aExp, align 4, !dbg !3943
  %19 = load i32, i32* %aExp, align 4, !dbg !3944
  %sub36 = sub nsw i32 112, %19, !dbg !3945
  %add37 = add nsw i32 %sub36, 1, !dbg !3946
  store i32 %add37, i32* %shift, align 4, !dbg !3947
  %20 = load i32, i32* %aRep, align 4, !dbg !3948
  %and38 = and i32 %20, 8388607, !dbg !3949
  %or39 = or i32 %and38, 8388608, !dbg !3950
  store i32 %or39, i32* %significand, align 4, !dbg !3951
  %21 = load i32, i32* %shift, align 4, !dbg !3952
  %cmp40 = icmp sgt i32 %21, 23, !dbg !3953
  br i1 %cmp40, label %if.then42, label %if.else43, !dbg !3952

if.then42:                                        ; preds = %if.else34
  store i16 0, i16* %absResult, align 2, !dbg !3954
  br label %if.end68, !dbg !3955

if.else43:                                        ; preds = %if.else34
  %22 = load i32, i32* %significand, align 4, !dbg !3956
  %23 = load i32, i32* %shift, align 4, !dbg !3957
  %sub44 = sub nsw i32 32, %23, !dbg !3958
  %shl = shl i32 %22, %sub44, !dbg !3959
  %tobool = icmp ne i32 %shl, 0, !dbg !3956
  %frombool = zext i1 %tobool to i8, !dbg !3960
  store i8 %frombool, i8* %sticky, align 1, !dbg !3960
  %24 = load i32, i32* %significand, align 4, !dbg !3961
  %25 = load i32, i32* %shift, align 4, !dbg !3962
  %shr45 = lshr i32 %24, %25, !dbg !3963
  %26 = load i8, i8* %sticky, align 1, !dbg !3964
  %tobool46 = trunc i8 %26 to i1, !dbg !3964
  %conv47 = zext i1 %tobool46 to i32, !dbg !3964
  %or48 = or i32 %shr45, %conv47, !dbg !3965
  store i32 %or48, i32* %denormalizedSignificand, align 4, !dbg !3966
  %27 = load i32, i32* %denormalizedSignificand, align 4, !dbg !3967
  %shr49 = lshr i32 %27, 13, !dbg !3968
  %conv50 = trunc i32 %shr49 to i16, !dbg !3967
  store i16 %conv50, i16* %absResult, align 2, !dbg !3969
  %28 = load i32, i32* %denormalizedSignificand, align 4, !dbg !3970
  %and52 = and i32 %28, 8191, !dbg !3971
  store i32 %and52, i32* %roundBits51, align 4, !dbg !3972
  %29 = load i32, i32* %roundBits51, align 4, !dbg !3973
  %cmp53 = icmp ugt i32 %29, 4096, !dbg !3974
  br i1 %cmp53, label %if.then55, label %if.else57, !dbg !3973

if.then55:                                        ; preds = %if.else43
  %30 = load i16, i16* %absResult, align 2, !dbg !3975
  %inc56 = add i16 %30, 1, !dbg !3975
  store i16 %inc56, i16* %absResult, align 2, !dbg !3975
  br label %if.end67, !dbg !3976

if.else57:                                        ; preds = %if.else43
  %31 = load i32, i32* %roundBits51, align 4, !dbg !3977
  %cmp58 = icmp eq i32 %31, 4096, !dbg !3978
  br i1 %cmp58, label %if.then60, label %if.end66, !dbg !3977

if.then60:                                        ; preds = %if.else57
  %32 = load i16, i16* %absResult, align 2, !dbg !3979
  %conv61 = zext i16 %32 to i32, !dbg !3979
  %and62 = and i32 %conv61, 1, !dbg !3980
  %33 = load i16, i16* %absResult, align 2, !dbg !3981
  %conv63 = zext i16 %33 to i32, !dbg !3981
  %add64 = add nsw i32 %conv63, %and62, !dbg !3981
  %conv65 = trunc i32 %add64 to i16, !dbg !3981
  store i16 %conv65, i16* %absResult, align 2, !dbg !3981
  br label %if.end66, !dbg !3982

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
  %34 = load i16, i16* %absResult, align 2, !dbg !3983
  %conv72 = zext i16 %34 to i32, !dbg !3983
  %35 = load i32, i32* %sign, align 4, !dbg !3984
  %shr73 = lshr i32 %35, 16, !dbg !3985
  %or74 = or i32 %conv72, %shr73, !dbg !3986
  %conv75 = trunc i32 %or74 to i16, !dbg !3983
  store i16 %conv75, i16* %result, align 2, !dbg !3987
  %36 = load i16, i16* %result, align 2, !dbg !3988
  %call76 = call arm_aapcs_vfpcc zeroext i16 @dstFromRep.62(i16 zeroext %36) #4, !dbg !3989
  ret i16 %call76, !dbg !3990
}

; Function Attrs: noinline nounwind
define internal arm_aapcs_vfpcc i32 @srcToRep.61(float %x) #0 !dbg !3991 {
entry:
  %x.addr = alloca float, align 4
  %rep = alloca %union.anon.0.0, align 4
  store float %x, float* %x.addr, align 4
  %f = bitcast %union.anon.0.0* %rep to float*, !dbg !3992
  %0 = load float, float* %x.addr, align 4, !dbg !3993
  store float %0, float* %f, align 4, !dbg !3992
  %i = bitcast %union.anon.0.0* %rep to i32*, !dbg !3994
  %1 = load i32, i32* %i, align 4, !dbg !3994
  ret i32 %1, !dbg !3995
}

; Function Attrs: noinline nounwind
define internal arm_aapcs_vfpcc zeroext i16 @dstFromRep.62(i16 zeroext %x) #0 !dbg !3996 {
entry:
  %x.addr = alloca i16, align 2
  %rep = alloca %union.anon, align 2
  store i16 %x, i16* %x.addr, align 2
  %i = bitcast %union.anon* %rep to i16*, !dbg !3997
  %0 = load i16, i16* %x.addr, align 2, !dbg !3998
  store i16 %0, i16* %i, align 2, !dbg !3997
  %f = bitcast %union.anon* %rep to i16*, !dbg !3999
  %1 = load i16, i16* %f, align 2, !dbg !3999
  ret i16 %1, !dbg !4000
}

; Function Attrs: noinline nounwind
define dso_local arm_aapcscc zeroext i16 @__gnu_f2h_ieee(float %a) #0 !dbg !4001 {
entry:
  %a.addr = alloca float, align 4
  store float %a, float* %a.addr, align 4
  %0 = load float, float* %a.addr, align 4, !dbg !4002
  %call = call arm_aapcscc zeroext i16 @__truncsfhf2(float %0) #4, !dbg !4003
  ret i16 %call, !dbg !4004
}

attributes #0 = { noinline nounwind "correctly-rounded-divide-sqrt-fp-math"="false" "disable-tail-calls"="false" "less-precise-fpmad"="false" "min-legal-vector-width"="0" "no-frame-pointer-elim"="true" "no-frame-pointer-elim-non-leaf" "no-infs-fp-math"="false" "no-jump-tables"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="false" "stack-protector-buffer-size"="8" "target-cpu"="generic" "target-features"="+armv7-a,+d32,+dsp,+fp64,+fpregs,+neon,+strict-align,+vfp2,+vfp2d16,+vfp2d16sp,+vfp2sp,+vfp3,+vfp3d16,+vfp3d16sp,+vfp3sp,-thumb-mode" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #1 = { nounwind readnone speculatable }
attributes #2 = { argmemonly nounwind }
attributes #3 = { noinline noreturn nounwind "correctly-rounded-divide-sqrt-fp-math"="false" "disable-tail-calls"="false" "less-precise-fpmad"="false" "min-legal-vector-width"="0" "no-frame-pointer-elim"="true" "no-frame-pointer-elim-non-leaf" "no-infs-fp-math"="false" "no-jump-tables"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="false" "stack-protector-buffer-size"="8" "target-cpu"="generic" "target-features"="+armv7-a,+d32,+dsp,+fp64,+fpregs,+neon,+strict-align,+vfp2,+vfp2d16,+vfp2d16sp,+vfp2sp,+vfp3,+vfp3d16,+vfp3d16sp,+vfp3sp,-thumb-mode" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #4 = { nobuiltin }
attributes #5 = { nobuiltin noreturn }

!llvm.dbg.cu = !{!0, !3, !5, !7, !9, !11, !13, !15, !17, !19, !21, !23, !25, !27, !29, !31, !33, !35, !37, !39, !41, !43, !45, !47, !49, !51, !53, !55, !57, !59, !61, !63, !65, !67, !69, !71, !73, !75, !77, !79, !81, !83, !85, !87, !89, !91, !93, !95, !97, !99, !101, !103, !105, !107, !109, !111, !113, !115, !117, !119, !121, !123, !125, !127, !129, !131, !133, !135, !137, !139, !141, !143, !145, !147, !149, !151, !153, !155, !157, !159, !161, !163, !165, !167, !169, !171}
!llvm.ident = !{!173, !173, !173, !173, !173, !173, !173, !173, !173, !173, !173, !173, !173, !173, !173, !173, !173, !173, !173, !173, !173, !173, !173, !173, !173, !173, !173, !173, !173, !173, !173, !173, !173, !173, !173, !173, !173, !173, !173, !173, !173, !173, !173, !173, !173, !173, !173, !173, !173, !173, !173, !173, !173, !173, !173, !173, !173, !173, !173, !173, !173, !173, !173, !173, !173, !173, !173, !173, !173, !173, !173, !173, !173, !173, !173, !173, !173, !173, !173, !173, !173, !173, !173, !173, !173, !173}
!llvm.module.flags = !{!174, !175, !176, !177}

!0 = distinct !DICompileUnit(language: DW_LANG_C99, file: !1, producer: "clang version 9.0.0 (tags/RELEASE_900/final)", isOptimized: false, runtimeVersion: 0, emissionKind: LineTablesOnly, enums: !2, nameTableKind: None)
!1 = !DIFile(filename: "adddf3.c", directory: "/llvmta_testcases/libraries/builtinsfloat")
!2 = !{}
!3 = distinct !DICompileUnit(language: DW_LANG_C99, file: !4, producer: "clang version 9.0.0 (tags/RELEASE_900/final)", isOptimized: false, runtimeVersion: 0, emissionKind: LineTablesOnly, enums: !2, nameTableKind: None)
!4 = !DIFile(filename: "addsf3.c", directory: "/llvmta_testcases/libraries/builtinsfloat")
!5 = distinct !DICompileUnit(language: DW_LANG_C99, file: !6, producer: "clang version 9.0.0 (tags/RELEASE_900/final)", isOptimized: false, runtimeVersion: 0, emissionKind: LineTablesOnly, enums: !2, nameTableKind: None)
!6 = !DIFile(filename: "addtf3.c", directory: "/llvmta_testcases/libraries/builtinsfloat")
!7 = distinct !DICompileUnit(language: DW_LANG_C99, file: !8, producer: "clang version 9.0.0 (tags/RELEASE_900/final)", isOptimized: false, runtimeVersion: 0, emissionKind: LineTablesOnly, enums: !2, nameTableKind: None)
!8 = !DIFile(filename: "comparedf2.c", directory: "/llvmta_testcases/libraries/builtinsfloat")
!9 = distinct !DICompileUnit(language: DW_LANG_C99, file: !10, producer: "clang version 9.0.0 (tags/RELEASE_900/final)", isOptimized: false, runtimeVersion: 0, emissionKind: LineTablesOnly, enums: !2, nameTableKind: None)
!10 = !DIFile(filename: "comparesf2.c", directory: "/llvmta_testcases/libraries/builtinsfloat")
!11 = distinct !DICompileUnit(language: DW_LANG_C99, file: !12, producer: "clang version 9.0.0 (tags/RELEASE_900/final)", isOptimized: false, runtimeVersion: 0, emissionKind: LineTablesOnly, enums: !2, nameTableKind: None)
!12 = !DIFile(filename: "comparetf2.c", directory: "/llvmta_testcases/libraries/builtinsfloat")
!13 = distinct !DICompileUnit(language: DW_LANG_C99, file: !14, producer: "clang version 9.0.0 (tags/RELEASE_900/final)", isOptimized: false, runtimeVersion: 0, emissionKind: LineTablesOnly, enums: !2, nameTableKind: None)
!14 = !DIFile(filename: "divdf3.c", directory: "/llvmta_testcases/libraries/builtinsfloat")
!15 = distinct !DICompileUnit(language: DW_LANG_C99, file: !16, producer: "clang version 9.0.0 (tags/RELEASE_900/final)", isOptimized: false, runtimeVersion: 0, emissionKind: LineTablesOnly, enums: !2, nameTableKind: None)
!16 = !DIFile(filename: "divsf3.c", directory: "/llvmta_testcases/libraries/builtinsfloat")
!17 = distinct !DICompileUnit(language: DW_LANG_C99, file: !18, producer: "clang version 9.0.0 (tags/RELEASE_900/final)", isOptimized: false, runtimeVersion: 0, emissionKind: LineTablesOnly, enums: !2, nameTableKind: None)
!18 = !DIFile(filename: "divtf3.c", directory: "/llvmta_testcases/libraries/builtinsfloat")
!19 = distinct !DICompileUnit(language: DW_LANG_C99, file: !20, producer: "clang version 9.0.0 (tags/RELEASE_900/final)", isOptimized: false, runtimeVersion: 0, emissionKind: LineTablesOnly, enums: !2, nameTableKind: None)
!20 = !DIFile(filename: "extenddftf2.c", directory: "/llvmta_testcases/libraries/builtinsfloat")
!21 = distinct !DICompileUnit(language: DW_LANG_C99, file: !22, producer: "clang version 9.0.0 (tags/RELEASE_900/final)", isOptimized: false, runtimeVersion: 0, emissionKind: LineTablesOnly, enums: !2, nameTableKind: None)
!22 = !DIFile(filename: "extendhfsf2.c", directory: "/llvmta_testcases/libraries/builtinsfloat")
!23 = distinct !DICompileUnit(language: DW_LANG_C99, file: !24, producer: "clang version 9.0.0 (tags/RELEASE_900/final)", isOptimized: false, runtimeVersion: 0, emissionKind: LineTablesOnly, enums: !2, nameTableKind: None)
!24 = !DIFile(filename: "extendsfdf2.c", directory: "/llvmta_testcases/libraries/builtinsfloat")
!25 = distinct !DICompileUnit(language: DW_LANG_C99, file: !26, producer: "clang version 9.0.0 (tags/RELEASE_900/final)", isOptimized: false, runtimeVersion: 0, emissionKind: LineTablesOnly, enums: !2, nameTableKind: None)
!26 = !DIFile(filename: "extendsftf2.c", directory: "/llvmta_testcases/libraries/builtinsfloat")
!27 = distinct !DICompileUnit(language: DW_LANG_C99, file: !28, producer: "clang version 9.0.0 (tags/RELEASE_900/final)", isOptimized: false, runtimeVersion: 0, emissionKind: LineTablesOnly, enums: !2, nameTableKind: None)
!28 = !DIFile(filename: "fixdfdi.c", directory: "/llvmta_testcases/libraries/builtinsfloat")
!29 = distinct !DICompileUnit(language: DW_LANG_C99, file: !30, producer: "clang version 9.0.0 (tags/RELEASE_900/final)", isOptimized: false, runtimeVersion: 0, emissionKind: LineTablesOnly, enums: !2, nameTableKind: None)
!30 = !DIFile(filename: "fixdfsi.c", directory: "/llvmta_testcases/libraries/builtinsfloat")
!31 = distinct !DICompileUnit(language: DW_LANG_C99, file: !32, producer: "clang version 9.0.0 (tags/RELEASE_900/final)", isOptimized: false, runtimeVersion: 0, emissionKind: LineTablesOnly, enums: !2, nameTableKind: None)
!32 = !DIFile(filename: "fixdfti.c", directory: "/llvmta_testcases/libraries/builtinsfloat")
!33 = distinct !DICompileUnit(language: DW_LANG_C99, file: !34, producer: "clang version 9.0.0 (tags/RELEASE_900/final)", isOptimized: false, runtimeVersion: 0, emissionKind: LineTablesOnly, enums: !2, nameTableKind: None)
!34 = !DIFile(filename: "fixsfdi.c", directory: "/llvmta_testcases/libraries/builtinsfloat")
!35 = distinct !DICompileUnit(language: DW_LANG_C99, file: !36, producer: "clang version 9.0.0 (tags/RELEASE_900/final)", isOptimized: false, runtimeVersion: 0, emissionKind: LineTablesOnly, enums: !2, nameTableKind: None)
!36 = !DIFile(filename: "fixsfsi.c", directory: "/llvmta_testcases/libraries/builtinsfloat")
!37 = distinct !DICompileUnit(language: DW_LANG_C99, file: !38, producer: "clang version 9.0.0 (tags/RELEASE_900/final)", isOptimized: false, runtimeVersion: 0, emissionKind: LineTablesOnly, enums: !2, nameTableKind: None)
!38 = !DIFile(filename: "fixsfti.c", directory: "/llvmta_testcases/libraries/builtinsfloat")
!39 = distinct !DICompileUnit(language: DW_LANG_C99, file: !40, producer: "clang version 9.0.0 (tags/RELEASE_900/final)", isOptimized: false, runtimeVersion: 0, emissionKind: LineTablesOnly, enums: !2, nameTableKind: None)
!40 = !DIFile(filename: "fixtfdi.c", directory: "/llvmta_testcases/libraries/builtinsfloat")
!41 = distinct !DICompileUnit(language: DW_LANG_C99, file: !42, producer: "clang version 9.0.0 (tags/RELEASE_900/final)", isOptimized: false, runtimeVersion: 0, emissionKind: LineTablesOnly, enums: !2, nameTableKind: None)
!42 = !DIFile(filename: "fixtfsi.c", directory: "/llvmta_testcases/libraries/builtinsfloat")
!43 = distinct !DICompileUnit(language: DW_LANG_C99, file: !44, producer: "clang version 9.0.0 (tags/RELEASE_900/final)", isOptimized: false, runtimeVersion: 0, emissionKind: LineTablesOnly, enums: !2, nameTableKind: None)
!44 = !DIFile(filename: "fixtfti.c", directory: "/llvmta_testcases/libraries/builtinsfloat")
!45 = distinct !DICompileUnit(language: DW_LANG_C99, file: !46, producer: "clang version 9.0.0 (tags/RELEASE_900/final)", isOptimized: false, runtimeVersion: 0, emissionKind: LineTablesOnly, enums: !2, nameTableKind: None)
!46 = !DIFile(filename: "fixunsdfdi.c", directory: "/llvmta_testcases/libraries/builtinsfloat")
!47 = distinct !DICompileUnit(language: DW_LANG_C99, file: !48, producer: "clang version 9.0.0 (tags/RELEASE_900/final)", isOptimized: false, runtimeVersion: 0, emissionKind: LineTablesOnly, enums: !2, nameTableKind: None)
!48 = !DIFile(filename: "fixunsdfsi.c", directory: "/llvmta_testcases/libraries/builtinsfloat")
!49 = distinct !DICompileUnit(language: DW_LANG_C99, file: !50, producer: "clang version 9.0.0 (tags/RELEASE_900/final)", isOptimized: false, runtimeVersion: 0, emissionKind: LineTablesOnly, enums: !2, nameTableKind: None)
!50 = !DIFile(filename: "fixunsdfti.c", directory: "/llvmta_testcases/libraries/builtinsfloat")
!51 = distinct !DICompileUnit(language: DW_LANG_C99, file: !52, producer: "clang version 9.0.0 (tags/RELEASE_900/final)", isOptimized: false, runtimeVersion: 0, emissionKind: LineTablesOnly, enums: !2, nameTableKind: None)
!52 = !DIFile(filename: "fixunssfdi.c", directory: "/llvmta_testcases/libraries/builtinsfloat")
!53 = distinct !DICompileUnit(language: DW_LANG_C99, file: !54, producer: "clang version 9.0.0 (tags/RELEASE_900/final)", isOptimized: false, runtimeVersion: 0, emissionKind: LineTablesOnly, enums: !2, nameTableKind: None)
!54 = !DIFile(filename: "fixunssfsi.c", directory: "/llvmta_testcases/libraries/builtinsfloat")
!55 = distinct !DICompileUnit(language: DW_LANG_C99, file: !56, producer: "clang version 9.0.0 (tags/RELEASE_900/final)", isOptimized: false, runtimeVersion: 0, emissionKind: LineTablesOnly, enums: !2, nameTableKind: None)
!56 = !DIFile(filename: "fixunssfti.c", directory: "/llvmta_testcases/libraries/builtinsfloat")
!57 = distinct !DICompileUnit(language: DW_LANG_C99, file: !58, producer: "clang version 9.0.0 (tags/RELEASE_900/final)", isOptimized: false, runtimeVersion: 0, emissionKind: LineTablesOnly, enums: !2, nameTableKind: None)
!58 = !DIFile(filename: "fixunstfdi.c", directory: "/llvmta_testcases/libraries/builtinsfloat")
!59 = distinct !DICompileUnit(language: DW_LANG_C99, file: !60, producer: "clang version 9.0.0 (tags/RELEASE_900/final)", isOptimized: false, runtimeVersion: 0, emissionKind: LineTablesOnly, enums: !2, nameTableKind: None)
!60 = !DIFile(filename: "fixunstfsi.c", directory: "/llvmta_testcases/libraries/builtinsfloat")
!61 = distinct !DICompileUnit(language: DW_LANG_C99, file: !62, producer: "clang version 9.0.0 (tags/RELEASE_900/final)", isOptimized: false, runtimeVersion: 0, emissionKind: LineTablesOnly, enums: !2, nameTableKind: None)
!62 = !DIFile(filename: "fixunstfti.c", directory: "/llvmta_testcases/libraries/builtinsfloat")
!63 = distinct !DICompileUnit(language: DW_LANG_C99, file: !64, producer: "clang version 9.0.0 (tags/RELEASE_900/final)", isOptimized: false, runtimeVersion: 0, emissionKind: LineTablesOnly, enums: !2, nameTableKind: None)
!64 = !DIFile(filename: "fixunsxfdi.c", directory: "/llvmta_testcases/libraries/builtinsfloat")
!65 = distinct !DICompileUnit(language: DW_LANG_C99, file: !66, producer: "clang version 9.0.0 (tags/RELEASE_900/final)", isOptimized: false, runtimeVersion: 0, emissionKind: LineTablesOnly, enums: !2, nameTableKind: None)
!66 = !DIFile(filename: "fixunsxfsi.c", directory: "/llvmta_testcases/libraries/builtinsfloat")
!67 = distinct !DICompileUnit(language: DW_LANG_C99, file: !68, producer: "clang version 9.0.0 (tags/RELEASE_900/final)", isOptimized: false, runtimeVersion: 0, emissionKind: LineTablesOnly, enums: !2, nameTableKind: None)
!68 = !DIFile(filename: "fixunsxfti.c", directory: "/llvmta_testcases/libraries/builtinsfloat")
!69 = distinct !DICompileUnit(language: DW_LANG_C99, file: !70, producer: "clang version 9.0.0 (tags/RELEASE_900/final)", isOptimized: false, runtimeVersion: 0, emissionKind: LineTablesOnly, enums: !2, nameTableKind: None)
!70 = !DIFile(filename: "fixxfdi.c", directory: "/llvmta_testcases/libraries/builtinsfloat")
!71 = distinct !DICompileUnit(language: DW_LANG_C99, file: !72, producer: "clang version 9.0.0 (tags/RELEASE_900/final)", isOptimized: false, runtimeVersion: 0, emissionKind: LineTablesOnly, enums: !2, nameTableKind: None)
!72 = !DIFile(filename: "fixxfti.c", directory: "/llvmta_testcases/libraries/builtinsfloat")
!73 = distinct !DICompileUnit(language: DW_LANG_C99, file: !74, producer: "clang version 9.0.0 (tags/RELEASE_900/final)", isOptimized: false, runtimeVersion: 0, emissionKind: LineTablesOnly, enums: !2, nameTableKind: None)
!74 = !DIFile(filename: "floatdidf.c", directory: "/llvmta_testcases/libraries/builtinsfloat")
!75 = distinct !DICompileUnit(language: DW_LANG_C99, file: !76, producer: "clang version 9.0.0 (tags/RELEASE_900/final)", isOptimized: false, runtimeVersion: 0, emissionKind: LineTablesOnly, enums: !2, nameTableKind: None)
!76 = !DIFile(filename: "floatdisf.c", directory: "/llvmta_testcases/libraries/builtinsfloat")
!77 = distinct !DICompileUnit(language: DW_LANG_C99, file: !78, producer: "clang version 9.0.0 (tags/RELEASE_900/final)", isOptimized: false, runtimeVersion: 0, emissionKind: LineTablesOnly, enums: !2, nameTableKind: None)
!78 = !DIFile(filename: "floatditf.c", directory: "/llvmta_testcases/libraries/builtinsfloat")
!79 = distinct !DICompileUnit(language: DW_LANG_C99, file: !80, producer: "clang version 9.0.0 (tags/RELEASE_900/final)", isOptimized: false, runtimeVersion: 0, emissionKind: LineTablesOnly, enums: !2, nameTableKind: None)
!80 = !DIFile(filename: "floatdixf.c", directory: "/llvmta_testcases/libraries/builtinsfloat")
!81 = distinct !DICompileUnit(language: DW_LANG_C99, file: !82, producer: "clang version 9.0.0 (tags/RELEASE_900/final)", isOptimized: false, runtimeVersion: 0, emissionKind: LineTablesOnly, enums: !2, nameTableKind: None)
!82 = !DIFile(filename: "floatsidf.c", directory: "/llvmta_testcases/libraries/builtinsfloat")
!83 = distinct !DICompileUnit(language: DW_LANG_C99, file: !84, producer: "clang version 9.0.0 (tags/RELEASE_900/final)", isOptimized: false, runtimeVersion: 0, emissionKind: LineTablesOnly, enums: !2, nameTableKind: None)
!84 = !DIFile(filename: "floatsisf.c", directory: "/llvmta_testcases/libraries/builtinsfloat")
!85 = distinct !DICompileUnit(language: DW_LANG_C99, file: !86, producer: "clang version 9.0.0 (tags/RELEASE_900/final)", isOptimized: false, runtimeVersion: 0, emissionKind: LineTablesOnly, enums: !2, nameTableKind: None)
!86 = !DIFile(filename: "floatsitf.c", directory: "/llvmta_testcases/libraries/builtinsfloat")
!87 = distinct !DICompileUnit(language: DW_LANG_C99, file: !88, producer: "clang version 9.0.0 (tags/RELEASE_900/final)", isOptimized: false, runtimeVersion: 0, emissionKind: LineTablesOnly, enums: !2, nameTableKind: None)
!88 = !DIFile(filename: "floattidf.c", directory: "/llvmta_testcases/libraries/builtinsfloat")
!89 = distinct !DICompileUnit(language: DW_LANG_C99, file: !90, producer: "clang version 9.0.0 (tags/RELEASE_900/final)", isOptimized: false, runtimeVersion: 0, emissionKind: LineTablesOnly, enums: !2, nameTableKind: None)
!90 = !DIFile(filename: "floattisf.c", directory: "/llvmta_testcases/libraries/builtinsfloat")
!91 = distinct !DICompileUnit(language: DW_LANG_C99, file: !92, producer: "clang version 9.0.0 (tags/RELEASE_900/final)", isOptimized: false, runtimeVersion: 0, emissionKind: LineTablesOnly, enums: !2, nameTableKind: None)
!92 = !DIFile(filename: "floattitf.c", directory: "/llvmta_testcases/libraries/builtinsfloat")
!93 = distinct !DICompileUnit(language: DW_LANG_C99, file: !94, producer: "clang version 9.0.0 (tags/RELEASE_900/final)", isOptimized: false, runtimeVersion: 0, emissionKind: LineTablesOnly, enums: !2, nameTableKind: None)
!94 = !DIFile(filename: "floattixf.c", directory: "/llvmta_testcases/libraries/builtinsfloat")
!95 = distinct !DICompileUnit(language: DW_LANG_C99, file: !96, producer: "clang version 9.0.0 (tags/RELEASE_900/final)", isOptimized: false, runtimeVersion: 0, emissionKind: LineTablesOnly, enums: !2, nameTableKind: None)
!96 = !DIFile(filename: "floatundidf.c", directory: "/llvmta_testcases/libraries/builtinsfloat")
!97 = distinct !DICompileUnit(language: DW_LANG_C99, file: !98, producer: "clang version 9.0.0 (tags/RELEASE_900/final)", isOptimized: false, runtimeVersion: 0, emissionKind: LineTablesOnly, enums: !2, nameTableKind: None)
!98 = !DIFile(filename: "floatundisf.c", directory: "/llvmta_testcases/libraries/builtinsfloat")
!99 = distinct !DICompileUnit(language: DW_LANG_C99, file: !100, producer: "clang version 9.0.0 (tags/RELEASE_900/final)", isOptimized: false, runtimeVersion: 0, emissionKind: LineTablesOnly, enums: !2, nameTableKind: None)
!100 = !DIFile(filename: "floatunditf.c", directory: "/llvmta_testcases/libraries/builtinsfloat")
!101 = distinct !DICompileUnit(language: DW_LANG_C99, file: !102, producer: "clang version 9.0.0 (tags/RELEASE_900/final)", isOptimized: false, runtimeVersion: 0, emissionKind: LineTablesOnly, enums: !2, nameTableKind: None)
!102 = !DIFile(filename: "floatundixf.c", directory: "/llvmta_testcases/libraries/builtinsfloat")
!103 = distinct !DICompileUnit(language: DW_LANG_C99, file: !104, producer: "clang version 9.0.0 (tags/RELEASE_900/final)", isOptimized: false, runtimeVersion: 0, emissionKind: LineTablesOnly, enums: !2, nameTableKind: None)
!104 = !DIFile(filename: "floatunsidf.c", directory: "/llvmta_testcases/libraries/builtinsfloat")
!105 = distinct !DICompileUnit(language: DW_LANG_C99, file: !106, producer: "clang version 9.0.0 (tags/RELEASE_900/final)", isOptimized: false, runtimeVersion: 0, emissionKind: LineTablesOnly, enums: !2, nameTableKind: None)
!106 = !DIFile(filename: "floatunsisf.c", directory: "/llvmta_testcases/libraries/builtinsfloat")
!107 = distinct !DICompileUnit(language: DW_LANG_C99, file: !108, producer: "clang version 9.0.0 (tags/RELEASE_900/final)", isOptimized: false, runtimeVersion: 0, emissionKind: LineTablesOnly, enums: !2, nameTableKind: None)
!108 = !DIFile(filename: "floatunsitf.c", directory: "/llvmta_testcases/libraries/builtinsfloat")
!109 = distinct !DICompileUnit(language: DW_LANG_C99, file: !110, producer: "clang version 9.0.0 (tags/RELEASE_900/final)", isOptimized: false, runtimeVersion: 0, emissionKind: LineTablesOnly, enums: !2, nameTableKind: None)
!110 = !DIFile(filename: "floatuntidf.c", directory: "/llvmta_testcases/libraries/builtinsfloat")
!111 = distinct !DICompileUnit(language: DW_LANG_C99, file: !112, producer: "clang version 9.0.0 (tags/RELEASE_900/final)", isOptimized: false, runtimeVersion: 0, emissionKind: LineTablesOnly, enums: !2, nameTableKind: None)
!112 = !DIFile(filename: "floatuntisf.c", directory: "/llvmta_testcases/libraries/builtinsfloat")
!113 = distinct !DICompileUnit(language: DW_LANG_C99, file: !114, producer: "clang version 9.0.0 (tags/RELEASE_900/final)", isOptimized: false, runtimeVersion: 0, emissionKind: LineTablesOnly, enums: !2, nameTableKind: None)
!114 = !DIFile(filename: "floatuntitf.c", directory: "/llvmta_testcases/libraries/builtinsfloat")
!115 = distinct !DICompileUnit(language: DW_LANG_C99, file: !116, producer: "clang version 9.0.0 (tags/RELEASE_900/final)", isOptimized: false, runtimeVersion: 0, emissionKind: LineTablesOnly, enums: !2, nameTableKind: None)
!116 = !DIFile(filename: "floatuntixf.c", directory: "/llvmta_testcases/libraries/builtinsfloat")
!117 = distinct !DICompileUnit(language: DW_LANG_C99, file: !118, producer: "clang version 9.0.0 (tags/RELEASE_900/final)", isOptimized: false, runtimeVersion: 0, emissionKind: LineTablesOnly, enums: !2, nameTableKind: None)
!118 = !DIFile(filename: "int_util.c", directory: "/llvmta_testcases/libraries/builtinsfloat")
!119 = distinct !DICompileUnit(language: DW_LANG_C99, file: !120, producer: "clang version 9.0.0 (tags/RELEASE_900/final)", isOptimized: false, runtimeVersion: 0, emissionKind: LineTablesOnly, enums: !2, nameTableKind: None)
!120 = !DIFile(filename: "muldf3.c", directory: "/llvmta_testcases/libraries/builtinsfloat")
!121 = distinct !DICompileUnit(language: DW_LANG_C99, file: !122, producer: "clang version 9.0.0 (tags/RELEASE_900/final)", isOptimized: false, runtimeVersion: 0, emissionKind: LineTablesOnly, enums: !2, nameTableKind: None)
!122 = !DIFile(filename: "muldi3.c", directory: "/llvmta_testcases/libraries/builtinsfloat")
!123 = distinct !DICompileUnit(language: DW_LANG_C99, file: !124, producer: "clang version 9.0.0 (tags/RELEASE_900/final)", isOptimized: false, runtimeVersion: 0, emissionKind: LineTablesOnly, enums: !2, nameTableKind: None)
!124 = !DIFile(filename: "mulodi4.c", directory: "/llvmta_testcases/libraries/builtinsfloat")
!125 = distinct !DICompileUnit(language: DW_LANG_C99, file: !126, producer: "clang version 9.0.0 (tags/RELEASE_900/final)", isOptimized: false, runtimeVersion: 0, emissionKind: LineTablesOnly, enums: !2, nameTableKind: None)
!126 = !DIFile(filename: "mulosi4.c", directory: "/llvmta_testcases/libraries/builtinsfloat")
!127 = distinct !DICompileUnit(language: DW_LANG_C99, file: !128, producer: "clang version 9.0.0 (tags/RELEASE_900/final)", isOptimized: false, runtimeVersion: 0, emissionKind: LineTablesOnly, enums: !2, nameTableKind: None)
!128 = !DIFile(filename: "muloti4.c", directory: "/llvmta_testcases/libraries/builtinsfloat")
!129 = distinct !DICompileUnit(language: DW_LANG_C99, file: !130, producer: "clang version 9.0.0 (tags/RELEASE_900/final)", isOptimized: false, runtimeVersion: 0, emissionKind: LineTablesOnly, enums: !2, nameTableKind: None)
!130 = !DIFile(filename: "mulsf3.c", directory: "/llvmta_testcases/libraries/builtinsfloat")
!131 = distinct !DICompileUnit(language: DW_LANG_C99, file: !132, producer: "clang version 9.0.0 (tags/RELEASE_900/final)", isOptimized: false, runtimeVersion: 0, emissionKind: LineTablesOnly, enums: !2, nameTableKind: None)
!132 = !DIFile(filename: "multf3.c", directory: "/llvmta_testcases/libraries/builtinsfloat")
!133 = distinct !DICompileUnit(language: DW_LANG_C99, file: !134, producer: "clang version 9.0.0 (tags/RELEASE_900/final)", isOptimized: false, runtimeVersion: 0, emissionKind: LineTablesOnly, enums: !2, nameTableKind: None)
!134 = !DIFile(filename: "multi3.c", directory: "/llvmta_testcases/libraries/builtinsfloat")
!135 = distinct !DICompileUnit(language: DW_LANG_C99, file: !136, producer: "clang version 9.0.0 (tags/RELEASE_900/final)", isOptimized: false, runtimeVersion: 0, emissionKind: LineTablesOnly, enums: !2, nameTableKind: None)
!136 = !DIFile(filename: "negdf2.c", directory: "/llvmta_testcases/libraries/builtinsfloat")
!137 = distinct !DICompileUnit(language: DW_LANG_C99, file: !138, producer: "clang version 9.0.0 (tags/RELEASE_900/final)", isOptimized: false, runtimeVersion: 0, emissionKind: LineTablesOnly, enums: !2, nameTableKind: None)
!138 = !DIFile(filename: "negdi2.c", directory: "/llvmta_testcases/libraries/builtinsfloat")
!139 = distinct !DICompileUnit(language: DW_LANG_C99, file: !140, producer: "clang version 9.0.0 (tags/RELEASE_900/final)", isOptimized: false, runtimeVersion: 0, emissionKind: LineTablesOnly, enums: !2, nameTableKind: None)
!140 = !DIFile(filename: "negsf2.c", directory: "/llvmta_testcases/libraries/builtinsfloat")
!141 = distinct !DICompileUnit(language: DW_LANG_C99, file: !142, producer: "clang version 9.0.0 (tags/RELEASE_900/final)", isOptimized: false, runtimeVersion: 0, emissionKind: LineTablesOnly, enums: !2, nameTableKind: None)
!142 = !DIFile(filename: "negti2.c", directory: "/llvmta_testcases/libraries/builtinsfloat")
!143 = distinct !DICompileUnit(language: DW_LANG_C99, file: !144, producer: "clang version 9.0.0 (tags/RELEASE_900/final)", isOptimized: false, runtimeVersion: 0, emissionKind: LineTablesOnly, enums: !2, nameTableKind: None)
!144 = !DIFile(filename: "negvdi2.c", directory: "/llvmta_testcases/libraries/builtinsfloat")
!145 = distinct !DICompileUnit(language: DW_LANG_C99, file: !146, producer: "clang version 9.0.0 (tags/RELEASE_900/final)", isOptimized: false, runtimeVersion: 0, emissionKind: LineTablesOnly, enums: !2, nameTableKind: None)
!146 = !DIFile(filename: "negvsi2.c", directory: "/llvmta_testcases/libraries/builtinsfloat")
!147 = distinct !DICompileUnit(language: DW_LANG_C99, file: !148, producer: "clang version 9.0.0 (tags/RELEASE_900/final)", isOptimized: false, runtimeVersion: 0, emissionKind: LineTablesOnly, enums: !2, nameTableKind: None)
!148 = !DIFile(filename: "negvti2.c", directory: "/llvmta_testcases/libraries/builtinsfloat")
!149 = distinct !DICompileUnit(language: DW_LANG_C99, file: !150, producer: "clang version 9.0.0 (tags/RELEASE_900/final)", isOptimized: false, runtimeVersion: 0, emissionKind: LineTablesOnly, enums: !2, nameTableKind: None)
!150 = !DIFile(filename: "powidf2.c", directory: "/llvmta_testcases/libraries/builtinsfloat")
!151 = distinct !DICompileUnit(language: DW_LANG_C99, file: !152, producer: "clang version 9.0.0 (tags/RELEASE_900/final)", isOptimized: false, runtimeVersion: 0, emissionKind: LineTablesOnly, enums: !2, nameTableKind: None)
!152 = !DIFile(filename: "powisf2.c", directory: "/llvmta_testcases/libraries/builtinsfloat")
!153 = distinct !DICompileUnit(language: DW_LANG_C99, file: !154, producer: "clang version 9.0.0 (tags/RELEASE_900/final)", isOptimized: false, runtimeVersion: 0, emissionKind: LineTablesOnly, enums: !2, nameTableKind: None)
!154 = !DIFile(filename: "powitf2.c", directory: "/llvmta_testcases/libraries/builtinsfloat")
!155 = distinct !DICompileUnit(language: DW_LANG_C99, file: !156, producer: "clang version 9.0.0 (tags/RELEASE_900/final)", isOptimized: false, runtimeVersion: 0, emissionKind: LineTablesOnly, enums: !2, nameTableKind: None)
!156 = !DIFile(filename: "powixf2.c", directory: "/llvmta_testcases/libraries/builtinsfloat")
!157 = distinct !DICompileUnit(language: DW_LANG_C99, file: !158, producer: "clang version 9.0.0 (tags/RELEASE_900/final)", isOptimized: false, runtimeVersion: 0, emissionKind: LineTablesOnly, enums: !2, nameTableKind: None)
!158 = !DIFile(filename: "subdf3.c", directory: "/llvmta_testcases/libraries/builtinsfloat")
!159 = distinct !DICompileUnit(language: DW_LANG_C99, file: !160, producer: "clang version 9.0.0 (tags/RELEASE_900/final)", isOptimized: false, runtimeVersion: 0, emissionKind: LineTablesOnly, enums: !2, nameTableKind: None)
!160 = !DIFile(filename: "subsf3.c", directory: "/llvmta_testcases/libraries/builtinsfloat")
!161 = distinct !DICompileUnit(language: DW_LANG_C99, file: !162, producer: "clang version 9.0.0 (tags/RELEASE_900/final)", isOptimized: false, runtimeVersion: 0, emissionKind: LineTablesOnly, enums: !2, nameTableKind: None)
!162 = !DIFile(filename: "subtf3.c", directory: "/llvmta_testcases/libraries/builtinsfloat")
!163 = distinct !DICompileUnit(language: DW_LANG_C99, file: !164, producer: "clang version 9.0.0 (tags/RELEASE_900/final)", isOptimized: false, runtimeVersion: 0, emissionKind: LineTablesOnly, enums: !2, nameTableKind: None)
!164 = !DIFile(filename: "truncdfhf2.c", directory: "/llvmta_testcases/libraries/builtinsfloat")
!165 = distinct !DICompileUnit(language: DW_LANG_C99, file: !166, producer: "clang version 9.0.0 (tags/RELEASE_900/final)", isOptimized: false, runtimeVersion: 0, emissionKind: LineTablesOnly, enums: !2, nameTableKind: None)
!166 = !DIFile(filename: "truncdfsf2.c", directory: "/llvmta_testcases/libraries/builtinsfloat")
!167 = distinct !DICompileUnit(language: DW_LANG_C99, file: !168, producer: "clang version 9.0.0 (tags/RELEASE_900/final)", isOptimized: false, runtimeVersion: 0, emissionKind: LineTablesOnly, enums: !2, nameTableKind: None)
!168 = !DIFile(filename: "truncsfhf2.c", directory: "/llvmta_testcases/libraries/builtinsfloat")
!169 = distinct !DICompileUnit(language: DW_LANG_C99, file: !170, producer: "clang version 9.0.0 (tags/RELEASE_900/final)", isOptimized: false, runtimeVersion: 0, emissionKind: LineTablesOnly, enums: !2, nameTableKind: None)
!170 = !DIFile(filename: "trunctfdf2.c", directory: "/llvmta_testcases/libraries/builtinsfloat")
!171 = distinct !DICompileUnit(language: DW_LANG_C99, file: !172, producer: "clang version 9.0.0 (tags/RELEASE_900/final)", isOptimized: false, runtimeVersion: 0, emissionKind: LineTablesOnly, enums: !2, nameTableKind: None)
!172 = !DIFile(filename: "trunctfsf2.c", directory: "/llvmta_testcases/libraries/builtinsfloat")
!173 = !{!"clang version 9.0.0 (tags/RELEASE_900/final)"}
!174 = !{i32 2, !"Dwarf Version", i32 4}
!175 = !{i32 2, !"Debug Info Version", i32 3}
!176 = !{i32 1, !"wchar_size", i32 4}
!177 = !{i32 1, !"min_enum_size", i32 4}
!178 = distinct !DISubprogram(name: "__adddf3", scope: !1, file: !1, line: 20, type: !179, scopeLine: 20, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !0, retainedNodes: !2)
!179 = !DISubroutineType(types: !2)
!180 = !DILocation(line: 21, column: 23, scope: !178)
!181 = !DILocation(line: 21, column: 26, scope: !178)
!182 = !DILocation(line: 21, column: 12, scope: !178)
!183 = !DILocation(line: 21, column: 5, scope: !178)
!184 = distinct !DISubprogram(name: "__addXf3__", scope: !185, file: !185, line: 17, type: !179, scopeLine: 17, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !0, retainedNodes: !2)
!185 = !DIFile(filename: "./fp_add_impl.inc", directory: "/llvmta_testcases/libraries/builtinsfloat")
!186 = !DILocation(line: 18, column: 24, scope: !184)
!187 = !DILocation(line: 18, column: 18, scope: !184)
!188 = !DILocation(line: 18, column: 11, scope: !184)
!189 = !DILocation(line: 19, column: 24, scope: !184)
!190 = !DILocation(line: 19, column: 18, scope: !184)
!191 = !DILocation(line: 19, column: 11, scope: !184)
!192 = !DILocation(line: 20, column: 24, scope: !184)
!193 = !DILocation(line: 20, column: 29, scope: !184)
!194 = !DILocation(line: 20, column: 17, scope: !184)
!195 = !DILocation(line: 21, column: 24, scope: !184)
!196 = !DILocation(line: 21, column: 29, scope: !184)
!197 = !DILocation(line: 21, column: 17, scope: !184)
!198 = !DILocation(line: 24, column: 9, scope: !184)
!199 = !DILocation(line: 24, column: 14, scope: !184)
!200 = !DILocation(line: 24, column: 25, scope: !184)
!201 = !DILocation(line: 24, column: 46, scope: !184)
!202 = !DILocation(line: 25, column: 9, scope: !184)
!203 = !DILocation(line: 25, column: 14, scope: !184)
!204 = !DILocation(line: 25, column: 25, scope: !184)
!205 = !DILocation(line: 27, column: 13, scope: !184)
!206 = !DILocation(line: 27, column: 18, scope: !184)
!207 = !DILocation(line: 27, column: 49, scope: !184)
!208 = !DILocation(line: 27, column: 43, scope: !184)
!209 = !DILocation(line: 27, column: 52, scope: !184)
!210 = !DILocation(line: 27, column: 35, scope: !184)
!211 = !DILocation(line: 27, column: 28, scope: !184)
!212 = !DILocation(line: 29, column: 13, scope: !184)
!213 = !DILocation(line: 29, column: 18, scope: !184)
!214 = !DILocation(line: 29, column: 49, scope: !184)
!215 = !DILocation(line: 29, column: 43, scope: !184)
!216 = !DILocation(line: 29, column: 52, scope: !184)
!217 = !DILocation(line: 29, column: 35, scope: !184)
!218 = !DILocation(line: 29, column: 28, scope: !184)
!219 = !DILocation(line: 31, column: 13, scope: !184)
!220 = !DILocation(line: 31, column: 18, scope: !184)
!221 = !DILocation(line: 33, column: 24, scope: !184)
!222 = !DILocation(line: 33, column: 18, scope: !184)
!223 = !DILocation(line: 33, column: 35, scope: !184)
!224 = !DILocation(line: 33, column: 29, scope: !184)
!225 = !DILocation(line: 33, column: 27, scope: !184)
!226 = !DILocation(line: 33, column: 39, scope: !184)
!227 = !DILocation(line: 33, column: 17, scope: !184)
!228 = !DILocation(line: 33, column: 58, scope: !184)
!229 = !DILocation(line: 33, column: 51, scope: !184)
!230 = !DILocation(line: 35, column: 25, scope: !184)
!231 = !DILocation(line: 35, column: 18, scope: !184)
!232 = !DILocation(line: 39, column: 13, scope: !184)
!233 = !DILocation(line: 39, column: 18, scope: !184)
!234 = !DILocation(line: 39, column: 36, scope: !184)
!235 = !DILocation(line: 39, column: 29, scope: !184)
!236 = !DILocation(line: 42, column: 14, scope: !184)
!237 = !DILocation(line: 42, column: 13, scope: !184)
!238 = !DILocation(line: 44, column: 18, scope: !184)
!239 = !DILocation(line: 44, column: 17, scope: !184)
!240 = !DILocation(line: 44, column: 45, scope: !184)
!241 = !DILocation(line: 44, column: 39, scope: !184)
!242 = !DILocation(line: 44, column: 56, scope: !184)
!243 = !DILocation(line: 44, column: 50, scope: !184)
!244 = !DILocation(line: 44, column: 48, scope: !184)
!245 = !DILocation(line: 44, column: 31, scope: !184)
!246 = !DILocation(line: 44, column: 24, scope: !184)
!247 = !DILocation(line: 45, column: 25, scope: !184)
!248 = !DILocation(line: 45, column: 18, scope: !184)
!249 = !DILocation(line: 49, column: 14, scope: !184)
!250 = !DILocation(line: 49, column: 13, scope: !184)
!251 = !DILocation(line: 49, column: 27, scope: !184)
!252 = !DILocation(line: 49, column: 20, scope: !184)
!253 = !DILocation(line: 50, column: 5, scope: !184)
!254 = !DILocation(line: 53, column: 9, scope: !184)
!255 = !DILocation(line: 53, column: 16, scope: !184)
!256 = !DILocation(line: 53, column: 14, scope: !184)
!257 = !DILocation(line: 54, column: 28, scope: !184)
!258 = !DILocation(line: 54, column: 21, scope: !184)
!259 = !DILocation(line: 55, column: 16, scope: !184)
!260 = !DILocation(line: 55, column: 14, scope: !184)
!261 = !DILocation(line: 56, column: 16, scope: !184)
!262 = !DILocation(line: 56, column: 14, scope: !184)
!263 = !DILocation(line: 57, column: 5, scope: !184)
!264 = !DILocation(line: 60, column: 21, scope: !184)
!265 = !DILocation(line: 60, column: 26, scope: !184)
!266 = !DILocation(line: 60, column: 45, scope: !184)
!267 = !DILocation(line: 60, column: 9, scope: !184)
!268 = !DILocation(line: 61, column: 21, scope: !184)
!269 = !DILocation(line: 61, column: 26, scope: !184)
!270 = !DILocation(line: 61, column: 45, scope: !184)
!271 = !DILocation(line: 61, column: 9, scope: !184)
!272 = !DILocation(line: 62, column: 26, scope: !184)
!273 = !DILocation(line: 62, column: 31, scope: !184)
!274 = !DILocation(line: 62, column: 11, scope: !184)
!275 = !DILocation(line: 63, column: 26, scope: !184)
!276 = !DILocation(line: 63, column: 31, scope: !184)
!277 = !DILocation(line: 63, column: 11, scope: !184)
!278 = !DILocation(line: 66, column: 9, scope: !184)
!279 = !DILocation(line: 66, column: 19, scope: !184)
!280 = !DILocation(line: 66, column: 37, scope: !184)
!281 = !DILocation(line: 66, column: 35, scope: !184)
!282 = !DILocation(line: 66, column: 25, scope: !184)
!283 = !DILocation(line: 67, column: 9, scope: !184)
!284 = !DILocation(line: 67, column: 19, scope: !184)
!285 = !DILocation(line: 67, column: 37, scope: !184)
!286 = !DILocation(line: 67, column: 35, scope: !184)
!287 = !DILocation(line: 67, column: 25, scope: !184)
!288 = !DILocation(line: 71, column: 30, scope: !184)
!289 = !DILocation(line: 71, column: 35, scope: !184)
!290 = !DILocation(line: 71, column: 17, scope: !184)
!291 = !DILocation(line: 72, column: 31, scope: !184)
!292 = !DILocation(line: 72, column: 38, scope: !184)
!293 = !DILocation(line: 72, column: 36, scope: !184)
!294 = !DILocation(line: 72, column: 44, scope: !184)
!295 = !DILocation(line: 72, column: 30, scope: !184)
!296 = !DILocation(line: 72, column: 16, scope: !184)
!297 = !DILocation(line: 78, column: 21, scope: !184)
!298 = !DILocation(line: 78, column: 34, scope: !184)
!299 = !DILocation(line: 78, column: 49, scope: !184)
!300 = !DILocation(line: 78, column: 18, scope: !184)
!301 = !DILocation(line: 79, column: 21, scope: !184)
!302 = !DILocation(line: 79, column: 34, scope: !184)
!303 = !DILocation(line: 79, column: 49, scope: !184)
!304 = !DILocation(line: 79, column: 18, scope: !184)
!305 = !DILocation(line: 83, column: 32, scope: !184)
!306 = !DILocation(line: 83, column: 44, scope: !184)
!307 = !DILocation(line: 83, column: 42, scope: !184)
!308 = !DILocation(line: 83, column: 24, scope: !184)
!309 = !DILocation(line: 84, column: 9, scope: !184)
!310 = !DILocation(line: 85, column: 13, scope: !184)
!311 = !DILocation(line: 85, column: 19, scope: !184)
!312 = !DILocation(line: 86, column: 33, scope: !184)
!313 = !DILocation(line: 86, column: 62, scope: !184)
!314 = !DILocation(line: 86, column: 60, scope: !184)
!315 = !DILocation(line: 86, column: 46, scope: !184)
!316 = !DILocation(line: 86, column: 24, scope: !184)
!317 = !DILocation(line: 87, column: 28, scope: !184)
!318 = !DILocation(line: 87, column: 44, scope: !184)
!319 = !DILocation(line: 87, column: 41, scope: !184)
!320 = !DILocation(line: 87, column: 52, scope: !184)
!321 = !DILocation(line: 87, column: 50, scope: !184)
!322 = !DILocation(line: 87, column: 26, scope: !184)
!323 = !DILocation(line: 88, column: 9, scope: !184)
!324 = !DILocation(line: 89, column: 26, scope: !184)
!325 = !DILocation(line: 91, column: 5, scope: !184)
!326 = !DILocation(line: 92, column: 9, scope: !184)
!327 = !DILocation(line: 93, column: 25, scope: !184)
!328 = !DILocation(line: 93, column: 22, scope: !184)
!329 = !DILocation(line: 95, column: 13, scope: !184)
!330 = !DILocation(line: 95, column: 26, scope: !184)
!331 = !DILocation(line: 95, column: 39, scope: !184)
!332 = !DILocation(line: 95, column: 32, scope: !184)
!333 = !DILocation(line: 99, column: 13, scope: !184)
!334 = !DILocation(line: 99, column: 26, scope: !184)
!335 = !DILocation(line: 100, column: 39, scope: !184)
!336 = !DILocation(line: 100, column: 31, scope: !184)
!337 = !DILocation(line: 100, column: 55, scope: !184)
!338 = !DILocation(line: 100, column: 53, scope: !184)
!339 = !DILocation(line: 100, column: 23, scope: !184)
!340 = !DILocation(line: 101, column: 30, scope: !184)
!341 = !DILocation(line: 101, column: 26, scope: !184)
!342 = !DILocation(line: 102, column: 26, scope: !184)
!343 = !DILocation(line: 102, column: 23, scope: !184)
!344 = !DILocation(line: 103, column: 9, scope: !184)
!345 = !DILocation(line: 104, column: 5, scope: !184)
!346 = !DILocation(line: 106, column: 25, scope: !184)
!347 = !DILocation(line: 106, column: 22, scope: !184)
!348 = !DILocation(line: 110, column: 13, scope: !184)
!349 = !DILocation(line: 110, column: 26, scope: !184)
!350 = !DILocation(line: 111, column: 33, scope: !184)
!351 = !DILocation(line: 111, column: 46, scope: !184)
!352 = !DILocation(line: 111, column: 24, scope: !184)
!353 = !DILocation(line: 112, column: 28, scope: !184)
!354 = !DILocation(line: 112, column: 41, scope: !184)
!355 = !DILocation(line: 112, column: 48, scope: !184)
!356 = !DILocation(line: 112, column: 46, scope: !184)
!357 = !DILocation(line: 112, column: 26, scope: !184)
!358 = !DILocation(line: 113, column: 23, scope: !184)
!359 = !DILocation(line: 114, column: 9, scope: !184)
!360 = !DILocation(line: 118, column: 9, scope: !184)
!361 = !DILocation(line: 118, column: 19, scope: !184)
!362 = !DILocation(line: 118, column: 59, scope: !184)
!363 = !DILocation(line: 118, column: 57, scope: !184)
!364 = !DILocation(line: 118, column: 42, scope: !184)
!365 = !DILocation(line: 118, column: 35, scope: !184)
!366 = !DILocation(line: 120, column: 9, scope: !184)
!367 = !DILocation(line: 120, column: 19, scope: !184)
!368 = !DILocation(line: 123, column: 31, scope: !184)
!369 = !DILocation(line: 123, column: 29, scope: !184)
!370 = !DILocation(line: 123, column: 19, scope: !184)
!371 = !DILocation(line: 124, column: 29, scope: !184)
!372 = !DILocation(line: 124, column: 58, scope: !184)
!373 = !DILocation(line: 124, column: 56, scope: !184)
!374 = !DILocation(line: 124, column: 42, scope: !184)
!375 = !DILocation(line: 124, column: 20, scope: !184)
!376 = !DILocation(line: 125, column: 24, scope: !184)
!377 = !DILocation(line: 125, column: 40, scope: !184)
!378 = !DILocation(line: 125, column: 37, scope: !184)
!379 = !DILocation(line: 125, column: 48, scope: !184)
!380 = !DILocation(line: 125, column: 46, scope: !184)
!381 = !DILocation(line: 125, column: 22, scope: !184)
!382 = !DILocation(line: 126, column: 19, scope: !184)
!383 = !DILocation(line: 127, column: 5, scope: !184)
!384 = !DILocation(line: 130, column: 34, scope: !184)
!385 = !DILocation(line: 130, column: 47, scope: !184)
!386 = !DILocation(line: 130, column: 15, scope: !184)
!387 = !DILocation(line: 133, column: 20, scope: !184)
!388 = !DILocation(line: 133, column: 33, scope: !184)
!389 = !DILocation(line: 133, column: 38, scope: !184)
!390 = !DILocation(line: 133, column: 11, scope: !184)
!391 = !DILocation(line: 136, column: 22, scope: !184)
!392 = !DILocation(line: 136, column: 15, scope: !184)
!393 = !DILocation(line: 136, column: 32, scope: !184)
!394 = !DILocation(line: 136, column: 12, scope: !184)
!395 = !DILocation(line: 137, column: 15, scope: !184)
!396 = !DILocation(line: 137, column: 12, scope: !184)
!397 = !DILocation(line: 141, column: 9, scope: !184)
!398 = !DILocation(line: 141, column: 26, scope: !184)
!399 = !DILocation(line: 141, column: 39, scope: !184)
!400 = !DILocation(line: 141, column: 33, scope: !184)
!401 = !DILocation(line: 142, column: 9, scope: !184)
!402 = !DILocation(line: 142, column: 26, scope: !184)
!403 = !DILocation(line: 142, column: 44, scope: !184)
!404 = !DILocation(line: 142, column: 51, scope: !184)
!405 = !DILocation(line: 142, column: 41, scope: !184)
!406 = !DILocation(line: 142, column: 34, scope: !184)
!407 = !DILocation(line: 143, column: 20, scope: !184)
!408 = !DILocation(line: 143, column: 12, scope: !184)
!409 = !DILocation(line: 143, column: 5, scope: !184)
!410 = !DILocation(line: 144, column: 1, scope: !184)
!411 = distinct !DISubprogram(name: "toRep", scope: !412, file: !412, line: 231, type: !179, scopeLine: 231, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !0, retainedNodes: !2)
!412 = !DIFile(filename: "./fp_lib.h", directory: "/llvmta_testcases/libraries/builtinsfloat")
!413 = !DILocation(line: 232, column: 44, scope: !411)
!414 = !DILocation(line: 232, column: 50, scope: !411)
!415 = !DILocation(line: 233, column: 16, scope: !411)
!416 = !DILocation(line: 233, column: 5, scope: !411)
!417 = distinct !DISubprogram(name: "fromRep", scope: !412, file: !412, line: 236, type: !179, scopeLine: 236, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !0, retainedNodes: !2)
!418 = !DILocation(line: 237, column: 44, scope: !417)
!419 = !DILocation(line: 237, column: 50, scope: !417)
!420 = !DILocation(line: 238, column: 16, scope: !417)
!421 = !DILocation(line: 238, column: 5, scope: !417)
!422 = distinct !DISubprogram(name: "normalize", scope: !412, file: !412, line: 241, type: !179, scopeLine: 241, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !0, retainedNodes: !2)
!423 = !DILocation(line: 242, column: 32, scope: !422)
!424 = !DILocation(line: 242, column: 31, scope: !422)
!425 = !DILocation(line: 242, column: 23, scope: !422)
!426 = !DILocation(line: 242, column: 47, scope: !422)
!427 = !DILocation(line: 242, column: 45, scope: !422)
!428 = !DILocation(line: 242, column: 15, scope: !422)
!429 = !DILocation(line: 243, column: 22, scope: !422)
!430 = !DILocation(line: 243, column: 6, scope: !422)
!431 = !DILocation(line: 243, column: 18, scope: !422)
!432 = !DILocation(line: 244, column: 16, scope: !422)
!433 = !DILocation(line: 244, column: 14, scope: !422)
!434 = !DILocation(line: 244, column: 5, scope: !422)
!435 = distinct !DISubprogram(name: "rep_clz", scope: !412, file: !412, line: 69, type: !179, scopeLine: 69, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !0, retainedNodes: !2)
!436 = !DILocation(line: 73, column: 9, scope: !435)
!437 = !DILocation(line: 73, column: 11, scope: !435)
!438 = !DILocation(line: 74, column: 30, scope: !435)
!439 = !DILocation(line: 74, column: 32, scope: !435)
!440 = !DILocation(line: 74, column: 16, scope: !435)
!441 = !DILocation(line: 74, column: 9, scope: !435)
!442 = !DILocation(line: 76, column: 35, scope: !435)
!443 = !DILocation(line: 76, column: 37, scope: !435)
!444 = !DILocation(line: 76, column: 21, scope: !435)
!445 = !DILocation(line: 76, column: 19, scope: !435)
!446 = !DILocation(line: 76, column: 9, scope: !435)
!447 = !DILocation(line: 78, column: 1, scope: !435)
!448 = distinct !DISubprogram(name: "__addsf3", scope: !4, file: !4, line: 20, type: !179, scopeLine: 20, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !3, retainedNodes: !2)
!449 = !DILocation(line: 21, column: 23, scope: !448)
!450 = !DILocation(line: 21, column: 26, scope: !448)
!451 = !DILocation(line: 21, column: 12, scope: !448)
!452 = !DILocation(line: 21, column: 5, scope: !448)
!453 = distinct !DISubprogram(name: "__addXf3__", scope: !185, file: !185, line: 17, type: !179, scopeLine: 17, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !3, retainedNodes: !2)
!454 = !DILocation(line: 18, column: 24, scope: !453)
!455 = !DILocation(line: 18, column: 18, scope: !453)
!456 = !DILocation(line: 18, column: 11, scope: !453)
!457 = !DILocation(line: 19, column: 24, scope: !453)
!458 = !DILocation(line: 19, column: 18, scope: !453)
!459 = !DILocation(line: 19, column: 11, scope: !453)
!460 = !DILocation(line: 20, column: 24, scope: !453)
!461 = !DILocation(line: 20, column: 29, scope: !453)
!462 = !DILocation(line: 20, column: 17, scope: !453)
!463 = !DILocation(line: 21, column: 24, scope: !453)
!464 = !DILocation(line: 21, column: 29, scope: !453)
!465 = !DILocation(line: 21, column: 17, scope: !453)
!466 = !DILocation(line: 24, column: 9, scope: !453)
!467 = !DILocation(line: 24, column: 14, scope: !453)
!468 = !DILocation(line: 24, column: 25, scope: !453)
!469 = !DILocation(line: 24, column: 46, scope: !453)
!470 = !DILocation(line: 25, column: 9, scope: !453)
!471 = !DILocation(line: 25, column: 14, scope: !453)
!472 = !DILocation(line: 25, column: 25, scope: !453)
!473 = !DILocation(line: 27, column: 13, scope: !453)
!474 = !DILocation(line: 27, column: 18, scope: !453)
!475 = !DILocation(line: 27, column: 49, scope: !453)
!476 = !DILocation(line: 27, column: 43, scope: !453)
!477 = !DILocation(line: 27, column: 52, scope: !453)
!478 = !DILocation(line: 27, column: 35, scope: !453)
!479 = !DILocation(line: 27, column: 28, scope: !453)
!480 = !DILocation(line: 29, column: 13, scope: !453)
!481 = !DILocation(line: 29, column: 18, scope: !453)
!482 = !DILocation(line: 29, column: 49, scope: !453)
!483 = !DILocation(line: 29, column: 43, scope: !453)
!484 = !DILocation(line: 29, column: 52, scope: !453)
!485 = !DILocation(line: 29, column: 35, scope: !453)
!486 = !DILocation(line: 29, column: 28, scope: !453)
!487 = !DILocation(line: 31, column: 13, scope: !453)
!488 = !DILocation(line: 31, column: 18, scope: !453)
!489 = !DILocation(line: 33, column: 24, scope: !453)
!490 = !DILocation(line: 33, column: 18, scope: !453)
!491 = !DILocation(line: 33, column: 35, scope: !453)
!492 = !DILocation(line: 33, column: 29, scope: !453)
!493 = !DILocation(line: 33, column: 27, scope: !453)
!494 = !DILocation(line: 33, column: 39, scope: !453)
!495 = !DILocation(line: 33, column: 17, scope: !453)
!496 = !DILocation(line: 33, column: 58, scope: !453)
!497 = !DILocation(line: 33, column: 51, scope: !453)
!498 = !DILocation(line: 35, column: 25, scope: !453)
!499 = !DILocation(line: 35, column: 18, scope: !453)
!500 = !DILocation(line: 39, column: 13, scope: !453)
!501 = !DILocation(line: 39, column: 18, scope: !453)
!502 = !DILocation(line: 39, column: 36, scope: !453)
!503 = !DILocation(line: 39, column: 29, scope: !453)
!504 = !DILocation(line: 42, column: 14, scope: !453)
!505 = !DILocation(line: 42, column: 13, scope: !453)
!506 = !DILocation(line: 44, column: 18, scope: !453)
!507 = !DILocation(line: 44, column: 17, scope: !453)
!508 = !DILocation(line: 44, column: 45, scope: !453)
!509 = !DILocation(line: 44, column: 39, scope: !453)
!510 = !DILocation(line: 44, column: 56, scope: !453)
!511 = !DILocation(line: 44, column: 50, scope: !453)
!512 = !DILocation(line: 44, column: 48, scope: !453)
!513 = !DILocation(line: 44, column: 31, scope: !453)
!514 = !DILocation(line: 44, column: 24, scope: !453)
!515 = !DILocation(line: 45, column: 25, scope: !453)
!516 = !DILocation(line: 45, column: 18, scope: !453)
!517 = !DILocation(line: 49, column: 14, scope: !453)
!518 = !DILocation(line: 49, column: 13, scope: !453)
!519 = !DILocation(line: 49, column: 27, scope: !453)
!520 = !DILocation(line: 49, column: 20, scope: !453)
!521 = !DILocation(line: 50, column: 5, scope: !453)
!522 = !DILocation(line: 53, column: 9, scope: !453)
!523 = !DILocation(line: 53, column: 16, scope: !453)
!524 = !DILocation(line: 53, column: 14, scope: !453)
!525 = !DILocation(line: 54, column: 28, scope: !453)
!526 = !DILocation(line: 54, column: 21, scope: !453)
!527 = !DILocation(line: 55, column: 16, scope: !453)
!528 = !DILocation(line: 55, column: 14, scope: !453)
!529 = !DILocation(line: 56, column: 16, scope: !453)
!530 = !DILocation(line: 56, column: 14, scope: !453)
!531 = !DILocation(line: 57, column: 5, scope: !453)
!532 = !DILocation(line: 60, column: 21, scope: !453)
!533 = !DILocation(line: 60, column: 26, scope: !453)
!534 = !DILocation(line: 60, column: 45, scope: !453)
!535 = !DILocation(line: 60, column: 9, scope: !453)
!536 = !DILocation(line: 61, column: 21, scope: !453)
!537 = !DILocation(line: 61, column: 26, scope: !453)
!538 = !DILocation(line: 61, column: 45, scope: !453)
!539 = !DILocation(line: 61, column: 9, scope: !453)
!540 = !DILocation(line: 62, column: 26, scope: !453)
!541 = !DILocation(line: 62, column: 31, scope: !453)
!542 = !DILocation(line: 62, column: 11, scope: !453)
!543 = !DILocation(line: 63, column: 26, scope: !453)
!544 = !DILocation(line: 63, column: 31, scope: !453)
!545 = !DILocation(line: 63, column: 11, scope: !453)
!546 = !DILocation(line: 66, column: 9, scope: !453)
!547 = !DILocation(line: 66, column: 19, scope: !453)
!548 = !DILocation(line: 66, column: 37, scope: !453)
!549 = !DILocation(line: 66, column: 35, scope: !453)
!550 = !DILocation(line: 66, column: 25, scope: !453)
!551 = !DILocation(line: 67, column: 9, scope: !453)
!552 = !DILocation(line: 67, column: 19, scope: !453)
!553 = !DILocation(line: 67, column: 37, scope: !453)
!554 = !DILocation(line: 67, column: 35, scope: !453)
!555 = !DILocation(line: 67, column: 25, scope: !453)
!556 = !DILocation(line: 71, column: 30, scope: !453)
!557 = !DILocation(line: 71, column: 35, scope: !453)
!558 = !DILocation(line: 71, column: 17, scope: !453)
!559 = !DILocation(line: 72, column: 31, scope: !453)
!560 = !DILocation(line: 72, column: 38, scope: !453)
!561 = !DILocation(line: 72, column: 36, scope: !453)
!562 = !DILocation(line: 72, column: 44, scope: !453)
!563 = !DILocation(line: 72, column: 30, scope: !453)
!564 = !DILocation(line: 72, column: 16, scope: !453)
!565 = !DILocation(line: 78, column: 21, scope: !453)
!566 = !DILocation(line: 78, column: 34, scope: !453)
!567 = !DILocation(line: 78, column: 49, scope: !453)
!568 = !DILocation(line: 78, column: 18, scope: !453)
!569 = !DILocation(line: 79, column: 21, scope: !453)
!570 = !DILocation(line: 79, column: 34, scope: !453)
!571 = !DILocation(line: 79, column: 49, scope: !453)
!572 = !DILocation(line: 79, column: 18, scope: !453)
!573 = !DILocation(line: 83, column: 32, scope: !453)
!574 = !DILocation(line: 83, column: 44, scope: !453)
!575 = !DILocation(line: 83, column: 42, scope: !453)
!576 = !DILocation(line: 83, column: 24, scope: !453)
!577 = !DILocation(line: 84, column: 9, scope: !453)
!578 = !DILocation(line: 85, column: 13, scope: !453)
!579 = !DILocation(line: 85, column: 19, scope: !453)
!580 = !DILocation(line: 86, column: 33, scope: !453)
!581 = !DILocation(line: 86, column: 62, scope: !453)
!582 = !DILocation(line: 86, column: 60, scope: !453)
!583 = !DILocation(line: 86, column: 46, scope: !453)
!584 = !DILocation(line: 86, column: 24, scope: !453)
!585 = !DILocation(line: 87, column: 28, scope: !453)
!586 = !DILocation(line: 87, column: 44, scope: !453)
!587 = !DILocation(line: 87, column: 41, scope: !453)
!588 = !DILocation(line: 87, column: 52, scope: !453)
!589 = !DILocation(line: 87, column: 50, scope: !453)
!590 = !DILocation(line: 87, column: 26, scope: !453)
!591 = !DILocation(line: 88, column: 9, scope: !453)
!592 = !DILocation(line: 89, column: 26, scope: !453)
!593 = !DILocation(line: 91, column: 5, scope: !453)
!594 = !DILocation(line: 92, column: 9, scope: !453)
!595 = !DILocation(line: 93, column: 25, scope: !453)
!596 = !DILocation(line: 93, column: 22, scope: !453)
!597 = !DILocation(line: 95, column: 13, scope: !453)
!598 = !DILocation(line: 95, column: 26, scope: !453)
!599 = !DILocation(line: 95, column: 39, scope: !453)
!600 = !DILocation(line: 95, column: 32, scope: !453)
!601 = !DILocation(line: 99, column: 13, scope: !453)
!602 = !DILocation(line: 99, column: 26, scope: !453)
!603 = !DILocation(line: 100, column: 39, scope: !453)
!604 = !DILocation(line: 100, column: 31, scope: !453)
!605 = !DILocation(line: 100, column: 55, scope: !453)
!606 = !DILocation(line: 100, column: 53, scope: !453)
!607 = !DILocation(line: 100, column: 23, scope: !453)
!608 = !DILocation(line: 101, column: 30, scope: !453)
!609 = !DILocation(line: 101, column: 26, scope: !453)
!610 = !DILocation(line: 102, column: 26, scope: !453)
!611 = !DILocation(line: 102, column: 23, scope: !453)
!612 = !DILocation(line: 103, column: 9, scope: !453)
!613 = !DILocation(line: 104, column: 5, scope: !453)
!614 = !DILocation(line: 106, column: 25, scope: !453)
!615 = !DILocation(line: 106, column: 22, scope: !453)
!616 = !DILocation(line: 110, column: 13, scope: !453)
!617 = !DILocation(line: 110, column: 26, scope: !453)
!618 = !DILocation(line: 111, column: 33, scope: !453)
!619 = !DILocation(line: 111, column: 46, scope: !453)
!620 = !DILocation(line: 111, column: 24, scope: !453)
!621 = !DILocation(line: 112, column: 28, scope: !453)
!622 = !DILocation(line: 112, column: 41, scope: !453)
!623 = !DILocation(line: 112, column: 48, scope: !453)
!624 = !DILocation(line: 112, column: 46, scope: !453)
!625 = !DILocation(line: 112, column: 26, scope: !453)
!626 = !DILocation(line: 113, column: 23, scope: !453)
!627 = !DILocation(line: 114, column: 9, scope: !453)
!628 = !DILocation(line: 118, column: 9, scope: !453)
!629 = !DILocation(line: 118, column: 19, scope: !453)
!630 = !DILocation(line: 118, column: 59, scope: !453)
!631 = !DILocation(line: 118, column: 57, scope: !453)
!632 = !DILocation(line: 118, column: 42, scope: !453)
!633 = !DILocation(line: 118, column: 35, scope: !453)
!634 = !DILocation(line: 120, column: 9, scope: !453)
!635 = !DILocation(line: 120, column: 19, scope: !453)
!636 = !DILocation(line: 123, column: 31, scope: !453)
!637 = !DILocation(line: 123, column: 29, scope: !453)
!638 = !DILocation(line: 123, column: 19, scope: !453)
!639 = !DILocation(line: 124, column: 29, scope: !453)
!640 = !DILocation(line: 124, column: 58, scope: !453)
!641 = !DILocation(line: 124, column: 56, scope: !453)
!642 = !DILocation(line: 124, column: 42, scope: !453)
!643 = !DILocation(line: 124, column: 20, scope: !453)
!644 = !DILocation(line: 125, column: 24, scope: !453)
!645 = !DILocation(line: 125, column: 40, scope: !453)
!646 = !DILocation(line: 125, column: 37, scope: !453)
!647 = !DILocation(line: 125, column: 48, scope: !453)
!648 = !DILocation(line: 125, column: 46, scope: !453)
!649 = !DILocation(line: 125, column: 22, scope: !453)
!650 = !DILocation(line: 126, column: 19, scope: !453)
!651 = !DILocation(line: 127, column: 5, scope: !453)
!652 = !DILocation(line: 130, column: 34, scope: !453)
!653 = !DILocation(line: 130, column: 47, scope: !453)
!654 = !DILocation(line: 130, column: 15, scope: !453)
!655 = !DILocation(line: 133, column: 20, scope: !453)
!656 = !DILocation(line: 133, column: 33, scope: !453)
!657 = !DILocation(line: 133, column: 38, scope: !453)
!658 = !DILocation(line: 133, column: 11, scope: !453)
!659 = !DILocation(line: 136, column: 22, scope: !453)
!660 = !DILocation(line: 136, column: 32, scope: !453)
!661 = !DILocation(line: 136, column: 12, scope: !453)
!662 = !DILocation(line: 137, column: 15, scope: !453)
!663 = !DILocation(line: 137, column: 12, scope: !453)
!664 = !DILocation(line: 141, column: 9, scope: !453)
!665 = !DILocation(line: 141, column: 26, scope: !453)
!666 = !DILocation(line: 141, column: 39, scope: !453)
!667 = !DILocation(line: 141, column: 33, scope: !453)
!668 = !DILocation(line: 142, column: 9, scope: !453)
!669 = !DILocation(line: 142, column: 26, scope: !453)
!670 = !DILocation(line: 142, column: 44, scope: !453)
!671 = !DILocation(line: 142, column: 51, scope: !453)
!672 = !DILocation(line: 142, column: 41, scope: !453)
!673 = !DILocation(line: 142, column: 34, scope: !453)
!674 = !DILocation(line: 143, column: 20, scope: !453)
!675 = !DILocation(line: 143, column: 12, scope: !453)
!676 = !DILocation(line: 143, column: 5, scope: !453)
!677 = !DILocation(line: 144, column: 1, scope: !453)
!678 = distinct !DISubprogram(name: "toRep", scope: !412, file: !412, line: 231, type: !179, scopeLine: 231, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !3, retainedNodes: !2)
!679 = !DILocation(line: 232, column: 44, scope: !678)
!680 = !DILocation(line: 232, column: 50, scope: !678)
!681 = !DILocation(line: 233, column: 16, scope: !678)
!682 = !DILocation(line: 233, column: 5, scope: !678)
!683 = distinct !DISubprogram(name: "fromRep", scope: !412, file: !412, line: 236, type: !179, scopeLine: 236, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !3, retainedNodes: !2)
!684 = !DILocation(line: 237, column: 44, scope: !683)
!685 = !DILocation(line: 237, column: 50, scope: !683)
!686 = !DILocation(line: 238, column: 16, scope: !683)
!687 = !DILocation(line: 238, column: 5, scope: !683)
!688 = distinct !DISubprogram(name: "normalize", scope: !412, file: !412, line: 241, type: !179, scopeLine: 241, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !3, retainedNodes: !2)
!689 = !DILocation(line: 242, column: 32, scope: !688)
!690 = !DILocation(line: 242, column: 31, scope: !688)
!691 = !DILocation(line: 242, column: 23, scope: !688)
!692 = !DILocation(line: 242, column: 47, scope: !688)
!693 = !DILocation(line: 242, column: 45, scope: !688)
!694 = !DILocation(line: 242, column: 15, scope: !688)
!695 = !DILocation(line: 243, column: 22, scope: !688)
!696 = !DILocation(line: 243, column: 6, scope: !688)
!697 = !DILocation(line: 243, column: 18, scope: !688)
!698 = !DILocation(line: 244, column: 16, scope: !688)
!699 = !DILocation(line: 244, column: 14, scope: !688)
!700 = !DILocation(line: 244, column: 5, scope: !688)
!701 = distinct !DISubprogram(name: "rep_clz", scope: !412, file: !412, line: 49, type: !179, scopeLine: 49, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !3, retainedNodes: !2)
!702 = !DILocation(line: 50, column: 26, scope: !701)
!703 = !DILocation(line: 50, column: 12, scope: !701)
!704 = !DILocation(line: 50, column: 5, scope: !701)
!705 = distinct !DISubprogram(name: "__ledf2", scope: !8, file: !8, line: 51, type: !179, scopeLine: 51, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !7, retainedNodes: !2)
!706 = !DILocation(line: 53, column: 31, scope: !705)
!707 = !DILocation(line: 53, column: 25, scope: !705)
!708 = !DILocation(line: 53, column: 18, scope: !705)
!709 = !DILocation(line: 54, column: 31, scope: !705)
!710 = !DILocation(line: 54, column: 25, scope: !705)
!711 = !DILocation(line: 54, column: 18, scope: !705)
!712 = !DILocation(line: 55, column: 24, scope: !705)
!713 = !DILocation(line: 55, column: 29, scope: !705)
!714 = !DILocation(line: 55, column: 17, scope: !705)
!715 = !DILocation(line: 56, column: 24, scope: !705)
!716 = !DILocation(line: 56, column: 29, scope: !705)
!717 = !DILocation(line: 56, column: 17, scope: !705)
!718 = !DILocation(line: 59, column: 9, scope: !705)
!719 = !DILocation(line: 59, column: 14, scope: !705)
!720 = !DILocation(line: 59, column: 23, scope: !705)
!721 = !DILocation(line: 59, column: 26, scope: !705)
!722 = !DILocation(line: 59, column: 31, scope: !705)
!723 = !DILocation(line: 59, column: 41, scope: !705)
!724 = !DILocation(line: 62, column: 10, scope: !705)
!725 = !DILocation(line: 62, column: 17, scope: !705)
!726 = !DILocation(line: 62, column: 15, scope: !705)
!727 = !DILocation(line: 62, column: 23, scope: !705)
!728 = !DILocation(line: 62, column: 9, scope: !705)
!729 = !DILocation(line: 62, column: 29, scope: !705)
!730 = !DILocation(line: 66, column: 10, scope: !705)
!731 = !DILocation(line: 66, column: 17, scope: !705)
!732 = !DILocation(line: 66, column: 15, scope: !705)
!733 = !DILocation(line: 66, column: 23, scope: !705)
!734 = !DILocation(line: 66, column: 9, scope: !705)
!735 = !DILocation(line: 67, column: 13, scope: !705)
!736 = !DILocation(line: 67, column: 20, scope: !705)
!737 = !DILocation(line: 67, column: 18, scope: !705)
!738 = !DILocation(line: 67, column: 26, scope: !705)
!739 = !DILocation(line: 68, column: 18, scope: !705)
!740 = !DILocation(line: 68, column: 26, scope: !705)
!741 = !DILocation(line: 68, column: 23, scope: !705)
!742 = !DILocation(line: 68, column: 32, scope: !705)
!743 = !DILocation(line: 69, column: 14, scope: !705)
!744 = !DILocation(line: 77, column: 13, scope: !705)
!745 = !DILocation(line: 77, column: 20, scope: !705)
!746 = !DILocation(line: 77, column: 18, scope: !705)
!747 = !DILocation(line: 77, column: 26, scope: !705)
!748 = !DILocation(line: 78, column: 18, scope: !705)
!749 = !DILocation(line: 78, column: 26, scope: !705)
!750 = !DILocation(line: 78, column: 23, scope: !705)
!751 = !DILocation(line: 78, column: 32, scope: !705)
!752 = !DILocation(line: 79, column: 14, scope: !705)
!753 = !DILocation(line: 81, column: 1, scope: !705)
!754 = distinct !DISubprogram(name: "toRep", scope: !412, file: !412, line: 231, type: !179, scopeLine: 231, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !7, retainedNodes: !2)
!755 = !DILocation(line: 232, column: 44, scope: !754)
!756 = !DILocation(line: 232, column: 50, scope: !754)
!757 = !DILocation(line: 233, column: 16, scope: !754)
!758 = !DILocation(line: 233, column: 5, scope: !754)
!759 = distinct !DISubprogram(name: "__gedf2", scope: !8, file: !8, line: 96, type: !179, scopeLine: 96, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !7, retainedNodes: !2)
!760 = !DILocation(line: 98, column: 31, scope: !759)
!761 = !DILocation(line: 98, column: 25, scope: !759)
!762 = !DILocation(line: 98, column: 18, scope: !759)
!763 = !DILocation(line: 99, column: 31, scope: !759)
!764 = !DILocation(line: 99, column: 25, scope: !759)
!765 = !DILocation(line: 99, column: 18, scope: !759)
!766 = !DILocation(line: 100, column: 24, scope: !759)
!767 = !DILocation(line: 100, column: 29, scope: !759)
!768 = !DILocation(line: 100, column: 17, scope: !759)
!769 = !DILocation(line: 101, column: 24, scope: !759)
!770 = !DILocation(line: 101, column: 29, scope: !759)
!771 = !DILocation(line: 101, column: 17, scope: !759)
!772 = !DILocation(line: 103, column: 9, scope: !759)
!773 = !DILocation(line: 103, column: 14, scope: !759)
!774 = !DILocation(line: 103, column: 23, scope: !759)
!775 = !DILocation(line: 103, column: 26, scope: !759)
!776 = !DILocation(line: 103, column: 31, scope: !759)
!777 = !DILocation(line: 103, column: 41, scope: !759)
!778 = !DILocation(line: 104, column: 10, scope: !759)
!779 = !DILocation(line: 104, column: 17, scope: !759)
!780 = !DILocation(line: 104, column: 15, scope: !759)
!781 = !DILocation(line: 104, column: 23, scope: !759)
!782 = !DILocation(line: 104, column: 9, scope: !759)
!783 = !DILocation(line: 104, column: 29, scope: !759)
!784 = !DILocation(line: 105, column: 10, scope: !759)
!785 = !DILocation(line: 105, column: 17, scope: !759)
!786 = !DILocation(line: 105, column: 15, scope: !759)
!787 = !DILocation(line: 105, column: 23, scope: !759)
!788 = !DILocation(line: 105, column: 9, scope: !759)
!789 = !DILocation(line: 106, column: 13, scope: !759)
!790 = !DILocation(line: 106, column: 20, scope: !759)
!791 = !DILocation(line: 106, column: 18, scope: !759)
!792 = !DILocation(line: 106, column: 26, scope: !759)
!793 = !DILocation(line: 107, column: 18, scope: !759)
!794 = !DILocation(line: 107, column: 26, scope: !759)
!795 = !DILocation(line: 107, column: 23, scope: !759)
!796 = !DILocation(line: 107, column: 32, scope: !759)
!797 = !DILocation(line: 108, column: 14, scope: !759)
!798 = !DILocation(line: 110, column: 13, scope: !759)
!799 = !DILocation(line: 110, column: 20, scope: !759)
!800 = !DILocation(line: 110, column: 18, scope: !759)
!801 = !DILocation(line: 110, column: 26, scope: !759)
!802 = !DILocation(line: 111, column: 18, scope: !759)
!803 = !DILocation(line: 111, column: 26, scope: !759)
!804 = !DILocation(line: 111, column: 23, scope: !759)
!805 = !DILocation(line: 111, column: 32, scope: !759)
!806 = !DILocation(line: 112, column: 14, scope: !759)
!807 = !DILocation(line: 114, column: 1, scope: !759)
!808 = distinct !DISubprogram(name: "__unorddf2", scope: !8, file: !8, line: 119, type: !179, scopeLine: 119, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !7, retainedNodes: !2)
!809 = !DILocation(line: 120, column: 30, scope: !808)
!810 = !DILocation(line: 120, column: 24, scope: !808)
!811 = !DILocation(line: 120, column: 33, scope: !808)
!812 = !DILocation(line: 120, column: 17, scope: !808)
!813 = !DILocation(line: 121, column: 30, scope: !808)
!814 = !DILocation(line: 121, column: 24, scope: !808)
!815 = !DILocation(line: 121, column: 33, scope: !808)
!816 = !DILocation(line: 121, column: 17, scope: !808)
!817 = !DILocation(line: 122, column: 12, scope: !808)
!818 = !DILocation(line: 122, column: 17, scope: !808)
!819 = !DILocation(line: 122, column: 26, scope: !808)
!820 = !DILocation(line: 122, column: 29, scope: !808)
!821 = !DILocation(line: 122, column: 34, scope: !808)
!822 = !DILocation(line: 122, column: 5, scope: !808)
!823 = distinct !DISubprogram(name: "__eqdf2", scope: !8, file: !8, line: 128, type: !179, scopeLine: 128, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !7, retainedNodes: !2)
!824 = !DILocation(line: 129, column: 20, scope: !823)
!825 = !DILocation(line: 129, column: 23, scope: !823)
!826 = !DILocation(line: 129, column: 12, scope: !823)
!827 = !DILocation(line: 129, column: 5, scope: !823)
!828 = distinct !DISubprogram(name: "__ltdf2", scope: !8, file: !8, line: 133, type: !179, scopeLine: 133, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !7, retainedNodes: !2)
!829 = !DILocation(line: 134, column: 20, scope: !828)
!830 = !DILocation(line: 134, column: 23, scope: !828)
!831 = !DILocation(line: 134, column: 12, scope: !828)
!832 = !DILocation(line: 134, column: 5, scope: !828)
!833 = distinct !DISubprogram(name: "__nedf2", scope: !8, file: !8, line: 138, type: !179, scopeLine: 138, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !7, retainedNodes: !2)
!834 = !DILocation(line: 139, column: 20, scope: !833)
!835 = !DILocation(line: 139, column: 23, scope: !833)
!836 = !DILocation(line: 139, column: 12, scope: !833)
!837 = !DILocation(line: 139, column: 5, scope: !833)
!838 = distinct !DISubprogram(name: "__gtdf2", scope: !8, file: !8, line: 143, type: !179, scopeLine: 143, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !7, retainedNodes: !2)
!839 = !DILocation(line: 144, column: 20, scope: !838)
!840 = !DILocation(line: 144, column: 23, scope: !838)
!841 = !DILocation(line: 144, column: 12, scope: !838)
!842 = !DILocation(line: 144, column: 5, scope: !838)
!843 = distinct !DISubprogram(name: "__lesf2", scope: !10, file: !10, line: 51, type: !179, scopeLine: 51, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !9, retainedNodes: !2)
!844 = !DILocation(line: 53, column: 31, scope: !843)
!845 = !DILocation(line: 53, column: 25, scope: !843)
!846 = !DILocation(line: 53, column: 18, scope: !843)
!847 = !DILocation(line: 54, column: 31, scope: !843)
!848 = !DILocation(line: 54, column: 25, scope: !843)
!849 = !DILocation(line: 54, column: 18, scope: !843)
!850 = !DILocation(line: 55, column: 24, scope: !843)
!851 = !DILocation(line: 55, column: 29, scope: !843)
!852 = !DILocation(line: 55, column: 17, scope: !843)
!853 = !DILocation(line: 56, column: 24, scope: !843)
!854 = !DILocation(line: 56, column: 29, scope: !843)
!855 = !DILocation(line: 56, column: 17, scope: !843)
!856 = !DILocation(line: 59, column: 9, scope: !843)
!857 = !DILocation(line: 59, column: 14, scope: !843)
!858 = !DILocation(line: 59, column: 23, scope: !843)
!859 = !DILocation(line: 59, column: 26, scope: !843)
!860 = !DILocation(line: 59, column: 31, scope: !843)
!861 = !DILocation(line: 59, column: 41, scope: !843)
!862 = !DILocation(line: 62, column: 10, scope: !843)
!863 = !DILocation(line: 62, column: 17, scope: !843)
!864 = !DILocation(line: 62, column: 15, scope: !843)
!865 = !DILocation(line: 62, column: 23, scope: !843)
!866 = !DILocation(line: 62, column: 9, scope: !843)
!867 = !DILocation(line: 62, column: 29, scope: !843)
!868 = !DILocation(line: 66, column: 10, scope: !843)
!869 = !DILocation(line: 66, column: 17, scope: !843)
!870 = !DILocation(line: 66, column: 15, scope: !843)
!871 = !DILocation(line: 66, column: 23, scope: !843)
!872 = !DILocation(line: 66, column: 9, scope: !843)
!873 = !DILocation(line: 67, column: 13, scope: !843)
!874 = !DILocation(line: 67, column: 20, scope: !843)
!875 = !DILocation(line: 67, column: 18, scope: !843)
!876 = !DILocation(line: 67, column: 26, scope: !843)
!877 = !DILocation(line: 68, column: 18, scope: !843)
!878 = !DILocation(line: 68, column: 26, scope: !843)
!879 = !DILocation(line: 68, column: 23, scope: !843)
!880 = !DILocation(line: 68, column: 32, scope: !843)
!881 = !DILocation(line: 69, column: 14, scope: !843)
!882 = !DILocation(line: 77, column: 13, scope: !843)
!883 = !DILocation(line: 77, column: 20, scope: !843)
!884 = !DILocation(line: 77, column: 18, scope: !843)
!885 = !DILocation(line: 77, column: 26, scope: !843)
!886 = !DILocation(line: 78, column: 18, scope: !843)
!887 = !DILocation(line: 78, column: 26, scope: !843)
!888 = !DILocation(line: 78, column: 23, scope: !843)
!889 = !DILocation(line: 78, column: 32, scope: !843)
!890 = !DILocation(line: 79, column: 14, scope: !843)
!891 = !DILocation(line: 81, column: 1, scope: !843)
!892 = distinct !DISubprogram(name: "toRep", scope: !412, file: !412, line: 231, type: !179, scopeLine: 231, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !9, retainedNodes: !2)
!893 = !DILocation(line: 232, column: 44, scope: !892)
!894 = !DILocation(line: 232, column: 50, scope: !892)
!895 = !DILocation(line: 233, column: 16, scope: !892)
!896 = !DILocation(line: 233, column: 5, scope: !892)
!897 = distinct !DISubprogram(name: "__gesf2", scope: !10, file: !10, line: 96, type: !179, scopeLine: 96, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !9, retainedNodes: !2)
!898 = !DILocation(line: 98, column: 31, scope: !897)
!899 = !DILocation(line: 98, column: 25, scope: !897)
!900 = !DILocation(line: 98, column: 18, scope: !897)
!901 = !DILocation(line: 99, column: 31, scope: !897)
!902 = !DILocation(line: 99, column: 25, scope: !897)
!903 = !DILocation(line: 99, column: 18, scope: !897)
!904 = !DILocation(line: 100, column: 24, scope: !897)
!905 = !DILocation(line: 100, column: 29, scope: !897)
!906 = !DILocation(line: 100, column: 17, scope: !897)
!907 = !DILocation(line: 101, column: 24, scope: !897)
!908 = !DILocation(line: 101, column: 29, scope: !897)
!909 = !DILocation(line: 101, column: 17, scope: !897)
!910 = !DILocation(line: 103, column: 9, scope: !897)
!911 = !DILocation(line: 103, column: 14, scope: !897)
!912 = !DILocation(line: 103, column: 23, scope: !897)
!913 = !DILocation(line: 103, column: 26, scope: !897)
!914 = !DILocation(line: 103, column: 31, scope: !897)
!915 = !DILocation(line: 103, column: 41, scope: !897)
!916 = !DILocation(line: 104, column: 10, scope: !897)
!917 = !DILocation(line: 104, column: 17, scope: !897)
!918 = !DILocation(line: 104, column: 15, scope: !897)
!919 = !DILocation(line: 104, column: 23, scope: !897)
!920 = !DILocation(line: 104, column: 9, scope: !897)
!921 = !DILocation(line: 104, column: 29, scope: !897)
!922 = !DILocation(line: 105, column: 10, scope: !897)
!923 = !DILocation(line: 105, column: 17, scope: !897)
!924 = !DILocation(line: 105, column: 15, scope: !897)
!925 = !DILocation(line: 105, column: 23, scope: !897)
!926 = !DILocation(line: 105, column: 9, scope: !897)
!927 = !DILocation(line: 106, column: 13, scope: !897)
!928 = !DILocation(line: 106, column: 20, scope: !897)
!929 = !DILocation(line: 106, column: 18, scope: !897)
!930 = !DILocation(line: 106, column: 26, scope: !897)
!931 = !DILocation(line: 107, column: 18, scope: !897)
!932 = !DILocation(line: 107, column: 26, scope: !897)
!933 = !DILocation(line: 107, column: 23, scope: !897)
!934 = !DILocation(line: 107, column: 32, scope: !897)
!935 = !DILocation(line: 108, column: 14, scope: !897)
!936 = !DILocation(line: 110, column: 13, scope: !897)
!937 = !DILocation(line: 110, column: 20, scope: !897)
!938 = !DILocation(line: 110, column: 18, scope: !897)
!939 = !DILocation(line: 110, column: 26, scope: !897)
!940 = !DILocation(line: 111, column: 18, scope: !897)
!941 = !DILocation(line: 111, column: 26, scope: !897)
!942 = !DILocation(line: 111, column: 23, scope: !897)
!943 = !DILocation(line: 111, column: 32, scope: !897)
!944 = !DILocation(line: 112, column: 14, scope: !897)
!945 = !DILocation(line: 114, column: 1, scope: !897)
!946 = distinct !DISubprogram(name: "__unordsf2", scope: !10, file: !10, line: 119, type: !179, scopeLine: 119, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !9, retainedNodes: !2)
!947 = !DILocation(line: 120, column: 30, scope: !946)
!948 = !DILocation(line: 120, column: 24, scope: !946)
!949 = !DILocation(line: 120, column: 33, scope: !946)
!950 = !DILocation(line: 120, column: 17, scope: !946)
!951 = !DILocation(line: 121, column: 30, scope: !946)
!952 = !DILocation(line: 121, column: 24, scope: !946)
!953 = !DILocation(line: 121, column: 33, scope: !946)
!954 = !DILocation(line: 121, column: 17, scope: !946)
!955 = !DILocation(line: 122, column: 12, scope: !946)
!956 = !DILocation(line: 122, column: 17, scope: !946)
!957 = !DILocation(line: 122, column: 26, scope: !946)
!958 = !DILocation(line: 122, column: 29, scope: !946)
!959 = !DILocation(line: 122, column: 34, scope: !946)
!960 = !DILocation(line: 122, column: 5, scope: !946)
!961 = distinct !DISubprogram(name: "__eqsf2", scope: !10, file: !10, line: 128, type: !179, scopeLine: 128, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !9, retainedNodes: !2)
!962 = !DILocation(line: 129, column: 20, scope: !961)
!963 = !DILocation(line: 129, column: 23, scope: !961)
!964 = !DILocation(line: 129, column: 12, scope: !961)
!965 = !DILocation(line: 129, column: 5, scope: !961)
!966 = distinct !DISubprogram(name: "__ltsf2", scope: !10, file: !10, line: 133, type: !179, scopeLine: 133, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !9, retainedNodes: !2)
!967 = !DILocation(line: 134, column: 20, scope: !966)
!968 = !DILocation(line: 134, column: 23, scope: !966)
!969 = !DILocation(line: 134, column: 12, scope: !966)
!970 = !DILocation(line: 134, column: 5, scope: !966)
!971 = distinct !DISubprogram(name: "__nesf2", scope: !10, file: !10, line: 138, type: !179, scopeLine: 138, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !9, retainedNodes: !2)
!972 = !DILocation(line: 139, column: 20, scope: !971)
!973 = !DILocation(line: 139, column: 23, scope: !971)
!974 = !DILocation(line: 139, column: 12, scope: !971)
!975 = !DILocation(line: 139, column: 5, scope: !971)
!976 = distinct !DISubprogram(name: "__gtsf2", scope: !10, file: !10, line: 143, type: !179, scopeLine: 143, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !9, retainedNodes: !2)
!977 = !DILocation(line: 144, column: 20, scope: !976)
!978 = !DILocation(line: 144, column: 23, scope: !976)
!979 = !DILocation(line: 144, column: 12, scope: !976)
!980 = !DILocation(line: 144, column: 5, scope: !976)
!981 = distinct !DISubprogram(name: "__divdf3", scope: !14, file: !14, line: 25, type: !179, scopeLine: 25, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !13, retainedNodes: !2)
!982 = !DILocation(line: 27, column: 42, scope: !981)
!983 = !DILocation(line: 27, column: 36, scope: !981)
!984 = !DILocation(line: 27, column: 45, scope: !981)
!985 = !DILocation(line: 27, column: 64, scope: !981)
!986 = !DILocation(line: 27, column: 24, scope: !981)
!987 = !DILocation(line: 28, column: 42, scope: !981)
!988 = !DILocation(line: 28, column: 36, scope: !981)
!989 = !DILocation(line: 28, column: 45, scope: !981)
!990 = !DILocation(line: 28, column: 64, scope: !981)
!991 = !DILocation(line: 28, column: 24, scope: !981)
!992 = !DILocation(line: 29, column: 39, scope: !981)
!993 = !DILocation(line: 29, column: 33, scope: !981)
!994 = !DILocation(line: 29, column: 50, scope: !981)
!995 = !DILocation(line: 29, column: 44, scope: !981)
!996 = !DILocation(line: 29, column: 42, scope: !981)
!997 = !DILocation(line: 29, column: 54, scope: !981)
!998 = !DILocation(line: 29, column: 17, scope: !981)
!999 = !DILocation(line: 31, column: 32, scope: !981)
!1000 = !DILocation(line: 31, column: 26, scope: !981)
!1001 = !DILocation(line: 31, column: 35, scope: !981)
!1002 = !DILocation(line: 31, column: 11, scope: !981)
!1003 = !DILocation(line: 32, column: 32, scope: !981)
!1004 = !DILocation(line: 32, column: 26, scope: !981)
!1005 = !DILocation(line: 32, column: 35, scope: !981)
!1006 = !DILocation(line: 32, column: 11, scope: !981)
!1007 = !DILocation(line: 33, column: 9, scope: !981)
!1008 = !DILocation(line: 36, column: 9, scope: !981)
!1009 = !DILocation(line: 36, column: 18, scope: !981)
!1010 = !DILocation(line: 36, column: 22, scope: !981)
!1011 = !DILocation(line: 36, column: 40, scope: !981)
!1012 = !DILocation(line: 36, column: 43, scope: !981)
!1013 = !DILocation(line: 36, column: 52, scope: !981)
!1014 = !DILocation(line: 36, column: 56, scope: !981)
!1015 = !DILocation(line: 38, column: 34, scope: !981)
!1016 = !DILocation(line: 38, column: 28, scope: !981)
!1017 = !DILocation(line: 38, column: 37, scope: !981)
!1018 = !DILocation(line: 38, column: 21, scope: !981)
!1019 = !DILocation(line: 39, column: 34, scope: !981)
!1020 = !DILocation(line: 39, column: 28, scope: !981)
!1021 = !DILocation(line: 39, column: 37, scope: !981)
!1022 = !DILocation(line: 39, column: 21, scope: !981)
!1023 = !DILocation(line: 42, column: 13, scope: !981)
!1024 = !DILocation(line: 42, column: 18, scope: !981)
!1025 = !DILocation(line: 42, column: 49, scope: !981)
!1026 = !DILocation(line: 42, column: 43, scope: !981)
!1027 = !DILocation(line: 42, column: 52, scope: !981)
!1028 = !DILocation(line: 42, column: 35, scope: !981)
!1029 = !DILocation(line: 42, column: 28, scope: !981)
!1030 = !DILocation(line: 44, column: 13, scope: !981)
!1031 = !DILocation(line: 44, column: 18, scope: !981)
!1032 = !DILocation(line: 44, column: 49, scope: !981)
!1033 = !DILocation(line: 44, column: 43, scope: !981)
!1034 = !DILocation(line: 44, column: 52, scope: !981)
!1035 = !DILocation(line: 44, column: 35, scope: !981)
!1036 = !DILocation(line: 44, column: 28, scope: !981)
!1037 = !DILocation(line: 46, column: 13, scope: !981)
!1038 = !DILocation(line: 46, column: 18, scope: !981)
!1039 = !DILocation(line: 48, column: 17, scope: !981)
!1040 = !DILocation(line: 48, column: 22, scope: !981)
!1041 = !DILocation(line: 48, column: 40, scope: !981)
!1042 = !DILocation(line: 48, column: 33, scope: !981)
!1043 = !DILocation(line: 50, column: 33, scope: !981)
!1044 = !DILocation(line: 50, column: 40, scope: !981)
!1045 = !DILocation(line: 50, column: 38, scope: !981)
!1046 = !DILocation(line: 50, column: 25, scope: !981)
!1047 = !DILocation(line: 50, column: 18, scope: !981)
!1048 = !DILocation(line: 54, column: 13, scope: !981)
!1049 = !DILocation(line: 54, column: 18, scope: !981)
!1050 = !DILocation(line: 54, column: 44, scope: !981)
!1051 = !DILocation(line: 54, column: 36, scope: !981)
!1052 = !DILocation(line: 54, column: 29, scope: !981)
!1053 = !DILocation(line: 56, column: 14, scope: !981)
!1054 = !DILocation(line: 56, column: 13, scope: !981)
!1055 = !DILocation(line: 58, column: 18, scope: !981)
!1056 = !DILocation(line: 58, column: 17, scope: !981)
!1057 = !DILocation(line: 58, column: 31, scope: !981)
!1058 = !DILocation(line: 58, column: 24, scope: !981)
!1059 = !DILocation(line: 60, column: 33, scope: !981)
!1060 = !DILocation(line: 60, column: 25, scope: !981)
!1061 = !DILocation(line: 60, column: 18, scope: !981)
!1062 = !DILocation(line: 63, column: 14, scope: !981)
!1063 = !DILocation(line: 63, column: 13, scope: !981)
!1064 = !DILocation(line: 63, column: 44, scope: !981)
!1065 = !DILocation(line: 63, column: 42, scope: !981)
!1066 = !DILocation(line: 63, column: 27, scope: !981)
!1067 = !DILocation(line: 63, column: 20, scope: !981)
!1068 = !DILocation(line: 68, column: 13, scope: !981)
!1069 = !DILocation(line: 68, column: 18, scope: !981)
!1070 = !DILocation(line: 68, column: 42, scope: !981)
!1071 = !DILocation(line: 68, column: 39, scope: !981)
!1072 = !DILocation(line: 68, column: 33, scope: !981)
!1073 = !DILocation(line: 69, column: 13, scope: !981)
!1074 = !DILocation(line: 69, column: 18, scope: !981)
!1075 = !DILocation(line: 69, column: 42, scope: !981)
!1076 = !DILocation(line: 69, column: 39, scope: !981)
!1077 = !DILocation(line: 69, column: 33, scope: !981)
!1078 = !DILocation(line: 70, column: 5, scope: !981)
!1079 = !DILocation(line: 75, column: 18, scope: !981)
!1080 = !DILocation(line: 76, column: 18, scope: !981)
!1081 = !DILocation(line: 77, column: 28, scope: !981)
!1082 = !DILocation(line: 77, column: 40, scope: !981)
!1083 = !DILocation(line: 77, column: 38, scope: !981)
!1084 = !DILocation(line: 77, column: 52, scope: !981)
!1085 = !DILocation(line: 77, column: 50, scope: !981)
!1086 = !DILocation(line: 77, column: 9, scope: !981)
!1087 = !DILocation(line: 83, column: 27, scope: !981)
!1088 = !DILocation(line: 83, column: 40, scope: !981)
!1089 = !DILocation(line: 83, column: 20, scope: !981)
!1090 = !DILocation(line: 84, column: 47, scope: !981)
!1091 = !DILocation(line: 84, column: 45, scope: !981)
!1092 = !DILocation(line: 84, column: 14, scope: !981)
!1093 = !DILocation(line: 94, column: 32, scope: !981)
!1094 = !DILocation(line: 94, column: 22, scope: !981)
!1095 = !DILocation(line: 94, column: 42, scope: !981)
!1096 = !DILocation(line: 94, column: 40, scope: !981)
!1097 = !DILocation(line: 94, column: 47, scope: !981)
!1098 = !DILocation(line: 94, column: 20, scope: !981)
!1099 = !DILocation(line: 94, column: 18, scope: !981)
!1100 = !DILocation(line: 95, column: 25, scope: !981)
!1101 = !DILocation(line: 95, column: 15, scope: !981)
!1102 = !DILocation(line: 95, column: 35, scope: !981)
!1103 = !DILocation(line: 95, column: 33, scope: !981)
!1104 = !DILocation(line: 95, column: 48, scope: !981)
!1105 = !DILocation(line: 95, column: 13, scope: !981)
!1106 = !DILocation(line: 96, column: 32, scope: !981)
!1107 = !DILocation(line: 96, column: 22, scope: !981)
!1108 = !DILocation(line: 96, column: 42, scope: !981)
!1109 = !DILocation(line: 96, column: 40, scope: !981)
!1110 = !DILocation(line: 96, column: 47, scope: !981)
!1111 = !DILocation(line: 96, column: 20, scope: !981)
!1112 = !DILocation(line: 96, column: 18, scope: !981)
!1113 = !DILocation(line: 97, column: 25, scope: !981)
!1114 = !DILocation(line: 97, column: 15, scope: !981)
!1115 = !DILocation(line: 97, column: 35, scope: !981)
!1116 = !DILocation(line: 97, column: 33, scope: !981)
!1117 = !DILocation(line: 97, column: 48, scope: !981)
!1118 = !DILocation(line: 97, column: 13, scope: !981)
!1119 = !DILocation(line: 98, column: 32, scope: !981)
!1120 = !DILocation(line: 98, column: 22, scope: !981)
!1121 = !DILocation(line: 98, column: 42, scope: !981)
!1122 = !DILocation(line: 98, column: 40, scope: !981)
!1123 = !DILocation(line: 98, column: 47, scope: !981)
!1124 = !DILocation(line: 98, column: 20, scope: !981)
!1125 = !DILocation(line: 98, column: 18, scope: !981)
!1126 = !DILocation(line: 99, column: 25, scope: !981)
!1127 = !DILocation(line: 99, column: 15, scope: !981)
!1128 = !DILocation(line: 99, column: 35, scope: !981)
!1129 = !DILocation(line: 99, column: 33, scope: !981)
!1130 = !DILocation(line: 99, column: 48, scope: !981)
!1131 = !DILocation(line: 99, column: 13, scope: !981)
!1132 = !DILocation(line: 105, column: 12, scope: !981)
!1133 = !DILocation(line: 109, column: 29, scope: !981)
!1134 = !DILocation(line: 109, column: 42, scope: !981)
!1135 = !DILocation(line: 109, column: 20, scope: !981)
!1136 = !DILocation(line: 111, column: 30, scope: !981)
!1137 = !DILocation(line: 111, column: 20, scope: !981)
!1138 = !DILocation(line: 111, column: 38, scope: !981)
!1139 = !DILocation(line: 111, column: 37, scope: !981)
!1140 = !DILocation(line: 111, column: 56, scope: !981)
!1141 = !DILocation(line: 111, column: 46, scope: !981)
!1142 = !DILocation(line: 111, column: 64, scope: !981)
!1143 = !DILocation(line: 111, column: 63, scope: !981)
!1144 = !DILocation(line: 111, column: 71, scope: !981)
!1145 = !DILocation(line: 111, column: 43, scope: !981)
!1146 = !DILocation(line: 111, column: 18, scope: !981)
!1147 = !DILocation(line: 111, column: 16, scope: !981)
!1148 = !DILocation(line: 112, column: 20, scope: !981)
!1149 = !DILocation(line: 112, column: 31, scope: !981)
!1150 = !DILocation(line: 112, column: 14, scope: !981)
!1151 = !DILocation(line: 113, column: 20, scope: !981)
!1152 = !DILocation(line: 113, column: 14, scope: !981)
!1153 = !DILocation(line: 114, column: 28, scope: !981)
!1154 = !DILocation(line: 114, column: 18, scope: !981)
!1155 = !DILocation(line: 114, column: 36, scope: !981)
!1156 = !DILocation(line: 114, column: 35, scope: !981)
!1157 = !DILocation(line: 114, column: 53, scope: !981)
!1158 = !DILocation(line: 114, column: 43, scope: !981)
!1159 = !DILocation(line: 114, column: 61, scope: !981)
!1160 = !DILocation(line: 114, column: 60, scope: !981)
!1161 = !DILocation(line: 114, column: 65, scope: !981)
!1162 = !DILocation(line: 114, column: 40, scope: !981)
!1163 = !DILocation(line: 114, column: 16, scope: !981)
!1164 = !DILocation(line: 121, column: 16, scope: !981)
!1165 = !DILocation(line: 136, column: 18, scope: !981)
!1166 = !DILocation(line: 136, column: 31, scope: !981)
!1167 = !DILocation(line: 136, column: 37, scope: !981)
!1168 = !DILocation(line: 136, column: 5, scope: !981)
!1169 = !DILocation(line: 152, column: 9, scope: !981)
!1170 = !DILocation(line: 152, column: 18, scope: !981)
!1171 = !DILocation(line: 153, column: 21, scope: !981)
!1172 = !DILocation(line: 153, column: 34, scope: !981)
!1173 = !DILocation(line: 153, column: 43, scope: !981)
!1174 = !DILocation(line: 153, column: 54, scope: !981)
!1175 = !DILocation(line: 153, column: 52, scope: !981)
!1176 = !DILocation(line: 153, column: 41, scope: !981)
!1177 = !DILocation(line: 153, column: 18, scope: !981)
!1178 = !DILocation(line: 154, column: 25, scope: !981)
!1179 = !DILocation(line: 155, column: 5, scope: !981)
!1180 = !DILocation(line: 156, column: 18, scope: !981)
!1181 = !DILocation(line: 157, column: 21, scope: !981)
!1182 = !DILocation(line: 157, column: 34, scope: !981)
!1183 = !DILocation(line: 157, column: 43, scope: !981)
!1184 = !DILocation(line: 157, column: 54, scope: !981)
!1185 = !DILocation(line: 157, column: 52, scope: !981)
!1186 = !DILocation(line: 157, column: 41, scope: !981)
!1187 = !DILocation(line: 157, column: 18, scope: !981)
!1188 = !DILocation(line: 160, column: 33, scope: !981)
!1189 = !DILocation(line: 160, column: 50, scope: !981)
!1190 = !DILocation(line: 160, column: 15, scope: !981)
!1191 = !DILocation(line: 162, column: 9, scope: !981)
!1192 = !DILocation(line: 162, column: 25, scope: !981)
!1193 = !DILocation(line: 164, column: 33, scope: !981)
!1194 = !DILocation(line: 164, column: 31, scope: !981)
!1195 = !DILocation(line: 164, column: 16, scope: !981)
!1196 = !DILocation(line: 164, column: 9, scope: !981)
!1197 = !DILocation(line: 167, column: 14, scope: !981)
!1198 = !DILocation(line: 167, column: 30, scope: !981)
!1199 = !DILocation(line: 170, column: 24, scope: !981)
!1200 = !DILocation(line: 170, column: 16, scope: !981)
!1201 = !DILocation(line: 170, column: 9, scope: !981)
!1202 = !DILocation(line: 174, column: 29, scope: !981)
!1203 = !DILocation(line: 174, column: 38, scope: !981)
!1204 = !DILocation(line: 174, column: 46, scope: !981)
!1205 = !DILocation(line: 174, column: 44, scope: !981)
!1206 = !DILocation(line: 174, column: 20, scope: !981)
!1207 = !DILocation(line: 176, column: 27, scope: !981)
!1208 = !DILocation(line: 176, column: 36, scope: !981)
!1209 = !DILocation(line: 176, column: 15, scope: !981)
!1210 = !DILocation(line: 178, column: 29, scope: !981)
!1211 = !DILocation(line: 178, column: 22, scope: !981)
!1212 = !DILocation(line: 178, column: 45, scope: !981)
!1213 = !DILocation(line: 178, column: 19, scope: !981)
!1214 = !DILocation(line: 180, column: 22, scope: !981)
!1215 = !DILocation(line: 180, column: 19, scope: !981)
!1216 = !DILocation(line: 182, column: 39, scope: !981)
!1217 = !DILocation(line: 182, column: 51, scope: !981)
!1218 = !DILocation(line: 182, column: 49, scope: !981)
!1219 = !DILocation(line: 182, column: 31, scope: !981)
!1220 = !DILocation(line: 182, column: 22, scope: !981)
!1221 = !DILocation(line: 183, column: 16, scope: !981)
!1222 = !DILocation(line: 183, column: 9, scope: !981)
!1223 = !DILocation(line: 185, column: 1, scope: !981)
!1224 = distinct !DISubprogram(name: "toRep", scope: !412, file: !412, line: 231, type: !179, scopeLine: 231, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !13, retainedNodes: !2)
!1225 = !DILocation(line: 232, column: 44, scope: !1224)
!1226 = !DILocation(line: 232, column: 50, scope: !1224)
!1227 = !DILocation(line: 233, column: 16, scope: !1224)
!1228 = !DILocation(line: 233, column: 5, scope: !1224)
!1229 = distinct !DISubprogram(name: "fromRep", scope: !412, file: !412, line: 236, type: !179, scopeLine: 236, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !13, retainedNodes: !2)
!1230 = !DILocation(line: 237, column: 44, scope: !1229)
!1231 = !DILocation(line: 237, column: 50, scope: !1229)
!1232 = !DILocation(line: 238, column: 16, scope: !1229)
!1233 = !DILocation(line: 238, column: 5, scope: !1229)
!1234 = distinct !DISubprogram(name: "normalize", scope: !412, file: !412, line: 241, type: !179, scopeLine: 241, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !13, retainedNodes: !2)
!1235 = !DILocation(line: 242, column: 32, scope: !1234)
!1236 = !DILocation(line: 242, column: 31, scope: !1234)
!1237 = !DILocation(line: 242, column: 23, scope: !1234)
!1238 = !DILocation(line: 242, column: 47, scope: !1234)
!1239 = !DILocation(line: 242, column: 45, scope: !1234)
!1240 = !DILocation(line: 242, column: 15, scope: !1234)
!1241 = !DILocation(line: 243, column: 22, scope: !1234)
!1242 = !DILocation(line: 243, column: 6, scope: !1234)
!1243 = !DILocation(line: 243, column: 18, scope: !1234)
!1244 = !DILocation(line: 244, column: 16, scope: !1234)
!1245 = !DILocation(line: 244, column: 14, scope: !1234)
!1246 = !DILocation(line: 244, column: 5, scope: !1234)
!1247 = distinct !DISubprogram(name: "wideMultiply", scope: !412, file: !412, line: 86, type: !179, scopeLine: 86, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !13, retainedNodes: !2)
!1248 = !DILocation(line: 88, column: 28, scope: !1247)
!1249 = !DILocation(line: 88, column: 40, scope: !1247)
!1250 = !DILocation(line: 88, column: 38, scope: !1247)
!1251 = !DILocation(line: 88, column: 20, scope: !1247)
!1252 = !DILocation(line: 89, column: 28, scope: !1247)
!1253 = !DILocation(line: 89, column: 40, scope: !1247)
!1254 = !DILocation(line: 89, column: 38, scope: !1247)
!1255 = !DILocation(line: 89, column: 20, scope: !1247)
!1256 = !DILocation(line: 90, column: 28, scope: !1247)
!1257 = !DILocation(line: 90, column: 40, scope: !1247)
!1258 = !DILocation(line: 90, column: 38, scope: !1247)
!1259 = !DILocation(line: 90, column: 20, scope: !1247)
!1260 = !DILocation(line: 91, column: 28, scope: !1247)
!1261 = !DILocation(line: 91, column: 40, scope: !1247)
!1262 = !DILocation(line: 91, column: 38, scope: !1247)
!1263 = !DILocation(line: 91, column: 20, scope: !1247)
!1264 = !DILocation(line: 93, column: 25, scope: !1247)
!1265 = !DILocation(line: 93, column: 20, scope: !1247)
!1266 = !DILocation(line: 94, column: 25, scope: !1247)
!1267 = !DILocation(line: 94, column: 41, scope: !1247)
!1268 = !DILocation(line: 94, column: 39, scope: !1247)
!1269 = !DILocation(line: 94, column: 57, scope: !1247)
!1270 = !DILocation(line: 94, column: 55, scope: !1247)
!1271 = !DILocation(line: 94, column: 20, scope: !1247)
!1272 = !DILocation(line: 95, column: 11, scope: !1247)
!1273 = !DILocation(line: 95, column: 17, scope: !1247)
!1274 = !DILocation(line: 95, column: 20, scope: !1247)
!1275 = !DILocation(line: 95, column: 14, scope: !1247)
!1276 = !DILocation(line: 95, column: 6, scope: !1247)
!1277 = !DILocation(line: 95, column: 9, scope: !1247)
!1278 = !DILocation(line: 97, column: 11, scope: !1247)
!1279 = !DILocation(line: 97, column: 27, scope: !1247)
!1280 = !DILocation(line: 97, column: 25, scope: !1247)
!1281 = !DILocation(line: 97, column: 43, scope: !1247)
!1282 = !DILocation(line: 97, column: 41, scope: !1247)
!1283 = !DILocation(line: 97, column: 56, scope: !1247)
!1284 = !DILocation(line: 97, column: 54, scope: !1247)
!1285 = !DILocation(line: 97, column: 6, scope: !1247)
!1286 = !DILocation(line: 97, column: 9, scope: !1247)
!1287 = !DILocation(line: 98, column: 1, scope: !1247)
!1288 = distinct !DISubprogram(name: "rep_clz", scope: !412, file: !412, line: 69, type: !179, scopeLine: 69, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !13, retainedNodes: !2)
!1289 = !DILocation(line: 73, column: 9, scope: !1288)
!1290 = !DILocation(line: 73, column: 11, scope: !1288)
!1291 = !DILocation(line: 74, column: 30, scope: !1288)
!1292 = !DILocation(line: 74, column: 32, scope: !1288)
!1293 = !DILocation(line: 74, column: 16, scope: !1288)
!1294 = !DILocation(line: 74, column: 9, scope: !1288)
!1295 = !DILocation(line: 76, column: 35, scope: !1288)
!1296 = !DILocation(line: 76, column: 37, scope: !1288)
!1297 = !DILocation(line: 76, column: 21, scope: !1288)
!1298 = !DILocation(line: 76, column: 19, scope: !1288)
!1299 = !DILocation(line: 76, column: 9, scope: !1288)
!1300 = !DILocation(line: 78, column: 1, scope: !1288)
!1301 = distinct !DISubprogram(name: "__divsf3", scope: !16, file: !16, line: 25, type: !179, scopeLine: 25, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !15, retainedNodes: !2)
!1302 = !DILocation(line: 27, column: 42, scope: !1301)
!1303 = !DILocation(line: 27, column: 36, scope: !1301)
!1304 = !DILocation(line: 27, column: 45, scope: !1301)
!1305 = !DILocation(line: 27, column: 64, scope: !1301)
!1306 = !DILocation(line: 27, column: 24, scope: !1301)
!1307 = !DILocation(line: 28, column: 42, scope: !1301)
!1308 = !DILocation(line: 28, column: 36, scope: !1301)
!1309 = !DILocation(line: 28, column: 45, scope: !1301)
!1310 = !DILocation(line: 28, column: 64, scope: !1301)
!1311 = !DILocation(line: 28, column: 24, scope: !1301)
!1312 = !DILocation(line: 29, column: 39, scope: !1301)
!1313 = !DILocation(line: 29, column: 33, scope: !1301)
!1314 = !DILocation(line: 29, column: 50, scope: !1301)
!1315 = !DILocation(line: 29, column: 44, scope: !1301)
!1316 = !DILocation(line: 29, column: 42, scope: !1301)
!1317 = !DILocation(line: 29, column: 54, scope: !1301)
!1318 = !DILocation(line: 29, column: 17, scope: !1301)
!1319 = !DILocation(line: 31, column: 32, scope: !1301)
!1320 = !DILocation(line: 31, column: 26, scope: !1301)
!1321 = !DILocation(line: 31, column: 35, scope: !1301)
!1322 = !DILocation(line: 31, column: 11, scope: !1301)
!1323 = !DILocation(line: 32, column: 32, scope: !1301)
!1324 = !DILocation(line: 32, column: 26, scope: !1301)
!1325 = !DILocation(line: 32, column: 35, scope: !1301)
!1326 = !DILocation(line: 32, column: 11, scope: !1301)
!1327 = !DILocation(line: 33, column: 9, scope: !1301)
!1328 = !DILocation(line: 36, column: 9, scope: !1301)
!1329 = !DILocation(line: 36, column: 18, scope: !1301)
!1330 = !DILocation(line: 36, column: 22, scope: !1301)
!1331 = !DILocation(line: 36, column: 40, scope: !1301)
!1332 = !DILocation(line: 36, column: 43, scope: !1301)
!1333 = !DILocation(line: 36, column: 52, scope: !1301)
!1334 = !DILocation(line: 36, column: 56, scope: !1301)
!1335 = !DILocation(line: 38, column: 34, scope: !1301)
!1336 = !DILocation(line: 38, column: 28, scope: !1301)
!1337 = !DILocation(line: 38, column: 37, scope: !1301)
!1338 = !DILocation(line: 38, column: 21, scope: !1301)
!1339 = !DILocation(line: 39, column: 34, scope: !1301)
!1340 = !DILocation(line: 39, column: 28, scope: !1301)
!1341 = !DILocation(line: 39, column: 37, scope: !1301)
!1342 = !DILocation(line: 39, column: 21, scope: !1301)
!1343 = !DILocation(line: 42, column: 13, scope: !1301)
!1344 = !DILocation(line: 42, column: 18, scope: !1301)
!1345 = !DILocation(line: 42, column: 49, scope: !1301)
!1346 = !DILocation(line: 42, column: 43, scope: !1301)
!1347 = !DILocation(line: 42, column: 52, scope: !1301)
!1348 = !DILocation(line: 42, column: 35, scope: !1301)
!1349 = !DILocation(line: 42, column: 28, scope: !1301)
!1350 = !DILocation(line: 44, column: 13, scope: !1301)
!1351 = !DILocation(line: 44, column: 18, scope: !1301)
!1352 = !DILocation(line: 44, column: 49, scope: !1301)
!1353 = !DILocation(line: 44, column: 43, scope: !1301)
!1354 = !DILocation(line: 44, column: 52, scope: !1301)
!1355 = !DILocation(line: 44, column: 35, scope: !1301)
!1356 = !DILocation(line: 44, column: 28, scope: !1301)
!1357 = !DILocation(line: 46, column: 13, scope: !1301)
!1358 = !DILocation(line: 46, column: 18, scope: !1301)
!1359 = !DILocation(line: 48, column: 17, scope: !1301)
!1360 = !DILocation(line: 48, column: 22, scope: !1301)
!1361 = !DILocation(line: 48, column: 40, scope: !1301)
!1362 = !DILocation(line: 48, column: 33, scope: !1301)
!1363 = !DILocation(line: 50, column: 33, scope: !1301)
!1364 = !DILocation(line: 50, column: 40, scope: !1301)
!1365 = !DILocation(line: 50, column: 38, scope: !1301)
!1366 = !DILocation(line: 50, column: 25, scope: !1301)
!1367 = !DILocation(line: 50, column: 18, scope: !1301)
!1368 = !DILocation(line: 54, column: 13, scope: !1301)
!1369 = !DILocation(line: 54, column: 18, scope: !1301)
!1370 = !DILocation(line: 54, column: 44, scope: !1301)
!1371 = !DILocation(line: 54, column: 36, scope: !1301)
!1372 = !DILocation(line: 54, column: 29, scope: !1301)
!1373 = !DILocation(line: 56, column: 14, scope: !1301)
!1374 = !DILocation(line: 56, column: 13, scope: !1301)
!1375 = !DILocation(line: 58, column: 18, scope: !1301)
!1376 = !DILocation(line: 58, column: 17, scope: !1301)
!1377 = !DILocation(line: 58, column: 31, scope: !1301)
!1378 = !DILocation(line: 58, column: 24, scope: !1301)
!1379 = !DILocation(line: 60, column: 33, scope: !1301)
!1380 = !DILocation(line: 60, column: 25, scope: !1301)
!1381 = !DILocation(line: 60, column: 18, scope: !1301)
!1382 = !DILocation(line: 63, column: 14, scope: !1301)
!1383 = !DILocation(line: 63, column: 13, scope: !1301)
!1384 = !DILocation(line: 63, column: 44, scope: !1301)
!1385 = !DILocation(line: 63, column: 42, scope: !1301)
!1386 = !DILocation(line: 63, column: 27, scope: !1301)
!1387 = !DILocation(line: 63, column: 20, scope: !1301)
!1388 = !DILocation(line: 68, column: 13, scope: !1301)
!1389 = !DILocation(line: 68, column: 18, scope: !1301)
!1390 = !DILocation(line: 68, column: 42, scope: !1301)
!1391 = !DILocation(line: 68, column: 39, scope: !1301)
!1392 = !DILocation(line: 68, column: 33, scope: !1301)
!1393 = !DILocation(line: 69, column: 13, scope: !1301)
!1394 = !DILocation(line: 69, column: 18, scope: !1301)
!1395 = !DILocation(line: 69, column: 42, scope: !1301)
!1396 = !DILocation(line: 69, column: 39, scope: !1301)
!1397 = !DILocation(line: 69, column: 33, scope: !1301)
!1398 = !DILocation(line: 70, column: 5, scope: !1301)
!1399 = !DILocation(line: 75, column: 18, scope: !1301)
!1400 = !DILocation(line: 76, column: 18, scope: !1301)
!1401 = !DILocation(line: 77, column: 28, scope: !1301)
!1402 = !DILocation(line: 77, column: 40, scope: !1301)
!1403 = !DILocation(line: 77, column: 38, scope: !1301)
!1404 = !DILocation(line: 77, column: 52, scope: !1301)
!1405 = !DILocation(line: 77, column: 50, scope: !1301)
!1406 = !DILocation(line: 77, column: 9, scope: !1301)
!1407 = !DILocation(line: 83, column: 21, scope: !1301)
!1408 = !DILocation(line: 83, column: 34, scope: !1301)
!1409 = !DILocation(line: 83, column: 14, scope: !1301)
!1410 = !DILocation(line: 84, column: 50, scope: !1301)
!1411 = !DILocation(line: 84, column: 48, scope: !1301)
!1412 = !DILocation(line: 84, column: 14, scope: !1301)
!1413 = !DILocation(line: 94, column: 30, scope: !1301)
!1414 = !DILocation(line: 94, column: 20, scope: !1301)
!1415 = !DILocation(line: 94, column: 43, scope: !1301)
!1416 = !DILocation(line: 94, column: 41, scope: !1301)
!1417 = !DILocation(line: 94, column: 48, scope: !1301)
!1418 = !DILocation(line: 94, column: 18, scope: !1301)
!1419 = !DILocation(line: 94, column: 16, scope: !1301)
!1420 = !DILocation(line: 95, column: 28, scope: !1301)
!1421 = !DILocation(line: 95, column: 18, scope: !1301)
!1422 = !DILocation(line: 95, column: 41, scope: !1301)
!1423 = !DILocation(line: 95, column: 39, scope: !1301)
!1424 = !DILocation(line: 95, column: 52, scope: !1301)
!1425 = !DILocation(line: 95, column: 16, scope: !1301)
!1426 = !DILocation(line: 96, column: 30, scope: !1301)
!1427 = !DILocation(line: 96, column: 20, scope: !1301)
!1428 = !DILocation(line: 96, column: 43, scope: !1301)
!1429 = !DILocation(line: 96, column: 41, scope: !1301)
!1430 = !DILocation(line: 96, column: 48, scope: !1301)
!1431 = !DILocation(line: 96, column: 18, scope: !1301)
!1432 = !DILocation(line: 96, column: 16, scope: !1301)
!1433 = !DILocation(line: 97, column: 28, scope: !1301)
!1434 = !DILocation(line: 97, column: 18, scope: !1301)
!1435 = !DILocation(line: 97, column: 41, scope: !1301)
!1436 = !DILocation(line: 97, column: 39, scope: !1301)
!1437 = !DILocation(line: 97, column: 52, scope: !1301)
!1438 = !DILocation(line: 97, column: 16, scope: !1301)
!1439 = !DILocation(line: 98, column: 30, scope: !1301)
!1440 = !DILocation(line: 98, column: 20, scope: !1301)
!1441 = !DILocation(line: 98, column: 43, scope: !1301)
!1442 = !DILocation(line: 98, column: 41, scope: !1301)
!1443 = !DILocation(line: 98, column: 48, scope: !1301)
!1444 = !DILocation(line: 98, column: 18, scope: !1301)
!1445 = !DILocation(line: 98, column: 16, scope: !1301)
!1446 = !DILocation(line: 99, column: 28, scope: !1301)
!1447 = !DILocation(line: 99, column: 18, scope: !1301)
!1448 = !DILocation(line: 99, column: 41, scope: !1301)
!1449 = !DILocation(line: 99, column: 39, scope: !1301)
!1450 = !DILocation(line: 99, column: 52, scope: !1301)
!1451 = !DILocation(line: 99, column: 16, scope: !1301)
!1452 = !DILocation(line: 107, column: 16, scope: !1301)
!1453 = !DILocation(line: 121, column: 32, scope: !1301)
!1454 = !DILocation(line: 121, column: 22, scope: !1301)
!1455 = !DILocation(line: 121, column: 44, scope: !1301)
!1456 = !DILocation(line: 121, column: 57, scope: !1301)
!1457 = !DILocation(line: 121, column: 43, scope: !1301)
!1458 = !DILocation(line: 121, column: 42, scope: !1301)
!1459 = !DILocation(line: 121, column: 63, scope: !1301)
!1460 = !DILocation(line: 121, column: 11, scope: !1301)
!1461 = !DILocation(line: 137, column: 9, scope: !1301)
!1462 = !DILocation(line: 137, column: 18, scope: !1301)
!1463 = !DILocation(line: 138, column: 21, scope: !1301)
!1464 = !DILocation(line: 138, column: 34, scope: !1301)
!1465 = !DILocation(line: 138, column: 43, scope: !1301)
!1466 = !DILocation(line: 138, column: 54, scope: !1301)
!1467 = !DILocation(line: 138, column: 52, scope: !1301)
!1468 = !DILocation(line: 138, column: 41, scope: !1301)
!1469 = !DILocation(line: 138, column: 18, scope: !1301)
!1470 = !DILocation(line: 139, column: 25, scope: !1301)
!1471 = !DILocation(line: 140, column: 5, scope: !1301)
!1472 = !DILocation(line: 141, column: 18, scope: !1301)
!1473 = !DILocation(line: 142, column: 21, scope: !1301)
!1474 = !DILocation(line: 142, column: 34, scope: !1301)
!1475 = !DILocation(line: 142, column: 43, scope: !1301)
!1476 = !DILocation(line: 142, column: 54, scope: !1301)
!1477 = !DILocation(line: 142, column: 52, scope: !1301)
!1478 = !DILocation(line: 142, column: 41, scope: !1301)
!1479 = !DILocation(line: 142, column: 18, scope: !1301)
!1480 = !DILocation(line: 145, column: 33, scope: !1301)
!1481 = !DILocation(line: 145, column: 50, scope: !1301)
!1482 = !DILocation(line: 145, column: 15, scope: !1301)
!1483 = !DILocation(line: 147, column: 9, scope: !1301)
!1484 = !DILocation(line: 147, column: 25, scope: !1301)
!1485 = !DILocation(line: 149, column: 33, scope: !1301)
!1486 = !DILocation(line: 149, column: 31, scope: !1301)
!1487 = !DILocation(line: 149, column: 16, scope: !1301)
!1488 = !DILocation(line: 149, column: 9, scope: !1301)
!1489 = !DILocation(line: 152, column: 14, scope: !1301)
!1490 = !DILocation(line: 152, column: 30, scope: !1301)
!1491 = !DILocation(line: 155, column: 24, scope: !1301)
!1492 = !DILocation(line: 155, column: 16, scope: !1301)
!1493 = !DILocation(line: 155, column: 9, scope: !1301)
!1494 = !DILocation(line: 159, column: 29, scope: !1301)
!1495 = !DILocation(line: 159, column: 38, scope: !1301)
!1496 = !DILocation(line: 159, column: 46, scope: !1301)
!1497 = !DILocation(line: 159, column: 44, scope: !1301)
!1498 = !DILocation(line: 159, column: 20, scope: !1301)
!1499 = !DILocation(line: 161, column: 27, scope: !1301)
!1500 = !DILocation(line: 161, column: 36, scope: !1301)
!1501 = !DILocation(line: 161, column: 15, scope: !1301)
!1502 = !DILocation(line: 163, column: 29, scope: !1301)
!1503 = !DILocation(line: 163, column: 45, scope: !1301)
!1504 = !DILocation(line: 163, column: 19, scope: !1301)
!1505 = !DILocation(line: 165, column: 22, scope: !1301)
!1506 = !DILocation(line: 165, column: 19, scope: !1301)
!1507 = !DILocation(line: 167, column: 24, scope: !1301)
!1508 = !DILocation(line: 167, column: 36, scope: !1301)
!1509 = !DILocation(line: 167, column: 34, scope: !1301)
!1510 = !DILocation(line: 167, column: 16, scope: !1301)
!1511 = !DILocation(line: 167, column: 9, scope: !1301)
!1512 = !DILocation(line: 169, column: 1, scope: !1301)
!1513 = distinct !DISubprogram(name: "toRep", scope: !412, file: !412, line: 231, type: !179, scopeLine: 231, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !15, retainedNodes: !2)
!1514 = !DILocation(line: 232, column: 44, scope: !1513)
!1515 = !DILocation(line: 232, column: 50, scope: !1513)
!1516 = !DILocation(line: 233, column: 16, scope: !1513)
!1517 = !DILocation(line: 233, column: 5, scope: !1513)
!1518 = distinct !DISubprogram(name: "fromRep", scope: !412, file: !412, line: 236, type: !179, scopeLine: 236, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !15, retainedNodes: !2)
!1519 = !DILocation(line: 237, column: 44, scope: !1518)
!1520 = !DILocation(line: 237, column: 50, scope: !1518)
!1521 = !DILocation(line: 238, column: 16, scope: !1518)
!1522 = !DILocation(line: 238, column: 5, scope: !1518)
!1523 = distinct !DISubprogram(name: "normalize", scope: !412, file: !412, line: 241, type: !179, scopeLine: 241, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !15, retainedNodes: !2)
!1524 = !DILocation(line: 242, column: 32, scope: !1523)
!1525 = !DILocation(line: 242, column: 31, scope: !1523)
!1526 = !DILocation(line: 242, column: 23, scope: !1523)
!1527 = !DILocation(line: 242, column: 47, scope: !1523)
!1528 = !DILocation(line: 242, column: 45, scope: !1523)
!1529 = !DILocation(line: 242, column: 15, scope: !1523)
!1530 = !DILocation(line: 243, column: 22, scope: !1523)
!1531 = !DILocation(line: 243, column: 6, scope: !1523)
!1532 = !DILocation(line: 243, column: 18, scope: !1523)
!1533 = !DILocation(line: 244, column: 16, scope: !1523)
!1534 = !DILocation(line: 244, column: 14, scope: !1523)
!1535 = !DILocation(line: 244, column: 5, scope: !1523)
!1536 = distinct !DISubprogram(name: "rep_clz", scope: !412, file: !412, line: 49, type: !179, scopeLine: 49, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !15, retainedNodes: !2)
!1537 = !DILocation(line: 50, column: 26, scope: !1536)
!1538 = !DILocation(line: 50, column: 12, scope: !1536)
!1539 = !DILocation(line: 50, column: 5, scope: !1536)
!1540 = distinct !DISubprogram(name: "__extendhfsf2", scope: !22, file: !22, line: 19, type: !179, scopeLine: 19, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !21, retainedNodes: !2)
!1541 = !DILocation(line: 20, column: 28, scope: !1540)
!1542 = !DILocation(line: 20, column: 12, scope: !1540)
!1543 = !DILocation(line: 20, column: 5, scope: !1540)
!1544 = distinct !DISubprogram(name: "__extendXfYf2__", scope: !1545, file: !1545, line: 41, type: !179, scopeLine: 41, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !21, retainedNodes: !2)
!1545 = !DIFile(filename: "./fp_extend_impl.inc", directory: "/llvmta_testcases/libraries/builtinsfloat")
!1546 = !DILocation(line: 44, column: 15, scope: !1544)
!1547 = !DILocation(line: 45, column: 15, scope: !1544)
!1548 = !DILocation(line: 46, column: 15, scope: !1544)
!1549 = !DILocation(line: 47, column: 15, scope: !1544)
!1550 = !DILocation(line: 49, column: 21, scope: !1544)
!1551 = !DILocation(line: 50, column: 21, scope: !1544)
!1552 = !DILocation(line: 51, column: 21, scope: !1544)
!1553 = !DILocation(line: 52, column: 21, scope: !1544)
!1554 = !DILocation(line: 53, column: 21, scope: !1544)
!1555 = !DILocation(line: 54, column: 21, scope: !1544)
!1556 = !DILocation(line: 56, column: 15, scope: !1544)
!1557 = !DILocation(line: 57, column: 15, scope: !1544)
!1558 = !DILocation(line: 58, column: 15, scope: !1544)
!1559 = !DILocation(line: 59, column: 15, scope: !1544)
!1560 = !DILocation(line: 61, column: 21, scope: !1544)
!1561 = !DILocation(line: 64, column: 37, scope: !1544)
!1562 = !DILocation(line: 64, column: 28, scope: !1544)
!1563 = !DILocation(line: 64, column: 21, scope: !1544)
!1564 = !DILocation(line: 65, column: 28, scope: !1544)
!1565 = !DILocation(line: 65, column: 33, scope: !1544)
!1566 = !DILocation(line: 65, column: 21, scope: !1544)
!1567 = !DILocation(line: 66, column: 28, scope: !1544)
!1568 = !DILocation(line: 66, column: 33, scope: !1544)
!1569 = !DILocation(line: 66, column: 21, scope: !1544)
!1570 = !DILocation(line: 71, column: 21, scope: !1544)
!1571 = !DILocation(line: 71, column: 26, scope: !1544)
!1572 = !DILocation(line: 71, column: 9, scope: !1544)
!1573 = !DILocation(line: 71, column: 42, scope: !1544)
!1574 = !DILocation(line: 75, column: 32, scope: !1544)
!1575 = !DILocation(line: 75, column: 21, scope: !1544)
!1576 = !DILocation(line: 75, column: 37, scope: !1544)
!1577 = !DILocation(line: 75, column: 19, scope: !1544)
!1578 = !DILocation(line: 76, column: 19, scope: !1544)
!1579 = !DILocation(line: 77, column: 5, scope: !1544)
!1580 = !DILocation(line: 79, column: 14, scope: !1544)
!1581 = !DILocation(line: 79, column: 19, scope: !1544)
!1582 = !DILocation(line: 84, column: 19, scope: !1544)
!1583 = !DILocation(line: 85, column: 34, scope: !1544)
!1584 = !DILocation(line: 85, column: 39, scope: !1544)
!1585 = !DILocation(line: 85, column: 50, scope: !1544)
!1586 = !DILocation(line: 85, column: 19, scope: !1544)
!1587 = !DILocation(line: 86, column: 34, scope: !1544)
!1588 = !DILocation(line: 86, column: 39, scope: !1544)
!1589 = !DILocation(line: 86, column: 53, scope: !1544)
!1590 = !DILocation(line: 86, column: 19, scope: !1544)
!1591 = !DILocation(line: 87, column: 5, scope: !1544)
!1592 = !DILocation(line: 89, column: 14, scope: !1544)
!1593 = !DILocation(line: 93, column: 41, scope: !1544)
!1594 = !DILocation(line: 93, column: 27, scope: !1544)
!1595 = !DILocation(line: 93, column: 47, scope: !1544)
!1596 = !DILocation(line: 93, column: 19, scope: !1544)
!1597 = !DILocation(line: 94, column: 32, scope: !1544)
!1598 = !DILocation(line: 94, column: 21, scope: !1544)
!1599 = !DILocation(line: 94, column: 67, scope: !1544)
!1600 = !DILocation(line: 94, column: 65, scope: !1544)
!1601 = !DILocation(line: 94, column: 37, scope: !1544)
!1602 = !DILocation(line: 94, column: 19, scope: !1544)
!1603 = !DILocation(line: 95, column: 19, scope: !1544)
!1604 = !DILocation(line: 96, column: 62, scope: !1544)
!1605 = !DILocation(line: 96, column: 60, scope: !1544)
!1606 = !DILocation(line: 96, column: 68, scope: !1544)
!1607 = !DILocation(line: 96, column: 19, scope: !1544)
!1608 = !DILocation(line: 97, column: 33, scope: !1544)
!1609 = !DILocation(line: 97, column: 48, scope: !1544)
!1610 = !DILocation(line: 97, column: 19, scope: !1544)
!1611 = !DILocation(line: 98, column: 5, scope: !1544)
!1612 = !DILocation(line: 102, column: 19, scope: !1544)
!1613 = !DILocation(line: 106, column: 30, scope: !1544)
!1614 = !DILocation(line: 106, column: 53, scope: !1544)
!1615 = !DILocation(line: 106, column: 42, scope: !1544)
!1616 = !DILocation(line: 106, column: 58, scope: !1544)
!1617 = !DILocation(line: 106, column: 40, scope: !1544)
!1618 = !DILocation(line: 106, column: 21, scope: !1544)
!1619 = !DILocation(line: 107, column: 23, scope: !1544)
!1620 = !DILocation(line: 107, column: 12, scope: !1544)
!1621 = !DILocation(line: 107, column: 5, scope: !1544)
!1622 = distinct !DISubprogram(name: "srcToRep", scope: !1623, file: !1623, line: 78, type: !179, scopeLine: 78, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !21, retainedNodes: !2)
!1623 = !DIFile(filename: "./fp_extend.h", directory: "/llvmta_testcases/libraries/builtinsfloat")
!1624 = !DILocation(line: 79, column: 49, scope: !1622)
!1625 = !DILocation(line: 79, column: 55, scope: !1622)
!1626 = !DILocation(line: 80, column: 16, scope: !1622)
!1627 = !DILocation(line: 80, column: 5, scope: !1622)
!1628 = distinct !DISubprogram(name: "dstFromRep", scope: !1623, file: !1623, line: 83, type: !179, scopeLine: 83, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !21, retainedNodes: !2)
!1629 = !DILocation(line: 84, column: 49, scope: !1628)
!1630 = !DILocation(line: 84, column: 55, scope: !1628)
!1631 = !DILocation(line: 85, column: 16, scope: !1628)
!1632 = !DILocation(line: 85, column: 5, scope: !1628)
!1633 = distinct !DISubprogram(name: "__gnu_h2f_ieee", scope: !22, file: !22, line: 23, type: !179, scopeLine: 23, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !21, retainedNodes: !2)
!1634 = !DILocation(line: 24, column: 26, scope: !1633)
!1635 = !DILocation(line: 24, column: 12, scope: !1633)
!1636 = !DILocation(line: 24, column: 5, scope: !1633)
!1637 = distinct !DISubprogram(name: "__extendsfdf2", scope: !24, file: !24, line: 17, type: !179, scopeLine: 17, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !23, retainedNodes: !2)
!1638 = !DILocation(line: 18, column: 28, scope: !1637)
!1639 = !DILocation(line: 18, column: 12, scope: !1637)
!1640 = !DILocation(line: 18, column: 5, scope: !1637)
!1641 = distinct !DISubprogram(name: "__extendXfYf2__", scope: !1545, file: !1545, line: 41, type: !179, scopeLine: 41, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !23, retainedNodes: !2)
!1642 = !DILocation(line: 44, column: 15, scope: !1641)
!1643 = !DILocation(line: 45, column: 15, scope: !1641)
!1644 = !DILocation(line: 46, column: 15, scope: !1641)
!1645 = !DILocation(line: 47, column: 15, scope: !1641)
!1646 = !DILocation(line: 49, column: 21, scope: !1641)
!1647 = !DILocation(line: 50, column: 21, scope: !1641)
!1648 = !DILocation(line: 51, column: 21, scope: !1641)
!1649 = !DILocation(line: 52, column: 21, scope: !1641)
!1650 = !DILocation(line: 53, column: 21, scope: !1641)
!1651 = !DILocation(line: 54, column: 21, scope: !1641)
!1652 = !DILocation(line: 56, column: 15, scope: !1641)
!1653 = !DILocation(line: 57, column: 15, scope: !1641)
!1654 = !DILocation(line: 58, column: 15, scope: !1641)
!1655 = !DILocation(line: 59, column: 15, scope: !1641)
!1656 = !DILocation(line: 61, column: 21, scope: !1641)
!1657 = !DILocation(line: 64, column: 37, scope: !1641)
!1658 = !DILocation(line: 64, column: 28, scope: !1641)
!1659 = !DILocation(line: 64, column: 21, scope: !1641)
!1660 = !DILocation(line: 65, column: 28, scope: !1641)
!1661 = !DILocation(line: 65, column: 33, scope: !1641)
!1662 = !DILocation(line: 65, column: 21, scope: !1641)
!1663 = !DILocation(line: 66, column: 28, scope: !1641)
!1664 = !DILocation(line: 66, column: 33, scope: !1641)
!1665 = !DILocation(line: 66, column: 21, scope: !1641)
!1666 = !DILocation(line: 71, column: 21, scope: !1641)
!1667 = !DILocation(line: 71, column: 26, scope: !1641)
!1668 = !DILocation(line: 71, column: 42, scope: !1641)
!1669 = !DILocation(line: 71, column: 9, scope: !1641)
!1670 = !DILocation(line: 75, column: 32, scope: !1641)
!1671 = !DILocation(line: 75, column: 21, scope: !1641)
!1672 = !DILocation(line: 75, column: 37, scope: !1641)
!1673 = !DILocation(line: 75, column: 19, scope: !1641)
!1674 = !DILocation(line: 76, column: 19, scope: !1641)
!1675 = !DILocation(line: 77, column: 5, scope: !1641)
!1676 = !DILocation(line: 79, column: 14, scope: !1641)
!1677 = !DILocation(line: 79, column: 19, scope: !1641)
!1678 = !DILocation(line: 84, column: 19, scope: !1641)
!1679 = !DILocation(line: 85, column: 34, scope: !1641)
!1680 = !DILocation(line: 85, column: 39, scope: !1641)
!1681 = !DILocation(line: 85, column: 22, scope: !1641)
!1682 = !DILocation(line: 85, column: 50, scope: !1641)
!1683 = !DILocation(line: 85, column: 19, scope: !1641)
!1684 = !DILocation(line: 86, column: 34, scope: !1641)
!1685 = !DILocation(line: 86, column: 39, scope: !1641)
!1686 = !DILocation(line: 86, column: 22, scope: !1641)
!1687 = !DILocation(line: 86, column: 53, scope: !1641)
!1688 = !DILocation(line: 86, column: 19, scope: !1641)
!1689 = !DILocation(line: 87, column: 5, scope: !1641)
!1690 = !DILocation(line: 89, column: 14, scope: !1641)
!1691 = !DILocation(line: 93, column: 41, scope: !1641)
!1692 = !DILocation(line: 93, column: 27, scope: !1641)
!1693 = !DILocation(line: 93, column: 47, scope: !1641)
!1694 = !DILocation(line: 93, column: 19, scope: !1641)
!1695 = !DILocation(line: 94, column: 32, scope: !1641)
!1696 = !DILocation(line: 94, column: 21, scope: !1641)
!1697 = !DILocation(line: 94, column: 67, scope: !1641)
!1698 = !DILocation(line: 94, column: 65, scope: !1641)
!1699 = !DILocation(line: 94, column: 37, scope: !1641)
!1700 = !DILocation(line: 94, column: 19, scope: !1641)
!1701 = !DILocation(line: 95, column: 19, scope: !1641)
!1702 = !DILocation(line: 96, column: 62, scope: !1641)
!1703 = !DILocation(line: 96, column: 60, scope: !1641)
!1704 = !DILocation(line: 96, column: 68, scope: !1641)
!1705 = !DILocation(line: 96, column: 19, scope: !1641)
!1706 = !DILocation(line: 97, column: 33, scope: !1641)
!1707 = !DILocation(line: 97, column: 22, scope: !1641)
!1708 = !DILocation(line: 97, column: 48, scope: !1641)
!1709 = !DILocation(line: 97, column: 19, scope: !1641)
!1710 = !DILocation(line: 98, column: 5, scope: !1641)
!1711 = !DILocation(line: 102, column: 19, scope: !1641)
!1712 = !DILocation(line: 106, column: 30, scope: !1641)
!1713 = !DILocation(line: 106, column: 53, scope: !1641)
!1714 = !DILocation(line: 106, column: 42, scope: !1641)
!1715 = !DILocation(line: 106, column: 58, scope: !1641)
!1716 = !DILocation(line: 106, column: 40, scope: !1641)
!1717 = !DILocation(line: 106, column: 21, scope: !1641)
!1718 = !DILocation(line: 107, column: 23, scope: !1641)
!1719 = !DILocation(line: 107, column: 12, scope: !1641)
!1720 = !DILocation(line: 107, column: 5, scope: !1641)
!1721 = distinct !DISubprogram(name: "srcToRep", scope: !1623, file: !1623, line: 78, type: !179, scopeLine: 78, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !23, retainedNodes: !2)
!1722 = !DILocation(line: 79, column: 49, scope: !1721)
!1723 = !DILocation(line: 79, column: 55, scope: !1721)
!1724 = !DILocation(line: 80, column: 16, scope: !1721)
!1725 = !DILocation(line: 80, column: 5, scope: !1721)
!1726 = distinct !DISubprogram(name: "dstFromRep", scope: !1623, file: !1623, line: 83, type: !179, scopeLine: 83, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !23, retainedNodes: !2)
!1727 = !DILocation(line: 84, column: 49, scope: !1726)
!1728 = !DILocation(line: 84, column: 55, scope: !1726)
!1729 = !DILocation(line: 85, column: 16, scope: !1726)
!1730 = !DILocation(line: 85, column: 5, scope: !1726)
!1731 = distinct !DISubprogram(name: "__fixdfdi", scope: !28, file: !28, line: 23, type: !179, scopeLine: 24, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !27, retainedNodes: !2)
!1732 = !DILocation(line: 25, column: 9, scope: !1731)
!1733 = !DILocation(line: 25, column: 11, scope: !1731)
!1734 = !DILocation(line: 26, column: 31, scope: !1731)
!1735 = !DILocation(line: 26, column: 30, scope: !1731)
!1736 = !DILocation(line: 26, column: 17, scope: !1731)
!1737 = !DILocation(line: 26, column: 16, scope: !1731)
!1738 = !DILocation(line: 26, column: 9, scope: !1731)
!1739 = !DILocation(line: 28, column: 25, scope: !1731)
!1740 = !DILocation(line: 28, column: 12, scope: !1731)
!1741 = !DILocation(line: 28, column: 5, scope: !1731)
!1742 = !DILocation(line: 29, column: 1, scope: !1731)
!1743 = distinct !DISubprogram(name: "__fixdfsi", scope: !30, file: !30, line: 20, type: !179, scopeLine: 20, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !29, retainedNodes: !2)
!1744 = !DILocation(line: 21, column: 21, scope: !1743)
!1745 = !DILocation(line: 21, column: 12, scope: !1743)
!1746 = !DILocation(line: 21, column: 5, scope: !1743)
!1747 = distinct !DISubprogram(name: "__fixint", scope: !1748, file: !1748, line: 17, type: !179, scopeLine: 17, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !29, retainedNodes: !2)
!1748 = !DIFile(filename: "./fp_fixint_impl.inc", directory: "/llvmta_testcases/libraries/builtinsfloat")
!1749 = !DILocation(line: 18, column: 20, scope: !1747)
!1750 = !DILocation(line: 19, column: 20, scope: !1747)
!1751 = !DILocation(line: 21, column: 30, scope: !1747)
!1752 = !DILocation(line: 21, column: 24, scope: !1747)
!1753 = !DILocation(line: 21, column: 17, scope: !1747)
!1754 = !DILocation(line: 22, column: 24, scope: !1747)
!1755 = !DILocation(line: 22, column: 29, scope: !1747)
!1756 = !DILocation(line: 22, column: 17, scope: !1747)
!1757 = !DILocation(line: 23, column: 27, scope: !1747)
!1758 = !DILocation(line: 23, column: 32, scope: !1747)
!1759 = !DILocation(line: 23, column: 20, scope: !1747)
!1760 = !DILocation(line: 24, column: 27, scope: !1747)
!1761 = !DILocation(line: 24, column: 32, scope: !1747)
!1762 = !DILocation(line: 24, column: 52, scope: !1747)
!1763 = !DILocation(line: 24, column: 26, scope: !1747)
!1764 = !DILocation(line: 24, column: 15, scope: !1747)
!1765 = !DILocation(line: 25, column: 32, scope: !1747)
!1766 = !DILocation(line: 25, column: 37, scope: !1747)
!1767 = !DILocation(line: 25, column: 56, scope: !1747)
!1768 = !DILocation(line: 25, column: 17, scope: !1747)
!1769 = !DILocation(line: 28, column: 9, scope: !1747)
!1770 = !DILocation(line: 28, column: 18, scope: !1747)
!1771 = !DILocation(line: 29, column: 9, scope: !1747)
!1772 = !DILocation(line: 32, column: 19, scope: !1747)
!1773 = !DILocation(line: 32, column: 28, scope: !1747)
!1774 = !DILocation(line: 32, column: 9, scope: !1747)
!1775 = !DILocation(line: 33, column: 16, scope: !1747)
!1776 = !DILocation(line: 33, column: 21, scope: !1747)
!1777 = !DILocation(line: 33, column: 9, scope: !1747)
!1778 = !DILocation(line: 37, column: 9, scope: !1747)
!1779 = !DILocation(line: 37, column: 18, scope: !1747)
!1780 = !DILocation(line: 38, column: 16, scope: !1747)
!1781 = !DILocation(line: 38, column: 24, scope: !1747)
!1782 = !DILocation(line: 38, column: 58, scope: !1747)
!1783 = !DILocation(line: 38, column: 56, scope: !1747)
!1784 = !DILocation(line: 38, column: 36, scope: !1747)
!1785 = !DILocation(line: 38, column: 21, scope: !1747)
!1786 = !DILocation(line: 38, column: 9, scope: !1747)
!1787 = !DILocation(line: 40, column: 16, scope: !1747)
!1788 = !DILocation(line: 40, column: 34, scope: !1747)
!1789 = !DILocation(line: 40, column: 24, scope: !1747)
!1790 = !DILocation(line: 40, column: 50, scope: !1747)
!1791 = !DILocation(line: 40, column: 59, scope: !1747)
!1792 = !DILocation(line: 40, column: 46, scope: !1747)
!1793 = !DILocation(line: 40, column: 21, scope: !1747)
!1794 = !DILocation(line: 40, column: 9, scope: !1747)
!1795 = !DILocation(line: 41, column: 1, scope: !1747)
!1796 = distinct !DISubprogram(name: "toRep", scope: !412, file: !412, line: 231, type: !179, scopeLine: 231, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !29, retainedNodes: !2)
!1797 = !DILocation(line: 232, column: 44, scope: !1796)
!1798 = !DILocation(line: 232, column: 50, scope: !1796)
!1799 = !DILocation(line: 233, column: 16, scope: !1796)
!1800 = !DILocation(line: 233, column: 5, scope: !1796)
!1801 = distinct !DISubprogram(name: "__fixsfdi", scope: !34, file: !34, line: 24, type: !179, scopeLine: 25, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !33, retainedNodes: !2)
!1802 = !DILocation(line: 26, column: 9, scope: !1801)
!1803 = !DILocation(line: 26, column: 11, scope: !1801)
!1804 = !DILocation(line: 27, column: 31, scope: !1801)
!1805 = !DILocation(line: 27, column: 30, scope: !1801)
!1806 = !DILocation(line: 27, column: 17, scope: !1801)
!1807 = !DILocation(line: 27, column: 16, scope: !1801)
!1808 = !DILocation(line: 27, column: 9, scope: !1801)
!1809 = !DILocation(line: 29, column: 25, scope: !1801)
!1810 = !DILocation(line: 29, column: 12, scope: !1801)
!1811 = !DILocation(line: 29, column: 5, scope: !1801)
!1812 = !DILocation(line: 30, column: 1, scope: !1801)
!1813 = distinct !DISubprogram(name: "__fixsfsi", scope: !36, file: !36, line: 20, type: !179, scopeLine: 20, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !35, retainedNodes: !2)
!1814 = !DILocation(line: 21, column: 21, scope: !1813)
!1815 = !DILocation(line: 21, column: 12, scope: !1813)
!1816 = !DILocation(line: 21, column: 5, scope: !1813)
!1817 = distinct !DISubprogram(name: "__fixint", scope: !1748, file: !1748, line: 17, type: !179, scopeLine: 17, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !35, retainedNodes: !2)
!1818 = !DILocation(line: 18, column: 20, scope: !1817)
!1819 = !DILocation(line: 19, column: 20, scope: !1817)
!1820 = !DILocation(line: 21, column: 30, scope: !1817)
!1821 = !DILocation(line: 21, column: 24, scope: !1817)
!1822 = !DILocation(line: 21, column: 17, scope: !1817)
!1823 = !DILocation(line: 22, column: 24, scope: !1817)
!1824 = !DILocation(line: 22, column: 29, scope: !1817)
!1825 = !DILocation(line: 22, column: 17, scope: !1817)
!1826 = !DILocation(line: 23, column: 27, scope: !1817)
!1827 = !DILocation(line: 23, column: 32, scope: !1817)
!1828 = !DILocation(line: 23, column: 20, scope: !1817)
!1829 = !DILocation(line: 24, column: 27, scope: !1817)
!1830 = !DILocation(line: 24, column: 32, scope: !1817)
!1831 = !DILocation(line: 24, column: 52, scope: !1817)
!1832 = !DILocation(line: 24, column: 15, scope: !1817)
!1833 = !DILocation(line: 25, column: 32, scope: !1817)
!1834 = !DILocation(line: 25, column: 37, scope: !1817)
!1835 = !DILocation(line: 25, column: 56, scope: !1817)
!1836 = !DILocation(line: 25, column: 17, scope: !1817)
!1837 = !DILocation(line: 28, column: 9, scope: !1817)
!1838 = !DILocation(line: 28, column: 18, scope: !1817)
!1839 = !DILocation(line: 29, column: 9, scope: !1817)
!1840 = !DILocation(line: 32, column: 19, scope: !1817)
!1841 = !DILocation(line: 32, column: 28, scope: !1817)
!1842 = !DILocation(line: 32, column: 9, scope: !1817)
!1843 = !DILocation(line: 33, column: 16, scope: !1817)
!1844 = !DILocation(line: 33, column: 21, scope: !1817)
!1845 = !DILocation(line: 33, column: 9, scope: !1817)
!1846 = !DILocation(line: 37, column: 9, scope: !1817)
!1847 = !DILocation(line: 37, column: 18, scope: !1817)
!1848 = !DILocation(line: 38, column: 16, scope: !1817)
!1849 = !DILocation(line: 38, column: 24, scope: !1817)
!1850 = !DILocation(line: 38, column: 58, scope: !1817)
!1851 = !DILocation(line: 38, column: 56, scope: !1817)
!1852 = !DILocation(line: 38, column: 36, scope: !1817)
!1853 = !DILocation(line: 38, column: 21, scope: !1817)
!1854 = !DILocation(line: 38, column: 9, scope: !1817)
!1855 = !DILocation(line: 40, column: 16, scope: !1817)
!1856 = !DILocation(line: 40, column: 34, scope: !1817)
!1857 = !DILocation(line: 40, column: 50, scope: !1817)
!1858 = !DILocation(line: 40, column: 59, scope: !1817)
!1859 = !DILocation(line: 40, column: 46, scope: !1817)
!1860 = !DILocation(line: 40, column: 21, scope: !1817)
!1861 = !DILocation(line: 40, column: 9, scope: !1817)
!1862 = !DILocation(line: 41, column: 1, scope: !1817)
!1863 = distinct !DISubprogram(name: "toRep", scope: !412, file: !412, line: 231, type: !179, scopeLine: 231, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !35, retainedNodes: !2)
!1864 = !DILocation(line: 232, column: 44, scope: !1863)
!1865 = !DILocation(line: 232, column: 50, scope: !1863)
!1866 = !DILocation(line: 233, column: 16, scope: !1863)
!1867 = !DILocation(line: 233, column: 5, scope: !1863)
!1868 = distinct !DISubprogram(name: "__fixunsdfdi", scope: !46, file: !46, line: 22, type: !179, scopeLine: 23, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !45, retainedNodes: !2)
!1869 = !DILocation(line: 24, column: 9, scope: !1868)
!1870 = !DILocation(line: 24, column: 11, scope: !1868)
!1871 = !DILocation(line: 24, column: 19, scope: !1868)
!1872 = !DILocation(line: 25, column: 19, scope: !1868)
!1873 = !DILocation(line: 25, column: 21, scope: !1868)
!1874 = !DILocation(line: 25, column: 12, scope: !1868)
!1875 = !DILocation(line: 26, column: 18, scope: !1868)
!1876 = !DILocation(line: 26, column: 30, scope: !1868)
!1877 = !DILocation(line: 26, column: 22, scope: !1868)
!1878 = !DILocation(line: 26, column: 35, scope: !1868)
!1879 = !DILocation(line: 26, column: 20, scope: !1868)
!1880 = !DILocation(line: 26, column: 12, scope: !1868)
!1881 = !DILocation(line: 27, column: 21, scope: !1868)
!1882 = !DILocation(line: 27, column: 13, scope: !1868)
!1883 = !DILocation(line: 27, column: 26, scope: !1868)
!1884 = !DILocation(line: 27, column: 35, scope: !1868)
!1885 = !DILocation(line: 27, column: 33, scope: !1868)
!1886 = !DILocation(line: 27, column: 5, scope: !1868)
!1887 = !DILocation(line: 28, column: 1, scope: !1868)
!1888 = distinct !DISubprogram(name: "__fixunsdfsi", scope: !48, file: !48, line: 19, type: !179, scopeLine: 19, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !47, retainedNodes: !2)
!1889 = !DILocation(line: 20, column: 22, scope: !1888)
!1890 = !DILocation(line: 20, column: 12, scope: !1888)
!1891 = !DILocation(line: 20, column: 5, scope: !1888)
!1892 = distinct !DISubprogram(name: "__fixuint", scope: !1893, file: !1893, line: 17, type: !179, scopeLine: 17, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !47, retainedNodes: !2)
!1893 = !DIFile(filename: "./fp_fixuint_impl.inc", directory: "/llvmta_testcases/libraries/builtinsfloat")
!1894 = !DILocation(line: 19, column: 30, scope: !1892)
!1895 = !DILocation(line: 19, column: 24, scope: !1892)
!1896 = !DILocation(line: 19, column: 17, scope: !1892)
!1897 = !DILocation(line: 20, column: 24, scope: !1892)
!1898 = !DILocation(line: 20, column: 29, scope: !1892)
!1899 = !DILocation(line: 20, column: 17, scope: !1892)
!1900 = !DILocation(line: 21, column: 22, scope: !1892)
!1901 = !DILocation(line: 21, column: 27, scope: !1892)
!1902 = !DILocation(line: 21, column: 15, scope: !1892)
!1903 = !DILocation(line: 22, column: 27, scope: !1892)
!1904 = !DILocation(line: 22, column: 32, scope: !1892)
!1905 = !DILocation(line: 22, column: 52, scope: !1892)
!1906 = !DILocation(line: 22, column: 26, scope: !1892)
!1907 = !DILocation(line: 22, column: 15, scope: !1892)
!1908 = !DILocation(line: 23, column: 32, scope: !1892)
!1909 = !DILocation(line: 23, column: 37, scope: !1892)
!1910 = !DILocation(line: 23, column: 56, scope: !1892)
!1911 = !DILocation(line: 23, column: 17, scope: !1892)
!1912 = !DILocation(line: 26, column: 9, scope: !1892)
!1913 = !DILocation(line: 26, column: 14, scope: !1892)
!1914 = !DILocation(line: 26, column: 20, scope: !1892)
!1915 = !DILocation(line: 26, column: 23, scope: !1892)
!1916 = !DILocation(line: 26, column: 32, scope: !1892)
!1917 = !DILocation(line: 27, column: 9, scope: !1892)
!1918 = !DILocation(line: 30, column: 19, scope: !1892)
!1919 = !DILocation(line: 30, column: 28, scope: !1892)
!1920 = !DILocation(line: 30, column: 9, scope: !1892)
!1921 = !DILocation(line: 31, column: 9, scope: !1892)
!1922 = !DILocation(line: 35, column: 9, scope: !1892)
!1923 = !DILocation(line: 35, column: 18, scope: !1892)
!1924 = !DILocation(line: 36, column: 16, scope: !1892)
!1925 = !DILocation(line: 36, column: 50, scope: !1892)
!1926 = !DILocation(line: 36, column: 48, scope: !1892)
!1927 = !DILocation(line: 36, column: 28, scope: !1892)
!1928 = !DILocation(line: 36, column: 9, scope: !1892)
!1929 = !DILocation(line: 38, column: 27, scope: !1892)
!1930 = !DILocation(line: 38, column: 16, scope: !1892)
!1931 = !DILocation(line: 38, column: 43, scope: !1892)
!1932 = !DILocation(line: 38, column: 52, scope: !1892)
!1933 = !DILocation(line: 38, column: 39, scope: !1892)
!1934 = !DILocation(line: 38, column: 9, scope: !1892)
!1935 = !DILocation(line: 39, column: 1, scope: !1892)
!1936 = distinct !DISubprogram(name: "toRep", scope: !412, file: !412, line: 231, type: !179, scopeLine: 231, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !47, retainedNodes: !2)
!1937 = !DILocation(line: 232, column: 44, scope: !1936)
!1938 = !DILocation(line: 232, column: 50, scope: !1936)
!1939 = !DILocation(line: 233, column: 16, scope: !1936)
!1940 = !DILocation(line: 233, column: 5, scope: !1936)
!1941 = distinct !DISubprogram(name: "__fixunssfdi", scope: !52, file: !52, line: 22, type: !179, scopeLine: 23, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !51, retainedNodes: !2)
!1942 = !DILocation(line: 24, column: 9, scope: !1941)
!1943 = !DILocation(line: 24, column: 11, scope: !1941)
!1944 = !DILocation(line: 24, column: 20, scope: !1941)
!1945 = !DILocation(line: 25, column: 17, scope: !1941)
!1946 = !DILocation(line: 25, column: 12, scope: !1941)
!1947 = !DILocation(line: 26, column: 19, scope: !1941)
!1948 = !DILocation(line: 26, column: 22, scope: !1941)
!1949 = !DILocation(line: 26, column: 12, scope: !1941)
!1950 = !DILocation(line: 27, column: 18, scope: !1941)
!1951 = !DILocation(line: 27, column: 31, scope: !1941)
!1952 = !DILocation(line: 27, column: 23, scope: !1941)
!1953 = !DILocation(line: 27, column: 36, scope: !1941)
!1954 = !DILocation(line: 27, column: 21, scope: !1941)
!1955 = !DILocation(line: 27, column: 12, scope: !1941)
!1956 = !DILocation(line: 28, column: 21, scope: !1941)
!1957 = !DILocation(line: 28, column: 13, scope: !1941)
!1958 = !DILocation(line: 28, column: 26, scope: !1941)
!1959 = !DILocation(line: 28, column: 35, scope: !1941)
!1960 = !DILocation(line: 28, column: 33, scope: !1941)
!1961 = !DILocation(line: 28, column: 5, scope: !1941)
!1962 = !DILocation(line: 29, column: 1, scope: !1941)
!1963 = distinct !DISubprogram(name: "__fixunssfsi", scope: !54, file: !54, line: 23, type: !179, scopeLine: 23, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !53, retainedNodes: !2)
!1964 = !DILocation(line: 24, column: 22, scope: !1963)
!1965 = !DILocation(line: 24, column: 12, scope: !1963)
!1966 = !DILocation(line: 24, column: 5, scope: !1963)
!1967 = distinct !DISubprogram(name: "__fixuint", scope: !1893, file: !1893, line: 17, type: !179, scopeLine: 17, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !53, retainedNodes: !2)
!1968 = !DILocation(line: 19, column: 30, scope: !1967)
!1969 = !DILocation(line: 19, column: 24, scope: !1967)
!1970 = !DILocation(line: 19, column: 17, scope: !1967)
!1971 = !DILocation(line: 20, column: 24, scope: !1967)
!1972 = !DILocation(line: 20, column: 29, scope: !1967)
!1973 = !DILocation(line: 20, column: 17, scope: !1967)
!1974 = !DILocation(line: 21, column: 22, scope: !1967)
!1975 = !DILocation(line: 21, column: 27, scope: !1967)
!1976 = !DILocation(line: 21, column: 15, scope: !1967)
!1977 = !DILocation(line: 22, column: 27, scope: !1967)
!1978 = !DILocation(line: 22, column: 32, scope: !1967)
!1979 = !DILocation(line: 22, column: 52, scope: !1967)
!1980 = !DILocation(line: 22, column: 15, scope: !1967)
!1981 = !DILocation(line: 23, column: 32, scope: !1967)
!1982 = !DILocation(line: 23, column: 37, scope: !1967)
!1983 = !DILocation(line: 23, column: 56, scope: !1967)
!1984 = !DILocation(line: 23, column: 17, scope: !1967)
!1985 = !DILocation(line: 26, column: 9, scope: !1967)
!1986 = !DILocation(line: 26, column: 14, scope: !1967)
!1987 = !DILocation(line: 26, column: 20, scope: !1967)
!1988 = !DILocation(line: 26, column: 23, scope: !1967)
!1989 = !DILocation(line: 26, column: 32, scope: !1967)
!1990 = !DILocation(line: 27, column: 9, scope: !1967)
!1991 = !DILocation(line: 30, column: 19, scope: !1967)
!1992 = !DILocation(line: 30, column: 28, scope: !1967)
!1993 = !DILocation(line: 30, column: 9, scope: !1967)
!1994 = !DILocation(line: 31, column: 9, scope: !1967)
!1995 = !DILocation(line: 35, column: 9, scope: !1967)
!1996 = !DILocation(line: 35, column: 18, scope: !1967)
!1997 = !DILocation(line: 36, column: 16, scope: !1967)
!1998 = !DILocation(line: 36, column: 50, scope: !1967)
!1999 = !DILocation(line: 36, column: 48, scope: !1967)
!2000 = !DILocation(line: 36, column: 28, scope: !1967)
!2001 = !DILocation(line: 36, column: 9, scope: !1967)
!2002 = !DILocation(line: 38, column: 27, scope: !1967)
!2003 = !DILocation(line: 38, column: 43, scope: !1967)
!2004 = !DILocation(line: 38, column: 52, scope: !1967)
!2005 = !DILocation(line: 38, column: 39, scope: !1967)
!2006 = !DILocation(line: 38, column: 9, scope: !1967)
!2007 = !DILocation(line: 39, column: 1, scope: !1967)
!2008 = distinct !DISubprogram(name: "toRep", scope: !412, file: !412, line: 231, type: !179, scopeLine: 231, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !53, retainedNodes: !2)
!2009 = !DILocation(line: 232, column: 44, scope: !2008)
!2010 = !DILocation(line: 232, column: 50, scope: !2008)
!2011 = !DILocation(line: 233, column: 16, scope: !2008)
!2012 = !DILocation(line: 233, column: 5, scope: !2008)
!2013 = distinct !DISubprogram(name: "__fixunsxfdi", scope: !64, file: !64, line: 34, type: !179, scopeLine: 35, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !63, retainedNodes: !2)
!2014 = !DILocation(line: 37, column: 12, scope: !2013)
!2015 = !DILocation(line: 37, column: 8, scope: !2013)
!2016 = !DILocation(line: 37, column: 10, scope: !2013)
!2017 = !DILocation(line: 38, column: 17, scope: !2013)
!2018 = !DILocation(line: 38, column: 19, scope: !2013)
!2019 = !DILocation(line: 38, column: 24, scope: !2013)
!2020 = !DILocation(line: 38, column: 26, scope: !2013)
!2021 = !DILocation(line: 38, column: 30, scope: !2013)
!2022 = !DILocation(line: 38, column: 44, scope: !2013)
!2023 = !DILocation(line: 38, column: 9, scope: !2013)
!2024 = !DILocation(line: 39, column: 9, scope: !2013)
!2025 = !DILocation(line: 39, column: 11, scope: !2013)
!2026 = !DILocation(line: 39, column: 15, scope: !2013)
!2027 = !DILocation(line: 39, column: 22, scope: !2013)
!2028 = !DILocation(line: 39, column: 24, scope: !2013)
!2029 = !DILocation(line: 39, column: 29, scope: !2013)
!2030 = !DILocation(line: 39, column: 31, scope: !2013)
!2031 = !DILocation(line: 39, column: 35, scope: !2013)
!2032 = !DILocation(line: 40, column: 9, scope: !2013)
!2033 = !DILocation(line: 41, column: 19, scope: !2013)
!2034 = !DILocation(line: 41, column: 21, scope: !2013)
!2035 = !DILocation(line: 41, column: 9, scope: !2013)
!2036 = !DILocation(line: 42, column: 9, scope: !2013)
!2037 = !DILocation(line: 43, column: 15, scope: !2013)
!2038 = !DILocation(line: 43, column: 17, scope: !2013)
!2039 = !DILocation(line: 43, column: 21, scope: !2013)
!2040 = !DILocation(line: 43, column: 34, scope: !2013)
!2041 = !DILocation(line: 43, column: 32, scope: !2013)
!2042 = !DILocation(line: 43, column: 25, scope: !2013)
!2043 = !DILocation(line: 43, column: 5, scope: !2013)
!2044 = !DILocation(line: 44, column: 1, scope: !2013)
!2045 = distinct !DISubprogram(name: "__fixunsxfsi", scope: !66, file: !66, line: 33, type: !179, scopeLine: 34, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !65, retainedNodes: !2)
!2046 = !DILocation(line: 36, column: 12, scope: !2045)
!2047 = !DILocation(line: 36, column: 8, scope: !2045)
!2048 = !DILocation(line: 36, column: 10, scope: !2045)
!2049 = !DILocation(line: 37, column: 17, scope: !2045)
!2050 = !DILocation(line: 37, column: 19, scope: !2045)
!2051 = !DILocation(line: 37, column: 24, scope: !2045)
!2052 = !DILocation(line: 37, column: 26, scope: !2045)
!2053 = !DILocation(line: 37, column: 30, scope: !2045)
!2054 = !DILocation(line: 37, column: 44, scope: !2045)
!2055 = !DILocation(line: 37, column: 9, scope: !2045)
!2056 = !DILocation(line: 38, column: 9, scope: !2045)
!2057 = !DILocation(line: 38, column: 11, scope: !2045)
!2058 = !DILocation(line: 38, column: 15, scope: !2045)
!2059 = !DILocation(line: 38, column: 22, scope: !2045)
!2060 = !DILocation(line: 38, column: 24, scope: !2045)
!2061 = !DILocation(line: 38, column: 29, scope: !2045)
!2062 = !DILocation(line: 38, column: 31, scope: !2045)
!2063 = !DILocation(line: 38, column: 35, scope: !2045)
!2064 = !DILocation(line: 39, column: 9, scope: !2045)
!2065 = !DILocation(line: 40, column: 19, scope: !2045)
!2066 = !DILocation(line: 40, column: 21, scope: !2045)
!2067 = !DILocation(line: 40, column: 9, scope: !2045)
!2068 = !DILocation(line: 41, column: 9, scope: !2045)
!2069 = !DILocation(line: 42, column: 15, scope: !2045)
!2070 = !DILocation(line: 42, column: 17, scope: !2045)
!2071 = !DILocation(line: 42, column: 21, scope: !2045)
!2072 = !DILocation(line: 42, column: 23, scope: !2045)
!2073 = !DILocation(line: 42, column: 37, scope: !2045)
!2074 = !DILocation(line: 42, column: 35, scope: !2045)
!2075 = !DILocation(line: 42, column: 28, scope: !2045)
!2076 = !DILocation(line: 42, column: 5, scope: !2045)
!2077 = !DILocation(line: 43, column: 1, scope: !2045)
!2078 = distinct !DISubprogram(name: "__fixxfdi", scope: !70, file: !70, line: 31, type: !179, scopeLine: 32, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !69, retainedNodes: !2)
!2079 = !DILocation(line: 33, column: 18, scope: !2078)
!2080 = !DILocation(line: 34, column: 18, scope: !2078)
!2081 = !DILocation(line: 36, column: 12, scope: !2078)
!2082 = !DILocation(line: 36, column: 8, scope: !2078)
!2083 = !DILocation(line: 36, column: 10, scope: !2078)
!2084 = !DILocation(line: 37, column: 17, scope: !2078)
!2085 = !DILocation(line: 37, column: 19, scope: !2078)
!2086 = !DILocation(line: 37, column: 24, scope: !2078)
!2087 = !DILocation(line: 37, column: 26, scope: !2078)
!2088 = !DILocation(line: 37, column: 30, scope: !2078)
!2089 = !DILocation(line: 37, column: 44, scope: !2078)
!2090 = !DILocation(line: 37, column: 9, scope: !2078)
!2091 = !DILocation(line: 38, column: 9, scope: !2078)
!2092 = !DILocation(line: 38, column: 11, scope: !2078)
!2093 = !DILocation(line: 39, column: 9, scope: !2078)
!2094 = !DILocation(line: 40, column: 19, scope: !2078)
!2095 = !DILocation(line: 40, column: 21, scope: !2078)
!2096 = !DILocation(line: 40, column: 9, scope: !2078)
!2097 = !DILocation(line: 41, column: 16, scope: !2078)
!2098 = !DILocation(line: 41, column: 18, scope: !2078)
!2099 = !DILocation(line: 41, column: 9, scope: !2078)
!2100 = !DILocation(line: 42, column: 30, scope: !2078)
!2101 = !DILocation(line: 42, column: 32, scope: !2078)
!2102 = !DILocation(line: 42, column: 37, scope: !2078)
!2103 = !DILocation(line: 42, column: 39, scope: !2078)
!2104 = !DILocation(line: 42, column: 43, scope: !2078)
!2105 = !DILocation(line: 42, column: 57, scope: !2078)
!2106 = !DILocation(line: 42, column: 16, scope: !2078)
!2107 = !DILocation(line: 42, column: 12, scope: !2078)
!2108 = !DILocation(line: 43, column: 19, scope: !2078)
!2109 = !DILocation(line: 43, column: 21, scope: !2078)
!2110 = !DILocation(line: 43, column: 25, scope: !2078)
!2111 = !DILocation(line: 43, column: 12, scope: !2078)
!2112 = !DILocation(line: 44, column: 17, scope: !2078)
!2113 = !DILocation(line: 44, column: 28, scope: !2078)
!2114 = !DILocation(line: 44, column: 26, scope: !2078)
!2115 = !DILocation(line: 44, column: 19, scope: !2078)
!2116 = !DILocation(line: 44, column: 7, scope: !2078)
!2117 = !DILocation(line: 45, column: 13, scope: !2078)
!2118 = !DILocation(line: 45, column: 17, scope: !2078)
!2119 = !DILocation(line: 45, column: 15, scope: !2078)
!2120 = !DILocation(line: 45, column: 22, scope: !2078)
!2121 = !DILocation(line: 45, column: 20, scope: !2078)
!2122 = !DILocation(line: 45, column: 5, scope: !2078)
!2123 = !DILocation(line: 46, column: 1, scope: !2078)
!2124 = distinct !DISubprogram(name: "__floatdidf", scope: !74, file: !74, line: 33, type: !179, scopeLine: 34, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !73, retainedNodes: !2)
!2125 = !DILocation(line: 38, column: 36, scope: !2124)
!2126 = !DILocation(line: 40, column: 35, scope: !2124)
!2127 = !DILocation(line: 40, column: 37, scope: !2124)
!2128 = !DILocation(line: 40, column: 25, scope: !2124)
!2129 = !DILocation(line: 40, column: 44, scope: !2124)
!2130 = !DILocation(line: 40, column: 18, scope: !2124)
!2131 = !DILocation(line: 41, column: 14, scope: !2124)
!2132 = !DILocation(line: 41, column: 16, scope: !2124)
!2133 = !DILocation(line: 41, column: 9, scope: !2124)
!2134 = !DILocation(line: 41, column: 11, scope: !2124)
!2135 = !DILocation(line: 43, column: 28, scope: !2124)
!2136 = !DILocation(line: 43, column: 33, scope: !2124)
!2137 = !DILocation(line: 43, column: 49, scope: !2124)
!2138 = !DILocation(line: 43, column: 43, scope: !2124)
!2139 = !DILocation(line: 43, column: 18, scope: !2124)
!2140 = !DILocation(line: 44, column: 12, scope: !2124)
!2141 = !DILocation(line: 44, column: 5, scope: !2124)
!2142 = distinct !DISubprogram(name: "__floatdisf", scope: !76, file: !76, line: 28, type: !179, scopeLine: 29, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !75, retainedNodes: !2)
!2143 = !DILocation(line: 30, column: 9, scope: !2142)
!2144 = !DILocation(line: 30, column: 11, scope: !2142)
!2145 = !DILocation(line: 31, column: 9, scope: !2142)
!2146 = !DILocation(line: 32, column: 20, scope: !2142)
!2147 = !DILocation(line: 33, column: 22, scope: !2142)
!2148 = !DILocation(line: 33, column: 24, scope: !2142)
!2149 = !DILocation(line: 33, column: 18, scope: !2142)
!2150 = !DILocation(line: 34, column: 10, scope: !2142)
!2151 = !DILocation(line: 34, column: 14, scope: !2142)
!2152 = !DILocation(line: 34, column: 12, scope: !2142)
!2153 = !DILocation(line: 34, column: 19, scope: !2142)
!2154 = !DILocation(line: 34, column: 17, scope: !2142)
!2155 = !DILocation(line: 34, column: 7, scope: !2142)
!2156 = !DILocation(line: 35, column: 34, scope: !2142)
!2157 = !DILocation(line: 35, column: 18, scope: !2142)
!2158 = !DILocation(line: 35, column: 16, scope: !2142)
!2159 = !DILocation(line: 35, column: 9, scope: !2142)
!2160 = !DILocation(line: 36, column: 13, scope: !2142)
!2161 = !DILocation(line: 36, column: 16, scope: !2142)
!2162 = !DILocation(line: 36, column: 9, scope: !2142)
!2163 = !DILocation(line: 37, column: 9, scope: !2142)
!2164 = !DILocation(line: 37, column: 12, scope: !2142)
!2165 = !DILocation(line: 47, column: 17, scope: !2142)
!2166 = !DILocation(line: 47, column: 9, scope: !2142)
!2167 = !DILocation(line: 50, column: 15, scope: !2142)
!2168 = !DILocation(line: 51, column: 13, scope: !2142)
!2169 = !DILocation(line: 53, column: 13, scope: !2142)
!2170 = !DILocation(line: 55, column: 26, scope: !2142)
!2171 = !DILocation(line: 55, column: 32, scope: !2142)
!2172 = !DILocation(line: 55, column: 35, scope: !2142)
!2173 = !DILocation(line: 55, column: 28, scope: !2142)
!2174 = !DILocation(line: 56, column: 19, scope: !2142)
!2175 = !DILocation(line: 56, column: 64, scope: !2142)
!2176 = !DILocation(line: 56, column: 62, scope: !2142)
!2177 = !DILocation(line: 56, column: 37, scope: !2142)
!2178 = !DILocation(line: 56, column: 21, scope: !2142)
!2179 = !DILocation(line: 56, column: 70, scope: !2142)
!2180 = !DILocation(line: 56, column: 17, scope: !2142)
!2181 = !DILocation(line: 55, column: 56, scope: !2142)
!2182 = !DILocation(line: 55, column: 15, scope: !2142)
!2183 = !DILocation(line: 57, column: 9, scope: !2142)
!2184 = !DILocation(line: 59, column: 15, scope: !2142)
!2185 = !DILocation(line: 59, column: 17, scope: !2142)
!2186 = !DILocation(line: 59, column: 22, scope: !2142)
!2187 = !DILocation(line: 59, column: 14, scope: !2142)
!2188 = !DILocation(line: 59, column: 11, scope: !2142)
!2189 = !DILocation(line: 60, column: 9, scope: !2142)
!2190 = !DILocation(line: 61, column: 11, scope: !2142)
!2191 = !DILocation(line: 63, column: 13, scope: !2142)
!2192 = !DILocation(line: 63, column: 15, scope: !2142)
!2193 = !DILocation(line: 65, column: 15, scope: !2142)
!2194 = !DILocation(line: 66, column: 13, scope: !2142)
!2195 = !DILocation(line: 67, column: 9, scope: !2142)
!2196 = !DILocation(line: 69, column: 5, scope: !2142)
!2197 = !DILocation(line: 72, column: 31, scope: !2142)
!2198 = !DILocation(line: 72, column: 29, scope: !2142)
!2199 = !DILocation(line: 72, column: 11, scope: !2142)
!2200 = !DILocation(line: 76, column: 21, scope: !2142)
!2201 = !DILocation(line: 76, column: 13, scope: !2142)
!2202 = !DILocation(line: 76, column: 23, scope: !2142)
!2203 = !DILocation(line: 77, column: 14, scope: !2142)
!2204 = !DILocation(line: 77, column: 16, scope: !2142)
!2205 = !DILocation(line: 77, column: 23, scope: !2142)
!2206 = !DILocation(line: 76, column: 37, scope: !2142)
!2207 = !DILocation(line: 78, column: 21, scope: !2142)
!2208 = !DILocation(line: 78, column: 13, scope: !2142)
!2209 = !DILocation(line: 78, column: 23, scope: !2142)
!2210 = !DILocation(line: 77, column: 36, scope: !2142)
!2211 = !DILocation(line: 76, column: 8, scope: !2142)
!2212 = !DILocation(line: 76, column: 10, scope: !2142)
!2213 = !DILocation(line: 79, column: 15, scope: !2142)
!2214 = !DILocation(line: 79, column: 5, scope: !2142)
!2215 = !DILocation(line: 80, column: 1, scope: !2142)
!2216 = distinct !DISubprogram(name: "__floatdixf", scope: !80, file: !80, line: 30, type: !179, scopeLine: 31, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !79, retainedNodes: !2)
!2217 = !DILocation(line: 32, column: 9, scope: !2216)
!2218 = !DILocation(line: 32, column: 11, scope: !2216)
!2219 = !DILocation(line: 33, column: 9, scope: !2216)
!2220 = !DILocation(line: 34, column: 20, scope: !2216)
!2221 = !DILocation(line: 35, column: 22, scope: !2216)
!2222 = !DILocation(line: 35, column: 24, scope: !2216)
!2223 = !DILocation(line: 35, column: 18, scope: !2216)
!2224 = !DILocation(line: 36, column: 10, scope: !2216)
!2225 = !DILocation(line: 36, column: 14, scope: !2216)
!2226 = !DILocation(line: 36, column: 12, scope: !2216)
!2227 = !DILocation(line: 36, column: 19, scope: !2216)
!2228 = !DILocation(line: 36, column: 17, scope: !2216)
!2229 = !DILocation(line: 36, column: 7, scope: !2216)
!2230 = !DILocation(line: 37, column: 31, scope: !2216)
!2231 = !DILocation(line: 37, column: 15, scope: !2216)
!2232 = !DILocation(line: 37, column: 9, scope: !2216)
!2233 = !DILocation(line: 38, column: 23, scope: !2216)
!2234 = !DILocation(line: 38, column: 21, scope: !2216)
!2235 = !DILocation(line: 38, column: 9, scope: !2216)
!2236 = !DILocation(line: 40, column: 32, scope: !2216)
!2237 = !DILocation(line: 40, column: 24, scope: !2216)
!2238 = !DILocation(line: 40, column: 34, scope: !2216)
!2239 = !DILocation(line: 41, column: 10, scope: !2216)
!2240 = !DILocation(line: 41, column: 12, scope: !2216)
!2241 = !DILocation(line: 40, column: 48, scope: !2216)
!2242 = !DILocation(line: 40, column: 8, scope: !2216)
!2243 = !DILocation(line: 40, column: 10, scope: !2216)
!2244 = !DILocation(line: 40, column: 15, scope: !2216)
!2245 = !DILocation(line: 40, column: 17, scope: !2216)
!2246 = !DILocation(line: 40, column: 21, scope: !2216)
!2247 = !DILocation(line: 42, column: 20, scope: !2216)
!2248 = !DILocation(line: 42, column: 25, scope: !2216)
!2249 = !DILocation(line: 42, column: 22, scope: !2216)
!2250 = !DILocation(line: 42, column: 8, scope: !2216)
!2251 = !DILocation(line: 42, column: 10, scope: !2216)
!2252 = !DILocation(line: 42, column: 14, scope: !2216)
!2253 = !DILocation(line: 42, column: 18, scope: !2216)
!2254 = !DILocation(line: 43, column: 15, scope: !2216)
!2255 = !DILocation(line: 43, column: 5, scope: !2216)
!2256 = !DILocation(line: 44, column: 1, scope: !2216)
!2257 = distinct !DISubprogram(name: "__floatsidf", scope: !82, file: !82, line: 24, type: !179, scopeLine: 24, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !81, retainedNodes: !2)
!2258 = !DILocation(line: 26, column: 15, scope: !2257)
!2259 = !DILocation(line: 29, column: 9, scope: !2257)
!2260 = !DILocation(line: 29, column: 11, scope: !2257)
!2261 = !DILocation(line: 30, column: 16, scope: !2257)
!2262 = !DILocation(line: 30, column: 9, scope: !2257)
!2263 = !DILocation(line: 33, column: 11, scope: !2257)
!2264 = !DILocation(line: 34, column: 9, scope: !2257)
!2265 = !DILocation(line: 34, column: 11, scope: !2257)
!2266 = !DILocation(line: 35, column: 14, scope: !2257)
!2267 = !DILocation(line: 36, column: 14, scope: !2257)
!2268 = !DILocation(line: 36, column: 13, scope: !2257)
!2269 = !DILocation(line: 36, column: 11, scope: !2257)
!2270 = !DILocation(line: 37, column: 5, scope: !2257)
!2271 = !DILocation(line: 40, column: 55, scope: !2257)
!2272 = !DILocation(line: 40, column: 41, scope: !2257)
!2273 = !DILocation(line: 40, column: 39, scope: !2257)
!2274 = !DILocation(line: 40, column: 15, scope: !2257)
!2275 = !DILocation(line: 46, column: 41, scope: !2257)
!2276 = !DILocation(line: 46, column: 39, scope: !2257)
!2277 = !DILocation(line: 46, column: 15, scope: !2257)
!2278 = !DILocation(line: 47, column: 35, scope: !2257)
!2279 = !DILocation(line: 47, column: 14, scope: !2257)
!2280 = !DILocation(line: 47, column: 40, scope: !2257)
!2281 = !DILocation(line: 47, column: 37, scope: !2257)
!2282 = !DILocation(line: 47, column: 46, scope: !2257)
!2283 = !DILocation(line: 47, column: 12, scope: !2257)
!2284 = !DILocation(line: 50, column: 23, scope: !2257)
!2285 = !DILocation(line: 50, column: 32, scope: !2257)
!2286 = !DILocation(line: 50, column: 15, scope: !2257)
!2287 = !DILocation(line: 50, column: 48, scope: !2257)
!2288 = !DILocation(line: 50, column: 12, scope: !2257)
!2289 = !DILocation(line: 52, column: 20, scope: !2257)
!2290 = !DILocation(line: 52, column: 29, scope: !2257)
!2291 = !DILocation(line: 52, column: 27, scope: !2257)
!2292 = !DILocation(line: 52, column: 12, scope: !2257)
!2293 = !DILocation(line: 52, column: 5, scope: !2257)
!2294 = !DILocation(line: 53, column: 1, scope: !2257)
!2295 = distinct !DISubprogram(name: "fromRep", scope: !412, file: !412, line: 236, type: !179, scopeLine: 236, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !81, retainedNodes: !2)
!2296 = !DILocation(line: 237, column: 44, scope: !2295)
!2297 = !DILocation(line: 237, column: 50, scope: !2295)
!2298 = !DILocation(line: 238, column: 16, scope: !2295)
!2299 = !DILocation(line: 238, column: 5, scope: !2295)
!2300 = distinct !DISubprogram(name: "__floatsisf", scope: !84, file: !84, line: 24, type: !179, scopeLine: 24, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !83, retainedNodes: !2)
!2301 = !DILocation(line: 26, column: 15, scope: !2300)
!2302 = !DILocation(line: 29, column: 9, scope: !2300)
!2303 = !DILocation(line: 29, column: 11, scope: !2300)
!2304 = !DILocation(line: 30, column: 16, scope: !2300)
!2305 = !DILocation(line: 30, column: 9, scope: !2300)
!2306 = !DILocation(line: 33, column: 11, scope: !2300)
!2307 = !DILocation(line: 34, column: 9, scope: !2300)
!2308 = !DILocation(line: 34, column: 11, scope: !2300)
!2309 = !DILocation(line: 35, column: 14, scope: !2300)
!2310 = !DILocation(line: 36, column: 14, scope: !2300)
!2311 = !DILocation(line: 36, column: 13, scope: !2300)
!2312 = !DILocation(line: 36, column: 11, scope: !2300)
!2313 = !DILocation(line: 37, column: 5, scope: !2300)
!2314 = !DILocation(line: 40, column: 55, scope: !2300)
!2315 = !DILocation(line: 40, column: 41, scope: !2300)
!2316 = !DILocation(line: 40, column: 39, scope: !2300)
!2317 = !DILocation(line: 40, column: 15, scope: !2300)
!2318 = !DILocation(line: 44, column: 9, scope: !2300)
!2319 = !DILocation(line: 44, column: 18, scope: !2300)
!2320 = !DILocation(line: 45, column: 45, scope: !2300)
!2321 = !DILocation(line: 45, column: 43, scope: !2300)
!2322 = !DILocation(line: 45, column: 19, scope: !2300)
!2323 = !DILocation(line: 46, column: 25, scope: !2300)
!2324 = !DILocation(line: 46, column: 30, scope: !2300)
!2325 = !DILocation(line: 46, column: 27, scope: !2300)
!2326 = !DILocation(line: 46, column: 36, scope: !2300)
!2327 = !DILocation(line: 46, column: 16, scope: !2300)
!2328 = !DILocation(line: 47, column: 5, scope: !2300)
!2329 = !DILocation(line: 48, column: 27, scope: !2300)
!2330 = !DILocation(line: 48, column: 36, scope: !2300)
!2331 = !DILocation(line: 48, column: 19, scope: !2300)
!2332 = !DILocation(line: 49, column: 25, scope: !2300)
!2333 = !DILocation(line: 49, column: 30, scope: !2300)
!2334 = !DILocation(line: 49, column: 27, scope: !2300)
!2335 = !DILocation(line: 49, column: 36, scope: !2300)
!2336 = !DILocation(line: 49, column: 16, scope: !2300)
!2337 = !DILocation(line: 50, column: 30, scope: !2300)
!2338 = !DILocation(line: 50, column: 48, scope: !2300)
!2339 = !DILocation(line: 50, column: 46, scope: !2300)
!2340 = !DILocation(line: 50, column: 32, scope: !2300)
!2341 = !DILocation(line: 50, column: 15, scope: !2300)
!2342 = !DILocation(line: 51, column: 13, scope: !2300)
!2343 = !DILocation(line: 51, column: 19, scope: !2300)
!2344 = !DILocation(line: 51, column: 36, scope: !2300)
!2345 = !DILocation(line: 51, column: 30, scope: !2300)
!2346 = !DILocation(line: 52, column: 13, scope: !2300)
!2347 = !DILocation(line: 52, column: 19, scope: !2300)
!2348 = !DILocation(line: 52, column: 41, scope: !2300)
!2349 = !DILocation(line: 52, column: 48, scope: !2300)
!2350 = !DILocation(line: 52, column: 38, scope: !2300)
!2351 = !DILocation(line: 52, column: 31, scope: !2300)
!2352 = !DILocation(line: 56, column: 23, scope: !2300)
!2353 = !DILocation(line: 56, column: 32, scope: !2300)
!2354 = !DILocation(line: 56, column: 48, scope: !2300)
!2355 = !DILocation(line: 56, column: 12, scope: !2300)
!2356 = !DILocation(line: 58, column: 20, scope: !2300)
!2357 = !DILocation(line: 58, column: 29, scope: !2300)
!2358 = !DILocation(line: 58, column: 27, scope: !2300)
!2359 = !DILocation(line: 58, column: 12, scope: !2300)
!2360 = !DILocation(line: 58, column: 5, scope: !2300)
!2361 = !DILocation(line: 59, column: 1, scope: !2300)
!2362 = distinct !DISubprogram(name: "fromRep", scope: !412, file: !412, line: 236, type: !179, scopeLine: 236, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !83, retainedNodes: !2)
!2363 = !DILocation(line: 237, column: 44, scope: !2362)
!2364 = !DILocation(line: 237, column: 50, scope: !2362)
!2365 = !DILocation(line: 238, column: 16, scope: !2362)
!2366 = !DILocation(line: 238, column: 5, scope: !2362)
!2367 = distinct !DISubprogram(name: "__floatundidf", scope: !96, file: !96, line: 33, type: !179, scopeLine: 34, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !95, retainedNodes: !2)
!2368 = !DILocation(line: 39, column: 37, scope: !2367)
!2369 = !DILocation(line: 40, column: 37, scope: !2367)
!2370 = !DILocation(line: 42, column: 15, scope: !2367)
!2371 = !DILocation(line: 42, column: 17, scope: !2367)
!2372 = !DILocation(line: 42, column: 10, scope: !2367)
!2373 = !DILocation(line: 42, column: 12, scope: !2367)
!2374 = !DILocation(line: 43, column: 14, scope: !2367)
!2375 = !DILocation(line: 43, column: 16, scope: !2367)
!2376 = !DILocation(line: 43, column: 9, scope: !2367)
!2377 = !DILocation(line: 43, column: 11, scope: !2367)
!2378 = !DILocation(line: 45, column: 33, scope: !2367)
!2379 = !DILocation(line: 45, column: 35, scope: !2367)
!2380 = !DILocation(line: 45, column: 63, scope: !2367)
!2381 = !DILocation(line: 45, column: 57, scope: !2367)
!2382 = !DILocation(line: 45, column: 18, scope: !2367)
!2383 = !DILocation(line: 46, column: 12, scope: !2367)
!2384 = !DILocation(line: 46, column: 5, scope: !2367)
!2385 = distinct !DISubprogram(name: "__floatundisf", scope: !98, file: !98, line: 28, type: !179, scopeLine: 29, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !97, retainedNodes: !2)
!2386 = !DILocation(line: 30, column: 9, scope: !2385)
!2387 = !DILocation(line: 30, column: 11, scope: !2385)
!2388 = !DILocation(line: 31, column: 9, scope: !2385)
!2389 = !DILocation(line: 32, column: 20, scope: !2385)
!2390 = !DILocation(line: 33, column: 34, scope: !2385)
!2391 = !DILocation(line: 33, column: 18, scope: !2385)
!2392 = !DILocation(line: 33, column: 16, scope: !2385)
!2393 = !DILocation(line: 33, column: 9, scope: !2385)
!2394 = !DILocation(line: 34, column: 13, scope: !2385)
!2395 = !DILocation(line: 34, column: 16, scope: !2385)
!2396 = !DILocation(line: 34, column: 9, scope: !2385)
!2397 = !DILocation(line: 35, column: 9, scope: !2385)
!2398 = !DILocation(line: 35, column: 12, scope: !2385)
!2399 = !DILocation(line: 45, column: 17, scope: !2385)
!2400 = !DILocation(line: 45, column: 9, scope: !2385)
!2401 = !DILocation(line: 48, column: 15, scope: !2385)
!2402 = !DILocation(line: 49, column: 13, scope: !2385)
!2403 = !DILocation(line: 51, column: 13, scope: !2385)
!2404 = !DILocation(line: 53, column: 18, scope: !2385)
!2405 = !DILocation(line: 53, column: 24, scope: !2385)
!2406 = !DILocation(line: 53, column: 27, scope: !2385)
!2407 = !DILocation(line: 53, column: 20, scope: !2385)
!2408 = !DILocation(line: 54, column: 19, scope: !2385)
!2409 = !DILocation(line: 54, column: 64, scope: !2385)
!2410 = !DILocation(line: 54, column: 62, scope: !2385)
!2411 = !DILocation(line: 54, column: 37, scope: !2385)
!2412 = !DILocation(line: 54, column: 21, scope: !2385)
!2413 = !DILocation(line: 54, column: 70, scope: !2385)
!2414 = !DILocation(line: 54, column: 17, scope: !2385)
!2415 = !DILocation(line: 53, column: 48, scope: !2385)
!2416 = !DILocation(line: 53, column: 15, scope: !2385)
!2417 = !DILocation(line: 55, column: 9, scope: !2385)
!2418 = !DILocation(line: 57, column: 15, scope: !2385)
!2419 = !DILocation(line: 57, column: 17, scope: !2385)
!2420 = !DILocation(line: 57, column: 22, scope: !2385)
!2421 = !DILocation(line: 57, column: 14, scope: !2385)
!2422 = !DILocation(line: 57, column: 11, scope: !2385)
!2423 = !DILocation(line: 58, column: 9, scope: !2385)
!2424 = !DILocation(line: 59, column: 11, scope: !2385)
!2425 = !DILocation(line: 61, column: 13, scope: !2385)
!2426 = !DILocation(line: 61, column: 15, scope: !2385)
!2427 = !DILocation(line: 63, column: 15, scope: !2385)
!2428 = !DILocation(line: 64, column: 13, scope: !2385)
!2429 = !DILocation(line: 65, column: 9, scope: !2385)
!2430 = !DILocation(line: 67, column: 5, scope: !2385)
!2431 = !DILocation(line: 70, column: 31, scope: !2385)
!2432 = !DILocation(line: 70, column: 29, scope: !2385)
!2433 = !DILocation(line: 70, column: 11, scope: !2385)
!2434 = !DILocation(line: 74, column: 14, scope: !2385)
!2435 = !DILocation(line: 74, column: 16, scope: !2385)
!2436 = !DILocation(line: 74, column: 23, scope: !2385)
!2437 = !DILocation(line: 75, column: 21, scope: !2385)
!2438 = !DILocation(line: 75, column: 13, scope: !2385)
!2439 = !DILocation(line: 75, column: 23, scope: !2385)
!2440 = !DILocation(line: 74, column: 36, scope: !2385)
!2441 = !DILocation(line: 74, column: 8, scope: !2385)
!2442 = !DILocation(line: 74, column: 10, scope: !2385)
!2443 = !DILocation(line: 76, column: 15, scope: !2385)
!2444 = !DILocation(line: 76, column: 5, scope: !2385)
!2445 = !DILocation(line: 77, column: 1, scope: !2385)
!2446 = distinct !DISubprogram(name: "__floatundixf", scope: !102, file: !102, line: 29, type: !179, scopeLine: 30, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !101, retainedNodes: !2)
!2447 = !DILocation(line: 31, column: 9, scope: !2446)
!2448 = !DILocation(line: 31, column: 11, scope: !2446)
!2449 = !DILocation(line: 32, column: 9, scope: !2446)
!2450 = !DILocation(line: 33, column: 20, scope: !2446)
!2451 = !DILocation(line: 34, column: 31, scope: !2446)
!2452 = !DILocation(line: 34, column: 15, scope: !2446)
!2453 = !DILocation(line: 34, column: 9, scope: !2446)
!2454 = !DILocation(line: 35, column: 23, scope: !2446)
!2455 = !DILocation(line: 35, column: 21, scope: !2446)
!2456 = !DILocation(line: 35, column: 9, scope: !2446)
!2457 = !DILocation(line: 37, column: 24, scope: !2446)
!2458 = !DILocation(line: 37, column: 26, scope: !2446)
!2459 = !DILocation(line: 37, column: 8, scope: !2446)
!2460 = !DILocation(line: 37, column: 10, scope: !2446)
!2461 = !DILocation(line: 37, column: 15, scope: !2446)
!2462 = !DILocation(line: 37, column: 17, scope: !2446)
!2463 = !DILocation(line: 37, column: 21, scope: !2446)
!2464 = !DILocation(line: 38, column: 20, scope: !2446)
!2465 = !DILocation(line: 38, column: 25, scope: !2446)
!2466 = !DILocation(line: 38, column: 22, scope: !2446)
!2467 = !DILocation(line: 38, column: 8, scope: !2446)
!2468 = !DILocation(line: 38, column: 10, scope: !2446)
!2469 = !DILocation(line: 38, column: 14, scope: !2446)
!2470 = !DILocation(line: 38, column: 18, scope: !2446)
!2471 = !DILocation(line: 39, column: 15, scope: !2446)
!2472 = !DILocation(line: 39, column: 5, scope: !2446)
!2473 = !DILocation(line: 40, column: 1, scope: !2446)
!2474 = distinct !DISubprogram(name: "__floatunsidf", scope: !104, file: !104, line: 24, type: !179, scopeLine: 24, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !103, retainedNodes: !2)
!2475 = !DILocation(line: 26, column: 15, scope: !2474)
!2476 = !DILocation(line: 29, column: 9, scope: !2474)
!2477 = !DILocation(line: 29, column: 11, scope: !2474)
!2478 = !DILocation(line: 29, column: 24, scope: !2474)
!2479 = !DILocation(line: 29, column: 17, scope: !2474)
!2480 = !DILocation(line: 32, column: 55, scope: !2474)
!2481 = !DILocation(line: 32, column: 41, scope: !2474)
!2482 = !DILocation(line: 32, column: 39, scope: !2474)
!2483 = !DILocation(line: 32, column: 15, scope: !2474)
!2484 = !DILocation(line: 36, column: 41, scope: !2474)
!2485 = !DILocation(line: 36, column: 39, scope: !2474)
!2486 = !DILocation(line: 36, column: 15, scope: !2474)
!2487 = !DILocation(line: 37, column: 21, scope: !2474)
!2488 = !DILocation(line: 37, column: 14, scope: !2474)
!2489 = !DILocation(line: 37, column: 26, scope: !2474)
!2490 = !DILocation(line: 37, column: 23, scope: !2474)
!2491 = !DILocation(line: 37, column: 32, scope: !2474)
!2492 = !DILocation(line: 37, column: 12, scope: !2474)
!2493 = !DILocation(line: 40, column: 23, scope: !2474)
!2494 = !DILocation(line: 40, column: 32, scope: !2474)
!2495 = !DILocation(line: 40, column: 15, scope: !2474)
!2496 = !DILocation(line: 40, column: 48, scope: !2474)
!2497 = !DILocation(line: 40, column: 12, scope: !2474)
!2498 = !DILocation(line: 41, column: 20, scope: !2474)
!2499 = !DILocation(line: 41, column: 12, scope: !2474)
!2500 = !DILocation(line: 41, column: 5, scope: !2474)
!2501 = !DILocation(line: 42, column: 1, scope: !2474)
!2502 = distinct !DISubprogram(name: "fromRep", scope: !412, file: !412, line: 236, type: !179, scopeLine: 236, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !103, retainedNodes: !2)
!2503 = !DILocation(line: 237, column: 44, scope: !2502)
!2504 = !DILocation(line: 237, column: 50, scope: !2502)
!2505 = !DILocation(line: 238, column: 16, scope: !2502)
!2506 = !DILocation(line: 238, column: 5, scope: !2502)
!2507 = distinct !DISubprogram(name: "__floatunsisf", scope: !106, file: !106, line: 24, type: !179, scopeLine: 24, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !105, retainedNodes: !2)
!2508 = !DILocation(line: 26, column: 15, scope: !2507)
!2509 = !DILocation(line: 29, column: 9, scope: !2507)
!2510 = !DILocation(line: 29, column: 11, scope: !2507)
!2511 = !DILocation(line: 29, column: 24, scope: !2507)
!2512 = !DILocation(line: 29, column: 17, scope: !2507)
!2513 = !DILocation(line: 32, column: 55, scope: !2507)
!2514 = !DILocation(line: 32, column: 41, scope: !2507)
!2515 = !DILocation(line: 32, column: 39, scope: !2507)
!2516 = !DILocation(line: 32, column: 15, scope: !2507)
!2517 = !DILocation(line: 36, column: 9, scope: !2507)
!2518 = !DILocation(line: 36, column: 18, scope: !2507)
!2519 = !DILocation(line: 37, column: 45, scope: !2507)
!2520 = !DILocation(line: 37, column: 43, scope: !2507)
!2521 = !DILocation(line: 37, column: 19, scope: !2507)
!2522 = !DILocation(line: 38, column: 25, scope: !2507)
!2523 = !DILocation(line: 38, column: 30, scope: !2507)
!2524 = !DILocation(line: 38, column: 27, scope: !2507)
!2525 = !DILocation(line: 38, column: 36, scope: !2507)
!2526 = !DILocation(line: 38, column: 16, scope: !2507)
!2527 = !DILocation(line: 39, column: 5, scope: !2507)
!2528 = !DILocation(line: 40, column: 27, scope: !2507)
!2529 = !DILocation(line: 40, column: 36, scope: !2507)
!2530 = !DILocation(line: 40, column: 19, scope: !2507)
!2531 = !DILocation(line: 41, column: 25, scope: !2507)
!2532 = !DILocation(line: 41, column: 30, scope: !2507)
!2533 = !DILocation(line: 41, column: 27, scope: !2507)
!2534 = !DILocation(line: 41, column: 36, scope: !2507)
!2535 = !DILocation(line: 41, column: 16, scope: !2507)
!2536 = !DILocation(line: 42, column: 30, scope: !2507)
!2537 = !DILocation(line: 42, column: 48, scope: !2507)
!2538 = !DILocation(line: 42, column: 46, scope: !2507)
!2539 = !DILocation(line: 42, column: 32, scope: !2507)
!2540 = !DILocation(line: 42, column: 15, scope: !2507)
!2541 = !DILocation(line: 43, column: 13, scope: !2507)
!2542 = !DILocation(line: 43, column: 19, scope: !2507)
!2543 = !DILocation(line: 43, column: 36, scope: !2507)
!2544 = !DILocation(line: 43, column: 30, scope: !2507)
!2545 = !DILocation(line: 44, column: 13, scope: !2507)
!2546 = !DILocation(line: 44, column: 19, scope: !2507)
!2547 = !DILocation(line: 44, column: 41, scope: !2507)
!2548 = !DILocation(line: 44, column: 48, scope: !2507)
!2549 = !DILocation(line: 44, column: 38, scope: !2507)
!2550 = !DILocation(line: 44, column: 31, scope: !2507)
!2551 = !DILocation(line: 48, column: 23, scope: !2507)
!2552 = !DILocation(line: 48, column: 32, scope: !2507)
!2553 = !DILocation(line: 48, column: 48, scope: !2507)
!2554 = !DILocation(line: 48, column: 12, scope: !2507)
!2555 = !DILocation(line: 49, column: 20, scope: !2507)
!2556 = !DILocation(line: 49, column: 12, scope: !2507)
!2557 = !DILocation(line: 49, column: 5, scope: !2507)
!2558 = !DILocation(line: 50, column: 1, scope: !2507)
!2559 = distinct !DISubprogram(name: "fromRep", scope: !412, file: !412, line: 236, type: !179, scopeLine: 236, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !105, retainedNodes: !2)
!2560 = !DILocation(line: 237, column: 44, scope: !2559)
!2561 = !DILocation(line: 237, column: 50, scope: !2559)
!2562 = !DILocation(line: 238, column: 16, scope: !2559)
!2563 = !DILocation(line: 238, column: 5, scope: !2559)
!2564 = distinct !DISubprogram(name: "compilerrt_abort_impl", scope: !118, file: !118, line: 57, type: !179, scopeLine: 57, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !117, retainedNodes: !2)
!2565 = !DILocation(line: 59, column: 1, scope: !2564)
!2566 = distinct !DISubprogram(name: "__muldf3", scope: !120, file: !120, line: 20, type: !179, scopeLine: 20, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !119, retainedNodes: !2)
!2567 = !DILocation(line: 21, column: 23, scope: !2566)
!2568 = !DILocation(line: 21, column: 26, scope: !2566)
!2569 = !DILocation(line: 21, column: 12, scope: !2566)
!2570 = !DILocation(line: 21, column: 5, scope: !2566)
!2571 = distinct !DISubprogram(name: "__mulXf3__", scope: !2572, file: !2572, line: 17, type: !179, scopeLine: 17, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !119, retainedNodes: !2)
!2572 = !DIFile(filename: "./fp_mul_impl.inc", directory: "/llvmta_testcases/libraries/builtinsfloat")
!2573 = !DILocation(line: 18, column: 42, scope: !2571)
!2574 = !DILocation(line: 18, column: 36, scope: !2571)
!2575 = !DILocation(line: 18, column: 45, scope: !2571)
!2576 = !DILocation(line: 18, column: 64, scope: !2571)
!2577 = !DILocation(line: 18, column: 24, scope: !2571)
!2578 = !DILocation(line: 19, column: 42, scope: !2571)
!2579 = !DILocation(line: 19, column: 36, scope: !2571)
!2580 = !DILocation(line: 19, column: 45, scope: !2571)
!2581 = !DILocation(line: 19, column: 64, scope: !2571)
!2582 = !DILocation(line: 19, column: 24, scope: !2571)
!2583 = !DILocation(line: 20, column: 38, scope: !2571)
!2584 = !DILocation(line: 20, column: 32, scope: !2571)
!2585 = !DILocation(line: 20, column: 49, scope: !2571)
!2586 = !DILocation(line: 20, column: 43, scope: !2571)
!2587 = !DILocation(line: 20, column: 41, scope: !2571)
!2588 = !DILocation(line: 20, column: 53, scope: !2571)
!2589 = !DILocation(line: 20, column: 17, scope: !2571)
!2590 = !DILocation(line: 22, column: 32, scope: !2571)
!2591 = !DILocation(line: 22, column: 26, scope: !2571)
!2592 = !DILocation(line: 22, column: 35, scope: !2571)
!2593 = !DILocation(line: 22, column: 11, scope: !2571)
!2594 = !DILocation(line: 23, column: 32, scope: !2571)
!2595 = !DILocation(line: 23, column: 26, scope: !2571)
!2596 = !DILocation(line: 23, column: 35, scope: !2571)
!2597 = !DILocation(line: 23, column: 11, scope: !2571)
!2598 = !DILocation(line: 24, column: 9, scope: !2571)
!2599 = !DILocation(line: 27, column: 9, scope: !2571)
!2600 = !DILocation(line: 27, column: 18, scope: !2571)
!2601 = !DILocation(line: 27, column: 22, scope: !2571)
!2602 = !DILocation(line: 27, column: 40, scope: !2571)
!2603 = !DILocation(line: 27, column: 43, scope: !2571)
!2604 = !DILocation(line: 27, column: 52, scope: !2571)
!2605 = !DILocation(line: 27, column: 56, scope: !2571)
!2606 = !DILocation(line: 29, column: 34, scope: !2571)
!2607 = !DILocation(line: 29, column: 28, scope: !2571)
!2608 = !DILocation(line: 29, column: 37, scope: !2571)
!2609 = !DILocation(line: 29, column: 21, scope: !2571)
!2610 = !DILocation(line: 30, column: 34, scope: !2571)
!2611 = !DILocation(line: 30, column: 28, scope: !2571)
!2612 = !DILocation(line: 30, column: 37, scope: !2571)
!2613 = !DILocation(line: 30, column: 21, scope: !2571)
!2614 = !DILocation(line: 33, column: 13, scope: !2571)
!2615 = !DILocation(line: 33, column: 18, scope: !2571)
!2616 = !DILocation(line: 33, column: 49, scope: !2571)
!2617 = !DILocation(line: 33, column: 43, scope: !2571)
!2618 = !DILocation(line: 33, column: 52, scope: !2571)
!2619 = !DILocation(line: 33, column: 35, scope: !2571)
!2620 = !DILocation(line: 33, column: 28, scope: !2571)
!2621 = !DILocation(line: 35, column: 13, scope: !2571)
!2622 = !DILocation(line: 35, column: 18, scope: !2571)
!2623 = !DILocation(line: 35, column: 49, scope: !2571)
!2624 = !DILocation(line: 35, column: 43, scope: !2571)
!2625 = !DILocation(line: 35, column: 52, scope: !2571)
!2626 = !DILocation(line: 35, column: 35, scope: !2571)
!2627 = !DILocation(line: 35, column: 28, scope: !2571)
!2628 = !DILocation(line: 37, column: 13, scope: !2571)
!2629 = !DILocation(line: 37, column: 18, scope: !2571)
!2630 = !DILocation(line: 39, column: 17, scope: !2571)
!2631 = !DILocation(line: 39, column: 38, scope: !2571)
!2632 = !DILocation(line: 39, column: 45, scope: !2571)
!2633 = !DILocation(line: 39, column: 43, scope: !2571)
!2634 = !DILocation(line: 39, column: 30, scope: !2571)
!2635 = !DILocation(line: 39, column: 23, scope: !2571)
!2636 = !DILocation(line: 41, column: 25, scope: !2571)
!2637 = !DILocation(line: 41, column: 18, scope: !2571)
!2638 = !DILocation(line: 44, column: 13, scope: !2571)
!2639 = !DILocation(line: 44, column: 18, scope: !2571)
!2640 = !DILocation(line: 46, column: 17, scope: !2571)
!2641 = !DILocation(line: 46, column: 38, scope: !2571)
!2642 = !DILocation(line: 46, column: 45, scope: !2571)
!2643 = !DILocation(line: 46, column: 43, scope: !2571)
!2644 = !DILocation(line: 46, column: 30, scope: !2571)
!2645 = !DILocation(line: 46, column: 23, scope: !2571)
!2646 = !DILocation(line: 48, column: 25, scope: !2571)
!2647 = !DILocation(line: 48, column: 18, scope: !2571)
!2648 = !DILocation(line: 52, column: 14, scope: !2571)
!2649 = !DILocation(line: 52, column: 13, scope: !2571)
!2650 = !DILocation(line: 52, column: 35, scope: !2571)
!2651 = !DILocation(line: 52, column: 27, scope: !2571)
!2652 = !DILocation(line: 52, column: 20, scope: !2571)
!2653 = !DILocation(line: 54, column: 14, scope: !2571)
!2654 = !DILocation(line: 54, column: 13, scope: !2571)
!2655 = !DILocation(line: 54, column: 35, scope: !2571)
!2656 = !DILocation(line: 54, column: 27, scope: !2571)
!2657 = !DILocation(line: 54, column: 20, scope: !2571)
!2658 = !DILocation(line: 59, column: 13, scope: !2571)
!2659 = !DILocation(line: 59, column: 18, scope: !2571)
!2660 = !DILocation(line: 59, column: 42, scope: !2571)
!2661 = !DILocation(line: 59, column: 39, scope: !2571)
!2662 = !DILocation(line: 59, column: 33, scope: !2571)
!2663 = !DILocation(line: 60, column: 13, scope: !2571)
!2664 = !DILocation(line: 60, column: 18, scope: !2571)
!2665 = !DILocation(line: 60, column: 42, scope: !2571)
!2666 = !DILocation(line: 60, column: 39, scope: !2571)
!2667 = !DILocation(line: 60, column: 33, scope: !2571)
!2668 = !DILocation(line: 61, column: 5, scope: !2571)
!2669 = !DILocation(line: 66, column: 18, scope: !2571)
!2670 = !DILocation(line: 67, column: 18, scope: !2571)
!2671 = !DILocation(line: 75, column: 18, scope: !2571)
!2672 = !DILocation(line: 75, column: 32, scope: !2571)
!2673 = !DILocation(line: 75, column: 45, scope: !2571)
!2674 = !DILocation(line: 75, column: 5, scope: !2571)
!2675 = !DILocation(line: 78, column: 27, scope: !2571)
!2676 = !DILocation(line: 78, column: 39, scope: !2571)
!2677 = !DILocation(line: 78, column: 37, scope: !2571)
!2678 = !DILocation(line: 78, column: 49, scope: !2571)
!2679 = !DILocation(line: 78, column: 66, scope: !2571)
!2680 = !DILocation(line: 78, column: 64, scope: !2571)
!2681 = !DILocation(line: 78, column: 9, scope: !2571)
!2682 = !DILocation(line: 81, column: 9, scope: !2571)
!2683 = !DILocation(line: 81, column: 19, scope: !2571)
!2684 = !DILocation(line: 81, column: 49, scope: !2571)
!2685 = !DILocation(line: 81, column: 34, scope: !2571)
!2686 = !DILocation(line: 82, column: 10, scope: !2571)
!2687 = !DILocation(line: 85, column: 9, scope: !2571)
!2688 = !DILocation(line: 85, column: 25, scope: !2571)
!2689 = !DILocation(line: 85, column: 65, scope: !2571)
!2690 = !DILocation(line: 85, column: 63, scope: !2571)
!2691 = !DILocation(line: 85, column: 48, scope: !2571)
!2692 = !DILocation(line: 85, column: 41, scope: !2571)
!2693 = !DILocation(line: 87, column: 9, scope: !2571)
!2694 = !DILocation(line: 87, column: 25, scope: !2571)
!2695 = !DILocation(line: 94, column: 61, scope: !2571)
!2696 = !DILocation(line: 94, column: 47, scope: !2571)
!2697 = !DILocation(line: 94, column: 45, scope: !2571)
!2698 = !DILocation(line: 94, column: 36, scope: !2571)
!2699 = !DILocation(line: 94, column: 28, scope: !2571)
!2700 = !DILocation(line: 95, column: 13, scope: !2571)
!2701 = !DILocation(line: 95, column: 19, scope: !2571)
!2702 = !DILocation(line: 95, column: 48, scope: !2571)
!2703 = !DILocation(line: 95, column: 40, scope: !2571)
!2704 = !DILocation(line: 95, column: 33, scope: !2571)
!2705 = !DILocation(line: 99, column: 58, scope: !2571)
!2706 = !DILocation(line: 99, column: 9, scope: !2571)
!2707 = !DILocation(line: 100, column: 5, scope: !2571)
!2708 = !DILocation(line: 103, column: 19, scope: !2571)
!2709 = !DILocation(line: 104, column: 29, scope: !2571)
!2710 = !DILocation(line: 104, column: 22, scope: !2571)
!2711 = !DILocation(line: 104, column: 45, scope: !2571)
!2712 = !DILocation(line: 104, column: 19, scope: !2571)
!2713 = !DILocation(line: 108, column: 18, scope: !2571)
!2714 = !DILocation(line: 108, column: 15, scope: !2571)
!2715 = !DILocation(line: 113, column: 9, scope: !2571)
!2716 = !DILocation(line: 113, column: 19, scope: !2571)
!2717 = !DILocation(line: 113, column: 39, scope: !2571)
!2718 = !DILocation(line: 113, column: 30, scope: !2571)
!2719 = !DILocation(line: 114, column: 9, scope: !2571)
!2720 = !DILocation(line: 114, column: 19, scope: !2571)
!2721 = !DILocation(line: 114, column: 44, scope: !2571)
!2722 = !DILocation(line: 114, column: 54, scope: !2571)
!2723 = !DILocation(line: 114, column: 41, scope: !2571)
!2724 = !DILocation(line: 114, column: 31, scope: !2571)
!2725 = !DILocation(line: 115, column: 20, scope: !2571)
!2726 = !DILocation(line: 115, column: 12, scope: !2571)
!2727 = !DILocation(line: 115, column: 5, scope: !2571)
!2728 = !DILocation(line: 116, column: 1, scope: !2571)
!2729 = distinct !DISubprogram(name: "toRep", scope: !412, file: !412, line: 231, type: !179, scopeLine: 231, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !119, retainedNodes: !2)
!2730 = !DILocation(line: 232, column: 44, scope: !2729)
!2731 = !DILocation(line: 232, column: 50, scope: !2729)
!2732 = !DILocation(line: 233, column: 16, scope: !2729)
!2733 = !DILocation(line: 233, column: 5, scope: !2729)
!2734 = distinct !DISubprogram(name: "fromRep", scope: !412, file: !412, line: 236, type: !179, scopeLine: 236, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !119, retainedNodes: !2)
!2735 = !DILocation(line: 237, column: 44, scope: !2734)
!2736 = !DILocation(line: 237, column: 50, scope: !2734)
!2737 = !DILocation(line: 238, column: 16, scope: !2734)
!2738 = !DILocation(line: 238, column: 5, scope: !2734)
!2739 = distinct !DISubprogram(name: "normalize", scope: !412, file: !412, line: 241, type: !179, scopeLine: 241, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !119, retainedNodes: !2)
!2740 = !DILocation(line: 242, column: 32, scope: !2739)
!2741 = !DILocation(line: 242, column: 31, scope: !2739)
!2742 = !DILocation(line: 242, column: 23, scope: !2739)
!2743 = !DILocation(line: 242, column: 47, scope: !2739)
!2744 = !DILocation(line: 242, column: 45, scope: !2739)
!2745 = !DILocation(line: 242, column: 15, scope: !2739)
!2746 = !DILocation(line: 243, column: 22, scope: !2739)
!2747 = !DILocation(line: 243, column: 6, scope: !2739)
!2748 = !DILocation(line: 243, column: 18, scope: !2739)
!2749 = !DILocation(line: 244, column: 16, scope: !2739)
!2750 = !DILocation(line: 244, column: 14, scope: !2739)
!2751 = !DILocation(line: 244, column: 5, scope: !2739)
!2752 = distinct !DISubprogram(name: "wideMultiply", scope: !412, file: !412, line: 86, type: !179, scopeLine: 86, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !119, retainedNodes: !2)
!2753 = !DILocation(line: 88, column: 28, scope: !2752)
!2754 = !DILocation(line: 88, column: 40, scope: !2752)
!2755 = !DILocation(line: 88, column: 38, scope: !2752)
!2756 = !DILocation(line: 88, column: 20, scope: !2752)
!2757 = !DILocation(line: 89, column: 28, scope: !2752)
!2758 = !DILocation(line: 89, column: 40, scope: !2752)
!2759 = !DILocation(line: 89, column: 38, scope: !2752)
!2760 = !DILocation(line: 89, column: 20, scope: !2752)
!2761 = !DILocation(line: 90, column: 28, scope: !2752)
!2762 = !DILocation(line: 90, column: 40, scope: !2752)
!2763 = !DILocation(line: 90, column: 38, scope: !2752)
!2764 = !DILocation(line: 90, column: 20, scope: !2752)
!2765 = !DILocation(line: 91, column: 28, scope: !2752)
!2766 = !DILocation(line: 91, column: 40, scope: !2752)
!2767 = !DILocation(line: 91, column: 38, scope: !2752)
!2768 = !DILocation(line: 91, column: 20, scope: !2752)
!2769 = !DILocation(line: 93, column: 25, scope: !2752)
!2770 = !DILocation(line: 93, column: 20, scope: !2752)
!2771 = !DILocation(line: 94, column: 25, scope: !2752)
!2772 = !DILocation(line: 94, column: 41, scope: !2752)
!2773 = !DILocation(line: 94, column: 39, scope: !2752)
!2774 = !DILocation(line: 94, column: 57, scope: !2752)
!2775 = !DILocation(line: 94, column: 55, scope: !2752)
!2776 = !DILocation(line: 94, column: 20, scope: !2752)
!2777 = !DILocation(line: 95, column: 11, scope: !2752)
!2778 = !DILocation(line: 95, column: 17, scope: !2752)
!2779 = !DILocation(line: 95, column: 20, scope: !2752)
!2780 = !DILocation(line: 95, column: 14, scope: !2752)
!2781 = !DILocation(line: 95, column: 6, scope: !2752)
!2782 = !DILocation(line: 95, column: 9, scope: !2752)
!2783 = !DILocation(line: 97, column: 11, scope: !2752)
!2784 = !DILocation(line: 97, column: 27, scope: !2752)
!2785 = !DILocation(line: 97, column: 25, scope: !2752)
!2786 = !DILocation(line: 97, column: 43, scope: !2752)
!2787 = !DILocation(line: 97, column: 41, scope: !2752)
!2788 = !DILocation(line: 97, column: 56, scope: !2752)
!2789 = !DILocation(line: 97, column: 54, scope: !2752)
!2790 = !DILocation(line: 97, column: 6, scope: !2752)
!2791 = !DILocation(line: 97, column: 9, scope: !2752)
!2792 = !DILocation(line: 98, column: 1, scope: !2752)
!2793 = distinct !DISubprogram(name: "wideLeftShift", scope: !412, file: !412, line: 247, type: !179, scopeLine: 247, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !119, retainedNodes: !2)
!2794 = !DILocation(line: 248, column: 12, scope: !2793)
!2795 = !DILocation(line: 248, column: 11, scope: !2793)
!2796 = !DILocation(line: 248, column: 18, scope: !2793)
!2797 = !DILocation(line: 248, column: 15, scope: !2793)
!2798 = !DILocation(line: 248, column: 27, scope: !2793)
!2799 = !DILocation(line: 248, column: 26, scope: !2793)
!2800 = !DILocation(line: 248, column: 46, scope: !2793)
!2801 = !DILocation(line: 248, column: 44, scope: !2793)
!2802 = !DILocation(line: 248, column: 30, scope: !2793)
!2803 = !DILocation(line: 248, column: 24, scope: !2793)
!2804 = !DILocation(line: 248, column: 6, scope: !2793)
!2805 = !DILocation(line: 248, column: 9, scope: !2793)
!2806 = !DILocation(line: 249, column: 12, scope: !2793)
!2807 = !DILocation(line: 249, column: 11, scope: !2793)
!2808 = !DILocation(line: 249, column: 18, scope: !2793)
!2809 = !DILocation(line: 249, column: 15, scope: !2793)
!2810 = !DILocation(line: 249, column: 6, scope: !2793)
!2811 = !DILocation(line: 249, column: 9, scope: !2793)
!2812 = !DILocation(line: 250, column: 1, scope: !2793)
!2813 = distinct !DISubprogram(name: "wideRightShiftWithSticky", scope: !412, file: !412, line: 252, type: !179, scopeLine: 252, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !119, retainedNodes: !2)
!2814 = !DILocation(line: 253, column: 9, scope: !2813)
!2815 = !DILocation(line: 253, column: 15, scope: !2813)
!2816 = !DILocation(line: 254, column: 30, scope: !2813)
!2817 = !DILocation(line: 254, column: 29, scope: !2813)
!2818 = !DILocation(line: 254, column: 49, scope: !2813)
!2819 = !DILocation(line: 254, column: 47, scope: !2813)
!2820 = !DILocation(line: 254, column: 33, scope: !2813)
!2821 = !DILocation(line: 254, column: 20, scope: !2813)
!2822 = !DILocation(line: 255, column: 16, scope: !2813)
!2823 = !DILocation(line: 255, column: 15, scope: !2813)
!2824 = !DILocation(line: 255, column: 35, scope: !2813)
!2825 = !DILocation(line: 255, column: 33, scope: !2813)
!2826 = !DILocation(line: 255, column: 19, scope: !2813)
!2827 = !DILocation(line: 255, column: 45, scope: !2813)
!2828 = !DILocation(line: 255, column: 44, scope: !2813)
!2829 = !DILocation(line: 255, column: 51, scope: !2813)
!2830 = !DILocation(line: 255, column: 48, scope: !2813)
!2831 = !DILocation(line: 255, column: 42, scope: !2813)
!2832 = !DILocation(line: 255, column: 59, scope: !2813)
!2833 = !DILocation(line: 255, column: 57, scope: !2813)
!2834 = !DILocation(line: 255, column: 10, scope: !2813)
!2835 = !DILocation(line: 255, column: 13, scope: !2813)
!2836 = !DILocation(line: 256, column: 16, scope: !2813)
!2837 = !DILocation(line: 256, column: 15, scope: !2813)
!2838 = !DILocation(line: 256, column: 22, scope: !2813)
!2839 = !DILocation(line: 256, column: 19, scope: !2813)
!2840 = !DILocation(line: 256, column: 10, scope: !2813)
!2841 = !DILocation(line: 256, column: 13, scope: !2813)
!2842 = !DILocation(line: 257, column: 5, scope: !2813)
!2843 = !DILocation(line: 258, column: 14, scope: !2813)
!2844 = !DILocation(line: 258, column: 20, scope: !2813)
!2845 = !DILocation(line: 259, column: 30, scope: !2813)
!2846 = !DILocation(line: 259, column: 29, scope: !2813)
!2847 = !DILocation(line: 259, column: 51, scope: !2813)
!2848 = !DILocation(line: 259, column: 49, scope: !2813)
!2849 = !DILocation(line: 259, column: 33, scope: !2813)
!2850 = !DILocation(line: 259, column: 61, scope: !2813)
!2851 = !DILocation(line: 259, column: 60, scope: !2813)
!2852 = !DILocation(line: 259, column: 58, scope: !2813)
!2853 = !DILocation(line: 259, column: 20, scope: !2813)
!2854 = !DILocation(line: 260, column: 16, scope: !2813)
!2855 = !DILocation(line: 260, column: 15, scope: !2813)
!2856 = !DILocation(line: 260, column: 23, scope: !2813)
!2857 = !DILocation(line: 260, column: 29, scope: !2813)
!2858 = !DILocation(line: 260, column: 19, scope: !2813)
!2859 = !DILocation(line: 260, column: 44, scope: !2813)
!2860 = !DILocation(line: 260, column: 42, scope: !2813)
!2861 = !DILocation(line: 260, column: 10, scope: !2813)
!2862 = !DILocation(line: 260, column: 13, scope: !2813)
!2863 = !DILocation(line: 261, column: 10, scope: !2813)
!2864 = !DILocation(line: 261, column: 13, scope: !2813)
!2865 = !DILocation(line: 262, column: 5, scope: !2813)
!2866 = !DILocation(line: 263, column: 30, scope: !2813)
!2867 = !DILocation(line: 263, column: 29, scope: !2813)
!2868 = !DILocation(line: 263, column: 36, scope: !2813)
!2869 = !DILocation(line: 263, column: 35, scope: !2813)
!2870 = !DILocation(line: 263, column: 33, scope: !2813)
!2871 = !DILocation(line: 263, column: 20, scope: !2813)
!2872 = !DILocation(line: 264, column: 15, scope: !2813)
!2873 = !DILocation(line: 264, column: 10, scope: !2813)
!2874 = !DILocation(line: 264, column: 13, scope: !2813)
!2875 = !DILocation(line: 265, column: 10, scope: !2813)
!2876 = !DILocation(line: 265, column: 13, scope: !2813)
!2877 = !DILocation(line: 267, column: 1, scope: !2813)
!2878 = distinct !DISubprogram(name: "rep_clz", scope: !412, file: !412, line: 69, type: !179, scopeLine: 69, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !119, retainedNodes: !2)
!2879 = !DILocation(line: 73, column: 9, scope: !2878)
!2880 = !DILocation(line: 73, column: 11, scope: !2878)
!2881 = !DILocation(line: 74, column: 30, scope: !2878)
!2882 = !DILocation(line: 74, column: 32, scope: !2878)
!2883 = !DILocation(line: 74, column: 16, scope: !2878)
!2884 = !DILocation(line: 74, column: 9, scope: !2878)
!2885 = !DILocation(line: 76, column: 35, scope: !2878)
!2886 = !DILocation(line: 76, column: 37, scope: !2878)
!2887 = !DILocation(line: 76, column: 21, scope: !2878)
!2888 = !DILocation(line: 76, column: 19, scope: !2878)
!2889 = !DILocation(line: 76, column: 9, scope: !2878)
!2890 = !DILocation(line: 78, column: 1, scope: !2878)
!2891 = distinct !DISubprogram(name: "__muldi3", scope: !122, file: !122, line: 46, type: !179, scopeLine: 47, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !121, retainedNodes: !2)
!2892 = !DILocation(line: 49, column: 13, scope: !2891)
!2893 = !DILocation(line: 49, column: 7, scope: !2891)
!2894 = !DILocation(line: 49, column: 11, scope: !2891)
!2895 = !DILocation(line: 51, column: 13, scope: !2891)
!2896 = !DILocation(line: 51, column: 7, scope: !2891)
!2897 = !DILocation(line: 51, column: 11, scope: !2891)
!2898 = !DILocation(line: 53, column: 25, scope: !2891)
!2899 = !DILocation(line: 53, column: 27, scope: !2891)
!2900 = !DILocation(line: 53, column: 34, scope: !2891)
!2901 = !DILocation(line: 53, column: 36, scope: !2891)
!2902 = !DILocation(line: 53, column: 13, scope: !2891)
!2903 = !DILocation(line: 53, column: 7, scope: !2891)
!2904 = !DILocation(line: 53, column: 11, scope: !2891)
!2905 = !DILocation(line: 54, column: 19, scope: !2891)
!2906 = !DILocation(line: 54, column: 21, scope: !2891)
!2907 = !DILocation(line: 54, column: 30, scope: !2891)
!2908 = !DILocation(line: 54, column: 32, scope: !2891)
!2909 = !DILocation(line: 54, column: 26, scope: !2891)
!2910 = !DILocation(line: 54, column: 40, scope: !2891)
!2911 = !DILocation(line: 54, column: 42, scope: !2891)
!2912 = !DILocation(line: 54, column: 50, scope: !2891)
!2913 = !DILocation(line: 54, column: 52, scope: !2891)
!2914 = !DILocation(line: 54, column: 46, scope: !2891)
!2915 = !DILocation(line: 54, column: 36, scope: !2891)
!2916 = !DILocation(line: 54, column: 7, scope: !2891)
!2917 = !DILocation(line: 54, column: 9, scope: !2891)
!2918 = !DILocation(line: 54, column: 14, scope: !2891)
!2919 = !DILocation(line: 55, column: 14, scope: !2891)
!2920 = !DILocation(line: 55, column: 5, scope: !2891)
!2921 = distinct !DISubprogram(name: "__muldsi3", scope: !122, file: !122, line: 21, type: !179, scopeLine: 22, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !121, retainedNodes: !2)
!2922 = !DILocation(line: 24, column: 15, scope: !2921)
!2923 = !DILocation(line: 25, column: 18, scope: !2921)
!2924 = !DILocation(line: 26, column: 16, scope: !2921)
!2925 = !DILocation(line: 26, column: 18, scope: !2921)
!2926 = !DILocation(line: 26, column: 35, scope: !2921)
!2927 = !DILocation(line: 26, column: 37, scope: !2921)
!2928 = !DILocation(line: 26, column: 32, scope: !2921)
!2929 = !DILocation(line: 26, column: 7, scope: !2921)
!2930 = !DILocation(line: 26, column: 9, scope: !2921)
!2931 = !DILocation(line: 26, column: 13, scope: !2921)
!2932 = !DILocation(line: 27, column: 18, scope: !2921)
!2933 = !DILocation(line: 27, column: 20, scope: !2921)
!2934 = !DILocation(line: 27, column: 24, scope: !2921)
!2935 = !DILocation(line: 27, column: 12, scope: !2921)
!2936 = !DILocation(line: 28, column: 7, scope: !2921)
!2937 = !DILocation(line: 28, column: 9, scope: !2921)
!2938 = !DILocation(line: 28, column: 13, scope: !2921)
!2939 = !DILocation(line: 29, column: 11, scope: !2921)
!2940 = !DILocation(line: 29, column: 13, scope: !2921)
!2941 = !DILocation(line: 29, column: 35, scope: !2921)
!2942 = !DILocation(line: 29, column: 37, scope: !2921)
!2943 = !DILocation(line: 29, column: 32, scope: !2921)
!2944 = !DILocation(line: 29, column: 7, scope: !2921)
!2945 = !DILocation(line: 30, column: 17, scope: !2921)
!2946 = !DILocation(line: 30, column: 19, scope: !2921)
!2947 = !DILocation(line: 30, column: 33, scope: !2921)
!2948 = !DILocation(line: 30, column: 7, scope: !2921)
!2949 = !DILocation(line: 30, column: 9, scope: !2921)
!2950 = !DILocation(line: 30, column: 13, scope: !2921)
!2951 = !DILocation(line: 31, column: 16, scope: !2921)
!2952 = !DILocation(line: 31, column: 18, scope: !2921)
!2953 = !DILocation(line: 31, column: 7, scope: !2921)
!2954 = !DILocation(line: 31, column: 9, scope: !2921)
!2955 = !DILocation(line: 31, column: 14, scope: !2921)
!2956 = !DILocation(line: 32, column: 11, scope: !2921)
!2957 = !DILocation(line: 32, column: 13, scope: !2921)
!2958 = !DILocation(line: 32, column: 17, scope: !2921)
!2959 = !DILocation(line: 32, column: 7, scope: !2921)
!2960 = !DILocation(line: 33, column: 7, scope: !2921)
!2961 = !DILocation(line: 33, column: 9, scope: !2921)
!2962 = !DILocation(line: 33, column: 13, scope: !2921)
!2963 = !DILocation(line: 34, column: 11, scope: !2921)
!2964 = !DILocation(line: 34, column: 13, scope: !2921)
!2965 = !DILocation(line: 34, column: 35, scope: !2921)
!2966 = !DILocation(line: 34, column: 37, scope: !2921)
!2967 = !DILocation(line: 34, column: 32, scope: !2921)
!2968 = !DILocation(line: 34, column: 7, scope: !2921)
!2969 = !DILocation(line: 35, column: 17, scope: !2921)
!2970 = !DILocation(line: 35, column: 19, scope: !2921)
!2971 = !DILocation(line: 35, column: 33, scope: !2921)
!2972 = !DILocation(line: 35, column: 7, scope: !2921)
!2973 = !DILocation(line: 35, column: 9, scope: !2921)
!2974 = !DILocation(line: 35, column: 13, scope: !2921)
!2975 = !DILocation(line: 36, column: 17, scope: !2921)
!2976 = !DILocation(line: 36, column: 19, scope: !2921)
!2977 = !DILocation(line: 36, column: 7, scope: !2921)
!2978 = !DILocation(line: 36, column: 9, scope: !2921)
!2979 = !DILocation(line: 36, column: 14, scope: !2921)
!2980 = !DILocation(line: 37, column: 18, scope: !2921)
!2981 = !DILocation(line: 37, column: 20, scope: !2921)
!2982 = !DILocation(line: 37, column: 42, scope: !2921)
!2983 = !DILocation(line: 37, column: 44, scope: !2921)
!2984 = !DILocation(line: 37, column: 39, scope: !2921)
!2985 = !DILocation(line: 37, column: 7, scope: !2921)
!2986 = !DILocation(line: 37, column: 9, scope: !2921)
!2987 = !DILocation(line: 37, column: 14, scope: !2921)
!2988 = !DILocation(line: 38, column: 14, scope: !2921)
!2989 = !DILocation(line: 38, column: 5, scope: !2921)
!2990 = distinct !DISubprogram(name: "__mulodi4", scope: !124, file: !124, line: 22, type: !179, scopeLine: 23, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !123, retainedNodes: !2)
!2991 = !DILocation(line: 24, column: 15, scope: !2990)
!2992 = !DILocation(line: 25, column: 18, scope: !2990)
!2993 = !DILocation(line: 26, column: 18, scope: !2990)
!2994 = !DILocation(line: 27, column: 6, scope: !2990)
!2995 = !DILocation(line: 27, column: 15, scope: !2990)
!2996 = !DILocation(line: 28, column: 21, scope: !2990)
!2997 = !DILocation(line: 28, column: 25, scope: !2990)
!2998 = !DILocation(line: 28, column: 23, scope: !2990)
!2999 = !DILocation(line: 28, column: 12, scope: !2990)
!3000 = !DILocation(line: 29, column: 9, scope: !2990)
!3001 = !DILocation(line: 29, column: 11, scope: !2990)
!3002 = !DILocation(line: 31, column: 13, scope: !2990)
!3003 = !DILocation(line: 31, column: 15, scope: !2990)
!3004 = !DILocation(line: 31, column: 20, scope: !2990)
!3005 = !DILocation(line: 31, column: 23, scope: !2990)
!3006 = !DILocation(line: 31, column: 25, scope: !2990)
!3007 = !DILocation(line: 32, column: 7, scope: !2990)
!3008 = !DILocation(line: 32, column: 16, scope: !2990)
!3009 = !DILocation(line: 32, column: 6, scope: !2990)
!3010 = !DILocation(line: 33, column: 9, scope: !2990)
!3011 = !DILocation(line: 33, column: 2, scope: !2990)
!3012 = !DILocation(line: 35, column: 9, scope: !2990)
!3013 = !DILocation(line: 35, column: 11, scope: !2990)
!3014 = !DILocation(line: 37, column: 13, scope: !2990)
!3015 = !DILocation(line: 37, column: 15, scope: !2990)
!3016 = !DILocation(line: 37, column: 20, scope: !2990)
!3017 = !DILocation(line: 37, column: 23, scope: !2990)
!3018 = !DILocation(line: 37, column: 25, scope: !2990)
!3019 = !DILocation(line: 38, column: 7, scope: !2990)
!3020 = !DILocation(line: 38, column: 16, scope: !2990)
!3021 = !DILocation(line: 38, column: 6, scope: !2990)
!3022 = !DILocation(line: 39, column: 16, scope: !2990)
!3023 = !DILocation(line: 39, column: 9, scope: !2990)
!3024 = !DILocation(line: 41, column: 17, scope: !2990)
!3025 = !DILocation(line: 41, column: 19, scope: !2990)
!3026 = !DILocation(line: 41, column: 12, scope: !2990)
!3027 = !DILocation(line: 42, column: 21, scope: !2990)
!3028 = !DILocation(line: 42, column: 25, scope: !2990)
!3029 = !DILocation(line: 42, column: 23, scope: !2990)
!3030 = !DILocation(line: 42, column: 31, scope: !2990)
!3031 = !DILocation(line: 42, column: 29, scope: !2990)
!3032 = !DILocation(line: 42, column: 12, scope: !2990)
!3033 = !DILocation(line: 43, column: 17, scope: !2990)
!3034 = !DILocation(line: 43, column: 19, scope: !2990)
!3035 = !DILocation(line: 43, column: 12, scope: !2990)
!3036 = !DILocation(line: 44, column: 21, scope: !2990)
!3037 = !DILocation(line: 44, column: 25, scope: !2990)
!3038 = !DILocation(line: 44, column: 23, scope: !2990)
!3039 = !DILocation(line: 44, column: 31, scope: !2990)
!3040 = !DILocation(line: 44, column: 29, scope: !2990)
!3041 = !DILocation(line: 44, column: 12, scope: !2990)
!3042 = !DILocation(line: 45, column: 9, scope: !2990)
!3043 = !DILocation(line: 45, column: 15, scope: !2990)
!3044 = !DILocation(line: 45, column: 19, scope: !2990)
!3045 = !DILocation(line: 45, column: 22, scope: !2990)
!3046 = !DILocation(line: 45, column: 28, scope: !2990)
!3047 = !DILocation(line: 46, column: 16, scope: !2990)
!3048 = !DILocation(line: 46, column: 9, scope: !2990)
!3049 = !DILocation(line: 47, column: 9, scope: !2990)
!3050 = !DILocation(line: 47, column: 15, scope: !2990)
!3051 = !DILocation(line: 47, column: 12, scope: !2990)
!3052 = !DILocation(line: 49, column: 13, scope: !2990)
!3053 = !DILocation(line: 49, column: 27, scope: !2990)
!3054 = !DILocation(line: 49, column: 25, scope: !2990)
!3055 = !DILocation(line: 49, column: 19, scope: !2990)
!3056 = !DILocation(line: 50, column: 14, scope: !2990)
!3057 = !DILocation(line: 50, column: 23, scope: !2990)
!3058 = !DILocation(line: 50, column: 13, scope: !2990)
!3059 = !DILocation(line: 51, column: 5, scope: !2990)
!3060 = !DILocation(line: 54, column: 13, scope: !2990)
!3061 = !DILocation(line: 54, column: 28, scope: !2990)
!3062 = !DILocation(line: 54, column: 27, scope: !2990)
!3063 = !DILocation(line: 54, column: 25, scope: !2990)
!3064 = !DILocation(line: 54, column: 19, scope: !2990)
!3065 = !DILocation(line: 55, column: 14, scope: !2990)
!3066 = !DILocation(line: 55, column: 23, scope: !2990)
!3067 = !DILocation(line: 55, column: 13, scope: !2990)
!3068 = !DILocation(line: 57, column: 12, scope: !2990)
!3069 = !DILocation(line: 57, column: 5, scope: !2990)
!3070 = !DILocation(line: 58, column: 1, scope: !2990)
!3071 = distinct !DISubprogram(name: "__mulosi4", scope: !126, file: !126, line: 22, type: !179, scopeLine: 23, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !125, retainedNodes: !2)
!3072 = !DILocation(line: 24, column: 15, scope: !3071)
!3073 = !DILocation(line: 25, column: 18, scope: !3071)
!3074 = !DILocation(line: 26, column: 18, scope: !3071)
!3075 = !DILocation(line: 27, column: 6, scope: !3071)
!3076 = !DILocation(line: 27, column: 15, scope: !3071)
!3077 = !DILocation(line: 28, column: 21, scope: !3071)
!3078 = !DILocation(line: 28, column: 25, scope: !3071)
!3079 = !DILocation(line: 28, column: 23, scope: !3071)
!3080 = !DILocation(line: 28, column: 12, scope: !3071)
!3081 = !DILocation(line: 29, column: 9, scope: !3071)
!3082 = !DILocation(line: 29, column: 11, scope: !3071)
!3083 = !DILocation(line: 31, column: 13, scope: !3071)
!3084 = !DILocation(line: 31, column: 15, scope: !3071)
!3085 = !DILocation(line: 31, column: 20, scope: !3071)
!3086 = !DILocation(line: 31, column: 23, scope: !3071)
!3087 = !DILocation(line: 31, column: 25, scope: !3071)
!3088 = !DILocation(line: 32, column: 7, scope: !3071)
!3089 = !DILocation(line: 32, column: 16, scope: !3071)
!3090 = !DILocation(line: 32, column: 6, scope: !3071)
!3091 = !DILocation(line: 33, column: 9, scope: !3071)
!3092 = !DILocation(line: 33, column: 2, scope: !3071)
!3093 = !DILocation(line: 35, column: 9, scope: !3071)
!3094 = !DILocation(line: 35, column: 11, scope: !3071)
!3095 = !DILocation(line: 37, column: 13, scope: !3071)
!3096 = !DILocation(line: 37, column: 15, scope: !3071)
!3097 = !DILocation(line: 37, column: 20, scope: !3071)
!3098 = !DILocation(line: 37, column: 23, scope: !3071)
!3099 = !DILocation(line: 37, column: 25, scope: !3071)
!3100 = !DILocation(line: 38, column: 7, scope: !3071)
!3101 = !DILocation(line: 38, column: 16, scope: !3071)
!3102 = !DILocation(line: 38, column: 6, scope: !3071)
!3103 = !DILocation(line: 39, column: 16, scope: !3071)
!3104 = !DILocation(line: 39, column: 9, scope: !3071)
!3105 = !DILocation(line: 41, column: 17, scope: !3071)
!3106 = !DILocation(line: 41, column: 19, scope: !3071)
!3107 = !DILocation(line: 41, column: 12, scope: !3071)
!3108 = !DILocation(line: 42, column: 21, scope: !3071)
!3109 = !DILocation(line: 42, column: 25, scope: !3071)
!3110 = !DILocation(line: 42, column: 23, scope: !3071)
!3111 = !DILocation(line: 42, column: 31, scope: !3071)
!3112 = !DILocation(line: 42, column: 29, scope: !3071)
!3113 = !DILocation(line: 42, column: 12, scope: !3071)
!3114 = !DILocation(line: 43, column: 17, scope: !3071)
!3115 = !DILocation(line: 43, column: 19, scope: !3071)
!3116 = !DILocation(line: 43, column: 12, scope: !3071)
!3117 = !DILocation(line: 44, column: 21, scope: !3071)
!3118 = !DILocation(line: 44, column: 25, scope: !3071)
!3119 = !DILocation(line: 44, column: 23, scope: !3071)
!3120 = !DILocation(line: 44, column: 31, scope: !3071)
!3121 = !DILocation(line: 44, column: 29, scope: !3071)
!3122 = !DILocation(line: 44, column: 12, scope: !3071)
!3123 = !DILocation(line: 45, column: 9, scope: !3071)
!3124 = !DILocation(line: 45, column: 15, scope: !3071)
!3125 = !DILocation(line: 45, column: 19, scope: !3071)
!3126 = !DILocation(line: 45, column: 22, scope: !3071)
!3127 = !DILocation(line: 45, column: 28, scope: !3071)
!3128 = !DILocation(line: 46, column: 16, scope: !3071)
!3129 = !DILocation(line: 46, column: 9, scope: !3071)
!3130 = !DILocation(line: 47, column: 9, scope: !3071)
!3131 = !DILocation(line: 47, column: 15, scope: !3071)
!3132 = !DILocation(line: 47, column: 12, scope: !3071)
!3133 = !DILocation(line: 49, column: 13, scope: !3071)
!3134 = !DILocation(line: 49, column: 27, scope: !3071)
!3135 = !DILocation(line: 49, column: 25, scope: !3071)
!3136 = !DILocation(line: 49, column: 19, scope: !3071)
!3137 = !DILocation(line: 50, column: 14, scope: !3071)
!3138 = !DILocation(line: 50, column: 23, scope: !3071)
!3139 = !DILocation(line: 50, column: 13, scope: !3071)
!3140 = !DILocation(line: 51, column: 5, scope: !3071)
!3141 = !DILocation(line: 54, column: 13, scope: !3071)
!3142 = !DILocation(line: 54, column: 28, scope: !3071)
!3143 = !DILocation(line: 54, column: 27, scope: !3071)
!3144 = !DILocation(line: 54, column: 25, scope: !3071)
!3145 = !DILocation(line: 54, column: 19, scope: !3071)
!3146 = !DILocation(line: 55, column: 14, scope: !3071)
!3147 = !DILocation(line: 55, column: 23, scope: !3071)
!3148 = !DILocation(line: 55, column: 13, scope: !3071)
!3149 = !DILocation(line: 57, column: 12, scope: !3071)
!3150 = !DILocation(line: 57, column: 5, scope: !3071)
!3151 = !DILocation(line: 58, column: 1, scope: !3071)
!3152 = distinct !DISubprogram(name: "__mulsf3", scope: !130, file: !130, line: 20, type: !179, scopeLine: 20, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !129, retainedNodes: !2)
!3153 = !DILocation(line: 21, column: 23, scope: !3152)
!3154 = !DILocation(line: 21, column: 26, scope: !3152)
!3155 = !DILocation(line: 21, column: 12, scope: !3152)
!3156 = !DILocation(line: 21, column: 5, scope: !3152)
!3157 = distinct !DISubprogram(name: "__mulXf3__", scope: !2572, file: !2572, line: 17, type: !179, scopeLine: 17, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !129, retainedNodes: !2)
!3158 = !DILocation(line: 18, column: 42, scope: !3157)
!3159 = !DILocation(line: 18, column: 36, scope: !3157)
!3160 = !DILocation(line: 18, column: 45, scope: !3157)
!3161 = !DILocation(line: 18, column: 64, scope: !3157)
!3162 = !DILocation(line: 18, column: 24, scope: !3157)
!3163 = !DILocation(line: 19, column: 42, scope: !3157)
!3164 = !DILocation(line: 19, column: 36, scope: !3157)
!3165 = !DILocation(line: 19, column: 45, scope: !3157)
!3166 = !DILocation(line: 19, column: 64, scope: !3157)
!3167 = !DILocation(line: 19, column: 24, scope: !3157)
!3168 = !DILocation(line: 20, column: 38, scope: !3157)
!3169 = !DILocation(line: 20, column: 32, scope: !3157)
!3170 = !DILocation(line: 20, column: 49, scope: !3157)
!3171 = !DILocation(line: 20, column: 43, scope: !3157)
!3172 = !DILocation(line: 20, column: 41, scope: !3157)
!3173 = !DILocation(line: 20, column: 53, scope: !3157)
!3174 = !DILocation(line: 20, column: 17, scope: !3157)
!3175 = !DILocation(line: 22, column: 32, scope: !3157)
!3176 = !DILocation(line: 22, column: 26, scope: !3157)
!3177 = !DILocation(line: 22, column: 35, scope: !3157)
!3178 = !DILocation(line: 22, column: 11, scope: !3157)
!3179 = !DILocation(line: 23, column: 32, scope: !3157)
!3180 = !DILocation(line: 23, column: 26, scope: !3157)
!3181 = !DILocation(line: 23, column: 35, scope: !3157)
!3182 = !DILocation(line: 23, column: 11, scope: !3157)
!3183 = !DILocation(line: 24, column: 9, scope: !3157)
!3184 = !DILocation(line: 27, column: 9, scope: !3157)
!3185 = !DILocation(line: 27, column: 18, scope: !3157)
!3186 = !DILocation(line: 27, column: 22, scope: !3157)
!3187 = !DILocation(line: 27, column: 40, scope: !3157)
!3188 = !DILocation(line: 27, column: 43, scope: !3157)
!3189 = !DILocation(line: 27, column: 52, scope: !3157)
!3190 = !DILocation(line: 27, column: 56, scope: !3157)
!3191 = !DILocation(line: 29, column: 34, scope: !3157)
!3192 = !DILocation(line: 29, column: 28, scope: !3157)
!3193 = !DILocation(line: 29, column: 37, scope: !3157)
!3194 = !DILocation(line: 29, column: 21, scope: !3157)
!3195 = !DILocation(line: 30, column: 34, scope: !3157)
!3196 = !DILocation(line: 30, column: 28, scope: !3157)
!3197 = !DILocation(line: 30, column: 37, scope: !3157)
!3198 = !DILocation(line: 30, column: 21, scope: !3157)
!3199 = !DILocation(line: 33, column: 13, scope: !3157)
!3200 = !DILocation(line: 33, column: 18, scope: !3157)
!3201 = !DILocation(line: 33, column: 49, scope: !3157)
!3202 = !DILocation(line: 33, column: 43, scope: !3157)
!3203 = !DILocation(line: 33, column: 52, scope: !3157)
!3204 = !DILocation(line: 33, column: 35, scope: !3157)
!3205 = !DILocation(line: 33, column: 28, scope: !3157)
!3206 = !DILocation(line: 35, column: 13, scope: !3157)
!3207 = !DILocation(line: 35, column: 18, scope: !3157)
!3208 = !DILocation(line: 35, column: 49, scope: !3157)
!3209 = !DILocation(line: 35, column: 43, scope: !3157)
!3210 = !DILocation(line: 35, column: 52, scope: !3157)
!3211 = !DILocation(line: 35, column: 35, scope: !3157)
!3212 = !DILocation(line: 35, column: 28, scope: !3157)
!3213 = !DILocation(line: 37, column: 13, scope: !3157)
!3214 = !DILocation(line: 37, column: 18, scope: !3157)
!3215 = !DILocation(line: 39, column: 17, scope: !3157)
!3216 = !DILocation(line: 39, column: 38, scope: !3157)
!3217 = !DILocation(line: 39, column: 45, scope: !3157)
!3218 = !DILocation(line: 39, column: 43, scope: !3157)
!3219 = !DILocation(line: 39, column: 30, scope: !3157)
!3220 = !DILocation(line: 39, column: 23, scope: !3157)
!3221 = !DILocation(line: 41, column: 25, scope: !3157)
!3222 = !DILocation(line: 41, column: 18, scope: !3157)
!3223 = !DILocation(line: 44, column: 13, scope: !3157)
!3224 = !DILocation(line: 44, column: 18, scope: !3157)
!3225 = !DILocation(line: 46, column: 17, scope: !3157)
!3226 = !DILocation(line: 46, column: 38, scope: !3157)
!3227 = !DILocation(line: 46, column: 45, scope: !3157)
!3228 = !DILocation(line: 46, column: 43, scope: !3157)
!3229 = !DILocation(line: 46, column: 30, scope: !3157)
!3230 = !DILocation(line: 46, column: 23, scope: !3157)
!3231 = !DILocation(line: 48, column: 25, scope: !3157)
!3232 = !DILocation(line: 48, column: 18, scope: !3157)
!3233 = !DILocation(line: 52, column: 14, scope: !3157)
!3234 = !DILocation(line: 52, column: 13, scope: !3157)
!3235 = !DILocation(line: 52, column: 35, scope: !3157)
!3236 = !DILocation(line: 52, column: 27, scope: !3157)
!3237 = !DILocation(line: 52, column: 20, scope: !3157)
!3238 = !DILocation(line: 54, column: 14, scope: !3157)
!3239 = !DILocation(line: 54, column: 13, scope: !3157)
!3240 = !DILocation(line: 54, column: 35, scope: !3157)
!3241 = !DILocation(line: 54, column: 27, scope: !3157)
!3242 = !DILocation(line: 54, column: 20, scope: !3157)
!3243 = !DILocation(line: 59, column: 13, scope: !3157)
!3244 = !DILocation(line: 59, column: 18, scope: !3157)
!3245 = !DILocation(line: 59, column: 42, scope: !3157)
!3246 = !DILocation(line: 59, column: 39, scope: !3157)
!3247 = !DILocation(line: 59, column: 33, scope: !3157)
!3248 = !DILocation(line: 60, column: 13, scope: !3157)
!3249 = !DILocation(line: 60, column: 18, scope: !3157)
!3250 = !DILocation(line: 60, column: 42, scope: !3157)
!3251 = !DILocation(line: 60, column: 39, scope: !3157)
!3252 = !DILocation(line: 60, column: 33, scope: !3157)
!3253 = !DILocation(line: 61, column: 5, scope: !3157)
!3254 = !DILocation(line: 66, column: 18, scope: !3157)
!3255 = !DILocation(line: 67, column: 18, scope: !3157)
!3256 = !DILocation(line: 75, column: 18, scope: !3157)
!3257 = !DILocation(line: 75, column: 32, scope: !3157)
!3258 = !DILocation(line: 75, column: 45, scope: !3157)
!3259 = !DILocation(line: 75, column: 5, scope: !3157)
!3260 = !DILocation(line: 78, column: 27, scope: !3157)
!3261 = !DILocation(line: 78, column: 39, scope: !3157)
!3262 = !DILocation(line: 78, column: 37, scope: !3157)
!3263 = !DILocation(line: 78, column: 49, scope: !3157)
!3264 = !DILocation(line: 78, column: 66, scope: !3157)
!3265 = !DILocation(line: 78, column: 64, scope: !3157)
!3266 = !DILocation(line: 78, column: 9, scope: !3157)
!3267 = !DILocation(line: 81, column: 9, scope: !3157)
!3268 = !DILocation(line: 81, column: 19, scope: !3157)
!3269 = !DILocation(line: 81, column: 49, scope: !3157)
!3270 = !DILocation(line: 81, column: 34, scope: !3157)
!3271 = !DILocation(line: 82, column: 10, scope: !3157)
!3272 = !DILocation(line: 85, column: 9, scope: !3157)
!3273 = !DILocation(line: 85, column: 25, scope: !3157)
!3274 = !DILocation(line: 85, column: 65, scope: !3157)
!3275 = !DILocation(line: 85, column: 63, scope: !3157)
!3276 = !DILocation(line: 85, column: 48, scope: !3157)
!3277 = !DILocation(line: 85, column: 41, scope: !3157)
!3278 = !DILocation(line: 87, column: 9, scope: !3157)
!3279 = !DILocation(line: 87, column: 25, scope: !3157)
!3280 = !DILocation(line: 94, column: 61, scope: !3157)
!3281 = !DILocation(line: 94, column: 45, scope: !3157)
!3282 = !DILocation(line: 94, column: 28, scope: !3157)
!3283 = !DILocation(line: 95, column: 13, scope: !3157)
!3284 = !DILocation(line: 95, column: 19, scope: !3157)
!3285 = !DILocation(line: 95, column: 48, scope: !3157)
!3286 = !DILocation(line: 95, column: 40, scope: !3157)
!3287 = !DILocation(line: 95, column: 33, scope: !3157)
!3288 = !DILocation(line: 99, column: 58, scope: !3157)
!3289 = !DILocation(line: 99, column: 9, scope: !3157)
!3290 = !DILocation(line: 100, column: 5, scope: !3157)
!3291 = !DILocation(line: 103, column: 19, scope: !3157)
!3292 = !DILocation(line: 104, column: 29, scope: !3157)
!3293 = !DILocation(line: 104, column: 45, scope: !3157)
!3294 = !DILocation(line: 104, column: 19, scope: !3157)
!3295 = !DILocation(line: 108, column: 18, scope: !3157)
!3296 = !DILocation(line: 108, column: 15, scope: !3157)
!3297 = !DILocation(line: 113, column: 9, scope: !3157)
!3298 = !DILocation(line: 113, column: 19, scope: !3157)
!3299 = !DILocation(line: 113, column: 39, scope: !3157)
!3300 = !DILocation(line: 113, column: 30, scope: !3157)
!3301 = !DILocation(line: 114, column: 9, scope: !3157)
!3302 = !DILocation(line: 114, column: 19, scope: !3157)
!3303 = !DILocation(line: 114, column: 44, scope: !3157)
!3304 = !DILocation(line: 114, column: 54, scope: !3157)
!3305 = !DILocation(line: 114, column: 41, scope: !3157)
!3306 = !DILocation(line: 114, column: 31, scope: !3157)
!3307 = !DILocation(line: 115, column: 20, scope: !3157)
!3308 = !DILocation(line: 115, column: 12, scope: !3157)
!3309 = !DILocation(line: 115, column: 5, scope: !3157)
!3310 = !DILocation(line: 116, column: 1, scope: !3157)
!3311 = distinct !DISubprogram(name: "toRep", scope: !412, file: !412, line: 231, type: !179, scopeLine: 231, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !129, retainedNodes: !2)
!3312 = !DILocation(line: 232, column: 44, scope: !3311)
!3313 = !DILocation(line: 232, column: 50, scope: !3311)
!3314 = !DILocation(line: 233, column: 16, scope: !3311)
!3315 = !DILocation(line: 233, column: 5, scope: !3311)
!3316 = distinct !DISubprogram(name: "fromRep", scope: !412, file: !412, line: 236, type: !179, scopeLine: 236, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !129, retainedNodes: !2)
!3317 = !DILocation(line: 237, column: 44, scope: !3316)
!3318 = !DILocation(line: 237, column: 50, scope: !3316)
!3319 = !DILocation(line: 238, column: 16, scope: !3316)
!3320 = !DILocation(line: 238, column: 5, scope: !3316)
!3321 = distinct !DISubprogram(name: "normalize", scope: !412, file: !412, line: 241, type: !179, scopeLine: 241, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !129, retainedNodes: !2)
!3322 = !DILocation(line: 242, column: 32, scope: !3321)
!3323 = !DILocation(line: 242, column: 31, scope: !3321)
!3324 = !DILocation(line: 242, column: 23, scope: !3321)
!3325 = !DILocation(line: 242, column: 47, scope: !3321)
!3326 = !DILocation(line: 242, column: 45, scope: !3321)
!3327 = !DILocation(line: 242, column: 15, scope: !3321)
!3328 = !DILocation(line: 243, column: 22, scope: !3321)
!3329 = !DILocation(line: 243, column: 6, scope: !3321)
!3330 = !DILocation(line: 243, column: 18, scope: !3321)
!3331 = !DILocation(line: 244, column: 16, scope: !3321)
!3332 = !DILocation(line: 244, column: 14, scope: !3321)
!3333 = !DILocation(line: 244, column: 5, scope: !3321)
!3334 = distinct !DISubprogram(name: "wideMultiply", scope: !412, file: !412, line: 54, type: !179, scopeLine: 54, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !129, retainedNodes: !2)
!3335 = !DILocation(line: 55, column: 40, scope: !3334)
!3336 = !DILocation(line: 55, column: 30, scope: !3334)
!3337 = !DILocation(line: 55, column: 42, scope: !3334)
!3338 = !DILocation(line: 55, column: 41, scope: !3334)
!3339 = !DILocation(line: 55, column: 20, scope: !3334)
!3340 = !DILocation(line: 56, column: 11, scope: !3334)
!3341 = !DILocation(line: 56, column: 19, scope: !3334)
!3342 = !DILocation(line: 56, column: 6, scope: !3334)
!3343 = !DILocation(line: 56, column: 9, scope: !3334)
!3344 = !DILocation(line: 57, column: 11, scope: !3334)
!3345 = !DILocation(line: 57, column: 6, scope: !3334)
!3346 = !DILocation(line: 57, column: 9, scope: !3334)
!3347 = !DILocation(line: 58, column: 1, scope: !3334)
!3348 = distinct !DISubprogram(name: "wideLeftShift", scope: !412, file: !412, line: 247, type: !179, scopeLine: 247, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !129, retainedNodes: !2)
!3349 = !DILocation(line: 248, column: 12, scope: !3348)
!3350 = !DILocation(line: 248, column: 11, scope: !3348)
!3351 = !DILocation(line: 248, column: 18, scope: !3348)
!3352 = !DILocation(line: 248, column: 15, scope: !3348)
!3353 = !DILocation(line: 248, column: 27, scope: !3348)
!3354 = !DILocation(line: 248, column: 26, scope: !3348)
!3355 = !DILocation(line: 248, column: 46, scope: !3348)
!3356 = !DILocation(line: 248, column: 44, scope: !3348)
!3357 = !DILocation(line: 248, column: 30, scope: !3348)
!3358 = !DILocation(line: 248, column: 24, scope: !3348)
!3359 = !DILocation(line: 248, column: 6, scope: !3348)
!3360 = !DILocation(line: 248, column: 9, scope: !3348)
!3361 = !DILocation(line: 249, column: 12, scope: !3348)
!3362 = !DILocation(line: 249, column: 11, scope: !3348)
!3363 = !DILocation(line: 249, column: 18, scope: !3348)
!3364 = !DILocation(line: 249, column: 15, scope: !3348)
!3365 = !DILocation(line: 249, column: 6, scope: !3348)
!3366 = !DILocation(line: 249, column: 9, scope: !3348)
!3367 = !DILocation(line: 250, column: 1, scope: !3348)
!3368 = distinct !DISubprogram(name: "wideRightShiftWithSticky", scope: !412, file: !412, line: 252, type: !179, scopeLine: 252, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !129, retainedNodes: !2)
!3369 = !DILocation(line: 253, column: 9, scope: !3368)
!3370 = !DILocation(line: 253, column: 15, scope: !3368)
!3371 = !DILocation(line: 254, column: 30, scope: !3368)
!3372 = !DILocation(line: 254, column: 29, scope: !3368)
!3373 = !DILocation(line: 254, column: 49, scope: !3368)
!3374 = !DILocation(line: 254, column: 47, scope: !3368)
!3375 = !DILocation(line: 254, column: 33, scope: !3368)
!3376 = !DILocation(line: 254, column: 20, scope: !3368)
!3377 = !DILocation(line: 255, column: 16, scope: !3368)
!3378 = !DILocation(line: 255, column: 15, scope: !3368)
!3379 = !DILocation(line: 255, column: 35, scope: !3368)
!3380 = !DILocation(line: 255, column: 33, scope: !3368)
!3381 = !DILocation(line: 255, column: 19, scope: !3368)
!3382 = !DILocation(line: 255, column: 45, scope: !3368)
!3383 = !DILocation(line: 255, column: 44, scope: !3368)
!3384 = !DILocation(line: 255, column: 51, scope: !3368)
!3385 = !DILocation(line: 255, column: 48, scope: !3368)
!3386 = !DILocation(line: 255, column: 42, scope: !3368)
!3387 = !DILocation(line: 255, column: 59, scope: !3368)
!3388 = !DILocation(line: 255, column: 57, scope: !3368)
!3389 = !DILocation(line: 255, column: 10, scope: !3368)
!3390 = !DILocation(line: 255, column: 13, scope: !3368)
!3391 = !DILocation(line: 256, column: 16, scope: !3368)
!3392 = !DILocation(line: 256, column: 15, scope: !3368)
!3393 = !DILocation(line: 256, column: 22, scope: !3368)
!3394 = !DILocation(line: 256, column: 19, scope: !3368)
!3395 = !DILocation(line: 256, column: 10, scope: !3368)
!3396 = !DILocation(line: 256, column: 13, scope: !3368)
!3397 = !DILocation(line: 257, column: 5, scope: !3368)
!3398 = !DILocation(line: 258, column: 14, scope: !3368)
!3399 = !DILocation(line: 258, column: 20, scope: !3368)
!3400 = !DILocation(line: 259, column: 30, scope: !3368)
!3401 = !DILocation(line: 259, column: 29, scope: !3368)
!3402 = !DILocation(line: 259, column: 51, scope: !3368)
!3403 = !DILocation(line: 259, column: 49, scope: !3368)
!3404 = !DILocation(line: 259, column: 33, scope: !3368)
!3405 = !DILocation(line: 259, column: 61, scope: !3368)
!3406 = !DILocation(line: 259, column: 60, scope: !3368)
!3407 = !DILocation(line: 259, column: 58, scope: !3368)
!3408 = !DILocation(line: 259, column: 20, scope: !3368)
!3409 = !DILocation(line: 260, column: 16, scope: !3368)
!3410 = !DILocation(line: 260, column: 15, scope: !3368)
!3411 = !DILocation(line: 260, column: 23, scope: !3368)
!3412 = !DILocation(line: 260, column: 29, scope: !3368)
!3413 = !DILocation(line: 260, column: 19, scope: !3368)
!3414 = !DILocation(line: 260, column: 44, scope: !3368)
!3415 = !DILocation(line: 260, column: 42, scope: !3368)
!3416 = !DILocation(line: 260, column: 10, scope: !3368)
!3417 = !DILocation(line: 260, column: 13, scope: !3368)
!3418 = !DILocation(line: 261, column: 10, scope: !3368)
!3419 = !DILocation(line: 261, column: 13, scope: !3368)
!3420 = !DILocation(line: 262, column: 5, scope: !3368)
!3421 = !DILocation(line: 263, column: 30, scope: !3368)
!3422 = !DILocation(line: 263, column: 29, scope: !3368)
!3423 = !DILocation(line: 263, column: 36, scope: !3368)
!3424 = !DILocation(line: 263, column: 35, scope: !3368)
!3425 = !DILocation(line: 263, column: 33, scope: !3368)
!3426 = !DILocation(line: 263, column: 20, scope: !3368)
!3427 = !DILocation(line: 264, column: 15, scope: !3368)
!3428 = !DILocation(line: 264, column: 10, scope: !3368)
!3429 = !DILocation(line: 264, column: 13, scope: !3368)
!3430 = !DILocation(line: 265, column: 10, scope: !3368)
!3431 = !DILocation(line: 265, column: 13, scope: !3368)
!3432 = !DILocation(line: 267, column: 1, scope: !3368)
!3433 = distinct !DISubprogram(name: "rep_clz", scope: !412, file: !412, line: 49, type: !179, scopeLine: 49, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !129, retainedNodes: !2)
!3434 = !DILocation(line: 50, column: 26, scope: !3433)
!3435 = !DILocation(line: 50, column: 12, scope: !3433)
!3436 = !DILocation(line: 50, column: 5, scope: !3433)
!3437 = distinct !DISubprogram(name: "__negdf2", scope: !136, file: !136, line: 20, type: !179, scopeLine: 20, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !135, retainedNodes: !2)
!3438 = !DILocation(line: 21, column: 26, scope: !3437)
!3439 = !DILocation(line: 21, column: 20, scope: !3437)
!3440 = !DILocation(line: 21, column: 29, scope: !3437)
!3441 = !DILocation(line: 21, column: 12, scope: !3437)
!3442 = !DILocation(line: 21, column: 5, scope: !3437)
!3443 = distinct !DISubprogram(name: "toRep", scope: !412, file: !412, line: 231, type: !179, scopeLine: 231, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !135, retainedNodes: !2)
!3444 = !DILocation(line: 232, column: 44, scope: !3443)
!3445 = !DILocation(line: 232, column: 50, scope: !3443)
!3446 = !DILocation(line: 233, column: 16, scope: !3443)
!3447 = !DILocation(line: 233, column: 5, scope: !3443)
!3448 = distinct !DISubprogram(name: "fromRep", scope: !412, file: !412, line: 236, type: !179, scopeLine: 236, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !135, retainedNodes: !2)
!3449 = !DILocation(line: 237, column: 44, scope: !3448)
!3450 = !DILocation(line: 237, column: 50, scope: !3448)
!3451 = !DILocation(line: 238, column: 16, scope: !3448)
!3452 = !DILocation(line: 238, column: 5, scope: !3448)
!3453 = distinct !DISubprogram(name: "__negdi2", scope: !138, file: !138, line: 20, type: !179, scopeLine: 21, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !137, retainedNodes: !2)
!3454 = !DILocation(line: 25, column: 13, scope: !3453)
!3455 = !DILocation(line: 25, column: 12, scope: !3453)
!3456 = !DILocation(line: 25, column: 5, scope: !3453)
!3457 = distinct !DISubprogram(name: "__negsf2", scope: !140, file: !140, line: 20, type: !179, scopeLine: 20, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !139, retainedNodes: !2)
!3458 = !DILocation(line: 21, column: 26, scope: !3457)
!3459 = !DILocation(line: 21, column: 20, scope: !3457)
!3460 = !DILocation(line: 21, column: 29, scope: !3457)
!3461 = !DILocation(line: 21, column: 12, scope: !3457)
!3462 = !DILocation(line: 21, column: 5, scope: !3457)
!3463 = distinct !DISubprogram(name: "toRep", scope: !412, file: !412, line: 231, type: !179, scopeLine: 231, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !139, retainedNodes: !2)
!3464 = !DILocation(line: 232, column: 44, scope: !3463)
!3465 = !DILocation(line: 232, column: 50, scope: !3463)
!3466 = !DILocation(line: 233, column: 16, scope: !3463)
!3467 = !DILocation(line: 233, column: 5, scope: !3463)
!3468 = distinct !DISubprogram(name: "fromRep", scope: !412, file: !412, line: 236, type: !179, scopeLine: 236, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !139, retainedNodes: !2)
!3469 = !DILocation(line: 237, column: 44, scope: !3468)
!3470 = !DILocation(line: 237, column: 50, scope: !3468)
!3471 = !DILocation(line: 238, column: 16, scope: !3468)
!3472 = !DILocation(line: 238, column: 5, scope: !3468)
!3473 = distinct !DISubprogram(name: "__negvdi2", scope: !144, file: !144, line: 22, type: !179, scopeLine: 23, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !143, retainedNodes: !2)
!3474 = !DILocation(line: 24, column: 18, scope: !3473)
!3475 = !DILocation(line: 25, column: 9, scope: !3473)
!3476 = !DILocation(line: 25, column: 11, scope: !3473)
!3477 = !DILocation(line: 26, column: 9, scope: !3473)
!3478 = !DILocation(line: 27, column: 13, scope: !3473)
!3479 = !DILocation(line: 27, column: 12, scope: !3473)
!3480 = !DILocation(line: 27, column: 5, scope: !3473)
!3481 = distinct !DISubprogram(name: "__negvsi2", scope: !146, file: !146, line: 22, type: !179, scopeLine: 23, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !145, retainedNodes: !2)
!3482 = !DILocation(line: 24, column: 18, scope: !3481)
!3483 = !DILocation(line: 25, column: 9, scope: !3481)
!3484 = !DILocation(line: 25, column: 11, scope: !3481)
!3485 = !DILocation(line: 26, column: 9, scope: !3481)
!3486 = !DILocation(line: 27, column: 13, scope: !3481)
!3487 = !DILocation(line: 27, column: 12, scope: !3481)
!3488 = !DILocation(line: 27, column: 5, scope: !3481)
!3489 = distinct !DISubprogram(name: "__powidf2", scope: !150, file: !150, line: 20, type: !179, scopeLine: 21, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !149, retainedNodes: !2)
!3490 = !DILocation(line: 22, column: 23, scope: !3489)
!3491 = !DILocation(line: 22, column: 25, scope: !3489)
!3492 = !DILocation(line: 22, column: 15, scope: !3489)
!3493 = !DILocation(line: 23, column: 12, scope: !3489)
!3494 = !DILocation(line: 24, column: 5, scope: !3489)
!3495 = !DILocation(line: 26, column: 13, scope: !3489)
!3496 = !DILocation(line: 26, column: 15, scope: !3489)
!3497 = !DILocation(line: 27, column: 18, scope: !3489)
!3498 = !DILocation(line: 27, column: 15, scope: !3489)
!3499 = !DILocation(line: 27, column: 13, scope: !3489)
!3500 = !DILocation(line: 28, column: 11, scope: !3489)
!3501 = !DILocation(line: 29, column: 13, scope: !3489)
!3502 = !DILocation(line: 29, column: 15, scope: !3489)
!3503 = !DILocation(line: 30, column: 13, scope: !3489)
!3504 = !DILocation(line: 31, column: 14, scope: !3489)
!3505 = !DILocation(line: 31, column: 11, scope: !3489)
!3506 = distinct !{!3506, !3494, !3507}
!3507 = !DILocation(line: 32, column: 5, scope: !3489)
!3508 = !DILocation(line: 33, column: 12, scope: !3489)
!3509 = !DILocation(line: 33, column: 22, scope: !3489)
!3510 = !DILocation(line: 33, column: 21, scope: !3489)
!3511 = !DILocation(line: 33, column: 26, scope: !3489)
!3512 = !DILocation(line: 33, column: 5, scope: !3489)
!3513 = distinct !DISubprogram(name: "__powisf2", scope: !152, file: !152, line: 20, type: !179, scopeLine: 21, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !151, retainedNodes: !2)
!3514 = !DILocation(line: 22, column: 23, scope: !3513)
!3515 = !DILocation(line: 22, column: 25, scope: !3513)
!3516 = !DILocation(line: 22, column: 15, scope: !3513)
!3517 = !DILocation(line: 23, column: 11, scope: !3513)
!3518 = !DILocation(line: 24, column: 5, scope: !3513)
!3519 = !DILocation(line: 26, column: 13, scope: !3513)
!3520 = !DILocation(line: 26, column: 15, scope: !3513)
!3521 = !DILocation(line: 27, column: 18, scope: !3513)
!3522 = !DILocation(line: 27, column: 15, scope: !3513)
!3523 = !DILocation(line: 27, column: 13, scope: !3513)
!3524 = !DILocation(line: 28, column: 11, scope: !3513)
!3525 = !DILocation(line: 29, column: 13, scope: !3513)
!3526 = !DILocation(line: 29, column: 15, scope: !3513)
!3527 = !DILocation(line: 30, column: 13, scope: !3513)
!3528 = !DILocation(line: 31, column: 14, scope: !3513)
!3529 = !DILocation(line: 31, column: 11, scope: !3513)
!3530 = distinct !{!3530, !3518, !3531}
!3531 = !DILocation(line: 32, column: 5, scope: !3513)
!3532 = !DILocation(line: 33, column: 12, scope: !3513)
!3533 = !DILocation(line: 33, column: 22, scope: !3513)
!3534 = !DILocation(line: 33, column: 21, scope: !3513)
!3535 = !DILocation(line: 33, column: 26, scope: !3513)
!3536 = !DILocation(line: 33, column: 5, scope: !3513)
!3537 = distinct !DISubprogram(name: "__powixf2", scope: !156, file: !156, line: 22, type: !179, scopeLine: 23, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !155, retainedNodes: !2)
!3538 = !DILocation(line: 24, column: 23, scope: !3537)
!3539 = !DILocation(line: 24, column: 25, scope: !3537)
!3540 = !DILocation(line: 24, column: 15, scope: !3537)
!3541 = !DILocation(line: 25, column: 17, scope: !3537)
!3542 = !DILocation(line: 26, column: 5, scope: !3537)
!3543 = !DILocation(line: 28, column: 13, scope: !3537)
!3544 = !DILocation(line: 28, column: 15, scope: !3537)
!3545 = !DILocation(line: 29, column: 18, scope: !3537)
!3546 = !DILocation(line: 29, column: 15, scope: !3537)
!3547 = !DILocation(line: 29, column: 13, scope: !3537)
!3548 = !DILocation(line: 30, column: 11, scope: !3537)
!3549 = !DILocation(line: 31, column: 13, scope: !3537)
!3550 = !DILocation(line: 31, column: 15, scope: !3537)
!3551 = !DILocation(line: 32, column: 13, scope: !3537)
!3552 = !DILocation(line: 33, column: 14, scope: !3537)
!3553 = !DILocation(line: 33, column: 11, scope: !3537)
!3554 = distinct !{!3554, !3542, !3555}
!3555 = !DILocation(line: 34, column: 5, scope: !3537)
!3556 = !DILocation(line: 35, column: 12, scope: !3537)
!3557 = !DILocation(line: 35, column: 22, scope: !3537)
!3558 = !DILocation(line: 35, column: 21, scope: !3537)
!3559 = !DILocation(line: 35, column: 26, scope: !3537)
!3560 = !DILocation(line: 35, column: 5, scope: !3537)
!3561 = distinct !DISubprogram(name: "__subdf3", scope: !158, file: !158, line: 22, type: !179, scopeLine: 22, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !157, retainedNodes: !2)
!3562 = !DILocation(line: 23, column: 21, scope: !3561)
!3563 = !DILocation(line: 23, column: 38, scope: !3561)
!3564 = !DILocation(line: 23, column: 32, scope: !3561)
!3565 = !DILocation(line: 23, column: 41, scope: !3561)
!3566 = !DILocation(line: 23, column: 24, scope: !3561)
!3567 = !DILocation(line: 23, column: 12, scope: !3561)
!3568 = !DILocation(line: 23, column: 5, scope: !3561)
!3569 = distinct !DISubprogram(name: "toRep", scope: !412, file: !412, line: 231, type: !179, scopeLine: 231, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !157, retainedNodes: !2)
!3570 = !DILocation(line: 232, column: 44, scope: !3569)
!3571 = !DILocation(line: 232, column: 50, scope: !3569)
!3572 = !DILocation(line: 233, column: 16, scope: !3569)
!3573 = !DILocation(line: 233, column: 5, scope: !3569)
!3574 = distinct !DISubprogram(name: "fromRep", scope: !412, file: !412, line: 236, type: !179, scopeLine: 236, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !157, retainedNodes: !2)
!3575 = !DILocation(line: 237, column: 44, scope: !3574)
!3576 = !DILocation(line: 237, column: 50, scope: !3574)
!3577 = !DILocation(line: 238, column: 16, scope: !3574)
!3578 = !DILocation(line: 238, column: 5, scope: !3574)
!3579 = distinct !DISubprogram(name: "__subsf3", scope: !160, file: !160, line: 22, type: !179, scopeLine: 22, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !159, retainedNodes: !2)
!3580 = !DILocation(line: 23, column: 21, scope: !3579)
!3581 = !DILocation(line: 23, column: 38, scope: !3579)
!3582 = !DILocation(line: 23, column: 32, scope: !3579)
!3583 = !DILocation(line: 23, column: 41, scope: !3579)
!3584 = !DILocation(line: 23, column: 24, scope: !3579)
!3585 = !DILocation(line: 23, column: 12, scope: !3579)
!3586 = !DILocation(line: 23, column: 5, scope: !3579)
!3587 = distinct !DISubprogram(name: "toRep", scope: !412, file: !412, line: 231, type: !179, scopeLine: 231, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !159, retainedNodes: !2)
!3588 = !DILocation(line: 232, column: 44, scope: !3587)
!3589 = !DILocation(line: 232, column: 50, scope: !3587)
!3590 = !DILocation(line: 233, column: 16, scope: !3587)
!3591 = !DILocation(line: 233, column: 5, scope: !3587)
!3592 = distinct !DISubprogram(name: "fromRep", scope: !412, file: !412, line: 236, type: !179, scopeLine: 236, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !159, retainedNodes: !2)
!3593 = !DILocation(line: 237, column: 44, scope: !3592)
!3594 = !DILocation(line: 237, column: 50, scope: !3592)
!3595 = !DILocation(line: 238, column: 16, scope: !3592)
!3596 = !DILocation(line: 238, column: 5, scope: !3592)
!3597 = distinct !DISubprogram(name: "__truncdfhf2", scope: !164, file: !164, line: 16, type: !179, scopeLine: 16, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !163, retainedNodes: !2)
!3598 = !DILocation(line: 17, column: 27, scope: !3597)
!3599 = !DILocation(line: 17, column: 12, scope: !3597)
!3600 = !DILocation(line: 17, column: 5, scope: !3597)
!3601 = distinct !DISubprogram(name: "__truncXfYf2__", scope: !3602, file: !3602, line: 42, type: !179, scopeLine: 42, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !163, retainedNodes: !2)
!3602 = !DIFile(filename: "./fp_trunc_impl.inc", directory: "/llvmta_testcases/libraries/builtinsfloat")
!3603 = !DILocation(line: 45, column: 15, scope: !3601)
!3604 = !DILocation(line: 46, column: 15, scope: !3601)
!3605 = !DILocation(line: 47, column: 15, scope: !3601)
!3606 = !DILocation(line: 48, column: 15, scope: !3601)
!3607 = !DILocation(line: 50, column: 21, scope: !3601)
!3608 = !DILocation(line: 51, column: 21, scope: !3601)
!3609 = !DILocation(line: 52, column: 21, scope: !3601)
!3610 = !DILocation(line: 53, column: 21, scope: !3601)
!3611 = !DILocation(line: 54, column: 21, scope: !3601)
!3612 = !DILocation(line: 55, column: 21, scope: !3601)
!3613 = !DILocation(line: 56, column: 21, scope: !3601)
!3614 = !DILocation(line: 57, column: 21, scope: !3601)
!3615 = !DILocation(line: 58, column: 21, scope: !3601)
!3616 = !DILocation(line: 60, column: 15, scope: !3601)
!3617 = !DILocation(line: 61, column: 15, scope: !3601)
!3618 = !DILocation(line: 62, column: 15, scope: !3601)
!3619 = !DILocation(line: 63, column: 15, scope: !3601)
!3620 = !DILocation(line: 65, column: 15, scope: !3601)
!3621 = !DILocation(line: 66, column: 15, scope: !3601)
!3622 = !DILocation(line: 67, column: 21, scope: !3601)
!3623 = !DILocation(line: 68, column: 21, scope: !3601)
!3624 = !DILocation(line: 70, column: 21, scope: !3601)
!3625 = !DILocation(line: 71, column: 21, scope: !3601)
!3626 = !DILocation(line: 74, column: 37, scope: !3601)
!3627 = !DILocation(line: 74, column: 28, scope: !3601)
!3628 = !DILocation(line: 74, column: 21, scope: !3601)
!3629 = !DILocation(line: 75, column: 28, scope: !3601)
!3630 = !DILocation(line: 75, column: 33, scope: !3601)
!3631 = !DILocation(line: 75, column: 21, scope: !3601)
!3632 = !DILocation(line: 76, column: 28, scope: !3601)
!3633 = !DILocation(line: 76, column: 33, scope: !3601)
!3634 = !DILocation(line: 76, column: 21, scope: !3601)
!3635 = !DILocation(line: 79, column: 9, scope: !3601)
!3636 = !DILocation(line: 79, column: 14, scope: !3601)
!3637 = !DILocation(line: 79, column: 28, scope: !3601)
!3638 = !DILocation(line: 79, column: 33, scope: !3601)
!3639 = !DILocation(line: 79, column: 26, scope: !3601)
!3640 = !DILocation(line: 83, column: 21, scope: !3601)
!3641 = !DILocation(line: 83, column: 26, scope: !3601)
!3642 = !DILocation(line: 83, column: 19, scope: !3601)
!3643 = !DILocation(line: 84, column: 19, scope: !3601)
!3644 = !DILocation(line: 86, column: 37, scope: !3601)
!3645 = !DILocation(line: 86, column: 42, scope: !3601)
!3646 = !DILocation(line: 86, column: 25, scope: !3601)
!3647 = !DILocation(line: 88, column: 13, scope: !3601)
!3648 = !DILocation(line: 88, column: 23, scope: !3601)
!3649 = !DILocation(line: 89, column: 22, scope: !3601)
!3650 = !DILocation(line: 89, column: 13, scope: !3601)
!3651 = !DILocation(line: 91, column: 18, scope: !3601)
!3652 = !DILocation(line: 91, column: 28, scope: !3601)
!3653 = !DILocation(line: 92, column: 26, scope: !3601)
!3654 = !DILocation(line: 92, column: 36, scope: !3601)
!3655 = !DILocation(line: 92, column: 23, scope: !3601)
!3656 = !DILocation(line: 92, column: 13, scope: !3601)
!3657 = !DILocation(line: 93, column: 5, scope: !3601)
!3658 = !DILocation(line: 94, column: 14, scope: !3601)
!3659 = !DILocation(line: 94, column: 19, scope: !3601)
!3660 = !DILocation(line: 98, column: 19, scope: !3601)
!3661 = !DILocation(line: 99, column: 19, scope: !3601)
!3662 = !DILocation(line: 100, column: 24, scope: !3601)
!3663 = !DILocation(line: 100, column: 29, scope: !3601)
!3664 = !DILocation(line: 100, column: 43, scope: !3601)
!3665 = !DILocation(line: 100, column: 73, scope: !3601)
!3666 = !DILocation(line: 100, column: 19, scope: !3601)
!3667 = !DILocation(line: 101, column: 5, scope: !3601)
!3668 = !DILocation(line: 102, column: 14, scope: !3601)
!3669 = !DILocation(line: 102, column: 19, scope: !3601)
!3670 = !DILocation(line: 104, column: 19, scope: !3601)
!3671 = !DILocation(line: 105, column: 5, scope: !3601)
!3672 = !DILocation(line: 110, column: 26, scope: !3601)
!3673 = !DILocation(line: 110, column: 31, scope: !3601)
!3674 = !DILocation(line: 110, column: 19, scope: !3601)
!3675 = !DILocation(line: 111, column: 53, scope: !3601)
!3676 = !DILocation(line: 111, column: 51, scope: !3601)
!3677 = !DILocation(line: 111, column: 58, scope: !3601)
!3678 = !DILocation(line: 111, column: 19, scope: !3601)
!3679 = !DILocation(line: 113, column: 40, scope: !3601)
!3680 = !DILocation(line: 113, column: 45, scope: !3601)
!3681 = !DILocation(line: 113, column: 67, scope: !3601)
!3682 = !DILocation(line: 113, column: 25, scope: !3601)
!3683 = !DILocation(line: 116, column: 13, scope: !3601)
!3684 = !DILocation(line: 116, column: 19, scope: !3601)
!3685 = !DILocation(line: 117, column: 23, scope: !3601)
!3686 = !DILocation(line: 118, column: 9, scope: !3601)
!3687 = !DILocation(line: 119, column: 33, scope: !3601)
!3688 = !DILocation(line: 119, column: 59, scope: !3601)
!3689 = !DILocation(line: 119, column: 57, scope: !3601)
!3690 = !DILocation(line: 119, column: 45, scope: !3601)
!3691 = !DILocation(line: 119, column: 24, scope: !3601)
!3692 = !DILocation(line: 120, column: 49, scope: !3601)
!3693 = !DILocation(line: 120, column: 64, scope: !3601)
!3694 = !DILocation(line: 120, column: 61, scope: !3601)
!3695 = !DILocation(line: 120, column: 72, scope: !3601)
!3696 = !DILocation(line: 120, column: 70, scope: !3601)
!3697 = !DILocation(line: 120, column: 23, scope: !3601)
!3698 = !DILocation(line: 121, column: 25, scope: !3601)
!3699 = !DILocation(line: 121, column: 49, scope: !3601)
!3700 = !DILocation(line: 121, column: 23, scope: !3601)
!3701 = !DILocation(line: 122, column: 41, scope: !3601)
!3702 = !DILocation(line: 122, column: 65, scope: !3601)
!3703 = !DILocation(line: 122, column: 29, scope: !3601)
!3704 = !DILocation(line: 124, column: 17, scope: !3601)
!3705 = !DILocation(line: 124, column: 27, scope: !3601)
!3706 = !DILocation(line: 125, column: 26, scope: !3601)
!3707 = !DILocation(line: 125, column: 17, scope: !3601)
!3708 = !DILocation(line: 127, column: 22, scope: !3601)
!3709 = !DILocation(line: 127, column: 32, scope: !3601)
!3710 = !DILocation(line: 128, column: 30, scope: !3601)
!3711 = !DILocation(line: 128, column: 40, scope: !3601)
!3712 = !DILocation(line: 128, column: 27, scope: !3601)
!3713 = !DILocation(line: 128, column: 17, scope: !3601)
!3714 = !DILocation(line: 133, column: 30, scope: !3601)
!3715 = !DILocation(line: 133, column: 42, scope: !3601)
!3716 = !DILocation(line: 133, column: 47, scope: !3601)
!3717 = !DILocation(line: 133, column: 40, scope: !3601)
!3718 = !DILocation(line: 133, column: 21, scope: !3601)
!3719 = !DILocation(line: 134, column: 23, scope: !3601)
!3720 = !DILocation(line: 134, column: 12, scope: !3601)
!3721 = !DILocation(line: 134, column: 5, scope: !3601)
!3722 = distinct !DISubprogram(name: "srcToRep", scope: !3723, file: !3723, line: 66, type: !179, scopeLine: 66, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !163, retainedNodes: !2)
!3723 = !DIFile(filename: "./fp_trunc.h", directory: "/llvmta_testcases/libraries/builtinsfloat")
!3724 = !DILocation(line: 67, column: 49, scope: !3722)
!3725 = !DILocation(line: 67, column: 55, scope: !3722)
!3726 = !DILocation(line: 68, column: 16, scope: !3722)
!3727 = !DILocation(line: 68, column: 5, scope: !3722)
!3728 = distinct !DISubprogram(name: "dstFromRep", scope: !3723, file: !3723, line: 71, type: !179, scopeLine: 71, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !163, retainedNodes: !2)
!3729 = !DILocation(line: 72, column: 49, scope: !3728)
!3730 = !DILocation(line: 72, column: 55, scope: !3728)
!3731 = !DILocation(line: 73, column: 16, scope: !3728)
!3732 = !DILocation(line: 73, column: 5, scope: !3728)
!3733 = distinct !DISubprogram(name: "__truncdfsf2", scope: !166, file: !166, line: 16, type: !179, scopeLine: 16, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !165, retainedNodes: !2)
!3734 = !DILocation(line: 17, column: 27, scope: !3733)
!3735 = !DILocation(line: 17, column: 12, scope: !3733)
!3736 = !DILocation(line: 17, column: 5, scope: !3733)
!3737 = distinct !DISubprogram(name: "__truncXfYf2__", scope: !3602, file: !3602, line: 42, type: !179, scopeLine: 42, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !165, retainedNodes: !2)
!3738 = !DILocation(line: 45, column: 15, scope: !3737)
!3739 = !DILocation(line: 46, column: 15, scope: !3737)
!3740 = !DILocation(line: 47, column: 15, scope: !3737)
!3741 = !DILocation(line: 48, column: 15, scope: !3737)
!3742 = !DILocation(line: 50, column: 21, scope: !3737)
!3743 = !DILocation(line: 51, column: 21, scope: !3737)
!3744 = !DILocation(line: 52, column: 21, scope: !3737)
!3745 = !DILocation(line: 53, column: 21, scope: !3737)
!3746 = !DILocation(line: 54, column: 21, scope: !3737)
!3747 = !DILocation(line: 55, column: 21, scope: !3737)
!3748 = !DILocation(line: 56, column: 21, scope: !3737)
!3749 = !DILocation(line: 57, column: 21, scope: !3737)
!3750 = !DILocation(line: 58, column: 21, scope: !3737)
!3751 = !DILocation(line: 60, column: 15, scope: !3737)
!3752 = !DILocation(line: 61, column: 15, scope: !3737)
!3753 = !DILocation(line: 62, column: 15, scope: !3737)
!3754 = !DILocation(line: 63, column: 15, scope: !3737)
!3755 = !DILocation(line: 65, column: 15, scope: !3737)
!3756 = !DILocation(line: 66, column: 15, scope: !3737)
!3757 = !DILocation(line: 67, column: 21, scope: !3737)
!3758 = !DILocation(line: 68, column: 21, scope: !3737)
!3759 = !DILocation(line: 70, column: 21, scope: !3737)
!3760 = !DILocation(line: 71, column: 21, scope: !3737)
!3761 = !DILocation(line: 74, column: 37, scope: !3737)
!3762 = !DILocation(line: 74, column: 28, scope: !3737)
!3763 = !DILocation(line: 74, column: 21, scope: !3737)
!3764 = !DILocation(line: 75, column: 28, scope: !3737)
!3765 = !DILocation(line: 75, column: 33, scope: !3737)
!3766 = !DILocation(line: 75, column: 21, scope: !3737)
!3767 = !DILocation(line: 76, column: 28, scope: !3737)
!3768 = !DILocation(line: 76, column: 33, scope: !3737)
!3769 = !DILocation(line: 76, column: 21, scope: !3737)
!3770 = !DILocation(line: 79, column: 9, scope: !3737)
!3771 = !DILocation(line: 79, column: 14, scope: !3737)
!3772 = !DILocation(line: 79, column: 28, scope: !3737)
!3773 = !DILocation(line: 79, column: 33, scope: !3737)
!3774 = !DILocation(line: 79, column: 26, scope: !3737)
!3775 = !DILocation(line: 83, column: 21, scope: !3737)
!3776 = !DILocation(line: 83, column: 26, scope: !3737)
!3777 = !DILocation(line: 83, column: 19, scope: !3737)
!3778 = !DILocation(line: 84, column: 19, scope: !3737)
!3779 = !DILocation(line: 86, column: 37, scope: !3737)
!3780 = !DILocation(line: 86, column: 42, scope: !3737)
!3781 = !DILocation(line: 86, column: 25, scope: !3737)
!3782 = !DILocation(line: 88, column: 13, scope: !3737)
!3783 = !DILocation(line: 88, column: 23, scope: !3737)
!3784 = !DILocation(line: 89, column: 22, scope: !3737)
!3785 = !DILocation(line: 89, column: 13, scope: !3737)
!3786 = !DILocation(line: 91, column: 18, scope: !3737)
!3787 = !DILocation(line: 91, column: 28, scope: !3737)
!3788 = !DILocation(line: 92, column: 26, scope: !3737)
!3789 = !DILocation(line: 92, column: 36, scope: !3737)
!3790 = !DILocation(line: 92, column: 23, scope: !3737)
!3791 = !DILocation(line: 92, column: 13, scope: !3737)
!3792 = !DILocation(line: 93, column: 5, scope: !3737)
!3793 = !DILocation(line: 94, column: 14, scope: !3737)
!3794 = !DILocation(line: 94, column: 19, scope: !3737)
!3795 = !DILocation(line: 98, column: 19, scope: !3737)
!3796 = !DILocation(line: 99, column: 19, scope: !3737)
!3797 = !DILocation(line: 100, column: 24, scope: !3737)
!3798 = !DILocation(line: 100, column: 29, scope: !3737)
!3799 = !DILocation(line: 100, column: 43, scope: !3737)
!3800 = !DILocation(line: 100, column: 73, scope: !3737)
!3801 = !DILocation(line: 100, column: 19, scope: !3737)
!3802 = !DILocation(line: 101, column: 5, scope: !3737)
!3803 = !DILocation(line: 102, column: 14, scope: !3737)
!3804 = !DILocation(line: 102, column: 19, scope: !3737)
!3805 = !DILocation(line: 104, column: 19, scope: !3737)
!3806 = !DILocation(line: 105, column: 5, scope: !3737)
!3807 = !DILocation(line: 110, column: 26, scope: !3737)
!3808 = !DILocation(line: 110, column: 31, scope: !3737)
!3809 = !DILocation(line: 110, column: 19, scope: !3737)
!3810 = !DILocation(line: 111, column: 53, scope: !3737)
!3811 = !DILocation(line: 111, column: 51, scope: !3737)
!3812 = !DILocation(line: 111, column: 58, scope: !3737)
!3813 = !DILocation(line: 111, column: 19, scope: !3737)
!3814 = !DILocation(line: 113, column: 40, scope: !3737)
!3815 = !DILocation(line: 113, column: 45, scope: !3737)
!3816 = !DILocation(line: 113, column: 67, scope: !3737)
!3817 = !DILocation(line: 113, column: 25, scope: !3737)
!3818 = !DILocation(line: 116, column: 13, scope: !3737)
!3819 = !DILocation(line: 116, column: 19, scope: !3737)
!3820 = !DILocation(line: 117, column: 23, scope: !3737)
!3821 = !DILocation(line: 118, column: 9, scope: !3737)
!3822 = !DILocation(line: 119, column: 33, scope: !3737)
!3823 = !DILocation(line: 119, column: 59, scope: !3737)
!3824 = !DILocation(line: 119, column: 57, scope: !3737)
!3825 = !DILocation(line: 119, column: 45, scope: !3737)
!3826 = !DILocation(line: 119, column: 24, scope: !3737)
!3827 = !DILocation(line: 120, column: 49, scope: !3737)
!3828 = !DILocation(line: 120, column: 64, scope: !3737)
!3829 = !DILocation(line: 120, column: 61, scope: !3737)
!3830 = !DILocation(line: 120, column: 72, scope: !3737)
!3831 = !DILocation(line: 120, column: 70, scope: !3737)
!3832 = !DILocation(line: 120, column: 23, scope: !3737)
!3833 = !DILocation(line: 121, column: 25, scope: !3737)
!3834 = !DILocation(line: 121, column: 49, scope: !3737)
!3835 = !DILocation(line: 121, column: 23, scope: !3737)
!3836 = !DILocation(line: 122, column: 41, scope: !3737)
!3837 = !DILocation(line: 122, column: 65, scope: !3737)
!3838 = !DILocation(line: 122, column: 29, scope: !3737)
!3839 = !DILocation(line: 124, column: 17, scope: !3737)
!3840 = !DILocation(line: 124, column: 27, scope: !3737)
!3841 = !DILocation(line: 125, column: 26, scope: !3737)
!3842 = !DILocation(line: 125, column: 17, scope: !3737)
!3843 = !DILocation(line: 127, column: 22, scope: !3737)
!3844 = !DILocation(line: 127, column: 32, scope: !3737)
!3845 = !DILocation(line: 128, column: 30, scope: !3737)
!3846 = !DILocation(line: 128, column: 40, scope: !3737)
!3847 = !DILocation(line: 128, column: 27, scope: !3737)
!3848 = !DILocation(line: 128, column: 17, scope: !3737)
!3849 = !DILocation(line: 133, column: 30, scope: !3737)
!3850 = !DILocation(line: 133, column: 42, scope: !3737)
!3851 = !DILocation(line: 133, column: 47, scope: !3737)
!3852 = !DILocation(line: 133, column: 40, scope: !3737)
!3853 = !DILocation(line: 133, column: 21, scope: !3737)
!3854 = !DILocation(line: 134, column: 23, scope: !3737)
!3855 = !DILocation(line: 134, column: 12, scope: !3737)
!3856 = !DILocation(line: 134, column: 5, scope: !3737)
!3857 = distinct !DISubprogram(name: "srcToRep", scope: !3723, file: !3723, line: 66, type: !179, scopeLine: 66, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !165, retainedNodes: !2)
!3858 = !DILocation(line: 67, column: 49, scope: !3857)
!3859 = !DILocation(line: 67, column: 55, scope: !3857)
!3860 = !DILocation(line: 68, column: 16, scope: !3857)
!3861 = !DILocation(line: 68, column: 5, scope: !3857)
!3862 = distinct !DISubprogram(name: "dstFromRep", scope: !3723, file: !3723, line: 71, type: !179, scopeLine: 71, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !165, retainedNodes: !2)
!3863 = !DILocation(line: 72, column: 49, scope: !3862)
!3864 = !DILocation(line: 72, column: 55, scope: !3862)
!3865 = !DILocation(line: 73, column: 16, scope: !3862)
!3866 = !DILocation(line: 73, column: 5, scope: !3862)
!3867 = distinct !DISubprogram(name: "__truncsfhf2", scope: !168, file: !168, line: 18, type: !179, scopeLine: 18, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !167, retainedNodes: !2)
!3868 = !DILocation(line: 19, column: 27, scope: !3867)
!3869 = !DILocation(line: 19, column: 12, scope: !3867)
!3870 = !DILocation(line: 19, column: 5, scope: !3867)
!3871 = distinct !DISubprogram(name: "__truncXfYf2__", scope: !3602, file: !3602, line: 42, type: !179, scopeLine: 42, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !167, retainedNodes: !2)
!3872 = !DILocation(line: 45, column: 15, scope: !3871)
!3873 = !DILocation(line: 46, column: 15, scope: !3871)
!3874 = !DILocation(line: 47, column: 15, scope: !3871)
!3875 = !DILocation(line: 48, column: 15, scope: !3871)
!3876 = !DILocation(line: 50, column: 21, scope: !3871)
!3877 = !DILocation(line: 51, column: 21, scope: !3871)
!3878 = !DILocation(line: 52, column: 21, scope: !3871)
!3879 = !DILocation(line: 53, column: 21, scope: !3871)
!3880 = !DILocation(line: 54, column: 21, scope: !3871)
!3881 = !DILocation(line: 55, column: 21, scope: !3871)
!3882 = !DILocation(line: 56, column: 21, scope: !3871)
!3883 = !DILocation(line: 57, column: 21, scope: !3871)
!3884 = !DILocation(line: 58, column: 21, scope: !3871)
!3885 = !DILocation(line: 60, column: 15, scope: !3871)
!3886 = !DILocation(line: 61, column: 15, scope: !3871)
!3887 = !DILocation(line: 62, column: 15, scope: !3871)
!3888 = !DILocation(line: 63, column: 15, scope: !3871)
!3889 = !DILocation(line: 65, column: 15, scope: !3871)
!3890 = !DILocation(line: 66, column: 15, scope: !3871)
!3891 = !DILocation(line: 67, column: 21, scope: !3871)
!3892 = !DILocation(line: 68, column: 21, scope: !3871)
!3893 = !DILocation(line: 70, column: 21, scope: !3871)
!3894 = !DILocation(line: 71, column: 21, scope: !3871)
!3895 = !DILocation(line: 74, column: 37, scope: !3871)
!3896 = !DILocation(line: 74, column: 28, scope: !3871)
!3897 = !DILocation(line: 74, column: 21, scope: !3871)
!3898 = !DILocation(line: 75, column: 28, scope: !3871)
!3899 = !DILocation(line: 75, column: 33, scope: !3871)
!3900 = !DILocation(line: 75, column: 21, scope: !3871)
!3901 = !DILocation(line: 76, column: 28, scope: !3871)
!3902 = !DILocation(line: 76, column: 33, scope: !3871)
!3903 = !DILocation(line: 76, column: 21, scope: !3871)
!3904 = !DILocation(line: 79, column: 9, scope: !3871)
!3905 = !DILocation(line: 79, column: 14, scope: !3871)
!3906 = !DILocation(line: 79, column: 28, scope: !3871)
!3907 = !DILocation(line: 79, column: 33, scope: !3871)
!3908 = !DILocation(line: 79, column: 26, scope: !3871)
!3909 = !DILocation(line: 83, column: 21, scope: !3871)
!3910 = !DILocation(line: 83, column: 26, scope: !3871)
!3911 = !DILocation(line: 83, column: 19, scope: !3871)
!3912 = !DILocation(line: 84, column: 19, scope: !3871)
!3913 = !DILocation(line: 86, column: 37, scope: !3871)
!3914 = !DILocation(line: 86, column: 42, scope: !3871)
!3915 = !DILocation(line: 86, column: 25, scope: !3871)
!3916 = !DILocation(line: 88, column: 13, scope: !3871)
!3917 = !DILocation(line: 88, column: 23, scope: !3871)
!3918 = !DILocation(line: 89, column: 22, scope: !3871)
!3919 = !DILocation(line: 89, column: 13, scope: !3871)
!3920 = !DILocation(line: 91, column: 18, scope: !3871)
!3921 = !DILocation(line: 91, column: 28, scope: !3871)
!3922 = !DILocation(line: 92, column: 26, scope: !3871)
!3923 = !DILocation(line: 92, column: 36, scope: !3871)
!3924 = !DILocation(line: 92, column: 23, scope: !3871)
!3925 = !DILocation(line: 92, column: 13, scope: !3871)
!3926 = !DILocation(line: 93, column: 5, scope: !3871)
!3927 = !DILocation(line: 94, column: 14, scope: !3871)
!3928 = !DILocation(line: 94, column: 19, scope: !3871)
!3929 = !DILocation(line: 98, column: 19, scope: !3871)
!3930 = !DILocation(line: 99, column: 19, scope: !3871)
!3931 = !DILocation(line: 100, column: 24, scope: !3871)
!3932 = !DILocation(line: 100, column: 29, scope: !3871)
!3933 = !DILocation(line: 100, column: 43, scope: !3871)
!3934 = !DILocation(line: 100, column: 73, scope: !3871)
!3935 = !DILocation(line: 100, column: 19, scope: !3871)
!3936 = !DILocation(line: 101, column: 5, scope: !3871)
!3937 = !DILocation(line: 102, column: 14, scope: !3871)
!3938 = !DILocation(line: 102, column: 19, scope: !3871)
!3939 = !DILocation(line: 104, column: 19, scope: !3871)
!3940 = !DILocation(line: 105, column: 5, scope: !3871)
!3941 = !DILocation(line: 110, column: 26, scope: !3871)
!3942 = !DILocation(line: 110, column: 31, scope: !3871)
!3943 = !DILocation(line: 110, column: 19, scope: !3871)
!3944 = !DILocation(line: 111, column: 53, scope: !3871)
!3945 = !DILocation(line: 111, column: 51, scope: !3871)
!3946 = !DILocation(line: 111, column: 58, scope: !3871)
!3947 = !DILocation(line: 111, column: 19, scope: !3871)
!3948 = !DILocation(line: 113, column: 40, scope: !3871)
!3949 = !DILocation(line: 113, column: 45, scope: !3871)
!3950 = !DILocation(line: 113, column: 67, scope: !3871)
!3951 = !DILocation(line: 113, column: 25, scope: !3871)
!3952 = !DILocation(line: 116, column: 13, scope: !3871)
!3953 = !DILocation(line: 116, column: 19, scope: !3871)
!3954 = !DILocation(line: 117, column: 23, scope: !3871)
!3955 = !DILocation(line: 118, column: 9, scope: !3871)
!3956 = !DILocation(line: 119, column: 33, scope: !3871)
!3957 = !DILocation(line: 119, column: 59, scope: !3871)
!3958 = !DILocation(line: 119, column: 57, scope: !3871)
!3959 = !DILocation(line: 119, column: 45, scope: !3871)
!3960 = !DILocation(line: 119, column: 24, scope: !3871)
!3961 = !DILocation(line: 120, column: 49, scope: !3871)
!3962 = !DILocation(line: 120, column: 64, scope: !3871)
!3963 = !DILocation(line: 120, column: 61, scope: !3871)
!3964 = !DILocation(line: 120, column: 72, scope: !3871)
!3965 = !DILocation(line: 120, column: 70, scope: !3871)
!3966 = !DILocation(line: 120, column: 23, scope: !3871)
!3967 = !DILocation(line: 121, column: 25, scope: !3871)
!3968 = !DILocation(line: 121, column: 49, scope: !3871)
!3969 = !DILocation(line: 121, column: 23, scope: !3871)
!3970 = !DILocation(line: 122, column: 41, scope: !3871)
!3971 = !DILocation(line: 122, column: 65, scope: !3871)
!3972 = !DILocation(line: 122, column: 29, scope: !3871)
!3973 = !DILocation(line: 124, column: 17, scope: !3871)
!3974 = !DILocation(line: 124, column: 27, scope: !3871)
!3975 = !DILocation(line: 125, column: 26, scope: !3871)
!3976 = !DILocation(line: 125, column: 17, scope: !3871)
!3977 = !DILocation(line: 127, column: 22, scope: !3871)
!3978 = !DILocation(line: 127, column: 32, scope: !3871)
!3979 = !DILocation(line: 128, column: 30, scope: !3871)
!3980 = !DILocation(line: 128, column: 40, scope: !3871)
!3981 = !DILocation(line: 128, column: 27, scope: !3871)
!3982 = !DILocation(line: 128, column: 17, scope: !3871)
!3983 = !DILocation(line: 133, column: 30, scope: !3871)
!3984 = !DILocation(line: 133, column: 42, scope: !3871)
!3985 = !DILocation(line: 133, column: 47, scope: !3871)
!3986 = !DILocation(line: 133, column: 40, scope: !3871)
!3987 = !DILocation(line: 133, column: 21, scope: !3871)
!3988 = !DILocation(line: 134, column: 23, scope: !3871)
!3989 = !DILocation(line: 134, column: 12, scope: !3871)
!3990 = !DILocation(line: 134, column: 5, scope: !3871)
!3991 = distinct !DISubprogram(name: "srcToRep", scope: !3723, file: !3723, line: 66, type: !179, scopeLine: 66, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !167, retainedNodes: !2)
!3992 = !DILocation(line: 67, column: 49, scope: !3991)
!3993 = !DILocation(line: 67, column: 55, scope: !3991)
!3994 = !DILocation(line: 68, column: 16, scope: !3991)
!3995 = !DILocation(line: 68, column: 5, scope: !3991)
!3996 = distinct !DISubprogram(name: "dstFromRep", scope: !3723, file: !3723, line: 71, type: !179, scopeLine: 71, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !167, retainedNodes: !2)
!3997 = !DILocation(line: 72, column: 49, scope: !3996)
!3998 = !DILocation(line: 72, column: 55, scope: !3996)
!3999 = !DILocation(line: 73, column: 16, scope: !3996)
!4000 = !DILocation(line: 73, column: 5, scope: !3996)
!4001 = distinct !DISubprogram(name: "__gnu_f2h_ieee", scope: !168, file: !168, line: 22, type: !179, scopeLine: 22, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !167, retainedNodes: !2)
!4002 = !DILocation(line: 23, column: 25, scope: !4001)
!4003 = !DILocation(line: 23, column: 12, scope: !4001)
!4004 = !DILocation(line: 23, column: 5, scope: !4001)
