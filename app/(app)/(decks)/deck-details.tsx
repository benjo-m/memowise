import { deleteDeck, updateDeck } from "@/api/decks";
import CustomButton from "@/components/custom-button";
import FallbackMessage from "@/components/fallback-message";
import FlashcardCard from "@/components/flashcard-card";
import InputWrapper from "@/components/input-wrapper";
import { useDecks } from "@/contexts/decks-context";
import { useTodaysProgress } from "@/contexts/todays-progress-context";
import { Deck } from "@/models/deck";
import colors from "@/styles/colors";
import { inputStyles } from "@/styles/inputs";
import FontAwesome from "@expo/vector-icons/FontAwesome";
import FontAwesome5 from "@expo/vector-icons/FontAwesome5";
import FontAwesome6 from "@expo/vector-icons/FontAwesome6";
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
  const { setFlashcardsDueTodayCount } = useTodaysProgress();

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

  const handleDeleteDeck = async (deckId: number) => {
    try {
      const d = await deleteDeck(deckId);
      const dueTodayCount = d.flashcards.filter((f) => f.due_today).length;
      setFlashcardsDueTodayCount((prev) => prev - dueTodayCount);
      removeDeck(deckId);
      router.back();
    } catch (err) {
      err instanceof Error && Alert.alert("Failed to delete deck", err.message);
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
            <InputWrapper>
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
            </InputWrapper>
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
                color={colors.gray}
                icon={null}
              />
            </View>
            <View style={{ flex: 1 }}>
              <CustomButton
                title="Save"
                onPress={handleSubmit(onSubmit)}
                color={colors.blue}
                icon={null}
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
              title="Edit name"
              onPress={() => {
                setIsEditing(true);
                setTimeout(() => {
                  inputRef.current?.focus();
                }, 100);
              }}
              color={colors.blue}
              icon={<FontAwesome5 name="pen" size={16} color="white" />}
            />
          </View>
        )}

        {deck.flashcards.length > 0 && (
          <Text style={{ marginTop: 20, fontSize: 16, fontWeight: "bold", color: "#313131ff" }}>
            Flashcards ({deck.flashcards.length})
          </Text>
        )}
        {deck.flashcards.length == 0 ? (
          <View style={{ flex: 1, justifyContent: "center", alignItems: "center" }}>
            <Text style={{ marginBottom: 10, fontSize: 16, fontWeight: "bold" }}>Deck empty</Text>
            <Text style={{ textAlign: "center", color: "#585858ff" }}>
              Press the <Text style={{ fontWeight: "bold" }}>Add flashcard</Text> button to start
              adding flashcards to this deck
            </Text>
          </View>
        ) : (
          <FlatList
            data={deck.flashcards}
            keyExtractor={(item) => item.id.toString()}
            renderItem={({ item }) => <FlashcardCard flashcard={item}></FlashcardCard>}
            style={{ marginTop: 16, borderRadius: 10 }}
            showsVerticalScrollIndicator={false}
            contentContainerStyle={{ gap: 16 }}
          />
        )}
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
                      onPress: async () => await handleDeleteDeck(deck.id),
                    },
                  ],
                  { cancelable: true }
                );
              }}
              icon={<FontAwesome6 name="trash" size={18} color="white" />}
            />
          </View>
          <View style={{ flex: 1 }}>
            <CustomButton
              title="Add flashcard"
              color={colors.blue}
              onPress={() =>
                router.navigate({
                  pathname: "/add-flashcards",
                  params: { deckId: deck.id },
                })
              }
              icon={<FontAwesome name="plus" size={18} color="white" />}
            />
          </View>
        </View>
      </View>
    </View>
  );
}
