import { Deck } from "@/models/deck";
import { router } from "expo-router";
import React, { useRef, useState } from "react";
import { Dimensions, Text, View } from "react-native";
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
        <Text onPress={() => ref.current?.prev()}>Prev</Text>
        <Carousel
          ref={ref}
          width={width}
          data={decks}
          defaultIndex={0}
          scrollAnimationDuration={400}
          onSnapToItem={(index) => setCurrentIndex(index)}
          renderItem={({ item }) => (
            <DeckCard
              name={item.name}
              onPress={() =>
                router.navigate({
                  pathname: "/deck-details",
                  params: { id: item.id },
                })
              }
            />
          )}
        />
        <Text onPress={() => ref.current?.next()}>Next</Text>
      </View>

      <Text style={{ marginTop: 10 }}>
        {currentIndex + 1} / {decks.length}
      </Text>
    </View>
  );
}
