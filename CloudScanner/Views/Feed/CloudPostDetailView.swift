import SwiftUI

struct CloudPostDetailView: View {
    let post: CloudPost
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                // Header
                HStack {
                    if let avatarUrl = post.userAvatarUrl {
                        AsyncImage(url: URL(string: avatarUrl)) { image in
                            image
                                .resizable()
                                .scaledToFill()
                                .frame(width: 40, height: 40)
                                .clipShape(Circle())
                        } placeholder: {
                            Image(systemName: "person.circle.fill")
                                .resizable()
                                .frame(width: 40, height: 40)
                                .foregroundColor(.gray)
                                .clipShape(Circle())
                        }
                    } else {
                        Image(systemName: "person.circle.fill")
                            .resizable()
                            .frame(width: 40, height: 40)
                            .foregroundColor(.gray)
                            .clipShape(Circle())
                    }
                    
                    VStack(alignment: .leading) {
                        Text(post.username)
                            .font(CloudFonts.body)
                        if let location = post.location {
                            Text("\(location.latitude), \(location.longitude)")
                                .font(CloudFonts.caption)
                                .foregroundStyle(.secondary)
                        }
                    }
                    
                    Spacer()
                }
                
                // Cloud Image
                Image(post.imageUrl)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .clipShape(RoundedRectangle(cornerRadius: 16))
                
                // Weather Data
                if let weather = post.weather {
                    WeatherDataSection(weatherData: weather)
                }
                
                // Description
                if let description = post.description {
                    Text(description)
                        .font(CloudFonts.body)
                }
                
                // Comments Section
                VStack(alignment: .leading, spacing: 12) {
                    Text("Comments")
                        .font(CloudFonts.headlineMedium)
                    
                    ForEach(post.comments) { comment in
                        CommentView(comment: comment)
                    }
                }
            }
            .padding()
        }
        .navigationTitle("Cloud Details")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct WeatherDataSection: View {
    let weatherData: WeatherData
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Weather Conditions")
                .font(CloudFonts.headlineMedium)
            
            HStack {
                WeatherDataBadge(
                    icon: "thermometer",
                    value: String(format: "%.1f°", weatherData.temperature)
                )
                
                WeatherDataBadge(
                    icon: "humidity",
                    value: "\(Int(weatherData.humidity))%"
                )
                
                WeatherDataBadge(
                    icon: "wind",
                    value: "\(Int(weatherData.windSpeed))m/s"
                )
            }
            
            HStack {
                WeatherDataBadge(
                    icon: "eye",
                    value: "\(Int(weatherData.visibility/1000))km"
                )
            }
        }
    }
}

struct CommentView: View {
    let comment: CloudPost.Comment
    
    var body: some View {
        HStack(alignment: .top, spacing: 8) {
            Text(comment.username)
                .font(CloudFonts.caption)
                .foregroundStyle(.secondary)
            
            Text(comment.text)
                .font(CloudFonts.body)
            
            Spacer()
            
            Text(comment.timestamp.timeAgo())
                .font(CloudFonts.caption)
                .foregroundStyle(.secondary)
        }
    }
} 