//
//  MiniPlayerView.swift
//  AlbumWidget
//
//  Created by Mason Sun on 2025/10/29.
//

import SwiftUI
import MusicKit
import Combine

final class MiniPlayerViewModel: ObservableObject {
    @Published var isPlaying: Bool = false
    @Published var title: String = "未在播放"
    @Published var subtitle: String = ""
    @Published var artworkURL: URL?
    
    private let player = ApplicationMusicPlayer.shared
    private var timer: Timer?
    
    init() {
        startObserving()
    }
    
    deinit {
        timer?.invalidate()
    }
    
    func startObserving() {
        updateNowPlaying()
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
            self?.updateNowPlaying()
        }
    }
    
    func updateNowPlaying() {
        Task { @MainActor in
            // 播放状态
            switch player.state.playbackStatus {
            case .playing:
                isPlaying = true
            default:
                isPlaying = false
            }
            
            // 当前条目（直接使用 entry 的通用属性）
            if let entry = player.queue.currentEntry {
                title = entry.title
                subtitle = entry.subtitle ?? ""
                artworkURL = entry.artwork?.url(width: 120, height: 120)
            } else {
                title = "未在播放"
                subtitle = ""
                artworkURL = nil
            }
        }
    }
    
    func togglePlayPause() {
        Task {
            switch player.state.playbackStatus {
            case .playing:
                try? await player.pause()
            default:
                try? await player.play()
            }
            await MainActor.run { self.updateNowPlaying() }
        }
    }
    
    func next() {
        Task {
            try? await player.skipToNextEntry()
            await MainActor.run { self.updateNowPlaying() }
        }
    }
    
    func previous() {
        Task {
            try? await player.skipToPreviousEntry()
            await MainActor.run { self.updateNowPlaying() }
        }
    }
}

struct MiniPlayerView: View {
    @StateObject private var viewModel = MiniPlayerViewModel()
    
    var body: some View {
        HStack(spacing: 12) {
            // 封面
            Group {
                if let url = viewModel.artworkURL {
                    AsyncImage(url: url) { image in
                        image
                            .resizable()
                            .scaledToFill()
                    } placeholder: {
                        Color.secondary.opacity(0.15)
                    }
                } else {
                    Color.secondary.opacity(0.15)
                }
            }
            .frame(width: 44, height: 44)
            .clipShape(RoundedRectangle(cornerRadius: 8, style: .continuous))
            
            // 标题与副标题
            VStack(alignment: .leading, spacing: 2) {
                Text(viewModel.title)
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .lineLimit(1)
                if !viewModel.subtitle.isEmpty {
                    Text(viewModel.subtitle)
                        .font(.caption)
                        .foregroundColor(.secondary)
                        .lineLimit(1)
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            
            // 控制按钮
            HStack(spacing: 12) {
                Button(action: { viewModel.previous() }) {
                    Image(systemName: "backward.fill")
                        .font(.system(size: 16, weight: .semibold))
                }
                Button(action: { viewModel.togglePlayPause() }) {
                    Image(systemName: viewModel.isPlaying ? "pause.fill" : "play.fill")
                        .font(.system(size: 18, weight: .bold))
                }
                Button(action: { viewModel.next() }) {
                    Image(systemName: "forward.fill")
                        .font(.system(size: 16, weight: .semibold))
                }
            }
        }
        .padding(12)
        .background(
            RoundedRectangle(cornerRadius: 14, style: .continuous)
                .fill(Color(.secondarySystemBackground))
        )
        .overlay(
            RoundedRectangle(cornerRadius: 14, style: .continuous)
                .stroke(Color.black.opacity(0.06), lineWidth: 0.5)
        )
        .shadow(color: Color.black.opacity(0.06), radius: 8, x: 0, y: 4)
    }
}


