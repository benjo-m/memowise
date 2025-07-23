import { getAllDecks } from "@/api/decks";
import CustomButton from "@/components/custom-button";
import DeckCard from "@/components/deck-card";
import { useDecks } from "@/contexts/decks-context";
import { router } from "expo-router";
import { useEffect, useState } from "react";
import { ActivityIndicator, FlatList, View } from "react-native";

export default function DecksScreen() {
  const { decks, setDecks } = useDecks();
  const [isLoading, setLoading] = useState(true);

  useEffect(() => {
    const loadDecks = async () => {
      const data = await getAllDecks();
      setDecks(data);
      setLoading(false);
    };

    if (decks.length === 0) {
      loadDecks();
    } else {
      setLoading(false);
    }
  }, []);

  return (
    <View style={{ flex: 1, margin: 20 }}>
      {isLoading ? (
        <ActivityIndicator style={{ flex: 1 }} />
      ) : (
        <View style={{ flex: 1, justifyContent: "space-between" }}>
          <FlatList
            data={decks}
            keyExtractor={({ id }) => id}
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
          <CustomButton
            title="New deck"
            onPress={() => router.navigate("/create-deck")}
            color={""}
          />
        </View>
      )}
    </View>
  );
}
