; ModuleID = 'llvm-link'
source_filename = "llvm-link"
target datalayout = "e-m:e-p:32:32-i64:64-n32-S128"
target triple = "riscv32"

; Function Attrs: noinline nounwind
define dso_local i8* @memcpy(i8* %destination, i8* %source, i32 %num) #0 !dbg !7 {
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
  %0 = load i8*, i8** %destination.addr, align 4, !dbg !9
  store i8* %0, i8** %destination8, align 4, !dbg !10
  %1 = load i8*, i8** %source.addr, align 4, !dbg !11
  store i8* %1, i8** %source8, align 4, !dbg !12
  store i32 0, i32* %i, align 4, !dbg !13
  br label %for.cond, !dbg !14

for.cond:                                         ; preds = %for.inc, %entry
  %2 = load i32, i32* %i, align 4, !dbg !15
  %3 = load i32, i32* %num.addr, align 4, !dbg !16
  %cmp = icmp ult i32 %2, %3, !dbg !17
  br i1 %cmp, label %for.body, label %for.end, !dbg !18

for.body:                                         ; preds = %for.cond
  %4 = load i8*, i8** %source8, align 4, !dbg !19
  %5 = load i32, i32* %i, align 4, !dbg !20
  %arrayidx = getelementptr inbounds i8, i8* %4, i32 %5, !dbg !19
  %6 = load i8, i8* %arrayidx, align 1, !dbg !19
  %7 = load i8*, i8** %destination8, align 4, !dbg !21
  %8 = load i32, i32* %i, align 4, !dbg !22
  %arrayidx1 = getelementptr inbounds i8, i8* %7, i32 %8, !dbg !21
  store i8 %6, i8* %arrayidx1, align 1, !dbg !23
  br label %for.inc, !dbg !24

for.inc:                                          ; preds = %for.body
  %9 = load i32, i32* %i, align 4, !dbg !25
  %inc = add nsw i32 %9, 1, !dbg !25
  store i32 %inc, i32* %i, align 4, !dbg !25
  br label %for.cond, !dbg !18, !llvm.loop !26

for.end:                                          ; preds = %for.cond
  %10 = load i8*, i8** %retval, align 4, !dbg !27
  ret i8* %10, !dbg !27
}

; Function Attrs: noinline nounwind
define dso_local i8* @memset(i8* %ptr, i32 %value, i32 %num) #0 !dbg !28 {
entry:
  %ptr.addr = alloca i8*, align 4
  %value.addr = alloca i32, align 4
  %num.addr = alloca i32, align 4
  %ptr8 = alloca i8*, align 4
  %i = alloca i32, align 4
  store i8* %ptr, i8** %ptr.addr, align 4
  store i32 %value, i32* %value.addr, align 4
  store i32 %num, i32* %num.addr, align 4
  %0 = load i8*, i8** %ptr.addr, align 4, !dbg !29
  store i8* %0, i8** %ptr8, align 4, !dbg !30
  store i32 0, i32* %i, align 4, !dbg !31
  br label %for.cond, !dbg !32

for.cond:                                         ; preds = %for.inc, %entry
  %1 = load i32, i32* %i, align 4, !dbg !33
  %2 = load i32, i32* %num.addr, align 4, !dbg !34
  %cmp = icmp ult i32 %1, %2, !dbg !35
  br i1 %cmp, label %for.body, label %for.end, !dbg !36

for.body:                                         ; preds = %for.cond
  %3 = load i32, i32* %value.addr, align 4, !dbg !37
  %conv = trunc i32 %3 to i8, !dbg !38
  %4 = load i8*, i8** %ptr8, align 4, !dbg !39
  %5 = load i32, i32* %i, align 4, !dbg !40
  %arrayidx = getelementptr inbounds i8, i8* %4, i32 %5, !dbg !39
  store i8 %conv, i8* %arrayidx, align 1, !dbg !41
  br label %for.inc, !dbg !42

for.inc:                                          ; preds = %for.body
  %6 = load i32, i32* %i, align 4, !dbg !43
  %inc = add nsw i32 %6, 1, !dbg !43
  store i32 %inc, i32* %i, align 4, !dbg !43
  br label %for.cond, !dbg !36, !llvm.loop !44

for.end:                                          ; preds = %for.cond
  %7 = load i8*, i8** %ptr.addr, align 4, !dbg !45
  ret i8* %7, !dbg !46
}

