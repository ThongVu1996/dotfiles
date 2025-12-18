# **🚀 VIM CHEATSHEET: TƯ DUY TỰ NHIÊN**

"Đừng học vẹt, hãy nhớ hình ảnh và ý nghĩa."

Tài liệu này tổng hợp các phím tắt Vim dựa trên tư duy hình ảnh (Mnemonics) giúp bạn nhớ lâu và phản xạ tự nhiên.

## **1\. Cơ bản (Basic Navigation)**

_Bạn đã nắm vững, nhưng liệt kê để đầy đủ._

| Phím | Tác dụng  | Mẹo nhớ                                       |
| :--- | :-------- | :-------------------------------------------- |
| h    | Sang trái | Ngón trỏ (bên trái).                          |
| j    | Đi xuống  | Hình dáng chữ j móc xuống dưới.               |
| k    | Đi lên    | Chữ k (King) ở trên cao / Hình dáng vươn lên. |
| l    | Sang phải | Ngón út (bên phải).                           |

## **2\. Di chuyển trong dòng (Line Motion)**

_Quy tắc: Hình tượng & Regex_

| Phím  | Tác dụng                           | Mẹo nhớ (Mnemonics)                                                             |
| :---- | :--------------------------------- | :------------------------------------------------------------------------------ |
| **^** | Về **đầu dòng** (chữ cái đầu tiên) | Hình mũi tên chỉ lên/vào điểm bắt đầu. (Regex start).                           |
| **$** | Về **cuối dòng**                   | **Tiền ($)** luôn nằm ở cuối cùng sau khi thanh toán. (Regex end).              |
| **%** | Nhảy qua lại cặp (), {}, \[\]      | Hai vòng tròn ở hai đầu % tượng trưng cho một **cặp đôi**. Dùng để debug ngoặc. |

## **3\. Di chuyển theo từ (Word vs WORD)**

_Quy tắc: Kích thước (Thường \= Nhỏ/Nhạy cảm, Hoa \= Lớn/Cục súc)_

| Phím  | Tác dụng                        | Mẹo nhớ (Mnemonics)                                              |
| :---- | :------------------------------ | :--------------------------------------------------------------- |
| **w** | Đi tới đầu từ sau (**word**)    | **w**ord (nhỏ). Bị chặn bởi dấu chấm, phẩy.                      |
| **W** | Đi tới đầu từ sau (**WORD**)    | **W**HOLE word (lớn). Chỉ dừng khi gặp **Khoảng trắng (Space)**. |
| **b** | Lùi lại đầu từ trước (**back**) | **b**ack (nhỏ). Bị chặn bởi ký tự đặc biệt.                      |
| **B** | Lùi lại đầu từ trước (**BACK**) | Đi lùi xuyên qua mọi dấu chấm phẩy, chỉ sợ Space.                |
| **e** | Tới cuối từ (**end**)           | **e**nd (nhỏ). Dừng ngay trước dấu chấm/phẩy.                    |
| **E** | Tới cuối từ (**END**)           | **E**ND (lớn). Giống W, nhảy xuyên qua dấu câu tới cuối từ.      |

## **4\. Di chuyển màn hình & Khối (Scrolling & Blocks)**

_Quy tắc: Tiếng Anh cơ bản & Lật trang sách_

| Phím          | Tác dụng                        | Mẹo nhớ (Mnemonics)                                                  |
| :------------ | :------------------------------ | :------------------------------------------------------------------- |
| **Ctrl \+ u** | Lên nửa trang                   | **U**p.                                                              |
| **Ctrl \+ d** | Xuống nửa trang                 | **D**own.                                                            |
| **Ctrl \+ f** | Xuống 1 trang (Lật tới)         | **F**orward (Tiến về phía trước).                                    |
| **Ctrl \+ b** | Lên 1 trang (Lật lùi)           | **B**ackward (Lùi lại phía sau).                                     |
| **Ctrl \+ e** | Cuộn xuống 1 dòng (Giữ con trỏ) | **E**xpose (Lộ ra thêm dòng ở dưới) hoặc **E**xtra lines.            |
| **Ctrl \+ y** | Cuộn lên 1 dòng (Giữ con trỏ)   | **Y**oyo (Kéo lên). Chữ Y nằm ở hàng phím trên nên kéo màn hình lên. |
| **{**         | Lùi lại một đoạn văn            | Nhảy lên dòng trống phía trên (Đầu block code {).                    |
| **}**         | Đi tới một đoạn văn             | Nhảy xuống dòng trống phía dưới (Cuối block code }).                 |

