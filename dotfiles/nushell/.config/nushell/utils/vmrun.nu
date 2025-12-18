########################################
# DATA
########################################
export const VM_BASE = "/Users/thongvu/Virtual Machines.localized"

export const VM_SERVICES = {
    all-in-one: [
        $"($VM_BASE)/all-in-one.vmwarevm/all-in-one.vmx"
    ] 
    harbor: [
        $"($VM_BASE)/Harbo-registry.vmwarevm/Harbo-registry.vmx"
    ]
    k8s: [
        $"($VM_BASE)/k8s-master-1.vmwarevm/k8s-master-1.vmx"
        $"($VM_BASE)/k8s-master-2.vmwarevm/k8s-master-2.vmx"
        $"($VM_BASE)/k8s-master-3.vmwarevm/k8s-master-3.vmx"
    ]
}

########################################
# COMPLETIONS
########################################
export def "nu-complete vmrun-cmd" [] {
    [start stop status]
}

export def "nu-complete vmrun-service" [] {
    $VM_SERVICES | columns
}

########################################
# INTERNAL: check VM running
########################################
def is-vm-running [vm: string] {
    ^vmrun list
    | lines
    | skip 1
    | any { |it| $it == $vm }
}

########################################
# INTERNAL: wait until VM running
########################################
def wait-vm [
    vm: string
    retries: int = 10
] {
    mut left = $retries

    loop {
        if (is-vm-running $vm) {
            print $"✅ VM is RUNNING: ($vm)"
            break
        }

        if $left == 0 {
            error make {
                msg: $"❌ Timeout waiting VM: ($vm)"
            }
        }

        sleep 2sec
        $left -= 1
    }
}

########################################
# MAIN COMMAND
########################################
export def main [
    cmd: string@"nu-complete vmrun-cmd"
    service: string@"nu-complete vmrun-service"
] {
    let vms = ($VM_SERVICES | get $service)

    match $cmd {

        start => {
    print $"🚀 Starting service: ($service)"

    for vm in $vms {

        if (is-vm-running $vm) {
            print $"⚠️ Already running: ($vm)"
            continue
        }

        print $"→ Starting VM: ($vm)"

        let r = (^vmrun start $vm nogui | complete)

        if $r.exit_code != 0 {
            print $"❌ Failed to start VM: ($vm)"
            print $r.stderr
            return
        }

        wait-vm $vm
    }

    print $"🟢 Service ($service) is READY"
}

        stop => {
            print $"🛑 Stopping service: ($service)"

            for vm in $vms {
                print $"→ Stopping VM: ($vm)"
                ^vmrun stop $vm | complete | ignore
            }
        }

        status => {
            $vms
            | each { |vm|
                {
                    vm: $vm
                    running: (is-vm-running $vm)
                }
            }
        }
    }
}

