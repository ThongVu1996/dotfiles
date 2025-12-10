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

| Phím          | Tác dụng                | Mẹo nhớ (Mnemonics)                                  |
| :------------ | :---------------------- | :--------------------------------------------------- |
| **Ctrl \+ u** | Lên nửa trang           | **U**p.                                              |
| **Ctrl \+ d** | Xuống nửa trang         | **D**own.                                            |
| **Ctrl \+ f** | Xuống 1 trang (Lật tới) | **F**orward (Tiến về phía trước).                    |
| **Ctrl \+ b** | Lên 1 trang (Lật lùi)   | **B**ackward (Lùi lại phía sau).                     |
| **{**         | Lùi lại một đoạn văn    | Nhảy lên dòng trống phía trên (Đầu block code {).    |
| **}**         | Đi tới một đoạn văn     | Nhảy xuống dòng trống phía dưới (Cuối block code }). |

## **5\. Định vị & Tầm nhìn (Z-Commands)**

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

## **6\. Tìm kiếm chính xác trong dòng (Inline Search)**

_Quy tắc: Combo bộ ba f \- ; \- ,_

| Phím          | Tác dụng                 | Mẹo nhớ (Mnemonics)                            |
| :------------ | :----------------------- | :--------------------------------------------- |
| **f** \+ kytu | Nhảy ngay tới kytu       | **F**ind (Tìm).                                |
| **;**         | Lặp lại lệnh f (đi tiếp) | Ngón út phải $\\rightarrow$ Thuận tay đi tới.  |
| **,**         | Lặp lại lệnh f (đi lùi)  | Dấu phẩy có móc ngược $\\rightarrow$ Quay đầu. |

## **7\. Lệnh thao tác đặc biệt (Special Command)**

| Phím  | Tác dụng                                 | Mẹo nhớ (Mnemonics)                                                         |
| :---- | :--------------------------------------- | :-------------------------------------------------------------------------- |
| **&** | Lặp lại lệnh **Thay thế** (:s) cuối cùng | **Ampersand** \= **AND** (Và). _"Làm dòng trên VÀ (&) làm dòng này y hệt."_ |

### **💡 Lộ trình luyện tập cập nhật**

1. **Tuần 1:** w/W \+ Ctrl-u/d (nửa trang đỡ chóng mặt hơn f/b).
2. **Tuần 2:** ^/$ \+ zz (đang code mà thấy dòng bị lệch thì bấm zz cho nó vào giữa ngay).
3. **Tuần 3:** f/;/, \+ Các lệnh z khác (zt, zb).
