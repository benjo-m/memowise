import { getAllDecks } from "@/api/decks";
import { Deck } from "@/models/deck";
import { useFocusEffect } from "@react-navigation/native";
import { router } from "expo-router";
import React, { useCallback, useState } from "react";
import { ActivityIndicator, Button, FlatList, Text, View } from "react-native";

export default function DecksScreen() {
  const [decks, setDecks] = useState<Deck[]>([]);
  const [isLoading, setLoading] = useState<boolean>(true);
  const [error, setError] = useState<string | null>(null);

  useFocusEffect(
    useCallback(() => {
      let isActive = true;

      const getDecks = async () => {
        try {
          setLoading(true);
          const decks: Deck[] = await getAllDecks();
          if (isActive) {
            setDecks(decks);
            setError(null);
          }
        } catch (e) {
          console.log(e);
          if (isActive) setError("Error loading decks...");
        } finally {
          if (isActive) setLoading(false);
        }
      };

      getDecks();

      return () => {
        isActive = false;
      };
    }, [])
  );

  return (
    <View style={{ flex: 1, justifyContent: "center" }}>
      {isLoading ? (
        <ActivityIndicator />
      ) : error != null ? (
        <Text>{error}</Text>
      ) : (
        <View style={{ alignItems: "center" }}>
          <FlatList
            data={decks}
            keyExtractor={({ id }) => id}
            renderItem={({ item }) => <Text>{item.name}</Text>}
          />
          <Button
            title="Create deck"
            onPress={() => router.push("/create-deck")}
          />
        </View>
      )}
    </View>
  );
}
