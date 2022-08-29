/*
 RMIT University Vietnam
 Course: COSC2659 iOS Development
 Semester: 2022B
 Assessment: Assignment 2
 Author: Nguyen Thanh Luan
 ID: s3757937
 Created  date: 14/08/2022
 Last modified: 29/08/2022
 */
import SwiftUI
struct HowToPlayView: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @State private var player: String = ""
    
    var body: some View {
        GeometryReader {screen in
            NavigationView {
                ZStack {
                    Image("landing").resizable().edgesIgnoringSafeArea(.all)
                    Rectangle()
                        .foregroundColor(.clear)
                        .background(LinearGradient(gradient: Gradient(colors: [.clear, .black]), startPoint: .bottom, endPoint: .top))
                        .edgesIgnoringSafeArea(.all)
                    VStack{
                        Text("The rules of the game can be find here:")
                            .font(.system(.title, design: .rounded))
                            .foregroundColor(.orange)
                            .multilineTextAlignment(.center)
                        Link("English", destination: URL(string: "https://www.pokerlistings.com/poker-rules-chinese-poker")!)
                            .font(.title)
                            .foregroundColor(.blue)
                        
                        Link("Vietnamese", destination: URL(string: "https://ngonaz.com/cach-choi-mau-binh/")!)
                            .font(.title)
                            .foregroundColor(.blue)
                    }
                    .padding()
                    .frame(width: screen.size.width/1.5, height: screen.size.height/1.1)
                    .foregroundColor(Color.black.opacity(0.8))
                    .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 5, style: .continuous))
                }
            }
            
        }
        .navigationViewStyle(StackNavigationViewStyle())
        .navigationBarBackButtonHidden(false)
        .accentColor(.pink)
    }
    
}
