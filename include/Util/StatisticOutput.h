#pragma once

#ifndef __STATISTIC_OUTPUT_H__
#define __STATISTIC_OUTPUT_H__

#include <cstdint>
#include <string>
#include <unordered_map>
#include <vector>

class StatisticOutput {
private:
  // data in matrix form
  std::vector<std::vector<std::string>> datas;
  std::vector<size_t> max_col_len;

  std::unordered_map<std::string, size_t> row_map, col_map;
  std::vector<std::string> row_names, col_names;

  std::string top_header;

  std::size_t init_col_len;

  // change this to change the output format
  const static char top_bottom = '-', left_right = '|', line_seg = '-',
                    col_seg = '|', dec = '+';

  inline void print_line_seg(FILE *fp, char ch = line_seg) {
    for (size_t i = 0; i < max_col_len.size(); ++i) {
      fprintf(fp, "%c", dec);
      for (size_t j = 0; j < max_col_len[i] + 2; ++j) {
        fprintf(fp, "%c", ch);
      }
    }
    fprintf(fp, "%c\n", dec);
  }

  inline void print_data_unit(FILE *fp, const std::string &data,
                              const size_t max_len, bool is_first = false) {
    if (is_first) {
      fprintf(fp, "%c", left_right);
    }
    fprintf(fp, " ");
    size_t diff = max_len - data.size();
    if (diff % 2 == 0) {
      for (size_t j = 0; j < diff / 2; ++j) {
        fprintf(fp, " ");
      }
      fprintf(fp, "%s", data.c_str());
      for (size_t j = 0; j < diff / 2; ++j) {
        fprintf(fp, " ");
      }
    } else {
      for (size_t j = 0; j < diff / 2; ++j) {
        fprintf(fp, " ");
      }
      fprintf(fp, "%s", data.c_str());
      for (size_t j = 0; j < diff / 2 + 1; ++j) {
        fprintf(fp, " ");
      }
    }
    fprintf(fp, " %c", col_seg);
  }

  // real dump function
  inline void dump_fp(FILE *fp) {
    print_line_seg(fp, top_bottom);
    print_data_unit(fp, top_header, max_col_len[0], true);

    for (size_t i = 0; i < col_names.size(); ++i) {
      print_data_unit(fp, col_names[i], max_col_len[i + 1]);
    }
    fprintf(fp, "\n");

    print_line_seg(fp, line_seg);

    // each row
    for (size_t i = 0; i < row_names.size(); ++i) {
      print_data_unit(fp, row_names[i], max_col_len[0], true);

      for (size_t j = 0; j < datas[i].size(); ++j) {
        print_data_unit(fp, datas[i][j], max_col_len[j + 1]);
      }
      fprintf(fp, "\n");
      if (i == row_names.size() - 1)
        print_line_seg(fp, top_bottom);
      else
        print_line_seg(fp, line_seg);
    }
  }

public:
  inline StatisticOutput(const std::string &top_header = "",
                         const size_t min_col_len = 0)
      : max_col_len(1, std::max(top_header.length(), min_col_len)),
        top_header(top_header), init_col_len(min_col_len){};

  inline StatisticOutput(const size_t min_col_len)
      : max_col_len(1, min_col_len), top_header(""),
        init_col_len(min_col_len){};

  inline void update(const std::string row, const std::string col) {
    update(row, col, "-");
  }

  inline void update(const std::string row, const std::string col,
                     const std::string value) {
    size_t row_idx = 0, col_idx = 0;
    if (row_map.find(row) == row_map.end()) {
      row_map[row] = datas.size();
      datas.push_back(std::vector<std::string>(col_map.size(), "0"));
      row_names.push_back(row);
      max_col_len[0] = std::max(max_col_len[0], row.size());
    }
    if (col_map.find(col) == col_map.end()) {
      col_map[col] = datas[0].size();
      for (size_t i = 0; i < datas.size(); ++i) {
        datas[i].push_back("0");
      }
      max_col_len.push_back(0);
      col_names.push_back(col);
    }

    row_idx = row_map[row];
    col_idx = col_map[col];
    datas[row_idx][col_idx] = value;
    max_col_len[col_idx + 1] =
        std::max(std::max(max_col_len[col_idx + 1], init_col_len),
                 std::max(col.size(), datas[row_idx][col_idx].size()));
  }

  inline void update(const std::string row, const std::string col,
                     uint64_t value) {
    std::string val = std::to_string(value);
    update(row, col, val);
  }

  inline void update(const std::string row, const std::string col, int value) {
    std::string val = std::to_string(value);
    update(row, col, val);
  }

  inline void update(const std::string row, const std::string col,
                     double value) {
    std::string val = std::to_string(value);
    update(row, col, val);
  }

  inline void update(const std::string row, const std::string col,
                     float value) {
    std::string val = std::to_string(value);
    update(row, col, val);
  }

  inline void dump() { dump_fp(stdout); }

  inline void dump(const char *output_file, const char *mode = "a") {
    FILE *fp = fopen(output_file, mode);
    if (fp == nullptr) {
      fprintf(stderr, "[WARN] Unable to open file %s, dump to stdout",
              output_file);
      fp = stdout;
    }
    dump_fp(fp);
    if (fp && fp != stdout)
      fclose(fp);
  }

  inline void dump(FILE *fp) {
    if (fp == nullptr) {
      fprintf(stderr, "[WARN] fp is nullptr, dump to stdout.\n");
      fp = stdout;
    }
    dump_fp(fp);
  }
};

#endif