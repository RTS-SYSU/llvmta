; ModuleID = 'llvm-link'
source_filename = "llvm-link"
target datalayout = "e-m:e-p:32:32-Fi8-i64:64-v128:64:128-a:0:32-n32-S64"
target triple = "armv7-unknown-unknown"

; Function Attrs: noinline nounwind
define dso_local arm_aapcs_vfpcc i8* @memcpy(i8* %destination, i8* %source, i32 %num) #0 !dbg !8 {
entry:
  %retval = alloca i8*, align 4
  %destination.addr = alloca i8*, align 4
  %source.addr = alloca i8*, align 4
  %num.addr = alloca i32, align 4
  %destination8 = alloca i8*, align 4
  %source8 = alloca i8*, align 4
  %i = alloca i32, align 4
  store i8* %destination, i8** %destination.addr, align 4
  store i8* %source, i8** %source.addr, align 4
  store i32 %num, i32* %num.addr, align 4
  %0 = load i8*, i8** %destination.addr, align 4, !dbg !10
  store i8* %0, i8** %destination8, align 4, !dbg !11
  %1 = load i8*, i8** %source.addr, align 4, !dbg !12
  store i8* %1, i8** %source8, align 4, !dbg !13
  store i32 0, i32* %i, align 4, !dbg !14
  br label %for.cond, !dbg !15

for.cond:                                         ; preds = %for.inc, %entry
  %2 = load i32, i32* %i, align 4, !dbg !16
  %3 = load i32, i32* %num.addr, align 4, !dbg !17
  %cmp = icmp ult i32 %2, %3, !dbg !18
  br i1 %cmp, label %for.body, label %for.end, !dbg !19

for.body:                                         ; preds = %for.cond
  %4 = load i8*, i8** %source8, align 4, !dbg !20
  %5 = load i32, i32* %i, align 4, !dbg !21
  %arrayidx = getelementptr inbounds i8, i8* %4, i32 %5, !dbg !20
  %6 = load i8, i8* %arrayidx, align 1, !dbg !20
  %7 = load i8*, i8** %destination8, align 4, !dbg !22
  %8 = load i32, i32* %i, align 4, !dbg !23
  %arrayidx1 = getelementptr inbounds i8, i8* %7, i32 %8, !dbg !22
  store i8 %6, i8* %arrayidx1, align 1, !dbg !24
  br label %for.inc, !dbg !25

for.inc:                                          ; preds = %for.body
  %9 = load i32, i32* %i, align 4, !dbg !26
  %inc = add nsw i32 %9, 1, !dbg !26
  store i32 %inc, i32* %i, align 4, !dbg !26
  br label %for.cond, !dbg !19, !llvm.loop !27

for.end:                                          ; preds = %for.cond
  %10 = load i8*, i8** %retval, align 4, !dbg !28
  ret i8* %10, !dbg !28
}

; Function Attrs: noinline nounwind
define dso_local arm_aapcs_vfpcc i8* @memset(i8* %ptr, i32 %value, i32 %num) #0 !dbg !29 {
entry:
  %ptr.addr = alloca i8*, align 4
  %value.addr = alloca i32, align 4
  %num.addr = alloca i32, align 4
  %ptr8 = alloca i8*, align 4
  %i = alloca i32, align 4
  store i8* %ptr, i8** %ptr.addr, align 4
  store i32 %value, i32* %value.addr, align 4
  store i32 %num, i32* %num.addr, align 4
  %0 = load i8*, i8** %ptr.addr, align 4, !dbg !30
  store i8* %0, i8** %ptr8, align 4, !dbg !31
  store i32 0, i32* %i, align 4, !dbg !32
  br label %for.cond, !dbg !33

for.cond:                                         ; preds = %for.inc, %entry
  %1 = load i32, i32* %i, align 4, !dbg !34
  %2 = load i32, i32* %num.addr, align 4, !dbg !35
  %cmp = icmp ult i32 %1, %2, !dbg !36
  br i1 %cmp, label %for.body, label %for.end, !dbg !37

for.body:                                         ; preds = %for.cond
  %3 = load i32, i32* %value.addr, align 4, !dbg !38
  %conv = trunc i32 %3 to i8, !dbg !39
  %4 = load i8*, i8** %ptr8, align 4, !dbg !40
  %5 = load i32, i32* %i, align 4, !dbg !41
  %arrayidx = getelementptr inbounds i8, i8* %4, i32 %5, !dbg !40
  store i8 %conv, i8* %arrayidx, align 1, !dbg !42
  br label %for.inc, !dbg !43

for.inc:                                          ; preds = %for.body
  %6 = load i32, i32* %i, align 4, !dbg !44
  %inc = add nsw i32 %6, 1, !dbg !44
  store i32 %inc, i32* %i, align 4, !dbg !44
  br label %for.cond, !dbg !37, !llvm.loop !45

