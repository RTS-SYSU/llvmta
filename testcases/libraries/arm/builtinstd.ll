; ModuleID = 'llvm-link'
source_filename = "llvm-link"
target datalayout = "e-m:e-p:32:32-Fi8-i64:64-v128:64:128-a:0:32-n32-S64"
target triple = "armv4t-unknown-unknown"

; Function Attrs: noinline nounwind
define dso_local arm_aapcscc i8* @memcpy(i8* noundef %destination, i8* noundef %source, i32 noundef %num) #0 !dbg !12 {
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
  %0 = load i8*, i8** %destination.addr, align 4, !dbg !15
  store i8* %0, i8** %destination8, align 4, !dbg !16
  %1 = load i8*, i8** %source.addr, align 4, !dbg !17
  store i8* %1, i8** %source8, align 4, !dbg !18
  store i32 0, i32* %i, align 4, !dbg !19
  br label %for.cond, !dbg !20

for.cond:                                         ; preds = %for.inc, %entry
  %2 = load i32, i32* %i, align 4, !dbg !21
  %3 = load i32, i32* %num.addr, align 4, !dbg !22
  %cmp = icmp ult i32 %2, %3, !dbg !23
  br i1 %cmp, label %for.body, label %for.end, !dbg !24

for.body:                                         ; preds = %for.cond
  %4 = load i8*, i8** %source8, align 4, !dbg !25
  %5 = load i32, i32* %i, align 4, !dbg !26
  %arrayidx = getelementptr inbounds i8, i8* %4, i32 %5, !dbg !25
  %6 = load i8, i8* %arrayidx, align 1, !dbg !25
  %7 = load i8*, i8** %destination8, align 4, !dbg !27
  %8 = load i32, i32* %i, align 4, !dbg !28
  %arrayidx1 = getelementptr inbounds i8, i8* %7, i32 %8, !dbg !27
  store i8 %6, i8* %arrayidx1, align 1, !dbg !29
  br label %for.inc, !dbg !30

for.inc:                                          ; preds = %for.body
  %9 = load i32, i32* %i, align 4, !dbg !31
  %inc = add nsw i32 %9, 1, !dbg !31
  store i32 %inc, i32* %i, align 4, !dbg !31
  br label %for.cond, !dbg !24, !llvm.loop !32

for.end:                                          ; preds = %for.cond
  %10 = load i8*, i8** %retval, align 4, !dbg !34
  ret i8* %10, !dbg !34
}

; Function Attrs: noinline nounwind
define dso_local arm_aapcscc i8* @memset(i8* noundef %ptr, i32 noundef %value, i32 noundef %num) #0 !dbg !35 {
entry:
  %ptr.addr = alloca i8*, align 4
  %value.addr = alloca i32, align 4
  %num.addr = alloca i32, align 4
  %ptr8 = alloca i8*, align 4
  %i = alloca i32, align 4
  store i8* %ptr, i8** %ptr.addr, align 4
  store i32 %value, i32* %value.addr, align 4
  store i32 %num, i32* %num.addr, align 4
  %0 = load i8*, i8** %ptr.addr, align 4, !dbg !36
  store i8* %0, i8** %ptr8, align 4, !dbg !37
  store i32 0, i32* %i, align 4, !dbg !38
  br label %for.cond, !dbg !39

for.cond:                                         ; preds = %for.inc, %entry
  %1 = load i32, i32* %i, align 4, !dbg !40
  %2 = load i32, i32* %num.addr, align 4, !dbg !41
  %cmp = icmp ult i32 %1, %2, !dbg !42
  br i1 %cmp, label %for.body, label %for.end, !dbg !43

for.body:                                         ; preds = %for.cond
  %3 = load i32, i32* %value.addr, align 4, !dbg !44
  %conv = trunc i32 %3 to i8, !dbg !45
  %4 = load i8*, i8** %ptr8, align 4, !dbg !46
  %5 = load i32, i32* %i, align 4, !dbg !47
  %arrayidx = getelementptr inbounds i8, i8* %4, i32 %5, !dbg !46
  store i8 %conv, i8* %arrayidx, align 1, !dbg !48
  br label %for.inc, !dbg !49

for.inc:                                          ; preds = %for.body
  %6 = load i32, i32* %i, align 4, !dbg !50
  %inc = add nsw i32 %6, 1, !dbg !50
  store i32 %inc, i32* %i, align 4, !dbg !50
  br label %for.cond, !dbg !43, !llvm.loop !51

for.end:                                          ; preds = %for.cond
  %7 = load i8*, i8** %ptr.addr, align 4, !dbg !52
  ret i8* %7, !dbg !53
}

