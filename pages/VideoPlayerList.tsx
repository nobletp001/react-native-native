import React, { useState, useRef } from 'react';
import { FlatList, StyleSheet, View, Dimensions, ListRenderItem } from 'react-native';
import VideoPlayer from '../specs/VideoPlayer';

type VideoItem = {
  id: string;
  uri: string;
};

const videoData: VideoItem[] = [
  { id: '1', uri: 'https://demo.unified-streaming.com/k8s/features/stable/video/tears-of-steel/tears-of-steel.ism/.m3u8' },
  { id: '2', uri: 'https://devstreaming-cdn.apple.com/videos/streaming/examples/img_bipbop_adv_example_fmp4/master.m3u8' },
  { id: '3', uri: 'https://devstreaming-cdn.apple.com/videos/streaming/examples/img_bipbop_adv_example_fmp4/master.m3u8' },
  { id: '4', uri: 'https://demo.unified-streaming.com/k8s/features/stable/video/tears-of-steel/tears-of-steel.ism/.m3u8' },
];

const VideoPlayerList: React.FC = () => {
  const [currentPlayingId, setCurrentPlayingId] = useState<string | null>(null);
  const flatListRef = useRef<FlatList<VideoItem>>(null);

  const onViewableItemsChanged = ({
    viewableItems,
  }: {
    viewableItems: { item: VideoItem }[];
  }) => {
    if (viewableItems.length > 0) {
      const visibleItem = viewableItems[0];
      setCurrentPlayingId(visibleItem.item.id); // Set the first visible item's ID as the playing video
    }
  };

  const viewabilityConfig = {
    itemVisiblePercentThreshold: 80, // Item is considered visible if 80% of it is visible
  };

  const renderItem: ListRenderItem<VideoItem> = ({ item }) => (
    <View style={styles.videoContainer}>
      <VideoPlayer
        uri={item?.uri}
        paused={currentPlayingId !== item.id} // Play only if this item is the currentPlayingId
        muted={false}
        volume={1.0}
        resizeMode="contain"
        onError={(error: any) => console.error(`Error with video ${item.id}:`, error)}
        style={styles.videoPlayer}
      />
    </View>
  );

  return (
    <View style={styles.container}>
      <FlatList
        ref={flatListRef}
        data={videoData}
        renderItem={renderItem}
        keyExtractor={(item) => item.id}
        contentContainerStyle={styles.listContainer}
        onViewableItemsChanged={onViewableItemsChanged}
        viewabilityConfig={viewabilityConfig}
        showsVerticalScrollIndicator={false}
        pagingEnabled // Snap to each item
        snapToInterval={height} // Each item occupies the full screen
        snapToAlignment="start" // Align items to the top
        decelerationRate="fast" // Makes the snap smooth
      />
    </View>
  );
};

const { width, height } = Dimensions.get('window');

const styles = StyleSheet.create({
  container: {
    flex: 1,
    backgroundColor: 'black', // Ensures the background is suitable for video playback
  },
  listContainer: {
    paddingBottom: 20,
  },
  videoContainer: {
    width, // Full width of the screen
    height, // Full height of the screen
  },
  videoPlayer: {
    flex: 1,
  },
});

export default VideoPlayerList;