for.end:                                          ; preds = %for.cond
  %7 = load i8*, i8** %ptr.addr, align 4, !dbg !46
  ret i8* %7, !dbg !47
}

attributes #0 = { noinline nounwind "correctly-rounded-divide-sqrt-fp-math"="false" "disable-tail-calls"="false" "less-precise-fpmad"="false" "min-legal-vector-width"="0" "no-frame-pointer-elim"="true" "no-frame-pointer-elim-non-leaf" "no-infs-fp-math"="false" "no-jump-tables"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="false" "stack-protector-buffer-size"="8" "target-cpu"="generic" "target-features"="+armv7-a,+d32,+dsp,+fp64,+fpregs,+neon,+strict-align,+vfp2,+vfp2d16,+vfp2d16sp,+vfp2sp,+vfp3,+vfp3d16,+vfp3d16sp,+vfp3sp,-thumb-mode" "unsafe-fp-math"="false" "use-soft-float"="false" }

!llvm.dbg.cu = !{!0}
!llvm.ident = !{!3}
!llvm.module.flags = !{!4, !5, !6, !7}

!0 = distinct !DICompileUnit(language: DW_LANG_C99, file: !1, producer: "clang version 9.0.0 (tags/RELEASE_900/final)", isOptimized: false, runtimeVersion: 0, emissionKind: LineTablesOnly, enums: !2, nameTableKind: None)
!1 = !DIFile(filename: "memory.c", directory: "/llvmta_testcases/libraries/builtinsstd")
!2 = !{}
!3 = !{!"clang version 9.0.0 (tags/RELEASE_900/final)"}
!4 = !{i32 2, !"Dwarf Version", i32 4}
!5 = !{i32 2, !"Debug Info Version", i32 3}
!6 = !{i32 1, !"wchar_size", i32 4}
!7 = !{i32 1, !"min_enum_size", i32 4}
!8 = distinct !DISubprogram(name: "memcpy", scope: !1, file: !1, line: 3, type: !9, scopeLine: 4, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !0, retainedNodes: !2)
!9 = !DISubroutineType(types: !2)
!10 = !DILocation(line: 5, column: 31, scope: !8)
!11 = !DILocation(line: 5, column: 8, scope: !8)
!12 = !DILocation(line: 6, column: 26, scope: !8)
!13 = !DILocation(line: 6, column: 8, scope: !8)
!14 = !DILocation(line: 8, column: 10, scope: !8)
!15 = !DILocation(line: 8, column: 6, scope: !8)
!16 = !DILocation(line: 8, column: 17, scope: !8)
!17 = !DILocation(line: 8, column: 21, scope: !8)
!18 = !DILocation(line: 8, column: 19, scope: !8)
!19 = !DILocation(line: 8, column: 2, scope: !8)
!20 = !DILocation(line: 9, column: 21, scope: !8)
!21 = !DILocation(line: 9, column: 29, scope: !8)
!22 = !DILocation(line: 9, column: 3, scope: !8)
!23 = !DILocation(line: 9, column: 16, scope: !8)
!24 = !DILocation(line: 9, column: 19, scope: !8)
!25 = !DILocation(line: 10, column: 2, scope: !8)
!26 = !DILocation(line: 8, column: 26, scope: !8)
!27 = distinct !{!27, !19, !25}
!28 = !DILocation(line: 11, column: 1, scope: !8)
!29 = distinct !DISubprogram(name: "memset", scope: !1, file: !1, line: 13, type: !9, scopeLine: 14, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !0, retainedNodes: !2)
!30 = !DILocation(line: 15, column: 41, scope: !29)
!31 = !DILocation(line: 15, column: 17, scope: !29)
!32 = !DILocation(line: 17, column: 10, scope: !29)
!33 = !DILocation(line: 17, column: 6, scope: !29)
!34 = !DILocation(line: 17, column: 17, scope: !29)
!35 = !DILocation(line: 17, column: 21, scope: !29)
!36 = !DILocation(line: 17, column: 19, scope: !29)
!37 = !DILocation(line: 17, column: 2, scope: !29)
!38 = !DILocation(line: 18, column: 29, scope: !29)
!39 = !DILocation(line: 18, column: 13, scope: !29)
!40 = !DILocation(line: 18, column: 3, scope: !29)
!41 = !DILocation(line: 18, column: 8, scope: !29)
!42 = !DILocation(line: 18, column: 11, scope: !29)
!43 = !DILocation(line: 19, column: 2, scope: !29)
!44 = !DILocation(line: 17, column: 26, scope: !29)
!45 = distinct !{!45, !37, !43}
!46 = !DILocation(line: 20, column: 9, scope: !29)
!47 = !DILocation(line: 20, column: 2, scope: !29)