## **5\. Di chuyển theo Cấu trúc Code (Bracket Jumping)**

_Quy tắc: **\[** là Lùi/Trước (Back), **\]** là Tới/Sau (Next). Ký tự thứ 2 là đích đến._

| Phím    | Tác dụng                           | Mẹo nhớ (Mnemonics)                                                                    |
| :------ | :--------------------------------- | :------------------------------------------------------------------------------------- |
| **\[{** | Nhảy về đầu khối { bao quanh       | **\[** (Lùi) về **{** (đầu hàm/block). Rất hay dùng để tìm tên hàm chứa dòng hiện tại. |
| **}\]** | Nhảy tới cuối khối } bao quanh     | **\]** (Tới) chỗ **}** (cuối hàm/block).                                               |
| **\[(** | Nhảy về dấu ( chưa đóng trước đó   | **\[** (Lùi) về **(** (đầu biểu thức).                                                 |
| **\])** | Nhảy tới dấu ) chưa đóng tiếp theo | **\]** (Tới) chỗ **)** (cuối biểu thức).                                               |

## **6\. Lịch sử Di chuyển (Time Travel)**

_Quy tắc: Giống nút Back/Forward trên trình duyệt web._

| Phím          | Tác dụng                 | Mẹo nhớ (Mnemonics)                            |
| :------------ | :----------------------- | :--------------------------------------------- |
| **Ctrl \+ o** | Quay lại vị trí vừa đứng | **O**ld positions (Vị trí cũ).                 |
| **Ctrl \+ i** | Đi tới vị trí mới hơn    | Đối lập với o. Hoặc **I**n front (Phía trước). |

## **7\. Ngôn ngữ Chỉnh sửa (Editing Operators) \- QUAN TRỌNG**

_Tư duy: **Động từ (Operators)** \+ **Danh từ (Motions/Objects)** \= Câu lệnh._

| Phím  | Ý nghĩa (Động từ)     | Tác dụng thực tế & Mẹo nhớ                                                    |
| :---- | :-------------------- | :---------------------------------------------------------------------------- |
| **d** | **D**elete (Xóa)      | Cắt đoạn văn bản vào clipboard (có thể paste lại).                            |
| **c** | **C**hange (Thay đổi) | **Xóa \+ Vào chế độ Insert**. Dùng khi bạn muốn sửa cái gì đó thành cái khác. |
| **y** | **Y**ank (Sao chép)   | Copy (Yank nghe giống tiếng giật mạnh cái gì đó ra để giữ lấy).               |
| **p** | **P**ut (Dán)         | Paste (Dán nội dung vừa d hoặc y ra sau con trỏ).                             |

### **Text Objects: "Bên trong" vs "Bao quanh"**

_Đây là đỉnh cao của Vim: Tác động vào cấu trúc thay vì đếm ký tự._

- **i** \= **I**nner (Bên trong): Chỉ nội dung, KHÔNG tính dấu bao quanh.
- **a** \= **A**round (Bao quanh): Cả nội dung VÀ dấu bao quanh.

