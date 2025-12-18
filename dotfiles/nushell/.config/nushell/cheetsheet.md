# Nushell — Kiểu dữ liệu, `each`, chuyển đổi dữ liệu & Autocomplete (1 file hoàn chỉnh)

---

## 1. Triết lý cốt lõi của Nushell

> **Nushell = shell làm việc với DATA, không phải text**

* Mọi lệnh trả về **structured data** (table / record / list)
* Pipe (`|`) = truyền **dữ liệu**, không phải chuỗi
* Autocomplete hiểu **command / param / value**

---

## 2. Các kiểu dữ liệu cơ bản trong Nushell

### 2.1 Scalar (giá trị đơn)

```nu
123            # int
3.14           # float
true / false   # bool
"hello"        # string
null           # null
```

---

### 2.2 List (danh sách)

```nu
[1 2 3]
["a" "b" "c"]
```

Truy cập:

```nu
[1 2 3].0      # 1
```

---

### 2.3 Record (object / map)

```nu
{ name: "vm1", status: "running" }
```

Truy cập:

```nu
$rec.name
```

---

### 2.4 Table (list + record)

```nu
[
  {name: "a", age: 1}
  {name: "b", age: 2}
]
```

Đây là **kiểu dữ liệu quan trọng nhất** trong Nushell

---

## 3. Lệnh `each` — hiểu đơn giản

### 3.1 `each` là gì?

> `each` = **for-each trên list / table**

```nu
[1 2 3] | each { |x| $x * 2 }
```

Kết quả:

```nu
[2 4 6]
```

---

### 3.2 `each` với table

```nu
ls | each { |row| $row.name }
```

---

### 3.3 `each` + record

```nu
[{a:1} {a:2}] | each { |r| $r.a }
```

---

### 3.4 Khi nào dùng `each`?

* Khi cần **xử lý từng dòng**
* Khi gọi external command nhiều lần
* Khi transform data phức tạp

---

## 4. Các hàm transform dữ liệu hay dùng (CHEAT LIST)

### 4.1 `get`

```nu
ls | get name
```

---

### 4.2 `select`

```nu
ls | select name size
```

---

### 4.3 `where` (filter)

```nu
ls | where size > 1mb
```

---

### 4.4 `update`

```nu
ls | update size { |r| $r.size / 1024 }
```

---

### 4.5 `insert`

```nu
ls | insert ext { |r| ($r.name | path parse).extension }
```

---

### 4.6 `merge`

```nu
{a:1} | merge {b:2}
```

---

### 4.7 `reduce`

```nu
[1 2 3] | reduce { |it acc| $acc + $it }
```

---

## 5. Dữ liệu cấu hình: JSON / YAML / CSV / TOML

### 5.1 `from` = parse (text → data)

| Lệnh      | Dùng cho |
| --------- | -------- |
| from json | JSON     |
| from yaml | YAML     |
| from csv  | CSV      |
| from toml | TOML     |

---

### 5.2 `to` = serialize (data → text)

| Lệnh    | Output |
| ------- | ------ |
| to json | JSON   |
| to yaml | YAML   |
| to csv  | CSV    |
| to toml | TOML   |

---

### 5.3 Ví dụ JSON

```nu
open config.json | from json
```

Sửa dữ liệu:

```nu
open config.json | from json | update port 8080 | to json | save config.json -f
```

---

### 5.4 YAML

```nu
open config.yaml | from yaml
```

---

### 5.5 CSV

```nu
open users.csv | from csv
```

---

### 5.6 TOML (rất hay dùng cho config)

```nu
open Cargo.toml | from toml
```

---

## 6. External command & data

### 6.1 External = text → cần parse

```nu
ps aux | lines
```

---

### 6.2 Bắt exit code

```nu
let r = (^git status | complete)
$r.exit_code
$r.stdout
$r.stderr
```

---

## 7. Autocomplete trong Nushell — CƠ CHẾ HOẠT ĐỘNG

### 7.1 3 tầng completion

1. **Command completion**
2. **Parameter completion**
3. **Value completion**

---

### 7.2 Completion function

```nu
def "nu-complete tmux-sessions" [] {
  tmux list-sessions -F '#S' | lines
}
```

---

### 7.3 Gắn completion vào param

```nu
export def tsn [
  session: string@"nu-complete tmux-sessions"
] {}
```

---

### 7.4 Khi nào function được gọi?

| Bạn gõ    | Completion          |
| --------- | ------------------- |
| ts<TAB>   | command             |
| tsn<TAB>  | param               |
| tsn <TAB> | value (nu-complete) |

---

## 8. Completion trong MODULE

### 8.1 Cấu trúc module chuẩn

```text
modules/
└── tmux.nu
```

```nu
# helper (không export)
def "nu-complete tmux-sessions" [] { ... }

# command (export)
export def tsn [ session: string@"nu-complete tmux-sessions" ] {}
```

---

### 8.2 Load module

```nu
use modules/tmux.nu *
```

---

### 8.3 Vì sao completion hoạt động?

* Nushell load **AST của module**
* Completion function nằm trong scope
* Param annotation tham chiếu được

---

## 9. Lỗi thường gặp

### 9.1 Alias với keyword

```nu
alias nuss = source config.nu   # ❌
```

→ `source` là keyword

---

### 9.2 Circular import

```nu
source config.nu trong chính config.nu
```

→ ❌ vòng lặp

---

## 10. Ghi nhớ nhanh

* `from` = text → data
* `to` = data → text
* `each` = for-each data
* completion = function trả list
* module = namespace + autocomplete

---

## 11. Tư duy đúng khi viết Nushell

> ❌ Nghĩ như bash
> ✔ Nghĩ như **query data**

---

**END — Copy & dùng ngay**

