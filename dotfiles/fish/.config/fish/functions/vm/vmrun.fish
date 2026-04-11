function vmrun
    # --- PART 1: ARGUMENT VALIDATION (EXACTLY 2 ARGUMENTS) ---
    if test (count $argv) -ne 2
        echo (set_color red) "Error:" (set_color normal) "Invalid syntax. This function accepts exactly 2 arguments."
        echo "Usage: vmrun <start|stop> <all-in-one|harbor|k8s>"
        return 1
    end

    set -l cmd $argv[1] # Action: start or stop
    set -l service_name $argv[2] # Target: all-in-one, harbor, k8s

    # DEBUG: echo "DEBUG: service_name received as: '$service_name'"

    # --- PART 2: HELPER FUNCTION TO START (service_run) ---
    # Note: Use 'command vmrun' to call the VMware binary and avoid recursion
    function service_run -V service_name
        switch "$service_name"
            case "all-in-one"
                echo "Starting virtual machine: $service_name"
                command vmrun start "/Users/thongvu/Virtual Machines.localized/all-in-one.vmwarevm/all-in-one.vm" nogui
                return 0
            case "harbor"
                echo "Starting virtual machine: $service_name"
                command vmrun start "/Users/thongvu/Virtual Machines.localized/Harbo-registry.vmwarevm/Harbo-registry.vmx" nogui
                return 0
            case "k8s"
                echo "Starting Kubernetes cluster machines..."
                command vmrun start "/Users/thongvu/Virtual Machines.localized/k8s-master-1.vmwarevm/k8s-master-1.vmx" nogui
                command vmrun start "/Users/thongvu/Virtual Machines.localized/k8s-master-2.vmwarevm/k8s-master-2.vmx" nogui
                command vmrun start "/Users/thongvu/Virtual Machines.localized/k8s-master-3.vmwarevm/k8s-master-3.vmx" nogui
                return 0
            case '*'
                echo (set_color red) "Error:" (set_color normal) "Invalid service name."
                echo "Acceptable targets: k8s, all-in-one, harbor"
                return 1
        end
    end

    # --- PART 3: HELPER FUNCTION TO STOP (service_stop) ---
    function service_stop -V service_name
        switch "$service_name"
            case "all-in-one"
                echo "Stopping virtual machine: $service_name"
                command vmrun stop "/Users/thongvu/Virtual Machines.localized/all-in-one.vmwarevm/all-in-one.vm"
                return 0
            case "harbor"
                echo "Stopping virtual machine: $service_name"
                command vmrun stop "/Users/thongvu/Virtual Machines.localized/Harbo-registry.vmwarevm/Harbo-registry.vmx"
                return 0
            case "k8s"
                echo "Stopping Kubernetes cluster machines..."
                command vmrun stop "/Users/thongvu/Virtual Machines.localized/k8s-master-1.vmwarevm/k8s-master-1.vmx"
                command vmrun stop "/Users/thongvu/Virtual Machines.localized/k8s-master-2.vmwarevm/k8s-master-2.vmx"
                command vmrun stop "/Users/thongvu/Virtual Machines.localized/k8s-master-3.vmwarevm/k8s-master-3.vmx"
                return 0
            case '*'
                echo (set_color red) "Error:" (set_color normal) "Invalid service name."
                echo "Acceptable targets: k8s, all-in-one, harbor"
                return 1
        end
    end

    # --- PART 4: EXECUTION LOGIC ---
    switch "$cmd"
        case start
            service_run
            return $status
        case stop
            service_stop
            return $status
        case '*'
            echo (set_color red) "Error:" (set_color normal) "Invalid command."
            echo "Command must be 'start' or 'stop'."
            return 1
    end
end