| Combo   | Ý nghĩa                        | Giải thích (Tư duy)                                             |
| :------ | :----------------------------- | :-------------------------------------------------------------- |
| **di(** | **D**elete **I**nner **(**     | Xóa hết chữ **trong** ngoặc (), giữ lại dấu ngoặc.              |
| **ci(** | **C**hange **I**nner **(**     | Xóa chữ trong ngoặc () và cho phép gõ mới ngay. (Cực hay dùng). |
| **da(** | **D**elete **A**round **(**    | Xóa **cả cụm** (...) bao gồm cả dấu ngoặc.                      |
| **ci"** | **C**hange **I**nner **"**     | Thay đổi nội dung trong dấu nháy kép "...".                     |
| **yi{** | **Y**ank **I**nner **{**       | Copy toàn bộ nội dung trong block code {...}.                   |
| **daw** | **D**elete **A**round **W**ord | Xóa từ và cả khoảng trắng thừa phía sau (làm sạch văn bản).     |

### **Quyền năng của dấu chấm . (The Dot)**

Đây là vũ khí mạnh nhất của Vim để tăng tốc độ.

| Phím  | Tác dụng                           | Tư duy luồng suy nghĩ                                        |
| :---- | :--------------------------------- | :----------------------------------------------------------- |
| **.** | Lặp lại thao tác sửa đổi cuối cùng | "Tao vừa làm gì xong, thì làm lại **y hệt** cái đó tại đây". |

**Ví dụ luồng suy nghĩ (Workflow):**

1. Bạn muốn xóa một từ: Gõ dw (Delete Word).
2. Bạn di chuyển đến từ rác tiếp theo (w, j...).
3. Bạn muốn xóa nó? Đừng gõ dw nữa. **Gõ .**.
4. Di chuyển tiếp \-\> Gõ . \-\> Di chuyển tiếp \-\> Gõ ..

## **8\. Định vị & Tầm nhìn (Z-Commands)**

_Quy tắc: **Z**one (Vùng nhìn) & Zoom_

| Phím   | Tác dụng                                 | Mẹo nhớ (Mnemonics)                                                          |
| :----- | :--------------------------------------- | :--------------------------------------------------------------------------- |
| **zz** | Đưa dòng hiện tại vào **Giữa** màn hình  | **Z**one **Z**ero (Về tâm). Hoặc tiếng ngáy "zz" ngủ gật đầu gục xuống giữa. |
| **zt** | Đưa dòng hiện tại lên **Đỉnh** màn hình  | **Z**one **T**op.                                                            |
| **zb** | Đưa dòng hiện tại xuống **Đáy** màn hình | **Z**one **B**ottom.                                                         |
| **zh** | Cuộn màn hình sang **Trái**              | Giữ z \+ hướng h (trái). Hữu dụng khi tắt wrap text.                         |
| **zl** | Cuộn màn hình sang **Phải**              | Giữ z \+ hướng l (phải).                                                     |
| **zm** | Đóng bớt các nếp gấp (Fold)              | Fold **M**ore (Gấp thêm vào).                                                |
| **zr** | Mở bớt các nếp gấp (Fold)                | **R**educe folding (Giảm gấp).                                               |

## **9\. Tìm kiếm chính xác trong dòng (Inline Search)**

_Quy tắc: Combo bộ ba f \- ; \- ,_

| Phím          | Tác dụng                 | Mẹo nhớ (Mnemonics)                            |
| :------------ | :----------------------- | :--------------------------------------------- |
| **f** \+ kytu | Nhảy ngay tới kytu       | **F**ind (Tìm).                                |
| **;**         | Lặp lại lệnh f (đi tiếp) | Ngón út phải $\\rightarrow$ Thuận tay đi tới.  |
| **,**         | Lặp lại lệnh f (đi lùi)  | Dấu phẩy có móc ngược $\\rightarrow$ Quay đầu. |

## **10\. Lệnh thao tác đặc biệt (Special Command)**

| Phím  | Tác dụng                                 | Mẹo nhớ (Mnemonics)                                                         |
| :---- | :--------------------------------------- | :-------------------------------------------------------------------------- |
| **&** | Lặp lại lệnh **Thay thế** (:s) cuối cùng | **Ampersand** \= **AND** (Và). _"Làm dòng trên VÀ (&) làm dòng này y hệt."_ |

### **💡 Lộ trình luyện tập cập nhật**

1. **Tuần 1:** w/W \+ Ctrl-u/d.
2. **Tuần 2:** ^/$ \+ zz \+ Ctrl+o/i (Nhảy đi rồi nhảy về).
3. **Tuần 3:** dw, cw kết hợp với dấu . (Đây là tuần quan trọng nhất để tăng tốc).
4. **Tuần 4:** f/;/, \+ ci(, di{ (Thao tác trên cấu trúc code).
