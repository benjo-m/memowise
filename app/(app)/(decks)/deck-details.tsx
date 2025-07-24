import { getDeckById, updateDeck } from "@/api/decks";
import CustomButton from "@/components/custom-button";
import FlashcardCard from "@/components/flashcard-card";
import { useDecks } from "@/contexts/decks-context";
import { Deck } from "@/models/deck";
import { inputStyles } from "@/styles/inputs";
import { useLocalSearchParams } from "expo-router";
import { useEffect, useRef, useState } from "react";
import { Controller, useForm } from "react-hook-form";
import { ActivityIndicator, Text, TextInput, View } from "react-native";

export default function DeckDetailsScreen() {
  const { id } = useLocalSearchParams<{ id: string }>();
  const { decks, setDecks } = useDecks();
  const [deck, setDeck] = useState<Deck | null>(null);
  const [loading, setLoading] = useState(true);
  const [deckError, setDeckError] = useState<string | null>(null);
  const [isEditing, setIsEditing] = useState<boolean>(false);
  const inputRef = useRef<TextInput>(null);

  useEffect(() => {
    const fetchDeck = async () => {
      try {
        const res = await getDeckById(id);
        setDeck(res);
        reset({ name: res.name });
      } catch (e) {
        console.error(e);
        setDeckError("Failed to load deck.");
      } finally {
        setLoading(false);
      }
    };

    fetchDeck();
  }, [id]);

  const {
    control,
    handleSubmit,
    reset,
    setError,
    setFocus,
    formState: { errors },
  } = useForm({
    defaultValues: {
      name: "",
    },
  });

  const onSubmit = async (data) => {
    try {
      const duplicate = decks.some(
        (d) => d.name === data.name && d.id !== deck.id
      );

      if (duplicate) {
        setError("name", {
          type: "manual",
          message: "Deck with that name already exists",
        });

        return;
      }

      await updateDeck(deck.id, data.name);
      const updatedDeck = { ...deck, name: data.name };
      setDecks((prev) => prev.map((d) => (d.id === deck.id ? updatedDeck : d)));
      setDeck(updatedDeck);
      setIsEditing(false);
    } catch (err) {
      console.error("Failed to update deck", err);
    }
  };

  return (
    <View style={{ flex: 1, margin: 30 }}>
      {loading ? (
        <ActivityIndicator />
      ) : deckError ? (
        <Text>{deckError}</Text>
      ) : deck ? (
        <View style={{ flex: 1 }}>
          <Controller
            control={control}
            rules={{ required: true }}
            name="name"
            render={({ field: { onChange, onBlur, value } }) => (
              <TextInput
                ref={inputRef}
                onBlur={onBlur}
                onChangeText={onChange}
                value={value}
                editable={isEditing}
                style={inputStyles.base}
                autoCapitalize="none"
                autoComplete="off"
                autoCorrect={false}
              />
            )}
          />
          {errors.name && (
            <Text style={{ marginTop: 5, color: "red", textAlign: "left" }}>
              {errors.name.message || "Name can't be blank"}
            </Text>
          )}

          {isEditing ? (
            <View
              style={{
                flexDirection: "row",
                marginVertical: 10,
                gap: "2%",
              }}
            >
              <View style={{ flex: 1 }}>
                <CustomButton
                  title="Save"
                  onPress={handleSubmit(onSubmit)}
                  color={""}
                />
              </View>
              <View style={{ flex: 1 }}>
                <CustomButton
                  title="Cancel"
                  onPress={() => {
                    setIsEditing(false);
                    reset({ name: deck.name });
                  }}
                  color={""}
                />
              </View>
            </View>
          ) : (
            <View
              style={{
                marginVertical: 10,
              }}
            >
              <CustomButton
                title="Edit deck"
                onPress={() => {
                  setIsEditing(true);
                  setTimeout(() => {
                    inputRef.current?.focus();
                  }, 100);
                }}
                color={""}
              />
            </View>
          )}

          {deck.flashcards.map((flashcard) => (
            <FlashcardCard key={flashcard.id} flashcard={flashcard} />
          ))}
        </View>
      ) : (
        <Text>Deck not found.</Text>
      )}
    </View>
  );
}
