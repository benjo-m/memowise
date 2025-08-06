import { deleteDeck, updateDeck } from "@/api/decks";
import CustomButton from "@/components/custom-button";
import FallbackMessage from "@/components/fallback-message";
import FlashcardCard from "@/components/flashcard-card";
import { useDecks } from "@/contexts/decks-context";
import { Deck } from "@/models/deck";
import colors from "@/styles/colors";
import { inputStyles } from "@/styles/inputs";
import { router, useLocalSearchParams } from "expo-router";
import { useEffect, useRef, useState } from "react";
import { Controller, useForm } from "react-hook-form";
import { Alert, FlatList, Text, TextInput, View } from "react-native";

export default function DeckDetailsScreen() {
  const { id } = useLocalSearchParams<{ id: string }>();
  const { decks, setDecks, removeDeck } = useDecks();
  const [deck, setDeck] = useState<Deck | null>(null);
  const [isEditing, setIsEditing] = useState<boolean>(false);
  const inputRef = useRef<TextInput>(null);

  useEffect(() => {
    const foundDeck = decks.find((d) => d.id === Number(id)) ?? null;

    if (foundDeck) {
      setDeck(foundDeck);
      reset({ name: foundDeck.name });
    }
  }, [decks, id]);

  const {
    control,
    handleSubmit,
    reset,
    setError,
    formState: { errors },
  } = useForm({
    defaultValues: {
      name: "",
    },
  });

  const onSubmit = async (data: any) => {
    try {
      const duplicate = decks.some((d) => d.name === data.name && d.id !== deck!.id);

      if (duplicate) {
        setError("name", {
          type: "manual",
          message: "Deck with that name already exists",
        });

        return;
      }

      const updatedDeck = await updateDeck(deck!.id, data.name);

      setDecks((prev) => prev.map((d) => (d.id === deck!.id ? updatedDeck : d)));
      setDeck(updatedDeck);
      setIsEditing(false);
    } catch (err) {
      err instanceof Error && Alert.alert("Failed to update deck", err.message);
    }
  };

  return !deck ? (
    FallbackMessage({})
  ) : (
    <View style={{ flex: 1, margin: 30 }}>
      <View style={{ flex: 1, justifyContent: "space-between" }}>
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
                title="Cancel"
                onPress={() => {
                  setIsEditing(false);
                  reset({ name: deck.name });
                }}
                color={colors.blue}
              />
            </View>
            <View style={{ flex: 1 }}>
              <CustomButton title="Save" onPress={handleSubmit(onSubmit)} color={colors.blue} />
            </View>
          </View>
        ) : (
          <View
            style={{
              marginVertical: 10,
            }}
          >
            <CustomButton
              title="Edit name"
              onPress={() => {
                setIsEditing(true);
                setTimeout(() => {
                  inputRef.current?.focus();
                }, 100);
              }}
              color={colors.blue}
            />
          </View>
        )}

        <Text style={{ marginTop: 20 }}>Flashcards</Text>
        <FlatList
          data={deck.flashcards}
          keyExtractor={(item) => item.id.toString()}
          renderItem={({ item }) => <FlashcardCard flashcard={item}></FlashcardCard>}
          style={{ width: "100%" }}
        />

        <View
          style={{
            flexDirection: "row",
            justifyContent: "space-between",
            gap: 16,
            marginTop: 20,
          }}
        >
          <View style={{ flex: 1 }}>
            <CustomButton
              title="Delete deck"
              color={colors.red}
              onPress={() => {
                Alert.alert(
                  "Delete deck",
                  `Are you sure you want to delete "${deck.name}"?`,
                  [
                    { text: "Cancel", style: "cancel" },
                    {
                      text: "Delete",
                      style: "destructive",
                      onPress: async () => {
                        try {
                          await deleteDeck(deck.id);
                          removeDeck(deck.id);
                          router.back();
                        } catch (err) {
                          err instanceof Error && Alert.alert("Failed to delete deck", err.message);
                        }
                      },
                    },
                  ],
                  { cancelable: true }
                );
              }}
            />
          </View>
          <View style={{ flex: 1 }}>
            <CustomButton
              title="Add flashcards"
              color={colors.blue}
              onPress={() =>
                router.navigate({
                  pathname: "/add-flashcards",
                  params: { deckId: deck.id },
                })
              }
            />
          </View>
        </View>
      </View>
    </View>
  );
}
