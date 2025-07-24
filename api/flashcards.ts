import { Flashcard } from "@/models/flashcard";
import * as SecureStore from "expo-secure-store";
import { BASE_URL } from "./constants";

export const getFlashcardById = async (id: string): Promise<Flashcard> => {
  const token = await SecureStore.getItemAsync("session");

  const res = await fetch(`${BASE_URL}/flashcards/${id}`, {
    headers: {
      Accept: "application/json",
      "Content-Type": "application/json",
      Authorization: `Bearer ${token}`,
    },
  });

  if (!res.ok) {
    throw new Error("Failed to fetch flashcard");
  }

  return res.json();
};