attributes #0 = { noinline nounwind "frame-pointer"="all" "min-legal-vector-width"="0" "no-builtins" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="arm7tdmi" "target-features"="+armv4t,+soft-float,+strict-align,-aes,-bf16,-d32,-dotprod,-fp-armv8,-fp-armv8d16,-fp-armv8d16sp,-fp-armv8sp,-fp16,-fp16fml,-fp64,-fpregs,-fullfp16,-mve,-mve.fp,-neon,-sha2,-thumb-mode,-vfp2,-vfp2sp,-vfp3,-vfp3d16,-vfp3d16sp,-vfp3sp,-vfp4,-vfp4d16,-vfp4d16sp,-vfp4sp" "use-soft-float"="true" }

!llvm.dbg.cu = !{!0}
!llvm.ident = !{!2}
!llvm.module.flags = !{!3, !4, !5, !6, !7, !8, !9, !10, !11}

!0 = distinct !DICompileUnit(language: DW_LANG_C99, file: !1, producer: "clang version 14.0.6 (git@gitlab.tu-dortmund.de:f4-ls12-daes/llvmta/llvmta.git 64262528b05c9d91a76d9ec1ec1045982f385529)", isOptimized: false, runtimeVersion: 0, emissionKind: LineTablesOnly, splitDebugInlining: false, nameTableKind: None)
!1 = !DIFile(filename: "../memory.c", directory: "/workspaces/llvmta/testcases/libraries/builtinsstd/buildarmv4", checksumkind: CSK_MD5, checksum: "fa9c872a007b30a353222cd13b38538d")
!2 = !{!"clang version 14.0.6 (git@gitlab.tu-dortmund.de:f4-ls12-daes/llvmta/llvmta.git 64262528b05c9d91a76d9ec1ec1045982f385529)"}
!3 = !{i32 7, !"Dwarf Version", i32 5}
!4 = !{i32 2, !"Debug Info Version", i32 3}
!5 = !{i32 1, !"wchar_size", i32 4}
!6 = !{i32 1, !"min_enum_size", i32 4}
!7 = !{i32 1, !"branch-target-enforcement", i32 0}
!8 = !{i32 1, !"sign-return-address", i32 0}
!9 = !{i32 1, !"sign-return-address-all", i32 0}
!10 = !{i32 1, !"sign-return-address-with-bkey", i32 0}
!11 = !{i32 7, !"frame-pointer", i32 2}
!12 = distinct !DISubprogram(name: "memcpy", scope: !1, file: !1, line: 3, type: !13, scopeLine: 4, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !0, retainedNodes: !14)
!13 = !DISubroutineType(types: !14)
!14 = !{}
!15 = !DILocation(line: 5, column: 31, scope: !12)
!16 = !DILocation(line: 5, column: 8, scope: !12)
!17 = !DILocation(line: 6, column: 26, scope: !12)
!18 = !DILocation(line: 6, column: 8, scope: !12)
!19 = !DILocation(line: 8, column: 10, scope: !12)
!20 = !DILocation(line: 8, column: 6, scope: !12)
!21 = !DILocation(line: 8, column: 17, scope: !12)
!22 = !DILocation(line: 8, column: 21, scope: !12)
!23 = !DILocation(line: 8, column: 19, scope: !12)
!24 = !DILocation(line: 8, column: 2, scope: !12)
!25 = !DILocation(line: 9, column: 21, scope: !12)
!26 = !DILocation(line: 9, column: 29, scope: !12)
!27 = !DILocation(line: 9, column: 3, scope: !12)
!28 = !DILocation(line: 9, column: 16, scope: !12)
!29 = !DILocation(line: 9, column: 19, scope: !12)
!30 = !DILocation(line: 10, column: 2, scope: !12)
!31 = !DILocation(line: 8, column: 26, scope: !12)
!32 = distinct !{!32, !24, !30, !33}
!33 = !{!"llvm.loop.mustprogress"}
!34 = !DILocation(line: 11, column: 1, scope: !12)
!35 = distinct !DISubprogram(name: "memset", scope: !1, file: !1, line: 13, type: !13, scopeLine: 14, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !0, retainedNodes: !14)
!36 = !DILocation(line: 15, column: 41, scope: !35)
!37 = !DILocation(line: 15, column: 17, scope: !35)
!38 = !DILocation(line: 17, column: 10, scope: !35)
!39 = !DILocation(line: 17, column: 6, scope: !35)
!40 = !DILocation(line: 17, column: 17, scope: !35)
!41 = !DILocation(line: 17, column: 21, scope: !35)
!42 = !DILocation(line: 17, column: 19, scope: !35)
!43 = !DILocation(line: 17, column: 2, scope: !35)
!44 = !DILocation(line: 18, column: 29, scope: !35)
!45 = !DILocation(line: 18, column: 13, scope: !35)
!46 = !DILocation(line: 18, column: 3, scope: !35)
!47 = !DILocation(line: 18, column: 8, scope: !35)
!48 = !DILocation(line: 18, column: 11, scope: !35)
!49 = !DILocation(line: 19, column: 2, scope: !35)
!50 = !DILocation(line: 17, column: 26, scope: !35)
!51 = distinct !{!51, !43, !49, !33}
!52 = !DILocation(line: 20, column: 9, scope: !35)
!53 = !DILocation(line: 20, column: 2, scope: !35)
