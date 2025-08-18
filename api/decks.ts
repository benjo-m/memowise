import { Deck } from "@/models/deck";
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

export const createDeck = async (name: string): Promise<Deck> => {
  const token = await SecureStore.getItemAsync("session");

  const response = await fetch(`${BASE_URL}/decks`, {
    method: "POST",
    headers: {
      Accept: "application/json",
      Authorization: `Bearer ${token}`,
      "Content-Type": "application/json",
    },
    body: JSON.stringify({ name: name }),
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

export const deleteDeck = async (id: number): Promise<Deck> => {
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

  return await response.json();
};
