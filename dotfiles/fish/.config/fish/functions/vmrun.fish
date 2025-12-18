function vmrun
    # --- PHẦN 1: KIỂM TRA THAM SỐ (CHỈ CHẤP NHẬN 2 THAM SỐ) ---
    if test (count $argv) -ne 2
        echo (set_color red) "Lỗi:" (set_color normal) "Cú pháp không hợp lệ. Hàm này chỉ chấp nhận 2 tham số."
        echo "Cú pháp: vmrun <start|stop> <all-in-one|harbor|k8s>"
        return 1
    end

    set cmd $argv[1] # Lệnh: start hoặc stop
    set service_name $argv[2] # Tên dịch vụ: all-in-one, harbor, k8s

    # Bạn có thể giữ lại dòng DEBUG này cho lần kiểm tra cuối cùng
    echo "DEBUG: \$service_name được nhận là: '$service_name'" 
    if test "$service_name = "all-in-one""
    echo "Hai chuỗi bằng nhau."
else
    echo "Hai chuỗi KHÔNG bằng nhau." # Kết quả sẽ là dòng này
end

    # --- PHẦN 2: HÀM CON ĐỂ KHỞI ĐỘNG (service_run) ---
    function service_run
    # Dùng if test để so sánh chuỗi
    echo "Da vao day"
    if test "$service_name = "all-in-one""
        echo "Đang khời động máy ảo $service_name"
        vmrun start "/Users/thongvu/Virtual Machines.localized/all-in-one.vmwarevm/all-in-one.vm" nogui
        return 0
    else if test "$service_name" = "harbor"
        echo "Đang khời động máy ảo $service_name"
        vmrun start "/Users/thongvu/Virtual Machines.localized/Harbo-registry.vmwarevm/Harbo-registry.vmx" nogui
        return 0
    else if test "$service_name" = "k8s"
        echo "Đang khời động cụm máy ảo $service_name"
        vmrun start "/Users/thongvu/Virtual Machines.localized/k8s-master-1.vmwarevm/k8s-master-1.vmx" nogui
        vmrun start "/Users/thongvu/Virtual Machines.localized/k8s-master-2.vmwarevm/k8s-master-2.vmx" nogui
        vmrun start "/Users/thongvu/Virtual Machines.localized/k8s-master-3.vmwarevm/k8s-master-3.vmx" nogui
        return 0
    else
        # Xử lý trường hợp không khớp với bất kỳ dịch vụ nào
        echo "Loi 12234"
        echo (set_color red) "Lỗi:" (set_color normal) "Tên dịch vụ không hợp lệ."
        echo "Tham số đầu vào chỉ có thể là k8s, all-in-one, harbor"
        return 1
    end
end
    # --- PHẦN 3: HÀM CON ĐỂ DỪNG (service_stop) ---
    function service_stop
        switch "$service_name"
            case all-in-one
                echo "Đang tắt máy ảo $service_name"
                vmrun stop "/Users/thongvu/Virtual Machines.localized/all-in-one.vmwarevm/all-in-one.vm"
                return 0
            case harbor
                echo "Đang tắt máy ảo $service_name"
                vmrun stop "/Users/thongvu/Virtual Machines.localized/Harbo-registry.vmwarevm/Harbo-registry.vmx"
                return 0
            case k8s
                echo "Đang tắt cụm máy ảo $service_name"
                vmrun stop "/Users/thongvu/Virtual Machines.localized/k8s-master-1.vmwarevm/k8s-master-1.vmx"
                vmrun stop "/Users/thongvu/Virtual Machines.localized/k8s-master-2.vmwarevm/k8s-master-2.vmx"
                vmrun stop "/Users/thongvu/Virtual Machines.localized/k8s-master-3.vmwarevm/k8s-master-3.vmx"
                return 0
            case '*'
                echo (set_color red) "Lỗi:" (set_color normal) "Tên dịch vụ không hợp lệ."
                echo "Tham số đầu vào chỉ có thể là k8s, all-in-one, harbor"
                return 1
        end
    end

    # --- PHẦN 4: LỆNH CHÍNH XỬ LÝ (cmd) ---
    switch "$cmd"
        case start
            service_run
            return $status 
        case stop
            service_stop
            return $status
        case '*'
            echo (set_color red) "Lỗi:" (set_color normal) "Lệnh không hợp lệ."
            echo "Lệnh chỉ có thể là 'start' hoặc 'stop'."
            return 1
    end
end
