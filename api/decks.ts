import { Deck } from "@/models/deck";
import * as SecureStore from "expo-secure-store";
import { BASE_URL } from "./constants";

const url = `${BASE_URL}/decks`;

export const getAllDecks = async (): Promise<Deck[]> => {
  const token = await SecureStore.getItemAsync("session");
  const response = await fetch(url, {
    headers: {
      Accept: "application/json",
      "Content-Type": "application/json",
      Authorization: `Bearer ${token}`,
    },
  });

  return await response.json();
};

export const createDeck = async (body): Promise<Deck> => {
  const token = await SecureStore.getItemAsync("session");
  const response = await fetch(url, {
    method: "POST",
    headers: {
      Accept: "application/json",
      "Content-Type": "application/json",
      Authorization: `Bearer ${token}`,
    },
    body: JSON.stringify(body),
  });

  return await response.json();
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
