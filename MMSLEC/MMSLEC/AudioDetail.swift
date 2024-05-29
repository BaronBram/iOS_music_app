//
//  AudioDetail.swift
//  MMSLEC
//
//  Created by Baron Bram on 04/12/23.
//

import SwiftUI
import AVFoundation
import AVKit

struct AudioDetail: View {
    
    
    
    @State private var player: AVAudioPlayer?
    
    @State private var currentAudioIndex: Int = 0
    @State private var isPlaying = false
    @State private var totalTime: TimeInterval = 0.0
    @State private var currentTime: TimeInterval = 0.0
    
    
    var selectedSong: [Audio]
    
    @Binding var expandSheet: Bool
    var animation: Namespace.ID
    @State private var animationContent: Bool = false
    var imageName: String
    var songName: String
    var singer: String
    var audioTitle: String
    
    
    
    var body: some View {
        GeometryReader{
            let size = $0.size
            let safeArea = $0.safeAreaInsets
            
            ZStack{
                Rectangle().fill(.ultraThickMaterial).overlay(content: {
                    Rectangle()
                    Image(imageName).blur(radius: 60)
                    //.opacity(animationContent ? 1 : 0)
                })
                
                VStack(spacing: 15){
                    GeometryReader{
                        let size = $0.size
                        Image(imageName).resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: size.width, height: size.height)
                            .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
                        
                    }
                    .frame(height: size.width - 50)
                    .padding(.vertical, size.height < 700 ? 10 : 30)
                    
                    playerView(size)
                    
                    
                } .padding(.top, safeArea.top + (safeArea.bottom == 0 ? 10 : 0))
                    .padding(.bottom, safeArea.bottom == 0 ? 10 : safeArea.bottom)
                    .padding(.horizontal, 25)
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
                    .clipped()
                
            }.ignoresSafeArea(.container, edges: .all)
        }
        
        .onAppear{
            setupAudio(with: selectedSong[currentAudioIndex].audioTitle)
        }
        .onReceive(Timer.publish(every: 0.1, on: .main, in: .common).autoconnect()) { _ in
            onUpdateProgress()
        }
    }
    
    private func setupAudio(with fileName: String){
        guard let url = Bundle.main.url(forResource: fileName, withExtension: "mp3")
        else{
            print("No URl")
            return
        }
        do{
            player = try AVAudioPlayer(contentsOf: url)
            player?.play()
            player?.numberOfLoops = -1
            totalTime = player?.duration ?? 0.0
            isPlaying = true
            print("setup success")
        } catch{
            print("Error")
        }
    }
    
    private func playAudio(){
        player?.play()
        isPlaying = true
    }
    private func stopAudio(){
        player?.pause()
        isPlaying = false
    }
    private func onUpdateProgress(){
        guard let player = player else{ return }
        currentTime = player.currentTime
    }
    private func seekAudio(to time: TimeInterval){
        player?.currentTime = time
    }
    private func timeString(time: TimeInterval) -> String{
        let minute = Int(time)/60
        let seconds = Int(time) % 60
        return String(format: "%02d:%02d", minute, seconds)
       
    }
    
    
    
    @ViewBuilder
    func playerView(_ mainSize: CGSize) -> some View{
        GeometryReader{
            let size = $0.size
            let spacing = size.height * 0.04
            
            VStack(spacing: spacing){
                VStack(spacing: spacing){
                    HStack(alignment: .center, spacing: 15){
                        VStack{
                            Text(songName).font(.system(size: 40, weight: .bold )).fontWeight(.bold).foregroundColor(.white)
                            Text(singer).font(.system(size: 15, weight: .medium)).foregroundColor(.white).fontWeight(.medium).font(.caption).foregroundColor(.white)
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        
                        
                    }
                    
                    Slider(value: Binding(get: {
                        currentTime
                    }, set: {
                        newValue in seekAudio(to: newValue)
                    }), in: 0...totalTime).accentColor(.white).foregroundColor(.white)
                    
                    HStack{
                        Text(timeString(time: currentTime)).foregroundColor(.white)
                        Spacer()
                        Text(timeString(time: totalTime)).foregroundColor(.white)
                    }
                }
                .frame(height: size.height / 2.5, alignment: .top)
                
                HStack(spacing: size.width * 0.18){
                    
                    Button{action: do {
                        isPlaying ? playAudio() : stopAudio()
                        isPlaying.toggle()
                    }
                        
                    }label: {
                        Image(systemName: isPlaying ? "pause.fill" : "play.fill")
                            .font(size.height < 300 ? .largeTitle : .system(size: 50)).onTapGesture {
                                isPlaying ? stopAudio() : playAudio()
                            }
                    }
                    .foregroundColor(.white)
                }
                
            }
        }
        
    }
}


struct AudioDetail_Previews: PreviewProvider {
    static var previews: some View {
        
        let audioArray: [Audio] = [
                    Audio(title: "Rain", Singer: "RainCorp", audioTitle: "song.mp3"),
                    Audio(title: "Storm", Singer: "WeatherBand", audioTitle: "song.mp3"),
                    // Add more Audio instances as needed...
                ]
        
        
        AudioDetail(selectedSong: audioArray, expandSheet: .constant(true), animation: Namespace().wrappedValue, imageName: "rain.jpeg", songName: "Rain", singer: "RainCorp", audioTitle: "song.mp3").preferredColorScheme(.dark)
    }
}

//expandSheet: .constant(true), animation: Namespace().wrappedValue);,imageName: "rain.jpeg", songName: "Rain", singer: "RainCorp", bio: "Heavy Rain", .preferredColorScheme(.dark)

extension View{
    var deviceCornerRadius: CGFloat {
        
        let key = "_displayCornerRadius"
        if let screen = (UIApplication.shared.connectedScenes.first as? UIWindowScene)?.windows.first?.screen{
            if let cornerRadius = screen.value(forKey: key) as? CGFloat {
                return cornerRadius
            }
            return 0
        }
        return 0
    }
}


