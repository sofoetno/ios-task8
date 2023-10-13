class OrbitronSpaceStation {
    let controlCenter: ControlCenter
    let researchLab: ResearchLab
    let lifeSupportSystem: LifeSupportSystem
    
    init(controlCenter: ControlCenter, researchLab: ResearchLab, lifeSupportSystem: LifeSupportSystem) {
        self.controlCenter = controlCenter
        self.researchLab = researchLab
        self.lifeSupportSystem = lifeSupportSystem
    }
    
    func controlCenterLockdown(password: String) {
        controlCenter.lockdown(password: password)
    }
}


class MissionControl {
    var spaceStation: OrbitronSpaceStation?
    
    func connectToOrbitronSpaceStation(orbitStation: OrbitronSpaceStation){
        spaceStation = orbitStation
    }
    
    func requestControlCenterStatus() {
        spaceStation?.controlCenter.isUnderLockdown()
    }
    
    func requestOxygenStatus() {
        spaceStation?.lifeSupportSystem.oxყgenStatus()
    }
    
    func requestDroneStatus(module: StationModule) {
        module.drone?.ifDroneHaveTask()
    }
}


class Drone {
    var task: String?
    unowned var assignedModule: StationModule
    weak var missionControlLink: MissionControl?
    
    init(assignedModule: StationModule, task: String?, missionControlLink: MissionControl? = nil) {
        self.task = task
        self.assignedModule = assignedModule
        self.missionControlLink = missionControlLink
    }
    
    func ifDroneHaveTask() -> Bool {
        if let task = self.task {
            print(task)
            return true
        } else {
            return false
        }
    }
}


class StationModule {
    private let moduleName: String
    var drone: Drone?
    
    init(moduleName: String, drone: Drone?) {
        self.moduleName = moduleName
        self.drone = drone
    }
    
    func giveTaskToDrone(taskForDrone: String) {
        drone?.task = taskForDrone
    }
}


class ControlCenter: StationModule  {
    private var isLockDown: Bool
    private let securityCode: String
    
    init(isLockDown: Bool, securityCode: String, drone: Drone?) {
        self.isLockDown = isLockDown
        self.securityCode = securityCode
        
        super.init(moduleName: "ControlCenter", drone: drone)
    }
    
    func lockdown(password: String) {
        if password == securityCode {
            isLockDown = true
        }
    }
    
    func isUnderLockdown() {
        if isLockDown {
            print ("Control center is locked down!")
        } else {
            print("Control center is not locked down!")
        }
    }
}


class ResearchLab: StationModule {
    private var samples: [String] = []
    
    init(drone: Drone?) {
        super.init(moduleName: "ResearchLab", drone: drone)
    }
    
    func addSample(sample: String) {
        samples.append(sample)
    }
}



class LifeSupportSystem: StationModule {
    private let oxygenLevel: Int
    
    init(oxygenLevel: Int, drone: Drone?) {
        self.oxygenLevel = oxygenLevel
        
        super.init(moduleName: "ResearchLab", drone: drone)
    }
    
    func oxყgenStatus() {
        print("Oxygen level is: \(oxygenLevel)")
    }
}

let controller = MissionControl()

let controlCenter = ControlCenter(isLockDown: false, securityCode: "superstrongpassword", drone: nil)
controlCenter.drone = Drone(assignedModule: controlCenter, task: "", missionControlLink: controller)

let researchLab = ResearchLab(drone: nil)
researchLab.drone = Drone(assignedModule: researchLab, task: "", missionControlLink: controller)

let lifeSupportSystem = LifeSupportSystem(oxygenLevel: 99, drone: nil)
lifeSupportSystem.drone = Drone(assignedModule: lifeSupportSystem, task: "", missionControlLink: controller)

let venera = OrbitronSpaceStation(controlCenter: controlCenter, researchLab: researchLab, lifeSupportSystem: lifeSupportSystem)

controller.connectToOrbitronSpaceStation(orbitStation: venera)
controller.requestControlCenterStatus()

venera.controlCenter.giveTaskToDrone(taskForDrone: "Kill Thanos!")
venera.researchLab.giveTaskToDrone(taskForDrone: "Save Thanos!")
venera.lifeSupportSystem.giveTaskToDrone(taskForDrone: "kill all drones!")

controller.requestDroneStatus(module: venera.controlCenter)
controller.requestDroneStatus(module: venera.researchLab)
controller.requestDroneStatus(module: venera.lifeSupportSystem)


controller.requestOxygenStatus()

venera.controlCenter.lockdown(password: "tyhgfdsa")
venera.controlCenter.isUnderLockdown()
venera.controlCenterLockdown(password: "superstrongpassword")
venera.controlCenter.isUnderLockdown()
