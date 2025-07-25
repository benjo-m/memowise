import { Flashcard } from "@/models/flashcard";
import { FlashcardCreateRequest } from "@/models/flashcard-create-request";
import { FlashcardUpdateRequest } from "@/models/flashcard-update-request";
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

export const createFlashcard = async (
  body: FlashcardCreateRequest
): Promise<Flashcard> => {
  const token = await SecureStore.getItemAsync("session");

  const response = await fetch(`${BASE_URL}/flashcards`, {
    method: "POST",
    headers: {
      Accept: "application/json",
      "Content-Type": "application/json",
      Authorization: `Bearer ${token}`,
    },
    body: JSON.stringify(body),
  });

  if (!response.ok) {
    throw new Error("Failed to create flashcard.");
  }

  return await response.json();
};

export const updateFlashcard = async (
  id: string,
  body: FlashcardUpdateRequest
): Promise<Flashcard> => {
  const token = await SecureStore.getItemAsync("session");

  const response = await fetch(`${BASE_URL}/flashcards/${id}`, {
    method: "PUT",
    headers: {
      Accept: "application/json",
      "Content-Type": "application/json",
      Authorization: `Bearer ${token}`,
    },
    body: JSON.stringify(body),
  });

  if (!response.ok) {
    throw new Error("Failed to update flashcard.");
  }

  return await response.json();
};