attributes #0 = { noinline nounwind "correctly-rounded-divide-sqrt-fp-math"="false" "disable-tail-calls"="false" "less-precise-fpmad"="false" "no-frame-pointer-elim"="true" "no-frame-pointer-elim-non-leaf" "no-infs-fp-math"="false" "no-jump-tables"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="false" "stack-protector-buffer-size"="8" "target-features"="+d,+f,+m" "unsafe-fp-math"="false" "use-soft-float"="false" }

!llvm.dbg.cu = !{!0}
!llvm.ident = !{!3}
!llvm.module.flags = !{!4, !5, !6}

!0 = distinct !DICompileUnit(language: DW_LANG_C99, file: !1, producer: "clang version 7.0.0 (tags/RELEASE_700/final)", isOptimized: false, runtimeVersion: 0, emissionKind: LineTablesOnly, enums: !2)
!1 = !DIFile(filename: "/home/hahns/Schreibtisch/llvmta_testcases/libraries/builtinsstd/memory.c", directory: "/home/hahns/Schreibtisch/llvmta_testcases/tmp.0OnKnrpueS")
!2 = !{}
!3 = !{!"clang version 7.0.0 (tags/RELEASE_700/final)"}
!4 = !{i32 2, !"Dwarf Version", i32 4}
!5 = !{i32 2, !"Debug Info Version", i32 3}
!6 = !{i32 1, !"wchar_size", i32 4}
!7 = distinct !DISubprogram(name: "memcpy", scope: !1, file: !1, line: 3, type: !8, isLocal: false, isDefinition: true, scopeLine: 4, flags: DIFlagPrototyped, isOptimized: false, unit: !0, retainedNodes: !2)
!8 = !DISubroutineType(types: !2)
!9 = !DILocation(line: 5, column: 31, scope: !7)
!10 = !DILocation(line: 5, column: 8, scope: !7)
!11 = !DILocation(line: 6, column: 26, scope: !7)
!12 = !DILocation(line: 6, column: 8, scope: !7)
!13 = !DILocation(line: 8, column: 10, scope: !7)
!14 = !DILocation(line: 8, column: 6, scope: !7)
!15 = !DILocation(line: 8, column: 17, scope: !7)
!16 = !DILocation(line: 8, column: 21, scope: !7)
!17 = !DILocation(line: 8, column: 19, scope: !7)
!18 = !DILocation(line: 8, column: 2, scope: !7)
!19 = !DILocation(line: 9, column: 21, scope: !7)
!20 = !DILocation(line: 9, column: 29, scope: !7)
!21 = !DILocation(line: 9, column: 3, scope: !7)
!22 = !DILocation(line: 9, column: 16, scope: !7)
!23 = !DILocation(line: 9, column: 19, scope: !7)
!24 = !DILocation(line: 10, column: 2, scope: !7)
!25 = !DILocation(line: 8, column: 26, scope: !7)
!26 = distinct !{!26, !18, !24}
!27 = !DILocation(line: 11, column: 1, scope: !7)
!28 = distinct !DISubprogram(name: "memset", scope: !1, file: !1, line: 13, type: !8, isLocal: false, isDefinition: true, scopeLine: 14, flags: DIFlagPrototyped, isOptimized: false, unit: !0, retainedNodes: !2)
!29 = !DILocation(line: 15, column: 41, scope: !28)
!30 = !DILocation(line: 15, column: 17, scope: !28)
!31 = !DILocation(line: 17, column: 10, scope: !28)
!32 = !DILocation(line: 17, column: 6, scope: !28)
!33 = !DILocation(line: 17, column: 17, scope: !28)
!34 = !DILocation(line: 17, column: 21, scope: !28)
!35 = !DILocation(line: 17, column: 19, scope: !28)
!36 = !DILocation(line: 17, column: 2, scope: !28)
!37 = !DILocation(line: 18, column: 29, scope: !28)
!38 = !DILocation(line: 18, column: 13, scope: !28)
!39 = !DILocation(line: 18, column: 3, scope: !28)
!40 = !DILocation(line: 18, column: 8, scope: !28)
!41 = !DILocation(line: 18, column: 11, scope: !28)
!42 = !DILocation(line: 19, column: 2, scope: !28)
!43 = !DILocation(line: 17, column: 26, scope: !28)
!44 = distinct !{!44, !36, !42}
!45 = !DILocation(line: 20, column: 9, scope: !28)
!46 = !DILocation(line: 20, column: 2, scope: !28)
