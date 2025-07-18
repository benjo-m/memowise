import { getAllDecks } from "@/api/decks";
import { Deck } from "@/models/deck";
import { router } from "expo-router";
import React, { useEffect, useState } from "react";
import { ActivityIndicator, Button, FlatList, Text, View } from "react-native";

export default function DecksScreen() {
  const [decks, setDecks] = useState<Deck[]>([]);
  const [isLoading, setLoading] = useState<boolean>(true);
  const [error, setError] = useState<string | null>(null);

  useEffect(() => {
    const getDecks = async () => {
      try {
        const decks: Deck[] = await getAllDecks();
        setDecks(decks);
      } catch (e) {
        console.log(e);
        setError("Error loading decks...");
      } finally {
        setLoading(false);
      }
    };
    getDecks();
  }, []);

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
