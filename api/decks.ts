import { Deck } from "@/models/deck";
import { DeckCreateRequest } from "@/models/deck-create-request";
import * as SecureStore from "expo-secure-store";
import { BASE_URL } from "./constants";

export const getAllDecks = async (): Promise<Deck[]> => {
  const token = await SecureStore.getItemAsync("session");
  const response = await fetch(`${BASE_URL}/decks`, {
    headers: {
      Accept: "application/json",
      "Content-Type": "application/json",
      Authorization: `Bearer ${token}`,
    },
  });

  return await response.json();
};

export const createDeck = async (deckCreateRequest: DeckCreateRequest): Promise<Deck> => {
  const token = await SecureStore.getItemAsync("session");

  const formData = new FormData();
  formData.append("deck[name]", deckCreateRequest.name);

  deckCreateRequest.flashcards_attributes.forEach((card, index) => {
    formData.append(`deck[flashcards_attributes][${index}][front]`, card.front);
    formData.append(`deck[flashcards_attributes][${index}][back]`, card.back);

    if (card.front_image_file) {
      formData.append(
        `deck[flashcards_attributes][${index}][front_image]`,
        card.front_image_file as any
      );
    }

    if (card.back_image_file) {
      formData.append(
        `deck[flashcards_attributes][${index}][back_image]`,
        card.back_image_file as any
      );
    }
  });

  const response = await fetch(`${BASE_URL}/decks`, {
    method: "POST",
    headers: {
      Accept: "application/json",
      Authorization: `Bearer ${token}`,
    },
    body: formData,
  });

  if (!response.ok) {
    throw new Error("Failed to create deck.");
  }

  const responseData = await response.json();

  return responseData;
};

export const getDeckById = async (id: string): Promise<Deck> => {
  const token = await SecureStore.getItemAsync("session");

  const res = await fetch(`${BASE_URL}/decks/${id}`, {
    headers: {
      Accept: "application/json",
      "Content-Type": "application/json",
      Authorization: `Bearer ${token}`,
    },
  });

  if (!res.ok) {
    throw new Error("Failed to fetch deck");
  }

  return res.json();
};

export const updateDeck = async (id: number, newName: string): Promise<Deck> => {
  const token = await SecureStore.getItemAsync("session");

  const res = await fetch(`${BASE_URL}/decks/${id}`, {
    method: "PUT",
    headers: {
      "Content-Type": "application/json",
      Authorization: `Bearer ${token}`,
    },
    body: JSON.stringify({ name: newName }),
  });

  if (!res.ok) throw new Error("Failed to update deck");
  return await res.json();
};

export const deleteDeck = async (id: number): Promise<void> => {
  const token = await SecureStore.getItemAsync("session");

  const response = await fetch(`${BASE_URL}/decks/${id}`, {
    method: "DELETE",
    headers: {
      Accept: "application/json",
      "Content-Type": "application/json",
      Authorization: `Bearer ${token}`,
    },
  });

  if (!response.ok) {
    throw new Error("Failed to delete deck");
  }
};
