import { Deck } from "@/models/deck";
import FontAwesome from "@expo/vector-icons/FontAwesome";
import React, { useRef, useState } from "react";
import { Dimensions, Text, TouchableOpacity, View } from "react-native";
import Carousel, { ICarouselInstance } from "react-native-reanimated-carousel";
import DeckCard from "./deck-card";

const width = Dimensions.get("window").width * 0.65;

type Props = {
  decks: Deck[];
};

export default function DecksCarousel({ decks }: Props) {
  const ref = useRef<ICarouselInstance>(null);
  const [currentIndex, setCurrentIndex] = useState(0);

  return (
    <View style={{ flex: 1, alignItems: "center" }}>
      <View style={{ alignItems: "center", flexDirection: "row" }}>
        <TouchableOpacity onPress={() => ref.current?.prev()} style={{ marginRight: 5 }}>
          <FontAwesome name="arrow-left" size={28} color="#2d2d2dff" />
        </TouchableOpacity>
        <Carousel
          ref={ref}
          width={width}
          data={decks}
          defaultIndex={0}
          scrollAnimationDuration={400}
          onSnapToItem={(index) => setCurrentIndex(index)}
          renderItem={({ item }) => <DeckCard deck={item} />}
        />
        <TouchableOpacity onPress={() => ref.current?.next()} style={{ marginLeft: 5 }}>
          <FontAwesome name="arrow-right" size={28} color="#2d2d2dff" />
        </TouchableOpacity>
      </View>

      <Text style={{ marginTop: 8, fontWeight: 500 }}>
        {currentIndex + 1} / {decks.length}
      </Text>
    </View>
  );
}
