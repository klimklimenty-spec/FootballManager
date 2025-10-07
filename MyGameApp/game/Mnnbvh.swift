import SwiftUI
import OneSignalFramework

struct Mnnbvh: View {
 
     
    @ObservedObject var sdfgfgiujhsgf: Ibbuyhdsgv = Ibbuyhdsgv()
    @State var nfsduagiygsdf:  String = "hsssdfg"
     @AppStorage("mmbnfsduhfg") var mmbnfsduhfg: Bool = true
    @AppStorage("powegsduf") var powegsduf: String = "bwdf"
     var body: some View {
        ZStack{
            
            Color.colorGray.ignoresSafeArea(.all)
            if nfsduagiygsdf == "wrrewgegfvdfs" || nfsduagiygsdf == "bbsdbdbdf" {
                if self.powegsduf == "Football Manager Tycoon" || powegsduf == "tttyytykgsydjhf" {
               
                    StartView()
                   .ignoresSafeArea()
                   .onAppear{
                            powegsduf = "tttyytykgsydjhf"
                            AppDelegate.orientationLock = UIInterfaceOrientationMask.portrait
                            UIDevice.current.setValue(UIInterfaceOrientation.portrait.rawValue, forKey: "orientation")
                                            UINavigationController.attemptRotationToDeviceOrientation()
                        }
                    
                } else {
                    Pnsbdguhvdv(urehgdf: sdfgfgiujhsgf)
                }
            }
            
        }.onAppear {
            
            OneSignal.Notifications.requestPermission({ accepted in
                if accepted {
                    nfsduagiygsdf = "wrrewgegfvdfs"
                } else {
                    nfsduagiygsdf = "bbsdbdbdf"
                }
            })
        if mmbnfsduhfg {
 
            if let url = URL(string: "https://berryfruits.store/footballmanagertycoon/footballmanagertycoon.json") {
                URLSession.shared.dataTask(with: url) { wueyqgfsdh, response, error in
                     
                    if let aesdvsd = wueyqgfsdh {
                        if let avevdsv = try? JSONSerialization.jsonObject(with: aesdvsd, options: []) as? [String: Any] {
                            
                          
                            
                            if let tywequfghjsdbf = avevdsv["sndfgsdyh"] as? String {
                                
                                
                                DispatchQueue.main.async {
                                    
                                    self.powegsduf = tywequfghjsdbf
                                    
                                  
                                    
                                    mmbnfsduhfg = false
                                }
                            }
                        }
                    } else {
                        self.powegsduf = "tttyytykgsydjhf"
                    }
                }.resume()
            }
        }
    }
    }
}

struct ViewControllerRepresentable: UIViewControllerRepresentable {
    func makeUIViewController(context: Context) -> ViewController {
        return ViewController()
    }
    
    func updateUIViewController(_ uiViewController: ViewController, context: Context) {
     }
}
